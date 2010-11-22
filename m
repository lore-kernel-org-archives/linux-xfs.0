Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oAMD7RB4228614 for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 07:07:27 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 060AE19915D
	for <xfs@oss.sgi.com>; Mon, 22 Nov 2010 05:09:04 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id A9R5ZnDD2pyhNHoW for
	<xfs@oss.sgi.com>; Mon, 22 Nov 2010 05:09:04 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PKW8m-0005gA-Io
	for xfs@oss.sgi.com; Mon, 22 Nov 2010 13:09:04 +0000
Message-Id: <20101122130904.551028056@bombadil.infradead.org>
Date: Mon, 22 Nov 2010 08:05:14 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 08/10] xfs: remove the all_bh flag from xfs_convert_page
References: <20101122130506.868076797@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-all-bh
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

The all_bh flag is always set when entering the page clustering machinery
with a regular written extent, which means the check for it is superflous.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-11-19 15:07:33.000000000 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-11-19 15:07:59.221005096 +0100
@@ -682,8 +682,7 @@ xfs_convert_page(
 	loff_t			tindex,
 	struct xfs_bmbt_irec	*imap,
 	xfs_ioend_t		**ioendp,
-	struct writeback_control *wbc,
-	int			all_bh)
+	struct writeback_control *wbc)
 {
 	struct buffer_head	*bh, *head;
 	xfs_off_t		end_offset;
@@ -738,11 +737,14 @@ xfs_convert_page(
 			continue;
 		}
 
-		if (buffer_unwritten(bh) || buffer_delay(bh)) {
+		if (buffer_unwritten(bh) || buffer_delay(bh) ||
+		    buffer_mapped(bh)) {
 			if (buffer_unwritten(bh))
 				type = IO_UNWRITTEN;
-			else
+			else if (buffer_delay(bh))
 				type = IO_DELALLOC;
+			else
+				type = IO_OVERWRITE;
 
 			if (!xfs_imap_valid(inode, imap, offset)) {
 				done = 1;
@@ -752,23 +754,17 @@ xfs_convert_page(
 			ASSERT(imap->br_startblock != HOLESTARTBLOCK);
 			ASSERT(imap->br_startblock != DELAYSTARTBLOCK);
 
-			xfs_map_at_offset(inode, bh, imap, offset);
+			if (type == IO_OVERWRITE)
+				lock_buffer(bh);
+			else
+				xfs_map_at_offset(inode, bh, imap, offset);
 			xfs_add_to_ioend(inode, bh, offset, type,
 					 ioendp, done);
 
 			page_dirty--;
 			count++;
 		} else {
-			type = IO_OVERWRITE;
-			if (buffer_mapped(bh) && all_bh) {
-				lock_buffer(bh);
-				xfs_add_to_ioend(inode, bh, offset,
-						type, ioendp, done);
-				count++;
-				page_dirty--;
-			} else {
-				done = 1;
-			}
+			done = 1;
 		}
 	} while (offset += len, (bh = bh->b_this_page) != head);
 
@@ -800,7 +796,6 @@ xfs_cluster_write(
 	struct xfs_bmbt_irec	*imap,
 	xfs_ioend_t		**ioendp,
 	struct writeback_control *wbc,
-	int			all_bh,
 	pgoff_t			tlast)
 {
 	struct pagevec		pvec;
@@ -815,7 +810,7 @@ xfs_cluster_write(
 
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			done = xfs_convert_page(inode, pvec.pages[i], tindex++,
-					imap, ioendp, wbc, all_bh);
+					imap, ioendp, wbc);
 			if (done)
 				break;
 		}
@@ -974,7 +969,6 @@ xfs_vm_writepage(
 	ssize_t			len;
 	int			err, imap_valid = 0, uptodate = 1;
 	int			count = 0;
-	int			all_bh = 0;
 	int			nonblocking = 0;
 
 	trace_xfs_writepage(inode, page, 0);
@@ -1110,7 +1104,6 @@ xfs_vm_writepage(
 			}
 
 			if (imap_valid) {
-				all_bh = 1;
 				lock_buffer(bh);
 				xfs_add_to_ioend(inode, bh, offset, type,
 						&ioend, new_ioend);
@@ -1147,7 +1140,7 @@ xfs_vm_writepage(
 			end_index = last_index;
 
 		xfs_cluster_write(inode, page->index + 1, &imap, &ioend,
-					wbc, all_bh, end_index);
+				  wbc, end_index);
 	}
 
 	if (iohead)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
