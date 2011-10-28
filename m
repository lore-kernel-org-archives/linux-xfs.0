Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3ils145572 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:45 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 05E7F203868
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:43 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	BF3thpP5wmMUQUoq for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:43 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHr-0003Dd-HC
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:43 +0000
Message-Id: <20111028100343.477098508@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:55:07 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 44/45] xfs: do not try to unpin the inode buffer in
	xfs_qm_dq_flush
References: <20111028095423.796574703@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-dqflush-dont-force-log
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

Instead of trying to unpin a pinned dquot buffer by forcing the log in
xfs_iflush let the caller handle it.  In case of AIL pushing we already
handle it more efficiently by forcing the log synchronously once after
cycling through all AIL entries.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_dquot.c |   16 +++++++---------
 fs/xfs/xfs_qm.c    |   16 ++++++++++++++++
 fs/xfs/xfs_trace.h |    1 -
 3 files changed, 23 insertions(+), 10 deletions(-)

Index: xfs/fs/xfs/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/xfs_dquot.c	2011-10-27 22:40:16.244688077 +0200
+++ xfs/fs/xfs/xfs_dquot.c	2011-10-27 22:40:18.049202868 +0200
@@ -1069,15 +1069,6 @@ xfs_qm_dqflush(
 	xfs_buf_attach_iodone(bp, xfs_qm_dqflush_done,
 				  &dqp->q_logitem.qli_item);
 
-	/*
-	 * If the buffer is pinned then push on the log so we won't
-	 * get stuck waiting in the write for too long.
-	 */
-	if (xfs_buf_ispinned(bp)) {
-		trace_xfs_dqflush_force(dqp);
-		xfs_log_force(mp, 0);
-	}
-
 	trace_xfs_dqflush_done(dqp);
 
 	*bpp = bp;
@@ -1152,6 +1143,13 @@ xfs_qm_dqpurge(
 		 */
 		error = xfs_qm_dqflush(dqp, &bp);
 		if (!error && bp) {
+			/*
+			 * If the buffer is pinned then push on the log so we
+			 * won't get stuck waiting in the write for too long.
+			 */
+			if (xfs_buf_ispinned(bp))
+				xfs_log_force(mp, 0);
+
 			error = xfs_bwrite(bp);
 			xfs_buf_relse(bp);
 		}
Index: xfs/fs/xfs/xfs_qm.c
===================================================================
--- xfs.orig/fs/xfs/xfs_qm.c	2011-10-27 22:40:16.238187917 +0200
+++ xfs/fs/xfs/xfs_qm.c	2011-10-27 22:40:18.049202868 +0200
@@ -388,6 +388,7 @@ xfs_qm_dqflush_all(
 	int			recl;
 	struct xfs_dquot	*dqp;
 	int			error = 0, error2;
+	int			pinned = 0;
 	LIST_HEAD		(buffer_list);
 
 	if (!q)
@@ -415,6 +416,12 @@ again:
 		mutex_unlock(&q->qi_dqlist_lock);
 		error = xfs_qm_dqflush(dqp, &bp);
 		if (!error && bp) {
+			/*
+			 * If the buffer is pinned then push on the log so we
+			 * won't get stuck waiting in the write for too long.
+			 */
+			if (xfs_buf_ispinned(bp))
+				pinned++;
 			xfs_buf_delwri_queue(bp, &buffer_list);
 			xfs_buf_relse(bp);
 		}
@@ -432,6 +439,8 @@ again:
 
 	mutex_unlock(&q->qi_dqlist_lock);
 out:
+	if (pinned)
+		xfs_log_force(mp, 0);
 	error2 = xfs_buf_delwri_submit(&buffer_list);
 	return error ? error : error2;
 }
@@ -1650,6 +1659,13 @@ xfs_qm_dqreclaim_one(
 			mutex_unlock(&xfs_Gqm->qm_dqfrlist_lock);
 			error = xfs_qm_dqflush(dqp, &bp);
 			if (!error && bp) {
+				/*
+				 * If the buffer is pinned then push on the
+				 * log so we won't get stuck waiting in the
+				 * write for too long.
+				 */
+				if (xfs_buf_ispinned(bp))
+					xfs_log_force(mp, 0);
 				xfs_buf_delwri_queue(bp, &buffer_list);
 				xfs_buf_relse(bp);
 			}
Index: xfs/fs/xfs/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/xfs_trace.h	2011-10-27 22:40:16.222187321 +0200
+++ xfs/fs/xfs/xfs_trace.h	2011-10-27 22:40:18.057171146 +0200
@@ -747,7 +747,6 @@ DEFINE_DQUOT_EVENT(xfs_dqput_wait);
 DEFINE_DQUOT_EVENT(xfs_dqput_free);
 DEFINE_DQUOT_EVENT(xfs_dqrele);
 DEFINE_DQUOT_EVENT(xfs_dqflush);
-DEFINE_DQUOT_EVENT(xfs_dqflush_force);
 DEFINE_DQUOT_EVENT(xfs_dqflush_done);
 
 DECLARE_EVENT_CLASS(xfs_loggrant_class,

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
