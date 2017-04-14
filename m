Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57935 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752590AbdDNMDR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Apr 2017 08:03:17 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 5/8] nowait aio: return on congested block device
Date: Fri, 14 Apr 2017 07:02:54 -0500
Message-Id: <20170414120257.8932-6-rgoldwyn@suse.de>
In-Reply-To: <20170414120257.8932-1-rgoldwyn@suse.de>
References: <20170414120257.8932-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org
Cc: jack@suse.com, hch@infradead.org, linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org, sagi@grimberg.me, avi@scylladb.com, axboe@kernel.dk, linux-api@vger.kernel.org, willy@infradead.org, tom.leiming@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

A new bio operation flag REQ_NOWAIT is introduced to identify bio's
orignating from iocb with IOCB_NOWAIT. This flag indicates
to return immediately if a request cannot be made instead
of retrying.

To facilitate this, QUEUE_FLAG_NOWAIT is set to devices
which support this. While currently this is set to
virtio and sd only. Support to more devices will be added soon
once I am sure they don't block. Currently blocks such as dm/md
block while performing sync.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 block/blk-core.c           | 24 ++++++++++++++++++++++--
 block/blk-mq-sched.c       |  3 +++
 block/blk-mq.c             |  4 ++++
 drivers/block/virtio_blk.c |  3 +++
 drivers/scsi/sd.c          |  3 +++
 fs/direct-io.c             | 10 ++++++++--
 include/linux/bio.h        |  6 ++++++
 include/linux/blk_types.h  |  2 ++
 include/linux/blkdev.h     |  3 +++
 9 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d772c221cc17..54698521756b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1232,6 +1232,11 @@ static struct request *get_request(struct request_queue *q, unsigned int op,
 	if (!IS_ERR(rq))
 		return rq;
 
+	if (bio && (bio->bi_opf & REQ_NOWAIT)) {
+		blk_put_rl(rl);
+		return ERR_PTR(-EAGAIN);
+	}
+
 	if (!gfpflags_allow_blocking(gfp_mask) || unlikely(blk_queue_dying(q))) {
 		blk_put_rl(rl);
 		return rq;
@@ -1870,6 +1875,18 @@ generic_make_request_checks(struct bio *bio)
 		goto end_io;
 	}
 
+	if (bio->bi_opf & REQ_NOWAIT) {
+		if (!blk_queue_nowait(q)) {
+			err = -EOPNOTSUPP;
+			goto end_io;
+		}
+		if (!(bio->bi_opf & REQ_SYNC)) {
+			err = -EINVAL;
+			goto end_io;
+		}
+	}
+
+
 	part = bio->bi_bdev->bd_part;
 	if (should_fail_request(part, bio->bi_iter.bi_size) ||
 	    should_fail_request(&part_to_disk(part)->part0,
@@ -2021,7 +2038,7 @@ blk_qc_t generic_make_request(struct bio *bio)
 	do {
 		struct request_queue *q = bdev_get_queue(bio->bi_bdev);
 
-		if (likely(blk_queue_enter(q, false) == 0)) {
+		if (likely(blk_queue_enter(q, bio->bi_opf & REQ_NOWAIT) == 0)) {
 			struct bio_list lower, same;
 
 			/* Create a fresh bio_list for all subordinate requests */
@@ -2046,7 +2063,10 @@ blk_qc_t generic_make_request(struct bio *bio)
 			bio_list_merge(&bio_list_on_stack[0], &same);
 			bio_list_merge(&bio_list_on_stack[0], &bio_list_on_stack[1]);
 		} else {
-			bio_io_error(bio);
+			if (unlikely(!blk_queue_dying(q) && (bio->bi_opf & REQ_NOWAIT)))
+				bio_wouldblock_error(bio);
+			else
+				bio_io_error(bio);
 		}
 		bio = bio_list_pop(&bio_list_on_stack[0]);
 	} while (bio);
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index c974a1bbf4cb..9f88190ff395 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -119,6 +119,9 @@ struct request *blk_mq_sched_get_request(struct request_queue *q,
 	if (likely(!data->hctx))
 		data->hctx = blk_mq_map_queue(q, data->ctx->cpu);
 
+	if (bio && (bio->bi_opf & REQ_NOWAIT))
+		data->flags |= BLK_MQ_REQ_NOWAIT;
+
 	if (e) {
 		data->flags |= BLK_MQ_REQ_INTERNAL;
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 572966f49596..8b9b1a411ce2 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1538,6 +1538,8 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	rq = blk_mq_sched_get_request(q, bio, bio->bi_opf, &data);
 	if (unlikely(!rq)) {
 		__wbt_done(q->rq_wb, wb_acct);
+		if (bio && (bio->bi_opf & REQ_NOWAIT))
+			bio_wouldblock_error(bio);
 		return BLK_QC_T_NONE;
 	}
 
@@ -1662,6 +1664,8 @@ static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
 	rq = blk_mq_sched_get_request(q, bio, bio->bi_opf, &data);
 	if (unlikely(!rq)) {
 		__wbt_done(q->rq_wb, wb_acct);
+		if (bio && (bio->bi_opf & REQ_NOWAIT))
+			bio_wouldblock_error(bio);
 		return BLK_QC_T_NONE;
 	}
 
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 1d4c9f8bc1e1..7481124c5025 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -731,6 +731,9 @@ static int virtblk_probe(struct virtio_device *vdev)
 	/* No real sector limit. */
 	blk_queue_max_hw_sectors(q, -1U);
 
+	/* Request queue supports BIO_NOWAIT */
+	queue_flag_set_unlocked(QUEUE_FLAG_NOWAIT, q);
+
 	/* Host can optionally specify maximum segment size and number of
 	 * segments. */
 	err = virtio_cread_feature(vdev, VIRTIO_BLK_F_SIZE_MAX,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index fcfeddc79331..9df85ee165be 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3177,6 +3177,9 @@ static int sd_probe(struct device *dev)
 					     SD_MOD_TIMEOUT);
 	}
 
+	/* Support BIO_NOWAIT */
+	queue_flag_set_unlocked(QUEUE_FLAG_NOWAIT, sdp->request_queue);
+
 	device_initialize(&sdkp->dev);
 	sdkp->dev.parent = dev;
 	sdkp->dev.class = &sd_disk_class;
diff --git a/fs/direct-io.c b/fs/direct-io.c
index a04ebea77de8..a802168284e1 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -480,8 +480,12 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 	unsigned i;
 	int err;
 
-	if (bio->bi_error)
-		dio->io_error = -EIO;
+	if (bio->bi_error) {
+		if (bio->bi_opf & REQ_NOWAIT)
+			dio->io_error = -EAGAIN;
+		else
+			dio->io_error = -EIO;
+	}
 
 	if (dio->is_async && dio->op == REQ_OP_READ && dio->should_dirty) {
 		err = bio->bi_error;
@@ -1197,6 +1201,8 @@ do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 	if (iov_iter_rw(iter) == WRITE) {
 		dio->op = REQ_OP_WRITE;
 		dio->op_flags = REQ_SYNC | REQ_IDLE;
+		if (iocb->ki_flags & IOCB_NOWAIT)
+			dio->op_flags |= REQ_NOWAIT;
 	} else {
 		dio->op = REQ_OP_READ;
 	}
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8e521194f6fc..1a9270744b1e 100644
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
index d703acb55d0f..5ce4da30ba43 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -187,6 +187,7 @@ enum req_flag_bits {
 	__REQ_PREFLUSH,		/* request for cache flush */
 	__REQ_RAHEAD,		/* read ahead, can fail anytime */
 	__REQ_BACKGROUND,	/* background IO */
+	__REQ_NOWAIT,		/* Don't wait if request will block */
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -203,6 +204,7 @@ enum req_flag_bits {
 #define REQ_PREFLUSH		(1ULL << __REQ_PREFLUSH)
 #define REQ_RAHEAD		(1ULL << __REQ_RAHEAD)
 #define REQ_BACKGROUND		(1ULL << __REQ_BACKGROUND)
+#define REQ_NOWAIT		(1ULL << __REQ_NOWAIT)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 7548f332121a..df0b1245d955 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -610,6 +610,8 @@ struct request_queue {
 #define QUEUE_FLAG_FLUSH_NQ    25	/* flush not queueuable */
 #define QUEUE_FLAG_DAX         26	/* device supports DAX */
 #define QUEUE_FLAG_STATS       27	/* track rq completion times */
+/* can return immediately on congestion  (for REQ_NOWAIT) */
+#define QUEUE_FLAG_NOWAIT      28
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -700,6 +702,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_secure_erase(q) \
 	(test_bit(QUEUE_FLAG_SECERASE, &(q)->queue_flags))
 #define blk_queue_dax(q)	test_bit(QUEUE_FLAG_DAX, &(q)->queue_flags)
+#define blk_queue_nowait(q)	test_bit(QUEUE_FLAG_NOWAIT, &(q)->queue_flags)
 
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
-- 
2.12.0

