Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jul 2007 20:14:35 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6B3EUbm004601
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2007 20:14:32 -0700
Date: Wed, 11 Jul 2007 13:18:20 +1000
Subject: REVIEW: fix xfs_bmap -vp confusion
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------5g2s3VDJlM5DkZKD2Ny1cP
MIME-Version: 1.0
Message-ID: <op.tu954us03jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

------------5g2s3VDJlM5DkZKD2Ny1cP
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
Content-Transfer-Encoding: 7bit

If xfs_bmap -vp is run on a file without unwritten extents
and the filesystem does not use sunit/swidth, the FLAGS
column is not shown. This leads to some confusion.

So, when -vp option is used, it will always print the
FLAGS column.
------------5g2s3VDJlM5DkZKD2Ny1cP
Content-Disposition: attachment; filename=xfs_bmap_pflag.patch
Content-Type: application/octet-stream; name=xfs_bmap_pflag.patch
Content-Transfer-Encoding: Base64

LS0tIGEveGZzcHJvZ3MvaW8vYm1hcC5jCTIwMDctMDctMTEgMTM6MTE6NDIu
MDAwMDAwMDAwICsxMDAwCisrKyBiL3hmc3Byb2dzL2lvL2JtYXAuYwkyMDA3
LTA3LTExIDEyOjM0OjMzLjUxOTU3MjcwOSArMTAwMApAQCAtNzQsNiArNzQs
NyBAQCBibWFwX2YoCiAJaW50CQkJYWZsYWcgPSAwOwogCWludAkJCWxmbGFn
ID0gMDsKIAlpbnQJCQluZmxhZyA9IDA7CisJaW50CQkJcGZsYWcgPSAwOwog
CWludAkJCXZmbGFnID0gMDsKIAlpbnQJCQlpc19ydCA9IDA7CiAJaW50CQkJ
Ym12X2lmbGFncyA9IDA7CS8qIGZsYWdzIGZvciBYRlNfSU9DX0dFVEJNQVBY
ICovCkBAIC05OSw2ICsxMDAsNyBAQCBibWFwX2YoCiAJCQlicmVhazsKIAkJ
Y2FzZSAncCc6CiAJCS8qIHJlcG9ydCB1bndyaXR0ZW4gcHJlYWxsb2NhdGVk
IGJsb2NrcyAqLworCQkJcGZsYWcgPSAxOwogCQkJYm12X2lmbGFncyB8PSBC
TVZfSUZfUFJFQUxMT0M7CiAJCQlicmVhazsKIAkJY2FzZSAndic6CS8qIFZl
cmJvc2Ugb3V0cHV0ICovCkBAIC0yODksNyArMjkxLDcgQEAgYm1hcF9mKAog
CQkJc3VuaXQgPSAoZnNnZW8uc3VuaXQgKiBmc2dlby5ibG9ja3NpemUpIC8g
QkJTSVpFOwogCQkJc3dpZHRoID0gKGZzZ2VvLnN3aWR0aCAqIGZzZ2VvLmJs
b2Nrc2l6ZSkgLyBCQlNJWkU7CiAJCX0KLQkJZmxnID0gc3VuaXQ7CisJCWZs
ZyA9IHN1bml0IHwgcGZsYWc7CiAKIAkJLyoKIAkJICogR28gdGhyb3VnaCB0
aGUgZXh0ZW50cyBhbmQgZmlndXJlIG91dCB0aGUgd2lkdGgKQEAgLTM5Nywx
NCArMzk5LDE0IEBAIGJtYXBfZigKIAkJCQkJcHJpbnRmKCIgICIpOwogCQkJ
CXByaW50ZigiICUqbGxkIiwgdG90X3csCiAJCQkJCShsb25nIGxvbmcpbWFw
W2krMV0uYm12X2xlbmd0aCk7Ci0JCQkJaWYgKGZsZyA9PSBGTEdfTlVMTCkg
eworCQkJCWlmIChmbGcgPT0gRkxHX05VTEwgJiYgIXBmbGFnKSB7CiAJCQkJ
CXByaW50ZigiXG4iKTsKIAkJCQl9IGVsc2UgewogCQkJCQlwcmludGYoIiAl
LSouKm9cbiIsIE5GTEcsIE5GTEcsIGZsZyk7CiAJCQkJfQogCQkJfQogCQl9
Ci0JCWlmIChmbGcgJiYgdmZsYWcgPiAxKSB7CisJCWlmICgoZmxnIHx8IHBm
bGFnKSAmJiB2ZmxhZyA+IDEpIHsKIAkJCXByaW50ZihfKCIgRkxBRyBWYWx1
ZXM6XG4iKSk7CiAJCQlwcmludGYoXygiICAgICUqLipvIFVud3JpdHRlbiBw
cmVhbGxvY2F0ZWQgZXh0ZW50XG4iKSwKIAkJCQlORkxHKzEsIE5GTEcrMSwg
RkxHX1BSRSk7Cg==

------------5g2s3VDJlM5DkZKD2Ny1cP--
