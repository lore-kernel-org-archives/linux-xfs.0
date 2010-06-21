Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L8XRxH113443 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 03:33:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9696014515CB
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:40:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id iCaBKMncE5uFZlpq for
	<xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:40:12 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OQcUB-0007ZC-2N
	for xfs@oss.sgi.com; Mon, 21 Jun 2010 08:36:07 +0000
Message-Id: <20100621083606.962351649@bombadil.infradead.org>
Date: Mon, 21 Jun 2010 04:35:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 04/12] xfs: simplify xfs_vm_writepage
References: <20100621083543.125860679@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-simplify-writepage
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The writepage implementation in XFS still tries to deal with dirty but
unmapped buffers which used to caused by writes through shared mmaps.  Since
the introduction of ->page_mkwrite these can't happen anymore, so remove the
code dealing with them.

Note that the all_bh variable which causes us to start I/O on all buffers on
the pages was controlled by the count of unmapped buffers, which also
included those not actually dirty.  It's now unconditionally initialized to
0 but set to 1 for the case of small file size extensions.  It probably can
be removed entirely, but that's left for another patch.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-06-11 09:27:27.602003840 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-06-11 09:28:45.408003978 +0200
@@ -85,18 +85,15 @@ void
 xfs_count_page_state(
 	struct page		*page,
 	int			*delalloc,
-	int			*unmapped,
 	int			*unwritten)
 {
 	struct buffer_head	*bh, *head;
 
-	*delalloc = *unmapped = *unwritten = 0;
+	*delalloc = *unwritten = 0;
 
 	bh = head = page_buffers(page);
 	do {
-		if (buffer_uptodate(bh) && !buffer_mapped(bh))
-			(*unmapped) = 1;
-		else if (buffer_unwritten(bh))
+		if (buffer_unwritten(bh))
 			(*unwritten) = 1;
 		else if (buffer_delay(bh))
 			(*delalloc) = 1;
@@ -607,31 +604,30 @@ xfs_map_at_offset(
 STATIC unsigned int
 xfs_probe_page(
 	struct page		*page,
-	unsigned int		pg_offset,
-	int			mapped)
+	unsigned int		pg_offset)
 {
+	struct buffer_head	*bh, *head;
 	int			ret = 0;
 
 	if (PageWriteback(page))
 		return 0;
+	if (!PageDirty(page))
+		return 0;
+	if (!page->mapping)
+		return 0;
+	if (!page_has_buffers(page))
+		return 0;
 
-	if (page->mapping && PageDirty(page)) {
-		if (page_has_buffers(page)) {
-			struct buffer_head	*bh, *head;
-
-			bh = head = page_buffers(page);
-			do {
-				if (!buffer_uptodate(bh))
-					break;
-				if (mapped != buffer_mapped(bh))
-					break;
-				ret += bh->b_size;
-				if (ret >= pg_offset)
-					break;
-			} while ((bh = bh->b_this_page) != head);
-		} else
-			ret = mapped ? 0 : PAGE_CACHE_SIZE;
-	}
+	bh = head = page_buffers(page);
+	do {
+		if (!buffer_uptodate(bh))
+			break;
+		if (!buffer_mapped(bh))
+			break;
+		ret += bh->b_size;
+		if (ret >= pg_offset)
+			break;
+	} while ((bh = bh->b_this_page) != head);
 
 	return ret;
 }
@@ -641,8 +637,7 @@ xfs_probe_cluster(
 	struct inode		*inode,
 	struct page		*startpage,
 	struct buffer_head	*bh,
-	struct buffer_head	*head,
-	int			mapped)
+	struct buffer_head	*head)
 {
 	struct pagevec		pvec;
 	pgoff_t			tindex, tlast, tloff;
@@ -651,7 +646,7 @@ xfs_probe_cluster(
 
 	/* First sum forwards in this page */
 	do {
-		if (!buffer_uptodate(bh) || (mapped != buffer_mapped(bh)))
+		if (!buffer_uptodate(bh) || !buffer_mapped(bh))
 			return total;
 		total += bh->b_size;
 	} while ((bh = bh->b_this_page) != head);
@@ -685,7 +680,7 @@ xfs_probe_cluster(
 				pg_offset = PAGE_CACHE_SIZE;
 
 			if (page->index == tindex && trylock_page(page)) {
-				pg_len = xfs_probe_page(page, pg_offset, mapped);
+				pg_len = xfs_probe_page(page, pg_offset);
 				unlock_page(page);
 			}
 
@@ -1021,18 +1016,12 @@ out_invalidate:
  * For delalloc space on the page we need to allocate space and flush it.
  * For unwritten space on the page we need to start the conversion to
  * regular allocated space.
- * For unmapped buffer heads on the page we should allocate space if the
- * page is uptodate.
  * For any other dirty buffer heads on the page we should flush them.
  *
  * If we detect that a transaction would be required to flush the page, we
  * have to check the process flags first, if we are already in a transaction
  * or disk I/O during allocations is off, we need to fail the writepage and
  * redirty the page.
- *
- * The bh->b_state's cannot know if any of the blocks or which block for that
- * matter are dirty due to mmap writes, and therefore bh uptodate is only
- * valid if the page itself isn't completely uptodate.
  */
 STATIC int
 xfs_vm_writepage(
@@ -1040,8 +1029,7 @@ xfs_vm_writepage(
 	struct writeback_control *wbc)
 {
 	struct inode		*inode = page->mapping->host;
-	int			need_trans;
-	int			delalloc, unmapped, unwritten;
+	int			delalloc, unwritten;
 	struct buffer_head	*bh, *head;
 	struct xfs_bmbt_irec	imap;
 	xfs_ioend_t		*ioend = NULL, *iohead = NULL;
@@ -1052,10 +1040,12 @@ xfs_vm_writepage(
 	ssize_t			size, len;
 	int			flags, err, imap_valid = 0, uptodate = 1;
 	int			count = 0;
-	int			all_bh;
+	int			all_bh = 0;
 
 	trace_xfs_writepage(inode, page, 0);
 
+	ASSERT(page_has_buffers(page));
+
 	/*
 	 * Refuse to write the page out if we are called from reclaim context.
 	 *
@@ -1072,39 +1062,18 @@ xfs_vm_writepage(
 		goto out_fail;
 
 	/*
-	 * We need a transaction if:
-	 *  1. There are delalloc buffers on the page
-	 *  2. The page is uptodate and we have unmapped buffers
-	 *  3. The page is uptodate and we have no buffers
-	 *  4. There are unwritten buffers on the page
-	 */
-	if (!page_has_buffers(page)) {
-		unmapped = 1;
-		need_trans = 1;
-	} else {
-		xfs_count_page_state(page, &delalloc, &unmapped, &unwritten);
-		if (!PageUptodate(page))
-			unmapped = 0;
-		need_trans = delalloc + unmapped + unwritten;
-	}
-
-	/*
-	 * If we need a transaction and the process flags say
-	 * we are already in a transaction, or no IO is allowed
-	 * then mark the page dirty again and leave the page
-	 * as is.
+	 * We need a transaction if there are delalloc or unwritten buffers
+	 * on the page.
+	 *
+	 * If we need a transaction and the process flags say we are already
+	 * in a transaction, or no IO is allowed then mark the page dirty
+	 * again and leave the page as is.
 	 */
-	if (current_test_flags(PF_FSTRANS) && need_trans)
+	xfs_count_page_state(page, &delalloc, &unwritten);
+	if ((current->flags & PF_FSTRANS) && (delalloc || unwritten))
 		goto out_fail;
 
 	/*
-	 * Delay hooking up buffer heads until we have
-	 * made our go/no-go decision.
-	 */
-	if (!page_has_buffers(page))
-		create_empty_buffers(page, 1 << inode->i_blkbits, 0);
-
-	/*
 	 * VM calculation for nr_to_write seems off.  Bump it way
 	 * up, this gets simple streaming writes zippy again.
 	 * To be reviewed again after Jens' writeback changes.
@@ -1124,7 +1093,8 @@ xfs_vm_writepage(
 	}
 
 	end_offset = min_t(unsigned long long,
-			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT, offset);
+			(xfs_off_t)(page->index + 1) << PAGE_CACHE_SHIFT,
+			offset);
 	len = 1 << inode->i_blkbits;
 
 	bh = head = page_buffers(page);
@@ -1132,8 +1102,6 @@ xfs_vm_writepage(
 	flags = BMAPI_READ;
 	type = IO_NEW;
 
-	all_bh = unmapped;
-
 	do {
 		if (offset >= end_offset)
 			break;
@@ -1153,19 +1121,7 @@ xfs_vm_writepage(
 		if (imap_valid)
 			imap_valid = xfs_imap_valid(inode, &imap, offset);
 
-		/*
-		 * First case, map an unwritten extent and prepare for
-		 * extent state conversion transaction on completion.
-		 *
-		 * Second case, allocate space for a delalloc buffer.
-		 * We can return EAGAIN here in the release page case.
-		 *
-		 * Third case, an unmapped buffer was found, and we are
-		 * in a path where we need to write the whole page out.
-		 */
-		if (buffer_unwritten(bh) || buffer_delay(bh) ||
-		    ((buffer_uptodate(bh) || PageUptodate(page)) &&
-		     !buffer_mapped(bh))) {
+		if (buffer_unwritten(bh) || buffer_delay(bh)) {
 			int new_ioend = 0;
 
 			/*
@@ -1184,14 +1140,11 @@ xfs_vm_writepage(
 				if (wbc->sync_mode == WB_SYNC_NONE &&
 				    wbc->nonblocking)
 					flags |= BMAPI_TRYLOCK;
-			} else {
-				type = IO_NEW;
-				flags = BMAPI_WRITE | BMAPI_MMAP;
 			}
 
 			if (!imap_valid) {
 				/*
-				 * if we didn't have a valid mapping then we
+				 * If we didn't have a valid mapping then we
 				 * need to ensure that we put the new mapping
 				 * in a new ioend structure. This needs to be
 				 * done to ensure that the ioends correctly
@@ -1199,14 +1152,7 @@ xfs_vm_writepage(
 				 * for unwritten extent conversion.
 				 */
 				new_ioend = 1;
-				if (type == IO_NEW) {
-					size = xfs_probe_cluster(inode,
-							page, bh, head, 0);
-				} else {
-					size = len;
-				}
-
-				err = xfs_map_blocks(inode, offset, size,
+				err = xfs_map_blocks(inode, offset, len,
 						&imap, flags);
 				if (err)
 					goto error;
@@ -1227,8 +1173,7 @@ xfs_vm_writepage(
 			 */
 			if (!imap_valid || flags != BMAPI_READ) {
 				flags = BMAPI_READ;
-				size = xfs_probe_cluster(inode, page, bh,
-								head, 1);
+				size = xfs_probe_cluster(inode, page, bh, head);
 				err = xfs_map_blocks(inode, offset, size,
 						&imap, flags);
 				if (err)
@@ -1247,7 +1192,6 @@ xfs_vm_writepage(
 			 */
 			type = IO_NEW;
 			if (trylock_buffer(bh)) {
-				ASSERT(buffer_mapped(bh));
 				if (imap_valid)
 					all_bh = 1;
 				xfs_add_to_ioend(inode, bh, offset, type,
@@ -1257,6 +1201,7 @@ xfs_vm_writepage(
 				imap_valid = 0;
 			}
 		} else if (PageUptodate(page)) {
+			ASSERT(buffer_mapped(bh));
 			imap_valid = 0;
 		}
 
@@ -1298,8 +1243,7 @@ error:
 	if (iohead)
 		xfs_cancel_ioend(iohead);
 
-	if (!unmapped)
-		xfs_aops_discard_page(page);
+	xfs_aops_discard_page(page);
 	ClearPageUptodate(page);
 	unlock_page(page);
 	return err;
@@ -1331,11 +1275,11 @@ xfs_vm_releasepage(
 	struct page		*page,
 	gfp_t			gfp_mask)
 {
-	int			delalloc, unmapped, unwritten;
+	int			delalloc, unwritten;
 
 	trace_xfs_releasepage(page->mapping->host, page, 0);
 
-	xfs_count_page_state(page, &delalloc, &unmapped, &unwritten);
+	xfs_count_page_state(page, &delalloc, &unwritten);
 
 	if (WARN_ON(delalloc))
 		return 0;
Index: xfs/fs/xfs/linux-2.6/xfs_aops.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.h	2010-02-13 22:45:45.000000000 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_aops.h	2010-06-11 09:27:44.075004398 +0200
@@ -45,6 +45,6 @@ extern int xfs_get_blocks(struct inode *
 extern void xfs_ioend_init(void);
 extern void xfs_ioend_wait(struct xfs_inode *);
 
-extern void xfs_count_page_state(struct page *, int *, int *, int *);
+extern void xfs_count_page_state(struct page *, int *, int *);
 
 #endif /* __XFS_AOPS_H__ */
Index: xfs/fs/xfs/linux-2.6/xfs_trace.h
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_trace.h	2010-06-04 15:12:52.000000000 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_trace.h	2010-06-11 09:27:44.083003979 +0200
@@ -829,33 +829,29 @@ DECLARE_EVENT_CLASS(xfs_page_class,
 		__field(loff_t, size)
 		__field(unsigned long, offset)
 		__field(int, delalloc)
-		__field(int, unmapped)
 		__field(int, unwritten)
 	),
 	TP_fast_assign(
-		int delalloc = -1, unmapped = -1, unwritten = -1;
+		int delalloc = -1, unwritten = -1;
 
 		if (page_has_buffers(page))
-			xfs_count_page_state(page, &delalloc,
-					     &unmapped, &unwritten);
+			xfs_count_page_state(page, &delalloc, &unwritten);
 		__entry->dev = inode->i_sb->s_dev;
 		__entry->ino = XFS_I(inode)->i_ino;
 		__entry->pgoff = page_offset(page);
 		__entry->size = i_size_read(inode);
 		__entry->offset = off;
 		__entry->delalloc = delalloc;
-		__entry->unmapped = unmapped;
 		__entry->unwritten = unwritten;
 	),
 	TP_printk("dev %d:%d ino 0x%llx pgoff 0x%lx size 0x%llx offset %lx "
-		  "delalloc %d unmapped %d unwritten %d",
+		  "delalloc %d unwritten %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->pgoff,
 		  __entry->size,
 		  __entry->offset,
 		  __entry->delalloc,
-		  __entry->unmapped,
 		  __entry->unwritten)
 )
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
