Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ozlabs.org ([103.22.144.67]:50575 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752024AbeCVGzF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 22 Mar 2018 02:55:05 -0400
Date: Thu, 22 Mar 2018 17:54:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: linux-next: manual merge of the nvdimm tree with the xfs tree
Message-ID: <20180322175424.032cf417@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/zhlqNwi8=c7E+bgT2RVlLmj"; protocol="application/pgp-signature"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dan Williams <dan.j.williams@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, David Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Cc: Linux-Next Mailing List <linux-next@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

--Sig_/zhlqNwi8=c7E+bgT2RVlLmj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dan,

Today's linux-next merge of the nvdimm tree got a conflict in:

  fs/xfs/xfs_inode.h

between commit:

  f5c54717bf2b ("xfs: remove xfs_zero_range")

from the xfs tree and commit:

  6ea4108852e9 ("xfs: prepare xfs_break_layouts() for another layout type")

from the nvdimm tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

--=20
Cheers,
Stephen Rothwell

diff --cc fs/xfs/xfs_inode.h
index 132d8aa2afc4,6951d57aae71..000000000000
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@@ -443,6 -457,12 +457,8 @@@ enum xfs_prealloc_flags=20
 =20
  int	xfs_update_prealloc_flags(struct xfs_inode *ip,
  				  enum xfs_prealloc_flags flags);
 -int	xfs_zero_eof(struct xfs_inode *ip, xfs_off_t offset,
 -		     xfs_fsize_t isize, bool *did_zeroing);
 -int	xfs_zero_range(struct xfs_inode *ip, xfs_off_t pos, xfs_off_t count,
 -		bool *did_zero);
+ int	xfs_break_layouts(struct inode *inode, uint *iolock,
+ 		enum layout_break_reason reason);
 =20
  /* from xfs_iops.c */
  extern void xfs_setup_inode(struct xfs_inode *ip);

--Sig_/zhlqNwi8=c7E+bgT2RVlLmj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlqzUyAACgkQAVBC80lX
0Gw9xAf/XuOHM+g8CadIj8I7WyuqazqOWlDHqJzlgTYJNkTLFAkBm1Z6JpxohFCl
uEmbYfRwtq90appMzVbPpQeidXPaEAN56gDYQ1CP1ZDeLKbXJMm8DYkVXINx5Ucn
shpeF+M1/uJPkpwiRrdiujhiErM7ECeGW84TCqWO4qJFtt4OVRK+gmLBSCU0VXy9
jAKFC4qPR3wlBMQUcXvQczqo8qmIWXvd5HSbBP7TIkdqnasf6N/qv7pPgyur0gJs
53YyvOrH6mI7fbyplT6981gFVzv/lF3LbnJFXEISIlkx61iyPGExKWHCPg9J0sKI
oIo+LAwc79423uw8o6V8iuJGrA32GQ==
=JL83
-----END PGP SIGNATURE-----

--Sig_/zhlqNwi8=c7E+bgT2RVlLmj--
