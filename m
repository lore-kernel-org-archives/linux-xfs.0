Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o0P6LmjU037468 for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 00:21:48 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E48401C76759
	for <xfs@oss.sgi.com>; Sun, 24 Jan 2010 22:22:50 -0800 (PST)
Received: from mail.internode.on.net (bld-mail16.adl2.internode.on.net
	[150.101.137.101]) by cuda.sgi.com with ESMTP id
	77dVnmmfEp2MTXkF for <xfs@oss.sgi.com>;
	Sun, 24 Jan 2010 22:22:50 -0800 (PST)
Received: from discord (unverified [121.44.156.64])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	11565359-1927428
	for <xfs@oss.sgi.com>; Mon, 25 Jan 2010 16:52:49 +1030 (CDT)
Received: from [192.168.1.6] (helo=disturbed) by discord with esmtp (Exim 4.69)
	(envelope-from <dave@fromorbit.com>) id 1NZILY-0002xU-FC
	for xfs@oss.sgi.com; Mon, 25 Jan 2010 17:22:48 +1100
Received: from dave by disturbed with local (Exim 4.71)
	(envelope-from <dave@disturbed.disaster>) id 1NZILX-0003o4-DR
	for xfs@oss.sgi.com; Mon, 25 Jan 2010 17:22:47 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/7] xfs: Use delay write promotion for dquot flushing
Date: Mon, 25 Jan 2010 17:22:42 +1100
Message-Id: <1264400564-19704-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1264400564-19704-1-git-send-email-david@fromorbit.com>
References: <1264400564-19704-1-git-send-email-david@fromorbit.com>
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

xfs_qm_dqflock_pushbuf_wait() does a very similar trick to item
pushing used to do to flush out delayed write dquot buffers. Change
it to use the new promotion method rather than an async flush.

Also, xfs_qm_dqflock_pushbuf_wait() can return without the flush lock
held, yet the callers make the assumption that after this call the
flush lock is held. Always return with the flush lock held.

Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/quota/xfs_dquot.c |   25 ++++++++++---------------
 1 files changed, 10 insertions(+), 15 deletions(-)

diff --git a/fs/xfs/quota/xfs_dquot.c b/fs/xfs/quota/xfs_dquot.c
index f9baeed..1620a56 100644
--- a/fs/xfs/quota/xfs_dquot.c
+++ b/fs/xfs/quota/xfs_dquot.c
@@ -1528,21 +1528,16 @@ xfs_qm_dqflock_pushbuf_wait(
 	 */
 	bp = xfs_incore(dqp->q_mount->m_ddev_targp, dqp->q_blkno,
 		    XFS_QI_DQCHUNKLEN(dqp->q_mount), XBF_TRYLOCK);
-	if (bp != NULL) {
-		if (XFS_BUF_ISDELAYWRITE(bp)) {
-			int	error;
-
-			if (XFS_BUF_ISPINNED(bp))
-				xfs_log_force(dqp->q_mount, 0);
-			error = xfs_bawrite(dqp->q_mount, bp);
-			if (error)
-				xfs_fs_cmn_err(CE_WARN, dqp->q_mount,
-					"xfs_qm_dqflock_pushbuf_wait: "
-					"pushbuf error %d on dqp %p, bp %p",
-					error, dqp, bp);
-		} else {
-			xfs_buf_relse(bp);
-		}
+	if (!bp)
+		goto out_lock;
+
+	if (XFS_BUF_ISDELAYWRITE(bp)) {
+		if (XFS_BUF_ISPINNED(bp))
+			xfs_log_force(dqp->q_mount, 0);
+		xfs_buf_delwri_promote(bp);
+		wake_up_process(bp->b_target->bt_task);
 	}
+	xfs_buf_relse(bp);
+out_lock:
 	xfs_dqflock(dqp);
 }
-- 
1.6.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
