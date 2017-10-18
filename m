Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51602 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750975AbdJRTeQ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 18 Oct 2017 15:34:16 -0400
Received: from [10.0.0.4] (liberator [10.0.0.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by sandeen.net (Postfix) with ESMTPSA id 78AD82ACC
        for <linux-xfs@vger.kernel.org>; Wed, 18 Oct 2017 14:33:27 -0500 (CDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 9d199c7
Message-ID: <4714fdb1-2dac-ffed-07b5-8914db6dbfe7@sandeen.net>
Date: Wed, 18 Oct 2017 14:34:07 -0500
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="HksNsnJoOAr1iJa1aEwpJUXN3svLnekxO"
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--HksNsnJoOAr1iJa1aEwpJUXN3svLnekxO
Content-Type: multipart/mixed; boundary="w7jaPOvGoVRQgiMp3B1KFDmK9x0gSwITm";
 protected-headers="v1"
From: Eric Sandeen <sandeen@sandeen.net>
To: linux-xfs <linux-xfs@vger.kernel.org>
Message-ID: <4714fdb1-2dac-ffed-07b5-8914db6dbfe7@sandeen.net>
Subject: [ANNOUNCE] xfsprogs: for-next updated to 9d199c7

--w7jaPOvGoVRQgiMp3B1KFDmK9x0gSwITm
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfsprogs repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated.

Patches often get missed, so please check if your outstanding
patches were in this update. If they have not been in this update,
please resubmit them to linux-xfs@vger.kernel.org so they can be
picked up in the next update.

The new head of the for-next branch is commit:

9d199c7 xfs: trim writepage mapping to within eof

New Commits:

Brian Foster (4):
      [7f87080] xfs: don't log dirty ranges for ordered buffers
      [c7ba173] xfs: skip bmbt block ino validation during owner change
      [38fa71a] xfs: relog dirty buffers during swapext bmbt owner change=

      [9d199c7] xfs: trim writepage mapping to within eof

Carlos Maiolino (1):
      [d8c4789] xfs: stop searching for free slots in an inode chunk when=
 there=20

Christoph Hellwig (9):
      [d67406c] xfs: refactor xfs_trans_roll
      [277d3c3] xfs: rename xfs_defer_join to xfs_defer_ijoin
      [5c33bae] xfs: remove the ip argument to xfs_defer_finish
      [6484fa5] xfs: add a xfs_iext_update_extent helper
      [05104e4] xfs: switch xfs_bmap_local_to_extents to use xfs_iext_ins=
ert
      [f71f3bc] xfs: use xfs_iext_get_extent in xfs_bmap_first_unused
      [b6ad780] xfs: move some code around inside xfs_bmap_shift_extents
      [2f08282] xfs: use xfs_iext_*_extent helpers in xfs_bmap_shift_exte=
nts
      [455044a] xfs: use xfs_iext_*_extent helpers in xfs_bmap_split_exte=
nt_at

Darrick J. Wong (4):
      [479284b] xfs: simplify the rmap code in xfs_bmse_merge
      [8cee3e4] xfs: fix compiler warnings
      [8b06892] xfs: perag initialization should only touch m_ag_max_usab=
le for=20
      [7fbe9b5] xfs: revert "xfs: factor rmap btree size into the indlen =
calcula

Dave Chinner (1):
      [87daa55] xfs: Don't log uninitialised fields in inode structures

Eric Sandeen (1):
      [b2284d0] xfs: handle error if xfs_btree_get_bufs fails

Thomas Meyer (1):
      [180d3cd] xfs: Fix bool initialization/comparison


Code Diffstat:

 include/xfs_trans.h      |   4 +-
 libxfs/libxfs_api_defs.h |   3 +
 libxfs/libxfs_priv.h     |   5 +-
 libxfs/trans.c           |  58 ++++++---
 libxfs/util.c            |   8 +-
 libxfs/xfs_ag_resv.c     |  12 +-
 libxfs/xfs_alloc.c       |   8 ++
 libxfs/xfs_attr.c        | 156 ++++++++++++------------
 libxfs/xfs_attr_leaf.c   |   6 +-
 libxfs/xfs_attr_remote.c |  39 +++---
 libxfs/xfs_bmap.c        | 310 +++++++++++++++++++++++------------------=
------
 libxfs/xfs_bmap.h        |   1 +
 libxfs/xfs_bmap_btree.c  |   1 +
 libxfs/xfs_btree.c       |  27 +++--
 libxfs/xfs_btree.h       |   3 +-
 libxfs/xfs_defer.c       |  29 ++---
 libxfs/xfs_defer.h       |   5 +-
 libxfs/xfs_ialloc.c      |  61 +++++-----
 libxfs/xfs_inode_fork.c  |  21 +++-
 libxfs/xfs_inode_fork.h  |   2 +
 libxfs/xfs_log_format.h  |  27 ++---
 libxfs/xfs_refcount.c    |   2 +-
 logprint/log_misc.c      |  87 ++++++-------
 logprint/log_print_all.c |   4 +-
 mkfs/proto.c             |  18 ++-
 repair/phase6.c          |  36 ++++--
 26 files changed, 486 insertions(+), 447 deletions(-)



--w7jaPOvGoVRQgiMp3B1KFDmK9x0gSwITm--

--HksNsnJoOAr1iJa1aEwpJUXN3svLnekxO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEK4GFkZ6NJImBhp3tIK4WkuE93uAFAlnnrLcACgkQIK4WkuE9
3uBBWw/9EAnqkX3WEr9lDf+i7b4PTO1LCzlHhzhXEKymE9+xZwG1RMC6Zi8LN1ZF
uO8YtWpZrTXupYg/Zki58FqZFd+DRj8vCkZa3nuuOvqmYRprwow48cwhcCX6zxCN
DIbar6s30nIwJN6ghDZ6/io7UfIJtg9rLYLp5T1zboHuGnzqc53dDe7gbWkMqk0I
OsQPBYD6l9Cmn4QdqjUCReAsPhrF1oxACPKE3HPZEo8Y/m/mox9Fm5NJOrvhhKYI
yJyA81P6UsN8do4RiLf9yRYORT5ES+ITcwH9brAT51rTvvgkT74sM8uXF6hWI1nZ
619lo+55h1eENqoGbHpNJL6obIgW+8wyVr62pO4CMi57ZAvsTBY8FzC8kngsCyIg
hbvLKLwZ4icljU9/MG2wuwS1tret+eP7z0pBLYnoXDRb57j7xVGEljEIJYq++E3G
+7O2nZ6o3NMeGhQcCJp/M7VX0dMxW7ra7tJnQfIG1cODqJ6Np6dS+6aXSOVuWuXQ
cnp+kMwK17Q2CZ8eGH6EZ0EetKlzfDFaQK2zGaqY2zGiijiCtpAdC2gH+YEzwqY5
Jqe7CYgtjErne0vuM9zCpwekotriFZTIclo/gVkAjWA3HPbXkLapZn6r6532Qklh
W3TAHPuQWX5B6DRlGoViWYmyEASK7/yMMTXVHC4WTsabrhti9L0=
=J+Tv
-----END PGP SIGNATURE-----

--HksNsnJoOAr1iJa1aEwpJUXN3svLnekxO--
