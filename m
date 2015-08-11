Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 317987F6D
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 17:50:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A3CE6AC003
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 15:50:02 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	oVMc96udtcVUnq6E for <xfs@oss.sgi.com>;
	Tue, 11 Aug 2015 15:49:56 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZPIMh-0005YH-0n
	for xfs@oss.sgi.com; Wed, 12 Aug 2015 08:49:51 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ZPIMh-0004Oe-06
	for xfs@oss.sgi.com; Wed, 12 Aug 2015 08:49:50 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/8] xfs: add ioend and iohead to xfs_writepage_ctx
Date: Wed, 12 Aug 2015 08:49:44 +1000
Message-Id: <1439333388-16452-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1439333388-16452-1-git-send-email-david@fromorbit.com>
References: <1439333388-16452-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Now we have a cross-writepage context, we don't need to submit IO at
the end of the writepage call - we can continue to aggregate ioends
across the entire writepages call if the iohead and ioend are held
in the writepage context.

This requires us to move the ioend submission up to the level where
the writepage context is declared. This does mean we do not submit
IO until we packaged the entire writeback range, but with the block
plugging in the writepages call this is the way IO is submitted,
anyway.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 122 +++++++++++++++++++++++++++---------------------------
 1 file changed, 60 insertions(+), 62 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index b718156..e4184f5 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -43,6 +43,8 @@ struct xfs_writepage_ctx {
 	struct xfs_bmbt_irec    imap;
 	bool			imap_valid;
 	unsigned int		io_type;
+	struct xfs_ioend	*iohead;
+	struct xfs_ioend	*ioend;
 };
 
 void
@@ -525,38 +527,6 @@ xfs_submit_ioend(
 }
 
 /*
- * Cancel submission of all buffer_heads so far in this endio.
- * Toss the endio too.  Only ever called for the initial page
- * in a writepage request, so only ever one page.
- */
-STATIC void
-xfs_cancel_ioend(
-	xfs_ioend_t		*ioend)
-{
-	xfs_ioend_t		*next;
-	struct buffer_head	*bh, *next_bh;
-
-	do {
-		next = ioend->io_list;
-		bh = ioend->io_buffer_head;
-		do {
-			next_bh = bh->b_private;
-			clear_buffer_async_write(bh);
-			/*
-			 * The unwritten flag is cleared when added to the
-			 * ioend. We're not submitting for I/O so mark the
-			 * buffer unwritten again for next time around.
-			 */
-			if (ioend->io_type == XFS_IO_UNWRITTEN)
-				set_buffer_unwritten(bh);
-			unlock_buffer(bh);
-		} while ((bh = next_bh) != NULL);
-
-		mempool_free(ioend, xfs_ioend_pool);
-	} while ((ioend = next) != NULL);
-}
-
-/*
  * Test to see if we've been building up a completion structure for
  * earlier buffers -- if so, we try to append to this ioend if we
  * can, otherwise we finish off any current ioend and start another.
@@ -928,6 +898,27 @@ out_invalidate:
 	return;
 }
 
+static int
+xfs_writepage_submit(
+	struct xfs_writepage_ctx *wpc,
+	struct writeback_control *wbc,
+	int			status)
+{
+	struct blk_plug		plug;
+
+	/* Reserve log space if we might write beyond the on-disk inode size. */
+	if (!status && wpc->ioend && wpc->ioend->io_type != XFS_IO_UNWRITTEN &&
+	    xfs_ioend_is_append(wpc->ioend))
+		status = xfs_setfilesize_trans_alloc(wpc->ioend);
+
+	if (wpc->iohead) {
+		blk_start_plug(&plug);
+		xfs_submit_ioend(wbc, wpc->iohead, status);
+		blk_finish_plug(&plug);
+	}
+	return status;
+}
+
 /*
  * Write out a dirty page.
  *
@@ -945,7 +936,6 @@ xfs_do_writepage(
 	struct xfs_writepage_ctx *wpc = data;
 	struct inode		*inode = page->mapping->host;
 	struct buffer_head	*bh, *head;
-	xfs_ioend_t		*ioend = NULL, *iohead = NULL;
 	loff_t			offset;
 	__uint64_t              end_offset;
 	pgoff_t                 end_index, last_index;
@@ -1122,12 +1112,12 @@ xfs_do_writepage(
 			if (wpc->io_type != XFS_IO_OVERWRITE)
 				xfs_map_at_offset(inode, bh, &wpc->imap, offset);
 			xfs_add_to_ioend(inode, bh, offset, wpc->io_type,
-					 &ioend, new_ioend);
+					 &wpc->ioend, new_ioend);
 			count++;
 		}
 
-		if (!iohead)
-			iohead = ioend;
+		if (!wpc->iohead)
+			wpc->iohead = wpc->ioend;
 
 	} while (offset += len, ((bh = bh->b_this_page) != head));
 
@@ -1137,10 +1127,10 @@ xfs_do_writepage(
 	xfs_start_page_writeback(page, 1, count);
 
 	/* if there is no IO to be submitted for this page, we are done */
-	if (!ioend)
+	if (!count)
 		return 0;
 
-	ASSERT(iohead);
+	ASSERT(wpc->iohead);
 
 	/*
 	 * Any errors from this point onwards need tobe reported through the IO
@@ -1162,31 +1152,37 @@ xfs_do_writepage(
 		if (end_index > last_index)
 			end_index = last_index;
 
-		xfs_cluster_write(inode, page->index + 1, &wpc->imap, &ioend,
-				  wbc, end_index);
+		xfs_cluster_write(inode, page->index + 1, &wpc->imap,
+				  &wpc->ioend, wbc, end_index);
 	}
 
-
-	/*
-	 * Reserve log space if we might write beyond the on-disk inode size.
-	 */
-	err = 0;
-	if (ioend->io_type != XFS_IO_UNWRITTEN && xfs_ioend_is_append(ioend))
-		err = xfs_setfilesize_trans_alloc(ioend);
-
-	xfs_submit_ioend(wbc, iohead, err);
-
 	return 0;
 
 error:
-	if (iohead)
-		xfs_cancel_ioend(iohead);
+	/*
+	 * We have to fail the iohead here because we buffers locked in the
+	 * ioend chain. If we don't do this, we'll deadlock invalidating the
+	 * page as that tries to lock the buffers on the page. Also, because we
+	 * have set pages under writeback, we have to run IO completion to mark
+	 * the error state of the IO appropriately, so we can't cancel the ioend
+	 * directly here. That means we have to mark this page as under
+	 * writeback if we included any buffers from it in the ioend chain.
+	 */
+	if (count)
+		xfs_start_page_writeback(page, 0, count);
+	xfs_writepage_submit(wpc, wbc, err);
 
-	xfs_aops_discard_page(page);
-	ClearPageUptodate(page);
-	unlock_page(page);
+	/*
+	 * We can only discard the page we had the IO error on if we haven't
+	 * included it in the ioend above. If it has already been errored out,
+	 * the it is unlocked and we can't touch it here.
+	 */
+	if (!count) {
+		xfs_aops_discard_page(page);
+		ClearPageUptodate(page);
+		unlock_page(page);
+	}
 	mapping_set_error(page->mapping, err);
-	wpc->imap_valid = false;
 	return err;
 
 redirty:
@@ -1203,8 +1199,12 @@ xfs_vm_writepage(
 	struct xfs_writepage_ctx wpc = {
 		.io_type = XFS_IO_OVERWRITE,
 	};
+	int			ret;
 
-	return xfs_do_writepage(page, wbc, &wpc);
+	ret = xfs_do_writepage(page, wbc, &wpc);
+	if (ret)
+		return ret;
+	return xfs_writepage_submit(&wpc, wbc, ret);
 }
 
 STATIC int
@@ -1215,15 +1215,13 @@ xfs_vm_writepages(
 	struct xfs_writepage_ctx wpc = {
 		.io_type = XFS_IO_OVERWRITE,
 	};
-	struct blk_plug		plug;
 	int			ret;
 
 	xfs_iflags_clear(XFS_I(mapping->host), XFS_ITRUNCATED);
-	blk_start_plug(&plug);
 	ret = write_cache_pages(mapping, wbc, xfs_do_writepage, &wpc);
-	blk_finish_plug(&plug);
-
-	return ret;
+	if (ret)
+		return ret;
+	return xfs_writepage_submit(&wpc, wbc, ret);
 }
 
 /*
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
