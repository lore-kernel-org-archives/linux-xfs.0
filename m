Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7Q71enH017218 for <xfs@oss.sgi.com>; Thu, 26 Aug 2010 02:01:40 -0500
Received: from smtp-relay.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A6E16276E5
	for <xfs@oss.sgi.com>; Thu, 26 Aug 2010 00:02:15 -0700 (PDT)
Received: from smtp-relay.maven.pl (smtp-relay.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id 6U7VPzJN46Dylc1F for
	<xfs@oss.sgi.com>; Thu, 26 Aug 2010 00:02:15 -0700 (PDT)
From: =?UTF-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: [PATCH] Disallow 32bit project quota id.
Date: Thu, 26 Aug 2010 09:02:11 +0200
Message-Id: <1282806131-20163-1-git-send-email-arekm@maven.pl>
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

Q3VycmVudGx5IG9uLWRpc2sgc3RydWN0dXJlIGlzIGFibGUgdG8ga2VlcCBvbmx5IDE2Yml0IHBy
b2plY3QgcXVvdGEgaWQsCnNvIGRpc2FsbG93IDMyYml0IG9uZXMuIFRoaXMgZml4ZXMgYSBwcm9i
bGVtIHdoZXJlIHBhcnQgb2Yga2VybmVsCnN0cnVjdHVyZXMgaG9sZGluZyBwcm9qZWN0IHF1b3Rh
IGlkIHVzZXMgMzJiaXQgdmFyaWFibGUgd2hpbGUgcGFydAoob24tZGlzaykgdXNlcyAxNmJpdCB2
YXJpYWJsZSB3aGljaCBjYXVzZXMgcHJvamVjdCBxdW90YSBtZW1iZXIgZmlsZXMKdG8gYmUgaW5h
Y2Nlc3NpYmxlIGZvciBzb21lIG9wZXJhdGlvbnMgKGxpa2UgbXYvcm0pLgoKU2lnbmVkLW9mZi1i
eTogQXJrYWRpdXN6IE1pxZtraWV3aWN6IDxhcmVrbUBtYXZlbi5wbD4KLS0tCgpQbGVhc2UgcXVl
dWUgZm9yIHVwY29taW5nIDIuNi4zNiBmaXhlcy4KCgogZnMveGZzL2xpbnV4LTIuNi94ZnNfaW9j
dGwuYyB8ICAgIDQgKysrKwogMSBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKyksIDAgZGVs
ZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMveGZzL2xpbnV4LTIuNi94ZnNfaW9jdGwuYyBiL2Zz
L3hmcy9saW51eC0yLjYveGZzX2lvY3RsLmMKaW5kZXggMjM3ZjVmZi4uMDE2NjIyNiAxMDA2NDQK
LS0tIGEvZnMveGZzL2xpbnV4LTIuNi94ZnNfaW9jdGwuYworKysgYi9mcy94ZnMvbGludXgtMi42
L3hmc19pb2N0bC5jCkBAIC05MDYsNiArOTA2LDEwIEBAIHhmc19pb2N0bF9zZXRhdHRyKAogCWlm
IChYRlNfRk9SQ0VEX1NIVVRET1dOKG1wKSkKIAkJcmV0dXJuIFhGU19FUlJPUihFSU8pOwogCisJ
LyogRGlzYWxsb3cgMzJiaXQgcHJvamVjdCBpZHMgdGhhdCBiZWNhdXNlIG9uLWRpc2sgc3RydWN0
dXJlIGlzIDE2Yml0IG9ubHkgKi8KKwlpZiAoZmEtPmZzeF9wcm9qaWQgPiAoX191aW50MTZfdCkt
MSkKKwkJcmV0dXJuIFhGU19FUlJPUihFSU5WQUwpOworCiAJLyoKIAkgKiBJZiBkaXNrIHF1b3Rh
cyBpcyBvbiwgd2UgbWFrZSBzdXJlIHRoYXQgdGhlIGRxdW90cyBkbyBleGlzdCBvbiBkaXNrLAog
CSAqIGJlZm9yZSB3ZSBzdGFydCBhbnkgb3RoZXIgdHJhbnNhY3Rpb25zLiBUcnlpbmcgdG8gZG8g
dGhpcyBsYXRlcgotLSAKMS43LjEuMQoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNnaS5jb20KaHR0cDovL29z
cy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
