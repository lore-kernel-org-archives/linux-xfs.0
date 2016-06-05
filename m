Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id B2E137D68
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 14:34:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 3BB91AC005
	for <xfs@oss.sgi.com>; Sun,  5 Jun 2016 12:34:08 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VBD9nkilYv0uzDiK (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 05 Jun 2016 12:34:07 -0700 (PDT)
From: mchristi@redhat.com
Subject: [PATCH 41/45] block, drivers, fs: shrink bi_rw from long to int
Date: Sun,  5 Jun 2016 14:32:21 -0500
Message-Id: <1465155145-10812-42-git-send-email-mchristi@redhat.com>
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

We don't need bi_rw to be so large on 64 bit archs, so
reduce it to unsigned int.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 block/blk-core.c           | 2 +-
 drivers/md/dm-flakey.c     | 2 +-
 drivers/md/raid5.c         | 6 +++---
 fs/btrfs/check-integrity.c | 4 ++--
 fs/btrfs/inode.c           | 2 +-
 include/linux/blk_types.h  | 2 +-
 6 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index f9f4228..c7d66c2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1853,7 +1853,7 @@ static void handle_bad_sector(struct bio *bio)
 	char b[BDEVNAME_SIZE];
 
 	printk(KERN_INFO "attempt to access beyond end of device\n");
-	printk(KERN_INFO "%s: rw=%ld, want=%Lu, limit=%Lu\n",
+	printk(KERN_INFO "%s: rw=%d, want=%Lu, limit=%Lu\n",
 			bdevname(bio->bi_bdev, b),
 			bio->bi_rw,
 			(unsigned long long)bio_end_sector(bio),
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index b7341de..29b99fb 100644
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
index e35c163..b9122e2 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -1001,7 +1001,7 @@ again:
 				: raid5_end_read_request;
 			bi->bi_private = sh;
 
-			pr_debug("%s: for %llu schedule op %ld on disc %d\n",
+			pr_debug("%s: for %llu schedule op %d on disc %d\n",
 				__func__, (unsigned long long)sh->sector,
 				bi->bi_rw, i);
 			atomic_inc(&sh->count);
@@ -1052,7 +1052,7 @@ again:
 			rbi->bi_end_io = raid5_end_write_request;
 			rbi->bi_private = sh;
 
-			pr_debug("%s: for %llu schedule op %ld on "
+			pr_debug("%s: for %llu schedule op %d on "
 				 "replacement disc %d\n",
 				__func__, (unsigned long long)sh->sector,
 				rbi->bi_rw, i);
@@ -1087,7 +1087,7 @@ again:
 		if (!rdev && !rrdev) {
 			if (op_is_write(op))
 				set_bit(STRIPE_DEGRADED, &sh->state);
-			pr_debug("skip op %ld on disc %d for sector %llu\n",
+			pr_debug("skip op %d on disc %d for sector %llu\n",
 				bi->bi_rw, i, (unsigned long long)sh->sector);
 			clear_bit(R5_LOCKED, &sh->dev[i].flags);
 			set_bit(STRIPE_HANDLE, &sh->state);
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index 80a4389..da944ff 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -2943,7 +2943,7 @@ static void __btrfsic_submit_bio(struct bio *bio)
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			printk(KERN_INFO
-			       "submit_bio(rw=%d,0x%lx, bi_vcnt=%u,"
+			       "submit_bio(rw=%d,0x%x, bi_vcnt=%u,"
 			       " bi_sector=%llu (bytenr %llu), bi_bdev=%p)\n",
 			       bio_op(bio), bio->bi_rw, bio->bi_vcnt,
 			       (unsigned long long)bio->bi_iter.bi_sector,
@@ -2986,7 +2986,7 @@ static void __btrfsic_submit_bio(struct bio *bio)
 		if (dev_state->state->print_mask &
 		    BTRFSIC_PRINT_MASK_SUBMIT_BIO_BH)
 			printk(KERN_INFO
-			       "submit_bio(rw=%d,0x%lx FLUSH, bdev=%p)\n",
+			       "submit_bio(rw=%d,0x%x FLUSH, bdev=%p)\n",
 			       bio_op(bio), bio->bi_rw, bio->bi_bdev);
 		if (!dev_state->dummy_block_for_bio_bh_flush.is_iodone) {
 			if ((dev_state->state->print_mask &
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 128b02b..412e582 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8173,7 +8173,7 @@ static void btrfs_end_dio_bio(struct bio *bio)
 
 	if (err)
 		btrfs_warn(BTRFS_I(dip->inode)->root->fs_info,
-			   "direct IO failed ino %llu rw %d,%lu sector %#Lx len %u err no %d",
+			   "direct IO failed ino %llu rw %d,%u sector %#Lx len %u err no %d",
 			   btrfs_ino(dip->inode), bio_op(bio), bio->bi_rw,
 			   (unsigned long long)bio->bi_iter.bi_sector,
 			   bio->bi_iter.bi_size, err);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 2738413..5efb6f1 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -48,7 +48,7 @@ struct bio {
 	struct block_device	*bi_bdev;
 	unsigned int		bi_flags;	/* status, command, etc */
 	int			bi_error;
-	unsigned long		bi_rw;		/* READ/WRITE */
+	unsigned int		bi_rw;		/* READ/WRITE */
 	unsigned short		bi_ioprio;
 
 	struct bvec_iter	bi_iter;
-- 
2.7.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
