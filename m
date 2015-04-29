Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 947FA7F37
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2015 03:13:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8509C304032
	for <xfs@oss.sgi.com>; Wed, 29 Apr 2015 01:13:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AVbIWXkJ9N6uNa3e (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Apr 2015 01:13:45 -0700 (PDT)
From: =?UTF-8?q?Jan=20=C5=A4ul=C3=A1k?= <jtulak@redhat.com>
Subject: [PATCH] xfsprogs: Removing deprecated _BSD_SOURCE definition.
Date: Wed, 29 Apr 2015 10:13:42 +0200
Message-Id: <1430295222-13565-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <20150428211259.GZ21261@dastard>
References: <20150428211259.GZ21261@dastard>
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
To: david@fromorbit.com
Cc: xfs@oss.sgi.com

SW4gZ2xpYmMgMi4yMCwgX0JTRF9TT1VSQ0Ugd2FzIGRlcHJlY2F0ZWQgaW4gZmF2b3Igb2YgX0RF
RkFVTFRfU09VUkNFLgpfREVGQVVMVF9TT1VSQ0UgaXMgaW5jbHVkZWQgd2l0aCBfR05VX1NPVVJD
RSwgYXMgd2VsbCBhcyBfWE9QRU5fU09VUkNFID49IDUwMCwKc28gdGhlIG9ic29sZXRlIGFuZCB1
bm5lY2Vzc2FyeSBkZWZpbml0aW9ucyBhcmUgcmVtb3ZlZC4KCkZvciBtb3JlIGRldGFpbHMsIHNl
ZSBtYW4gNyBmZWF0dXJlX3Rlc3RfbWFjcm9zIGZvciBnbGliYyA+PSAyLjIwLgoKU2lnbmVkLW9m
Zi1ieTogSmFuIMWkdWzDoWsgPGp0dWxha0ByZWRoYXQuY29tPgotLS0KIGluY2x1ZGUvYnVpbGRk
ZWZzLmluIHwgMiArLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9u
KC0pCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9idWlsZGRlZnMuaW4gYi9pbmNsdWRlL2J1aWxkZGVm
cy5pbgppbmRleCA5NDRiY2Y2Li43ZTlmNTNkIDEwMDY0NAotLS0gYS9pbmNsdWRlL2J1aWxkZGVm
cy5pbgorKysgYi9pbmNsdWRlL2J1aWxkZGVmcy5pbgpAQCAtMTA5LDcgKzEwOSw3IEBAIEdDQ0ZM
QUdTID0gLWZ1bnNpZ25lZC1jaGFyIC1mbm8tc3RyaWN0LWFsaWFzaW5nIC1XYWxsCiAjCSAgIC1X
Yml0d2lzZSAtV25vLXRyYW5zcGFyZW50LXVuaW9uIC1Xbm8tb2xkLWluaXRpYWxpemVyIC1Xbm8t
ZGVjbAogCiBpZmVxICgkKFBLR19QTEFURk9STSksbGludXgpCi1QQ0ZMQUdTID0gLURfR05VX1NP
VVJDRSAtRF9CU0RfU09VUkNFIC1EX1hPUEVOX1NPVVJDRT01MDAgLURfRklMRV9PRkZTRVRfQklU
Uz02NCAkKEdDQ0ZMQUdTKQorUENGTEFHUyA9IC1EX0dOVV9TT1VSQ0UgLURfRklMRV9PRkZTRVRf
QklUUz02NCAkKEdDQ0ZMQUdTKQogaWZlcSAoJChIQVZFX1VNT0RFX1QpLHllcykKIFBDRkxBR1Mg
Kz0gLURIQVZFX1VNT0RFX1QKIGVuZGlmCi0tIAoyLjEuMAoKX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5j
b20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
