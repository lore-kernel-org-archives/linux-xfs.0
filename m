Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2EK9euR236749 for <xfs@oss.sgi.com>; Wed, 14 Mar 2012 15:09:40 -0500
Received: from MMS3.broadcom.com (mms3.broadcom.com [216.31.210.19]) by
	cuda.sgi.com with ESMTP id ZExs5NMrVFZ0apbY for
	<xfs@oss.sgi.com>; Wed, 14 Mar 2012 13:09:39 -0700 (PDT)
From: "Kamal Dasu" <kdasu.kdev@gmail.com>
Subject: [PATCH 1/1] xfsprogs: Use Posix signal API sigprocmask instead
	of sigrelse/sighold in xfs_copy.c
Date: Wed, 14 Mar 2012 16:09:28 -0400
Message-ID: <1331755768-14681-2-git-send-email-kdasu.kdev@gmail.com>
In-Reply-To: <1331755768-14681-1-git-send-email-kdasu.kdev@gmail.com>
References: <1331755768-14681-1-git-send-email-kdasu.kdev@gmail.com>
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
To: xfs@oss.sgi.com, cernekee@gmail.com
Cc: Kamal Dasu <kdasu.kdev@gmail.com>

RnJvbSBzaWdyZWxzZSBhbmQgc2lnaG9sZCBtYW4gcGFnZQoKREVTQ1JJUFRJT04KICAgICAgIFRo
ZXNlICBmdW5jdGlvbnMgYXJlIHByb3ZpZGVkIGluIGdsaWJjIGFzIGEgY29tcGF0aWJpbGl0eSBp
bnRlcmZhY2UgZm9yCiAgICAgICBwcm9ncmFtcyB0aGF0IG1ha2UgdXNlIG9mIHRoZSBoaXN0b3Jp
Y2FsIFN5c3RlbSBWIHNpZ25hbCBBUEkuICBUaGlzIEFQSQogICAgICAgaXMgIG9ic29sZXRlOiAg
bmV3IGFwcGxpY2F0aW9ucyBzaG91bGQgdXNlIHRoZSBQT1NJWCBzaWduYWwgQVBJIChzaWdhY+KA
kAogICAgICAgdGlvbigyKSwgc2lncHJvY21hc2soMiksIGV0Yy4pCgpTaWduZWQtb2ZmLWJ5OiBL
YW1hbCBEYXN1IDxrZGFzdS5rZGV2QGdtYWlsLmNvbT4KLS0tCiBjb3B5L3hmc19jb3B5LmMgfCAg
IDE2ICsrKysrKysrKysrKystLS0KIDEgZmlsZXMgY2hhbmdlZCwgMTMgaW5zZXJ0aW9ucygrKSwg
MyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9jb3B5L3hmc19jb3B5LmMgYi9jb3B5L3hmc19j
b3B5LmMKaW5kZXggYzAxZTBiOS4uODAwZjRmZCAxMDA2NDQKLS0tIGEvY29weS94ZnNfY29weS5j
CisrKyBiL2NvcHkveGZzX2NvcHkuYwpAQCAtNzEsNiArNzEsMTYgQEAgeGZzX29mZl90IHdyaXRl
X2xvZ19oZWFkZXIoaW50IGZkLCB3YnVmICp3LCB4ZnNfbW91bnRfdCAqbXApOwogI2RlZmluZSBQ
UkUJMHgwOAkJLyogYXBwZW5kIHN0cmVycm9yIHN0cmluZyAqLwogI2RlZmluZSBMQVNUCTB4MTAJ
CS8qIGZpbmFsIG1lc3NhZ2Ugd2UgcHJpbnQgKi8KIAorc3RhdGljIHZvaWQKK3NpZ25hbF9tYXNr
ZnVuYyhpbnQgc2lnLCBpbnQgaG93KSAKK3sKKwlzaWdzZXRfdCBzZXQ7CisKKwlzaWdlbXB0eXNl
dCgmc2V0KTsKKwlzaWdhZGRzZXQoJnNldCwgc2lnKTsKKwlzaWdwcm9jbWFzayhob3csICZzZXQs
IE5VTEwpOworfQorCiB2b2lkCiBkb19tZXNzYWdlKGludCBmbGFncywgaW50IGNvZGUsIGNvbnN0
IGNoYXIgKmZtdCwgLi4uKQogewpAQCAtNDc4LDkgKzQ4OCw5IEBAIHdyaXRlX3didWYodm9pZCkK
IAkJaWYgKHRhcmdldFtpXS5zdGF0ZSAhPSBJTkFDVElWRSkKIAkJCXB0aHJlYWRfbXV0ZXhfdW5s
b2NrKCZ0YXJnW2ldLndhaXQpOwkvKiB3YWtlIHVwICovCiAKLQlzaWdyZWxzZShTSUdDSExEKTsK
KwlzaWduYWxfbWFza2Z1bmMoU0lHQ0hMRCwgU0lHX1VOQkxPQ0spOwogCXB0aHJlYWRfbXV0ZXhf
bG9jaygmbWFpbndhaXQpOwotCXNpZ2hvbGQoU0lHQ0hMRCk7CisJc2lnbmFsX21hc2tmdW5jKFNJ
R0NITEQsIFNJR19CTE9DSyk7CiB9CiAKIApAQCAtODQ3LDcgKzg1Nyw3IEBAIG1haW4oaW50IGFy
Z2MsIGNoYXIgKiphcmd2KQogCS8qIHNldCB1cCBzaWdjaGlsZCBzaWduYWwgaGFuZGxlciAqLwog
CiAJc2lnbmFsKFNJR0NITEQsIGhhbmRsZXIpOwotCXNpZ2hvbGQoU0lHQ0hMRCk7CisJc2lnbmFs
X21hc2tmdW5jKFNJR0NITEQsIFNJR19CTE9DSyk7CiAKIAkvKiBtYWtlIGNoaWxkcmVuICovCiAK
LS0gCjEuNy41LjQKCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fXwp4ZnMgbWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20v
bWFpbG1hbi9saXN0aW5mby94ZnMK
