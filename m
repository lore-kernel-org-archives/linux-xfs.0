Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42377 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755913AbcI3DIV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 29 Sep 2016 23:08:21 -0400
Subject: [PATCH 24/63] xfs: when replaying bmap operations,
 don't let unlinked inodes get reaped
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 29 Sep 2016 20:08:17 -0700
Message-ID: <147520489698.29434.13242363533695270347.stgit@birch.djwong.org>
In-Reply-To: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
References: <147520472904.29434.15518629624221621056.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Log recovery will iget an inode to replay BUI items and iput the inode
when it's done.  Unfortunately, the iput will see that i_nlink == 0
and decide to truncate & free the inode, which prevents us from
replaying subsequent BUIs.  We can't skip the BUIs because we have to
replay all the redo items to ensure that atomic operations complete.

Since unlinked inode recovery will reap the inode anyway, we can
safely introduce a new inode flag to indicate that an inode is in this
'unlinked recovery' state and should not be auto-reaped in the
drop_inode path.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_bmap_item.c   |    1 +
 fs/xfs/xfs_inode.c       |    8 ++++++++
 fs/xfs/xfs_inode.h       |    6 ++++++
 fs/xfs/xfs_log_recover.c |    1 +
 4 files changed, 16 insertions(+)


diff --git a/fs/xfs/xfs_bmap_item.c b/fs/xfs/xfs_bmap_item.c
index ddda7c3..b1a220f 100644
--- a/fs/xfs/xfs_bmap_item.c
+++ b/fs/xfs/xfs_bmap_item.c
@@ -456,6 +456,7 @@ xfs_bui_recover(
 	if (error)
 		goto err_inode;
 
+	xfs_iflags_set(ip, XFS_IRECOVER_UNLINKED);
 	xfs_defer_init(&dfops, &firstfsb);
 
 	/* Process deferred bmap item. */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e08eaea..0c25a76 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1855,6 +1855,14 @@ xfs_inactive(
 	if (mp->m_flags & XFS_MOUNT_RDONLY)
 		return;
 
+	/*
+	 * If this unlinked inode is in the middle of recovery, don't
+	 * truncate and free the inode just yet; log recovery will take
+	 * care of that.  See the comment for this inode flag.
+	 */
+	if (xfs_iflags_test(ip, XFS_IRECOVER_UNLINKED))
+		return;
+
 	if (VFS_I(ip)->i_nlink != 0) {
 		/*
 		 * force is true because we are evicting an inode from the
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index a8658e6..46632f1 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -222,6 +222,12 @@ static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 #define XFS_IPINNED		(1 << __XFS_IPINNED_BIT)
 #define XFS_IDONTCACHE		(1 << 9) /* don't cache the inode long term */
 #define XFS_IEOFBLOCKS		(1 << 10)/* has the preallocblocks tag set */
+/*
+ * If this unlinked inode is in the middle of recovery, don't let drop_inode
+ * truncate and free the inode.  This can happen if we iget the inode during
+ * log recovery to replay a bmap operation on the inode.
+ */
+#define XFS_IRECOVER_UNLINKED	(1 << 11)
 
 /*
  * Per-lifetime flags need to be reset when re-using a reclaimable inode during
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9697e94..b121f02 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -4969,6 +4969,7 @@ xlog_recover_process_one_iunlink(
 	if (error)
 		goto fail_iput;
 
+	xfs_iflags_clear(ip, XFS_IRECOVER_UNLINKED);
 	ASSERT(VFS_I(ip)->i_nlink == 0);
 	ASSERT(VFS_I(ip)->i_mode != 0);
 

