Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5B9VKca053291 for <xfs@oss.sgi.com>; Sat, 11 Jun 2011 04:31:21 -0500
Received: from smtp3-g21.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A5DB4B7061
	for <xfs@oss.sgi.com>; Sat, 11 Jun 2011 02:31:18 -0700 (PDT)
Received: from smtp3-g21.free.fr (smtp3-g21.free.fr [212.27.42.3]) by
	cuda.sgi.com with ESMTP id cO35EaKwBBe6a1ld for
	<xfs@oss.sgi.com>; Sat, 11 Jun 2011 02:31:18 -0700 (PDT)
Date: Sat, 11 Jun 2011 11:30:49 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: FYI: LSI rebuilding;  and XFS speed V. raw - hints on maxing
	out 'dd'....(if not already obvious)...
Message-ID: <20110611113049.2868f9c7@galadriel2.home>
In-Reply-To: <4DF2C5D4.6030507@tlinx.org>
References: <BANLkTik4YjSr7-VA+f9Sh+UxvKfFKMy=+w@mail.gmail.com>
	<20110502191323.417ef644@harpe.intellique.com>
	<4DF2C5D4.6030507@tlinx.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linda Walsh <xfs@tlinx.org>
Cc: Paul Anderson <pha@umich.edu>, xfs@oss.sgi.com

TGUgRnJpLCAxMCBKdW4gMjAxMSAxODozMzowOCAtMDcwMCB2b3VzIMOpY3JpdmllejoKCj4gSSBo
YXZlIGEgOTI4NS04RSBhbmQgaGF2ZSBiZWVuIHByZXR0eSBoYXBweSB3aXRoIGl0J3MgcGVyZm9y
bWFuY2UsCj4gYnV0IEkgb25seSBoYXZlIDEwIGRhdGEgZGlza3MgKDJ4Ni1kaXNrIFJBSUQ1ID0+
UkFJRDUwKSB3aXRoIDJUQgo+IFNBVEEncyBhbmQgZ2V0IDFHQiBwZXJmLi4uIGFib3V0IHdoYXQg
SSdkIGV4cGVjdCBmcm9tIGRpc2tzIHRoYXQgZ2V0Cj4gYXJvdW5kIDEyME1CIGVhY2ggYW5kIGRv
aW5nIDIgUkFJRDUgY2FsY3MuLi4pLi4uCgpJJ3ZlIG1hZGUgc29tZSBtb3JlIHRlc3RzIHNpbmNl
IHRoZW4sIGFuZCBJIHdhcyB1c2luZyBjaGVhcG8gZHJpdmVzIGZvcgp0ZXN0aW5nIHRoYXQgZm9y
IHNvbWUgcmVhc29uLCBiZWhhdmUgZXh0cmFvcmRpbmFyaWx5IHBvb3JseSBpbgpjb21iaW5hdGlv
biB3aXRoIHRoZSBMU0kgY2FyZC4gSSd2ZSByZXRlc3RlZCB0aGUgY2FyZCB3aXRoIGhpdGFjaGkK
VWx0cmFzdGFycyBhbmQgaXQgd29ya2VkIGp1c3QgZmluZSAodGhvdWdoIGEgYml0IHNsb3dlciB0
aGFuIEFkYXB0ZWMKNnh4NSkuIE9UT0gsIHRoZSBBZGFwdGVjIHdvcmtzIGZpbmUgd2l0aCB0aGUg
ImJhZCIgZHJpdmVzIHRvbywgZ28KZmlndXJlLiAKCkkgZGlkbid0IHlldCBleHBsb3JlZCB0aGUg
YWR2YW5jZWQgY2FwYWJpbGl0aWVzIG9mIHRoZSBjYXJkIChhcHBhcmVudGx5Cml0IG1heSBoYXZl
IHNvbWUgc25hcHNob3QgbWVjaGFuaXNtKSBiZWNhdXNlIE1lZ2FDbGkgaXMgc3VjaCBhIFBJVEEg
OikKCnJlZ2FyZHMsCi0tIAotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KRW1tYW51ZWwgRmxvcmFjICAgICB8ICAg
RGlyZWN0aW9uIHRlY2huaXF1ZQogICAgICAgICAgICAgICAgICAgIHwgICBJbnRlbGxpcXVlCiAg
ICAgICAgICAgICAgICAgICAgfAk8ZWZsb3JhY0BpbnRlbGxpcXVlLmNvbT4KICAgICAgICAgICAg
ICAgICAgICB8ICAgKzMzIDEgNzggOTQgODQgMDIKLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCgpfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhm
c0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
