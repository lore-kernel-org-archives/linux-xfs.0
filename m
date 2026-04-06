Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79559347505;
	Mon,  6 Apr 2026 05:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775455061; cv=none; b=MvSeKQ6hE8SPULEfs8NuTGO/tal1MuE1gpJXBmjfxlKEBjvas5AmfCSIeKWNTQIf0O43LdVokLEKsc1TxRP1umEqBoTzCsWwbV63OCirFRwk2C6+TBKLeRSgzb0pk+uGdUcO0PywQs1XqnRU+nUTE5hcTxCWEV2vSCz2ySxRSQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775455061; c=relaxed/simple;
	bh=l9GGs5uozNnO/D7MIQv9ilO64MCvUSDFsfILvgaP5lI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M4oERVjWBvYJVC3ksSlDC24zbBRDQcpI/DSLvAnl4lCYEobwi1JaOYI1ohWBNYkhRPq/3RfDMYzrfdSPX9q/FTiJikj9ZcMe5QJiEBiv7EK7wFQ/hMPRW57jihMDQ7zvzVZXXNIt2NimHk1+4NIy3Mfe/ZVBH8VqJCOKKQYygKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EQvnDkm+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EQvnDkm+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8iBwNL3Nontz1MeVdP9e2XLv+V11Wv67uGBs7W/aS90=; b=EQvnDkm+J54m/BEgn2W2cbWlGW
	t6kNBGmywUf4XmEyjDKzqqjrNE/y1yliaNiQhbZzjURtOkX73iN/niYXVNhC5AcBwX04P5v13APqs
	ROnVs9A4GiMij/HmrrRyPfXU+cmk9JBeYbIR20TmJU2Vk5EFKaj8jMqxAr2+28l6ngtGpGKXJrkJs
	d/atK1dA/eZostPPjnERcr725a2MQpn1FPjjll5C1pxylrUmtFiOUl8ldjcSc20IYwfMMLs0bIKSy
	LTkXymroN0hGMgYG00THIvZ+dpDiP1JPJNImfFn4bItqJrr3ZtSr53zU3hAKFeh6For9OTVl/ckc5
	k12o+dTg==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9cxv-00000004pVY-3Jhe;
	Mon, 06 Apr 2026 05:57:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] block: factor out a bio_await helper
Date: Mon,  6 Apr 2026 07:57:21 +0200
Message-ID: <20260406055728.472919-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260406055728.472919-1-hch@lst.de>
References: <20260406055728.472919-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a new helper to wait for a bio and anything chained off it to
complete synchronous after kicking it.  This factors common code out
of submit_bio_wait and bio_await_chain and will also be useful for
file system code and thus is exported.

Note that this will now set REQ_SYNC also for the bio_await case for
consistency.  Nothing should look at the flag in the end_io handler,
but if did, having the flag set makes more sense.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c         | 53 +++++++++++++++++++++++++++++++--------------
 include/linux/bio.h |  2 ++
 2 files changed, 39 insertions(+), 16 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 434e41182c05..c7e75d532666 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1468,17 +1468,20 @@ static void bio_wait_end_io(struct bio *bio)
 }
 
 /**
- * submit_bio_wait - submit a bio, and wait until it completes
- * @bio: The &struct bio which describes the I/O
+ * bio_await - call a function on a bio, and wait until it completes
+ * @bio:	the bio which describes the I/O
+ * @kick:	function called to "kick off" the bio
+ * @priv:	private data passed to @kick.
  *
- * Simple wrapper around submit_bio(). Returns 0 on success, or the error from
- * bio_endio() on failure.
+ * Wait for the bio as well as any bio chained off it after executing the
+ * passed in callback @kick.  The wait for the bio is set up before calling
+ * @kick to ensure that the completion is captured.  If @kick is %NULL,
+ * submit_bio() is used instead to submit the bio.
  *
- * WARNING: Unlike to how submit_bio() is usually used, this function does not
- * result in bio reference to be consumed. The caller must drop the reference
- * on his own.
+ * Note: this overrides the bi_private and bi_end_io fields in the bio.
  */
-int submit_bio_wait(struct bio *bio)
+void bio_await(struct bio *bio, void *priv,
+	       void (*kick)(struct bio *bio, void *priv))
 {
 	DECLARE_COMPLETION_ONSTACK_MAP(done,
 			bio->bi_bdev->bd_disk->lockdep_map);
@@ -1486,13 +1489,37 @@ int submit_bio_wait(struct bio *bio)
 	bio->bi_private = &done;
 	bio->bi_end_io = bio_wait_end_io;
 	bio->bi_opf |= REQ_SYNC;
-	submit_bio(bio);
+	if (kick)
+		kick(bio, priv);
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
index 984844d2870b..adcca9ad4eec 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -432,6 +432,8 @@ extern void bio_uninit(struct bio *);
 void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf);
 void bio_reuse(struct bio *bio, blk_opf_t opf);
 void bio_chain(struct bio *, struct bio *);
+void bio_await(struct bio *bio, void *priv,
+	       void (*kick)(struct bio *bio, void *priv));
 
 int __must_check bio_add_page(struct bio *bio, struct page *page, unsigned len,
 			      unsigned off);
-- 
2.47.3

