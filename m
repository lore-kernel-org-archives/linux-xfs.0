Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from tmailer.gwdg.de ([134.76.10.23]:39806 "EHLO tmailer.gwdg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbfD3VH2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 30 Apr 2019 17:07:28 -0400
Date: Tue, 30 Apr 2019 23:07:24 +0200
From: Andre Noll <maan@tuebingen.mpg.de>
Subject: Re: xfs: Assertion failed in xfs_ag_resv_init()
Message-ID: <20190430210724.GD2780@tuebingen.mpg.de>
References: <20190430121420.GW2780@tuebingen.mpg.de>
 <20190430151151.GF5207@magnolia>
 <20190430162506.GZ2780@tuebingen.mpg.de>
 <20190430174042.GH5207@magnolia>
 <20190430190525.GB2780@tuebingen.mpg.de>
 <20190430191825.GF5217@magnolia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="eu8nj/18vubUeVCi"
Content-Disposition: inline
In-Reply-To: <20190430191825.GF5217@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org


--eu8nj/18vubUeVCi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 30, 12:18, Darrick J. Wong wrote
> > commit f847bda4d612744ff1812788417bd8df41a806d3
> > Author: Dave Chinner <dchinner@redhat.com>
> > Date:   Mon Nov 19 13:31:08 2018 -0800
> >=20
> >     xfs: finobt AG reserves don't consider last AG can be a runt
> >    =20
> >     This is a backport of upstream commit c08768977b9 and the part of
> >     21ec54168b36 which is needed by c08768977b9.
>=20
> You could send this patch to the stable list, but my guess is that
> they'd prefer a straight backport of all three commits...

Hm, cherry-picking the first commit onto 4.9,171 already gives
four conflicting files. The conflicts are trivial to resolve (git
cherry-pick -xX theirs 21ec54168b36 does it), but that doesn't
compile because xfs_btree_query_all() is missing.  So e9a2599a249ed
(xfs: create a function to query all records in a btree) is needed as
well. But then, applying 86210fbebae (xfs: move various type verifiers
to common file) on top of that gives non-trivial conflicts.

So, for automatic backporting we would need to cherry-pick even more,
and each backported commit should be tested of course. Given this, do
you still think Greg prefers a rather large set of straight backports
over the simple commit that just pulls in the missing function?

I guess the important question is how much impact this issue
has on production systems (i.e., on CONFIG_XFS_DEBUG=3Dn kernels,
where the assert statement is not compiled in). If the unpatched
xfs_inobt_max_size() is very unlikely to cause problems on such
systems, we might as well live with it.

Thanks
Andre
--=20
Max Planck Institute for Developmental Biology
Max-Planck-Ring 5, 72076 T=C3=BCbingen, Germany. Phone: (+49) 7071 601 829
http://people.tuebingen.mpg.de/maan/

--eu8nj/18vubUeVCi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQSHtF/cbZGyylvqq1Ra2jVAMQCTDwUCXMi5CQAKCRBa2jVAMQCT
DyqRAJ9haZLNWKNF1m2TNS7qlvy9B+Og7QCgkgF+uEQORJ7ALymtB4oypC+7MUY=
=LEL+
-----END PGP SIGNATURE-----

--eu8nj/18vubUeVCi--
