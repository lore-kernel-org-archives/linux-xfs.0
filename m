Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3T25m6N027669 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 21:05:49 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E41FD2FCA9E
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 19:07:53 -0700 (PDT)
Received: from mail.sandeen.net (64-131-60-146.usfamily.net [64.131.60.146])
	by cuda.sgi.com with ESMTP id MAIuj0yS8wWdXIOW for
	<xfs@oss.sgi.com>; Wed, 28 Apr 2010 19:07:53 -0700 (PDT)
Message-ID: <4BD8E9F8.4090701@sandeen.net>
Date: Wed, 28 Apr 2010 21:07:52 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: write both features2 fields when xfs_admin changes
	lazy_count
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
To: xfs-oss <xfs@oss.sgi.com>
Cc: =?UTF-8?B?TWFyY2luIE1pcm9zxYJhdw==?= <marcin@mejor.pl>

eGZzX2FkbWluIC1jIGludm9rZXMgcmVwYWlyIGRpcmVjdGx5IHRvIGNoYW5nZSBsYXp5X2NvdW50
LApidXQgaXQgZG9lc24ndCB3cml0ZSBib3RoIGZlYXR1cmVzMiBmaWVsZHMsIHNvIHRoaXM6Cgoj
IG1rZnMueGZzIC1kZmlsZSxuYW1lPWZzZmlsZSxzaXplPTEwZyAtbGxhenktY291bnQ9MAojIHhm
c19hZG1pbiAtYyAxIGZzZmlsZQojIHhmc19yZXBhaXIgZnNmaWxlCgp5aWVsZHMgZXJyb3JzLgoK
UmVwb3J0ZWQtYnk6IE1hcmNpbiBNaXJvc8WCYXcgPG1hcmNpbkBtZWpvci5wbD4KU2lnbmVkLW9m
Zi1ieTogRXJpYyBTYW5kZWVuIDxzYW5kZWVuQHNhbmRlZW4ubmV0PgotLS0KCmRpZmYgLS1naXQg
YS9yZXBhaXIvcGhhc2UxLmMgYi9yZXBhaXIvcGhhc2UxLmMKaW5kZXggNjE4Nzk2ZS4uZGJmYmM5
YiAxMDA2NDQKLS0tIGEvcmVwYWlyL3BoYXNlMS5jCisrKyBiL3JlcGFpci9waGFzZTEuYwpAQCAt
MTE3LDExICsxMTcsMTMgQEAgcGhhc2UxKHhmc19tb3VudF90ICptcCkKIAkJaWYgKGxhenlfY291
bnQgJiYgIXhmc19zYl92ZXJzaW9uX2hhc2xhenlzYmNvdW50KHNiKSkgewogCQkJc2ItPnNiX3Zl
cnNpb25udW0gfD0gWEZTX1NCX1ZFUlNJT05fTU9SRUJJVFNCSVQ7CiAJCQlzYi0+c2JfZmVhdHVy
ZXMyIHw9IFhGU19TQl9WRVJTSU9OMl9MQVpZU0JDT1VOVEJJVDsKKwkJCXNiLT5zYl9iYWRfZmVh
dHVyZXMyIHw9IFhGU19TQl9WRVJTSU9OMl9MQVpZU0JDT1VOVEJJVDsKIAkJCXByaW1hcnlfc2Jf
bW9kaWZpZWQgPSAxOwogCQkJcHJpbnRmKF8oIkVuYWJsaW5nIGxhenktY291bnRlcnNcbiIpKTsK
IAkJfSBlbHNlCiAJCWlmICghbGF6eV9jb3VudCAmJiB4ZnNfc2JfdmVyc2lvbl9oYXNsYXp5c2Jj
b3VudChzYikpIHsKIAkJCXNiLT5zYl9mZWF0dXJlczIgJj0gflhGU19TQl9WRVJTSU9OMl9MQVpZ
U0JDT1VOVEJJVDsKKwkJCXNiLT5zYl9iYWRfZmVhdHVyZXMyICY9IH5YRlNfU0JfVkVSU0lPTjJf
TEFaWVNCQ09VTlRCSVQ7CiAJCQlwcmludGYoXygiRGlzYWJsaW5nIGxhenktY291bnRlcnNcbiIp
KTsKIAkJCXByaW1hcnlfc2JfbW9kaWZpZWQgPSAxOwogCQl9IGVsc2UgewoKCl9fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fCnhmcyBtYWlsaW5nIGxpc3QKeGZz
QG9zcy5zZ2kuY29tCmh0dHA6Ly9vc3Muc2dpLmNvbS9tYWlsbWFuL2xpc3RpbmZvL3hmcwo=
