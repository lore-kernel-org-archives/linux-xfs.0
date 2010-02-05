Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o159uiST127034 for <xfs@oss.sgi.com>; Fri, 5 Feb 2010 03:56:45 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AD00C1B224D
	for <xfs@oss.sgi.com>; Fri,  5 Feb 2010 01:57:55 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id DVpoBOpPdQmnqH4W for
	<xfs@oss.sgi.com>; Fri, 05 Feb 2010 01:57:55 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1NdKwl-00083S-Cj
	for xfs@oss.sgi.com; Fri, 05 Feb 2010 09:57:55 +0000
Date: Fri, 5 Feb 2010 04:57:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: optimize log flushing in xfs_fsync
Message-ID: <20100205095755.GA30848@infradead.org>
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


If we have a pinned inode it must have a log item attached to it.
Usually that log item will have ili_last_lsn already set, in which
case we only need to flush the log up to that LSN instead of doing
a full log force.  This gives speedups of about 5% in some fsync
heavy workloads.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2010-02-04 17:38:33.679254119 +0100
+++ xfs/fs/xfs/xfs_vnodeops.c	2010-02-04 17:38:51.606006156 +0100
@@ -626,8 +626,14 @@ xfs_fsync(
 		 * force the log.
 		 */
 		if (xfs_ipincount(ip)) {
-			error = _xfs_log_force(ip->i_mount, XFS_LOG_SYNC,
-					       &log_flushed);
+			if (ip->i_itemp->ili_last_lsn) {
+				error = _xfs_log_force_lsn(ip->i_mount,
+						ip->i_itemp->ili_last_lsn,
+						XFS_LOG_SYNC, &log_flushed);
+			} else {
+				error = _xfs_log_force(ip->i_mount,
+						XFS_LOG_SYNC, &log_flushed);
+			}
 		}
 	} else	{
 		/*

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
