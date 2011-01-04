Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p044m76N176201 for <xfs@oss.sgi.com>; Mon, 3 Jan 2011 22:48:08 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0305230982
	for <xfs@oss.sgi.com>; Mon,  3 Jan 2011 20:50:13 -0800 (PST)
Received: from mail.internode.on.net (bld-mail14.adl6.internode.on.net
	[150.101.137.99]) by cuda.sgi.com with ESMTP id
	JsvL3trfZYkIYDmC for <xfs@oss.sgi.com>;
	Mon, 03 Jan 2011 20:50:13 -0800 (PST)
Received: from dastard (unverified [121.44.135.206])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	52194523-1927428
	for <xfs@oss.sgi.com>; Tue, 04 Jan 2011 15:20:12 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PZyqZ-0000Ta-5R
	for xfs@oss.sgi.com; Tue, 04 Jan 2011 15:50:11 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1PZyqX-0003wg-DP
	for xfs@oss.sgi.com; Tue, 04 Jan 2011 15:50:09 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH] xfs: errors on sync superblock writes leave it locked
Date: Tue,  4 Jan 2011 15:50:09 +1100
Message-Id: <1294116609-15138-1-git-send-email-david@fromorbit.com>
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

If we get an IO error on a synchronous superblock write, we attach a
error release function to it so that when the last reference goes
away the release function is called and the buffer is invalidated
and unlocked. The buffer is left locked until the release function
is called so that other concurrent users of the buffer will be
locked out until the buffer error is fully processed.

Unfortunately, for the superblock buffer the filesyetm itself holds
a reference to the buffer which prevents the reference count from
dropping to zero and the release function being called. As a result,
once an IO error occurs on a sync write, the buffer will never be
unlocked and all future attempts to lock the buffer will hang.

To make matters worse, this problems is not unique to such buffers;
if there is a concurrent _xfs_buf_find() running, the lookup will
grab a reference to the buffer and then wait on the buffer lock,
preventing the reference count from ever falling to zero and hence
unlocking the buffer.

As such, the whole b_relse function implementation is broken because
it cannot rely on the buffer reference count falling to zero to
unlock the errored buffer. The synchronous write error path is the
only path that uses this callback - it is used to ensure that the
synchronous waiter gets the buffer error before the error state is
cleared from the buffer by the release function.

Given that the only sychronous buffer writes now go through
xfs_bwrite() and the error path in question can only occur for a
write of a dirty, logged buffer, we can call the b_relse function
when an error is detected in xfs_bwrite() after calling
xfs_buf_iowait(). The subsequent xfs_buf_relse() call in
xfs_bwrite() will then unlock the buffer and everything should
continue as per normal.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_buf.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 92f1f2a..1775269 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -908,11 +908,8 @@ xfs_buf_rele(
 
 	ASSERT(atomic_read(&bp->b_hold) > 0);
 	if (atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock)) {
-		if (bp->b_relse) {
-			atomic_inc(&bp->b_hold);
-			spin_unlock(&pag->pag_buf_lock);
-			bp->b_relse(bp);
-		} else if (!(bp->b_flags & XBF_STALE) &&
+		ASSERT(!bp->b_relse);
+		if (!(bp->b_flags & XBF_STALE) &&
 			   atomic_read(&bp->b_lru_ref)) {
 			xfs_buf_lru_add(bp);
 			spin_unlock(&pag->pag_buf_lock);
@@ -1112,8 +1109,16 @@ xfs_bwrite(
 	xfs_bdstrat_cb(bp);
 
 	error = xfs_buf_iowait(bp);
-	if (error)
+	if (error) {
+		/*
+		 * If the error caused a release function to be set, call it
+		 * now to clear the error from the buffer as we have already
+		 * harvested it.
+		 */
 		xfs_force_shutdown(mp, SHUTDOWN_META_IO_ERROR);
+		if (bp->b_relse)
+			bp->b_relse(bp);
+	}
 	xfs_buf_relse(bp);
 	return error;
 }
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
