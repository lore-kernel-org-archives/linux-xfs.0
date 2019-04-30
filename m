Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from tmailer.gwdg.de ([134.76.10.23]:54431 "EHLO tmailer.gwdg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725976AbfD3QZN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Apr 2019 12:25:13 -0400
Date: Tue, 30 Apr 2019 18:25:06 +0200
From: Andre Noll <maan@tuebingen.mpg.de>
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190430162506.GZ2780@tuebingen.mpg.de>
References: <20190430121420.GW2780@tuebingen.mpg.de>
 <20190430151151.GF5207@magnolia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Ioq9Y4M6AeSMCjnH"
Content-Disposition: inline
In-Reply-To: <20190430151151.GF5207@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org


--Ioq9Y4M6AeSMCjnH
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 30, 08:11, Darrick J. Wong wrote
> > To see why the assertion triggers, I added
> >=20
> >         xfs_warn(NULL, "a: %u", xfs_perag_resv(pag, XFS_AG_RESV_METADAT=
A)->ar_reserved);
> >         xfs_warn(NULL, "b: %u", xfs_perag_resv(pag, XFS_AG_RESV_AGFL)->=
ar_reserved);
> >         xfs_warn(NULL, "c: %u", pag->pagf_freeblks);
> >         xfs_warn(NULL, "d: %u", pag->pagf_flcount);
> >=20
> > right before the ASSERT() in xfs_ag_resv.c. Looks like
> > pag->pagf_freeblks is way too small:
> >=20
> > [  149.777035] XFS: a: 267367
> > [  149.777036] XFS: b: 0
> > [  149.777036] XFS: c: 6388
> > [  149.777037] XFS: d: 4
> >=20
> > Fortunately, this is new hardware which is not yet in production use,
> > and the filesystem in question only contains a few dummy files. So
> > I can test patches.
>=20
> The assert (and your very helpful debugging xfs_warns) indicate that for
> the kernel was trying to reserve 267,367 blocks to guarantee space for
> metadata btrees in an allocation group (AG) that has only 6,392 blocks
> remaining.
>=20
> This per-AG block reservation exists to avoid running out of space for
> metadata in worst case situations (needing space midway through a
> transaction on a nearly full fs).  The assert your machine hit is a
> debugging warning to alert developers to the per-AG block reservation
> system deciding that it won't be able to handle all cases.

So, consider yourself alerted :)

> Hmmm, what features does this filesystem have enabled?

With CONFIG_XFS_DEBUG=3Dn the mount succeeded, and xfs_info says

	meta-data=3D/dev/mapper/zeal-tst   isize=3D512    agcount=3D101, agsize=3D=
268435392 blks
		 =3D                       sectsz=3D4096  attr=3D2, projid32bit=3D1
		 =3D                       crc=3D1        finobt=3D1 spinodes=3D0 rmapbt=
=3D0
		 =3D                       reflink=3D0
	data     =3D                       bsize=3D4096   blocks=3D26843545600, im=
axpct=3D1
		 =3D                       sunit=3D64     swidth=3D1024 blks
	naming   =3Dversion 2              bsize=3D4096   ascii-ci=3D0 ftype=3D1
	log      =3Dinternal               bsize=3D4096   blocks=3D521728, version=
=3D2
		 =3D                       sectsz=3D4096  sunit=3D1 blks, lazy-count=3D1
	realtime =3Dnone                   extsz=3D4096   blocks=3D0, rtextents=3D0

> Given that XFS_AG_RESV_METADATA > 0 and there's no warning about the
> experimental reflink feature, that implies that the free inode btree
> (finobt) feature is enabled?

yep: no reflink, but finobt.

> The awkward thing about the finobt reservation is that it was added long
> after the finobt feature was enabled, to fix a corner case in that code.
> If you're coming from an older kernel, there might not be enough free
> space in the AG to guarantee space for the finobt.

No, this machine and its storage is new, and never ran a kernel other
than 4.9.x. The filesystem was created with mkfs.xfs of xfsprogs
version 4.9.0+nmu1ubuntu2, which ships with Ubuntu-18.04.

Isn't it surprising to run into ENOSPC on an almost empty 100T
large filesystem? If so, do you think the issue could be related to
dm-thin? Another explanation would be that the assert condition is
broken, for example because pag->pagf_freeblks is not uptodate.

> In any case, if you're /not/ trying to debug the XFS code itself, you
> could set CONFIG_XFS_DEBUG=3Dn to turn off all the programmer debugging
> pieces (which will improve fs performance substantially).
>=20
> If you want all the verbose debugging checks without the kernel hang
> behavior you could set CONFIG_XFS_DEBUG=3Dn and CONFIG_XFS_WARN=3Dy.

Sure, debugging will be turned off when the machine goes into production
mode. For stress testing new hardware I prefer to leave it on, though.

Anyways, do you believe that the assert is just an overzealous check
to inform developers about a corner case that never triggers under
normal circumstances, or is this an issue that will come back to hurt
plenty when the assert is ignored due to CONFIG_XFS_DEBUG=3Dn?

One more data point: After booting into a CONFIG_XFS_DEBUG=3Dn kernel,
mounting and unmounting the filesystem, and booting back into the
CONFIG_XFS_DEBUG=3Dy kernel, the assert still triggers.

Thanks for your help
Andre
--=20
Max Planck Institute for Developmental Biology
Max-Planck-Ring 5, 72076 T=C3=BCbingen, Germany. Phone: (+49) 7071 601 829
http://people.tuebingen.mpg.de/maan/

--Ioq9Y4M6AeSMCjnH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSHtF/cbZGyylvqq1Ra2jVAMQCTDwUCXMh24AAKCRBa2jVAMQCT
D+ifAJ9K7F46/wRUQhS/ZWVpgB53lCpibACeObl3JvpDsP0+FYGpJO6rnMN7aXs=
=yIOO
-----END PGP SIGNATURE-----

--Ioq9Y4M6AeSMCjnH--
