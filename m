Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n1K8r121164771 for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 02:53:02 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0F93A1383A3
	for <xfs@oss.sgi.com>; Fri, 20 Feb 2009 00:52:29 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id GwVuuMYaMn37xFqD for
	<xfs@oss.sgi.com>; Fri, 20 Feb 2009 00:52:29 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1LaR7V-00040O-2c
	for xfs@oss.sgi.com; Fri, 20 Feb 2009 08:52:29 +0000
Message-Id: <20090220085228.896448000@bombadil.infradead.org>
Date: Fri, 20 Feb 2009 03:52:09 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/7] xfs: remove another leftover of the old inode log item
	format
References: <20090220085207.663702000@bombadil.infradead.org>
Content-Disposition: inline;
	filename=xfs-kill-xlog_recover_do_inode_trans-special-case
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

There's another little snipplet of code left from the handling of the old
inode log item format in xlog_recover_do_inode_trans.  Kill it as it
can't be reached anymore.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_log_recover.c
===================================================================
--- xfs.orig/fs/xfs/xfs_log_recover.c	2009-02-15 19:55:53.424104583 +0100
+++ xfs/fs/xfs/xfs_log_recover.c	2009-02-15 19:56:17.286945615 +0100
@@ -2519,16 +2519,10 @@ xlog_recover_do_inode_trans(
 	}
 
 write_inode_buffer:
-	if (ITEM_TYPE(item) == XFS_LI_INODE) {
-		ASSERT(bp->b_mount == NULL || bp->b_mount == mp);
-		bp->b_mount = mp;
-		XFS_BUF_SET_IODONE_FUNC(bp, xlog_recover_iodone);
-		xfs_bdwrite(mp, bp);
-	} else {
-		XFS_BUF_STALE(bp);
-		error = xfs_bwrite(mp, bp);
-	}
-
+	ASSERT(bp->b_mount == NULL || bp->b_mount == mp);
+	bp->b_mount = mp;
+	XFS_BUF_SET_IODONE_FUNC(bp, xlog_recover_iodone);
+	xfs_bdwrite(mp, bp);
 error:
 	if (need_free)
 		kmem_free(in_f);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
