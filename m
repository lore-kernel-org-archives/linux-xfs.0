Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 270097CA6
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 23:44:35 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1ECBF8F8033
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 21:44:31 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	deQg7BGWQbNQd0ap for <xfs@oss.sgi.com>;
	Sun, 07 Feb 2016 21:44:29 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aSecX-0007Au-Rx
	for xfs@oss.sgi.com; Mon, 08 Feb 2016 16:44:21 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aSecX-00021h-RI
	for xfs@oss.sgi.com; Mon, 08 Feb 2016 16:44:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/5] xfs: factor mapping out of xfs_do_writepage
Date: Mon,  8 Feb 2016 16:44:17 +1100
Message-Id: <1454910258-7578-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1454910258-7578-1-git-send-email-david@fromorbit.com>
References: <1454910258-7578-1-git-send-email-david@fromorbit.com>
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

Separate out the bufferhead based mapping from the writepage code so
that we have a clear separation of the page operations and the
bufferhead state.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 221 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 119 insertions(+), 102 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e473f53..e5b8214 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -753,6 +753,116 @@ xfs_writepage_submit(
 	return status;
 }
 
+static int
+xfs_writepage_map(
+	struct xfs_writepage_ctx *wpc,
+	struct inode		*inode,
+	struct page		*page,
+	loff_t			offset,
+	__uint64_t              end_offset)
+{
+	struct buffer_head	*bh, *head;
+	ssize_t			len = 1 << inode->i_blkbits;
+	int			error = 0;
+	int			uptodate = 1;
+	int			count = 0;
+
+	bh = head = page_buffers(page);
+	offset = page_offset(page);
+
+	do {
+		if (offset >= end_offset)
+			break;
+		if (!buffer_uptodate(bh))
+			uptodate = 0;
+
+		/*
+		 * set_page_dirty dirties all buffers in a page, independent
+		 * of their state.  The dirty state however is entirely
+		 * meaningless for holes (!mapped && uptodate), so skip
+		 * buffers covering holes here.
+		 */
+		if (!buffer_mapped(bh) && buffer_uptodate(bh)) {
+			wpc->imap_valid = false;
+			continue;
+		}
+
+		if (buffer_unwritten(bh)) {
+			if (wpc->io_type != XFS_IO_UNWRITTEN) {
+				wpc->io_type = XFS_IO_UNWRITTEN;
+				wpc->imap_valid = false;
+			}
+		} else if (buffer_delay(bh)) {
+			if (wpc->io_type != XFS_IO_DELALLOC) {
+				wpc->io_type = XFS_IO_DELALLOC;
+				wpc->imap_valid = false;
+			}
+		} else if (buffer_uptodate(bh)) {
+			if (wpc->io_type != XFS_IO_OVERWRITE) {
+				wpc->io_type = XFS_IO_OVERWRITE;
+				wpc->imap_valid = false;
+			}
+		} else {
+			if (PageUptodate(page))
+				ASSERT(buffer_mapped(bh));
+			/*
+			 * This buffer is not uptodate and will not be
+			 * written to disk.  Ensure that we will put any
+			 * subsequent writeable buffers into a new
+			 * ioend.
+			 */
+			wpc->imap_valid = false;
+			continue;
+		}
+
+		if (wpc->imap_valid)
+			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
+							 offset);
+		if (!wpc->imap_valid) {
+			error = xfs_map_blocks(inode, offset, &wpc->imap,
+					     wpc->io_type);
+			if (error)
+				goto out_error;
+			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
+							 offset);
+		}
+		if (wpc->imap_valid) {
+			lock_buffer(bh);
+			if (wpc->io_type != XFS_IO_OVERWRITE)
+				xfs_map_at_offset(inode, bh, &wpc->imap, offset);
+			xfs_add_to_ioend(inode, bh, offset, wpc);
+			count++;
+		}
+
+		if (!wpc->iohead)
+			wpc->iohead = wpc->ioend;
+
+	} while (offset += len, ((bh = bh->b_this_page) != head));
+
+	if (uptodate && bh == head)
+		SetPageUptodate(page);
+
+	xfs_start_page_writeback(page, 1, count);
+	ASSERT(wpc->iohead || !count);
+	return 0;
+
+out_error:
+	/*
+	 * We can only discard the page we had the IO error on if we haven't
+	 * included it in the ioend above. If it has already been added to the
+	 * ioend, then we can't touch it here and need to rely on IO submission
+	 * to unlock it.
+	 */
+	if (count)
+		xfs_start_page_writeback(page, 0, count);
+	else {
+		xfs_aops_discard_page(page);
+		ClearPageUptodate(page);
+		unlock_page(page);
+	}
+	return error;
+}
+
 /*
  * Write out a dirty page.
  *
@@ -769,13 +879,10 @@ xfs_do_writepage(
 {
 	struct xfs_writepage_ctx *wpc = data;
 	struct inode		*inode = page->mapping->host;
-	struct buffer_head	*bh, *head;
 	loff_t			offset;
 	__uint64_t              end_offset;
 	pgoff_t                 end_index;
-	ssize_t			len;
-	int			err, uptodate = 1;
-	int			count = 0;
+	int			error = 0;
 
 	trace_xfs_writepage(inode, page, 0, 0);
 
@@ -868,113 +975,23 @@ xfs_do_writepage(
 		end_offset = offset;
 	}
 
-	len = 1 << inode->i_blkbits;
-
-	bh = head = page_buffers(page);
-	offset = page_offset(page);
-
-	do {
-		if (offset >= end_offset)
-			break;
-		if (!buffer_uptodate(bh))
-			uptodate = 0;
-
-		/*
-		 * set_page_dirty dirties all buffers in a page, independent
-		 * of their state.  The dirty state however is entirely
-		 * meaningless for holes (!mapped && uptodate), so skip
-		 * buffers covering holes here.
-		 */
-		if (!buffer_mapped(bh) && buffer_uptodate(bh)) {
-			wpc->imap_valid = false;
-			continue;
-		}
-
-		if (buffer_unwritten(bh)) {
-			if (wpc->io_type != XFS_IO_UNWRITTEN) {
-				wpc->io_type = XFS_IO_UNWRITTEN;
-				wpc->imap_valid = false;
-			}
-		} else if (buffer_delay(bh)) {
-			if (wpc->io_type != XFS_IO_DELALLOC) {
-				wpc->io_type = XFS_IO_DELALLOC;
-				wpc->imap_valid = false;
-			}
-		} else if (buffer_uptodate(bh)) {
-			if (wpc->io_type != XFS_IO_OVERWRITE) {
-				wpc->io_type = XFS_IO_OVERWRITE;
-				wpc->imap_valid = false;
-			}
-		} else {
-			if (PageUptodate(page))
-				ASSERT(buffer_mapped(bh));
-			/*
-			 * This buffer is not uptodate and will not be
-			 * written to disk.  Ensure that we will put any
-			 * subsequent writeable buffers into a new
-			 * ioend.
-			 */
-			wpc->imap_valid = false;
-			continue;
-		}
-
-		if (wpc->imap_valid)
-			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
-							 offset);
-		if (!wpc->imap_valid) {
-			err = xfs_map_blocks(inode, offset, &wpc->imap,
-					     wpc->io_type);
-			if (err)
-				goto error;
-			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
-							 offset);
-		}
-		if (wpc->imap_valid) {
-			lock_buffer(bh);
-			if (wpc->io_type != XFS_IO_OVERWRITE)
-				xfs_map_at_offset(inode, bh, &wpc->imap, offset);
-			xfs_add_to_ioend(inode, bh, offset, wpc);
-			count++;
-		}
-
-		if (!wpc->iohead)
-			wpc->iohead = wpc->ioend;
-
-	} while (offset += len, ((bh = bh->b_this_page) != head));
-
-	if (uptodate && bh == head)
-		SetPageUptodate(page);
-
-	xfs_start_page_writeback(page, 1, count);
-	ASSERT(wpc->iohead || !count);
+	error = xfs_writepage_map(wpc, inode, page, offset, end_offset);
+	if (error)
+		goto out_error;
 	return 0;
 
-error:
+out_error:
 	/*
 	 * We have to fail the iohead here because we buffers locked in the
 	 * ioend chain. If we don't do this, we'll deadlock invalidating the
 	 * page as that tries to lock the buffers on the page. Also, because we
 	 * have set pages under writeback, we have to run IO completion to mark
 	 * the error state of the IO appropriately, so we can't cancel the ioend
-	 * directly here. That means we have to mark this page as under
-	 * writeback if we included any buffers from it in the ioend chain.
+	 * directly here.
 	 */
-	if (count)
-		xfs_start_page_writeback(page, 0, count);
-	xfs_writepage_submit(wpc, wbc, err);
-
-	/*
-	 * We can only discard the page we had the IO error on if we haven't
-	 * included it in the ioend above. If it has already been errored out,
-	 * the it is unlocked and we can't touch it here.
-	 */
-	if (!count) {
-		xfs_aops_discard_page(page);
-		ClearPageUptodate(page);
-		unlock_page(page);
-	}
-	mapping_set_error(page->mapping, err);
-	return err;
+	xfs_writepage_submit(wpc, wbc, error);
+	mapping_set_error(page->mapping, error);
+	return error;
 
 redirty:
 	redirty_page_for_writepage(wbc, page);
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
