Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p04516BJ177070 for <xfs@oss.sgi.com>; Mon, 3 Jan 2011 23:01:07 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E76971D083ED
	for <xfs@oss.sgi.com>; Mon,  3 Jan 2011 21:03:12 -0800 (PST)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	O2Hp1fTGnjmjVdAh for <xfs@oss.sgi.com>;
	Mon, 03 Jan 2011 21:03:12 -0800 (PST)
Received: from dastard (unverified [121.44.135.206])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	51170817-1927428
	for <xfs@oss.sgi.com>; Tue, 04 Jan 2011 15:33:11 +1030 (CDT)
Received: from dave by dastard with local (Exim 4.72)
	(envelope-from <david@fromorbit.com>) id 1PZz2x-0000VY-5R
	for xfs@oss.sgi.com; Tue, 04 Jan 2011 16:02:59 +1100
Date: Tue, 4 Jan 2011 16:02:59 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: My current xfs-for-2.6.38 tree....
Message-ID: <20110104050259.GH15179@dastard>
MIME-Version: 1.0
Content-Disposition: inline
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
To: xfs@oss.sgi.com

Folks,

FYI, my current xfs-for-2.6.38 tree has just been updated. Changes
since last update:

	- dropped the per-cpu superblock counter cleanup patches
	  from it so we can get it right before merging.
	- added unaligned aio/dio write fix series (needs review)
	- added log covering idle fix (needs review)
	- added superblock write error hang fix (needs review)

The tree can be found here (when the rsync updates git.kernel.org):

The following changes since commit 489a150f6454e2cd93d9e0ee6d7c5a361844f62a:

  xfs: factor duplicate code in xfs_alloc_ag_vextent_near into a helper (2010-12-16 16:06:15 -0600)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/dgc/xfsdev.git xfs-for-2.6.38

Dave Chinner (40):
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
      xfs: ensure sync write errors are returned
      xfs: factor common post-write isize handling code
      xfs: factor post-write newsize updates
      xfs: introduce xfs_rw_lock() helpers for locking the inode
      xfs: split direct IO write path from xfs_file_aio_write
      xfs: split buffered IO write path from xfs_file_aio_write
      xfs: factor common write setup code
      xfs: serialise unaligned direct IOs
      xfs: ensure log covering transactions are synchronous
      xfs: errors on sync superblock writes leave it locked

 fs/xfs/linux-2.6/sv.h        |   59 ----
 fs/xfs/linux-2.6/xfs_buf.c   |  248 ++++++++++-----
 fs/xfs/linux-2.6/xfs_buf.h   |   22 +-
 fs/xfs/linux-2.6/xfs_file.c  |  528 +++++++++++++++++-------------
 fs/xfs/linux-2.6/xfs_linux.h |    1 -
 fs/xfs/linux-2.6/xfs_super.c |   24 ++-
 fs/xfs/linux-2.6/xfs_sync.c  |  103 +++++--
 fs/xfs/linux-2.6/xfs_trace.h |   30 +-
 fs/xfs/quota/xfs_dquot.c     |    1 -
 fs/xfs/xfs_ag.h              |    2 +-
 fs/xfs/xfs_attr_leaf.c       |    4 +-
 fs/xfs/xfs_btree.c           |    9 +-
 fs/xfs/xfs_buf_item.c        |   32 ++-
 fs/xfs/xfs_extfree_item.c    |   97 +++---
 fs/xfs/xfs_extfree_item.h    |   11 +-
 fs/xfs/xfs_fsops.c           |   11 +-
 fs/xfs/xfs_fsops.h           |    2 +-
 fs/xfs/xfs_iget.c            |   90 ++++-
 fs/xfs/xfs_inode.c           |   54 +++-
 fs/xfs/xfs_inode.h           |   15 +-
 fs/xfs/xfs_inode_item.c      |   92 +++++-
 fs/xfs/xfs_iomap.c           |   84 +++++-
 fs/xfs/xfs_log.c             |  739 +++++++++++++++++++-----------------------
 fs/xfs/xfs_log_cil.c         |   17 +-
 fs/xfs/xfs_log_priv.h        |  121 ++++++--
 fs/xfs/xfs_log_recover.c     |   35 +--
 fs/xfs/xfs_mount.c           |   23 ++-
 fs/xfs/xfs_mount.h           |   14 +
 fs/xfs/xfs_trans.c           |   79 +++++-
 fs/xfs/xfs_trans.h           |    2 +-
 fs/xfs/xfs_trans_ail.c       |  232 +++++++-------
 fs/xfs/xfs_trans_extfree.c   |    8 +-
 fs/xfs/xfs_trans_priv.h      |   35 ++-
 fs/xfs/xfs_vnodeops.c        |   61 +++--
 34 files changed, 1723 insertions(+), 1162 deletions(-)
 delete mode 100644 fs/xfs/linux-2.6/sv.h

-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
