Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B611423A9D;
	Thu, 30 Apr 2026 13:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777555238; cv=none; b=NWAs+TnZ6LDapQECdHqR1EwCKQcB98s+EBk1V6nBDGW/xI7M+gaqhtvtZJIyzsuOwYS4wdWg70K+8cfVrowxyFReN92/fOfO6TKkSfPNzMcwstXKW34Jzv5TXZgmmXWVyXwmgibZgNd9BMRnyO7RIQ8dIBoQdsYR9ylvxZUlrh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777555238; c=relaxed/simple;
	bh=bpoan2kgr9u0YNCzi3qNlb8rAxf2sZgibNuWaH3BxqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pWVSiqLR/9x/8fmn3/p2LaiVwmEyzj87ql6gdK6CRTrGcTFlW2Vu/sFmPPCl0REj2UR35r/PER0Ph7Vuc4es1dieTARg4vlqB3oWB7qLDcyR86pPZZAUMXepPLJ7Stz6nzOtDmrqts0VWATLL76x+GTzwffFC+r5beL/pr0H/RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=SF/EQ3XW; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="SF/EQ3XW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=CPFxZNTQytVfHaxtfiohRAc9s2mKfDTB2TlkwitFdEg=; b=SF/EQ3XWRjqFJiQUZhtn90HMuj
	djFNUt+lvt04W5jFmo+2GRHNi/smEVo5AymolkJ9YFlSZ05rYFwUq00HIap4O2Mci0ocHS6YlIc/2
	/0jXrERaicQ+SpZd3QdTm5cOylh01YvL4RNh35F9xqj8gVOV38K50I3UJMqanHSAk1v2i+W8lxVm5
	j2my5iYMQXFme0CJCQgNfMC6iat99H7Vh46RhlRKQfgr52mPSCDwsM8TmGrb2C2xlhXBv6s9c4ZaJ
	qWpib6BdzBM+m+hLt0W6RRCVQQuppb/PPaXoZMfyCPpJ0oDwDSVfFFBjszu7mo5IiQCwerzFTNNVn
	3G0Yal+A==;
Received: from [2001:4bb8:2d1:b956:8772:dd9e:18ae:7a3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wIRJc-00000005WvA-3UvF;
	Thu, 30 Apr 2026 13:20:29 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH 1/2] block: pass a minsize argument to bio_iov_iter_bounce
Date: Thu, 30 Apr 2026 15:20:04 +0200
Message-ID: <20260430132019.312405-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260430132019.312405-1-hch@lst.de>
References: <20260430132019.312405-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

When bouncing for block size > PAGE_SIZE file systems, the bio needs to
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

