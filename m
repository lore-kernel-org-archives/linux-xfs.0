Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o7N99gAs122875 for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 04:09:43 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1534C16444
	for <xfs@oss.sgi.com>; Mon, 23 Aug 2010 02:10:15 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id jMeRNlF6e4sDOSZK for
	<xfs@oss.sgi.com>; Mon, 23 Aug 2010 02:10:15 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OnT2l-0001pX-Ku
	for xfs@oss.sgi.com; Mon, 23 Aug 2010 09:10:15 +0000
Date: Mon, 23 Aug 2010 05:10:15 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: do not discard page cache data on EAGAIN
Message-ID: <20100823091015.GA2829@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

If xfs_map_blocks returns EAGAIN because of lock contention we must redirty
the page and not disard the pagecache content and return an error from
writepage.  We used to do this correctly, but the logic got lost during
the recent reshuffle of the writepage code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Mike Gao <ygao.linux@gmail.com> 
Tested-by: Mike Gao <ygao.linux@gmail.com> 

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-08-18 18:10:48.140261091 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-08-18 18:12:41.167005888 +0200
@@ -1068,7 +1068,7 @@ xfs_vm_writepage(
 	 * by themselves.
 	 */
 	if ((current->flags & (PF_MEMALLOC|PF_KSWAPD)) == PF_MEMALLOC)
-		goto out_fail;
+		goto redirty;
 
 	/*
 	 * We need a transaction if there are delalloc or unwritten buffers
@@ -1080,7 +1080,7 @@ xfs_vm_writepage(
 	 */
 	xfs_count_page_state(page, &delalloc, &unwritten);
 	if ((current->flags & PF_FSTRANS) && (delalloc || unwritten))
-		goto out_fail;
+		goto redirty;
 
 	/* Is this page beyond the end of the file? */
 	offset = i_size_read(inode);
@@ -1245,12 +1245,15 @@ error:
 	if (iohead)
 		xfs_cancel_ioend(iohead);
 
+	if (err == -EAGAIN)
+		goto redirty;
+
 	xfs_aops_discard_page(page);
 	ClearPageUptodate(page);
 	unlock_page(page);
 	return err;
 
-out_fail:
+redirty:
 	redirty_page_for_writepage(wbc, page);
 	unlock_page(page);
 	return 0;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
