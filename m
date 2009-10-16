Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9G0Z5mV048291 for <xfs@oss.sgi.com>; Thu, 15 Oct 2009 19:35:05 -0500
Received: from realbig.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 160721B9FC5F
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2009 17:36:35 -0700 (PDT)
Received: from realbig.com (realbig.com [207.36.196.230]) by cuda.sgi.com with
	ESMTP id 8K8GuYdPc8samywG for <xfs@oss.sgi.com>;
	Thu, 15 Oct 2009 17:36:35 -0700 (PDT)
Date: Thu, 15 Oct 2009 19:36:33 -0500 (CDT)
From: Andy Poling <andy@realbig.com>
Subject: Re: Wrapped journal record corruption on read at recovery - patch
	attached (was Re: XFS corruption with failover)
In-Reply-To: <alpine.DEB.2.00.0910141053150.5504@andydesk>
Message-ID: <alpine.DEB.2.00.0910151858340.5504@andydesk>
References: <mailman.0.1255458988.141519.xfs@oss.sgi.com>
	<alpine.DEB.2.00.0910131342440.11546@andydesk>
	<20091013233324.GA28942@infradead.org>
	<alpine.DEB.2.00.0910131853200.11546@andydesk>
	<20091014132030.GB15001@infradead.org>
	<alpine.DEB.2.00.0910141053150.5504@andydesk>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-207263922-1255653394=:5504"
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
To: Christoph Hellwig <hch@infradead.org>
Cc: John Quigley <jquigley@cleversafe.com>, xfs@oss.sgi.com

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-207263922-1255653394=:5504
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

On Wed, 14 Oct 2009, Christoph Hellwig wrote:
>> It seems like the more elegant approach would be to set offset before the
>> first read, and then update it if the first read takes place (in case it 
>> was
>> unaligned).  That also gets rid of bufaddr, and seems like it might read
>> better.
> 
> Yeah.  Note that in Linux 2.6.29 I did some changes in that are to
> take the read and offset calculation into a common helper

Looking at the improved code since 2.6.29, and assuming that the beginning of
the log will always be aligned, I have come up with the attached patch against
2.6.31.4.  I think it's cleaner, and it passes my tests.

The bufaddr variable is no longer needed.  I removed the xlog_align() after
the second read for both headers and data since the second read will always be
aligned (even if there was no first read) since it is always at the beginning
of the log.

It sets offset to the beginning of the buffer with XFS_BUF_PTR() before the
first read, and then your improved xlog_bread() will update the offset if the
first read had to be re-aligned.

What do you think?

-Andy

It ain't what you don't know that gets you into trouble.
It's what you know for sure that just ain't so. - Mark Twain
--8323328-207263922-1255653394=:5504
Content-Type: IMAGE/x-coreldrawpattern; name=xfs_log_recover.pat
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.00.0910151936330.5504@andydesk>
Content-Description: xfs_log_recover.pat
Content-Disposition: attachment; filename=xfs_log_recover.pat

LS0tIGZzL3hmcy94ZnNfbG9nX3JlY292ZXIuYy5vcmlnCTIwMDktMTAtMTQg
MjM6Mzk6NDkuNzUzNDk0ODc2IC0wNTAwCisrKyBmcy94ZnMveGZzX2xvZ19y
ZWNvdmVyLmMJMjAwOS0xMC0xNSAxODoyNjoyMy43OTA4ODc3MDAgLTA1MDAK
QEAgLTM1MTcsNyArMzUxNyw3IEBACiB7CiAJeGxvZ19yZWNfaGVhZGVyX3QJ
KnJoZWFkOwogCXhmc19kYWRkcl90CQlibGtfbm87Ci0JeGZzX2NhZGRyX3QJ
CWJ1ZmFkZHIsIG9mZnNldDsKKwl4ZnNfY2FkZHJfdAkJb2Zmc2V0OwogCXhm
c19idWZfdAkJKmhicCwgKmRicDsKIAlpbnQJCQllcnJvciA9IDAsIGhfc2l6
ZTsKIAlpbnQJCQliYmxrcywgc3BsaXRfYmJsa3M7CkBAIC0zNjEwLDcgKzM2
MTAsNyBAQAogCQkJLyoKIAkJCSAqIENoZWNrIGZvciBoZWFkZXIgd3JhcHBp
bmcgYXJvdW5kIHBoeXNpY2FsIGVuZC1vZi1sb2cKIAkJCSAqLwotCQkJb2Zm
c2V0ID0gTlVMTDsKKwkJCW9mZnNldCA9IFhGU19CVUZfUFRSKGhicCk7CiAJ
CQlzcGxpdF9oYmxrcyA9IDA7CiAJCQl3cmFwcGVkX2hibGtzID0gMDsKIAkJ
CWlmIChibGtfbm8gKyBoYmxrcyA8PSBsb2ctPmxfbG9nQkJzaXplKSB7CkBA
IC0zNjQ2LDkgKzM2NDYsOCBAQAogCQkJCSAqICAgLSBvcmRlciBpcyBpbXBv
cnRhbnQuCiAJCQkJICovCiAJCQkJd3JhcHBlZF9oYmxrcyA9IGhibGtzIC0g
c3BsaXRfaGJsa3M7Ci0JCQkJYnVmYWRkciA9IFhGU19CVUZfUFRSKGhicCk7
CiAJCQkJZXJyb3IgPSBYRlNfQlVGX1NFVF9QVFIoaGJwLAotCQkJCQkJYnVm
YWRkciArIEJCVE9CKHNwbGl0X2hibGtzKSwKKwkJCQkJCW9mZnNldCArIEJC
VE9CKHNwbGl0X2hibGtzKSwKIAkJCQkJCUJCVE9CKGhibGtzIC0gc3BsaXRf
aGJsa3MpKTsKIAkJCQlpZiAoZXJyb3IpCiAJCQkJCWdvdG8gYnJlYWRfZXJy
MjsKQEAgLTM2NTgsMTQgKzM2NTcsMTAgQEAKIAkJCQlpZiAoZXJyb3IpCiAJ
CQkJCWdvdG8gYnJlYWRfZXJyMjsKIAotCQkJCWVycm9yID0gWEZTX0JVRl9T
RVRfUFRSKGhicCwgYnVmYWRkciwKKwkJCQllcnJvciA9IFhGU19CVUZfU0VU
X1BUUihoYnAsIG9mZnNldCwKIAkJCQkJCQlCQlRPQihoYmxrcykpOwogCQkJ
CWlmIChlcnJvcikKIAkJCQkJZ290byBicmVhZF9lcnIyOwotCi0JCQkJaWYg
KCFvZmZzZXQpCi0JCQkJCW9mZnNldCA9IHhsb2dfYWxpZ24obG9nLCAwLAot
CQkJCQkJCXdyYXBwZWRfaGJsa3MsIGhicCk7CiAJCQl9CiAJCQlyaGVhZCA9
ICh4bG9nX3JlY19oZWFkZXJfdCAqKW9mZnNldDsKIAkJCWVycm9yID0geGxv
Z192YWxpZF9yZWNfaGVhZGVyKGxvZywgcmhlYWQsCkBAIC0zNjg1LDcgKzM2
ODAsNyBAQAogCQkJfSBlbHNlIHsKIAkJCQkvKiBUaGlzIGxvZyByZWNvcmQg
aXMgc3BsaXQgYWNyb3NzIHRoZQogCQkJCSAqIHBoeXNpY2FsIGVuZCBvZiBs
b2cgKi8KLQkJCQlvZmZzZXQgPSBOVUxMOworCQkJCW9mZnNldCA9IFhGU19C
VUZfUFRSKGRicCk7CiAJCQkJc3BsaXRfYmJsa3MgPSAwOwogCQkJCWlmIChi
bGtfbm8gIT0gbG9nLT5sX2xvZ0JCc2l6ZSkgewogCQkJCQkvKiBzb21lIGRh
dGEgaXMgYmVmb3JlIHRoZSBwaHlzaWNhbApAQCAtMzcxNCw5ICszNzA5LDgg
QEAKIAkJCQkgKiAgIF9maXJzdF8sIHRoZW4gdGhlIGxvZyBzdGFydCAoTFIg
aGVhZGVyIGVuZCkKIAkJCQkgKiAgIC0gb3JkZXIgaXMgaW1wb3J0YW50Lgog
CQkJCSAqLwotCQkJCWJ1ZmFkZHIgPSBYRlNfQlVGX1BUUihkYnApOwogCQkJ
CWVycm9yID0gWEZTX0JVRl9TRVRfUFRSKGRicCwKLQkJCQkJCWJ1ZmFkZHIg
KyBCQlRPQihzcGxpdF9iYmxrcyksCisJCQkJCQlvZmZzZXQgKyBCQlRPQihz
cGxpdF9iYmxrcyksCiAJCQkJCQlCQlRPQihiYmxrcyAtIHNwbGl0X2JibGtz
KSk7CiAJCQkJaWYgKGVycm9yKQogCQkJCQlnb3RvIGJyZWFkX2VycjI7CkBA
IC0zNzI3LDEzICszNzIxLDkgQEAKIAkJCQlpZiAoZXJyb3IpCiAJCQkJCWdv
dG8gYnJlYWRfZXJyMjsKIAotCQkJCWVycm9yID0gWEZTX0JVRl9TRVRfUFRS
KGRicCwgYnVmYWRkciwgaF9zaXplKTsKKwkJCQllcnJvciA9IFhGU19CVUZf
U0VUX1BUUihkYnAsIG9mZnNldCwgaF9zaXplKTsKIAkJCQlpZiAoZXJyb3Ip
CiAJCQkJCWdvdG8gYnJlYWRfZXJyMjsKLQotCQkJCWlmICghb2Zmc2V0KQot
CQkJCQlvZmZzZXQgPSB4bG9nX2FsaWduKGxvZywgd3JhcHBlZF9oYmxrcywK
LQkJCQkJCWJibGtzIC0gc3BsaXRfYmJsa3MsIGRicCk7CiAJCQl9CiAJCQl4
bG9nX3VucGFja19kYXRhKHJoZWFkLCBvZmZzZXQsIGxvZyk7CiAJCQlpZiAo
KGVycm9yID0geGxvZ19yZWNvdmVyX3Byb2Nlc3NfZGF0YShsb2csIHJoYXNo
LAo=

--8323328-207263922-1255653394=:5504
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8323328-207263922-1255653394=:5504--
