Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6IMGqnR176610 for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 17:16:55 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6F8A4363AC4
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 15:17:34 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KIZJ9pFIjxfNYmG9 for
	<xfs@oss.sgi.com>; Sat, 18 Jul 2009 15:17:34 -0700 (PDT)
Message-Id: <20090718221733.879984000@bombadil.infradead.org>
Date: Sat, 18 Jul 2009 18:14:59 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 7/9] xfs: switch to NOFS allocation under i_lock in
	xfs_attr_rmtval_set
References: <20090718221452.594956000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-lockdep-buf-2
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

xfs_attr_rmtval_set is always called with i_lock held, and i_lock is taken
in reclaim context so all allocations under it must avoid recursions into
the filesystem.

Reported by the new reclaim context tracing in lockdep.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_attr.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_attr.c	2009-07-18 18:49:20.129533080 +0200
+++ linux-2.6/fs/xfs/xfs_attr.c	2009-07-18 18:50:01.713535041 +0200
@@ -2141,8 +2141,8 @@ xfs_attr_rmtval_set(xfs_da_args_t *args)
 		dblkno = XFS_FSB_TO_DADDR(mp, map.br_startblock),
 		blkcnt = XFS_FSB_TO_BB(mp, map.br_blockcount);
 
-		bp = xfs_buf_get_flags(mp->m_ddev_targp, dblkno,
-							blkcnt, XFS_BUF_LOCK);
+		bp = xfs_buf_get_flags(mp->m_ddev_targp, dblkno, blkcnt,
+				       XFS_BUF_LOCK | XBF_DONT_BLOCK);
 		ASSERT(bp);
 		ASSERT(!XFS_BUF_GETERROR(bp));
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
