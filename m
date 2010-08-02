Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o72IiitQ202590 for <xfs@oss.sgi.com>; Mon, 2 Aug 2010 13:44:44 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201008021845.o72Ij016021377@stout.americas.sgi.com>
Date: Mon, 02 Aug 2010 13:44:59 -0500
Subject: [GIT PULL] XFS update for 2.6.36-rc1
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

The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:

  Linux 2.6.35 (2010-08-01 15:11:14 -0700)

are available in the git repository at:
  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      Merge branch 'v2.6.35'

Christoph Hellwig (38):
      xfs: drop dmapi hooks
      xfs: remove unneeded #include statements
      xfs: simplify log item descriptor tracking
      xfs: merge iop_unpin_remove into iop_unpin
      xfs: give xfs_item_ops methods the correct prototypes
      xfs: give li_cb callbacks the correct prototype
      xfs: simplify buffer pinning
      xfs: simplify inode to transaction joining
      xfs: fix the xfs_log_iovec i_addr type
      xfs: kill the unused xlog_debug variable
      xfs: remove the unused XFS_LOG_SLEEP and XFS_LOG_NOSLEEP flags
      xfs: remove the unused XFS_TRANS_NOSLEEP/XFS_TRANS_WAIT flags
      xfs: remove unused XFS_BMAPI_ flags
      xfs: remove unused delta tracking code in xfs_bmapi
      xfs: simplify xfs_vm_releasepage
      xfs: simplify xfs_vm_writepage
      xfs: avoid synchronous transaction in xfs_fs_write_inode
      xfs: reduce stack usage in xfs_iomap
      xfs: small cleanups for xfs_iomap / __xfs_get_blocks
      xfs: remove explicit xfs_sync_data/xfs_sync_attr calls on umount
      xfs: do not use emums for flags used in tracing
      xfs: some iget tracing cleanups / fixes
      xfs: remove xfs_iput_new
      xfs: remove xfs_iput
      xfs: split xfs_itrace_entry
      xfs: remove incorrect log write optimization
      xfs: allow writeback from kswapd
      xfs: writepage always has buffers
      xfs: remove a dmapi leftover
      xfs: fix gcc 4.6 set but not read and unused statement warnings
      xfs: clean up filestreams helpers
      xfs: remove obsolete osyncisosync mount option
      xfs: kill the b_strat callback in xfs_buf
      xfs: simplify xfs_truncate_file
      xfs: clean up xfs_bmap_get_bp
      direct-io: move aio_complete into ->end_io
      xfs: move aio completion after unwritten extent conversion
      xfs simplify and speed up direct I/O completions

Dave Chinner (8):
      xfs: unregister inode shrinker before freeing filesystem structures
      xfs: move inode shrinker unregister even earlier
      xfs: don't block on buffer read errors
      xfs: simplify and remove xfs_ireclaim
      xfs: fix xfs_trans_add_item() lockdep warnings
      xfs: fix memory reclaim recursion deadlock on locked inode buffer
      xfs: use GFP_NOFS for page cache allocation
      xfs: fix big endian build

Eric Sandeen (1):
      xfs: fix corruption case for block size < page size

Kulikov Vasiliy (1):
      xfs: fix unsigned underflow in xfs_free_eofblocks

Tony Luck (1):
      xfs: Fix build when CONFIG_XFS_POSIX_ACL=n

 Documentation/filesystems/xfs.txt |   11 -
 fs/direct-io.c                    |   26 +-
 fs/ext4/inode.c                   |   10 +-
 fs/ocfs2/aops.c                   |    7 +-
 fs/xfs/Makefile                   |    4 +-
 fs/xfs/linux-2.6/xfs_acl.c        |    2 +-
 fs/xfs/linux-2.6/xfs_aops.c       |  611 +++++++++++++------------------------
 fs/xfs/linux-2.6/xfs_aops.h       |    4 +-
 fs/xfs/linux-2.6/xfs_buf.c        |   62 ++---
 fs/xfs/linux-2.6/xfs_buf.h        |  119 ++++----
 fs/xfs/linux-2.6/xfs_dmapi_priv.h |   28 --
 fs/xfs/linux-2.6/xfs_export.c     |    8 +-
 fs/xfs/linux-2.6/xfs_file.c       |  104 +------
 fs/xfs/linux-2.6/xfs_fs_subr.c    |    4 -
 fs/xfs/linux-2.6/xfs_fs_subr.h    |   25 --
 fs/xfs/linux-2.6/xfs_ioctl.c      |   27 +--
 fs/xfs/linux-2.6/xfs_ioctl32.c    |    6 +-
 fs/xfs/linux-2.6/xfs_iops.c       |   10 +-
 fs/xfs/linux-2.6/xfs_linux.h      |    1 -
 fs/xfs/linux-2.6/xfs_quotaops.c   |    1 -
 fs/xfs/linux-2.6/xfs_super.c      |  171 ++++-------
 fs/xfs/linux-2.6/xfs_super.h      |    7 -
 fs/xfs/linux-2.6/xfs_sync.c       |   49 ++-
 fs/xfs/linux-2.6/xfs_sync.h       |    3 -
 fs/xfs/linux-2.6/xfs_trace.c      |    4 -
 fs/xfs/linux-2.6/xfs_trace.h      |  128 ++++++--
 fs/xfs/quota/xfs_dquot.c          |  114 +++----
 fs/xfs/quota/xfs_dquot_item.c     |  301 ++++++++-----------
 fs/xfs/quota/xfs_qm.c             |   15 +-
 fs/xfs/quota/xfs_qm_bhv.c         |   10 -
 fs/xfs/quota/xfs_qm_stats.c       |   10 -
 fs/xfs/quota/xfs_qm_syscalls.c    |   89 ++++--
 fs/xfs/quota/xfs_trans_dquot.c    |   35 +--
 fs/xfs/support/debug.c            |    1 -
 fs/xfs/xfs_alloc.c                |   15 +-
 fs/xfs/xfs_alloc.h                |   20 +-
 fs/xfs/xfs_alloc_btree.c          |    5 -
 fs/xfs/xfs_attr.c                 |   91 ++----
 fs/xfs/xfs_attr_leaf.c            |    5 +-
 fs/xfs/xfs_bmap.c                 |  327 +++-----------------
 fs/xfs/xfs_bmap.h                 |   37 +--
 fs/xfs/xfs_bmap_btree.c           |    5 -
 fs/xfs/xfs_btree.c                |    5 -
 fs/xfs/xfs_buf_item.c             |  228 +++++++--------
 fs/xfs/xfs_buf_item.h             |    2 +-
 fs/xfs/xfs_da_btree.c             |   20 +-
 fs/xfs/xfs_dfrag.c                |   16 +-
 fs/xfs/xfs_dir2.c                 |   11 +-
 fs/xfs/xfs_dir2_block.c           |    8 +-
 fs/xfs/xfs_dir2_data.c            |    2 -
 fs/xfs/xfs_dir2_leaf.c            |    4 +-
 fs/xfs/xfs_dir2_node.c            |    2 -
 fs/xfs/xfs_dir2_sf.c              |    2 -
 fs/xfs/xfs_dmapi.h                |  170 ----------
 fs/xfs/xfs_dmops.c                |   55 ----
 fs/xfs/xfs_error.c                |    4 -
 fs/xfs/xfs_extfree_item.c         |  278 +++++++----------
 fs/xfs/xfs_filestream.c           |   84 +++++-
 fs/xfs/xfs_filestream.h           |   82 -----
 fs/xfs/xfs_fsops.c                |    7 +-
 fs/xfs/xfs_ialloc.c               |    4 -
 fs/xfs/xfs_ialloc_btree.c         |    4 -
 fs/xfs/xfs_iget.c                 |  108 +-------
 fs/xfs/xfs_inode.c                |   60 ++---
 fs/xfs/xfs_inode.h                |    4 +-
 fs/xfs/xfs_inode_item.c           |  273 ++++++-----------
 fs/xfs/xfs_inode_item.h           |   12 +-
 fs/xfs/xfs_iomap.c                |   76 +++---
 fs/xfs/xfs_iomap.h                |   22 +-
 fs/xfs/xfs_itable.c               |    8 +-
 fs/xfs/xfs_log.c                  |   16 +-
 fs/xfs/xfs_log.h                  |   11 +-
 fs/xfs/xfs_log_cil.c              |    4 +-
 fs/xfs/xfs_log_recover.c          |   42 +--
 fs/xfs/xfs_mount.c                |    3 -
 fs/xfs/xfs_mount.h                |   69 -----
 fs/xfs/xfs_rename.c               |   63 +----
 fs/xfs/xfs_rtalloc.c              |    9 +-
 fs/xfs/xfs_rw.c                   |   15 -
 fs/xfs/xfs_trans.c                |  211 ++++++++-----
 fs/xfs/xfs_trans.h                |  117 +-------
 fs/xfs/xfs_trans_ail.c            |    1 -
 fs/xfs/xfs_trans_buf.c            |   75 +----
 fs/xfs/xfs_trans_extfree.c        |   23 +-
 fs/xfs/xfs_trans_inode.c          |   74 ++---
 fs/xfs/xfs_trans_item.c           |  441 --------------------------
 fs/xfs/xfs_trans_priv.h           |   18 +-
 fs/xfs/xfs_utils.c                |   87 ------
 fs/xfs/xfs_utils.h                |    1 -
 fs/xfs/xfs_vnodeops.c             |  293 ++++--------------
 include/linux/fs.h                |    3 +-
 91 files changed, 1621 insertions(+), 4018 deletions(-)
 delete mode 100644 fs/xfs/linux-2.6/xfs_dmapi_priv.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_fs_subr.h
 delete mode 100644 fs/xfs/xfs_dmapi.h
 delete mode 100644 fs/xfs/xfs_dmops.c
 delete mode 100644 fs/xfs/xfs_trans_item.c

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
