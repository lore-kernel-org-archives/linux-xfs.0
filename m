Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:53646 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727754AbfFCRaV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jun 2019 13:30:21 -0400
Received: from 089144193064.atnat0002.highway.a1.net ([89.144.193.64] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hXqmq-0003iG-Rq
        for linux-xfs@vger.kernel.org; Mon, 03 Jun 2019 17:30:21 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/20] xfs: use bios directly to write log buffers
Date: Mon,  3 Jun 2019 19:29:38 +0200
Message-Id: <20190603172945.13819-14-hch@lst.de>
In-Reply-To: <20190603172945.13819-1-hch@lst.de>
References: <20190603172945.13819-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Currently the XFS logging code uses the xfs_buf structure and
associated APIs to write the log buffers to disk.  This requires
various special cases in the log code and is generally not very
optimal.

Instead of using a buffer just allocate a kmem_alloc_larger region for
each log buffer, and use a bio and bio_vec array embedded in the iclog
structure to write the buffer to disk.  This also allows for using
the bio split and chaining case to deal with the case of a log
buffer wrapping around the end of the log.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log.c      | 220 ++++++++++++++++++++----------------------
 fs/xfs/xfs_log_priv.h |  15 +--
 2 files changed, 112 insertions(+), 123 deletions(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 358a19789402..1d4480ea1725 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1239,32 +1239,32 @@ xlog_space_left(
 }
 
 
-/*
- * Log function which is called when an io completes.
- *
- * The log manager needs its own routine, in order to control what
- * happens with the buffer after the write completes.
- */
 static void
-xlog_iodone(xfs_buf_t *bp)
+xlog_ioend_work(
+	struct work_struct	*work)
 {
-	struct xlog_in_core	*iclog = bp->b_log_item;
-	struct xlog		*l = iclog->ic_log;
+	struct xlog_in_core     *iclog =
+		container_of(work, struct xlog_in_core, ic_end_io_work);
+	struct xlog		*log = iclog->ic_log;
 	int			aborted = 0;
+	int			error;
+
+	if (is_vmalloc_addr(iclog->ic_data))
+		invalidate_kernel_vmap_range(iclog->ic_data, iclog->ic_io_size);
 
 	/*
 	 * Race to shutdown the filesystem if we see an error or the iclog is in
 	 * IOABORT state. The IOABORT state is only set in DEBUG mode to inject
 	 * CRC errors into log recovery.
 	 */
-	if (XFS_TEST_ERROR(bp->b_error, l->l_mp, XFS_ERRTAG_IODONE_IOERR) ||
+	error = blk_status_to_errno(iclog->ic_bio.bi_status);
+	if (XFS_TEST_ERROR(error, log->l_mp, XFS_ERRTAG_IODONE_IOERR) ||
 	    iclog->ic_state & XLOG_STATE_IOABORT) {
 		if (iclog->ic_state & XLOG_STATE_IOABORT)
 			iclog->ic_state &= ~XLOG_STATE_IOABORT;
 
-		xfs_buf_ioerror_alert(bp, __func__);
-		xfs_buf_stale(bp);
-		xfs_force_shutdown(l->l_mp, SHUTDOWN_LOG_IO_ERROR);
+		xfs_alert(log->l_mp, "log I/O error %d", error);
+		xfs_force_shutdown(log->l_mp, SHUTDOWN_LOG_IO_ERROR);
 		/*
 		 * This flag will be propagated to the trans-committed
 		 * callback routines to let them know that the log-commit
@@ -1275,17 +1275,16 @@ xlog_iodone(xfs_buf_t *bp)
 		aborted = XFS_LI_ABORTED;
 	}
 
-	/* log I/O is always issued ASYNC */
-	ASSERT(bp->b_flags & XBF_ASYNC);
 	xlog_state_done_syncing(iclog, aborted);
+	bio_uninit(&iclog->ic_bio);
 
 	/*
-	 * drop the buffer lock now that we are done. Nothing references
-	 * the buffer after this, so an unmount waiting on this lock can now
-	 * tear it down safely. As such, it is unsafe to reference the buffer
-	 * (bp) after the unlock as we could race with it being freed.
+	 * Drop the lock to signal that we are done. Nothing references the
+	 * iclog after this, so an unmount waiting on this lock can now tear it
+	 * down safely. As such, it is unsafe to reference the iclog after the
+	 * unlock as we could race with it being freed.
 	 */
-	xfs_buf_unlock(bp);
+	up(&iclog->ic_sema);
 }
 
 /*
@@ -1417,7 +1416,6 @@ xlog_alloc_log(
 	xlog_rec_header_t	*head;
 	xlog_in_core_t		**iclogp;
 	xlog_in_core_t		*iclog, *prev_iclog=NULL;
-	xfs_buf_t		*bp;
 	int			i;
 	int			error = -ENOMEM;
 	uint			log2_size = 0;
@@ -1475,30 +1473,6 @@ xlog_alloc_log(
 
 	xlog_get_iclog_buffer_size(mp, log);
 
-	/*
-	 * Use a NULL block for the extra log buffer used during splits so that
-	 * it will trigger errors if we ever try to do IO on it without first
-	 * having set it up properly.
-	 */
-	error = -ENOMEM;
-	bp = xfs_buf_alloc(log->l_targ, XFS_BUF_DADDR_NULL,
-			   BTOBB(log->l_iclog_size), XBF_NO_IOACCT);
-	if (!bp)
-		goto out_free_log;
-
-	/*
-	 * The iclogbuf buffer locks are held over IO but we are not going to do
-	 * IO yet.  Hence unlock the buffer so that the log IO path can grab it
-	 * when appropriately.
-	 */
-	ASSERT(xfs_buf_islocked(bp));
-	xfs_buf_unlock(bp);
-
-	/* use high priority wq for log I/O completion */
-	bp->b_ioend_wq = mp->m_log_workqueue;
-	bp->b_iodone = xlog_iodone;
-	log->l_xbuf = bp;
-
 	spin_lock_init(&log->l_icloglock);
 	init_waitqueue_head(&log->l_flush_wait);
 
@@ -1512,7 +1486,9 @@ xlog_alloc_log(
 	 */
 	ASSERT(log->l_iclog_size >= 4096);
 	for (i=0; i < log->l_iclog_bufs; i++) {
-		*iclogp = kmem_zalloc(sizeof(xlog_in_core_t), KM_MAYFAIL);
+		*iclogp = kmem_zalloc(struct_size(*iclogp, ic_bvec,
+				howmany(log->l_iclog_size, PAGE_SIZE)),
+				KM_MAYFAIL);
 		if (!*iclogp)
 			goto out_free_iclog;
 
@@ -1520,20 +1496,10 @@ xlog_alloc_log(
 		iclog->ic_prev = prev_iclog;
 		prev_iclog = iclog;
 
-		bp = xfs_buf_get_uncached(mp->m_logdev_targp,
-					  BTOBB(log->l_iclog_size),
-					  XBF_NO_IOACCT);
-		if (!bp)
+		iclog->ic_data = kmem_alloc_large(log->l_iclog_size,
+				KM_MAYFAIL);
+		if (!iclog->ic_data)
 			goto out_free_iclog;
-
-		ASSERT(xfs_buf_islocked(bp));
-		xfs_buf_unlock(bp);
-
-		/* use high priority wq for log I/O completion */
-		bp->b_ioend_wq = mp->m_log_workqueue;
-		bp->b_iodone = xlog_iodone;
-		iclog->ic_bp = bp;
-		iclog->ic_data = bp->b_addr;
 #ifdef DEBUG
 		log->l_iclog_bak[i] = &iclog->ic_header;
 #endif
@@ -1547,7 +1513,7 @@ xlog_alloc_log(
 		head->h_fmt = cpu_to_be32(XLOG_FMT);
 		memcpy(&head->h_fs_uuid, &mp->m_sb.sb_uuid, sizeof(uuid_t));
 
-		iclog->ic_size = BBTOB(bp->b_length) - log->l_iclog_hsize;
+		iclog->ic_size = log->l_iclog_size - log->l_iclog_hsize;
 		iclog->ic_state = XLOG_STATE_ACTIVE;
 		iclog->ic_log = log;
 		atomic_set(&iclog->ic_refcnt, 0);
@@ -1557,6 +1523,8 @@ xlog_alloc_log(
 
 		init_waitqueue_head(&iclog->ic_force_wait);
 		init_waitqueue_head(&iclog->ic_write_wait);
+		INIT_WORK(&iclog->ic_end_io_work, xlog_ioend_work);
+		sema_init(&iclog->ic_sema, 1);
 
 		iclogp = &iclog->ic_next;
 	}
@@ -1571,11 +1539,9 @@ xlog_alloc_log(
 out_free_iclog:
 	for (iclog = log->l_iclog; iclog; iclog = prev_iclog) {
 		prev_iclog = iclog->ic_next;
-		if (iclog->ic_bp)
-			xfs_buf_free(iclog->ic_bp);
+		kmem_free(iclog->ic_data);
 		kmem_free(iclog);
 	}
-	xfs_buf_free(log->l_xbuf);
 out_free_log:
 	kmem_free(log);
 out:
@@ -1760,23 +1726,43 @@ xlog_cksum(
 	return xfs_end_cksum(crc);
 }
 
+static void
+xlog_bio_end_io(
+	struct bio		*bio)
+{
+	struct xlog_in_core	*iclog = bio->bi_private;
+
+	queue_work(iclog->ic_log->l_mp->m_log_workqueue,
+		   &iclog->ic_end_io_work);
+}
+
+static void
+xlog_map_iclog_data(
+	struct bio		*bio,
+	void			*data,
+	size_t			count)
+{
+	do {
+		struct page	*page = kmem_to_page(data);
+		unsigned int	off = offset_in_page(data);
+		size_t		len = min_t(size_t, count, PAGE_SIZE - off);
+
+		WARN_ON_ONCE(bio_add_page(bio, page, len, off) != len);
+
+		data += len;
+		count -= len;
+	} while (count);
+}
+
 STATIC void
 xlog_write_iclog(
 	struct xlog		*log,
 	struct xlog_in_core	*iclog,
-	struct xfs_buf		*bp,
 	uint64_t		bno,
+	unsigned int		count,
 	bool			need_flush)
 {
 	ASSERT(bno < log->l_logBBsize);
-	ASSERT(bno + bp->b_io_length <= log->l_logBBsize);
-
-	bp->b_maps[0].bm_bn = log->l_logBBstart + bno;
-	bp->b_log_item = iclog;
-	bp->b_flags &= ~XBF_FLUSH;
-	bp->b_flags |= (XBF_ASYNC | XBF_SYNCIO | XBF_WRITE | XBF_FUA);
-	if (need_flush)
-		bp->b_flags |= XBF_FLUSH;
 
 	/*
 	 * We lock the iclogbufs here so that we can serialise against I/O
@@ -1786,11 +1772,10 @@ xlog_write_iclog(
 	 * tearing down the iclogbufs.  Hence we need to hold the buffer lock
 	 * across the log IO to archieve that.
 	 */
-	xfs_buf_lock(bp);
+	down(&iclog->ic_sema);
 	if (unlikely(iclog->ic_state & XLOG_STATE_IOERROR)) {
-		xfs_buf_ioerror(bp, -EIO);
-		xfs_buf_stale(bp);
-		xfs_buf_ioend(bp);
+		xlog_state_done_syncing(iclog, XFS_LI_ABORTED);
+		up(&iclog->ic_sema);
 		/*
 		 * It would seem logical to return EIO here, but we rely on
 		 * the log state machine to propagate I/O errors instead of
@@ -1800,7 +1785,38 @@ xlog_write_iclog(
 		return;
 	}
 
-	xfs_buf_submit(bp);
+	iclog->ic_io_size = count;
+
+	bio_init(&iclog->ic_bio, iclog->ic_bvec, howmany(count, PAGE_SIZE));
+	bio_set_dev(&iclog->ic_bio, log->l_targ->bt_bdev);
+	iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart + bno;
+	iclog->ic_bio.bi_end_io = xlog_bio_end_io;
+	iclog->ic_bio.bi_private = iclog;
+	iclog->ic_bio.bi_opf = REQ_OP_WRITE | REQ_META | REQ_SYNC | REQ_FUA;
+	if (need_flush)
+		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
+
+	xlog_map_iclog_data(&iclog->ic_bio, iclog->ic_data, iclog->ic_io_size);
+	if (is_vmalloc_addr(iclog->ic_data))
+		flush_kernel_vmap_range(iclog->ic_data, iclog->ic_io_size);
+
+	/*
+	 * If this log buffer would straddle the end of the log we will have
+	 * to split it up into two bios, so that we can continue at the start.
+	 */
+	if (bno + BTOBB(count) > log->l_logBBsize) {
+		struct bio *split;
+
+		split = bio_split(&iclog->ic_bio, log->l_logBBsize - bno,
+				  GFP_NOIO, &fs_bio_set);
+		bio_chain(split, &iclog->ic_bio);
+		submit_bio(split);
+
+		/* restart at logical offset zero for the remainder */
+		iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart;
+	}
+
+	submit_bio(&iclog->ic_bio);
 }
 
 /*
@@ -1808,7 +1824,7 @@ xlog_write_iclog(
  * written to the start of the log. Watch out for the header magic
  * number case, though.
  */
-static unsigned int
+static void
 xlog_split_iclog(
 	struct xlog		*log,
 	void			*data,
@@ -1825,8 +1841,6 @@ xlog_split_iclog(
 			cycle++;
 		put_unaligned_be32(cycle, data + i);
 	}
-
-	return split_offset;
 }
 
 static int
@@ -1893,9 +1907,8 @@ xlog_sync(
 	unsigned int		count;		/* byte count of bwrite */
 	unsigned int		roundoff;       /* roundoff to BB or stripe */
 	uint64_t		bno;
-	unsigned int		split = 0;
 	unsigned int		size;
-	bool			need_flush = true;
+	bool			need_flush = true, split = false;
 
 	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
 
@@ -1920,8 +1933,10 @@ xlog_sync(
 	bno = BLOCK_LSN(be64_to_cpu(iclog->ic_header.h_lsn));
 
 	/* Do we need to split this write into 2 parts? */
-	if (bno + BTOBB(count) > log->l_logBBsize)
-		split = xlog_split_iclog(log, &iclog->ic_header, bno, count);
+	if (bno + BTOBB(count) > log->l_logBBsize) {
+		xlog_split_iclog(log, &iclog->ic_header, bno, count);
+		split = true;
+	}
 
 	/* calculcate the checksum */
 	iclog->ic_header.h_crc = xlog_cksum(log, &iclog->ic_header,
@@ -1954,18 +1969,8 @@ xlog_sync(
 		need_flush = false;
 	}
 
-	iclog->ic_bp->b_io_length = BTOBB(split ? split : count);
-	iclog->ic_bwritecnt = split ? 2 : 1;
-
 	xlog_verify_iclog(log, iclog, count);
-	xlog_write_iclog(log, iclog, iclog->ic_bp, bno, need_flush);
-
-	if (split) {
-		xfs_buf_associate_memory(iclog->ic_log->l_xbuf,
-				(char *)&iclog->ic_header + split,
-				count - split);
-		xlog_write_iclog(log, iclog, iclog->ic_log->l_xbuf, 0, false);
-	}
+	xlog_write_iclog(log, iclog, bno, count, need_flush);
 }
 
 /*
@@ -1986,25 +1991,15 @@ xlog_dealloc_log(
 	 */
 	iclog = log->l_iclog;
 	for (i = 0; i < log->l_iclog_bufs; i++) {
-		xfs_buf_lock(iclog->ic_bp);
-		xfs_buf_unlock(iclog->ic_bp);
+		down(&iclog->ic_sema);
+		up(&iclog->ic_sema);
 		iclog = iclog->ic_next;
 	}
 
-	/*
-	 * Always need to ensure that the extra buffer does not point to memory
-	 * owned by another log buffer before we free it. Also, cycle the lock
-	 * first to ensure we've completed IO on it.
-	 */
-	xfs_buf_lock(log->l_xbuf);
-	xfs_buf_unlock(log->l_xbuf);
-	xfs_buf_set_empty(log->l_xbuf, BTOBB(log->l_iclog_size));
-	xfs_buf_free(log->l_xbuf);
-
 	iclog = log->l_iclog;
 	for (i = 0; i < log->l_iclog_bufs; i++) {
-		xfs_buf_free(iclog->ic_bp);
 		next_iclog = iclog->ic_next;
+		kmem_free(iclog->ic_data);
 		kmem_free(iclog);
 		iclog = next_iclog;
 	}
@@ -2922,8 +2917,6 @@ xlog_state_done_syncing(
 	ASSERT(iclog->ic_state == XLOG_STATE_SYNCING ||
 	       iclog->ic_state == XLOG_STATE_IOERROR);
 	ASSERT(atomic_read(&iclog->ic_refcnt) == 0);
-	ASSERT(iclog->ic_bwritecnt == 1 || iclog->ic_bwritecnt == 2);
-
 
 	/*
 	 * If we got an error, either on the first buffer, or in the case of
@@ -2931,13 +2924,8 @@ xlog_state_done_syncing(
 	 * and none should ever be attempted to be written to disk
 	 * again.
 	 */
-	if (iclog->ic_state != XLOG_STATE_IOERROR) {
-		if (--iclog->ic_bwritecnt == 1) {
-			spin_unlock(&log->l_icloglock);
-			return;
-		}
+	if (iclog->ic_state != XLOG_STATE_IOERROR)
 		iclog->ic_state = XLOG_STATE_DONE_SYNC;
-	}
 
 	/*
 	 * Someone could be sleeping prior to writing out the next
diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index b5f82cb36202..062ee9c13039 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -179,7 +179,6 @@ typedef struct xlog_ticket {
  *	the iclog.
  * - ic_forcewait is used to implement synchronous forcing of the iclog to disk.
  * - ic_next is the pointer to the next iclog in the ring.
- * - ic_bp is a pointer to the buffer used to write this incore log to disk.
  * - ic_log is a pointer back to the global log structure.
  * - ic_callback is a linked list of callback function/argument pairs to be
  *	called after an iclog finishes writing.
@@ -206,11 +205,10 @@ typedef struct xlog_in_core {
 	wait_queue_head_t	ic_write_wait;
 	struct xlog_in_core	*ic_next;
 	struct xlog_in_core	*ic_prev;
-	struct xfs_buf		*ic_bp;
 	struct xlog		*ic_log;
-	int			ic_size;
-	int			ic_offset;
-	int			ic_bwritecnt;
+	u32			ic_size;
+	u32			ic_io_size;
+	u32			ic_offset;
 	unsigned short		ic_state;
 	char			*ic_datap;	/* pointer to iclog data */
 
@@ -223,6 +221,11 @@ typedef struct xlog_in_core {
 	atomic_t		ic_refcnt ____cacheline_aligned_in_smp;
 	xlog_in_core_2_t	*ic_data;
 #define ic_header	ic_data->hic_header
+
+	struct semaphore	ic_sema;
+	struct work_struct	ic_end_io_work;
+	struct bio		ic_bio;
+	struct bio_vec		ic_bvec[];
 } xlog_in_core_t;
 
 /*
@@ -350,8 +353,6 @@ struct xlog {
 	struct xfs_mount	*l_mp;	        /* mount point */
 	struct xfs_ail		*l_ailp;	/* AIL log is working with */
 	struct xfs_cil		*l_cilp;	/* CIL log is working with */
-	struct xfs_buf		*l_xbuf;        /* extra buffer for log
-						 * wrapping */
 	struct xfs_buftarg	*l_targ;        /* buftarg of log */
 	struct delayed_work	l_work;		/* background flush work */
 	uint			l_flags;
-- 
2.20.1
