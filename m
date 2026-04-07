Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72D63B8BD9;
	Tue,  7 Apr 2026 14:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775570758; cv=none; b=WL6Xu4JIqgto0oEB1gczVghowKdtoVQ+gIUQTH0truiPiGzFC3INctVopx9RyKBodGHR2ya+EEHPSALqj6+CXIOwr20NUDsA3SwE2tWSWm2UTvA6HVcNTSjgHjz+JTPpMLihRz7nHCCIfzoZ7wpDTSCfxSVgW7r3341Hmc5aFlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775570758; c=relaxed/simple;
	bh=6hFHCh9X0AJ66Uw7e3ZKMIm2CErL1hWGIOG4naQ3k3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDp/k8NDXJmTEeUSc5P9+efhL8hHvkwTBFybPn4HgoJnAlh5MtgH8iyVg5eJmcu0jIhBygCYUWgfRjTJLfrm5HiEFHTkbPslmXb6lh94H2afZfZc/ZjifMEcrIrujfdNsUb+58MzODx5t9XUa2Z4y22SEeXqTHg/Fu3qQCaqflg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Fsme/I1z; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fsme/I1z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Gw9usk+F1GQAte9rxiRiChyPVZXrpJZa7XBAVxnd/v0=; b=Fsme/I1zLzdqL37tXAM2Sbg39+
	+DUTWzz7KWEBcskqiF0laibLKAChIw316lWQidc+KJP0wynFlhLxCeOK72eqPhOX8s1Pgij9kWtku
	Z4lREQj+ObpvjDUwyJwLSEsKjEm+EYu2/nFtao+DotEwn1Y1FywD1ndhSAYNkzPX20X7Rj5dEmhX0
	Qw5IWT6ATi7dx7kPD9+IECfABXfxr9AtvoC17ZLNc9clyhcqcKMdxUbqdkflLHc7d7Ko8EluYb3wt
	xFyjfQhZTIcJDdDg8B2A5ih0mW0mbzmeNk03tpPJNAg2s+LYWQXBS+yFXnEcW1BATkfZhgPaLwrTY
	alzfwtig==;
Received: from 2a02-8389-2341-5b80-d601-7564-c2e0-491c.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d601:7564:c2e0:491c] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wA740-00000006Ytx-3Nff;
	Tue, 07 Apr 2026 14:05:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/5] block: factor out a bio_await helper
Date: Tue,  7 Apr 2026 16:05:26 +0200
Message-ID: <20260407140538.633364-4-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407140538.633364-1-hch@lst.de>
References: <20260407140538.633364-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a new helper to wait for a bio and anything chained off it to
complete synchronously after submitting it.  This factors common code out
of submit_bio_wait and bio_await_chain and will also be useful for
file system code and thus is exported.

Note that this will now set REQ_SYNC also for the bio_await case for
consistency.  Nothing should look at the flag in the end_io handler,
but if something does having the flag set makes more sense.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/bio.c         | 53 +++++++++++++++++++++++++++++++--------------
 include/linux/bio.h |  2 ++
 2 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 434e41182c05..61d65c544bcc 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1468,17 +1468,20 @@ static void bio_wait_end_io(struct bio *bio)
 }
 
 /**
- * submit_bio_wait - submit a bio, and wait until it completes
- * @bio: The &struct bio which describes the I/O
+ * bio_await - call a function on a bio, and wait until it completes
+ * @bio:	the bio which describes the I/O
+ * @submit:	function called to submit the bio
+ * @priv:	private data passed to @submit
  *
- * Simple wrapper around submit_bio(). Returns 0 on success, or the error from
- * bio_endio() on failure.
+ * Wait for the bio as well as any bio chained off it after executing the
+ * passed in callback @submit.  The wait for the bio is set up before calling
+ * @submit to ensure that the completion is captured.  If @submit is %NULL,
+ * submit_bio() is used instead to submit the bio.
  *
- * WARNING: Unlike to how submit_bio() is usually used, this function does not
- * result in bio reference to be consumed. The caller must drop the reference
- * on his own.
+ * Note: this overrides the bi_private and bi_end_io fields in the bio.
  */
-int submit_bio_wait(struct bio *bio)
+void bio_await(struct bio *bio, void *priv,
+	       void (*submit)(struct bio *bio, void *priv))
 {
 	DECLARE_COMPLETION_ONSTACK_MAP(done,
 			bio->bi_bdev->bd_disk->lockdep_map);
@@ -1486,13 +1489,37 @@ int submit_bio_wait(struct bio *bio)
 	bio->bi_private = &done;
 	bio->bi_end_io = bio_wait_end_io;
 	bio->bi_opf |= REQ_SYNC;
-	submit_bio(bio);
+	if (submit)
+		submit(bio, priv);
+	else
+		submit_bio(bio);
 	blk_wait_io(&done);
+}
+EXPORT_SYMBOL_GPL(bio_await);
 
+/**
+ * submit_bio_wait - submit a bio, and wait until it completes
+ * @bio: The &struct bio which describes the I/O
+ *
+ * Simple wrapper around submit_bio(). Returns 0 on success, or the error from
+ * bio_endio() on failure.
+ *
+ * WARNING: Unlike to how submit_bio() is usually used, this function does not
+ * result in bio reference to be consumed. The caller must drop the reference
+ * on his own.
+ */
+int submit_bio_wait(struct bio *bio)
+{
+	bio_await(bio, NULL, NULL);
 	return blk_status_to_errno(bio->bi_status);
 }
 EXPORT_SYMBOL(submit_bio_wait);
 
+static void bio_endio_cb(struct bio *bio, void *priv)
+{
+	bio_endio(bio);
+}
+
 /**
  * bdev_rw_virt - synchronously read into / write from kernel mapping
  * @bdev:	block device to access
@@ -1528,13 +1555,7 @@ EXPORT_SYMBOL_GPL(bdev_rw_virt);
  */
 void bio_await_chain(struct bio *bio)
 {
-	DECLARE_COMPLETION_ONSTACK_MAP(done,
-			bio->bi_bdev->bd_disk->lockdep_map);
-
-	bio->bi_private = &done;
-	bio->bi_end_io = bio_wait_end_io;
-	bio_endio(bio);
-	blk_wait_io(&done);
+	bio_await(bio, NULL, bio_endio_cb);
 	bio_put(bio);
 }
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 984844d2870b..97d747320b35 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -432,6 +432,8 @@ extern void bio_uninit(struct bio *);
 void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf);
 void bio_reuse(struct bio *bio, blk_opf_t opf);
 void bio_chain(struct bio *, struct bio *);
+void bio_await(struct bio *bio, void *priv,
+	       void (*submit)(struct bio *bio, void *priv));
 
 int __must_check bio_add_page(struct bio *bio, struct page *page, unsigned len,
 			      unsigned off);
-- 
2.47.3

