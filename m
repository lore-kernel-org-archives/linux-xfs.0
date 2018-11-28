Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50952 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726894AbeK1Owl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 28 Nov 2018 09:52:41 -0500
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v1 2/7] block: expand write_hint of bio/request to rw_hint
Date: Tue, 27 Nov 2018 20:49:46 -0700
Message-Id: <1543376991-5764-3-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
References: <1543376991-5764-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-block@vger.kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: martin.petersen@oracle.com, shirley.ma@oracle.com, bob.liu@oracle.com, allison.henderson@oracle.com

From: Bob Liu <bob.liu@oracle.com>

Write_hint was expanded to rw_hint in order to to alternative mirror device
retry.

* Renaming @bi_write_hint in 'struct bio' to @bi_rw_hint, and @write_hint
  in 'struct request' to @rw_hint.

* Making @bi_rw_hint only be updated for WRITE IO. It isn't a problem before
  because READ didn't use this hint at all.

* Setting @bi_rw_hint to specify which mirror to read from by force.

* Recording which mirror i/o really went to. This is because lower layer
  e.g MD/radi1 driver may have optimization to spread i/o on different copies,
  Upper layer e.g fs doesn't have idea data was reading from which device/mirror,
  so as can not start retry.

Todo:
 - Eat no more than 3-4 of the hint bits since most devices won't have more than
   8-16 mirrors.

Signed-off-by: Bob Liu <bob.liu@oracle.com>
---
 Documentation/block/biodoc.txt |  7 +++++++
 block/bio.c                    |  2 +-
 block/blk-core.c               | 10 +++++++++-
 block/blk-merge.c              |  8 ++++----
 block/bounce.c                 |  2 +-
 drivers/md/raid1.c             |  2 +-
 drivers/md/raid5.c             | 10 +++++-----
 drivers/md/raid5.h             |  2 +-
 drivers/nvme/host/core.c       |  2 +-
 fs/block_dev.c                 |  6 ++++--
 fs/btrfs/extent_io.c           |  3 ++-
 fs/buffer.c                    |  3 ++-
 fs/direct-io.c                 |  3 ++-
 fs/ext4/page-io.c              |  7 +++++--
 fs/f2fs/data.c                 |  2 +-
 fs/iomap.c                     |  3 ++-
 fs/mpage.c                     |  2 +-
 fs/xfs/xfs_aops.c              |  4 ++--
 include/linux/blk_types.h      |  2 +-
 include/linux/blkdev.h         |  2 +-
 20 files changed, 53 insertions(+), 29 deletions(-)

diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index 207eca5..65cda9e 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -431,6 +431,7 @@ struct bio {
        struct bio          *bi_next;    /* request queue link */
        struct block_device *bi_bdev;	/* target device */
        unsigned long       bi_flags;    /* status, command, etc */
+       unsigned short	   bi_rw_hint;  /* bio read/write hint */
        unsigned long       bi_opf;       /* low bits: r/w, high: priority */
 
        unsigned int	bi_vcnt;     /* how may bio_vec's */
@@ -465,6 +466,12 @@ With this multipage bio design:
   (e.g a 1MB bio_vec needs to be handled in max 128kB chunks for IDE)
   [TBD: Should preferably also have a bi_voffset and bi_vlen to avoid modifying
    bi_offset an len fields]
+- bi_rw_hint is an in/out parameter. Fs can set bi_rw_hint in submit_bio() to
+  specify which mirror/copy to read from by force. Zero is a special value
+  means fs don't care about reading from which mirror/copy. Starting from 1
+  means to read from the 'bi_rw_hint-1' mirror mandatory.
+  bi_rw_hint was set to indicate which mirror this i/o was really
+  happened on completion.
 
 (*) unrelated merges -- a request ends up containing two or more bios that
     didn't originate from the same place.
diff --git a/block/bio.c b/block/bio.c
index d5368a4..25f1b22 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -605,7 +605,7 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
 	if (bio_flagged(bio_src, BIO_THROTTLED))
 		bio_set_flag(bio, BIO_THROTTLED);
 	bio->bi_opf = bio_src->bi_opf;
-	bio->bi_write_hint = bio_src->bi_write_hint;
+	bio->bi_rw_hint = bio_src->bi_rw_hint;
 	bio->bi_iter = bio_src->bi_iter;
 	bio->bi_io_vec = bio_src->bi_io_vec;
 
diff --git a/block/blk-core.c b/block/blk-core.c
index 50779c8..e9f7080 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1980,7 +1980,7 @@ void blk_init_request_from_bio(struct request *req, struct bio *bio)
 		req->ioprio = ioc->ioprio;
 	else
 		req->ioprio = IOPRIO_PRIO_VALUE(IOPRIO_CLASS_NONE, 0);
-	req->write_hint = bio->bi_write_hint;
+	req->rw_hint = bio->bi_rw_hint;
 	blk_rq_bio_prep(req->q, req, bio);
 }
 EXPORT_SYMBOL_GPL(blk_init_request_from_bio);
@@ -2314,6 +2314,14 @@ generic_make_request_checks(struct bio *bio)
 		if (!q->limits.max_write_zeroes_sectors)
 			goto not_supported;
 		break;
+	/*
+	 * Zero is special value which means upper layer e.g fs don't care
+	 * about reading from which mirror.
+	 * Starting from 1 means reading from mirror 'bi_rw_hint-1' mandatory.
+	 */
+	case REQ_OP_READ:
+		if (bio->bi_rw_hint < 0 || bio->bi_rw_hint > q->nr_mirrors)
+			goto not_supported;
 	default:
 		break;
 	}
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 6b5ad27..e32e2d2 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -766,10 +766,10 @@ static struct request *attempt_merge(struct request_queue *q,
 		return NULL;
 
 	/*
-	 * Don't allow merge of different write hints, or for a hint with
+	 * Don't allow merge of different rw hints, or for a hint with
 	 * non-hint IO.
 	 */
-	if (req->write_hint != next->write_hint)
+	if (req->rw_hint != next->rw_hint)
 		return NULL;
 
 	/*
@@ -904,10 +904,10 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 		return false;
 
 	/*
-	 * Don't allow merge of different write hints, or for a hint with
+	 * Don't allow merge of different rw hints, or for a hint with
 	 * non-hint IO.
 	 */
-	if (rq->write_hint != bio->bi_write_hint)
+	if (rq->rw_hint != bio->bi_rw_hint)
 		return false;
 
 	return true;
diff --git a/block/bounce.c b/block/bounce.c
index 36869af..a7b789e 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -248,7 +248,7 @@ static struct bio *bounce_clone_bio(struct bio *bio_src, gfp_t gfp_mask,
 		return NULL;
 	bio->bi_disk		= bio_src->bi_disk;
 	bio->bi_opf		= bio_src->bi_opf;
-	bio->bi_write_hint	= bio_src->bi_write_hint;
+	bio->bi_rw_hint	        = bio_src->bi_rw_hint;
 	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
 	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
 
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1d54109..fedf8c0 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1102,7 +1102,7 @@ static void alloc_behind_master_bio(struct r1bio *r1_bio,
 		goto skip_copy;
 	}
 
-	behind_bio->bi_write_hint = bio->bi_write_hint;
+	behind_bio->bi_rw_hint = bio->bi_rw_hint;
 
 	while (i < vcnt && size) {
 		struct page *page;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4990f03..37593a0 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1137,9 +1137,9 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			bi->bi_io_vec[0].bv_offset = 0;
 			bi->bi_iter.bi_size = STRIPE_SIZE;
-			bi->bi_write_hint = sh->dev[i].write_hint;
+			bi->bi_rw_hint = sh->dev[i].rw_hint;
 			if (!rrdev)
-				sh->dev[i].write_hint = RWF_WRITE_LIFE_NOT_SET;
+				sh->dev[i].rw_hint = RWF_WRITE_LIFE_NOT_SET;
 			/*
 			 * If this is discard request, set bi_vcnt 0. We don't
 			 * want to confuse SCSI because SCSI will replace payload
@@ -1191,8 +1191,8 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 			rbi->bi_io_vec[0].bv_len = STRIPE_SIZE;
 			rbi->bi_io_vec[0].bv_offset = 0;
 			rbi->bi_iter.bi_size = STRIPE_SIZE;
-			rbi->bi_write_hint = sh->dev[i].write_hint;
-			sh->dev[i].write_hint = RWF_WRITE_LIFE_NOT_SET;
+			rbi->bi_rw_hint = sh->dev[i].rw_hint;
+			sh->dev[i].rw_hint = RWF_WRITE_LIFE_NOT_SET;
 			/*
 			 * If this is discard request, set bi_vcnt 0. We don't
 			 * want to confuse SCSI because SCSI will replace payload
@@ -3219,7 +3219,7 @@ static int add_stripe_bio(struct stripe_head *sh, struct bio *bi, int dd_idx,
 		(unsigned long long)sh->sector);
 
 	spin_lock_irq(&sh->stripe_lock);
-	sh->dev[dd_idx].write_hint = bi->bi_write_hint;
+	sh->dev[dd_idx].rw_hint = bi->bi_rw_hint;
 	/* Don't allow new IO added to stripes in batch list */
 	if (sh->batch_head)
 		goto overlap;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 8474c22..e9f0794 100644
--- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -257,7 +257,7 @@ struct stripe_head {
 		sector_t	sector;			/* sector of this page */
 		unsigned long	flags;
 		u32		log_checksum;
-		unsigned short	write_hint;
+		unsigned short	rw_hint;
 	} dev[1]; /* allocated with extra space depending of RAID geometry */
 };
 
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 2e65be8..18f0824 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -516,7 +516,7 @@ static void nvme_assign_write_stream(struct nvme_ctrl *ctrl,
 				     struct request *req, u16 *control,
 				     u32 *dsmgmt)
 {
-	enum rw_hint streamid = req->write_hint;
+	enum rw_hint streamid = req->rw_hint;
 
 	if (streamid == WRITE_LIFE_NOT_SET || streamid == WRITE_LIFE_NONE)
 		streamid = 0;
diff --git a/fs/block_dev.c b/fs/block_dev.c
index a80b4f0..cd6e154 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -214,7 +214,8 @@ __blkdev_direct_IO_simple(struct kiocb *iocb, struct iov_iter *iter,
 	bio_init(&bio, vecs, nr_pages);
 	bio_set_dev(&bio, bdev);
 	bio.bi_iter.bi_sector = pos >> 9;
-	bio.bi_write_hint = iocb->ki_hint;
+	if (iov_iter_rw(iter) == WRITE)
+		bio.bi_rw_hint = iocb->ki_hint;
 	bio.bi_private = current;
 	bio.bi_end_io = blkdev_bio_end_io_simple;
 	bio.bi_ioprio = iocb->ki_ioprio;
@@ -355,7 +356,8 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_pages)
 	for (;;) {
 		bio_set_dev(bio, bdev);
 		bio->bi_iter.bi_sector = pos >> 9;
-		bio->bi_write_hint = iocb->ki_hint;
+		if (!is_read)
+			bio->bi_rw_hint = iocb->ki_hint;
 		bio->bi_private = dio;
 		bio->bi_end_io = blkdev_bio_end_io;
 		bio->bi_ioprio = iocb->ki_ioprio;
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index d228f70..3a9525e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2806,7 +2806,8 @@ static int submit_extent_page(unsigned int opf, struct extent_io_tree *tree,
 	bio_add_page(bio, page, page_size, pg_offset);
 	bio->bi_end_io = end_io_func;
 	bio->bi_private = tree;
-	bio->bi_write_hint = page->mapping->host->i_write_hint;
+	if (opf & REQ_OP_WRITE)
+		bio->bi_rw_hint = page->mapping->host->i_write_hint;
 	bio->bi_opf = opf;
 	if (wbc) {
 		wbc_init_bio(wbc, bio);
diff --git a/fs/buffer.c b/fs/buffer.c
index 1286c2b..2959055 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3067,7 +3067,8 @@ static int submit_bh_wbc(int op, int op_flags, struct buffer_head *bh,
 
 	bio->bi_iter.bi_sector = bh->b_blocknr * (bh->b_size >> 9);
 	bio_set_dev(bio, bh->b_bdev);
-	bio->bi_write_hint = write_hint;
+	if (REQ_OP_WRITE & op)
+		bio->bi_rw_hint = write_hint;
 
 	bio_add_page(bio, bh->b_page, bh->b_size, bh_offset(bh));
 	BUG_ON(bio->bi_iter.bi_size != bh->b_size);
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 722d17c..290b29e 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -445,7 +445,8 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 	else
 		bio->bi_end_io = dio_bio_end_io;
 
-	bio->bi_write_hint = dio->iocb->ki_hint;
+	if (dio->op == REQ_OP_WRITE)
+		bio->bi_rw_hint = dio->iocb->ki_hint;
 
 	sdio->bio = bio;
 	sdio->logical_offset_in_bio = sdio->cur_page_fs_offset;
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index db75901..8d63174 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -351,7 +351,9 @@ void ext4_io_submit(struct ext4_io_submit *io)
 	if (bio) {
 		int io_op_flags = io->io_wbc->sync_mode == WB_SYNC_ALL ?
 				  REQ_SYNC : 0;
-		io->io_bio->bi_write_hint = io->io_end->inode->i_write_hint;
+		if (io->io_bio->bi_opf & REQ_OP_WRITE)
+			io->io_bio->bi_rw_hint =
+					io->io_end->inode->i_write_hint;
 		bio_set_op_attrs(io->io_bio, REQ_OP_WRITE, io_op_flags);
 		submit_bio(io->io_bio);
 	}
@@ -399,7 +401,8 @@ static int io_submit_add_bh(struct ext4_io_submit *io,
 		ret = io_submit_init_bio(io, bh);
 		if (ret)
 			return ret;
-		io->io_bio->bi_write_hint = inode->i_write_hint;
+		if (io->io_bio->bi_opf & REQ_OP_WRITE)
+			io->io_bio->bi_rw_hint = inode->i_write_hint;
 	}
 	ret = bio_add_page(io->io_bio, page, bh->b_size, bh_offset(bh));
 	if (ret != bh->b_size)
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index b293cb3..5f9afa2 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -269,7 +269,7 @@ static struct bio *__bio_alloc(struct f2fs_sb_info *sbi, block_t blk_addr,
 	} else {
 		bio->bi_end_io = f2fs_write_end_io;
 		bio->bi_private = sbi;
-		bio->bi_write_hint = f2fs_io_type_to_rw_hint(sbi, type, temp);
+		bio->bi_rw_hint = f2fs_io_type_to_rw_hint(sbi, type, temp);
 	}
 	if (wbc)
 		wbc_init_bio(wbc, bio);
diff --git a/fs/iomap.c b/fs/iomap.c
index 64ce240..8115475 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1637,7 +1637,8 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		bio = bio_alloc(GFP_KERNEL, nr_pages);
 		bio_set_dev(bio, iomap->bdev);
 		bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
-		bio->bi_write_hint = dio->iocb->ki_hint;
+		if (dio->flags & IOMAP_DIO_WRITE)
+			bio->bi_rw_hint = dio->iocb->ki_hint;
 		bio->bi_ioprio = dio->iocb->ki_ioprio;
 		bio->bi_private = dio;
 		bio->bi_end_io = iomap_dio_bio_end_io;
diff --git a/fs/mpage.c b/fs/mpage.c
index c820dc9..fd70ba7 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -639,7 +639,7 @@ static int __mpage_writepage(struct page *page, struct writeback_control *wbc,
 			goto confused;
 
 		wbc_init_bio(wbc, bio);
-		bio->bi_write_hint = inode->i_write_hint;
+		bio->bi_rw_hint = inode->i_write_hint;
 	}
 
 	/*
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 338b9d9..6dafcec 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -523,7 +523,7 @@ xfs_submit_ioend(
 		return status;
 	}
 
-	ioend->io_bio->bi_write_hint = ioend->io_inode->i_write_hint;
+	ioend->io_bio->bi_rw_hint = ioend->io_inode->i_write_hint;
 	submit_bio(ioend->io_bio);
 	return 0;
 }
@@ -577,7 +577,7 @@ xfs_chain_bio(
 	bio_chain(ioend->io_bio, new);
 	bio_get(ioend->io_bio);		/* for xfs_destroy_ioend */
 	ioend->io_bio->bi_opf = REQ_OP_WRITE | wbc_to_write_flags(wbc);
-	ioend->io_bio->bi_write_hint = ioend->io_inode->i_write_hint;
+	ioend->io_bio->bi_rw_hint = ioend->io_inode->i_write_hint;
 	submit_bio(ioend->io_bio);
 	ioend->io_bio = new;
 }
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 1dcf652..612e8a6 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -150,7 +150,7 @@ struct bio {
 						 */
 	unsigned short		bi_flags;	/* status, etc and bvec pool number */
 	unsigned short		bi_ioprio;
-	unsigned short		bi_write_hint;
+	unsigned short		bi_rw_hint;
 	blk_status_t		bi_status;
 	u8			bi_partno;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index fac35da..02179af 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -234,7 +234,7 @@ struct request {
 	unsigned short nr_integrity_segments;
 #endif
 
-	unsigned short write_hint;
+	unsigned short rw_hint;
 	unsigned short ioprio;
 
 	void *special;		/* opaque pointer available for LLD use */
-- 
2.7.4
