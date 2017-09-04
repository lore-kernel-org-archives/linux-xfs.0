Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:46366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753968AbdIDRbZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Sep 2017 13:31:25 -0400
Date: Mon, 4 Sep 2017 10:31:23 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
Subject: [GIT PULL] xfs: changes for 4.14
Message-ID: <20170904173123.GD4660@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>, djwong@kernel.org

Hi Linus,

Here are the changes for xfs for 4.14.  Most of these are cleanups and
fixes for bad behavior, as we're mostly focusing on improving reliablity
this cycle (read: there's potentially a lot of stuff on the horizon for
4.15 so better to spend a few weeks killing other bugs now.)

Anyway, I tried a test merge+build against master this morning and it
worked fine for me, so please let me know if you encounter any problems.

--D

The following changes since commit 6470812e22261d2342ef1597be62e63a0423d691:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc (2017-08-21 14:07:48 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-4.14-merge-7

for you to fetch changes up to 6c370590cfe0c36bcd62d548148aa65c984540b7:

  xfs: use kmem_free to free return value of kmem_zalloc (2017-09-03 10:40:46 -0700)

----------------------------------------------------------------
Updates for 4.14:
- Write unmount record for a ro mount to avoid unnecessary log replay
- Clean up orphaned inodes when mounting fs readonly
- Resubmit inode log items when buffer writeback fails to avoid umount hang
- Fix log recovery corruption problems when log headers wrap around the end
- Avoid infinite loop searching for free inodes when inode counters are wrong
- Evict inodes involved with log redo so that we don't leak them later
- Fix a potential race between reclaim and inode cluster freeing
- Refactor the inode joining code w.r.t. transaction rolling & deferred ops
- Fix a bug where the log doesn't properly deal with dirty buffers that
  are about to become ordered buffers
- Fix the extent swap code to deal with making dirty buffers ordered properly
- Consolidate page fault handlers
- Refactor the incore extent manipulation functions to use the iext
  abstractions instead of directly modifying with extent data
- Disable crashy chattr +/-x until we fix it
- Don't allow us to set S_DAX for v2 inodes
- Various cleanups
- Clarify some documentation
- Fix a problem where fsync and a log commit race to send the disk a
  flush command, resulting in a small window where power fail data loss
  could occur
- Simplify some rmap operations in the fcollapse code
- Fix some use-after-free problems in async writeback

----------------------------------------------------------------
Amir Goldstein (1):
      xfs: fix incorrect log_flushed on fsync

Brian Foster (15):
      xfs: fix recovery failure when log record header wraps log end
      xfs: always verify the log tail during recovery
      xfs: fix log recovery corruption error due to tail overwrite
      xfs: add log item pinning error injection tag
      xfs: handle -EFSCORRUPTED during head/tail verification
      xfs: add log recovery tracepoint for head/tail
      xfs: open-code xfs_buf_item_dirty()
      xfs: remove unnecessary dirty bli format check for ordered bufs
      xfs: ordered buffer log items are never formatted
      xfs: refactor buffer logging into buffer dirtying helper
      xfs: don't log dirty ranges for ordered buffers
      xfs: skip bmbt block ino validation during owner change
      xfs: move bmbt owner change to last step of extent swap
      xfs: disallow marking previously dirty buffers as ordered
      xfs: relog dirty buffers during swapext bmbt owner change

Carlos Maiolino (3):
      xfs: Add infrastructure needed for error propagation during buffer IO failure
      xfs: Properly retry failed inode items in case of error during buffer writeback
      xfs: stop searching for free slots in an inode chunk when there are none

Christoph Hellwig (16):
      xfs: refactor xfs_trans_roll
      xfs: rename xfs_defer_join to xfs_defer_ijoin
      xfs: remove the ip argument to xfs_defer_finish
      iomap: return VM_FAULT_* codes from iomap_page_mkwrite
      xfs: consolidate the various page fault handlers
      xfs: add a xfs_iext_update_extent helper
      xfs: switch xfs_bmap_local_to_extents to use xfs_iext_insert
      xfs: use xfs_iext_get_extent in xfs_bmap_first_unused
      xfs: move some code around inside xfs_bmap_shift_extents
      xfs: use xfs_iext_*_extent helpers in xfs_bmap_shift_extents
      xfs: use xfs_iext_*_extent helpers in xfs_bmap_split_extent_at
      xfs: rewrite xfs_bmap_count_leaves using xfs_iext_get_extent
      xfs: replace xfs_qm_get_rtblks with a direct call to xfs_bmap_count_leaves
      xfs: disable per-inode DAX flag
      xfs: don't set v3 xflags for v2 inodes
      xfs: open code end_buffer_async_write in xfs_finish_page_writeback

Darrick J. Wong (4):
      xfs: evict all inodes involved with log redo item
      xfs: simplify the rmap code in xfs_bmse_merge
      fsmap: fix documentation of FMR_OF_LAST
      xfs: fix compiler warnings

Eric Sandeen (3):
      xfs: write unmount record for ro mounts
      xfs: toggle readonly state around xfs_log_mount_finish
      xfs: remove unused flags arg from xfs_file_iomap_begin_delay

Omar Sandoval (1):
      xfs: check for race with xfs_reclaim_inode() in xfs_ifree_cluster()

Pan Bian (1):
      xfs: use kmem_free to free return value of kmem_zalloc

 fs/inode.c                      |   1 +
 fs/internal.h                   |   1 -
 fs/iomap.c                      |   4 +-
 fs/xfs/libxfs/xfs_attr.c        | 156 +++++++++++-----------
 fs/xfs/libxfs/xfs_attr_leaf.c   |   6 +-
 fs/xfs/libxfs/xfs_attr_remote.c |  39 +++---
 fs/xfs/libxfs/xfs_bmap.c        | 280 +++++++++++++++++++---------------------
 fs/xfs/libxfs/xfs_bmap_btree.c  |   1 +
 fs/xfs/libxfs/xfs_btree.c       |  27 ++--
 fs/xfs/libxfs/xfs_btree.h       |   3 +-
 fs/xfs/libxfs/xfs_defer.c       |  29 ++---
 fs/xfs/libxfs/xfs_defer.h       |   5 +-
 fs/xfs/libxfs/xfs_ialloc.c      |  57 ++++----
 fs/xfs/libxfs/xfs_inode_fork.c  |  21 ++-
 fs/xfs/libxfs/xfs_inode_fork.h  |   2 +
 fs/xfs/libxfs/xfs_refcount.c    |   2 +-
 fs/xfs/xfs_aops.c               |  71 ++++++----
 fs/xfs/xfs_attr_inactive.c      |   6 +-
 fs/xfs/xfs_bmap_item.c          |   2 +-
 fs/xfs/xfs_bmap_util.c          | 124 ++++++++++++------
 fs/xfs/xfs_bmap_util.h          |   1 +
 fs/xfs/xfs_buf_item.c           | 137 +++++++++++++-------
 fs/xfs/xfs_buf_item.h           |   5 +-
 fs/xfs/xfs_dquot.c              |   2 +-
 fs/xfs/xfs_error.c              |   3 +
 fs/xfs/xfs_error.h              |   4 +-
 fs/xfs/xfs_file.c               |  97 +++++---------
 fs/xfs/xfs_icache.c             |  10 +-
 fs/xfs/xfs_inode.c              |  40 ++++--
 fs/xfs/xfs_inode_item.c         |  47 ++++++-
 fs/xfs/xfs_ioctl.c              |  41 ++++--
 fs/xfs/xfs_iomap.c              |  10 +-
 fs/xfs/xfs_iops.c               |   2 +-
 fs/xfs/xfs_log.c                |  33 +++--
 fs/xfs/xfs_log_recover.c        | 161 ++++++++++++++---------
 fs/xfs/xfs_qm.c                 |  44 ++-----
 fs/xfs/xfs_refcount_item.c      |   2 +-
 fs/xfs/xfs_reflink.c            |  11 +-
 fs/xfs/xfs_rtalloc.c            |   2 +-
 fs/xfs/xfs_super.c              |   2 +-
 fs/xfs/xfs_symlink.c            |   5 +-
 fs/xfs/xfs_trace.h              |  48 ++++++-
 fs/xfs/xfs_trans.c              |  28 +---
 fs/xfs/xfs_trans.h              |  17 ++-
 fs/xfs/xfs_trans_ail.c          |  20 ++-
 fs/xfs/xfs_trans_buf.c          |  79 +++++++-----
 fs/xfs/xfs_trans_inode.c        |  14 ++
 fs/xfs/xfs_trans_priv.h         |  31 +++++
 include/linux/fs.h              |   1 +
 include/uapi/linux/fsmap.h      |   2 +-
 50 files changed, 1027 insertions(+), 709 deletions(-)
