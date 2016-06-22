Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D85657CA1
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 19:29:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 955AA8F8033
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 17:29:50 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	zzA175SMvb7bNK6I for <xfs@oss.sgi.com>;
	Tue, 21 Jun 2016 17:29:46 -0700 (PDT)
Date: Wed, 22 Jun 2016 10:29:17 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to f477ced
Message-ID: <20160622002917.GH27480@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============0140200597207791922=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, rpeterso@redhat.com


--===============0140200597207791922==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. This update includes the long-awaited
iomap-based IO path infrastructure changes that Christoph has
finished off, along with a few bug fixes and the first handful of
miscellaneous changes from Darrick's mega-rmap patchset.

The iomap infrastructure patches are in their own separate branch -
fs-4.8-iomap-infrastructure - so it can be considered a stable
branch and hence can be merged into other fs trees so they can start
adding their own iomap-based work.  It will be included in the
linux-next build by the merge into the XFS tree's for-next branch.
Any bug fixes that are needed will be appended to this branch, so
please cc me on bug reports so I see them quickly.

Cheers,

Dave.

The new head of the for-next branch is commit:

f477ced Merge branch 'xfs-4.8-misc-fixes-2' into for-next

New Commits:

Brian Foster (2):
      [fa5a4f5] xfs: cancel eofblocks background trimming on remount read-o=
nly
      [408fd48] xfs: refactor xfs_reserve_blocks() to handle ENOSPC correct=
ly

Christoph Hellwig (14):
      [199a31c] fs: move struct iomap from exportfs.h to a separate header
      [ae259a9] fs: introduce iomap infrastructure
      [9a286f0] fs: support DAX based iomap zeroing
      [8be9f56] fs: iomap based fiemap implementation
      [3b3dce0] xfs: make xfs_bmbt_to_iomap available outside of xfs_pnfs.c
      [f0c6bcb] xfs: reorder zeroing and flushing sequence in truncate
      [68a9f5e] xfs: implement iomap based buffered write path
      [6e8a27a] xfs: remove buffered write support from __xfs_get_blocks
      [d2bb140] xfs: use iomap fiemap implementation
      [459f0fb] xfs: use iomap infrastructure for DAX zeroing
      [7bb41db] xfs: handle 64-bit length in xfs_iozero
      [570b621] xfs: use xfs_zero_range in xfs_zero_eof
      [bdb0d04] xfs: split xfs_free_file_space in manageable pieces
      [3c2bdc9] xfs: kill xfs_zero_remaining_bytes

Darrick J. Wong (6):
      [3f94c44] xfs: check offsets of variable length structures
      [479c641] xfs: enable buffer deadlock postmortem diagnosis via ftrace
      [128f24d] xfs: check for a valid error_tag in errortag_add
      [59bad07] xfs: rearrange xfs_bmap_add_free parameters
      [e66a4c6] xfs: convert list of extents to free into a regular list
      [19b54ee] xfs: refactor btree maxlevels computation

Dave Chinner (4):
      [07931b7] Merge branch 'fs-4.8-iomap-infrastructure' into for-next
      [9b7fad2] Merge branch 'xfs-4.8-iomap-write' into for-next
      [4d89e20] xfs: separate freelist fixing into a separate helper
      [f477ced] Merge branch 'xfs-4.8-misc-fixes-2' into for-next


Code Diffstat:

 fs/Kconfig                     |   3 +
 fs/Makefile                    |   1 +
 fs/buffer.c                    |  76 ++++++-
 fs/internal.h                  |   3 +
 fs/iomap.c                     | 497 +++++++++++++++++++++++++++++++++++++=
+++++++
 fs/nfsd/blocklayout.c          |   1 +
 fs/nfsd/blocklayoutxdr.c       |   1 +
 fs/xfs/Kconfig                 |   1 +
 fs/xfs/libxfs/xfs_alloc.c      |  99 +++++----
 fs/xfs/libxfs/xfs_alloc.h      |   2 +
 fs/xfs/libxfs/xfs_bmap.c       |  51 ++---
 fs/xfs/libxfs/xfs_bmap.h       |  18 +-
 fs/xfs/libxfs/xfs_bmap_btree.c |   2 +-
 fs/xfs/libxfs/xfs_btree.c      |  19 ++
 fs/xfs/libxfs/xfs_btree.h      |   2 +
 fs/xfs/libxfs/xfs_ialloc.c     |  28 +--
 fs/xfs/xfs_aops.c              | 283 ++-----------------------
 fs/xfs/xfs_bmap_util.c         | 375 ++++++++++++++-------------------
 fs/xfs/xfs_bmap_util.h         |   1 -
 fs/xfs/xfs_buf.c               |   8 +-
 fs/xfs/xfs_error.c             |   3 +
 fs/xfs/xfs_file.c              | 193 ++---------------
 fs/xfs/xfs_fsops.c             | 105 ++++++----
 fs/xfs/xfs_icache.c            |   2 +-
 fs/xfs/xfs_icache.h            |   1 +
 fs/xfs/xfs_inode.h             |   3 +-
 fs/xfs/xfs_iomap.c             | 171 +++++++++++++++
 fs/xfs/xfs_iomap.h             |   7 +
 fs/xfs/xfs_iops.c              | 113 ++--------
 fs/xfs/xfs_ondisk.h            |  25 ++-
 fs/xfs/xfs_pnfs.c              |  27 +--
 fs/xfs/xfs_super.c             |  13 +-
 fs/xfs/xfs_trace.h             |   4 +
 include/linux/exportfs.h       |  16 +-
 include/linux/iomap.h          |  70 +++++++
 35 files changed, 1262 insertions(+), 962 deletions(-)
 create mode 100644 fs/iomap.c
 create mode 100644 include/linux/iomap.h
--=20
Dave Chinner
david@fromorbit.com

--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXadvcAAoJEK3oKUf0dfodOCwP/A/v/EkPWznzgoFP5+9f87VO
i+PgKeaupZWg6GqLxvjg2s56RVZXB7nhAfmmssiPaZ/riB7JZvumKedrX7/2E7DY
nkd7/O4nAY6ELW9kHzKsRUkaqzScpNBCrDRfjcGmCRC73sgrh2kfvetY8qgY6iXm
oGUNb7T8IEXHPP6ZSeiP1AsaZjHkoEK/BOwScYHmiVhRfj80+Afd+1wOQh9wNexv
XiRPrJ99oxXbQVLSWkEadu66S0bsvZb1TgV7h43/hsgXDne9JkTJGV/een9sgX2N
Cg+GpHhGbcfpMJCNUtRM0XSRnEuLL3exyab1SefKzJLKo59AkOjziJMN1YNvO8br
EOD18+VGCykwIeBN9PTZa1krHOpkcAFvcoUVQFZRtRey/0EyykK6Vh4f3CNjRPGr
GcqPfIxB2qKhqRCEztoTDYiCb3p4bjiguMfEAz4qK6J/tQptte74X402caISLAbY
0wT9CnupBUUe0ZGUi1x9MI4VcLbBiWnVOW3B9CA6ApJqZzoOXQ++hALXJRX4I8Zs
i+TDowiBwNNL55odniv1XC3Dlm/K4TkItl2ESB1GBr8Qn0c0nCsq93X9muC3NOyu
oba/XwwkMoXcuYH4oNJYDtIS/KZ/rlrUJ/P78Qt72YQ9H0/YoF0mqotGmARl9j/F
vwNcCGRp3mlIFp570ZHq
=ahkn
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--


--===============0140200597207791922==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0140200597207791922==--
