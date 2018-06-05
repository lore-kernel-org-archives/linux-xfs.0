Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([203.11.71.1]:33699 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751046AbeFEAi0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Jun 2018 20:38:26 -0400
Date: Tue, 5 Jun 2018 10:38:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: manual merge of the xfs tree with Linus' tree
Message-ID: <20180605103823.2ce02805@canb.auug.org.au>
In-Reply-To: <20180605103403.3e5b2c91@canb.auug.org.au>
References: <20180605103403.3e5b2c91@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/X4xRD2gfPK5/0=N=lZZ8RQa"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andreas Gruenbacher <agruenba@redhat.com>, Bob Peterson <rpeterso@redhat.com>, Christoph Hellwig <hch@lst.de>

--Sig_/X4xRD2gfPK5/0=N=lZZ8RQa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 5 Jun 2018 10:34:03 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Today's linux-next merge of the xfs tree got a conflict in:
>=20
>   fs/gfs2/bmap.c
>=20
> between commit:
>=20
>   628e366df11c ("gfs2: Iomap cleanups and improvements")
>=20
> from Linus' tree and commit:
>=20
>   7ee66c03e40a ("iomap: move IOMAP_F_BOUNDARY to gfs2")
>=20
> from the xfs tree.
>=20
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Forgot the diff :-(
--=20
Cheers,
Stephen Rothwell

diff --cc fs/gfs2/bmap.c
index a7b586e02693,8efa6297e19c..000000000000
--- a/fs/gfs2/bmap.c
+++ b/fs/gfs2/bmap.c
@@@ -767,12 -680,13 +767,13 @@@ static void gfs2_stuffed_iomap(struct i
  		      sizeof(struct gfs2_dinode);
  	iomap->offset =3D 0;
  	iomap->length =3D i_size_read(inode);
- 	iomap->type =3D IOMAP_MAPPED;
- 	iomap->flags =3D IOMAP_F_DATA_INLINE;
+ 	iomap->type =3D IOMAP_INLINE;
  }
 =20
+ #define IOMAP_F_GFS2_BOUNDARY IOMAP_F_PRIVATE
+=20
  /**
 - * gfs2_iomap_begin - Map blocks from an inode to disk blocks
 + * gfs2_iomap_get - Map blocks from an inode to disk blocks
   * @inode: The inode
   * @pos: Starting position in bytes
   * @length: Length to map, in bytes
@@@ -838,20 -770,20 +839,20 @@@ static int gfs2_iomap_get(struct inode=20
  	if (*ptr =3D=3D 0)
  		goto do_alloc;
 =20
 -	iomap->type =3D IOMAP_MAPPED;
 -	iomap->addr =3D be64_to_cpu(*ptr) << inode->i_blkbits;
 +	bh =3D mp->mp_bh[ip->i_height - 1];
 +	len =3D gfs2_extent_length(bh->b_data, bh->b_size, ptr, len, &eob);
 =20
 -	bh =3D mp.mp_bh[ip->i_height - 1];
 -	len =3D gfs2_extent_length(bh->b_data, bh->b_size, ptr, lend - lblock, &=
eob);
 +	iomap->addr =3D be64_to_cpu(*ptr) << inode->i_blkbits;
 +	iomap->length =3D len << inode->i_blkbits;
 +	iomap->type =3D IOMAP_MAPPED;
 +	iomap->flags =3D IOMAP_F_MERGED;
  	if (eob)
- 		iomap->flags |=3D IOMAP_F_BOUNDARY;
+ 		iomap->flags |=3D IOMAP_F_GFS2_BOUNDARY;
 -	iomap->length =3D (u64)len << inode->i_blkbits;
 =20
 -out_release:
 -	release_metapath(&mp);
 -	bmap_unlock(ip, flags & IOMAP_WRITE);
  out:
 -	trace_gfs2_iomap_end(ip, iomap, ret);
 +	iomap->bdev =3D inode->i_sb->s_bdev;
 +unlock:
 +	up_read(&ip->i_rw_mutex);
  	return ret;
 =20
  do_alloc:

--Sig_/X4xRD2gfPK5/0=N=lZZ8RQa
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlsV238ACgkQAVBC80lX
0GyauwgAlVhiYB9DYApT38VM3the3KD3DvpIlv8BSa9hUCvNGWmb1AxyXVskmg55
n8gkLYVHifBor3kJ/8bJiN8ou6K1OxemowaKu6WX1vYvlt7gWIkoDHIGo7WCjbPP
N7+kxv4sNjevQqyJ2fld0NOgWKJ1uC1g6yMtKRnGwyWZUWSEbzdNlxkywIlZSCd7
oTVWXYtvVxsTM7FHX3uNpmH/JPmGn4NB0WUBb3IB0orDKT520SSjVXXatVfBQN36
MG9rsCXhHHrLQ38hcZ5+mJzyy6Q2ibKuNALKXOh1plGFXDVWcSBHtp2YaOZarlsN
rQQG6rllqhIDd7fEAZ6rbmWJVIYViA==
=Srn3
-----END PGP SIGNATURE-----

--Sig_/X4xRD2gfPK5/0=N=lZZ8RQa--
