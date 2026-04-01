Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5406B2DA765;
	Wed,  1 Apr 2026 14:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775052285; cv=none; b=Az/v3EEWbHDJad+WDVrvgdHk5ePlZhZpVIiESwNDD+XPTJEqiF0A4630lnCbUcy/qg455GAZwKTAKBI7YWdYnIKHNlnQXFY/pFACtafG73KkjeisCg+otEbEO3HkKtINiDJ4TivxOWXnF8tQwN+EeoQfllycHZMk7/YHnHffIkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775052285; c=relaxed/simple;
	bh=nBictF88AaO0+yDZh6XlO2i5nxhNTyCQqvkhNILa1cU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8HRHpUZeumRgTBRVviAfcFKlE+oWksTV9kBLg/XqeS6AHsTFR40ICCf14i9wzmjkKJqFGTMs6ESaOKcOEjY+HkRn8noiiINoLzxgB6vf6lpTyqCEGZLJyLmCtf3bo7HyWnt5BBDqopVTotyDsvSmD4/Y2KzMKGznRquAyxe/kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=LXXUtuPO; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LXXUtuPO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vvFnCsjyaIh/RegMfBgrGzk7vtuxaBfJHejx6dNchvA=; b=LXXUtuPOr+/fEcfgF1OTGLSzGW
	xEDqpknEbT6EGC4NDXfN7Gg2MVhW3aUV5c/fq0BlHl8/DQxSW+omDPwGj+1hftGOM/avDL7DU3e1v
	KI1DLw2vLjiWJVrNM35p+2z7QhoN1dn48A3JrJeKSyAGEDRTIk7psHk2tu54ltlzfEV4JX1xBjTLd
	LaQIdc/dyInLcqRZ/wRxaX1i0QHv4l3uNSqi9fEqedcYI6mq7vEdzuGma8MxBLIqgHYYlAQAlQlDA
	68WNNQwqYlSQ6jmIuW/g6pE/TCa3o4SpMHx6iCktoUZKGLATNlLuyUTf9ov9LwUfc07XSiTkGN5Ok
	9v91qv3Q==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7wBW-0000000FNQL-0CQn;
	Wed, 01 Apr 2026 14:04:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 2/4] block: factor out a bio_await helper
Date: Wed,  1 Apr 2026 16:03:57 +0200
Message-ID: <20260401140433.125924-3-hch@lst.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260401140433.125924-1-hch@lst.de>
References: <20260401140433.125924-1-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c         | 52 +++++++++++++++++++++++++++++++--------------
 include/linux/bio.h |  2 ++
 2 files changed, 38 insertions(+), 16 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index f5a058531cd9..c9410804c61a 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1453,6 +1453,35 @@ static void bio_wait_end_io(struct bio *bio)
 	complete(bio->bi_private);
 }
 
+/**
+ * bio_await - call a function on a bio, and wait until it completes
+ * @bio:	the bio which describes the I/O
+ * @kick:	function called to "kick off" the bio
+ * @priv:	private data passed to @kick.
+ *
+ * Wait for the bio as well as any bio chained off it after executing the
+ * passed in callback @kick.  The wait for the bio is set up before calling
+ * @kick to ensure that the completion is captured.  If @kick is %NULL,
+ * submit_bio() is used instead to submit the bio.
+ *
+ * Note: this overrides the bi_private and bi_end_io fields in the bio.
+ */
+void bio_await(struct bio *bio, void *priv,
+	       void (*kick)(struct bio *bio, void *priv))
+{
+	DECLARE_COMPLETION_ONSTACK_MAP(done,
+			bio->bi_bdev->bd_disk->lockdep_map);
+
+	bio->bi_private = &done;
+	bio->bi_end_io = bio_wait_end_io;
+	if (kick)
+		kick(bio, priv);
+	else
+		submit_bio(bio);
+	blk_wait_io(&done);
+}
+EXPORT_SYMBOL_GPL(bio_await);
+
 /**
  * submit_bio_wait - submit a bio, and wait until it completes
  * @bio: The &struct bio which describes the I/O
@@ -1466,19 +1495,16 @@ static void bio_wait_end_io(struct bio *bio)
  */
 int submit_bio_wait(struct bio *bio)
 {
-	DECLARE_COMPLETION_ONSTACK_MAP(done,
-			bio->bi_bdev->bd_disk->lockdep_map);
-
-	bio->bi_private = &done;
-	bio->bi_end_io = bio_wait_end_io;
-	bio->bi_opf |= REQ_SYNC;
-	submit_bio(bio);
-	blk_wait_io(&done);
-
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
@@ -1514,13 +1540,7 @@ EXPORT_SYMBOL_GPL(bdev_rw_virt);
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

