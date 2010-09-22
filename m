Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8M6huCs050824 for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 01:43:56 -0500
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 35B35903E8
	for <xfs@oss.sgi.com>; Tue, 21 Sep 2010 23:44:49 -0700 (PDT)
Received: from mail.internode.on.net (bld-mail19.adl2.internode.on.net
	[150.101.137.104]) by cuda.sgi.com with ESMTP id
	tHg6BACWjUJdXhjd for <xfs@oss.sgi.com>;
	Tue, 21 Sep 2010 23:44:49 -0700 (PDT)
Received: from dastard (unverified [121.44.66.70])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	39842541-1927428
	for <xfs@oss.sgi.com>; Wed, 22 Sep 2010 16:14:47 +0930 (CST)
Received: from disturbed ([192.168.1.9]) by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1OyJ4G-0003tb-7S
	for xfs@oss.sgi.com; Wed, 22 Sep 2010 16:44:36 +1000
Received: from dave by disturbed with local (Exim 4.72)
	(envelope-from <dave@disturbed.disaster>) id 1OyJ4D-0002kn-Vp
	for xfs@oss.sgi.com; Wed, 22 Sep 2010 16:44:33 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 0/16] xfs: metadata scalability V2
Date: Wed, 22 Sep 2010 16:44:13 +1000
Message-Id: <1285137869-10310-1-git-send-email-david@fromorbit.com>
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

This patchset started out as a "convert the buffer cache to rbtrees"
patch, and just gew from there as I peeled the onion from one
bottleneck to another. The second version of this patch does not go
as far as the first version - it drops the more radical changes as
they are not ready for integration yet.

I dropped the RCU inode cache lookups because it is not well enough
tested yet.  The lock contention reductions allowed by the RCU inode
cache lookups are replaced by more efficient lookup mechanisms
during inode cache walking - using batching mechanisms as originally
suggested by Nick Piggin. This code is more efficient than Nick's
proof of concept as it uses batched gang lookups on the radix trees.
These batched lookups show almost the same performance improvement
as the RCU lookup did but without changing the locking algorithms at
all. This batching is necessary for efficient reclaim walks
regardless of whether the sync walk is protected by RCU or the
current rwlock.

I also dropped the no-page-cache conversion patches for the buffer
cache as they need more work and testing before they are ready.

The shrinker rework improves parallel unlink performance
substantially more than just single threading the shrinker execution
and does not have the OOM problems that single threading the
shrinker had. It avoids the OOM problems by ensuring that every
shrinker call does some work or sleeps while waiting for an AG to do
some work on. The lookup optimisations done for gang lookups ensure
that the scanning is as efficient as possible, so overall shrinker
overhead has gone down significantly.

Performance numbers here are 8-way fs_mark create to 50M files, and
8-way rm -rf to remove the files created.

			wall time	fs_mark rate
2.6.36-rc4:
	create:		13m10s		65k file/s
	unlink:		23m58s		N/A

2.6.36-rc4 + v1-patchset:
	create:		 9m47s		95k files/s
	unlink:		14m16s		N/A

2.6.36-rc3 + v2-patchset:
	create:		10m32s		85k file/s
	unlink:		11m49s		N/A

So as you can see, the new patch set is a little slower on creates than
the previous version, but is still much faster than vanilla. The
unlink test is much faster than both vanilla and the previous version
thanks to the rework of the reclaim lookup and shrinker operations.

A breif description of the changes are:

xfs: reduce the number of CIL lock round trips during commit
	- reduces lock traffic on the xc_cil_lock by two orders of
	  magnitude

xfs: remove debug assert for per-ag reference counting
xfs: lockless per-ag lookups
	- hottest lock in the system with buffer cache rbtree path
	- converted to use RCU.

xfs: don't use vfs writeback for pure metadata modifications
	- inode writeback does not keep up with dirtying 100,000
	  inodes a second. Avoids the superblock dirty list where
	  possible by using the AIL as the age-order flusher.

xfs: rename xfs_buf_get_nodaddr to be more appropriate
xfs: introduced uncached buffer read primitve
xfs: store xfs_mount in the buftarg instead of in the xfs_buf
xfs: kill XBF_FS_MANAGED buffers
xfs: use unhashed buffers for size checks
xfs: remove buftarg hash for external devices
	- preparatory buffer cache API cleanup patches

xfs: split inode AG walking into separate code for reclaim
xfs: implement batched inode lookups for AG walking
xfs: batch inode reclaim lookup
xfs: serialise inode reclaim within an AG
	- inode cache shrinker rework

xfs: convert buffer cache hash to rbtree
xfs; pack xfs_buf structure more tightly
	- conversion of buffer cache to use rbtrees for caches.

Version 2:
o dropped inode cache RCU/spinlock conversion (needs more testing)
o dropped buffer cache LRU/no page cache conversion (needs more testing)
o added CIL item insertion cleanup as suggested by Christoph.
o added flags to xfs_buf_get_uncached() and xfs_buf_read_uncached()
  to control memory allocation flags.
o cleaned up buffer page allocation failure path
o reworked inode reclaim shrinker scalability
	- separated reclaim AG walk from sync walks
	- implemented batch lookups for both sync and reclaim walks
	- added per-ag reclaim serialisation locks and traversal
	  cursors


The patches are available in the following git tree. The branch is
based on the current OSS xfs tree, and as such is based on
2.6.36-rc3 (which is why the tests were run on -rc3 instead of
-rc4).

Note: The branch also contains Christoph's btree + dquot cleanups;
they have been sitting in my tree being tested for quite some time
now and have been tested all through this metadata scalability work.

The following changes since commit 0e251465b06b75dfed16b9373c25cce85eeda484:

  xfs: log IO completion workqueue is a high priority queue (2010-09-10 10:15:51 -0500)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/dgc/xfsdev.git metadata-scale

Christoph Hellwig (3):
      xfs: remove the ->kill_root btree operation
      xfs: simplify xfs_qm_dqusage_adjust
      xfs: stop using xfs_qm_dqtobp in xfs_qm_dqflush

Dave Chinner (16):
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
      xfs: implement batched inode lookups for AG walking
      xfs: batch inode reclaim lookup
      xfs: serialise inode reclaim within an AG
      xfs: convert buffer cache hash to rbtree
      xfs; pack xfs_buf structure more tightly

 fs/xfs/linux-2.6/xfs_buf.c     |  198 ++++++++++++----------
 fs/xfs/linux-2.6/xfs_buf.h     |   50 +++---
 fs/xfs/linux-2.6/xfs_ioctl.c   |    2 +-
 fs/xfs/linux-2.6/xfs_iops.c    |   55 ++++--
 fs/xfs/linux-2.6/xfs_super.c   |    8 +-
 fs/xfs/linux-2.6/xfs_sync.c    |  378 +++++++++++++++++++++++-----------------
 fs/xfs/linux-2.6/xfs_sync.h    |    5 +-
 fs/xfs/linux-2.6/xfs_trace.h   |    4 +-
 fs/xfs/quota/xfs_dquot.c       |  164 ++++++++----------
 fs/xfs/quota/xfs_qm.c          |  203 +++++++---------------
 fs/xfs/quota/xfs_qm_syscalls.c |   29 ++--
 fs/xfs/xfs_ag.h                |    9 +
 fs/xfs/xfs_alloc_btree.c       |   33 ----
 fs/xfs/xfs_attr.c              |   36 ++--
 fs/xfs/xfs_btree.c             |   52 +++++-
 fs/xfs/xfs_btree.h             |   14 +--
 fs/xfs/xfs_buf_item.c          |    3 +-
 fs/xfs/xfs_fsops.c             |   11 +-
 fs/xfs/xfs_ialloc_btree.c      |   33 ----
 fs/xfs/xfs_inode.h             |    1 +
 fs/xfs/xfs_inode_item.c        |    9 -
 fs/xfs/xfs_log.c               |    3 +-
 fs/xfs/xfs_log_cil.c           |  232 ++++++++++++++-----------
 fs/xfs/xfs_log_recover.c       |   19 +-
 fs/xfs/xfs_mount.c             |  152 +++++++++--------
 fs/xfs/xfs_mount.h             |    2 +
 fs/xfs/xfs_rename.c            |   12 +-
 fs/xfs/xfs_rtalloc.c           |   29 ++--
 fs/xfs/xfs_utils.c             |    4 +-
 fs/xfs/xfs_vnodeops.c          |   12 +-
 30 files changed, 884 insertions(+), 878 deletions(-)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
