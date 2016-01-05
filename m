Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C421029E0A
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 14:55:26 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 8A5AC8F804C
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 12:55:26 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TfM7BkvmV4btF6iS (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2016 12:55:23 -0800 (PST)
From: mchristi@redhat.com
Subject: [PATCH 35/35] block, drivers, fs: rename REQ_FLUSH to REQ_PREFLUSH
Date: Tue,  5 Jan 2016 14:53:38 -0600
Message-Id: <1452027218-32303-36-git-send-email-mchristi@redhat.com>
In-Reply-To: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
References: <1452027218-32303-1-git-send-email-mchristi@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org, konrad.wilk@oracle.com, drbd-dev@lists.linbit.com, philipp.reisner@linbit.com, lars.ellenberg@linbit.com, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org, target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org, osd-dev@open-osd.org, xfs@oss.sgi.com, ocfs2-devel@oss.oracle.com
Cc: Mike Christie <mchristi@redhat.com>

From: Mike Christie <mchristi@redhat.com>

To avoid confusion between REQ_OP_FLUSH, which is handled by
request_fn drivers, and upper layers requesting the block layer
perform a flush sequence along with possibly a WRITE, this patch
renames REQ_FLUSH to REQ_PREFLUSH.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 Documentation/block/writeback_cache_control.txt | 31 +++++++++++++------------
 block/blk-core.c                                | 12 +++++-----
 block/blk-flush.c                               |  4 ++--
 block/blk-mq.c                                  |  4 ++--
 drivers/block/drbd/drbd_actlog.c                |  2 +-
 drivers/block/drbd/drbd_main.c                  |  2 +-
 drivers/block/drbd/drbd_receiver.c              |  2 +-
 drivers/block/drbd/drbd_req.c                   |  2 +-
 drivers/md/bcache/journal.c                     |  2 +-
 drivers/md/bcache/request.c                     |  8 +++----
 drivers/md/dm-cache-target.c                    |  9 +++----
 drivers/md/dm-crypt.c                           |  7 +++---
 drivers/md/dm-era-target.c                      |  4 ++--
 drivers/md/dm-io.c                              |  2 +-
 drivers/md/dm-log-writes.c                      |  2 +-
 drivers/md/dm-raid1.c                           |  5 ++--
 drivers/md/dm-region-hash.c                     |  4 ++--
 drivers/md/dm-snap.c                            |  6 ++---
 drivers/md/dm-stripe.c                          |  2 +-
 drivers/md/dm-thin.c                            |  8 +++----
 drivers/md/dm.c                                 | 12 +++++-----
 drivers/md/linear.c                             |  2 +-
 drivers/md/md.c                                 |  2 +-
 drivers/md/multipath.c                          |  2 +-
 drivers/md/raid0.c                              |  2 +-
 drivers/md/raid1.c                              |  3 ++-
 drivers/md/raid10.c                             |  2 +-
 drivers/md/raid5-cache.c                        |  2 +-
 drivers/md/raid5.c                              |  2 +-
 fs/btrfs/check-integrity.c                      |  8 +++----
 fs/jbd2/journal.c                               |  2 +-
 fs/xfs/xfs_buf.c                                |  2 +-
 include/linux/blk_types.h                       |  8 +++----
 include/linux/fs.h                              |  4 ++--
 include/trace/events/f2fs.h                     |  2 +-
 kernel/trace/blktrace.c                         |  5 ++--
 36 files changed, 92 insertions(+), 86 deletions(-)

diff --git a/Documentation/block/writeback_cache_control.txt b/Documentation/block/writeback_cache_control.txt
index ea5550f..9869f18 100644
--- a/Documentation/block/writeback_cache_control.txt
+++ b/Documentation/block/writeback_cache_control.txt
@@ -20,11 +20,11 @@ a forced cache flush, and the Force Unit Access (FUA) flag for requests.
 Explicit cache flushes
 ----------------------
 
-The REQ_FLUSH flag can be OR ed into the r/w flags of a bio submitted from
+The REQ_PREFLUSH flag can be OR ed into the r/w flags of a bio submitted from
 the filesystem and will make sure the volatile cache of the storage device
 has been flushed before the actual I/O operation is started.  This explicitly
 guarantees that previously completed write requests are on non-volatile
-storage before the flagged bio starts. In addition the REQ_FLUSH flag can be
+storage before the flagged bio starts. In addition the REQ_PREFLUSH flag can be
 set on an otherwise empty bio structure, which causes only an explicit cache
 flush without any dependent I/O.  It is recommend to use
 the blkdev_issue_flush() helper for a pure cache flush.
@@ -41,21 +41,21 @@ signaled after the data has been committed to non-volatile storage.
 Implementation details for filesystems
 --------------------------------------
 
-Filesystems can simply set the REQ_FLUSH and REQ_FUA bits and do not have to
+Filesystems can simply set the REQ_PREFLUSH and REQ_FUA bits and do not have to
 worry if the underlying devices need any explicit cache flushing and how
-the Forced Unit Access is implemented.  The REQ_FLUSH and REQ_FUA flags
+the Forced Unit Access is implemented.  The REQ_PREFLUSH and REQ_FUA flags
 may both be set on a single bio.
 
 
 Implementation details for make_request_fn based block drivers
 --------------------------------------------------------------
 
-These drivers will always see the REQ_FLUSH and REQ_FUA bits as they sit
+These drivers will always see the REQ_PREFLUSH and REQ_FUA bits as they sit
 directly below the submit_bio interface.  For remapping drivers the REQ_FUA
 bits need to be propagated to underlying devices, and a global flush needs
-to be implemented for bios with the REQ_FLUSH bit set.  For real device
-drivers that do not have a volatile cache the REQ_FLUSH and REQ_FUA bits
-on non-empty bios can simply be ignored, and REQ_FLUSH requests without
+to be implemented for bios with the REQ_PREFLUSH bit set.  For real device
+drivers that do not have a volatile cache the REQ_PREFLUSH and REQ_FUA bits
+on non-empty bios can simply be ignored, and REQ_PREFLUSH requests without
 data can be completed successfully without doing any work.  Drivers for
 devices with volatile caches need to implement the support for these
 flags themselves without any help from the block layer.
@@ -65,21 +65,22 @@ Implementation details for request_fn based block drivers
 --------------------------------------------------------------
 
 For devices that do not support volatile write caches there is no driver
-support required, the block layer completes empty REQ_FLUSH requests before
-entering the driver and strips off the REQ_FLUSH and REQ_FUA bits from
-requests that have a payload.  For devices with volatile write caches the
-driver needs to tell the block layer that it supports flushing caches by
+support required, the block layer completes empty REQ_PREFLUSH requests
+before entering the driver and strips off the REQ_PREFLUSH and REQ_FUA bits
+from requests that have a payload.  For devices with volatile write caches
+the driver needs to tell the block layer that it supports flushing caches by
 doing:
 
-	blk_queue_flush(sdkp->disk->queue, REQ_FLUSH);
+	queue_flag_set_unlocked(QUEUE_FLAG_FLUSH, sdkp->disk->queue);
 
 and handle empty REQ_OP_FLUSH requests in its prep_fn/request_fn.  Note that
-REQ_FLUSH requests with a payload are automatically turned into a sequence
+REQ_PREFLUSH requests with a payload are automatically turned into a sequence
 of an empty REQ_OP_FLUSH request followed by the actual write by the block
 layer.  For devices that also support the FUA bit the block layer needs
 to be told to pass through the REQ_FUA bit using:
 
-	blk_queue_flush(sdkp->disk->queue, REQ_FLUSH | REQ_FUA);
+	queue_flag_set_unlocked(QUEUE_FLAG_FLUSH, sdkp->disk->queue);
+	queue_flag_set_unlocked(QUEUE_FLAG_FUA, sdkp->disk->queue);
 
 and the driver must handle write requests that have the REQ_FUA bit set
 in prep_fn/request_fn.  If the FUA bit is not natively supported the block
diff --git a/block/blk-core.c b/block/blk-core.c
index bb29230..dbc9082 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1029,7 +1029,7 @@ static bool blk_rq_should_init_elevator(struct bio *bio)
 	 * Flush requests do not use the elevator so skip initialization.
 	 * This allows a request to share the flush and elevator data.
 	 */
-	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA))
+	if (bio->bi_rw & (REQ_PREFLUSH | REQ_FUA))
 		return false;
 
 	return true;
@@ -1737,7 +1737,7 @@ static blk_qc_t blk_queue_bio(struct request_queue *q, struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
-	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
+	if (bio->bi_rw & (REQ_PREFLUSH | REQ_FUA)) {
 		spin_lock_irq(q->queue_lock);
 		where = ELEVATOR_INSERT_FLUSH;
 		goto get_rq;
@@ -1969,9 +1969,9 @@ generic_make_request_checks(struct bio *bio)
 	 * drivers without flush support don't have to worry
 	 * about them.
 	 */
-	if ((bio->bi_rw & (REQ_FLUSH | REQ_FUA)) &&
+	if ((bio->bi_rw & (REQ_PREFLUSH | REQ_FUA)) &&
 	    !(blk_queue_flush(q) || blk_queue_fua(q))) {
-		bio->bi_rw &= ~(REQ_FLUSH | REQ_FUA);
+		bio->bi_rw &= ~(REQ_PREFLUSH | REQ_FUA);
 		if (!nr_sectors) {
 			err = 0;
 			goto end_io;
@@ -2218,7 +2218,7 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 	 */
 	BUG_ON(blk_queued_rq(rq));
 
-	if (rq->cmd_flags & (REQ_FLUSH|REQ_FUA))
+	if (rq->cmd_flags & (REQ_PREFLUSH | REQ_FUA))
 		where = ELEVATOR_INSERT_FLUSH;
 
 	add_acct_request(q, rq, where);
@@ -3310,7 +3310,7 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 		/*
 		 * rq is already accounted, so use raw insert
 		 */
-		if (rq->cmd_flags & (REQ_FLUSH | REQ_FUA))
+		if (rq->cmd_flags & (REQ_PREFLUSH | REQ_FUA))
 			__elv_add_request(q, rq, ELEVATOR_INSERT_FLUSH);
 		else
 			__elv_add_request(q, rq, ELEVATOR_INSERT_SORT_MERGE);
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 633f9b3..9cf387c 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -104,7 +104,7 @@ static unsigned int blk_flush_policy(struct request *rq)
 		policy |= REQ_FSEQ_DATA;
 
 	if (blk_queue_flush(q)) {
-		if (rq->cmd_flags & REQ_FLUSH)
+		if (rq->cmd_flags & REQ_PREFLUSH)
 			policy |= REQ_FSEQ_PREFLUSH;
 		if (!blk_queue_fua(q) && (rq->cmd_flags & REQ_FUA))
 			policy |= REQ_FSEQ_POSTFLUSH;
@@ -393,7 +393,7 @@ void blk_insert_flush(struct request *rq)
 	 * @policy now records what operations need to be done.  Adjust
 	 * REQ_FLUSH and FUA for the driver.
 	 */
-	rq->cmd_flags &= ~REQ_FLUSH;
+	rq->cmd_flags &= ~REQ_PREFLUSH;
 	if (!blk_queue_fua(q))
 		rq->cmd_flags &= ~REQ_FUA;
 
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 72a028b..bb376a8 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1244,7 +1244,7 @@ static int blk_mq_direct_issue_request(struct request *rq, blk_qc_t *cookie)
 static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 {
 	const int is_sync = rw_is_sync(bio->bi_op, bio->bi_rw);
-	const int is_flush_fua = bio->bi_rw & (REQ_FLUSH | REQ_FUA);
+	const int is_flush_fua = bio->bi_rw & (REQ_PREFLUSH | REQ_FUA);
 	struct blk_map_ctx data;
 	struct request *rq;
 	unsigned int request_count = 0;
@@ -1341,7 +1341,7 @@ done:
 static blk_qc_t blk_sq_make_request(struct request_queue *q, struct bio *bio)
 {
 	const int is_sync = rw_is_sync(bio->bi_op, bio->bi_rw);
-	const int is_flush_fua = bio->bi_rw & (REQ_FLUSH | REQ_FUA);
+	const int is_flush_fua = bio->bi_rw & (REQ_PREFLUSH | REQ_FUA);
 	struct blk_plug *plug;
 	unsigned int request_count = 0;
 	struct blk_map_ctx data;
diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 2fa8534..9f5e00b 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -148,7 +148,7 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 	device->md_io.error = -ENODEV;
 
 	if ((op == REQ_OP_WRITE) && !test_bit(MD_NO_FUA, &device->flags))
-		op_flags |= REQ_FUA | REQ_FLUSH;
+		op_flags |= REQ_FUA | REQ_PREFLUSH;
 	op_flags |= REQ_SYNC | REQ_NOIDLE;
 
 	bio = bio_alloc_drbd(GFP_NOIO);
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 7bc78ab..88543d1 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -1608,7 +1608,7 @@ static u32 bio_flags_to_wire(struct drbd_connection *connection, struct bio *bio
 	if (connection->agreed_pro_version >= 95)
 		return  (bio->bi_rw & REQ_SYNC ? DP_RW_SYNC : 0) |
 			(bio->bi_rw & REQ_FUA ? DP_FUA : 0) |
-			(bio->bi_rw & REQ_FLUSH ? DP_FLUSH : 0) |
+			(bio->bi_rw & REQ_PREFLUSH ? DP_FLUSH : 0) |
 			(bio->bi_op == REQ_OP_DISCARD ? DP_DISCARD : 0);
 	else
 		return bio->bi_rw & REQ_SYNC ? DP_RW_SYNC : 0;
diff --git a/drivers/block/drbd/drbd_receiver.c b/drivers/block/drbd/drbd_receiver.c
index 880de0d..752948f 100644
--- a/drivers/block/drbd/drbd_receiver.c
+++ b/drivers/block/drbd/drbd_receiver.c
@@ -2159,7 +2159,7 @@ static unsigned long wire_flags_to_bio_flags(u32 dpf)
 {
 	return  (dpf & DP_RW_SYNC ? REQ_SYNC : 0) |
 		(dpf & DP_FUA ? REQ_FUA : 0) |
-		(dpf & DP_FLUSH ? REQ_FLUSH : 0);
+		(dpf & DP_FLUSH ? REQ_PREFLUSH : 0);
 }
 
 static unsigned long wire_flags_to_bio_op(u32 dpf)
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 2255dcf..eef6e95 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -1132,7 +1132,7 @@ static int drbd_process_write_request(struct drbd_request *req)
 	 * replicating, in which case there is no point. */
 	if (unlikely(req->i.size == 0)) {
 		/* The only size==0 bios we expect are empty flushes. */
-		D_ASSERT(device, req->master_bio->bi_rw & REQ_FLUSH);
+		D_ASSERT(device, req->master_bio->bi_rw & REQ_PREFLUSH);
 		if (remote)
 			_req_mod(req, QUEUE_AS_DRBD_BARRIER);
 		return remote;
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 68fa0f0..6e0a330 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -627,7 +627,7 @@ static void journal_write_unlocked(struct closure *cl)
 		bio->bi_iter.bi_sector	= PTR_OFFSET(k, i);
 		bio->bi_bdev	= ca->bdev;
 		bio->bi_op	= REQ_OP_WRITE;
-		bio->bi_rw	= REQ_SYNC|REQ_META|REQ_FLUSH|REQ_FUA;
+		bio->bi_rw	= REQ_SYNC|REQ_META|REQ_PREFLUSH|REQ_FUA;
 		bio->bi_iter.bi_size = sectors << 9;
 
 		bio->bi_end_io	= journal_write_endio;
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index be8cd63f..3947114 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -205,10 +205,10 @@ static void bch_data_insert_start(struct closure *cl)
 		return bch_data_invalidate(cl);
 
 	/*
-	 * Journal writes are marked REQ_FLUSH; if the original write was a
+	 * Journal writes are marked REQ_PREFLUSH; if the original write was a
 	 * flush, it'll wait on the journal write.
 	 */
-	bio->bi_rw &= ~(REQ_FLUSH|REQ_FUA);
+	bio->bi_rw &= ~(REQ_PREFLUSH|REQ_FUA);
 
 	do {
 		unsigned i;
@@ -668,7 +668,7 @@ static inline struct search *search_alloc(struct bio *bio,
 	s->iop.write_prio	= 0;
 	s->iop.error		= 0;
 	s->iop.flags		= 0;
-	s->iop.flush_journal	= (bio->bi_rw & (REQ_FLUSH|REQ_FUA)) != 0;
+	s->iop.flush_journal	= (bio->bi_rw & (REQ_PREFLUSH|REQ_FUA)) != 0;
 	s->iop.wq		= bcache_wq;
 
 	return s;
@@ -920,7 +920,7 @@ static void cached_dev_write(struct cached_dev *dc, struct search *s)
 		bch_writeback_add(dc);
 		s->iop.bio = bio;
 
-		if (bio->bi_rw & REQ_FLUSH) {
+		if (bio->bi_rw & REQ_PREFLUSH) {
 			/* Also need to send a flush to the backing device */
 			struct bio *flush = bio_alloc_bioset(GFP_NOIO, 0,
 							     dc->disk.bio_split);
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index fe222c0..3c9aebe 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -788,7 +788,7 @@ static void check_if_tick_bio_needed(struct cache *cache, struct bio *bio)
 
 	spin_lock_irqsave(&cache->lock, flags);
 	if (cache->need_tick_bio &&
-	    !(bio->bi_rw & (REQ_FUA | REQ_FLUSH)) &&
+	    !(bio->bi_rw & (REQ_FUA | REQ_PREFLUSH)) &&
 	    bio->bi_op != REQ_OP_DISCARD) {
 		pb->tick = true;
 		cache->need_tick_bio = false;
@@ -830,7 +830,7 @@ static dm_oblock_t get_bio_block(struct cache *cache, struct bio *bio)
 
 static int bio_triggers_commit(struct cache *cache, struct bio *bio)
 {
-	return bio->bi_rw & (REQ_FLUSH | REQ_FUA);
+	return bio->bi_rw & (REQ_PREFLUSH | REQ_FUA);
 }
 
 /*
@@ -1063,7 +1063,8 @@ static void dec_io_migrations(struct cache *cache)
 
 static bool discard_or_flush(struct bio *bio)
 {
-	return bio->bi_op == REQ_OP_DISCARD || bio->bi_rw & (REQ_FLUSH | REQ_FUA);
+	return bio->bi_op == REQ_OP_DISCARD ||
+	       bio->bi_rw & (REQ_PREFLUSH | REQ_FUA);
 }
 
 static void __cell_defer(struct cache *cache, struct dm_bio_prison_cell *cell)
@@ -1974,7 +1975,7 @@ static void process_deferred_bios(struct cache *cache)
 
 		bio = bio_list_pop(&bios);
 
-		if (bio->bi_rw & REQ_FLUSH)
+		if (bio->bi_rw & REQ_PREFLUSH)
 			process_flush_bio(cache, bio);
 		else if (bio->bi_op == REQ_OP_DISCARD)
 			process_discard_bio(cache, &structs, bio);
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index b7cbd39..7e39d3c 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1909,11 +1909,12 @@ static int crypt_map(struct dm_target *ti, struct bio *bio)
 	struct crypt_config *cc = ti->private;
 
 	/*
-	 * If bio is REQ_FLUSH or REQ_DISCARD, just bypass crypt queues.
-	 * - for REQ_FLUSH device-mapper core ensures that no IO is in-flight
+	 * If bio is REQ_PREFLUSH or REQ_DISCARD, just bypass crypt queues.
+	 * - for REQ_PREFLUSH device-mapper core ensures that no IO is in-flight
 	 * - for REQ_DISCARD caller must use flush if IO ordering matters
 	 */
-	if (unlikely(bio->bi_rw & REQ_FLUSH || bio->bi_op == REQ_OP_DISCARD)) {
+	if (unlikely(bio->bi_rw & REQ_PREFLUSH ||
+	    bio->bi_op == REQ_OP_DISCARD)) {
 		bio->bi_bdev = cc->dev->bdev;
 		if (bio_sectors(bio))
 			bio->bi_iter.bi_sector = cc->start +
diff --git a/drivers/md/dm-era-target.c b/drivers/md/dm-era-target.c
index 665bf32..2faf49d8 100644
--- a/drivers/md/dm-era-target.c
+++ b/drivers/md/dm-era-target.c
@@ -1540,9 +1540,9 @@ static int era_map(struct dm_target *ti, struct bio *bio)
 	remap_to_origin(era, bio);
 
 	/*
-	 * REQ_FLUSH bios carry no data, so we're not interested in them.
+	 * REQ_PREFLUSH bios carry no data, so we're not interested in them.
 	 */
-	if (!(bio->bi_rw & REQ_FLUSH) &&
+	if (!(bio->bi_rw & REQ_PREFLUSH) &&
 	    (bio_data_dir(bio) == WRITE) &&
 	    !metadata_current_marked(era->md, block)) {
 		defer_bio(era, bio);
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 790b185..84aa27c 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -381,7 +381,7 @@ static void dispatch_io(int op, int op_flags, unsigned int num_regions,
 	 */
 	for (i = 0; i < num_regions; i++) {
 		*dp = old_pages;
-		if (where[i].count || (op_flags & REQ_FLUSH))
+		if (where[i].count || (op_flags & REQ_PREFLUSH))
 			do_region(op, op_flags, i, where + i, dp, io);
 	}
 
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 813bb4d..0848a43 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -555,7 +555,7 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 	struct bio_vec bv;
 	size_t alloc_size;
 	int i = 0;
-	bool flush_bio = (bio->bi_rw & REQ_FLUSH);
+	bool flush_bio = (bio->bi_rw & REQ_PREFLUSH);
 	bool fua_bio = (bio->bi_rw & REQ_FUA);
 	bool discard_bio = (bio->bi_op == REQ_OP_DISCARD);
 
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 54cc0c7..9f34923 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -704,7 +704,7 @@ static void do_writes(struct mirror_set *ms, struct bio_list *writes)
 	bio_list_init(&requeue);
 
 	while ((bio = bio_list_pop(writes))) {
-		if ((bio->bi_rw & REQ_FLUSH) ||
+		if ((bio->bi_rw & REQ_PREFLUSH) ||
 		    (bio->bi_op == REQ_OP_DISCARD)) {
 			bio_list_add(&sync, bio);
 			continue;
@@ -1253,7 +1253,8 @@ static int mirror_end_io(struct dm_target *ti, struct bio *bio, int error)
 	 * We need to dec pending if this was a write.
 	 */
 	if (rw == WRITE) {
-		if (!(bio->bi_rw & REQ_FLUSH) && bio->bi_op != REQ_OP_DISCARD)
+		if (!(bio->bi_rw & REQ_PREFLUSH) &&
+		    bio->bi_op != REQ_OP_DISCARD)
 			dm_rh_dec(ms->rh, bio_record->write_region);
 		return error;
 	}
diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
index ce4af57..d257428 100644
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -398,7 +398,7 @@ void dm_rh_mark_nosync(struct dm_region_hash *rh, struct bio *bio)
 	region_t region = dm_rh_bio_to_region(rh, bio);
 	int recovering = 0;
 
-	if (bio->bi_rw & REQ_FLUSH) {
+	if (bio->bi_rw & REQ_PREFLUSH) {
 		rh->flush_failure = 1;
 		return;
 	}
@@ -526,7 +526,7 @@ void dm_rh_inc_pending(struct dm_region_hash *rh, struct bio_list *bios)
 	struct bio *bio;
 
 	for (bio = bios->head; bio; bio = bio->bi_next) {
-		if (bio->bi_rw & REQ_FLUSH || bio->bi_op == REQ_OP_DISCARD)
+		if (bio->bi_rw & REQ_PREFLUSH || bio->bi_op == REQ_OP_DISCARD)
 			continue;
 		rh_inc(rh, dm_rh_bio_to_region(rh, bio));
 	}
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index f68d0ae..6e82975 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1681,7 +1681,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio)
 
 	init_tracked_chunk(bio);
 
-	if (bio->bi_rw & REQ_FLUSH) {
+	if (bio->bi_rw & REQ_PREFLUSH) {
 		bio->bi_bdev = s->cow->bdev;
 		return DM_MAPIO_REMAPPED;
 	}
@@ -1800,7 +1800,7 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio)
 
 	init_tracked_chunk(bio);
 
-	if (bio->bi_rw & REQ_FLUSH) {
+	if (bio->bi_rw & REQ_PREFLUSH) {
 		if (!dm_bio_get_target_bio_nr(bio))
 			bio->bi_bdev = s->origin->bdev;
 		else
@@ -2286,7 +2286,7 @@ static int origin_map(struct dm_target *ti, struct bio *bio)
 
 	bio->bi_bdev = o->dev->bdev;
 
-	if (unlikely(bio->bi_rw & REQ_FLUSH))
+	if (unlikely(bio->bi_rw & REQ_PREFLUSH))
 		return DM_MAPIO_REMAPPED;
 
 	if (bio_rw(bio) != WRITE)
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index 12b1630..e6f330c 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -286,7 +286,7 @@ static int stripe_map(struct dm_target *ti, struct bio *bio)
 	uint32_t stripe;
 	unsigned target_bio_nr;
 
-	if (bio->bi_rw & REQ_FLUSH) {
+	if (bio->bi_rw & REQ_PREFLUSH) {
 		target_bio_nr = dm_bio_get_target_bio_nr(bio);
 		BUG_ON(target_bio_nr >= sc->stripes);
 		bio->bi_bdev = sc->stripe[target_bio_nr].dev->bdev;
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 1e170e7..5eac816 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -697,7 +697,7 @@ static void remap_to_origin(struct thin_c *tc, struct bio *bio)
 
 static int bio_triggers_commit(struct thin_c *tc, struct bio *bio)
 {
-	return (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) &&
+	return (bio->bi_rw & (REQ_PREFLUSH | REQ_FUA)) &&
 		dm_thin_changed_this_transaction(tc->td);
 }
 
@@ -868,7 +868,7 @@ static void __inc_remap_and_issue_cell(void *context,
 	struct bio *bio;
 
 	while ((bio = bio_list_pop(&cell->bios))) {
-		if (bio->bi_rw & (REQ_FLUSH | REQ_FUA) ||
+		if (bio->bi_rw & (REQ_PREFLUSH | REQ_FUA) ||
 		    bio->bi_op == REQ_OP_DISCARD)
 			bio_list_add(&info->defer_bios, bio);
 		else {
@@ -1647,7 +1647,7 @@ static void __remap_and_issue_shared_cell(void *context,
 
 	while ((bio = bio_list_pop(&cell->bios))) {
 		if ((bio_data_dir(bio) == WRITE) ||
-		    (bio->bi_rw & (REQ_FLUSH | REQ_FUA) ||
+		    (bio->bi_rw & (REQ_PREFLUSH | REQ_FUA) ||
 		     bio->bi_op == REQ_OP_DISCARD))
 			bio_list_add(&info->defer_bios, bio);
 		else {
@@ -2560,7 +2560,7 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_SUBMITTED;
 	}
 
-	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA) ||
+	if (bio->bi_rw & (REQ_PREFLUSH | REQ_FUA) ||
 	    bio->bi_op == REQ_OP_DISCARD) {
 		thin_defer_bio_with_throttle(tc, bio);
 		return DM_MAPIO_SUBMITTED;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 90135b6..5336148c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -964,12 +964,12 @@ static void dec_pending(struct dm_io *io, int error)
 		if (io_error == DM_ENDIO_REQUEUE)
 			return;
 
-		if ((bio->bi_rw & REQ_FLUSH) && bio->bi_iter.bi_size) {
+		if ((bio->bi_rw & REQ_PREFLUSH) && bio->bi_iter.bi_size) {
 			/*
 			 * Preflush done for flush with data, reissue
-			 * without REQ_FLUSH.
+			 * without REQ_PREFLUSH.
 			 */
-			bio->bi_rw &= ~REQ_FLUSH;
+			bio->bi_rw &= ~REQ_PREFLUSH;
 			queue_io(md, bio);
 		} else {
 			/* done with normal IO or empty flush */
@@ -1428,7 +1428,7 @@ EXPORT_SYMBOL_GPL(dm_set_target_max_io_len);
 
 /*
  * A target may call dm_accept_partial_bio only from the map routine.  It is
- * allowed for all bio types except REQ_FLUSH.
+ * allowed for all bio types except REQ_PREFLUSH.
  *
  * dm_accept_partial_bio informs the dm that the target only wants to process
  * additional n_sectors sectors of the bio and the rest of the data should be
@@ -1458,7 +1458,7 @@ void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
 {
 	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
 	unsigned bi_size = bio->bi_iter.bi_size >> SECTOR_SHIFT;
-	BUG_ON(bio->bi_rw & REQ_FLUSH);
+	BUG_ON(bio->bi_rw & REQ_PREFLUSH);
 	BUG_ON(bi_size > *tio->len_ptr);
 	BUG_ON(n_sectors > bi_size);
 	*tio->len_ptr -= bi_size - n_sectors;
@@ -1733,7 +1733,7 @@ static void __split_and_process_bio(struct mapped_device *md,
 
 	start_io_acct(ci.io);
 
-	if (bio->bi_rw & REQ_FLUSH) {
+	if (bio->bi_rw & REQ_PREFLUSH) {
 		ci.bio = &ci.md->flush_bio;
 		ci.sector_count = 0;
 		error = __send_empty_flush(&ci);
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index aad82c7..657053e 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -221,7 +221,7 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 	struct bio *split;
 	sector_t start_sector, end_sector, data_offset;
 
-	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
+	if (unlikely(bio->bi_rw & REQ_PREFLUSH)) {
 		md_flush_request(mddev, bio);
 		return;
 	}
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7e16813..4f666d1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -422,7 +422,7 @@ static void md_submit_flush_data(struct work_struct *ws)
 		/* an empty barrier - all done */
 		bio_endio(bio);
 	else {
-		bio->bi_rw &= ~REQ_FLUSH;
+		bio->bi_rw &= ~REQ_PREFLUSH;
 		mddev->pers->make_request(mddev, bio);
 	}
 
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index 7331a80..b651af1 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -111,7 +111,7 @@ static void multipath_make_request(struct mddev *mddev, struct bio * bio)
 	struct multipath_bh * mp_bh;
 	struct multipath_info *multipath;
 
-	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
+	if (unlikely(bio->bi_rw & REQ_PREFLUSH)) {
 		md_flush_request(mddev, bio);
 		return;
 	}
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index e0d1b8c..f95463d 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -458,7 +458,7 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 	struct md_rdev *tmp_dev;
 	struct bio *split;
 
-	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
+	if (unlikely(bio->bi_rw & REQ_PREFLUSH)) {
 		md_flush_request(mddev, bio);
 		return;
 	}
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 2a42daa..2856b50 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1056,7 +1056,8 @@ static void make_request(struct mddev *mddev, struct bio * bio)
 	const int op = bio->bi_op;
 	const int rw = bio_data_dir(bio);
 	const unsigned long do_sync = (bio->bi_rw & REQ_SYNC);
-	const unsigned long do_flush_fua = (bio->bi_rw & (REQ_FLUSH | REQ_FUA));
+	const unsigned long do_flush_fua = (bio->bi_rw &
+						(REQ_PREFLUSH | REQ_FUA));
 	const unsigned long do_sec = (bio->bi_rw & REQ_SECURE);
 	struct md_rdev *blocked_rdev;
 	struct blk_plug_cb *cb;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1cfc061..6171ff7 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1452,7 +1452,7 @@ static void make_request(struct mddev *mddev, struct bio *bio)
 
 	struct bio *split;
 
-	if (unlikely(bio->bi_rw & REQ_FLUSH)) {
+	if (unlikely(bio->bi_rw & REQ_PREFLUSH)) {
 		md_flush_request(mddev, bio);
 		return;
 	}
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 311b7f2..c9f4ed5 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -536,7 +536,7 @@ int r5l_handle_flush_request(struct r5l_log *log, struct bio *bio)
 		bio_endio(bio);
 		return 0;
 	}
-	bio->bi_rw &= ~REQ_FLUSH;
+	bio->bi_rw &= ~REQ_PREFLUSH;
 	return -EAGAIN;
 }
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index aafd49e..2109881 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5154,7 +5154,7 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 	DEFINE_WAIT(w);
 	bool do_prepare;
 
-	if (unlikely(bi->bi_rw & REQ_FLUSH)) {
+	if (unlikely(bi->bi_rw & REQ_PREFLUSH)) {
 		int ret = r5l_handle_flush_request(conf->log, bi);
 
 		if (ret == 0)
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 1623d11..e63ad0f 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2237,7 +2237,7 @@ static void btrfsic_bio_end_io(struct bio *bp)
 			       block->dev_bytenr, block->mirror_num);
 		next_block = block->next_in_same_bio;
 		block->iodone_w_error = iodone_w_error;
-		if (block->submit_bio_bh_rw & REQ_FLUSH) {
+		if (block->submit_bio_bh_rw & REQ_PREFLUSH) {
 			dev_state->last_flush_gen++;
 			if ((dev_state->state->print_mask &
 			     BTRFSIC_PRINT_MASK_END_IO_BIO_BH))
@@ -2273,7 +2273,7 @@ static void btrfsic_bh_end_io(struct buffer_head *bh, int uptodate)
 		       block->dev_bytenr, block->mirror_num);
 
 	block->iodone_w_error = iodone_w_error;
-	if (block->submit_bio_bh_rw & REQ_FLUSH) {
+	if (block->submit_bio_bh_rw & REQ_PREFLUSH) {
 		dev_state->last_flush_gen++;
 		if ((dev_state->state->print_mask &
 		     BTRFSIC_PRINT_MASK_END_IO_BIO_BH))
@@ -2926,7 +2926,7 @@ int btrfsic_submit_bh(int op, int op_flags, struct buffer_head *bh)
 		btrfsic_process_written_block(dev_state, dev_bytenr,
 					      &bh->b_data, 1, NULL,
 					      NULL, bh, op_flags);
-	} else if (NULL != dev_state && (op_flags & REQ_FLUSH)) {
+	} else if (NULL != dev_state && (op_flags & REQ_PREFLUSH)) {
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			printk(KERN_INFO
@@ -3024,7 +3024,7 @@ static void __btrfsic_submit_bio(struct bio *bio)
 			kunmap(bio->bi_io_vec[i].bv_page);
 		}
 		kfree(mapped_datav);
-	} else if (NULL != dev_state && (bio->bi_rw & REQ_FLUSH)) {
+	} else if (NULL != dev_state && (bio->bi_rw & REQ_PREFLUSH)) {
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			printk(KERN_INFO
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 7104d76..2e4760b 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -1331,7 +1331,7 @@ static int jbd2_write_superblock(journal_t *journal, int write_flags)
 
 	trace_jbd2_write_superblock(journal, write_flags);
 	if (!(journal->j_flags & JBD2_BARRIER))
-		write_flags &= ~(REQ_FUA | REQ_FLUSH);
+		write_flags &= ~(REQ_FUA | REQ_PREFLUSH);
 	lock_buffer(bh);
 	if (buffer_write_io_error(bh)) {
 		/*
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 4cfba72..d355483 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1235,7 +1235,7 @@ _xfs_buf_ioapply(
 		if (bp->b_flags & XBF_FUA)
 			op_flags |= REQ_FUA;
 		if (bp->b_flags & XBF_FLUSH)
-			op_flags |= REQ_FLUSH;
+			op_flags |= REQ_PREFLUSH;
 
 		/*
 		 * Run the write verifier callback function if it exists. If
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index b4ef8d7..d637d8b 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -158,7 +158,7 @@ enum rq_flag_bits {
 	__REQ_NOIDLE,		/* don't anticipate more IO after this one */
 	__REQ_INTEGRITY,	/* I/O includes block integrity payload */
 	__REQ_FUA,		/* forced unit access */
-	__REQ_FLUSH,		/* request for cache flush */
+	__REQ_PREFLUSH,		/* request for cache flush */
 
 	/* bio only flags */
 	__REQ_RAHEAD,		/* read ahead, can fail anytime */
@@ -202,12 +202,12 @@ enum rq_flag_bits {
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
 #define REQ_COMMON_MASK \
 	(REQ_FAILFAST_MASK | REQ_SYNC | REQ_META | REQ_PRIO | REQ_NOIDLE | \
-	 REQ_FLUSH | REQ_FUA | REQ_SECURE | REQ_INTEGRITY)
+	 REQ_PREFLUSH | REQ_FUA | REQ_SECURE | REQ_INTEGRITY)
 #define REQ_CLONE_MASK		REQ_COMMON_MASK
 
 /* This mask is used for both bio and request merge checking */
 #define REQ_NOMERGE_FLAGS \
-	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_FLUSH | REQ_FUA | REQ_FLUSH_SEQ)
+	(REQ_NOMERGE | REQ_STARTED | REQ_SOFTBARRIER | REQ_PREFLUSH | REQ_FUA | REQ_FLUSH_SEQ)
 
 #define REQ_RAHEAD		(1ULL << __REQ_RAHEAD)
 #define REQ_THROTTLED		(1ULL << __REQ_THROTTLED)
@@ -225,7 +225,7 @@ enum rq_flag_bits {
 #define REQ_PREEMPT		(1ULL << __REQ_PREEMPT)
 #define REQ_ALLOCED		(1ULL << __REQ_ALLOCED)
 #define REQ_COPY_USER		(1ULL << __REQ_COPY_USER)
-#define REQ_FLUSH		(1ULL << __REQ_FLUSH)
+#define REQ_PREFLUSH		(1ULL << __REQ_PREFLUSH)
 #define REQ_FLUSH_SEQ		(1ULL << __REQ_FLUSH_SEQ)
 #define REQ_IO_STAT		(1ULL << __REQ_IO_STAT)
 #define REQ_MIXED_MERGE		(1ULL << __REQ_MIXED_MERGE)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index d57a5b5..7197027 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -203,9 +203,9 @@ typedef void (dax_iodone_t)(struct buffer_head *bh_map, int uptodate);
 #define READ_SYNC		REQ_SYNC
 #define WRITE_SYNC		(REQ_SYNC | REQ_NOIDLE)
 #define WRITE_ODIRECT		REQ_SYNC
-#define WRITE_FLUSH		(REQ_SYNC | REQ_NOIDLE | REQ_FLUSH)
+#define WRITE_FLUSH		(REQ_SYNC | REQ_NOIDLE | REQ_PREFLUSH)
 #define WRITE_FUA		(REQ_SYNC | REQ_NOIDLE | REQ_FUA)
-#define WRITE_FLUSH_FUA		(REQ_SYNC | REQ_NOIDLE | REQ_FLUSH | REQ_FUA)
+#define WRITE_FLUSH_FUA		(REQ_SYNC | REQ_NOIDLE | REQ_PREFLUSH | REQ_FUA)
 
 /*
  * Attribute flags.  These should be or-ed together to figure out what
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index ed3fc87..9df1cd8 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -33,7 +33,7 @@ TRACE_DEFINE_ENUM(SSR);
 TRACE_DEFINE_ENUM(__REQ_RAHEAD);
 TRACE_DEFINE_ENUM(__REQ_SYNC);
 TRACE_DEFINE_ENUM(__REQ_NOIDLE);
-TRACE_DEFINE_ENUM(__REQ_FLUSH);
+TRACE_DEFINE_ENUM(__REQ_PREFLUSH);
 TRACE_DEFINE_ENUM(__REQ_FUA);
 TRACE_DEFINE_ENUM(__REQ_PRIO);
 TRACE_DEFINE_ENUM(__REQ_META);
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 3a54c83..c94dec7 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -189,6 +189,7 @@ static const u32 ddir_act[2] = { BLK_TC_ACT(BLK_TC_READ),
 				 BLK_TC_ACT(BLK_TC_WRITE) };
 
 #define BLK_TC_RAHEAD		BLK_TC_AHEAD
+#define BLK_TC_PREFLUSH		BLK_TC_FLUSH
 
 /* The ilog2() calls fall out because they're constant */
 #define MASK_TC_BIT(rw, __name) ((rw & REQ_ ## __name) << \
@@ -219,7 +220,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
 	what |= MASK_TC_BIT(op_flags, SYNC);
 	what |= MASK_TC_BIT(op_flags, RAHEAD);
 	what |= MASK_TC_BIT(op_flags, META);
-	what |= MASK_TC_BIT(op_flags, FLUSH);
+	what |= MASK_TC_BIT(op_flags, PREFLUSH);
 	what |= MASK_TC_BIT(op_flags, FUA);
 	if (op == REQ_OP_DISCARD)
 		what |= BLK_TC_ACT(BLK_TC_DISCARD);
@@ -1777,7 +1778,7 @@ void blk_fill_rwbs(char *rwbs, int op, u32 rw, int bytes)
 {
 	int i = 0;
 
-	if (rw & REQ_FLUSH ||
+	if (rw & REQ_PREFLUSH ||
 	    op == REQ_OP_FLUSH)
 		rwbs[i++] = 'F';
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
