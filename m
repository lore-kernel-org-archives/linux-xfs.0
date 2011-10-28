Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3icV145553 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C72D820386D
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:43 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	h4WMWyH4g9HMRz17 for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:43 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHr-0003D7-Ax
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:43 +0000
Message-Id: <20111028100343.299490670@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:55:06 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 43/45] xfs: do not try to unpin the inode buffer in xfs_iflush
References: <20111028095423.796574703@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-iflush-dont-force-log
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

Instead of trying to unpin a pinned inode buffer by forcing the log in
xfs_iflush let the caller handle it.  In case of AIL pushing we already
handle it more efficiently by forcing the log synchronously once after
cycling through all AIL entries.

Signed-off-by: Christoph Hellwig <hch@lst.de>

---
 fs/xfs/xfs_inode.c |    7 -------
 fs/xfs/xfs_sync.c  |    7 +++++++
 2 files changed, 7 insertions(+), 7 deletions(-)

Index: xfs/fs/xfs/xfs_inode.c
===================================================================
--- xfs.orig/fs/xfs/xfs_inode.c	2011-10-27 22:40:16.244688077 +0200
+++ xfs/fs/xfs/xfs_inode.c	2011-10-27 22:40:16.821171772 +0200
@@ -2468,13 +2468,6 @@ xfs_iflush(
 		goto corrupt_out;
 
 	/*
-	 * If the buffer is pinned then push on the log now so we won't
-	 * get stuck waiting in the write for too long.
-	 */
-	if (xfs_buf_ispinned(bp))
-		xfs_log_force(mp, 0);
-
-	/*
 	 * inode clustering:
 	 * see if other inodes can be gathered into this write
 	 */
Index: xfs/fs/xfs/xfs_sync.c
===================================================================
--- xfs.orig/fs/xfs/xfs_sync.c	2011-10-27 22:40:16.257172598 +0200
+++ xfs/fs/xfs/xfs_sync.c	2011-10-27 22:40:16.821171772 +0200
@@ -724,6 +724,13 @@ restart:
 		delay(2);
 		goto restart;
 	} else if (!error) {
+		/*
+		 * If the buffer is pinned then push on the log now so we
+		 * won't get stuck waiting in the write for too long.
+		 */
+		if (xfs_buf_ispinned(bp))
+			xfs_log_force(ip->i_mount, 0);
+
 		error = xfs_bwrite(bp);
 		xfs_buf_relse(bp);
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
