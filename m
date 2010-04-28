Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3SCUMhl233084 for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 07:30:22 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C25112F9892
	for <xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:16 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id SNcDw8VbJ4YuUwwD for
	<xfs@oss.sgi.com>; Wed, 28 Apr 2010 05:30:16 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1O76PA-0000qt-Dv
	for xfs@oss.sgi.com; Wed, 28 Apr 2010 12:30:16 +0000
Message-Id: <20100428123016.305118675@bombadil.infradead.org>
Date: Wed, 28 Apr 2010 08:29:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 10/11] xfs: clean up end index calculation in
	xfs_page_state_convert
References: <20100428122850.075189557@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iomap-cleanup-11
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

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_aops.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_aops.c	2010-04-28 12:59:52.857024355 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_aops.c	2010-04-28 12:59:54.989003542 +0200
@@ -1064,7 +1064,7 @@ xfs_page_state_convert(
 	unsigned long           p_offset = 0;
 	unsigned int		type;
 	__uint64_t              end_offset;
-	pgoff_t                 end_index, last_index, tlast;
+	pgoff_t                 end_index, last_index;
 	ssize_t			size, len;
 	int			flags, err, imap_valid = 0, uptodate = 1;
 	int			page_dirty, count = 0;
@@ -1259,15 +1259,22 @@ xfs_page_state_convert(
 		xfs_start_page_writeback(page, 1, count);
 
 	if (ioend && imap_valid) {
-		struct xfs_mount	*m = XFS_I(inode)->i_mount;
-		xfs_off_t		iomap_offset = XFS_FSB_TO_B(m, imap.br_startoff);
-		xfs_off_t		iomap_bsize = XFS_FSB_TO_B(m, imap.br_blockcount);
-
-		offset = (iomap_offset + iomap_bsize - 1) >>
-					PAGE_CACHE_SHIFT;
-		tlast = min_t(pgoff_t, offset, last_index);
+		xfs_off_t		end_index;
+
+		end_index = imap.br_startoff + imap.br_blockcount;
+
+		/* to bytes */
+		end_index <<= inode->i_blkbits;
+
+		/* to pages */
+		end_index = (end_index - 1) >> PAGE_CACHE_SHIFT;
+
+		/* check against file size */
+		if (end_index > last_index)
+			end_index = last_index;
+
 		xfs_cluster_write(inode, page->index + 1, &imap, &ioend,
-					wbc, startio, all_bh, tlast);
+					wbc, startio, all_bh, end_index);
 	}
 
 	if (iohead)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
