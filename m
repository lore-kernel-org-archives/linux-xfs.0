Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 87AB27F8D
	for <xfs@oss.sgi.com>; Wed, 22 Jan 2014 15:01:41 -0600 (CST)
Subject: [GIT PULL] XFS updates for 3.14-rc1
Message-Id: <20140122210137.1FC224266DC@whiskey.americas.sgi.com>
Date: Wed, 22 Jan 2014 15:01:37 -0600 (CST)
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

   Please pull these XFS updates for 3.14-rc1.  This is primarily bug fixes,
   many of which you already have.  New stuff includes a series to decouple the
   in-memory and on-disk log format, helpers in the area of inode clusters, and
   i_version handling.

   We decided to try to use more topic branches this release, so there are some
   merge commits in there on account of that.  I'm afraid I didn't do a good
   job of putting meaningful comments in the first couple of merges.  Sorry
   about that.  I think I have the hang of it now.

Thanks,
     Ben	

The following changes since commit dc1ccc48159d63eca5089e507c82c7d22ef60839:

  Linux 3.13-rc2 (2013-11-29 12:57:14 -0800)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs.git tags/xfs-for-linus-v3.14-rc1

for you to fetch changes up to bf3964c188d686424ff7b69a45941851b9f437f0:

  Merge branch 'xfs-extent-list-locking-fixes' into for-next (2014-01-09 16:03:18 -0600)

----------------------------------------------------------------

xfs: update for v3.14-rc1

For 3.14-rc1 there are fixes in the areas of remote attributes, discard,
growfs, memory leaks in recovery, directory v2, quotas, the MAINTAINERS
file, allocation alignment, extent list locking, and in
xfs_bmapi_allocate.  There are cleanups in xfs_setsize_buftarg, removing
unused macros, quotas, setattr, and freeing of inode clusters.  The
in-memory and on-disk log format have been decoupled, a common helper to
calculate the number of blocks in an inode cluster has been added, and
handling of i_version has been pulled into the filesystems that use it.

- cleanup in xfs_setsize_buftarg
- removal of remaining unused flags for vop toss/flush/flushinval
- fix for memory corruption in xfs_attrlist_by_handle
- fix for out-of-date comment in xfs_trans_dqlockedjoin
- fix for discard if range length is less than one block
- fix for overrun of agfl buffer using growfs on v4 superblock filesystems
- pull i_version handling out into the filesystems that use it
- don't leak recovery items on error
- fix for memory leak in xfs_dir2_node_removename
- several cleanups for quotas
- fix bad assertion in xfs_qm_vop_create_dqattach
- cleanup for xfs_setattr_mode, and add xfs_setattr_time
- fix quota assert in xfs_setattr_nonsize
- fix an infinite loop when turning off group/project quota before user
  quota
- fix for temporary buffer allocation failure in xfs_dir2_block_to_sf
  with large directory block sizes
- fix Dave's email address in MAINTAINERS
- cleanup calculation of freed inode cluster blocks
- fix alignment of initial file allocations to match filesystem geometry
- decouple in-memory and on-disk log format
- introduce a common helper to calculate the number of filesystem
  blocks in an inode cluster
- fixes for extent list locking
- fix for off-by-one in xfs_attr3_rmt_verify
- fix for missing destroy_work_on_stack in xfs_bmapi_allocate

----------------------------------------------------------------
Ben Myers (6):
      xfs: fix calculation of freed inode cluster blocks
      Merge branch 'xfs-factor-icluster-macros' into for-next
      Merge branch 'xfs-for-linus-v3.13-rc5' into for-next
      xfs: reinstate the ilock in xfs_readdir
      Merge branch 'xfs-misc' into for-next
      Merge branch 'xfs-extent-list-locking-fixes' into for-next

Christoph Hellwig (26):
      xfs: remove unused FI_ flags
      xfs: fix the comment explaining xfs_trans_dqlockedjoin
      fs: fix iversion handling
      xfs: tiny xfs_setattr_mode cleanup
      xfs: add xfs_setattr_time
      xfs: remove duplicate code in xlog_cil_insert_format_items
      xfs: refactor xfs_buf_item_format_segment
      xfs: refactor xfs_inode_item_size
      xfs: refactor xfs_inode_item_format
      xfs: introduce xlog_copy_iovec
      xfs: format log items write directly into the linear CIL buffer
      xfs: format logged extents directly into the CIL
      xfs: remove the inode log format from the inode log item
      xfs: remove the dquot log format from the dquot log item
      xfs: remove the quotaoff log format from the quotaoff log item
      xfs: remove xfsbdstrat error
      xfs: no need to lock the inode in xfs_find_handle
      xfs: remove xfs_iunlock_map_shared
      xfs: rename xfs_ilock_map_shared
      xfs: add xfs_ilock_attr_map_shared
      xfs: take the ilock around xfs_bmapi_read in xfs_zero_remaining_bytes
      xfs: use xfs_ilock_data_map_shared in xfs_qm_dqtobp
      xfs: use xfs_ilock_data_map_shared in xfs_qm_dqiterate
      xfs: use xfs_ilock_attr_map_shared in xfs_attr_get
      xfs: use xfs_ilock_attr_map_shared in xfs_attr_list_int
      xfs: assert that we hold the ilock for extent map access

Chuansheng Liu (1):
      xfs: Calling destroy_work_on_stack() to pair with INIT_WORK_ONSTACK()

Dan Carpenter (2):
      xfs: underflow bug in xfs_attrlist_by_handle()
      xfs: underflow bug in xfs_attrlist_by_handle()

Dave Chinner (7):
      xfs: growfs overruns AGFL buffer on V4 filesystems
      xfs: growfs overruns AGFL buffer on V4 filesystems
      xfs: xfs_dir2_block_to_sf temp buffer allocation fails
      xfs: align initial file allocations correctly
      xfs: align initial file allocations correctly
      xfs: swalloc doesn't align allocations properly
      xfs: abort metadata writeback on permanent errors

Eric Sandeen (1):
      xfs: simplify xfs_setsize_buftarg callchain; remove unused arg

Jie Liu (19):
      xfs: don't perform discard if the given range length is less than block size
      xfs: make quota metadata truncation behavior consistent to user space
      xfs: integrate xfs_quota_priv header file to xfs_qm
      xfs: fix false assertion at xfs_qm_vop_create_dqattach
      xfs: fix assertion failure at xfs_setattr_nonsize
      xfs: fix infinite loop by detaching the group/project hints from user dquot
      xfs: don't perform discard if the given range length is less than block size
      xfs: get rid of XFS_IALLOC_INODES macros
      xfs: get rid of XFS_INODE_CLUSTER_SIZE macros
      xfs: get rid of XFS_IALLOC_BLOCKS macros
      xfs: introduce a common helper xfs_icluster_size_fsb
      xfs: use xfs_icluster_size_fsb in xfs_bulkstat
      xfs: use xfs_icluster_size_fsb in xfs_ialloc_inode_init
      xfs: use xfs_icluster_size_fsb in xfs_ifree_cluster
      xfs: use xfs_icluster_size_fsb in xfs_imap
      xfs: fix false assertion at xfs_qm_vop_create_dqattach
      xfs: fix assertion failure at xfs_setattr_nonsize
      xfs: fix infinite loop by detaching the group/project hints from user dquot
      xfs: fix off-by-one error in xfs_attr3_rmt_verify

Mark Tinguely (3):
      xfs: free the list of recovery items on error
      xfs: fix memory leak in xfs_dir2_node_removename
      xfs: fix memory leak in xfs_dir2_node_removename

Namjae Jeon (2):
      MAINTAINERS: fix incorrect mail address of XFS maintainer
      MAINTAINERS: fix incorrect mail address of XFS maintainer

 MAINTAINERS               |   2 +-
 fs/attr.c                 |   5 -
 fs/btrfs/inode.c          |   8 +-
 fs/ext4/inode.c           |   4 +
 fs/xfs/xfs_aops.c         |   2 +-
 fs/xfs/xfs_attr.c         |   5 +-
 fs/xfs/xfs_attr_list.c    |   8 +-
 fs/xfs/xfs_attr_remote.c  |   2 +-
 fs/xfs/xfs_bmap.c         |  36 ++++-
 fs/xfs/xfs_bmap_util.c    |  50 ++++--
 fs/xfs/xfs_buf.c          |  63 +++-----
 fs/xfs/xfs_buf.h          |  11 +-
 fs/xfs/xfs_buf_item.c     | 124 +++++++-------
 fs/xfs/xfs_dir2_node.c    |  26 +--
 fs/xfs/xfs_dir2_readdir.c |   4 +
 fs/xfs/xfs_dir2_sf.c      |  58 ++++---
 fs/xfs/xfs_discard.c      |   5 +-
 fs/xfs/xfs_dquot.c        |   7 +-
 fs/xfs/xfs_dquot_item.c   |  67 +++-----
 fs/xfs/xfs_dquot_item.h   |   3 +-
 fs/xfs/xfs_extfree_item.c |  21 +--
 fs/xfs/xfs_file.c         |  10 +-
 fs/xfs/xfs_fsops.c        |   6 +-
 fs/xfs/xfs_ialloc.c       |  53 +++---
 fs/xfs/xfs_ialloc.h       |  21 +--
 fs/xfs/xfs_icreate_item.c |  10 +-
 fs/xfs/xfs_inode.c        |  85 +++++-----
 fs/xfs/xfs_inode.h        |   4 +-
 fs/xfs/xfs_inode_fork.c   |  17 +-
 fs/xfs/xfs_inode_item.c   | 400 +++++++++++++++++++---------------------------
 fs/xfs/xfs_inode_item.h   |   5 -
 fs/xfs/xfs_ioctl.c        |   7 +-
 fs/xfs/xfs_ioctl32.c      |   3 +-
 fs/xfs/xfs_iops.c         |  79 +++++----
 fs/xfs/xfs_itable.c       |  22 ++-
 fs/xfs/xfs_log.h          |  46 ++++++
 fs/xfs/xfs_log_cil.c      |  74 +++------
 fs/xfs/xfs_log_recover.c  |  46 ++++--
 fs/xfs/xfs_qm.c           |  86 ++++++----
 fs/xfs/xfs_qm.h           |  18 ++-
 fs/xfs/xfs_qm_syscalls.c  |  18 ++-
 fs/xfs/xfs_quota_priv.h   |  42 -----
 fs/xfs/xfs_trans.h        |   2 +-
 fs/xfs/xfs_trans_buf.c    |  13 +-
 fs/xfs/xfs_trans_dquot.c  |   4 +-
 fs/xfs/xfs_trans_resv.c   |  10 +-
 fs/xfs/xfs_trans_space.h  |   2 +-
 fs/xfs/xfs_vnode.h        |   9 --
 48 files changed, 796 insertions(+), 807 deletions(-)
 delete mode 100644 fs/xfs/xfs_quota_priv.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
