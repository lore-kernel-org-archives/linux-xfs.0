Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id E55097F37
	for <xfs@oss.sgi.com>; Wed, 13 Nov 2013 18:14:13 -0600 (CST)
Subject: [GIT PULL] XFS update for 3.13-rc1
Message-Id: <20131114001409.D79774266DC@whiskey.americas.sgi.com>
Date: Wed, 13 Nov 2013 18:14:09 -0600 (CST)
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

Please pull these XFS updates for 3.13-rc1.  It's kind of a random
assortment.  There is more rearrangement to make libxfs sync with the
kernel, the differences between v2 and v3 were abstracted into an ops
vector, xfs_inactive was reworked, along with the preallocation and hole
punch codepaths.  Plenty of bugfixes, and cleanups too.

Thanks,
	Ben

The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:

  Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-v3.13-rc1

for you to fetch changes up to 359d992bcd398273637cd9edde10afca953783c4:

  xfs: simplify kmem_{zone_}zalloc (2013-11-06 16:31:27 -0600)

----------------------------------------------------------------
xfs: update for v3.13-rc1

For 3.13-rc1 we have an eclectic assortment of bugfixes, cleanups, and
refactoring.  Bugfixes that stand out are the fix for the AGF/AGI
deadlock, incore extent list fixes, verifier fixes for v4 superblocks
and growfs, and memory leaks.  There are some asserts, warnings, and
strings that were cleaned up.  There was further rearrangement of code
to make libxfs and the kernel sync up more easily, differences between
v2 and v3 directory code were abstracted using an ops vector,
xfs_inactive was reworked, and the preallocation/hole punching code was
refactored.

- simplify kmem_zone_zalloc
- add traces for AGF/AGI read ops
- add additional AIL traces
- fix xfs_remove AGF vs AGI deadlock
- fix the extent count of new incore extent page in the indirection array
- don't fail bad secondary superblocks verification on v4 filesystems
  due to unzeroed bits after v4 fields
- fix possible NULL dereference in xlog_verify_iclog
- remove redundant assert in xfs_dir2_leafn_split
- prevent stack overflows from page cache allocation
- fix some sparse warnings
- fix directory block format verifier to check the leaf entry count
- abstract the differences in dir2/dir3 via an ops vector
- continue process of reorganization to make libxfs/kernel code merges easier
- refactor the preallocation and hole punching code
- fix for growfs and verifiers
- remove unnecessary scary corruption error when probing non-xfs filesystems
- remove extra newlines from strings passed to printk
- prevent deadlock trying to cover an active log
- rework xfs_inactive()
- add the inode directory type support to XFS_IOC_FSGEOM
- cleanup (remove) usage of is_bad_inode
- fix miscalculation in xfs_iext_realloc_direct which results in oversized
  direct extent list
- remove unnecessary count arg to xfs_iomap_write_allocate
- fix memory leak in xlog_recover_add_to_trans
- check superblock instead of block magic to determine if dtype field
  is present
- fix lockdep annotation due to project quotas
- fix regression in xfs_node_toosmall which can lead to incorrect directory
  btree node collapse
- make log recovery verify filesystem uuid of recovering blocks
- fix XFS_IOC_FREE_EOFBLOCKS definition
- remove invalid assert in xfs_inode_free
- fix for AIL lock regression

----------------------------------------------------------------
Ben Myers (1):
      xfs: remove usage of is_bad_inode

Brian Foster (4):
      xfs: push down inactive transaction mgmt for remote symlinks
      xfs: push down inactive transaction mgmt for truncate
      xfs: push down inactive transaction mgmt for ifree
      xfs: clean up xfs_inactive() error handling, kill VN_INACTIVE_[NO]CACHE

Christoph Hellwig (5):
      xfs: always take the iolock around xfs_setattr_size
      xfs: remove the unused XFS_ATTR_NONBLOCK flag
      xfs: always hold the iolock when calling xfs_change_file_space
      xfs: simplify the fallocate path
      xfs: fold xfs_change_file_space into xfs_ioc_space

Dave Chinner (30):
      xfs: lock the AIL before removing the buffer item
      xfs: asserting lock not held during freeing not valid
      xfs: fix XFS_IOC_FREE_EOFBLOCKS definition
      xfs: log recovery lsn ordering needs uuid check
      xfs: lockdep needs to know about 3 dquot-deep nesting
      xfs: dirent dtype presence is dependent on directory magic numbers
      xfs: prevent deadlock trying to cover an active log
      xfs: create a shared header file for format-related information
      xfs: unify directory/attribute format definitions
      xfs: split dquot buffer operations out
      xfs: remove unused transaction callback variables
      xfs: decouple log and transaction headers
      xfs: decouple inode and bmap btree header files
      xfs: split xfs_rtalloc.c for userspace sanity
      xfs: abstract the differences in dir2/dir3 via an ops vector
      xfs: vectorise remaining shortform dir2 ops
      xfs: vectorise directory data operations
      xfs: vectorise directory data operations part 2
      xfs: vectorise directory leaf operations
      xfs: vectorise DA btree operations
      xfs: vectorise encoding/decoding directory headers
      xfs: convert directory vector functions to constants
      xfs: convert directory vector functions to constants
      xfs: make dir2 ftype offset pointers explicit
      xfs: validity check the directory block leaf entry count
      xfs: fix static and extern sparse warnings
      xfs: prevent stack overflows from page cache allocation
      xfs: xfs_remove deadlocks due to inverted AGF vs AGI lock ordering
      xfs: trace AIL manipulations
      xfs: add tracepoints to AGF/AGI read operations

Denis Efremov (1):
      xfs:xfs_dir2_node.c: pointer use before check for null

Eric Sandeen (4):
      xfs: remove newlines from strings passed to __xfs_printk
      xfs: don't emit corruption noise on fs probes
      xfs: don't break from growfs ag update loop on error
      xfs: be more forgiving of a v4 secondary sb w/ junk in v5 fields

Geyslan G. Bem (1):
      xfs: fix possible NULL dereference in xlog_verify_iclog

Gu Zheng (1):
      xfs: simplify kmem_{zone_}zalloc

Jie Liu (3):
      xfs: get rid of count from xfs_iomap_write_allocate()
      xfs: fix the wrong new_size/rnew_size at xfs_iext_realloc_direct()
      xfs: fix the extent count when allocating an new indirection array entry

Mark Tinguely (2):
      xfs: fix node forward in xfs_node_toosmall
      xfs: add the inode directory type support to XFS_IOC_FSGEOM

Thierry Reding (1):
      xfs: Use kmem_free() instead of free()

tinguely@sgi.com (1):
      xfs: fix memory leak in xlog_recover_add_to_trans

 fs/xfs/Makefile                               |    8 +-
 fs/xfs/kmem.c                                 |   22 -
 fs/xfs/kmem.h                                 |   21 +-
 fs/xfs/xfs_acl.c                              |    8 +-
 fs/xfs/xfs_ag.h                               |    4 -
 fs/xfs/xfs_alloc.c                            |   19 +-
 fs/xfs/xfs_alloc.h                            |    3 -
 fs/xfs/xfs_alloc_btree.c                      |   14 +-
 fs/xfs/xfs_alloc_btree.h                      |   35 -
 fs/xfs/xfs_aops.c                             |   16 +-
 fs/xfs/xfs_attr.c                             |   12 +-
 fs/xfs/xfs_attr_inactive.c                    |   21 +-
 fs/xfs/xfs_attr_leaf.c                        |   29 +-
 fs/xfs/xfs_attr_leaf.h                        |  232 ----
 fs/xfs/xfs_attr_list.c                        |   32 +-
 fs/xfs/xfs_attr_remote.c                      |   14 +-
 fs/xfs/xfs_attr_remote.h                      |   29 -
 fs/xfs/xfs_bit.c                              |    4 +-
 fs/xfs/xfs_bmap.c                             |   22 +-
 fs/xfs/xfs_bmap_btree.c                       |   13 +-
 fs/xfs/xfs_bmap_btree.h                       |  105 --
 fs/xfs/xfs_bmap_util.c                        |  293 +---
 fs/xfs/xfs_bmap_util.h                        |    9 +-
 fs/xfs/xfs_btree.c                            |   12 +-
 fs/xfs/xfs_btree.h                            |   79 +-
 fs/xfs/xfs_buf.c                              |   11 +-
 fs/xfs/xfs_buf_item.c                         |   10 +-
 fs/xfs/xfs_buf_item.h                         |    4 -
 fs/xfs/xfs_da_btree.c                         |  267 ++--
 fs/xfs/xfs_da_btree.h                         |  143 +-
 fs/xfs/xfs_da_format.c                        |  907 ++++++++++++
 fs/xfs/{xfs_dir2_format.h => xfs_da_format.h} |  692 ++++-----
 fs/xfs/xfs_dir2.c                             |   20 +-
 fs/xfs/xfs_dir2.h                             |  106 +-
 fs/xfs/xfs_dir2_block.c                       |  109 +-
 fs/xfs/xfs_dir2_data.c                        |  161 ++-
 fs/xfs/xfs_dir2_leaf.c                        |  243 ++--
 fs/xfs/xfs_dir2_node.c                        |  351 +++--
 fs/xfs/xfs_dir2_priv.h                        |   20 +-
 fs/xfs/xfs_dir2_readdir.c                     |   42 +-
 fs/xfs/xfs_dir2_sf.c                          |  216 +--
 fs/xfs/xfs_discard.c                          |   11 +-
 fs/xfs/xfs_dquot.c                            |  152 +-
 fs/xfs/xfs_dquot.h                            |    2 -
 fs/xfs/xfs_dquot_buf.c                        |  288 ++++
 fs/xfs/xfs_dquot_item.c                       |   14 +-
 fs/xfs/xfs_error.c                            |   11 +-
 fs/xfs/xfs_export.c                           |   12 +-
 fs/xfs/xfs_extent_busy.c                      |   11 +-
 fs/xfs/xfs_extent_busy.h                      |    4 +
 fs/xfs/xfs_extfree_item.c                     |    8 +-
 fs/xfs/xfs_file.c                             |   92 +-
 fs/xfs/xfs_filestream.c                       |   12 +-
 fs/xfs/xfs_format.h                           |  263 +++-
 fs/xfs/xfs_fs.h                               |    6 +-
 fs/xfs/xfs_fsops.c                            |   45 +-
 fs/xfs/xfs_ialloc.c                           |   20 +-
 fs/xfs/xfs_ialloc.h                           |    5 +-
 fs/xfs/xfs_ialloc_btree.c                     |   13 +-
 fs/xfs/xfs_ialloc_btree.h                     |   51 -
 fs/xfs/xfs_icache.c                           |   29 +-
 fs/xfs/xfs_icreate_item.c                     |    7 +-
 fs/xfs/xfs_inode.c                            |  338 +++--
 fs/xfs/xfs_inode.h                            |    6 +-
 fs/xfs/xfs_inode_buf.c                        |   10 +-
 fs/xfs/xfs_inode_buf.h                        |    3 -
 fs/xfs/xfs_inode_fork.c                       |   40 +-
 fs/xfs/xfs_inode_fork.h                       |    1 +
 fs/xfs/xfs_inode_item.c                       |   12 +-
 fs/xfs/xfs_ioctl.c                            |  146 +-
 fs/xfs/xfs_ioctl32.c                          |    7 +-
 fs/xfs/xfs_iomap.c                            |   23 +-
 fs/xfs/xfs_iomap.h                            |    8 +-
 fs/xfs/xfs_iops.c                             |   70 +-
 fs/xfs/xfs_iops.h                             |    8 +-
 fs/xfs/xfs_itable.c                           |   15 +-
 fs/xfs/xfs_log.c                              |   75 +-
 fs/xfs/xfs_log.h                              |   10 +-
 fs/xfs/xfs_log_cil.c                          |   26 +-
 fs/xfs/xfs_log_format.h                       |  177 ---
 fs/xfs/xfs_log_priv.h                         |   17 +-
 fs/xfs/xfs_log_recover.c                      |  245 ++--
 fs/xfs/xfs_log_rlimit.c                       |    9 +-
 fs/xfs/xfs_message.c                          |    5 +-
 fs/xfs/xfs_mount.c                            |   21 +-
 fs/xfs/xfs_mount.h                            |    3 +
 fs/xfs/xfs_qm.c                               |   39 +-
 fs/xfs/xfs_qm.h                               |    2 -
 fs/xfs/xfs_qm_bhv.c                           |   12 +-
 fs/xfs/xfs_qm_syscalls.c                      |   28 +-
 fs/xfs/xfs_quota.h                            |    4 -
 fs/xfs/xfs_quota_defs.h                       |    4 +
 fs/xfs/xfs_quotaops.c                         |    5 +-
 fs/xfs/xfs_rtalloc.c                          | 1848 ++++++-------------------
 fs/xfs/xfs_rtalloc.h                          |   24 +
 fs/xfs/xfs_rtbitmap.c                         |  974 +++++++++++++
 fs/xfs/xfs_sb.c                               |   46 +-
 fs/xfs/xfs_sb.h                               |    3 -
 fs/xfs/xfs_shared.h                           |  244 ++++
 fs/xfs/xfs_super.c                            |   38 +-
 fs/xfs/xfs_symlink.c                          |  102 +-
 fs/xfs/xfs_symlink.h                          |    2 +-
 fs/xfs/xfs_symlink_remote.c                   |    6 +-
 fs/xfs/xfs_trace.c                            |   16 +-
 fs/xfs/xfs_trace.h                            |   84 +-
 fs/xfs/xfs_trans.c                            |   23 +-
 fs/xfs/xfs_trans.h                            |   20 +-
 fs/xfs/xfs_trans_ail.c                        |   10 +-
 fs/xfs/xfs_trans_buf.c                        |   12 +-
 fs/xfs/xfs_trans_dquot.c                      |   15 +-
 fs/xfs/xfs_trans_extfree.c                    |    7 +-
 fs/xfs/xfs_trans_inode.c                      |   13 +-
 fs/xfs/xfs_trans_priv.h                       |    1 -
 fs/xfs/xfs_trans_resv.c                       |   18 +-
 fs/xfs/xfs_vnode.h                            |    8 -
 fs/xfs/xfs_xattr.c                            |    8 +-
 116 files changed, 5441 insertions(+), 4864 deletions(-)
 create mode 100644 fs/xfs/xfs_da_format.c
 rename fs/xfs/{xfs_dir2_format.h => xfs_da_format.h} (60%)
 create mode 100644 fs/xfs/xfs_dquot_buf.c
 create mode 100644 fs/xfs/xfs_rtbitmap.c
 create mode 100644 fs/xfs/xfs_shared.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
