Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([203.11.71.1]:44495 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751046AbeFEAeH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Jun 2018 20:34:07 -0400
Date: Tue, 5 Jun 2018 10:34:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the xfs tree with Linus' tree
Message-ID: <20180605103403.3e5b2c91@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/tDUNVkH5tRJmlCioqY95Qrk"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Bob Peterson <rpeterso@redhat.com>, Christoph Hellwig <hch@lst.de>

--Sig_/tDUNVkH5tRJmlCioqY95Qrk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the xfs tree got a conflict in:

  fs/gfs2/bmap.c

between commit:

  628e366df11c ("gfs2: Iomap cleanups and improvements")

from Linus' tree and commit:

  7ee66c03e40a ("iomap: move IOMAP_F_BOUNDARY to gfs2")

from the xfs tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.



--=20
Cheers,
Stephen Rothwell

--Sig_/tDUNVkH5tRJmlCioqY95Qrk
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlsV2nsACgkQAVBC80lX
0GxxNgf9HYKq6dGa5CJc7vMLG/6gFKQhXQ7WGxrd/VuqluKAuwfuO4yEehwai2vN
fPLYbXOkFfnP4uFDSieXdepIAIqg/Inpi25uBULOXYraDqEUQ/9ydguPDzQvtI+O
6Y/i8Ng1HGewf5yiBsDKS3yeL6iSJ+aq3UZE+Io2aYP1ysAbLSp5bN9MQ84TNYOE
JaJzm0ofCXX4zFS+ilzRv6uDJyjcmhYXu11FjmNWDgLmMXWF6GHVK/0f/9E8ln6J
2oiRpXGe0JOZ/hM0NK4E1GOvGqzZFeaQQeeC0qgKSGNyfo5kBUqlVvzcXv2CZG0o
Co9BHhxUjdYYBgS2BUKrAXYgycsQqQ==
=9XyL
-----END PGP SIGNATURE-----

--Sig_/tDUNVkH5tRJmlCioqY95Qrk--
