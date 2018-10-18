Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:53435 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727427AbeJRQ6L (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 18 Oct 2018 12:58:11 -0400
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gD47g-0005PB-Eh
        for linux-xfs@vger.kernel.org; Thu, 18 Oct 2018 19:57:40 +1100
Date: Thu, 18 Oct 2018 19:57:40 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs-linux: for-next branch updated to 96987eea537d
Message-ID: <20181018085740.GG6311@dastard>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="KFztAG8eRSV9hGtP"
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org


--KFztAG8eRSV9hGtP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Folks,

The for-next branch of the xfs-linux repository at:

        git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

This update contains my candidate 4.20 merge tree. It's not a huge
bunch of changes this time around, but if you could pull it and pass
and eye (and a test!) over the changes it would be much
appreciated. If I've missed anything, let me know.

I haven't included Darrick's reflink/dedupe patchset yet - we need
finish review and to work out which tree that is going to be merged
through first.

-Dave.


The following changes since commit b39989009bdb84992915c9869f58094ed5becf10:

  xfs: fix data corruption w/ unaligned reflink ranges (2018-10-06 11:44:39=
 +1000)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux xfs-4.20-merge

for you to fetch changes up to 96987eea537d6ccd98704a71958f9ba02da80843:

  xfs: cancel COW blocks before swapext (2018-10-18 17:21:55 +1100)

----------------------------------------------------------------
Adam Borowski (1):
      xfs: add a define for statfs magic to uapi

Allison Henderson (4):
      xfs: Move fs/xfs/xfs_attr.h to fs/xfs/libxfs/xfs_attr.h
      xfs: Add helper function xfs_attr_try_sf_addname
      xfs: Add attibute set and helper functions
      xfs: Add attibute remove and helper functions

Brian Foster (1):
      xfs: clear ail delwri queued bufs on unmount of shutdown fs

Carlos Maiolino (2):
      xfs: Fix xqmstats offsets in /proc/fs/xfs/xqmstat
      xfs: use offsetof() in place of offset macros for __xfsstats

Christoph Hellwig (8):
      xfs: remove XFS_IO_INVALID
      xfs: remove suport for filesystems without unwritten extent flag
      xfs: handle zeroing in xfs_file_iomap_begin_delay
      xfs: remove the unused shared argument to xfs_reflink_reserve_cow
      xfs: remove the unused trimmed argument from xfs_reflink_trim_around_=
shared
      xfs: fix fork selection in xfs_find_trim_cow_extent
      xfs: print dangling delalloc extents
      xfs: cancel COW blocks before swapext

Darrick J. Wong (3):
      xfs: xrep_findroot_block should reject root blocks with siblings
      xfs: always assign buffer verifiers when one is provided
      xfs: fix buffer state management in xrep_findroot_block

Dave Chinner (2):
      xfs: issue log message on user force shutdown
      xfs: fix use-after-free race in xfs_buf_rele

 fs/xfs/libxfs/xfs_attr.c       | 236 ++++++++++++++++++++++++-------------=
----
 fs/xfs/{ =3D> libxfs}/xfs_attr.h |   2 +
 fs/xfs/libxfs/xfs_bmap.c       |  70 ++++++------
 fs/xfs/libxfs/xfs_bmap.h       |   1 +
 fs/xfs/libxfs/xfs_format.h     |   8 +-
 fs/xfs/libxfs/xfs_sb.c         |   5 +-
 fs/xfs/scrub/repair.c          | 128 +++++++++++++++++-----
 fs/xfs/scrub/scrub.c           |  13 ---
 fs/xfs/xfs_aops.c              |   4 +-
 fs/xfs/xfs_aops.h              |  14 ++-
 fs/xfs/xfs_bmap_util.c         |  61 ++---------
 fs/xfs/xfs_buf.c               | 109 +++++++++++++++----
 fs/xfs/xfs_buf.h               |   2 +
 fs/xfs/xfs_fsops.c             |  50 ++++-----
 fs/xfs/xfs_ioctl.c             |   8 --
 fs/xfs/xfs_iomap.c             |  53 ++++++---
 fs/xfs/xfs_reflink.c           |  33 +++---
 fs/xfs/xfs_reflink.h           |   4 +-
 fs/xfs/xfs_stats.c             |  52 ++++-----
 fs/xfs/xfs_stats.h             |  28 +----
 fs/xfs/xfs_super.c             |  38 ++++++-
 fs/xfs/xfs_trans.h             |   1 +
 fs/xfs/xfs_trans_ail.c         |  28 +++--
 fs/xfs/xfs_trans_buf.c         |  42 ++++++++
 include/uapi/linux/magic.h     |   1 +
 25 files changed, 608 insertions(+), 383 deletions(-)
 rename fs/xfs/{ =3D> libxfs}/xfs_attr.h (97%)
--=20
Dave Chinner
david@fromorbit.com

--KFztAG8eRSV9hGtP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJbyEsDAAoJEK3oKUf0dfodWDsP/ieKXQXAc7oAqEBg7Y8nB4jo
lGpHUD9Virfmz3heW7wTg0tcqsp0xPX9ADhmg4nvIlhQhLZQf9Gdmjzx8SCfU07k
yx0Gb2p74dmI81YO6/zT6pyC+kwDC/twBL1gs60DZ7wdU5zFHSDgL0sKN93P/FDy
amFLdyYYwzG9eSca2jpedyBGKCuJXVTvWCMiSyn4f/iAzkHoKiziiaxbLmBhFNUR
J87jkNiDAukZnEVzju/YE304DgyF2jADJjDelG8BTE/FmUXCJycvtlk8KIlrI4zz
pZuFmeq/WeUKxLZUVwB7bWVijQrw+o+ty//sXIE1nW9j3iRHrz+731QnSGX3pCQx
drvcUisBJ2N/r+P3966zodv9gRVqbz4pSzpSzY8iMdCaqvrGZfLvkHtYAhZ6qORS
EEEt4h4hL7EBk+Ct8gg7t3epBApT5ZcGS2SvTuGx6FsqGQgnNwbaUk//DUQarkWi
b+G6MNWmeiz2DQFrgEmJLVza9YfF3UiSfOf3mjIk/nKETF9XJzFhsNiIMeKthtoE
Ya6h9gXe7gdK+uqPtO7kktj1gWSqcEJ8dz0upuv16yk8wHNbx2dm233n+QZFEwHG
T5qRkW6lVr7DyUFGdxHdGgBlUVpUGUZ0+Hffh6MfG56QQj5gkTTtl+sr2/Hbusu9
FNb8z0XZ93V6ZDyr6QuJ
=ySyb
-----END PGP SIGNATURE-----

--KFztAG8eRSV9hGtP--
