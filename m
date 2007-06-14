Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Jun 2007 01:42:48 -0700 (PDT)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.173])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5E8geWt018540
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2007 01:42:42 -0700
Received: by ug-out-1314.google.com with SMTP id 74so712660ugb
        for <xfs@oss.sgi.com>; Thu, 14 Jun 2007 01:42:40 -0700 (PDT)
Subject: Re: XFS shrink functionality
From: Ruben Porras <nahoo82@gmail.com>
In-Reply-To: <20070608151223.GF86004887@sgi.com>
References: <1180715974.10796.46.camel@localhost>
	 <20070604001632.GA86004887@sgi.com>
	 <20070604084154.GA8273@teal.hq.k1024.org>
	 <1181291033.7510.40.camel@localhost>
	 <20070608101532.GA18788@teal.hq.k1024.org>
	 <20070608151223.GF86004887@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oxU5dVOBePDayLCCRZvz"
Date: Thu, 14 Jun 2007 10:35:27 +0200
Message-Id: <1181810127.6539.13.camel@localhost>
Mime-Version: 1.0
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com, cw@f00f.org, iusty@k1024.org

--=-oxU5dVOBePDayLCCRZvz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

> > I took a look at both items since this discussion started. And honestly,
> > I think 1) is harder that 4), so you're welcome to work on it :) The
> > points that make it harder is that, per David's suggestion, there needs
> > to be:
> >  - define two new transaction types
>=20
> one new transaction type:
>=20
> XFS_TRANS_AGF_FLAGS

done

> and and extension to xfs_alloc_log_agf(). Is about all that is
> needed there.

still to do. Will come after the ioctls.

> See the patch here:
>=20
> http://oss.sgi.com/archives/xfs/2007-04/msg00103.html
>=20
> For an example of a very simlar transaction to what is needed
> (look at xfs_log_sbcount()) and very similar addition to
> the AGF (xfs_btreeblks).
>=20
> >  - define two new ioctls
>=20
> XFS_IOC_ALLOC_ALLOW_AG, parameter xfsagnumber_t.
> XFS_IOC_ALLOC_DENY_AG, parameter xfsagnumber_t.

almost done. How I'm should I obtain a pointer to an xfs_agf_t from
inside the ioctls?

I guess that the first step is to get a *bp with xfs_getsb and then an *sbp,
but, which function/macro gives me the xfs_agf_t pointer? Sorry, I can't
find the way greeping through the code.

> >  - update the ondisk-format (!), if we want persistence of these flags;
> >    luckily, there are two spare fields in the AGF structure.
>=20
> Better to expand, I think. The AGF is a sector in length - we can
> expand the structure as we need to this size without fear, esp. as
> the part of the sector outside the structure is guaranteed to be
> zero.  i.e. we can add a fields flag to the end of the AGF
> structure - old filesystems simple read as "no flags set" and
> old kernels never look at those bits....

done.

> >  - check the list of allocation functions that allocate space from the
> >    AG

still to be done.

Thaks again for the help.

--=-oxU5dVOBePDayLCCRZvz
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGcP3PYubrKblAx+oRAtXUAJ9HRydd5yl/7dPiqNTVMDTlRw+8lwCeO05B
JJC+DMs0+wkQ0PfReV7ysoQ=
=9qWU
-----END PGP SIGNATURE-----

--=-oxU5dVOBePDayLCCRZvz--
