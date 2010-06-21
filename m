Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o5L8XQ3c113430 for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 03:33:29 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CC5A7267830
	for <xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:36:06 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id idZcUunGjq3EI5EB for
	<xfs@oss.sgi.com>; Mon, 21 Jun 2010 01:36:06 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1OQcUA-0007Xd-G0
	for xfs@oss.sgi.com; Mon, 21 Jun 2010 08:36:06 +0000
Message-Id: <20100621083606.399435078@bombadil.infradead.org>
Date: Mon, 21 Jun 2010 04:35:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 01/12] [PATCH] xfs: avoid synchronous transaction in
	xfs_fs_write_inode
References: <20100621083543.125860679@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-optimize-write_inode
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

We already rely on the fact that the sync code will cause a synchronous
log force later on (currently via xfs_fs_sync_fs -> xfs_quiesce_data ->
xfs_sync_data), so no need to do this here.  This allows us to avoid
a lot of synchronous log forces during sync, which pays of especially
with delayed logging enabled.   Some compilebench numbers that show
this:

xfs (delayed logging, 256k logbufs)
===================================

intial create		  25.94 MB/s	  25.75 MB/s	  25.64 MB/s
create			   8.54 MB/s	   9.12 MB/s	   9.15 MB/s
patch			   2.47 MB/s	   2.47 MB/s	   3.17 MB/s
compile			  29.65 MB/s	  30.51 MB/s	  27.33 MB/s
clean			  90.92 MB/s	  98.83 MB/s	 128.87 MB/s
read tree		  11.90 MB/s	  11.84 MB/s	   8.56 MB/s
read compiled		  28.75 MB/s	  29.96 MB/s	  24.25 MB/s
delete tree		8.39 seconds	8.12 seconds	8.46 seconds
delete compiled		8.35 seconds	8.44 seconds	5.11 seconds
stat tree		6.03 seconds	5.59 seconds	5.19 seconds
stat compiled tree	9.00 seconds	9.52 seconds	8.49 seconds


xfs + write_inode log_force removal
===================================
intial create		  25.87 MB/s	  25.76 MB/s	  25.87 MB/s
create			  15.18 MB/s	  14.80 MB/s	  14.94 MB/s
patch			   3.13 MB/s	   3.14 MB/s	   3.11 MB/s
compile			  36.74 MB/s	  37.17 MB/s	  36.84 MB/s
clean			 226.02 MB/s	 222.58 MB/s	 217.94 MB/s
read tree		  15.14 MB/s	  15.02 MB/s	  15.14 MB/s
read compiled tree	  29.30 MB/s	  29.31 MB/s	  29.32 MB/s
delete tree		6.22 seconds	6.14 seconds	6.15 seconds
delete compiled tree	5.75 seconds	5.92 seconds	5.81 seconds
stat tree		4.60 seconds	4.51 seconds	4.56 seconds
stat compiled tree	4.07 seconds	3.87 seconds	3.96 seconds

In addition to that also remove the delwri inode flush that is unessecary
now that bulkstat is always coherent.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2010-06-21 09:31:43.638254092 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2010-06-21 09:37:01.982255907 +0200
@@ -1025,7 +1025,6 @@ xfs_log_inode(
 	 */
 	xfs_trans_ijoin(tp, ip);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	xfs_trans_set_sync(tp);
 	error = xfs_trans_commit(tp, 0);
 	xfs_ilock_demote(ip, XFS_ILOCK_EXCL);
 
@@ -1048,20 +1047,11 @@ xfs_fs_write_inode(
 
 	if (wbc->sync_mode == WB_SYNC_ALL) {
 		/*
-		 * Make sure the inode has hit stable storage.  By using the
-		 * log and the fsync transactions we reduce the IOs we have
-		 * to do here from two (log and inode) to just the log.
-		 *
-		 * Note: We still need to do a delwri write of the inode after
-		 * this to flush it to the backing buffer so that bulkstat
-		 * works properly if this is the first time the inode has been
-		 * written.  Because we hold the ilock atomically over the
-		 * transaction commit and the inode flush we are guaranteed
-		 * that the inode is not pinned when it returns. If the flush
-		 * lock is already held, then the inode has already been
-		 * flushed once and we don't need to flush it again.  Hence
-		 * the code will only flush the inode if it isn't already
-		 * being flushed.
+		 * Make sure the inode has made it it into the log.  Instead
+		 * of forcing it all the way to stable storage using a
+		 * synchronous transaction we let the log force inside the
+		 * ->sync_fs call do that for thus, which reduces the number
+		 * of synchronous log foces dramatically.
 		 */
 		xfs_ioend_wait(ip);
 		xfs_ilock(ip, XFS_ILOCK_SHARED);
@@ -1075,27 +1065,29 @@ xfs_fs_write_inode(
 		 * We make this non-blocking if the inode is contended, return
 		 * EAGAIN to indicate to the caller that they did not succeed.
 		 * This prevents the flush path from blocking on inodes inside
-		 * another operation right now, they get caught later by xfs_sync.
+		 * another operation right now, they get caught later by
+		 * xfs_sync.
 		 */
 		if (!xfs_ilock_nowait(ip, XFS_ILOCK_SHARED))
 			goto out;
-	}
 
-	if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
-		goto out_unlock;
+		if (xfs_ipincount(ip) || !xfs_iflock_nowait(ip))
+			goto out_unlock;
 
-	/*
-	 * Now we have the flush lock and the inode is not pinned, we can check
-	 * if the inode is really clean as we know that there are no pending
-	 * transaction completions, it is not waiting on the delayed write
-	 * queue and there is no IO in progress.
-	 */
-	if (xfs_inode_clean(ip)) {
-		xfs_ifunlock(ip);
-		error = 0;
-		goto out_unlock;
+		/*
+		 * Now we have the flush lock and the inode is not pinned, we
+		 * can check if the inode is really clean as we know that
+		 * there are no pending transaction completions, it is not
+		 * waiting on the delayed write queue and there is no IO in
+		 * progress.
+		 */
+		if (xfs_inode_clean(ip)) {
+			xfs_ifunlock(ip);
+			error = 0;
+			goto out_unlock;
+		}
+		error = xfs_iflush(ip, 0);
 	}
-	error = xfs_iflush(ip, 0);
 
  out_unlock:
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
