Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D45647CA0
	for <xfs@oss.sgi.com>; Sat,  4 Jun 2016 20:19:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 4C621AC005
	for <xfs@oss.sgi.com>; Sat,  4 Jun 2016 18:19:45 -0700 (PDT)
Received: from shadbolt.e.decadent.org.uk (shadbolt.e.decadent.org.uk
	[88.96.1.126]) by cuda.sgi.com with ESMTP id k3by0pdl7VhyqhV3
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 04 Jun 2016 18:19:40 -0700 (PDT)
Message-ID: <1465089572.2847.180.camel@decadent.org.uk>
Subject: Re: XFS hole punch races
From: Ben Hutchings <ben@decadent.org.uk>
Date: Sun, 05 Jun 2016 02:19:32 +0100
In-Reply-To: <20160604232800.GW26977@dastard>
References: <20160322155740.GB28772@quack.suse.cz>
	<1465060270.2847.149.camel@decadent.org.uk>
	<20160604232800.GW26977@dastard>
Mime-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============7366282649965941311=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, stable@vger.kernel.org, xfs@oss.sgi.com


--===============7366282649965941311==
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-GGgF4nOcNdE0iJ56Ay5F"


--=-GGgF4nOcNdE0iJ56Ay5F
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2016-06-05 at 09:28 +1000, Dave Chinner wrote:
> On Sat, Jun 04, 2016 at 06:11:10PM +0100, Ben Hutchings wrote:
> > On Tue, 2016-03-22 at 16:57 +0100, Jan Kara wrote:
> >=20
> > Hi,
> >=20
> > similarly to ext4 also XFS had races between hole punching and page fau=
lts
> > which could result in data corruption. The fixes were merged in 4.1-rc1=
 but
> > it might make sense to backport them to older stable releases given the
> > nature of the issue.
> >=20
> > Relevant fixes are:
> >=20
> > de0e8c20ba3a65b0f15040aabbefdc1999876e6b
> > 075a924d45cc69c75a35f20b4912b85aa98b180a
> > e8e9ad42c1f1e1bfbe0e8c32c8cac02e9ebfb7ef
> > 0f9160b444e4de33b65dfcd3b901358a3129461a
> > 723cac48473358939759885a18e8df113ea96138
> > ec56b1f1fdc69599963574ce94cc5693d535dd64
> >=20
> >=20
> > You missed the first in that sequence:
> >=20
> > 653c60b633a9 xfs: introduce mmap/truncate lock
> >=20
> > For 3.16, I've queued up all=C2=A0those fixes with one further=C2=A0pre=
requisite:
> >=20
> > 812176832169 xfs: fix swapext ilock deadlock
> >=20
> > For 3.2, I've queued up all but 723cac484733, with these additional
> > prerequisites:
> >=20
> > f38996f57687 xfs: reduce ilock hold times in xfs_setattr_size
> > bc4010ecb8f4 xfs: use iolock on XFS_IOC_ALLOCSP calls
> > 76ca4c238cf5 xfs: always take the iolock around xfs_setattr_size
> > 5f8aca8b43f4 xfs: always hold the iolock when calling xfs_change_file_s=
pace
> > I realise I'll need to check for regressions with xfstests.
>=20
> Hi Ben,
>=20
> You do realise that this sort of backport effectively makes the
> stable kernels unsupportable by the upstream XFS developers? You're
> taking random changes from the upstream kernel until the kernel
> compiles, and then mostly hoping that it works.

I'm applying slightly more intelligence than that, but of course I'm
not an XFS developer.

> It's trivially easy to break truncate by screwing up the locking and
> IO barriers that it depends on, and this set of patches make quite a
> lot of different changes that have an unknown set of dependencies
> for correct behaviour. xfstests won't find all those problems; at
> best it will tell us that there won't be obvious problems.
>=20
> Stable kernels are supposed to be stable, and backports like this
> are riskier than the original changes in the upstream kernels. if a
> user is hitting a mmap/hole-punch race on an XFS filesytem (I can't
> remember any reports to the upstream list for any kernel) on a 3.2
> kernel, then correct answer is "upgrade to a newer upstream kernel",
> not "do a risky backport that exposes the entire user base to the
> potential of new data corruption bugs"....

OK, then I'll drop them for 3.2.

Ben.

--=20
Ben Hutchings
Everything should be made as simple as possible, but not simpler.
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0- Albert
Einstein

--=-GGgF4nOcNdE0iJ56Ay5F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJXU34kAAoJEOe/yOyVhhEJ9IYP/iaZuRDEahJ6CCIBHzbOwiYw
xb23RFpa0bk0uXLgIZaiRkMQ+LAAf/n8mLFcqGkZP6DhaaSh5qdzi8yguz5izd+F
gK/qmugvOUANA5gQ8IQaW0t4GfvkgdSBE/I7uXBbKB1Q9VHqaClm6xdzbCWN6RbE
QAOXWhl1Uf8M4hVWV57BxJTllycRX8buvm+cgJLPN1TzL5r6kHMIo6qs7PJVlKGH
lAHQ6mvgz9sTtF3c7z8wpF+jr74xNYSaU7XrPq5jGXm2HGLQboQkHnzYGzIMkxKY
GEbZ+VkDHhg4vaN9wYOyIGMz7F3MHhOuc7Ev+Ctni1Aa7HJxE5w5pZwNQ5mS/o3p
zacjRB7AsAqsLHlUJat1+ZmxCJywdsyNGD5zU7yLLvUl09yxrY49JyeoCNgzf1Hu
TRvadINWcmgNdFSSRvfECGqqLtcQW0e890sLC3/6D8rrU50uDBxyrHwoXpRkVsrQ
M0oDpwu5uq8NV7pxGY9LcJsXPRKZC41ePvEozO0/+0DiALLUvPFArt3nHlOD9U81
MMpNNN7NPDjeFUaBSG2vxhqjfBCcPj3UXq+oKNoVXgdjaWOr5meTqu84FDvyKvie
yCmBMk/xQd6hhfnDonVNroXMe2+iecwfeECS379OLpQi/hEZpq31WEcUjyhR60BO
qRCTxL5RJCYUaUw0o/NR
=yS2t
-----END PGP SIGNATURE-----

--=-GGgF4nOcNdE0iJ56Ay5F--


--===============7366282649965941311==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============7366282649965941311==--
