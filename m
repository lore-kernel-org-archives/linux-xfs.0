Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EC9232E6B8;
	Thu, 18 Dec 2025 06:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766039572; cv=none; b=FwLNMPs/GNoOg1qsH0xyD9LRUiCCEjF76zCq8OHlCNIvGu0UXgrPN1Ddj0i+77LM8OLcMh6DEJVzT8TqJ0CHgok9Qnl4NkYtrSnOx8zs1UsINywplbNQy8Y5+e96CoPPE6iW5EB0fMJk6D4XSXk8D5ZYAp5Z5vFntQC656xtWzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766039572; c=relaxed/simple;
	bh=p87NNM3i//FKn5NQp18EQt86lR3vuoi2PEyT2iZ9us0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVfaZy7oH/faCbQSwp7Nka16rmIEmkJGXZUDN/XqKLq/hNRPs7mVXDa2ftqAYA53emx9VwaXGogu7jHVudrlJhJQKEBKKXNyf8uu1oV4J+8Km1vrWSHicacBY7LJtybVAwWIBHxTFmsLIPlpDTLH6yTba6GOL0ETaZE7Uoy5e2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UH6cVu9h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UH6cVu9h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IfLWjeSyO7jIvG5rByClBg0W1Af+u4x9Ppzz5fTuPy8=; b=UH6cVu9hOfdTbu0APKcLjnzr+F
	tDmVy/OY1CZcQxQgWYW9z/BJmPhKt5iiRrfXcgCRTzl2Z5LYZh26JYL7Y1IESK0+Wv0w157JBeN92
	mRG5yqs1T7s9bnra04BCCMCxHjl4312EzncVaoXwtr2Jr1xtjWD5ZdsLfmc6HcY2uM431a69L6TK1
	m/RM+DiOC87FCbOph3OHp7aYjKfnRgF2jzYgjslnQ3rIhTxNE2BrhLerUy8CJ8sd8WzjdCnslLAkX
	ETi+vJHvBOVgwHqSHEfB1TSokxeDUlA6WeDnDYFBTlCWG38ppPmFLQgkqE4mlhqztsXmxByXjX7Wf
	pTCtRMXA==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vW7ZB-00000007tzy-29mt;
	Thu, 18 Dec 2025 06:32:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Carlos Maiolino <cem@kernel.org>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/3] xfs: rework zone GC buffer management
Date: Thu, 18 Dec 2025 07:31:47 +0100
Message-ID: <20251218063234.1539374-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218063234.1539374-1-hch@lst.de>
References: <20251218063234.1539374-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

The double buffering where just one scratch area is used at a time does
not efficiently use the available memory.  It was originally implemented
when GC I/O could happen out of order, but that was removed before
upstream submission to avoid fragmentation.  Now that all GC I/Os are
processed in order, just use a number of buffers as a simple ring buffer.

For a synthetic benchmark that fills 256MiB HDD zones and punches out
holes to free half the space this leads to a decrease of GC time by
a little more than 25%.

Thanks to Hans Holmberg <hans.holmberg@wdc.com> for testing and
benchmarking.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_zone_gc.c | 106 ++++++++++++++++++++++++-------------------
 1 file changed, 59 insertions(+), 47 deletions(-)

diff --git a/fs/xfs/xfs_zone_gc.c b/fs/xfs/xfs_zone_gc.c
index f3dec13a620c..90f70473c3d5 100644
--- a/fs/xfs/xfs_zone_gc.c
+++ b/fs/xfs/xfs_zone_gc.c
@@ -50,23 +50,11 @@
  */
 
 /*
- * Size of each GC scratch pad.  This is also the upper bound for each
- * GC I/O, which helps to keep latency down.
+ * Size of each GC scratch allocation, and the number of buffers.
  */
-#define XFS_GC_CHUNK_SIZE	SZ_1M
-
-/*
- * Scratchpad data to read GCed data into.
- *
- * The offset member tracks where the next allocation starts, and freed tracks
- * the amount of space that is not used anymore.
- */
-#define XFS_ZONE_GC_NR_SCRATCH	2
-struct xfs_zone_scratch {
-	struct folio			*folio;
-	unsigned int			offset;
-	unsigned int			freed;
-};
+#define XFS_GC_BUF_SIZE		SZ_1M
+#define XFS_GC_NR_BUFS		2
+static_assert(XFS_GC_NR_BUFS < BIO_MAX_VECS);
 
 /*
  * Chunk that is read and written for each GC operation.
@@ -141,10 +129,14 @@ struct xfs_zone_gc_data {
 	struct bio_set			bio_set;
 
 	/*
-	 * Scratchpad used, and index to indicated which one is used.
+	 * Scratchpad to buffer GC data, organized as a ring buffer over
+	 * discontiguous folios.  scratch_head is where the buffer is filled,
+	 * and scratch_tail tracks the buffer space freed.
 	 */
-	struct xfs_zone_scratch		scratch[XFS_ZONE_GC_NR_SCRATCH];
-	unsigned int			scratch_idx;
+	struct folio			*scratch_folios[XFS_GC_NR_BUFS];
+	unsigned int			scratch_size;
+	unsigned int			scratch_head;
+	unsigned int			scratch_tail;
 
 	/*
 	 * List of bios currently being read, written and reset.
@@ -210,20 +202,16 @@ xfs_zone_gc_data_alloc(
 	if (!data->iter.recs)
 		goto out_free_data;
 
-	/*
-	 * We actually only need a single bio_vec.  It would be nice to have
-	 * a flag that only allocates the inline bvecs and not the separate
-	 * bvec pool.
-	 */
 	if (bioset_init(&data->bio_set, 16, offsetof(struct xfs_gc_bio, bio),
 			BIOSET_NEED_BVECS))
 		goto out_free_recs;
-	for (i = 0; i < XFS_ZONE_GC_NR_SCRATCH; i++) {
-		data->scratch[i].folio =
-			folio_alloc(GFP_KERNEL, get_order(XFS_GC_CHUNK_SIZE));
-		if (!data->scratch[i].folio)
+	for (i = 0; i < XFS_GC_NR_BUFS; i++) {
+		data->scratch_folios[i] =
+			folio_alloc(GFP_KERNEL, get_order(XFS_GC_BUF_SIZE));
+		if (!data->scratch_folios[i])
 			goto out_free_scratch;
 	}
+	data->scratch_size = XFS_GC_BUF_SIZE * XFS_GC_NR_BUFS;
 	INIT_LIST_HEAD(&data->reading);
 	INIT_LIST_HEAD(&data->writing);
 	INIT_LIST_HEAD(&data->resetting);
@@ -232,7 +220,7 @@ xfs_zone_gc_data_alloc(
 
 out_free_scratch:
 	while (--i >= 0)
-		folio_put(data->scratch[i].folio);
+		folio_put(data->scratch_folios[i]);
 	bioset_exit(&data->bio_set);
 out_free_recs:
 	kfree(data->iter.recs);
@@ -247,8 +235,8 @@ xfs_zone_gc_data_free(
 {
 	int			i;
 
-	for (i = 0; i < XFS_ZONE_GC_NR_SCRATCH; i++)
-		folio_put(data->scratch[i].folio);
+	for (i = 0; i < XFS_GC_NR_BUFS; i++)
+		folio_put(data->scratch_folios[i]);
 	bioset_exit(&data->bio_set);
 	kfree(data->iter.recs);
 	kfree(data);
@@ -591,7 +579,12 @@ static unsigned int
 xfs_zone_gc_scratch_available(
 	struct xfs_zone_gc_data	*data)
 {
-	return XFS_GC_CHUNK_SIZE - data->scratch[data->scratch_idx].offset;
+	if (!data->scratch_tail)
+		return data->scratch_size - data->scratch_head;
+
+	if (!data->scratch_head)
+		return data->scratch_tail;
+	return (data->scratch_size - data->scratch_head) + data->scratch_tail;
 }
 
 static bool
@@ -665,6 +658,28 @@ xfs_zone_gc_alloc_blocks(
 	return oz;
 }
 
+static void
+xfs_zone_gc_add_data(
+	struct xfs_gc_bio	*chunk)
+{
+	struct xfs_zone_gc_data	*data = chunk->data;
+	unsigned int		len = chunk->len;
+	unsigned int		off = data->scratch_head;
+
+	do {
+		unsigned int	this_off = off % XFS_GC_BUF_SIZE;
+		unsigned int	this_len = min(len, XFS_GC_BUF_SIZE - this_off);
+
+		bio_add_folio_nofail(&chunk->bio,
+				data->scratch_folios[off / XFS_GC_BUF_SIZE],
+				this_len, this_off);
+		len -= this_len;
+		off += this_len;
+		if (off == data->scratch_size)
+			off = 0;
+	} while (len);
+}
+
 static bool
 xfs_zone_gc_start_chunk(
 	struct xfs_zone_gc_data	*data)
@@ -678,6 +693,7 @@ xfs_zone_gc_start_chunk(
 	struct xfs_inode	*ip;
 	struct bio		*bio;
 	xfs_daddr_t		daddr;
+	unsigned int		len;
 	bool			is_seq;
 
 	if (xfs_is_shutdown(mp))
@@ -692,17 +708,19 @@ xfs_zone_gc_start_chunk(
 		return false;
 	}
 
-	bio = bio_alloc_bioset(bdev, 1, REQ_OP_READ, GFP_NOFS, &data->bio_set);
+	len = XFS_FSB_TO_B(mp, irec.rm_blockcount);
+	bio = bio_alloc_bioset(bdev,
+			min(howmany(len, XFS_GC_BUF_SIZE) + 1, XFS_GC_NR_BUFS),
+			REQ_OP_READ, GFP_NOFS, &data->bio_set);
 
 	chunk = container_of(bio, struct xfs_gc_bio, bio);
 	chunk->ip = ip;
 	chunk->offset = XFS_FSB_TO_B(mp, irec.rm_offset);
-	chunk->len = XFS_FSB_TO_B(mp, irec.rm_blockcount);
+	chunk->len = len;
 	chunk->old_startblock =
 		xfs_rgbno_to_rtb(iter->victim_rtg, irec.rm_startblock);
 	chunk->new_daddr = daddr;
 	chunk->is_seq = is_seq;
-	chunk->scratch = &data->scratch[data->scratch_idx];
 	chunk->data = data;
 	chunk->oz = oz;
 	chunk->victim_rtg = iter->victim_rtg;
@@ -711,13 +729,9 @@ xfs_zone_gc_start_chunk(
 
 	bio->bi_iter.bi_sector = xfs_rtb_to_daddr(mp, chunk->old_startblock);
 	bio->bi_end_io = xfs_zone_gc_end_io;
-	bio_add_folio_nofail(bio, chunk->scratch->folio, chunk->len,
-			chunk->scratch->offset);
-	chunk->scratch->offset += chunk->len;
-	if (chunk->scratch->offset == XFS_GC_CHUNK_SIZE) {
-		data->scratch_idx =
-			(data->scratch_idx + 1) % XFS_ZONE_GC_NR_SCRATCH;
-	}
+	xfs_zone_gc_add_data(chunk);
+	data->scratch_head = (data->scratch_head + len) % data->scratch_size;
+
 	WRITE_ONCE(chunk->state, XFS_GC_BIO_NEW);
 	list_add_tail(&chunk->entry, &data->reading);
 	xfs_zone_gc_iter_advance(iter, irec.rm_blockcount);
@@ -835,6 +849,7 @@ xfs_zone_gc_finish_chunk(
 	struct xfs_gc_bio	*chunk)
 {
 	uint			iolock = XFS_IOLOCK_EXCL | XFS_MMAPLOCK_EXCL;
+	struct xfs_zone_gc_data	*data = chunk->data;
 	struct xfs_inode	*ip = chunk->ip;
 	struct xfs_mount	*mp = ip->i_mount;
 	int			error;
@@ -846,11 +861,8 @@ xfs_zone_gc_finish_chunk(
 		return;
 	}
 
-	chunk->scratch->freed += chunk->len;
-	if (chunk->scratch->freed == chunk->scratch->offset) {
-		chunk->scratch->offset = 0;
-		chunk->scratch->freed = 0;
-	}
+	data->scratch_tail =
+		(data->scratch_tail + chunk->len) % data->scratch_size;
 
 	/*
 	 * Cycle through the iolock and wait for direct I/O and layouts to
-- 
2.47.3

