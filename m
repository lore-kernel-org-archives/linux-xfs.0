Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3L9Uwex149831 for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 04:30:59 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 68F88132E346
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2011 02:34:24 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	f9vlorGkap7x1lZx for <xfs@oss.sgi.com>;
	Thu, 21 Apr 2011 02:34:24 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1QCqHG-0003Uf-Av
	for xfs@oss.sgi.com; Thu, 21 Apr 2011 19:34:22 +1000
Received: from dave by disappointment with local (Exim 4.75)
	(envelope-from <dave@disappointment.disaster>) id 1QCqHO-0003hQ-RW
	for xfs@oss.sgi.com; Thu, 21 Apr 2011 19:34:30 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/4] xfs: don't look forever in xfs_inode_ag_walk during async
	inode flushes
Date: Thu, 21 Apr 2011 19:34:26 +1000
Message-Id: <1303378468-14163-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1303378468-14163-1-git-send-email-david@fromorbit.com>
References: <1303378468-14163-1-git-send-email-david@fromorbit.com>
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

RnJvbTogRGF2ZSBDaGlubmVyIDxkY2hpbm5lckByZWRoYXQuY29tPgoKV2hlbiB0aGUgdW5kZXJs
eWluZyBpbm9kZSBidWZmZXIgaXMgbG9ja2VkIGFuZCB4ZnNfc3luY19pbm9kZV9hdHRyKCkKaXMg
ZG9pbmcgYSBub24tYmxvY2tpbmcgZmx1c2gsIHhmc19pZmx1c2goKSBjYW4gcmV0dXJuIEVBR0FJ
Ti4gV2hlbgp0aGlzIGhhcHBlbtGVLCBjbGVhciB0aGUgZXJyb3IgcmF0aGVyIHRoYW4gcmV0dXJu
aW5nIGl0IHRvCnhmc19pbm9kZV9hZ193YWxrKCksIGFzIHJldHVybmluZyBFQUdBSU4gd2lsbCBy
ZXN1bHQgaW4gdGhlIEFHIHdhbGsKZGVsYXlpbmcgZm9yIGEgc2hvcnQgd2hpbGUgYW5kIHRyeWlu
ZyBhZ2Fpbi4gVGhpcyBjYW4gcmVzdWx0IGluCmJhY2tncm91bmQgd2Fsa3MgZ2V0dGluZyBzdHVj
ayBvbiB0aGUgb25lIEFHIHVudGlsIGlub2RlIGJ1ZmZlciBpcwp1bmxvY2tlZCBieSBzb21lIG90
aGVyIG1lYW5zLgoKVGhpcyBiZWhhdmlvdXIgd2FzIG5vdGljZWQgd2hlbiBhbmFseXNpbmcgZXZl
bnQgdHJhY2VzIGZvbGxvd2VkIGJ5CmNvZGUgaW5zcGVjdGlvbiBhbmQgdmVyaWZpY2F0aW9uIG9m
IHRoZSBmaXggdmlhIGZ1cnRoZXIgdHJhY2VzLgoKU2lnbmVkLW9mZi1ieTogRGF2ZSBDaGlubmVy
IDxkY2hpbm5lckByZWRoYXQuY29tPgpSZXZpZXdlZC1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhj
aEBsc3QuZGU+Ci0tLQogZnMveGZzL2xpbnV4LTIuNi94ZnNfc3luYy5jIHwgICAxMCArKysrKysr
KysrCiAxIGZpbGVzIGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDAgZGVsZXRpb25zKC0pCgpk
aWZmIC0tZ2l0IGEvZnMveGZzL2xpbnV4LTIuNi94ZnNfc3luYy5jIGIvZnMveGZzL2xpbnV4LTIu
Ni94ZnNfc3luYy5jCmluZGV4IDc4ODM3NjIuLjMyNTM1NzIgMTAwNjQ0Ci0tLSBhL2ZzL3hmcy9s
aW51eC0yLjYveGZzX3N5bmMuYworKysgYi9mcy94ZnMvbGludXgtMi42L3hmc19zeW5jLmMKQEAg
LTI2Nyw2ICsyNjcsMTYgQEAgeGZzX3N5bmNfaW5vZGVfYXR0cigKIAogCWVycm9yID0geGZzX2lm
bHVzaChpcCwgZmxhZ3MpOwogCisJLyoKKwkgKiBXZSBkb24ndCB3YW50IHRvIHRyeSBhZ2FpbiBv
biBub24tYmxvY2tpbmcgZmx1c2hlcyB0aGF0IGNhbid0IHJ1bgorCSAqIGFnYWluIGltbWVkaWF0
ZWx5LiBJZiBhbiBpbm9kZSByZWFsbHkgbXVzdCBiZSB3cml0dGVuLCB0aGVuIHRoYXQncworCSAq
IHdoYXQgdGhlIFNZTkNfV0FJVCBmbGFnIGlzIGZvci4KKwkgKi8KKwlpZiAoZXJyb3IgPT0gRUFH
QUlOKSB7CisJCUFTU0VSVCghKGZsYWdzICYgU1lOQ19XQUlUKSk7CisJCWVycm9yID0gMDsKKwl9
CisKICBvdXRfdW5sb2NrOgogCXhmc19pdW5sb2NrKGlwLCBYRlNfSUxPQ0tfU0hBUkVEKTsKIAly
ZXR1cm4gZXJyb3I7Ci0tIAoxLjcuNC40CgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8v
b3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
