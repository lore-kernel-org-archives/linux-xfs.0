Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7EHGs3w248860 for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 12:16:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1764A136B1FF
	for <xfs@oss.sgi.com>; Sun, 14 Aug 2011 10:18:44 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	NVEkkNYLzBLpUOo5 for <xfs@oss.sgi.com>;
	Sun, 14 Aug 2011 10:18:44 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QseIt-0007og-UE
	for xfs@oss.sgi.com; Sun, 14 Aug 2011 17:16:52 +0000
Message-Id: <20110814171651.889248041@bombadil.infradead.org>
Date: Sun, 14 Aug 2011 13:15:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/6] xfs: remove the unlock argument to xfs_buf_delwri_queue
References: <20110814171517.174040686@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-simplify-xfs_buf_delwri_queue
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

We can just unlock the buffer in the caller, and the decrement of b_hold
would also be needed in the !unlock, we just never hit that case currently
given that the caller handles that case.

Signed-off-by: Christoph Hellwig <hch@lst.de>

--- xfs.orig/fs/xfs/xfs_buf.c	2011-08-11 22:29:23.490069868 +0200
+++ xfs/fs/xfs/xfs_buf.c	2011-08-11 22:31:10.196731133 +0200
@@ -43,7 +43,7 @@
 
 static kmem_zone_t *xfs_buf_zone;
 STATIC int xfsbufd(void *);
-STATIC void xfs_buf_delwri_queue(xfs_buf_t *, int);
+STATIC void xfs_buf_delwri_queue(xfs_buf_t *);
 
 static struct workqueue_struct *xfslogd_workqueue;
 struct workqueue_struct *xfsdatad_workqueue;
@@ -940,7 +940,7 @@ xfs_buf_unlock(
 	if ((bp->b_flags & (XBF_DELWRI|_XBF_DELWRI_Q)) == XBF_DELWRI) {
 		atomic_inc(&bp->b_hold);
 		bp->b_flags |= XBF_ASYNC;
-		xfs_buf_delwri_queue(bp, 0);
+		xfs_buf_delwri_queue(bp);
 	}
 
 	XB_CLEAR_OWNER(bp);
@@ -1049,7 +1049,8 @@ xfs_bdwrite(
 	bp->b_flags &= ~XBF_READ;
 	bp->b_flags |= (XBF_DELWRI | XBF_ASYNC);
 
-	xfs_buf_delwri_queue(bp, 1);
+	xfs_buf_delwri_queue(bp);
+	xfs_buf_unlock(bp);
 }
 
 /*
@@ -1562,8 +1563,7 @@ error:
  */
 STATIC void
 xfs_buf_delwri_queue(
-	xfs_buf_t		*bp,
-	int			unlock)
+	xfs_buf_t		*bp)
 {
 	struct list_head	*dwq = &bp->b_target->bt_delwrite_queue;
 	spinlock_t		*dwlk = &bp->b_target->bt_delwrite_lock;
@@ -1576,8 +1576,7 @@ xfs_buf_delwri_queue(
 	/* If already in the queue, dequeue and place at tail */
 	if (!list_empty(&bp->b_list)) {
 		ASSERT(bp->b_flags & _XBF_DELWRI_Q);
-		if (unlock)
-			atomic_dec(&bp->b_hold);
+		atomic_dec(&bp->b_hold);
 		list_del(&bp->b_list);
 	}
 
@@ -1590,9 +1589,6 @@ xfs_buf_delwri_queue(
 	list_add_tail(&bp->b_list, dwq);
 	bp->b_queuetime = jiffies;
 	spin_unlock(dwlk);
-
-	if (unlock)
-		xfs_buf_unlock(bp);
 }
 
 void

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
