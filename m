Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9EIr4MW043307 for <xfs@oss.sgi.com>; Fri, 14 Oct 2011 13:53:04 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6CE2D562018
	for <xfs@oss.sgi.com>; Fri, 14 Oct 2011 11:53:02 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	kCs86AOAquxqYGwr for <xfs@oss.sgi.com>;
	Fri, 14 Oct 2011 11:53:02 -0700 (PDT)
Message-Id: <20111014185300.951347780@bombadil.infradead.org>
Date: Fri, 14 Oct 2011 14:50:49 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 1/5] xfs: start periodic workers later
References: <20111014185048.893798829@bombadil.infradead.org>
Content-Disposition: inline; filename=backport1.diff
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
To: stable@kernel.org
Cc: xfs@oss.sgi.com

commit 2bcf6e970f5a88fa05dced5eeb0326e13d93c4a1 upstream

Start the periodic sync workers only after we have finished xfs_mountfs
and thus fully set up the filesystem structures.  Without this we can
call into xfs_qm_sync before the quotainfo strucute is set up if the
mount takes unusually long, and probably hit other incomplete states
as well.
    
Also clean up the xfs_fs_fill_super error path by using consistent
label names, and removing an impossible to reach case.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
Reviewed-by: Alex Elder <aelder@sgi.com>

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index a1a881e..3ebb458 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1412,37 +1412,35 @@ xfs_fs_fill_super(
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
@@ -1456,17 +1454,12 @@ xfs_fs_fill_super(
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
