Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7E5297FB3
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:00:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F35EFAC00D
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:00:14 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id Lq3vIjAlZmceRyzw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:00:13 -0700 (PDT)
Subject: [PATCH 45/58] xfs: create a separate workqueue for copy-on-write
	activities
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:00:05 -0700
Message-ID: <20151007050005.30457.80025.stgit@birch.djwong.org>
In-Reply-To: <20151007045443.30457.47038.stgit@birch.djwong.org>
References: <20151007045443.30457.47038.stgit@birch.djwong.org>
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
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

Create a separate workqueue to handle copy on write blocks so that we
don't explode the number of kworkers if a flood of writes comes
through.  We could possibly use m_buf_wq for this too...

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_mount.h |    1 +
 fs/xfs/xfs_super.c |   36 +++++++++++++++++++++++++++++++++++-
 2 files changed, 36 insertions(+), 1 deletion(-)


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
index 6dc5993..c6a26b0 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -883,6 +883,33 @@ xfs_destroy_mount_workqueues(
 	destroy_workqueue(mp->m_buf_workqueue);
 }
 
+STATIC int
+xfs_init_feature_workqueues(
+	struct xfs_mount	*mp)
+{
+	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
+		/* XXX awful, but it'll improve when bh's go away */
+		/* XXX probably need locking around the endio rbtree */
+		mp->m_cow_workqueue = alloc_workqueue("xfs-cow/%s",
+				WQ_MEM_RECLAIM|WQ_FREEZABLE|WQ_UNBOUND,
+				1, mp->m_fsname);
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
@@ -1490,6 +1517,10 @@ xfs_fs_fill_super(
 	if (error)
 		goto out_free_sb;
 
+	error = xfs_init_feature_workqueues(mp);
+	if (error)
+		goto out_filestream_unmount;
+
 	/*
 	 * we must configure the block size in the superblock before we run the
 	 * full mount process as the mount process can lookup and cache inodes.
@@ -1526,7 +1557,7 @@ xfs_fs_fill_super(
 
 	error = xfs_mountfs(mp);
 	if (error)
-		goto out_filestream_unmount;
+		goto out_destroy_feature_workqueues;
 
 	root = igrab(VFS_I(mp->m_rootip));
 	if (!root) {
@@ -1541,6 +1572,8 @@ xfs_fs_fill_super(
 
 	return 0;
 
+out_destroy_feature_workqueues:
+	xfs_destroy_feature_workqueues(mp);
  out_filestream_unmount:
 	xfs_filestream_unmount(mp);
  out_free_sb:
@@ -1570,6 +1603,7 @@ xfs_fs_put_super(
 	struct xfs_mount	*mp = XFS_M(sb);
 
 	xfs_notice(mp, "Unmounting Filesystem");
+	xfs_destroy_feature_workqueues(mp);
 	xfs_filestream_unmount(mp);
 	xfs_unmountfs(mp);
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
