Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6IMGqQw176608 for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 17:16:54 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 51EE4363AC2
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 15:17:34 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id IvJNhdcPHfHCpAHH for
	<xfs@oss.sgi.com>; Sat, 18 Jul 2009 15:17:34 -0700 (PDT)
Message-Id: <20090718221733.640848000@bombadil.infradead.org>
Date: Sat, 18 Jul 2009 18:14:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 6/9] xfs: switch to NOFS allocation under i_lock in
	xfs_buf_associate_memory
References: <20090718221452.594956000@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-lockdep-buf
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

xfs_buf_associate_memory is used for setting up the spare buffer for the
log wrap case in xlog_sync which can happen under i_lock when called from
xfs_fsync. The i_lock mutex is taken in reclaim context so all allocations
under it must avoid recursions into the filesystem.  There are a couple
more uses of xfs_buf_associate_memory in the log recovery code that are
also affected by this, but I'd rather keep the code simple than passing on
a gfp_mask argument.  Longer term we should just stop requiring the memoery
allocation in xlog_sync by some smaller rework of the buffer layer.

Reported by the new reclaim context tracing in lockdep.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/linux-2.6/xfs_buf.c
===================================================================
--- linux-2.6.orig/fs/xfs/linux-2.6/xfs_buf.c	2009-07-18 18:26:07.359681952 +0200
+++ linux-2.6/fs/xfs/linux-2.6/xfs_buf.c	2009-07-18 18:26:53.531658254 +0200
@@ -770,7 +770,7 @@ xfs_buf_associate_memory(
 	bp->b_pages = NULL;
 	bp->b_addr = mem;
 
-	rval = _xfs_buf_get_pages(bp, page_count, 0);
+	rval = _xfs_buf_get_pages(bp, page_count, XBF_DONT_BLOCK);
 	if (rval)
 		return rval;
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
