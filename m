Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p2UB2Oav033745 for <xfs@oss.sgi.com>; Wed, 30 Mar 2011 06:02:25 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1978D15A8495
	for <xfs@oss.sgi.com>; Wed, 30 Mar 2011 04:05:10 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id sYoLbNu5gWoszV73 for
	<xfs@oss.sgi.com>; Wed, 30 Mar 2011 04:05:10 -0700 (PDT)
Date: Wed, 30 Mar 2011 07:05:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: use proper interfaces for on-stack plugging
Message-ID: <20110330110509.GA9507@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: jaxboe@fusionio.com

Add proper blk_start_plug/blk_finish_plug pairs for the two places where
we issue buffer I/O, and remove the blk_flush_plug in xfs_buf_lock and
xfs_buf_iowait, given that context switches already flush the per-process
plugging lists.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2011-03-29 21:55:12.863724557 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2011-03-29 21:58:39.028224204 +0200
@@ -919,8 +919,6 @@ xfs_buf_lock(
 
 	if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
 		xfs_log_force(bp->b_target->bt_mount, 0);
-	if (atomic_read(&bp->b_io_remaining))
-		blk_flush_plug(current);
 	down(&bp->b_sema);
 	XB_SET_OWNER(bp);
 
@@ -1309,8 +1307,6 @@ xfs_buf_iowait(
 {
 	trace_xfs_buf_iowait(bp, _RET_IP_);
 
-	if (atomic_read(&bp->b_io_remaining))
-		blk_flush_plug(current);
 	wait_for_completion(&bp->b_iowait);
 
 	trace_xfs_buf_iowait_done(bp, _RET_IP_);
@@ -1747,8 +1743,8 @@ xfsbufd(
 	do {
 		long	age = xfs_buf_age_centisecs * msecs_to_jiffies(10);
 		long	tout = xfs_buf_timer_centisecs * msecs_to_jiffies(10);
-		int	count = 0;
 		struct list_head tmp;
+		struct blk_plug plug;
 
 		if (unlikely(freezing(current))) {
 			set_bit(XBT_FORCE_SLEEP, &target->bt_flags);
@@ -1764,16 +1760,15 @@ xfsbufd(
 
 		xfs_buf_delwri_split(target, &tmp, age);
 		list_sort(NULL, &tmp, xfs_buf_cmp);
+
+		blk_start_plug(&plug);
 		while (!list_empty(&tmp)) {
 			struct xfs_buf *bp;
 			bp = list_first_entry(&tmp, struct xfs_buf, b_list);
 			list_del_init(&bp->b_list);
 			xfs_bdstrat_cb(bp);
-			count++;
 		}
-		if (count)
-			blk_flush_plug(current);
-
+		blk_finish_plug(&plug);
 	} while (!kthread_should_stop());
 
 	return 0;
@@ -1793,6 +1788,7 @@ xfs_flush_buftarg(
 	int		pincount = 0;
 	LIST_HEAD(tmp_list);
 	LIST_HEAD(wait_list);
+	struct blk_plug plug;
 
 	xfs_buf_runall_queues(xfsconvertd_workqueue);
 	xfs_buf_runall_queues(xfsdatad_workqueue);
@@ -1807,6 +1803,8 @@ xfs_flush_buftarg(
 	 * we do that after issuing all the IO.
 	 */
 	list_sort(NULL, &tmp_list, xfs_buf_cmp);
+
+	blk_start_plug(&plug);
 	while (!list_empty(&tmp_list)) {
 		bp = list_first_entry(&tmp_list, struct xfs_buf, b_list);
 		ASSERT(target == bp->b_target);
@@ -1817,10 +1815,10 @@ xfs_flush_buftarg(
 		}
 		xfs_bdstrat_cb(bp);
 	}
+	blk_finish_plug(&plug);
 
 	if (wait) {
-		/* Expedite and wait for IO to complete. */
-		blk_flush_plug(current);
+		/* Wait for IO to complete. */
 		while (!list_empty(&wait_list)) {
 			bp = list_first_entry(&wait_list, struct xfs_buf, b_list);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
