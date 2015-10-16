Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BF40D7F5F
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 08:26:21 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 9D8BE8F8052
	for <xfs@oss.sgi.com>; Fri, 16 Oct 2015 06:26:18 -0700 (PDT)
Received: from mail1.g1.pair.com (mail1.g1.pair.com [66.39.3.162]) by
	cuda.sgi.com with ESMTP id QRlpJ89d7y8qr3Td (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 16 Oct 2015 06:26:16 -0700 (PDT)
Date: Fri, 16 Oct 2015 15:26:18 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Error in `xfs_repair': double free or corruption
Message-ID: <20151016152618.32621033@harpe.intellique.com>
In-Reply-To: <trinity-7e00f108-b6b9-4750-82b6-fb7533517200-1445001537779@3capp-gmx-bs54>
References: <trinity-16122364-b1e6-4dc9-9057-f2df3aa193bb-1445001446455@3capp-gmx-bs54>
	<trinity-7e00f108-b6b9-4750-82b6-fb7533517200-1445001537779@3capp-gmx-bs54>
MIME-Version: 1.0
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
To: Dragon <Sunghost@gmx.de>
Cc: xfs@oss.sgi.com

TGUgRnJpLCAxNiBPY3QgMjAxNSAxNToxODo1NyArMDIwMApEcmFnb24gPFN1bmdob3N0QGdteC5k
ZT4gw6ljcml2YWl0OgoKPiBIZWxsbywKPiBpIGhhdmUgYSBwcm9ibGVtIGFmdGVyIHJlcGFpcmVk
IGEgZGVncmFkZWQgU29mdGFyZSBSYWlkNi4gU3lzdGVtIGlzCj4gRGViaWFuIEplc3NpIGFuZCBS
b290IGFuZCBCb290IGFyZSBvbiBSYWlkMSwgYW5kIERhdGEgb24gUmFpZDYgb24gbWQyCj4gd2hp
Y2ggbWlzcyBvbmUgRGlzay4gVGhlIG1haW5wcm9ibGVtIHdhcyBhIG1pc3NpbmcgRGlzayBiZWNh
dXNlIG9mCj4gYmFkYmxvY2tzIHdoaWNoIGkgY2xvbmVkIGFuZCBleGNoYW5nZWQgYWdhaW5zIGEg
bmV3IG9uZS4gQWZ0ZXIgdGhhdCBpCj4gY291bGQgc3VjY2Vzc2Z1bGx5IHJlYnVpbGQgdGhlIHJh
aWQgKG1kMiksIHdoaWxlIG5vdyBvbmx5IG9uZSBkaXNrIGlzCj4gbWlkZGluZy4gQnV0IGkgcmVj
b2duaXNlZCB0aGF0IHhmcyByZXBvcnRzIGlub2RlIHByb2JsZW1zLiBUaGVyZWZvciBpCj4gcnVu
IHhmc19yZXBhaXIgb24gdGhlIHJhaWQgZGV2aWNlIG1kMiwgYnV0IGdldCBtZXNzYWdlICJFcnJv
ciBpbgo+ICYjOTY7eGZzX3JlcGFpcic6IGRvdWJsZSBmcmVlIG9yIGNvcnJ1cHRpb24iIFdoYXQg
Y2FuIGkgZG8gdGhlIGZpeAo+IHRoaXM/IHRoeCAKCllvdSBkaWRuJ3QgcHJvdmlkZSBlbm91Z2gg
aW5mb3JtYXRpb24gKGtlcm5lbCBhbmQgeGZzLXByb2dzIHZlcnNpb24gYXQKdGhlIHZlcnkgbGVh
c3QpIGJ1dCB5b3Ugc2hvdWxkIHVzZSB0aGUgbGF0ZXN0IHZlcnNpb24gb2YgeGZzX3JlcGFpciwg
dGhlCm9uZSBpbmNsdWRlZCBpbiBEZWJpYW4gaXMgcHJvYmFibHkgcXVpdGUgb2xkLiBIZXJlJ3Mg
b25lIG5ldzoKCmh0dHA6Ly91cGRhdGUuaW50ZWxsaXF1ZS5jb20vcHViL3hmc19yZXBhaXItNC4y
LjAuZ3oKCk9yIGlmIHlvdSBsaWtlIGl0IGJldHRlciBpbiBkZWJpYW4gZm9ybToKaHR0cDovL3Vw
ZGF0ZS5pbnRlbGxpcXVlLmNvbS9yZXBvc2l0b3J5L3Bvb2wvc3RvcmlxMy91bnN0YWJsZS9hbWQ2
NC94ZnNwcm9nc180LjIuMCsxX2FtZDY0LmRlYgoKCi0tIAotLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KRW1tYW51
ZWwgRmxvcmFjICAgICB8ICAgRGlyZWN0aW9uIHRlY2huaXF1ZQogICAgICAgICAgICAgICAgICAg
IHwgICBJbnRlbGxpcXVlCiAgICAgICAgICAgICAgICAgICAgfAk8ZWZsb3JhY0BpbnRlbGxpcXVl
LmNvbT4KICAgICAgICAgICAgICAgICAgICB8ICAgKzMzIDEgNzggOTQgODQgMDIKLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4
ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1h
bi9saXN0aW5mby94ZnMK
