Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6DE557CC9
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:32:54 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3F9B38F8040
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:32:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 4wZ3u5LD6z1grMsn (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:32:51 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 08/45] block, fs, mm, drivers: use bio set/get op accessors
Date: Sun,  5 Jun 2016 14:31:48 -0500
Message-Id: <1465155145-10812-9-git-send-email-mchristi@redhat.com>
In-Reply-To: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
References: <1465155145-10812-1-git-send-email-mchristi@redhat.com>
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

This patch converts the simple bi_rw use cases in the block,
drivers, mm and fs code to set/get the bio operation using
bio_set_op_attrs/bio_op

These should be simple one or two liner cases, so I just did them
in one patch. The next patches handle the more complicated
cases in a module per patch.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---

v5:
1. Add missed crypto call.
2. Change nfs bi_rw check to bi_op.

 block/bio.c                                 | 13 ++++++-------
 block/blk-core.c                            |  6 +++---
 block/blk-flush.c                           |  2 +-
 block/blk-lib.c                             |  4 ++--
 block/blk-map.c                             |  2 +-
 block/blk-merge.c                           | 12 ++++++------
 drivers/block/brd.c                         |  2 +-
 drivers/block/floppy.c                      |  2 +-
 drivers/block/pktcdvd.c                     |  4 ++--
 drivers/block/rsxx/dma.c                    |  2 +-
 drivers/block/zram/zram_drv.c               |  2 +-
 drivers/lightnvm/rrpc.c                     |  6 +++---
 drivers/scsi/osd/osd_initiator.c            |  8 ++++----
 drivers/staging/lustre/lustre/llite/lloop.c |  6 +++---
 fs/crypto/crypto.c                          |  2 +-
 fs/exofs/ore.c                              |  2 +-
 fs/ext4/page-io.c                           |  6 +++---
 fs/ext4/readpage.c                          |  2 +-
 fs/jfs/jfs_logmgr.c                         |  4 ++--
 fs/jfs/jfs_metapage.c                       |  4 ++--
 fs/logfs/dev_bdev.c                         | 12 ++++++------
 fs/nfs/blocklayout/blocklayout.c            |  4 ++--
 include/linux/bio.h                         | 15 ++++++++++-----
 mm/page_io.c                                |  4 ++--
 24 files changed, 65 insertions(+), 61 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index fc779eb..848cd35 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -656,16 +656,15 @@ struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
 	bio = bio_alloc_bioset(gfp_mask, bio_segments(bio_src), bs);
 	if (!bio)
 		return NULL;
-
 	bio->bi_bdev		= bio_src->bi_bdev;
 	bio->bi_rw		= bio_src->bi_rw;
 	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
 	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
 
-	if (bio->bi_rw & REQ_DISCARD)
+	if (bio_op(bio) == REQ_OP_DISCARD)
 		goto integrity_clone;
 
-	if (bio->bi_rw & REQ_WRITE_SAME) {
+	if (bio_op(bio) == REQ_OP_WRITE_SAME) {
 		bio->bi_io_vec[bio->bi_vcnt++] = bio_src->bi_io_vec[0];
 		goto integrity_clone;
 	}
@@ -1166,7 +1165,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 		goto out_bmd;
 
 	if (iter->type & WRITE)
-		bio->bi_rw |= REQ_WRITE;
+		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
 	ret = 0;
 
@@ -1336,7 +1335,7 @@ struct bio *bio_map_user_iov(struct request_queue *q,
 	 * set data direction, and check if mapped pages need bouncing
 	 */
 	if (iter->type & WRITE)
-		bio->bi_rw |= REQ_WRITE;
+		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
 	bio_set_flag(bio, BIO_USER_MAPPED);
 
@@ -1529,7 +1528,7 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 		bio->bi_private = data;
 	} else {
 		bio->bi_end_io = bio_copy_kern_endio;
-		bio->bi_rw |= REQ_WRITE;
+		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 	}
 
 	return bio;
@@ -1784,7 +1783,7 @@ struct bio *bio_split(struct bio *bio, int sectors,
 	 * Discards need a mutable bio_vec to accommodate the payload
 	 * required by the DSM TRIM and UNMAP commands.
 	 */
-	if (bio->bi_rw & REQ_DISCARD)
+	if (bio_op(bio) == REQ_OP_DISCARD)
 		split = bio_clone_bioset(bio, gfp, bs);
 	else
 		split = bio_clone_fast(bio, gfp, bs);
diff --git a/block/blk-core.c b/block/blk-core.c
index e8e5865..7e943dc 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1973,14 +1973,14 @@ generic_make_request_checks(struct bio *bio)
 		}
 	}
 
-	if ((bio->bi_rw & REQ_DISCARD) &&
+	if ((bio_op(bio) == REQ_OP_DISCARD) &&
 	    (!blk_queue_discard(q) ||
 	     ((bio->bi_rw & REQ_SECURE) && !blk_queue_secdiscard(q)))) {
 		err = -EOPNOTSUPP;
 		goto end_io;
 	}
 
-	if (bio->bi_rw & REQ_WRITE_SAME && !bdev_write_same(bio->bi_bdev)) {
+	if (bio_op(bio) == REQ_OP_WRITE_SAME && !bdev_write_same(bio->bi_bdev)) {
 		err = -EOPNOTSUPP;
 		goto end_io;
 	}
@@ -2110,7 +2110,7 @@ blk_qc_t submit_bio(struct bio *bio)
 	if (bio_has_data(bio)) {
 		unsigned int count;
 
-		if (unlikely(bio->bi_rw & REQ_WRITE_SAME))
+		if (unlikely(bio_op(bio) == REQ_OP_WRITE_SAME))
 			count = bdev_logical_block_size(bio->bi_bdev) >> 9;
 		else
 			count = bio_sectors(bio);
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 3af4a5a..9fd1f63 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -485,7 +485,7 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 
 	bio = bio_alloc(gfp_mask, 0);
 	bio->bi_bdev = bdev;
-	bio->bi_rw = WRITE_FLUSH;
+	bio_set_op_attrs(bio, REQ_OP_WRITE, WRITE_FLUSH);
 
 	ret = submit_bio_wait(bio);
 
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 1f6dec5..c614eaa 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -155,7 +155,7 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		bio->bi_io_vec->bv_page = page;
 		bio->bi_io_vec->bv_offset = 0;
 		bio->bi_io_vec->bv_len = bdev_logical_block_size(bdev);
-		bio->bi_rw = REQ_WRITE | REQ_WRITE_SAME;
+		bio_set_op_attrs(bio, REQ_OP_WRITE_SAME, 0);
 
 		if (nr_sects > max_write_same_sectors) {
 			bio->bi_iter.bi_size = max_write_same_sectors << 9;
@@ -196,7 +196,7 @@ static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 				gfp_mask);
 		bio->bi_iter.bi_sector = sector;
 		bio->bi_bdev   = bdev;
-		bio->bi_rw = REQ_WRITE;
+		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
 		while (nr_sects != 0) {
 			sz = min((sector_t) PAGE_SIZE >> 9 , nr_sects);
diff --git a/block/blk-map.c b/block/blk-map.c
index b9f88b7..61733a6 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -224,7 +224,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 		return PTR_ERR(bio);
 
 	if (!reading)
-		bio->bi_rw |= REQ_WRITE;
+		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
 	if (do_copy)
 		rq->cmd_flags |= REQ_COPY_USER;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index b198070..5a03f96 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -172,9 +172,9 @@ void blk_queue_split(struct request_queue *q, struct bio **bio,
 	struct bio *split, *res;
 	unsigned nsegs;
 
-	if ((*bio)->bi_rw & REQ_DISCARD)
+	if (bio_op(*bio) == REQ_OP_DISCARD)
 		split = blk_bio_discard_split(q, *bio, bs, &nsegs);
-	else if ((*bio)->bi_rw & REQ_WRITE_SAME)
+	else if (bio_op(*bio) == REQ_OP_WRITE_SAME)
 		split = blk_bio_write_same_split(q, *bio, bs, &nsegs);
 	else
 		split = blk_bio_segment_split(q, *bio, q->bio_split, &nsegs);
@@ -213,10 +213,10 @@ static unsigned int __blk_recalc_rq_segments(struct request_queue *q,
 	 * This should probably be returning 0, but blk_add_request_payload()
 	 * (Christoph!!!!)
 	 */
-	if (bio->bi_rw & REQ_DISCARD)
+	if (bio_op(bio) == REQ_OP_DISCARD)
 		return 1;
 
-	if (bio->bi_rw & REQ_WRITE_SAME)
+	if (bio_op(bio) == REQ_OP_WRITE_SAME)
 		return 1;
 
 	fbio = bio;
@@ -385,7 +385,7 @@ static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
 	nsegs = 0;
 	cluster = blk_queue_cluster(q);
 
-	if (bio->bi_rw & REQ_DISCARD) {
+	if (bio_op(bio) == REQ_OP_DISCARD) {
 		/*
 		 * This is a hack - drivers should be neither modifying the
 		 * biovec, nor relying on bi_vcnt - but because of
@@ -400,7 +400,7 @@ static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
 		return 0;
 	}
 
-	if (bio->bi_rw & REQ_WRITE_SAME) {
+	if (bio_op(bio) == REQ_OP_WRITE_SAME) {
 single_segment:
 		*sg = sglist;
 		bvec = bio_iovec(bio);
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index c04bd9b..f5b0d6f 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -339,7 +339,7 @@ static blk_qc_t brd_make_request(struct request_queue *q, struct bio *bio)
 	if (bio_end_sector(bio) > get_capacity(bdev->bd_disk))
 		goto io_error;
 
-	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
+	if (unlikely(bio_op(bio) == REQ_OP_DISCARD)) {
 		if (sector & ((PAGE_SIZE >> SECTOR_SHIFT) - 1) ||
 		    bio->bi_iter.bi_size & ~PAGE_MASK)
 			goto io_error;
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 73ded25..f9bfecd 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3822,7 +3822,7 @@ static int __floppy_read_block_0(struct block_device *bdev, int drive)
 	bio.bi_flags |= (1 << BIO_QUIET);
 	bio.bi_private = &cbdata;
 	bio.bi_end_io = floppy_rb0_cb;
-	bio.bi_rw = READ;
+	bio_set_op_attrs(&bio, REQ_OP_READ, 0);
 
 	submit_bio(&bio);
 	process_fd_request();
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index d06c62e..9393bc7 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -1074,7 +1074,7 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 			BUG();
 
 		atomic_inc(&pkt->io_wait);
-		bio->bi_rw = READ;
+		bio_set_op_attrs(bio, REQ_OP_READ, 0);
 		pkt_queue_bio(pd, bio);
 		frames_read++;
 	}
@@ -1336,7 +1336,7 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 
 	/* Start the write request */
 	atomic_set(&pkt->io_wait, 1);
-	pkt->w_bio->bi_rw = WRITE;
+	bio_set_op_attrs(pkt->w_bio, REQ_OP_WRITE, 0);
 	pkt_queue_bio(pd, pkt->w_bio);
 }
 
diff --git a/drivers/block/rsxx/dma.c b/drivers/block/rsxx/dma.c
index cf8cd29..5a20385f8 100644
--- a/drivers/block/rsxx/dma.c
+++ b/drivers/block/rsxx/dma.c
@@ -705,7 +705,7 @@ int rsxx_dma_queue_bio(struct rsxx_cardinfo *card,
 		dma_cnt[i] = 0;
 	}
 
-	if (bio->bi_rw & REQ_DISCARD) {
+	if (bio_op(bio) == REQ_OP_DISCARD) {
 		bv_len = bio->bi_iter.bi_size;
 
 		while (bv_len > 0) {
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 8fcad8b..e5e5d19 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -874,7 +874,7 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
 	offset = (bio->bi_iter.bi_sector &
 		  (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
 
-	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
+	if (unlikely(bio_op(bio) == REQ_OP_DISCARD)) {
 		zram_bio_discard(zram, index, offset, bio);
 		bio_endio(bio);
 		return;
diff --git a/drivers/lightnvm/rrpc.c b/drivers/lightnvm/rrpc.c
index 2103e97..de86d72 100644
--- a/drivers/lightnvm/rrpc.c
+++ b/drivers/lightnvm/rrpc.c
@@ -342,7 +342,7 @@ try:
 
 		/* Perform read to do GC */
 		bio->bi_iter.bi_sector = rrpc_get_sector(rev->addr);
-		bio->bi_rw = READ;
+		bio_set_op_attrs(bio,  REQ_OP_READ, 0);
 		bio->bi_private = &wait;
 		bio->bi_end_io = rrpc_end_sync_bio;
 
@@ -364,7 +364,7 @@ try:
 		reinit_completion(&wait);
 
 		bio->bi_iter.bi_sector = rrpc_get_sector(rev->addr);
-		bio->bi_rw = WRITE;
+		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 		bio->bi_private = &wait;
 		bio->bi_end_io = rrpc_end_sync_bio;
 
@@ -908,7 +908,7 @@ static blk_qc_t rrpc_make_rq(struct request_queue *q, struct bio *bio)
 	struct nvm_rq *rqd;
 	int err;
 
-	if (bio->bi_rw & REQ_DISCARD) {
+	if (bio_op(bio) == REQ_OP_DISCARD) {
 		rrpc_discard(rrpc, bio);
 		return BLK_QC_T_NONE;
 	}
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 14ed39b..daa4dc1 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -726,7 +726,7 @@ static int _osd_req_list_objects(struct osd_request *or,
 		return PTR_ERR(bio);
 	}
 
-	bio->bi_rw &= ~REQ_WRITE;
+	bio_set_op_attrs(bio, REQ_OP_READ, 0);
 	or->in.bio = bio;
 	or->in.total_bytes = bio->bi_iter.bi_size;
 	return 0;
@@ -839,7 +839,7 @@ int osd_req_write_kern(struct osd_request *or,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	bio->bi_rw |= REQ_WRITE; /* FIXME: bio_set_dir() */
+	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 	osd_req_write(or, obj, offset, bio, len);
 	return 0;
 }
@@ -956,7 +956,7 @@ static int _osd_req_finalize_cdb_cont(struct osd_request *or, const u8 *cap_key)
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	bio->bi_rw |= REQ_WRITE;
+	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
 	/* integrity check the continuation before the bio is linked
 	 * with the other data segments since the continuation
@@ -1077,7 +1077,7 @@ int osd_req_write_sg_kern(struct osd_request *or,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	bio->bi_rw |= REQ_WRITE;
+	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 	osd_req_write_sg(or, obj, bio, sglist, numentries);
 
 	return 0;
diff --git a/drivers/staging/lustre/lustre/llite/lloop.c b/drivers/staging/lustre/lustre/llite/lloop.c
index 813a9a3..b677930 100644
--- a/drivers/staging/lustre/lustre/llite/lloop.c
+++ b/drivers/staging/lustre/lustre/llite/lloop.c
@@ -211,9 +211,9 @@ static int do_bio_lustrebacked(struct lloop_device *lo, struct bio *head)
 		return io->ci_result;
 	io->ci_lockreq = CILR_NEVER;
 
-	rw = head->bi_rw;
+	rw = bio_data_dir(head);
 	for (bio = head; bio ; bio = bio->bi_next) {
-		LASSERT(rw == bio->bi_rw);
+		LASSERT(rw == bio_data_dir(bio));
 
 		offset = (pgoff_t)(bio->bi_iter.bi_sector << 9) + lo->lo_offset;
 		bio_for_each_segment(bvec, bio, iter) {
@@ -305,7 +305,7 @@ static unsigned int loop_get_bio(struct lloop_device *lo, struct bio **req)
 	/* TODO: need to split the bio, too bad. */
 	LASSERT(first->bi_vcnt <= LLOOP_MAX_SEGMENTS);
 
-	rw = first->bi_rw;
+	rw = bio_data_dir(first);
 	bio = &lo->lo_bio;
 	while (*bio && (*bio)->bi_rw == rw) {
 		CDEBUG(D_INFO, "bio sector %llu size %u count %u vcnt%u\n",
diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index 5b75856..c502c11 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -318,7 +318,7 @@ int fscrypt_zeroout_range(struct inode *inode, pgoff_t lblk,
 		bio->bi_bdev = inode->i_sb->s_bdev;
 		bio->bi_iter.bi_sector =
 			pblk << (inode->i_sb->s_blocksize_bits - 9);
-		bio->bi_rw = WRITE;
+		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 		ret = bio_add_page(bio, ciphertext_page,
 					inode->i_sb->s_blocksize, 0);
 		if (ret != inode->i_sb->s_blocksize) {
diff --git a/fs/exofs/ore.c b/fs/exofs/ore.c
index 7bd8ac8..8bb7280 100644
--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -878,7 +878,7 @@ static int _write_mirror(struct ore_io_state *ios, int cur_comp)
 			} else {
 				bio = master_dev->bio;
 				/* FIXME: bio_set_dir() */
-				bio->bi_rw |= REQ_WRITE;
+				bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 			}
 
 			osd_req_write(or, _ios_obj(ios, cur_comp),
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index a72dbcc..5185fed 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -340,9 +340,9 @@ void ext4_io_submit(struct ext4_io_submit *io)
 	struct bio *bio = io->io_bio;
 
 	if (bio) {
-		int io_op = io->io_wbc->sync_mode == WB_SYNC_ALL ?
-			    WRITE_SYNC : WRITE;
-		io->io_bio->bi_rw = io_op;
+		int io_op_flags = io->io_wbc->sync_mode == WB_SYNC_ALL ?
+				  WRITE_SYNC : 0;
+		bio_set_op_attrs(io->io_bio, REQ_OP_WRITE, io_op_flags);
 		submit_bio(io->io_bio);
 	}
 	io->io_bio = NULL;
diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index 130bd45..2ced5a8 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -294,7 +294,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
 			bio->bi_iter.bi_sector = blocks[0] << (blkbits - 9);
 			bio->bi_end_io = mpage_end_io;
 			bio->bi_private = ctx;
-			bio->bi_rw = READ;
+			bio_set_op_attrs(bio, REQ_OP_READ, 0);
 		}
 
 		length = first_hole << blkbits;
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index 3ee3f32..a747521 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2002,7 +2002,7 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 
 	bio->bi_end_io = lbmIODone;
 	bio->bi_private = bp;
-	bio->bi_rw = READ_SYNC;
+	bio_set_op_attrs(bio, REQ_OP_READ, READ_SYNC);
 	/*check if journaling to disk has been disabled*/
 	if (log->no_integrity) {
 		bio->bi_iter.bi_size = 0;
@@ -2146,7 +2146,7 @@ static void lbmStartIO(struct lbuf * bp)
 
 	bio->bi_end_io = lbmIODone;
 	bio->bi_private = bp;
-	bio->bi_rw = WRITE_SYNC;
+	bio_set_op_attrs(bio, REQ_OP_WRITE, WRITE_SYNC);
 
 	/* check if journaling to disk has been disabled */
 	if (log->no_integrity) {
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index 9725443..e7fa9e5 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -434,7 +434,7 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
 		bio->bi_iter.bi_sector = pblock << (inode->i_blkbits - 9);
 		bio->bi_end_io = metapage_write_end_io;
 		bio->bi_private = page;
-		bio->bi_rw = WRITE;
+		bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 
 		/* Don't call bio_add_page yet, we may add to this vec */
 		bio_offset = offset;
@@ -515,7 +515,7 @@ static int metapage_readpage(struct file *fp, struct page *page)
 				pblock << (inode->i_blkbits - 9);
 			bio->bi_end_io = metapage_read_end_io;
 			bio->bi_private = page;
-			bio->bi_rw = READ;
+			bio_set_op_attrs(bio, REQ_OP_READ, 0);
 			len = xlen << inode->i_blkbits;
 			offset = block_offset << inode->i_blkbits;
 			if (bio_add_page(bio, page, len, offset) < len)
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index 29704bd..a8329cc 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -14,7 +14,7 @@
 
 #define PAGE_OFS(ofs) ((ofs) & (PAGE_SIZE-1))
 
-static int sync_request(struct page *page, struct block_device *bdev, int rw)
+static int sync_request(struct page *page, struct block_device *bdev, int op)
 {
 	struct bio bio;
 	struct bio_vec bio_vec;
@@ -29,7 +29,7 @@ static int sync_request(struct page *page, struct block_device *bdev, int rw)
 	bio.bi_bdev = bdev;
 	bio.bi_iter.bi_sector = page->index * (PAGE_SIZE >> 9);
 	bio.bi_iter.bi_size = PAGE_SIZE;
-	bio.bi_rw = rw;
+	bio_set_op_attrs(&bio, op, 0);
 
 	return submit_bio_wait(&bio);
 }
@@ -96,7 +96,7 @@ static int __bdev_writeseg(struct super_block *sb, u64 ofs, pgoff_t index,
 			bio->bi_iter.bi_sector = ofs >> 9;
 			bio->bi_private = sb;
 			bio->bi_end_io = writeseg_end_io;
-			bio->bi_rw = WRITE;
+			bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 			atomic_inc(&super->s_pending_writes);
 			submit_bio(bio);
 
@@ -124,7 +124,7 @@ static int __bdev_writeseg(struct super_block *sb, u64 ofs, pgoff_t index,
 	bio->bi_iter.bi_sector = ofs >> 9;
 	bio->bi_private = sb;
 	bio->bi_end_io = writeseg_end_io;
-	bio->bi_rw = WRITE;
+	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 	atomic_inc(&super->s_pending_writes);
 	submit_bio(bio);
 	return 0;
@@ -188,7 +188,7 @@ static int do_erase(struct super_block *sb, u64 ofs, pgoff_t index,
 			bio->bi_iter.bi_sector = ofs >> 9;
 			bio->bi_private = sb;
 			bio->bi_end_io = erase_end_io;
-			bio->bi_rw = WRITE;
+			bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 			atomic_inc(&super->s_pending_writes);
 			submit_bio(bio);
 
@@ -210,7 +210,7 @@ static int do_erase(struct super_block *sb, u64 ofs, pgoff_t index,
 	bio->bi_iter.bi_sector = ofs >> 9;
 	bio->bi_private = sb;
 	bio->bi_end_io = erase_end_io;
-	bio->bi_rw = WRITE;
+	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 	atomic_inc(&super->s_pending_writes);
 	submit_bio(bio);
 	return 0;
diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 4c79f4d..f55a4e7 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -107,7 +107,7 @@ bl_submit_bio(struct bio *bio)
 	if (bio) {
 		get_parallel(bio->bi_private);
 		dprintk("%s submitting %s bio %u@%llu\n", __func__,
-			bio->bi_rw == READ ? "read" : "write",
+			bio_op(bio) == READ ? "read" : "write",
 			bio->bi_iter.bi_size,
 			(unsigned long long)bio->bi_iter.bi_sector);
 		submit_bio(bio);
@@ -175,7 +175,7 @@ retry:
 				disk_addr >> SECTOR_SHIFT, end_io, par);
 		if (!bio)
 			return ERR_PTR(-ENOMEM);
-		bio->bi_rw = rw;
+		bio_set_op_attrs(bio, rw, 0);
 	}
 	if (bio_add_page(bio, page, *len, offset) < *len) {
 		bio = bl_submit_bio(bio);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 09c5308..4568647 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -109,18 +109,23 @@ static inline bool bio_has_data(struct bio *bio)
 {
 	if (bio &&
 	    bio->bi_iter.bi_size &&
-	    !(bio->bi_rw & REQ_DISCARD))
+	    bio_op(bio) != REQ_OP_DISCARD)
 		return true;
 
 	return false;
 }
 
+static inline bool bio_no_advance_iter(struct bio *bio)
+{
+	return bio_op(bio) == REQ_OP_DISCARD || bio_op(bio) == REQ_OP_WRITE_SAME;
+}
+
 static inline bool bio_is_rw(struct bio *bio)
 {
 	if (!bio_has_data(bio))
 		return false;
 
-	if (bio->bi_rw & BIO_NO_ADVANCE_ITER_MASK)
+	if (bio_no_advance_iter(bio))
 		return false;
 
 	return true;
@@ -228,7 +233,7 @@ static inline void bio_advance_iter(struct bio *bio, struct bvec_iter *iter,
 {
 	iter->bi_sector += bytes >> 9;
 
-	if (bio->bi_rw & BIO_NO_ADVANCE_ITER_MASK)
+	if (bio_no_advance_iter(bio))
 		iter->bi_size -= bytes;
 	else
 		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
@@ -256,10 +261,10 @@ static inline unsigned bio_segments(struct bio *bio)
 	 * differently:
 	 */
 
-	if (bio->bi_rw & REQ_DISCARD)
+	if (bio_op(bio) == REQ_OP_DISCARD)
 		return 1;
 
-	if (bio->bi_rw & REQ_WRITE_SAME)
+	if (bio_op(bio) == REQ_OP_WRITE_SAME)
 		return 1;
 
 	bio_for_each_segment(bv, bio, iter)
diff --git a/mm/page_io.c b/mm/page_io.c
index 5a5fd66..dcc5d37 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -317,7 +317,7 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		ret = -ENOMEM;
 		goto out;
 	}
-	bio->bi_rw = WRITE;
+	bio_set_op_attrs(bio, REQ_OP_WRITE, 0);
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		bio->bi_rw |= REQ_SYNC;
 	count_vm_event(PSWPOUT);
@@ -370,7 +370,7 @@ int swap_readpage(struct page *page)
 		ret = -ENOMEM;
 		goto out;
 	}
-	bio->bi_rw = READ;
+	bio_set_op_attrs(bio, REQ_OP_READ, 0);
 	count_vm_event(PSWPIN);
 	submit_bio(bio);
 out:
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
