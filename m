Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([203.11.71.1]:45773 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750899AbeFEBZd (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Jun 2018 21:25:33 -0400
Date: Tue, 5 Jun 2018 11:25:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the xfs tree with Linus' tree
Message-ID: <20180605112531.23b392f3@canb.auug.org.au>
In-Reply-To: <20180605005904.GY10363@dastard>
References: <20180605103403.3e5b2c91@canb.auug.org.au>
        <20180605005904.GY10363@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/fw2ZlOu+ZpCr0EG3KSdrqIa"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Bob Peterson <rpeterso@redhat.com>, Christoph Hellwig <hch@lst.de>, Linus <torvalds@linux-foundation.org>

--Sig_/fw2ZlOu+ZpCr0EG3KSdrqIa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Tue, 5 Jun 2018 10:59:04 +1000 Dave Chinner <david@fromorbit.com> wrote:
>
> On Tue, Jun 05, 2018 at 10:34:03AM +1000, Stephen Rothwell wrote:
> >
> > Today's linux-next merge of the xfs tree got a conflict in:
> >=20
> >   fs/gfs2/bmap.c
> >=20
> > between commit:
> >=20
> >   628e366df11c ("gfs2: Iomap cleanups and improvements")
> >=20
> > from Linus' tree and commit:
> >=20
> >   7ee66c03e40a ("iomap: move IOMAP_F_BOUNDARY to gfs2")
> >=20
> > from the xfs tree.
>=20
> We should have seen this before the gfs2 tree was merged into Linus'
> tree. Does that mean the gfs2 tree is not being pulled into the
> linux-next tree?

It is pulled in, but the above gfs2 commit was only committed to the
linux-next included branch overnight and then Linus was asked to pull
it before I got a chance to build today's linux-next.

--=20
Cheers,
Stephen Rothwell

--Sig_/fw2ZlOu+ZpCr0EG3KSdrqIa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlsV5osACgkQAVBC80lX
0Gzz/Af/R8kRCCn7j6NYrwbebbUNOJzeT2GtSY1PCf+Jk9pVkY19vL/XrCTRl4CF
hHL3MPQVwoXniBLNzHNJXLt+Jvth8GG2Z0aXVwk15Qi9VSXWbpQt4XJXA73GzHCK
42uBHsJXsRWoP9n/q5tDZ+1gApWk+5NZJwhP4emzQcdJjT2dBl0FRKYyQvDXJNgd
mUAE17UKpHUZqVrMC3/8+4iPCs/lIortOv9V9NCd/p/1mSu4QHI5mi+sCzRmqNJo
BxccOXwA42ppudSzDQUzmqb9SsIPGUv95b6mYgnJtcfTEAVNH+Dqm9n9ccloPfJr
Et6B8TS/Ht+5sa4e3uNvhDxHNDMhZQ==
=V2hG
-----END PGP SIGNATURE-----

--Sig_/fw2ZlOu+ZpCr0EG3KSdrqIa--
