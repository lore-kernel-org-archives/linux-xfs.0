Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 340037F6F
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 02:57:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 35F588F804C
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 00:57:07 -0700 (PDT)
Received: from mail-wi0-f182.google.com (mail-wi0-f182.google.com
	[209.85.212.182]) by cuda.sgi.com with ESMTP id
	zd5HuQbg8c5cMbg4 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 14 Jul 2014 00:57:03 -0700 (PDT)
Received: by mail-wi0-f182.google.com with SMTP id d1so2029777wiv.9
	for <xfs@oss.sgi.com>; Mon, 14 Jul 2014 00:57:02 -0700 (PDT)
From: =?UTF-8?q?Arkadiusz=20Mi=C5=9Bkiewicz?= <arekm@maven.pl>
Subject: [PATCH] Detect strto* failures based on errno.
Date: Mon, 14 Jul 2014 09:56:59 +0200
Message-Id: <1405324619-25515-1-git-send-email-arekm@maven.pl>
In-Reply-To: <20140713230406.GE22339@dastard>
References: <20140713230406.GE22339@dastard>
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

Q29kZSB3YXMgdGVzdGluZyBmb3IgRVJBTkdFIGVycm5vIG9ubHkgaW4gc29tZSBwbGFjZXMuIElu
IG90aGVyIHBsYWNlcwppdCBkaWRuJ3QgZG8gYW55IGVycm5vIGNoZWNraW5nIGF0IGFsbC4KClVu
aWZ5IHN0cnRvKiByZXN1bHQgdGVzdGluZyBieSB0cmVhdGluZyBhbnkgbm9uIHplcm8gZXJybm8g
YXMgZmFpbHVyZS4KClNpZ25lZC1vZmYtYnk6IEFya2FkaXVzeiBNacWba2lld2ljeiA8YXJla21A
bWF2ZW4ucGw+Ci0tLQogbGlieGNtZC9pbnB1dC5jIHwgMTggKysrKysrKysrKy0tLS0tLS0tCiAx
IGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkKCmRpZmYgLS1n
aXQgYS9saWJ4Y21kL2lucHV0LmMgYi9saWJ4Y21kL2lucHV0LmMKaW5kZXggYzA2YjViOC4uZDcy
ZGZmMyAxMDA2NDQKLS0tIGEvbGlieGNtZC9pbnB1dC5jCisrKyBiL2xpYnhjbWQvaW5wdXQuYwpA
QCAtMTUzLDggKzE1Myw5IEBAIGN2dG51bSgKIAljaGFyCQkqc3A7CiAJaW50CQljOwogCisJZXJy
bm8gPSAwOwogCWkgPSBzdHJ0b2xsKHMsICZzcCwgMCk7Ci0JaWYgKGkgPT0gMCAmJiBzcCA9PSBz
KQorCWlmIChlcnJubyB8fCAoaSA9PSAwICYmIHNwID09IHMpKQogCQlyZXR1cm4gLTFMTDsKIAlp
ZiAoKnNwID09ICdcMCcpCiAJCXJldHVybiBpOwpAQCAtMjM3LDggKzIzOCw5IEBAIGN2dHRpbWUo
CiAJdW5zaWduZWQgbG9uZwlpOwogCWNoYXIJCSpzcDsKIAorCWVycm5vID0gMDsKIAlpID0gc3Ry
dG91bChzLCAmc3AsIDApOwotCWlmIChpID09IDAgJiYgc3AgPT0gcykKKwlpZiAoZXJybm8gfHwg
KGkgPT0gMCAmJiBzcCA9PSBzKSkKIAkJcmV0dXJuIDA7CiAJaWYgKCpzcCA9PSAnXDAnKQogCQly
ZXR1cm4gaTsKQEAgLTM0NCwxMCArMzQ2LDEwIEBAIHByaWRfZnJvbV9zdHJpbmcoCiAJICogQWxs
b3cgZWl0aGVyIGEgZnVsbCBudW1lcmljIG9yIGEgdmFsaWQgcHJvamVjdG5hbWUsIGV2ZW4KIAkg
KiBpZiBpdCBzdGFydHMgd2l0aCBhIGRpZ2l0LgogCSAqLworCWVycm5vID0gMDsKIAlwcmlkX2xv
bmcgPSBzdHJ0b3VsKHByb2plY3QsICZzcCwgMTApOwogCWlmICgqcHJvamVjdCAhPSAnXDAnICYm
ICpzcCA9PSAnXDAnKSB7Ci0JCWlmICgocHJpZF9sb25nID09IFVMT05HX01BWCAmJiBlcnJubyA9
PSBFUkFOR0UpCi0JCQkJfHwgKHByaWRfbG9uZyA+IChwcmlkX3QpLTEpKQorCQlpZiAoZXJybm8g
fHwgKHByaWRfbG9uZyA+IChwcmlkX3QpLTEpKQogCQkJcmV0dXJuIC0xOwogCQlyZXR1cm4gKHBy
aWRfdClwcmlkX2xvbmc7CiAJfQpAQCAtMzY1LDEwICszNjcsMTAgQEAgdWlkX2Zyb21fc3RyaW5n
KAogCXVuc2lnbmVkIGxvbmcJdWlkX2xvbmc7CiAJY2hhcgkJKnNwOwogCisJZXJybm8gPSAwOwog
CXVpZF9sb25nID0gc3RydG91bCh1c2VyLCAmc3AsIDEwKTsKIAlpZiAoc3AgIT0gdXNlcikgewot
CQlpZiAoKHVpZF9sb25nID09IFVMT05HX01BWCAmJiBlcnJubyA9PSBFUkFOR0UpCi0JCQkJfHwg
KHVpZF9sb25nID4gKHVpZF90KS0xKSkKKwkJaWYgKGVycm5vIHx8ICh1aWRfbG9uZyA+ICh1aWRf
dCktMSkpCiAJCQlyZXR1cm4gLTE7CiAJCXJldHVybiAodWlkX3QpdWlkX2xvbmc7CiAJfQpAQCAt
Mzg2LDEwICszODgsMTAgQEAgZ2lkX2Zyb21fc3RyaW5nKAogCXVuc2lnbmVkIGxvbmcJZ2lkX2xv
bmc7CiAJY2hhcgkJKnNwOwogCisJZXJybm8gPSAwOwogCWdpZF9sb25nID0gc3RydG91bChncm91
cCwgJnNwLCAxMCk7CiAJaWYgKHNwICE9IGdyb3VwKSB7Ci0JCWlmICgoZ2lkX2xvbmcgPT0gVUxP
TkdfTUFYICYmIGVycm5vID09IEVSQU5HRSkKLQkJCQl8fCAoZ2lkX2xvbmcgPiAoZ2lkX3QpLTEp
KQorCQlpZiAoZXJybm8gfHwgKGdpZF9sb25nID4gKGdpZF90KS0xKSkKIAkJCXJldHVybiAtMTsK
IAkJcmV0dXJuIChnaWRfdClnaWRfbG9uZzsKIAl9Ci0tIAoyLjAuMQoKX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX18KeGZzIG1haWxpbmcgbGlzdAp4ZnNAb3Nz
LnNnaS5jb20KaHR0cDovL29zcy5zZ2kuY29tL21haWxtYW4vbGlzdGluZm8veGZzCg==
