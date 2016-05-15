Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 658D77CA6
	for <xfs@oss.sgi.com>; Sun, 15 May 2016 17:23:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B57ACAC001
	for <xfs@oss.sgi.com>; Sun, 15 May 2016 15:23:27 -0700 (PDT)
Received: from shadbolt.e.decadent.org.uk (shadbolt.e.decadent.org.uk
	[88.96.1.126]) by cuda.sgi.com with ESMTP id cBUhuPQHH785AnWx
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 15 May 2016 15:23:24 -0700 (PDT)
Message-ID: <1463350996.2631.55.camel@decadent.org.uk>
Subject: Re: XFS hole punch races
From: Ben Hutchings <ben@decadent.org.uk>
Date: Sun, 15 May 2016 23:23:16 +0100
In-Reply-To: <20160322155740.GB28772@quack.suse.cz>
References: <20160322155740.GB28772@quack.suse.cz>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============9056883578406812250=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jan Kara <jack@suse.cz>, stable@vger.kernel.org
Cc: xfs@oss.sgi.com


--===============9056883578406812250==
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-nWEbxTSjJh37pmBRtVXu"


--=-nWEbxTSjJh37pmBRtVXu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2016-03-22 at 16:57 +0100, Jan Kara wrote:
> Hi,
>=20
> similarly to ext4 also XFS had races between hole punching and page fault=
s
> which could result in data corruption. The fixes were merged in 4.1-rc1 b=
ut
> it might make sense to backport them to older stable releases given the
> nature of the issue.
>=20
> Relevant fixes are:
>=20
> de0e8c20ba3a65b0f15040aabbefdc1999876e6b
> 075a924d45cc69c75a35f20b4912b85aa98b180a
> e8e9ad42c1f1e1bfbe0e8c32c8cac02e9ebfb7ef
> 0f9160b444e4de33b65dfcd3b901358a3129461a
> 723cac48473358939759885a18e8df113ea96138
> ec56b1f1fdc69599963574ce94cc5693d535dd64

Thanks.  For 3.2 I needed to apply these first:

f38996f57687 xfs: reduce ilock hold times in xfs_setattr_size
bc4010ecb8f4 xfs: use iolock on XFS_IOC_ALLOCSP calls
76ca4c238cf5 xfs: always take the iolock around xfs_setattr_size
5f8aca8b43f4 xfs: always hold the iolock when calling xfs_change_file_space
653c60b633a9 xfs: introduce mmap/truncate lock

and I left out 723cac484733 "xfs: lock out page faults from extent swap
operations" as it doesn't seem applicable.

Ben.

--=20
Ben Hutchings
For every action, there is an equal and opposite criticism. - Harrison
--=-nWEbxTSjJh37pmBRtVXu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXOPbUAAoJEOe/yOyVhhEJ6fQP/ikdem6Rb6bywJopY5wYC5pc
Zu6Vy/6N2/RqQDdL64IfT0FdsQD8N4kUPu1Fw/ojmGBHHNVQxlb6qElOgWSySci+
NhXhQYHu6f9JI2Vr7gvYSbbDGhL0nSvGXt64PyVj/iAkydOGnHvAbdfCOLEKZMnz
dJakjHBB65kSc9S0e2rGJiyGoMkqIRXw+SKKAcLMZy9eHcbSK0mC0MnCcyKm0xnK
e0X2an452dDyNb5Favl9UoTxK09j0EU4qb0htRvl+W9IurnWrCSn0XsXmR2Pc6pH
SUsvzF4lCHaubaIVg7XlMgdpkRySHhMat277oREArxHLy67uCZkTLnekH6aaBBb2
GCrwtjDy0AXLMCnCZqpfJE45FWfh89TAdlA1PibwUEfqGP63+Fo3rr+W0YVE3BA1
x8ttZp1ngn5cylg8QTdNSFFTTcernWqQdtv0z5EQkAQhw4IWbVy1740vVSj/okIC
i/PWMPE0WnYAHXd9J606zYnOSKgZXBCyjpuUR1V1bnatA+AQvE/TeRrA2ebE82pa
+6bco451fR4/+3hLVio3x6eMBtDmgXOjTty5BPewXoAd1/7rCQJkQpNhx2aaTlh+
IvxE0BxEPfSZNDSIL10qisIk8GOLcEhp0UnyJuIE+Sx3p4UiI/JCj5wNRH3fduWP
T/NtP/zV6z8Gf6QvF58g
=CPig
-----END PGP SIGNATURE-----

--=-nWEbxTSjJh37pmBRtVXu--


--===============9056883578406812250==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============9056883578406812250==--
