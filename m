Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DFC2D7F4E
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 22:11:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CBE748F8037
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 20:11:02 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	yZ0ZxQgd1UHuxWja for <xfs@oss.sgi.com>;
	Wed, 21 Jan 2015 20:10:57 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1YE94e-0005lv-2k
	for xfs@oss.sgi.com; Thu, 22 Jan 2015 15:08:52 +1100
Date: Thu, 22 Jan 2015 15:08:52 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 438c3c8
Message-ID: <20150122040851.GM16510@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3452081559054643900=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============3452081559054643900==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RASg3xLB4tUQ4RcS"
Content-Disposition: inline


--RASg3xLB4tUQ4RcS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated. Note that this update rebases the
xfs-sb-logging-rework topic branch to correct and on-disk format
handling regression Brian noticed.

Also worth noting: I have stopped mirroring updates to the kernel
tree on oss.sgi.com. I'm about to update the xfs.org wiki to reflect
this.

The new head of the for-next branch is commit:

438c3c8 Merge branch 'xfs-buf-type-fixes' into for-next

New Commits:

Dave Chinner (9):
      [4d11a40] xfs: remove bitfield based superblock updates
      [61e63ec] xfs: consolidate superblock logging functions
      [074e427] xfs: sanitise sb_bad_features2 handling
      [465e2de] Merge branch 'xfs-sb-logging-rework' into for-next
      [0d612fb] xfs: ensure buffer types are set correctly
      [f19b872] xfs: inode unlink does not set AGI buffer type
      [fe22d55] xfs: set buf types when converting extent formats
      [3443a3b] xfs: set superblock buffer type correctly
      [438c3c8] Merge branch 'xfs-buf-type-fixes' into for-next


Code Diffstat:

 fs/xfs/libxfs/xfs_attr_leaf.c      |   2 +-
 fs/xfs/libxfs/xfs_bmap.c           |  20 +--
 fs/xfs/libxfs/xfs_format.h         |  14 +-
 fs/xfs/libxfs/xfs_sb.c             | 320 ++++++++++++++++-----------------=
----
 fs/xfs/libxfs/xfs_sb.h             |  11 +-
 fs/xfs/libxfs/xfs_shared.h         |  33 ++--
 fs/xfs/libxfs/xfs_symlink_remote.c |   2 +
 fs/xfs/libxfs/xfs_trans_resv.c     |  14 --
 fs/xfs/libxfs/xfs_trans_resv.h     |   1 -
 fs/xfs/xfs_buf_item.c              |   4 +
 fs/xfs/xfs_fsops.c                 |  33 +---
 fs/xfs/xfs_inode.c                 |   2 +
 fs/xfs/xfs_log.c                   |  18 ++-
 fs/xfs/xfs_mount.c                 | 106 +++---------
 fs/xfs/xfs_mount.h                 |   5 +-
 fs/xfs/xfs_qm.c                    |  43 +----
 fs/xfs/xfs_qm.h                    |   1 -
 fs/xfs/xfs_qm_syscalls.c           |  14 +-
 fs/xfs/xfs_super.c                 |  13 +-
 fs/xfs/xfs_trans.c                 |   1 +
 20 files changed, 240 insertions(+), 417 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--RASg3xLB4tUQ4RcS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUwHfTAAoJEK3oKUf0dfodrbwQANC2tmFT0tOxI9OR5ZnZ/IR8
tR6RdMiJ0EO4U+caYmZU1QpnUy0YUaB+Nps77cM7//j2+FJjmg+sScHUxvCDqtjE
oJxVEoaQlr04D4Q2Vg9RlYcAErAZyk2qs8TQz23YCpu0azizrID8XHMTmlDdVetN
+QkSu+HGsn2JA5Qs9DW5uMmHf2r1XoODsuFpq9BYU4XkCIqj4Mu6jWTCvxRweWLS
/PiSW6qlxTRVQmdrnXXyaKDJNGQ9JtQHNpbHA06j/X76kA7ZcWzweucB7Mbg+qB1
wxq0ikHpALl5owtPPz5jgyWcxiUhSI+Tup7S3pt3CDvOx5f/M1sTi7IU/10zCK04
gKA40CszFEI3w5gKyzjxBAifuh7KH/S9A3qz5TJx3ktj49XMXGFspIspmM84qIvT
JL+zkwmXsCJvm5Hzn745u0MUJa8EOeyl25E2yp64oNNO1fivQIJEC5PXrAmCMudY
nTkDnbUnIGhxt/Q+gF/PQWSjubvxWHwMd5KmNv0vlYUV+F0sPAChrEGMd4ZXkrLT
QeGu1FPuRVyPt/8d/MoV8qIdB3WXp7no+e1mjkkf7VuaJ7zCYXZSI2pB3FDughNk
qHlqwWNBAfF20VHLEanXDrHIuDrK/j4dK2i9Xc/BKXtlekiU4mxK8vQSLUg6r0in
Z01BIJjv46KqYYtuIlFm
=FikZ
-----END PGP SIGNATURE-----

--RASg3xLB4tUQ4RcS--


--===============3452081559054643900==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3452081559054643900==--
