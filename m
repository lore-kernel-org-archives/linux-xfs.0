Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAOBPmbF101216 for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 05:25:49 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C15D91A22F5
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 03:27:25 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	2Y1nieWhgszcNFiL for <xfs@oss.sgi.com>;
	Wed, 24 Nov 2010 03:27:25 -0800 (PST)
Received: from dastard (unverified [121.44.7.57])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	47313727-1927428
	for <xfs@oss.sgi.com>; Wed, 24 Nov 2010 21:57:24 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.71)
	(envelope-from <dave@fromorbit.com>) id 1PLDVT-0002H8-4I
	for xfs@oss.sgi.com; Wed, 24 Nov 2010 22:27:23 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PLDSn-0001Wb-S5
	for xfs@oss.sgi.com; Wed, 24 Nov 2010 22:24:37 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/2] xfs: push stale, pinned buffers on trylock failures
Date: Wed, 24 Nov 2010 22:24:33 +1100
Message-Id: <1290597873-5807-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1290597873-5807-1-git-send-email-david@fromorbit.com>
References: <1290597873-5807-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

As reported by Nick Piggin, XFS is suffering from long pauses under
highly concurrent workloads when hosted on ramdisks. The problem is
that an inode buffer is stuck in the pinned state in memory and as a
result either the inode buffer or one of the inodes within the
buffer is stopping the tail of the log from being moved forward.

The system remains in this state until a periodic log force issued
by xfssyncd causes the buffer to be unpinned. The main problem is
that these are stale buffers, and are hence held locked until the
transaction/checkpoint that marked them state has been committed to
disk. When the filesystem gets into this state, only the xfssyncd
can cause the async transactions to be committed to disk and hence
unpin the inode buffer.

This problem was encountered when scaling the busy extent list, but
only the blocking lock interface was fixed to solve the problem.
Extend the same fix to the buffer trylock operations - if we fail to
lock a pinned, stale buffer, then force the log immediately so that
when the next attempt to lock it comes around, it will have been
unpinned.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   36 +++++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index aa1d353..94e69a7 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -488,29 +488,21 @@ found:
 	spin_unlock(&pag->pag_buf_lock);
 	xfs_perag_put(pag);
 
-	/* Attempt to get the semaphore without sleeping,
-	 * if this does not work then we need to drop the
-	 * spinlock and do a hard attempt on the semaphore.
+	/*
+	 * Attempt to get the semaphore without sleeping first. if we fail then
+	 * do a blocking lock if requested.
 	 */
-	if (down_trylock(&bp->b_sema)) {
+	if (xfs_buf_cond_lock(bp)) {
 		if (!(flags & XBF_TRYLOCK)) {
 			/* wait for buffer ownership */
 			xfs_buf_lock(bp);
 			XFS_STATS_INC(xb_get_locked_waited);
 		} else {
-			/* We asked for a trylock and failed, no need
-			 * to look at file offset and length here, we
-			 * know that this buffer at least overlaps our
-			 * buffer and is locked, therefore our buffer
-			 * either does not exist, or is this buffer.
-			 */
+			/* We asked for a trylock and failed.  */
 			xfs_buf_rele(bp);
 			XFS_STATS_INC(xb_busy_locked);
 			return NULL;
 		}
-	} else {
-		/* trylock worked */
-		XB_SET_OWNER(bp);
 	}
 
 	if (bp->b_flags & XBF_STALE) {
@@ -876,10 +868,18 @@ xfs_buf_rele(
  */
 
 /*
- *	Locks a buffer object, if it is not already locked.
- *	Note that this in no way locks the underlying pages, so it is only
- *	useful for synchronizing concurrent use of buffer objects, not for
- *	synchronizing independent access to the underlying pages.
+ *	Locks a buffer object, if it is not already locked.  Note that this in
+ *	no way locks the underlying pages, so it is only useful for
+ *	synchronizing concurrent use of buffer objects, not for synchronizing
+ *	independent access to the underlying pages.
+ *
+ *	If we come across a stale, pinned, locked buffer, we know that we are
+ *	being asked to lock a buffer that has been reallocated. Because it is
+ *	pinned, we know that the log has not been pushed to disk and hence it
+ *	will still be locked.  Rather than continuing to have trylock attempts
+ *	fail until someone else pushes the log, push it ourselves before
+ *	returning.  This means that the xfsaild will not get stuck trying
+ *	to push on stale inode buffers.
  */
 int
 xfs_buf_cond_lock(
@@ -890,6 +890,8 @@ xfs_buf_cond_lock(
 	locked = down_trylock(&bp->b_sema) == 0;
 	if (locked)
 		XB_SET_OWNER(bp);
+	else if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
+		xfs_log_force(bp->b_target->bt_mount, 0);
 
 	trace_xfs_buf_cond_lock(bp, _RET_IP_);
 	return locked ? 0 : -EBUSY;
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
