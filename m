Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAMD7RLU228608 for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 07:07:27 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C3501199154
	for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 05:09:04 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id yMDFJ14CcM6q1HTh for
	<xfs@oss.sgi.com>; Mon, 22 Nov 2010 05:09:04 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PKW8m-0005fe-CF
	for xfs@oss.sgi.com; Mon, 22 Nov 2010 13:09:04 +0000
Message-Id: <20101122130904.341654979@bombadil.infradead.org>
Date: Mon, 22 Nov 2010 08:05:13 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 07/10] xfs: remove xfs_probe_cluster
References: <20101122130506.868076797@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-xfs_probe_cluster
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

xfs_map_blocks always calls xfs_bmapi with the XFS_BMAPI_ENTIRE entire
flag, which tells it to not cap the extent at the passed in size, but
just treat the size as an minimum to map.  This means xfs_probe_cluster
is entirely useless as we'll always get the whole extent back anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-11-19 15:07:17.349281326 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-11-19 15:07:33.141005552 +0100
@@ -304,13 +304,13 @@ STATIC int
 xfs_map_blocks(
 	struct inode		*inode,
 	loff_t			offset,
-	ssize_t			count,
 	struct xfs_bmbt_irec	*imap,
 	int			type,
 	int			nonblocking)
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
+	ssize_t			count = 1 << inode->i_blkbits;
 	xfs_fileoff_t		offset_fsb, end_fsb;
 	int			error = 0;
 	int			bmapi_flags = XFS_BMAPI_ENTIRE;
@@ -635,108 +635,6 @@ xfs_map_at_offset(
 }
 
 /*
- * Look for a page at index that is suitable for clustering.
- */
-STATIC unsigned int
-xfs_probe_page(
-	struct page		*page,
-	unsigned int		pg_offset)
-{
-	struct buffer_head	*bh, *head;
-	int			ret = 0;
-
-	if (PageWriteback(page))
-		return 0;
-	if (!PageDirty(page))
-		return 0;
-	if (!page->mapping)
-		return 0;
-	if (!page_has_buffers(page))
-		return 0;
-
-	bh = head = page_buffers(page);
-	do {
-		if (!buffer_uptodate(bh))
-			break;
-		if (!buffer_mapped(bh))
-			break;
-		ret += bh->b_size;
-		if (ret >= pg_offset)
-			break;
-	} while ((bh = bh->b_this_page) != head);
-
-	return ret;
-}
-
-STATIC size_t
-xfs_probe_cluster(
-	struct inode		*inode,
-	struct page		*startpage,
-	struct buffer_head	*bh,
-	struct buffer_head	*head)
-{
-	struct pagevec		pvec;
-	pgoff_t			tindex, tlast, tloff;
-	size_t			total = 0;
-	int			done = 0, i;
-
-	/* First sum forwards in this page */
-	do {
-		if (!buffer_uptodate(bh) || !buffer_mapped(bh))
-			return total;
-		total += bh->b_size;
-	} while ((bh = bh->b_this_page) != head);
-
-	/* if we reached the end of the page, sum forwards in following pages */
-	tlast = i_size_read(inode) >> PAGE_CACHE_SHIFT;
-	tindex = startpage->index + 1;
-
-	/* Prune this back to avoid pathological behavior */
-	tloff = min(tlast, startpage->index + 64);
-
-	pagevec_init(&pvec, 0);
-	while (!done && tindex <= tloff) {
-		unsigned len = min_t(pgoff_t, PAGEVEC_SIZE, tlast - tindex + 1);
-
-		if (!pagevec_lookup(&pvec, inode->i_mapping, tindex, len))
-			break;
-
-		for (i = 0; i < pagevec_count(&pvec); i++) {
-			struct page *page = pvec.pages[i];
-			size_t pg_offset, pg_len = 0;
-
-			if (tindex == tlast) {
-				pg_offset =
-				    i_size_read(inode) & (PAGE_CACHE_SIZE - 1);
-				if (!pg_offset) {
-					done = 1;
-					break;
-				}
-			} else
-				pg_offset = PAGE_CACHE_SIZE;
-
-			if (page->index == tindex && trylock_page(page)) {
-				pg_len = xfs_probe_page(page, pg_offset);
-				unlock_page(page);
-			}
-
-			if (!pg_len) {
-				done = 1;
-				break;
-			}
-
-			total += pg_len;
-			tindex++;
-		}
-
-		pagevec_release(&pvec);
-		cond_resched();
-	}
-
-	return total;
-}
-
-/*
  * Test if a given page is suitable for writing as part of an unwritten
  * or delayed allocate extent.
  */
@@ -1073,7 +971,7 @@ xfs_vm_writepage(
 	unsigned int		type;
 	__uint64_t              end_offset;
 	pgoff_t                 end_index, last_index;
-	ssize_t			size, len;
+	ssize_t			len;
 	int			err, imap_valid = 0, uptodate = 1;
 	int			count = 0;
 	int			all_bh = 0;
@@ -1178,7 +1076,7 @@ xfs_vm_writepage(
 				 * for unwritten extent conversion.
 				 */
 				new_ioend = 1;
-				err = xfs_map_blocks(inode, offset, len, &imap,
+				err = xfs_map_blocks(inode, offset, &imap,
 						     type, nonblocking);
 				if (err)
 					goto error;
@@ -1203,8 +1101,7 @@ xfs_vm_writepage(
 			}
 			if (!imap_valid) {
 				new_ioend = 1;
-				size = xfs_probe_cluster(inode, page, bh, head);
-				err = xfs_map_blocks(inode, offset, size,
+				err = xfs_map_blocks(inode, offset,
 						&imap, type, nonblocking);
 				if (err)
 					goto error;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
