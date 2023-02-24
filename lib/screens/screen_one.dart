import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

import '../data/data.dart';

class ScreenOne extends StatefulWidget {
  const ScreenOne({super.key});

  @override
  State<ScreenOne> createState() => _ScreenOneState();
}

class _ScreenOneState extends State<ScreenOne> {
  bool _isLoading = true;
  File? _image;
  List? _output;
  final imagePicker = ImagePicker();

  @override
  @override
  void initState() {
    super.initState();
    modelLoader().then((value) {
      setState(() {});
    });
  }

  _detectImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.6,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _output = output;
      _isLoading = false;
    });
  }

  modelLoader() async {
    await Tflite.loadModel(
        model: "/assets/tflite_data/model_unquant.tflite",
        labels: "/assets/tflite_data/labels.txt");
  }

  @override
  void dispose() {
    super.dispose();
  }

  captureImage() async {
    var image = await imagePicker.getImage(source: ImageSource.camera);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    _detectImage(_image!);
  }

  chooseImage() async {
    var image = await imagePicker.getImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _image = File(image.path);
    });

    _detectImage(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("is Cat? is Dog?"),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                clipBehavior: Clip.none,
                padding: EdgeInsets.all(15),
                height: 400,
                child: Image.network(
                    "https://cdn.pixabay.com/photo/2018/10/01/09/21/pets-3715734__340.jpg")),
            Column(children: [
              Center(
                child: Text(
                  aboutApp,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.pink, width: 5)),
                  child: Row(
                    children: [
                      const Icon(Icons.photo_album, size: 40),
                      InkWell(
                          child: const Text("Choose Image",
                              style: TextStyle(fontSize: 20)),
                          onTap: chooseImage),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.green, width: 5.0)),
                  child: Row(
                    children: [
                      const Icon(Icons.camera, size: 38),
                      InkWell(
                          child: const Text("Capture Image",
                              style: const TextStyle(fontSize: 20)),
                          onTap: captureImage),
                    ],
                  ),
                ),
              ]),
            ])
          ],
        ),
      ),
    );
  }
}
