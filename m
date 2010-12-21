Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBL7S1rI244581 for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 01:28:01 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 926581470316
	for <xfs@oss.sgi.com>; Mon, 20 Dec 2010 23:29:56 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	Y9sY0shRLAXSniUG for <xfs@oss.sgi.com>;
	Mon, 20 Dec 2010 23:29:56 -0800 (PST)
Received: from dastard (unverified [121.44.88.148])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	39223356-1927428
	for <xfs@oss.sgi.com>; Tue, 21 Dec 2010 17:59:55 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PUwfI-0001CK-5P
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:29:44 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PUwf6-0006Yg-Ot
	for xfs@oss.sgi.com; Tue, 21 Dec 2010 18:29:32 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 00/34] xfs: scalability patchset for 2.6.38
Date: Tue, 21 Dec 2010 18:28:56 +1100
Message-Id: <1292916570-25015-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

Folks,

I'm sending the entire series of scalability patches in a single
patchbomb because I'm tired and it's too much like hard work to send
it out in multiple patchsets (i.e. I'm being lazy). Overall there
are relatively few changes:

- new patch for iolock lockdep annotations
- new patch for allocations under ilock

rcu inode freeing and lookup:
- reworked reclaim to use rcu read locking
- removed synchronise_rcu() from lookup failure
- cleaned up validity checks, added comments and rcu_read_lock_held
  annotations

AIL locking
- fixed aild sleep to use TASK_INTERRUPTABLE

Log grant scaling
- made reserveq/writeq tracing just indicate if there are queued
  tickets.
- cleaned up some minor formatting nitpicks suggested by Christoph
- split xlog_space_left() into __xlog_space_left() for AIl tail
  pushing to work off a single tail lsn value.

I'm mainly concerned with getting reviews for the few remaining
patches that don't currently have reviewed-by tags. Christoph, I
think I've fixed all the things your last round of comments covered,
so there should be relatively little remaining to be fixed up.

The series is in the following git tree which is based on the
current OSS xfs tree. Alex, once I get the remaining reviews
complete I'll update the branch and send you a pull request.

The following changes since commit 489a150f6454e2cd93d9e0ee6d7c5a361844f62a:

  xfs: factor duplicate code in xfs_alloc_ag_vextent_near into a helper (2010-12-16 16:06:15 -0600)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/dgc/xfsdev.git xfs-for-2.6.38

Dave Chinner (34):
      xfs: provide a inode iolock lockdep class
      xfs: use KM_NOFS for allocations during attribute list operations
      lib: percpu counter add unless less than functionality
      xfs: use generic per-cpu counter infrastructure
      xfs: demultiplex xfs_icsb_modify_counters()
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
      xfs: kill useless spinlock_destroy macro

 fs/xfs/linux-2.6/sv.h          |   59 ---
 fs/xfs/linux-2.6/xfs_buf.c     |  235 ++++++++----
 fs/xfs/linux-2.6/xfs_buf.h     |   22 +-
 fs/xfs/linux-2.6/xfs_linux.h   |   12 -
 fs/xfs/linux-2.6/xfs_super.c   |   26 +-
 fs/xfs/linux-2.6/xfs_sync.c    |   92 ++++-
 fs/xfs/linux-2.6/xfs_trace.h   |   30 +-
 fs/xfs/quota/xfs_dquot.c       |    1 -
 fs/xfs/xfs_ag.h                |    2 +-
 fs/xfs/xfs_attr_leaf.c         |    4 +-
 fs/xfs/xfs_bmap.c              |   34 +-
 fs/xfs/xfs_btree.c             |    9 +-
 fs/xfs/xfs_buf_item.c          |   32 +-
 fs/xfs/xfs_extfree_item.c      |   97 +++---
 fs/xfs/xfs_extfree_item.h      |   11 +-
 fs/xfs/xfs_fsops.c             |    8 +-
 fs/xfs/xfs_iget.c              |   90 ++++-
 fs/xfs/xfs_inode.c             |   54 ++-
 fs/xfs/xfs_inode.h             |   15 +-
 fs/xfs/xfs_inode_item.c        |   92 ++++-
 fs/xfs/xfs_iomap.c             |   84 ++++-
 fs/xfs/xfs_log.c               |  741 ++++++++++++++++--------------------
 fs/xfs/xfs_log_cil.c           |   17 +-
 fs/xfs/xfs_log_priv.h          |  121 +++++-
 fs/xfs/xfs_log_recover.c       |   35 +-
 fs/xfs/xfs_mount.c             |  821 ++++++++--------------------------------
 fs/xfs/xfs_mount.h             |   90 ++---
 fs/xfs/xfs_trans.c             |  102 +++++-
 fs/xfs/xfs_trans.h             |    2 +-
 fs/xfs/xfs_trans_ail.c         |  232 ++++++------
 fs/xfs/xfs_trans_extfree.c     |    8 +-
 fs/xfs/xfs_trans_priv.h        |   35 ++-
 fs/xfs/xfs_vnodeops.c          |   61 ++-
 include/linux/percpu_counter.h |   27 ++
 lib/percpu_counter.c           |   79 ++++
 35 files changed, 1698 insertions(+), 1682 deletions(-)
 delete mode 100644 fs/xfs/linux-2.6/sv.h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
