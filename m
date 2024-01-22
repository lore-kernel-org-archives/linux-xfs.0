Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E363E48B
	for <linux-xfs@vger.kernel.org>; Mon, 22 Jan 2024 19:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705952380; cv=none; b=Km8clGWVSMndwHKoJEP/5niQSo44fPAPRpAa6sjYSo+2rMHPGXMVH7oiNttasObvOoCdAZfhVs34rerHvkY9yfpYqfKKjmOmGE124rACq0GLR8HjVYISRsnK5dlLvz9PmJzOLR6Wv9vXluiInlRul1Wwt+CW72fvE0QQ/W67lTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705952380; c=relaxed/simple;
	bh=KOKKefF7L5u5cnasn+mMx/ON88wk4fS1XzBxh5/5UyI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qs9f/WJ9+i5zdb8skQVRDnHRyehR0A7jV5f1Qnr8n2sH7nZn371AlSFU8qIvo33Y39ln6otDFvKwnjNEZQp532cqb8FX0Enq7SOyhQCb0WeWZFJ+CywwWMlJAyoJuWbNw8U2y9APpKM7BcL0BSNAgiuz6ya1SKo7oUW3JY27A6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=S5kYTJza; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="S5kYTJza"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=DvyaHEf0eh7I7CLwR0yWShj0NfyseUW0ePy4xYOaAVE=; b=S5kYTJzaHRNJCzFvqCzaa4BFMC
	Nrm0z7VKhWejTAMhHsV/gQQJLSDQIiencRwDbEMAKvLKwA2/29grV3xmnsbJkx/VwKIxFNof27Qk9
	vb3KgLkI6T03OBmj3MMKXZAQWjxmj0sHFm6Gn/ORJQP45iBxcwuFnjtHThOoRzWV5xtNwvmQfUbAV
	seV47bwOCdprKBQJnCMoMKHMnsRjkB/0WdewuG5Vx31G8HcZ0/1w8gfj9twDX7SqH5Z7JH6VkJcJB
	Ssls5QH1069tr4g6xTJYn1e+osYzbSWN/HCiOSrh+CC7MiBFbPnaAGcb7t1b6g0amley28YUn/U1C
	JPG0ORzw==;
Received: from [2001:4bb8:198:a22c:146a:86ef:5806:b115] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rS08v-00DkVG-1C;
	Mon, 22 Jan 2024 19:39:38 +0000
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] xfs: walk b_addr for buffer I/O
Date: Mon, 22 Jan 2024 20:39:15 +0100
Message-Id: <20240122193916.1803448-4-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240122193916.1803448-1-hch@lst.de>
References: <20240122193916.1803448-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Instead of walking the page array just walk the kernel virtual
address in ->b_addr.  This prepares for using vmalloc for buffers
and removing the b_pages array.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_buf.c | 93 ++++++++++++++----------------------------------
 fs/xfs/xfs_buf.h |  2 --
 2 files changed, 26 insertions(+), 69 deletions(-)

diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 1bfd89dbb78d79..ddd917bed22e34 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -343,7 +343,6 @@ xfs_buf_alloc_kmem(
 		bp->b_addr = NULL;
 		return -ENOMEM;
 	}
-	bp->b_offset = offset_in_page(bp->b_addr);
 	bp->b_pages = bp->b_page_array;
 	bp->b_pages[0] = kmem_to_page(bp->b_addr);
 	bp->b_page_count = 1;
@@ -1426,79 +1425,47 @@ xfs_buf_bio_end_io(
 static void
 xfs_buf_ioapply_map(
 	struct xfs_buf	*bp,
-	int		map,
-	int		*buf_offset,
-	int		*count,
+	unsigned int	map,
+	unsigned int	*buf_offset,
 	blk_opf_t	op)
 {
-	int		page_index;
-	unsigned int	total_nr_pages = bp->b_page_count;
-	int		nr_pages;
 	struct bio	*bio;
-	sector_t	sector =  bp->b_maps[map].bm_bn;
 	int		size;
-	int		offset;
-
-	/* skip the pages in the buffer before the start offset */
-	page_index = 0;
-	offset = *buf_offset;
-	while (offset >= PAGE_SIZE) {
-		page_index++;
-		offset -= PAGE_SIZE;
-	}
 
 	/*
 	 * Limit the IO size to the length of the current vector, and update the
 	 * remaining IO count for the next time around.
 	 */
-	size = min_t(int, BBTOB(bp->b_maps[map].bm_len), *count);
-	*count -= size;
-	*buf_offset += size;
+	size = min_t(unsigned int, BBTOB(bp->b_maps[map].bm_len),
+			BBTOB(bp->b_length) - *buf_offset);
+	if (WARN_ON_ONCE(bp->b_page_count > BIO_MAX_VECS)) {
+		xfs_buf_ioerror(bp, -EIO);
+		return;
+	}
 
-next_chunk:
 	atomic_inc(&bp->b_io_remaining);
-	nr_pages = bio_max_segs(total_nr_pages);
 
-	bio = bio_alloc(bp->b_target->bt_bdev, nr_pages, op, GFP_NOIO);
-	bio->bi_iter.bi_sector = sector;
+	bio = bio_alloc(bp->b_target->bt_bdev, bp->b_page_count, op, GFP_NOIO);
+	bio->bi_iter.bi_sector = bp->b_maps[map].bm_bn;
 	bio->bi_end_io = xfs_buf_bio_end_io;
 	bio->bi_private = bp;
 
-	for (; size && nr_pages; nr_pages--, page_index++) {
-		int	rbytes, nbytes = PAGE_SIZE - offset;
+	do {
+		void		*data = bp->b_addr + *buf_offset;
+		struct page	*page = kmem_to_page(data);
+		unsigned int	off = offset_in_page(data);
+		unsigned int	len = min_t(unsigned, size, PAGE_SIZE - off);
 
-		if (nbytes > size)
-			nbytes = size;
+		__bio_add_page(bio, page, len, off);
+		size -= len;
+		*buf_offset += len;
+	} while (size);
 
-		rbytes = bio_add_page(bio, bp->b_pages[page_index], nbytes,
-				      offset);
-		if (rbytes < nbytes)
-			break;
-
-		offset = 0;
-		sector += BTOBB(nbytes);
-		size -= nbytes;
-		total_nr_pages--;
+	if (xfs_buf_is_vmapped(bp)) {
+		flush_kernel_vmap_range(bp->b_addr,
+					xfs_buf_vmap_len(bp));
 	}
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
+	submit_bio(bio);
 }
 
 STATIC void
@@ -1507,8 +1474,7 @@ _xfs_buf_ioapply(
 {
 	struct blk_plug	plug;
 	blk_opf_t	op;
-	int		offset;
-	int		size;
+	unsigned int	offset = 0;
 	int		i;
 
 	/*
@@ -1564,16 +1530,9 @@ _xfs_buf_ioapply(
 	 * _xfs_buf_ioapply_vec() will modify them appropriately for each
 	 * subsequent call.
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
-	}
+	for (i = 0; i < bp->b_map_count; i++)
+		xfs_buf_ioapply_map(bp, i, &offset, op);
 	blk_finish_plug(&plug);
 }
 
diff --git a/fs/xfs/xfs_buf.h b/fs/xfs/xfs_buf.h
index 379d58c4cb9a27..2116fed2b53026 100644
--- a/fs/xfs/xfs_buf.h
+++ b/fs/xfs/xfs_buf.h
@@ -186,8 +186,6 @@ struct xfs_buf {
 	atomic_t		b_pin_count;	/* pin count */
 	atomic_t		b_io_remaining;	/* #outstanding I/O requests */
 	unsigned int		b_page_count;	/* size of page array */
-	unsigned int		b_offset;	/* page offset of b_addr,
-						   only for _XBF_KMEM buffers */
 	int			b_error;	/* error code on I/O */
 
 	/*
-- 
2.39.2

