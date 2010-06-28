Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5SEVnXu029700 for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 09:31:49 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B3F051558AF4
	for <xfs@oss.sgi.com>; Mon, 28 Jun 2010 07:34:34 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id Y5gNXvQO8VrJxuYc for
	<xfs@oss.sgi.com>; Mon, 28 Jun 2010 07:34:34 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OTFPu-0001SJ-Ah
	for xfs@oss.sgi.com; Mon, 28 Jun 2010 14:34:34 +0000
Date: Mon, 28 Jun 2010 10:34:34 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: remove incorrect log write optimization
Message-ID: <20100628143434.GA5473@infradead.org>
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

We do need a barrier for the first buffer of a split log write.  Otherwise
we might incorrectly stamp the tail LSN into transactions in the first
block, or not flush data I/O before updating the inode size.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs-dev/fs/xfs/xfs_log.c
===================================================================
--- xfs-dev.orig/fs/xfs/xfs_log.c	2010-06-28 11:51:30.423004228 +0200
+++ xfs-dev/fs/xfs/xfs_log.c	2010-06-28 11:52:52.559255519 +0200
@@ -1423,11 +1423,8 @@ xlog_sync(xlog_t		*log,
 	XFS_BUF_BUSY(bp);
 	XFS_BUF_ASYNC(bp);
 	bp->b_flags |= XBF_LOG_BUFFER;
-	/*
-	 * Do an ordered write for the log block.
-	 * Its unnecessary to flush the first split block in the log wrap case.
-	 */
-	if (!split && (log->l_mp->m_flags & XFS_MOUNT_BARRIER))
+
+	if (log->l_mp->m_flags & XFS_MOUNT_BARRIER)
 		XFS_BUF_ORDERED(bp);
 
 	ASSERT(XFS_BUF_ADDR(bp) <= log->l_logBBsize-1);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
