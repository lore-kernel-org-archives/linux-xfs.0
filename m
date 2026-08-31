Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56BC3B47FF;
	Mon, 31 Aug 2026 06:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158427; cv=none; b=AjeoZVF/UE0laBr3DSOBKUocipTwyfXT8Dsn70xspH089Qw4Dgpbr1X5jpTmg7HkD2DDF0GgNhKam7xFt6af9l/PQlwofq+IanLPH7gI+we9kVj79LLjuIL2ci7EkTSuZJZ5iQ32ZJYJ9yW2QgkFieBWycNwLOPgEgxFd8i8j/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158427; c=relaxed/simple;
	bh=We8qITbK7SNfNvgdeiVyOKD7Sbvm9bJk8pdNd/3XwCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNcRZcKY+zMygUZPtzv3eJMb91xp+mr3fDD6WzFaLN7lbkRbVCDE6uy4lLJtvl5Tl9InhH7s+OlXIRM0GTt6i6f0aMed0FNLclOp/wENaz642H78w1J/GssvnjpzEHuGQ1gGSd3gHi1vMJukqHpqG8/SUaVywp5ehIjoNjeugUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=3PwZ9Zgr; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="3PwZ9Zgr"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=4DkhIf8gb6zPilPXW0yailbBAKiVXHygzf7/PedHm8o=; b=3PwZ9Zgr1uevQaVGr8uyRASkn4
	OB9zH/VeoM9mGhFfRf2+Z3Hy+OOfv2ssg9+RqfUB1+yVkCBZf7Tf7hzFgfqS3GPNH5BmEcQ3cn7FE
	rVIbf1Rv5TcX//3ReGAtxXFnQECW7L2NZ1STh6E6RzSJDqCIYUyNRJDmwScNXxE8sRbZl5/lMGaIj
	C0F1zvLd21Wa3opVet/lxYWYSOTcvD9wPvGPTgf4hHHIZaSYi9Z9aJSmbmjfROSRDjbbeyfxC9JMm
	XMJeQza9zw68IH2sT7WNtylXCcCrlKfDchZv9unRCHRLiHtC5zCaWVi6TIaknkoWU/hT+H2bDHM3a
	ti5cvrNg==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vgt-00000008cso-0TEi;
	Mon, 31 Aug 2026 06:40:23 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>,
	Anuj Gupta <anuj20.g@samsung.com>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 01/17] block: pass a maxlen argument to bio_iov_iter_get_pages
Date: Mon, 31 Aug 2026 09:39:49 +0300
Message-ID: <20260831064010.2574896-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831064010.2574896-1-hch@lst.de>
References: <20260831064010.2574896-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Writes that require additional per-I/O allocations such as when using
file system level protection information can be limited to a maximum
size.  Allow passing that to bio_iov_iter_get_pages.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c          |  8 ++++++--
 block/blk-map.c      |  2 +-
 block/fops.c         |  3 ++-
 fs/iomap/direct-io.c | 10 +++++-----
 include/linux/bio.h  |  3 ++-
 5 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 898b2f5ef8c8..efd9483b8348 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1261,6 +1261,7 @@ static inline bool bio_iov_bvec_aligned(const struct bio *bio,
  * bio_iov_iter_get_pages - add user or kernel pages to a bio
  * @bio: bio to add pages to
  * @iter: iov iterator describing the region to be added
+ * @maxlen: maximum size to consume from @iter
  * @mem_align_mask: the mask the source address and length must be aligned to,
  *	0 for no requirement
  * @len_align_mask: the mask to align the total size to, 0 for any length
@@ -1281,7 +1282,8 @@ static inline bool bio_iov_bvec_aligned(const struct bio *bio,
  * is returned only if 0 pages could be pinned.
  */
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
-			   unsigned mem_align_mask, unsigned len_align_mask)
+			   unsigned maxlen, unsigned mem_align_mask,
+			   unsigned len_align_mask)
 {
 	iov_iter_extraction_t flags = 0;
 
@@ -1293,6 +1295,8 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
 		    !bio_iov_bvec_aligned(bio, mem_align_mask))
 			return -EINVAL;
 
+		/* Truncate to the maximum size that the caller can handle */
+		bio->bi_iter.bi_size = min(bio->bi_iter.bi_size, maxlen);
 		iov_iter_advance(iter, bio->bi_iter.bi_size);
 		return 0;
 	}
@@ -1306,7 +1310,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
 		ssize_t ret;
 
 		ret = iov_iter_extract_bvecs(iter, bio->bi_io_vec,
-				BIO_MAX_SIZE - bio->bi_iter.bi_size,
+				maxlen - bio->bi_iter.bi_size,
 				&bio->bi_vcnt, bio->bi_max_vecs,
 				mem_align_mask, flags);
 		if (ret <= 0) {
diff --git a/block/blk-map.c b/block/blk-map.c
index 9cb9605d1f62..81cba3af4e9c 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -274,7 +274,7 @@ static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
 	 * No alignment requirements on our part to support arbitrary
 	 * passthrough commands.
 	 */
-	ret = bio_iov_iter_get_pages(bio, iter, 0, 0);
+	ret = bio_iov_iter_get_pages(bio, iter, BIO_MAX_SIZE, 0, 0);
 	if (ret)
 		goto out_put;
 	ret = blk_rq_append_bio(rq, bio);
diff --git a/block/fops.c b/block/fops.c
index 2ce7c6c4714e..a83df69b175a 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -46,7 +46,8 @@ static bool blkdev_dio_invalid(struct block_device *bdev, struct kiocb *iocb,
 static inline int blkdev_iov_iter_get_pages(struct bio *bio,
 		struct iov_iter *iter, struct block_device *bdev)
 {
-	return bio_iov_iter_get_pages(bio, iter, bdev_dma_alignment(bdev),
+	return bio_iov_iter_get_pages(bio, iter, BIO_MAX_SIZE,
+			bdev_dma_alignment(bdev),
 			bdev_logical_block_size(bdev) - 1);
 }
 
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 8b4039d16ce8..bc726d47b7dc 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -359,8 +359,8 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 				iomap_max_bio_size(&iter->iomap), alignment);
 	else
 		ret = bio_iov_iter_get_pages(bio, dio->submit.iter,
-					     bdev_dma_alignment(bio->bi_bdev),
-					     alignment - 1);
+				BIO_MAX_SIZE, bdev_dma_alignment(bio->bi_bdev),
+				alignment - 1);
 	if (unlikely(ret))
 		goto out_put_bio;
 	ret = bio->bi_iter.bi_size;
@@ -1034,9 +1034,9 @@ ssize_t __iomap_dio_read_simple(struct kiocb *iocb, struct iov_iter *iter,
 	bio->bi_iter.bi_sector = iomap_sector(&iomi->iomap, iomi->pos);
 	bio->bi_ioprio = iocb->ki_ioprio;
 
-	ret = bio_iov_iter_get_pages(bio, iter,
-				bdev_dma_alignment(bio->bi_bdev),
-				alignment - 1);
+	ret = bio_iov_iter_get_pages(bio, iter, BIO_MAX_SIZE,
+			bdev_dma_alignment(bio->bi_bdev),
+			alignment - 1);
 	if (unlikely(ret))
 		goto out_bio_put;
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index bb3235497e67..0070be355181 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -516,7 +516,8 @@ int bdev_rw_virt(struct block_device *bdev, sector_t sector, void *data,
 		size_t len, enum req_op op);
 
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
-		unsigned mem_align_mask, unsigned len_align_mask);
+		unsigned maxlen, unsigned mem_align_mask,
+		unsigned len_align_mask);
 
 bool bio_iov_iter_set(struct bio *bio, const struct iov_iter *iter);
 void __bio_release_pages(struct bio *bio, bool mark_dirty);
-- 
2.53.0

