Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id C3D227F9C
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2014 16:01:07 -0500 (CDT)
Date: Thu, 11 Sep 2014 16:01:04 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 09/13] libxfs: apply utf-8 normalization rules to user
	extended attribute names
Message-ID: <20140911210104.GR13262@sgi.com>
References: <20140911203735.GA19952@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140911203735.GA19952@sgi.com>
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
To: xfs@oss.sgi.com
Cc: tinguely@sgi.com, olaf@sgi.com

From: Olaf Weber <olaf@sgi.com>

Apply the same rules for UTF-8 normalization to the names of user-defined
extended attributes. System attributes are excluded because they are not
user-visible in the first place, and the kernel is expected to know what
it is doing when naming them.

Signed-off-by: Olaf Weber <olaf@sgi.com>
---
 libxfs/xfs_attr.c      | 49 +++++++++++++++++++++++++++++++++++++++++--------
 libxfs/xfs_attr_leaf.c | 11 +++++++++--
 libxfs/xfs_utf8.c      |  7 +++++++
 3 files changed, 57 insertions(+), 10 deletions(-)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 17519d3..c30703b 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -88,8 +88,9 @@ xfs_attr_get_int(
 	int			*valuelenp,
 	int			flags)
 {
-	xfs_da_args_t   args;
-	int             error;
+	xfs_da_args_t   	args;
+	struct xfs_mount	*mp = ip->i_mount;
+	int             	error;
 
 	if (!xfs_inode_hasattr(ip))
 		return ENOATTR;
@@ -103,9 +104,12 @@ xfs_attr_get_int(
 	args.value = value;
 	args.valuelen = *valuelenp;
 	args.flags = flags;
-	args.hashval = xfs_da_hashname(args.name, args.namelen);
 	args.dp = ip;
 	args.whichfork = XFS_ATTR_FORK;
+	if (! xfs_sb_version_hasutf8(&mp->m_sb))
+		args.hashval = xfs_da_hashname(args.name, args.namelen);
+	else if ((error = mp->m_dirnameops->normhash(&args)) != 0)
+		return error;
 
 	/*
 	 * Decide on what work routines to call based on the inode size.
@@ -118,6 +122,9 @@ xfs_attr_get_int(
 		error = xfs_attr_node_get(&args);
 	}
 
+	if (args.norm)
+		kmem_free((void *)args.norm);
+
 	/*
 	 * Return the number of bytes in the value to the caller.
 	 */
@@ -239,12 +246,15 @@ xfs_attr_set_int(
 	args.value = value;
 	args.valuelen = valuelen;
 	args.flags = flags;
-	args.hashval = xfs_da_hashname(args.name, args.namelen);
 	args.dp = dp;
 	args.firstblock = &firstblock;
 	args.flist = &flist;
 	args.whichfork = XFS_ATTR_FORK;
 	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
+	if (! xfs_sb_version_hasutf8(&mp->m_sb))
+		args.hashval = xfs_da_hashname(args.name, args.namelen);
+	else if ((error = mp->m_dirnameops->normhash(&args)) != 0)
+		return error;
 
 	/* Size is now blocks for attribute data */
 	args.total = xfs_attr_calc_size(dp, name->len, valuelen, &local);
@@ -276,6 +286,8 @@ xfs_attr_set_int(
 	error = xfs_trans_reserve(args.trans, &tres, args.total, 0);
 	if (error) {
 		xfs_trans_cancel(args.trans, 0);
+		if (args.norm)
+			kmem_free((void *)args.norm);
 		return(error);
 	}
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
@@ -286,6 +298,8 @@ xfs_attr_set_int(
 	if (error) {
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 		xfs_trans_cancel(args.trans, XFS_TRANS_RELEASE_LOG_RES);
+		if (args.norm)
+			kmem_free((void *)args.norm);
 		return (error);
 	}
 
@@ -333,7 +347,8 @@ xfs_attr_set_int(
 			err2 = xfs_trans_commit(args.trans,
 						 XFS_TRANS_RELEASE_LOG_RES);
 			xfs_iunlock(dp, XFS_ILOCK_EXCL);
-
+			if (args.norm)
+				kmem_free((void *)args.norm);
 			return(error == 0 ? err2 : error);
 		}
 
@@ -398,6 +413,8 @@ xfs_attr_set_int(
 	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
 	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (args.norm)
+		kmem_free((void *)args.norm);
 
 	return(error);
 
@@ -406,6 +423,9 @@ out:
 		xfs_trans_cancel(args.trans,
 			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (args.norm)
+		kmem_free((void *)args.norm);
+
 	return(error);
 }
 
@@ -452,12 +472,15 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 	args.name = name->name;
 	args.namelen = name->len;
 	args.flags = flags;
-	args.hashval = xfs_da_hashname(args.name, args.namelen);
 	args.dp = dp;
 	args.firstblock = &firstblock;
 	args.flist = &flist;
 	args.total = 0;
 	args.whichfork = XFS_ATTR_FORK;
+	if (! xfs_sb_version_hasutf8(&mp->m_sb))
+		args.hashval = xfs_da_hashname(args.name, args.namelen);
+	else if ((error = mp->m_dirnameops->normhash(&args)) != 0)
+		return error;
 
 	/*
 	 * we have no control over the attribute names that userspace passes us
@@ -470,8 +493,11 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 	 * Attach the dquots to the inode.
 	 */
 	error = xfs_qm_dqattach(dp, 0);
-	if (error)
-		return error;
+	if (error) {
+		if (args.norm)
+			kmem_free((void *)args.norm);
+			return error;
+	}
 
 	/*
 	 * Start our first transaction of the day.
@@ -497,6 +523,8 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 				  XFS_ATTRRM_SPACE_RES(mp), 0);
 	if (error) {
 		xfs_trans_cancel(args.trans, 0);
+		if (args.norm)
+			kmem_free((void *)args.norm);
 		return(error);
 	}
 
@@ -546,6 +574,8 @@ xfs_attr_remove_int(xfs_inode_t *dp, struct xfs_name *name, int flags)
 	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
 	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (args.norm)
+		kmem_free((void *)args.norm);
 
 	return(error);
 
@@ -554,6 +584,9 @@ out:
 		xfs_trans_cancel(args.trans,
 			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (args.norm)
+		kmem_free((void *)args.norm);
+
 	return(error);
 }
 
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index f7f02ae..052a6a1 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -634,6 +634,7 @@ int
 xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
 {
 	xfs_inode_t *dp;
+	struct xfs_mount *mp;
 	xfs_attr_shortform_t *sf;
 	xfs_attr_sf_entry_t *sfe;
 	xfs_da_args_t nargs;
@@ -646,6 +647,7 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
 	trace_xfs_attr_sf_to_leaf(args);
 
 	dp = args->dp;
+	mp = dp->i_mount;
 	ifp = dp->i_afp;
 	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
 	size = be16_to_cpu(sf->hdr.totsize);
@@ -698,13 +700,18 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
 		nargs.namelen = sfe->namelen;
 		nargs.value = &sfe->nameval[nargs.namelen];
 		nargs.valuelen = sfe->valuelen;
-		nargs.hashval = xfs_da_hashname(sfe->nameval,
-						sfe->namelen);
 		nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(sfe->flags);
+		if (! xfs_sb_version_hasutf8(&mp->m_sb))
+			nargs.hashval = xfs_da_hashname(sfe->nameval,
+							sfe->namelen);
+		else if ((error = mp->m_dirnameops->normhash(&nargs)) != 0)
+			goto out;
 		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
 		ASSERT(error == ENOATTR);
 		error = xfs_attr3_leaf_add(bp, &nargs);
 		ASSERT(error != ENOSPC);
+		if (nargs.norm)
+			 kmem_free((void *)nargs.norm);
 		if (error)
 			goto out;
 		sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
diff --git a/libxfs/xfs_utf8.c b/libxfs/xfs_utf8.c
index f5cc231..5c69591 100644
--- a/libxfs/xfs_utf8.c
+++ b/libxfs/xfs_utf8.c
@@ -31,6 +31,7 @@
 #include "xfs_inode_fork.h"
 #include "xfs_bmap.h"
 #include "xfs_dir2.h"
+#include "xfs_attr_leaf.h"
 #include "xfs_trace.h"
 #include "xfs_utf8.h"
 #include "utf8norm.h"
@@ -72,6 +73,9 @@ xfs_utf8_normhash(
 	ssize_t		normlen;
 	int		c;
 
+	/* Don't normalize system attribute names. */
+	if (args->flags & (ATTR_ROOT|ATTR_SECURE))
+		goto blob;
 	nfkdi = utf8nfkdi(utf8version);
 	/* Failure to normalize is treated as a blob. */
 	if ((normlen = utf8nlen(nfkdi, (const char *)args->name,
@@ -173,6 +177,9 @@ xfs_utf8_ci_normhash(
 	ssize_t		normlen;
 	int		c;
 
+	/* Don't normalize system attribute names. */
+	if (args->flags & (ATTR_ROOT|ATTR_SECURE))
+		goto blob;
 	nfkdicf = utf8nfkdicf(utf8version);
 	/* Failure to normalize is treated as a blob. */
 	if ((normlen = utf8nlen(nfkdicf, (const char *)args->name,
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
