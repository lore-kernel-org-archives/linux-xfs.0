Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4NKnitL249215 for <xfs@oss.sgi.com>; Wed, 23 May 2012 15:49:44 -0500
Subject: [GIT PULL] XFS update for 3.5-rc1
Message-Id: <20120523205453.E994A402073@whiskey.americas.sgi.com>
Date: Wed, 23 May 2012 15:54:53 -0500 (CDT)
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Hi Linus,

   Please pull these XFS changes for 3.5.  They include:

   * Removal of xfsbufd
   * Background CIL flushes have been moved to a workqueue.
   * Fix to xfs_check_page_type applicable to filesystems where
     blocksize < page size
   * Fix for stale data exposure when extsize hints are used.
   * A series of xfs_buf cache cleanups.
   * Fix for XFS_IOC_ALLOCSP
   * Cleanups for includes and removal of xfs_lrw.[ch].
   * Moved all busy extent handling to it's own file so that it is
     easier to merge with userspace.
   * Fix for log mount failure.
   * Fix to enable inode reclaim during quotacheck at mount time.
   * Fix for delalloc quota accounting.
   * Fix for memory reclaim deadlock on agi buffer.
   * Fixes for failed writes and to clean up stale delalloc blocks.
   * Fix to use GFP_NOFS in blkdev_issue_flush
   * SEEK_DATA/SEEK_HOLE support

Thanks,
Ben

The following changes since commit 56edab315927d2a5ae6064b9fc083236a6fc278f:

  Merge branches 'perf-urgent-for-linus' and 'perf-core-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip (2012-05-23 12:12:49 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Ben Myers (3):
      MAINTAINERS: retire xfs-masters@oss.sgi.com
      xfs: make xfs_extent_busy_trim not static
      xfs: protect xfs_sync_worker with s_umount semaphore

Christoph Hellwig (14):
      xfs: avoid taking the ilock unnessecarily in xfs_qm_dqattach
      xfs: reduce ilock hold times in xfs_file_aio_write_checks
      xfs: reduce ilock hold times in xfs_setattr_size
      xfs: push the ilock into xfs_zero_eof
      xfs: remove log item from AIL in xfs_qm_dqflush after a shutdown
      xfs: remove log item from AIL in xfs_iflush after a shutdown
      xfs: allow assigning the tail lsn with the AIL lock held
      xfs: implement freezing by emptying the AIL
      xfs: don't flush inodes from background inode reclaim
      xfs: do not write the buffer from xfs_iflush
      xfs: do not write the buffer from xfs_qm_dqflush
      xfs: do not add buffers to the delwri queue until pushed
      xfs: on-stack delayed write buffer lists
      xfs: remove some obsolete comments in xfs_trans_ail.c

Dave Chinner (36):
      xfs: Ensure inode reclaim can run during quotacheck
      xfs: use shared ilock mode for direct IO writes by default
      xfs: punch all delalloc blocks beyond EOF on write failure.
      xfs: pass shutdown method into xfs_trans_ail_delete_bulk
      xfs: Do background CIL flushes via a workqueue
      xfs: page type check in writeback only checks last buffer
      xfs: punch new delalloc blocks out of failed writes inside EOF.
      xfs: prevent needless mount warning causing test failures
      xfs: don't assert on delalloc regions beyond EOF
      xfs: limit specualtive delalloc to maxioffset
      xfs: Use preallocation for inodes with extsz hints
      xfs: fix buffer lookup race on allocation failure
      xfs: check for buffer errors before waiting
      xfs: fix incorrect b_offset initialisation
      xfs: use kmem_zone_zalloc for buffers
      xfs: clean up buffer get/read call API
      xfs: kill b_file_offset
      xfs: use blocks for counting length of buffers
      xfs: use blocks for storing the desired IO size
      xfs: kill xfs_buf_btoc
      xfs: kill XBF_LOCK
      xfs: kill xfs_read_buf()
      xfs: kill XBF_DONTBLOCK
      xfs: use iolock on XFS_IOC_ALLOCSP calls
      xfs: move xfsagino_t to xfs_types.h
      xfs: move busy extent handling to it's own file
      xfs: clean up busy extent naming
      xfs: move xfs_fsb_to_db to xfs_bmap.h
      xfs: move xfs_get_extsz_hint() and kill xfs_rw.h
      xfs: move xfs_do_force_shutdown() and kill xfs_rw.c
      xfs: clean up xfs_bit.h includes
      xfs: Properly exclude IO type flags from buffer flags
      xfs: flush outstanding buffers on log mount failure
      xfs: make XBF_MAPPED the default behaviour
      xfs: fix delalloc quota accounting on failure
      xfs: add trace points for log forces

Jeff Liu (1):
      xfs: introduce SEEK_DATA/SEEK_HOLE support

Jie Liu (1):
      xfs: don't fill statvfs with project quota for a directory if it was not enabled.

Peter Watkins (1):
      xfs: fix memory reclaim deadlock on agi buffer

Shaohua Li (1):
      xfs: using GFP_NOFS for blkdev_issue_flush

 MAINTAINERS                |    2 +-
 fs/xfs/Makefile            |    2 +-
 fs/xfs/xfs_ag.h            |   18 --
 fs/xfs/xfs_alloc.c         |  585 +------------------------------------------
 fs/xfs/xfs_alloc.h         |   28 --
 fs/xfs/xfs_alloc_btree.c   |    9 +-
 fs/xfs/xfs_aops.c          |  218 ++++++++++++-----
 fs/xfs/xfs_attr.c          |   25 +-
 fs/xfs/xfs_attr_leaf.c     |    3 +-
 fs/xfs/xfs_bmap.c          |   32 ++-
 fs/xfs/xfs_bmap.h          |    3 +
 fs/xfs/xfs_bmap_btree.c    |    1 -
 fs/xfs/xfs_btree.c         |    1 -
 fs/xfs/xfs_buf.c           |  593 ++++++++++++++++++-------------------------
 fs/xfs/xfs_buf.h           |   96 +++-----
 fs/xfs/xfs_buf_item.c      |  123 +++------
 fs/xfs/xfs_da_btree.c      |   17 +-
 fs/xfs/xfs_dfrag.c         |    2 -
 fs/xfs/xfs_dir2.c          |    1 -
 fs/xfs/xfs_dir2_block.c    |    1 -
 fs/xfs/xfs_dir2_data.c     |    1 -
 fs/xfs/xfs_dir2_leaf.c     |    1 -
 fs/xfs/xfs_dir2_node.c     |    1 -
 fs/xfs/xfs_dir2_sf.c       |    1 -
 fs/xfs/xfs_discard.c       |    6 +-
 fs/xfs/xfs_dquot.c         |   91 ++-----
 fs/xfs/xfs_dquot.h         |    3 +-
 fs/xfs/xfs_dquot_item.c    |  162 ++++---------
 fs/xfs/xfs_error.c         |    1 -
 fs/xfs/xfs_export.c        |    1 -
 fs/xfs/xfs_extent_busy.c   |  603 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_extent_busy.h   |   69 +++++
 fs/xfs/xfs_extfree_item.c  |   59 ++----
 fs/xfs/xfs_file.c          |  327 ++++++++++++++++---------
 fs/xfs/xfs_fsops.c         |   82 +++++-
 fs/xfs/xfs_ialloc.c        |   10 +-
 fs/xfs/xfs_ialloc.h        |    9 -
 fs/xfs/xfs_ialloc_btree.c  |    1 -
 fs/xfs/xfs_iget.c          |   24 +--
 fs/xfs/xfs_inode.c         |  132 ++++------
 fs/xfs/xfs_inode.h         |    5 +-
 fs/xfs/xfs_inode_item.c    |  176 ++++---------
 fs/xfs/xfs_inode_item.h    |    2 +-
 fs/xfs/xfs_inum.h          |    5 -
 fs/xfs/xfs_ioctl.c         |    2 -
 fs/xfs/xfs_ioctl32.c       |    2 -
 fs/xfs/xfs_iomap.c         |   59 +++---
 fs/xfs/xfs_iops.c          |   15 +-
 fs/xfs/xfs_itable.c        |    1 -
 fs/xfs/xfs_log.c           |   49 +++--
 fs/xfs/xfs_log.h           |    1 +
 fs/xfs/xfs_log_cil.c       |  253 +++++++++++--------
 fs/xfs/xfs_log_priv.h      |    2 +
 fs/xfs/xfs_log_recover.c   |  103 +++++----
 fs/xfs/xfs_message.c       |    1 -
 fs/xfs/xfs_mount.c         |   77 ++----
 fs/xfs/xfs_mount.h         |    2 +-
 fs/xfs/xfs_qm.c            |  196 ++++++++-------
 fs/xfs/xfs_qm_bhv.c        |    2 -
 fs/xfs/xfs_qm_syscalls.c   |    1 -
 fs/xfs/xfs_quotaops.c      |    1 -
 fs/xfs/xfs_rename.c        |    1 -
 fs/xfs/xfs_rtalloc.c       |   10 +-
 fs/xfs/xfs_rw.c            |  156 ------------
 fs/xfs/xfs_rw.h            |   47 ----
 fs/xfs/xfs_super.c         |   49 ++---
 fs/xfs/xfs_sync.c          |  281 +++++++--------------
 fs/xfs/xfs_trace.c         |    2 -
 fs/xfs/xfs_trace.h         |   53 +++--
 fs/xfs/xfs_trans.c         |    7 +-
 fs/xfs/xfs_trans.h         |   18 +-
 fs/xfs/xfs_trans_ail.c     |  207 ++++++++--------
 fs/xfs/xfs_trans_buf.c     |  126 +++-------
 fs/xfs/xfs_trans_dquot.c   |    2 -
 fs/xfs/xfs_trans_extfree.c |    1 -
 fs/xfs/xfs_trans_inode.c   |    2 -
 fs/xfs/xfs_trans_priv.h    |   12 +-
 fs/xfs/xfs_types.h         |    5 +
 fs/xfs/xfs_utils.c         |    2 -
 fs/xfs/xfs_vnodeops.c      |   31 ++-
 80 files changed, 2459 insertions(+), 2852 deletions(-)
 create mode 100644 fs/xfs/xfs_extent_busy.c
 create mode 100644 fs/xfs/xfs_extent_busy.h
 delete mode 100644 fs/xfs/xfs_rw.c
 delete mode 100644 fs/xfs/xfs_rw.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
