Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3SD1fUF005323 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 08:01:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 271E641C46C
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 06:05:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vNll0wPYuI6lgNda for
	<xfs@oss.sgi.com>; Thu, 28 Apr 2011 06:05:15 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QFQuA-0003Pb-O8
	for xfs@oss.sgi.com; Thu, 28 Apr 2011 13:05:14 +0000
Message-Id: <20110428130514.716332376@bombadil.infradead.org>
Date: Thu, 28 Apr 2011 08:55:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 4/4] xfs: cleanup xfs_add_to_ioend
References: <20110428125546.696493391@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-cleanup-xfs_add_to_ioend
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

Pass the writeback context to xfs_add_to_ioend to make the ioend
chain manipulations self-contained in this function.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2011-04-28 11:22:42.747447011 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2011-04-28 11:22:46.124095385 +0200
@@ -560,39 +560,39 @@ xfs_cancel_ioend(
 }
 
 /*
- * Test to see if we've been building up a completion structure for
- * earlier buffers -- if so, we try to append to this ioend if we
- * can, otherwise we finish off any current ioend and start another.
- * Return true if we've finished the given ioend.
+ * Test to see if we've been building up a completion structure for earlier
+ * buffers -- if so, we try to append to this ioend if we can, otherwise we
+ * finish off any current ioend and start another.
  */
 STATIC void
 xfs_add_to_ioend(
+	struct xfs_writeback_ctx *ctx,
 	struct inode		*inode,
 	struct buffer_head	*bh,
 	xfs_off_t		offset,
 	unsigned int		type,
-	xfs_ioend_t		**result,
 	int			need_ioend)
 {
-	xfs_ioend_t		*ioend = *result;
+	if (!ctx->ioend || need_ioend || type != ctx->ioend->io_type) {
+		struct xfs_ioend	*new;
 
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
+		new = xfs_alloc_ioend(inode, type);
+		new->io_offset = offset;
+		new->io_buffer_head = bh;
+		new->io_buffer_tail = bh;
+
+		if (ctx->ioend)
+			ctx->ioend->io_list = new;
+		ctx->ioend = new;
+		if (!ctx->iohead)
+			ctx->iohead = new;
 	} else {
-		ioend->io_buffer_tail->b_private = bh;
-		ioend->io_buffer_tail = bh;
+		ctx->ioend->io_buffer_tail->b_private = bh;
+		ctx->ioend->io_buffer_tail = bh;
 	}
 
 	bh->b_private = NULL;
-	ioend->io_size += bh->b_size;
+	ctx->ioend->io_size += bh->b_size;
 }
 
 STATIC void
@@ -874,14 +874,9 @@ __xfs_vm_writepage(
 				xfs_map_at_offset(inode, bh, &ctx->imap,
 						  offset);
 			}
-			xfs_add_to_ioend(inode, bh, offset, type, &ctx->ioend,
-					 new_ioend);
+			xfs_add_to_ioend(ctx, inode, bh, offset, type, new_ioend);
 			count++;
 		}
-
-		if (!ctx->iohead)
-			ctx->iohead = ctx->ioend;
-
 	} while (offset += len, ((bh = bh->b_this_page) != head));
 
 	if (uptodate && bh == head)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
