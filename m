Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 74FFE7F54
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2014 15:40:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 56B8C304039
	for <xfs@oss.sgi.com>; Sun,  1 Jun 2014 13:40:32 -0700 (PDT)
Received: from smtp1-g21.free.fr (smtp1-g21.free.fr [212.27.42.1]) by
	cuda.sgi.com with ESMTP id mqGvRuXcKnpbPHVL for
	<xfs@oss.sgi.com>; Sun, 01 Jun 2014 13:40:28 -0700 (PDT)
Date: Sun, 1 Jun 2014 22:40:24 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: What to do when... xfs_repair hangs?
Message-ID: <20140601224024.628372c5@galadriel.home>
In-Reply-To: <CAA43vkUBF3q-F6XYTPTVx43KXg_3_COgaK8wtHxRynshOT9smg@mail.gmail.com>
References: <CAA43vkVzWRTqNQh2VSi5yvFLtstmVOKRJUnYw_ZSkYJGsex8Uw@mail.gmail.com>
	<20140531000117.GM6677@dastard>
	<CAA43vkUBF3q-F6XYTPTVx43KXg_3_COgaK8wtHxRynshOT9smg@mail.gmail.com>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Sean Caron <scaron@umich.edu>
Cc: xfs@oss.sgi.com

TGUgU3VuLCAxIEp1biAyMDE0IDEyOjIxOjU1IC0wNDAwIHZvdXMgw6ljcml2aWV6OgoKPiBTaW5j
ZSBEYXZlIGlzIHNheWluZyBpdCdzIE9LIHRvIHRyeSByZS1ydW5uaW5nIHhmc19yZXBhaXI7IGl0
J2xsIGp1c3QKPiBwaWNrIHVwIHdoZXJlIGl0IGxlZnQgb2ZmOyBsZXQgbWUgZ2l2ZSBpdCBhbm90
aGVyIHBhc3MgYW5kIHNlZSBpZiBpdAo+IG1hbmFnZXMgdG8gY29tcGxldGUsIG9yIGlmIGl0IHNl
Z2ZhdWx0cyBvdXQgYWdhaW4uIEkgZ3Vlc3MgaXQgaXQKPiBwb29wcyBvdXQgYSBzZWNvbmQgdGlt
ZSwgbWF5YmUgd2UnbGwganVzdCB3YW50IHRvIGNvbnNpZGVyIHJlYnVpbGRpbmcKPiB0aGUgZmls
ZXN5c3RlbSBhbmQgcmVzdG9yaW5nIGZyb20gb3VyIGNvcGllcz8KCllvdSBzaG91bGQgZGVmaW5p
dGVseSB0cnkgYSBtb3JlIHVwLXRvLWRhdGUgdmVyc2lvbiBvZiB4ZnNfcmVwYWlyCmZpcnN0LiBJ
biBjYXNlIHlvdSdyZSBub3QgYWZyYWlkIG9mIHJ1bm5pbmcgYSBiaW5hcnkgZnJvbSBhbiB1bmtv
d24Kc291cmNlLCBwbGVhc2UgZmluZCBhIDMuMS4xMSBiaW5hcnkgaGVyZToKCmh0dHA6Ly91cGRh
dGUuaW50ZWxsaXF1ZS5jb20vcHViL3hmc3JlcGFpci50YXIuZ3oKCi0tIAotLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0KRW1tYW51ZWwgRmxvcmFjICAgICB8ICAgRGlyZWN0aW9uIHRlY2huaXF1ZQogICAgICAgICAg
ICAgICAgICAgIHwgICBJbnRlbGxpcXVlCiAgICAgICAgICAgICAgICAgICAgfAk8ZWZsb3JhY0Bp
bnRlbGxpcXVlLmNvbT4KICAgICAgICAgICAgICAgICAgICB8ICAgKzMzIDEgNzggOTQgODQgMDIK
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5j
b20vbWFpbG1hbi9saXN0aW5mby94ZnMK
