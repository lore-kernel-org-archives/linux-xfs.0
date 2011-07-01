Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p619k3rV055978 for <xfs@oss.sgi.com>; Fri, 1 Jul 2011 04:46:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1E8B016748BA
	for <xfs@oss.sgi.com>; Fri,  1 Jul 2011 02:46:02 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	QgEY7CYDxDVxrXc7 for <xfs@oss.sgi.com>;
	Fri, 01 Jul 2011 02:46:02 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QcaIU-0001pr-AD
	for xfs@oss.sgi.com; Fri, 01 Jul 2011 09:46:02 +0000
Message-Id: <20110701094602.285184989@bombadil.infradead.org>
Date: Fri, 01 Jul 2011 05:43:22 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/27] xfs: PF_FSTRANS should never be set in ->writepage
References: <20110701094321.936534538@bombadil.infradead.org>
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
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2011-06-30 14:50:35.206501640 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2011-06-30 15:34:59.156468543 +0200
@@ -894,11 +894,6 @@ out_invalidate:
  * For unwritten space on the page we need to start the conversion to
  * regular allocated space.
  * For any other dirty buffer heads on the page we should flush them.
- *
- * If we detect that a transaction would be required to flush the page, we
- * have to check the process flags first, if we are already in a transaction
- * or disk I/O during allocations is off, we need to fail the writepage and
- * redirty the page.
  */
 STATIC int
 xfs_vm_writepage(
@@ -906,7 +901,6 @@ xfs_vm_writepage(
 	struct writeback_control *wbc)
 {
 	struct inode		*inode = page->mapping->host;
-	int			delalloc, unwritten;
 	struct buffer_head	*bh, *head;
 	struct xfs_bmbt_irec	imap;
 	xfs_ioend_t		*ioend = NULL, *iohead = NULL;
@@ -938,15 +932,10 @@ xfs_vm_writepage(
 		goto redirty;
 
 	/*
-	 * We need a transaction if there are delalloc or unwritten buffers
-	 * on the page.
-	 *
-	 * If we need a transaction and the process flags say we are already
-	 * in a transaction, or no IO is allowed then mark the page dirty
-	 * again and leave the page as is.
+	 * Given that we do not allow direct reclaim to call us, we should
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
