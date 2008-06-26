Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 25 Jun 2008 21:40:50 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5Q4eNoA008313
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 21:40:23 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF8C5D5613F
	for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 21:41:22 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id hzYsX8kb5IzdwM5L for <xfs@oss.sgi.com>; Wed, 25 Jun 2008 21:41:22 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/6] Replace inode flush semaphore with a completion
Date: Thu, 26 Jun 2008 14:41:13 +1000
Message-Id: <1214455277-6387-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1214455277-6387-1-git-send-email-david@fromorbit.com>
References: <1214455277-6387-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: matthew@wil.cx, linux-kernel@vger.kernel.org, Dave Chinner <david@fromorbit.com>

Use the new completion flush code to implement the inode
flush lock. Removes one of the final users of semaphores
in the XFS code base.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/xfs_iget.c       |   15 +++++++--------
 fs/xfs/xfs_inode.c      |   11 +++++------
 fs/xfs/xfs_inode.h      |    2 +-
 fs/xfs/xfs_inode_item.c |   11 +++++------
 4 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
index b07604b..5eed054 100644
--- a/fs/xfs/xfs_iget.c
+++ b/fs/xfs/xfs_iget.c
@@ -216,7 +216,7 @@ finish_inode:
 	mrlock_init(&ip->i_iolock, MRLOCK_BARRIER, "xfsio", ip->i_ino);
 	init_waitqueue_head(&ip->i_ipin_wait);
 	atomic_set(&ip->i_pincount, 0);
-	initnsema(&ip->i_flock, 1, "xfsfino");
+	init_completion_flush(&ip->i_flush);
 
 	if (lock_flags)
 		xfs_ilock(ip, lock_flags);
@@ -776,25 +776,24 @@ xfs_isilocked(
 #endif
 
 /*
- * The following three routines simply manage the i_flock
- * semaphore embedded in the inode.  This semaphore synchronizes
- * processes attempting to flush the in-core inode back to disk.
+ * Manage the i_flush queue embedded in the inode.  This completion
+ * queue synchronizes processes attempting to flush the in-core
+ * inode back to disk.
  */
 void
 xfs_iflock(xfs_inode_t *ip)
 {
-	psema(&(ip->i_flock), PINOD|PLTWAIT);
+	completion_flush_start(&ip->i_flush);
 }
 
 int
 xfs_iflock_nowait(xfs_inode_t *ip)
 {
-	return (cpsema(&(ip->i_flock)));
+	return completion_flush_start_nowait(&ip->i_flush);
 }
 
 void
 xfs_ifunlock(xfs_inode_t *ip)
 {
-	ASSERT(issemalocked(&(ip->i_flock)));
-	vsema(&(ip->i_flock));
+	complete(&ip->i_flush);
 }
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index bedc661..81e2040 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2630,7 +2630,6 @@ xfs_idestroy(
 		xfs_idestroy_fork(ip, XFS_ATTR_FORK);
 	mrfree(&ip->i_lock);
 	mrfree(&ip->i_iolock);
-	freesema(&ip->i_flock);
 
 #ifdef XFS_INODE_TRACE
 	ktrace_free(ip->i_trace);
@@ -3048,10 +3047,10 @@ cluster_corrupt_out:
 /*
  * xfs_iflush() will write a modified inode's changes out to the
  * inode's on disk home.  The caller must have the inode lock held
- * in at least shared mode and the inode flush semaphore must be
- * held as well.  The inode lock will still be held upon return from
+ * in at least shared mode and the inode flush completion must be
+ * active as well.  The inode lock will still be held upon return from
  * the call and the caller is free to unlock it.
- * The inode flush lock will be unlocked when the inode reaches the disk.
+ * The inode flush will be completed when the inode reaches the disk.
  * The flags indicate how the inode's buffer should be written out.
  */
 int
@@ -3070,7 +3069,7 @@ xfs_iflush(
 	XFS_STATS_INC(xs_iflush_count);
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
-	ASSERT(issemalocked(&(ip->i_flock)));
+	ASSERT(completion_flush_inprogress(&ip->i_flush));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > ip->i_df.if_ext_max);
 
@@ -3233,7 +3232,7 @@ xfs_iflush_int(
 #endif
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
-	ASSERT(issemalocked(&(ip->i_flock)));
+	ASSERT(completion_flush_inprogress(&ip->i_flush));
 	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_d.di_nextents > ip->i_df.if_ext_max);
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 17a04b6..caaec3c 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -223,7 +223,7 @@ typedef struct xfs_inode {
 	struct xfs_inode_log_item *i_itemp;	/* logging information */
 	mrlock_t		i_lock;		/* inode lock */
 	mrlock_t		i_iolock;	/* inode IO lock */
-	sema_t			i_flock;	/* inode flush lock */
+	struct completion	i_flush;	/* inode flush completion q */
 	atomic_t		i_pincount;	/* inode pin count */
 	wait_queue_head_t	i_ipin_wait;	/* inode pinning wait queue */
 	spinlock_t		i_flags_lock;	/* inode i_flags lock */
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 0eee08a..7c54046 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -779,11 +779,10 @@ xfs_inode_item_pushbuf(
 	ASSERT(iip->ili_push_owner == current_pid());
 
 	/*
-	 * If flushlock isn't locked anymore, chances are that the
-	 * inode flush completed and the inode was taken off the AIL.
-	 * So, just get out.
+	 * If a flush is not in progress anymore, chances are that the
+	 * inode was taken off the AIL. So, just get out.
 	 */
-	if (!issemalocked(&(ip->i_flock)) ||
+	if (!completion_flush_inprogress(&ip->i_flush) ||
 	    ((iip->ili_item.li_flags & XFS_LI_IN_AIL) == 0)) {
 		iip->ili_pushbuf_flag = 0;
 		xfs_iunlock(ip, XFS_ILOCK_SHARED);
@@ -805,7 +804,7 @@ xfs_inode_item_pushbuf(
 			 * If not, we can flush it async.
 			 */
 			dopush = ((iip->ili_item.li_flags & XFS_LI_IN_AIL) &&
-				  issemalocked(&(ip->i_flock)));
+				  completion_flush_inprogress(&ip->i_flush));
 			iip->ili_pushbuf_flag = 0;
 			xfs_iunlock(ip, XFS_ILOCK_SHARED);
 			xfs_buftrace("INODE ITEM PUSH", bp);
@@ -858,7 +857,7 @@ xfs_inode_item_push(
 	ip = iip->ili_inode;
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED));
-	ASSERT(issemalocked(&(ip->i_flock)));
+	ASSERT(completion_flush_inprogress(&ip->i_flush));
 	/*
 	 * Since we were able to lock the inode's flush lock and
 	 * we found it on the AIL, the inode must be dirty.  This
-- 
1.5.5.4
