Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5T0rDqV025158 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 19:53:13 -0500
Received: from e31.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CECDA1775D88
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 17:53:12 -0700 (PDT)
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149]) by
	cuda.sgi.com with ESMTP id GEni7kzf3YYMgfzA for
	<xfs@oss.sgi.com>; Tue, 28 Jun 2011 17:53:12 -0700 (PDT)
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by e31.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5T0a2RT030082
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 18:36:02 -0600
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id
	p5T0r6V9175918 for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 18:53:06 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p5T0r5Kv009732
	for <xfs@oss.sgi.com>; Tue, 28 Jun 2011 18:53:05 -0600
Subject: [PATCH] xfs: replace bp->flags usage with predefined macros
From: Chandra Seetharaman <sekharan@us.ibm.com>
Date: Tue, 28 Jun 2011 17:53:04 -0700
Message-ID: <1309308784.5505.6214.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
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
To: XFS Mailing List <xfs@oss.sgi.com>
Cc: Alex Elder <aelder@sgi.com>

Cleanup: Replace bp->flags usage with predefined macros.

Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
---
diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index 5e68099..8b24dc4 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -470,7 +470,7 @@ _xfs_buf_find(
 			 * continue searching to the right for an exact match.
 			 */
 			if (bp->b_buffer_length != range_length) {
-				ASSERT(bp->b_flags & XBF_STALE);
+				ASSERT(XFS_BUF_ISSTALE(bp));
 				rbp = &(*rbp)->rb_right;
 				continue;
 			}
@@ -516,7 +516,7 @@ found:
 	 * it. We need to keep flags such as how we allocated the buffer memory
 	 * intact here.
 	 */
-	if (bp->b_flags & XBF_STALE) {
+	if (XFS_BUF_ISSTALE(bp)) {
 		ASSERT((bp->b_flags & _XBF_DELWRI_Q) == 0);
 		bp->b_flags &= XBF_MAPPED | _XBF_KMEM | _XBF_PAGES;
 	}
@@ -631,7 +631,7 @@ xfs_buf_read(
 			goto no_buffer;
 		} else {
 			/* We do not want read in the flags */
-			bp->b_flags &= ~XBF_READ;
+			XFS_BUF_UNREAD(bp);
 		}
 	}
 
@@ -868,7 +868,7 @@ xfs_buf_rele(
 
 	ASSERT(atomic_read(&bp->b_hold) > 0);
 	if (atomic_dec_and_lock(&bp->b_hold, &pag->pag_buf_lock)) {
-		if (!(bp->b_flags & XBF_STALE) &&
+		if (!XFS_BUF_ISSTALE(bp) &&
 			   atomic_read(&bp->b_lru_ref)) {
 			xfs_buf_lru_add(bp);
 			spin_unlock(&pag->pag_buf_lock);
@@ -904,7 +904,7 @@ xfs_buf_cond_lock(
 	locked = down_trylock(&bp->b_sema) == 0;
 	if (locked)
 		XB_SET_OWNER(bp);
-	else if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
+	else if (atomic_read(&bp->b_pin_count) && XFS_BUF_ISSTALE(bp))
 		xfs_log_force(bp->b_target->bt_mount, 0);
 
 	trace_xfs_buf_cond_lock(bp, _RET_IP_);
@@ -933,7 +933,7 @@ xfs_buf_lock(
 {
 	trace_xfs_buf_lock(bp, _RET_IP_);
 
-	if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
+	if (atomic_read(&bp->b_pin_count) && XFS_BUF_ISSTALE(bp))
 		xfs_log_force(bp->b_target->bt_mount, 0);
 	down(&bp->b_sema);
 	XB_SET_OWNER(bp);
@@ -954,7 +954,7 @@ xfs_buf_unlock(
 {
 	if ((bp->b_flags & (XBF_DELWRI|_XBF_DELWRI_Q)) == XBF_DELWRI) {
 		atomic_inc(&bp->b_hold);
-		bp->b_flags |= XBF_ASYNC;
+		XFS_BUF_ASYNC(bp);
 		xfs_buf_delwri_queue(bp, 0);
 	}
 
@@ -997,7 +997,7 @@ xfs_buf_iodone_work(
 
 	if (bp->b_iodone)
 		(*(bp->b_iodone))(bp);
-	else if (bp->b_flags & XBF_ASYNC)
+	else if (XFS_BUF_ISASYNC(bp))
 		xfs_buf_relse(bp);
 }
 
@@ -1010,9 +1010,9 @@ xfs_buf_ioend(
 
 	bp->b_flags &= ~(XBF_READ | XBF_WRITE | XBF_READ_AHEAD);
 	if (bp->b_error == 0)
-		bp->b_flags |= XBF_DONE;
+		XFS_BUF_DONE(bp);
 
-	if ((bp->b_iodone) || (bp->b_flags & XBF_ASYNC)) {
+	if ((bp->b_iodone) || XFS_BUF_ISASYNC(bp)) {
 		if (schedule) {
 			INIT_WORK(&bp->b_iodone_work, xfs_buf_iodone_work);
 			queue_work(xfslogd_workqueue, &bp->b_iodone_work);
@@ -1041,8 +1041,9 @@ xfs_bwrite(
 {
 	int			error;
 
-	bp->b_flags |= XBF_WRITE;
-	bp->b_flags &= ~(XBF_ASYNC | XBF_READ);
+	XFS_BUF_WRITE(bp);
+	XFS_BUF_UNASYNC(bp);
+	XFS_BUF_UNREAD(bp);
 
 	xfs_buf_delwri_dequeue(bp);
 	xfs_bdstrat_cb(bp);
@@ -1061,8 +1062,9 @@ xfs_bdwrite(
 {
 	trace_xfs_buf_bdwrite(bp, _RET_IP_);
 
-	bp->b_flags &= ~XBF_READ;
-	bp->b_flags |= (XBF_DELWRI | XBF_ASYNC);
+	XFS_BUF_UNREAD(bp);
+	XFS_BUF_DELAYWRITE(bp);
+	XFS_BUF_ASYNC(bp);
 
 	xfs_buf_delwri_queue(bp, 1);
 }
@@ -1108,7 +1110,7 @@ STATIC int
 xfs_bioerror_relse(
 	struct xfs_buf	*bp)
 {
-	int64_t		fl = XFS_BUF_BFLAGS(bp);
+	int64_t		async = XFS_BUF_ISASYNC(bp);
 	/*
 	 * No need to wait until the buffer is unpinned.
 	 * We aren't flushing it.
@@ -1122,7 +1124,7 @@ xfs_bioerror_relse(
 	XFS_BUF_DONE(bp);
 	XFS_BUF_STALE(bp);
 	XFS_BUF_CLR_IODONE_FUNC(bp);
-	if (!(fl & XBF_ASYNC)) {
+	if (!async) {
 		/*
 		 * Mark b_error and B_ERROR _both_.
 		 * Lot's of chunkcache code assumes that.
@@ -1203,7 +1205,7 @@ xfs_buf_bio_end_io(
 
 	xfs_buf_ioerror(bp, -error);
 
-	if (!error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
+	if (!error && xfs_buf_is_vmapped(bp) && (XFS_BUF_ISREAD(bp)))
 		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
 
 	_xfs_buf_ioend(bp, 1);
@@ -1223,19 +1225,19 @@ _xfs_buf_ioapply(
 	total_nr_pages = bp->b_page_count;
 	map_i = 0;
 
-	if (bp->b_flags & XBF_ORDERED) {
-		ASSERT(!(bp->b_flags & XBF_READ));
+	if (XFS_BUF_ISORDERED(bp)) {
+		ASSERT(!(XFS_BUF_ISREAD(bp)));
 		rw = WRITE_FLUSH_FUA;
 	} else if (bp->b_flags & XBF_LOG_BUFFER) {
 		ASSERT(!(bp->b_flags & XBF_READ_AHEAD));
 		bp->b_flags &= ~_XBF_RUN_QUEUES;
-		rw = (bp->b_flags & XBF_WRITE) ? WRITE_SYNC : READ_SYNC;
+		rw = XFS_BUF_ISWRITE(bp) ? WRITE_SYNC : READ_SYNC;
 	} else if (bp->b_flags & _XBF_RUN_QUEUES) {
 		ASSERT(!(bp->b_flags & XBF_READ_AHEAD));
 		bp->b_flags &= ~_XBF_RUN_QUEUES;
-		rw = (bp->b_flags & XBF_WRITE) ? WRITE_META : READ_META;
+		rw = XFS_BUF_ISWRITE(bp) ? WRITE_META : READ_META;
 	} else {
-		rw = (bp->b_flags & XBF_WRITE) ? WRITE :
+		rw = XFS_BUF_ISWRITE(bp) ? WRITE :
 		     (bp->b_flags & XBF_READ_AHEAD) ? READA : READ;
 	}
 
@@ -1289,14 +1291,13 @@ xfs_buf_iorequest(
 {
 	trace_xfs_buf_iorequest(bp, _RET_IP_);
 
-	if (bp->b_flags & XBF_DELWRI) {
+	if (XFS_BUF_ISDELAYWRITE(bp)) {
 		xfs_buf_delwri_queue(bp, 1);
 		return 0;
 	}
 
-	if (bp->b_flags & XBF_WRITE) {
+	if (XFS_BUF_ISWRITE(bp))
 		xfs_buf_wait_unpin(bp);
-	}
 
 	xfs_buf_hold(bp);
 
@@ -1622,7 +1623,7 @@ xfs_buf_delwri_dequeue(
 	int			dequeued = 0;
 
 	spin_lock(dwlk);
-	if ((bp->b_flags & XBF_DELWRI) && !list_empty(&bp->b_list)) {
+	if (XFS_BUF_ISDELAYWRITE(bp) && !list_empty(&bp->b_list)) {
 		ASSERT(bp->b_flags & _XBF_DELWRI_Q);
 		list_del_init(&bp->b_list);
 		dequeued = 1;
@@ -1650,7 +1651,7 @@ xfs_buf_delwri_promote(
 	struct xfs_buftarg *btp = bp->b_target;
 	long		age = xfs_buf_age_centisecs * msecs_to_jiffies(10) + 1;
 
-	ASSERT(bp->b_flags & XBF_DELWRI);
+	ASSERT(XFS_BUF_ISDELAYWRITE(bp));
 	ASSERT(bp->b_flags & _XBF_DELWRI_Q);
 
 	/*
@@ -1692,7 +1693,7 @@ xfs_buf_delwri_split(
 	INIT_LIST_HEAD(list);
 	spin_lock(dwlk);
 	list_for_each_entry_safe(bp, n, dwq, b_list) {
-		ASSERT(bp->b_flags & XBF_DELWRI);
+		ASSERT(XFS_BUF_ISDELAYWRITE(bp));
 
 		if (!XFS_BUF_ISPINNED(bp) && !xfs_buf_cond_lock(bp)) {
 			if (!force &&
@@ -1703,7 +1704,7 @@ xfs_buf_delwri_split(
 
 			bp->b_flags &= ~(XBF_DELWRI|_XBF_DELWRI_Q|
 					 _XBF_RUN_QUEUES);
-			bp->b_flags |= XBF_WRITE;
+			XFS_BUF_WRITE(bp);
 			list_move_tail(&bp->b_list, list);
 			trace_xfs_buf_delwri_split(bp, _RET_IP_);
 		} else
@@ -1826,7 +1827,7 @@ xfs_flush_buftarg(
 		ASSERT(target == bp->b_target);
 		list_del_init(&bp->b_list);
 		if (wait) {
-			bp->b_flags &= ~XBF_ASYNC;
+			XFS_BUF_UNASYNC(bp);
 			list_add(&bp->b_list, &wait_list);
 		}
 		xfs_bdstrat_cb(bp);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
