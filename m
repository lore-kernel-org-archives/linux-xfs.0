Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 02 Aug 2007 20:10:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7339Jbm016377
	for <xfs@oss.sgi.com>; Thu, 2 Aug 2007 20:09:21 -0700
Date: Fri, 03 Aug 2007 13:13:34 +1000
Subject: REVIEW:  fix xfs_repair phase 4 ag_stride with prefetch
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: multipart/mixed; boundary=----------gjkibzd07A5PDL7qz04KI3
MIME-Version: 1.0
Message-ID: <op.twgq8w1a3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

------------gjkibzd07A5PDL7qz04KI3
Content-Type: text/plain; format=flowed; delsp=yes; charset=iso-8859-15
Content-Transfer-Encoding: Quoted-Printable


AG stride testing was performed on a system with ample amounts
of memory, so prefetching with AG stride during Phase 4 was
missed. The attached patch fixes this.

32 AGs, ag_stride =3D 4:

Phase 3 - for each AG...
         - scan and clear agi unlinked lists...
         - process known inodes and perform inode discovery...
         - agno =3D 0
         - agno =3D 4
         - agno =3D 8
         - agno =3D 12
         - agno =3D 16
         - agno =3D 20
         - agno =3D 24
         - agno =3D 28

which is correct... but in Phase 4:

Phase 4 - check for duplicate blocks...
         - setting up duplicate extent list...
         - check for inodes claiming duplicate blocks...
         - agno =3D 0
         - agno =3D 1
         - agno =3D 2
         - agno =3D 5
         - agno =3D 6
         - agno =3D 4
         - agno =3D 7
         - agno =3D 3=

------------gjkibzd07A5PDL7qz04KI3
Content-Disposition: attachment; filename=fix_ag_stride
Content-Type: application/octet-stream; name=fix_ag_stride
Content-Transfer-Encoding: Base64

SW5kZXg6IHJlcGFpci94ZnNwcm9ncy9yZXBhaXIvcGhhc2U0LmMKPT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PQotLS0gcmVwYWlyLm9yaWcveGZzcHJvZ3MvcmVw
YWlyL3BoYXNlNC5jCTIwMDctMDctMjQgMTU6MzQ6MzkuMDAwMDAwMDAwICsx
MDAwCisrKyByZXBhaXIveGZzcHJvZ3MvcmVwYWlyL3BoYXNlNC5jCTIwMDct
MDgtMDMgMTI6MDQ6MzguMjAxMTc2MjgzICsxMDAwCkBAIC0xMzcsNiArMTM3
LDcgQEAKIAl4ZnNfbW91bnRfdAkJKm1wKQogewogCWludCAJCQlpLCBqOwor
CXhmc19hZ251bWJlcl90IAkJYWdubzsKIAl3b3JrX3F1ZXVlX3QJCSpxdWV1
ZXM7CiAJcHJlZmV0Y2hfYXJnc190CQkqcGZfYXJnc1syXTsKIApAQCAtMTUz
LDEyICsxNTQsMTMgQEAKIAkJCS8qCiAJCQkgKiBjcmVhdGUgb25lIHdvcmtl
ciB0aHJlYWQgZm9yIGVhY2ggc2VnbWVudCBvZiB0aGUgdm9sdW1lCiAJCQkg
Ki8KLQkJCWZvciAoaSA9IDA7IGkgPCB0aHJlYWRfY291bnQ7IGkrKykgewor
CQkJZm9yIChpID0gMCwgYWdubyA9IDA7IGkgPCB0aHJlYWRfY291bnQ7IGkr
KykgewogCQkJCWNyZWF0ZV93b3JrX3F1ZXVlKCZxdWV1ZXNbaV0sIG1wLCAx
KTsKIAkJCQlwZl9hcmdzWzBdID0gTlVMTDsKLQkJCQlmb3IgKGogPSBpOyBq
IDwgbXAtPm1fc2Iuc2JfYWdjb3VudDsgaiArPSBhZ19zdHJpZGUpIHsKLQkJ
CQkJcGZfYXJnc1swXSA9IHN0YXJ0X2lub2RlX3ByZWZldGNoKGosIDAsIHBm
X2FyZ3NbMF0pOwotCQkJCQlxdWV1ZV93b3JrKCZxdWV1ZXNbaV0sIHByb2Nl
c3NfYWdfZnVuYywgaiwgcGZfYXJnc1swXSk7CisJCQkJZm9yIChqID0gMDsg
aiA8IGFnX3N0cmlkZSAmJiBhZ25vIDwgbXAtPm1fc2Iuc2JfYWdjb3VudDsK
KwkJCQkJCWorKywgYWdubysrKSB7CisJCQkJCXBmX2FyZ3NbMF0gPSBzdGFy
dF9pbm9kZV9wcmVmZXRjaChhZ25vLCAwLCBwZl9hcmdzWzBdKTsKKwkJCQkJ
cXVldWVfd29yaygmcXVldWVzW2ldLCBwcm9jZXNzX2FnX2Z1bmMsIGFnbm8s
IHBmX2FyZ3NbMF0pOwogCQkJCX0KIAkJCX0KIAkJCS8qCg==

------------gjkibzd07A5PDL7qz04KI3--
