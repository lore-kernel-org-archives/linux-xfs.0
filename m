Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52386 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751291AbdB1X7y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 28 Feb 2017 18:59:54 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 5/8] nowait aio: return on congested block device
Date: Tue, 28 Feb 2017 17:36:07 -0600
Message-Id: <20170228233610.25456-6-rgoldwyn@suse.de>
In-Reply-To: <20170228233610.25456-1-rgoldwyn@suse.de>
References: <20170228233610.25456-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: jack@suse.com
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

A new flag BIO_NOWAIT is introduced to identify bio's
orignating from iocb with IOCB_NOWAIT. This flag indicates
to return immediately if a request cannot be made instead
of retrying.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 block/blk-core.c          | 13 +++++++++++--
 fs/direct-io.c            | 11 +++++++++--
 include/linux/blk_types.h |  1 +
 3 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 61ba08c..e5cfc50 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1258,6 +1258,11 @@ static struct request *get_request(struct request_queue *q, unsigned int op,
 	if (!IS_ERR(rq))
 		return rq;
 
+	if (bio_flagged(bio, BIO_NOWAIT)) {
+		blk_put_rl(rl);
+		return ERR_PTR(-EAGAIN);
+	}
+
 	if (!gfpflags_allow_blocking(gfp_mask) || unlikely(blk_queue_dying(q))) {
 		blk_put_rl(rl);
 		return rq;
@@ -2018,7 +2023,7 @@ blk_qc_t generic_make_request(struct bio *bio)
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 
-		if (likely(blk_queue_enter(q, false) == 0)) {
+		if (likely(blk_queue_enter(q, bio_flagged(bio, BIO_NOWAIT)) == 0)) {
 			ret = q->make_request_fn(q, bio);
 
 			blk_queue_exit(q);
@@ -2027,7 +2032,11 @@ blk_qc_t generic_make_request(struct bio *bio)
 		} else {
 			struct bio *bio_next = bio_list_pop(current->bio_list);
 
-			bio_io_error(bio);
+			if (unlikely(bio_flagged(bio, BIO_NOWAIT))) {
+				bio->bi_error = -EAGAIN;
+				bio_endio(bio);
+			} else
+				bio_io_error(bio);
 			bio = bio_next;
 		}
 	} while (bio);
diff --git a/fs/direct-io.c b/fs/direct-io.c
index c87bae4..2973df0 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -386,6 +386,9 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 	else
 		bio->bi_end_io = dio_bio_end_io;
 
+	if (dio->iocb->ki_flags & IOCB_NOWAIT)
+		bio_set_flag(bio, BIO_NOWAIT);
+
 	sdio->bio = bio;
 	sdio->logical_offset_in_bio = sdio->cur_page_fs_offset;
 }
@@ -480,8 +483,12 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 	unsigned i;
 	int err;
 
-	if (bio->bi_error)
-		dio->io_error = -EIO;
+	if (bio->bi_error) {
+		if (bio_flagged(bio, BIO_NOWAIT))
+			dio->io_error = bio->bi_error;
+		else
+			dio->io_error = -EIO;
+	}
 
 	if (dio->is_async && dio->op == REQ_OP_READ && dio->should_dirty) {
 		err = bio->bi_error;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 519ea2c..1d77e9b 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -102,6 +102,7 @@ struct bio {
 #define BIO_REFFED	8	/* bio has elevated ->bi_cnt */
 #define BIO_THROTTLED	9	/* This bio has already been subjected to
 				 * throttling rules. Don't do it again. */
+#define BIO_NOWAIT	10	/* don't block over blk device congestion */
 
 /*
  * Flags starting here get preserved by bio_reset() - this includes
-- 
2.10.2

