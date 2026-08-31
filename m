Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E4803BE635;
	Mon, 31 Aug 2026 06:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788158440; cv=none; b=JzjJSRC8Tau2ci33rFf8I+OM2h97TBclook+WIGp70ZqpBY0aj5gGvojADpuP2bCuFzBvFHZu9hT/pSzi3/H7aBxcV7CKpBBfjuftOTv4xKLu4LzZHvSmpqjNIamw8smwfXL17VJQLpl7ksiA99eErOrcphInQ8Yj4VB98aLqFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788158440; c=relaxed/simple;
	bh=aMPatBEyKuZVxQj6Wtugo4KjMhLU10s6ebscS1SNhRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjpEwdFu2k+AG0q/uBrS433ysPXBUQ41qiUKR7bIFevmn3IqGJiPrCOD5yh5KyC4EL1On4VhcD5jpQkJSxZmLQhJinOGZN6aJ/IS9eCanGzQjC6xF8cGukiy3MAOKd5n1dDFwOG1K6/yfg4LdF/+LS4oJT1Rp1Z6yyk3nZupch4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=347HNbmT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="347HNbmT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=x7EcafIkPvPOB24vfglqzdceXuW9mvt9Bm9EtfVYe7A=; b=347HNbmTTHv6MeSQAKOGDq2RH1
	9Bov8j7V7FXPXW6rLKGE05Qa+sDUs96b4LVAr7l39vXe8xAmWoxUlVij9kCvyOLizsYQY/57VhhIz
	4YyWBw/HlGITWAwIoKB8Qv3+/x1RqFohCRF7USJRc7Mn3huXYT702Y0vjjoG37U9PwwWw5Xk3ONpF
	BHSw/hxyZCRjtGR4DlsShk99y0OQUzxFNlICTyhwIBXRkYygCgrwVrYyW+WSHR16OByLuz/NOCgz0
	iRvbJneL6FeVrTP8On4ioqzvHmvRTRYImP8AD3i10cPXzU+B2aOwNVKA3pOZyke76/gwytlH5Zwr+
	6+t5j7Iw==;
Received: from [2001:4bb8:2f9:3a59:1608:d03f:db12:ee92] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0vh5-00000008ctv-2e0j;
	Mon, 31 Aug 2026 06:40:36 +0000
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
Subject: [PATCH 03/17] block: split bio_iov_iter_bounce_write
Date: Mon, 31 Aug 2026 09:39:51 +0300
Message-ID: <20260831064010.2574896-4-hch@lst.de>
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
index efd9483b8348..a87c33fe96ac 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1353,7 +1353,7 @@ static struct folio *folio_alloc_greedy(gfp_t gfp, size_t *size,
 	return folio_alloc(gfp, get_order(*size));
 }
 
-static void bio_free_folios(struct bio *bio)
+void bio_free_folios(struct bio *bio)
 {
 	struct bio_vec *bv;
 	int i;
@@ -1366,11 +1366,8 @@ static void bio_free_folios(struct bio *bio)
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
@@ -1380,7 +1377,6 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
 
 	do {
 		size_t this_len = min(total_len, SZ_1M);
-		size_t copied;
 		struct folio *folio;
 
 		if (this_len > minsize * 2)
@@ -1393,32 +1389,44 @@ static int bio_iov_iter_bounce_write(struct bio *bio, struct iov_iter *iter,
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
index 0070be355181..584b6abf6baf 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -527,6 +527,8 @@ extern void bio_check_pages_dirty(struct bio *bio);
 int bio_iov_iter_bounce(struct bio *bio, struct iov_iter *iter, size_t maxlen,
 		size_t minsize);
 void bio_iov_iter_unbounce(struct bio *bio, bool is_error, bool mark_dirty);
+int bio_alloc_bounce_folios(struct bio *bio, size_t total_len, size_t minsize);
+void bio_free_folios(struct bio *bio);
 
 extern void bio_copy_data(struct bio *dst, struct bio *src);
 extern void bio_free_pages(struct bio *bio);
-- 
2.53.0

