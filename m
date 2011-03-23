Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with SMTP id
	p2N6CfW4074525 for <xfs@oss.sgi.com>; Wed, 23 Mar 2011 01:12:46 -0500
Received: from ipmail06.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FA7613FA515
	for <xfs@oss.sgi.com>; Tue, 22 Mar 2011 23:15:40 -0700 (PDT)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	XJu0fd0nqu8esZ2B for <xfs@oss.sgi.com>;
	Tue, 22 Mar 2011 23:15:40 -0700 (PDT)
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/6] xfs: register the inode cache shrinker before quotachecks
Date: Wed, 23 Mar 2011 17:14:29 +1100
Message-Id: <1300860870-15471-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1300860870-15471-1-git-send-email-david@fromorbit.com>
References: <1300860870-15471-1-git-send-email-david@fromorbit.com>
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
Cc: aelder@sgi.com

From: Dave Chinner <dchinner@redhat.com>

During mount, we can do a quotacheck that involves a bulkstat pass
on all inodes. If there are more inodes in the filesystem than can
be held in memory, we require the inode cache shrinker to run to
ensure that we don't run out of memory.

Unfortunately, the inode cache shrinker is not registered until we
get to the end of the superblock setup process, which is after a
quotacheck is run if it is needed. Hence we need to register the
inode cache shrinker earlier in the mount process so that we don't
OOM during mount. This requires that we also initialise the syncd
work before we register the shrinker, so we nee dto juggle that
around as well.

While there, make sure that we have set up the block sizes in the
VFS superblock correctly before the quotacheck is run so that any
inodes that are cached as a result of the quotacheck have their
block size fields set up correctly.

Cc: stable@kernel.org
Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_super.c |   34 ++++++++++++++++++++++++----------
 1 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_super.c b/fs/xfs/linux-2.6/xfs_super.c
index 8a70b2a..1ba5c45 100644
--- a/fs/xfs/linux-2.6/xfs_super.c
+++ b/fs/xfs/linux-2.6/xfs_super.c
@@ -1539,10 +1539,14 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_free_sb;
 
-	error = xfs_mountfs(mp);
-	if (error)
-		goto out_filestream_unmount;
-
+	/*
+	 * we must configure the block size in the superblock before we run the
+	 * full mount process as the mount process can lookup and cache inodes.
+	 * For the same reason we must also initialise the syncd and register
+	 * the inode cache shrinker so that inodes can be reclaimed during
+	 * operations like a quotacheck that iterate all inodes in the
+	 * filesystem.
+	 */
 	sb->s_magic = XFS_SB_MAGIC;
 	sb->s_blocksize = mp->m_sb.sb_blocksize;
 	sb->s_blocksize_bits = ffs(sb->s_blocksize) - 1;
@@ -1550,6 +1554,16 @@ xfs_fs_fill_super(
 	sb->s_time_gran = 1;
 	set_posix_acl_flag(sb);
 
+	error = xfs_syncd_init(mp);
+	if (error)
+		goto out_filestream_unmount;
+
+	xfs_inode_shrinker_register(mp);
+
+	error = xfs_mountfs(mp);
+	if (error)
+		goto out_syncd_stop;
+
 	root = igrab(VFS_I(mp->m_rootip));
 	if (!root) {
 		error = ENOENT;
@@ -1565,14 +1579,11 @@ xfs_fs_fill_super(
 		goto fail_vnrele;
 	}
 
-	error = xfs_syncd_init(mp);
-	if (error)
-		goto fail_vnrele;
-
-	xfs_inode_shrinker_register(mp);
-
 	return 0;
 
+ out_syncd_stop:
+	xfs_inode_shrinker_unregister(mp);
+	xfs_syncd_stop(mp);
  out_filestream_unmount:
 	xfs_filestream_unmount(mp);
  out_free_sb:
@@ -1596,6 +1607,9 @@ xfs_fs_fill_super(
 	}
 
  fail_unmount:
+	xfs_inode_shrinker_unregister(mp);
+	xfs_syncd_stop(mp);
+
 	/*
 	 * Blow away any referenced inode in the filestreams cache.
 	 * This can and will cause log traffic as inodes go inactive
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
