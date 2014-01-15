Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BBCA57F3F
	for <xfs@oss.sgi.com>; Tue, 14 Jan 2014 23:31:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9E116304075
	for <xfs@oss.sgi.com>; Tue, 14 Jan 2014 21:31:07 -0800 (PST)
Received: from mail.uberzach.com (rondo.uberzach.com [64.22.125.169]) by
	cuda.sgi.com with ESMTP id hKrE4JzA5fHuouFe (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Jan 2014 21:31:03 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair
From: Zachary Kotlarek <zach@kotlarek.com>
In-Reply-To: <20140115034803.GT3469@dastard>
Date: Tue, 14 Jan 2014 21:30:57 -0800
Message-Id: <1E5E569C-2E11-42A1-A771-89D4800BC412@kotlarek.com>
References: <20140113015007.GC3469@dastard>
	<EDB09149-717F-4089-9C21-1D342CF77A7D@kotlarek.com>
	<20140113031947.GG3469@dastard>
	<E2EE0AEA-ED22-4D3B-8550-88F2ED1F8314@kotlarek.com>
	<20140113192732.GI3469@dastard>
	<0E45339E-04C4-4775-B6B0-FC55245B0AED@kotlarek.com>
	<20140114022414.GM3469@dastard>
	<BE0C947E-37DE-4CA1-B120-59B95E1E8EB8@kotlarek.com>
	<20140115015350.GR3469@dastard>
	<61E74CEF-8244-4E90-BA7D-91D54DADC3C1@kotlarek.com>
	<20140115034803.GT3469@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4913725018378434799=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com


--===============4913725018378434799==
Content-Type: multipart/signed; boundary="Apple-Mail=_CE92C729-5C51-4C37-88A1-CBF0F67E5A04"; protocol="application/pkcs7-signature"; micalg=sha1


--Apple-Mail=_CE92C729-5C51-4C37-88A1-CBF0F67E5A04
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


On Jan 14, 2014, at 7:48 PM, Dave Chinner <david@fromorbit.com> wrote:

> It's called *ASCII* Case Insensitivity for a reason: it doesn't
> support anything other than ASCII. So your usage is not actually
> supported at all, hence it's no surprise that it has caused
> breakage.


Okay. Thanks for the explanation.

FWIW, I read =93ASCII-only case-insensitive=94 to mean =93only =
case-insensitive for ASCII=94 as in =F1 and =D1 would not match each =
other. If it actually means =93anything other than ASCII is subject to =
complete breakage=94 a more nuanced explanation in the man page might be =
desirable.

I don=92t suppose there=92s any way to disable that setting short of =
creating a new file system?


> I suspect that the way to fix your filesystem is to run xfs_repair
> under a "C" locale so that the glibc tolower() function behaves the
> same way the kernel behaves and so the hashes calculated by
> xfs_repair match the what the kernel thinks is correct.

Neither this:
	LC_ALL=3DC
nor this:
	LC_ALL=3DPOSIX
or for that matter:
	LC_ALL=3Den_US.utf8
made any difference. And my default was already POSIX.

Any other thoughts?

Theoretically I could find the expected hashvals and overwrite them with =
xfs_db, right? Or at least unlink the files so I can reclaim the disk =
space?

	Zach


--Apple-Mail=_CE92C729-5C51-4C37-88A1-CBF0F67E5A04
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGGTCCBhUw
ggP9oAMCAQICAQEwDQYJKoZIhvcNAQEFBQAwgYsxCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApXYXNo
aW5ndG9uMRAwDgYDVQQHDAdTZWF0dGxlMRwwGgYDVQQKDBNaYWNoYXJ5IFAuIEtvdGxhcmVrMRUw
EwYDVQQDDAx1YmVyemFjaC5jb20xIDAeBgkqhkiG9w0BCQEWEXphY2hAa290bGFyZWsuY29tMB4X
DTEzMDgxMzAwMjMzM1oXDTE4MDgxMjAwMjMzM1owgZIxCzAJBgNVBAYTAlVTMRMwEQYDVQQIDApX
YXNoaW5ndG9uMRAwDgYDVQQHDAdTZWF0dGxlMRwwGgYDVQQKDBNaYWNoYXJ5IFAuIEtvdGxhcmVr
MRwwGgYDVQQDDBNaYWNoYXJ5IFAuIEtvdGxhcmVrMSAwHgYJKoZIhvcNAQkBFhF6YWNoQGtvdGxh
cmVrLmNvbTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBANL424NB+EzPp7/CqB/kxV+u
7MSpl9A8NlMqLldoPPJjpEwH9+4wfYrx+yUOBddih4WIgCD9NiF41+9tHu9gUqm+PZT8kdGXUIRP
fuQuwKyzAv0rSyydXBQD/Q/gRrFaEJvJ5wVUxgE51K/ugGATmyWTSeMwATOJR4qTs1u2dfxBliyR
xc2LCJCAgvuonwhfP1JprFYz+ycmlb/od3cAC5+8ggof5YJiitsUM6FPQtDykGPNWxhFnBwrVlQ+
vAxA1aT2v33C4MMK3hY3Ik8BUCZrAr4r/eWDSCBmcQydoawrUllAzEsVuozYqOW+EwbFp9RFDAZZ
UZH/pMSEK5v2yQcf2m3zx4+9S5fLbvX660DFY90C1GSt9MyDjfpgx+Mtx7RtJI2abcei2PEXt38p
U2aLypsHWsdloWhouzM4JpTkDXqCyUOm5hkUPgMdOXKHY5jCj0e7ok/Rknty7fJjolo4uyOKfJHQ
cjoU1xuzA8ob0i8zufIL03FUK72dWL7xyAGjRs4Hsa6xd/SbPYGvYHJ2afxLeTDPZwzrLErxn9no
E0wkAPnV0MfYbB+0Y/+Xaa2KIUflawzh3iQVkohrzmE9PU3gjiQJ9UqYtvx8HrUK2eEjCRinnSd5
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
gwmvsLnXjgAAAAAAAA==

--Apple-Mail=_CE92C729-5C51-4C37-88A1-CBF0F67E5A04--


--===============4913725018378434799==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4913725018378434799==--
