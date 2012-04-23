Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N5xIqf127383 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 00:59:18 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	4j1RPOCYUFLQaH30 for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 22:59:16 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMCIo-0001Zj-Gn
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:10 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMCIo-0004XX-E9
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:10 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 05/37] xfs: don't flush inodes from background inode reclaim
Date: Mon, 23 Apr 2012 15:58:35 +1000
Message-Id: <1335160747-17254-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-1-git-send-email-david@fromorbit.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
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

From: Christoph Hellwig <hch@infradead.org>

We already flush dirty inodes throug the AIL regularly, there is no reason
to have second thread compete with it and disturb the I/O pattern.  We still
do write inodes when doing a synchronous reclaim from the shrinker or during
unmount for now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
---
 fs/xfs/xfs_sync.c |  102 ++++++++++++++++++++++-------------------------------
 1 file changed, 42 insertions(+), 60 deletions(-)

diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 7163ca8..89f14e5 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -631,11 +631,8 @@ xfs_reclaim_inode_grab(
 }
 
 /*
- * Inodes in different states need to be treated differently, and the return
- * value of xfs_iflush is not sufficient to get this right. The following table
- * lists the inode states and the reclaim actions necessary for non-blocking
- * reclaim:
- *
+ * Inodes in different states need to be treated differently. The following
+ * table lists the inode states and the reclaim actions necessary:
  *
  *	inode state	     iflush ret		required action
  *      ---------------      ----------         ---------------
@@ -645,9 +642,8 @@ xfs_reclaim_inode_grab(
  *	stale, unpinned		0		reclaim
  *	clean, pinned(*)	0		requeue
  *	stale, pinned		EAGAIN		requeue
- *	dirty, delwri ok	0		requeue
- *	dirty, delwri blocked	EAGAIN		requeue
- *	dirty, sync flush	0		reclaim
+ *	dirty, async		-		requeue
+ *	dirty, sync		0		reclaim
  *
  * (*) dgc: I don't think the clean, pinned state is possible but it gets
  * handled anyway given the order of checks implemented.
@@ -658,26 +654,23 @@ xfs_reclaim_inode_grab(
  *
  * Also, because we get the flush lock first, we know that any inode that has
  * been flushed delwri has had the flush completed by the time we check that
- * the inode is clean. The clean inode check needs to be done before flushing
- * the inode delwri otherwise we would loop forever requeuing clean inodes as
- * we cannot tell apart a successful delwri flush and a clean inode from the
- * return value of xfs_iflush().
+ * the inode is clean.
  *
- * Note that because the inode is flushed delayed write by background
- * writeback, the flush lock may already be held here and waiting on it can
- * result in very long latencies. Hence for sync reclaims, where we wait on the
- * flush lock, the caller should push out delayed write inodes first before
- * trying to reclaim them to minimise the amount of time spent waiting. For
- * background relaim, we just requeue the inode for the next pass.
+ * Note that because the inode is flushed delayed write by AIL pushing, the
+ * flush lock may already be held here and waiting on it can result in very
+ * long latencies.  Hence for sync reclaims, where we wait on the flush lock,
+ * the caller should push the AIL first before trying to reclaim inodes to
+ * minimise the amount of time spent waiting.  For background relaim, we only
+ * bother to reclaim clean inodes anyway.
  *
  * Hence the order of actions after gaining the locks should be:
  *	bad		=> reclaim
  *	shutdown	=> unpin and reclaim
- *	pinned, delwri	=> requeue
+ *	pinned, async	=> requeue
  *	pinned, sync	=> unpin
  *	stale		=> reclaim
  *	clean		=> reclaim
- *	dirty, delwri	=> flush and requeue
+ *	dirty, async	=> requeue
  *	dirty, sync	=> flush, wait and reclaim
  */
 STATIC int
@@ -716,10 +709,8 @@ restart:
 		goto reclaim;
 	}
 	if (xfs_ipincount(ip)) {
-		if (!(sync_mode & SYNC_WAIT)) {
-			xfs_ifunlock(ip);
-			goto out;
-		}
+		if (!(sync_mode & SYNC_WAIT))
+			goto out_ifunlock;
 		xfs_iunpin_wait(ip);
 	}
 	if (xfs_iflags_test(ip, XFS_ISTALE))
@@ -728,6 +719,13 @@ restart:
 		goto reclaim;
 
 	/*
+	 * Never flush out dirty data during non-blocking reclaim, as it would
+	 * just contend with AIL pushing trying to do the same job.
+	 */
+	if (!(sync_mode & SYNC_WAIT))
+		goto out_ifunlock;
+
+	/*
 	 * Now we have an inode that needs flushing.
 	 *
 	 * We do a nonblocking flush here even if we are doing a SYNC_WAIT
@@ -745,42 +743,13 @@ restart:
 	 * pass through will see the stale flag set on the inode.
 	 */
 	error = xfs_iflush(ip, SYNC_TRYLOCK | sync_mode);
-	if (sync_mode & SYNC_WAIT) {
-		if (error == EAGAIN) {
-			xfs_iunlock(ip, XFS_ILOCK_EXCL);
-			/* backoff longer than in xfs_ifree_cluster */
-			delay(2);
-			goto restart;
-		}
-		xfs_iflock(ip);
-		goto reclaim;
-	}
-
-	/*
-	 * When we have to flush an inode but don't have SYNC_WAIT set, we
-	 * flush the inode out using a delwri buffer and wait for the next
-	 * call into reclaim to find it in a clean state instead of waiting for
-	 * it now. We also don't return errors here - if the error is transient
-	 * then the next reclaim pass will flush the inode, and if the error
-	 * is permanent then the next sync reclaim will reclaim the inode and
-	 * pass on the error.
-	 */
-	if (error && error != EAGAIN && !XFS_FORCED_SHUTDOWN(ip->i_mount)) {
-		xfs_warn(ip->i_mount,
-			"inode 0x%llx background reclaim flush failed with %d",
-			(long long)ip->i_ino, error);
+	if (error == EAGAIN) {
+		xfs_iunlock(ip, XFS_ILOCK_EXCL);
+		/* backoff longer than in xfs_ifree_cluster */
+		delay(2);
+		goto restart;
 	}
-out:
-	xfs_iflags_clear(ip, XFS_IRECLAIM);
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-	/*
-	 * We could return EAGAIN here to make reclaim rescan the inode tree in
-	 * a short while. However, this just burns CPU time scanning the tree
-	 * waiting for IO to complete and xfssyncd never goes back to the idle
-	 * state. Instead, return 0 to let the next scheduled background reclaim
-	 * attempt to reclaim the inode again.
-	 */
-	return 0;
+	xfs_iflock(ip);
 
 reclaim:
 	xfs_ifunlock(ip);
@@ -814,8 +783,21 @@ reclaim:
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 
 	xfs_inode_free(ip);
-
 	return error;
+
+out_ifunlock:
+	xfs_ifunlock(ip);
+out:
+	xfs_iflags_clear(ip, XFS_IRECLAIM);
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	/*
+	 * We could return EAGAIN here to make reclaim rescan the inode tree in
+	 * a short while. However, this just burns CPU time scanning the tree
+	 * waiting for IO to complete and xfssyncd never goes back to the idle
+	 * state. Instead, return 0 to let the next scheduled background reclaim
+	 * attempt to reclaim the inode again.
+	 */
+	return 0;
 }
 
 /*
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
