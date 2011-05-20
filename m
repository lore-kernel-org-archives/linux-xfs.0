Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p4KBKXAF088263 for <xfs@oss.sgi.com>; Fri, 20 May 2011 06:20:33 -0500
Date: Fri, 20 May 2011 17:20:18 +0600
From: Andrey Rahmatullin <wrar@altlinux.org>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110520112018.GB3867@belkar.wrar.name>
References: <20110423224403.5fd1136a@neptune.home>
	<20110427050850.GG12436@dastard>
	<20110427182622.05a068a2@neptune.home>
	<20110428194528.GA1627@x4.trippels.de>
	<20110429011929.GA13542@dastard>
MIME-Version: 1.0
In-Reply-To: <20110429011929.GA13542@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============1901490380666981429=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: Dave Chinner <dchinner@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, xfs-masters@oss.sgi.com, Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>, Alex Elder <aelder@sgi.com>, Markus Trippelsdorf <markus@trippelsdorf.de>


--===============1901490380666981429==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Content-Disposition: inline


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 29, 2011 at 11:19:29AM +1000, Dave Chinner wrote:
> > x4 ~ # xfs_info /
> > meta-data=3D/dev/root              isize=3D256    agcount=3D4, agsize=
=3D1949824 blks
> >          =3D                       sectsz=3D512   attr=3D2
> > data     =3D                       bsize=3D4096   blocks=3D7799296, ima=
xpct=3D25
> >          =3D                       sunit=3D128    swidth=3D128 blks
> > naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0
> > log      =3Dinternal               bsize=3D4096   blocks=3D3808, versio=
n=3D2
> >          =3D                       sectsz=3D512   sunit=3D8 blks, lazy-=
count=3D1
> > realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=
=3D0
> OK, so the common elements here appears to be root filesystems
> with small log sizes, which means they are tail pushing all the
> time metadata operations are in progress.=20
Does that mean that such filesystems are not optimal in terms of
performance and/or reliability and should have larger log sizes?

--=20
WBR, wRAR

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJN1k5yAAoJEDNi9wMaSZLh8YkQAKjzB4at+kizRbI1dL2KqGwp
teIgc4x6aF3NCXdRUHHJvRr9zCIFwUUf0D3Tf1LAgmDsHhZ1cJSjwKHnPPR48giS
SVXA2O0JI1lr4D0jWtcd6FQfS9E2cw2wrwswZqc3zvAihN1G1dfe+kEfLV0AVRCE
Iim/Kqsd0aB3Ua/+01K87aPbA50EGhPkwO5SRu4upn8H86bvj3Yg0Out5dnvMYjX
j5WXT6Ywu/xQkfhG7hQkJXdqs6SDGleqaAE2GFMI5q5FLs+ENUwlo8pgl4pvXAa5
kbThH5ZzJkwEo4b+W5j6JfnOKfqLl78YL/WnFXghYkaVb5Fkc1AkcRZ1C0HeTZeV
Ssqt79wAWwMinpZBo2YVr+LgztQo582m7ZBEVnTOsae93jBTjryWyOSpMH1x5BYn
z+U6d+Nd1/tjYLn2NjTFLLaq9Q7Y2gT0qGg/eEupNEzHeLOgQCBhMDJ87ZkEHDpz
UepYDQFFhh0TNUC5pzPwS8k5yIQFWWF7XRvU1IH4jwpRFQTau4yEeKWDvVdi0CiN
KHDgAK15kWmrpZ+y+I0Khq5sTRFLryIZmWS3p4NqRaMnKVoelTj/+6njZchAYuW5
D/APtuxNg9gOloUIb8wN5qQNDSojit0mkIYh7PDA4GtrYQZhWEuFQLuLQ2oLUQkw
hizcs7YQb2IJrpsnmt69
=d5hH
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--


--===============1901490380666981429==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============1901490380666981429==--
