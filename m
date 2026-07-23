Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D20B3290C9;
	Thu, 23 Jul 2026 14:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784818250; cv=none; b=EZaWk0KaHqrSj43ui6T9YHLXNqYFLVTUDYiNhXqVpyVyzxke8pP2oU9xHTIiisjlocxvMB/Y4hjQdyi8cvDLcd3yw0wAR3XtE8ZTGXd/2+wYbyG+TcolaEpNrSkKdLKuelVDx3Fz4Ve2AtEcgE7jKFBa7FdfQDYbAL3eDSISLgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784818250; c=relaxed/simple;
	bh=6w+vaXJyXjfF5OEiYd/Jj6yQihKCF5ikwTrIVvG2k4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQo8fEwY/qTEgF3SGmMcAFOYZN/6lx+t0w9ms410gZrB3KBzJlaXnImP7yi7Croa9PU5Z5jqxVArrwsmn/9qzc9+VfDg0fQHLa1YgYHmZlbkto1awgJp2A3N4ZqvGMSW26LvoVjaB3jrE5L1g6m5db/UH0TJj5Mk+F5XseR3+Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cHNVxP/q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cHNVxP/q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Hi6XblRmT44/njbEllFzwtTsGKwSBrZmAq0G3Hk2hfo=; b=cHNVxP/qsVuZXsKBbTjn4KNmaK
	iOgBSNZLGNj7EyZJL2TFHyYFc+qD8ZCg1Nv/YFT34PM0NtSjKFZDxpG+VcDx6crThOaZJSDg5HJQF
	xgctqkIUBuTac6adtS0+QMM1CSkwprEmY4lBwPP03lR3bL3vQ/dlnu8WDxBNZELYvIP9NEyggZALv
	SacIjhVKMbhRsekmCkjp9fREWO/XBBtOkKN0QjpjcnZOflKswE4wOhlZyug1Yy05Izn4vu6nHlilp
	sGTGuYNZ13yMRPgwxTH+WXsgepJkFdhrxoWjql7mStzPQNgLaE/RMTaHY9wUocYi2P6K8/WG3TZzh
	leEF1u1Q==;
Received: from [2001:4bb8:2e9:b20c:3d3c:bb0:5e13:19af] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmul5-0000000EXKb-3HBr;
	Thu, 23 Jul 2026 14:50:48 +0000
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
Subject: [PATCH 09/22] block: split bio_iov_iter_bounce_write
Date: Thu, 23 Jul 2026 16:49:34 +0200
Message-ID: <20260723145000.116419-10-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260723145000.116419-1-hch@lst.de>
References: <20260723145000.116419-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Factor out a bio_alloc_bounce_folios helper that we'll use for a
different take on read-side bounce buffering soon.

For that make it and also bio_free_folios available to callers outside of
bio.c.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c         | 58 ++++++++++++++++++++++++++-------------------
 include/linux/bio.h |  2 ++
 2 files changed, 35 insertions(+), 25 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 79fb94f85a5f..545cd8622ebd 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1298,7 +1298,7 @@ static struct folio *folio_alloc_greedy(gfp_t gfp, size_t *size,
 	return folio_alloc(gfp, get_order(*size));
 }
 
-static void bio_free_folios(struct bio *bio)
+void bio_free_folios(struct bio *bio)
 {
 	struct bio_vec *bv;
 	int i;
@@ -1311,11 +1311,8 @@ static void bio_free_folios(struct bio *bio)
 	}
 }
 
-static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
-		size_t maxlen, size_t minsize)
+int bio_alloc_bounce_folios(struct bio *bio, size_t total_len, size_t minsize)
 {
-	size_t total_len = min(maxlen, iov_iter_count(iter));
-
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
 		return -EINVAL;
 	if (WARN_ON_ONCE(bio->bi_iter.bi_size))
@@ -1325,7 +1322,6 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
 
 	do {
 		size_t this_len = min(total_len, SZ_1M);
-		size_t copied;
 		struct folio *folio;
 
 		if (this_len > minsize * 2)
@@ -1338,32 +1334,44 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
 		if (!folio)
 			break;
 		bio_add_folio_nofail(bio, folio, this_len, 0);
+		total_len -= this_len;
+	} while (total_len && bio->bi_vcnt < bio->bi_max_vecs);
+
+	if (!bio->bi_iter.bi_size)
+		return -ENOMEM;
+	return 0;
+}
+
+static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
+		size_t maxlen, size_t minsize)
+{
+	size_t total_len = min(maxlen, iov_iter_count(iter));
+	size_t total_copied = 0;
+	struct bio_vec *bv;
+	int i, error;
+
+	error = bio_alloc_bounce_folios(bio, total_len, minsize);
+	if (error)
+		return error;
+
+	bio_for_each_bvec_all(bv, bio, i) {
+		struct folio *folio = page_folio(bv->bv_page);
+		size_t copied;
 
 		if (iter->nofault)
-			copied = copy_folio_from_iter_atomic(folio, 0, this_len,
-							     iter);
+			copied = copy_folio_from_iter_atomic(folio, 0,
+					bv->bv_len, iter);
 		else
-			copied = copy_folio_from_iter(folio, 0, this_len, iter);
-		if (copied < this_len) {
-			/*
-			 * Need to revert the iov iter for all bytes we have
-			 * copied.
-			 *
-			 * However the bio size differs from the real copied
-			 * bytes as @this_len is queued but only advanced
-			 * less than that.
-			 * Need to compensate that for the revert.
-			 */
-			iov_iter_revert(iter, bio->bi_iter.bi_size - this_len +
-					copied);
+			copied = copy_folio_from_iter(folio, 0, bv->bv_len,
+					iter);
+		total_copied += copied;
+		if (copied < bv->bv_len) {
+			iov_iter_revert(iter, total_copied);
 			bio_free_folios(bio);
 			return -EFAULT;
 		}
-		total_len -= this_len;
-	} while (total_len && bio->bi_vcnt < bio->bi_max_vecs);
+	}
 
-	if (!bio->bi_iter.bi_size)
-		return -ENOMEM;
 	return bio_iov_iter_align_down(bio, iter,
 			&bio->bi_io_vec[bio->bi_vcnt - 1], minsize - 1);
 }
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 501847105aa8..7db87ea0e1b0 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -519,6 +519,8 @@ extern void bio_check_pages_dirty(struct bio *bio);
 int bio_iov_iter_bounce(struct bio *bio, struct iov_iter *iter, size_t maxlen,
 		size_t minsize);
 void bio_iov_iter_unbounce(struct bio *bio, bool is_error, bool mark_dirty);
+int bio_alloc_bounce_folios(struct bio *bio, size_t total_len, size_t minsize);
+void bio_free_folios(struct bio *bio);
 
 extern void bio_copy_data(struct bio *dst, struct bio *src);
 extern void bio_free_pages(struct bio *bio);
-- 
2.53.0

