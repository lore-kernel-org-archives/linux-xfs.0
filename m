Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q92Morsu100714 for <xfs@oss.sgi.com>; Tue, 2 Oct 2012 17:50:53 -0500
Received: from Ishtar.sc.tlinx.org (ishtar.tlinx.org [173.164.175.65]) by
	cuda.sgi.com with ESMTP id bhHVxt76tBUh81Fp (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Oct 2012 15:52:13 -0700 (PDT)
Message-ID: <506B7018.7040000@tlinx.org>
Date: Tue, 02 Oct 2012 15:52:08 -0700
From: Linda Walsh <xfs@tlinx.org>
MIME-Version: 1.0
Subject: Re: Why xfs_<utils> not 'readline' w/line-edit & history enabled?
	(+attachment)
References: <506B1A03.7030600@tlinx.org> <20121002201748.GQ23520@dastard>
	<506B5DE1.4020000@tlinx.org> <20121002215253.GT23520@dastard>
In-Reply-To: <20121002215253.GT23520@dastard>
Content-Type: multipart/mixed; boundary="------------090200020400080301040904"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs-oss <xfs@oss.sgi.com>

This is a multi-part message in MIME format.
--------------090200020400080301040904
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dave Chinner wrote:
> Patches welcome.
> 
> Cheers,
> 
> Dave.
---
Gee, that's a hard one... (build and tested that it was included)...

--------------090200020400080301040904
Content-Type: text/plain;
 name="config.diff"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="config.diff"

LS0tIGNvbmZpZ3VyZS5pbgkyMDExLTA4LTA0IDA3OjA0OjQ0LjAwMDAwMDAwMCAtMDcwMAor
KysgY29uZmlndXJlLmluCTIwMTItMTAtMDIgMTU6Mjg6MjMuMzQyMDkwMDM4IC0wNzAwCkBA
IC0xOCwyMSArMTgsMjEgQEAKIEFDX1NVQlNUKGVuYWJsZV9nZXR0ZXh0KQogCiBBQ19BUkdf
RU5BQkxFKHJlYWRsaW5lLAotWyAtLWVuYWJsZS1yZWFkbGluZT1beWVzL25vXSBFbmFibGUg
cmVhZGxpbmUgY29tbWFuZCBlZGl0aW5nIFtkZWZhdWx0PW5vXV0sCitbIC0tZW5hYmxlLXJl
YWRsaW5lPVt5ZXMvbm9dIEVuYWJsZSByZWFkbGluZSBjb21tYW5kIGVkaXRpbmcgW2RlZmF1
bHQ9eWVzXV0sCiAJdGVzdCAkZW5hYmxlX3JlYWRsaW5lID0geWVzICYmIGxpYnJlYWRsaW5l
PSItbHJlYWRsaW5lIiwKIAllbmFibGVfcmVhZGxpbmU9bm8pCiBBQ19TVUJTVChsaWJyZWFk
bGluZSkKIEFDX1NVQlNUKGVuYWJsZV9yZWFkbGluZSkKIAogQUNfQVJHX0VOQUJMRShlZGl0
bGluZSwKLVsgLS1lbmFibGUtZWRpdGxpbmU9W3llcy9ub10gRW5hYmxlIGVkaXRsaW5lIGNv
bW1hbmQgZWRpdGluZyBbZGVmYXVsdD1ub11dLAorWyAtLWVuYWJsZS1lZGl0bGluZT1beWVz
L25vXSBFbmFibGUgZWRpdGxpbmUgY29tbWFuZCBlZGl0aW5nIFtkZWZhdWx0PXllc11dLAog
CXRlc3QgJGVuYWJsZV9lZGl0bGluZSA9IHllcyAmJiBsaWJlZGl0bGluZT0iLWxlZGl0IiwK
IAllbmFibGVfZWRpdGxpbmU9bm8pCiBBQ19TVUJTVChsaWJlZGl0bGluZSkKIEFDX1NVQlNU
KGVuYWJsZV9lZGl0bGluZSkKIAogQUNfQVJHX0VOQUJMRSh0ZXJtY2FwLAotWyAtLWVuYWJs
ZS10ZXJtY2FwPVt5ZXMvbm9dIEVuYWJsZSB0ZXJtaW5hbCBjYXBhYmlsaXRpZXMgbGlicmFy
eSBbZGVmYXVsdD1ub11dLAorWyAtLWVuYWJsZS10ZXJtY2FwPVt5ZXMvbm9dIEVuYWJsZSB0
ZXJtaW5hbCBjYXBhYmlsaXRpZXMgbGlicmFyeSBbZGVmYXVsdD15ZXNdXSwKIAl0ZXN0ICRl
bmFibGVfdGVybWNhcCA9IHllcyAmJiBsaWJ0ZXJtY2FwPSItbHRlcm1jYXAiLCkKIEFDX1NV
QlNUKGxpYnRlcm1jYXApCiAKCi0tLSBjb25maWd1cmUJMjAxMS0wOS0yNyAwODozNjoxMC4w
MDAwMDAwMDAgLTA3MDAKKysrIGNvbmZpZ3VyZQkyMDEyLTEwLTAyIDE1OjQ1OjA3LjkxMTgw
NzAyOCAtMDcwMApAQCAtMTUzMiw5ICsxNTMyLDkgQEAKICAgLS1kaXNhYmxlLWxpYnRvb2wt
bG9jayAgYXZvaWQgbG9ja2luZyAobWlnaHQgYnJlYWsgcGFyYWxsZWwgYnVpbGRzKQogIC0t
ZW5hYmxlLXNoYXJlZD15ZXMvbm8gRW5hYmxlIHVzZSBvZiBzaGFyZWQgbGlicmFyaWVzIGRl
ZmF1bHQ9eWVzCiAgLS1lbmFibGUtZ2V0dGV4dD15ZXMvbm8gRW5hYmxlIGFsdGVybmF0ZSBs
YW5ndWFnZSBzdXBwb3J0IGRlZmF1bHQ9eWVzCi0gLS1lbmFibGUtcmVhZGxpbmU9eWVzL25v
IEVuYWJsZSByZWFkbGluZSBjb21tYW5kIGVkaXRpbmcgZGVmYXVsdD1ubwotIC0tZW5hYmxl
LWVkaXRsaW5lPXllcy9ubyBFbmFibGUgZWRpdGxpbmUgY29tbWFuZCBlZGl0aW5nIGRlZmF1
bHQ9bm8KLSAtLWVuYWJsZS10ZXJtY2FwPXllcy9ubyBFbmFibGUgdGVybWluYWwgY2FwYWJp
bGl0aWVzIGxpYnJhcnkgZGVmYXVsdD1ubworIC0tZW5hYmxlLXJlYWRsaW5lPXllcy9ubyBF
bmFibGUgcmVhZGxpbmUgY29tbWFuZCBlZGl0aW5nIGRlZmF1bHQ9eWVzCisgLS1lbmFibGUt
ZWRpdGxpbmU9eWVzL25vIEVuYWJsZSBlZGl0bGluZSBjb21tYW5kIGVkaXRpbmcgZGVmYXVs
dD15ZXMKKyAtLWVuYWJsZS10ZXJtY2FwPXllcy9ubyBFbmFibGUgdGVybWluYWwgY2FwYWJp
bGl0aWVzIGxpYnJhcnkgZGVmYXVsdD15ZXMKICAtLWVuYWJsZS1ibGtpZD15ZXMvbm8gRW5h
YmxlIGJsb2NrIGRldmljZSBpZCBsaWJyYXJ5IGRlZmF1bHQ9eWVzCiAgLS1lbmFibGUtbGli
NjQ9eWVzL25vIEVuYWJsZSBsaWI2NCBzdXBwb3J0IGRlZmF1bHQ9eWVzCiAKQEAgLTk5NzEs
NyArOTk3MSw4IEBACiBpZiB0ZXN0ICIke2VuYWJsZV9yZWFkbGluZStzZXR9IiA9IHNldDsg
dGhlbiA6CiAgIGVuYWJsZXZhbD0kZW5hYmxlX3JlYWRsaW5lOyB0ZXN0ICRlbmFibGVfcmVh
ZGxpbmUgPSB5ZXMgJiYgbGlicmVhZGxpbmU9Ii1scmVhZGxpbmUiCiBlbHNlCi0gIGVuYWJs
ZV9yZWFkbGluZT1ubworICBlbmFibGVfcmVhZGxpbmU9eWVzCisJbGlicmVhZGxpbmU9Ii1s
cmVhZGxpbmUiCiBmaQogCiAKQEAgLTk5ODEsNyArOTk4Miw4IEBACiBpZiB0ZXN0ICIke2Vu
YWJsZV9lZGl0bGluZStzZXR9IiA9IHNldDsgdGhlbiA6CiAgIGVuYWJsZXZhbD0kZW5hYmxl
X2VkaXRsaW5lOyB0ZXN0ICRlbmFibGVfZWRpdGxpbmUgPSB5ZXMgJiYgbGliZWRpdGxpbmU9
Ii1sZWRpdCIKIGVsc2UKLSAgZW5hYmxlX2VkaXRsaW5lPW5vCisgIGVuYWJsZV9lZGl0bGlu
ZT15ZXMKKwlsaWJlZGl0bGluZT0iLWxlZGl0IgogZmkKIAogCkBAIC05OTkwLDYgKzk5OTIs
OSBAQAogIyBDaGVjayB3aGV0aGVyIC0tZW5hYmxlLXRlcm1jYXAgd2FzIGdpdmVuLgogaWYg
dGVzdCAiJHtlbmFibGVfdGVybWNhcCtzZXR9IiA9IHNldDsgdGhlbiA6CiAgIGVuYWJsZXZh
bD0kZW5hYmxlX3Rlcm1jYXA7IHRlc3QgJGVuYWJsZV90ZXJtY2FwID0geWVzICYmIGxpYnRl
cm1jYXA9Ii1sdGVybWNhcCIKK2Vsc2UgCisJZW5hYmxlX3Rlcm1jYXA9eWVzCisJbGlidGVy
bWNhcD0iLWx0ZXJtY2FwIgogZmkKIAogCg==
--------------090200020400080301040904
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------090200020400080301040904--
