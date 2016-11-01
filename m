Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:25589 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753568AbcKATy3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 1 Nov 2016 15:54:29 -0400
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v9 02/16] dax: remove buffer_size_valid()
Date: Tue,  1 Nov 2016 13:54:04 -0600
Message-Id: <1478030058-1422-3-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1478030058-1422-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1478030058-1422-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org

Now that ext4 properly sets bh.b_size when we call get_block() for a hole,
rely on that value and remove the buffer_size_valid() sanity check.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c | 22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 014defd..b09817a 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -123,19 +123,6 @@ static bool buffer_written(struct buffer_head *bh)
 	return buffer_mapped(bh) && !buffer_unwritten(bh);
 }
 
-/*
- * When ext4 encounters a hole, it returns without modifying the buffer_head
- * which means that we can't trust b_size.  To cope with this, we set b_state
- * to 0 before calling get_block and, if any bit is set, we know we can trust
- * b_size.  Unfortunate, really, since ext4 knows precisely how long a hole is
- * and would save us time calling get_block repeatedly.
- */
-static bool buffer_size_valid(struct buffer_head *bh)
-{
-	return bh->b_state != 0;
-}
-
-
 static sector_t to_sector(const struct buffer_head *bh,
 		const struct inode *inode)
 {
@@ -177,8 +164,6 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
 				rc = get_block(inode, block, bh, rw == WRITE);
 				if (rc)
 					break;
-				if (!buffer_size_valid(bh))
-					bh->b_size = 1 << blkbits;
 				bh_max = pos - first + bh->b_size;
 				bdev = bh->b_bdev;
 				/*
@@ -1012,12 +997,7 @@ int dax_pmd_fault(struct vm_area_struct *vma, unsigned long address,
 
 	bdev = bh.b_bdev;
 
-	/*
-	 * If the filesystem isn't willing to tell us the length of a hole,
-	 * just fall back to PTEs.  Calling get_block 512 times in a loop
-	 * would be silly.
-	 */
-	if (!buffer_size_valid(&bh) || bh.b_size < PMD_SIZE) {
+	if (bh.b_size < PMD_SIZE) {
 		dax_pmd_dbg(&bh, address, "allocated block too small");
 		return VM_FAULT_FALLBACK;
 	}
-- 
2.7.4

