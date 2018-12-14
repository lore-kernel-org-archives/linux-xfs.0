Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52794 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730956AbeLNWOY (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 14 Dec 2018 17:14:24 -0500
Subject: [PATCH 2/3 V2] mm: don't search past page end in
 is_partially_uptodate
From: Eric Sandeen <sandeen@sandeen.net>
References: <1544739929-21651-1-git-send-email-sandeen@sandeen.net>
 <1544739929-21651-3-git-send-email-sandeen@sandeen.net>
Message-ID: <5338b144-4501-25a7-2064-79103c7afb8e@sandeen.net>
Date: Fri, 14 Dec 2018 16:14:23 -0600
MIME-Version: 1.0
In-Reply-To: <1544739929-21651-3-git-send-email-sandeen@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: hch@lst.de

When generic_file_buffered_read() calls ->is_partially_uptodate() on
a page today, it passes in iov->count as the length to check,
which may extend past the end of the page.  The original
implementation, block_is_partially_uptodate(), clamps the length
to the end of the page.

However, the iomap implementation does not do so, and tries to check
all blocks to the end of the iovec, which may be beyond the page,
and may be beyond the iop->uptodate bitmap as well.

I think the worst that will happen is that we may eventually find a zero
bit and return "not partially uptodate" when it would have otherwise
returned true, and skip the optimization.  Still, it's clearly an
invalid memory access that must be fixed.

Zorro noticed this when KASAN went off for 512 byte blocks on a 64k
page system:

 BUG: KASAN: slab-out-of-bounds in iomap_is_partially_uptodate+0x1a0/0x1e0
 Read of size 8 at addr ffff800120c3a318 by task fsstress/22337

and dchinner pointed out the underlying flaw.

Fix this by limiting the range we ask for in the caller
(generic_file_buffered_read()) so that offset+len doesn't extend past
the page in question, and remove the clamping from the block variant.

This also hoists the "don't bother checking each block if we span
the whole page" optimization from the block implementation.  It
changes the arg types too, because we no longer need a long to hold
offsets or lengths that will fit within a page.

Reported-by: Zorro Lang <zlang@redhat.com>
Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

V2: Move the common code (clamping & optimizations) to the caller,
rather than re-implementing in the iomap implementation.

This makes my patch 3/3 unnecessary

Dave, if you've already done and tested the same thing, happy
to just use your patch if it's in better shape.

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index efea228c..b7cc610 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -208,7 +208,7 @@ prototypes:
 	int (*migratepage)(struct address_space *, struct page *, struct page *);
 	void (*putback_page) (struct page *);
 	int (*launder_page)(struct page *);
-	int (*is_partially_uptodate)(struct page *, unsigned long, unsigned long);
+	int (*is_partially_uptodate)(struct page *, unsigned, unsigned);
 	int (*error_remove_page)(struct address_space *, struct page *);
 	int (*swap_activate)(struct file *);
 	int (*swap_deactivate)(struct file *);
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 5f71a25..ed6d581 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -648,8 +648,7 @@ struct address_space_operations {
 	void (*putback_page) (struct page *);
 	int (*launder_page) (struct page *);
 
-	int (*is_partially_uptodate) (struct page *, unsigned long,
-					unsigned long);
+	int (*is_partially_uptodate) (struct page *, unsigned, unsigned);
 	void (*is_dirty_writeback) (struct page *, bool *, bool *);
 	int (*error_remove_page) (struct mapping *mapping, struct page *page);
 	int (*swap_activate)(struct file *);
diff --git a/fs/buffer.c b/fs/buffer.c
index 1286c2b..b8605e5 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2170,8 +2170,8 @@ int generic_write_end(struct file *file, struct address_space *mapping,
  * Returns true if all buffers which correspond to a file portion
  * we want to read are uptodate.
  */
-int block_is_partially_uptodate(struct page *page, unsigned long from,
-					unsigned long count)
+int block_is_partially_uptodate(struct page *page, unsigned int from,
+					unsigned int count)
 {
 	unsigned block_start, block_end, blocksize;
 	unsigned to;
@@ -2183,10 +2183,7 @@ int block_is_partially_uptodate(struct page *page, unsigned long from,
 
 	head = page_buffers(page);
 	blocksize = head->b_size;
-	to = min_t(unsigned, PAGE_SIZE - from, count);
-	to = from + to;
-	if (from < blocksize && to > PAGE_SIZE - blocksize)
-		return 0;
+	to = from + count;
 
 	bh = head;
 	block_start = 0;
diff --git a/fs/iomap.c b/fs/iomap.c
index d6bc98a..6fec633 100644
--- a/fs/iomap.c
+++ b/fs/iomap.c
@@ -493,8 +493,7 @@ struct iomap_readpage_ctx {
 EXPORT_SYMBOL_GPL(iomap_readpages);
 
 int
-iomap_is_partially_uptodate(struct page *page, unsigned long from,
-		unsigned long count)
+iomap_is_partially_uptodate(struct page *page, unsigned from, unsigned count)
 {
 	struct iomap_page *iop = to_iomap_page(page);
 	struct inode *inode = page->mapping->host;
diff --git a/include/linux/buffer_head.h b/include/linux/buffer_head.h
index 7b73ef7..0fef1e5 100644
--- a/include/linux/buffer_head.h
+++ b/include/linux/buffer_head.h
@@ -220,8 +220,8 @@ int __block_write_full_page(struct inode *inode, struct page *page,
 			get_block_t *get_block, struct writeback_control *wbc,
 			bh_end_io_t *handler);
 int block_read_full_page(struct page*, get_block_t*);
-int block_is_partially_uptodate(struct page *page, unsigned long from,
-				unsigned long count);
+int block_is_partially_uptodate(struct page *page, unsigned from,
+				unsigned count);
 int block_write_begin(struct address_space *mapping, loff_t pos, unsigned len,
 		unsigned flags, struct page **pagep, get_block_t *get_block);
 int __block_write_begin(struct page *page, loff_t pos, unsigned len,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c95c080..95a0ec6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -378,8 +378,7 @@ struct address_space_operations {
 	bool (*isolate_page)(struct page *, isolate_mode_t);
 	void (*putback_page)(struct page *);
 	int (*launder_page) (struct page *);
-	int (*is_partially_uptodate) (struct page *, unsigned long,
-					unsigned long);
+	int (*is_partially_uptodate) (struct page *, unsigned, unsigned);
 	void (*is_dirty_writeback) (struct page *, bool *, bool *);
 	int (*error_remove_page)(struct address_space *, struct page *);
 
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index edcdb3a..d59e986 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -127,8 +127,8 @@ ssize_t iomap_file_buffered_write(struct kiocb *iocb, struct iov_iter *from,
 int iomap_readpages(struct address_space *mapping, struct list_head *pages,
 		unsigned nr_pages, const struct iomap_ops *ops);
 int iomap_set_page_dirty(struct page *page);
-int iomap_is_partially_uptodate(struct page *page, unsigned long from,
-		unsigned long count);
+int iomap_is_partially_uptodate(struct page *page, unsigned from,
+		unsigned count);
 int iomap_releasepage(struct page *page, gfp_t gfp_mask);
 void iomap_invalidatepage(struct page *page, unsigned int offset,
 		unsigned int len);
diff --git a/mm/filemap.c b/mm/filemap.c
index 81adec8..0fab63f 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1985,7 +1985,8 @@ static ssize_t generic_file_buffered_read(struct kiocb *iocb,
 	pgoff_t index;
 	pgoff_t last_index;
 	pgoff_t prev_index;
-	unsigned long offset;      /* offset into pagecache page */
+	unsigned offset, count;		/* offset into pagecache page */
+	unsigned blocksize;
 	unsigned int prev_offset;
 	int error = 0;
 
@@ -2045,9 +2046,21 @@ static ssize_t generic_file_buffered_read(struct kiocb *iocb,
 			if (PageUptodate(page))
 				goto page_ok;
 
-			if (inode->i_blkbits == PAGE_SHIFT ||
+			blocksize = i_blocksize(inode);
+			/* There can be no partial for page-sized blocks */
+			if (blocksize == PAGE_SIZE ||
 					!mapping->a_ops->is_partially_uptodate)
 				goto page_not_up_to_date;
+			/* Limit query to within a single page */
+			count = min_t(unsigned, PAGE_SIZE - offset,
+							iter->count);
+			/*
+			 * If the range spans all blocks in the page, and the
+			 * page is not uptodate, we can't be partially uptodate.
+			 */
+			if (offset < blocksize &&
+			    offset + count > PAGE_SIZE - blocksize)
+				goto page_not_up_to_date;
 			/* pipes can't handle partially uptodate pages */
 			if (unlikely(iov_iter_is_pipe(iter)))
 				goto page_not_up_to_date;
@@ -2057,7 +2070,7 @@ static ssize_t generic_file_buffered_read(struct kiocb *iocb,
 			if (!page->mapping)
 				goto page_not_up_to_date_locked;
 			if (!mapping->a_ops->is_partially_uptodate(page,
-							offset, iter->count))
+							offset, count))
 				goto page_not_up_to_date_locked;
 			unlock_page(page);
 		}
