Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8IKnBOX201702 for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 15:49:11 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id EED42172089
	for <xfs@oss.sgi.com>; Sun, 18 Sep 2011 13:49:10 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	livuFWzR2WUV9xpc for <xfs@oss.sgi.com>;
	Sun, 18 Sep 2011 13:49:10 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1R5OIY-0005y4-AY
	for xfs@oss.sgi.com; Sun, 18 Sep 2011 20:49:10 +0000
Message-Id: <20110918204910.285475671@bombadil.infradead.org>
Date: Sun, 18 Sep 2011 16:47:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 3/3] xfs: unlock the inode before log force in
	xfs_change_file_space
References: <20110918204748.547510183@bombadil.infradead.org>
Content-Disposition: inline; filename=xfs-optimize-osync-prealloc
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

Let the transaction commit unlock the inode before it potentially causes
a synchronous log force.

Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/xfs_vnodeops.c
===================================================================
--- xfs.orig/fs/xfs/xfs_vnodeops.c	2011-09-18 11:41:41.000000000 -0400
+++ xfs/fs/xfs/xfs_vnodeops.c	2011-09-18 11:43:05.951778942 -0400
@@ -2342,8 +2342,7 @@ xfs_change_file_space(
 	}
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-
-	xfs_trans_ijoin(tp, ip);
+	xfs_trans_ijoin_ref(tp, ip, XFS_ILOCK_EXCL);
 
 	if ((attr_flags & XFS_ATTR_DMI) == 0) {
 		ip->i_d.di_mode &= ~S_ISUID;
@@ -2368,10 +2367,5 @@ xfs_change_file_space(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	if (attr_flags & XFS_ATTR_SYNC)
 		xfs_trans_set_sync(tp);
-
-	error = xfs_trans_commit(tp, 0);
-
-	xfs_iunlock(ip, XFS_ILOCK_EXCL);
-
-	return error;
+	return xfs_trans_commit(tp, 0);
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
