Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6IMGtOj176617 for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 17:16:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A0084137E095
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 15:17:34 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 8pCQs5n8vHHD0dgm for
	<xfs@oss.sgi.com>; Sat, 18 Jul 2009 15:17:34 -0700 (PDT)
Message-Id: <20090718221734.102783000@bombadil.infradead.org>
Date: Sat, 18 Jul 2009 18:15:00 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 8/9] xfs: switch to NOFS allocation under i_lock in
	xfs_readlink_bmap
References: <20090718221452.594956000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-lockdep-buf-3
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
Cc: sage@newdream.net

xfs_readlink_bmap is called with i_lock held, but i_lock is taken in
reclaim context so all allocations under it must avoid recursions into
the filesystem.  

Reported by the new reclaim context tracing in lockdep.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_vnodeops.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_vnodeops.c	2009-07-18 20:29:59.041657600 +0200
+++ linux-2.6/fs/xfs/xfs_vnodeops.c	2009-07-18 20:31:22.964535322 +0200
@@ -547,7 +547,9 @@ xfs_readlink_bmap(
 		d = XFS_FSB_TO_DADDR(mp, mval[n].br_startblock);
 		byte_cnt = XFS_FSB_TO_B(mp, mval[n].br_blockcount);
 
-		bp = xfs_buf_read(mp->m_ddev_targp, d, BTOBB(byte_cnt), 0);
+		bp = xfs_buf_read_flags(mp->m_ddev_targp, d, BTOBB(byte_cnt),
+					XBF_LOCK | XBF_MAPPED |
+					XBF_DONT_BLOCK);
 		error = XFS_BUF_GETERROR(bp);
 		if (error) {
 			xfs_ioerror_alert("xfs_readlink",

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
