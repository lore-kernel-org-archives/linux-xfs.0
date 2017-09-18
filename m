Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56882 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751550AbdIRJRp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 Sep 2017 05:17:45 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4.9 76/78] xfs: open code end_buffer_async_write in xfs_finish_page_writeback
Date: Mon, 18 Sep 2017 11:12:25 +0200
Message-Id: <20170918091138.020831355@linuxfoundation.org>
In-Reply-To: <20170918091126.077483037@linuxfoundation.org>
References: <20170918091126.077483037@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-xfs@vger.kernel.org, "Darrick J . Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>

4.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

commit 8353a814f2518dcfa79a5bb77afd0e7dfa391bb1 upstream.

Our loop in xfs_finish_page_writeback, which iterates over all buffer
heads in a page and then calls end_buffer_async_write, which also
iterates over all buffers in the page to check if any I/O is in flight
is not only inefficient, but also potentially dangerous as
end_buffer_async_write can cause the page and all buffers to be freed.

Replace it with a single loop that does the work of end_buffer_async_write
on a per-page basis.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/xfs_aops.c |   72 ++++++++++++++++++++++++++++++++++++------------------
 1 file changed, 48 insertions(+), 24 deletions(-)

--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -90,11 +90,11 @@ xfs_find_bdev_for_inode(
  * associated buffer_heads, paying attention to the start and end offsets that
  * we need to process on the page.
  *
- * Landmine Warning: bh->b_end_io() will call end_page_writeback() on the last
- * buffer in the IO. Once it does this, it is unsafe to access the bufferhead or
- * the page at all, as we may be racing with memory reclaim and it can free both
- * the bufferhead chain and the page as it will see the page as clean and
- * unused.
+ * Note that we open code the action in end_buffer_async_write here so that we
+ * only have to iterate over the buffers attached to the page once.  This is not
+ * only more efficient, but also ensures that we only calls end_page_writeback
+ * at the end of the iteration, and thus avoids the pitfall of having the page
+ * and buffers potentially freed after every call to end_buffer_async_write.
  */
 static void
 xfs_finish_page_writeback(
@@ -102,29 +102,45 @@ xfs_finish_page_writeback(
 	struct bio_vec		*bvec,
 	int			error)
 {
-	unsigned int		end = bvec->bv_offset + bvec->bv_len - 1;
-	struct buffer_head	*head, *bh, *next;
+	struct buffer_head	*head = page_buffers(bvec->bv_page), *bh = head;
+	bool			busy = false;
 	unsigned int		off = 0;
-	unsigned int		bsize;
+	unsigned long		flags;
 
 	ASSERT(bvec->bv_offset < PAGE_SIZE);
 	ASSERT((bvec->bv_offset & (i_blocksize(inode) - 1)) == 0);
-	ASSERT(end < PAGE_SIZE);
+	ASSERT(bvec->bv_offset + bvec->bv_len <= PAGE_SIZE);
 	ASSERT((bvec->bv_len & (i_blocksize(inode) - 1)) == 0);
 
-	bh = head = page_buffers(bvec->bv_page);
-
-	bsize = bh->b_size;
+	local_irq_save(flags);
+	bit_spin_lock(BH_Uptodate_Lock, &head->b_state);
 	do {
-		if (off > end)
-			break;
-		next = bh->b_this_page;
-		if (off < bvec->bv_offset)
-			goto next_bh;
-		bh->b_end_io(bh, !error);
-next_bh:
-		off += bsize;
-	} while ((bh = next) != head);
+		if (off >= bvec->bv_offset &&
+		    off < bvec->bv_offset + bvec->bv_len) {
+			ASSERT(buffer_async_write(bh));
+			ASSERT(bh->b_end_io == NULL);
+
+			if (error) {
+				mapping_set_error(bvec->bv_page->mapping, -EIO);
+				set_buffer_write_io_error(bh);
+				clear_buffer_uptodate(bh);
+				SetPageError(bvec->bv_page);
+			} else {
+				set_buffer_uptodate(bh);
+			}
+			clear_buffer_async_write(bh);
+			unlock_buffer(bh);
+		} else if (buffer_async_write(bh)) {
+			ASSERT(buffer_locked(bh));
+			busy = true;
+		}
+		off += bh->b_size;
+	} while ((bh = bh->b_this_page) != head);
+	bit_spin_unlock(BH_Uptodate_Lock, &head->b_state);
+	local_irq_restore(flags);
+
+	if (!busy)
+		end_page_writeback(bvec->bv_page);
 }
 
 /*
@@ -138,8 +154,10 @@ xfs_destroy_ioend(
 	int			error)
 {
 	struct inode		*inode = ioend->io_inode;
-	struct bio		*last = ioend->io_bio;
-	struct bio		*bio, *next;
+	struct bio		*bio = &ioend->io_inline_bio;
+	struct bio		*last = ioend->io_bio, *next;
+	u64			start = bio->bi_iter.bi_sector;
+	bool			quiet = bio_flagged(bio, BIO_QUIET);
 
 	for (bio = &ioend->io_inline_bio; bio; bio = next) {
 		struct bio_vec	*bvec;
@@ -160,6 +178,11 @@ xfs_destroy_ioend(
 
 		bio_put(bio);
 	}
+
+	if (unlikely(error && !quiet)) {
+		xfs_err_ratelimited(XFS_I(inode)->i_mount,
+			"writeback error on sector %llu", start);
+	}
 }
 
 /*
@@ -427,7 +450,8 @@ xfs_start_buffer_writeback(
 	ASSERT(!buffer_delay(bh));
 	ASSERT(!buffer_unwritten(bh));
 
-	mark_buffer_async_write(bh);
+	bh->b_end_io = NULL;
+	set_buffer_async_write(bh);
 	set_buffer_uptodate(bh);
 	clear_buffer_dirty(bh);
 }


