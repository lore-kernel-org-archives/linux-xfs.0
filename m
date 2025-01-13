Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1352A23ED45
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jan 2025 14:13:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736777581; cv=none; b=bBv3PBGn0eWCCzVTFwOeh8d4enFcJ70ppTVusLv5fck6ZIDuP4OvIc4bxO8higZXo8+yMWHajXCSJe43q4Ud8ILku2M1twzkyNSRi+sAy9KuzWfiP9WK0IFVwS0QjLpL93DcaQnECeYNEpzfEqtjUq4wLvMOAzst62Q24jVYsUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736777581; c=relaxed/simple;
	bh=TUMz7IAp3ozG9FWLh/aQp8NBcpS2G6xRkEN+U4syijU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=utzmGNcMvLjzCaptkUftFpaRfIR42wJdjUTjm2uDXNQ7VucrsZWYFVJrRvwI9TGk/4frIRVWRdE9cxU4el6OasKEcomkU+Qhl6Q7jUofn+LxzxX6S8AatovezPsEHr+1u7O4T7g2ZBvbVs7Q1jxCOGKBrxOUeV0YlAtUzJCsRsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YW4Q/+xA; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YW4Q/+xA"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZCRhdIFTQVbsecW/tyVGergHlTtr9Ajykf4liRGApts=; b=YW4Q/+xA8UrPoAmOmq0Nu5O0Se
	E6w03yv+79kfAp2XLIoQYkZU9GxNMXfHHhuY6/AboujHiDs7pgZVylP5QpXlg4uSMDO7oCScsSLwO
	hEXOrFYqb5PA1A6oNIt8gxknZeTRaxje6a8jaKcm1Wsc+JvegSZPB3vkBUgPXVYjZrI07bTiXZOXT
	uwt2mbRyJGvQ/dPrR362OV+PsiD2UeD6TWTcVVP4JauIVGkgzx/6s2vzIi0iZGBrugv8XqwNzLKIh
	JV6ZEryxbN3avxMvCx7sZ436blzPyU5PoVSsB0GrLN4NU1cRGOjb7pVyt3SSlh6w1yXJxn5MNK8Bk
	mAVfZNKw==;
Received: from 2a02-8389-2341-5b80-b273-11c2-5421-183d.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:b273:11c2:5421:183d] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tXLBb-00000005MqW-0t4e;
	Mon, 13 Jan 2025 14:12:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Carlos Maiolino <cem@kernel.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: [PATCH 09/15] xfs: simplify buffer I/O submission
Date: Mon, 13 Jan 2025 15:12:13 +0100
Message-ID: <20250113141228.113714-10-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250113141228.113714-1-hch@lst.de>
References: <20250113141228.113714-1-hch@lst.de>
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
 fs/xfs/xfs_buf.c | 204 ++++++++++++++---------------------------------
 fs/xfs/xfs_buf.h |   2 -
 2 files changed, 60 insertions(+), 146 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1e98fa812ba9..541e56b13869 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1362,13 +1362,6 @@ xfs_buf_ioend(
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
@@ -1491,118 +1484,26 @@ static void
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
@@ -1612,25 +1513,53 @@ _xfs_buf_ioapply(
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
+	 * If there is more than one map segment, split out a new bio for each
+	 * map except of the last one.  The last map is handled by the
+	 * remainder of the original bio outside the loop.
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
 
@@ -1729,14 +1658,7 @@ xfs_buf_submit(
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
 
@@ -1749,21 +1671,15 @@ xfs_buf_submit(
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

