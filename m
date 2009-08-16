Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7GDwxUo254922 for <xfs@oss.sgi.com>; Sun, 16 Aug 2009 08:59:09 -0500
Received: from mail.rtr.ca (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6B9573D3FEA
	for <xfs@oss.sgi.com>; Sun, 16 Aug 2009 06:59:34 -0700 (PDT)
Received: from mail.rtr.ca (rtr.ca [76.10.145.34]) by cuda.sgi.com with ESMTP
	id IC88a6HNwS8QRv50 for <xfs@oss.sgi.com>;
	Sun, 16 Aug 2009 06:59:34 -0700 (PDT)
Message-ID: <4A8810C4.3050800@rtr.ca>
Date: Sun, 16 Aug 2009 09:59:32 -0400
From: Mark Lord <liml@rtr.ca>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfs: batched discard support
References: <20090816004705.GA7347@infradead.org> <4A876255.10606@rtr.ca>
	<4A876CA9.20906@rtr.ca> <20090816022500.GA12392@infradead.org>
	<4A8802F3.6010908@rtr.ca>
In-Reply-To: <4A8802F3.6010908@rtr.ca>
Content-Type: multipart/mixed; boundary="------------080808060703000702020109"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, IDE/ATA development list <linux-ide@vger.kernel.org>, jens.axboe@oracle.com, linux-fsdevel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080808060703000702020109
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Mark Lord wrote:
> Christoph Hellwig wrote:
>> On Sat, Aug 15, 2009 at 10:19:21PM -0400, Mark Lord wrote:
>>> Mark Lord wrote:
>>>> Christoph Hellwig wrote:
>>> ..
>>>>> Mark, any chance to try it?  Just create an XFS filesystem, age it a
>>>>> bit and then call the attached little trim.c program on the mountmoint
>>>>> (or any file inside the filesystem for that matter)
>>>> ..
>>>>
>>>> Looking at it now.  Thanks, Christoph!
>>> ..
>>>
>>> Fails to work on 64-bit kernel w/ 32-bit userspace (no compat ioctl).
>>> Rebuilding with 32-bit kernel now..
>>
>> The actual ioctl is compatible, just add the
>>
>>     case XFS_IOC_TRIM:
>>         return xfs_ioc_trim(mp, arg);
>>
>> to xfs_file_compat_ioctl().  I'll add this to the next spin of the patch.
> ..
> 
> Okay, this gives me ENOSYS now --> discard/trim support is missing from
> the lower layers.
> 
> What other patches do I need to make this work?
> 
> The latest from Matthew's discard tree (May 2009) don't appear to be sufficient,
> even after updating them for 2.6.31-rc6.
..

Okay, I got Matthews patches updated onto 2.6.31, and fixed the incompatibilities
between those and the XFS TRIM patch (from Christoph), plus a sector_t printk issue.

My apologies for attachments, but I am attaching the updated Christoph patch,
as well as my hacked-up forward-port of Matthew's patches.

Not pretty, but they work.  :)

Now.. running Christoph's "xfs trim" on a 4.6GB mostly already-trimmed
XFS partition gave this for the first time around:

[   25.961891] Filesystem "sdb3": discarding sectors [0xc558-0x102328]
[   27.814553] Filesystem "sdb3": discarding sectors [0x10ea78-0x10e688]
[   29.771218] Filesystem "sdb3": discarding sectors [0x21d120-0x10e860]
[   31.726444] Filesystem "sdb3": discarding sectors [0x32b9a0-0x10e860]
[   33.679023] Filesystem "sdb3": discarding sectors [0x43f220-0x109860]
[   35.629948] Filesystem "sdb3": discarding sectors [0x548aa0-0x10e860]
[   37.583142] Filesystem "sdb3": discarding sectors [0x657320-0x10e860]
[   39.531822] Filesystem "sdb3": discarding sectors [0x765ba0-0x10e860]

Slow, but presumably thorough.
Subsequent runs were equally slow.

The problem is, it still issues TRIMs to the LLD one extent at a time.
Compare this with doing it all in a single TRIM command
with the wiper.sh script (filesystem unmounted):

	[~] time wiper.sh /dev/sdb3 --commit
	
	wiper.sh: Linux SATA SSD TRIM utility, version 1.9b, by Mark Lord.
	Preparing for offline TRIM of free space on /dev/sdb3 (xfs non-mounted).
	This operation could destroy your data.  Are you sure (y/N)? y
	Syncing disks..
	Beginning TRIM operations..
	Trimming 168 free extents encompassing 8793136 sectors (4294 MB)
	Done.
	
	real    0m1.249s
	user    0m0.110s
	sys     0m0.063s

That includes the time for me to type 'y' and hit enter.  :)

Cheers

--------------080808060703000702020109
Content-Type: text/x-diff;
 name="51_add_trim_support.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="51_add_trim_support.patch"

diff -u --recursive --new-file --exclude-from=linux-2.6.31-rc6/Documentation/dontdiff --exclude='*.lds' --exclude-from=linux-2.6.31-rc6/.gitignore linux-2.6.31-rc6/block/blk-barrier.c linux/block/blk-barrier.c
--- linux-2.6.31-rc6/block/blk-barrier.c	2009-08-16 09:16:36.303766940 -0400
+++ linux/block/blk-barrier.c	2009-08-16 09:19:07.287086209 -0400
@@ -348,30 +348,22 @@
 		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	}
 
+	if (bio_has_data(bio))
+		__free_page(bio_page(bio));
+
+	if (bio->bi_private)
+		complete(bio->bi_private);
+
 	bio_put(bio);
 }
 
-/**
- * blkdev_issue_discard - queue a discard
- * @bdev:	blockdev to issue discard for
- * @sector:	start sector
- * @nr_sects:	number of sectors to discard
- * @gfp_mask:	memory allocation flags (for bio_alloc)
- *
- * Description:
- *    Issue a discard request for the sectors in question. Does not wait.
- */
-int blkdev_issue_discard(struct block_device *bdev,
-			 sector_t sector, sector_t nr_sects, gfp_t gfp_mask)
+int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
+				sector_t nr_sects, gfp_t gfp_mask,
+				unsigned type, struct completion *completion)
 {
-	struct request_queue *q;
-	struct bio *bio;
 	int ret = 0;
+	struct request_queue *q = bdev_get_queue(bdev);
 
-	if (bdev->bd_disk == NULL)
-		return -ENXIO;
-
-	q = bdev_get_queue(bdev);
 	if (!q)
 		return -ENXIO;
 
@@ -379,12 +371,13 @@
 		return -EOPNOTSUPP;
 
 	while (nr_sects && !ret) {
-		bio = bio_alloc(gfp_mask, 0);
+		struct bio *bio = bio_alloc(gfp_mask, 1);
 		if (!bio)
 			return -ENOMEM;
 
 		bio->bi_end_io = blkdev_discard_end_io;
 		bio->bi_bdev = bdev;
+		bio->bi_private = completion;
 
 		bio->bi_sector = sector;
 
@@ -396,10 +389,13 @@
 			bio->bi_size = nr_sects << 9;
 			nr_sects = 0;
 		}
+
 		bio_get(bio);
-		submit_bio(DISCARD_BARRIER, bio);
+		submit_bio(type, bio);
+
+		if (completion)
+			wait_for_completion(completion);
 
-		/* Check if it failed immediately */
 		if (bio_flagged(bio, BIO_EOPNOTSUPP))
 			ret = -EOPNOTSUPP;
 		else if (!bio_flagged(bio, BIO_UPTODATE))
@@ -408,4 +404,24 @@
 	}
 	return ret;
 }
+
+/**
+ * blkdev_issue_discard - queue a discard
+ * @bdev:	blockdev to issue discard for
+ * @sector:	start sector
+ * @nr_sects:	number of sectors to discard
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ *
+ * Description:
+ *    Issue a discard request for the sectors in question. Does not wait.
+ */
+int blkdev_issue_discard(struct block_device *bdev,
+			 sector_t sector, sector_t nr_sects, gfp_t gfp_mask)
+{
+	if (bdev->bd_disk == NULL)
+		return -ENXIO;
+
+	return __blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask,
+					DISCARD_BARRIER, NULL);
+}
 EXPORT_SYMBOL(blkdev_issue_discard);
diff -u --recursive --new-file --exclude-from=linux-2.6.31-rc6/Documentation/dontdiff --exclude='*.lds' --exclude-from=linux-2.6.31-rc6/.gitignore linux-2.6.31-rc6/block/blk-core.c linux/block/blk-core.c
--- linux-2.6.31-rc6/block/blk-core.c	2009-08-16 09:16:36.307099905 -0400
+++ linux/block/blk-core.c	2009-08-16 08:53:19.000000000 -0400
@@ -1107,6 +1107,8 @@
 
 void init_request_from_bio(struct request *req, struct bio *bio)
 {
+	might_sleep();
+
 	req->cpu = bio->bi_comp_cpu;
 	req->cmd_type = REQ_TYPE_FS;
 
@@ -1127,7 +1129,7 @@
 		req->cmd_flags |= REQ_DISCARD;
 		if (bio_barrier(bio))
 			req->cmd_flags |= REQ_SOFTBARRIER;
-		req->q->prepare_discard_fn(req->q, req);
+		req->q->prepare_discard_fn(req->q, req, bio);
 	} else if (unlikely(bio_barrier(bio)))
 		req->cmd_flags |= REQ_HARDBARRIER;
 
diff -u --recursive --new-file --exclude-from=linux-2.6.31-rc6/Documentation/dontdiff --exclude='*.lds' --exclude-from=linux-2.6.31-rc6/.gitignore linux-2.6.31-rc6/block/blk.h linux/block/blk.h
--- linux-2.6.31-rc6/block/blk.h	2009-08-16 09:16:36.310433289 -0400
+++ linux/block/blk.h	2009-08-16 08:53:19.000000000 -0400
@@ -17,6 +17,10 @@
 		      struct bio *bio);
 void blk_dequeue_request(struct request *rq);
 void __blk_queue_free_tags(struct request_queue *q);
+int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
+				sector_t nr_sects, gfp_t gfp_mask,
+				unsigned type, struct completion *completion);
+
 
 void blk_unplug_work(struct work_struct *work);
 void blk_unplug_timeout(unsigned long data);
diff -u --recursive --new-file --exclude-from=linux-2.6.31-rc6/Documentation/dontdiff --exclude='*.lds' --exclude-from=linux-2.6.31-rc6/.gitignore linux-2.6.31-rc6/block/ioctl.c linux/block/ioctl.c
--- linux-2.6.31-rc6/block/ioctl.c	2009-08-16 09:16:36.313766813 -0400
+++ linux/block/ioctl.c	2009-08-16 08:53:19.000000000 -0400
@@ -7,6 +7,7 @@
 #include <linux/smp_lock.h>
 #include <linux/blktrace_api.h>
 #include <asm/uaccess.h>
+#include "blk.h"
 
 static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user *arg)
 {
@@ -112,21 +113,10 @@
 	return res;
 }
 
-static void blk_ioc_discard_endio(struct bio *bio, int err)
-{
-	if (err) {
-		if (err == -EOPNOTSUPP)
-			set_bit(BIO_EOPNOTSUPP, &bio->bi_flags);
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
-	}
-	complete(bio->bi_private);
-}
-
 static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 			     uint64_t len)
 {
-	struct request_queue *q = bdev_get_queue(bdev);
-	int ret = 0;
+	DECLARE_COMPLETION_ONSTACK(wait);
 
 	if (start & 511)
 		return -EINVAL;
@@ -138,39 +128,8 @@
 	if (start + len > (bdev->bd_inode->i_size >> 9))
 		return -EINVAL;
 
-	if (!q->prepare_discard_fn)
-		return -EOPNOTSUPP;
-
-	while (len && !ret) {
-		DECLARE_COMPLETION_ONSTACK(wait);
-		struct bio *bio;
-
-		bio = bio_alloc(GFP_KERNEL, 0);
-
-		bio->bi_end_io = blk_ioc_discard_endio;
-		bio->bi_bdev = bdev;
-		bio->bi_private = &wait;
-		bio->bi_sector = start;
-
-		if (len > queue_max_hw_sectors(q)) {
-			bio->bi_size = queue_max_hw_sectors(q) << 9;
-			len -= queue_max_hw_sectors(q);
-			start += queue_max_hw_sectors(q);
-		} else {
-			bio->bi_size = len << 9;
-			len = 0;
-		}
-		submit_bio(DISCARD_NOBARRIER, bio);
-
-		wait_for_completion(&wait);
-
-		if (bio_flagged(bio, BIO_EOPNOTSUPP))
-			ret = -EOPNOTSUPP;
-		else if (!bio_flagged(bio, BIO_UPTODATE))
-			ret = -EIO;
-		bio_put(bio);
-	}
-	return ret;
+	return __blkdev_issue_discard(bdev, start, len, GFP_KERNEL,
+						DISCARD_NOBARRIER, &wait);
 }
 
 static int put_ushort(unsigned long arg, unsigned short val)
diff -u --recursive --new-file --exclude-from=linux-2.6.31-rc6/Documentation/dontdiff --exclude='*.lds' --exclude-from=linux-2.6.31-rc6/.gitignore linux-2.6.31-rc6/drivers/ata/libata-scsi.c linux/drivers/ata/libata-scsi.c
--- linux-2.6.31-rc6/drivers/ata/libata-scsi.c	2009-08-16 09:16:36.350433414 -0400
+++ linux/drivers/ata/libata-scsi.c	2009-08-16 08:53:19.000000000 -0400
@@ -1051,6 +1051,46 @@
 	desc[11] = block;
 }
 
+static int ata_discard_fn(struct request_queue *q, struct request *req,
+							struct bio *bio)
+{
+	unsigned size;
+	struct page *page = alloc_page(GFP_KERNEL);
+	if (!page)
+		goto error;
+
+	size = ata_set_lba_range_entries(page_address(page), PAGE_SIZE / 8,
+					bio->bi_sector, bio_sectors(bio));
+	bio->bi_size = 0;
+	if (bio_add_pc_page(q, bio, page, size, 0) < size)
+		goto free_page;
+
+	req->cmd_type = REQ_TYPE_BLOCK_PC;
+	req->cmd_len = 16;
+	req->cmd[0] = ATA_16;
+	req->cmd[1] = (6 << 1) | 1;		/* dma, 48-bit */
+	req->cmd[2] = 0x6;			/* length, direction */
+	req->cmd[3] = 0;			/* feature high */
+	req->cmd[4] = ATA_DSM_TRIM;		/* feature low */
+	req->cmd[5] = (size / 512) >> 8;	/* nsect high */
+	req->cmd[6] = size / 512;		/* nsect low */
+	req->cmd[7] = 0;			/* lba */
+	req->cmd[8] = 0;			/* lba */
+	req->cmd[9] = 0;			/* lba */
+	req->cmd[10] = 0;			/* lba */
+	req->cmd[11] = 0;			/* lba */
+	req->cmd[12] = 0;			/* lba */
+	req->cmd[13] = ATA_LBA;			/* device */
+	req->cmd[14] = ATA_CMD_DSM;		/* command */
+	req->cmd[15] = 0;			/* control */
+
+	return 0;
+ free_page:
+	__free_page(page);
+ error:
+	return -ENOMEM;
+}
+
 static void ata_scsi_sdev_config(struct scsi_device *sdev)
 {
 	sdev->use_10_for_rw = 1;
@@ -1099,6 +1139,9 @@
 	/* configure max sectors */
 	blk_queue_max_sectors(sdev->request_queue, dev->max_sectors);
 
+	if (ata_id_has_trim(dev->id))
+		blk_queue_set_discard(sdev->request_queue, ata_discard_fn);
+
 	if (dev->class == ATA_DEV_ATAPI) {
 		struct request_queue *q = sdev->request_queue;
 		void *buf;
@@ -1747,6 +1790,12 @@
 	 * whether the command completed successfully or not. If there
 	 * was no error, SK, ASC and ASCQ will all be zero.
 	 */
+
+	if (need_sense && qc->tf.command == ATA_CMD_DSM) {
+		ata_port_printk(ap, KERN_ERR, "%s: DISCARD/TRIM failed: disabling it\n", __func__);
+		blk_queue_set_discard(qc->dev->sdev->request_queue, NULL);
+	}
+
 	if (((cdb[0] == ATA_16) || (cdb[0] == ATA_12)) &&
 	    ((cdb[2] & 0x20) || need_sense)) {
 		ata_gen_passthru_sense(qc);
diff -u --recursive --new-file --exclude-from=linux-2.6.31-rc6/Documentation/dontdiff --exclude='*.lds' --exclude-from=linux-2.6.31-rc6/.gitignore linux-2.6.31-rc6/drivers/mtd/mtd_blkdevs.c linux/drivers/mtd/mtd_blkdevs.c
--- linux-2.6.31-rc6/drivers/mtd/mtd_blkdevs.c	2009-08-16 09:16:36.963766818 -0400
+++ linux/drivers/mtd/mtd_blkdevs.c	2009-08-16 08:53:19.000000000 -0400
@@ -33,7 +33,7 @@
 };
 
 static int blktrans_discard_request(struct request_queue *q,
-				    struct request *req)
+				    struct request *req, struct bio *bio)
 {
 	req->cmd_type = REQ_TYPE_LINUX_BLOCK;
 	req->cmd[0] = REQ_LB_OP_DISCARD;
diff -u --recursive --new-file --exclude-from=linux-2.6.31-rc6/Documentation/dontdiff --exclude='*.lds' --exclude-from=linux-2.6.31-rc6/.gitignore linux-2.6.31-rc6/include/linux/blkdev.h linux/include/linux/blkdev.h
--- linux-2.6.31-rc6/include/linux/blkdev.h	2009-08-16 09:16:39.053766322 -0400
+++ linux/include/linux/blkdev.h	2009-08-16 08:53:19.000000000 -0400
@@ -255,7 +255,8 @@
 typedef int (make_request_fn) (struct request_queue *q, struct bio *bio);
 typedef int (prep_rq_fn) (struct request_queue *, struct request *);
 typedef void (unplug_fn) (struct request_queue *);
-typedef int (prepare_discard_fn) (struct request_queue *, struct request *);
+typedef int (prepare_discard_fn) (struct request_queue *, struct request *,
+							struct bio *bio);
 
 struct bio_vec;
 struct bvec_merge_data {
diff -u --recursive --new-file --exclude-from=linux-2.6.31-rc6/Documentation/dontdiff --exclude='*.lds' --exclude-from=linux-2.6.31-rc6/.gitignore linux-2.6.31-rc6/include/linux/fs.h linux/include/linux/fs.h
--- linux-2.6.31-rc6/include/linux/fs.h	2009-08-16 09:16:39.070433246 -0400
+++ linux/include/linux/fs.h	2009-08-16 08:53:19.000000000 -0400
@@ -161,8 +161,8 @@
  * These aren't really reads or writes, they pass down information about
  * parts of device that are now unused by the file system.
  */
-#define DISCARD_NOBARRIER (1 << BIO_RW_DISCARD)
-#define DISCARD_BARRIER ((1 << BIO_RW_DISCARD) | (1 << BIO_RW_BARRIER))
+#define DISCARD_NOBARRIER (WRITE | (1 << BIO_RW_DISCARD))
+#define DISCARD_BARRIER (DISCARD_NOBARRIER | (1 << BIO_RW_BARRIER))
 
 #define SEL_IN		1
 #define SEL_OUT		2

--------------080808060703000702020109
Content-Type: text/x-diff;
 name="52_christoph_xfs_trim.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="52_christoph_xfs_trim.patch"

diff -u --recursive --new-file --exclude-from=linux-2.6.31-rc6//Documentation/dontdiff --exclude='*.lds' --exclude-from=linux-2.6.31-rc6//.gitignore linux-2.6.31-rc6/block/blk-barrier.c linux/block/blk-barrier.c
--- linux-2.6.31-rc6/block/blk-barrier.c	2009-08-16 09:36:36.431146680 -0400
+++ linux/block/blk-barrier.c	2009-08-16 09:20:15.164578531 -0400
@@ -425,3 +425,4 @@
 					DISCARD_BARRIER, NULL);
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
+EXPORT_SYMBOL(__blkdev_issue_discard);
diff -u --recursive --new-file --exclude-from=linux-2.6.31-rc6//Documentation/dontdiff --exclude='*.lds' --exclude-from=linux-2.6.31-rc6//.gitignore linux-2.6.31-rc6/fs/xfs/linux-2.6/xfs_ioctl.c linux/fs/xfs/linux-2.6/xfs_ioctl.c
--- linux-2.6.31-rc6/fs/xfs/linux-2.6/xfs_ioctl.c	2009-08-16 09:16:39.000433070 -0400
+++ linux/fs/xfs/linux-2.6/xfs_ioctl.c	2009-08-16 09:30:38.973683042 -0400
@@ -1274,6 +1274,31 @@
 	return 0;
 }
 
+int
+xfs_ioc_trim(
+	struct xfs_mount	*mp,
+	__uint32_t		*argp)
+{
+	xfs_agnumber_t		agno;
+	int			error = 0;
+	__uint32_t		minlen;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+	if (get_user(minlen, argp))
+		return -EFAULT;
+
+	down_read(&mp->m_peraglock);
+	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
+		error = -xfs_trim_extents(mp, agno, minlen);
+		if (error)
+			break;
+	}
+	up_read(&mp->m_peraglock);
+
+	return error;
+}
+
 /*
  * Note: some of the ioctl's return positive numbers as a
  * byte count indicating success, such as readlink_by_handle.
@@ -1523,6 +1548,9 @@
 		error = xfs_errortag_clearall(mp, 1);
 		return -error;
 
+	case XFS_IOC_TRIM:
+		return xfs_ioc_trim(mp, arg);
+
 	default:
 		return -ENOTTY;
 	}
diff -u --recursive --new-file --exclude-from=linux-2.6.31-rc6//Documentation/dontdiff --exclude='*.lds' --exclude-from=linux-2.6.31-rc6//.gitignore linux-2.6.31-rc6/fs/xfs/linux-2.6/xfs_ioctl32.c linux/fs/xfs/linux-2.6/xfs_ioctl32.c
--- linux-2.6.31-rc6/fs/xfs/linux-2.6/xfs_ioctl32.c	2009-06-09 23:05:27.000000000 -0400
+++ linux/fs/xfs/linux-2.6/xfs_ioctl32.c	2009-08-16 09:31:21.005588977 -0400
@@ -539,6 +539,7 @@
 	void			__user *arg = (void __user *)p;
 	int			ioflags = 0;
 	int			error;
+	extern int xfs_ioc_trim(struct xfs_mount *mp, __uint32_t *argp);
 
 	if (filp->f_mode & FMODE_NOCMTIME)
 		ioflags |= IO_INVIS;
@@ -564,6 +565,8 @@
 	case XFS_IOC_ERROR_INJECTION:
 	case XFS_IOC_ERROR_CLEARALL:
 		return xfs_file_ioctl(filp, cmd, p);
+	case XFS_IOC_TRIM:
+		return xfs_ioc_trim(mp, arg);
 #ifndef BROKEN_X86_ALIGNMENT
 	/* These are handled fine if no alignment issues */
 	case XFS_IOC_ALLOCSP:
diff -u --recursive --new-file --exclude-from=linux-2.6.31-rc6//Documentation/dontdiff --exclude='*.lds' --exclude-from=linux-2.6.31-rc6//.gitignore linux-2.6.31-rc6/fs/xfs/xfs_alloc.h linux/fs/xfs/xfs_alloc.h
--- linux-2.6.31-rc6/fs/xfs/xfs_alloc.h	2009-06-09 23:05:27.000000000 -0400
+++ linux/fs/xfs/xfs_alloc.h	2009-08-16 09:20:15.167913313 -0400
@@ -215,4 +215,7 @@
 	xfs_fsblock_t	bno,	/* starting block number of extent */
 	xfs_extlen_t	len);	/* length of extent */
 
+int xfs_trim_extents(struct xfs_mount *mp, xfs_agnumber_t agno,
+	xfs_extlen_t minlen);
+
 #endif	/* __XFS_ALLOC_H__ */
diff -u --recursive --new-file --exclude-from=linux-2.6.31-rc6//Documentation/dontdiff --exclude='*.lds' --exclude-from=linux-2.6.31-rc6//.gitignore linux-2.6.31-rc6/fs/xfs/xfs_fs.h linux/fs/xfs/xfs_fs.h
--- linux-2.6.31-rc6/fs/xfs/xfs_fs.h	2009-08-16 09:16:39.017099926 -0400
+++ linux/fs/xfs/xfs_fs.h	2009-08-16 09:20:15.171246419 -0400
@@ -475,6 +475,7 @@
 #define XFS_IOC_ATTRMULTI_BY_HANDLE  _IOW ('X', 123, struct xfs_fsop_attrmulti_handlereq)
 #define XFS_IOC_FSGEOMETRY	     _IOR ('X', 124, struct xfs_fsop_geom)
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
+#define XFS_IOC_TRIM		     _IOR ('X', 126, __uint32_t)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
 
--- linux-2.6.31-rc6/fs/xfs/xfs_alloc.c	2009-06-09 23:05:27.000000000 -0400
+++ linux/fs/xfs/xfs_alloc.c	2009-08-16 09:44:51.073580438 -0400
@@ -39,6 +39,9 @@
 #include "xfs_alloc.h"
 #include "xfs_error.h"
 
+int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
+				sector_t nr_sects, gfp_t gfp_mask,
+				unsigned type, struct completion *completion);
 
 #define XFS_ABSDIFF(a,b)	(((a) <= (b)) ? ((b) - (a)) : ((a) - (b)))
 
@@ -2609,6 +2612,97 @@
 	return error;
 }
 
+STATIC int
+xfs_trim_extent(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_agblock_t		fbno,
+	xfs_extlen_t		flen)
+{
+	xfs_daddr_t		blkno = XFS_AGB_TO_DADDR(mp, agno, fbno);
+	sector_t		nblks = XFS_FSB_TO_BB(mp, flen);
+	int			error;
+	DECLARE_COMPLETION_ONSTACK(done);
+
+	xfs_fs_cmn_err(CE_NOTE, mp, "discarding sectors [0x%llx-0x%llx]",
+			blkno, (u64)nblks);
+
+	error = -__blkdev_issue_discard(mp->m_ddev_targp->bt_bdev,
+			blkno, nblks, GFP_NOFS, DISCARD_BARRIER, &done);
+	if (error && error != EOPNOTSUPP)
+		xfs_fs_cmn_err(CE_NOTE, mp, "discard failed, error %d", error);
+	return error;
+}
+
+/*
+ * Notify the underlying block device about our free extent map.
+ *
+ * This walks all free extents above a minimum threshold and notifies the
+ * underlying device that these blocks are unused.  That information is
+ * useful for SSDs or thinly provisioned storage in high end arrays or
+ * virtualization scenarios.
+ */
+int
+xfs_trim_extents(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno,
+	xfs_extlen_t		minlen)	/* minimum extent size to bother */
+{
+	struct xfs_btree_cur	*cur;	/* cursor for the by-block btree */
+	struct xfs_buf		*agbp;	/* AGF buffer pointer */
+	xfs_agblock_t		bno;	/* block the for next search */
+	xfs_agblock_t		fbno;	/* start block of found extent */
+	xfs_extlen_t		flen;	/* length of found extent */
+	int			error;
+	int			i;
+
+	error = xfs_alloc_read_agf(mp, NULL, agno, 0, &agbp);
+	if (error)
+		return error;
+
+	bno = 0;
+	for (;;) {
+		cur = xfs_allocbt_init_cursor(mp, NULL, agbp, agno,
+					      XFS_BTNUM_BNO);
+
+		error = xfs_alloc_lookup_ge(cur, bno, minlen, &i);
+		if (error)
+			goto error0;
+		if (!i) {
+			/*
+			 * No more free extents found: done.
+			 */
+			xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+			break;
+		}
+
+		error = xfs_alloc_get_rec(cur, &fbno, &flen, &i);
+		if (error)
+			goto error0;
+		XFS_WANT_CORRUPTED_GOTO(i == 1, error0);
+
+		/*
+		 * Pass if the freespace extent isn't long enough to bother.
+		 */
+		if (flen >= minlen) {
+			error = xfs_trim_extent(mp, agno, fbno, flen);
+			if (error) {
+				xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+				break;
+			}
+		}
+
+		xfs_btree_del_cursor(cur, XFS_BTREE_NOERROR);
+		bno = fbno + flen;
+	}
+
+out:
+	xfs_buf_relse(agbp);
+	return error;
+error0:
+	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
+	goto out;
+}
 
 /*
  * AG Busy list management

--------------080808060703000702020109
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------080808060703000702020109--
