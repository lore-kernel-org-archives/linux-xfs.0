Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id ED01C7CCD
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:32:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AD9F68F8039
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:32:57 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id sGaMV1KhvVUNBUKD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:32:56 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 10/45] direct-io: use bio set/get op accessors
Date: Sun,  5 Jun 2016 14:31:50 -0500
Message-Id: <1465155145-10812-11-git-send-email-mchristi@redhat.com>
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

This patch has the dio code use a REQ_OP for the op and rq_flag_bits
for bi_rw flags. To set/get the op it uses the bio_set_op_attrs/bio_op
accssors.

It also begins to convert btrfs's dio_submit_t because of the dio
submit_io callout use. The next patches will completely convert
this code and the reset of the btrfs code paths.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 fs/btrfs/inode.c   |  8 ++++----
 fs/direct-io.c     | 34 ++++++++++++++++++++--------------
 include/linux/fs.h |  2 +-
 3 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 2704995..96f9192 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8422,14 +8422,14 @@ out_err:
 	return 0;
 }
 
-static void btrfs_submit_direct(int rw, struct bio *dio_bio,
-				struct inode *inode, loff_t file_offset)
+static void btrfs_submit_direct(struct bio *dio_bio, struct inode *inode,
+				loff_t file_offset)
 {
 	struct btrfs_dio_private *dip = NULL;
 	struct bio *io_bio = NULL;
 	struct btrfs_io_bio *btrfs_bio;
 	int skip_sum;
-	int write = rw & REQ_WRITE;
+	bool write = (bio_op(dio_bio) == REQ_OP_WRITE);
 	int ret = 0;
 
 	skip_sum = BTRFS_I(inode)->flags & BTRFS_INODE_NODATASUM;
@@ -8480,7 +8480,7 @@ static void btrfs_submit_direct(int rw, struct bio *dio_bio,
 			dio_data->unsubmitted_oe_range_end;
 	}
 
-	ret = btrfs_submit_direct_hook(rw, dip, skip_sum);
+	ret = btrfs_submit_direct_hook(dio_bio->bi_rw, dip, skip_sum);
 	if (!ret)
 		return;
 
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 1bcdd5d..7c3ce73 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -108,7 +108,8 @@ struct dio_submit {
 /* dio_state communicated between submission path and end_io */
 struct dio {
 	int flags;			/* doesn't change */
-	int rw;
+	int op;
+	int op_flags;
 	blk_qc_t bio_cookie;
 	struct block_device *bio_bdev;
 	struct inode *inode;
@@ -163,7 +164,7 @@ static inline int dio_refill_pages(struct dio *dio, struct dio_submit *sdio)
 	ret = iov_iter_get_pages(sdio->iter, dio->pages, LONG_MAX, DIO_PAGES,
 				&sdio->from);
 
-	if (ret < 0 && sdio->blocks_available && (dio->rw & WRITE)) {
+	if (ret < 0 && sdio->blocks_available && (dio->op == REQ_OP_WRITE)) {
 		struct page *page = ZERO_PAGE(0);
 		/*
 		 * A memory fault, but the filesystem has some outstanding
@@ -242,7 +243,8 @@ static ssize_t dio_complete(struct dio *dio, ssize_t ret, bool is_async)
 		transferred = dio->result;
 
 		/* Check for short read case */
-		if ((dio->rw == READ) && ((offset + transferred) > dio->i_size))
+		if ((dio->op == REQ_OP_READ) &&
+		    ((offset + transferred) > dio->i_size))
 			transferred = dio->i_size - offset;
 	}
 
@@ -273,7 +275,7 @@ static ssize_t dio_complete(struct dio *dio, ssize_t ret, bool is_async)
 		 */
 		dio->iocb->ki_pos += transferred;
 
-		if (dio->rw & WRITE)
+		if (dio->op == REQ_OP_WRITE)
 			ret = generic_write_sync(dio->iocb,  transferred);
 		dio->iocb->ki_complete(dio->iocb, ret, 0);
 	}
@@ -375,7 +377,7 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 
 	bio->bi_bdev = bdev;
 	bio->bi_iter.bi_sector = first_sector;
-	bio->bi_rw = dio->rw;
+	bio_set_op_attrs(bio, dio->op, dio->op_flags);
 	if (dio->is_async)
 		bio->bi_end_io = dio_bio_end_aio;
 	else
@@ -403,14 +405,13 @@ static inline void dio_bio_submit(struct dio *dio, struct dio_submit *sdio)
 	dio->refcount++;
 	spin_unlock_irqrestore(&dio->bio_lock, flags);
 
-	if (dio->is_async && dio->rw == READ && dio->should_dirty)
+	if (dio->is_async && dio->op == REQ_OP_READ && dio->should_dirty)
 		bio_set_pages_dirty(bio);
 
 	dio->bio_bdev = bio->bi_bdev;
 
 	if (sdio->submit_io) {
-		sdio->submit_io(dio->rw, bio, dio->inode,
-			       sdio->logical_offset_in_bio);
+		sdio->submit_io(bio, dio->inode, sdio->logical_offset_in_bio);
 		dio->bio_cookie = BLK_QC_T_NONE;
 	} else
 		dio->bio_cookie = submit_bio(bio);
@@ -479,14 +480,14 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 	if (bio->bi_error)
 		dio->io_error = -EIO;
 
-	if (dio->is_async && dio->rw == READ && dio->should_dirty) {
+	if (dio->is_async && dio->op == REQ_OP_READ && dio->should_dirty) {
 		err = bio->bi_error;
 		bio_check_pages_dirty(bio);	/* transfers ownership */
 	} else {
 		bio_for_each_segment_all(bvec, bio, i) {
 			struct page *page = bvec->bv_page;
 
-			if (dio->rw == READ && !PageCompound(page) &&
+			if (dio->op == REQ_OP_READ && !PageCompound(page) &&
 					dio->should_dirty)
 				set_page_dirty_lock(page);
 			put_page(page);
@@ -639,7 +640,7 @@ static int get_more_blocks(struct dio *dio, struct dio_submit *sdio,
 		 * which may decide to handle it or also return an unmapped
 		 * buffer head.
 		 */
-		create = dio->rw & WRITE;
+		create = dio->op == REQ_OP_WRITE;
 		if (dio->flags & DIO_SKIP_HOLES) {
 			if (fs_startblk <= ((i_size_read(dio->inode) - 1) >>
 							i_blkbits))
@@ -789,7 +790,7 @@ submit_page_section(struct dio *dio, struct dio_submit *sdio, struct page *page,
 {
 	int ret = 0;
 
-	if (dio->rw & WRITE) {
+	if (dio->op == REQ_OP_WRITE) {
 		/*
 		 * Read accounting is performed in submit_bio()
 		 */
@@ -989,7 +990,7 @@ do_holes:
 				loff_t i_size_aligned;
 
 				/* AKPM: eargh, -ENOTBLK is a hack */
-				if (dio->rw & WRITE) {
+				if (dio->op == REQ_OP_WRITE) {
 					put_page(page);
 					return -ENOTBLK;
 				}
@@ -1203,7 +1204,12 @@ do_blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
 		dio->is_async = true;
 
 	dio->inode = inode;
-	dio->rw = iov_iter_rw(iter) == WRITE ? WRITE_ODIRECT : READ;
+	if (iov_iter_rw(iter) == WRITE) {
+		dio->op = REQ_OP_WRITE;
+		dio->op_flags = WRITE_ODIRECT;
+	} else {
+		dio->op = REQ_OP_READ;
+	}
 
 	/*
 	 * For AIO O_(D)SYNC writes we need to defer completions to a workqueue
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 62ca2f9..af6f3c7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2824,7 +2824,7 @@ extern int generic_file_open(struct inode * inode, struct file * filp);
 extern int nonseekable_open(struct inode * inode, struct file * filp);
 
 #ifdef CONFIG_BLOCK
-typedef void (dio_submit_t)(int rw, struct bio *bio, struct inode *inode,
+typedef void (dio_submit_t)(struct bio *bio, struct inode *inode,
 			    loff_t file_offset);
 
 enum {
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
