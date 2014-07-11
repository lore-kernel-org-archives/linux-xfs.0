Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 84DF97F47
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 14:34:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4EAD2304039
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 12:34:19 -0700 (PDT)
Received: from mail-we0-f176.google.com (mail-we0-f176.google.com
	[74.125.82.176]) by cuda.sgi.com with ESMTP id a0Y7KKfk10drGJuN
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 11 Jul 2014 12:34:16 -0700 (PDT)
Received: by mail-we0-f176.google.com with SMTP id u56so1531411wes.21
	for <xfs@oss.sgi.com>; Fri, 11 Jul 2014 12:34:11 -0700 (PDT)
From: =?UTF-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: [PATCH] Catch under/overflow cases in cvtnum() and cvttime().
Date: Fri, 11 Jul 2014 21:34:04 +0200
Message-Id: <1405107244-14234-1-git-send-email-arekm@maven.pl>
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

Y3Z0bnVtKCkgYW5kIGN2dHRpbWUoKSBzaWxlbnRseSBpZ25vcmUgb3ZlcmZsb3dzLiBUaGlzIGxl
YWRzIHRvIGVycm9yCmNvbmRpdGlvbnMgbm90IGJlaW5nIGNhdGNoZWQuIEV4YW1wbGU6CgokIHhm
c19xdW90YSAteCAtYyAnbGltaXQgLXUgYnNvZnQ9OTg3NjU0MzIxMDk4NzY1NDMyMTk5IFwKICAg
ICAgICBiaGFyZD05ODc2NTQzMjEwOTg3NjU0MzIxOTkgOTk5JyAvCiQKCkZpeGVkIHZlcnNpb246
CiQgeGZzX3F1b3RhIC14IC1jICdsaW1pdCAtdSBic29mdD05ODc2NTQzMjEwOTg3NjU0MzIxOTkg
XAogICAgICAgIGJoYXJkPTk4NzY1NDMyMTA5ODc2NTQzMjE5OSA5OTknIC8KeGZzX3F1b3RhOiBF
cnJvcjogY291bGQgbm90IHBhcnNlIHNpemUgOTg3NjU0MzIxMDk4NzY1NDMyMTk5Lgp4ZnNfcXVv
dGE6IHVucmVjb2duaXNlZCBhcmd1bWVudCBic29mdD05ODc2NTQzMjEwOTg3NjU0MzIxOTkKClNp
Z25lZC1vZmYtYnk6IEFya2FkaXVzeiBNacWba2lld2ljeiA8YXJla21AbWF2ZW4ucGw+Ci0tLQog
bGlieGNtZC9pbnB1dC5jIHwgNCArKysrCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCsp
CgpkaWZmIC0tZ2l0IGEvbGlieGNtZC9pbnB1dC5jIGIvbGlieGNtZC9pbnB1dC5jCmluZGV4IGMw
NmI1YjguLjM5N2ExMjQgMTAwNjQ0Ci0tLSBhL2xpYnhjbWQvaW5wdXQuYworKysgYi9saWJ4Y21k
L2lucHV0LmMKQEAgLTE1NCw2ICsxNTQsOCBAQCBjdnRudW0oCiAJaW50CQljOwogCiAJaSA9IHN0
cnRvbGwocywgJnNwLCAwKTsKKwlpZiAoKGkgPT0gTExPTkdfTUlOIHx8IGkgPT0gTExPTkdfTUFY
KSAmJiBlcnJubyA9PSBFUkFOR0UpCisJCXJldHVybiAtMUxMOwogCWlmIChpID09IDAgJiYgc3Ag
PT0gcykKIAkJcmV0dXJuIC0xTEw7CiAJaWYgKCpzcCA9PSAnXDAnKQpAQCAtMjM4LDYgKzI0MCw4
IEBAIGN2dHRpbWUoCiAJY2hhcgkJKnNwOwogCiAJaSA9IHN0cnRvdWwocywgJnNwLCAwKTsKKwlp
ZiAoaSA9PSBVTE9OR19NQVggJiYgZXJybm8gPT0gRVJBTkdFKQorCQlyZXR1cm4gMDsKIAlpZiAo
aSA9PSAwICYmIHNwID09IHMpCiAJCXJldHVybiAwOwogCWlmICgqc3AgPT0gJ1wwJykKLS0gCjIu
MC4wCgpfX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXwp4ZnMg
bWFpbGluZyBsaXN0Cnhmc0Bvc3Muc2dpLmNvbQpodHRwOi8vb3NzLnNnaS5jb20vbWFpbG1hbi9s
aXN0aW5mby94ZnMK
