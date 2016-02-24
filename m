Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7B37E7CB9
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 13:48:58 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4AC838F8037
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 11:48:52 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id nNWz5tDxFDJSNE9D (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 24 Feb 2016 11:48:45 -0800 (PST)
From: mchristi@redhat.com
Subject: [PATCH 08/35] btrfs: set bi_op tp REQ_OP
Date: Wed, 24 Feb 2016 13:47:45 -0600
Message-Id: <1456343292-14535-9-git-send-email-mchristi@redhat.com>
In-Reply-To: <1456343292-14535-1-git-send-email-mchristi@redhat.com>
References: <1456343292-14535-1-git-send-email-mchristi@redhat.com>
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

This patch has btrfs set the bio bi_op to a REQ_OP, and rq_flag_bits
to bi_rw.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 fs/btrfs/check-integrity.c | 19 +++++++++----------
 fs/btrfs/compression.c     |  4 ++++
 fs/btrfs/disk-io.c         |  7 ++++---
 fs/btrfs/inode.c           | 20 +++++++++++++-------
 fs/btrfs/raid56.c          | 10 +++++-----
 fs/btrfs/scrub.c           |  9 +++++----
 fs/btrfs/volumes.c         | 20 ++++++++++----------
 7 files changed, 50 insertions(+), 39 deletions(-)

diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 1c3c40a..d95c323 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1671,7 +1671,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 		}
 		bio->bi_bdev = block_ctx->dev->bdev;
 		bio->bi_iter.bi_sector = dev_bytenr >> 9;
-		bio->bi_rw = READ;
+		bio->bi_op = REQ_OP_READ;
 
 		for (j = i; j < num_pages; j++) {
 			ret = bio_add_page(bio, block_ctx->pagev[j],
@@ -2920,7 +2920,6 @@ int btrfsic_submit_bh(int op, int op_flags, struct buffer_head *bh)
 static void __btrfsic_submit_bio(struct bio *bio)
 {
 	struct btrfsic_dev_state *dev_state;
-	int rw = bio->bi_rw;
 
 	if (!btrfsic_is_initialized)
 		return;
@@ -2930,7 +2929,7 @@ static void __btrfsic_submit_bio(struct bio *bio)
 	 * btrfsic_mount(), this might return NULL */
 	dev_state = btrfsic_dev_state_lookup(bio->bi_bdev);
 	if (NULL != dev_state &&
-	    (rw & WRITE) && NULL != bio->bi_io_vec) {
+	    (bio->bi_op == REQ_OP_WRITE) && NULL != bio->bi_io_vec) {
 		unsigned int i;
 		u64 dev_bytenr;
 		u64 cur_bytenr;
@@ -2942,9 +2941,9 @@ static void __btrfsic_submit_bio(struct bio *bio)
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			printk(KERN_INFO
-			       "submit_bio(rw=0x%x, bi_vcnt=%u,"
+			       "submit_bio(rw=%d,0x%lx, bi_vcnt=%u,"
 			       " bi_sector=%llu (bytenr %llu), bi_bdev=%p)\n",
-			       rw, bio->bi_vcnt,
+			       bio->bi_op, bio->bi_rw, bio->bi_vcnt,
 			       (unsigned long long)bio->bi_iter.bi_sector,
 			       dev_bytenr, bio->bi_bdev);
 
@@ -2975,18 +2974,18 @@ static void __btrfsic_submit_bio(struct bio *bio)
 		btrfsic_process_written_block(dev_state, dev_bytenr,
 					      mapped_datav, bio->bi_vcnt,
 					      bio, &bio_is_patched,
-					      NULL, rw);
+					      NULL, bio->bi_rw);
 		while (i > 0) {
 			i--;
 			kunmap(bio->bi_io_vec[i].bv_page);
 		}
 		kfree(mapped_datav);
-	} else if (NULL != dev_state && (rw & REQ_FLUSH)) {
+	} else if (NULL != dev_state && (bio->bi_rw & REQ_FLUSH)) {
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			printk(KERN_INFO
-			       "submit_bio(rw=0x%x FLUSH, bdev=%p)\n",
-			       rw, bio->bi_bdev);
+			       "submit_bio(rw=%d,0x%lx FLUSH, bdev=%p)\n",
+			       bio->bi_op, bio->bi_rw, bio->bi_bdev);
 		if (!dev_state->dummy_block_for_bio_bh_flush.is_iodone) {
 			if ((dev_state->state->print_mask &
 			     (BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH |
@@ -3004,7 +3003,7 @@ static void __btrfsic_submit_bio(struct bio *bio)
 			block->never_written = 0;
 			block->iodone_w_error = 0;
 			block->flush_gen = dev_state->last_flush_gen + 1;
-			block->submit_bio_bh_rw = rw;
+			block->submit_bio_bh_rw = bio->bi_rw;
 			block->orig_bio_bh_private = bio->bi_private;
 			block->orig_bio_bh_end_io.bio = bio->bi_end_io;
 			block->next_in_same_bio = NULL;
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 3346cd8..7e64f3e 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -363,6 +363,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 		kfree(cb);
 		return -ENOMEM;
 	}
+	bio->bi_op = REQ_OP_WRITE;
 	bio->bi_private = cb;
 	bio->bi_end_io = end_compressed_bio_write;
 	atomic_inc(&cb->pending_bios);
@@ -408,6 +409,7 @@ int btrfs_submit_compressed_write(struct inode *inode, u64 start,
 
 			bio = compressed_bio_alloc(bdev, first_byte, GFP_NOFS);
 			BUG_ON(!bio);
+			bio->bi_op = REQ_OP_WRITE;
 			bio->bi_private = cb;
 			bio->bi_end_io = end_compressed_bio_write;
 			bio_add_page(bio, page, PAGE_CACHE_SIZE, 0);
@@ -646,6 +648,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	comp_bio = compressed_bio_alloc(bdev, cur_disk_byte, GFP_NOFS);
 	if (!comp_bio)
 		goto fail2;
+	comp_bio->bi_op = REQ_OP_READ;
 	comp_bio->bi_private = cb;
 	comp_bio->bi_end_io = end_compressed_bio_read;
 	atomic_inc(&cb->pending_bios);
@@ -699,6 +702,7 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 			comp_bio = compressed_bio_alloc(bdev, cur_disk_byte,
 							GFP_NOFS);
 			BUG_ON(!comp_bio);
+			comp_bio->bi_op = REQ_OP_READ;
 			comp_bio->bi_private = cb;
 			comp_bio->bi_end_io = end_compressed_bio_read;
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index bb23db7..49d2f29 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -719,7 +719,7 @@ static void end_workqueue_bio(struct bio *bio)
 	fs_info = end_io_wq->info;
 	end_io_wq->error = bio->bi_error;
 
-	if (bio->bi_rw & REQ_WRITE) {
+	if (bio->bi_op == REQ_OP_WRITE) {
 		if (end_io_wq->metadata == BTRFS_WQ_ENDIO_METADATA) {
 			wq = fs_info->endio_meta_write_workers;
 			func = btrfs_endio_meta_write_helper;
@@ -865,7 +865,7 @@ int btrfs_wq_submit_bio(struct btrfs_fs_info *fs_info, struct inode *inode,
 
 	atomic_inc(&fs_info->nr_async_submits);
 
-	if (rw & REQ_SYNC)
+	if (bio->bi_rw & REQ_SYNC)
 		btrfs_set_work_high_priority(&async->work);
 
 	btrfs_queue_work(fs_info->workers, &async->work);
@@ -943,7 +943,7 @@ static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 	int async = check_async_write(inode, bio_flags);
 	int ret;
 
-	if (!(rw & REQ_WRITE)) {
+	if (bio->bi_op != REQ_OP_WRITE) {
 		/*
 		 * called for a read, do the setup so that checksum validation
 		 * can happen in the async kernel threads
@@ -3470,6 +3470,7 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 
 	bio->bi_end_io = btrfs_end_empty_barrier;
 	bio->bi_bdev = device->bdev;
+	bio->bi_op = REQ_OP_WRITE;
 	bio->bi_rw = WRITE_FLUSH;
 	init_completion(&device->flush_wait);
 	bio->bi_private = &device->flush_wait;
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 3a7fe66..19f38f5 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1894,7 +1894,7 @@ static int btrfs_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 	if (btrfs_is_free_space_inode(inode))
 		metadata = BTRFS_WQ_ENDIO_FREE_SPACE;
 
-	if (!(rw & REQ_WRITE)) {
+	if (bio->bi_op != REQ_OP_WRITE) {
 		ret = btrfs_bio_wq_end_io(root->fs_info, bio, metadata);
 		if (ret)
 			goto out;
@@ -7730,7 +7730,7 @@ static inline int submit_dio_repair_bio(struct inode *inode, struct bio *bio,
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 
-	BUG_ON(rw & REQ_WRITE);
+	BUG_ON(bio->bi_op == REQ_OP_WRITE);
 
 	bio_get(bio);
 
@@ -7790,7 +7790,7 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 	int read_mode;
 	int ret;
 
-	BUG_ON(failed_bio->bi_rw & REQ_WRITE);
+	BUG_ON(failed_bio->bi_op == REQ_OP_WRITE);
 
 	ret = btrfs_get_io_failure_record(inode, start, end, &failrec);
 	if (ret)
@@ -7818,6 +7818,8 @@ static int dio_read_error(struct inode *inode, struct bio *failed_bio,
 		free_io_failure(inode, failrec);
 		return -EIO;
 	}
+	bio->bi_op = REQ_OP_READ;
+	bio->bi_rw = read_mode;
 
 	btrfs_debug(BTRFS_I(inode)->root->fs_info,
 		    "Repair DIO Read Error: submitting new dio read[%#x] to this_mirror=%d, in_validation=%d\n",
@@ -8132,8 +8134,8 @@ static void btrfs_end_dio_bio(struct bio *bio)
 
 	if (err)
 		btrfs_warn(BTRFS_I(dip->inode)->root->fs_info,
-			   "direct IO failed ino %llu rw %lu sector %#Lx len %u err no %d",
-			   btrfs_ino(dip->inode), bio->bi_rw,
+			   "direct IO failed ino %llu rw %d,%lu sector %#Lx len %u err no %d",
+			   btrfs_ino(dip->inode), bio->bi_op, bio->bi_rw,
 			   (unsigned long long)bio->bi_iter.bi_sector,
 			   bio->bi_iter.bi_size, err);
 
@@ -8211,7 +8213,7 @@ static inline int __btrfs_submit_dio_bio(struct bio *bio, struct inode *inode,
 					 int async_submit)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
-	int write = rw & REQ_WRITE;
+	bool write = bio->bi_op == REQ_OP_WRITE;
 	struct btrfs_root *root = BTRFS_I(inode)->root;
 	int ret;
 
@@ -8298,6 +8300,8 @@ static int btrfs_submit_direct_hook(int rw, struct btrfs_dio_private *dip,
 	if (!bio)
 		return -ENOMEM;
 
+	bio->bi_op = orig_bio->bi_op;
+	bio->bi_rw = orig_bio->bi_rw;
 	bio->bi_private = dip;
 	bio->bi_end_io = btrfs_end_dio_bio;
 	btrfs_io_bio(bio)->logical = file_offset;
@@ -8335,12 +8339,14 @@ next_block:
 						  start_sector, GFP_NOFS);
 			if (!bio)
 				goto out_err;
+			bio->bi_op = orig_bio->bi_op;
+			bio->bi_rw = orig_bio->bi_rw;
 			bio->bi_private = dip;
 			bio->bi_end_io = btrfs_end_dio_bio;
 			btrfs_io_bio(bio)->logical = file_offset;
 
 			map_length = orig_bio->bi_iter.bi_size;
-			ret = btrfs_map_block(root->fs_info, rw,
+			ret = btrfs_map_block(root->fs_info, orig_bio->bi_op,
 					      start_sector << 9,
 					      &map_length, NULL, 0);
 			if (ret) {
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index a8e66e4..8aa3ec9 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1320,7 +1320,7 @@ write_data:
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_write_end_io;
-		bio->bi_rw = WRITE;
+		bio->bi_op = REQ_OP_WRITE;
 
 		submit_bio(bio);
 	}
@@ -1575,7 +1575,7 @@ static int raid56_rmw_stripe(struct btrfs_raid_bio *rbio)
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_rmw_end_io;
-		bio->bi_rw = READ;
+		bio->bi_op = REQ_OP_READ;
 
 		btrfs_bio_wq_end_io(rbio->fs_info, bio,
 				    BTRFS_WQ_ENDIO_RAID56);
@@ -2100,7 +2100,7 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_recover_end_io;
-		bio->bi_rw = READ;
+		bio->bi_op = REQ_OP_READ;
 
 		btrfs_bio_wq_end_io(rbio->fs_info, bio,
 				    BTRFS_WQ_ENDIO_RAID56);
@@ -2437,7 +2437,7 @@ submit_write:
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_write_end_io;
-		bio->bi_rw = WRITE;
+		bio->bi_rw = REQ_OP_WRITE;
 
 		submit_bio(bio);
 	}
@@ -2616,7 +2616,7 @@ static void raid56_parity_scrub_stripe(struct btrfs_raid_bio *rbio)
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid56_parity_scrub_end_io;
-		bio->bi_rw = READ;
+		bio->bi_op = REQ_OP_READ;
 
 		btrfs_bio_wq_end_io(rbio->fs_info, bio,
 				    BTRFS_WQ_ENDIO_RAID56);
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 8315947..7273efe 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1504,7 +1504,7 @@ static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
 				sblock->no_io_error_seen = 0;
 		} else {
 			bio->bi_iter.bi_sector = page->physical >> 9;
-			bio->bi_rw = READ;
+			bio->bi_op = REQ_OP_READ;
 
 			if (btrfsic_submit_bio_wait(bio))
 				sblock->no_io_error_seen = 0;
@@ -1584,7 +1584,7 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 			return -EIO;
 		bio->bi_bdev = page_bad->dev->bdev;
 		bio->bi_iter.bi_sector = page_bad->physical >> 9;
-		bio->bi_rw = WRITE;
+		bio->bi_op = REQ_OP_WRITE;
 
 		ret = bio_add_page(bio, page_good->page, PAGE_SIZE, 0);
 		if (PAGE_SIZE != ret) {
@@ -1686,7 +1686,7 @@ again:
 		bio->bi_end_io = scrub_wr_bio_end_io;
 		bio->bi_bdev = sbio->dev->bdev;
 		bio->bi_iter.bi_sector = sbio->physical >> 9;
-		bio->bi_rw = WRITE;
+		bio->bi_op = REQ_OP_WRITE;
 		sbio->err = 0;
 	} else if (sbio->physical + sbio->page_count * PAGE_SIZE !=
 		   spage->physical_for_dev_replace ||
@@ -2091,7 +2091,7 @@ again:
 		bio->bi_end_io = scrub_bio_end_io;
 		bio->bi_bdev = sbio->dev->bdev;
 		bio->bi_iter.bi_sector = sbio->physical >> 9;
-		bio->bi_rw = READ;
+		bio->bi_op = REQ_OP_READ;
 		sbio->err = 0;
 	} else if (sbio->physical + sbio->page_count * PAGE_SIZE !=
 		   spage->physical ||
@@ -4394,6 +4394,7 @@ static int write_page_nocow(struct scrub_ctx *sctx,
 	bio->bi_iter.bi_size = 0;
 	bio->bi_iter.bi_sector = physical_for_dev_replace >> 9;
 	bio->bi_bdev = dev->bdev;
+	bio->bi_op = REQ_OP_WRITE;
 	bio->bi_rw = WRITE_SYNC;
 
 	ret = bio_add_page(bio, page, PAGE_CACHE_SIZE, 0);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index f87678f..2be39f6 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5879,7 +5879,7 @@ static void btrfs_end_bio(struct bio *bio)
 			BUG_ON(stripe_index >= bbio->num_stripes);
 			dev = bbio->stripes[stripe_index].dev;
 			if (dev->bdev) {
-				if (bio->bi_rw & WRITE)
+				if (bio->bi_op == REQ_OP_WRITE)
 					btrfs_dev_stat_inc(dev,
 						BTRFS_DEV_STAT_WRITE_ERRS);
 				else
@@ -5944,7 +5944,7 @@ static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 	}
 
 	/* don't bother with additional async steps for reads, right now */
-	if (!(bio->bi_rw & REQ_WRITE)) {
+	if (bio->bi_op == REQ_OP_READ) {
 		bio_get(bio);
 		btrfsic_submit_bio(bio);
 		bio_put(bio);
@@ -5993,15 +5993,14 @@ static void submit_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
 	btrfs_io_bio(bio)->stripe_index = dev_nr;
 	bio->bi_end_io = btrfs_end_bio;
 	bio->bi_iter.bi_sector = physical >> 9;
-	bio->bi_rw |= rw;
 #ifdef DEBUG
 	{
 		struct rcu_string *name;
 
 		rcu_read_lock();
 		name = rcu_dereference(dev->name);
-		pr_debug("btrfs_map_bio: rw %d, sector=%llu, dev=%lu "
-			 "(%s id %llu), size=%u\n", rw,
+		pr_debug("btrfs_map_bio: rw %d 0x%x, sector=%llu, dev=%lu "
+			 "(%s id %llu), size=%u\n", bio->bi_op, bio->bi_rw,
 			 (u64)bio->bi_iter.bi_sector, (u_long)dev->bdev->bd_dev,
 			 name->str, dev->devid, bio->bi_iter.bi_size);
 		rcu_read_unlock();
@@ -6048,8 +6047,8 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 	map_length = length;
 
 	btrfs_bio_counter_inc_blocked(root->fs_info);
-	ret = __btrfs_map_block(root->fs_info, rw, logical, &map_length, &bbio,
-			      mirror_num, 1);
+	ret = __btrfs_map_block(root->fs_info, bio->bi_op, logical,
+				&map_length, &bbio, mirror_num, 1);
 	if (ret) {
 		btrfs_bio_counter_dec(root->fs_info);
 		return ret;
@@ -6063,10 +6062,10 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 	atomic_set(&bbio->stripes_pending, bbio->num_stripes);
 
 	if ((bbio->map_type & BTRFS_BLOCK_GROUP_RAID56_MASK) &&
-	    ((rw & WRITE) || (mirror_num > 1))) {
+	    ((bio->bi_op == REQ_OP_WRITE) || (mirror_num > 1))) {
 		/* In this case, map_length has been set to the length of
 		   a single stripe; not the whole write */
-		if (rw & WRITE) {
+		if (bio->bi_op == REQ_OP_WRITE) {
 			ret = raid56_parity_write(root, bio, bbio, map_length);
 		} else {
 			ret = raid56_parity_recover(root, bio, bbio, map_length,
@@ -6085,7 +6084,8 @@ int btrfs_map_bio(struct btrfs_root *root, int rw, struct bio *bio,
 
 	for (dev_nr = 0; dev_nr < total_devs; dev_nr++) {
 		dev = bbio->stripes[dev_nr].dev;
-		if (!dev || !dev->bdev || (rw & WRITE && !dev->writeable)) {
+		if (!dev || !dev->bdev ||
+		    (bio->bi_op == REQ_OP_WRITE && !dev->writeable)) {
 			bbio_error(bbio, first_bio, logical);
 			continue;
 		}
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
