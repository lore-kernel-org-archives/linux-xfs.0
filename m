Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:56366 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731264AbfEWRlt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 May 2019 13:41:49 -0400
Received: from 213-225-10-46.nat.highway.a1.net ([213.225.10.46] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hTriu-0002Sd-Px
        for linux-xfs@vger.kernel.org; Thu, 23 May 2019 17:41:49 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/20] xfs: use bios directly to read and write the log recovery buffers
Date: Thu, 23 May 2019 19:37:38 +0200
Message-Id: <20190523173742.15551-17-hch@lst.de>
In-Reply-To: <20190523173742.15551-1-hch@lst.de>
References: <20190523173742.15551-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The xfs_buf structure is basically used as a glorified container for
a memory allocation in the log recovery code.  Replace it with a
call to kmem_alloc_large and a simple abstraction to read into or
write from it synchronously using chained bios.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile          |   1 +
 fs/xfs/xfs_bio_io.c      |  61 ++++++++++
 fs/xfs/xfs_linux.h       |   3 +
 fs/xfs/xfs_log_recover.c | 241 ++++++++++++++-------------------------
 4 files changed, 149 insertions(+), 157 deletions(-)
 create mode 100644 fs/xfs/xfs_bio_io.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 91831975363b..701028e3e4ac 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -62,6 +62,7 @@ xfs-y				+= xfs_aops.o \
 				   xfs_attr_inactive.o \
 				   xfs_attr_list.o \
 				   xfs_bmap_util.o \
+				   xfs_bio_io.o \
 				   xfs_buf.o \
 				   xfs_dir2_readdir.o \
 				   xfs_discard.o \
diff --git a/fs/xfs/xfs_bio_io.c b/fs/xfs/xfs_bio_io.c
new file mode 100644
index 000000000000..d251850c6bf6
--- /dev/null
+++ b/fs/xfs/xfs_bio_io.c
@@ -0,0 +1,61 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019 Christoph Hellwig.
+ */
+#include "xfs.h"
+
+static inline unsigned int bio_max_vecs(unsigned int count)
+{
+	return min_t(unsigned, howmany(count, PAGE_SIZE), BIO_MAX_PAGES);
+}
+
+int
+xfs_rw_bdev(
+	struct block_device	*bdev,
+	sector_t		sector,
+	unsigned int		count,
+	char			*data,
+	unsigned int		op)
+
+{
+	unsigned int		is_vmalloc = is_vmalloc_addr(data);
+	unsigned int		left = count;
+	int			error;
+	struct bio		*bio;
+
+	if (is_vmalloc && op == REQ_OP_READ)
+		flush_kernel_vmap_range(data, count);
+
+	bio = bio_alloc(GFP_KERNEL, bio_max_vecs(left));
+	bio_set_dev(bio, bdev);
+	bio->bi_iter.bi_sector = sector;
+	bio->bi_opf = op | REQ_META | REQ_SYNC;
+
+	do {
+		struct page	*page = kmem_to_page(data);
+		unsigned int	off = offset_in_page(data);
+		unsigned int	len = min_t(unsigned, left, PAGE_SIZE - off);
+
+		while (bio_add_page(bio, page, len, off) != len) {
+			struct bio	*prev = bio;
+
+			bio = bio_alloc(GFP_KERNEL, bio_max_vecs(left));
+			bio_copy_dev(bio, prev);
+			bio->bi_iter.bi_sector = bio_end_sector(prev);
+			bio->bi_opf = prev->bi_opf;
+			bio_chain(bio, prev);
+
+			submit_bio(prev);
+		}
+
+		data += len;
+		left -= len;
+	} while (left > 0);
+
+	error = submit_bio_wait(bio);
+	bio_put(bio);
+
+	if (is_vmalloc && op == REQ_OP_WRITE)
+		invalidate_kernel_vmap_range(data, count);
+	return error;
+}
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index b78287666309..ca15105681ca 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -219,6 +219,9 @@ static inline uint64_t howmany_64(uint64_t x, uint32_t y)
 	return x;
 }
 
+int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
+		char *data, unsigned int op);
+
 #define ASSERT_ALWAYS(expr)	\
 	(likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
 
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 74fd3784bcb7..a28c9dc8f1f2 100644
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
@@ -115,36 +112,23 @@ xlog_get_bp(
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
-}
-
-STATIC void
-xlog_put_bp(
-	xfs_buf_t	*bp)
-{
-	xfs_buf_free(bp);
+	return kmem_alloc_large(BBTOB(nbblks), KM_MAYFAIL);
 }
 
 /*
@@ -159,17 +143,15 @@ xlog_align(
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
+static int
+xlog_do_io(
+	struct xlog		*log,
+	xfs_daddr_t		blk_no,
+	unsigned int		nbblks,
+	char			*data,
+	unsigned int		op)
 {
-	int		error;
+	int			error;
 
 	if (!xlog_verify_bp(log, blk_no, nbblks)) {
 		xfs_warn(log->l_mp,
@@ -181,107 +163,53 @@ xlog_bread_noalign(
 
 	blk_no = round_down(blk_no, log->l_sectBBsize);
 	nbblks = round_up(nbblks, log->l_sectBBsize);
-
 	ASSERT(nbblks > 0);
-	ASSERT(nbblks <= bp->b_length);
-
-	XFS_BUF_SET_ADDR(bp, log->l_logBBstart + blk_no);
-	bp->b_flags |= XBF_READ;
-	bp->b_io_length = nbblks;
-	bp->b_error = 0;
 
-	error = xfs_buf_submit(bp);
-	if (error && !XFS_FORCED_SHUTDOWN(log->l_mp))
-		xfs_buf_ioerror_alert(bp, __func__);
+	error = xfs_rw_bdev(log->l_targ->bt_bdev, log->l_logBBstart + blk_no,
+			BBTOB(nbblks), data, op);
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
@@ -399,7 +327,7 @@ xlog_recover_iodone(
 STATIC int
 xlog_find_cycle_start(
 	struct xlog	*log,
-	struct xfs_buf	*bp,
+	char		*bp,
 	xfs_daddr_t	first_blk,
 	xfs_daddr_t	*last_blk,
 	uint		cycle)
@@ -449,7 +377,7 @@ xlog_find_verify_cycle(
 {
 	xfs_daddr_t	i, j;
 	uint		cycle;
-	xfs_buf_t	*bp;
+	char		*bp;
 	xfs_daddr_t	bufblks;
 	char		*buf = NULL;
 	int		error = 0;
@@ -492,7 +420,7 @@ xlog_find_verify_cycle(
 	*new_blk = -1;
 
 out:
-	xlog_put_bp(bp);
+	kmem_free(bp);
 	return error;
 }
 
@@ -516,7 +444,7 @@ xlog_find_verify_log_record(
 	int			extra_bblks)
 {
 	xfs_daddr_t		i;
-	xfs_buf_t		*bp;
+	char			*bp;
 	char			*offset = NULL;
 	xlog_rec_header_t	*head = NULL;
 	int			error = 0;
@@ -601,7 +529,7 @@ xlog_find_verify_log_record(
 		*last_blk = i;
 
 out:
-	xlog_put_bp(bp);
+	kmem_free(bp);
 	return error;
 }
 
@@ -623,7 +551,7 @@ xlog_find_head(
 	struct xlog	*log,
 	xfs_daddr_t	*return_head_blk)
 {
-	xfs_buf_t	*bp;
+	char		*bp;
 	char		*offset;
 	xfs_daddr_t	new_blk, first_blk, start_blk, last_blk, head_blk;
 	int		num_scan_bblks;
@@ -854,7 +782,7 @@ xlog_find_head(
 			goto bp_err;
 	}
 
-	xlog_put_bp(bp);
+	kmem_free(bp);
 	if (head_blk == log_bbnum)
 		*return_head_blk = 0;
 	else
@@ -868,7 +796,7 @@ xlog_find_head(
 	return 0;
 
  bp_err:
-	xlog_put_bp(bp);
+	kmem_free(bp);
 
 	if (error)
 		xfs_warn(log->l_mp, "failed to find log head");
@@ -889,7 +817,7 @@ xlog_rseek_logrec_hdr(
 	xfs_daddr_t		head_blk,
 	xfs_daddr_t		tail_blk,
 	int			count,
-	struct xfs_buf		*bp,
+	char			*bp,
 	xfs_daddr_t		*rblk,
 	struct xlog_rec_header	**rhead,
 	bool			*wrapped)
@@ -963,7 +891,7 @@ xlog_seek_logrec_hdr(
 	xfs_daddr_t		head_blk,
 	xfs_daddr_t		tail_blk,
 	int			count,
-	struct xfs_buf		*bp,
+	char			*bp,
 	xfs_daddr_t		*rblk,
 	struct xlog_rec_header	**rhead,
 	bool			*wrapped)
@@ -1063,7 +991,7 @@ xlog_verify_tail(
 	int			hsize)
 {
 	struct xlog_rec_header	*thead;
-	struct xfs_buf		*bp;
+	char			*bp;
 	xfs_daddr_t		first_bad;
 	int			error = 0;
 	bool			wrapped;
@@ -1123,7 +1051,7 @@ xlog_verify_tail(
 		"Tail block (0x%llx) overwrite detected. Updated to 0x%llx",
 			 orig_tail, *tail_blk);
 out:
-	xlog_put_bp(bp);
+	kmem_free(bp);
 	return error;
 }
 
@@ -1145,13 +1073,13 @@ xlog_verify_head(
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
@@ -1170,7 +1098,7 @@ xlog_verify_head(
 	error = xlog_rseek_logrec_hdr(log, *head_blk, *tail_blk,
 				      XLOG_MAX_ICLOGS, tmp_bp, &tmp_rhead_blk,
 				      &tmp_rhead, &tmp_wrapped);
-	xlog_put_bp(tmp_bp);
+	kmem_free(tmp_bp);
 	if (error < 0)
 		return error;
 
@@ -1260,7 +1188,7 @@ xlog_check_unmount_rec(
 	xfs_daddr_t		*tail_blk,
 	struct xlog_rec_header	*rhead,
 	xfs_daddr_t		rhead_blk,
-	struct xfs_buf		*bp,
+	char			*bp,
 	bool			*clean)
 {
 	struct xlog_op_header	*op_head;
@@ -1382,7 +1310,7 @@ xlog_find_tail(
 {
 	xlog_rec_header_t	*rhead;
 	char			*offset = NULL;
-	xfs_buf_t		*bp;
+	char			*bp;
 	int			error;
 	xfs_daddr_t		rhead_blk;
 	xfs_lsn_t		tail_lsn;
@@ -1503,7 +1431,7 @@ xlog_find_tail(
 		error = xlog_clear_stale_blocks(log, tail_lsn);
 
 done:
-	xlog_put_bp(bp);
+	kmem_free(bp);
 
 	if (error)
 		xfs_warn(log->l_mp, "failed to locate log tail");
@@ -1531,7 +1459,7 @@ xlog_find_zeroed(
 	struct xlog	*log,
 	xfs_daddr_t	*blk_no)
 {
-	xfs_buf_t	*bp;
+	char		*bp;
 	char		*offset;
 	uint	        first_cycle, last_cycle;
 	xfs_daddr_t	new_blk, last_blk, start_blk;
@@ -1551,7 +1479,7 @@ xlog_find_zeroed(
 	first_cycle = xlog_get_cycle(offset);
 	if (first_cycle == 0) {		/* completely zeroed log */
 		*blk_no = 0;
-		xlog_put_bp(bp);
+		kmem_free(bp);
 		return 1;
 	}
 
@@ -1562,7 +1490,7 @@ xlog_find_zeroed(
 
 	last_cycle = xlog_get_cycle(offset);
 	if (last_cycle != 0) {		/* log completely written to */
-		xlog_put_bp(bp);
+		kmem_free(bp);
 		return 0;
 	}
 
@@ -1608,7 +1536,7 @@ xlog_find_zeroed(
 
 	*blk_no = last_blk;
 bp_err:
-	xlog_put_bp(bp);
+	kmem_free(bp);
 	if (error)
 		return error;
 	return 1;
@@ -1651,7 +1579,7 @@ xlog_write_log_records(
 	int		tail_block)
 {
 	char		*offset;
-	xfs_buf_t	*bp;
+	char		*bp;
 	int		balign, ealign;
 	int		sectbb = log->l_sectBBsize;
 	int		end_block = start_block + blocks;
@@ -1699,15 +1627,14 @@ xlog_write_log_records(
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
@@ -1721,7 +1648,7 @@ xlog_write_log_records(
 	}
 
  out_put_bp:
-	xlog_put_bp(bp);
+	kmem_free(bp);
 	return error;
 }
 
@@ -5301,7 +5228,7 @@ xlog_do_recovery_pass(
 	xfs_daddr_t		blk_no, rblk_no;
 	xfs_daddr_t		rhead_blk;
 	char			*offset;
-	xfs_buf_t		*hbp, *dbp;
+	char			*hbp, *dbp;
 	int			error = 0, h_size, h_len;
 	int			error2 = 0;
 	int			bblks, split_bblks;
@@ -5368,7 +5295,7 @@ xlog_do_recovery_pass(
 			hblks = h_size / XLOG_HEADER_CYCLE_SIZE;
 			if (h_size % XLOG_HEADER_CYCLE_SIZE)
 				hblks++;
-			xlog_put_bp(hbp);
+			kmem_free(hbp);
 			hbp = xlog_get_bp(log, hblks);
 		} else {
 			hblks = 1;
@@ -5384,7 +5311,7 @@ xlog_do_recovery_pass(
 		return -ENOMEM;
 	dbp = xlog_get_bp(log, BTOBB(h_size));
 	if (!dbp) {
-		xlog_put_bp(hbp);
+		kmem_free(hbp);
 		return -ENOMEM;
 	}
 
@@ -5399,7 +5326,7 @@ xlog_do_recovery_pass(
 			/*
 			 * Check for header wrapping around physical end-of-log
 			 */
-			offset = hbp->b_addr;
+			offset = hbp;
 			split_hblks = 0;
 			wrapped_hblks = 0;
 			if (blk_no + hblks <= log->l_logBBsize) {
@@ -5435,8 +5362,8 @@ xlog_do_recovery_pass(
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
@@ -5467,7 +5394,7 @@ xlog_do_recovery_pass(
 			} else {
 				/* This log record is split across the
 				 * physical end of log */
-				offset = dbp->b_addr;
+				offset = dbp;
 				split_bblks = 0;
 				if (blk_no != log->l_logBBsize) {
 					/* some data is before the physical
@@ -5496,8 +5423,8 @@ xlog_do_recovery_pass(
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
@@ -5545,9 +5472,9 @@ xlog_do_recovery_pass(
 	}
 
  bread_err2:
-	xlog_put_bp(dbp);
+	kmem_free(dbp);
  bread_err1:
-	xlog_put_bp(hbp);
+	kmem_free(hbp);
 
 	/*
 	 * Submit buffers that have been added from the last record processed,
-- 
2.20.1
