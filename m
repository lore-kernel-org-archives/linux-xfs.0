Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DFFC47CA0
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2016 20:29:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 46A1AAC003
	for <xfs@oss.sgi.com>; Tue,  5 Apr 2016 18:29:46 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	e95Eq7a379VlTVE8 for <xfs@oss.sgi.com>;
	Tue, 05 Apr 2016 18:29:41 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.80)
	(envelope-from <david@fromorbit.com>) id 1ancHq-0003U6-E6
	for xfs@oss.sgi.com; Wed, 06 Apr 2016 11:29:38 +1000
Date: Wed, 6 Apr 2016 11:29:38 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [ANNOUNCE] xfs: for-next branch updated to d8bdd04
Message-ID: <20160406012938.GI11238@dastard>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi folks,

The for-next branch of the xfs kernel repository at

git://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git

has just been updated.

The new head of the for-next branch is commit:

d8bdd04 Merge branch 'xfs-4.7-misc-fixes' into for-next

New Commits:

Carlos Maiolino (1):
      [9f27889] xfs: Add caller function output to xfs_log_force tracepoint

Christoph Hellwig (8):
      [143f4ae] xfs: factor out a helper to initialize a local format inode fork
      [2b3d1d4] xfs: set up inode operation vectors later
      [bfe8804] xfs: use ->readlink to implement the readlink_by_handle ioctl
      [30ee052] xfs: optimize inline symlinks
      [0e51a8e] xfs: optimize bio handling in the buffer writeback path
      [253f491] xfs: better xfs_trans_alloc interface
      [710b1e2] xfs: remove transaction types
      [664b60f] xfs: improve kmem_realloc

Dave Chinner (8):
      [ad747e3] xfs: Don't wrap growfs AGFL indexes
      [bb18782] xfs: build bios directly in xfs_add_to_ioend
      [37992c1] xfs: don't release bios on completion immediately
      [f0634af] Merge branch 'xfs-4.7-writeback-bio' into for-next
      [1347070] Merge branch 'xfs-4.7-trans-type-cleanup' into for-next
      [14e3103] Merge branch 'xfs-4.7-optimise-inline-symlinks' into for-next
      [615c175] Merge branch 'xfs-4.7-cleanup-attr-listent' into for-next
      [d8bdd04] Merge branch 'xfs-4.7-misc-fixes' into for-next

Eric Sandeen (5):
      [d0a58e8] xfs: disallow rw remount on fs with unknown ro-compat features
      [2a6fba6] xfs: only return -errno or success from attr ->put_listent
      [e5bd12b] xfs: don't pass value into attr ->put_listent
      [7af5ad2] xfs: remove put_value from attr ->put_listent context
      [3ab3ffc] xfs: collapse cases in xfs_attr3_leaf_list_int

Eryu Guan (2):
      [ce5c767] xfs: add missing break in xfs_parseargs()
      [6e3e6d5] xfs: mute some sparse warnings


Code Diffstat:

 fs/namei.c                     |   1 -
 fs/xfs/kmem.c                  |  26 ++--
 fs/xfs/kmem.h                  |   2 +-
 fs/xfs/libxfs/xfs_attr.c       |  58 ++-----
 fs/xfs/libxfs/xfs_bmap.c       |  22 ++-
 fs/xfs/libxfs/xfs_dir2_sf.c    |   9 +-
 fs/xfs/libxfs/xfs_inode_fork.c |  72 ++++++---
 fs/xfs/libxfs/xfs_inode_fork.h |   1 +
 fs/xfs/libxfs/xfs_log_format.h |   5 +
 fs/xfs/libxfs/xfs_sb.c         |   8 +-
 fs/xfs/libxfs/xfs_shared.h     | 102 +------------
 fs/xfs/xfs_aops.c              | 354 +++++++++++++++++++++----------------------
 fs/xfs/xfs_aops.h              |  15 +-
 fs/xfs/xfs_attr.h              |   4 +-
 fs/xfs/xfs_attr_inactive.c     |  16 +-
 fs/xfs/xfs_attr_list.c         |  85 ++++-------
 fs/xfs/xfs_bmap_util.c         |  45 ++----
 fs/xfs/xfs_dquot.c             |   9 +-
 fs/xfs/xfs_file.c              |   8 +-
 fs/xfs/xfs_fsops.c             |  14 +-
 fs/xfs/xfs_inode.c             |  63 +++-----
 fs/xfs/xfs_inode.h             |   5 +-
 fs/xfs/xfs_inode_item.c        |   6 +-
 fs/xfs/xfs_ioctl.c             |  31 +---
 fs/xfs/xfs_iomap.c             |  53 +++----
 fs/xfs/xfs_iops.c              | 117 ++++++++------
 fs/xfs/xfs_log.c               |  62 +-------
 fs/xfs/xfs_log.h               |   3 +-
 fs/xfs/xfs_log_cil.c           |   1 -
 fs/xfs/xfs_log_priv.h          |   1 -
 fs/xfs/xfs_log_recover.c       |  12 +-
 fs/xfs/xfs_mount.c             |   1 -
 fs/xfs/xfs_pnfs.c              |   7 +-
 fs/xfs/xfs_qm.c                |   9 +-
 fs/xfs/xfs_qm_syscalls.c       |  26 +---
 fs/xfs/xfs_rtalloc.c           |  21 ++-
 fs/xfs/xfs_super.c             |  37 ++---
 fs/xfs/xfs_symlink.c           |  37 ++---
 fs/xfs/xfs_trace.h             |  15 +-
 fs/xfs/xfs_trans.c             |  88 +++++------
 fs/xfs/xfs_trans.h             |   8 +-
 fs/xfs/xfs_xattr.c             |  17 ++-
 42 files changed, 594 insertions(+), 882 deletions(-)
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
