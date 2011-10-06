Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p96L6eYn201648 for <xfs@oss.sgi.com>; Thu, 6 Oct 2011 16:06:41 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 9577A14518F3
	for <xfs@oss.sgi.com>; Thu,  6 Oct 2011 14:13:29 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	OsSwT7lVyPLAqKgV for <xfs@oss.sgi.com>;
	Thu, 06 Oct 2011 14:13:29 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RBv9K-0004Cw-Q8
	for xfs@oss.sgi.com; Thu, 06 Oct 2011 21:06:38 +0000
Message-Id: <20111006210638.768207092@bombadil.infradead.org>
Date: Thu, 06 Oct 2011 17:06:09 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/9] xfs: remove XFS_BUF_FINISH_IOWAIT
References: <20111006210607.175284390@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-kill-XFS_BUF_FINISH_IOWAIT
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

Index: xfs/fs/xfs/xfs_buf.c
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.c	2011-10-02 14:06:02.936771751 +0200
+++ xfs/fs/xfs/xfs_buf.c	2011-10-02 14:06:08.028771236 +0200
@@ -1100,7 +1100,7 @@ xfs_bioerror_relse(
 		 * ASYNC buffers.
 		 */
 		xfs_buf_ioerror(bp, EIO);
-		XFS_BUF_FINISH_IOWAIT(bp);
+		complete(&bp->b_iowait);
 	} else {
 		xfs_buf_relse(bp);
 	}
Index: xfs/fs/xfs/xfs_buf.h
===================================================================
--- xfs.orig/fs/xfs/xfs_buf.h	2011-10-02 14:06:02.936771751 +0200
+++ xfs/fs/xfs/xfs_buf.h	2011-10-02 14:06:08.028771236 +0200
@@ -293,8 +293,6 @@ static inline int xfs_buf_ispinned(struc
 	return atomic_read(&bp->b_pin_count);
 }
 
-#define XFS_BUF_FINISH_IOWAIT(bp)	complete(&bp->b_iowait);
-
 static inline void xfs_buf_relse(xfs_buf_t *bp)
 {
 	xfs_buf_unlock(bp);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
