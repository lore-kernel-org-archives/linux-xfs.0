Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p7R5vwiW179149 for <xfs@oss.sgi.com>; Sat, 27 Aug 2011 00:57:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0FE6313A67A0
	for <xfs@oss.sgi.com>; Fri, 26 Aug 2011 23:00:58 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	xYgGFT0bbpNELPLF for <xfs@oss.sgi.com>;
	Fri, 26 Aug 2011 23:00:58 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1QxBtz-0007Ng-Tf
	for xfs@oss.sgi.com; Sat, 27 Aug 2011 05:57:55 +0000
Date: Sat, 27 Aug 2011 01:57:55 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/2] xfs: fix ->write_inode return values
Message-ID: <20110827055755.GB28351@infradead.org>
References: <20110827055731.GA24159@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20110827055731.GA24159@infradead.org>
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

Currently we always redirty an inode that was attempted to be written out
synchronously but has been cleaned by an AIL pushed internall, which is
rather bogus.  Fix that by doing the i_update_core check early on and
return 0 for it.  Also include async calls for it, as doing any work for
those is just as pointless.  While we're at it also fix the sign for the
EIO return in case of a filesystem shutdown, and fix the completely
non-sensical locking around xfs_log_inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/xfs/xfs_super.c
===================================================================
--- linux-2.6.orig/fs/xfs/xfs_super.c	2011-08-26 14:47:54.320317391 +0200
+++ linux-2.6/fs/xfs/xfs_super.c	2011-08-26 14:51:46.095728421 +0200
@@ -877,33 +877,17 @@ xfs_log_inode(
 	struct xfs_trans	*tp;
 	int			error;
 
-	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	tp = xfs_trans_alloc(mp, XFS_TRANS_FSYNC_TS);
 	error = xfs_trans_reserve(tp, 0, XFS_FSYNC_TS_LOG_RES(mp), 0, 0, 0);
-
 	if (error) {
 		xfs_trans_cancel(tp, 0);
-		/* we need to return with the lock hold shared */
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
 		return error;
 	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-	/*
-	 * Note - it's possible that we might have pushed ourselves out of the
-	 * way during trans_reserve which would flush the inode.  But there's
-	 * no guarantee that the inode buffer has actually gone out yet (it's
-	 * delwri).  Plus the buffer could be pinned anyway if it's part of
-	 * an inode in another recent transaction.  So we play it safe and
-	 * fire off the transaction anyway.
-	 */
-	xfs_trans_ijoin(tp, ip);
+	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	error = xfs_trans_commit(tp, 0);
-	xfs_ilock_demote(ip, XFS_ILOCK_EXCL);
-
-	return error;
+	return xfs_trans_commit(tp, 0);
 }
 
 STATIC int
@@ -918,7 +902,9 @@ xfs_fs_write_inode(
 	trace_xfs_write_inode(ip);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
-		return XFS_ERROR(EIO);
+		return -XFS_ERROR(EIO);
+	if (!ip->i_update_core)
+		return 0;
 
 	if (wbc->sync_mode == WB_SYNC_ALL) {
 		/*
@@ -929,12 +915,10 @@ xfs_fs_write_inode(
 		 * of synchronous log foces dramatically.
 		 */
 		xfs_ioend_wait(ip);
-		xfs_ilock(ip, XFS_ILOCK_SHARED);
-		if (ip->i_update_core) {
-			error = xfs_log_inode(ip);
-			if (error)
-				goto out_unlock;
-		}
+		error = xfs_log_inode(ip);
+		if (error)
+			goto out;
+		return 0;
 	} else {
 		/*
 		 * We make this non-blocking if the inode is contended, return

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
