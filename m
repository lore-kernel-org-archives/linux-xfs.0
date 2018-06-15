Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:36634 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753242AbeFONCZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 15 Jun 2018 09:02:25 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 03/24] iomap: add initial support for writes without buffer heads
Date: Fri, 15 Jun 2018 15:01:48 +0200
Message-Id: <20180615130209.1970-4-hch@lst.de>
In-Reply-To: <20180615130209.1970-1-hch@lst.de>
References: <20180615130209.1970-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org

For now just limited to blocksize == PAGE_SIZE, where we can simply read
in the full page in write begin, and just set the whole page dirty after
copying data into it.  This code is enabled by default and XFS will now
be feed pages without buffer heads in ->writepage and ->writepages.

If a file system sets the IOMAP_F_BUFFER_HEAD flag on the iomap the old
path will still be used, this both helps the transition in XFS and
prepares for the gfs2 migration to the iomap infrastructure.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/iomap.c            | 115 +++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_iomap.c    |   6 ++-
 include/linux/iomap.h |   2 +
 3 files changed, 114 insertions(+), 9 deletions(-)

diff --git a/fs/iomap.c b/fs/iomap.c
index e99e4fbc31f4..a504077bb38f 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -348,6 +348,48 @@ iomap_write_failed(struct inode *inode, loff_t pos, unsigned len)
 		truncate_pagecache_range(inode, max(pos, i_size), pos + len);
 }
 
+static int
+iomap_read_page_sync(struct inode *inode, loff_t block_start, struct page *page,
+		unsigned poff, unsigned plen, unsigned from, unsigned to,
+		struct iomap *iomap)
+{
+	struct bio_vec bvec;
+	struct bio bio;
+
+	if (iomap->type != IOMAP_MAPPED || block_start >= i_size_read(inode)) {
+		zero_user_segments(page, poff, from, to, poff + plen);
+		return 0;
+	}
+
+	bio_init(&bio, &bvec, 1);
+	bio.bi_opf = REQ_OP_READ;
+	bio.bi_iter.bi_sector = iomap_sector(iomap, block_start);
+	bio_set_dev(&bio, iomap->bdev);
+	__bio_add_page(&bio, page, plen, poff);
+	return submit_bio_wait(&bio);
+}
+
+static int
+__iomap_write_begin(struct inode *inode, loff_t pos, unsigned len,
+		struct page *page, struct iomap *iomap)
+{
+	loff_t block_size = i_blocksize(inode);
+	loff_t block_start = pos & ~(block_size - 1);
+	loff_t block_end = (pos + len + block_size - 1) & ~(block_size - 1);
+	unsigned poff = block_start & (PAGE_SIZE - 1);
+	unsigned plen = min_t(loff_t, PAGE_SIZE - poff, block_end - block_start);
+	unsigned from = pos & (PAGE_SIZE - 1), to = from + len;
+
+	WARN_ON_ONCE(i_blocksize(inode) < PAGE_SIZE);
+
+	if (PageUptodate(page))
+		return 0;
+	if (from <= poff && to >= poff + plen)
+		return 0;
+	return iomap_read_page_sync(inode, block_start, page,
+			poff, plen, from, to, iomap);
+}
+
 static int
 iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, unsigned flags,
 		struct page **pagep, struct iomap *iomap)
@@ -367,9 +409,10 @@ iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, unsigned flags,
 
 	if (iomap->type == IOMAP_INLINE)
 		iomap_read_inline_data(inode, page, iomap);
-	else
+	else if (iomap->flags & IOMAP_F_BUFFER_HEAD)
 		status = __block_write_begin_int(page, pos, len, NULL, iomap);
-
+	else
+		status = __iomap_write_begin(inode, pos, len, page, iomap);
 	if (unlikely(status)) {
 		unlock_page(page);
 		put_page(page);
@@ -382,6 +425,57 @@ iomap_write_begin(struct inode *inode, loff_t pos, unsigned len, unsigned flags,
 	return status;
 }
 
+int
+iomap_set_page_dirty(struct page *page)
+{
+	struct address_space *mapping = page_mapping(page);
+	int newly_dirty;
+
+	if (unlikely(!mapping))
+		return !TestSetPageDirty(page);
+
+	/*
+	 * Lock out page->mem_cgroup migration to keep PageDirty
+	 * synchronized with per-memcg dirty page counters.
+	 */
+	lock_page_memcg(page);
+	newly_dirty = !TestSetPageDirty(page);
+	if (newly_dirty)
+		__set_page_dirty(page, mapping, 0);
+	unlock_page_memcg(page);
+
+	if (newly_dirty)
+		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+	return newly_dirty;
+}
+EXPORT_SYMBOL_GPL(iomap_set_page_dirty);
+
+static int
+__iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
+		unsigned copied, struct page *page, struct iomap *iomap)
+{
+	flush_dcache_page(page);
+
+	/*
+	 * The blocks that were entirely written will now be uptodate, so we
+	 * don't have to worry about a readpage reading them and overwriting a
+	 * partial write.  However if we have encountered a short write and only
+	 * partially written into a block, it will not be marked uptodate, so a
+	 * readpage might come in and destroy our partial write.
+	 *
+	 * Do the simplest thing, and just treat any short write to a non
+	 * uptodate page as a zero-length write, and force the caller to redo
+	 * the whole thing.
+	 */
+	if (unlikely(copied < len && !PageUptodate(page))) {
+		copied = 0;
+	} else {
+		SetPageUptodate(page);
+		iomap_set_page_dirty(page);
+	}
+	return __generic_write_end(inode, pos, copied, page);
+}
+
 static int
 iomap_write_end_inline(struct inode *inode, struct page *page,
 		struct iomap *iomap, loff_t pos, unsigned copied)
@@ -408,9 +502,11 @@ iomap_write_end(struct inode *inode, loff_t pos, unsigned len,
 
 	if (iomap->type == IOMAP_INLINE) {
 		ret = iomap_write_end_inline(inode, page, iomap, pos, copied);
-	} else {
+	} else if (iomap->flags & IOMAP_F_BUFFER_HEAD) {
 		ret = generic_write_end(NULL, inode->i_mapping, pos, len,
 				copied, page, NULL);
+	} else {
+		ret = __iomap_write_end(inode, pos, len, copied, page, iomap);
 	}
 
 	if (iomap->page_done)
@@ -703,11 +799,16 @@ iomap_page_mkwrite_actor(struct inode *inode, loff_t pos, loff_t length,
 	struct page *page = data;
 	int ret;
 
-	ret = __block_write_begin_int(page, pos, length, NULL, iomap);
-	if (ret)
-		return ret;
+	if (iomap->flags & IOMAP_F_BUFFER_HEAD) {
+		ret = __block_write_begin_int(page, pos, length, NULL, iomap);
+		if (ret)
+			return ret;
+		block_commit_write(page, 0, length);
+	} else {
+		WARN_ON_ONCE(!PageUptodate(page));
+		WARN_ON_ONCE(i_blocksize(inode) < PAGE_SIZE);
+	}
 
-	block_commit_write(page, 0, length);
 	return length;
 }
 
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index c9c3d0df5e4c..85c66e78f9e8 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -640,7 +640,7 @@ xfs_file_iomap_begin_delay(
 	 * Flag newly allocated delalloc blocks with IOMAP_F_NEW so we punch
 	 * them out if the write happens to fail.
 	 */
-	iomap->flags = IOMAP_F_NEW;
+	iomap->flags |= IOMAP_F_NEW;
 	trace_xfs_iomap_alloc(ip, offset, count, 0, &got);
 done:
 	if (isnullstartblock(got.br_startblock))
@@ -1033,6 +1033,8 @@ xfs_file_iomap_begin(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
+	iomap->flags |= IOMAP_F_BUFFER_HEAD;
+
 	if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
 			!IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
 		/* Reserve delalloc blocks for regular writeback. */
@@ -1133,7 +1135,7 @@ xfs_file_iomap_begin(
 	if (error)
 		return error;
 
-	iomap->flags = IOMAP_F_NEW;
+	iomap->flags |= IOMAP_F_NEW;
 	trace_xfs_iomap_alloc(ip, offset, length, 0, &imap);
 
 out_finish:
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index cfbc28b4005c..c2706cfb27c7 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -30,6 +30,7 @@ struct vm_fault;
  */
 #define IOMAP_F_NEW		0x01	/* blocks have been newly allocated */
 #define IOMAP_F_DIRTY		0x02	/* uncommitted metadata */
+#define IOMAP_F_BUFFER_HEAD	0x04	/* file system requires buffer heads */
 
 /*
  * Flags that only need to be reported for IOMAP_REPORT requests:
@@ -103,6 +104,7 @@ ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 int iomap_readpage(struct page *page, const struct iomap_ops *ops);
 int iomap_readpages(struct address_space *mapping, struct list_head *pages,
 		unsigned nr_pages, const struct iomap_ops *ops);
+int iomap_set_page_dirty(struct page *page);
 int iomap_file_dirty(struct inode *inode, loff_t pos, loff_t len,
 		const struct iomap_ops *ops);
 int iomap_zero_range(struct inode *inode, loff_t pos, loff_t len,
-- 
2.17.1

