Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EED6F7F47
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 21:19:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BFD7E304032
	for <xfs@oss.sgi.com>; Mon, 23 Feb 2015 19:19:35 -0800 (PST)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	1HE2oj3D9lQRvzjQ for <xfs@oss.sgi.com>;
	Mon, 23 Feb 2015 19:19:32 -0800 (PST)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1YQ61r-0002hy-QF
	for xfs@oss.sgi.com; Tue, 24 Feb 2015 14:19:23 +1100
Date: Tue, 24 Feb 2015 14:19:23 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 88e8fda
Message-ID: <20150224031923.GY4251@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============3270201340477197804=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============3270201340477197804==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
Content-Disposition: inline


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

I've also updated the master branch to point at v4.0-rc1, so you
should update you current dev trees and post patches against the
updated branch.

The new head of the for-next branch is commit:

88e8fda Merge branch 'xfs-mmap-lock' into for-next

New Commits:

Dave Chinner (19):
      [501ab32] xfs: use generic percpu counters for inode counter
      [e88b64e] xfs: use generic percpu counters for free inode counter
      [0d485ad] xfs: use generic percpu counters for free block counter
      [5681ca4] xfs: Remove icsb infrastructure
      [bab98bb] xfs: introduce xfs_mod_frextents
      [0bd5dde] xfs: replace xfs_mod_incore_sb_batched
      [964aa8d9] xfs: remove xfs_mod_incore_sb API
      [653c60b] xfs: introduce mmap/truncate lock
      [de0e8c2] xfs: use i_mmaplock on read faults
      [075a924] xfs: use i_mmaplock on write faults
      [e8e9ad4] xfs: take i_mmap_lock on extent manipulation operations
      [0f9160b] xfs: xfs_setattr_size no longer races with page faults
      [723cac4] xfs: lock out page faults from extent swap operations
      [5885ebd] xfs: ensure truncate forces zeroed blocks to disk
      [58c9047] xfs: inodes are new until the dentry cache is set up
      [3790a8c] xfs: xfs_alloc_fix_minleft can underflow near ENOSPC
      [3cabb83] Merge branch 'xfs-misc-fixes-for-4.1' into for-next
      [4225441] Merge branch 'xfs-generic-sb-counters' into for-next
      [88e8fda] Merge branch 'xfs-mmap-lock' into for-next

Eric Sandeen (7):
      [c29aad4] xfs: pass mp to XFS_WANT_CORRUPTED_GOTO
      [5fb5aee] xfs: pass mp to XFS_WANT_CORRUPTED_RETURN
      [fc92156] xfs: Ensure we have target_ip for RENAME_EXCHANGE
      [3b9ce79] xfs: log unmount events on console
      [fdadf26] xfs: clarify async write failure ratelimit message
      [83d5f01] xfs: cancel failed transaction in xfs_fs_commit_blocks()
      [444a702] xfs: remove deprecated mount options

Jan Kara (1):
      [dfcc70a] xfs: Fix quota type in quota structures when reusing quota =
file

Wang Sheng-Hui (1):
      [dd5e712] xfs: remove old and redundant comment in xfs_mount_validate=
_sb


Code Diffstat:

 Documentation/filesystems/xfs.txt |  29 +-
 fs/xfs/libxfs/xfs_alloc.c         | 104 +++--
 fs/xfs/libxfs/xfs_bmap.c          | 174 ++++----
 fs/xfs/libxfs/xfs_btree.c         |  24 +-
 fs/xfs/libxfs/xfs_dir2_data.c     |  39 +-
 fs/xfs/libxfs/xfs_format.h        |  62 ---
 fs/xfs/libxfs/xfs_ialloc.c        |  48 +-
 fs/xfs/libxfs/xfs_sb.c            |  20 +-
 fs/xfs/xfs_bmap_util.c            |  31 +-
 fs/xfs/xfs_buf_item.c             |   4 +-
 fs/xfs/xfs_discard.c              |   2 +-
 fs/xfs/xfs_error.h                |   8 +-
 fs/xfs/xfs_file.c                 |  84 +++-
 fs/xfs/xfs_fsops.c                |  20 +-
 fs/xfs/xfs_icache.c               |   4 +-
 fs/xfs/xfs_inode.c                | 154 +++++--
 fs/xfs/xfs_inode.h                |  58 ++-
 fs/xfs/xfs_ioctl.c                |   5 +-
 fs/xfs/xfs_iomap.c                |   3 +-
 fs/xfs/xfs_iops.c                 | 123 ++---
 fs/xfs/xfs_iops.h                 |   2 -
 fs/xfs/xfs_itable.c               |   2 +-
 fs/xfs/xfs_linux.h                |   9 -
 fs/xfs/xfs_log_recover.c          |   4 +-
 fs/xfs/xfs_mount.c                | 918 +++++-----------------------------=
----
 fs/xfs/xfs_mount.h                |  95 +---
 fs/xfs/xfs_pnfs.c                 |   4 +-
 fs/xfs/xfs_qm.c                   |  18 +-
 fs/xfs/xfs_super.c                | 126 ++++--
 fs/xfs/xfs_super.h                |   2 +
 fs/xfs/xfs_symlink.c              |  58 ++-
 fs/xfs/xfs_trace.h                |   3 +
 fs/xfs/xfs_trans.c                | 234 ++++++----
 33 files changed, 925 insertions(+), 1546 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJU6+27AAoJEK3oKUf0dfodi7UQAMZtfZZoEmmnH6RtNOGi22/2
Oka96YufehBHR9exIW6swrAU1Mt8cds3PlSpwaIWlzHIDH3fzvofDqKyRBpTD5UC
XTfkvggQgwjPkNkbsiB3cGYg7/udTbdH2q3kSUeyEei9srP7so4GdJmDy1jnA3D6
nIV0aPARSLtXpC61uO/iG/hiiezjree+qcm5kb23GmYSE/0O7AP8Khm8xLejGtcz
WzpJ1KZ3zPYpaUQF8jl1AY6vhTAzB3RL9US88ZOzyYvFvfAkrLrigsx5+DgHzb4H
Bd9tiMRxD5sFR2J2sDozKmdJK8+b7VDBpLdfv2LaAihAHwjqN8BBAl7YVfXN0vn2
QacgQCNEh1DTmU6QIMtcGa5zzgSc8Mwm2DVp98MqNROOMCxg2tb9yu0Ad7DFAQdW
OURtmOW3Z68shBI4fVU/GLrxjZAu32lAte2pCbfQ1p+bfBFjh99f7Z9hMuYfwlmr
AwLBORNcJ8smRksd7Oi7+gOCxzI4eVHjW9ZxEJjCnXtGr56YT4rHnSOBx2YwMtbn
YsCsP93I8BLrFKIbiK+9eUBOY27WQ16WL2XIxykcV2FL9uZBykRgeBp0mW/909rl
ao8x1MuzidSiPEqzi59mHtglieHHLLe7c1jp3OF+cPsRmSazU/g3HGrGpifVfFPj
023qvAivWf3A0hikSe5h
=4z63
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--


--===============3270201340477197804==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============3270201340477197804==--
