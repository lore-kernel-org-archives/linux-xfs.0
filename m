Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:37204 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732368AbfETQPX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 May 2019 12:15:23 -0400
Received: from 089144206147.atnat0015.highway.bob.at ([89.144.206.147] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hSkwc-0006wF-Tb
        for linux-xfs@vger.kernel.org; Mon, 20 May 2019 16:15:23 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/17] xfs: use bios directly to read and write the log recovery buffers
Date: Mon, 20 May 2019 18:13:44 +0200
Message-Id: <20190520161347.3044-15-hch@lst.de>
In-Reply-To: <20190520161347.3044-1-hch@lst.de>
References: <20190520161347.3044-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The xfs_buf structure is basically used as a glorified container for
a vmalloc allocation in the log recovery code.  Replace it with a
real vmalloc implementation and just build bios directly as needed
to read into or write from it to simplify things a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_recover.c | 266 +++++++++++++++++++--------------------
 1 file changed, 131 insertions(+), 135 deletions(-)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9519956b1ccf..350c9a123dad 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -92,17 +92,14 @@ xlog_verify_bp(
 }
 
 /*
- * Allocate a buffer to hold log data.  The buffer needs to be able
- * to map to a range of nbblks basic blocks at any valid (basic
- * block) offset within the log.
+ * Allocate a buffer to hold log data.  The buffer needs to be able to map to
+ * a range of nbblks basic blocks at any valid offset within the log.
  */
-STATIC xfs_buf_t *
+static char *
 xlog_get_bp(
 	struct xlog	*log,
 	int		nbblks)
 {
-	struct xfs_buf	*bp;
-
 	/*
 	 * Pass log block 0 since we don't have an addr yet, buffer will be
 	 * verified on read.
@@ -115,36 +112,30 @@ xlog_get_bp(
 	}
 
 	/*
-	 * We do log I/O in units of log sectors (a power-of-2
-	 * multiple of the basic block size), so we round up the
-	 * requested size to accommodate the basic blocks required
-	 * for complete log sectors.
+	 * We do log I/O in units of log sectors (a power-of-2 multiple of the
+	 * basic block size), so we round up the requested size to accommodate
+	 * the basic blocks required for complete log sectors.
 	 *
-	 * In addition, the buffer may be used for a non-sector-
-	 * aligned block offset, in which case an I/O of the
-	 * requested size could extend beyond the end of the
-	 * buffer.  If the requested size is only 1 basic block it
-	 * will never straddle a sector boundary, so this won't be
-	 * an issue.  Nor will this be a problem if the log I/O is
-	 * done in basic blocks (sector size 1).  But otherwise we
-	 * extend the buffer by one extra log sector to ensure
-	 * there's space to accommodate this possibility.
+	 * In addition, the buffer may be used for a non-sector-aligned block
+	 * offset, in which case an I/O of the requested size could extend
+	 * beyond the end of the buffer.  If the requested size is only 1 basic
+	 * block it will never straddle a sector boundary, so this won't be an
+	 * issue.  Nor will this be a problem if the log I/O is done in basic
+	 * blocks (sector size 1).  But otherwise we extend the buffer by one
+	 * extra log sector to ensure there's space to accommodate this
+	 * possibility.
 	 */
 	if (nbblks > 1 && log->l_sectBBsize > 1)
 		nbblks += log->l_sectBBsize;
 	nbblks = round_up(nbblks, log->l_sectBBsize);
-
-	bp = xfs_buf_get_uncached(log->l_targ, nbblks, 0);
-	if (bp)
-		xfs_buf_unlock(bp);
-	return bp;
+	return vmalloc(BBTOB(nbblks));
 }
 
 STATIC void
 xlog_put_bp(
-	xfs_buf_t	*bp)
+	char		*data)
 {
-	xfs_buf_free(bp);
+	vfree(data);
 }
 
 /*
@@ -159,17 +150,71 @@ xlog_align(
 	return BBTOB(blk_no & ((xfs_daddr_t)log->l_sectBBsize - 1));
 }
 
-/*
- * nbblks should be uint, but oh well.  Just want to catch that 32-bit length.
- */
-STATIC int
-xlog_bread_noalign(
-	struct xlog	*log,
-	xfs_daddr_t	blk_no,
-	int		nbblks,
-	struct xfs_buf	*bp)
+static struct bio *
+xlog_alloc_bio(
+	struct xlog		*log,
+	xfs_daddr_t		blk_no,
+	unsigned int		count,
+	unsigned int		op)
 {
-	int		error;
+	int			vecs = howmany(count, PAGE_SIZE);
+	struct bio		*bio;
+
+	bio = bio_alloc(GFP_KERNEL, min(vecs, BIO_MAX_PAGES));
+	bio_set_dev(bio, log->l_targ->bt_bdev);
+	bio->bi_iter.bi_sector = log->l_logBBstart + blk_no;
+	bio->bi_opf = op | REQ_META | REQ_SYNC;
+	return bio;
+}
+
+static int
+xlog_submit_bio(
+	struct xlog		*log,
+	xfs_daddr_t		blk_no,
+	unsigned int		count,
+	char			*data,
+	unsigned int		op)
+
+{
+	int			error;
+	struct bio		*bio;
+
+	bio = xlog_alloc_bio(log, blk_no, count, op);
+
+	do {
+		struct page	*page = vmalloc_to_page(data);
+		unsigned int	off = offset_in_page(data);
+		unsigned int	len = min_t(unsigned, count, PAGE_SIZE - off);
+
+		while (bio_add_page(bio, page, len, off) != len) {
+			struct bio	*prev = bio;
+
+			bio = xlog_alloc_bio(log, blk_no, count, op);
+			bio_chain(bio, prev);
+			submit_bio(prev);
+		}
+
+		data += len;
+		count -= len;
+		blk_no += BTOBB(len);
+	} while (count > 0);
+
+	error = submit_bio_wait(bio);
+	bio_put(bio);
+
+	return error;
+}
+
+static int
+xlog_do_io(
+	struct xlog		*log,
+	xfs_daddr_t		blk_no,
+	unsigned int		nbblks,
+	char			*data,
+	unsigned int		op)
+{
+	unsigned int		count;
+	int			error;
 
 	if (!xlog_verify_bp(log, blk_no, nbblks)) {
 		xfs_warn(log->l_mp,
@@ -181,107 +226,59 @@ xlog_bread_noalign(
 
 	blk_no = round_down(blk_no, log->l_sectBBsize);
 	nbblks = round_up(nbblks, log->l_sectBBsize);
+	count = BBTOB(nbblks);
 
 	ASSERT(nbblks > 0);
-	ASSERT(nbblks <= bp->b_length);
 
-	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
-	bp->b_flags |= XBF_READ;
-	bp->b_io_length = nbblks;
-	bp->b_error = 0;
+	if (op == REQ_OP_READ)
+		flush_kernel_vmap_range(data, count);
+	error = xlog_submit_bio(log, blk_no, count, data, op);
+	if (op == REQ_OP_WRITE)
+		invalidate_kernel_vmap_range(data, count);
 
-	error = xfs_buf_submit(bp);
-	if (error && !XFS_FORCED_SHUTDOWN(log->l_mp))
-		xfs_buf_ioerror_alert(bp, __func__);
+	if (error && !XFS_FORCED_SHUTDOWN(log->l_mp)) {
+		xfs_alert(log->l_mp,
+			  "log recovery %s I/O error at daddr 0x%llx len %d error %d",
+			  op == REQ_OP_WRITE ? "write" : "read",
+			  blk_no, nbblks, error);
+	}
 	return error;
 }
 
 STATIC int
-xlog_bread(
+xlog_bread_noalign(
 	struct xlog	*log,
 	xfs_daddr_t	blk_no,
 	int		nbblks,
-	struct xfs_buf	*bp,
-	char		**offset)
+	char		*data)
 {
-	int		error;
-
-	error = xlog_bread_noalign(log, blk_no, nbblks, bp);
-	if (error)
-		return error;
-
-	*offset = bp->b_addr + xlog_align(log, blk_no);
-	return 0;
+	return xlog_do_io(log, blk_no, nbblks, data, REQ_OP_READ);
 }
 
-/*
- * Read at an offset into the buffer. Returns with the buffer in it's original
- * state regardless of the result of the read.
- */
 STATIC int
-xlog_bread_offset(
+xlog_bread(
 	struct xlog	*log,
-	xfs_daddr_t	blk_no,		/* block to read from */
-	int		nbblks,		/* blocks to read */
-	struct xfs_buf	*bp,
-	char		*offset)
+	xfs_daddr_t	blk_no,
+	int		nbblks,
+	char		*data,
+	char		**offset)
 {
-	char		*orig_offset = bp->b_addr;
-	int		orig_len = BBTOB(bp->b_length);
-	int		error, error2;
-
-	error = xfs_buf_associate_memory(bp, offset, BBTOB(nbblks));
-	if (error)
-		return error;
-
-	error = xlog_bread_noalign(log, blk_no, nbblks, bp);
+	int		error;
 
-	/* must reset buffer pointer even on error */
-	error2 = xfs_buf_associate_memory(bp, orig_offset, orig_len);
-	if (error)
-		return error;
-	return error2;
+	error = xlog_do_io(log, blk_no, nbblks, data, REQ_OP_READ);
+	if (!error)
+		*offset = data + xlog_align(log, blk_no);
+	return error;
 }
 
-/*
- * Write out the buffer at the given block for the given number of blocks.
- * The buffer is kept locked across the write and is returned locked.
- * This can only be used for synchronous log writes.
- */
 STATIC int
 xlog_bwrite(
 	struct xlog	*log,
 	xfs_daddr_t	blk_no,
 	int		nbblks,
-	struct xfs_buf	*bp)
+	char		*data)
 {
-	int		error;
-
-	if (!xlog_verify_bp(log, blk_no, nbblks)) {
-		xfs_warn(log->l_mp,
-			 "Invalid log block/length (0x%llx, 0x%x) for buffer",
-			 blk_no, nbblks);
-		XFS_ERROR_REPORT(__func__, XFS_ERRLEVEL_HIGH, log->l_mp);
-		return -EFSCORRUPTED;
-	}
-
-	blk_no = round_down(blk_no, log->l_sectBBsize);
-	nbblks = round_up(nbblks, log->l_sectBBsize);
-
-	ASSERT(nbblks > 0);
-	ASSERT(nbblks <= bp->b_length);
-
-	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
-	xfs_buf_hold(bp);
-	xfs_buf_lock(bp);
-	bp->b_io_length = nbblks;
-	bp->b_error = 0;
-
-	error = xfs_bwrite(bp);
-	if (error)
-		xfs_buf_ioerror_alert(bp, __func__);
-	xfs_buf_relse(bp);
-	return error;
+	return xlog_do_io(log, blk_no, nbblks, data, REQ_OP_WRITE);
 }
 
 #ifdef DEBUG
@@ -399,7 +396,7 @@ xlog_recover_iodone(
 STATIC int
 xlog_find_cycle_start(
 	struct xlog	*log,
-	struct xfs_buf	*bp,
+	char		*bp,
 	xfs_daddr_t	first_blk,
 	xfs_daddr_t	*last_blk,
 	uint		cycle)
@@ -449,7 +446,7 @@ xlog_find_verify_cycle(
 {
 	xfs_daddr_t	i, j;
 	uint		cycle;
-	xfs_buf_t	*bp;
+	char		*bp;
 	xfs_daddr_t	bufblks;
 	char		*buf = NULL;
 	int		error = 0;
@@ -516,7 +513,7 @@ xlog_find_verify_log_record(
 	int			extra_bblks)
 {
 	xfs_daddr_t		i;
-	xfs_buf_t		*bp;
+	char			*bp;
 	char			*offset = NULL;
 	xlog_rec_header_t	*head = NULL;
 	int			error = 0;
@@ -623,7 +620,7 @@ xlog_find_head(
 	struct xlog	*log,
 	xfs_daddr_t	*return_head_blk)
 {
-	xfs_buf_t	*bp;
+	char		*bp;
 	char		*offset;
 	xfs_daddr_t	new_blk, first_blk, start_blk, last_blk, head_blk;
 	int		num_scan_bblks;
@@ -889,7 +886,7 @@ xlog_rseek_logrec_hdr(
 	xfs_daddr_t		head_blk,
 	xfs_daddr_t		tail_blk,
 	int			count,
-	struct xfs_buf		*bp,
+	char			*bp,
 	xfs_daddr_t		*rblk,
 	struct xlog_rec_header	**rhead,
 	bool			*wrapped)
@@ -963,7 +960,7 @@ xlog_seek_logrec_hdr(
 	xfs_daddr_t		head_blk,
 	xfs_daddr_t		tail_blk,
 	int			count,
-	struct xfs_buf		*bp,
+	char			*bp,
 	xfs_daddr_t		*rblk,
 	struct xlog_rec_header	**rhead,
 	bool			*wrapped)
@@ -1063,7 +1060,7 @@ xlog_verify_tail(
 	int			hsize)
 {
 	struct xlog_rec_header	*thead;
-	struct xfs_buf		*bp;
+	char			*bp;
 	xfs_daddr_t		first_bad;
 	int			error = 0;
 	bool			wrapped;
@@ -1145,13 +1142,13 @@ xlog_verify_head(
 	struct xlog		*log,
 	xfs_daddr_t		*head_blk,	/* in/out: unverified head */
 	xfs_daddr_t		*tail_blk,	/* out: tail block */
-	struct xfs_buf		*bp,
+	char			*bp,
 	xfs_daddr_t		*rhead_blk,	/* start blk of last record */
 	struct xlog_rec_header	**rhead,	/* ptr to last record */
 	bool			*wrapped)	/* last rec. wraps phys. log */
 {
 	struct xlog_rec_header	*tmp_rhead;
-	struct xfs_buf		*tmp_bp;
+	char			*tmp_bp;
 	xfs_daddr_t		first_bad;
 	xfs_daddr_t		tmp_rhead_blk;
 	int			found;
@@ -1260,7 +1257,7 @@ xlog_check_unmount_rec(
 	xfs_daddr_t		*tail_blk,
 	struct xlog_rec_header	*rhead,
 	xfs_daddr_t		rhead_blk,
-	struct xfs_buf		*bp,
+	char			*bp,
 	bool			*clean)
 {
 	struct xlog_op_header	*op_head;
@@ -1382,7 +1379,7 @@ xlog_find_tail(
 {
 	xlog_rec_header_t	*rhead;
 	char			*offset = NULL;
-	xfs_buf_t		*bp;
+	char			*bp;
 	int			error;
 	xfs_daddr_t		rhead_blk;
 	xfs_lsn_t		tail_lsn;
@@ -1531,7 +1528,7 @@ xlog_find_zeroed(
 	struct xlog	*log,
 	xfs_daddr_t	*blk_no)
 {
-	xfs_buf_t	*bp;
+	char		*bp;
 	char		*offset;
 	uint	        first_cycle, last_cycle;
 	xfs_daddr_t	new_blk, last_blk, start_blk;
@@ -1651,7 +1648,7 @@ xlog_write_log_records(
 	int		tail_block)
 {
 	char		*offset;
-	xfs_buf_t	*bp;
+	char		*bp;
 	int		balign, ealign;
 	int		sectbb = log->l_sectBBsize;
 	int		end_block = start_block + blocks;
@@ -1699,15 +1696,14 @@ xlog_write_log_records(
 		 */
 		ealign = round_down(end_block, sectbb);
 		if (j == 0 && (start_block + endcount > ealign)) {
-			offset = bp->b_addr + BBTOB(ealign - start_block);
-			error = xlog_bread_offset(log, ealign, sectbb,
-							bp, offset);
+			error = xlog_bread_noalign(log, ealign, sectbb,
+					bp + BBTOB(ealign - start_block));
 			if (error)
 				break;
 
 		}
 
-		offset = bp->b_addr + xlog_align(log, start_block);
+		offset = bp + xlog_align(log, start_block);
 		for (; j < endcount; j++) {
 			xlog_add_record(log, offset, cycle, i+j,
 					tail_cycle, tail_block);
@@ -5301,7 +5297,7 @@ xlog_do_recovery_pass(
 	xfs_daddr_t		blk_no, rblk_no;
 	xfs_daddr_t		rhead_blk;
 	char			*offset;
-	xfs_buf_t		*hbp, *dbp;
+	char			*hbp, *dbp;
 	int			error = 0, h_size, h_len;
 	int			error2 = 0;
 	int			bblks, split_bblks;
@@ -5399,7 +5395,7 @@ xlog_do_recovery_pass(
 			/*
 			 * Check for header wrapping around physical end-of-log
 			 */
-			offset = hbp->b_addr;
+			offset = hbp;
 			split_hblks = 0;
 			wrapped_hblks = 0;
 			if (blk_no + hblks <= log->l_logBBsize) {
@@ -5435,8 +5431,8 @@ xlog_do_recovery_pass(
 				 *   - order is important.
 				 */
 				wrapped_hblks = hblks - split_hblks;
-				error = xlog_bread_offset(log, 0,
-						wrapped_hblks, hbp,
+				error = xlog_bread_noalign(log, 0,
+						wrapped_hblks,
 						offset + BBTOB(split_hblks));
 				if (error)
 					goto bread_err2;
@@ -5467,7 +5463,7 @@ xlog_do_recovery_pass(
 			} else {
 				/* This log record is split across the
 				 * physical end of log */
-				offset = dbp->b_addr;
+				offset = dbp;
 				split_bblks = 0;
 				if (blk_no != log->l_logBBsize) {
 					/* some data is before the physical
@@ -5496,8 +5492,8 @@ xlog_do_recovery_pass(
 				 *   _first_, then the log start (LR header end)
 				 *   - order is important.
 				 */
-				error = xlog_bread_offset(log, 0,
-						bblks - split_bblks, dbp,
+				error = xlog_bread_noalign(log, 0,
+						bblks - split_bblks,
 						offset + BBTOB(split_bblks));
 				if (error)
 					goto bread_err2;
-- 
2.20.1
