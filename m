Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Jun 2007 22:38:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l565btWt017471
	for <xfs@oss.sgi.com>; Tue, 5 Jun 2007 22:37:57 -0700
Date: Wed, 6 Jun 2007 15:37:48 +1000
From: David Chinner <dgc@sgi.com>
Subject: review: prevent log tail-pushing unmount deadlock
Message-ID: <20070606053748.GV86004887@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

When we are unmounting the filesystem, we flush all the inodes to
disk. Unfortunately, if we have an inode cluster that has just been
freed and marked stale sitting in an incore log buffer (i.e. hasn't
been flushed to disk), it will be holding all the flush locks on the
inodes in that cluster.

xfs_iflush_all() which is called during unmount walks all the inodes
trying to reclaim them, and it doing so calls xfs_finish_reclaim() on
each inode. If the inode is dirty, if grabs the flush lock and flushes
it. Unfortunately, find dirty inodes that already have their flush lock
held and so we sleep.

At this point in the unmount process, we are running single-threaded.
There is nothing more that can push on the log to force the transaction
holding the inode flush locks to disk and hence we deadlock.

The fix is to issue a log force before flushing the inodes on
unmount so that all the flush locks will be released before we start
flushing the inodes.

Recently discovered during testing with filestreams enabled.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 fs/xfs/xfs_mount.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

Index: 2.6.x-xfs-new/fs/xfs/xfs_mount.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/xfs_mount.c	2007-04-19 13:47:41.272642686 +1000
+++ 2.6.x-xfs-new/fs/xfs/xfs_mount.c	2007-04-19 13:49:53.643581957 +1000
@@ -1162,6 +1162,17 @@ xfs_unmountfs(xfs_mount_t *mp, struct cr
 	int64_t		fsid;
 #endif
 
+	/*
+	 * We can potentially deadlock here if we have an inode cluster
+	 * that has been freed has it's buffer still pinned in memory because
+	 * the transaction is still sitting in a iclog. The stale inodes
+	 * on that buffer will have their flush locks held until the
+	 * transaction hits the disk and the callbacks run. the inode
+	 * flush takes the flush lock unconditionally and with nothing to
+	 * push out the iclog we will never get that unlocked. hence we
+	 * need to force the log first.
+	 */
+	xfs_log_force(mp, (xfs_lsn_t)0, XFS_LOG_FORCE | XFS_LOG_SYNC);
 	xfs_iflush_all(mp);
 
 	XFS_QM_DQPURGEALL(mp, XFS_QMOPT_QUOTALL | XFS_QMOPT_UMOUNTING);
