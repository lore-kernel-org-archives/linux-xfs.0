Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:33836 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755156AbeFNMFD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Jun 2018 08:05:03 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 1/6] fs: factor out a __generic_write_end helper
Date: Thu, 14 Jun 2018 14:04:52 +0200
Message-Id: <20180614120457.28285-2-hch@lst.de>
In-Reply-To: <20180614120457.28285-1-hch@lst.de>
References: <20180614120457.28285-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Andreas Gruenbacher <agruenba@redhat.com>, linux-xfs@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, linux-fsdevel@vger.kernel.org, cluster-devel@redhat.com, linux-ext4@vger.kernel.org

Bits of the buffer.c based write_end implementations that don't know
about buffer_heads and can be reused by other implementations.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Andreas Gruenbacher <agruenba@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/buffer.c   | 67 +++++++++++++++++++++++++++------------------------
 fs/internal.h |  2 ++
 2 files changed, 37 insertions(+), 32 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index cabc045f483d..aba2a948b235 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2076,6 +2076,40 @@ int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
 }
 EXPORT_SYMBOL(block_write_begin);
 
+int __generic_write_end(struct inode *inode, loff_t pos, unsigned copied,
+		struct page *page)
+{
+	loff_t old_size = inode->i_size;
+	bool i_size_changed = false;
+
+	/*
+	 * No need to use i_size_read() here, the i_size cannot change under us
+	 * because we hold i_rwsem.
+	 *
+	 * But it's important to update i_size while still holding page lock:
+	 * page writeout could otherwise come in and zero beyond i_size.
+	 */
+	if (pos + copied > inode->i_size) {
+		i_size_write(inode, pos + copied);
+		i_size_changed = true;
+	}
+
+	unlock_page(page);
+	put_page(page);
+
+	if (old_size < pos)
+		pagecache_isize_extended(inode, old_size, pos);
+	/*
+	 * Don't mark the inode dirty under page lock. First, it unnecessarily
+	 * makes the holding time of page lock longer. Second, it forces lock
+	 * ordering of page lock and transaction start for journaling
+	 * filesystems.
+	 */
+	if (i_size_changed)
+		mark_inode_dirty(inode);
+	return copied;
+}
+
 int block_write_end(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned copied,
 			struct page *page, void *fsdata)
@@ -2116,39 +2150,8 @@ int generic_write_end(struct file *file, struct address_space *mapping,
 			loff_t pos, unsigned len, unsigned copied,
 			struct page *page, void *fsdata)
 {
-	struct inode *inode = mapping->host;
-	loff_t old_size = inode->i_size;
-	int i_size_changed = 0;
-
 	copied = block_write_end(file, mapping, pos, len, copied, page, fsdata);
-
-	/*
-	 * No need to use i_size_read() here, the i_size
-	 * cannot change under us because we hold i_mutex.
-	 *
-	 * But it's important to update i_size while still holding page lock:
-	 * page writeout could otherwise come in and zero beyond i_size.
-	 */
-	if (pos+copied > inode->i_size) {
-		i_size_write(inode, pos+copied);
-		i_size_changed = 1;
-	}
-
-	unlock_page(page);
-	put_page(page);
-
-	if (old_size < pos)
-		pagecache_isize_extended(inode, old_size, pos);
-	/*
-	 * Don't mark the inode dirty under page lock. First, it unnecessarily
-	 * makes the holding time of page lock longer. Second, it forces lock
-	 * ordering of page lock and transaction start for journaling
-	 * filesystems.
-	 */
-	if (i_size_changed)
-		mark_inode_dirty(inode);
-
-	return copied;
+	return __generic_write_end(mapping->host, pos, copied, page);
 }
 EXPORT_SYMBOL(generic_write_end);
 
diff --git a/fs/internal.h b/fs/internal.h
index 980d005b21b4..4a18bdbd2214 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -43,6 +43,8 @@ static inline int __sync_blockdev(struct block_device *bdev, int wait)
 extern void guard_bio_eod(int rw, struct bio *bio);
 extern int __block_write_begin_int(struct page *page, loff_t pos, unsigned len,
 		get_block_t *get_block, struct iomap *iomap);
+int __generic_write_end(struct inode *inode, loff_t pos, unsigned copied,
+		struct page *page);
 
 /*
  * char_dev.c
-- 
2.17.1

