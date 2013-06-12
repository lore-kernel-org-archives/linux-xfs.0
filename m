Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 48C317F3F
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 13:31:07 -0500 (CDT)
Received: from eagdhcp-232-136.americas.sgi.com
	(eagdhcp-232-136.americas.sgi.com [128.162.232.136])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 15EFC30406B
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 11:31:07 -0700 (PDT)
Received: from eagdhcp-232-136.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-136.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	r5CIV7vQ003170
	for <xfs@oss.sgi.com>; Wed, 12 Jun 2013 13:31:07 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Message-Id: <20130612182836.141843930@sgi.com>
Date: Wed, 12 Jun 2013 13:28:19 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH v2] xfs: fix the symbolic link assert in xfs_ifree
References: <20130612182818.363497890@.sgi.com>
Content-Disposition: inline; filename=v2-xfs-fix-assert-in-xfs_ifree.patch
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Adding an extended attribute to a symbolic link can force that
link to an remote extent. xfs_inactive() incorrectly assumes
that any symbolic link small enough to be in the inode core
is incore, resulting in the remote extent to not be removed.
xfs_ifree() will assert on presence of this leaked remote extent.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
xfstest is coming.

 fs/xfs/xfs_symlink.c  |   24 +++++++++++++++++++++++-
 fs/xfs/xfs_symlink.h  |    1 +
 fs/xfs/xfs_vnodeops.c |   15 +++------------
 3 files changed, 27 insertions(+), 13 deletions(-)

Index: b/fs/xfs/xfs_symlink.c
===================================================================
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -606,7 +606,7 @@ xfs_inactive_symlink_rmt(
 
 	tp = *tpp;
 	mp = ip->i_mount;
-	ASSERT(ip->i_d.di_size > XFS_IFORK_DSIZE(ip));
+	ASSERT(ip->i_df.if_flags & XFS_IFEXTENTS);
 	/*
 	 * We're freeing a symlink that has some
 	 * blocks allocated to it.  Free the
@@ -720,3 +720,25 @@ xfs_inactive_symlink_rmt(
  error0:
 	return error;
 }
+
+/*
+ * xfs_inactive_symlink - free a symlink
+ */
+int
+xfs_inactive_symlink(
+	struct xfs_inode	*ip,
+	struct xfs_trans	**tp)
+{
+
+	/*
+	 * Zero length symlinks _can_ exist.
+	 */
+	if (ip->i_df.if_flags & XFS_IFINLINE) {
+		if (ip->i_df.if_bytes > 0)
+			xfs_idata_realloc(ip, -(ip->i_df.if_bytes),
+					  XFS_DATA_FORK);
+		ASSERT(ip->i_df.if_bytes == 0);
+		return 0;
+	} else
+		return (xfs_inactive_symlink_rmt(ip, tp));
+}
Index: b/fs/xfs/xfs_symlink.h
===================================================================
--- a/fs/xfs/xfs_symlink.h
+++ b/fs/xfs/xfs_symlink.h
@@ -61,6 +61,7 @@ int xfs_symlink(struct xfs_inode *dp, st
 		const char *target_path, umode_t mode, struct xfs_inode **ipp);
 int xfs_readlink(struct xfs_inode *ip, char *link);
 int xfs_inactive_symlink_rmt(struct xfs_inode *ip, struct xfs_trans **tpp);
+int xfs_inactive_symlink(struct xfs_inode *ip, struct xfs_trans **tpp);
 
 #endif /* __KERNEL__ */
 #endif /* __XFS_SYMLINK_H */
Index: b/fs/xfs/xfs_vnodeops.c
===================================================================
--- a/fs/xfs/xfs_vnodeops.c
+++ b/fs/xfs/xfs_vnodeops.c
@@ -322,18 +322,9 @@ xfs_inactive(
 	xfs_trans_ijoin(tp, ip, 0);
 
 	if (S_ISLNK(ip->i_d.di_mode)) {
-		/*
-		 * Zero length symlinks _can_ exist.
-		 */
-		if (ip->i_d.di_size > XFS_IFORK_DSIZE(ip)) {
-			error = xfs_inactive_symlink_rmt(ip, &tp);
-			if (error)
-				goto out_cancel;
-		} else if (ip->i_df.if_bytes > 0) {
-			xfs_idata_realloc(ip, -(ip->i_df.if_bytes),
-					  XFS_DATA_FORK);
-			ASSERT(ip->i_df.if_bytes == 0);
-		}
+		error = xfs_inactive_symlink(ip, &tp);
+		if (error)
+			goto out_cancel;
 	} else if (truncate) {
 		ip->i_d.di_size = 0;
 		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
