Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id C6BCD29E01
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 17:34:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6FEC2AC006
	for <xfs@oss.sgi.com>; Wed, 29 Jul 2015 15:34:29 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id qaVlI4RwkFcarVfL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 29 Jul 2015 15:34:27 -0700 (PDT)
Subject: [PATCH 13/24] xfs: create a separate workqueue for copy-on-write
	activities
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 29 Jul 2015 15:34:22 -0700
Message-ID: <20150729223421.17414.67745.stgit@birch.djwong.org>
In-Reply-To: <20150729223258.17414.91354.stgit@birch.djwong.org>
References: <20150729223258.17414.91354.stgit@birch.djwong.org>
MIME-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Create a separate workqueue to handle copy on write blocks so that we
don't explode the number of kworkers if a flood of writes comes
through.  We could possibly use m_buf_wq for this too...

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_mount.h |    1 +
 fs/xfs/xfs_super.c |   33 ++++++++++++++++++++++++++++++++-
 2 files changed, 33 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index aba42d7..6f4c335 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -142,6 +142,7 @@ typedef struct xfs_mount {
 	struct workqueue_struct	*m_reclaim_workqueue;
 	struct workqueue_struct	*m_log_workqueue;
 	struct workqueue_struct *m_eofblocks_workqueue;
+	struct workqueue_struct *m_cow_workqueue;
 
 	/*
 	 * Generation of the filesysyem layout.  This is incremented by each
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 796ccb5..01109db 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -891,6 +891,30 @@ xfs_destroy_mount_workqueues(
 	destroy_workqueue(mp->m_buf_workqueue);
 }
 
+STATIC int
+xfs_init_feature_workqueues(
+	struct xfs_mount	*mp)
+{
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		mp->m_cow_workqueue = alloc_workqueue("xfs-cow/%s",
+				WQ_MEM_RECLAIM|WQ_FREEZABLE, 1, mp->m_fsname);
+		if (!mp->m_cow_workqueue)
+			goto out;
+	}
+
+	return 0;
+out:
+	return -ENOMEM;
+}
+
+STATIC void
+xfs_destroy_feature_workqueues(
+	struct xfs_mount	*mp)
+{
+	if (mp->m_cow_workqueue)
+		destroy_workqueue(mp->m_cow_workqueue);
+}
+
 /*
  * Flush all dirty data to disk. Must not be called while holding an XFS_ILOCK
  * or a page lock. We use sync_inodes_sb() here to ensure we block while waiting
@@ -1498,6 +1522,10 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_free_sb;
 
+	error = xfs_init_feature_workqueues(mp);
+	if (error)
+		goto out_filestream_unmount;
+
 	/*
 	 * we must configure the block size in the superblock before we run the
 	 * full mount process as the mount process can lookup and cache inodes.
@@ -1530,7 +1558,7 @@ xfs_fs_fill_super(
 
 	error = xfs_mountfs(mp);
 	if (error)
-		goto out_filestream_unmount;
+		goto out_destroy_feature_workqueues;
 
 	root = igrab(VFS_I(mp->m_rootip));
 	if (!root) {
@@ -1545,6 +1573,8 @@ xfs_fs_fill_super(
 
 	return 0;
 
+out_destroy_feature_workqueues:
+	xfs_destroy_feature_workqueues(mp);
  out_filestream_unmount:
 	xfs_filestream_unmount(mp);
  out_free_sb:
@@ -1574,6 +1604,7 @@ xfs_fs_put_super(
 	struct xfs_mount	*mp = XFS_M(sb);
 
 	xfs_notice(mp, "Unmounting Filesystem");
+	xfs_destroy_feature_workqueues(mp);
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
