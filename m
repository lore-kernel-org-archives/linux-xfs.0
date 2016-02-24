Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 9D0BC7CB9
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 13:48:41 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5E54E304067
	for <xfs@oss.sgi.com>; Wed, 24 Feb 2016 11:48:32 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id qgJOemxQvjAsMGe7 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 24 Feb 2016 11:48:27 -0800 (PST)
From: mchristi@redhat.com
Subject: [PATCH 01/35] block/fs/drivers: remove rw argument from submit_bio
Date: Wed, 24 Feb 2016 13:47:38 -0600
Message-Id: <1456343292-14535-2-git-send-email-mchristi@redhat.com>
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

This has callers of submit_bio/submit_bio_wait set the bio->bi_rw
instead of passing it in. This makes that use the same as
generic_make_request and how we set the other bio fields.

v2.

1. Set bi_rw instead of ORing it. For cloned bios, I still OR it
to keep the old behavior incase there bits we wanted to keep.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com> 
Reviewed-by: Christoph Hellwig <hch@lst.de>

---
 block/bio.c                         |  7 +++----
 block/blk-core.c                    | 11 ++++-------
 block/blk-flush.c                   |  3 ++-
 block/blk-lib.c                     |  9 ++++++---
 drivers/block/drbd/drbd_actlog.c    |  2 +-
 drivers/block/drbd/drbd_bitmap.c    |  4 ++--
 drivers/block/floppy.c              |  3 ++-
 drivers/block/xen-blkback/blkback.c |  4 +++-
 drivers/block/xen-blkfront.c        |  4 ++--
 drivers/md/bcache/debug.c           |  6 ++++--
 drivers/md/bcache/journal.c         |  2 +-
 drivers/md/bcache/super.c           |  4 ++--
 drivers/md/dm-bufio.c               |  3 ++-
 drivers/md/dm-io.c                  |  3 ++-
 drivers/md/dm-log-writes.c          |  9 ++++++---
 drivers/md/dm-thin.c                |  3 ++-
 drivers/md/md.c                     | 10 +++++++---
 drivers/md/raid1.c                  |  3 ++-
 drivers/md/raid10.c                 |  4 +++-
 drivers/md/raid5-cache.c            |  7 ++++---
 drivers/target/target_core_iblock.c | 24 +++++++++++++-----------
 fs/btrfs/check-integrity.c          | 18 ++++++++++--------
 fs/btrfs/check-integrity.h          |  4 ++--
 fs/btrfs/disk-io.c                  |  3 ++-
 fs/btrfs/extent_io.c                |  7 ++++---
 fs/btrfs/raid56.c                   | 17 ++++++++++++-----
 fs/btrfs/scrub.c                    | 16 +++++++++++-----
 fs/btrfs/volumes.c                  | 14 +++++++-------
 fs/buffer.c                         |  3 ++-
 fs/direct-io.c                      |  3 ++-
 fs/ext4/crypto.c                    |  3 ++-
 fs/ext4/page-io.c                   |  3 ++-
 fs/ext4/readpage.c                  |  9 +++++----
 fs/f2fs/data.c                      | 13 ++++++++-----
 fs/f2fs/segment.c                   |  6 ++++--
 fs/gfs2/lops.c                      |  3 ++-
 fs/gfs2/meta_io.c                   |  3 ++-
 fs/gfs2/ops_fstype.c                |  3 ++-
 fs/hfsplus/wrapper.c                |  3 ++-
 fs/jfs/jfs_logmgr.c                 |  6 ++++--
 fs/jfs/jfs_metapage.c               | 10 ++++++----
 fs/logfs/dev_bdev.c                 | 15 ++++++++++-----
 fs/mpage.c                          |  3 ++-
 fs/nfs/blocklayout/blocklayout.c    | 22 ++++++++++++----------
 fs/nilfs2/segbuf.c                  |  3 ++-
 fs/ocfs2/cluster/heartbeat.c        | 12 +++++++-----
 fs/xfs/xfs_aops.c                   |  3 ++-
 fs/xfs/xfs_buf.c                    |  4 ++--
 include/linux/bio.h                 |  2 +-
 include/linux/fs.h                  |  2 +-
 kernel/power/swap.c                 |  5 +++--
 mm/page_io.c                        | 10 ++++++----
 52 files changed, 212 insertions(+), 141 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index cf75915..7e4d050 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -859,21 +859,20 @@ static void submit_bio_wait_endio(struct bio *bio)
 
 /**
  * submit_bio_wait - submit a bio, and wait until it completes
- * @rw: whether to %READ or %WRITE, or maybe to %READA (read ahead)
  * @bio: The &struct bio which describes the I/O
  *
  * Simple wrapper around submit_bio(). Returns 0 on success, or the error from
  * bio_endio() on failure.
  */
-int submit_bio_wait(int rw, struct bio *bio)
+int submit_bio_wait(struct bio *bio)
 {
 	struct submit_bio_ret ret;
 
-	rw |= REQ_SYNC;
 	init_completion(&ret.event);
 	bio->bi_private = &ret;
 	bio->bi_end_io = submit_bio_wait_endio;
-	submit_bio(rw, bio);
+	bio->bi_rw |= REQ_SYNC;
+	submit_bio(bio);
 	wait_for_completion_io(&ret.event);
 
 	return ret.error;
diff --git a/block/blk-core.c b/block/blk-core.c
index 827f8ba..f23d1b0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2092,7 +2092,6 @@ EXPORT_SYMBOL(generic_make_request);
 
 /**
  * submit_bio - submit a bio to the block device layer for I/O
- * @rw: whether to %READ or %WRITE, or maybe to %READA (read ahead)
  * @bio: The &struct bio which describes the I/O
  *
  * submit_bio() is very similar in purpose to generic_make_request(), and
@@ -2100,10 +2099,8 @@ EXPORT_SYMBOL(generic_make_request);
  * interfaces; @bio must be presetup and ready for I/O.
  *
  */
-blk_qc_t submit_bio(int rw, struct bio *bio)
+blk_qc_t submit_bio(struct bio *bio)
 {
-	bio->bi_rw |= rw;
-
 	/*
 	 * If it's a regular read/write or a barrier with data attached,
 	 * go through the normal accounting stuff before submission.
@@ -2111,12 +2108,12 @@ blk_qc_t submit_bio(int rw, struct bio *bio)
 	if (bio_has_data(bio)) {
 		unsigned int count;
 
-		if (unlikely(rw & REQ_WRITE_SAME))
+		if (unlikely(bio->bi_rw & REQ_WRITE_SAME))
 			count = bdev_logical_block_size(bio->bi_bdev) >> 9;
 		else
 			count = bio_sectors(bio);
 
-		if (rw & WRITE) {
+		if (bio->bi_rw & WRITE) {
 			count_vm_events(PGPGOUT, count);
 		} else {
 			task_io_account_read(bio->bi_iter.bi_size);
@@ -2127,7 +2124,7 @@ blk_qc_t submit_bio(int rw, struct bio *bio)
 			char b[BDEVNAME_SIZE];
 			printk(KERN_DEBUG "%s(%d): %s block %Lu on %s (%u sectors)\n",
 			current->comm, task_pid_nr(current),
-				(rw & WRITE) ? "WRITE" : "READ",
+				(bio->bi_rw & WRITE) ? "WRITE" : "READ",
 				(unsigned long long)bio->bi_iter.bi_sector,
 				bdevname(bio->bi_bdev, b),
 				count);
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 9c423e5..f2fbf9a 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -484,8 +484,9 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 
 	bio = bio_alloc(gfp_mask, 0);
 	bio->bi_bdev = bdev;
+	bio->bi_rw = WRITE_FLUSH;
 
-	ret = submit_bio_wait(WRITE_FLUSH, bio);
+	ret = submit_bio_wait(bio);
 
 	/*
 	 * The driver must store the error location in ->bi_sector, if
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 9ebf653..87e3de4 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -102,13 +102,14 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_bdev = bdev;
 		bio->bi_private = &bb;
+		bio->bi_rw = type;
 
 		bio->bi_iter.bi_size = req_sects << 9;
 		nr_sects -= req_sects;
 		sector = end_sect;
 
 		atomic_inc(&bb.done);
-		submit_bio(type, bio);
+		submit_bio(bio);
 
 		/*
 		 * We can loop for a long time in here, if someone does
@@ -177,6 +178,7 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		bio->bi_io_vec->bv_page = page;
 		bio->bi_io_vec->bv_offset = 0;
 		bio->bi_io_vec->bv_len = bdev_logical_block_size(bdev);
+		bio->bi_rw = REQ_WRITE | REQ_WRITE_SAME;
 
 		if (nr_sects > max_write_same_sectors) {
 			bio->bi_iter.bi_size = max_write_same_sectors << 9;
@@ -188,7 +190,7 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		}
 
 		atomic_inc(&bb.done);
-		submit_bio(REQ_WRITE | REQ_WRITE_SAME, bio);
+		submit_bio(bio);
 	}
 
 	/* Wait for bios in-flight */
@@ -238,6 +240,7 @@ static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		bio->bi_bdev   = bdev;
 		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_private = &bb;
+		bio->bi_rw = WRITE;
 
 		while (nr_sects != 0) {
 			sz = min((sector_t) PAGE_SIZE >> 9 , nr_sects);
@@ -249,7 +252,7 @@ static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		}
 		ret = 0;
 		atomic_inc(&bb.done);
-		submit_bio(WRITE, bio);
+		submit_bio(bio);
 	}
 
 	/* Wait for bios in-flight */
diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 10459a1..6069e15 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -177,7 +177,7 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 	if (drbd_insert_fault(device, (rw & WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD))
 		bio_io_error(bio);
 	else
-		submit_bio(rw, bio);
+		submit_bio(bio);
 	wait_until_done_or_force_detached(device, bdev, &device->md_io.done);
 	if (!bio->bi_error)
 		err = device->md_io.error;
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 92d6fc0..e8959fe 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -1011,12 +1011,12 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
 	bio_add_page(bio, page, len, 0);
 	bio->bi_private = ctx;
 	bio->bi_end_io = drbd_bm_endio;
+	bio->bi_rw = rw;
 
 	if (drbd_insert_fault(device, (rw & WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD)) {
-		bio->bi_rw |= rw;
 		bio_io_error(bio);
 	} else {
-		submit_bio(rw, bio);
+		submit_bio(bio);
 		/* this should not count as user activity and cause the
 		 * resync to throttle -- see drbd_rs_should_slow_down(). */
 		atomic_add(len >> 9, &device->rs_sect_ev);
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 84708a5..73ded25 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3822,8 +3822,9 @@ static int __floppy_read_block_0(struct block_device *bdev, int drive)
 	bio.bi_flags |= (1 << BIO_QUIET);
 	bio.bi_private = &cbdata;
 	bio.bi_end_io = floppy_rb0_cb;
+	bio.bi_rw = READ;
 
-	submit_bio(READ, &bio);
+	submit_bio(&bio);
 	process_fd_request();
 
 	init_completion(&cbdata.complete);
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index 4809c15..79fe493 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -1369,6 +1369,7 @@ static int dispatch_rw_block_io(struct xen_blkif_ring *ring,
 			bio->bi_private = pending_req;
 			bio->bi_end_io  = end_block_io_op;
 			bio->bi_iter.bi_sector  = preq.sector_number;
+			bio->bi_rw	= operation;
 		}
 
 		preq.sector_number += seg[i].nsec;
@@ -1386,13 +1387,14 @@ static int dispatch_rw_block_io(struct xen_blkif_ring *ring,
 		bio->bi_bdev    = preq.bdev;
 		bio->bi_private = pending_req;
 		bio->bi_end_io  = end_block_io_op;
+		bio->bi_rw	= operation;
 	}
 
 	atomic_set(&pending_req->pendcnt, nbio);
 	blk_start_plug(&plug);
 
 	for (i = 0; i < nbio; i++)
-		submit_bio(operation, biolist[i]);
+		submit_bio(biolist[i]);
 
 	/* Let the I/Os go.. */
 	blk_finish_plug(&plug);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 83eb9e6..7ba2ed1 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -2111,7 +2111,7 @@ static int blkif_recover(struct blkfront_info *info)
 				bio_trim(cloned_bio, offset, size);
 				cloned_bio->bi_private = split_bio;
 				cloned_bio->bi_end_io = split_bio_end;
-				submit_bio(cloned_bio->bi_rw, cloned_bio);
+				submit_bio(cloned_bio);
 			}
 			/*
 			 * Now we have to wait for all those smaller bios to
@@ -2120,7 +2120,7 @@ static int blkif_recover(struct blkfront_info *info)
 			continue;
 		}
 		/* We don't need to split this bio */
-		submit_bio(bio->bi_rw, bio);
+		submit_bio(bio);
 	}
 
 	return 0;
diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
index 8b1f1d5..52b6bcf 100644
--- a/drivers/md/bcache/debug.c
+++ b/drivers/md/bcache/debug.c
@@ -52,9 +52,10 @@ void bch_btree_verify(struct btree *b)
 	bio->bi_bdev		= PTR_CACHE(b->c, &b->key, 0)->bdev;
 	bio->bi_iter.bi_sector	= PTR_OFFSET(&b->key, 0);
 	bio->bi_iter.bi_size	= KEY_SIZE(&v->key) << 9;
+	bio->bi_rw		= REQ_META|READ_SYNC;
 	bch_bio_map(bio, sorted);
 
-	submit_bio_wait(REQ_META|READ_SYNC, bio);
+	submit_bio_wait(bio);
 	bch_bbio_free(bio, b->c);
 
 	memcpy(ondisk, sorted, KEY_SIZE(&v->key) << 9);
@@ -113,11 +114,12 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
 	check = bio_clone(bio, GFP_NOIO);
 	if (!check)
 		return;
+	check->bi_rw |= READ_SYNC;
 
 	if (bio_alloc_pages(check, GFP_NOIO))
 		goto out_put;
 
-	submit_bio_wait(READ_SYNC, check);
+	submit_bio_wait(check);
 
 	bio_for_each_segment(bv, bio, iter) {
 		void *p1 = kmap_atomic(bv.bv_page);
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 29eba72..af3f9f7 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -418,7 +418,7 @@ static void journal_discard_work(struct work_struct *work)
 	struct journal_device *ja =
 		container_of(work, struct journal_device, discard_work);
 
-	submit_bio(0, &ja->discard_bio);
+	submit_bio(&ja->discard_bio);
 }
 
 static void do_journal_discard(struct cache *ca)
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 8d0ead9..9e2eac8 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -212,7 +212,7 @@ static void __write_super(struct cache_sb *sb, struct bio *bio)
 	unsigned i;
 
 	bio->bi_iter.bi_sector	= SB_SECTOR;
-	bio->bi_rw		= REQ_SYNC|REQ_META;
+	bio->bi_rw		= REQ_WRITE|REQ_SYNC|REQ_META;
 	bio->bi_iter.bi_size	= SB_SIZE;
 	bch_bio_map(bio, NULL);
 
@@ -238,7 +238,7 @@ static void __write_super(struct cache_sb *sb, struct bio *bio)
 	pr_debug("ver %llu, flags %llu, seq %llu",
 		 sb->version, sb->flags, sb->seq);
 
-	submit_bio(REQ_WRITE, bio);
+	submit_bio(bio);
 }
 
 static void bch_write_bdev_super_unlock(struct closure *cl)
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index cd77216..9d3ee7f 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -634,6 +634,7 @@ static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
 	 * the dm_buffer's inline bio is local to bufio.
 	 */
 	b->bio.bi_private = end_io;
+	b->bio.bi_rw = rw;
 
 	/*
 	 * We assume that if len >= PAGE_SIZE ptr is page-aligned.
@@ -660,7 +661,7 @@ static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
 		ptr += PAGE_SIZE;
 	} while (len > 0);
 
-	submit_bio(rw, &b->bio);
+	submit_bio(&b->bio);
 }
 
 static void submit_io(struct dm_buffer *b, int rw, sector_t block,
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 06d426e..50f17e3 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -322,6 +322,7 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 		bio->bi_iter.bi_sector = where->sector + (where->count - remaining);
 		bio->bi_bdev = where->bdev;
 		bio->bi_end_io = endio;
+		bio->bi_rw = rw;
 		store_io_and_region_in_bio(bio, io, region);
 
 		if (rw & REQ_DISCARD) {
@@ -355,7 +356,7 @@ static void do_region(int rw, unsigned region, struct dm_io_region *where,
 		}
 
 		atomic_inc(&io->count);
-		submit_bio(rw, bio);
+		submit_bio(bio);
 	} while (remaining);
 }
 
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index 608302e..addcc4b 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -205,6 +205,7 @@ static int write_metadata(struct log_writes_c *lc, void *entry,
 	bio->bi_bdev = lc->logdev->bdev;
 	bio->bi_end_io = log_end_io;
 	bio->bi_private = lc;
+	bio->bi_rw = WRITE;
 
 	page = alloc_page(GFP_KERNEL);
 	if (!page) {
@@ -226,7 +227,7 @@ static int write_metadata(struct log_writes_c *lc, void *entry,
 		DMERR("Couldn't add page to the log block");
 		goto error_bio;
 	}
-	submit_bio(WRITE, bio);
+	submit_bio(bio);
 	return 0;
 error_bio:
 	bio_put(bio);
@@ -269,6 +270,7 @@ static int log_one_block(struct log_writes_c *lc,
 	bio->bi_bdev = lc->logdev->bdev;
 	bio->bi_end_io = log_end_io;
 	bio->bi_private = lc;
+	bio->bi_rw = WRITE;
 
 	for (i = 0; i < block->vec_cnt; i++) {
 		/*
@@ -279,7 +281,7 @@ static int log_one_block(struct log_writes_c *lc,
 				   block->vecs[i].bv_len, 0);
 		if (ret != block->vecs[i].bv_len) {
 			atomic_inc(&lc->io_blocks);
-			submit_bio(WRITE, bio);
+			submit_bio(bio);
 			bio = bio_alloc(GFP_KERNEL, block->vec_cnt - i);
 			if (!bio) {
 				DMERR("Couldn't alloc log bio");
@@ -290,6 +292,7 @@ static int log_one_block(struct log_writes_c *lc,
 			bio->bi_bdev = lc->logdev->bdev;
 			bio->bi_end_io = log_end_io;
 			bio->bi_private = lc;
+			bio->bi_rw = WRITE;
 
 			ret = bio_add_page(bio, block->vecs[i].bv_page,
 					   block->vecs[i].bv_len, 0);
@@ -301,7 +304,7 @@ static int log_one_block(struct log_writes_c *lc,
 		}
 		sector += block->vecs[i].bv_len >> SECTOR_SHIFT;
 	}
-	submit_bio(WRITE, bio);
+	submit_bio(bio);
 out:
 	kfree(block->data);
 	kfree(block);
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 4fbbe1f..e39ad11 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -365,8 +365,9 @@ static int __blkdev_issue_discard_async(struct block_device *bdev, sector_t sect
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_bdev = bdev;
 	bio->bi_iter.bi_size = nr_sects << 9;
+	bio->bi_rw = type;
 
-	submit_bio(type, bio);
+	submit_bio(bio);
 
 	return 0;
 }
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 464627b..6f6102e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -391,8 +391,9 @@ static void submit_flushes(struct work_struct *ws)
 			bi->bi_end_io = md_end_flush;
 			bi->bi_private = rdev;
 			bi->bi_bdev = rdev->bdev;
+			bi->bi_rw = WRITE_FLUSH;
 			atomic_inc(&mddev->flush_pending);
-			submit_bio(WRITE_FLUSH, bi);
+			submit_bio(bi);
 			rcu_read_lock();
 			rdev_dec_pending(rdev, mddev);
 		}
@@ -736,9 +737,10 @@ void md_super_write(struct mddev *mddev, struct md_rdev *rdev,
 	bio_add_page(bio, page, size, 0);
 	bio->bi_private = rdev;
 	bio->bi_end_io = super_written;
+	bio->bi_rw = WRITE_FLUSH_FUA;
 
 	atomic_inc(&mddev->pending_writes);
-	submit_bio(WRITE_FLUSH_FUA, bio);
+	submit_bio(bio);
 }
 
 void md_super_wait(struct mddev *mddev)
@@ -755,6 +757,7 @@ int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 
 	bio->bi_bdev = (metadata_op && rdev->meta_bdev) ?
 		rdev->meta_bdev : rdev->bdev;
+	bio->bi_rw = rw;
 	if (metadata_op)
 		bio->bi_iter.bi_sector = sector + rdev->sb_start;
 	else if (rdev->mddev->reshape_position != MaxSector &&
@@ -764,7 +767,8 @@ int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 	else
 		bio->bi_iter.bi_sector = sector + rdev->data_offset;
 	bio_add_page(bio, page, size, 0);
-	submit_bio_wait(rw, bio);
+
+	submit_bio_wait(bio);
 
 	ret = !bio->bi_error;
 	bio_put(bio);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 4e3843f..f2d9c01 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2208,7 +2208,8 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 		bio_trim(wbio, sector - r1_bio->sector, sectors);
 		wbio->bi_iter.bi_sector += rdev->data_offset;
 		wbio->bi_bdev = rdev->bdev;
-		if (submit_bio_wait(WRITE, wbio) < 0)
+
+		if (submit_bio_wait(wbio) < 0)
 			/* failure! */
 			ok = rdev_set_badblocks(rdev, sector,
 						sectors, 0)
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 1c1447d..d0d84f3 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2474,7 +2474,9 @@ static int narrow_write_error(struct r10bio *r10_bio, int i)
 				   choose_data_offset(r10_bio, rdev) +
 				   (sector - r10_bio->sector));
 		wbio->bi_bdev = rdev->bdev;
-		if (submit_bio_wait(WRITE, wbio) < 0)
+		wbio->bi_rw = WRITE;
+
+		if (submit_bio_wait(wbio) < 0)
 			/* Failure! */
 			ok = rdev_set_badblocks(rdev, sector,
 						sectors, 0)
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 9531f5f..2d56fdc 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -254,7 +254,7 @@ static void r5l_submit_current_io(struct r5l_log *log)
 	__r5l_set_io_unit_state(io, IO_UNIT_IO_START);
 	spin_unlock_irqrestore(&log->io_list_lock, flags);
 
-	submit_bio(WRITE, io->current_bio);
+	submit_bio(io->current_bio);
 }
 
 static struct bio *r5l_bio_alloc(struct r5l_log *log)
@@ -373,7 +373,7 @@ static void r5l_append_payload_page(struct r5l_log *log, struct page *page)
 		io->current_bio = r5l_bio_alloc(log);
 		bio_chain(io->current_bio, prev);
 
-		submit_bio(WRITE, prev);
+		submit_bio(prev);
 	}
 
 	if (!bio_add_page(io->current_bio, page, PAGE_SIZE, 0))
@@ -686,7 +686,8 @@ void r5l_flush_stripe_to_raid(struct r5l_log *log)
 	bio_reset(&log->flush_bio);
 	log->flush_bio.bi_bdev = log->rdev->bdev;
 	log->flush_bio.bi_end_io = r5l_log_flush_endio;
-	submit_bio(WRITE_FLUSH, &log->flush_bio);
+	log->flush_bio.bi_rw = WRITE_FLUSH;
+	submit_bio(&log->flush_bio);
 }
 
 static void r5l_write_super(struct r5l_log *log, sector_t cp);
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index abe4eb9..c352a64 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -312,7 +312,7 @@ static void iblock_bio_done(struct bio *bio)
 }
 
 static struct bio *
-iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num)
+iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num, int rw)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(cmd->se_dev);
 	struct bio *bio;
@@ -334,18 +334,19 @@ iblock_get_bio(struct se_cmd *cmd, sector_t lba, u32 sg_num)
 	bio->bi_private = cmd;
 	bio->bi_end_io = &iblock_bio_done;
 	bio->bi_iter.bi_sector = lba;
+	bio->bi_rw = rw;
 
 	return bio;
 }
 
-static void iblock_submit_bios(struct bio_list *list, int rw)
+static void iblock_submit_bios(struct bio_list *list)
 {
 	struct blk_plug plug;
 	struct bio *bio;
 
 	blk_start_plug(&plug);
 	while ((bio = bio_list_pop(list)))
-		submit_bio(rw, bio);
+		submit_bio(bio);
 	blk_finish_plug(&plug);
 }
 
@@ -387,9 +388,10 @@ iblock_execute_sync_cache(struct se_cmd *cmd)
 	bio = bio_alloc(GFP_KERNEL, 0);
 	bio->bi_end_io = iblock_end_io_flush;
 	bio->bi_bdev = ib_dev->ibd_bd;
+	bio->bi_rw = WRITE_FLUSH;
 	if (!immed)
 		bio->bi_private = cmd;
-	submit_bio(WRITE_FLUSH, bio);
+	submit_bio(bio);
 	return 0;
 }
 
@@ -444,7 +446,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		goto fail;
 	cmd->priv = ibr;
 
-	bio = iblock_get_bio(cmd, block_lba, 1);
+	bio = iblock_get_bio(cmd, block_lba, 1, WRITE);
 	if (!bio)
 		goto fail_free_ibr;
 
@@ -457,7 +459,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		while (bio_add_page(bio, sg_page(sg), sg->length, sg->offset)
 				!= sg->length) {
 
-			bio = iblock_get_bio(cmd, block_lba, 1);
+			bio = iblock_get_bio(cmd, block_lba, 1, WRITE);
 			if (!bio)
 				goto fail_put_bios;
 
@@ -470,7 +472,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		sectors -= 1;
 	}
 
-	iblock_submit_bios(&list, WRITE);
+	iblock_submit_bios(&list);
 	return 0;
 
 fail_put_bios:
@@ -678,7 +680,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		return 0;
 	}
 
-	bio = iblock_get_bio(cmd, block_lba, sgl_nents);
+	bio = iblock_get_bio(cmd, block_lba, sgl_nents, rw);
 	if (!bio)
 		goto fail_free_ibr;
 
@@ -698,11 +700,11 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		while (bio_add_page(bio, sg_page(sg), sg->length, sg->offset)
 				!= sg->length) {
 			if (bio_cnt >= IBLOCK_MAX_BIO_PER_TASK) {
-				iblock_submit_bios(&list, rw);
+				iblock_submit_bios(&list);
 				bio_cnt = 0;
 			}
 
-			bio = iblock_get_bio(cmd, block_lba, sg_num);
+			bio = iblock_get_bio(cmd, block_lba, sg_num, rw);
 			if (!bio)
 				goto fail_put_bios;
 
@@ -722,7 +724,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 			goto fail_put_bios;
 	}
 
-	iblock_submit_bios(&list, rw);
+	iblock_submit_bios(&list);
 	iblock_complete_cmd(cmd);
 	return 0;
 
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 861d472..9c51373 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -1671,6 +1671,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 		}
 		bio->bi_bdev = block_ctx->dev->bdev;
 		bio->bi_iter.bi_sector = dev_bytenr >> 9;
+		bio->bi_rw = READ;
 
 		for (j = i; j < num_pages; j++) {
 			ret = bio_add_page(bio, block_ctx->pagev[j],
@@ -1683,7 +1684,7 @@ static int btrfsic_read_block(struct btrfsic_state *state,
 			       "btrfsic: error, failed to add a single page!\n");
 			return -1;
 		}
-		if (submit_bio_wait(READ, bio)) {
+		if (submit_bio_wait(bio)) {
 			printk(KERN_INFO
 			       "btrfsic: read error at logical %llu dev %s!\n",
 			       block_ctx->start, block_ctx->dev->name);
@@ -2916,9 +2917,10 @@ int btrfsic_submit_bh(int rw, struct buffer_head *bh)
 	return submit_bh(rw, bh);
 }
 
-static void __btrfsic_submit_bio(int rw, struct bio *bio)
+static void __btrfsic_submit_bio(struct bio *bio)
 {
 	struct btrfsic_dev_state *dev_state;
+	int rw = bio->bi_rw;
 
 	if (!btrfsic_is_initialized)
 		return;
@@ -3014,16 +3016,16 @@ leave:
 	mutex_unlock(&btrfsic_mutex);
 }
 
-void btrfsic_submit_bio(int rw, struct bio *bio)
+void btrfsic_submit_bio(struct bio *bio)
 {
-	__btrfsic_submit_bio(rw, bio);
-	submit_bio(rw, bio);
+	__btrfsic_submit_bio(bio);
+	submit_bio(bio);
 }
 
-int btrfsic_submit_bio_wait(int rw, struct bio *bio)
+int btrfsic_submit_bio_wait(struct bio *bio)
 {
-	__btrfsic_submit_bio(rw, bio);
-	return submit_bio_wait(rw, bio);
+	__btrfsic_submit_bio(bio);
+	return submit_bio_wait(bio);
 }
 
 int btrfsic_mount(struct btrfs_root *root,
diff --git a/fs/btrfs/check-integrity.h b/fs/btrfs/check-integrity.h
index 13b8566..c04e249 100644
--- a/fs/btrfs/check-integrity.h
+++ b/fs/btrfs/check-integrity.h
@@ -21,8 +21,8 @@
 
 #ifdef CONFIG_BTRFS_FS_CHECK_INTEGRITY
 int btrfsic_submit_bh(int rw, struct buffer_head *bh);
-void btrfsic_submit_bio(int rw, struct bio *bio);
-int btrfsic_submit_bio_wait(int rw, struct bio *bio);
+void btrfsic_submit_bio(struct bio *bio);
+int btrfsic_submit_bio_wait(struct bio *bio);
 #else
 #define btrfsic_submit_bh submit_bh
 #define btrfsic_submit_bio submit_bio
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 2f75069..3437390 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3470,12 +3470,13 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 
 	bio->bi_end_io = btrfs_end_empty_barrier;
 	bio->bi_bdev = device->bdev;
+	bio->bi_rw = WRITE_FLUSH;
 	init_completion(&device->flush_wait);
 	bio->bi_private = &device->flush_wait;
 	device->flush_bio = bio;
 
 	bio_get(bio);
-	btrfsic_submit_bio(WRITE_FLUSH, bio);
+	btrfsic_submit_bio(bio);
 
 	return 0;
 }
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 76a0c85..454100e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2040,9 +2040,10 @@ int repair_io_failure(struct inode *inode, u64 start, u64 length, u64 logical,
 		return -EIO;
 	}
 	bio->bi_bdev = dev->bdev;
+	bio->bi_rw = WRITE_SYNC;
 	bio_add_page(bio, page, length, pg_offset);
 
-	if (btrfsic_submit_bio_wait(WRITE_SYNC, bio)) {
+	if (btrfsic_submit_bio_wait(bio)) {
 		/* try to remap that extent elsewhere? */
 		bio_put(bio);
 		btrfs_dev_stat_inc_and_print(dev, BTRFS_DEV_STAT_WRITE_ERRS);
@@ -2725,14 +2726,14 @@ static int __must_check submit_one_bio(int rw, struct bio *bio,
 	start = page_offset(page) + bvec->bv_offset;
 
 	bio->bi_private = NULL;
-
+	bio->bi_rw = rw;
 	bio_get(bio);
 
 	if (tree->ops && tree->ops->submit_bio_hook)
 		ret = tree->ops->submit_bio_hook(page->mapping->host, rw, bio,
 					   mirror_num, bio_flags, start);
 	else
-		btrfsic_submit_bio(rw, bio);
+		btrfsic_submit_bio(bio);
 
 	bio_put(bio);
 	return ret;
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index 5516136..a8e66e4 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -1320,7 +1320,9 @@ write_data:
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_write_end_io;
-		submit_bio(WRITE, bio);
+		bio->bi_rw = WRITE;
+
+		submit_bio(bio);
 	}
 	return;
 
@@ -1573,11 +1575,12 @@ static int raid56_rmw_stripe(struct btrfs_raid_bio *rbio)
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_rmw_end_io;
+		bio->bi_rw = READ;
 
 		btrfs_bio_wq_end_io(rbio->fs_info, bio,
 				    BTRFS_WQ_ENDIO_RAID56);
 
-		submit_bio(READ, bio);
+		submit_bio(bio);
 	}
 	/* the actual write will happen once the reads are done */
 	return 0;
@@ -2097,11 +2100,12 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_recover_end_io;
+		bio->bi_rw = READ;
 
 		btrfs_bio_wq_end_io(rbio->fs_info, bio,
 				    BTRFS_WQ_ENDIO_RAID56);
 
-		submit_bio(READ, bio);
+		submit_bio(bio);
 	}
 out:
 	return 0;
@@ -2433,7 +2437,9 @@ submit_write:
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_write_end_io;
-		submit_bio(WRITE, bio);
+		bio->bi_rw = WRITE;
+
+		submit_bio(bio);
 	}
 	return;
 
@@ -2610,11 +2616,12 @@ static void raid56_parity_scrub_stripe(struct btrfs_raid_bio *rbio)
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid56_parity_scrub_end_io;
+		bio->bi_rw = READ;
 
 		btrfs_bio_wq_end_io(rbio->fs_info, bio,
 				    BTRFS_WQ_ENDIO_RAID56);
 
-		submit_bio(READ, bio);
+		submit_bio(bio);
 	}
 	/* the actual write will happen once the reads are done */
 	return;
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index e42aa27..8315947 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -1504,8 +1504,9 @@ static void scrub_recheck_block(struct btrfs_fs_info *fs_info,
 				sblock->no_io_error_seen = 0;
 		} else {
 			bio->bi_iter.bi_sector = page->physical >> 9;
+			bio->bi_rw = READ;
 
-			if (btrfsic_submit_bio_wait(READ, bio))
+			if (btrfsic_submit_bio_wait(bio))
 				sblock->no_io_error_seen = 0;
 		}
 
@@ -1583,6 +1584,7 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 			return -EIO;
 		bio->bi_bdev = page_bad->dev->bdev;
 		bio->bi_iter.bi_sector = page_bad->physical >> 9;
+		bio->bi_rw = WRITE;
 
 		ret = bio_add_page(bio, page_good->page, PAGE_SIZE, 0);
 		if (PAGE_SIZE != ret) {
@@ -1590,7 +1592,7 @@ static int scrub_repair_page_from_good_copy(struct scrub_block *sblock_bad,
 			return -EIO;
 		}
 
-		if (btrfsic_submit_bio_wait(WRITE, bio)) {
+		if (btrfsic_submit_bio_wait(bio)) {
 			btrfs_dev_stat_inc_and_print(page_bad->dev,
 				BTRFS_DEV_STAT_WRITE_ERRS);
 			btrfs_dev_replace_stats_inc(
@@ -1684,6 +1686,7 @@ again:
 		bio->bi_end_io = scrub_wr_bio_end_io;
 		bio->bi_bdev = sbio->dev->bdev;
 		bio->bi_iter.bi_sector = sbio->physical >> 9;
+		bio->bi_rw = WRITE;
 		sbio->err = 0;
 	} else if (sbio->physical + sbio->page_count * PAGE_SIZE !=
 		   spage->physical_for_dev_replace ||
@@ -1731,7 +1734,7 @@ static void scrub_wr_submit(struct scrub_ctx *sctx)
 	 * orders the requests before sending them to the driver which
 	 * doubled the write performance on spinning disks when measured
 	 * with Linux 3.5 */
-	btrfsic_submit_bio(WRITE, sbio->bio);
+	btrfsic_submit_bio(sbio->bio);
 }
 
 static void scrub_wr_bio_end_io(struct bio *bio)
@@ -2041,7 +2044,7 @@ static void scrub_submit(struct scrub_ctx *sctx)
 	sbio = sctx->bios[sctx->curr];
 	sctx->curr = -1;
 	scrub_pending_bio_inc(sctx);
-	btrfsic_submit_bio(READ, sbio->bio);
+	btrfsic_submit_bio(sbio->bio);
 }
 
 static int scrub_add_page_to_rd_bio(struct scrub_ctx *sctx,
@@ -2088,6 +2091,7 @@ again:
 		bio->bi_end_io = scrub_bio_end_io;
 		bio->bi_bdev = sbio->dev->bdev;
 		bio->bi_iter.bi_sector = sbio->physical >> 9;
+		bio->bi_rw = READ;
 		sbio->err = 0;
 	} else if (sbio->physical + sbio->page_count * PAGE_SIZE !=
 		   spage->physical ||
@@ -4390,6 +4394,8 @@ static int write_page_nocow(struct scrub_ctx *sctx,
 	bio->bi_iter.bi_size = 0;
 	bio->bi_iter.bi_sector = physical_for_dev_replace >> 9;
 	bio->bi_bdev = dev->bdev;
+	bio->bi_rw = WRITE_SYNC;
+
 	ret = bio_add_page(bio, page, PAGE_CACHE_SIZE, 0);
 	if (ret != PAGE_CACHE_SIZE) {
 leave_with_eio:
@@ -4398,7 +4404,7 @@ leave_with_eio:
 		return -EIO;
 	}
 
-	if (btrfsic_submit_bio_wait(WRITE_SYNC, bio))
+	if (btrfsic_submit_bio_wait(bio))
 		goto leave_with_eio;
 
 	bio_put(bio);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index d883278..f87678f 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -462,7 +462,7 @@ loop_lock:
 			sync_pending = 0;
 		}
 
-		btrfsic_submit_bio(cur->bi_rw, cur);
+		btrfsic_submit_bio(cur);
 		num_run++;
 		batch_run++;
 
@@ -5933,7 +5933,7 @@ static void btrfs_end_bio(struct bio *bio)
  */
 static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 					struct btrfs_device *device,
-					int rw, struct bio *bio)
+					struct bio *bio)
 {
 	int should_queue = 1;
 	struct btrfs_pending_bios *pending_bios;
@@ -5944,9 +5944,9 @@ static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 	}
 
 	/* don't bother with additional async steps for reads, right now */
-	if (!(rw & REQ_WRITE)) {
+	if (!(bio->bi_rw & REQ_WRITE)) {
 		bio_get(bio);
-		btrfsic_submit_bio(rw, bio);
+		btrfsic_submit_bio(bio);
 		bio_put(bio);
 		return;
 	}
@@ -5960,7 +5960,6 @@ static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 	atomic_inc(&root->fs_info->nr_async_bios);
 	WARN_ON(bio->bi_next);
 	bio->bi_next = NULL;
-	bio->bi_rw |= rw;
 
 	spin_lock(&device->io_lock);
 	if (bio->bi_rw & REQ_SYNC)
@@ -5994,6 +5993,7 @@ static void submit_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
 	btrfs_io_bio(bio)->stripe_index = dev_nr;
 	bio->bi_end_io = btrfs_end_bio;
 	bio->bi_iter.bi_sector = physical >> 9;
+	bio->bi_rw |= rw;
 #ifdef DEBUG
 	{
 		struct rcu_string *name;
@@ -6012,9 +6012,9 @@ static void submit_stripe_bio(struct btrfs_root *root, struct btrfs_bio *bbio,
 	btrfs_bio_counter_inc_noblocked(root->fs_info);
 
 	if (async)
-		btrfs_schedule_bio(root, dev, rw, bio);
+		btrfs_schedule_bio(root, dev, bio);
 	else
-		btrfsic_submit_bio(rw, bio);
+		btrfsic_submit_bio(bio);
 }
 
 static void bbio_error(struct btrfs_bio *bbio, struct bio *bio, u64 logical)
diff --git a/fs/buffer.c b/fs/buffer.c
index 33be296..ef70d65 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3030,8 +3030,9 @@ static int submit_bh_wbc(int rw, struct buffer_head *bh,
 		rw |= REQ_META;
 	if (buffer_prio(bh))
 		rw |= REQ_PRIO;
+	bio->bi_rw = rw;
 
-	submit_bio(rw, bio);
+	submit_bio(bio);
 	return 0;
 }
 
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 7487174..1bce5c3 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -374,6 +374,7 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 
 	bio->bi_bdev = bdev;
 	bio->bi_iter.bi_sector = first_sector;
+	bio->bi_rw = dio->rw;
 	if (dio->is_async)
 		bio->bi_end_io = dio_bio_end_aio;
 	else
@@ -411,7 +412,7 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 			       sdio->logical_offset_in_bio);
 		dio->bio_cookie = BLK_QC_T_NONE;
 	} else
-		dio->bio_cookie = submit_bio(dio->rw, bio);
+		dio->bio_cookie = submit_bio(bio);
 
 	sdio->bio = NULL;
 	sdio->boundary = 0;
diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index edc053a..18b8893 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -422,6 +422,7 @@ int ext4_encrypted_zeroout(struct inode *inode, ext4_lblk_t lblk,
 		bio->bi_bdev = inode->i_sb->s_bdev;
 		bio->bi_iter.bi_sector =
 			pblk << (inode->i_sb->s_blocksize_bits - 9);
+		bio->bi_rw = WRITE;
 		ret = bio_add_page(bio, ciphertext_page,
 				   inode->i_sb->s_blocksize, 0);
 		if (ret != inode->i_sb->s_blocksize) {
@@ -433,7 +434,7 @@ int ext4_encrypted_zeroout(struct inode *inode, ext4_lblk_t lblk,
 			err = -EIO;
 			goto errout;
 		}
-		err = submit_bio_wait(WRITE, bio);
+		err = submit_bio_wait(bio);
 		if ((err == 0) && bio->bi_error)
 			err = -EIO;
 		bio_put(bio);
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 090b349..cf63ac3 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -356,7 +356,8 @@ void ext4_io_submit(struct ext4_io_submit *io)
 		int io_op = io->io_wbc->sync_mode == WB_SYNC_ALL ?
 			    WRITE_SYNC : WRITE;
 		bio_get(io->io_bio);
-		submit_bio(io_op, io->io_bio);
+		io->io_bio->bi_rw = io_op;
+		submit_bio(io->io_bio);
 		bio_put(io->io_bio);
 	}
 	io->io_bio = NULL;
diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index 5dc5e95..893dc15 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -271,7 +271,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
 		 */
 		if (bio && (last_block_in_bio != blocks[0] - 1)) {
 		submit_and_realloc:
-			submit_bio(READ, bio);
+			submit_bio(bio);
 			bio = NULL;
 		}
 		if (bio == NULL) {
@@ -294,6 +294,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
 			bio->bi_iter.bi_sector = blocks[0] << (blkbits - 9);
 			bio->bi_end_io = mpage_end_io;
 			bio->bi_private = ctx;
+			bio->bi_rw = READ;
 		}
 
 		length = first_hole << blkbits;
@@ -303,14 +304,14 @@ int ext4_mpage_readpages(struct address_space *mapping,
 		if (((map.m_flags & EXT4_MAP_BOUNDARY) &&
 		     (relative_block == map.m_len)) ||
 		    (first_hole != blocks_per_page)) {
-			submit_bio(READ, bio);
+			submit_bio(bio);
 			bio = NULL;
 		} else
 			last_block_in_bio = blocks[blocks_per_page - 1];
 		goto next_page;
 	confused:
 		if (bio) {
-			submit_bio(READ, bio);
+			submit_bio(bio);
 			bio = NULL;
 		}
 		if (!PageUptodate(page))
@@ -323,6 +324,6 @@ int ext4_mpage_readpages(struct address_space *mapping,
 	}
 	BUG_ON(pages && !list_empty(pages));
 	if (bio)
-		submit_bio(READ, bio);
+		submit_bio(bio);
 	return 0;
 }
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index a6e7133..ff623b2 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -109,8 +109,9 @@ static void __submit_merged_bio(struct f2fs_bio_info *io)
 		trace_f2fs_submit_read_bio(io->sbi->sb, fio, io->bio);
 	else
 		trace_f2fs_submit_write_bio(io->sbi->sb, fio, io->bio);
+	io->bio->bi_rw = fio->rw;
 
-	submit_bio(fio->rw, io->bio);
+	submit_bio(io->bio);
 	io->bio = NULL;
 }
 
@@ -220,8 +221,9 @@ int f2fs_submit_page_bio(struct f2fs_io_info *fio)
 		bio_put(bio);
 		return -EFAULT;
 	}
+	bio->bi_rw = fio->rw;
 
-	submit_bio(fio->rw, bio);
+	submit_bio(bio);
 	return 0;
 }
 
@@ -969,7 +971,7 @@ got_it:
 		 */
 		if (bio && (last_block_in_bio != block_nr - 1)) {
 submit_and_realloc:
-			submit_bio(READ, bio);
+			submit_bio(bio);
 			bio = NULL;
 		}
 		if (bio == NULL) {
@@ -998,6 +1000,7 @@ submit_and_realloc:
 			bio->bi_iter.bi_sector = SECTOR_FROM_BLOCK(block_nr);
 			bio->bi_end_io = f2fs_read_end_io;
 			bio->bi_private = ctx;
+			bio->bi_rw = READ;
 		}
 
 		if (bio_add_page(bio, page, blocksize, 0) < blocksize)
@@ -1012,7 +1015,7 @@ set_error_page:
 		goto next_page;
 confused:
 		if (bio) {
-			submit_bio(READ, bio);
+			submit_bio(bio);
 			bio = NULL;
 		}
 		unlock_page(page);
@@ -1022,7 +1025,7 @@ next_page:
 	}
 	BUG_ON(pages && !list_empty(pages));
 	if (bio)
-		submit_bio(READ, bio);
+		submit_bio(bio);
 	return 0;
 }
 
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index d8e13b0..34e99fe 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -402,7 +402,8 @@ repeat:
 		fcc->dispatch_list = llist_reverse_order(fcc->dispatch_list);
 
 		bio->bi_bdev = sbi->sb->s_bdev;
-		ret = submit_bio_wait(WRITE_FLUSH, bio);
+		bio->bi_rw = WRITE_FLUSH;
+		ret = submit_bio_wait(bio);
 
 		llist_for_each_entry_safe(cmd, next,
 					  fcc->dispatch_list, llnode) {
@@ -434,7 +435,8 @@ int f2fs_issue_flush(struct f2fs_sb_info *sbi)
 		int ret;
 
 		bio->bi_bdev = sbi->sb->s_bdev;
-		ret = submit_bio_wait(WRITE_FLUSH, bio);
+		bio->bi_rw = WRITE_FLUSH;
+		ret = submit_bio_wait(bio);
 		bio_put(bio);
 		return ret;
 	}
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index d5369a1..ce28242 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -240,7 +240,8 @@ void gfs2_log_flush_bio(struct gfs2_sbd *sdp, int rw)
 {
 	if (sdp->sd_log_bio) {
 		atomic_inc(&sdp->sd_log_in_flight);
-		submit_bio(rw, sdp->sd_log_bio);
+		sdp->sd_log_bio->bi_rw = rw;
+		submit_bio(sdp->sd_log_bio);
 		sdp->sd_log_bio = NULL;
 	}
 }
diff --git a/fs/gfs2/meta_io.c b/fs/gfs2/meta_io.c
index e137d96..87a3abc 100644
--- a/fs/gfs2/meta_io.c
+++ b/fs/gfs2/meta_io.c
@@ -230,7 +230,8 @@ static void gfs2_submit_bhs(int rw, struct buffer_head *bhs[], int num)
 		bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh));
 	}
 	bio->bi_end_io = gfs2_meta_read_endio;
-	submit_bio(rw, bio);
+	bio->bi_rw = rw;
+	submit_bio(bio);
 }
 
 /**
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index dbed9e2..4872a61 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -246,7 +246,8 @@ static int gfs2_read_super(struct gfs2_sbd *sdp, sector_t sector, int silent)
 
 	bio->bi_end_io = end_bio_io_page;
 	bio->bi_private = page;
-	submit_bio(READ_SYNC | REQ_META, bio);
+	bio->bi_rw = READ_SYNC | REQ_META;
+	submit_bio(bio);
 	wait_on_page_locked(page);
 	bio_put(bio);
 	if (!PageUptodate(page)) {
diff --git a/fs/hfsplus/wrapper.c b/fs/hfsplus/wrapper.c
index cc62356..d026bb3 100644
--- a/fs/hfsplus/wrapper.c
+++ b/fs/hfsplus/wrapper.c
@@ -65,6 +65,7 @@ int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
 	bio = bio_alloc(GFP_NOIO, 1);
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_bdev = sb->s_bdev;
+	bio->bi_rw = rw;
 
 	if (!(rw & WRITE) && data)
 		*data = (u8 *)buf + offset;
@@ -83,7 +84,7 @@ int hfsplus_submit_bio(struct super_block *sb, sector_t sector,
 		buf = (u8 *)buf + len;
 	}
 
-	ret = submit_bio_wait(rw, bio);
+	ret = submit_bio_wait(bio);
 out:
 	bio_put(bio);
 	return ret < 0 ? ret : 0;
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index a270cb7..b0e068f 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2004,12 +2004,13 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 
 	bio->bi_end_io = lbmIODone;
 	bio->bi_private = bp;
+	bio->bi_rw = READ_SYNC;
 	/*check if journaling to disk has been disabled*/
 	if (log->no_integrity) {
 		bio->bi_iter.bi_size = 0;
 		lbmIODone(bio);
 	} else {
-		submit_bio(READ_SYNC, bio);
+		submit_bio(bio);
 	}
 
 	wait_event(bp->l_ioevent, (bp->l_flag != lbmREAD));
@@ -2147,13 +2148,14 @@ static void lbmStartIO(struct lbuf * bp)
 
 	bio->bi_end_io = lbmIODone;
 	bio->bi_private = bp;
+	bio->bi_rw = WRITE_SYNC;
 
 	/* check if journaling to disk has been disabled */
 	if (log->no_integrity) {
 		bio->bi_iter.bi_size = 0;
 		lbmIODone(bio);
 	} else {
-		submit_bio(WRITE_SYNC, bio);
+		submit_bio(bio);
 		INCREMENT(lmStat.submitted);
 	}
 }
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index a3eb316..bc29972 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -411,7 +411,7 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
 			inc_io(page);
 			if (!bio->bi_iter.bi_size)
 				goto dump_bio;
-			submit_bio(WRITE, bio);
+			submit_bio(bio);
 			nr_underway++;
 			bio = NULL;
 		} else
@@ -434,6 +434,7 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
 		bio->bi_iter.bi_sector = pblock << (inode->i_blkbits - 9);
 		bio->bi_end_io = metapage_write_end_io;
 		bio->bi_private = page;
+		bio->bi_rw = WRITE;
 
 		/* Don't call bio_add_page yet, we may add to this vec */
 		bio_offset = offset;
@@ -448,7 +449,7 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
 		if (!bio->bi_iter.bi_size)
 			goto dump_bio;
 
-		submit_bio(WRITE, bio);
+		submit_bio(bio);
 		nr_underway++;
 	}
 	if (redirty)
@@ -506,7 +507,7 @@ static int metapage_readpage(struct file *fp, struct page *page)
 				insert_metapage(page, NULL);
 			inc_io(page);
 			if (bio)
-				submit_bio(READ, bio);
+				submit_bio(bio);
 
 			bio = bio_alloc(GFP_NOFS, 1);
 			bio->bi_bdev = inode->i_sb->s_bdev;
@@ -514,6 +515,7 @@ static int metapage_readpage(struct file *fp, struct page *page)
 				pblock << (inode->i_blkbits - 9);
 			bio->bi_end_io = metapage_read_end_io;
 			bio->bi_private = page;
+			bio->bi_rw = READ;
 			len = xlen << inode->i_blkbits;
 			offset = block_offset << inode->i_blkbits;
 			if (bio_add_page(bio, page, len, offset) < len)
@@ -523,7 +525,7 @@ static int metapage_readpage(struct file *fp, struct page *page)
 			block_offset++;
 	}
 	if (bio)
-		submit_bio(READ, bio);
+		submit_bio(bio);
 	else
 		unlock_page(page);
 
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index a709d80..9e690ad 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -29,8 +29,9 @@ static int sync_request(struct page *page, struct block_device *bdev, int rw)
 	bio.bi_bdev = bdev;
 	bio.bi_iter.bi_sector = page->index * (PAGE_SIZE >> 9);
 	bio.bi_iter.bi_size = PAGE_SIZE;
+	bio.bi_rw = rw;
 
-	return submit_bio_wait(rw, &bio);
+	return submit_bio_wait(&bio);
 }
 
 static int bdev_readpage(void *_sb, struct page *page)
@@ -95,8 +96,9 @@ static int __bdev_writeseg(struct super_block *sb, u64 ofs, pgoff_t index,
 			bio->bi_iter.bi_sector = ofs >> 9;
 			bio->bi_private = sb;
 			bio->bi_end_io = writeseg_end_io;
+			bio->bi_rw = WRITE;
 			atomic_inc(&super->s_pending_writes);
-			submit_bio(WRITE, bio);
+			submit_bio(bio);
 
 			ofs += i * PAGE_SIZE;
 			index += i;
@@ -122,8 +124,9 @@ static int __bdev_writeseg(struct super_block *sb, u64 ofs, pgoff_t index,
 	bio->bi_iter.bi_sector = ofs >> 9;
 	bio->bi_private = sb;
 	bio->bi_end_io = writeseg_end_io;
+	bio->bi_rw = WRITE;
 	atomic_inc(&super->s_pending_writes);
-	submit_bio(WRITE, bio);
+	submit_bio(bio);
 	return 0;
 }
 
@@ -185,8 +188,9 @@ static int do_erase(struct super_block *sb, u64 ofs, pgoff_t index,
 			bio->bi_iter.bi_sector = ofs >> 9;
 			bio->bi_private = sb;
 			bio->bi_end_io = erase_end_io;
+			bio->bi_rw = WRITE;
 			atomic_inc(&super->s_pending_writes);
-			submit_bio(WRITE, bio);
+			submit_bio(bio);
 
 			ofs += i * PAGE_SIZE;
 			index += i;
@@ -206,8 +210,9 @@ static int do_erase(struct super_block *sb, u64 ofs, pgoff_t index,
 	bio->bi_iter.bi_sector = ofs >> 9;
 	bio->bi_private = sb;
 	bio->bi_end_io = erase_end_io;
+	bio->bi_rw = WRITE;
 	atomic_inc(&super->s_pending_writes);
-	submit_bio(WRITE, bio);
+	submit_bio(bio);
 	return 0;
 }
 
diff --git a/fs/mpage.c b/fs/mpage.c
index 6bd9fd9..9479e73 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -59,8 +59,9 @@ static void mpage_end_io(struct bio *bio)
 static struct bio *mpage_bio_submit(int rw, struct bio *bio)
 {
 	bio->bi_end_io = mpage_end_io;
+	bio->bi_rw = rw;
 	guard_bio_eod(rw, bio);
-	submit_bio(rw, bio);
+	submit_bio(bio);
 	return NULL;
 }
 
diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index ddd0138..8c0443c 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -102,14 +102,15 @@ static inline void put_parallel(struct parallel_io *p)
 }
 
 static struct bio *
-bl_submit_bio(int rw, struct bio *bio)
+bl_submit_bio(struct bio *bio)
 {
 	if (bio) {
 		get_parallel(bio->bi_private);
 		dprintk("%s submitting %s bio %u@%llu\n", __func__,
-			rw == READ ? "read" : "write", bio->bi_iter.bi_size,
+			bio->bi_rw == READ ? "read" : "write",
+			bio->bi_iter.bi_size,
 			(unsigned long long)bio->bi_iter.bi_sector);
-		submit_bio(rw, bio);
+		submit_bio(bio);
 	}
 	return NULL;
 }
@@ -158,7 +159,7 @@ do_add_page_to_bio(struct bio *bio, int npg, int rw, sector_t isect,
 	if (disk_addr < map->start || disk_addr >= map->start + map->len) {
 		if (!dev->map(dev, disk_addr, map))
 			return ERR_PTR(-EIO);
-		bio = bl_submit_bio(rw, bio);
+		bio = bl_submit_bio(bio);
 	}
 	disk_addr += map->disk_offset;
 	disk_addr -= map->start;
@@ -174,9 +175,10 @@ retry:
 				disk_addr >> SECTOR_SHIFT, end_io, par);
 		if (!bio)
 			return ERR_PTR(-ENOMEM);
+		bio->bi_rw = rw;
 	}
 	if (bio_add_page(bio, page, *len, offset) < *len) {
-		bio = bl_submit_bio(rw, bio);
+		bio = bl_submit_bio(bio);
 		goto retry;
 	}
 	return bio;
@@ -252,7 +254,7 @@ bl_read_pagelist(struct nfs_pgio_header *header)
 	for (i = pg_index; i < header->page_array.npages; i++) {
 		if (extent_length <= 0) {
 			/* We've used up the previous extent */
-			bio = bl_submit_bio(READ, bio);
+			bio = bl_submit_bio(bio);
 
 			/* Get the next one */
 			if (!ext_tree_lookup(bl, isect, &be, false)) {
@@ -273,7 +275,7 @@ bl_read_pagelist(struct nfs_pgio_header *header)
 		}
 
 		if (is_hole(&be)) {
-			bio = bl_submit_bio(READ, bio);
+			bio = bl_submit_bio(bio);
 			/* Fill hole w/ zeroes w/o accessing device */
 			dprintk("%s Zeroing page for hole\n", __func__);
 			zero_user_segment(pages[i], pg_offset, pg_len);
@@ -306,7 +308,7 @@ bl_read_pagelist(struct nfs_pgio_header *header)
 		header->res.count = (isect << SECTOR_SHIFT) - header->args.offset;
 	}
 out:
-	bl_submit_bio(READ, bio);
+	bl_submit_bio(bio);
 	blk_finish_plug(&plug);
 	put_parallel(par);
 	return PNFS_ATTEMPTED;
@@ -398,7 +400,7 @@ bl_write_pagelist(struct nfs_pgio_header *header, int sync)
 	for (i = pg_index; i < header->page_array.npages; i++) {
 		if (extent_length <= 0) {
 			/* We've used up the previous extent */
-			bio = bl_submit_bio(WRITE, bio);
+			bio = bl_submit_bio(bio);
 			/* Get the next one */
 			if (!ext_tree_lookup(bl, isect, &be, true)) {
 				header->pnfs_error = -EINVAL;
@@ -427,7 +429,7 @@ bl_write_pagelist(struct nfs_pgio_header *header, int sync)
 
 	header->res.count = header->args.count;
 out:
-	bl_submit_bio(WRITE, bio);
+	bl_submit_bio(bio);
 	blk_finish_plug(&plug);
 	put_parallel(par);
 	return PNFS_ATTEMPTED;
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index f63620c..7666f1d 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -368,7 +368,8 @@ static int nilfs_segbuf_submit_bio(struct nilfs_segment_buffer *segbuf,
 
 	bio->bi_end_io = nilfs_end_bio_write;
 	bio->bi_private = segbuf;
-	submit_bio(mode, bio);
+	bio->bi_rw = mode;
+	submit_bio(bio);
 	segbuf->sb_nbio++;
 
 	wi->bio = NULL;
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 1d3bf9e..bbc6203 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -531,7 +531,7 @@ static void o2hb_bio_end_io(struct bio *bio)
 static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 				      struct o2hb_bio_wait_ctxt *wc,
 				      unsigned int *current_slot,
-				      unsigned int max_slots)
+				      unsigned int max_slots, int rw)
 {
 	int len, current_page;
 	unsigned int vec_len, vec_start;
@@ -557,6 +557,7 @@ static struct bio *o2hb_setup_one_bio(struct o2hb_region *reg,
 	bio->bi_bdev = reg->hr_bdev;
 	bio->bi_private = wc;
 	bio->bi_end_io = o2hb_bio_end_io;
+	bio->bi_rw = rw;
 
 	vec_start = (cs << bits) % PAGE_CACHE_SIZE;
 	while(cs < max_slots) {
@@ -592,7 +593,8 @@ static int o2hb_read_slots(struct o2hb_region *reg,
 	o2hb_bio_wait_init(&wc);
 
 	while(current_slot < max_slots) {
-		bio = o2hb_setup_one_bio(reg, &wc, &current_slot, max_slots);
+		bio = o2hb_setup_one_bio(reg, &wc, &current_slot, max_slots,
+					 READ);
 		if (IS_ERR(bio)) {
 			status = PTR_ERR(bio);
 			mlog_errno(status);
@@ -600,7 +602,7 @@ static int o2hb_read_slots(struct o2hb_region *reg,
 		}
 
 		atomic_inc(&wc.wc_num_reqs);
-		submit_bio(READ, bio);
+		submit_bio(bio);
 	}
 
 	status = 0;
@@ -624,7 +626,7 @@ static int o2hb_issue_node_write(struct o2hb_region *reg,
 
 	slot = o2nm_this_node();
 
-	bio = o2hb_setup_one_bio(reg, write_wc, &slot, slot+1);
+	bio = o2hb_setup_one_bio(reg, write_wc, &slot, slot+1, WRITE_SYNC);
 	if (IS_ERR(bio)) {
 		status = PTR_ERR(bio);
 		mlog_errno(status);
@@ -632,7 +634,7 @@ static int o2hb_issue_node_write(struct o2hb_region *reg,
 	}
 
 	atomic_inc(&write_wc->wc_num_reqs);
-	submit_bio(WRITE_SYNC, bio);
+	submit_bio(bio);
 
 	status = 0;
 bail:
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index a378373..9cd38d1 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -393,7 +393,8 @@ xfs_submit_ioend_bio(
 	atomic_inc(&ioend->io_remaining);
 	bio->bi_private = ioend;
 	bio->bi_end_io = xfs_end_bio;
-	submit_bio(wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE, bio);
+	bio->bi_rw = (wbc->sync_mode == WB_SYNC_ALL ? WRITE_SYNC : WRITE);
+	submit_bio(bio);
 }
 
 STATIC struct bio *
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 9a2191b..079bb77 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1170,7 +1170,7 @@ next_chunk:
 	bio->bi_iter.bi_sector = sector;
 	bio->bi_end_io = xfs_buf_bio_end_io;
 	bio->bi_private = bp;
-
+	bio->bi_rw = rw;
 
 	for (; size && nr_pages; nr_pages--, page_index++) {
 		int	rbytes, nbytes = PAGE_SIZE - offset;
@@ -1194,7 +1194,7 @@ next_chunk:
 			flush_kernel_vmap_range(bp->b_addr,
 						xfs_buf_vmap_len(bp));
 		}
-		submit_bio(rw, bio);
+		submit_bio(bio);
 		if (size)
 			goto next_chunk;
 	} else {
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 5349e68..9f0e2cf 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -441,7 +441,7 @@ static inline void bio_io_error(struct bio *bio)
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
-extern int submit_bio_wait(int rw, struct bio *bio);
+extern int submit_bio_wait(struct bio *bio);
 extern void bio_advance(struct bio *, unsigned);
 
 extern void bio_init(struct bio *);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2a15fe2..3d9fdf4 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2686,7 +2686,7 @@ static inline void remove_inode_hash(struct inode *inode)
 extern void inode_sb_list_add(struct inode *inode);
 
 #ifdef CONFIG_BLOCK
-extern blk_qc_t submit_bio(int, struct bio *);
+extern blk_qc_t submit_bio(struct bio *);
 extern int bdev_read_only(struct block_device *);
 #endif
 extern int set_blocksize(struct block_device *, int);
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 12cd989..4d050eb 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -260,6 +260,7 @@ static int hib_submit_io(int rw, pgoff_t page_off, void *addr,
 	bio = bio_alloc(__GFP_RECLAIM | __GFP_HIGH, 1);
 	bio->bi_iter.bi_sector = page_off * (PAGE_SIZE >> 9);
 	bio->bi_bdev = hib_resume_bdev;
+	bio->bi_rw = rw;
 
 	if (bio_add_page(bio, page, PAGE_SIZE, 0) < PAGE_SIZE) {
 		printk(KERN_ERR "PM: Adding page to bio failed at %llu\n",
@@ -272,9 +273,9 @@ static int hib_submit_io(int rw, pgoff_t page_off, void *addr,
 		bio->bi_end_io = hib_end_io;
 		bio->bi_private = hb;
 		atomic_inc(&hb->count);
-		submit_bio(rw, bio);
+		submit_bio(bio);
 	} else {
-		error = submit_bio_wait(rw, bio);
+		error = submit_bio_wait(bio);
 		bio_put(bio);
 	}
 
diff --git a/mm/page_io.c b/mm/page_io.c
index b995a5b..e8a18a7 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -253,7 +253,7 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		bio_end_io_t end_write_func)
 {
 	struct bio *bio;
-	int ret, rw = WRITE;
+	int ret;
 	struct swap_info_struct *sis = page_swap_info(page);
 
 	if (sis->flags & SWP_FILE) {
@@ -311,12 +311,13 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		ret = -ENOMEM;
 		goto out;
 	}
+	bio->bi_rw = WRITE;
 	if (wbc->sync_mode == WB_SYNC_ALL)
-		rw |= REQ_SYNC;
+		bio->bi_rw |= REQ_SYNC;
 	count_vm_event(PSWPOUT);
 	set_page_writeback(page);
 	unlock_page(page);
-	submit_bio(rw, bio);
+	submit_bio(bio);
 out:
 	return ret;
 }
@@ -358,8 +359,9 @@ int swap_readpage(struct page *page)
 		ret = -ENOMEM;
 		goto out;
 	}
+	bio->bi_rw = READ;
 	count_vm_event(PSWPIN);
-	submit_bio(READ, bio);
+	submit_bio(bio);
 out:
 	return ret;
 }
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
