Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1HJXdbZ255379 for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 13:33:40 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 90CF813B4276
	for <xfs@oss.sgi.com>; Wed, 17 Feb 2010 11:34:58 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id XJMhgCj3zlCWsRL8 for
	<xfs@oss.sgi.com>; Wed, 17 Feb 2010 11:34:58 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Nhpfm-0005hF-0L
	for xfs@oss.sgi.com; Wed, 17 Feb 2010 19:34:58 +0000
Date: Wed, 17 Feb 2010 14:34:57 -0500
From: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>
Subject: [PATCH] xfs: fix inode pincount check in fsync
Message-ID: <20100217193457.GA21840@infradead.org>
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

We need to hold the ilock to check the inode pincount safely.  While
we're at it also remove the check for ip->i_itemp->ili_last_lsn, a
pinned inode always has it set.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_file.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_file.c	2010-02-17 10:46:24.440003402 +0100
+++ xfs/fs/xfs/linux-2.6/xfs_file.c	2010-02-17 10:47:25.499028406 +0100
@@ -180,17 +180,12 @@ xfs_file_fsync(
 		 * disk yet, the inode will be still be pinned.  If it is,
 		 * force the log.
 		 */
-		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 		if (xfs_ipincount(ip)) {
-			if (ip->i_itemp->ili_last_lsn) {
-				error = _xfs_log_force_lsn(ip->i_mount,
-						ip->i_itemp->ili_last_lsn,
-						XFS_LOG_SYNC, &log_flushed);
-			} else {
-				error = _xfs_log_force(ip->i_mount,
-						XFS_LOG_SYNC, &log_flushed);
-			}
+			error = _xfs_log_force_lsn(ip->i_mount,
+					ip->i_itemp->ili_last_lsn,
+					XFS_LOG_SYNC, &log_flushed);
 		}
+		xfs_iunlock(ip, XFS_ILOCK_SHARED);
 	}
 
 	if (ip->i_mount->m_flags & XFS_MOUNT_BARRIER) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
