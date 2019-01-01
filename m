Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:43820 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728195AbfAACVG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:21:06 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012EgKo019067
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:21:04 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2130.oracle.com with ESMTP id 2pp0btp7a9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:21:04 +0000
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012L4Pf027422
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:21:04 GMT
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x012L3Rh027995
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:21:03 GMT
Subject: [PATCH 17/22] xfs: hoist inode free function to libxfs
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:21:02 -0800
Message-ID: <154630926266.18437.9885897962204223918.stgit@magnolia>
In-Reply-To: <154630914104.18437.15354380637179830566.stgit@magnolia>
References: <154630914104.18437.15354380637179830566.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create a libxfs helper function that marks an inode free on disk.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_inode_util.c |   63 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_inode_util.h |    4 +++
 fs/xfs/xfs_inode.c             |   48 +-----------------------------
 3 files changed, 68 insertions(+), 47 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_inode_util.c b/fs/xfs/libxfs/xfs_inode_util.c
index e7251f8fd96a..01a320747ddf 100644
--- a/fs/xfs/libxfs/xfs_inode_util.c
+++ b/fs/xfs/libxfs/xfs_inode_util.c
@@ -17,6 +17,7 @@
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
 #include "xfs_error.h"
+#include "xfs_inode_item.h"
 
 /*
  * helper function to extract extent size hint from inode
@@ -823,3 +824,65 @@ xfs_bumplink(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	return 0;
 }
+
+/*
+ * Free any local-format buffers sitting around before we reset to
+ * extents format.
+ */
+static inline void
+xfs_ifree_local_data(
+	struct xfs_inode	*ip,
+	int			whichfork)
+{
+	struct xfs_ifork	*ifp;
+
+	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
+		return;
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
+}
+
+/* Mark an inode free on disk. */
+int
+xfs_dir_ifree(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_icluster	*xic)
+{
+	int			error;
+
+	/*
+	 * Pull the on-disk inode from the AGI unlinked list.
+	 */
+	error = xfs_iunlink_remove(tp, ip);
+	if (error)
+		return error;
+
+	error = xfs_difree(tp, ip->i_ino, xic);
+	if (error)
+		return error;
+
+	xfs_ifree_local_data(ip, XFS_DATA_FORK);
+	xfs_ifree_local_data(ip, XFS_ATTR_FORK);
+
+	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
+	ip->i_d.di_flags = 0;
+	ip->i_d.di_flags2 = 0;
+	ip->i_d.di_dmevmask = 0;
+	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
+	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
+	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
+
+	/* Don't attempt to replay owner changes for a deleted inode */
+	ip->i_itemp->ili_fields &= ~(XFS_ILOG_AOWNER | XFS_ILOG_DOWNER);
+
+	/*
+	 * Bump the generation count so no one will be confused
+	 * by reincarnations of this inode.
+	 */
+	VFS_I(ip)->i_generation++;
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+
+	return 0;
+}
diff --git a/fs/xfs/libxfs/xfs_inode_util.h b/fs/xfs/libxfs/xfs_inode_util.h
index 7258e18aeed0..4918379b682e 100644
--- a/fs/xfs/libxfs/xfs_inode_util.h
+++ b/fs/xfs/libxfs/xfs_inode_util.h
@@ -6,6 +6,8 @@
 #ifndef	__XFS_INODE_UTIL_H__
 #define	__XFS_INODE_UTIL_H__
 
+struct xfs_icluster;
+
 xfs_extlen_t	xfs_get_extsz_hint(struct xfs_inode *ip);
 xfs_extlen_t	xfs_get_cowextsz_hint(struct xfs_inode *ip);
 
@@ -100,5 +102,7 @@ int xfs_iunlink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_iunlink_remove(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_droplink(struct xfs_trans *tp, struct xfs_inode *ip);
 int xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
+int xfs_dir_ifree(struct xfs_trans *tp, struct xfs_inode *ip,
+		  struct xfs_icluster *xic);
 
 #endif /* __XFS_INODE_UTIL_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 189f11bba539..93a03cbbb9af 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1770,24 +1770,6 @@ xfs_ifree_cluster(
 	return 0;
 }
 
-/*
- * Free any local-format buffers sitting around before we reset to
- * extents format.
- */
-static inline void
-xfs_ifree_local_data(
-	struct xfs_inode	*ip,
-	int			whichfork)
-{
-	struct xfs_ifork	*ifp;
-
-	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL)
-		return;
-
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	xfs_idata_realloc(ip, -ifp->if_bytes, whichfork);
-}
-
 /*
  * This is called to return an inode to the inode free list.
  * The inode should already be truncated to 0 length and have
@@ -1813,38 +1795,10 @@ xfs_ifree(
 	ASSERT(ip->i_d.di_size == 0 || !S_ISREG(VFS_I(ip)->i_mode));
 	ASSERT(ip->i_d.di_nblocks == 0);
 
-	/*
-	 * Pull the on-disk inode from the AGI unlinked list.
-	 */
-	error = xfs_iunlink_remove(tp, ip);
-	if (error)
-		return error;
-
-	error = xfs_difree(tp, ip->i_ino, &xic);
+	error = xfs_dir_ifree(tp, ip, &xic);
 	if (error)
 		return error;
 
-	xfs_ifree_local_data(ip, XFS_DATA_FORK);
-	xfs_ifree_local_data(ip, XFS_ATTR_FORK);
-
-	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
-	ip->i_d.di_flags = 0;
-	ip->i_d.di_flags2 = 0;
-	ip->i_d.di_dmevmask = 0;
-	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
-	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
-	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
-
-	/* Don't attempt to replay owner changes for a deleted inode */
-	ip->i_itemp->ili_fields &= ~(XFS_ILOG_AOWNER|XFS_ILOG_DOWNER);
-
-	/*
-	 * Bump the generation count so no one will be confused
-	 * by reincarnations of this inode.
-	 */
-	VFS_I(ip)->i_generation++;
-	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
 	if (xic.deleted)
 		error = xfs_ifree_cluster(ip, tp, &xic);
 
