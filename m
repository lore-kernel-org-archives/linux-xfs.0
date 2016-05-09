Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A98EB7CA4
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 03:47:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7BB52304039
	for <xfs@oss.sgi.com>; Mon,  9 May 2016 01:47:32 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 3ql1OP4nTJlN8rLX (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 09 May 2016 01:47:29 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/15] dax: export a low-level __dax_zero_page_range helper
Date: Mon,  9 May 2016 10:47:04 +0200
Message-Id: <1462783638-4968-2-git-send-email-hch@lst.de>
In-Reply-To: <1462783638-4968-1-git-send-email-hch@lst.de>
References: <1462783638-4968-1-git-send-email-hch@lst.de>
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
To: xfs@oss.sgi.com
Cc: rpeterso@redhat.com, vishal.l.verma@intel.com, linux-fsdevel@vger.kernel.org

This allows XFS to perform zeroing using the iomap infrastructure and
avoid buffer heads.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c            | 35 ++++++++++++++++++++---------------
 include/linux/dax.h |  7 +++++++
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 90322eb..6d5d744 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1082,6 +1082,23 @@ int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
 
+int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
+		unsigned int offset, unsigned int length)
+{
+	struct blk_dax_ctl dax = {
+		.sector		= sector,
+		.size		= PAGE_CACHE_SIZE,
+	};
+
+	if (dax_map_atomic(bdev, &dax) < 0)
+		return PTR_ERR(dax.addr);
+	clear_pmem(dax.addr + offset, length);
+	wmb_pmem();
+	dax_unmap_atomic(bdev, &dax);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(__dax_zero_page_range);
+
 /**
  * dax_zero_page_range - zero a range within a page of a DAX file
  * @inode: The file being truncated
@@ -1117,23 +1134,11 @@ int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
 	bh.b_bdev = inode->i_sb->s_bdev;
 	bh.b_size = PAGE_CACHE_SIZE;
 	err = get_block(inode, index, &bh, 0);
-	if (err < 0)
+	if (err < 0 || !buffer_written(&bh))
 		return err;
-	if (buffer_written(&bh)) {
-		struct block_device *bdev = bh.b_bdev;
-		struct blk_dax_ctl dax = {
-			.sector = to_sector(&bh, inode),
-			.size = PAGE_CACHE_SIZE,
-		};
 
-		if (dax_map_atomic(bdev, &dax) < 0)
-			return PTR_ERR(dax.addr);
-		clear_pmem(dax.addr + offset, length);
-		wmb_pmem();
-		dax_unmap_atomic(bdev, &dax);
-	}
-
-	return 0;
+	return __dax_zero_page_range(bh.b_bdev, to_sector(&bh, inode),
+			offset, length);
 }
 EXPORT_SYMBOL_GPL(dax_zero_page_range);
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 636dd59..8155b81 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -17,12 +17,19 @@ int __dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t,
 
 #ifdef CONFIG_FS_DAX
 struct page *read_dax_sector(struct block_device *bdev, sector_t n);
+int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
+		unsigned int offset, unsigned int length);
 #else
 static inline struct page *read_dax_sector(struct block_device *bdev,
 		sector_t n)
 {
 	return ERR_PTR(-ENXIO);
 }
+static inline int __dax_zero_page_range(struct block_device *bdev,
+		sector_t sector, unsigned int offset, unsigned int length)
+{
+	return -ENXIO;
+}
 #endif
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
