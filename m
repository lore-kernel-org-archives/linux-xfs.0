Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4AHQ2wq017571 for <xfs@oss.sgi.com>; Mon, 10 May 2010 12:26:03 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BAB491288756
	for <xfs@oss.sgi.com>; Mon, 10 May 2010 10:28:34 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id HWzYXUSziNLqnQBe for
	<xfs@oss.sgi.com>; Mon, 10 May 2010 10:28:34 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1OBWm6-0001K9-4L
	for xfs@oss.sgi.com; Mon, 10 May 2010 17:28:14 +0000
Date: Mon, 10 May 2010 13:28:14 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: clean up xlog_align
Message-ID: <20100510172814.GB14991@infradead.org>
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

Add suggested cleanups to commit 29db3370a1369541d58d692fbfb168b8a0bd7f41
from review that didn't end up being commited.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2010-05-10 19:12:01.539262194 +0200
+++ xfs/fs/xfs/xfs_log_recover.c	2010-05-10 19:14:52.295255420 +0200
@@ -132,15 +132,10 @@ xlog_align(
 	int		nbblks,
 	xfs_buf_t	*bp)
 {
-	xfs_daddr_t	offset;
-	xfs_caddr_t	ptr;
+	xfs_daddr_t	offset = blk_no & ((xfs_daddr_t)log->l_sectBBsize - 1);
 
-	offset = blk_no & ((xfs_daddr_t) log->l_sectBBsize - 1);
-	ptr = XFS_BUF_PTR(bp) + BBTOB(offset);
-
-	ASSERT(ptr + BBTOB(nbblks) <= XFS_BUF_PTR(bp) + XFS_BUF_SIZE(bp));
-
-	return ptr;
+	ASSERT(BBTOB(offset + nbblks) <= XFS_BUF_SIZE(bp));
+	return XFS_BUF_PTR(bp) + BBTOB(offset);
 }
 
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
