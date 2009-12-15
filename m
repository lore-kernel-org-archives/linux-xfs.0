Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	nBFF0ZO4238792 for <xfs@oss.sgi.com>; Tue, 15 Dec 2009 09:00:36 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <200912151501.nBFF12hv014517@stout.americas.sgi.com>
Date: Tue, 15 Dec 2009 09:01:01 -0600
Subject: [GIT PULL] XFS update for 2.6.33-rc1
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

This is a rather pervasive change to XFS code that switches it from
using its own internal tracing mechanism to instead use the tracepoint
support provided elsewhere in the kernel.

Please pull this in for 2.6.33.

I have a few other much smaller XFS changes for 2.6.33 but wanted to
get past this hump first.

					-Alex


The following changes since commit 3ea6b3d0e6d0ffd91c0f8cadeb69b7133c038b32:
  Linus Torvalds (1):
        Merge branch 'for_linus' of git://git.kernel.org/.../jack/linux-udf-2.6

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (3):
      xfs: cleanup bmap extent state macros
      xfs: change the xfs_iext_insert / xfs_iext_remove
      xfs: event tracing support

 fs/xfs/Makefile                |    8 +-
 fs/xfs/linux-2.6/xfs_acl.c     |    1 +
 fs/xfs/linux-2.6/xfs_aops.c    |   52 +--
 fs/xfs/linux-2.6/xfs_aops.h    |    2 +
 fs/xfs/linux-2.6/xfs_buf.c     |  117 ++---
 fs/xfs/linux-2.6/xfs_buf.h     |   33 +-
 fs/xfs/linux-2.6/xfs_fs_subr.c |    3 +
 fs/xfs/linux-2.6/xfs_ioctl.c   |    1 +
 fs/xfs/linux-2.6/xfs_ioctl32.c |    1 +
 fs/xfs/linux-2.6/xfs_iops.c    |    1 +
 fs/xfs/linux-2.6/xfs_linux.h   |    1 -
 fs/xfs/linux-2.6/xfs_lrw.c     |   87 +---
 fs/xfs/linux-2.6/xfs_lrw.h     |   45 --
 fs/xfs/linux-2.6/xfs_super.c   |  104 +---
 fs/xfs/linux-2.6/xfs_super.h   |    7 -
 fs/xfs/linux-2.6/xfs_sync.c    |    1 +
 fs/xfs/linux-2.6/xfs_trace.c   |   75 +++
 fs/xfs/linux-2.6/xfs_trace.h   | 1369 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_vnode.h   |    4 +
 fs/xfs/quota/xfs_dquot.c       |  110 +---
 fs/xfs/quota/xfs_dquot.h       |   21 -
 fs/xfs/quota/xfs_qm.c          |   40 +-
 fs/xfs/quota/xfs_qm_syscalls.c |    4 +-
 fs/xfs/support/ktrace.c        |  323 ----------
 fs/xfs/support/ktrace.h        |   85 ---
 fs/xfs/xfs.h                   |   16 -
 fs/xfs/xfs_ag.h                |   14 +
 fs/xfs/xfs_alloc.c             |  230 ++------
 fs/xfs/xfs_alloc.h             |   27 +-
 fs/xfs/xfs_alloc_btree.c       |    1 +
 fs/xfs/xfs_attr.c              |  107 +---
 fs/xfs/xfs_attr.h              |   10 +
 fs/xfs/xfs_attr_leaf.c         |   14 +-
 fs/xfs/xfs_attr_sf.h           |   40 --
 fs/xfs/xfs_bmap.c              |  942 +++++++++-------------------
 fs/xfs/xfs_bmap.h              |   58 ++-
 fs/xfs/xfs_bmap_btree.c        |    6 -
 fs/xfs/xfs_btree.c             |    5 +-
 fs/xfs/xfs_btree_trace.h       |   17 -
 fs/xfs/xfs_buf_item.c          |   87 +--
 fs/xfs/xfs_buf_item.h          |   20 +-
 fs/xfs/xfs_da_btree.c          |    3 +-
 fs/xfs/xfs_da_btree.h          |    7 +
 fs/xfs/xfs_dfrag.c             |    2 +-
 fs/xfs/xfs_dir2.c              |    8 +-
 fs/xfs/xfs_dir2_block.c        |   20 +-
 fs/xfs/xfs_dir2_leaf.c         |   21 +-
 fs/xfs/xfs_dir2_node.c         |   27 +-
 fs/xfs/xfs_dir2_sf.c           |   26 +-
 fs/xfs/xfs_dir2_trace.c        |  216 -------
 fs/xfs/xfs_dir2_trace.h        |   72 ---
 fs/xfs/xfs_filestream.c        |    8 +-
 fs/xfs/xfs_fsops.c             |    2 +
 fs/xfs/xfs_iget.c              |  111 +---
 fs/xfs/xfs_inode.c             |   79 +--
 fs/xfs/xfs_inode.h             |   82 +--
 fs/xfs/xfs_inode_item.c        |    5 +-
 fs/xfs/xfs_iomap.c             |   85 +---
 fs/xfs/xfs_iomap.h             |    8 +
 fs/xfs/xfs_log.c               |  181 ++----
 fs/xfs/xfs_log_priv.h          |   20 +-
 fs/xfs/xfs_log_recover.c       |    1 +
 fs/xfs/xfs_mount.c             |    2 +
 fs/xfs/xfs_quota.h             |    8 +
 fs/xfs/xfs_rename.c            |    1 +
 fs/xfs/xfs_rtalloc.c           |    1 +
 fs/xfs/xfs_rw.c                |    3 +-
 fs/xfs/xfs_trans.h             |   47 ++
 fs/xfs/xfs_trans_buf.c         |   62 +-
 fs/xfs/xfs_vnodeops.c          |    8 +-
 70 files changed, 2369 insertions(+), 2836 deletions(-)
 create mode 100644 fs/xfs/linux-2.6/xfs_trace.c
 create mode 100644 fs/xfs/linux-2.6/xfs_trace.h
 delete mode 100644 fs/xfs/support/ktrace.c
 delete mode 100644 fs/xfs/support/ktrace.h
 delete mode 100644 fs/xfs/xfs_dir2_trace.c
 delete mode 100644 fs/xfs/xfs_dir2_trace.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
