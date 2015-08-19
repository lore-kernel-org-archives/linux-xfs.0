Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 868357F6F
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 02:25:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 687968F8040
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2015 00:25:21 -0700 (PDT)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	iWYFxgt5mjpgfFLB for <xfs@oss.sgi.com>;
	Wed, 19 Aug 2015 00:25:17 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ZRxji-0005h9-DH
	for xfs@oss.sgi.com; Wed, 19 Aug 2015 17:24:38 +1000
Date: Wed, 19 Aug 2015 17:24:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to 5bb05d5
Message-ID: <20150819072438.GQ714@dastard>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: multipart/mixed; boundary="===============4637742027236463553=="
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com


--===============4637742027236463553==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8NvZYKFJsRX2Djef"
Content-Disposition: inline


--8NvZYKFJsRX2Djef
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

5bb05d5 Merge branch 'xfs-misc-fixes-for-4.3-2' into for-next

New Commits:

Brian Foster (16):
      [5e4b538] xfs: disentagle EFI release from the extent count
      [d43ac29] xfs: return committed status from xfs_trans_roll()
      [8d99fe9] xfs: fix efi/efd error handling to avoid fs shutdown hangs
      [6bc43af] xfs: ensure EFD trans aborts on log recovery extent free fa=
ilure
      [e32a1d1] xfs: use EFI refcount consistently in log recovery
      [f0b2efa] xfs: don't leave EFIs on AIL on mount failure
      [78d57e4] xfs: icreate log item recovery and cancellation tracepoints
      [fc0d165] xfs: fix broken icreate log item cancellation
      [a3f2001] xfs: checksum log record ext headers based on record size
      [0ae120f] xfs: clean up root inode properly on mount failure
      [f307080] xfs: fix btree cursor error cleanups
      [146e54b] xfs: add helper to conditionally remove items from the AIL
      [d4a97a0] xfs: add missing bmap cancel calls in error paths
      [1b867d3] xfs: relocate sparse inode mount warning
      [7df1c17] xfs: swap leaf buffer into path struct atomically during pa=
th shift
      [3d751af] xfs: flush entire file on dio read/write to cached file

Darrick J. Wong (1):
      [2f123bc] libxfs: readahead of dir3 data blocks should use the read v=
erifier

Dave Chinner (8):
      [5be203a] Merge branch 'xfs-efi-rework' into for-next
      [bbf155a] xfs: fix sb_meta_uuid usage
      [ac383de] xfs: growfs not aware of sb_meta_uuid
      [fcfbe2c] xfs: log recovery needs to validate against sb_meta_uuid
      [9286345] xfs: dquots should be stamped with sb_meta_uuid
      [0952c81] xfs: clean up inode lockdep annotations
      [dbad7c9] xfs: stop holding ILOCK over filldir callbacks
      [5bb05d5] Merge branch 'xfs-misc-fixes-for-4.3-2' into for-next

Eric Sandeen (1):
      [c400ee3] xfs: set XFS_DA_OP_OKNOENT in xfs_attr_get

Jan Kara (1):
      [ffeecc5] xfs: Fix xfs_attr_leafblock definition


Code Diffstat:

 fs/xfs/libxfs/xfs_attr.c      |   2 +
 fs/xfs/libxfs/xfs_bmap.c      |   1 +
 fs/xfs/libxfs/xfs_da_btree.c  |  23 +++---
 fs/xfs/libxfs/xfs_da_format.h |  11 ++-
 fs/xfs/libxfs/xfs_dir2.c      |   3 +
 fs/xfs/libxfs/xfs_dir2_data.c |   3 +-
 fs/xfs/libxfs/xfs_ialloc.c    |   2 +-
 fs/xfs/libxfs/xfs_sb.c        |   3 -
 fs/xfs/xfs_bmap_util.c        |  87 +++++++++++---------
 fs/xfs/xfs_buf_item.c         |   6 +-
 fs/xfs/xfs_dir2_readdir.c     |  11 ++-
 fs/xfs/xfs_dquot.c            |  10 +--
 fs/xfs/xfs_extfree_item.c     | 105 ++++++++++--------------
 fs/xfs/xfs_extfree_item.h     |  26 +++++-
 fs/xfs/xfs_file.c             |  51 ++++++------
 fs/xfs/xfs_fsops.c            |   6 +-
 fs/xfs/xfs_inode.c            | 113 ++++++++++++++++++--------
 fs/xfs/xfs_inode.h            |  85 ++++++++++++++------
 fs/xfs/xfs_inode_item.c       |  11 +--
 fs/xfs/xfs_itable.c           |   3 +-
 fs/xfs/xfs_log.c              |  37 +++++++--
 fs/xfs/xfs_log.h              |   1 +
 fs/xfs/xfs_log_priv.h         |   2 +
 fs/xfs/xfs_log_recover.c      | 180 ++++++++++++++++++++++++++++++++------=
----
 fs/xfs/xfs_mount.c            |  28 ++++---
 fs/xfs/xfs_rtalloc.c          |  57 ++++++-------
 fs/xfs/xfs_super.c            |   4 +
 fs/xfs/xfs_symlink.c          |   7 +-
 fs/xfs/xfs_trace.h            |  34 ++++++++
 fs/xfs/xfs_trans.c            |  15 +++-
 fs/xfs/xfs_trans.h            |   9 +--
 fs/xfs/xfs_trans_extfree.c    |  32 +++++---
 fs/xfs/xfs_trans_priv.h       |  15 ++++
 33 files changed, 643 insertions(+), 340 deletions(-)
--=20
Dave Chinner
david@fromorbit.com

--8NvZYKFJsRX2Djef
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJV1C81AAoJEK3oKUf0dfodDLQP+wanj0zTmwKbhsRwliIkw7YC
bkZAVVfU/j6x6tWIwqiBeJVWuhDU8DRH3GKn5V2wrrOkMSDgirVhUhsff5jsCCRS
Rtm/PIdXyklrYzAOXtSF4L8Hy+jVYRPho53uYl/SaYQttHBqjBMlr2BclcuKKQPD
tA2L9gVyJYWGsdW8VwY7TsOEx5UIJfJsaT4BiRdt/XkLi15gKhMmtF4Ao0mKgIrz
bzrf1IhgKNP9q2WfuF4X8KdlfkW/QalUt+AoIbRGmjLbSGSJmRAylDgUBcubcyDe
TnAwpaqw8G08/0KWcwPqQDvfMfDY+vLtrwFUBa6YlJ3mn/tINVIHg46VtY4ErZzl
zBBbWJyUxQFO6meuhxFGj3KnczCXN9Gdcx5Yk+HguAXrCkz/9x6V8VwJi9Bh1Mn0
ecvz4yWBPmwJ1+f+16KTzdFl7HAetnEK4PJYaZlUAXJykwVG+/DyDiVC5EEoIF+d
kEMXmADvr++cpULQgDQP0+0wZXwHOz/eUaOKCX1ZhA8Z0pgwkxarAF8BZBvEtdbn
eeRrt9REbzOVLrNyu5XXQUFc7oqusHRmS38T3X3DnMxPGiYS4UnhcamM94Fbl4Bi
VbLTC+prn/CydFY3P8hifIq6Log0Ig/Eu4gH9NMBZVqJVCjAMrfVP/T4FN5VCojd
oXWpisbYj6gjfIsYL/6A
=pTYB
-----END PGP SIGNATURE-----

--8NvZYKFJsRX2Djef--


--===============4637742027236463553==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============4637742027236463553==--
