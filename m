Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1QLXH6p211008 for <xfs@oss.sgi.com>; Fri, 26 Feb 2010 15:33:17 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201002262134.o1QLYbcp000308@stout.americas.sgi.com>
Date: Fri, 26 Feb 2010 15:34:37 -0600
Subject: [GIT PULL] XFS update for 2.6.34-rc1
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

FYI, I am planning on an additional (smaller) pull request for
2.6.34-rc1 early next week.

					-Alex

The following changes since commit 60b341b778cc2929df16c0a504c91621b3c6a4ad:
  Linus Torvalds (1):
        Linux 2.6.33

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      Merge branch 'linux-2.6.33'

Christoph Hellwig (15):
      xfs: clean up log buffer writes
      xfs: clean up xfs_bwrite
      xfs: move more buffer helpers into xfs_buf.c
      xfs: kill XFS_QMOPT_ASYNC
      xfs: clean up error handling in xfs_trans_dqresv
      xfs: implement quota warnings via netlink
      xfs: remove duplicate buffer flags
      xfs: kill XLOG_VEC_SET_TYPE
      xfs: cleanup up xfs_log_force calling conventions
      xfs: replace KM_LARGE with explicit vmalloc use
      xfs: quota limit statvfs available blocks
      xfs: remove invalid barrier optimization from xfs_fsync
      xfs: log changed inodes instead of writing them synchronously
      xfs: only clear the suid bit once in xfs_write
      xfs: optimize log flushing in xfs_fsync

Dave Chinner (34):
      xfs: add tracing to xfs_swap_extents
      xfs: clean up inconsistent variable naming in xfs_swap_extent
      xfs: Use list_heads for log recovery item lists
      xfs: Don't wake the aild once per second
      xfs: Don't wake xfsbufd when idle
      xfs: rename xfs_get_perag
      xfs: Don't directly reference m_perag in allocation code
      xfs: Convert filestreams code to use per-ag get/put routines
      xfs: convert remaining direct references to m_perag
      xfs: Replace per-ag array with a radix tree
      xfs: Reference count per-ag structures
      xfs: Add trace points for per-ag refcount debugging.
      xfs: Kill filestreams cache flush
      xfs: handle ENOMEM correctly during initialisation of perag structures
      xfs: embed the pagb_list array in the perag structure
      xfs: directory names are unsigned
      xfs: convert DM ops to use unsigned char names
      xfs: convert dirnameops to unsigned char names
      xfs: make xfs_dir_cilookup_result use unsigned char
      xfs: xfs_buf_iomove() doesn't care about signedness
      xfs: convert attr to use unsigned names
      xfs: clean up sign warnings in dir2 code
      xfs: make compile warn about char sign mismatches again
      xfs: suppress spurious uninitialised var warning in xfs_bmapi()
      xfs: rearrange xfs_mod_sb() to avoid array subscript warning
      xfs: don't hold onto reserved blocks on remount,ro
      xfs: turn off sign warnings
      xfs: Make inode reclaim states explicit
      xfs: Use delayed write for inodes rather than async V2
      xfs: Don't issue buffer IO direct from AIL push V2
      xfs: Sort delayed write buffers before dispatch
      xfs: Use delay write promotion for dquot flushing
      xfs: kill the unused XFS_QMOPT_* flush flags V2
      xfs: kill xfs_bawrite

Eric Sandeen (2):
      xfs: make several more functions static
      xfs: more reserved blocks fixups

Julia Lawall (1):
      fs/xfs: Correct NULL test

 fs/xfs/Makefile                |    2 +-
 fs/xfs/linux-2.6/kmem.c        |   56 ++----
 fs/xfs/linux-2.6/kmem.h        |   21 ++-
 fs/xfs/linux-2.6/xfs_acl.c     |   11 +-
 fs/xfs/linux-2.6/xfs_buf.c     |  290 +++++++++++++++++++++++++-----
 fs/xfs/linux-2.6/xfs_buf.h     |   52 ++----
 fs/xfs/linux-2.6/xfs_fs_subr.c |    2 +-
 fs/xfs/linux-2.6/xfs_ioctl.c   |   21 ++-
 fs/xfs/linux-2.6/xfs_ioctl.h   |   12 +-
 fs/xfs/linux-2.6/xfs_ioctl32.c |    4 +-
 fs/xfs/linux-2.6/xfs_iops.c    |    4 +-
 fs/xfs/linux-2.6/xfs_lrw.c     |   62 +------
 fs/xfs/linux-2.6/xfs_lrw.h     |    3 -
 fs/xfs/linux-2.6/xfs_super.c   |  169 ++++++++++++++----
 fs/xfs/linux-2.6/xfs_sync.c    |  186 ++++++++++++++------
 fs/xfs/linux-2.6/xfs_sync.h    |    1 -
 fs/xfs/linux-2.6/xfs_trace.h   |   81 +++++++++
 fs/xfs/linux-2.6/xfs_xattr.c   |   27 ++-
 fs/xfs/quota/xfs_dquot.c       |   47 ++---
 fs/xfs/quota/xfs_dquot_item.c  |   99 ++---------
 fs/xfs/quota/xfs_dquot_item.h  |    4 -
 fs/xfs/quota/xfs_qm.c          |   40 +++--
 fs/xfs/quota/xfs_qm_bhv.c      |    2 +-
 fs/xfs/quota/xfs_qm_syscalls.c |    4 +-
 fs/xfs/quota/xfs_trans_dquot.c |   49 ++++--
 fs/xfs/xfs_acl.h               |    4 +-
 fs/xfs/xfs_ag.h                |   16 +-
 fs/xfs/xfs_alloc.c             |   96 +++++-----
 fs/xfs/xfs_alloc_btree.c       |    9 +-
 fs/xfs/xfs_attr.c              |   52 +++---
 fs/xfs/xfs_attr.h              |    3 +-
 fs/xfs/xfs_attr_leaf.c         |   30 ++--
 fs/xfs/xfs_attr_sf.h           |    2 +-
 fs/xfs/xfs_bmap.c              |   17 +-
 fs/xfs/xfs_bmap_btree.c        |    2 +-
 fs/xfs/xfs_bmap_btree.h        |    1 -
 fs/xfs/xfs_btree.c             |    4 +-
 fs/xfs/xfs_buf_item.c          |   72 ++++----
 fs/xfs/xfs_da_btree.c          |    4 +-
 fs/xfs/xfs_da_btree.h          |    5 +-
 fs/xfs/xfs_dfrag.c             |   43 +++--
 fs/xfs/xfs_dfrag.h             |    3 -
 fs/xfs/xfs_dir2.c              |    8 +-
 fs/xfs/xfs_dir2.h              |    4 +-
 fs/xfs/xfs_dir2_block.c        |    9 +-
 fs/xfs/xfs_dir2_leaf.c         |    2 +-
 fs/xfs/xfs_dir2_node.c         |    2 +-
 fs/xfs/xfs_dir2_node.h         |    2 -
 fs/xfs/xfs_dir2_sf.c           |    2 +-
 fs/xfs/xfs_extfree_item.c      |    4 +-
 fs/xfs/xfs_filestream.c        |   42 ++---
 fs/xfs/xfs_filestream.h        |   28 +++-
 fs/xfs/xfs_fsops.c             |   42 +++---
 fs/xfs/xfs_ialloc.c            |   62 +++----
 fs/xfs/xfs_iget.c              |   10 +-
 fs/xfs/xfs_inode.c             |  126 +++----------
 fs/xfs/xfs_inode.h             |   11 +-
 fs/xfs/xfs_inode_item.c        |  129 ++++----------
 fs/xfs/xfs_inode_item.h        |    6 -
 fs/xfs/xfs_itable.c            |   12 +-
 fs/xfs/xfs_log.c               |  383 ++++++++++++++++++++--------------------
 fs/xfs/xfs_log.h               |   19 +--
 fs/xfs/xfs_log_priv.h          |    5 -
 fs/xfs/xfs_log_recover.c       |  222 ++++++++---------------
 fs/xfs/xfs_log_recover.h       |   23 ++--
 fs/xfs/xfs_mount.c             |  183 +++++++++++++++----
 fs/xfs/xfs_mount.h             |   27 ++--
 fs/xfs/xfs_mru_cache.c         |    2 +-
 fs/xfs/xfs_mru_cache.h         |    1 -
 fs/xfs/xfs_quota.h             |    9 +-
 fs/xfs/xfs_rw.c                |  155 ----------------
 fs/xfs/xfs_rw.h                |    4 -
 fs/xfs/xfs_trans.c             |    7 +-
 fs/xfs/xfs_trans.h             |    3 +-
 fs/xfs/xfs_trans_ail.c         |   34 ++--
 fs/xfs/xfs_trans_buf.c         |   27 ++--
 fs/xfs/xfs_types.h             |    4 +-
 fs/xfs/xfs_vnodeops.c          |   33 ++--
 fs/xfs/xfs_vnodeops.h          |   10 +-
 79 files changed, 1667 insertions(+), 1597 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
