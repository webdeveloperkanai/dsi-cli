@echo off
setlocal enabledelayedexpansion
title DEV SEC IT - Project CLI

REM Set the path for the temporary configuration file
set "TEMP_CONFIG_FILE=%TEMP%\dsi_config.dsi"

REM Check for command line arguments
set "COMMAND=%~1"

REM Check if the configuration is already set
if /i "%COMMAND%" neq "config" (
    if exist "%TEMP_CONFIG_FILE%" (
        for /f "usebackq delims=" %%A in ("%TEMP_CONFIG_FILE%") do (
            set "CONFIG=%%A"
        ) 
        goto :process_command
    )
)

REM Ask the user to enter email and password if config is not set
if /i "%COMMAND%"=="config" (
    call :configure
    exit /b 0
)

:process_command
REM Process the input command
if /i "%COMMAND%"=="init" (
    call :init
) else if /i "%COMMAND%"=="create" (
    if "%~2"=="" (
        echo Usage: dsi create PROJECT_NAME
        exit /b 1
    )
    call :create_project "%~2"
) else if /i "%COMMAND%"=="verify" (
    call :verify
) else if /i "%COMMAND%"=="get" (
    if "%~2"=="" (
        echo Usage: dsi get PROJECT_URL
        exit /b 1
    )
    call :get_project "%~2"
) else if /i "%COMMAND%"=="push" (
    if "%~2"=="" (
        echo Usage: dsi push BRANCH_NAME
        exit /b 1
    )
    call :push_branch "%~2"
) else if /i "%COMMAND%"=="serve" (
    call :serve
) else if /i "%COMMAND%"=="stop" (
    call :stop
) else if /i "%COMMAND%"=="deploy" (
    call :deploy
) else if /i "%COMMAND%"=="api" (
    if "%~2"=="" (
        echo Usage: dsi push BRANCH_NAME
        exit /b 1
    )
    call :dsi_api "%~2"
) else (
    echo Invalid command: %COMMAND%
    exit /b 1
)

exit /b 0


:dsi_api
REM downloading and creating api folder
set "PROJECT_NAME=%~1"
set "PROJECT_FOLDER=%cd%\%PROJECT_NAME%"

REM Check if the project folder already exists
if exist "%PROJECT_FOLDER%" (
    echo The project folder "%PROJECT_NAME%" already exists in the current directory.
    exit /b 1
)

REM Create the project folder
mkdir "%PROJECT_FOLDER%"
echo.
echo Generating project files...
REM Set the URLs for the zip file and the progress bar characters
set "ZIP_URL=https://devsecit.com/sdk-api.zip"
set "PROGRESS_BAR_CHAR=|"

REM Download the zip file
@REM echo Downloading %ZIP_URL% ...
curl --progress-bar -o "%PROJECT_FOLDER%\downloaded_file.zip" %ZIP_URL%

REM Extract the zip file and calculate the total number of files to extract
set "TOTAL_FILES=0"
for /f %%F in ('7z l "%PROJECT_FOLDER%\downloaded_file.zip" ^| find /c /v ""') do set "TOTAL_FILES=%%F"

REM Extract the zip file with progress
echo Extracting...
7z x "%PROJECT_FOLDER%\downloaded_file.zip" -o"%PROJECT_FOLDER%" -y | find /v /c ""
set "EXTRACTED_FILES=0"

REM Show downloading and extracting percentages
echo.
for /L %%P in (1,1,%TOTAL_FILES%) do (
    set /a "EXTRACTED_FILES=%%P * 100 / %TOTAL_FILES%"
    set "PROGRESS="
    for /L %%C in (1,1,50) do if %%C LEQ !EXTRACTED_FILES! (set "PROGRESS=!PROGRESS!%PROGRESS_BAR_CHAR%") else (set "PROGRESS=!PROGRESS! ")
    echo Downloading: !EXTRACTED_FILES!%% [!PROGRESS!]
    @REM timeout 1 >nul
)

REM Delete the downloaded zip file
del "%PROJECT_FOLDER%\downloaded_file.zip"

echo.
echo Project "%PROJECT_NAME%" has been created successfully! 
echo cd "%PROJECT_NAME%" 
echo dsi serve 
echo Happy Coding! 
exit /b 0


:configure

REM Save the email and password to the temporary configuration file
set /p "EMAIL=Enter your email: "
set /p "PASSWORD=Enter your password: "

REM Check if the "C:\dsi" directory exists, create it if it doesn't
if not exist "C:\dsi" (
    mkdir "C:\dsi"
)

REM Save the email and password to the configuration file
echo EMAIL=%EMAIL%> "C:\dsi\config.dat"
echo PASSWORD=%PASSWORD%>> "C:\dsi\config.dat"
exit /b 0

:init
echo This is the dsi init command.
REM Add your code for dsi init here.
echo PROJECT Configuration - Don't Edit > .ignore
echo PROJECT_URI: >> .ignore
echo PROJECT_VER: 1.0.0>> .ignore
echo AUTHOR: %USERNAME%>> .ignore

exit /b 0

:create_project
REM Set the project name and create the project folder in the current directory
set "PROJECT_NAME=%~1"
set "PROJECT_FOLDER=%cd%\%PROJECT_NAME%"

REM Check if the project folder already exists
if exist "%PROJECT_FOLDER%" (
    echo The project folder "%PROJECT_NAME%" already exists in the current directory.
    exit /b 1
)

REM Create the project folder
mkdir "%PROJECT_FOLDER%"
echo.
echo Generating project files...
REM Set the URLs for the zip file and the progress bar characters
set "ZIP_URL=https://devsecit.com/sdk.zip"
set "PROGRESS_BAR_CHAR=|"

REM Download the zip file
@REM echo Downloading %ZIP_URL% ...
curl --progress-bar -o "%PROJECT_FOLDER%\downloaded_file.zip" %ZIP_URL%

REM Extract the zip file and calculate the total number of files to extract
set "TOTAL_FILES=0"
for /f %%F in ('7z l "%PROJECT_FOLDER%\downloaded_file.zip" ^| find /c /v ""') do set "TOTAL_FILES=%%F"

REM Extract the zip file with progress
echo Extracting...
7z x "%PROJECT_FOLDER%\downloaded_file.zip" -o"%PROJECT_FOLDER%" -y | find /v /c ""
set "EXTRACTED_FILES=0"

REM Show downloading and extracting percentages
echo.
for /L %%P in (1,1,%TOTAL_FILES%) do (
    set /a "EXTRACTED_FILES=%%P * 100 / %TOTAL_FILES%"
    set "PROGRESS="
    for /L %%C in (1,1,50) do if %%C LEQ !EXTRACTED_FILES! (set "PROGRESS=!PROGRESS!%PROGRESS_BAR_CHAR%") else (set "PROGRESS=!PROGRESS! ")
    echo Downloading: !EXTRACTED_FILES!%% [!PROGRESS!]
    @REM timeout 1 >nul
)

REM Delete the downloaded zip file
del "%PROJECT_FOLDER%\downloaded_file.zip"

echo.
echo Project "%PROJECT_NAME%" has been created successfully! 
echo cd "%PROJECT_NAME%" 
echo dsi serve 
echo Happy Coding! 
exit /b 0


:verify
echo Verifying...
REM Add your code for verification here.
exit /b 0

:get_project
echo Getting project from URL: "%~1"...
REM Add your code for getting the project here.
exit /b 0

:push_branch
echo Pushing branch "%~1"...
REM Add your code for pushing the branch here.
exit /b 0

:serve
echo Starting the server...
echo Starting the PHP server on port 8081...
REM Add your code for starting the PHP server here.
start http://127.0.0.1:8081 
REM Check if PHP is installed on the system
where php >nul 2>&1
if not errorlevel 1 (
    REM PHP is installed, start the server
    php -S 127.0.0.1:8081 -t ./
    exit /b 0
) else (
    REM PHP is not installed or not found, show an error message
    echo PHP is not installed or not found on your system. Please install PHP and try again.
    exit /b 1
)
exit /b 0


:deploy
echo Deploying...
REM Add your code for deployment here.
start https://devsecit.com/dsi/dashboard/?%USERNAME%
exit /b 0
