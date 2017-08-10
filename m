Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24761 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752232AbdHJBny (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2017 21:43:54 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7A1hrkG012274
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:54 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id v7A1hrcO012969
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:53 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7A1hrga017105
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:53 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [RFC PATCH 10/13] xfs: remove parent pointers in unlink
Date: Wed,  9 Aug 2017 18:41:30 -0700
Message-Id: <1502329293-4091-11-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
References: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>

From: Dave Chinner <dchinner@redhat.com>

[bfoster: rebase, use VFS inode generation]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t
	   implemented xfs_attr_remove_parent]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
:100644 100644 49e1187... 80431cb... M	fs/xfs/libxfs/xfs_attr.c
:100644 100644 0707336... ca695c4... M	fs/xfs/libxfs/xfs_parent.c
:100644 100644 17fdd5f... 374e8da... M	fs/xfs/xfs_attr.h
:100644 100644 09caea7... 0654ad8b.. M	fs/xfs/xfs_inode.c
:100644 100644 f013c893.. 6dcd89a... M	fs/xfs/xfs_qm.c
:100644 100644 2975a82... 9976369... M	fs/xfs/xfs_qm.h
 fs/xfs/libxfs/xfs_attr.c   | 76 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_parent.c | 22 ++++++++++++++
 fs/xfs/xfs_attr.h          |  7 +++++
 fs/xfs/xfs_inode.c         | 10 +++++-
 fs/xfs/xfs_qm.c            |  2 +-
 fs/xfs/xfs_qm.h            |  1 +
 6 files changed, 116 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 49e1187..80431cb 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -42,6 +42,7 @@
 #include "xfs_quota.h"
 #include "xfs_trans_space.h"
 #include "xfs_trace.h"
+#include "xfs_qm.h"
 
 /*
  * xfs_attr.c
@@ -499,6 +500,81 @@ xfs_attr_set(
 	return error;
 }
 
+int
+xfs_attr_remove_parent(
+	struct xfs_trans		*tp,
+	struct xfs_inode		*dp,
+	struct xfs_parent_name_rec	*rec,
+	int				reclen,
+	struct xfs_defer_ops		*dfops,
+	xfs_fsblock_t			*firstblock)
+{
+	int flags = ATTR_PARENT;
+	char *name = (char *)rec;
+	struct xfs_mount        *mp = dp->i_mount;
+	struct xfs_da_args      args;
+	int                     error;
+	int                     rsvd = 0;
+
+	XFS_STATS_INC(mp, xs_attr_remove);
+
+	if (XFS_FORCED_SHUTDOWN(dp->i_mount))
+		return -EIO;
+
+	error = xfs_attr_args_init(&args, dp, name, flags);
+	if (error)
+		return error;
+
+	args.firstblock = firstblock;
+	args.dfops = dfops;
+	args.name = (char *)rec;
+	args.namelen = reclen;
+
+	/*
+	 * we have no control over the attribute names that userspace passes us
+	 * to remove, so we have to allow the name lookup prior to attribute
+	 * removal to fail.
+	 */
+	args.op_flags = XFS_DA_OP_OKNOENT;
+
+	if (xfs_qm_need_dqattach(dp)) {
+		error = xfs_qm_dqattach_locked(dp, 0);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Root fork attributes can use reserved data blocks for this
+	 * operation if necessary
+	 */
+	if (flags & (ATTR_ROOT | ATTR_PARENT))
+		rsvd = XFS_TRANS_RESERVE;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_attrrm,
+				XFS_ATTRRM_SPACE_RES(mp), 0, rsvd, &args.trans);
+	if (error)
+		return error;
+
+	if (!xfs_inode_hasattr(dp))
+		error = -ENOATTR;
+	else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
+		error = xfs_attr_shortform_remove(&args);
+	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+		error = xfs_attr_leaf_removename(&args);
+	else
+		error = xfs_attr_node_removename(&args);
+
+	/*
+	 * If this is a synchronous mount, make sure that the
+	 * transaction goes to disk before returning to the user.
+	 */
+	if (!error && mp->m_flags & XFS_MOUNT_WSYNC)
+		xfs_trans_set_sync(args.trans);
+
+	return error;
+}
+
 /*
  * Generic handler routine to remove a name from an attribute list.
  * Transitions attribute list from Btree to shortform as necessary.
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 0707336..ca695c4 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -139,3 +139,25 @@ xfs_parent_add(
 
 	return xfs_parent_add_nrec(tp, child, &nrec, dfops, firstblock);
 }
+
+/*
+ * Remove a parent record from a child inode.
+ */
+int
+xfs_parent_remove(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*parent,
+	struct xfs_inode	*child,
+	xfs_dir2_dataptr_t	diroffset,
+	struct xfs_defer_ops	*dfops,
+	xfs_fsblock_t		*firstblock)
+{
+	struct xfs_parent_name_rec rec;
+
+	rec.p_ino = cpu_to_be64(parent->i_ino);
+	rec.p_gen = cpu_to_be32(VFS_I(parent)->i_generation);
+	rec.p_diroffset = cpu_to_be32(diroffset);
+
+	return xfs_attr_remove_parent(tp, child, &rec, sizeof(rec),
+				      dfops, firstblock);
+}
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index 17fdd5f..374e8da 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -177,4 +177,11 @@ int xfs_attr_set_parent(struct xfs_trans *tp, struct xfs_inode *ip,
 			const char *value, int valuelen,
 			struct xfs_defer_ops *dfops, xfs_fsblock_t *firstblock);
 
+int xfs_parent_remove(struct xfs_trans *tp, struct xfs_inode *parent,
+		      struct xfs_inode *child, xfs_dir2_dataptr_t diroffset,
+		      struct xfs_defer_ops *dfops, xfs_fsblock_t *firstblock);
+int xfs_attr_remove_parent(struct xfs_trans *tp, struct xfs_inode *ip,
+			struct xfs_parent_name_rec *rec, int reclen,
+			struct xfs_defer_ops *dfops, xfs_fsblock_t *firstblock);
+
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 09caea7..0654ad8b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -2594,6 +2594,7 @@ xfs_remove(
 	struct xfs_defer_ops	dfops;
 	xfs_fsblock_t           first_block;
 	uint			resblks;
+	uint32_t		dir_offset;
 
 	trace_xfs_remove(dp, name);
 
@@ -2674,12 +2675,19 @@ xfs_remove(
 
 	xfs_defer_init(&dfops, &first_block);
 	error = xfs_dir_removename(tp, dp, name, ip->i_ino, &first_block,
-				   &dfops, resblks, NULL);
+				   &dfops, resblks, &dir_offset);
 	if (error) {
 		ASSERT(error != -ENOENT);
 		goto out_bmap_cancel;
 	}
 
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		error = xfs_parent_remove(tp, dp, ip, dir_offset, &dfops,
+					  &first_block);
+		if (error)
+			goto out_bmap_cancel;
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index f013c893..6dcd89a 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -305,7 +305,7 @@ xfs_qm_dqattach_one(
 	return 0;
 }
 
-static bool
+bool
 xfs_qm_need_dqattach(
 	struct xfs_inode	*ip)
 {
diff --git a/fs/xfs/xfs_qm.h b/fs/xfs/xfs_qm.h
index 2975a82..9976369 100644
--- a/fs/xfs/xfs_qm.h
+++ b/fs/xfs/xfs_qm.h
@@ -176,6 +176,7 @@ extern int		xfs_qm_scall_setqlim(struct xfs_mount *, xfs_dqid_t, uint,
 					struct qc_dqblk *);
 extern int		xfs_qm_scall_quotaon(struct xfs_mount *, uint);
 extern int		xfs_qm_scall_quotaoff(struct xfs_mount *, uint);
+extern bool		xfs_qm_need_dqattach(struct xfs_inode *ip);
 
 static inline struct xfs_def_quota *
 xfs_get_defquota(struct xfs_dquot *dqp, struct xfs_quotainfo *qi)
-- 
2.7.4

