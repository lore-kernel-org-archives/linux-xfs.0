Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBCE6eZN101595 for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 08:06:41 -0600
Received: from mail-ee0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id DAED516EEF11
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 06:06:39 -0800 (PST)
Received: from mail-ee0-f53.google.com (mail-ee0-f53.google.com
	[74.125.83.53]) by cuda.sgi.com with ESMTP id ET3keM5aDRIewCym
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 06:06:39 -0800 (PST)
Received: by eekd41 with SMTP id d41so1392089eek.26
	for <xfs@oss.sgi.com>; Mon, 12 Dec 2011 06:06:38 -0800 (PST)
From: =?UTF-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: [PATCH] xfs_lsprojid: show quota project id for specified files
Date: Mon, 12 Dec 2011 15:06:32 +0100
Message-Id: <1323698792-25775-1-git-send-email-arekm@maven.pl>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

VGhlcmUgaXMgbm8gc2ltcGxlIHdheSBmb3IgZXh0cmFjdGluZyBxdW90YSBwcm9qZWN0IGlkIGZv
ciBzcGVjaWZpZWQKZmlsZXMsIHNvIGhlcmUgaXMgYSBzaGVsbCB3cmFwcGVyIHdoaWNoIG1ha2Vz
IHRoaXMgZWFzeSB0aGluZzoKCi9ob21lL3NvbWV0aGluZy9hYWE6IDEwNzkxOQovaG9tZS9zb21l
dGhpbmcvYmJiOiAxMDc5MjMKClNpZ25lZC1vZmYtYnk6IEFya2FkaXVzeiBNacWba2lld2ljeiA8
YXJla21AbWF2ZW4ucGw+Ci0tLQogcXVvdGEvTWFrZWZpbGUgICAgICAgIHwgICAgNCArKystCiBx
dW90YS94ZnNfbHNwcm9qaWQuc2ggfCAgICA5ICsrKysrKysrKwogMiBmaWxlcyBjaGFuZ2VkLCAx
MiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9ucygtKQogY3JlYXRlIG1vZGUgMTAwNzU1IHF1b3Rh
L3hmc19sc3Byb2ppZC5zaAoKZGlmZiAtLWdpdCBhL3F1b3RhL01ha2VmaWxlIGIvcXVvdGEvTWFr
ZWZpbGUKaW5kZXggOWM2NDExZS4uZDgxMzAwNSAxMDA2NDQKLS0tIGEvcXVvdGEvTWFrZWZpbGUK
KysrIGIvcXVvdGEvTWFrZWZpbGUKQEAgLTEyLDcgKzEyLDggQEAgQ0ZJTEVTID0gaW5pdC5jIHV0
aWwuYyBcCiAKIENGSUxFUyArPSAkKFBLR19QTEFURk9STSkuYwogUENGSUxFUyA9IGRhcndpbi5j
IGZyZWVic2QuYyBpcml4LmMgbGludXguYwotTFNSQ0ZJTEVTID0gJChzaGVsbCBlY2hvICQoUENG
SUxFUykgfCBzZWQgLWUgInMvJChQS0dfUExBVEZPUk0pLmMvL2ciKQorTFNSQ0ZJTEVTID0gJChz
aGVsbCBlY2hvICQoUENGSUxFUykgfCBzZWQgLWUgInMvJChQS0dfUExBVEZPUk0pLmMvL2ciKSBc
CisJeGZzX2xzcHJvamlkLnNoCiAKIExMRExJQlMgPSAkKExJQlhDTUQpCiBMVERFUEVOREVOQ0lF
UyA9ICQoTElCWENNRCkKQEAgLTM1LDYgKzM2LDcgQEAgaW5jbHVkZSAkKEJVSUxEUlVMRVMpCiBp
bnN0YWxsOiBkZWZhdWx0CiAJJChJTlNUQUxMKSAtbSA3NTUgLWQgJChQS0dfU0JJTl9ESVIpCiAJ
JChMVElOU1RBTEwpIC1tIDc1NSAkKExUQ09NTUFORCkgJChQS0dfU0JJTl9ESVIpCisJJChJTlNU
QUxMKSAtbSA3NTUgeGZzX2xzcHJvamlkLnNoICQoUEtHX1NCSU5fRElSKS94ZnNfbHNwcm9qaWQK
IGluc3RhbGwtZGV2OgogCiAtaW5jbHVkZSAuZGVwCmRpZmYgLS1naXQgYS9xdW90YS94ZnNfbHNw
cm9qaWQuc2ggYi9xdW90YS94ZnNfbHNwcm9qaWQuc2gKbmV3IGZpbGUgbW9kZSAxMDA3NTUKaW5k
ZXggMDAwMDAwMC4uNDQwNGRlNQotLS0gL2Rldi9udWxsCisrKyBiL3F1b3RhL3hmc19sc3Byb2pp
ZC5zaApAQCAtMCwwICsxLDkgQEAKKyMhL2Jpbi9zaAorIworIyBDb3B5cmlnaHQgKGMpIDIwMTEg
QXJrYWRpdXN6IE1pxZtraWV3aWN6LgorIworCit4ZnNfaW8gLXAgIiQwIiAtYyAic3RhdCIgJEAg
fCBhd2sgJworL15mZFwucGF0aCA9LyB7IHByb2ppZD0iIjsgcGF0aD0kMzsgZ3N1YigvXlwiLywg
IiIsIHBhdGgpOyBnc3ViKC9cIiQvLCAiIiwgcGF0aCk7IH0KKy9eZnN4YXR0clwucHJvamlkID0v
IHsgcHJvamlkPSQzOyBwcmludCBwYXRoICI6ICIgcHJvamlkOyB9CisnCi0tIAoxLjcuOAoKX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcg
bGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8v
eGZzCg==
