Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2D2FE7CA7
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 23:44:33 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2406E8F8033
	for <xfs@oss.sgi.com>; Sun,  7 Feb 2016 21:44:33 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	wGKSmOKc6Ob8MJwv for <xfs@oss.sgi.com>;
	Sun, 07 Feb 2016 21:44:30 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aSecX-0007Av-SO
	for xfs@oss.sgi.com; Mon, 08 Feb 2016 16:44:21 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aSecX-00021m-Rn
	for xfs@oss.sgi.com; Mon, 08 Feb 2016 16:44:21 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/5] xfs: don't chain ioends during writepage submission
Date: Mon,  8 Feb 2016 16:44:18 +1100
Message-Id: <1454910258-7578-6-git-send-email-david@fromorbit.com>
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

Currently we can build a long ioend chain during ->writepages that
gets attached to the writepage context. IO submission only then
occurs when we finish all the writepage processing. This means we
can have many ioends allocated and pending, and this violates the
mempool guarantees that we need to give about forwards progress.
i.e. we really should only have one ioend being built at a time,
otherwise we may drain the mempool trying to allocate a new ioend
and that blocks submission, completion and freeing of ioends that
are already in progress.

To prevent this situation from happening, we need to submit ioends
for IO as soon as they are ready for dispatch rather than queuing
them for later submission. This means the ioends have bios built
immediately and they get queued on any plug that is current active.
Hence if we schedule away from writeback, the ioends that have been
built will make forwards progress due to the plug flushing on
context switch. This will also prevent context switches from
creating unnecessary IO submission latency.

We can't completely avoid having nested IO allocation - when we have
a block size smaller than a page size, we still need to hold the
ioend submission until after we have marked the current page dirty.
Hence we may need multiple ioends to be held while the current page
is completely mapped and made ready for IO dispatch. We cannot avoid
this problem - the current code already has this ioend chaining
within a page so we can mostly ignore that it occurs.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_aops.c | 94 ++++++++++++++++++++++++++++---------------------------
 1 file changed, 48 insertions(+), 46 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index e5b8214..852ecf2 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -47,7 +47,6 @@ struct xfs_writepage_ctx {
 	struct xfs_bmbt_irec    imap;
 	bool			imap_valid;
 	unsigned int		io_type;
-	struct xfs_ioend	*iohead;
 	struct xfs_ioend	*ioend;
 	sector_t		last_block;
 };
@@ -461,19 +460,6 @@ static inline int xfs_bio_add_buffer(struct bio *bio, struct buffer_head *bh)
  * Submit all of the bios for all of the ioends we have saved up, covering the
  * initial writepage page and also any probed pages.
  *
- * Because we may have multiple ioends spanning a page, we need to start
- * writeback on all the buffers before we submit them for I/O. If we mark the
- * buffers as we got, then we can end up with a page that only has buffers
- * marked async write and I/O complete on can occur before we mark the other
- * buffers async write.
- *
- * The end result of this is that we trip a bug in end_page_writeback() because
- * we call it twice for the one page as the code in end_buffer_async_write()
- * assumes that all buffers on the page are started at the same time.
- *
- * The fix is two passes across the ioend list - one to start writeback on the
- * buffer_heads, and then submit them for I/O on the second pass.
- *
  * If @fail is non-zero, it means that we have a situation where some part of
  * the submission process has failed after we have marked paged for writeback
  * and unlocked them. In this situation, we need to fail the ioend chain rather
@@ -491,14 +477,11 @@ xfs_submit_ioend(
 	struct bio		*bio;
 	sector_t		lastblock = 0;
 
-	/* Pass 1 - start writeback */
-	do {
-		next = ioend->io_list;
-		for (bh = ioend->io_buffer_head; bh; bh = bh->b_private)
-			xfs_start_buffer_writeback(bh);
-	} while ((ioend = next) != NULL);
+	/* Reserve log space if we might write beyond the on-disk inode size. */
+	if (!fail && ioend && ioend->io_type != XFS_IO_UNWRITTEN &&
+	    xfs_ioend_is_append(ioend))
+		fail = xfs_setfilesize_trans_alloc(ioend);
 
-	/* Pass 2 - submit I/O */
 	ioend = head;
 	do {
 		next = ioend->io_list;
@@ -543,25 +526,28 @@ xfs_submit_ioend(
  * Test to see if we've been building up a completion structure for
  * earlier buffers -- if so, we try to append to this ioend if we
  * can, otherwise we finish off any current ioend and start another.
- * Return true if we've finished the given ioend.
+ * Return the ioend we finished off so that the caller can submit it
+ * once it has finished processing the dirty page.
  */
-STATIC void
+STATIC struct xfs_ioend *
 xfs_add_to_ioend(
 	struct inode		*inode,
 	struct buffer_head	*bh,
 	xfs_off_t		offset,
 	struct xfs_writepage_ctx *wpc)
 {
+	struct xfs_ioend	*ioend_to_submit = NULL;
+
 	if (!wpc->ioend || wpc->io_type != wpc->ioend->io_type ||
 	    bh->b_blocknr != wpc->last_block + 1) {
 		struct xfs_ioend	*new;
 
+		ioend_to_submit = wpc->ioend;
+
 		new = xfs_alloc_ioend(inode, wpc->io_type);
 		new->io_offset = offset;
 		new->io_buffer_head = bh;
 		new->io_buffer_tail = bh;
-		if (wpc->ioend)
-			wpc->ioend->io_list = new;
 		wpc->ioend = new;
 	} else {
 		wpc->ioend->io_buffer_tail->b_private = bh;
@@ -571,6 +557,8 @@ xfs_add_to_ioend(
 	bh->b_private = NULL;
 	wpc->ioend->io_size += bh->b_size;
 	wpc->last_block = bh->b_blocknr;
+	xfs_start_buffer_writeback(bh);
+	return ioend_to_submit;
 }
 
 STATIC void
@@ -738,29 +726,22 @@ xfs_writepage_submit(
 	struct writeback_control *wbc,
 	int			status)
 {
-	struct blk_plug		plug;
-
-	/* Reserve log space if we might write beyond the on-disk inode size. */
-	if (!status && wpc->ioend && wpc->ioend->io_type != XFS_IO_UNWRITTEN &&
-	    xfs_ioend_is_append(wpc->ioend))
-		status = xfs_setfilesize_trans_alloc(wpc->ioend);
-
-	if (wpc->iohead) {
-		blk_start_plug(&plug);
-		xfs_submit_ioend(wbc, wpc->iohead, status);
-		blk_finish_plug(&plug);
-	}
+	if (wpc->ioend)
+		xfs_submit_ioend(wbc, wpc->ioend, status);
 	return status;
 }
 
 static int
 xfs_writepage_map(
 	struct xfs_writepage_ctx *wpc,
+	struct writeback_control *wbc,
 	struct inode		*inode,
 	struct page		*page,
 	loff_t			offset,
 	__uint64_t              end_offset)
 {
+	struct xfs_ioend	*ioend_to_submit = NULL;
+	struct xfs_ioend	*ioend_tail = NULL;
 	struct buffer_head	*bh, *head;
 	ssize_t			len = 1 << inode->i_blkbits;
 	int			error = 0;
@@ -827,23 +808,37 @@ xfs_writepage_map(
 							 offset);
 		}
 		if (wpc->imap_valid) {
+			struct xfs_ioend *ioend;
+
 			lock_buffer(bh);
 			if (wpc->io_type != XFS_IO_OVERWRITE)
 				xfs_map_at_offset(inode, bh, &wpc->imap, offset);
-			xfs_add_to_ioend(inode, bh, offset, wpc);
+			ioend = xfs_add_to_ioend(inode, bh, offset, wpc);
+			if (ioend) {
+				ioend->io_list = NULL;
+				if (!ioend_to_submit)
+					ioend_to_submit = ioend;
+				else
+					ioend_tail->io_list = ioend;
+				ioend_tail = ioend;
+			}
 			count++;
 		}
 
-		if (!wpc->iohead)
-			wpc->iohead = wpc->ioend;
-
 	} while (offset += len, ((bh = bh->b_this_page) != head));
 
 	if (uptodate && bh == head)
 		SetPageUptodate(page);
 
 	xfs_start_page_writeback(page, 1, count);
-	ASSERT(wpc->iohead || !count);
+	ASSERT(wpc->ioend || !count);
+	while (ioend_to_submit) {
+		struct xfs_ioend *next = ioend_to_submit->io_list;
+
+		ioend_to_submit->io_list = NULL;
+		xfs_submit_ioend(wbc, ioend_to_submit, 0);
+		ioend_to_submit = next;
+	}
 	return 0;
 
 out_error:
@@ -853,9 +848,16 @@ out_error:
 	 * ioend, then we can't touch it here and need to rely on IO submission
 	 * to unlock it.
 	 */
-	if (count)
+	if (count) {
 		xfs_start_page_writeback(page, 0, count);
-	else {
+		while (ioend_to_submit) {
+			struct xfs_ioend *next = ioend_to_submit->io_list;
+
+			ioend_to_submit->io_list = NULL;
+			xfs_submit_ioend(wbc, ioend_to_submit, 0);
+			ioend_to_submit = next;
+		}
+	} else {
 		xfs_aops_discard_page(page);
 		ClearPageUptodate(page);
 		unlock_page(page);
@@ -975,14 +977,14 @@ xfs_do_writepage(
 		end_offset = offset;
 	}
 
-	error = xfs_writepage_map(wpc, inode, page, offset, end_offset);
+	error = xfs_writepage_map(wpc, wbc, inode, page, offset, end_offset);
 	if (error)
 		goto out_error;
 	return 0;
 
 out_error:
 	/*
-	 * We have to fail the iohead here because we buffers locked in the
+	 * We have to fail the ioend here because we buffers locked in the
 	 * ioend chain. If we don't do this, we'll deadlock invalidating the
 	 * page as that tries to lock the buffers on the page. Also, because we
 	 * have set pages under writeback, we have to run IO completion to mark
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
