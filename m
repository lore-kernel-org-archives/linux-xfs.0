Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9AGrS3m189838 for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 11:53:28 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CEC6016BAE3C
	for <xfs@oss.sgi.com>; Mon, 10 Oct 2011 10:00:38 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	apOeUaC6FL3DK3Z7 for <xfs@oss.sgi.com>;
	Mon, 10 Oct 2011 10:00:38 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RDJ6U-0008Dl-QH
	for xfs@oss.sgi.com; Mon, 10 Oct 2011 16:53:26 +0000
Message-Id: <20111010165326.771579338@bombadil.infradead.org>
Date: Mon, 10 Oct 2011 12:52:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/11] xfs: remove XFS_BUF_FINISH_IOWAIT
References: <20111010165242.656850411@bombadil.infradead.org>
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
Reviewed-by: Alex Elder <aelder@sgi.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>

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
