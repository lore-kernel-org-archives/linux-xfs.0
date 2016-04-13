Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id E21757CA2
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 23:02:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 570198F8037
	for <xfs@oss.sgi.com>; Tue, 12 Apr 2016 21:02:13 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id SSs2U9VR7Ln5PfZw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Apr 2016 21:02:11 -0700 (PDT)
Subject: [PATCH 3/3] block: implement (some of) fallocate for block devices
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 12 Apr 2016 21:01:42 -0700
Message-ID: <20160413040142.10562.42269.stgit@birch.djwong.org>
In-Reply-To: <20160413040121.10562.98998.stgit@birch.djwong.org>
References: <20160413040121.10562.98998.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: darrick.wong@oracle.com
Cc: axboe@kernel.dk, linux-block@vger.kernel.org, tytso@mit.edu, martin.petersen@oracle.com, snitzer@redhat.com, linux-api@vger.kernel.org, bfoster@redhat.com, xfs@oss.sgi.com, hch@infradead.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org

After much discussion, it seems that the fallocate feature flag
FALLOC_FL_ZERO_RANGE maps nicely to SCSI WRITE SAME; and the feature
FALLOC_FL_PUNCH_HOLE maps nicely to the devices that have been
whitelisted for zeroing SCSI UNMAP.  Punch still requires that
FALLOC_FL_KEEP_SIZE is set.  A length that goes past the end of the
device will be clamped to the device size if KEEP_SIZE is set; or will
return -EINVAL if not.  Both start and length must be aligned to the
device's logical block size.

Since the semantics of fallocate are fairly well established already,
wire up the two pieces.  The other fallocate variants (collapse range,
insert range, and allocate blocks) are not supported.

v2: Incorporate feedback from Christoph & Linus.  Tentatively add
a requirement that the fallocate arguments be aligned to logical block
size, and put in a few XXX comments ahead of LSF discussion.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/block_dev.c |   87 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/open.c      |    3 +-
 2 files changed, 89 insertions(+), 1 deletion(-)


diff --git a/fs/block_dev.c b/fs/block_dev.c
index 20a2c02..5c8eb0c 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -29,6 +29,7 @@
 #include <linux/log2.h>
 #include <linux/cleancache.h>
 #include <linux/dax.h>
+#include <linux/falloc.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -1790,6 +1791,91 @@ static int blkdev_mmap(struct file *file, struct vm_area_struct *vma)
 #define blkdev_mmap generic_file_mmap
 #endif
 
+#define	BLKDEV_FALLOC_FL_SUPPORTED					\
+		(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE |		\
+		 FALLOC_FL_ZERO_RANGE | FALLOC_FL_NO_HIDE_STALE)
+
+static long blkdev_fallocate(struct file *file, int mode, loff_t start,
+			     loff_t len)
+{
+	struct block_device *bdev = I_BDEV(bdev_file_inode(file));
+	struct request_queue *q = bdev_get_queue(bdev);
+	struct address_space *mapping;
+	loff_t end = start + len - 1;
+	loff_t isize;
+	int error;
+
+	/* Fail if we don't recognize the flags. */
+	if (mode & ~BLKDEV_FALLOC_FL_SUPPORTED)
+		return -EOPNOTSUPP;
+
+	/* Don't go off the end of the device. */
+	isize = i_size_read(bdev->bd_inode);
+	if (start >= isize)
+		return -EINVAL;
+	if (end > isize) {
+		if (mode & FALLOC_FL_KEEP_SIZE) {
+			len = isize - start;
+			end = start + len - 1;
+		} else
+			return -EINVAL;
+	}
+
+	/*
+	 * Don't allow IO that isn't aligned to logical block size.
+	 * XXX: Should zero and punch write zeroes through the page cache
+	 *      if start or end aren't lbs aligned?
+	 * XXX: What about thinp which prefers io_min alignment?
+	 */
+	if ((start | len) & bdev_logical_block_size(bdev) - 1)
+		return -EINVAL;
+
+	/* Invalidate the page cache, including dirty pages. */
+	mapping = bdev->bd_inode->i_mapping;
+	truncate_inode_pages_range(mapping, start, end);
+
+	switch (mode) {
+	case FALLOC_FL_ZERO_RANGE:
+	case FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE:
+		error = blkdev_issue_zeroout(bdev, start >> 9, len >> 9,
+					    GFP_KERNEL, false);
+		if (error)
+			return error;
+		break;
+	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE:
+		/* Only punch if the device can do zeroing discard. */
+		if (!blk_queue_discard(q) || !q->limits.discard_zeroes_data)
+			return -EOPNOTSUPP;
+		error = blkdev_issue_discard(bdev, start >> 9, len >> 9,
+					     GFP_KERNEL, 0);
+		if (error)
+			return error;
+		break;
+	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | FALLOC_FL_NO_HIDE_STALE:
+		/*
+		 * XXX: a well known search engine vendor interprets this
+		 * flag (in other circumstances) to mean "I don't care if
+		 * we can read stale contents later".  Is it appropriate
+		 * to wire this up to the non-zeroing discard?
+		 */
+		error = blkdev_issue_discard(bdev, start >> 9, len >> 9,
+					     GFP_KERNEL, 0);
+		if (error)
+			return error;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	/*
+	 * Invalidate again; if someone wandered in and dirtied a page,
+	 * the caller will be given -EBUSY;
+	 */
+	return invalidate_inode_pages2_range(mapping,
+					     start >> PAGE_SHIFT,
+					     end >> PAGE_SHIFT);
+}
+
 const struct file_operations def_blk_fops = {
 	.open		= blkdev_open,
 	.release	= blkdev_close,
@@ -1804,6 +1890,7 @@ const struct file_operations def_blk_fops = {
 #endif
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
+	.fallocate	= blkdev_fallocate,
 };
 
 int ioctl_by_bdev(struct block_device *bdev, unsigned cmd, unsigned long arg)
diff --git a/fs/open.c b/fs/open.c
index 17cb6b1..f9ebe32 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -289,7 +289,8 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	 * Let individual file system decide if it supports preallocation
 	 * for directories or not.
 	 */
-	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
+	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode) &&
+	    !S_ISBLK(inode->i_mode))
 		return -ENODEV;
 
 	/* Check for wrap through zero too */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
