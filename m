Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EBD537F3F
	for <xfs@oss.sgi.com>; Tue, 14 Jan 2014 19:59:32 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6D803AC006
	for <xfs@oss.sgi.com>; Tue, 14 Jan 2014 17:59:29 -0800 (PST)
Received: from mail.uberzach.com (rondo.uberzach.com [64.22.125.169]) by
	cuda.sgi.com with ESMTP id ZUCnMP5kJQBNyW8M (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 14 Jan 2014 17:59:28 -0800 (PST)
Received: from archer.uberzach.com (unknown
	[IPv6:2602:3f:e50d:7605:60c:ceff:fed3:ff7e])
	(Authenticated sender: profplump)
	by mail.uberzach.com (Postfix) with ESMTPSA id AB38B58013
	for <xfs@oss.sgi.com>; Tue, 14 Jan 2014 17:59:26 -0800 (PST)
From: Zachary Kotlarek <zach@kotlarek.com>
Message-Id: <61E74CEF-8244-4E90-BA7D-91D54DADC3C1@kotlarek.com>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: Files with non-ASCII names inaccessible after xfs_repair
Date: Tue, 14 Jan 2014 17:59:23 -0800
References: <52D2E358.6070106@hardwarefreak.com>
	<CF41F386-E86A-4745-B28D-0DAA8D3CA1DD@kotlarek.com>
	<20140113015007.GC3469@dastard>
	<EDB09149-717F-4089-9C21-1D342CF77A7D@kotlarek.com>
	<20140113031947.GG3469@dastard>
	<E2EE0AEA-ED22-4D3B-8550-88F2ED1F8314@kotlarek.com>
	<20140113192732.GI3469@dastard>
	<0E45339E-04C4-4775-B6B0-FC55245B0AED@kotlarek.com>
	<20140114022414.GM3469@dastard>
	<BE0C947E-37DE-4CA1-B120-59B95E1E8EB8@kotlarek.com>
	<20140115015350.GR3469@dastard>
In-Reply-To: <20140115015350.GR3469@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1996908179947872854=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============1996908179947872854==
Content-Type: multipart/signed; boundary="Apple-Mail=_23ED5300-B99D-4686-A019-0897B02DA1CE"; protocol="application/pkcs7-signature"; micalg=sha1


--Apple-Mail=_23ED5300-B99D-4686-A019-0897B02DA1CE
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252


On Jan 14, 2014, at 5:53 PM, Dave Chinner <david@fromorbit.com> wrote:

> Pretty simple - the leaf[].address is simply a compressed offset
> into the leaf. all dirents are 8 byte aligned, and the tag is the
> byte offset into the leaf dirent space. Hence:
>=20
> 	leaf[].address =3D bu[16].tag >> 3
> 			=3D 0x1d8 >> 3
> 			=3D 0x3b
> 			=3D bleaf[3].address
>=20
>> bleaf[3].hashval =3D 0x16d0707c
>> bleaf[3].address =3D 0x3b
>=20
> And there were are - there's a single bit discrepancy in the lower
> byte of the hash. That tends to imply we have a bug in xfs_repair.
>=20
> What version of xfs_repair did you use? (xfs_repair -V)


3.1.11.

I=92m happy to build from git if you suspect something has changed since =
then.

	Zach


--Apple-Mail=_23ED5300-B99D-4686-A019-0897B02DA1CE
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
QMkwEM6YpAAAAAAAAA==

--Apple-Mail=_23ED5300-B99D-4686-A019-0897B02DA1CE--


--===============1996908179947872854==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1996908179947872854==--
