Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-io0-f196.google.com ([209.85.223.196]:41015 "EHLO
        mail-io0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754695AbeD3Pc5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 30 Apr 2018 11:32:57 -0400
Received: by mail-io0-f196.google.com with SMTP id e12-v6so10610028iob.8
        for <linux-xfs@vger.kernel.org>; Mon, 30 Apr 2018 08:32:57 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] block: add BLKDEV_DISCARD_SYNC flag
Date: Mon, 30 Apr 2018 09:32:51 -0600
Message-Id: <1525102372-8430-2-git-send-email-axboe@kernel.dk>
In-Reply-To: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
References: <1525102372-8430-1-git-send-email-axboe@kernel.dk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-block@vger.kernel.org
Cc: hch@lst.de, Jens Axboe <axboe@kernel.dk>

By default, blkdev_issue_discard() will build potentially big
bio chains, even when the discard size has been limited by the
user. Add a BLKDEV_DISCARD_SYNC flag, telling blkdev_issue_discard()
to wait for completion of each discard.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-lib.c        | 33 ++++++++++++++++++++++++---------
 include/linux/blkdev.h |  1 +
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index a676084d4740..1d0263c13c9c 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -11,13 +11,18 @@
 #include "blk.h"
 
 static struct bio *next_bio(struct bio *bio, unsigned int nr_pages,
-		gfp_t gfp)
+			    gfp_t gfp, bool do_sync)
 {
 	struct bio *new = bio_alloc(gfp, nr_pages);
 
 	if (bio) {
-		bio_chain(bio, new);
-		submit_bio(bio);
+		if (do_sync) {
+			submit_bio_wait(bio);
+			bio_put(bio);
+		} else {
+			bio_chain(bio, new);
+			submit_bio(bio);
+		}
 	}
 
 	return new;
@@ -30,7 +35,7 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	struct request_queue *q = bdev_get_queue(bdev);
 	struct bio *bio = *biop;
 	unsigned int granularity;
-	unsigned int op;
+	unsigned int op, max_sectors;
 	int alignment;
 	sector_t bs_mask;
 
@@ -58,12 +63,17 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	granularity = max(q->limits.discard_granularity >> 9, 1U);
 	alignment = (bdev_discard_alignment(bdev) >> 9) % granularity;
 
+	if (flags & BLKDEV_DISCARD_SYNC)
+		max_sectors = q->limits.max_discard_sectors;
+	else
+		max_sectors = UINT_MAX >> 9;
+
 	while (nr_sects) {
 		unsigned int req_sects;
 		sector_t end_sect, tmp;
 
 		/* Make sure bi_size doesn't overflow */
-		req_sects = min_t(sector_t, nr_sects, UINT_MAX >> 9);
+		req_sects = min_t(sector_t, nr_sects, max_sectors);
 
 		/**
 		 * If splitting a request, and the next starting sector would be
@@ -79,7 +89,7 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 			req_sects = end_sect - sector;
 		}
 
-		bio = next_bio(bio, 0, gfp_mask);
+		bio = next_bio(bio, 0, gfp_mask, flags & BLKDEV_DISCARD_SYNC);
 		bio->bi_iter.bi_sector = sector;
 		bio_set_dev(bio, bdev);
 		bio_set_op_attrs(bio, op, 0);
@@ -97,6 +107,11 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		cond_resched();
 	}
 
+	if (bio && (flags & BLKDEV_DISCARD_SYNC)) {
+		submit_bio_wait(bio);
+		bio_put(bio);
+		bio = NULL;
+	}
 	*biop = bio;
 	return 0;
 }
@@ -173,7 +188,7 @@ static int __blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 	max_write_same_sectors = UINT_MAX >> 9;
 
 	while (nr_sects) {
-		bio = next_bio(bio, 1, gfp_mask);
+		bio = next_bio(bio, 1, gfp_mask, false);
 		bio->bi_iter.bi_sector = sector;
 		bio_set_dev(bio, bdev);
 		bio->bi_vcnt = 1;
@@ -249,7 +264,7 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
 		return -EOPNOTSUPP;
 
 	while (nr_sects) {
-		bio = next_bio(bio, 0, gfp_mask);
+		bio = next_bio(bio, 0, gfp_mask, false);
 		bio->bi_iter.bi_sector = sector;
 		bio_set_dev(bio, bdev);
 		bio->bi_opf = REQ_OP_WRITE_ZEROES;
@@ -301,7 +316,7 @@ static int __blkdev_issue_zero_pages(struct block_device *bdev,
 
 	while (nr_sects != 0) {
 		bio = next_bio(bio, __blkdev_sectors_to_bio_pages(nr_sects),
-			       gfp_mask);
+			       gfp_mask, false);
 		bio->bi_iter.bi_sector = sector;
 		bio_set_dev(bio, bdev);
 		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5c4eee043191..e90388004029 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1396,6 +1396,7 @@ extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
 
 #define BLKDEV_DISCARD_SECURE	(1 << 0)	/* issue a secure erase */
+#define BLKDEV_DISCARD_SYNC	(1 << 1)
 
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
-- 
2.7.4

