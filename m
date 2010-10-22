Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9MDSisQ180172 for <xfs@oss.sgi.com>; Fri, 22 Oct 2010 08:28:44 -0500
From: Alex Elder <aelder@sgi.com>
Message-Id: <201010221329.o9MDTs0Y001227@stout.americas.sgi.com>
Date: Fri, 22 Oct 2010 08:29:54 -0500
Subject: [GIT PULL] XFS update for 2.6.37-rc1
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

The following changes since commit d4429f608abde89e8bc1e24b43cd503feb95c496:

  Merge branch 'next' of git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc (2010-10-21 21:19:54 -0700)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Alex Elder (1):
      Merge branch 'v2.6.36'

Arkadiusz Mi?kiewicz (1):
      xfs: Extend project quotas to support 32bit project ids

Christoph Hellwig (14):
      xfs: simplify xfs_qm_dqusage_adjust
      xfs: stop using xfs_qm_dqtobp in xfs_qm_dqflush
      xfs: remove the ->kill_root btree operation
      xfs: remove XFS_MOUNT_NO_PERCPU_SB
      xfs: do not use xfs_mod_incore_sb for per-cpu counters
      xfs: do not use xfs_mod_incore_sb_batch for per-cpu counters
      xfs: fix bogus m_maxagi check in xfs_iget
      xfs: remove unused t_callback field in struct xfs_trans
      xfs: fix the xfs_trans_committed
      xfs: remove xfs_refcache.h
      xfs: remove xfs_version.h
      xfs: remove xfs_globals.h
      xfs: remove xfs_cred.h
      xfs: remove xfs_buf wrappers

Dave Chinner (19):
      xfs: use range primitives for xfs page cache operations
      xfs: Introduce XFS_IOC_ZERO_RANGE
      xfs: reduce the number of CIL lock round trips during commit
      xfs: remove debug assert for per-ag reference counting
      xfs: lockless per-ag lookups
      xfs: don't use vfs writeback for pure metadata modifications
      xfs: rename xfs_buf_get_nodaddr to be more appropriate
      xfs: introduced uncached buffer read primitve
      xfs: store xfs_mount in the buftarg instead of in the xfs_buf
      xfs: kill XBF_FS_MANAGED buffers
      xfs: use unhashed buffers for size checks
      xfs: remove buftarg hash for external devices
      xfs: split inode AG walking into separate code for reclaim
      xfs: split out inode walk inode grabbing
      xfs: implement batched inode lookups for AG walking
      xfs: batch inode reclaim lookup
      xfs: serialise inode reclaim within an AG
      xfs: convert buffer cache hash to rbtree
      xfs: pack xfs_buf structure more tightly

Poyo VL (1):
      xfs: eliminate some newly-reported gcc warnings

Thomas Gleixner (1):
      xfs: semaphore cleanup

 fs/xfs/linux-2.6/xfs_buf.c     |  219 ++++++++++++----------
 fs/xfs/linux-2.6/xfs_buf.h     |   70 +++----
 fs/xfs/linux-2.6/xfs_cred.h    |   28 ---
 fs/xfs/linux-2.6/xfs_fs_subr.c |   31 ++--
 fs/xfs/linux-2.6/xfs_globals.c |    1 -
 fs/xfs/linux-2.6/xfs_globals.h |   23 ---
 fs/xfs/linux-2.6/xfs_ioctl.c   |   19 +-
 fs/xfs/linux-2.6/xfs_ioctl32.c |    5 +-
 fs/xfs/linux-2.6/xfs_ioctl32.h |    6 +-
 fs/xfs/linux-2.6/xfs_iops.c    |   39 +----
 fs/xfs/linux-2.6/xfs_linux.h   |    5 +-
 fs/xfs/linux-2.6/xfs_super.c   |   24 +--
 fs/xfs/linux-2.6/xfs_super.h   |    1 +
 fs/xfs/linux-2.6/xfs_sync.c    |  413 +++++++++++++++++++++++-----------------
 fs/xfs/linux-2.6/xfs_sync.h    |    4 +-
 fs/xfs/linux-2.6/xfs_trace.h   |    4 +-
 fs/xfs/linux-2.6/xfs_version.h |   29 ---
 fs/xfs/quota/xfs_dquot.c       |  164 ++++++++---------
 fs/xfs/quota/xfs_qm.c          |  221 +++++++---------------
 fs/xfs/quota/xfs_qm_bhv.c      |    2 +-
 fs/xfs/quota/xfs_qm_syscalls.c |   16 +--
 fs/xfs/xfs_ag.h                |    9 +
 fs/xfs/xfs_alloc.c             |    4 +-
 fs/xfs/xfs_alloc_btree.c       |   33 ----
 fs/xfs/xfs_attr.c              |   37 ++---
 fs/xfs/xfs_bmap.c              |   44 +++--
 fs/xfs/xfs_bmap.h              |    9 +-
 fs/xfs/xfs_btree.c             |   56 +++++-
 fs/xfs/xfs_btree.h             |   14 +--
 fs/xfs/xfs_buf_item.c          |    7 +-
 fs/xfs/xfs_da_btree.c          |    2 +-
 fs/xfs/xfs_dinode.h            |    5 +-
 fs/xfs/xfs_dir2_leaf.c         |    2 +-
 fs/xfs/xfs_fs.h                |    7 +-
 fs/xfs/xfs_fsops.c             |   14 +-
 fs/xfs/xfs_ialloc.c            |    2 +-
 fs/xfs/xfs_ialloc_btree.c      |   33 ----
 fs/xfs/xfs_iget.c              |    4 +-
 fs/xfs/xfs_inode.c             |   17 +-
 fs/xfs/xfs_inode.h             |   30 +++-
 fs/xfs/xfs_inode_item.c        |    9 -
 fs/xfs/xfs_itable.c            |    3 +-
 fs/xfs/xfs_log.c               |    5 +-
 fs/xfs/xfs_log_cil.c           |  232 ++++++++++++----------
 fs/xfs/xfs_log_recover.c       |   25 ++--
 fs/xfs/xfs_mount.c             |  308 ++++++++++++------------------
 fs/xfs/xfs_mount.h             |    9 +-
 fs/xfs/xfs_refcache.h          |   52 -----
 fs/xfs/xfs_rename.c            |   14 +-
 fs/xfs/xfs_rtalloc.c           |   29 ++--
 fs/xfs/xfs_sb.h                |   10 +-
 fs/xfs/xfs_trans.c             |   91 ++++++----
 fs/xfs/xfs_trans.h             |    3 +-
 fs/xfs/xfs_trans_buf.c         |    2 +-
 fs/xfs/xfs_trans_inode.c       |   30 +++
 fs/xfs/xfs_types.h             |    2 -
 fs/xfs/xfs_utils.c             |    9 +-
 fs/xfs/xfs_utils.h             |    3 +-
 fs/xfs/xfs_vnodeops.c          |   65 ++++---
 fs/xfs/xfs_vnodeops.h          |    6 +-
 60 files changed, 1185 insertions(+), 1375 deletions(-)
 delete mode 100644 fs/xfs/linux-2.6/xfs_cred.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_globals.h
 delete mode 100644 fs/xfs/linux-2.6/xfs_version.h
 delete mode 100644 fs/xfs/xfs_refcache.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
