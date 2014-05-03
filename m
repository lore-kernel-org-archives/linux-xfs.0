Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 865417F37
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 10:18:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 78E8030405F
	for <xfs@oss.sgi.com>; Sat,  3 May 2014 08:18:04 -0700 (PDT)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id hBwaOu99zJiNGVJF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 03 May 2014 08:18:03 -0700 (PDT)
Received: from [83.175.99.196] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1WgbhS-0003i3-9e
	for xfs@oss.sgi.com; Sat, 03 May 2014 15:18:02 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3/5] xfs: fold xfs_attr_remove_int into xfs_attr_remove
Date: Sat,  3 May 2014 17:20:13 +0200
Message-Id: <1399130415-5382-4-git-send-email-hch@lst.de>
In-Reply-To: <1399130415-5382-1-git-send-email-hch@lst.de>
References: <1399130415-5382-1-git-send-email-hch@lst.de>
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

Also remove a useless ilock roundtrip for the first attr fork check, it's
racy anyway and we redo it later under the ilock before we start the removal.

Plus various minor style fixes to the new xfs_attr_remove.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr.c |   97 +++++++++++++++++++----------------------------------
 1 file changed, 35 insertions(+), 62 deletions(-)

diff --git a/fs/xfs/xfs_attr.c b/fs/xfs/xfs_attr.c
index 01f2267..a96e27b 100644
--- a/fs/xfs/xfs_attr.c
+++ b/fs/xfs/xfs_attr.c
@@ -416,21 +416,34 @@ out:
  * Generic handler routine to remove a name from an attribute list.
  * Transitions attribute list from Btree to shortform as necessary.
  */
-STATIC int
-xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
+int
+xfs_attr_remove(
+	struct xfs_inode	*dp,
+	const unsigned char	*name,
+	int			flags)
 {
-	xfs_da_args_t	args;
-	xfs_fsblock_t	firstblock;
-	xfs_bmap_free_t	flist;
-	int		error;
-	xfs_mount_t	*mp = dp->i_mount;
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_da_args	args;
+	struct xfs_bmap_free	flist;
+	struct xfs_name		xname;
+	xfs_fsblock_t		firstblock;
+	int			error;
 
-	/*
-	 * Fill in the arg structure for this request.
-	 */
-	memset((char *)&args, 0, sizeof(args));
-	args.name = name->name;
-	args.namelen = name->len;
+	XFS_STATS_INC(xs_attr_remove);
+
+	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
+		return EIO;
+
+	if (!xfs_inode_hasattr(dp))
+		return ENOATTR;
+
+	error = xfs_attr_name_to_xname(&xname, name);
+	if (error)
+		return error;
+
+	memset(&args, 0, sizeof(args));
+	args.name = xname.name;
+	args.namelen = xname.len;
 	args.flags = flags;
 	args.hashval = xfs_da_hashname(args.name, args.namelen);
 	args.dp = dp;
@@ -446,9 +459,6 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 	 */
 	args.op_flags = XFS_DA_OP_OKNOENT;
 
-	/*
-	 * Attach the dquots to the inode.
-	 */
 	error = xfs_qm_dqattach(dp, 0);
 	if (error)
 		return error;
@@ -477,7 +487,7 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 				  XFS_ATTRRM_SPACE_RES(mp), 0);
 	if (error) {
 		xfs_trans_cancel(args.trans, 0);
-		return(error);
+		return error;
 	}
 
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
@@ -487,35 +497,26 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
 
-	/*
-	 * Decide on what work routines to call based on the inode size.
-	 */
 	if (!xfs_inode_hasattr(dp)) {
 		error = XFS_ERROR(ENOATTR);
-		goto out;
-	}
-	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
 		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
 		error = xfs_attr_shortform_remove(&args);
-		if (error) {
-			goto out;
-		}
 	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
 		error = xfs_attr_leaf_removename(&args);
 	} else {
 		error = xfs_attr_node_removename(&args);
 	}
-	if (error) {
+
+	if (error)
 		goto out;
-	}
 
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * transaction goes to disk before returning to the user.
 	 */
-	if (mp->m_flags & XFS_MOUNT_WSYNC) {
+	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args.trans);
-	}
 
 	if ((flags & ATTR_KERNOTIME) == 0)
 		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
@@ -527,45 +528,17 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
-	return(error);
+	return error;
 
 out:
-	if (args.trans)
+	if (args.trans) {
 		xfs_trans_cancel(args.trans,
 			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
-	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-	return(error);
-}
-
-int
-xfs_attr_remove(
-	xfs_inode_t	*dp,
-	const unsigned char *name,
-	int		flags)
-{
-	int		error;
-	struct xfs_name	xname;
-
-	XFS_STATS_INC(xs_attr_remove);
-
-	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
-		return (EIO);
-
-	error = xfs_attr_name_to_xname(&xname, name);
-	if (error)
-		return error;
-
-	xfs_ilock(dp, XFS_ILOCK_SHARED);
-	if (!xfs_inode_hasattr(dp)) {
-		xfs_iunlock(dp, XFS_ILOCK_SHARED);
-		return XFS_ERROR(ENOATTR);
 	}
-	xfs_iunlock(dp, XFS_ILOCK_SHARED);
-
-	return xfs_attr_remove_int(dp, &xname, flags);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	return error;
 }
 
-
 /*========================================================================
  * External routines when attribute list is inside the inode
  *========================================================================*/
-- 
1.7.10.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
