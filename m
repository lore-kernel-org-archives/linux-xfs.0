Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2V5eKg7241140 for <xfs@oss.sgi.com>; Tue, 31 Mar 2009 00:40:30 -0500
Received: from attica.americas.sgi.com (attica.americas.sgi.com
	[128.162.236.44])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A885A304067
	for <xfs@oss.sgi.com>; Mon, 30 Mar 2009 22:39:57 -0700 (PDT)
Date: Tue, 31 Mar 2009 00:30:13 -0500
Subject: [GIT PULL] XFS update for 2.6.30
MIME-Version: 1.0
Message-Id: <20090331053013.7642414167108@attica.americas.sgi.com>
From: felixb@sgi.com (Felix Blyakher)
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

The following changes since commit 15f7176eb1cccec0a332541285ee752b935c1c85:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../davem/net-2.6

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus

Christoph Hellwig (39):
      xfs: fix dentry aliasing issues in open_by_handle
      xfs: use mnt_want_write in compat_attrmulti ioctl
      xfs: add a separate lock class for the per-mount list of dquots
      xfs: lockdep annotations for xfs_dqlock2
      xfs: add a lock class for group/project dquots
      xfs: fix bad_features2 fixups for the root filesystem
      xfs: sanity check attr fork size
      xfs: cleanup error handling in xfs_mountfs:
      xfs: make sure to free the real-time inodes in the mount error path
      xfs: tiny cleanup for xfs_link
      xfs: remove unused XFS_MOUNT_ILOCK/XFS_MOUNT_IUNLOCK
      xfs: factor out attr fork reset handling
      xfs: merge xfs_inode_flush into xfs_fs_write_inode
      xfs: cleanup xfs_find_handle
      xfs: remove the unused XFS_QMOPT_DQLOCK flag
      xfs: remove iclog calculation special cases
      xfs: remove superflous inobt macros
      xfs: remove uchar_t/ushort_t/uint_t/ulong_t types
      xfs: merge xfs_mkdir into xfs_create
      xfs: remove XFS_QM_LOCK/XFS_QM_UNLOCK/XFS_QM_HOLD/XFS_QM_RELE
      xfs: use mutex_is_locked in XFS_DQ_IS_LOCKED
      xfs: sanitize qh_lock wrappers
      xfs: get rid of indirections in the quotaops implementation
      xfs: fix error handling in xfs_log_mount
      xfs: reject swapext ioctl on swapfiles
      xfs: prevent kernel crash due to corrupted inode log format
      xfs: prevent lockdep false positive in xfs_iget_cache_miss
      xfs: only issues a cache flush on unmount if barriers are enabled
      xfs: cleanup log unmount handling
      xfs: remove another leftover of the old inode log item format
      xfs: cleanup xlog_recover_do_trans
      xfs: cleanup xlog_bread
      xfs: kill vn_atime_* helpers.
      xfs: kill VN_BAD
      xfs: kill mutex_t typedef
      xfs: kill ino64 mount option
      xfs: remove m_litino
      xfs: remove m_attroffset
      xfs: cleanup uuid handling

Dave Chinner (3):
      Long btree pointers are still 64 bit on disk
      xfs: Check buffer lengths in log recovery
      xfs: factor out code to find the longest free extent in the AG

Eric Sandeen (3):
      [XFS] Remove the rest of the macro-to-function indirections.
      [XFS] remove always-true #ifndef HAVE_FORMAT32 tests
      don't reallocate sxp variable passed into xfs_swapext

Felix Blyakher (25):
      Merge branch 'master' of git+ssh://oss.sgi.com/oss/git/xfs/xfs
      [XFS] Warn on transaction in flight on read-only remount
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6
      xfs: Update maintainers
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6
      Merge branch 'master' of git://git.kernel.org/pub/scm/fs/xfs/xfs
      Merge branch 'master' of git://git.kernel.org/pub/scm/fs/xfs/xfs
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6
      Merge branch 'master' of git://git.kernel.org/pub/scm/fs/xfs/xfs
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6
      Revert "[XFS] use scalable vmap API"
      Revert "[XFS] remove old vmap cache"
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6
      Fix xfs debug build breakage by pushing xfs_error.h after
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6
      Merge branch 'master' of git://git.kernel.org/pub/scm/fs/xfs/xfs
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6
      xfs: increase the maximum number of supported ACL entries
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6
      Merge branch 'master' of git://git.kernel.org/pub/scm/fs/xfs/xfs
      Revert "xfs: increase the maximum number of supported ACL entries"

Hannes Eder (3):
      xfs: move declaration to header file
      xfs: make symbols static
      xfs: include header files for prototypes

Hisashi Hifumi (1):
      xfs: pagecache usage optimization

Josef 'Jeff' Sipek (1):
      xfs: cleanup error handling in xfs_swap_extents

Lachlan McIlroy (6):
      [XFS] Update maintainers
      Merge git://git.kernel.org/.../torvalds/linux-2.6
      Merge branch 'for-linus' of git+ssh://git.melbourne.sgi.com/git/xfs
      Merge branch 'master' of git://git.kernel.org/.../torvalds/linux-2.6
      Merge git://git.kernel.org/.../torvalds/linux-2.6
      Merge branch 'master' of git://git.kernel.org/pub/scm/fs/xfs/xfs

Malcolm Parsons (1):
      xfs: fix various typos

Nick Piggin (2):
      [XFS] remove old vmap cache
      [XFS] use scalable vmap API

 MAINTAINERS                     |    3 +-
 fs/xfs/Makefile                 |    1 +
 fs/xfs/linux-2.6/mutex.h        |   25 ---
 fs/xfs/linux-2.6/xfs_aops.c     |    1 +
 fs/xfs/linux-2.6/xfs_ioctl.c    |  117 +++++-------
 fs/xfs/linux-2.6/xfs_iops.c     |   33 +---
 fs/xfs/linux-2.6/xfs_linux.h    |   13 +--
 fs/xfs/linux-2.6/xfs_quotaops.c |  157 +++++++++++++++
 fs/xfs/linux-2.6/xfs_super.c    |  137 +++++---------
 fs/xfs/linux-2.6/xfs_super.h    |    1 +
 fs/xfs/linux-2.6/xfs_sync.h     |    1 +
 fs/xfs/linux-2.6/xfs_vnode.h    |   32 ---
 fs/xfs/quota/xfs_dquot.c        |   28 ++--
 fs/xfs/quota/xfs_dquot.h        |   18 +--
 fs/xfs/quota/xfs_qm.c           |  212 ++++++---------------
 fs/xfs/quota/xfs_qm.h           |   26 ++--
 fs/xfs/quota/xfs_qm_bhv.c       |    1 -
 fs/xfs/quota/xfs_qm_syscalls.c  |  190 +-----------------
 fs/xfs/quota/xfs_quota_priv.h   |   38 ++---
 fs/xfs/quota/xfs_trans_dquot.c  |   16 +-
 fs/xfs/support/debug.c          |    1 +
 fs/xfs/support/uuid.c           |   71 -------
 fs/xfs/support/uuid.h           |    4 -
 fs/xfs/xfs_ag.h                 |    4 +-
 fs/xfs/xfs_alloc.c              |   26 ++-
 fs/xfs/xfs_alloc.h              |    6 +
 fs/xfs/xfs_attr_leaf.c          |   58 +++---
 fs/xfs/xfs_bmap.c               |   76 +++++---
 fs/xfs/xfs_bmap.h               |    6 +-
 fs/xfs/xfs_btree.c              |    4 +-
 fs/xfs/xfs_btree.h              |    2 +-
 fs/xfs/xfs_da_btree.c           |    2 +-
 fs/xfs/xfs_da_btree.h           |    9 +-
 fs/xfs/xfs_dfrag.c              |   68 +++----
 fs/xfs/xfs_dinode.h             |    4 +-
 fs/xfs/xfs_dir2.c               |    2 -
 fs/xfs/xfs_dir2_block.c         |    7 +-
 fs/xfs/xfs_dir2_data.h          |    2 +-
 fs/xfs/xfs_dir2_leaf.c          |   17 +--
 fs/xfs/xfs_dir2_node.c          |    2 +-
 fs/xfs/xfs_dir2_sf.c            |   13 +--
 fs/xfs/xfs_extfree_item.h       |    6 -
 fs/xfs/xfs_filestream.c         |    9 +-
 fs/xfs/xfs_fsops.c              |    2 +-
 fs/xfs/xfs_ialloc.c             |   12 +-
 fs/xfs/xfs_ialloc_btree.c       |    2 +-
 fs/xfs/xfs_ialloc_btree.h       |   22 +--
 fs/xfs/xfs_inode.h              |    2 +-
 fs/xfs/xfs_inode_item.h         |    2 -
 fs/xfs/xfs_iomap.h              |    2 +-
 fs/xfs/xfs_itable.c             |    9 +-
 fs/xfs/xfs_log.c                |   67 ++-----
 fs/xfs/xfs_log.h                |    3 +-
 fs/xfs/xfs_log_priv.h           |    3 +-
 fs/xfs/xfs_log_recover.c        |  308 +++++++++++++++++-------------
 fs/xfs/xfs_mount.c              |  253 ++++++++++++++-----------
 fs/xfs/xfs_mount.h              |   19 +--
 fs/xfs/xfs_qmops.c              |    1 -
 fs/xfs/xfs_quota.h              |    3 +-
 fs/xfs/xfs_rtalloc.c            |   10 +
 fs/xfs/xfs_rtalloc.h            |    8 +-
 fs/xfs/xfs_trans.h              |   24 ++--
 fs/xfs/xfs_trans_ail.c          |    4 +-
 fs/xfs/xfs_trans_item.c         |    2 +-
 fs/xfs/xfs_trans_space.h        |    2 +-
 fs/xfs/xfs_types.h              |    8 -
 fs/xfs/xfs_utils.c              |    2 +-
 fs/xfs/xfs_vnodeops.c           |  408 +++++++++------------------------------
 fs/xfs/xfs_vnodeops.h           |    3 -
 69 files changed, 1031 insertions(+), 1599 deletions(-)
 delete mode 100644 fs/xfs/linux-2.6/mutex.h
 create mode 100644 fs/xfs/linux-2.6/xfs_quotaops.c

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
