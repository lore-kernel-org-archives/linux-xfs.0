Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33990 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755058AbeFNMFP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 08:05:15 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/6] iomap: generic inline data handling
Date: Thu, 14 Jun 2018 14:04:56 +0200
Message-Id: <20180614120457.28285-6-hch@lst.de>
In-Reply-To: <20180614120457.28285-1-hch@lst.de>
References: <20180614120457.28285-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org

From: Andreas Gruenbacher <agruenba@redhat.com>

Add generic inline data handling by adding a pointer to the inline data
region to struct iomap.  When handling a buffered IOMAP_INLINE write,
iomap_write_begin will copy the current inline data from the inline data
region into the page cache, and iomap_write_end will copy the changes in
the page cache back to the inline data region.

This doesn't cover inline data reads and direct I/O yet because so far,
we have no users.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
[hch: small cleanups to better fit in with other iomap work]
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/iomap.c            | 62 ++++++++++++++++++++++++++++++++++++++-----
 include/linux/iomap.h |  1 +
 2 files changed, 56 insertions(+), 7 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index bf1e81b08962..6d5a2ebe5dd8 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -103,6 +103,26 @@ iomap_sector(struct iomap *iomap, loff_t pos)
 	return (iomap->addr + pos - iomap->offset) >> SECTOR_SHIFT;
 }
 
+static void
+iomap_read_inline_data(struct inode *inode, struct page *page,
+		struct iomap *iomap)
+{
+	size_t size = i_size_read(inode);
+	void *addr;
+
+	if (PageUptodate(page))
+		return;
+
+	BUG_ON(page->index);
+	BUG_ON(size > PAGE_SIZE - offset_in_page(iomap->inline_data));
+
+	addr = kmap_atomic(page);
+	memcpy(addr, iomap->inline_data, size);
+	memset(addr + size, 0, PAGE_SIZE - size);
+	kunmap_atomic(addr);
+	SetPageUptodate(page);
+}
+
 static void
 iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
 {
@@ -133,7 +153,11 @@ iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, unsigned flags,
 	if (!page)
 		return -ENOMEM;
 
-	status = __block_write_begin_int(page, pos, len, NULL, iomap);
+	if (iomap->type == IOMAP_INLINE)
+		iomap_read_inline_data(inode, page, iomap);
+	else
+		status = __block_write_begin_int(page, pos, len, NULL, iomap);
+
 	if (unlikely(status)) {
 		unlock_page(page);
 		put_page(page);
@@ -146,14 +170,37 @@ iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, unsigned flags,
 	return status;
 }
 
+static int
+iomap_write_end_inline(struct inode *inode, struct page *page,
+		struct iomap *iomap, loff_t pos, unsigned copied)
+{
+	void *addr;
+
+	WARN_ON_ONCE(!PageUptodate(page));
+	BUG_ON(pos + copied > PAGE_SIZE - offset_in_page(iomap->inline_data));
+
+	addr = kmap_atomic(page);
+	memcpy(iomap->inline_data + pos, addr + pos, copied);
+	kunmap_atomic(addr);
+
+	mark_inode_dirty(inode);
+	__generic_write_end(inode, pos, copied, page);
+	return copied;
+}
+
 static int
 iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
-		unsigned copied, struct page *page)
+		unsigned copied, struct page *page, struct iomap *iomap)
 {
 	int ret;
 
-	ret = generic_write_end(NULL, inode->i_mapping, pos, len,
-			copied, page, NULL);
+	if (iomap->type == IOMAP_INLINE) {
+		ret = iomap_write_end_inline(inode, page, iomap, pos, copied);
+	} else {
+		ret = generic_write_end(NULL, inode->i_mapping, pos, len,
+				copied, page, NULL);
+	}
+
 	if (ret < len)
 		iomap_write_failed(inode, pos, len);
 	return ret;
@@ -208,7 +255,8 @@ iomap_write_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 
 		flush_dcache_page(page);
 
-		status = iomap_write_end(inode, pos, bytes, copied, page);
+		status = iomap_write_end(inode, pos, bytes, copied, page,
+				iomap);
 		if (unlikely(status < 0))
 			break;
 		copied = status;
@@ -302,7 +350,7 @@ iomap_dirty_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 
 		WARN_ON_ONCE(!PageUptodate(page));
 
-		status = iomap_write_end(inode, pos, bytes, bytes, page);
+		status = iomap_write_end(inode, pos, bytes, bytes, page, iomap);
 		if (unlikely(status <= 0)) {
 			if (WARN_ON_ONCE(status == 0))
 				return -EIO;
@@ -354,7 +402,7 @@ static int iomap_zero(struct inode *inode, loff_t pos, unsigned offset,
 	zero_user(page, offset, bytes);
 	mark_page_accessed(page);
 
-	return iomap_write_end(inode, pos, bytes, bytes, page);
+	return iomap_write_end(inode, pos, bytes, bytes, page, iomap);
 }
 
 static int iomap_dax_zero(loff_t pos, unsigned offset, unsigned bytes,
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 212f4d59bcbf..69ef622f650e 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -56,6 +56,7 @@ struct iomap {
 	union {
 		struct block_device *bdev;
 		struct dax_device   *dax_dev;
+		void		    *inline_data;
 	};
 };
 
-- 
2.17.1

