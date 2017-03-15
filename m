Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53433 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754206AbdCOVvp (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Mar 2017 17:51:45 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 5/8] nowait aio: return on congested block device
Date: Wed, 15 Mar 2017 16:51:04 -0500
Message-Id: <20170315215107.5628-6-rgoldwyn@suse.de>
In-Reply-To: <20170315215107.5628-1-rgoldwyn@suse.de>
References: <20170315215107.5628-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

A new flag BIO_NOWAIT is introduced to identify bio's
orignating from iocb with IOCB_NOWAIT. This flag indicates
to return immediately if a request cannot be made instead
of retrying.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 block/blk-core.c          | 12 ++++++++++--
 block/blk-mq-sched.c      |  3 +++
 block/blk-mq.c            |  4 ++++
 fs/direct-io.c            | 11 +++++++++--
 include/linux/bio.h       |  6 ++++++
 include/linux/blk_types.h |  1 +
 6 files changed, 33 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 0eeb99e..2e5cba2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1232,6 +1232,11 @@ static struct request *get_request(struct request_queue *q, unsigned int op,
 	if (!IS_ERR(rq))
 		return rq;
 
+	if (bio && bio_flagged(bio, BIO_NOWAIT)) {
+		blk_put_rl(rl);
+		return ERR_PTR(-EAGAIN);
+	}
+
 	if (!gfpflags_allow_blocking(gfp_mask) || unlikely(blk_queue_dying(q))) {
 		blk_put_rl(rl);
 		return rq;
@@ -2014,7 +2019,7 @@ blk_qc_t generic_make_request(struct bio *bio)
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 
-		if (likely(blk_queue_enter(q, false) == 0)) {
+		if (likely(blk_queue_enter(q, bio_flagged(bio, BIO_NOWAIT)) == 0)) {
 			struct bio_list hold;
 			struct bio_list lower, same;
 
@@ -2040,7 +2045,10 @@ blk_qc_t generic_make_request(struct bio *bio)
 			bio_list_merge(&bio_list_on_stack, &same);
 			bio_list_merge(&bio_list_on_stack, &hold);
 		} else {
-			bio_io_error(bio);
+			if (unlikely(bio_flagged(bio, BIO_NOWAIT)))
+				bio_wouldblock_error(bio);
+			else
+				bio_io_error(bio);
 		}
 		bio = bio_list_pop(current->bio_list);
 	} while (bio);
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 09af8ff..40e78b5 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -119,6 +119,9 @@ struct request *blk_mq_sched_get_request(struct request_queue *q,
 	if (likely(!data->hctx))
 		data->hctx = blk_mq_map_queue(q, data->ctx->cpu);
 
+	if (likely(bio) && bio_flagged(bio, BIO_NOWAIT))
+		data->flags |= BLK_MQ_REQ_NOWAIT;
+
 	if (e) {
 		data->flags |= BLK_MQ_REQ_INTERNAL;
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 159187a..942ce8c 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1518,6 +1518,8 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	rq = blk_mq_sched_get_request(q, bio, bio->bi_opf, &data);
 	if (unlikely(!rq)) {
 		__wbt_done(q->rq_wb, wb_acct);
+		if (bio && bio_flagged(bio, BIO_NOWAIT))
+			bio_wouldblock_error(bio);
 		return BLK_QC_T_NONE;
 	}
 
@@ -1642,6 +1644,8 @@ static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
 	rq = blk_mq_sched_get_request(q, bio, bio->bi_opf, &data);
 	if (unlikely(!rq)) {
 		__wbt_done(q->rq_wb, wb_acct);
+		if (bio && bio_flagged(bio, BIO_NOWAIT))
+			bio_wouldblock_error(bio);
 		return BLK_QC_T_NONE;
 	}
 
diff --git a/fs/direct-io.c b/fs/direct-io.c
index a04ebea..f6835d3 100644
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
+			dio->io_error = -EAGAIN;
+		else
+			dio->io_error = -EIO;
+	}
 
 	if (dio->is_async && dio->op == REQ_OP_READ && dio->should_dirty) {
 		err = bio->bi_error;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8e52119..1a92707 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -425,6 +425,12 @@ static inline void bio_io_error(struct bio *bio)
 	bio_endio(bio);
 }
 
+static inline void bio_wouldblock_error(struct bio *bio)
+{
+	bio->bi_error = -EAGAIN;
+	bio_endio(bio);
+}
+
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index d703acb..514c08e 100644
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

