Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 073D77F61
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 17:50:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 8DE0AAC004
	for <xfs@oss.sgi.com>; Tue, 11 Aug 2015 15:50:01 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	VK3qoAA0jyPnTR6n for <xfs@oss.sgi.com>;
	Tue, 11 Aug 2015 15:49:59 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZPIMh-0005YI-1g
	for xfs@oss.sgi.com; Wed, 12 Aug 2015 08:49:51 +1000
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1ZPIMh-0004Oj-0V
	for xfs@oss.sgi.com; Wed, 12 Aug 2015 08:49:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/8] xfs: writepage context needs to handle discontiguous page
	ranges
Date: Wed, 12 Aug 2015 08:49:45 +1000
Message-Id: <1439333388-16452-6-git-send-email-david@fromorbit.com>
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

If the pages sent down by write_cache_pages to the writepage
callback are discontiguous, we need to detect this and put each
discontiguous page range into individual ioends. This is needed to
ensure that the ioend accurately represents the range of the file
that it covers so that file size updates during IO completion set
the size correctly. Failure to take into account the discontiguous
ranges results in files being too small when writeback patterns are
non-sequential.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 82 ++++++++++++++++++++++---------------------------------
 1 file changed, 32 insertions(+), 50 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e4184f5..93bf13c 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -45,6 +45,7 @@ struct xfs_writepage_ctx {
 	unsigned int		io_type;
 	struct xfs_ioend	*iohead;
 	struct xfs_ioend	*ioend;
+	sector_t		last_block;
 };
 
 void
@@ -537,29 +538,27 @@ xfs_add_to_ioend(
 	struct inode		*inode,
 	struct buffer_head	*bh,
 	xfs_off_t		offset,
-	unsigned int		type,
-	xfs_ioend_t		**result,
-	int			need_ioend)
+	struct xfs_writepage_ctx *wpc)
 {
-	xfs_ioend_t		*ioend = *result;
-
-	if (!ioend || need_ioend || type != ioend->io_type) {
-		xfs_ioend_t	*previous = *result;
-
-		ioend = xfs_alloc_ioend(inode, type);
-		ioend->io_offset = offset;
-		ioend->io_buffer_head = bh;
-		ioend->io_buffer_tail = bh;
-		if (previous)
-			previous->io_list = ioend;
-		*result = ioend;
+	if (!wpc->ioend || wpc->io_type != wpc->ioend->io_type ||
+	    bh->b_blocknr != wpc->last_block + 1) {
+		struct xfs_ioend	*new;
+
+		new = xfs_alloc_ioend(inode, wpc->io_type);
+		new->io_offset = offset;
+		new->io_buffer_head = bh;
+		new->io_buffer_tail = bh;
+		if (wpc->ioend)
+			wpc->ioend->io_list = new;
+		wpc->ioend = new;
 	} else {
-		ioend->io_buffer_tail->b_private = bh;
-		ioend->io_buffer_tail = bh;
+		wpc->ioend->io_buffer_tail->b_private = bh;
+		wpc->ioend->io_buffer_tail = bh;
 	}
 
 	bh->b_private = NULL;
-	ioend->io_size += bh->b_size;
+	wpc->ioend->io_size += bh->b_size;
+	wpc->last_block = bh->b_blocknr;
 }
 
 STATIC void
@@ -656,17 +655,15 @@ xfs_convert_page(
 	struct inode		*inode,
 	struct page		*page,
 	loff_t			tindex,
-	struct xfs_bmbt_irec	*imap,
-	xfs_ioend_t		**ioendp,
+	struct xfs_writepage_ctx *wpc,
 	struct writeback_control *wbc)
 {
 	struct buffer_head	*bh, *head;
 	xfs_off_t		end_offset;
 	unsigned long		p_offset;
-	unsigned int		type;
 	int			len, page_dirty;
 	int			count = 0, done = 0, uptodate = 1;
- 	xfs_off_t		offset = page_offset(page);
+	xfs_off_t		offset = page_offset(page);
 
 	if (page->index != tindex)
 		goto fail;
@@ -676,7 +673,7 @@ xfs_convert_page(
 		goto fail_unlock_page;
 	if (page->mapping != inode->i_mapping)
 		goto fail_unlock_page;
-	if (!xfs_check_page_type(page, (*ioendp)->io_type, false))
+	if (!xfs_check_page_type(page, wpc->ioend->io_type, false))
 		goto fail_unlock_page;
 
 	/*
@@ -712,7 +709,7 @@ xfs_convert_page(
 	 * writeback.  Hence for more optimal IO patterns, we should always
 	 * avoid partial page writeback due to multiple mappings on a page here.
 	 */
-	if (!xfs_imap_valid(inode, imap, end_offset))
+	if (!xfs_imap_valid(inode, &wpc->imap, end_offset))
 		goto fail_unlock_page;
 
 	len = 1 << inode->i_blkbits;
@@ -744,23 +741,22 @@ xfs_convert_page(
 		if (buffer_unwritten(bh) || buffer_delay(bh) ||
 		    buffer_mapped(bh)) {
 			if (buffer_unwritten(bh))
-				type = XFS_IO_UNWRITTEN;
+				wpc->io_type = XFS_IO_UNWRITTEN;
 			else if (buffer_delay(bh))
-				type = XFS_IO_DELALLOC;
+				wpc->io_type = XFS_IO_DELALLOC;
 			else
-				type = XFS_IO_OVERWRITE;
+				wpc->io_type = XFS_IO_OVERWRITE;
 
 			/*
 			 * imap should always be valid because of the above
 			 * partial page end_offset check on the imap.
 			 */
-			ASSERT(xfs_imap_valid(inode, imap, offset));
+			ASSERT(xfs_imap_valid(inode, &wpc->imap, offset));
 
 			lock_buffer(bh);
-			if (type != XFS_IO_OVERWRITE)
-				xfs_map_at_offset(inode, bh, imap, offset);
-			xfs_add_to_ioend(inode, bh, offset, type,
-					 ioendp, done);
+			if (wpc->io_type != XFS_IO_OVERWRITE)
+				xfs_map_at_offset(inode, bh, &wpc->imap, offset);
+			xfs_add_to_ioend(inode, bh, offset, wpc);
 
 			page_dirty--;
 			count++;
@@ -795,8 +791,7 @@ STATIC void
 xfs_cluster_write(
 	struct inode		*inode,
 	pgoff_t			tindex,
-	struct xfs_bmbt_irec	*imap,
-	xfs_ioend_t		**ioendp,
+	struct xfs_writepage_ctx *wpc,
 	struct writeback_control *wbc,
 	pgoff_t			tlast)
 {
@@ -812,7 +807,7 @@ xfs_cluster_write(
 
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			done = xfs_convert_page(inode, pvec.pages[i], tindex++,
-					imap, ioendp, wbc);
+						wpc, wbc);
 			if (done)
 				break;
 		}
@@ -1041,8 +1036,6 @@ xfs_do_writepage(
 	offset = page_offset(page);
 
 	do {
-		int new_ioend = 0;
-
 		if (offset >= end_offset)
 			break;
 		if (!buffer_uptodate(bh))
@@ -1091,15 +1084,6 @@ xfs_do_writepage(
 			wpc->imap_valid = xfs_imap_valid(inode, &wpc->imap,
 							 offset);
 		if (!wpc->imap_valid) {
-			/*
-			 * If we didn't have a valid mapping then we need to
-			 * put the new mapping into a separate ioend structure.
-			 * This ensures non-contiguous extents always have
-			 * separate ioends, which is particularly important
-			 * for unwritten extent conversion at I/O completion
-			 * time.
-			 */
-			new_ioend = 1;
 			err = xfs_map_blocks(inode, offset, &wpc->imap,
 					     wpc->io_type);
 			if (err)
@@ -1111,8 +1095,7 @@ xfs_do_writepage(
 			lock_buffer(bh);
 			if (wpc->io_type != XFS_IO_OVERWRITE)
 				xfs_map_at_offset(inode, bh, &wpc->imap, offset);
-			xfs_add_to_ioend(inode, bh, offset, wpc->io_type,
-					 &wpc->ioend, new_ioend);
+			xfs_add_to_ioend(inode, bh, offset, wpc);
 			count++;
 		}
 
@@ -1152,8 +1135,7 @@ xfs_do_writepage(
 		if (end_index > last_index)
 			end_index = last_index;
 
-		xfs_cluster_write(inode, page->index + 1, &wpc->imap,
-				  &wpc->ioend, wbc, end_index);
+		xfs_cluster_write(inode, page->index + 1, wpc, wbc, end_index);
 	}
 
 	return 0;
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
