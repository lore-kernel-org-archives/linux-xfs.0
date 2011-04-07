Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p376P0MP081263 for <xfs@oss.sgi.com>; Thu, 7 Apr 2011 01:25:00 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3B4EA1494E43
	for <xfs@oss.sgi.com>; Wed,  6 Apr 2011 23:28:16 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	hUXGU0IQY4CyDVuE for <xfs@oss.sgi.com>;
	Wed, 06 Apr 2011 23:28:16 -0700 (PDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1Q7ihH-0006SF-36
	for xfs@oss.sgi.com; Thu, 07 Apr 2011 16:28:03 +1000
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Q7ihJ-00012U-Os
	for xfs@oss.sgi.com; Thu, 07 Apr 2011 16:28:05 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: don't look forever in xfs_inode_ag_walk during async
	inode flushes
Date: Thu,  7 Apr 2011 16:28:05 +1000
Message-Id: <1302157685-3966-1-git-send-email-david@fromorbit.com>
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
IDxkY2hpbm5lckByZWRoYXQuY29tPgotLS0KIGZzL3hmcy9saW51eC0yLjYveGZzX3N5bmMuYyB8
ICAgMTAgKysrKysrKysrKwogMSBmaWxlcyBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCAwIGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2ZzL3hmcy9saW51eC0yLjYveGZzX3N5bmMuYyBiL2Zz
L3hmcy9saW51eC0yLjYveGZzX3N5bmMuYwppbmRleCBjMjQwZDQ2Li40NTZiYzMxIDEwMDY0NAot
LS0gYS9mcy94ZnMvbGludXgtMi42L3hmc19zeW5jLmMKKysrIGIvZnMveGZzL2xpbnV4LTIuNi94
ZnNfc3luYy5jCkBAIC0yNjcsNiArMjY3LDE2IEBAIHhmc19zeW5jX2lub2RlX2F0dHIoCiAKIAll
cnJvciA9IHhmc19pZmx1c2goaXAsIGZsYWdzKTsKIAorCS8qCisJICogV2UgZG9uJ3Qgd2FudCB0
byB0cnkgYWdhaW4gb24gbm9uLWJsb2NraW5nIGZsdXNoZXMgdGhhdCBjYW4ndCBydW4KKwkgKiBh
Z2FpbiBpbW1lZGlhdGVseS4gSWYgYW4gaW5vZGUgcmVhbGx5IG11c3QgYmUgd3JpdHRlbiwgdGhl
biB0aGF0J3MKKwkgKiB3aGF0IHRoZSBTWU5DX1dBSVQgZmxhZyBpcyBmb3IuCisJICovCisJaWYg
KGVycm9yID09IEVBR0FJTikgeworCQlBU1NFUlQoIShmbGFncyAmIFNZTkNfV0FJVCkpOworCQll
cnJvciA9IDA7CisJfQorCiAgb3V0X3VubG9jazoKIAl4ZnNfaXVubG9jayhpcCwgWEZTX0lMT0NL
X1NIQVJFRCk7CiAJcmV0dXJuIGVycm9yOwotLSAKMS43LjIuMwoKX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3NzLnNn
aS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
