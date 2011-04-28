Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3SD1gRt005344 for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 08:01:42 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3A65F41C46D
	for <xfs@oss.sgi.com>; Thu, 28 Apr 2011 06:05:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id JWNgnuaVM8lWe3TB for
	<xfs@oss.sgi.com>; Thu, 28 Apr 2011 06:05:16 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1QFQuA-0003O2-5w
	for xfs@oss.sgi.com; Thu, 28 Apr 2011 13:05:14 +0000
Message-Id: <20110428130514.146517168@bombadil.infradead.org>
Date: Thu, 28 Apr 2011 08:55:47 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/4] xfs: PF_FSTRANS should never be set in ->writepage
References: <20110428125546.696493391@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-writepage-simplify-fstrans-check
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

Now that we reject direct reclaim in addition to always using GFP_NOFS
allocation there's no chance we'll ever end up in ->writepage with
PF_FSTRANS set.  Add a WARN_ON if we hit this case, and stop checking
if we'd actually need to start a transaction.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_aops.c	2011-04-27 20:51:57.503817127 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_aops.c	2011-04-27 20:53:02.186800044 +0200
@@ -906,7 +906,6 @@ xfs_vm_writepage(
 	struct writeback_control *wbc)
 {
 	struct inode		*inode = page->mapping->host;
-	int			delalloc, unwritten;
 	struct buffer_head	*bh, *head;
 	struct xfs_bmbt_irec	imap;
 	xfs_ioend_t		*ioend = NULL, *iohead = NULL;
@@ -938,15 +937,10 @@ xfs_vm_writepage(
 		goto redirty;
 
 	/*
-	 * We need a transaction if there are delalloc or unwritten buffers
-	 * on the page.
-	 *
-	 * If we need a transaction and the process flags say we are already
-	 * in a transaction, or no IO is allowed then mark the page dirty
-	 * again and leave the page as is.
+	 * Given that we do not allow direct reclaim to call us we should
+	 * never be called while in a filesystem transaction.
 	 */
-	xfs_count_page_state(page, &delalloc, &unwritten);
-	if ((current->flags & PF_FSTRANS) && (delalloc || unwritten))
+	if (WARN_ON(current->flags & PF_FSTRANS))
 		goto redirty;
 
 	/* Is this page beyond the end of the file? */

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
