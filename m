Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (unknown [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 5D30E7F3F
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 05:38:46 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8D55FAC013
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 03:38:35 -0800 (PST)
Received: from smtp5-g21.free.fr (smtp5-g21.free.fr [212.27.42.5]) by
	cuda.sgi.com with ESMTP id HQriLyDBw4QECfxZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Jan 2015 03:21:07 -0800 (PST)
Received: from harpe.intellique.com (unknown [82.225.196.72])
	by smtp5-g21.free.fr (Postfix) with ESMTP id 245E0D48065
	for <xfs@oss.sgi.com>; Tue, 13 Jan 2015 12:18:10 +0100 (CET)
Date: Tue, 13 Jan 2015 12:21:08 +0100
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: easily reproducible filesystem crash on rebuilding array
Message-ID: <20150113122108.2d3a5ccc@harpe.intellique.com>
In-Reply-To: <20141211123936.1f3d713d@harpe.intellique.com>
References: <20141211123936.1f3d713d@harpe.intellique.com>
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
To: xfs@oss.sgi.com

TGUgVGh1LCAxMSBEZWMgMjAxNCAxMjozOTozNiArMDEwMApFbW1hbnVlbCBGbG9yYWMgPGVmbG9y
YWNAaW50ZWxsaXF1ZS5jb20+IMOpY3JpdmFpdDoKCj4gSGVyZSdzIHRoZSBzZXR1cDogaGFyZHdh
cmUgUkFJRCBjb250cm9sbGVyIChBZGFwdGVjIDd4eDUgc2VyaWVzLAo+IGxhdGVzdCBmaXJtd2Fy
ZSksIFJBSUQtNiBhcnJheSAocHJvYmxlbSBvY2N1cmVkIHdpdGggZGlmZmVyZW50IFJBSUQKPiB3
aWR0aCwgc2l6ZXMsIGFuZCBkaXNrIGNvbmZpZ3VyYXRpb24pLCBhbmQgZGlmZmVyZW50IGtlcm5l
bHMgZnJvbQo+IDMuMi54IHRvIDMuMTYueC4KPiAKPiBXaGF0IGhhcHBlbnM6IHdoaWxlIHRoZSBh
cnJheSBpcyByZWJ1aWxkaW5nLCBzaW11bHRhbmVvdXNseSByZWFkaW5nCj4gYW5kIHdyaXRpbmcg
aXMgYSBzdXJlIHdheSB0byBicmVhayB0aGUgZmlsZXN5c3RlbSBhbmQgYXQgdGltZXMsCj4gY29y
cnVwdCBkYXRhLgo+IAo+IElmIHRoZSBhcnJheSBpcyBOT1QgcmVidWlsZGluZywgbm90aGluZyBl
dmVyIGhhcHBlbnMuIFdoZW4gdXNpbmcgdGhlCj4gYXJyYXkgaW4gcmVhZC1vbmx5IG1vZGUgd2hp
bGUgaXQgcmVidWlsZHMsIG5vdGhpbmcgZXZlciBoYXBwZW5zLgo+IEhvd2V2ZXIsIHdoaWxlIHRo
ZSBhcnJheSBpcyByZWJ1aWxkaW5nLCByZWxhdGl2ZWx5IGhlYXZ5IElPIGFsbW9zdAo+IGNlcnRh
aW5seSBicmluZ3MgdXAgc29tZXRoaW5nIGFzIGZvbGxvd3MgW3NuaXBdCgpTbyBoZXJlJ3Mgd2hl
cmUgSSBhbSBhdCB0aGUgbW9tZW50OgoKKiBYRlMgdjQgb24gcmVidWlsZGluZyBhZGFwdGVjIFJB
SUQgZmFpbHMgdW5kZXIgaGVhdnkgSU8sIHdpdGggb3IKICB3aXRob3V0IExWTSwgd2l0aCBrZXJu
ZWxzIDMuMi54eCB1cCB0byAzLjE3LjcuCgoqIFRvZGF5IEkndmUgcnVuIHRoZSBzYW1lIHRlc3Qg
d2l0aCBleHQ0IDogbm8gcHJvYmxlbSB3aGF0c29ldmVyLiBJJ20KICByZWNoZWNraW5nIG1kNSBv
ZiBhbGwgZmlsZXMgdG8gZ2V0IHN1cmUsIGJ1dCBpdCBsb29rcyBPSyBzbyBmYXIgYWZ0ZXIKICB0
ZXN0aW5nIHNldmVyYWwgdGVyYWJ5dGVzLiAKCkkgZG9uJ3QgdW5kZXJzdGFuZCBob3cgdGhlIFJB
SUQgZmlybXdhcmUgY291bGQgc2VuZCBiYWNrIGJhZCBkYXRhCihjb3JydXB0ZWQgbWV0YWRhdGEg
QU5EIGRhdGEpIHRvIFhGUyBidXQgbm90IHRvIGV4dDQuLi4KCi0tIAotLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0K
RW1tYW51ZWwgRmxvcmFjICAgICB8ICAgRGlyZWN0aW9uIHRlY2huaXF1ZQogICAgICAgICAgICAg
ICAgICAgIHwgICBJbnRlbGxpcXVlCiAgICAgICAgICAgICAgICAgICAgfAk8ZWZsb3JhY0BpbnRl
bGxpcXVlLmNvbT4KICAgICAgICAgICAgICAgICAgICB8ICAgKzMzIDEgNzggOTQgODQgMDIKLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20v
bWFpbG1hbi9saXN0aW5mby94ZnMK
