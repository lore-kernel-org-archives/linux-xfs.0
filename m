Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9RK1A8Z117084 for <xfs@oss.sgi.com>; Thu, 27 Oct 2011 15:01:10 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201110272001.p9RK1497011512@stout.americas.sgi.com>
Date: Thu, 27 Oct 2011 15:01:02 -0500
Subject: [GIT PULL] XFS update for 3.2-rc1
MIME-Version: 1.0
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: torvalds@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Linus, please pull the following set of XFS changes for 3.2-rc1.

The repository is oss.sgi.com.  If you would prefer I use something
you feel is more trustworthy let me know and I will arrange that.  I
have tagged the top commit "xfs_for_3.2-rc1_v1", signing it with a
key I established last year for signing XFS user space releases.

Thanks.

					-Alex

The following changes since commit 396e6e49c58bb23d1814d3c240c736c9f01523c5:

  Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input (2011-10-27 08:44:20 +0200)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (2):
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux
      xfs: put in missed fix for merge problem

Chandra Seetharaman (3):
      xfs: Check the return value of xfs_buf_get()
      xfs: Check the return value of xfs_trans_get_buf()
      xfs: Fix the incorrect comment in the header of _xfs_buf_find

Christoph Hellwig (46):
      xfs: remove delwri buffer handling from xfs_buf_iorequest
      xfs: remove the unlock argument to xfs_buf_delwri_queue
      xfs: move more delwri setup into xfs_buf_delwri_queue
      xfs: call xfs_buf_delwri_queue directly
      xfs: let xfs_bwrite callers handle the xfs_buf_relse
      xfs: use the "delwri" terminology consistently
      xfs: remove dead ENODEV handling in xfs_destroy_ioend
      xfs: defer AIO/DIO completions
      xfs: reduce ioend latency
      xfs: wait for I/O completion when writing out pages in xfs_setattr_size
      xfs: remove i_iocount
      xfs: avoid synchronous transactions when deleting attr blocks
      xfs: avoid direct I/O write vs buffered I/O race
      xfs: improve ioend error handling
      xfs: remove the first extent special case in xfs_bmap_add_extent
      xfs: remove impossible to read code in xfs_bmap_add_extent_delay_real
      xfs: remove the nextents variable in xfs_bmapi
      xfs: factor delalloc reservations out of xfs_bmapi
      xfs: introduce xfs_bmapi_delay()
      xfs: do not use xfs_bmap_add_extent for adding delalloc extents
      xfs: introduce xfs_bmap_last_extent
      xfs: remove xfs_bmap_add_extent
      xfs: move logflags into bmalloca
      xfs: pass bmalloca to xfs_bmap_add_extent_delay_real
      xfs: pass bmalloca to xfs_bmap_add_extent_hole_real
      xfs: dont ignore error code from xfs_bmbt_update
      xfs: cleanup xfs_bmap.h
      xfs: XFS_TRANS_SWAPEXT is not a valid flag for xfs_trans_commit
      xfs: unlock the inode before log force in xfs_fsync
      xfs: unlock the inode before log force in xfs_fs_nfs_commit_metadata
      xfs: unlock the inode before log force in xfs_change_file_space
      xfs: simplify xfs_trans_ijoin* again
      xfs: optimize fsync on directories
      xfs: fix buffer flushing during unmount
      xfs: remove xfs_get_buftarg_list
      xfs: remove XFS_BUF_FINISH_IOWAIT
      xfs: remove XFS_BUF_SET_VTYPE and XFS_BUF_SET_VTYPE_REF
      xfs: remove XFS_BUF_STALE and XFS_BUF_SUPER_STALE
      xfs: remove buffers from the delwri list in xfs_buf_stale
      xfs: clean up buffer allocation
      xfs: clean up xfs_ioerror_alert
      xfs: use xfs_ioerror_alert in xfs_buf_iodone_callbacks
      xfs: remove xfs_buf_target_name
      xfs: remove XFS_bflush
      xfs: do not flush data workqueues in xfs_flush_buftarg
      xfs: add AIL pushing tracepoints

Dave Chinner (17):
      xfs: don't serialise direct IO reads on page cache checks
      xfs: don't serialise adjacent concurrent direct IO appending writes
      xfs: factor extent map manipulations out of xfs_bmapi
      xfs: introduce xfs_bmapi_read()
      xfs: remove xfs_bmapi_single()
      xfs: factor extent allocation out of xfs_bmapi
      xfs: factor unwritten extent map manipulations out of xfs_bmapi
      xfs: rename xfs_bmapi to xfs_bmapi_write
      xfs: pass bmalloca structure to xfs_bmap_isaeof
      xfs: move extent records into bmalloca structure
      xfs: move firstblock and bmap freelist cursor into bmalloca structure
      xfs: rename allocation range fields in struct xfs_bmalloca
      xfs: do not keep local copies of allocation ranges in xfs_bmapi_allocate
      xfs: move btree cursor into bmalloca
      xfs: move lastx and nallocs into bmalloca
      xfs: Don't allocate new buffers on every call to _xfs_buf_find
      xfs: reduce the number of log forces from tail pushing

Lukas Czerner (1):
      xfs: fix possible overflow in xfs_ioc_trim()

Mitsuo Hayasaka (1):
      xfs: Return -EIO when xfs_vn_getattr() failed

 fs/xfs/xfs_alloc.c       |    4 +-
 fs/xfs/xfs_aops.c        |  119 +--
 fs/xfs/xfs_aops.h        |    4 +-
 fs/xfs/xfs_attr.c        |   89 +-
 fs/xfs/xfs_attr_leaf.c   |    7 +-
 fs/xfs/xfs_bmap.c        | 2531 +++++++++++++++++++++++-----------------------
 fs/xfs/xfs_bmap.h        |  318 ++-----
 fs/xfs/xfs_btree.c       |   11 +-
 fs/xfs/xfs_buf.c         |  244 ++---
 fs/xfs/xfs_buf.h         |   51 +-
 fs/xfs/xfs_buf_item.c    |   12 +-
 fs/xfs/xfs_da_btree.c    |   54 +-
 fs/xfs/xfs_dfrag.c       |    6 +-
 fs/xfs/xfs_dir2_leaf.c   |    6 +-
 fs/xfs/xfs_discard.c     |   20 +-
 fs/xfs/xfs_dquot.c       |   32 +-
 fs/xfs/xfs_export.c      |   12 +-
 fs/xfs/xfs_file.c        |  168 +++-
 fs/xfs/xfs_filestream.c  |    4 +-
 fs/xfs/xfs_fsops.c       |   60 +-
 fs/xfs/xfs_ialloc.c      |   15 +-
 fs/xfs/xfs_iget.c        |    2 -
 fs/xfs/xfs_inode.c       |   43 +-
 fs/xfs/xfs_inode.h       |    1 -
 fs/xfs/xfs_inode_item.c  |    4 +-
 fs/xfs/xfs_ioctl.c       |    2 +-
 fs/xfs/xfs_iomap.c       |   39 +-
 fs/xfs/xfs_iops.c        |   14 +-
 fs/xfs/xfs_log.c         |   20 +-
 fs/xfs/xfs_log_recover.c |   43 +-
 fs/xfs/xfs_mount.c       |   36 +-
 fs/xfs/xfs_qm.c          |   12 +-
 fs/xfs/xfs_qm_syscalls.c |    2 +-
 fs/xfs/xfs_rename.c      |    8 +-
 fs/xfs/xfs_rtalloc.c     |   48 +-
 fs/xfs/xfs_rw.c          |   23 +-
 fs/xfs/xfs_rw.h          |    2 -
 fs/xfs/xfs_super.c       |   13 +-
 fs/xfs/xfs_sync.c        |   16 +-
 fs/xfs/xfs_trace.h       |   39 +-
 fs/xfs/xfs_trans.c       |   13 +-
 fs/xfs/xfs_trans.h       |    8 +-
 fs/xfs/xfs_trans_ail.c   |   43 +-
 fs/xfs/xfs_trans_buf.c   |   24 +-
 fs/xfs/xfs_trans_inode.c |   25 +-
 fs/xfs/xfs_trans_priv.h  |    1 +
 fs/xfs/xfs_vnodeops.c    |  109 +--
 47 files changed, 2033 insertions(+), 2324 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
