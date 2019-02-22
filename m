Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from tmailer.gwdg.de ([134.76.10.23]:41632 "EHLO tmailer.gwdg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726109AbfBVTzk (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 22 Feb 2019 14:55:40 -0500
Date: Fri, 22 Feb 2019 20:55:37 +0100
From: Andre Noll <maan@tuebingen.mpg.de>
Subject: Re: [PATCH 1/4] xfs_restore: refactor open-coded file creation code
Message-ID: <20190222195537.GG15048@tuebingen.mpg.de>
References: <155085403848.5141.1866278990901950186.stgit@magnolia>
 <155085404462.5141.11851529133557195388.stgit@magnolia>
 <20190222192053.GF15048@tuebingen.mpg.de>
 <20190222192836.GB21626@magnolia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="udcq9yAoWb9A4FsZ"
Content-Disposition: inline
In-Reply-To: <20190222192836.GB21626@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org


--udcq9yAoWb9A4FsZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 22, 11:28, Darrick J. Wong wrote
> > > +_("attempt to reserve %lld bytes for %s using %s failed: %s (%d)\n"),
> > > +				size, pathname, "XFS_IOC_RESVSP64",
> > > +				strerror(errno), errno);
> >=20
> > The "XFS_IOC_RESVSP64" string literal can be included in the format str=
ing.
>=20
> I was trying not to force an update of the i18n message catalogs.

Point.

> > > +	if (ret =3D=3D 0)
> > > +		goto done;
> > > +
> > > +done:
> >=20
> > LOL
>=20
> Yes, it's silly, but gcc will complain if the label doesn't get
> used, which it won't if you apply the rest of the series and build
> xfsdump on a system that (somehow) doesn't know about fallocate.

True. It does trigger a WTF event in wetware though, at least if you
read the patch without context of 4/4.

Anyway, thanks for the explanations
Andre
--=20
Max Planck Institute for Developmental Biology
Max-Planck-Ring 5, 72076 T=C3=BCbingen, Germany. Phone: (+49) 7071 601 829
http://people.tuebingen.mpg.de/maan/

--udcq9yAoWb9A4FsZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSHtF/cbZGyylvqq1Ra2jVAMQCTDwUCXHBTtgAKCRBa2jVAMQCT
Dy1pAJ42H/Nxl/e6MXDiXjkhmXRSW78GngCfS1P39PL7LJ35YSwYL+G4JL1SVu4=
=2M0C
-----END PGP SIGNATURE-----

--udcq9yAoWb9A4FsZ--
