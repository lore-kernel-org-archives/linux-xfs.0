Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052CE405AA0;
	Wed,  1 Apr 2026 14:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775052288; cv=none; b=YFxxScZXtO4XjvGPIlURJ1aY8lZr2TXOZhtlenxWQC8fk//CYOu91DnBvMQhyDLko7925VbErPOT29RRb6533v0BMP7NnvhivLc/BzKc7mL+WOgcBXKiweWSGvKMJhh1qQnz2tynuCrnARqVVFkKFmxR43a83f7sV5elUrBSD+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775052288; c=relaxed/simple;
	bh=AzvSU6mE8Y5eXJg1lXl7EQqAUKcFPQXL5/unNLFxZXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mRgb1q8LNzAhxH7uljANAMKqNdvo7PWEdMpexOmM/VmmNLeHJkfp6JgwYoVYx2nyz+DDvNPZrn9aJ7uwe9+tbMsU1TdD7ATDI+nBEmjL5bAG1rQVPk9VQNyWBGO2jcr5REv0wLM44WfcO1o9aMW2atPZEO0Gic3zKUj91I2q74E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=o4qYU+zV; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="o4qYU+zV"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mFzMH0GrSf+b4u3GhF8tOcz2ld7hSJIxPaNbUpToAwg=; b=o4qYU+zV+sMsR4AytTARVJxui8
	8FCa3w9VkLSiL/kdhDOx9Hi5JeKm3M+4+jDrWTt0IvO6j2KP7jZZrfikwEH3GxgpLsM4txRVt52Yd
	AsPMUWw21j0myjTyhCZaIgi2G/mb2rz+GqfuyjuW7z9t9VrovYYxdXhx9dK4b9/xvOy0d5Pk1C4DB
	nvBvRWS9S1gIJKDM0rkFOY+5+fBzOVa1lu+ph92hBoVxZ0URVqYkVwaKGv0/MMdP2Wg7z6FRS7vFw
	8IeOYMKrkzqDvpUWwQ+il7JRXtBTFc24unTW16YDpKRS5JGJV/6j5S8dSK0e5nyfOyhOIcU/0Ecp6
	zt42dx5A==;
Received: from [2a02:1210:321a:af00:3fa:89ae:5c22:a910] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w7wBa-0000000FNQx-1FUz;
	Wed, 01 Apr 2026 14:04:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Carlos Maiolino <cem@kernel.org>,
	linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: [PATCH 3/4] block: add a bio_submit_or_kill helper
Date: Wed,  1 Apr 2026 16:03:58 +0200
Message-ID: <20260401140433.125924-4-hch@lst.de>
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
index c9410804c61a..9a4fda7867ed 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1505,6 +1505,20 @@ static void bio_endio_cb(struct bio *bio, void *priv)
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
@@ -1535,15 +1549,6 @@ int bdev_rw_virt(struct block_device *bdev, sector_t sector, void *data,
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

