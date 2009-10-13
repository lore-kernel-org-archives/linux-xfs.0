Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n9DJPAH8144817 for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 14:25:11 -0500
Received: from realbig.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 52962C2539B
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2009 12:26:39 -0700 (PDT)
Received: from realbig.com (realbig.com [207.36.196.230]) by cuda.sgi.com with
	ESMTP id zq7oYqI9B6DtZ8nR for <xfs@oss.sgi.com>;
	Tue, 13 Oct 2009 12:26:39 -0700 (PDT)
Date: Tue, 13 Oct 2009 14:26:23 -0500 (CDT)
From: Andy Poling <andy@realbig.com>
Subject: Wrapped journal record corruption on read at recovery - patch attached
	(was Re: XFS corruption with failover)
In-Reply-To: <mailman.0.1255458988.141519.xfs@oss.sgi.com>
Message-ID: <alpine.DEB.2.00.0910131342440.11546@andydesk>
References: <mailman.0.1255458988.141519.xfs@oss.sgi.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1068810406-1255461942=:11546"
Content-ID: <alpine.DEB.2.00.0910131425540.11546@andydesk>
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
To: xfs@oss.sgi.com
Cc: John Quigley <jquigley@cleversafe.com>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1068810406-1255461942=:11546
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Content-ID: <alpine.DEB.2.00.0910131425541.11546@andydesk>

At his request, I followed up on John Quigley's problem, and I believe I found
a bug in xlog_do_recovery_pass() in handling of a wrapped journal record.  A
patch against 2.6.28.10 is attached.  It looks like the patch will apply
cleanly against any recent version.

Summary of problem:

If a journal record wraps at the physical end of the journal, it has to be
read in two parts in xlog_do_recovery_pass(): a read at the physical end and a
read at the physical beginning.  If xlog_bread() has to re-align the first
read, the second read request does not take that re-alignment into account.
If the first read was re-aligned, the second read over-writes the end of the
data from the first read, effectively corrupting it.  This can happen either
when reading the record header or reading the record data.

The first sanity check in xlog_recover_process_data() is to check for a valid
clientid, so that is the error reported.


Summary of fix:

If there was a first read at the physical end, XFS_BUF_PTR() returns where the
data was requested to begin.  Conversely, because it is the result of
xlog_align(), offset indicates where the requested data for the first read
actually begins - whether or not xlog_bread() has re-aligned it.

Using offset as the base for the calculation of where to place the second read
data ensures that it will be correctly placed immediately following the data
from the first read instead of sometimes over-writing the end of it.

The attached patch has resolved the reported problem of occasional inability
to recover the journal (reporting "bad clientid").

-Andy

It ain't what you don't know that gets you into trouble.
It's what you know for sure that just ain't so. - Mark Twain
--8323328-1068810406-1255461942=:11546
Content-Type: IMAGE/X-CORELDRAWPATTERN; name=xfs_log_recover.pat
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.DEB.2.00.0910131425420.11546@andydesk>
Content-Description: xfs_log_recover.pat
Content-Disposition: attachment; filename=xfs_log_recover.pat

LS0tIGZzL3hmcy94ZnNfbG9nX3JlY292ZXIuYy5vcmlnCTIwMDktMTAtMTMg
MDE6NTc6MzMuMDAwMDAwMDAwIC0wNTAwCisrKyBmcy94ZnMveGZzX2xvZ19y
ZWNvdmVyLmMJMjAwOS0xMC0xMyAwMTo1Njo1MS4wMDAwMDAwMDAgLTA1MDAK
QEAgLTM2MzgsNyArMzYzOCwxMCBAQAogCQkJCSAqICAgLSBvcmRlciBpcyBp
bXBvcnRhbnQuCiAJCQkJICovCiAJCQkJd3JhcHBlZF9oYmxrcyA9IGhibGtz
IC0gc3BsaXRfaGJsa3M7Ci0JCQkJYnVmYWRkciA9IFhGU19CVUZfUFRSKGhi
cCk7CisJCQkJaWYgKG9mZnNldCkKKwkJCQkJYnVmYWRkciA9IG9mZnNldDsK
KwkJCQllbHNlCisJCQkJCWJ1ZmFkZHIgPSBYRlNfQlVGX1BUUihoYnApOwog
CQkJCWVycm9yID0gWEZTX0JVRl9TRVRfUFRSKGhicCwKIAkJCQkJCWJ1ZmFk
ZHIgKyBCQlRPQihzcGxpdF9oYmxrcyksCiAJCQkJCQlCQlRPQihoYmxrcyAt
IHNwbGl0X2hibGtzKSk7CkBAIC0zNzAwLDcgKzM3MDMsMTAgQEAKIAkJCQkg
KiAgIF9maXJzdF8sIHRoZW4gdGhlIGxvZyBzdGFydCAoTFIgaGVhZGVyIGVu
ZCkKIAkJCQkgKiAgIC0gb3JkZXIgaXMgaW1wb3J0YW50LgogCQkJCSAqLwot
CQkJCWJ1ZmFkZHIgPSBYRlNfQlVGX1BUUihkYnApOworCQkJCWlmIChvZmZz
ZXQpCisJCQkJCWJ1ZmFkZHIgPSBvZmZzZXQ7CisJCQkJZWxzZQorCQkJCQli
dWZhZGRyID0gWEZTX0JVRl9QVFIoZGJwKTsKIAkJCQllcnJvciA9IFhGU19C
VUZfU0VUX1BUUihkYnAsCiAJCQkJCQlidWZhZGRyICsgQkJUT0Ioc3BsaXRf
YmJsa3MpLAogCQkJCQkJQkJUT0IoYmJsa3MgLSBzcGxpdF9iYmxrcykpOwo=

--8323328-1068810406-1255461942=:11546
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--8323328-1068810406-1255461942=:11546--
