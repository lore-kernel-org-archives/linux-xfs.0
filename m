Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:56539 "EHLO
        ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751021AbcJCDcj (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2016 23:32:39 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1bqtzW-0007ZH-1f
        for linux-xfs@vger.kernel.org; Mon, 03 Oct 2016 14:32:34 +1100
Date: Mon, 3 Oct 2016 14:32:34 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfsprogs: v4.8.0-rc3 released
Message-ID: <20161003033233.GM27872@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="oC1+HKm2/end4ao3"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


--oC1+HKm2/end4ao3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The xfsprogs repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git

has just been updated and tagged as v4.8.0-rc3. This contains fixes
for repair, libxcmd and libxfs, and a clean up the xfs_io inode
command. If nothing else comes up in the next week, then the next
update will be a full release.

-Dave.

The new head of the master branch is commit:

36617169e946 xfsprogs: Release 4.8.0-rc3

New Commits:

Darrick J. Wong (2):
      [636f06d882cf] xfs_repair: fix bogosity when rmapping new AGFL blocks
      [ef4332b8fbd3] xfs_repair: add freesp btree block overflow to the fre=
e space

Dave Chinner (1):
      [36617169e946] xfsprogs: Release 4.8.0-rc3

Eric Sandeen (6):
      [81f8132ae361] libxfs: remove unused libxfs_iget arg
      [870ecc222fb4] xfs_io: fix inode command help and argsmax
      [d0e8bb48b7a6] xfs_io: factor out new get_last_inode() helper
      [5afa1b2d0f2c] xfs_io: move inode command arg handling to top
      [d5b046de584d] xfs_io: refactor inode command
      [197069505b88] xfs_io: fix inode command with "-n" for bogus inode

Eryu Guan (1):
      [753a71d46f0f] libxcmd: fix counting of xfs entries in fs_table_insert


Code Diffstat:

 VERSION                  |   2 +-
 configure.ac             |   2 +-
 db/attrset.c             |   4 +-
 doc/CHANGES              |   7 ++
 include/xfs_inode.h      |   2 +-
 io/open.c                | 178 ++++++++++++++++++++++++++++---------------=
-------
 libxcmd/paths.c          |   3 +-
 libxfs/libxfs_api_defs.h |   1 +
 libxfs/rdwr.c            |   4 +-
 libxfs/trans.c           |   4 +-
 repair/phase5.c          | 102 +++++++++++++++++++++--------
 repair/phase6.c          |  10 +--
 repair/rmap.c            |  15 +++--
 13 files changed, 209 insertions(+), 125 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--oC1+HKm2/end4ao3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJX8dFRAAoJEK3oKUf0dfodThEP/12hWOCF59OZr6fZgo70rvwP
l1aQ6nUs9f2hvfyXaKiPYDSNMqj+hPYTbSdCL2b1zvlUfkE6cLnQE4e8x9GJKb8U
KHwUWZTkROG5vZYJD0eUm3M8eEPk2fPdd/tWQBZv7naTgKKAHdBgtfYezUTxLIP2
dzAIZ2PNr36SLvjXm1lEkCWMSq6N2WnWtJWkzQDUqx4V5/Bl/Ng2c0ZRhQtXPxYk
8AM2E2dtXyvVuwcDyBBbtIfEaWFeQbj8zIBB4Xo0fRbnxgLRjUb5B2/LOz4REmoz
gR87NDDz6RJGacUZ7ZpzHeZvg4TxjrXWZqA9b8Nu3Knic0QmpsYQnlAsxjTPV/HY
r7K/K0Nb1ucoztEIpLksqauiwjthRBufizFQNpUC9AYBMwfy/ibHxqSyewKeWVVW
HEaCJFMrQztpstnUxyCgM2Hwyr4Fq33CL7XPgVwFhY0F3Qh2fRslX+IMMbOVVPiY
/Sd7zthnPCz4UG5TpmlwDuE1X/XR/28WW+MqkCncwZhMCz4adolxcUvMkTeNHKIh
/kExOZ+fv9QXzns1fafOnqLKISBe9u2phfxsyO/v5V4bmNmLmRudYlSFvItuWCXy
lBE85Ymmu8J+ZOw+eHUbPr7JviyCxS45IV8r8wMswjoFPc4ffVR9VakYQtXkkBUp
dTTY7R+JRCSlGaWFEn1B
=T/+p
-----END PGP SIGNATURE-----

--oC1+HKm2/end4ao3--
