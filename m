Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 949CE29E57
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 14:55:16 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 32766AC005
	for <xfs@oss.sgi.com>; Tue,  5 Jan 2016 12:55:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id rSDCUKmjx4vCDVED (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 05 Jan 2016 12:55:14 -0800 (PST)
From: mchristi@redhat.com
Subject: [PATCH 32/35] block: shrink bi_rw and bi_op
Date: Tue,  5 Jan 2016 14:53:35 -0600
Message-Id: <1452027218-32303-33-git-send-email-mchristi@redhat.com>
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

There is no need for bi_op/op and bi_rw to be so large
now, so this patch shrinks them.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 block/blk-core.c           |  2 +-
 drivers/md/dm-flakey.c     |  2 +-
 drivers/md/raid5.c         | 13 +++++++------
 fs/btrfs/check-integrity.c |  4 ++--
 fs/btrfs/inode.c           |  2 +-
 include/linux/bio.h        | 13 ++-----------
 include/linux/blk_types.h  | 11 +++--------
 include/linux/blkdev.h     |  2 +-
 8 files changed, 18 insertions(+), 31 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 0f6cb5c..ae2afab 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1854,7 +1854,7 @@ static void handle_bad_sector(struct bio *bio)
 	char b[BDEVNAME_SIZE];
 
 	printk(KERN_INFO "attempt to access beyond end of device\n");
-	printk(KERN_INFO "%s: rw=%d,%ld, want=%Lu, limit=%Lu\n",
+	printk(KERN_INFO "%s: rw=%d,%u, want=%Lu, limit=%Lu\n",
 			bdevname(bio->bi_bdev, b),
 			bio->bi_op, bio->bi_rw,
 			(unsigned long long)bio_end_sector(bio),
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 09e2afc..b831226 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -266,7 +266,7 @@ static void corrupt_bio_data(struct bio *bio, struct flakey_c *fc)
 		data[fc->corrupt_bio_byte - 1] = fc->corrupt_bio_value;
 
 		DMDEBUG("Corrupting data bio=%p by writing %u to byte %u "
-			"(rw=%c bi_rw=%lu bi_sector=%llu cur_bytes=%u)\n",
+			"(rw=%c bi_rw=%u bi_sector=%llu cur_bytes=%u)\n",
 			bio, fc->corrupt_bio_value, fc->corrupt_bio_byte,
 			(bio_data_dir(bio) == WRITE) ? 'w' : 'r', bio->bi_rw,
 			(unsigned long long)bio->bi_iter.bi_sector, bio_bytes);
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index fa4fe95..aafd49e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1015,9 +1015,9 @@ again:
 				: raid5_end_read_request;
 			bi->bi_private = sh;
 
-			pr_debug("%s: for %llu schedule op %ld on disc %d\n",
+			pr_debug("%s: for %llu schedule op %d,%u on disc %d\n",
 				__func__, (unsigned long long)sh->sector,
-				bi->bi_rw, i);
+				bi->bi_op, bi->bi_rw, i);
 			atomic_inc(&sh->count);
 			if (sh != head_sh)
 				atomic_inc(&head_sh->count);
@@ -1067,10 +1067,10 @@ again:
 			rbi->bi_end_io = raid5_end_write_request;
 			rbi->bi_private = sh;
 
-			pr_debug("%s: for %llu schedule op %ld on "
+			pr_debug("%s: for %llu schedule op %d,%u on "
 				 "replacement disc %d\n",
 				__func__, (unsigned long long)sh->sector,
-				rbi->bi_rw, i);
+				rbi->bi_op, rbi->bi_rw, i);
 			atomic_inc(&sh->count);
 			if (sh != head_sh)
 				atomic_inc(&head_sh->count);
@@ -1102,8 +1102,9 @@ again:
 		if (!rdev && !rrdev) {
 			if (op_is_write(op))
 				set_bit(STRIPE_DEGRADED, &sh->state);
-			pr_debug("skip op %ld on disc %d for sector %llu\n",
-				bi->bi_rw, i, (unsigned long long)sh->sector);
+			pr_debug("skip op %d,%u on disc %d for sector %llu\n",
+				 bi->bi_op, bi->bi_rw, i,
+				 (unsigned long long)sh->sector);
 			clear_bit(R5_LOCKED, &sh->dev[i].flags);
 			set_bit(STRIPE_HANDLE, &sh->state);
 		}
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index e409d1f..1623d11 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2985,7 +2985,7 @@ static void __btrfsic_submit_bio(struct bio *bio)
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			printk(KERN_INFO
-			       "submit_bio(rw=%d,0x%lx, bi_vcnt=%u,"
+			       "submit_bio(rw=%d,0x%x, bi_vcnt=%u,"
 			       " bi_sector=%llu (bytenr %llu), bi_bdev=%p)\n",
 			       bio->bi_op, bio->bi_rw, bio->bi_vcnt,
 			       (unsigned long long)bio->bi_iter.bi_sector,
@@ -3028,7 +3028,7 @@ static void __btrfsic_submit_bio(struct bio *bio)
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			printk(KERN_INFO
-			       "submit_bio(rw=%d,0x%lx FLUSH, bdev=%p)\n",
+			       "submit_bio(rw=%d,0x%x FLUSH, bdev=%p)\n",
 			       bio->bi_op, bio->bi_rw, bio->bi_bdev);
 		if (!dev_state->dummy_block_for_bio_bh_flush.is_iodone) {
 			if ((dev_state->state->print_mask &
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index a96984f..b9c3799 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8061,7 +8061,7 @@ static void btrfs_end_dio_bio(struct bio *bio)
 
 	if (err)
 		btrfs_warn(BTRFS_I(dip->inode)->root->fs_info,
-			   "direct IO failed ino %llu rw %d,%lu sector %#Lx len %u err no %d",
+			   "direct IO failed ino %llu rw %d,0x%x sector %#Lx len %u err no %d",
 			   btrfs_ino(dip->inode), bio->bi_op, bio->bi_rw,
 			   (unsigned long long)bio->bi_iter.bi_sector,
 			   bio->bi_iter.bi_size, err);
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 1e4b3b5..c91afc1 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -44,18 +44,9 @@
 #define BIO_MAX_SIZE		(BIO_MAX_PAGES << PAGE_CACHE_SHIFT)
 #define BIO_MAX_SECTORS		(BIO_MAX_SIZE >> 9)
 
-/*
- * upper 16 bits of bi_rw define the io priority of this bio
- */
-#define BIO_PRIO_SHIFT	(8 * sizeof(unsigned long) - IOPRIO_BITS)
-#define bio_prio(bio)	((bio)->bi_rw >> BIO_PRIO_SHIFT)
+#define bio_prio(bio)		(bio)->bi_ioprio
 #define bio_prio_valid(bio)	ioprio_valid(bio_prio(bio))
-
-#define bio_set_prio(bio, prio)		do {			\
-	WARN_ON(prio >= (1 << IOPRIO_BITS));			\
-	(bio)->bi_rw &= ((1UL << BIO_PRIO_SHIFT) - 1);		\
-	(bio)->bi_rw |= ((unsigned long) (prio) << BIO_PRIO_SHIFT);	\
-} while (0)
+#define bio_set_prio(bio, prio)	((bio)->bi_ioprio = prio)
 
 /*
  * various member access, note that bio_data should of course not be used
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index bb30c2b..5d19b393 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -48,14 +48,9 @@ struct bio {
 	struct block_device	*bi_bdev;
 	unsigned int		bi_flags;	/* status, command, etc */
 	int			bi_error;
-	unsigned long		bi_rw;		/* bottom bits rq_flags_bits
-						 * top bits priority
-						 */
-	/*
-	 * this will be a u8 in the next patches and bi_rw can be shrunk to
-	 * a u32. For compat in these transistional patches op is a int here.
-	 */
-	int			bi_op;		/* REQ_OP */
+	unsigned int		bi_rw;		/* rq_flag_bits */
+	unsigned short		bi_ioprio;
+	u8			bi_op;		/* REQ_OP */
 
 
 	struct bvec_iter	bi_iter;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bc024c7..83d6f033 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -96,7 +96,7 @@ struct request {
 	struct request_queue *q;
 	struct blk_mq_ctx *mq_ctx;
 
-	int op;
+	u8 op;
 	u64 cmd_flags;
 	unsigned cmd_type;
 	unsigned long atomic_flags;
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
