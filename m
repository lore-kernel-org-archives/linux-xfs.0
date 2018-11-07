Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail03.adl2.internode.on.net ([150.101.137.141]:27974 "EHLO
        ipmail03.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728363AbeKGQBU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 7 Nov 2018 11:01:20 -0500
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 06/16] iomap: support block size > page size for direct IO
Date: Wed,  7 Nov 2018 17:31:17 +1100
Message-Id: <20181107063127.3902-7-david@fromorbit.com>
In-Reply-To: <20181107063127.3902-1-david@fromorbit.com>
References: <20181107063127.3902-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

iomap_dio_rw() has all the infrastructure in place to support block
size > page size filesystems because it is essentially just
sub-block DIO. It needs help, however, with the sub-block zeroing
code (needs multi-page IOs) page cache invalidation over the block
being written.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/iomap.c | 65 ++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 49 insertions(+), 16 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index 16d16596b00f..8878b1f1f9c7 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -1548,21 +1548,34 @@ static void iomap_dio_bio_end_io(struct bio *bio)
 	}
 }
 
+/*
+ * With zeroing for block size larger than page size, the zeroing length can
+ * span multiple pages.
+ */
+#define howmany(x, y) (((x)+((y)-1))/(y))
 static blk_qc_t
 iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
 		unsigned len)
 {
 	struct page *page = ZERO_PAGE(0);
 	struct bio *bio;
+	int npages = howmany(len, PAGE_SIZE);
+
+	WARN_ON_ONCE(npages > 16);
 
-	bio = bio_alloc(GFP_KERNEL, 1);
+	bio = bio_alloc(GFP_KERNEL, npages);
 	bio_set_dev(bio, iomap->bdev);
 	bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
 	bio->bi_private = dio;
 	bio->bi_end_io = iomap_dio_bio_end_io;
 
-	get_page(page);
-	__bio_add_page(bio, page, len, 0);
+	while (npages-- > 0) {
+		unsigned plen = min_t(unsigned, PAGE_SIZE, len);
+		get_page(page);
+		__bio_add_page(bio, page, plen, 0);
+		len -= plen;
+	}
+	WARN_ON(len != 0);
 	bio_set_op_attrs(bio, REQ_OP_WRITE, REQ_SYNC | REQ_IDLE);
 
 	atomic_inc(&dio->ref);
@@ -1752,6 +1765,38 @@ iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
 	}
 }
 
+/*
+ * This is lifted almost straight from xfs_flush_unmap_range(). Need a generic
+ * version of the block size rounding for these purposes.
+ */
+static int
+iomap_flush_unmap_range(struct file *f, loff_t offset, loff_t len)
+{
+	struct inode *inode = file_inode(f);
+	loff_t rounding, start, end;
+	int ret;
+
+	rounding = max_t(loff_t, i_blocksize(inode), PAGE_SIZE);
+	start = round_down(offset, rounding);
+	end = round_up(offset + len, rounding) - 1;
+
+	ret = filemap_write_and_wait_range(inode->i_mapping, start, end);
+	if (ret)
+		return ret;
+
+	/*
+	 * Try to invalidate cache pages for the range we're direct
+	 * writing.  If this invalidation fails, tough, the write will
+	 * still work, but racing two incompatible write paths is a
+	 * pretty crazy thing to do, so we don't support it 100%.
+	 */
+	ret = invalidate_inode_pages2_range(inode->i_mapping,
+			start >> PAGE_SHIFT, end >> PAGE_SHIFT);
+	if (ret)
+		dio_warn_stale_pagecache(f);
+	return 0;
+}
+
 /*
  * iomap_dio_rw() always completes O_[D]SYNC writes regardless of whether the IO
  * is being issued as AIO or not.  This allows us to optimise pure data writes
@@ -1829,22 +1874,10 @@ iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		flags |= IOMAP_NOWAIT;
 	}
 
-	ret = filemap_write_and_wait_range(mapping, start, end);
+	ret = iomap_flush_unmap_range(iocb->ki_filp, start, end);
 	if (ret)
 		goto out_free_dio;
 
-	/*
-	 * Try to invalidate cache pages for the range we're direct
-	 * writing.  If this invalidation fails, tough, the write will
-	 * still work, but racing two incompatible write paths is a
-	 * pretty crazy thing to do, so we don't support it 100%.
-	 */
-	ret = invalidate_inode_pages2_range(mapping,
-			start >> PAGE_SHIFT, end >> PAGE_SHIFT);
-	if (ret)
-		dio_warn_stale_pagecache(iocb->ki_filp);
-	ret = 0;
-
 	if (iov_iter_rw(iter) == WRITE && !dio->wait_for_completion &&
 	    !inode->i_sb->s_dio_done_wq) {
 		ret = sb_init_dio_done_wq(inode->i_sb);
-- 
2.19.1
