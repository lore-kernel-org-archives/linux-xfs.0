Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1CD787F5A
	for <xfs@oss.sgi.com>; Tue,  9 Jul 2013 14:15:10 -0500 (CDT)
Subject: [GIT PULL] XFS update for 3.11-rc1
Message-Id: <20130709191509.49A24500B4B@whiskey.americas.sgi.com>
Date: Tue,  9 Jul 2013 14:15:09 -0500 (CDT)
From: bpm@sgi.com (Ben Myers)
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

   Please pull these XFS updates for 3.11-rc1.  This includes several bugfixes,
   part of the work for project quotas and group quotas to be used together,
   performance improvements for inode creation/deletion, buffer readahead, and
   bulkstat, implementation of the inode change count, an inode create
   transaction, and the removal of a bunch of dead code.  There are also some
   duplicate commits that you already have from the 3.10-rc series.

Thanks,
	Ben

The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:

  Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/for-linus-v3.11-rc1

for you to fetch changes up to 83e782e1a1cc0159888e58e14dfc8f3289663338:

  xfs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD (2013-06-28 17:39:22 -0500)

----------------------------------------------------------------
xfs: update for 3.11-rc1

- part of the work to allow project quotas and group quotas to
  be used together
- inode change count
- inode create transaction
- block queue plugging in buffer readahead and bulkstat
- ordered log vector support
- removal of dead code in and around xfs_sync_inode_grab,
  xfs_ialloc_get_rec, XFS_MOUNT_RETERR, XFS_ALLOCFREE_LOG_RES,
  XFS_DIROP_LOG_RES, xfs_chash, ctl_table, and xfs_growfs_data_private
- don't keep silent if sunit/swidth can not be changed via mount
- fix a leak of remote symlink blocks into the filesystem when
  xattrs are used on symlinks
- fix for fiemap to return FIEMAP_EXTENT_UNKOWN flag on delay extents
- part of a fix for xfs_fsr
- disable speculative preallocation with small files
- performance improvements for inode creates and deletes

----------------------------------------------------------------
Chandra Seetharaman (6):
      xfs: Define a new function xfs_is_quota_inode()
      xfs: Replace macro XFS_DQUOT_TREE with a function
      xfs: Replace macro XFS_DQ_TO_QIP with a function
      xfs: Code cleanup and removal of some typedef usage
      xfs: Change xfs_dquot_acct to be a 2-dimensional array
      xfs: Remove incore use of XFS_OQUOTA_ENFD and XFS_OQUOTA_CHKD

Dave Chinner (43):
      xfs: fix sub-page blocksize data integrity writes
      xfs: fix rounding in xfs_free_file_space
      xfs: Don't reference the EFI after it is freed
      xfs: fix missing KM_NOFS tags to keep lockdep happy
      xfs: xfs_da3_node_read_verify() doesn't handle XFS_ATTR3_LEAF_MAGIC
      xfs: xfs_attr_shortform_allfit() does not handle attr3 format.
      xfs: remote attribute lookups require the value length
      xfs: avoid nesting transactions in xfs_qm_scall_setqlim()
      xfs: remote attribute allocation may be contiguous
      xfs: remote attribute read too short
      xfs: remote attribute tail zeroing does too much
      xfs: correctly map remote attr buffers during removal
      xfs: fully initialise temp leaf in xfs_attr3_leaf_unbalance
      xfs: fully initialise temp leaf in xfs_attr3_leaf_compact
      xfs: rework remote attr CRCs
      xfs: don't emit v5 superblock warnings on write
      xfs: fix incorrect remote symlink block count
      xfs: fix split buffer vector log recovery support
      xfs: disable swap extents ioctl on CRC enabled filesystems
      xfs: add fsgeom flag for v5 superblock support.
      xfs: kill suid/sgid through the truncate path.
      xfs: fix dir3 freespace block corruption
      xfs: rework dquot CRCs
      xfs: fix remote attribute invalidation for a leaf
      xfs: fix log recovery transaction item reordering
      xfs: inode unlinked list needs to recalculate the inode CRC
      xfs: disable noattr2/attr2 mount options for CRC enabled filesystems
      xfs: increase number of ACL entries for V5 superblocks
      xfs: fix implicit padding in directory and attr CRC formats
      xfs: ensure btree root split sets blkno correctly
      xfs: don't shutdown log recovery on validation errors
      xfs: add pluging for bulkstat readahead
      xfs: plug directory buffer readahead
      xfs: don't use speculative prealloc for small files
      xfs: don't do IO when creating an new inode
      xfs: xfs_ifree doesn't need to modify the inode buffer
      xfs: Introduce ordered log vector support
      xfs: Introduce an ordered buffer item
      xfs: Inode create log items
      xfs: Inode create transaction reservations
      xfs: Inode create item recovery
      xfs: Use inode create transaction
      xfs: implement inode change count

Eric Sandeen (1):
      xfs: check on-disk (not incore) btree root size in dfrag.c

Jan Kara (1):
      xfs: Avoid pathological backwards allocation

Jeff Liu (1):
      xfs: Remove struct xfs_chash from xfs_mount

Jie Liu (7):
      xfs: Remove redundant error variable from xfs_growfs_data_private()
      xfs: Don't keep silent if sunit/swidth can not be changed via mount
      xfs: return FIEMAP_EXTENT_UNKNOWN for delayed allocation extent
      xfs: Remove two dead transaction log reservaion macros
      xfs: Remove XFS_MOUNT_RETERR
      xfs: Remove the left function variable from xfs_ialloc_get_rec()
      xfs: Remove dead function prototype xfs_sync_inode_grab()

Joe Perches (1):
      xfs: Convert use of typedef ctl_table to struct ctl_table

Mark Tinguely (1):
      xfs: fix the symbolic link assert in xfs_ifree

 Documentation/filesystems/xfs.txt |   3 +
 fs/xfs/Makefile                   |   1 +
 fs/xfs/xfs_acl.c                  |  31 +--
 fs/xfs/xfs_acl.h                  |  31 ++-
 fs/xfs/xfs_alloc.c                |  24 ++-
 fs/xfs/xfs_aops.c                 |  19 ++
 fs/xfs/xfs_attr_leaf.c            |  98 +++++----
 fs/xfs/xfs_attr_leaf.h            |   1 +
 fs/xfs/xfs_attr_remote.c          | 408 +++++++++++++++++++++++---------------
 fs/xfs/xfs_attr_remote.h          |  10 +
 fs/xfs/xfs_bmap_btree.h           |   2 +
 fs/xfs/xfs_btree.c                |  10 +
 fs/xfs/xfs_buf.c                  |   3 +-
 fs/xfs/xfs_buf_item.c             |  94 +++++----
 fs/xfs/xfs_buf_item.h             |   4 +-
 fs/xfs/xfs_da_btree.c             |   7 +-
 fs/xfs/xfs_dfrag.c                |  16 +-
 fs/xfs/xfs_dir2_format.h          |   4 +-
 fs/xfs/xfs_dir2_leaf.c            |   5 +-
 fs/xfs/xfs_dir2_node.c            |  13 +-
 fs/xfs/xfs_dquot.c                |  53 +++--
 fs/xfs/xfs_dquot.h                |   4 -
 fs/xfs/xfs_extfree_item.c         |   5 +-
 fs/xfs/xfs_fs.h                   |   1 +
 fs/xfs/xfs_fsops.c                |   6 +-
 fs/xfs/xfs_ialloc.c               |  74 +++++--
 fs/xfs/xfs_ialloc.h               |   8 +
 fs/xfs/xfs_icache.c               |   3 +-
 fs/xfs/xfs_icache.h               |   1 -
 fs/xfs/xfs_icreate_item.c         | 195 ++++++++++++++++++
 fs/xfs/xfs_icreate_item.h         |  52 +++++
 fs/xfs/xfs_inode.c                |  84 ++++----
 fs/xfs/xfs_iomap.c                |  13 ++
 fs/xfs/xfs_iops.c                 |  50 +++--
 fs/xfs/xfs_itable.c               |   5 +-
 fs/xfs/xfs_log.c                  |  22 +-
 fs/xfs/xfs_log.h                  |   5 +-
 fs/xfs/xfs_log_cil.c              |  77 ++++---
 fs/xfs/xfs_log_recover.c          | 218 +++++++++++++++++++-
 fs/xfs/xfs_mount.c                | 110 +++++++---
 fs/xfs/xfs_mount.h                |   4 -
 fs/xfs/xfs_qm.c                   | 215 +++++++++++---------
 fs/xfs/xfs_qm.h                   |  83 +++++---
 fs/xfs/xfs_qm_syscalls.c          |  91 +++++----
 fs/xfs/xfs_quota.h                |  49 +++--
 fs/xfs/xfs_quotaops.c             |   6 +-
 fs/xfs/xfs_sb.h                   |   6 +
 fs/xfs/xfs_super.c                |  50 +++--
 fs/xfs/xfs_symlink.c              |  71 +++++--
 fs/xfs/xfs_symlink.h              |   2 +-
 fs/xfs/xfs_sysctl.c               |  26 +--
 fs/xfs/xfs_trace.h                |   5 +
 fs/xfs/xfs_trans.c                | 118 +++++++----
 fs/xfs/xfs_trans.h                |  16 +-
 fs/xfs/xfs_trans_buf.c            |  34 +++-
 fs/xfs/xfs_trans_dquot.c          |  87 ++++----
 fs/xfs/xfs_trans_inode.c          |  11 +
 fs/xfs/xfs_vnodeops.c             |  19 +-
 58 files changed, 1859 insertions(+), 804 deletions(-)
 create mode 100644 fs/xfs/xfs_icreate_item.c
 create mode 100644 fs/xfs/xfs_icreate_item.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
