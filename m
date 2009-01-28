Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n0SIPPKe143417 for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 12:25:26 -0600
Received: from main.carme.maven.pl (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A23741880B4D
	for <xfs@oss.sgi.com>; Wed, 28 Jan 2009 10:24:43 -0800 (PST)
Received: from main.carme.maven.pl (main.carme.maven.pl [193.239.45.138]) by
	cuda.sgi.com with ESMTP id rxPnnG5qmCjYBmNy for
	<xfs@oss.sgi.com>; Wed, 28 Jan 2009 10:24:43 -0800 (PST)
Received: from chello089076029166.chello.pl ([89.76.29.166]:1374 helo=maven.pl)
	by main.carme.maven.pl with esmtpsa (TLSv1:DHE-RSA-AES256-SHA:256)
	(Exim 4.69) (envelope-from <arekm@maven.pl>) id 1LSF5e-0004Cl-2X
	for xfs@oss.sgi.com; Wed, 28 Jan 2009 19:24:42 +0100
From: =?utf-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: [PATCH] [LIBXCMD]: Move error messages to appropriate places.
Date: Wed, 28 Jan 2009 19:24:11 +0100
Message-Id: <1233167051-14711-1-git-send-email-arekm@maven.pl>
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

UmVwbGFjZSByYXcgcGVycm9yKCkgd2l0aCBwcm9wZXIgbWVzc2FnZSBpbgpmc190YWJsZV9pbml0
aWFsaXNlX21vdW50cygpLgoKUmVwbGFjZSByYXcgcGVycm9yKCkgd2l0aCBwcm9wZXIgbWVzc2Fn
ZSBhbmQgbW92ZSBpdCBmcm9tCmZzX21vdW50X3BvaW50X2Zyb21fcGF0aCgpIHRvIGZzX3RhYmxl
X2luaXRpYWxpc2VfcHJvamVjdHMoKSB3aGVyZSB0aGlzCm1lc3NhZ2UgaGFzIG1lYW5pbmcuCgpT
aWduZWQtb2ZmLWJ5OiBBcmthZGl1c3ogTWnFm2tpZXdpY3ogPGFyZWttQG1hdmVuLnBsPgotLS0K
IGxpYnhjbWQvcGF0aHMuYyB8ICAgIDkgKysrKysrLS0tCiAxIGZpbGVzIGNoYW5nZWQsIDYgaW5z
ZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9saWJ4Y21kL3BhdGhzLmMg
Yi9saWJ4Y21kL3BhdGhzLmMKaW5kZXggZmFjZWEwNi4uNmMzNmI3OSAxMDA2NDQKLS0tIGEvbGli
eGNtZC9wYXRocy5jCisrKyBiL2xpYnhjbWQvcGF0aHMuYwpAQCAtMjQ4LDcgKzI0OCw4IEBAIGZz
X3RhYmxlX2luaXRpYWxpc2VfbW91bnRzKAogCWRpciA9IGZzbmFtZSA9IGZzbG9nID0gZnNydCA9
IE5VTEw7CiAKIAlpZiAoKGNvdW50ID0gZ2V0bW50aW5mbygmc3RhdHMsIDApKSA8IDApIHsKLQkJ
cGVycm9yKCJnZXRtbnRpbmZvIik7CisJCWZwcmludGYoc3RkZXJyLCBfKCIlczogZ2V0bW50aW5m
bygpIGZhaWxlZDogJXNcbiIpLAorCQkJCXByb2duYW1lLCBzdHJlcnJvcihlcnJubykpOwogCQly
ZXR1cm4gMDsKIAl9CiAKQEAgLTI5OCw3ICsyOTksNiBAQCBmc19tb3VudF9wb2ludF9mcm9tX3Bh
dGgoCiAJc3RydWN0IHN0YXQ2NAlzOwogCiAJaWYgKHN0YXQ2NChkaXIsICZzKSA8IDApIHsKLQkJ
cGVycm9yKGRpcik7CiAJCXJldHVybiBOVUxMOwogCX0KIApAQCAtMzI3LDggKzMyNywxMSBAQCBm
c190YWJsZV9pbml0aWFsaXNlX3Byb2plY3RzKAogCXdoaWxlICgocGF0aCA9IGdldHBycGF0aGVu
dCgpKSAhPSBOVUxMKSB7CiAJCWlmIChwcm9qZWN0ICYmIHByaWQgIT0gcGF0aC0+cHBfcHJpZCkK
IAkJCWNvbnRpbnVlOwotCQlpZiAoKGZzID0gZnNfbW91bnRfcG9pbnRfZnJvbV9wYXRoKHBhdGgt
PnBwX3BhdGhuYW1lKSkgPT0gTlVMTCkKKwkJaWYgKChmcyA9IGZzX21vdW50X3BvaW50X2Zyb21f
cGF0aChwYXRoLT5wcF9wYXRobmFtZSkpID09IE5VTEwpIHsKKwkJCWZwcmludGYoc3RkZXJyLCBf
KCIlczogY2Fubm90IGZpbmQgbW91bnQgcG9pbnQgZm9yIHBhdGggYCVzJzogJXNcbiIpLAorCQkJ
CQlwcm9nbmFtZSwgcGF0aC0+cHBfcGF0aG5hbWUsIHN0cmVycm9yKGVycm5vKSk7CiAJCQljb250
aW51ZTsKKwkJfQogCQlmb3VuZCA9IDE7CiAJCWRpciA9IHN0cmR1cChwYXRoLT5wcF9wYXRobmFt
ZSk7CiAJCWZzbmFtZSA9IHN0cmR1cChmcy0+ZnNfbmFtZSk7Ci0tIAoxLjYuMS4xCgpfX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMgbWFpbGluZyBsaXN0
Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9saXN0aW5mby94ZnMK
