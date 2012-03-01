Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q21LERVY187428 for <xfs@oss.sgi.com>; Thu, 1 Mar 2012 15:14:27 -0600
Received: from MMS3.broadcom.com (mms3.broadcom.com [216.31.210.19]) by
	cuda.sgi.com with ESMTP id DFRgpCtl5TZABJDe for
	<xfs@oss.sgi.com>; Thu, 01 Mar 2012 13:14:26 -0800 (PST)
From: "Kamal Dasu" <kdasu.kdev@gmail.com>
Subject: [PATCH 2/2] xfsprogs: Use Posix signal API signprocmask instead
	of sigrelse/sighold in xfs_copy.c
Date: Thu, 1 Mar 2012 16:11:25 -0500
Message-ID: <c574f896af47c36a5d86c9be8c1f801e759e7b79.1330635228.git.kdasu.kdev@gmail.com>
In-Reply-To: <de74feb44ebd887269fe85d9a5879765afccf4c2.1330635228.git.kdasu.kdev@gmail.com>
References: <de74feb44ebd887269fe85d9a5879765afccf4c2.1330635228.git.kdasu.kdev@gmail.com>
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
Cc: Kamal Dasu <kdasu.kdev@gmail.com>

RnJvbSBzaWdyZWxzZSBhbmQgc2lnaG9sZCBtYW4gcGFnZQoKREVTQ1JJUFRJT04KICAgICAgIFRo
ZXNlICBmdW5jdGlvbnMgYXJlIHByb3ZpZGVkIGluIGdsaWJjIGFzIGEgY29tcGF0aWJpbGl0eSBp
bnRlcmZhY2UgZm9yCiAgICAgICBwcm9ncmFtcyB0aGF0IG1ha2UgdXNlIG9mIHRoZSBoaXN0b3Jp
Y2FsIFN5c3RlbSBWIHNpZ25hbCBBUEkuICBUaGlzIEFQSQogICAgICAgaXMgIG9ic29sZXRlOiAg
bmV3IGFwcGxpY2F0aW9ucyBzaG91bGQgdXNlIHRoZSBQT1NJWCBzaWduYWwgQVBJIChzaWdhY+KA
kAogICAgICAgdGlvbigyKSwgc2lncHJvY21hc2soMiksIGV0Yy4pCgpTaWduZWQtb2ZmLWJ5OiBL
YW1hbCBEYXN1IDxrZGFzdS5rZGV2QGdtYWlsLmNvbT4KLS0tCiBjb3B5L3hmc19jb3B5LmMgfCAg
IDE3ICsrKysrKysrKysrKysrLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyks
IDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvY29weS94ZnNfY29weS5jIGIvY29weS94ZnNf
Y29weS5jCmluZGV4IGMwMWUwYjkuLjY5Yzg1YmQgMTAwNjQ0Ci0tLSBhL2NvcHkveGZzX2NvcHku
YworKysgYi9jb3B5L3hmc19jb3B5LmMKQEAgLTcxLDYgKzcxLDE3IEBAIHhmc19vZmZfdCB3cml0
ZV9sb2dfaGVhZGVyKGludCBmZCwgd2J1ZiAqdywgeGZzX21vdW50X3QgKm1wKTsKICNkZWZpbmUg
UFJFCTB4MDgJCS8qIGFwcGVuZCBzdHJlcnJvciBzdHJpbmcgKi8KICNkZWZpbmUgTEFTVAkweDEw
CQkvKiBmaW5hbCBtZXNzYWdlIHdlIHByaW50ICovCiAKKwordm9pZAorc2lnbmFsX21hc2tmdW5j
KGludCBhZGRzZXQsIGludCBuZXdzZXQpIAoreworCXNpZ3NldF90IHNldDsKKworCXNpZ2VtcHR5
c2V0KCZzZXQpOworCXNpZ2FkZHNldCgmc2V0LCBhZGRzZXQpOworCXNpZ3Byb2NtYXNrKG5ld3Nl
dCwgJnNldCwgTlVMTCk7Cit9CisKIHZvaWQKIGRvX21lc3NhZ2UoaW50IGZsYWdzLCBpbnQgY29k
ZSwgY29uc3QgY2hhciAqZm10LCAuLi4pCiB7CkBAIC00NzgsOSArNDg5LDkgQEAgd3JpdGVfd2J1
Zih2b2lkKQogCQlpZiAodGFyZ2V0W2ldLnN0YXRlICE9IElOQUNUSVZFKQogCQkJcHRocmVhZF9t
dXRleF91bmxvY2soJnRhcmdbaV0ud2FpdCk7CS8qIHdha2UgdXAgKi8KIAotCXNpZ3JlbHNlKFNJ
R0NITEQpOworCXNpZ25hbF9tYXNrZnVuYyhTSUdDSExELCBTSUdfVU5CTE9DSyk7CiAJcHRocmVh
ZF9tdXRleF9sb2NrKCZtYWlud2FpdCk7Ci0Jc2lnaG9sZChTSUdDSExEKTsKKwlzaWduYWxfbWFz
a2Z1bmMoU0lHQ0hMRCwgU0lHX0JMT0NLKTsKIH0KIAogCkBAIC04NDcsNyArODU4LDcgQEAgbWFp
bihpbnQgYXJnYywgY2hhciAqKmFyZ3YpCiAJLyogc2V0IHVwIHNpZ2NoaWxkIHNpZ25hbCBoYW5k
bGVyICovCiAKIAlzaWduYWwoU0lHQ0hMRCwgaGFuZGxlcik7Ci0Jc2lnaG9sZChTSUdDSExEKTsK
KwlzaWduYWxfbWFza2Z1bmMoU0lHQ0hMRCwgU0lHX0JMT0NLKTsKIAogCS8qIG1ha2UgY2hpbGRy
ZW4gKi8KIAotLSAKMS43LjUuNAoKCl9fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZzQG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Mu
c2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
