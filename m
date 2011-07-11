Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6BDxx1Q226052 for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 09:00:00 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 4601A17B3107
	for <xfs@oss.sgi.com>; Mon, 11 Jul 2011 06:59:58 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	LyLKIFoSUDv2MaLC for <xfs@oss.sgi.com>;
	Mon, 11 Jul 2011 06:59:58 -0700 (PDT)
Date: Mon, 11 Jul 2011 09:59:57 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfs: start periodic workers later
Message-ID: <20110711135957.GA23737@infradead.org>
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

Start the periodic sync workers only after we have finished xfs_mountfs
and thus fully set up the filesystem structures.  Without this we can
call into xfs_qm_sync before the quotainfo strucute is set up if the
mount takes unusually long, and probably hit other incomplete states
as well.

Also clean up the xfs_fs_fill_super error path by using consistent
label names, and removing an impossible to reach case.

Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfs/fs/xfs/linux-2.6/xfs_super.c
===================================================================
--- xfs.orig/fs/xfs/linux-2.6/xfs_super.c	2011-07-11 12:02:56.762758869 +0200
+++ xfs/fs/xfs/linux-2.6/xfs_super.c	2011-07-11 12:09:20.817344934 +0200
@@ -1411,37 +1411,35 @@ xfs_fs_fill_super(
 	sb->s_time_gran = 1;
 	set_posix_acl_flag(sb);
 
-	error = xfs_syncd_init(mp);
-	if (error)
-		goto out_filestream_unmount;
-
 	xfs_inode_shrinker_register(mp);
 
 	error = xfs_mountfs(mp);
 	if (error)
-		goto out_syncd_stop;
+		goto out_filestream_unmount;
+
+	error = xfs_syncd_init(mp);
+	if (error)
+		goto out_unmount;
 
 	root = igrab(VFS_I(mp->m_rootip));
 	if (!root) {
 		error = ENOENT;
-		goto fail_unmount;
+		goto out_syncd_stop;
 	}
 	if (is_bad_inode(root)) {
 		error = EINVAL;
-		goto fail_vnrele;
+		goto out_syncd_stop;
 	}
 	sb->s_root = d_alloc_root(root);
 	if (!sb->s_root) {
 		error = ENOMEM;
-		goto fail_vnrele;
+		goto out_iput;
 	}
 
 	return 0;
 
- out_syncd_stop:
-	xfs_inode_shrinker_unregister(mp);
-	xfs_syncd_stop(mp);
  out_filestream_unmount:
+	xfs_inode_shrinker_unregister(mp);
 	xfs_filestream_unmount(mp);
  out_free_sb:
 	xfs_freesb(mp);
@@ -1455,17 +1453,12 @@ xfs_fs_fill_super(
  out:
 	return -error;
 
- fail_vnrele:
-	if (sb->s_root) {
-		dput(sb->s_root);
-		sb->s_root = NULL;
-	} else {
-		iput(root);
-	}
-
- fail_unmount:
-	xfs_inode_shrinker_unregister(mp);
+ out_iput:
+	iput(root);
+ out_syncd_stop:
 	xfs_syncd_stop(mp);
+ out_unmount:
+	xfs_inode_shrinker_unregister(mp);
 
 	/*
 	 * Blow away any referenced inode in the filestreams cache.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
