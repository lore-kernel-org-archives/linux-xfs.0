Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8581221FBB;
	Thu,  7 May 2026 05:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778130125; cv=none; b=K/mROdsJ+kF6TBwzAcFG7i+8dm4dRZrZsgtXujDn7lW/KHGel7CsiGHXlIdDVLx8ImMsEZmmOoXEOSsQXpzIhCbeDoN4dpYLTZLfyghWOZG0Tm0ubse/5DLgsANi+bvAYMqxSzLZOCcNzHScYHaO2Kgm5ohPUaOyXZJvza7cUrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778130125; c=relaxed/simple;
	bh=ePuawZF9OjLQtudaPEwK1xGAtWR3g3zQGfYuJsu7Z1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ABoxzDH+Y8JV8A1t2eNwMfmaV/TLAoyjZUrqdqCLxafsRpaYKlCcTCEORhajjfSbMu3KjGeMQ1DfSDelYYBKP0Qco2DjC+9SVRKPR7CRrb481w1VyOcTV3+YBUj5Q5UwRsyMeh1M0MWvyTH2UjGxoL9KqND28BKzFM7YOc53TMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=jWpChlOf; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jWpChlOf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FaFKH5vT2rtipzrQllR+phwI/hXuQWvFEHX9DcKIENA=; b=jWpChlOfUQBx+Ra7D/OJZ3MA/h
	qRGTTtGujmksUrPXM4S+rQv8KboyU67ZO1Zz0mOilb8gwUXjBYVIMyKDASxwZ/I7n5fPj8VEvKa+/
	ZmuDvVfvURPcLvStSRoxj/s/kWwxilae74FNpLck3eMRiN1QBAxtFh+N3rjCRGjySJbB9ojCn52sL
	OXfBavWXw/5IJ7CV0Uuo06NE64HcZdRTT/yjVvCI9jHSkzJYD9RO628FY+5Qj2QTq4nRf2qhRI9Xq
	kC+KPSq/A6lhvJ5kY4HJUIL/wBk5x/mJlbRZ7C5ITjCensRGtu/8iDJL99piI72elzzmGIxXgvf4y
	SsghooUw==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wKqs6-00000002ly6-2O4A;
	Thu, 07 May 2026 05:02:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Pankaj Raghav <pankaj.raghav@linux.dev>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/2] block: pass a minsize argument to bio_iov_iter_bounce
Date: Thu,  7 May 2026 07:01:47 +0200
Message-ID: <20260507050153.1298375-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260507050153.1298375-1-hch@lst.de>
References: <20260507050153.1298375-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When bouncing for block size > PAGE_SIZE file systems that require
file system block size alignment (e.g. zoned XFS), the bio needs to
be big enough to fit an entire block.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c          | 23 +++++++++++++----------
 fs/iomap/direct-io.c |  2 +-
 include/linux/bio.h  |  3 ++-
 3 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index b8972dba68a0..f3e5d8bea08c 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1279,11 +1279,12 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
 	return bio_iov_iter_align_down(bio, iter, len_align_mask);
 }
 
-static struct folio *folio_alloc_greedy(gfp_t gfp, size_t *size)
+static struct folio *folio_alloc_greedy(gfp_t gfp, size_t *size,
+		size_t minsize)
 {
 	struct folio *folio;
 
-	while (*size > PAGE_SIZE) {
+	while (*size > minsize) {
 		folio = folio_alloc(gfp | __GFP_NORETRY, get_order(*size));
 		if (folio)
 			return folio;
@@ -1307,7 +1308,7 @@ static void bio_free_folios(struct bio *bio)
 }
 
 static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
-		size_t maxlen)
+		size_t maxlen, size_t minsize)
 {
 	size_t total_len = min(maxlen, iov_iter_count(iter));
 
@@ -1322,13 +1323,13 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
 		size_t this_len = min(total_len, SZ_1M);
 		struct folio *folio;
 
-		if (this_len > PAGE_SIZE * 2)
+		if (this_len > minsize * 2)
 			this_len = rounddown_pow_of_two(this_len);
 
 		if (bio->bi_iter.bi_size > BIO_MAX_SIZE - this_len)
 			break;
 
-		folio = folio_alloc_greedy(GFP_KERNEL, &this_len);
+		folio = folio_alloc_greedy(GFP_KERNEL, &this_len, minsize);
 		if (!folio)
 			break;
 		bio_add_folio_nofail(bio, folio, this_len, 0);
@@ -1348,12 +1349,12 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
 }
 
 static int bio_iov_iter_bounce_read(struct bio *bio, struct iov_iter *iter,
-		size_t maxlen)
+		size_t maxlen, size_t minsize)
 {
 	size_t len = min3(iov_iter_count(iter), maxlen, SZ_1M);
 	struct folio *folio;
 
-	folio = folio_alloc_greedy(GFP_KERNEL, &len);
+	folio = folio_alloc_greedy(GFP_KERNEL, &len, minsize);
 	if (!folio)
 		return -ENOMEM;
 
@@ -1390,6 +1391,7 @@ static int bio_iov_iter_bounce_read(struct bio *bio, struct iov_iter *iter,
  * @bio:	bio to send
  * @iter:	iter to read from / write into
  * @maxlen:	maximum size to bounce
+ * @minsize:	minimum folio allocation size
  *
  * Helper for direct I/O implementations that need to bounce buffer because
  * we need to checksum the data or perform other operations that require
@@ -1397,11 +1399,12 @@ static int bio_iov_iter_bounce_read(struct bio *bio, struct iov_iter *iter,
  * copies the data into it.  Needs to be paired with bio_iov_iter_unbounce()
  * called on completion.
  */
-int bio_iov_iter_bounce(struct bio *bio, struct iov_iter *iter, size_t maxlen)
+int bio_iov_iter_bounce(struct bio *bio, struct iov_iter *iter, size_t maxlen,
+			size_t minsize)
 {
 	if (op_is_write(bio_op(bio)))
-		return bio_iov_iter_bounce_write(bio, iter, maxlen);
-	return bio_iov_iter_bounce_read(bio, iter, maxlen);
+		return bio_iov_iter_bounce_write(bio, iter, maxlen, minsize);
+	return bio_iov_iter_bounce_read(bio, iter, maxlen, minsize);
 }
 
 static void bvec_unpin(struct bio_vec *bv, bool mark_dirty)
diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b0a6549b3848..b36ee619cdcd 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -355,7 +355,7 @@ static ssize_t iomap_dio_bio_iter_one(struct iomap_iter *iter,
 
 	if (dio->flags & IOMAP_DIO_BOUNCE)
 		ret = bio_iov_iter_bounce(bio, dio->submit.iter,
-				iomap_max_bio_size(&iter->iomap));
+				iomap_max_bio_size(&iter->iomap), alignment);
 	else
 		ret = bio_iov_iter_get_pages(bio, dio->submit.iter,
 					     alignment - 1);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 97d747320b35..dc17780d6c1e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -475,7 +475,8 @@ void __bio_release_pages(struct bio *bio, bool mark_dirty);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
 
-int bio_iov_iter_bounce(struct bio *bio, struct iov_iter *iter, size_t maxlen);
+int bio_iov_iter_bounce(struct bio *bio, struct iov_iter *iter, size_t maxlen,
+		size_t minsize);
 void bio_iov_iter_unbounce(struct bio *bio, bool is_error, bool mark_dirty);
 
 extern void bio_copy_data_iter(struct bio *dst, struct bvec_iter *dst_iter,
-- 
2.53.0

