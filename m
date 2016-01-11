Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8AE6C29DFA
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 14:21:51 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7AF1030405F
	for <xfs@oss.sgi.com>; Mon, 11 Jan 2016 12:21:51 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kjEHs84i8AgxvmFh (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 11 Jan 2016 12:21:49 -0800 (PST)
From: mchristi@redhat.com
Subject: [PATCH 03/35] block, fs, mm, drivers: set bi_op to REQ_OP
Date: Mon, 11 Jan 2016 14:21:01 -0600
Message-Id: <1452543693-4440-4-git-send-email-mchristi@redhat.com>
In-Reply-To: <1452543693-4440-1-git-send-email-mchristi@redhat.com>
References: <1452543693-4440-1-git-send-email-mchristi@redhat.com>
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
drivers, mm and fs code to use bi_op for a REQ_OP and bi_rw
for rq_flag_bits.

These should be simple one liner cases, so I just did them
in one patch. The next patches handle the more complicated
cases in a module per patch.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 block/bio.c                      |  8 +++++---
 block/blk-flush.c                |  1 +
 block/blk-lib.c                  |  7 ++++---
 block/blk-map.c                  |  2 +-
 drivers/block/floppy.c           |  2 +-
 drivers/block/pktcdvd.c          |  4 ++--
 drivers/lightnvm/rrpc.c          |  4 ++--
 drivers/scsi/osd/osd_initiator.c |  8 ++++----
 fs/exofs/ore.c                   |  2 +-
 fs/ext4/crypto.c                 |  2 +-
 fs/ext4/page-io.c                |  8 +++++---
 fs/ext4/readpage.c               |  2 +-
 fs/jfs/jfs_logmgr.c              |  2 ++
 fs/jfs/jfs_metapage.c            |  4 ++--
 fs/logfs/dev_bdev.c              | 12 ++++++------
 fs/nfs/blocklayout/blocklayout.c |  2 +-
 mm/page_io.c                     |  4 ++--
 17 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 921112b..3b8e970 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -581,6 +581,7 @@ void __bio_clone_fast(struct bio *bio, struct bio *bio_src)
 	 */
 	bio->bi_bdev = bio_src->bi_bdev;
 	bio_set_flag(bio, BIO_CLONED);
+	bio->bi_op = bio_src->bi_op;
 	bio->bi_rw = bio_src->bi_rw;
 	bio->bi_iter = bio_src->bi_iter;
 	bio->bi_io_vec = bio_src->bi_io_vec;
@@ -663,6 +664,7 @@ struct bio *bio_clone_bioset(struct bio *bio_src, gfp_t gfp_mask,
 		return NULL;
 
 	bio->bi_bdev		= bio_src->bi_bdev;
+	bio->bi_op		= bio_src->bi_op;
 	bio->bi_rw		= bio_src->bi_rw;
 	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
 	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
@@ -1168,7 +1170,7 @@ struct bio *bio_copy_user_iov(struct request_queue *q,
 		goto out_bmd;
 
 	if (iter->type & WRITE)
-		bio->bi_rw |= REQ_WRITE;
+		bio->bi_op = REQ_OP_WRITE;
 
 	ret = 0;
 
@@ -1338,7 +1340,7 @@ struct bio *bio_map_user_iov(struct request_queue *q,
 	 * set data direction, and check if mapped pages need bouncing
 	 */
 	if (iter->type & WRITE)
-		bio->bi_rw |= REQ_WRITE;
+		bio->bi_op = REQ_OP_WRITE;
 
 	bio_set_flag(bio, BIO_USER_MAPPED);
 
@@ -1531,7 +1533,7 @@ struct bio *bio_copy_kern(struct request_queue *q, void *data, unsigned int len,
 		bio->bi_private = data;
 	} else {
 		bio->bi_end_io = bio_copy_kern_endio;
-		bio->bi_rw |= REQ_WRITE;
+		bio->bi_op = REQ_OP_WRITE;
 	}
 
 	return bio;
diff --git a/block/blk-flush.c b/block/blk-flush.c
index f2fbf9a..b05acca 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -484,6 +484,7 @@ int blkdev_issue_flush(struct block_device *bdev, gfp_t gfp_mask,
 
 	bio = bio_alloc(gfp_mask, 0);
 	bio->bi_bdev = bdev;
+	bio->bi_op = REQ_OP_WRITE;
 	bio->bi_rw = WRITE_FLUSH;
 
 	ret = submit_bio_wait(bio);
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 87e3de4..d01b5f2 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -42,7 +42,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 {
 	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q = bdev_get_queue(bdev);
-	int type = REQ_WRITE | REQ_DISCARD;
+	int type = 0;
 	unsigned int granularity;
 	int alignment;
 	struct bio_batch bb;
@@ -102,6 +102,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_bdev = bdev;
 		bio->bi_private = &bb;
+		bio->bi_op = REQ_OP_DISCARD;
 		bio->bi_rw = type;
 
 		bio->bi_iter.bi_size = req_sects << 9;
@@ -178,7 +179,7 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		bio->bi_io_vec->bv_page = page;
 		bio->bi_io_vec->bv_offset = 0;
 		bio->bi_io_vec->bv_len = bdev_logical_block_size(bdev);
-		bio->bi_rw = REQ_WRITE | REQ_WRITE_SAME;
+		bio->bi_op = REQ_OP_WRITE_SAME;
 
 		if (nr_sects > max_write_same_sectors) {
 			bio->bi_iter.bi_size = max_write_same_sectors << 9;
@@ -240,7 +241,7 @@ static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		bio->bi_bdev   = bdev;
 		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_private = &bb;
-		bio->bi_rw = WRITE;
+		bio->bi_op = REQ_OP_WRITE;
 
 		while (nr_sects != 0) {
 			sz = min((sector_t) PAGE_SIZE >> 9 , nr_sects);
diff --git a/block/blk-map.c b/block/blk-map.c
index f565e11..9021a8f 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -224,7 +224,7 @@ int blk_rq_map_kern(struct request_queue *q, struct request *rq, void *kbuf,
 		return PTR_ERR(bio);
 
 	if (!reading)
-		bio->bi_rw |= REQ_WRITE;
+		bio->bi_op = REQ_OP_WRITE;
 
 	if (do_copy)
 		rq->cmd_flags |= REQ_COPY_USER;
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index aebbdb9..3fda035 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3817,7 +3817,7 @@ static int __floppy_read_block_0(struct block_device *bdev, int drive)
 	bio.bi_flags |= (1 << BIO_QUIET);
 	bio.bi_private = &cbdata;
 	bio.bi_end_io = floppy_rb0_cb;
-	bio.bi_rw = READ;
+	bio.bi_op = REQ_OP_READ;
 
 	submit_bio(&bio);
 	process_fd_request();
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index d06c62e..a4ecbd3 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -1074,7 +1074,7 @@ static void pkt_gather_data(struct pktcdvd_device *pd, struct packet_data *pkt)
 			BUG();
 
 		atomic_inc(&pkt->io_wait);
-		bio->bi_rw = READ;
+		bio->bi_op = REQ_OP_READ;
 		pkt_queue_bio(pd, bio);
 		frames_read++;
 	}
@@ -1336,7 +1336,7 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 
 	/* Start the write request */
 	atomic_set(&pkt->io_wait, 1);
-	pkt->w_bio->bi_rw = WRITE;
+	pkt->w_bio->bi_op = REQ_OP_WRITE;
 	pkt_queue_bio(pd, pkt->w_bio);
 }
 
diff --git a/drivers/lightnvm/rrpc.c b/drivers/lightnvm/rrpc.c
index 134e4fa..c20cb18 100644
--- a/drivers/lightnvm/rrpc.c
+++ b/drivers/lightnvm/rrpc.c
@@ -315,7 +315,7 @@ try:
 
 		/* Perform read to do GC */
 		bio->bi_iter.bi_sector = rrpc_get_sector(rev->addr);
-		bio->bi_rw = READ;
+		bio->bi_op = REQ_OP_READ;
 		bio->bi_private = &wait;
 		bio->bi_end_io = rrpc_end_sync_bio;
 
@@ -333,7 +333,7 @@ try:
 		reinit_completion(&wait);
 
 		bio->bi_iter.bi_sector = rrpc_get_sector(rev->addr);
-		bio->bi_rw = WRITE;
+		bio->bi_op = REQ_OP_WRITE;
 		bio->bi_private = &wait;
 		bio->bi_end_io = rrpc_end_sync_bio;
 
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index d8a2b51..4e7b440 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -726,7 +726,7 @@ static int _osd_req_list_objects(struct osd_request *or,
 		return PTR_ERR(bio);
 	}
 
-	bio->bi_rw &= ~REQ_WRITE;
+	bio->bi_op = REQ_OP_READ;
 	or->in.bio = bio;
 	or->in.total_bytes = bio->bi_iter.bi_size;
 	return 0;
@@ -839,7 +839,7 @@ int osd_req_write_kern(struct osd_request *or,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	bio->bi_rw |= REQ_WRITE; /* FIXME: bio_set_dir() */
+	bio->bi_op = REQ_OP_WRITE;
 	osd_req_write(or, obj, offset, bio, len);
 	return 0;
 }
@@ -956,7 +956,7 @@ static int _osd_req_finalize_cdb_cont(struct osd_request *or, const u8 *cap_key)
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	bio->bi_rw |= REQ_WRITE;
+	bio->bi_op = REQ_OP_WRITE;
 
 	/* integrity check the continuation before the bio is linked
 	 * with the other data segments since the continuation
@@ -1077,7 +1077,7 @@ int osd_req_write_sg_kern(struct osd_request *or,
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
-	bio->bi_rw |= REQ_WRITE;
+	bio->bi_op = REQ_OP_WRITE;
 	osd_req_write_sg(or, obj, bio, sglist, numentries);
 
 	return 0;
diff --git a/fs/exofs/ore.c b/fs/exofs/ore.c
index 7bd8ac8..c40ed74 100644
--- a/fs/exofs/ore.c
+++ b/fs/exofs/ore.c
@@ -878,7 +878,7 @@ static int _write_mirror(struct ore_io_state *ios, int cur_comp)
 			} else {
 				bio = master_dev->bio;
 				/* FIXME: bio_set_dir() */
-				bio->bi_rw |= REQ_WRITE;
+				bio->bi_op = REQ_OP_WRITE;
 			}
 
 			osd_req_write(or, _ios_obj(ios, cur_comp),
diff --git a/fs/ext4/crypto.c b/fs/ext4/crypto.c
index 02f2070..cc884e2 100644
--- a/fs/ext4/crypto.c
+++ b/fs/ext4/crypto.c
@@ -424,7 +424,7 @@ int ext4_encrypted_zeroout(struct inode *inode, ext4_lblk_t lblk,
 		bio->bi_bdev = inode->i_sb->s_bdev;
 		bio->bi_iter.bi_sector =
 			pblk << (inode->i_sb->s_blocksize_bits - 9);
-		bio->bi_rw = WRITE;
+		bio->bi_op = REQ_OP_WRITE;
 		ret = bio_add_page(bio, ciphertext_page,
 				   inode->i_sb->s_blocksize, 0);
 		if (ret != inode->i_sb->s_blocksize) {
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index cf63ac3..046863c 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -353,10 +353,12 @@ void ext4_io_submit(struct ext4_io_submit *io)
 	struct bio *bio = io->io_bio;
 
 	if (bio) {
-		int io_op = io->io_wbc->sync_mode == WB_SYNC_ALL ?
-			    WRITE_SYNC : WRITE;
+		int io_op_flags = io->io_wbc->sync_mode == WB_SYNC_ALL ?
+				WRITE_SYNC : 0;
+
 		bio_get(io->io_bio);
-		io->io_bio->bi_rw = io_op;
+		io->io_bio->bi_op = REQ_OP_WRITE;
+		io->io_bio->bi_rw = io_op_flags;
 		submit_bio(io->io_bio);
 		bio_put(io->io_bio);
 	}
diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index 893dc15..fb36434 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -294,7 +294,7 @@ int ext4_mpage_readpages(struct address_space *mapping,
 			bio->bi_iter.bi_sector = blocks[0] << (blkbits - 9);
 			bio->bi_end_io = mpage_end_io;
 			bio->bi_private = ctx;
-			bio->bi_rw = READ;
+			bio->bi_op = REQ_OP_READ;
 		}
 
 		length = first_hole << blkbits;
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index b0e068f..00227f8 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2004,6 +2004,7 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 
 	bio->bi_end_io = lbmIODone;
 	bio->bi_private = bp;
+	bio->bi_op = REQ_OP_READ;
 	bio->bi_rw = READ_SYNC;
 	/*check if journaling to disk has been disabled*/
 	if (log->no_integrity) {
@@ -2148,6 +2149,7 @@ static void lbmStartIO(struct lbuf * bp)
 
 	bio->bi_end_io = lbmIODone;
 	bio->bi_private = bp;
+	bio->bi_op = REQ_OP_WRITE;
 	bio->bi_rw = WRITE_SYNC;
 
 	/* check if journaling to disk has been disabled */
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index bc29972..115d99e 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -434,7 +434,7 @@ static int metapage_writepage(struct page *page, struct writeback_control *wbc)
 		bio->bi_iter.bi_sector = pblock << (inode->i_blkbits - 9);
 		bio->bi_end_io = metapage_write_end_io;
 		bio->bi_private = page;
-		bio->bi_rw = WRITE;
+		bio->bi_op = REQ_OP_WRITE;
 
 		/* Don't call bio_add_page yet, we may add to this vec */
 		bio_offset = offset;
@@ -515,7 +515,7 @@ static int metapage_readpage(struct file *fp, struct page *page)
 				pblock << (inode->i_blkbits - 9);
 			bio->bi_end_io = metapage_read_end_io;
 			bio->bi_private = page;
-			bio->bi_rw = READ;
+			bio->bi_op = REQ_OP_READ;
 			len = xlen << inode->i_blkbits;
 			offset = block_offset << inode->i_blkbits;
 			if (bio_add_page(bio, page, len, offset) < len)
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index 9e690ad..130b7e2 100644
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
+	bio.bi_op = op;
 
 	return submit_bio_wait(&bio);
 }
@@ -96,7 +96,7 @@ static int __bdev_writeseg(struct super_block *sb, u64 ofs, pgoff_t index,
 			bio->bi_iter.bi_sector = ofs >> 9;
 			bio->bi_private = sb;
 			bio->bi_end_io = writeseg_end_io;
-			bio->bi_rw = WRITE;
+			bio->bi_op = REQ_OP_WRITE;
 			atomic_inc(&super->s_pending_writes);
 			submit_bio(bio);
 
@@ -124,7 +124,7 @@ static int __bdev_writeseg(struct super_block *sb, u64 ofs, pgoff_t index,
 	bio->bi_iter.bi_sector = ofs >> 9;
 	bio->bi_private = sb;
 	bio->bi_end_io = writeseg_end_io;
-	bio->bi_rw = WRITE;
+	bio->bi_op = REQ_OP_WRITE;
 	atomic_inc(&super->s_pending_writes);
 	submit_bio(bio);
 	return 0;
@@ -188,7 +188,7 @@ static int do_erase(struct super_block *sb, u64 ofs, pgoff_t index,
 			bio->bi_iter.bi_sector = ofs >> 9;
 			bio->bi_private = sb;
 			bio->bi_end_io = erase_end_io;
-			bio->bi_rw = WRITE;
+			bio->bi_op = REQ_OP_WRITE;
 			atomic_inc(&super->s_pending_writes);
 			submit_bio(bio);
 
@@ -210,7 +210,7 @@ static int do_erase(struct super_block *sb, u64 ofs, pgoff_t index,
 	bio->bi_iter.bi_sector = ofs >> 9;
 	bio->bi_private = sb;
 	bio->bi_end_io = erase_end_io;
-	bio->bi_rw = WRITE;
+	bio->bi_op = REQ_OP_WRITE;
 	atomic_inc(&super->s_pending_writes);
 	submit_bio(bio);
 	return 0;
diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index 8c0443c..3832909 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -175,7 +175,7 @@ retry:
 				disk_addr >> SECTOR_SHIFT, end_io, par);
 		if (!bio)
 			return ERR_PTR(-ENOMEM);
-		bio->bi_rw = rw;
+		bio->bi_op = rw;
 	}
 	if (bio_add_page(bio, page, *len, offset) < *len) {
 		bio = bl_submit_bio(bio);
diff --git a/mm/page_io.c b/mm/page_io.c
index e8a18a7..e48b84c 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -311,7 +311,7 @@ int __swap_writepage(struct page *page, struct writeback_control *wbc,
 		ret = -ENOMEM;
 		goto out;
 	}
-	bio->bi_rw = WRITE;
+	bio->bi_op = REQ_OP_WRITE;
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		bio->bi_rw |= REQ_SYNC;
 	count_vm_event(PSWPOUT);
@@ -359,7 +359,7 @@ int swap_readpage(struct page *page)
 		ret = -ENOMEM;
 		goto out;
 	}
-	bio->bi_rw = READ;
+	bio->bi_op = REQ_OP_READ;
 	count_vm_event(PSWPIN);
 	submit_bio(bio);
 out:
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
