Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78403090D7;
	Mon,  6 Apr 2026 05:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775455065; cv=none; b=SRDDlUlOHkbYHGksibzs22LxVUeIqmv//fniNDQkx7fLGoeYQZTHyEIxouKYBnW+164YF3eSVZDYmff8QX6xPUOvOQw0cj/NzfYl/ESQmlThDJB73fgBwW3ee0O72m4YFzvRXXi7iK+MBecrHAwKiYhNLjM10FVHFGgYiQiJsHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775455065; c=relaxed/simple;
	bh=8JvZXD7HMZtGPvmol9ntzwJxW+7l7iLtUWEgxIRte0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YpAr6k875eyi/VSeV6sSDkz90Fo8TU9BH4TKYyrT3XxbmeMDyf+QmEo7+E3yRvJJe/NR0H7xCSyu4XaiYWMmMqC5T+ixYj9N4GPYDmDavzTJN6/mnCAKEj+50S7L0KozqJyzA9cBPu4V/ULQJFrM3FZNlG+cfqnKCsoig2b0FiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=g67/hr86; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="g67/hr86"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SSxVspOIKov0F0EhJyrcfJynOhHpz12TOz0iFiZGtz0=; b=g67/hr86PwFOZh6hDgmt940POa
	2tIC7EKPGYme5FC7MAPWe+P6Q4NZbv+N5xidqR5uUOSzXw8dn4Ft+wthwkceLnn5rHm7ol4q93RC9
	HtwEp4vXXPV5CD11qWXr1OFQDO4veYBbzjsddWSOsfJhEjpXVz6JKf97pvZJXGxuUlzvidkqc1xXm
	AEaxEOuacMQQrjc396hja9NfrEf2pSigST4qU/RKH6oo5KTIXvTU9vBDRLWaRrfZMjS49cLiowPz6
	2sCkQtMzhf9lS26XMN8HRU0bukcfhZCRvJE/VKQj/y4nks+UClgGroEvnG4uTFwehwBJWkTXNK0Hw
	M4lrqfXA==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w9cxz-00000004pVh-0VWt;
	Mon, 06 Apr 2026 05:57:43 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] block: add a bio_submit_or_kill helper
Date: Mon,  6 Apr 2026 07:57:22 +0200
Message-ID: <20260406055728.472919-4-hch@lst.de>
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

Factor the common logic for the ioctl helpers to either submit a bio or
end if the process is being killed.  As this is now the only user of
bio_await_chain, open code that.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c     | 23 ++++++++++++++---------
 block/blk-lib.c | 16 ++--------------
 block/blk.h     |  2 +-
 block/ioctl.c   | 11 ++---------
 4 files changed, 19 insertions(+), 33 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index c7e75d532666..994db354439f 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1520,6 +1520,20 @@ static void bio_endio_cb(struct bio *bio, void *priv)
 	bio_endio(bio);
 }
 
+/*
+ * Submit @bio synchronously, or call bio_endio on it if the current process
+ * is being killed.
+ */
+int bio_submit_or_kill(struct bio *bio, unsigned int flags)
+{
+	if ((flags & BLKDEV_ZERO_KILLABLE) && fatal_signal_pending(current)) {
+		bio_await(bio, NULL, bio_endio_cb);
+		return -EINTR;
+	}
+
+	return submit_bio_wait(bio);
+}
+
 /**
  * bdev_rw_virt - synchronously read into / write from kernel mapping
  * @bdev:	block device to access
@@ -1550,15 +1564,6 @@ int bdev_rw_virt(struct block_device *bdev, sector_t sector, void *data,
 }
 EXPORT_SYMBOL_GPL(bdev_rw_virt);
 
-/*
- * bio_await_chain - ends @bio and waits for every chained bio to complete
- */
-void bio_await_chain(struct bio *bio)
-{
-	bio_await(bio, NULL, bio_endio_cb);
-	bio_put(bio);
-}
-
 void __bio_advance(struct bio *bio, unsigned bytes)
 {
 	if (bio_integrity(bio))
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 3213afc7f0d5..688bc67cbf73 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -155,13 +155,7 @@ static int blkdev_issue_write_zeroes(struct block_device *bdev, sector_t sector,
 	__blkdev_issue_write_zeroes(bdev, sector, nr_sects, gfp, &bio,
 			flags, limit);
 	if (bio) {
-		if ((flags & BLKDEV_ZERO_KILLABLE) &&
-		    fatal_signal_pending(current)) {
-			bio_await_chain(bio);
-			blk_finish_plug(&plug);
-			return -EINTR;
-		}
-		ret = submit_bio_wait(bio);
+		ret = bio_submit_or_kill(bio, flags);
 		bio_put(bio);
 	}
 	blk_finish_plug(&plug);
@@ -236,13 +230,7 @@ static int blkdev_issue_zero_pages(struct block_device *bdev, sector_t sector,
 	blk_start_plug(&plug);
 	__blkdev_issue_zero_pages(bdev, sector, nr_sects, gfp, &bio, flags);
 	if (bio) {
-		if ((flags & BLKDEV_ZERO_KILLABLE) &&
-		    fatal_signal_pending(current)) {
-			bio_await_chain(bio);
-			blk_finish_plug(&plug);
-			return -EINTR;
-		}
-		ret = submit_bio_wait(bio);
+		ret = bio_submit_or_kill(bio, flags);
 		bio_put(bio);
 	}
 	blk_finish_plug(&plug);
diff --git a/block/blk.h b/block/blk.h
index 103cb1d0b9cb..ec4674cdf2ea 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -55,7 +55,7 @@ bool __blk_freeze_queue_start(struct request_queue *q,
 			      struct task_struct *owner);
 int __bio_queue_enter(struct request_queue *q, struct bio *bio);
 void submit_bio_noacct_nocheck(struct bio *bio, bool split);
-void bio_await_chain(struct bio *bio);
+int bio_submit_or_kill(struct bio *bio, unsigned int flags);
 
 static inline bool blk_try_enter_queue(struct request_queue *q, bool pm)
 {
diff --git a/block/ioctl.c b/block/ioctl.c
index 0b04661ac809..fc3be0549aa7 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -153,13 +153,7 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
 	nr_sects = len >> SECTOR_SHIFT;
 
 	blk_start_plug(&plug);
-	while (1) {
-		if (fatal_signal_pending(current)) {
-			if (prev)
-				bio_await_chain(prev);
-			err = -EINTR;
-			goto out_unplug;
-		}
+	while (!fatal_signal_pending(current)) {
 		bio = blk_alloc_discard_bio(bdev, &sector, &nr_sects,
 				GFP_KERNEL);
 		if (!bio)
@@ -167,12 +161,11 @@ static int blk_ioctl_discard(struct block_device *bdev, blk_mode_t mode,
 		prev = bio_chain_and_submit(prev, bio);
 	}
 	if (prev) {
-		err = submit_bio_wait(prev);
+		err = bio_submit_or_kill(prev, BLKDEV_ZERO_KILLABLE);
 		if (err == -EOPNOTSUPP)
 			err = 0;
 		bio_put(prev);
 	}
-out_unplug:
 	blk_finish_plug(&plug);
 fail:
 	filemap_invalidate_unlock(bdev->bd_mapping);
-- 
2.47.3

