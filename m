Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8CC037CA0
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 15:05:07 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5FE118F8037
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 13:05:04 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0LDzpe8YOqSI5g7d (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 13:05:03 -0700 (PDT)
Date: Tue, 12 Apr 2016 16:04:59 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH] block: wire blkdev_fallocate() to
	block_device_operations' reserve_space
Message-ID: <20160412200459.GA10730@redhat.com>
References: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1460479373-63317-1-git-send-email-bfoster@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, dm-devel@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>, xfs@oss.sgi.com

On Tue, Apr 12 2016 at 12:42P -0400,
Brian Foster <bfoster@redhat.com> wrote:

> Hi all,
> 
> This is v2 of the XFS and block device reservation experiment. The
> significant changes in v2 are that the bdev interface has been condensed
> to a single callback function, the XFS transaction reservation
> management has been reworked to make transactions responsible for
> tracking and releasing excess reservation (for non-delalloc cases) and a
> workaround for the fallocate over-reservation issue is included. Beyond
> that, this version adds a bunch of miscellaneous cleanups and fixes some
> of the nastier locking/leak issues present in the first rfc.
> 
> Patches 1-2 refactor some XFS reserve pool and block accounting code in
> preparation for subsequent patches. Patches 3-5 add block/device-mapper
> reservation support. Patches 6-10 add the core reservation
> infrastructure and management bits to XFS. See the link to the original
> rfc below for instructions and further details around the purpose of
> this series.
> 
> Finally, note that this is still highly experimental/theoretical and
> should not be used on production systems. Thoughts, reviews, flames
> appreciated.

Thanks for carrying on with this work Brian.

I've started to review your patchset and Darrick's fallocate patchset.
I've pushed a branch to linux-dm.git that combines the 2, see:
https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/log/?h=dm-fallocate

and then added this RFC patch, at the end, which relies on both of your
patchsets -- you'll see blkdev_ensure_space_exists() has a FIXME which
implies it isn't much more than simply stubbed out at this point
(completely untested):

From: Mike Snitzer <snitzer@redhat.com>
Date: Tue, 12 Apr 2016 15:54:31 -0400
Subject: [RFC PATCH] block: wire blkdev_fallocate() to block_device_operations' reserve_space

This effectively exposes the primitive for "ensure space exists".  It
relies on block_device_operations' reserve_space method.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-lib.c        | 26 ++++++++++++++++++++++++++
 fs/block_dev.c         | 20 +++++++++++---------
 include/linux/blkdev.h |  2 ++
 3 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 9dca6bb..5042a84 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -314,3 +314,29 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	return __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask);
 }
 EXPORT_SYMBOL(blkdev_issue_zeroout);
+
+/**
+ * blkdev_ensure_space_exists - preallocate a block range
+ * @bdev:	blockdev to preallocate space for
+ * @sector:	start sector
+ * @nr_sects:	number of sectors to preallocate
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ * @flags:	FALLOC_FL_* to control behaviour
+ *
+ * Description:
+ *    Ensure space exists, or is preallocated, for the sectors in question.
+ */
+int blkdev_ensure_space_exists(struct block_device *bdev, sector_t sector,
+		sector_t nr_sects, unsigned long flags)
+{
+	sector_t res;
+	const struct block_device_operations *ops = bdev->bd_disk->fops;
+
+	if (!ops->reserve_space)
+		return -EOPNOTSUPP;
+
+	// FIXME: check with Brian Foster on whether it makes sense to
+	// use BDEV_RES_GET/BDEV_RES_MOD instead of BDEV_RES_PROVISION?
+	return ops->reserve_space(bdev, BDEV_RES_PROVISION, sector, nr_sects, &res);
+}
+EXPORT_SYMBOL(blkdev_ensure_space_exists);
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 5a2c3ab..b34c07b 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1801,17 +1801,13 @@ long blkdev_fallocate(struct file *file, int mode, loff_t start, loff_t len)
 	struct request_queue *q = bdev_get_queue(bdev);
 	struct address_space *mapping;
 	loff_t end = start + len - 1;
-	loff_t bs_mask, isize;
+	loff_t isize;
 	int error;
 
 	/* We only support zero range and punch hole. */
 	if (mode & ~BLKDEV_FALLOC_FL_SUPPORTED)
 		return -EOPNOTSUPP;
 
-	/* We haven't a primitive for "ensure space exists" right now. */
-	if (!(mode & ~FALLOC_FL_KEEP_SIZE))
-		return -EOPNOTSUPP;
-
 	/* Only punch if the device can do zeroing discard. */
 	if ((mode & FALLOC_FL_PUNCH_HOLE) &&
 	    (!blk_queue_discard(q) || !q->limits.discard_zeroes_data))
@@ -1829,9 +1825,12 @@ long blkdev_fallocate(struct file *file, int mode, loff_t start, loff_t len)
 			return -EINVAL;
 	}
 
-	/* Don't allow IO that isn't aligned to logical block size */
-	bs_mask = bdev_logical_block_size(bdev) - 1;
-	if ((start | len) & bs_mask)
+	/*
+	 * Don't allow IO that isn't aligned to minimum IO size (io_min)
+	 * - for normal device's io_min is usually logical block size
+	 * - but for more exotic devices (e.g. DM thinp) it may be larger
+	 */
+	if ((start | len) % bdev_io_min(bdev))
 		return -EINVAL;
 
 	/* Invalidate the page cache, including dirty pages. */
@@ -1839,7 +1838,10 @@ long blkdev_fallocate(struct file *file, int mode, loff_t start, loff_t len)
 	truncate_inode_pages_range(mapping, start, end);
 
 	error = -EINVAL;
-	if (mode & FALLOC_FL_ZERO_RANGE)
+	if (!(mode & ~FALLOC_FL_KEEP_SIZE))
+		error = blkdev_ensure_space_exists(bdev, start >> 9, len >> 9,
+						   mode);
+	else if (mode & FALLOC_FL_ZERO_RANGE)
 		error = blkdev_issue_zeroout(bdev, start >> 9, len >> 9,
 					    GFP_KERNEL, false);
 	else if (mode & FALLOC_FL_PUNCH_HOLE)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6c6ea96..4147af2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1132,6 +1132,8 @@ extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, bool discard);
+extern int blkdev_ensure_space_exists(struct block_device *bdev, sector_t sector,
+		sector_t nr_sects, unsigned long flags);
 static inline int sb_issue_discard(struct super_block *sb, sector_t block,
 		sector_t nr_blocks, gfp_t gfp_mask, unsigned long flags)
 {
-- 
2.6.4 (Apple Git-63)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
