Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKnB0L201700 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:49:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C47F81C23427
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:49:10 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	aegJWc4WWF7D8ouF for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:49:10 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R5OIY-0005xY-3x
	for xfs@oss.sgi.com; Sun, 18 Sep 2011 20:49:10 +0000
Message-Id: <20110918204910.076049421@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:47:50 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 2/3] xfs: unlock the inode before log force in
	xfs_fs_nfs_commit_metadata
References: <20110918204748.547510183@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-optimize-commit_metadata
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

Only read the LSN we need to push to with the ilock held, and then release
it before we do the log force to improve concurrency.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_export.c
===================================================================
--- xfs.orig/fs/xfs/xfs_export.c	2011-09-07 11:08:48.670961391 +0200
+++ xfs/fs/xfs/xfs_export.c	2011-09-07 11:08:56.515960258 +0200
@@ -229,16 +229,16 @@ xfs_fs_nfs_commit_metadata(
 {
 	struct xfs_inode	*ip = XFS_I(inode);
 	struct xfs_mount	*mp = ip->i_mount;
-	int			error = 0;
+	xfs_lsn_t		lsn = 0;
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	if (xfs_ipincount(ip)) {
-		error = _xfs_log_force_lsn(mp, ip->i_itemp->ili_last_lsn,
-				XFS_LOG_SYNC, NULL);
-	}
+	if (xfs_ipincount(ip))
+		lsn = ip->i_itemp->ili_last_lsn;
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
 
-	return error;
+	if (!lsn)
+		return 0;
+	return _xfs_log_force_lsn(mp, lsn, XFS_LOG_SYNC, NULL);
 }
 
 const struct export_operations xfs_export_operations = {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
