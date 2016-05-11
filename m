Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5FF8B7CA6
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 16:09:24 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 012A8304048
	for <xfs@oss.sgi.com>; Wed, 11 May 2016 14:09:23 -0700 (PDT)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id PD0oGvN94Ou6093H for
	<xfs@oss.sgi.com>; Wed, 11 May 2016 14:09:22 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v7 4/6] dax: export a low-level __dax_zero_page_range helper
Date: Wed, 11 May 2016 15:08:50 -0600
Message-Id: <1463000932-31680-5-git-send-email-vishal.l.verma@intel.com>
In-Reply-To: <1463000932-31680-1-git-send-email-vishal.l.verma@intel.com>
References: <1463000932-31680-1-git-send-email-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>, Boaz Harrosh <boaz@plexistor.com>, linux-fsdevel@vger.kernel.org, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

This allows XFS to perform zeroing using the iomap infrastructure and
avoid buffer heads.

[vishal: fix conflicts with dax-error-handling]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c            | 35 ++++++++++++++++++++---------------
 include/linux/dax.h |  7 +++++++
 2 files changed, 27 insertions(+), 15 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 0abbbb6..651d4b1 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -947,6 +947,23 @@ int dax_pfn_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 }
 EXPORT_SYMBOL_GPL(dax_pfn_mkwrite);
 
+int __dax_zero_page_range(struct block_device *bdev, sector_t sector,
+		unsigned int offset, unsigned int length)
+{
+	struct blk_dax_ctl dax = {
+		.sector		= sector,
+		.size		= PAGE_SIZE,
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
@@ -982,23 +999,11 @@ int dax_zero_page_range(struct inode *inode, loff_t from, unsigned length,
 	bh.b_bdev = inode->i_sb->s_bdev;
 	bh.b_size = PAGE_SIZE;
 	err = get_block(inode, index, &bh, 0);
-	if (err < 0)
+	if (err < 0 || !buffer_written(&bh))
 		return err;
-	if (buffer_written(&bh)) {
-		struct block_device *bdev = bh.b_bdev;
-		struct blk_dax_ctl dax = {
-			.sector = to_sector(&bh, inode),
-			.size = PAGE_SIZE,
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
index 7f853ff..90fbc99 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -14,12 +14,19 @@ int __dax_fault(struct vm_area_struct *, struct vm_fault *, get_block_t);
 
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
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
