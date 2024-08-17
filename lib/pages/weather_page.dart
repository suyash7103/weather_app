import 'package:flutter/material.dart';
import 'package:weather_4/models/weather_model.dart';
import 'package:weather_4/services/weather_service.dart';
import 'package:lottie/lottie.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  // api_key
  final _weatherService = WeatherService('48bf03076b6255b6f9ee5fa25a48458f');
  Weather? _weather;

  // fetch weather
  Future<void> _fetchWeather() async {
    try {
      // Get current city
      String cityname = await _weatherService.getCurrentCity();

      // Get weather for city
      final weather = await _weatherService.getWeather(cityname);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      print(e);
      // Optionally, set an error state to display to the user
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) return 'assets/sunny.json';
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return 'assets/cloudy.json';
      case 'rain':
        return 'assets/rain.json';
      case 'thunderstorm':
        return 'assets/thunder.json';
      case 'mist':
      case 'fog':
      case 'haze':
      case 'smoke':
      case 'dust':
      case 'clear':
        return 'assets/sunny.json';
      default:
        return 'assets/sunny.json'; // Default animation if none of the cases match
    }
  }

  @override
  void initState() {
    super.initState();
    // Fetch weather on startup
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // City name
                Text(
                  _weather?.cityname ?? "Loading city...",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                  textAlign: TextAlign.center, // Center-align the text
                ),

                SizedBox(height: 20), // Add some spacing

                Lottie.asset(
                  getWeatherAnimation(_weather?.maincondition),
                  width: 200, // Adjust width as needed
                  height: 200, // Adjust height as needed
                  fit: BoxFit.contain, // Adjust fit as needed
                ),

                SizedBox(height: 20), // Add some spacing

                // Temperature
                Text(
                  _weather != null
                      ? '${_weather!.temperature.round()}°C'
                      : 'Loading temperature...',
                  style: TextStyle(fontSize: 32, color: Colors.white),
                ),

                SizedBox(height: 10), // Add some spacing

                Text(
                  _weather?.maincondition ?? "",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
