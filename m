Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C69307F50
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2015 06:09:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A78228F80BA
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2015 04:09:10 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Fd0gHlWYxBhrn78Q (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 28 Apr 2015 04:09:06 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (Postfix) with ESMTPS id 5648A8E778
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2015 11:09:06 +0000 (UTC)
Received: from jtulak.brq.redhat.com ([10.34.27.15])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t3SB95KV018403
	for <xfs@oss.sgi.com>; Tue, 28 Apr 2015 07:09:05 -0400
From: =?UTF-8?q?Jan=20=C5=A4ul=C3=A1k?= <jtulak@redhat.com>
Subject: xfsprogs compile warnings: _BSD_SOURCE is deprecated in glibc 2.20.
Date: Tue, 28 Apr 2015 13:09:04 +0200
Message-Id: <1430219344-11662-1-git-send-email-jtulak@redhat.com>
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

SW4gZ2xpYmMgMi4yMCwgX0JTRF9TT1VSQ0UgYW5kIF9TVklEX1NPVVJDRSB3ZXJlIGRlcHJlY2F0
ZWQgYW5kIHNob3VsZCBiZQpyZXBsYWNlZCB3aXRoIF9ERUZBVUxUX1NPVVJDRS4gQ3VycmVudGx5
LCBjb21waWxpbmcgeGZzcHJvZ3Mgb24gYSBzeXN0ZW0gd2l0aApnbGliYyBpbiBzYWlkIG9yIG5l
d2VyIHZlcnNpb24gKGxpa2UgY3VycmVudCBGZWRvcmEpIHByb2R1Y2VzIHRvbnMgb2Ygd2Fybmlu
Z3MKbGlrZSB0aGlzIG9uZToKCkluIGZpbGUgaW5jbHVkZWQgZnJvbSAvdXNyL2luY2x1ZGUvc3Rk
aW8uaDoyNzowLAogICAgICAgICAgICAgICAgICBmcm9tIC4uL2luY2x1ZGUveGZzL3BsYXRmb3Jt
X2RlZnMuaDoyNCwKICAgICAgICAgICAgICAgICBmcm9tIC4uL2luY2x1ZGUveGZzL2xpYnhmcy5o
OjI1LAogICAgICAgICAgICAgICAgIGZyb20geGZzX21rZnMuYzoxOToKL3Vzci9pbmNsdWRlL2Zl
YXR1cmVzLmg6MTQ4OjM6IHdhcm5pbmc6ICN3YXJuaW5nICJfQlNEX1NPVVJDRSBhbmQgX1NWSURf
U09VUkNFIGFyZSBkZXByZWNhdGVkLCB1c2UgX0RFRkFVTFRfU09VUkNFIiBbLVdjcHBdCiAjIHdh
cm5pbmcgIl9CU0RfU09VUkNFIGFuZCBfU1ZJRF9TT1VSQ0UgYXJlIGRlcHJlY2F0ZWQsIHVzZSBf
REVGQVVMVF9TT1VSQ0UiCgpJdCBjYW4gYmUgZml4ZWQgd2l0aCB0aGUgc2luZ2xlIGxpbmUgcGF0
Y2ggYmVsbG93LCBidXQgSSdtIG5vdCBzdXJlIGlmIHdlIGNhbgpyZW1vdmUgdGhlIGRlcHJlY2F0
ZWQgdmVyc2lvbiBiZWNhdXNlIG9mIGNvbXBhdGlibGl0eS4gR2xpYmMgMi4xOSwgd2hpY2ggYWRk
ZWQKX0RFRkFVTFRfU09VUkNFLCB3YXMgcmVsZWFzZWQgaW4gMjAxNCwgYW5kIEknbSBub3Qgc3Vy
ZSBob3cgbXVjaCBpdCBpcwpiYWNrcG9ydGVkIGFuZCBob3cgbXVjaCB4ZnNwcm9ncyBhcmUgYmFj
a3BvcnRlZCB0b28uIFNvLCBkbyB3ZSBuZWVkIGEgYmV0dGVyCnBhdGNoIHRvIHRha2UgY2FyZSBv
ZiB0aGlzIGFuZCBwcm92aWRlIGRpZmZlcmVuZCBfU09VUkNFIGJhc2VkIG9uIGdsaWJjCnZlcnNp
b24sIG9yIHRoaXMgcGF0Y2ggaXMgZW5vdWdoPwoKU291cmNlOiBtYW4gNyBmZWF0dXJlX3Rlc3Rf
bWFjcm9zCkhlcmUgaXMgYSBsaW5rIGluIGNhc2UgeW91IG9sZGVyIHZlcnNpb246Cmh0dHA6Ly9t
YW43Lm9yZy9saW51eC9tYW4tcGFnZXMvbWFuNy9mZWF0dXJlX3Rlc3RfbWFjcm9zLjcuaHRtbAoK
ClNpZ25lZC1vZmYtYnk6IEphbiDFpHVsw6FrIDxqdHVsYWtAcmVkaGF0LmNvbT4KLS0tCiBpbmNs
dWRlL2J1aWxkZGVmcy5pbiB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwg
MSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2luY2x1ZGUvYnVpbGRkZWZzLmluIGIvaW5jbHVk
ZS9idWlsZGRlZnMuaW4KaW5kZXggOTQ0YmNmNi4uNmU2MDk3YSAxMDA2NDQKLS0tIGEvaW5jbHVk
ZS9idWlsZGRlZnMuaW4KKysrIGIvaW5jbHVkZS9idWlsZGRlZnMuaW4KQEAgLTEwOSw3ICsxMDks
NyBAQCBHQ0NGTEFHUyA9IC1mdW5zaWduZWQtY2hhciAtZm5vLXN0cmljdC1hbGlhc2luZyAtV2Fs
bAogIwkgICAtV2JpdHdpc2UgLVduby10cmFuc3BhcmVudC11bmlvbiAtV25vLW9sZC1pbml0aWFs
aXplciAtV25vLWRlY2wKIAogaWZlcSAoJChQS0dfUExBVEZPUk0pLGxpbnV4KQotUENGTEFHUyA9
IC1EX0dOVV9TT1VSQ0UgLURfQlNEX1NPVVJDRSAtRF9YT1BFTl9TT1VSQ0U9NTAwIC1EX0ZJTEVf
T0ZGU0VUX0JJVFM9NjQgJChHQ0NGTEFHUykKK1BDRkxBR1MgPSAtRF9HTlVfU09VUkNFIC1EX0RF
RkFVTFRfU09VUkNFIC1EX1hPUEVOX1NPVVJDRT01MDAgLURfRklMRV9PRkZTRVRfQklUUz02NCAk
KEdDQ0ZMQUdTKQogaWZlcSAoJChIQVZFX1VNT0RFX1QpLHllcykKIFBDRkxBR1MgKz0gLURIQVZF
X1VNT0RFX1QKIGVuZGlmCi0tIAoyLjEuMAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDov
L29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
