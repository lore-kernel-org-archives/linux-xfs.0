Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p67B6l7d160029 for <xfs@oss.sgi.com>; Thu, 7 Jul 2011 06:06:47 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1B880176A800
	for <xfs@oss.sgi.com>; Thu,  7 Jul 2011 04:06:45 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	G6hh6Q1vFjQQgphx for <xfs@oss.sgi.com>;
	Thu, 07 Jul 2011 04:06:45 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QemPt-000427-Fu
	for xfs@oss.sgi.com; Thu, 07 Jul 2011 11:06:45 +0000
Message-Id: <20110707110645.456074114@bombadil.infradead.org>
Date: Thu, 07 Jul 2011 07:06:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 25/28] xfs: clean up buffer locking helpers
References: <20110707110535.205001532@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-buffer-locking
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

Rename xfs_buf_cond_lock and reverse it's return value to fit most other
trylock operations in the Kernel and XFS (with the exception of down_trylock,
after which xfs_buf_cond_lock was modelled), and replace xfs_buf_lock_val
with an xfs_buf_islocked for use in asserts, or and opencoded variant in
tracing.  remove the XFS_BUF_* wrappers for all the locking helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.c	2011-06-29 11:26:14.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.c	2011-06-29 13:57:15.596795734 +0200
@@ -499,16 +499,14 @@ found:
 	spin_unlock(&pag->pag_buf_lock);
 	xfs_perag_put(pag);
 
-	if (xfs_buf_cond_lock(bp)) {
-		/* failed, so wait for the lock if requested. */
-		if (!(flags & XBF_TRYLOCK)) {
-			xfs_buf_lock(bp);
-			XFS_STATS_INC(xb_get_locked_waited);
-		} else {
+	if (!xfs_buf_trylock(bp)) {
+		if (flags & XBF_TRYLOCK) {
 			xfs_buf_rele(bp);
 			XFS_STATS_INC(xb_busy_locked);
 			return NULL;
 		}
+		xfs_buf_lock(bp);
+		XFS_STATS_INC(xb_get_locked_waited);
 	}
 
 	/*
@@ -896,8 +894,8 @@ xfs_buf_rele(
  *	to push on stale inode buffers.
  */
 int
-xfs_buf_cond_lock(
-	xfs_buf_t		*bp)
+xfs_buf_trylock(
+	struct xfs_buf		*bp)
 {
 	int			locked;
 
@@ -907,15 +905,8 @@ xfs_buf_cond_lock(
 	else if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
 		xfs_log_force(bp->b_target->bt_mount, 0);
 
-	trace_xfs_buf_cond_lock(bp, _RET_IP_);
-	return locked ? 0 : -EBUSY;
-}
-
-int
-xfs_buf_lock_value(
-	xfs_buf_t		*bp)
-{
-	return bp->b_sema.count;
+	trace_xfs_buf_trylock(bp, _RET_IP_);
+	return locked;
 }
 
 /*
@@ -929,7 +920,7 @@ xfs_buf_lock_value(
  */
 void
 xfs_buf_lock(
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	trace_xfs_buf_lock(bp, _RET_IP_);
 
@@ -950,7 +941,7 @@ xfs_buf_lock(
  */
 void
 xfs_buf_unlock(
-	xfs_buf_t		*bp)
+	struct xfs_buf		*bp)
 {
 	if ((bp->b_flags & (XBF_DELWRI|_XBF_DELWRI_Q)) == XBF_DELWRI) {
 		atomic_inc(&bp->b_hold);
@@ -1694,7 +1685,7 @@ xfs_buf_delwri_split(
 	list_for_each_entry_safe(bp, n, dwq, b_list) {
 		ASSERT(bp->b_flags & XBF_DELWRI);
 
-		if (!XFS_BUF_ISPINNED(bp) && !xfs_buf_cond_lock(bp)) {
+		if (!XFS_BUF_ISPINNED(bp) && xfs_buf_trylock(bp)) {
 			if (!force &&
 			    time_before(jiffies, bp->b_queuetime + age)) {
 				xfs_buf_unlock(bp);
Index: xfs/fs/xfs/linux-2.6/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_buf.h	2011-06-29 13:50:40.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_buf.h	2011-06-29 13:54:35.250997736 +0200
@@ -187,10 +187,11 @@ extern void xfs_buf_free(xfs_buf_t *);
 extern void xfs_buf_rele(xfs_buf_t *);
 
 /* Locking and Unlocking Buffers */
-extern int xfs_buf_cond_lock(xfs_buf_t *);
-extern int xfs_buf_lock_value(xfs_buf_t *);
+extern int xfs_buf_trylock(xfs_buf_t *);
 extern void xfs_buf_lock(xfs_buf_t *);
 extern void xfs_buf_unlock(xfs_buf_t *);
+#define xfs_buf_islocked(bp) \
+	((bp)->b_sema.count <= 0)
 
 /* Buffer Read and Write Routines */
 extern int xfs_bwrite(struct xfs_mount *mp, struct xfs_buf *bp);
@@ -308,10 +309,6 @@ xfs_buf_set_ref(
 
 #define XFS_BUF_ISPINNED(bp)	atomic_read(&((bp)->b_pin_count))
 
-#define XFS_BUF_VALUSEMA(bp)	xfs_buf_lock_value(bp)
-#define XFS_BUF_CPSEMA(bp)	(xfs_buf_cond_lock(bp) == 0)
-#define XFS_BUF_VSEMA(bp)	xfs_buf_unlock(bp)
-#define XFS_BUF_PSEMA(bp,x)	xfs_buf_lock(bp)
 #define XFS_BUF_FINISH_IOWAIT(bp)	complete(&bp->b_iowait);
 
 #define XFS_BUF_SET_TARGET(bp, target)	((bp)->b_target = (target))
Index: xfs/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.h	2011-06-29 11:35:45.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_trace.h	2011-06-29 13:54:32.974343403 +0200
@@ -293,7 +293,7 @@ DECLARE_EVENT_CLASS(xfs_buf_class,
 		__entry->buffer_length = bp->b_buffer_length;
 		__entry->hold = atomic_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
-		__entry->lockval = xfs_buf_lock_value(bp);
+		__entry->lockval = bp->b_sema.count;
 		__entry->flags = bp->b_flags;
 		__entry->caller_ip = caller_ip;
 	),
@@ -323,7 +323,7 @@ DEFINE_BUF_EVENT(xfs_buf_bawrite);
 DEFINE_BUF_EVENT(xfs_buf_bdwrite);
 DEFINE_BUF_EVENT(xfs_buf_lock);
 DEFINE_BUF_EVENT(xfs_buf_lock_done);
-DEFINE_BUF_EVENT(xfs_buf_cond_lock);
+DEFINE_BUF_EVENT(xfs_buf_trylock);
 DEFINE_BUF_EVENT(xfs_buf_unlock);
 DEFINE_BUF_EVENT(xfs_buf_iowait);
 DEFINE_BUF_EVENT(xfs_buf_iowait_done);
@@ -366,7 +366,7 @@ DECLARE_EVENT_CLASS(xfs_buf_flags_class,
 		__entry->flags = flags;
 		__entry->hold = atomic_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
-		__entry->lockval = xfs_buf_lock_value(bp);
+		__entry->lockval = bp->b_sema.count;
 		__entry->caller_ip = caller_ip;
 	),
 	TP_printk("dev %d:%d bno 0x%llx len 0x%zx hold %d pincount %d "
@@ -409,7 +409,7 @@ TRACE_EVENT(xfs_buf_ioerror,
 		__entry->buffer_length = bp->b_buffer_length;
 		__entry->hold = atomic_read(&bp->b_hold);
 		__entry->pincount = atomic_read(&bp->b_pin_count);
-		__entry->lockval = xfs_buf_lock_value(bp);
+		__entry->lockval = bp->b_sema.count;
 		__entry->error = error;
 		__entry->flags = bp->b_flags;
 		__entry->caller_ip = caller_ip;
@@ -454,7 +454,7 @@ DECLARE_EVENT_CLASS(xfs_buf_item_class,
 		__entry->buf_flags = bip->bli_buf->b_flags;
 		__entry->buf_hold = atomic_read(&bip->bli_buf->b_hold);
 		__entry->buf_pincount = atomic_read(&bip->bli_buf->b_pin_count);
-		__entry->buf_lockval = xfs_buf_lock_value(bip->bli_buf);
+		__entry->buf_lockval = bip->bli_buf->b_sema.count;
 		__entry->li_desc = bip->bli_item.li_desc;
 		__entry->li_flags = bip->bli_item.li_flags;
 	),
Index: xfs/fs/xfs/quota/xfs_dquot.c
===================================================================
--- xfs.orig/fs/xfs/quota/xfs_dquot.c	2011-05-11 08:41:56.000000000 +0200
+++ xfs/fs/xfs/quota/xfs_dquot.c	2011-06-29 13:53:07.801471491 +0200
@@ -318,7 +318,7 @@ xfs_qm_init_dquot_blk(
 
 	ASSERT(tp);
 	ASSERT(XFS_BUF_ISBUSY(bp));
-	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
+	ASSERT(xfs_buf_islocked(bp));
 
 	d = (xfs_dqblk_t *)XFS_BUF_PTR(bp);
 
@@ -534,7 +534,7 @@ xfs_qm_dqtobp(
 	}
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
-	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
+	ASSERT(xfs_buf_islocked(bp));
 
 	/*
 	 * calculate the location of the dquot inside the buffer.
@@ -622,7 +622,7 @@ xfs_qm_dqread(
 	 * brelse it because we have the changes incore.
 	 */
 	ASSERT(XFS_BUF_ISBUSY(bp));
-	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
+	ASSERT(xfs_buf_islocked(bp));
 	xfs_trans_brelse(tp, bp);
 
 	return (error);
Index: xfs/fs/xfs/xfs_buf_item.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf_item.c	2011-04-22 06:21:45.000000000 +0200
+++ xfs/fs/xfs/xfs_buf_item.c	2011-06-29 13:53:20.938066990 +0200
@@ -420,7 +420,7 @@ xfs_buf_item_unpin(
 
 	if (freed && stale) {
 		ASSERT(bip->bli_flags & XFS_BLI_STALE);
-		ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
+		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(!(XFS_BUF_ISDELAYWRITE(bp)));
 		ASSERT(XFS_BUF_ISSTALE(bp));
 		ASSERT(bip->bli_format.blf_flags & XFS_BLF_CANCEL);
@@ -483,7 +483,7 @@ xfs_buf_item_trylock(
 
 	if (XFS_BUF_ISPINNED(bp))
 		return XFS_ITEM_PINNED;
-	if (!XFS_BUF_CPSEMA(bp))
+	if (!xfs_buf_trylock(bp))
 		return XFS_ITEM_LOCKED;
 
 	/* take a reference to the buffer.  */
@@ -905,7 +905,7 @@ xfs_buf_attach_iodone(
 	xfs_log_item_t	*head_lip;
 
 	ASSERT(XFS_BUF_ISBUSY(bp));
-	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
+	ASSERT(xfs_buf_islocked(bp));
 
 	lip->li_cb = cb;
 	if (XFS_BUF_FSPRIVATE(bp, void *) != NULL) {
Index: xfs/fs/xfs/xfs_log.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log.c	2011-06-17 14:07:57.000000000 +0200
+++ xfs/fs/xfs/xfs_log.c	2011-06-29 13:53:33.954663139 +0200
@@ -1059,7 +1059,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 	XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
 	XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
 	ASSERT(XFS_BUF_ISBUSY(bp));
-	ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
+	ASSERT(xfs_buf_islocked(bp));
 	log->l_xbuf = bp;
 
 	spin_lock_init(&log->l_icloglock);
@@ -1090,7 +1090,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 						log->l_iclog_size, 0);
 		if (!bp)
 			goto out_free_iclog;
-		if (!XFS_BUF_CPSEMA(bp))
+		if (!xfs_buf_trylock(bp))
 			ASSERT(0);
 		XFS_BUF_SET_IODONE_FUNC(bp, xlog_iodone);
 		XFS_BUF_SET_FSPRIVATE2(bp, (unsigned long)1);
@@ -1118,7 +1118,7 @@ xlog_alloc_log(xfs_mount_t	*mp,
 		iclog->ic_datap = (char *)iclog->ic_data + log->l_iclog_hsize;
 
 		ASSERT(XFS_BUF_ISBUSY(iclog->ic_bp));
-		ASSERT(XFS_BUF_VALUSEMA(iclog->ic_bp) <= 0);
+		ASSERT(xfs_buf_islocked(iclog->ic_bp));
 		init_waitqueue_head(&iclog->ic_force_wait);
 		init_waitqueue_head(&iclog->ic_write_wait);
 
Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2011-05-20 15:25:52.000000000 +0200
+++ xfs/fs/xfs/xfs_log_recover.c	2011-06-29 13:51:20.425386530 +0200
@@ -264,7 +264,7 @@ xlog_bwrite(
 	XFS_BUF_ZEROFLAGS(bp);
 	XFS_BUF_BUSY(bp);
 	XFS_BUF_HOLD(bp);
-	XFS_BUF_PSEMA(bp, PRIBIO);
+	xfs_buf_lock(bp);
 	XFS_BUF_SET_COUNT(bp, BBTOB(nbblks));
 	XFS_BUF_SET_TARGET(bp, log->l_mp->m_logdev_targp);
 
Index: xfs/fs/xfs/xfs_mount.c
===================================================================
--- xfs.orig/fs/xfs/xfs_mount.c	2011-06-29 11:38:53.000000000 +0200
+++ xfs/fs/xfs/xfs_mount.c	2011-06-29 13:51:20.425386530 +0200
@@ -1941,22 +1941,19 @@ unwind:
  * the superblock buffer if it can be locked without sleeping.
  * If it can't then we'll return NULL.
  */
-xfs_buf_t *
+struct xfs_buf *
 xfs_getsb(
-	xfs_mount_t	*mp,
-	int		flags)
+	struct xfs_mount	*mp,
+	int			flags)
 {
-	xfs_buf_t	*bp;
+	struct xfs_buf		*bp = mp->m_sb_bp;
 
-	ASSERT(mp->m_sb_bp != NULL);
-	bp = mp->m_sb_bp;
-	if (flags & XBF_TRYLOCK) {
-		if (!XFS_BUF_CPSEMA(bp)) {
+	if (!xfs_buf_trylock(bp)) {
+		if (flags & XBF_TRYLOCK)
 			return NULL;
-		}
-	} else {
-		XFS_BUF_PSEMA(bp, PRIBIO);
+		xfs_buf_lock(bp);
 	}
+
 	XFS_BUF_HOLD(bp);
 	ASSERT(XFS_BUF_ISDONE(bp));
 	return bp;
Index: xfs/fs/xfs/xfs_trans_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_trans_buf.c	2011-03-27 23:52:57.000000000 +0200
+++ xfs/fs/xfs/xfs_trans_buf.c	2011-06-29 13:53:47.084592005 +0200
@@ -160,7 +160,7 @@ xfs_trans_get_buf(xfs_trans_t	*tp,
 	 */
 	bp = xfs_trans_buf_item_match(tp, target_dev, blkno, len);
 	if (bp != NULL) {
-		ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
+		ASSERT(xfs_buf_islocked(bp));
 		if (XFS_FORCED_SHUTDOWN(tp->t_mountp))
 			XFS_BUF_SUPER_STALE(bp);
 
@@ -327,7 +327,7 @@ xfs_trans_read_buf(
 	 */
 	bp = xfs_trans_buf_item_match(tp, target, blkno, len);
 	if (bp != NULL) {
-		ASSERT(XFS_BUF_VALUSEMA(bp) <= 0);
+		ASSERT(xfs_buf_islocked(bp));
 		ASSERT(XFS_BUF_FSPRIVATE2(bp, xfs_trans_t *) == tp);
 		ASSERT(XFS_BUF_FSPRIVATE(bp, void *) != NULL);
 		ASSERT((XFS_BUF_ISERROR(bp)) == 0);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
