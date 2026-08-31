Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D4A3BCD2F;
	Mon, 31 Aug 2026 06:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158526; cv=none; b=X4vUgj6MDiGmu63DiAtgEyXb2M9HUoTtmZlVgyr1nTRElrel40q/NjnC3f2UJiW4SyVePe5/CMYghhgiP6cIsD66UC4B9Yj86eOFp6y94kfXAPg79XJV3sMJA7fS2JasvFYHPWpLMKYAKbbtftTSMyxLh+VD18lDjy/JXsKTVsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158526; c=relaxed/simple;
	bh=YdfQlYOjGlndC73PB4cjicfJI2nwmvLf/Ak+zeUVDPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnHvYGFKcFqoaXMIGkNGioUTxWHxSrNTY7hn6CQMhzPYd1dLr+fbLj6DKZyKBdXyArP2BQLHT2yTj/MpWYWEYfC7YbkjcvOp77gusDTgzIgseIysz9bOAjKII9AlC6G2JfOWi29hIiIKkAuyLPEWEoifNgJUJimctAHmA0pyx5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XShJpXY1; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XShJpXY1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ocqFmlgeX1hM5Oj3lASbpWSi4JuxfBR0d39XwVhm2vY=; b=XShJpXY1L1Z5DHNflWih55JcGR
	Anf47EyhEtYka1C+pdJT/FtIFCdtztS12c45Vp5lnl68nkgsB2d+WbGw3DW5AeYp/GKBEpxr6BiNB
	40FYki2REBnSNl7o3S0jp1ybeqRB1+6jWPxoUJFiSqhuvjY2Z/2Js9ootR0Dq5u/KCimgbcWwk387
	IhEgkQmIYGfy1YCw9MlK2Cfph/Jb8gI+7U0wVqZrK29SBQhm9kzaUfcxiJmLpdJYHPlDHILnizCnD
	pT/Un1LNRLEKjYWwlyzzGd/tsekwlCVSl82d1/XdD88W8bux7yUktv9xRVEF9KLlwKW9+bMnUvd/t
	bjLtKeWA==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0viS-00000008d1P-3fCW;
	Mon, 31 Aug 2026 06:42:01 +0000
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
Subject: [PATCH 17/17] block,iomap: remove the old read side bounce buffering support
Date: Mon, 31 Aug 2026 09:40:05 +0300
Message-ID: <20260831064010.2574896-18-hch@lst.de>
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

bio_iov_iter_bounce_read turned to generate suboptimal I/O sizes and
isn't usable for lazy bounce buffering.  Now that is has been replaced
with the iomap side implementation that requires extra bounce bios, it
is unused and can be removed.  Change the interface so that the
previously hidden write-side implementation is directly exposed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c          | 144 +++++--------------------------------------
 fs/iomap/direct-io.c |   7 +--
 include/linux/bio.h  |   5 +-
 3 files changed, 20 insertions(+), 136 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index a87c33fe96ac..82ac8cda8271 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1397,7 +1397,20 @@ int bio_alloc_bounce_folios(struct bio *bio, size_t total_len, size_t minsize)
 	return 0;
 }
 
-static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
+/**
+ * bio_iov_iter_bounce_write - bounce buffer data from an iter into a bio
+ * @bio:	bio to send
+ * @iter:	iter to read from
+ * @maxlen:	maximum size to bounce
+ * @minsize:	minimum folio allocation size
+ *
+ * Helper for direct I/O write implementations that need to bounce buffer
+ * because they need need to checksum the data or perform other operations that
+ * require consistency.  Allocates folios to back the bounce buffer, and copies
+ * the data into it.  Needs to be paired with bio_free_folios() called on
+ * completion.
+ */
+int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
 		size_t maxlen, size_t minsize)
 {
 	size_t total_len = min(maxlen, iov_iter_count(iter));
@@ -1430,134 +1443,7 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
 	return bio_iov_iter_align_down(bio, iter,
 			&bio->bi_io_vec[bio->bi_vcnt - 1], minsize - 1);
 }
-
-static int bio_iov_iter_bounce_read(struct bio *bio, struct iov_iter *iter,
-		size_t maxlen, size_t minsize)
-{
-	size_t len = min3(iov_iter_count(iter), maxlen, SZ_1M);
-	struct folio *folio;
-	ssize_t ret;
-
-	folio = folio_alloc_greedy(GFP_KERNEL, &len, minsize);
-	if (!folio)
-		return -ENOMEM;
-
-	do {
-		ret = iov_iter_extract_bvecs(iter, bio->bi_io_vec + 1, len,
-				&bio->bi_vcnt, bio->bi_max_vecs - 1, 0, 0);
-		if (ret <= 0) {
-			if (!bio->bi_vcnt)
-				goto out_folio_put;
-			break;
-		}
-		len -= ret;
-		bio->bi_iter.bi_size += ret;
-	} while (len && bio->bi_vcnt < bio->bi_max_vecs - 1);
-
-	/*
-	 * Set the folio directly here.  The above loop has already calculated
-	 * the correct bi_size, and we use bi_vcnt for the user buffers.  That
-	 * is safe as bi_vcnt is only used by the submitter and not the actual
-	 * I/O path.
-	 */
-	bvec_set_folio(&bio->bi_io_vec[0], folio, bio->bi_iter.bi_size, 0);
-	if (iov_iter_extract_will_pin(iter))
-		bio_set_flag(bio, BIO_PAGE_PINNED);
-
-	/* The first vec stores the bounce buffer, so do not subtract 1 here. */
-	ret = bio_iov_iter_align_down(bio, iter,
-			&bio->bi_io_vec[bio->bi_vcnt], minsize - 1);
-	if (ret)
-		goto out_folio_put;
-
-	/* Update the bounc buffer bv_len to the aligned down size. */
-	bio->bi_io_vec[0].bv_len = bio->bi_iter.bi_size;
-	return 0;
-
-out_folio_put:
-	folio_put(folio);
-	return ret;
-}
-
-/**
- * bio_iov_iter_bounce - bounce buffer data from an iter into a bio
- * @bio:	bio to send
- * @iter:	iter to read from / write into
- * @maxlen:	maximum size to bounce
- * @minsize:	minimum folio allocation size
- *
- * Helper for direct I/O implementations that need to bounce buffer because
- * we need to checksum the data or perform other operations that require
- * consistency.  Allocates folios to back the bounce buffer, and for writes
- * copies the data into it.  Needs to be paired with bio_iov_iter_unbounce()
- * called on completion.
- */
-int bio_iov_iter_bounce(struct bio *bio, struct iov_iter *iter, size_t maxlen,
-			size_t minsize)
-{
-	if (op_is_write(bio_op(bio)))
-		return bio_iov_iter_bounce_write(bio, iter, maxlen, minsize);
-	return bio_iov_iter_bounce_read(bio, iter, maxlen, minsize);
-}
-
-static void bvec_unpin(struct bio_vec *bv, bool mark_dirty)
-{
-	struct folio *folio = bvec_folio(bv);
-	size_t nr_pages = (bv->bv_offset + bv->bv_len - 1) / PAGE_SIZE -
-			bv->bv_offset / PAGE_SIZE + 1;
-
-	if (mark_dirty)
-		folio_mark_dirty_lock(folio);
-	unpin_user_folio(folio, nr_pages);
-}
-
-static void bio_iov_iter_unbounce_read(struct bio *bio, bool is_error,
-		bool mark_dirty)
-{
-	unsigned int len = bio->bi_io_vec[0].bv_len;
-
-	if (likely(!is_error)) {
-		void *buf = bvec_virt(&bio->bi_io_vec[0]);
-		struct iov_iter to;
-
-		iov_iter_bvec(&to, ITER_DEST, bio->bi_io_vec + 1, bio->bi_vcnt,
-				len);
-		/* copying to pinned pages should always work */
-		WARN_ON_ONCE(copy_to_iter(buf, len, &to) != len);
-	} else {
-		/* No need to mark folios dirty if never copied to them */
-		mark_dirty = false;
-	}
-
-	if (bio_flagged(bio, BIO_PAGE_PINNED)) {
-		int i;
-
-		for (i = 0; i < bio->bi_vcnt; i++)
-			bvec_unpin(&bio->bi_io_vec[1 + i], mark_dirty);
-	}
-
-	folio_put(bvec_folio(&bio->bi_io_vec[0]));
-}
-
-/**
- * bio_iov_iter_unbounce - finish a bounce buffer operation
- * @bio:	completed bio
- * @is_error:	%true if an I/O error occurred and data should not be copied
- * @mark_dirty:	If %true, folios will be marked dirty.
- *
- * Helper for direct I/O implementations that need to bounce buffer because
- * we need to checksum the data or perform other operations that require
- * consistency.  Called to complete a bio set up by bio_iov_iter_bounce().
- * Copies data back for reads, and marks the original folios dirty if
- * requested and then frees the bounce buffer.
- */
-void bio_iov_iter_unbounce(struct bio *bio, bool is_error, bool mark_dirty)
-{
-	if (op_is_write(bio_op(bio)))
-		bio_free_folios(bio);
-	else
-		bio_iov_iter_unbounce_read(bio, is_error, mark_dirty);
-}
+EXPORT_SYMBOL_GPL(bio_iov_iter_bounce_write);
 
 static void bio_wait_end_io(struct bio *bio)
 {
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 4154717a09de..41fdc90a9094 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -255,8 +255,7 @@ static void __iomap_dio_bio_end_io(struct bio *bio, bool inline_completion)
 		fs_bio_integrity_free(bio);
 
 	if (dio->flags & IOMAP_DIO_BOUNCE) {
-		bio_iov_iter_unbounce(bio, !!dio->error,
-				dio->flags & IOMAP_DIO_USER_BACKED);
+		bio_free_folios(bio);
 		bio_put(bio);
 	} else if (dio->flags & IOMAP_DIO_USER_BACKED) {
 		bio_check_pages_dirty(bio);
@@ -364,7 +363,7 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 	bio->bi_end_io = iomap_dio_bio_end_io;
 
 	if (dio->flags & IOMAP_DIO_BOUNCE)
-		ret = bio_iov_iter_bounce(bio, dio->submit.iter, maxsize,
+		ret = bio_iov_iter_bounce_write(bio, dio->submit.iter, maxsize,
 				alignment);
 	else
 		ret = bio_iov_iter_get_pages(bio, dio->submit.iter, maxsize,
@@ -398,7 +397,7 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 
 out_bio_release_pages:
 	if (dio->flags & IOMAP_DIO_BOUNCE)
-		bio_iov_iter_unbounce(bio, true, false);
+		bio_free_folios(bio);
 	else
 		bio_release_pages(bio, false);
 out_put_bio:
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 584b6abf6baf..828ae414e365 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -524,11 +524,10 @@ void __bio_release_pages(struct bio *bio, bool mark_dirty);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
 
-int bio_iov_iter_bounce(struct bio *bio, struct iov_iter *iter, size_t maxlen,
-		size_t minsize);
-void bio_iov_iter_unbounce(struct bio *bio, bool is_error, bool mark_dirty);
 int bio_alloc_bounce_folios(struct bio *bio, size_t total_len, size_t minsize);
 void bio_free_folios(struct bio *bio);
+int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
+		size_t maxlen, size_t minsize);
 
 extern void bio_copy_data(struct bio *dst, struct bio *src);
 extern void bio_free_pages(struct bio *bio);
-- 
2.53.0

