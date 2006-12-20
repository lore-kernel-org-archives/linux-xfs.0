Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Dec 2006 22:29:31 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBK6TJqw022586
	for <xfs@oss.sgi.com>; Tue, 19 Dec 2006 22:29:23 -0800
Date: Wed, 20 Dec 2006 17:28:13 +1100
From: David Chinner <dgc@sgi.com>
Subject: Review: Clear unwritten flag on during partial page truncation
Message-ID: <20061220062813.GU44411608@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev@sgi.com
Cc: xfs@oss.sgi.com

For a long time now we've been getting assert failures in XFSQA test
083 which is a fsstress test near ENOSPC.

The failure mode is:

<4>Assertion failed: !(iomapp->iomap_flags & IOMAP_DELAY), file: fs/xfs/linux-2.6/xfs_aops.c, line: 510

A inode read-write trace uncovered what the problem was.  We had a
page with an unwritten extent lying partially over it (last block on
the page), and then we truncated the file to the first block on the
page. Because it is a partial page truncation, we walk the buffers
on the page and clear the flags on the buffers past end of file so
that if we write to them again the correct flags are set on the
buffers.

block_invalidatepage() call discard_buffers() to do this, which
clears all the common state from the buffers past EOF. The problem
stems from the fact that the buffer_unwritten() flag is an XFS
private flag, and hence does not get cleared from the buffer.

If we then extend the file with a write to within the buffer that we
failed to clear the unwritten flag from, we then make the wrong
decision in xfs_convert_page_state() when trying to map that buffer
- we see buffer_unwritten() instead of buffer_delay(), but the
extent map we got for that range from xfs_bmapi() correctly says
IOMAP_DELAY.

Hence the solution is to clear the private buffer flags in
xfs_vm_invalidatepage() so that when we extend the file the buffers
on the page are all consistent.

Patch below. Comments?

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group


---
 fs/xfs/linux-2.6/xfs_aops.c |   38 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 37 insertions(+), 1 deletion(-)

Index: 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- 2.6.x-xfs-new.orig/fs/xfs/linux-2.6/xfs_aops.c	2006-11-30 19:24:46.000000000 +1100
+++ 2.6.x-xfs-new/fs/xfs/linux-2.6/xfs_aops.c	2006-11-30 23:17:14.123674539 +1100
@@ -41,6 +41,8 @@
 #include <linux/pagevec.h>
 #include <linux/writeback.h>
 
+STATIC void xfs_vm_invalidatepage(struct page *, unsigned long);
+
 STATIC void
 xfs_count_page_state(
 	struct page		*page,
@@ -1061,7 +1063,7 @@ error:
 	 */
 	if (err != -EAGAIN) {
 		if (!unmapped)
-			block_invalidatepage(page, 0);
+			xfs_vm_invalidatepage(page, 0);
 		ClearPageUptodate(page);
 	}
 	return err;
@@ -1451,6 +1453,14 @@ xfs_vm_readpages(
 	return mpage_readpages(mapping, pages, nr_pages, xfs_get_blocks);
 }
 
+/*
+ * block_invalidatepage() doesn't clear private buffer flags like the unwritten
+ * flag. Leaving the unwritten flag behind on buffers that have been
+ * invalidated but are still attached to a page (i.e.  buffer size < page size
+ * and partial page invalidation) will result in incorrect allocation occurring
+ * during writeback if the file is extended to within or past the invalidated
+ * block before writeback.
+ */
 STATIC void
 xfs_vm_invalidatepage(
 	struct page		*page,
@@ -1458,6 +1468,32 @@ xfs_vm_invalidatepage(
 {
 	xfs_page_trace(XFS_INVALIDPAGE_ENTER,
 			page->mapping->host, page, offset);
+
+	/*
+	 * Need to clear private flags from buffers on partial
+	 * page truncations ourselves. Same inner loop as
+	 * block_invalidatepage() is used.
+	 */
+	if (offset && page_has_buffers(page)) {
+		struct buffer_head *head, *bh, *next;
+		unsigned int curr_off = 0;
+
+		head = page_buffers(page);
+		bh = head;
+		do {
+			unsigned int next_off = curr_off + bh->b_size;
+			next = bh->b_this_page;
+
+			/*
+			 * is this block fully invalidated?
+			 */
+			if (offset <= curr_off)
+				clear_buffer_unwritten(bh);
+			curr_off = next_off;
+			bh = next;
+		} while (bh != head);
+	}
+
 	block_invalidatepage(page, offset);
 }
 
