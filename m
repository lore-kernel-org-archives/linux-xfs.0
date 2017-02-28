Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:44726 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751986AbdB1O6E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 09:58:04 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/12] iomap: pass IOMAP_* flags to actors
Date: Tue, 28 Feb 2017 06:57:27 -0800
Message-Id: <20170228145737.19016-3-hch@lst.de>
In-Reply-To: <20170228145737.19016-1-hch@lst.de>
References: <20170228145737.19016-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-block@vger.kernel.org

This will be needed to implement O_ATOMIC.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/dax.c      |  2 +-
 fs/internal.h |  2 +-
 fs/iomap.c    | 39 +++++++++++++++++++++------------------
 3 files changed, 23 insertions(+), 20 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 78b9651576c6..5d71fc5f0a08 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -997,7 +997,7 @@ static sector_t dax_iomap_sector(struct iomap *iomap, loff_t pos)
 
 static loff_t
 dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
-		struct iomap *iomap)
+		struct iomap *iomap, unsigned flags)
 {
 	struct iov_iter *iter = data;
 	loff_t end = pos + length, done = 0;
diff --git a/fs/internal.h b/fs/internal.h
index 11c6d89dce9c..1934fdb2bb27 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -179,7 +179,7 @@ extern long vfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
  * iomap support:
  */
 typedef loff_t (*iomap_actor_t)(struct inode *inode, loff_t pos, loff_t len,
-		void *data, struct iomap *iomap);
+		void *data, struct iomap *iomap, unsigned flags);
 
 loff_t iomap_apply(struct inode *inode, loff_t pos, loff_t length,
 		unsigned flags, const struct iomap_ops *ops, void *data,
diff --git a/fs/iomap.c b/fs/iomap.c
index 7f08ca03d95d..16a9d2b89cb6 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -76,7 +76,7 @@ iomap_apply(struct inode *inode, loff_t pos, loff_t length, unsigned flags,
 	 * we can do the copy-in page by page without having to worry about
 	 * failures exposing transient data.
 	 */
-	written = actor(inode, pos, length, data, &iomap);
+	written = actor(inode, pos, length, data, &iomap, flags);
 
 	/*
 	 * Now the data has been copied, commit the range we've copied.  This
@@ -105,8 +105,9 @@ iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
 }
 
 static int
-iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, unsigned flags,
-		struct page **pagep, struct iomap *iomap)
+iomap_write_begin(struct inode *inode, loff_t pos, unsigned len,
+		unsigned aop_flags, struct page **pagep, struct iomap *iomap,
+		unsigned flags)
 {
 	pgoff_t index = pos >> PAGE_SHIFT;
 	struct page *page;
@@ -114,7 +115,7 @@ iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, unsigned flags,
 
 	BUG_ON(pos + len > iomap->offset + iomap->length);
 
-	page = grab_cache_page_write_begin(inode->i_mapping, index, flags);
+	page = grab_cache_page_write_begin(inode->i_mapping, index, aop_flags);
 	if (!page)
 		return -ENOMEM;
 
@@ -146,18 +147,18 @@ iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
 
 static loff_t
 iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
-		struct iomap *iomap)
+		struct iomap *iomap, unsigned flags)
 {
 	struct iov_iter *i = data;
 	long status = 0;
 	ssize_t written = 0;
-	unsigned int flags = AOP_FLAG_NOFS;
+	unsigned int aop_flags = AOP_FLAG_NOFS;
 
 	/*
 	 * Copies from kernel address space cannot fail (NFSD is a big user).
 	 */
 	if (!iter_is_iovec(i))
-		flags |= AOP_FLAG_UNINTERRUPTIBLE;
+		aop_flags |= AOP_FLAG_UNINTERRUPTIBLE;
 
 	do {
 		struct page *page;
@@ -187,8 +188,8 @@ iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 			break;
 		}
 
-		status = iomap_write_begin(inode, pos, bytes, flags, &page,
-				iomap);
+		status = iomap_write_begin(inode, pos, bytes, aop_flags, &page,
+				iomap, flags);
 		if (unlikely(status))
 			break;
 
@@ -268,7 +269,7 @@ __iomap_read_page(struct inode *inode, loff_t offset)
 
 static loff_t
 iomap_dirty_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
-		struct iomap *iomap)
+		struct iomap *iomap, unsigned flags)
 {
 	long status = 0;
 	ssize_t written = 0;
@@ -287,7 +288,7 @@ iomap_dirty_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 
 		status = iomap_write_begin(inode, pos, bytes,
 				AOP_FLAG_NOFS | AOP_FLAG_UNINTERRUPTIBLE,
-				&page, iomap);
+				&page, iomap, flags);
 		put_page(rpage);
 		if (unlikely(status))
 			return status;
@@ -333,13 +334,14 @@ iomap_file_dirty(struct inode *inode, loff_t pos, loff_t len,
 EXPORT_SYMBOL_GPL(iomap_file_dirty);
 
 static int iomap_zero(struct inode *inode, loff_t pos, unsigned offset,
-		unsigned bytes, struct iomap *iomap)
+		unsigned bytes, struct iomap *iomap, unsigned flags)
 {
 	struct page *page;
 	int status;
 
 	status = iomap_write_begin(inode, pos, bytes,
-			AOP_FLAG_UNINTERRUPTIBLE | AOP_FLAG_NOFS, &page, iomap);
+			AOP_FLAG_UNINTERRUPTIBLE | AOP_FLAG_NOFS, &page, iomap,
+			flags);
 	if (status)
 		return status;
 
@@ -360,7 +362,7 @@ static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
 
 static loff_t
 iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
-		void *data, struct iomap *iomap)
+		void *data, struct iomap *iomap, unsigned flags)
 {
 	bool *did_zero = data;
 	loff_t written = 0;
@@ -379,7 +381,8 @@ iomap_zero_range_actor(struct inode *inode, loff_t pos, loff_t count,
 		if (IS_DAX(inode))
 			status = iomap_dax_zero(pos, offset, bytes, iomap);
 		else
-			status = iomap_zero(inode, pos, offset, bytes, iomap);
+			status = iomap_zero(inode, pos, offset, bytes, iomap,
+					flags);
 		if (status < 0)
 			return status;
 
@@ -429,7 +432,7 @@ EXPORT_SYMBOL_GPL(iomap_truncate_page);
 
 static loff_t
 iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
-		void *data, struct iomap *iomap)
+		void *data, struct iomap *iomap, unsigned flags)
 {
 	struct page *page = data;
 	int ret;
@@ -521,7 +524,7 @@ static int iomap_to_fiemap(struct fiemap_extent_info *fi,
 
 static loff_t
 iomap_fiemap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
-		struct iomap *iomap)
+		struct iomap *iomap, unsigned flags)
 {
 	struct fiemap_ctx *ctx = data;
 	loff_t ret = length;
@@ -730,7 +733,7 @@ iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
 
 static loff_t
 iomap_dio_actor(struct inode *inode, loff_t pos, loff_t length,
-		void *data, struct iomap *iomap)
+		void *data, struct iomap *iomap, unsigned flags)
 {
 	struct iomap_dio *dio = data;
 	unsigned blkbits = blksize_bits(bdev_logical_block_size(iomap->bdev));
-- 
2.11.0

