Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7N8TDNd164695 for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 03:29:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EC3801DA1884
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 01:29:12 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	zFl8YP9eHIfyg8am for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 01:29:12 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QvmMC-000612-Bq
	for xfs@oss.sgi.com; Tue, 23 Aug 2011 08:29:12 +0000
Message-Id: <20110823082912.320240070@bombadil.infradead.org>
Date: Tue, 23 Aug 2011 04:28:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/11] xfs: move more delwri setup into xfs_buf_delwri_queue
References: <20110823082802.335389799@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-simplify-xfs_buf_delwri_queue-2
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

Do not transfer a reference held by the caller to the buffer on the list,
or decrement it in xfs_buf_delwri_queue, but instead grab a new reference
if needed, and let the caller drop its own reference.  Also move setting
of the XBF_DELWRI and XBF_ASYNC flags into xfs_buf_delwri_queue, and
only do it if needed.  Note that for now xfs_buf_unlock already has
XBF_DELWRI, but that will change in the following patches.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2011-08-13 06:36:49.564247143 -0700
+++ xfs/fs/xfs/xfs_buf.c	2011-08-13 06:37:38.907313161 -0700
@@ -937,11 +937,8 @@ void
 xfs_buf_unlock(
 	struct xfs_buf		*bp)
 {
-	if ((bp->b_flags & (XBF_DELWRI|_XBF_DELWRI_Q)) == XBF_DELWRI) {
-		atomic_inc(&bp->b_hold);
-		bp->b_flags |= XBF_ASYNC;
+	if ((bp->b_flags & (XBF_DELWRI|_XBF_DELWRI_Q)) == XBF_DELWRI)
 		xfs_buf_delwri_queue(bp);
-	}
 
 	XB_CLEAR_OWNER(bp);
 	up(&bp->b_sema);
@@ -1046,11 +1043,8 @@ xfs_bdwrite(
 {
 	trace_xfs_buf_bdwrite(bp, _RET_IP_);
 
-	bp->b_flags &= ~XBF_READ;
-	bp->b_flags |= (XBF_DELWRI | XBF_ASYNC);
-
 	xfs_buf_delwri_queue(bp);
-	xfs_buf_unlock(bp);
+	xfs_buf_relse(bp);
 }
 
 /*
@@ -1570,23 +1564,22 @@ xfs_buf_delwri_queue(
 
 	trace_xfs_buf_delwri_queue(bp, _RET_IP_);
 
-	ASSERT((bp->b_flags&(XBF_DELWRI|XBF_ASYNC)) == (XBF_DELWRI|XBF_ASYNC));
+	ASSERT(!(bp->b_flags & XBF_READ));
 
 	spin_lock(dwlk);
-	/* If already in the queue, dequeue and place at tail */
 	if (!list_empty(&bp->b_list)) {
+		/* if already in the queue, move it to the tail */
 		ASSERT(bp->b_flags & _XBF_DELWRI_Q);
-		atomic_dec(&bp->b_hold);
-		list_del(&bp->b_list);
-	}
-
-	if (list_empty(dwq)) {
+		list_move_tail(&bp->b_list, dwq);
+	} else {
 		/* start xfsbufd as it is about to have something to do */
-		wake_up_process(bp->b_target->bt_task);
-	}
+		if (list_empty(dwq))
+			wake_up_process(bp->b_target->bt_task);
 
-	bp->b_flags |= _XBF_DELWRI_Q;
-	list_add_tail(&bp->b_list, dwq);
+		atomic_inc(&bp->b_hold);
+		bp->b_flags |= XBF_DELWRI | _XBF_DELWRI_Q | XBF_ASYNC;
+		list_add_tail(&bp->b_list, dwq);
+	}
 	bp->b_queuetime = jiffies;
 	spin_unlock(dwlk);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
