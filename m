Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0BH6jKW101960 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 11:06:45 -0600
From: Alex Elder <aelder@sgi.com>
Message-Id: <201101111708.p0BH8s0L010204@stout.americas.sgi.com>
Date: Tue, 11 Jan 2011 11:08:54 -0600
Subject: [GIT PULL] XFS update for 2.6.38-rc1
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

Linus, please pull the following XFS updates for 2.6.38.  I have two
branches for you to choose from this time:

    git://oss.sgi.com/xfs/xfs for-linus-merged  (recommended)
	This version includes one additional commit, a manual merge
	I completed to fix a merge conflict due to Nick Piggin's
	scalability changes.

    git://oss.sgi.com/xfs/xfs for-linus
	This version contains the XFS changes only, in case you want
	to do the merge yourself.

Thank you.

					-Alex

The following changes since commit 5b2eef966cb2ae307aa4ef1767f7307774bc96ca:

  Merge branch 'drm-core-next' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6 (2011-01-10 17:11:39 -0800)

are available in the git repository at:

  git://oss.sgi.com/xfs/xfs for-linus-merged

Alex Elder (1):
      Merge branch 'master' into for-linus-merged

Christoph Hellwig (16):
      xfs: remove leftovers of old buffer log items in recovery code
      xfs: use struct list_head for the buf cancel table
      xfs: refactor xlog_recover_commit_trans
      xfs: untangle phase1 vs phase2 recovery helpers
      xfs: improve mapping type check in xfs_vm_writepage
      xfs: remove some dead bio handling code
      xfs: a few small tweaks for overwrites in xfs_vm_writepage
      xfs: cleanup the xfs_iomap_write_* helpers
      xfs: kill xfs_iomap
      xfs: simplify xfs_map_blocks
      xfs: remove xfs_probe_cluster
      xfs: remove the all_bh flag from xfs_convert_page
      xfs: refactor xfs_vm_writepage
      xfs: simplify xfs_map_at_offset
      xfs: clean up xfs_alloc_ag_vextent_exact
      xfs: factor duplicate code in xfs_alloc_ag_vextent_near into a helper

Dave Chinner (30):
      xfs: provide a inode iolock lockdep class
      xfs: use KM_NOFS for allocations during attribute list operations
      xfs: dynamic speculative EOF preallocation
      xfs: don't truncate prealloc from frequently accessed inodes
      xfs: rcu free inodes
      xfs: convert inode cache lookups to use RCU locking
      xfs: convert pag_ici_lock to a spin lock
      xfs: convert xfsbud shrinker to a per-buftarg shrinker.
      xfs: add a lru to the XFS buffer cache
      xfs: connect up buffer reclaim priority hooks
      xfs: fix EFI transaction cancellation.
      xfs: Pull EFI/EFD handling out from under the AIL lock
      xfs: clean up xfs_ail_delete()
      xfs: bulk AIL insertion during transaction commit
      xfs: reduce the number of AIL push wakeups
      xfs: consume iodone callback items on buffers as they are processed
      xfs: remove all the inodes on a buffer from the AIL in bulk
      xfs: use AIL bulk update function to implement single updates
      xfs: use AIL bulk delete function to implement single delete
      xfs: convert log grant ticket queues to list heads
      xfs: fact out common grant head/log tail verification code
      xfs: rework log grant space calculations
      xfs: combine grant heads into a single 64 bit integer
      xfs: use wait queues directly for the log wait queues
      xfs: make AIL tail pushing independent of the grant lock
      xfs: convert l_last_sync_lsn to an atomic variable
      xfs: convert l_tail_lsn to an atomic variable.
      xfs: convert log grant heads to atomic variables
      xfs: introduce new locks for the log grant ticket wait queues
      xfs: convert grant head manipulations to lockless algorithm

Samuel Kvasnica (1):
      xfs: fix exporting with left over 64-bit inodes

 fs/xfs/linux-2.6/sv.h         |   59 ----
 fs/xfs/linux-2.6/xfs_aops.c   |  425 ++++++++++--------------
 fs/xfs/linux-2.6/xfs_aops.h   |   16 +
 fs/xfs/linux-2.6/xfs_buf.c    |  235 +++++++++-----
 fs/xfs/linux-2.6/xfs_buf.h    |   22 +-
 fs/xfs/linux-2.6/xfs_export.c |   12 +-
 fs/xfs/linux-2.6/xfs_linux.h  |    1 -
 fs/xfs/linux-2.6/xfs_super.c  |   22 +-
 fs/xfs/linux-2.6/xfs_sync.c   |   92 ++++--
 fs/xfs/linux-2.6/xfs_trace.h  |   59 ++--
 fs/xfs/quota/xfs_dquot.c      |    1 -
 fs/xfs/xfs_ag.h               |    2 +-
 fs/xfs/xfs_alloc.c            |  351 ++++++++------------
 fs/xfs/xfs_attr_leaf.c        |    4 +-
 fs/xfs/xfs_btree.c            |    9 +-
 fs/xfs/xfs_buf_item.c         |   32 ++-
 fs/xfs/xfs_buf_item.h         |   11 -
 fs/xfs/xfs_extfree_item.c     |   97 +++---
 fs/xfs/xfs_extfree_item.h     |   11 +-
 fs/xfs/xfs_fsops.c            |    1 +
 fs/xfs/xfs_iget.c             |   79 ++++-
 fs/xfs/xfs_inode.c            |   54 +++-
 fs/xfs/xfs_inode.h            |   15 +-
 fs/xfs/xfs_inode_item.c       |   92 +++++-
 fs/xfs/xfs_iomap.c            |  233 +++++---------
 fs/xfs/xfs_iomap.h            |   27 +--
 fs/xfs/xfs_log.c              |  739 +++++++++++++++++++----------------------
 fs/xfs/xfs_log_cil.c          |   17 +-
 fs/xfs/xfs_log_priv.h         |  127 ++++++--
 fs/xfs/xfs_log_recover.c      |  620 ++++++++++++++---------------------
 fs/xfs/xfs_mount.c            |   23 ++-
 fs/xfs/xfs_mount.h            |   14 +
 fs/xfs/xfs_trans.c            |   79 +++++-
 fs/xfs/xfs_trans.h            |    2 +-
 fs/xfs/xfs_trans_ail.c        |  232 +++++++------
 fs/xfs/xfs_trans_extfree.c    |    8 +-
 fs/xfs/xfs_trans_priv.h       |   35 ++-
 fs/xfs/xfs_vnodeops.c         |   61 +++--
 38 files changed, 1998 insertions(+), 1921 deletions(-)
 delete mode 100644 fs/xfs/linux-2.6/sv.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
