Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7N8TFbn164721 for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 03:29:15 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84B7E1DA1886
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2011 01:29:13 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	xdai4VqYq3vmPfUc for <xfs@oss.sgi.com>;
	Tue, 23 Aug 2011 01:29:13 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QvmMC-00062a-Tm
	for xfs@oss.sgi.com; Tue, 23 Aug 2011 08:29:12 +0000
Message-Id: <20110823082912.891422803@bombadil.infradead.org>
Date: Tue, 23 Aug 2011 04:28:08 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/11] xfs: use the "delwri" terminology consistently
References: <20110823082802.335389799@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-delwrite
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

And also remove the strange local lock and delwri list pointers in a few
functions.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2011-08-11 22:37:58.616710453 +0200
+++ xfs/fs/xfs/xfs_buf.c	2011-08-11 22:41:08.463367486 +0200
@@ -1489,12 +1489,12 @@ xfs_setsize_buftarg(
 }
 
 STATIC int
-xfs_alloc_delwrite_queue(
+xfs_alloc_delwri_queue(
 	xfs_buftarg_t		*btp,
 	const char		*fsname)
 {
-	INIT_LIST_HEAD(&btp->bt_delwrite_queue);
-	spin_lock_init(&btp->bt_delwrite_lock);
+	INIT_LIST_HEAD(&btp->bt_delwri_queue);
+	spin_lock_init(&btp->bt_delwri_lock);
 	btp->bt_flags = 0;
 	btp->bt_task = kthread_run(xfsbufd, btp, "xfsbufd/%s", fsname);
 	if (IS_ERR(btp->bt_task))
@@ -1524,7 +1524,7 @@ xfs_alloc_buftarg(
 	spin_lock_init(&btp->bt_lru_lock);
 	if (xfs_setsize_buftarg_early(btp, bdev))
 		goto error;
-	if (xfs_alloc_delwrite_queue(btp, fsname))
+	if (xfs_alloc_delwri_queue(btp, fsname))
 		goto error;
 	btp->bt_shrinker.shrink = xfs_buftarg_shrink;
 	btp->bt_shrinker.seeks = DEFAULT_SEEKS;
@@ -1544,46 +1544,44 @@ STATIC void
 xfs_buf_delwri_queue(
 	xfs_buf_t		*bp)
 {
-	struct list_head	*dwq = &bp->b_target->bt_delwrite_queue;
-	spinlock_t		*dwlk = &bp->b_target->bt_delwrite_lock;
+	struct xfs_buftarg	*btp = bp->b_target;
 
 	trace_xfs_buf_delwri_queue(bp, _RET_IP_);
 
 	ASSERT(!(bp->b_flags & XBF_READ));
 
-	spin_lock(dwlk);
+	spin_lock(&btp->bt_delwri_lock);
 	if (!list_empty(&bp->b_list)) {
 		/* if already in the queue, move it to the tail */
 		ASSERT(bp->b_flags & _XBF_DELWRI_Q);
-		list_move_tail(&bp->b_list, dwq);
+		list_move_tail(&bp->b_list, &btp->bt_delwri_queue);
 	} else {
 		/* start xfsbufd as it is about to have something to do */
-		if (list_empty(dwq))
+		if (list_empty(&btp->bt_delwri_queue))
 			wake_up_process(bp->b_target->bt_task);
 
 		atomic_inc(&bp->b_hold);
 		bp->b_flags |= XBF_DELWRI | _XBF_DELWRI_Q | XBF_ASYNC;
-		list_add_tail(&bp->b_list, dwq);
+		list_add_tail(&bp->b_list, &btp->bt_delwri_queue);
 	}
 	bp->b_queuetime = jiffies;
-	spin_unlock(dwlk);
+	spin_unlock(&btp->bt_delwri_lock);
 }
 
 void
 xfs_buf_delwri_dequeue(
 	xfs_buf_t		*bp)
 {
-	spinlock_t		*dwlk = &bp->b_target->bt_delwrite_lock;
 	int			dequeued = 0;
 
-	spin_lock(dwlk);
+	spin_lock(&bp->b_target->bt_delwri_lock);
 	if ((bp->b_flags & XBF_DELWRI) && !list_empty(&bp->b_list)) {
 		ASSERT(bp->b_flags & _XBF_DELWRI_Q);
 		list_del_init(&bp->b_list);
 		dequeued = 1;
 	}
 	bp->b_flags &= ~(XBF_DELWRI|_XBF_DELWRI_Q);
-	spin_unlock(dwlk);
+	spin_unlock(&bp->b_target->bt_delwri_lock);
 
 	if (dequeued)
 		xfs_buf_rele(bp);
@@ -1615,9 +1613,9 @@ xfs_buf_delwri_promote(
 	if (bp->b_queuetime < jiffies - age)
 		return;
 	bp->b_queuetime = jiffies - age;
-	spin_lock(&btp->bt_delwrite_lock);
-	list_move(&bp->b_list, &btp->bt_delwrite_queue);
-	spin_unlock(&btp->bt_delwrite_lock);
+	spin_lock(&btp->bt_delwri_lock);
+	list_move(&bp->b_list, &btp->bt_delwri_queue);
+	spin_unlock(&btp->bt_delwri_lock);
 }
 
 STATIC void
@@ -1638,15 +1636,13 @@ xfs_buf_delwri_split(
 	unsigned long	age)
 {
 	xfs_buf_t	*bp, *n;
-	struct list_head *dwq = &target->bt_delwrite_queue;
-	spinlock_t	*dwlk = &target->bt_delwrite_lock;
 	int		skipped = 0;
 	int		force;
 
 	force = test_and_clear_bit(XBT_FORCE_FLUSH, &target->bt_flags);
 	INIT_LIST_HEAD(list);
-	spin_lock(dwlk);
-	list_for_each_entry_safe(bp, n, dwq, b_list) {
+	spin_lock(&target->bt_delwri_lock);
+	list_for_each_entry_safe(bp, n, &target->bt_delwri_queue, b_list) {
 		ASSERT(bp->b_flags & XBF_DELWRI);
 
 		if (!xfs_buf_ispinned(bp) && xfs_buf_trylock(bp)) {
@@ -1663,10 +1659,9 @@ xfs_buf_delwri_split(
 		} else
 			skipped++;
 	}
-	spin_unlock(dwlk);
 
+	spin_unlock(&target->bt_delwri_lock);
 	return skipped;
-
 }
 
 /*
@@ -1716,7 +1711,7 @@ xfsbufd(
 		}
 
 		/* sleep for a long time if there is nothing to do. */
-		if (list_empty(&target->bt_delwrite_queue))
+		if (list_empty(&target->bt_delwri_queue))
 			tout = MAX_SCHEDULE_TIMEOUT;
 		schedule_timeout_interruptible(tout);
 
Index: xfs/fs/xfs/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.h	2011-08-11 22:37:58.620043786 +0200
+++ xfs/fs/xfs/xfs_buf.h	2011-08-11 22:39:35.703372204 +0200
@@ -105,8 +105,8 @@ typedef struct xfs_buftarg {
 
 	/* per device delwri queue */
 	struct task_struct	*bt_task;
-	struct list_head	bt_delwrite_queue;
-	spinlock_t		bt_delwrite_lock;
+	struct list_head	bt_delwri_queue;
+	spinlock_t		bt_delwri_lock;
 	unsigned long		bt_flags;
 
 	/* LRU control structures */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
