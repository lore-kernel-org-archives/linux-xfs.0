Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55BA4594D
	for <linux-xfs@vger.kernel.org>; Mon,  6 Jan 2025 09:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736157403; cv=none; b=niUFdfpjlpNt953r+9qM9m8P/9IWwbeFpK1eymy5n62Z2bsUUTocGhLePPmOFXIH9O6k5U14Rl12vlDr/JtJw0rymkpIv6StyK5BdZLQa6CdCEn0DQHYgWHnztM+kEzwGkpgYTZEx0OxGwa+4liZtQmdO8mQ4dsZGDDHRpHOWYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736157403; c=relaxed/simple;
	bh=Vrjne/xfuYkntIK+5cGcZ6qTQ/4bZBmurPBxiY8vHm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sT8tIXoBgGAa6a0iEVF8X5XoYvqgURSpwemPzvedjtfY/IdSwXxRp5gumv9cAelE1ystsEDPfsPK58f6xzjn77zdEXfMeQKABEmsaLRJcvav3Z0bofKDIrqATWXHmZa09v3tVljKKZyrlKhMnreBSIAf3EKbSfIALi4Mln/oYBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=IinCDbhh; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IinCDbhh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qkjui50oQnn7XneLZAY8VkBT8WcFwEeA/5VsOwkmI8g=; b=IinCDbhhIuAz6pxaw7Ml05M7pE
	lcNIx7UlWR13KYpZXpv6q+IQkYCf/T6DiWw1I/7eLshmu/lo/zOsL1kMWMq2HTa+hBpsP9E7v9PC8
	debafw/VErZhGJnf0+PMy3rsrwcYI3nZC07fxKke2s1jMJe0PyMkkfhQ6n8TY7R1k9b0cMyfNIBhl
	fRzXM8si8tEzT3rTMtP3Uyjmh0Pmvm8GFvuvez91qIwpd1kbCeo41+t+4uzFrXatu2OeXwXI0kZj8
	2iy935UUWhfLN/EsIGLQsHnf569VSgodzyLkn9xbCqW6jzwbCj1cGsWGDMqwvxP79OKE/zBGW1nwS
	Y9RquDZg==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUjqi-00000000lLs-2si0;
	Mon, 06 Jan 2025 09:56:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/15] xfs: simplify buffer I/O submission
Date: Mon,  6 Jan 2025 10:54:46 +0100
Message-ID: <20250106095613.847700-10-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250106095613.847700-1-hch@lst.de>
References: <20250106095613.847700-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The code in _xfs_buf_ioapply is unnecessarily complicated because it
doesn't take advantage of modern bio features.

Simplify it by making use of bio splitting and chaining, that is build
a single bio for the pages in the buffer using a simple loop, and then
split that bio on the map boundaries for discontiguous multi-FSB buffers
and chain the split bios to the main one so that there is only a single
I/O completion.

This not only simplifies the code to build the buffer, but also removes
the need for the b_io_remaining field as buffer ownership is granted
to the bio on submit of the final bio with no chance for a completion
before that as well as the b_io_error field that is now superfluous
because there always is exactly one completion.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 207 ++++++++++++++---------------------------------
 fs/xfs/xfs_buf.h |   2 -
 2 files changed, 60 insertions(+), 149 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index e886605b5721..094f16457998 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1364,13 +1364,6 @@ xfs_buf_ioend(
 {
 	trace_xfs_buf_iodone(bp, _RET_IP_);
 
-	/*
-	 * Pull in IO completion errors now. We are guaranteed to be running
-	 * single threaded, so we don't need the lock to read b_io_error.
-	 */
-	if (!bp->b_error && bp->b_io_error)
-		xfs_buf_ioerror(bp, bp->b_io_error);
-
 	if (bp->b_flags & XBF_READ) {
 		if (!bp->b_error && bp->b_ops)
 			bp->b_ops->verify_read(bp);
@@ -1494,118 +1487,26 @@ static void
 xfs_buf_bio_end_io(
 	struct bio		*bio)
 {
-	struct xfs_buf		*bp = (struct xfs_buf *)bio->bi_private;
+	struct xfs_buf		*bp = bio->bi_private;
 
-	if (!bio->bi_status &&
-	    (bp->b_flags & XBF_WRITE) && (bp->b_flags & XBF_ASYNC) &&
-	    XFS_TEST_ERROR(false, bp->b_mount, XFS_ERRTAG_BUF_IOERROR))
-		bio->bi_status = BLK_STS_IOERR;
-
-	/*
-	 * don't overwrite existing errors - otherwise we can lose errors on
-	 * buffers that require multiple bios to complete.
-	 */
-	if (bio->bi_status) {
-		int error = blk_status_to_errno(bio->bi_status);
-
-		cmpxchg(&bp->b_io_error, 0, error);
-	}
+	if (bio->bi_status)
+		xfs_buf_ioerror(bp, blk_status_to_errno(bio->bi_status));
+	else if ((bp->b_flags & XBF_WRITE) && (bp->b_flags & XBF_ASYNC) &&
+		 XFS_TEST_ERROR(false, bp->b_mount, XFS_ERRTAG_BUF_IOERROR))
+		xfs_buf_ioerror(bp, -EIO);
 
 	if (!bp->b_error && xfs_buf_is_vmapped(bp) && (bp->b_flags & XBF_READ))
 		invalidate_kernel_vmap_range(bp->b_addr, xfs_buf_vmap_len(bp));
 
-	if (atomic_dec_and_test(&bp->b_io_remaining) == 1)
-		xfs_buf_ioend_async(bp);
+	xfs_buf_ioend_async(bp);
 	bio_put(bio);
 }
 
-static void
-xfs_buf_ioapply_map(
-	struct xfs_buf	*bp,
-	int		map,
-	int		*buf_offset,
-	int		*count,
-	blk_opf_t	op)
-{
-	int		page_index;
-	unsigned int	total_nr_pages = bp->b_page_count;
-	int		nr_pages;
-	struct bio	*bio;
-	sector_t	sector =  bp->b_maps[map].bm_bn;
-	int		size;
-	int		offset;
-
-	/* skip the pages in the buffer before the start offset */
-	page_index = 0;
-	offset = *buf_offset;
-	while (offset >= PAGE_SIZE) {
-		page_index++;
-		offset -= PAGE_SIZE;
-	}
-
-	/*
-	 * Limit the IO size to the length of the current vector, and update the
-	 * remaining IO count for the next time around.
-	 */
-	size = min_t(int, BBTOB(bp->b_maps[map].bm_len), *count);
-	*count -= size;
-	*buf_offset += size;
-
-next_chunk:
-	atomic_inc(&bp->b_io_remaining);
-	nr_pages = bio_max_segs(total_nr_pages);
-
-	bio = bio_alloc(bp->b_target->bt_bdev, nr_pages, op, GFP_NOIO);
-	bio->bi_iter.bi_sector = sector;
-	bio->bi_end_io = xfs_buf_bio_end_io;
-	bio->bi_private = bp;
-
-	for (; size && nr_pages; nr_pages--, page_index++) {
-		int	rbytes, nbytes = PAGE_SIZE - offset;
-
-		if (nbytes > size)
-			nbytes = size;
-
-		rbytes = bio_add_page(bio, bp->b_pages[page_index], nbytes,
-				      offset);
-		if (rbytes < nbytes)
-			break;
-
-		offset = 0;
-		sector += BTOBB(nbytes);
-		size -= nbytes;
-		total_nr_pages--;
-	}
-
-	if (likely(bio->bi_iter.bi_size)) {
-		if (xfs_buf_is_vmapped(bp)) {
-			flush_kernel_vmap_range(bp->b_addr,
-						xfs_buf_vmap_len(bp));
-		}
-		submit_bio(bio);
-		if (size)
-			goto next_chunk;
-	} else {
-		/*
-		 * This is guaranteed not to be the last io reference count
-		 * because the caller (xfs_buf_submit) holds a count itself.
-		 */
-		atomic_dec(&bp->b_io_remaining);
-		xfs_buf_ioerror(bp, -EIO);
-		bio_put(bio);
-	}
-
-}
-
-STATIC void
-_xfs_buf_ioapply(
-	struct xfs_buf	*bp)
+static inline blk_opf_t
+xfs_buf_bio_op(
+	struct xfs_buf		*bp)
 {
-	struct blk_plug	plug;
-	blk_opf_t	op;
-	int		offset;
-	int		size;
-	int		i;
+	blk_opf_t		op;
 
 	if (bp->b_flags & XBF_WRITE) {
 		op = REQ_OP_WRITE;
@@ -1615,25 +1516,52 @@ _xfs_buf_ioapply(
 			op |= REQ_RAHEAD;
 	}
 
-	/* we only use the buffer cache for meta-data */
-	op |= REQ_META;
+	return op | REQ_META;
+}
+
+static void
+xfs_buf_submit_bio(
+	struct xfs_buf		*bp)
+{
+	unsigned int		size = BBTOB(bp->b_length);
+	unsigned int		map = 0, p;
+	struct blk_plug		plug;
+	struct bio		*bio;
+
+	bio = bio_alloc(bp->b_target->bt_bdev, bp->b_page_count,
+			xfs_buf_bio_op(bp), GFP_NOIO);
+	bio->bi_private = bp;
+	bio->bi_end_io = xfs_buf_bio_end_io;
+
+	if (bp->b_flags & _XBF_KMEM) {
+		__bio_add_page(bio, virt_to_page(bp->b_addr), size,
+				bp->b_offset);
+	} else {
+		for (p = 0; p < bp->b_page_count; p++)
+			__bio_add_page(bio, bp->b_pages[p], PAGE_SIZE, 0);
+		bio->bi_iter.bi_size = size; /* limit to the actual size used */
+
+		if (xfs_buf_is_vmapped(bp))
+			flush_kernel_vmap_range(bp->b_addr,
+					xfs_buf_vmap_len(bp));
+	}
 
 	/*
-	 * Walk all the vectors issuing IO on them. Set up the initial offset
-	 * into the buffer and the desired IO size before we start -
-	 * _xfs_buf_ioapply_vec() will modify them appropriately for each
-	 * subsequent call.
+	 * If there is more than one map segment, split the original bio to
+	 * submit a separate bio for each discontiguous range.
 	 */
-	offset = bp->b_offset;
-	size = BBTOB(bp->b_length);
 	blk_start_plug(&plug);
-	for (i = 0; i < bp->b_map_count; i++) {
-		xfs_buf_ioapply_map(bp, i, &offset, &size, op);
-		if (bp->b_error)
-			break;
-		if (size <= 0)
-			break;	/* all done */
+	for (map = 0; map < bp->b_map_count - 1; map++) {
+		struct bio	*split;
+
+		split = bio_split(bio, bp->b_maps[map].bm_len, GFP_NOFS,
+				&fs_bio_set);
+		split->bi_iter.bi_sector = bp->b_maps[map].bm_bn;
+		bio_chain(split, bio);
+		submit_bio(split);
 	}
+	bio->bi_iter.bi_sector = bp->b_maps[map].bm_bn;
+	submit_bio(bio);
 	blk_finish_plug(&plug);
 }
 
@@ -1693,8 +1621,6 @@ static int
 xfs_buf_submit(
 	struct xfs_buf	*bp)
 {
-	int		error = 0;
-
 	trace_xfs_buf_submit(bp, _RET_IP_);
 
 	ASSERT(!(bp->b_flags & _XBF_DELWRI_Q));
@@ -1735,14 +1661,7 @@ xfs_buf_submit(
 	 * left over from previous use of the buffer (e.g. failed readahead).
 	 */
 	bp->b_error = 0;
-	bp->b_io_error = 0;
 
-	/*
-	 * Set the count to 1 initially, this will stop an I/O completion
-	 * callout which happens before we have started all the I/O from calling
-	 * xfs_buf_ioend too early.
-	 */
-	atomic_set(&bp->b_io_remaining, 1);
 	if (bp->b_flags & XBF_ASYNC)
 		xfs_buf_ioacct_inc(bp);
 
@@ -1755,28 +1674,22 @@ xfs_buf_submit(
 	if (xfs_buftarg_is_mem(bp->b_target))
 		goto done;
 
-	_xfs_buf_ioapply(bp);
+	xfs_buf_submit_bio(bp);
+	goto rele;
 
 done:
-	/*
-	 * If _xfs_buf_ioapply failed, we can get back here with only the IO
-	 * reference we took above. If we drop it to zero, run completion so
-	 * that we don't return to the caller with completion still pending.
-	 */
-	if (atomic_dec_and_test(&bp->b_io_remaining) == 1) {
-		if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
-			xfs_buf_ioend(bp);
-		else
-			xfs_buf_ioend_async(bp);
-	}
-
+	if (bp->b_error || !(bp->b_flags & XBF_ASYNC))
+		xfs_buf_ioend(bp);
+	else
+		xfs_buf_ioend_async(bp);
+rele:
 	/*
 	 * Release the hold that keeps the buffer referenced for the entire
 	 * I/O. Note that if the buffer is async, it is not safe to reference
 	 * after this release.
 	 */
 	xfs_buf_rele(bp);
-	return error;
+	return 0;
 }
 
 void *
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index da80399c7457..c53d27439ff2 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -184,7 +184,6 @@ struct xfs_buf {
 	struct list_head	b_lru;		/* lru list */
 	spinlock_t		b_lock;		/* internal state lock */
 	unsigned int		b_state;	/* internal state flags */
-	int			b_io_error;	/* internal IO error state */
 	wait_queue_head_t	b_waiters;	/* unpin waiters */
 	struct list_head	b_list;
 	struct xfs_perag	*b_pag;
@@ -202,7 +201,6 @@ struct xfs_buf {
 	struct xfs_buf_map	__b_map;	/* inline compound buffer map */
 	int			b_map_count;
 	atomic_t		b_pin_count;	/* pin count */
-	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
 	unsigned int		b_page_count;	/* size of page array */
 	unsigned int		b_offset;	/* page offset of b_addr,
 						   only for _XBF_KMEM buffers */
-- 
2.45.2

