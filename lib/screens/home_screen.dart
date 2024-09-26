import 'package:flutter/material.dart';
import 'package:tutorial/loaders/screen_loader.dart';
import 'package:tutorial/themes/colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

const _URL = 'https://pub.dev/packages/webview_flutter';

class HomeScreen extends StatefulWidget {
  final String title;
  final String url;

  const HomeScreen({this.title = 'Tutorial-Webview', this.url = _URL});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _loader = true;
  late WebViewController _controller;

  @override
  void initState() {
    _initializeWebview();
    super.initState();
  }

  void _initializeWebview() {
    late final PlatformWebViewControllerCreationParams params;
    params = const PlatformWebViewControllerCreationParams();
    final controller = WebViewController.fromPlatformCreationParams(params);
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: (url) => setState(() => _loader = false)))
      ..addJavaScriptChannel('Toaster', onMessageReceived: (message) {})
      ..loadRequest(Uri.parse(widget.url));
    setState(() => _controller = controller);
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: white,
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        color: white,
        width: size.width,
        height: size.height,
        child: Stack(children: [WebViewWidget(controller: _controller), if (_loader) ScreenLoader(background: white)]),
      ),
    );
  }
}
