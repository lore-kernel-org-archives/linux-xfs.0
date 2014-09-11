Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 507FA7F85
	for <xfs@oss.sgi.com>; Thu, 11 Sep 2014 15:50:24 -0500 (CDT)
Date: Thu, 11 Sep 2014 15:50:23 -0500
From: Ben Myers <bpm@sgi.com>
Subject: [PATCH 9/9] xfs: apply utf-8 normalization rules to user extended
	attribute names
Message-ID: <20140911205023.GI13262@sgi.com>
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
 fs/xfs/libxfs/xfs_attr.c      | 56 ++++++++++++++++++++++++++++++++++++-------
 fs/xfs/libxfs/xfs_attr_leaf.c | 11 +++++++--
 fs/xfs/xfs_attr_list.c        | 11 ++++++++-
 fs/xfs/xfs_utf8.c             |  7 ++++++
 4 files changed, 74 insertions(+), 11 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 353fb42..68e7ce3 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -83,12 +83,14 @@ xfs_attr_args_init(
 	const unsigned char	*name,
 	int			flags)
 {
+	struct xfs_mount	*mp = dp->i_mount;
+	int			error;
 
 	if (!name)
 		return -EINVAL;
 
 	memset(args, 0, sizeof(*args));
-	args->geo = dp->i_mount->m_attr_geo;
+	args->geo = mp->m_attr_geo;
 	args->whichfork = XFS_ATTR_FORK;
 	args->dp = dp;
 	args->flags = flags;
@@ -97,7 +99,11 @@ xfs_attr_args_init(
 	if (args->namelen >= MAXNAMELEN)
 		return -EFAULT;		/* match IRIX behaviour */
 
-	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	if (!xfs_sb_version_hasutf8(&mp->m_sb))
+		args->hashval = xfs_da_hashname(args->name, args->namelen);
+	else if ((error = mp->m_dirnameops->normhash(args)) != 0)
+		return error;
+
 	return 0;
 }
 
@@ -154,6 +160,9 @@ xfs_attr_get(
 		error = xfs_attr_node_get(&args);
 	xfs_iunlock(ip, lock_mode);
 
+	if (args.norm)
+		kmem_free(args.norm);
+
 	*valuelenp = args.valuelen;
 	return error == -EEXIST ? 0 : error;
 }
@@ -216,8 +225,11 @@ xfs_attr_set(
 		return -EIO;
 
 	error = xfs_attr_args_init(&args, dp, name, flags);
-	if (error)
+	if (error) {
+		if (args.norm)
+			kmem_free(args.norm);
 		return error;
+	}
 
 	args.value = value;
 	args.valuelen = valuelen;
@@ -227,8 +239,11 @@ xfs_attr_set(
 	args.total = xfs_attr_calc_size(&args, &local);
 
 	error = xfs_qm_dqattach(dp, 0);
-	if (error)
+	if (error) {
+		if (args.norm)
+			kmem_free(args.norm);
 		return error;
+	}
 
 	/*
 	 * If the inode doesn't have an attribute fork, add one.
@@ -239,8 +254,11 @@ xfs_attr_set(
 			XFS_ATTR_SF_ENTSIZE_BYNAME(args.namelen, valuelen);
 
 		error = xfs_bmap_add_attrfork(dp, sf_size, rsvd);
-		if (error)
+		if (error) {
+			if (args.norm)
+				kmem_free(args.norm);
 			return error;
+		}
 	}
 
 	/*
@@ -270,6 +288,8 @@ xfs_attr_set(
 	error = xfs_trans_reserve(args.trans, &tres, args.total, 0);
 	if (error) {
 		xfs_trans_cancel(args.trans, 0);
+		if (args.norm)
+			kmem_free(args.norm);
 		return error;
 	}
 	xfs_ilock(dp, XFS_ILOCK_EXCL);
@@ -280,6 +300,8 @@ xfs_attr_set(
 	if (error) {
 		xfs_iunlock(dp, XFS_ILOCK_EXCL);
 		xfs_trans_cancel(args.trans, XFS_TRANS_RELEASE_LOG_RES);
+		if (args.norm)
+			kmem_free(args.norm);
 		return error;
 	}
 
@@ -327,6 +349,8 @@ xfs_attr_set(
 						 XFS_TRANS_RELEASE_LOG_RES);
 			xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
+			if (args.norm)
+				kmem_free(args.norm);
 			return error ? error : err2;
 		}
 
@@ -388,7 +412,8 @@ xfs_attr_set(
 	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
 	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
-
+	if (args.norm)
+		kmem_free(args.norm);
 	return error;
 
 out:
@@ -397,6 +422,8 @@ out:
 			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
 	}
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (args.norm)
+		kmem_free(args.norm);
 	return error;
 }
 
@@ -425,8 +452,11 @@ xfs_attr_remove(
 		return -ENOATTR;
 
 	error = xfs_attr_args_init(&args, dp, name, flags);
-	if (error)
+	if (error) {
+		if (args.norm)
+			kmem_free(args.norm);
 		return error;
+	}
 
 	args.firstblock = &firstblock;
 	args.flist = &flist;
@@ -439,8 +469,11 @@ xfs_attr_remove(
 	args.op_flags = XFS_DA_OP_OKNOENT;
 
 	error = xfs_qm_dqattach(dp, 0);
-	if (error)
+	if (error) {
+		if (args.norm)
+			kmem_free(args.norm);
 		return error;
+	}
 
 	/*
 	 * Start our first transaction of the day.
@@ -466,6 +499,8 @@ xfs_attr_remove(
 				  XFS_ATTRRM_SPACE_RES(mp), 0);
 	if (error) {
 		xfs_trans_cancel(args.trans, 0);
+		if (args.norm)
+			kmem_free(args.norm);
 		return error;
 	}
 
@@ -506,6 +541,8 @@ xfs_attr_remove(
 	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
 	error = xfs_trans_commit(args.trans, XFS_TRANS_RELEASE_LOG_RES);
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (args.norm)
+		kmem_free(args.norm);
 
 	return error;
 
@@ -515,6 +552,9 @@ out:
 			XFS_TRANS_RELEASE_LOG_RES|XFS_TRANS_ABORT);
 	}
 	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+	if (args.norm)
+		kmem_free(args.norm);
+
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index b1f73db..c991a88 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -661,6 +661,7 @@ int
 xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
 {
 	xfs_inode_t *dp;
+	struct xfs_mount *mp;
 	xfs_attr_shortform_t *sf;
 	xfs_attr_sf_entry_t *sfe;
 	xfs_da_args_t nargs;
@@ -673,6 +674,7 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
 	trace_xfs_attr_sf_to_leaf(args);
 
 	dp = args->dp;
+	mp = dp->i_mount;
 	ifp = dp->i_afp;
 	sf = (xfs_attr_shortform_t *)ifp->if_u1.if_data;
 	size = be16_to_cpu(sf->hdr.totsize);
@@ -726,13 +728,18 @@ xfs_attr_shortform_to_leaf(xfs_da_args_t *args)
 		nargs.namelen = sfe->namelen;
 		nargs.value = &sfe->nameval[nargs.namelen];
 		nargs.valuelen = sfe->valuelen;
-		nargs.hashval = xfs_da_hashname(sfe->nameval,
-						sfe->namelen);
 		nargs.flags = XFS_ATTR_NSP_ONDISK_TO_ARGS(sfe->flags);
+		if (!xfs_sb_version_hasutf8(&mp->m_sb))
+			nargs.hashval = xfs_da_hashname(sfe->nameval,
+							sfe->namelen);
+		else if ((error = mp->m_dirnameops->normhash(&nargs)) != 0)
+			goto out;
 		error = xfs_attr3_leaf_lookup_int(bp, &nargs); /* set a->index */
 		ASSERT(error == -ENOATTR);
 		error = xfs_attr3_leaf_add(bp, &nargs);
 		ASSERT(error != -ENOSPC);
+		if (nargs.norm)
+			kmem_free(nargs.norm);
 		if (error)
 			goto out;
 		sfe = XFS_ATTR_SF_NEXTENTRY(sfe);
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 62db83a..4075d54 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -76,12 +76,14 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 	xfs_attr_shortform_t *sf;
 	xfs_attr_sf_entry_t *sfe;
 	xfs_inode_t *dp;
+	struct xfs_mount *mp;
 	int sbsize, nsbuf, count, i;
 	int error;
 
 	ASSERT(context != NULL);
 	dp = context->dp;
 	ASSERT(dp != NULL);
+	mp = dp->i_mount;
 	ASSERT(dp->i_afp != NULL);
 	sf = (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
 	ASSERT(sf != NULL);
@@ -154,7 +156,14 @@ xfs_attr_shortform_list(xfs_attr_list_context_t *context)
 		}
 
 		sbp->entno = i;
-		sbp->hash = xfs_da_hashname(sfe->nameval, sfe->namelen);
+		/* ATTR_ROOT and ATTR_SECURE are never normalized. */
+		if (!xfs_sb_version_hasutf8(&mp->m_sb) ||
+		    (sfe->flags & (ATTR_ROOT|ATTR_SECURE))) {
+			sbp->hash = xfs_da_hashname(sfe->nameval, sfe->namelen);
+		} else {
+			sbp->hash = mp->m_dirnameops->hashname(sfe->nameval,
+							       sfe->namelen);
+		}
 		sbp->name = sfe->nameval;
 		sbp->namelen = sfe->namelen;
 		/* These are bytes, and both on-disk, don't endian-flip */
diff --git a/fs/xfs/xfs_utf8.c b/fs/xfs/xfs_utf8.c
index 7c18e43..8df05fe 100644
--- a/fs/xfs/xfs_utf8.c
+++ b/fs/xfs/xfs_utf8.c
@@ -38,6 +38,7 @@
 #include "xfs_inode.h"
 #include "xfs_inode_item.h"
 #include "xfs_bmap.h"
+#include "xfs_attr.h"
 #include "xfs_error.h"
 #include "xfs_trace.h"
 #include "xfs_utf8.h"
@@ -80,6 +81,9 @@ xfs_utf8_normhash(
 	ssize_t		normlen;
 	int		c;
 
+	/* Don't normalize system attribute names. */
+	if (args->flags & (ATTR_ROOT|ATTR_SECURE))
+		goto blob;
 	nfkdi = utf8nfkdi(utf8version);
 	/* Failure to normalize is treated as a blob. */
 	if ((normlen = utf8nlen(nfkdi, args->name, args->namelen)) < 0)
@@ -179,6 +183,9 @@ xfs_utf8_ci_normhash(
 	ssize_t		normlen;
 	int		c;
 
+	/* Don't normalize system attribute names. */
+	if (args->flags & (ATTR_ROOT|ATTR_SECURE))
+		goto blob;
 	nfkdicf = utf8nfkdicf(utf8version);
 	/* Failure to normalize is treated as a blob. */
 	if ((normlen = utf8nlen(nfkdicf, args->name, args->namelen)) < 0)
-- 
1.7.12.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
