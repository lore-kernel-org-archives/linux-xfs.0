Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24759 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752220AbdHJBny (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2017 21:43:54 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v7A1hq3w012269
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:53 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v7A1hqko017792
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:52 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id v7A1hqmt017102
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2017 01:43:52 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [RFC PATCH 09/13] xfs: add parent attributes to link
Date: Wed,  9 Aug 2017 18:41:29 -0700
Message-Id: <1502329293-4091-10-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
References: <1502329293-4091-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Allison Henderson <allison.henderson@oracle.com>

From: Dave Chinner <dchinner@redhat.com>

[bfoster: rebase, use VFS inode fields, fix xfs_bmap_finish() usage]
[achender: rebased, changed __unint32_t to xfs_dir2_dataptr_t,
	   fixed null pointer bugs]

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
:100644 100644 ed13c67... 49e1187... M	fs/xfs/libxfs/xfs_attr.c
:100644 100644 88f7edc... 0707336... M	fs/xfs/libxfs/xfs_parent.c
:100644 100644 fad2fbd... 17fdd5f... M	fs/xfs/xfs_attr.h
:100644 100644 3557791... 09caea7... M	fs/xfs/xfs_inode.c
 fs/xfs/libxfs/xfs_attr.c   | 221 +++++++++++++++++++++++++++------------------
 fs/xfs/libxfs/xfs_parent.c |  43 +++++++++
 fs/xfs/xfs_attr.h          |  10 ++
 fs/xfs/xfs_inode.c         |  66 +++++++++++---
 4 files changed, 240 insertions(+), 100 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index ed13c67..49e1187 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -35,6 +35,7 @@
 #include "xfs_bmap_util.h"
 #include "xfs_bmap_btree.h"
 #include "xfs_attr.h"
+#include "xfs_attr_sf.h"
 #include "xfs_attr_leaf.h"
 #include "xfs_attr_remote.h"
 #include "xfs_error.h"
@@ -273,6 +274,129 @@ xfs_attr_set_first_parent(
 	return xfs_attr_leaf_addname(&args);
 }
 
+/*
+ * set the attribute specified in @args. In the case of the parent attribute
+ * being set, we do not want to roll the transaction on shortform-to-leaf
+ * conversion, as the attribute must be added in the same transaction as the
+ * parent directory modifications. Hence @roll_trans needs to be set
+ * appropriately to control whether the transaction is committed during this
+ * function.
+ */
+static int
+xfs_attr_set_args(
+	struct xfs_da_args	*args,
+	int			flags,
+	bool			roll_trans)
+{
+	struct xfs_inode	*dp = args->dp;
+	int			error = 0;
+
+	/*
+	 * If the attribute list is non-existent or a shortform list,
+	 * upgrade it to a single-leaf-block attribute list.
+	 */
+	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
+	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
+	     dp->i_d.di_anextents == 0)) {
+
+		/*
+		 * Build initial attribute list (if required).
+		 */
+		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
+			xfs_attr_shortform_create(args);
+
+		/*
+		 * Try to add the attr to the attribute list in the inode.
+		 */
+		error = xfs_attr_shortform_addname(args);
+		if (error != -ENOSPC) {
+			ASSERT(args->trans);
+			if (!error && (flags & ATTR_KERNOTIME) == 0)
+				xfs_trans_ichgtime(args->trans, dp,
+						   XFS_ICHGTIME_CHG);
+			goto out;
+		}
+
+		/*
+		 * It won't fit in the shortform, transform to a leaf block.
+		 * GROT: another possible req'mt for a double-split btree op.
+		 */
+		error = xfs_attr_shortform_to_leaf(args);
+		if (error)
+			goto out;
+		if (roll_trans) {
+			error = xfs_defer_finish(&args->trans, args->dfops, dp);
+			if (error) {
+				args->trans = NULL;
+				goto out;
+			}
+
+			/*
+			 * Commit the leaf transformation.  We'll need another
+			 * (linked) transaction to add the new attribute to the
+			 * leaf.
+			 */
+			error = xfs_trans_roll(&args->trans, dp);
+			if (error)
+				goto out;
+		}
+	}
+
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+		error = xfs_attr_leaf_addname(args);
+	else
+		error = xfs_attr_node_addname(args);
+	if (error)
+		goto out;
+
+	if ((flags & ATTR_KERNOTIME) == 0)
+		xfs_trans_ichgtime(args->trans, dp, XFS_ICHGTIME_CHG);
+
+	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
+out:
+	return error;
+}
+
+int
+xfs_attr_set_parent(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip,
+	struct xfs_parent_name_rec *rec,
+	int			reclen,
+	const char		*value,
+	int			valuelen,
+	struct xfs_defer_ops	*dfops,
+	xfs_fsblock_t		*firstblock)
+{
+	struct xfs_da_args	args;
+	int			flags = ATTR_PARENT;
+	int			local;
+	int			error;
+
+	ASSERT(XFS_IFORK_Q(ip));
+
+	tp->t_flags |= XFS_TRANS_RESERVE;
+
+	error = xfs_attr_args_init(&args, ip, (char *)rec, flags);
+	if (error)
+		return error;
+
+	args.name = (char *)rec;
+	args.namelen = reclen;
+	args.hashval = xfs_da_hashname(args.name, args.namelen);
+	args.value = (char *)value;
+	args.valuelen = valuelen;
+	args.firstblock = firstblock;
+	args.dfops = dfops;
+	args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
+	args.total = xfs_attr_calc_size(&args, &local);
+	args.trans = tp;
+	ASSERT(local);
+	args.trans = tp;
+
+	return xfs_attr_set_args(&args, flags, false);
+}
+
 int
 xfs_attr_set(
 	struct xfs_inode	*dp,
@@ -287,7 +411,7 @@ xfs_attr_set(
 	struct xfs_trans_res	tres;
 	xfs_fsblock_t		firstblock;
 	bool			rsvd = (flags & (ATTR_ROOT | ATTR_PARENT)) != 0;
-	int			error, err2, local;
+	int			error, local;
 
 	XFS_STATS_INC(mp, xs_attr_set);
 
@@ -340,89 +464,15 @@ xfs_attr_set(
 	error = xfs_trans_reserve_quota_nblks(args.trans, dp, args.total, 0,
 				rsvd ? XFS_QMOPT_RES_REGBLKS | XFS_QMOPT_FORCE_RES :
 				       XFS_QMOPT_RES_REGBLKS);
-	if (error) {
-		xfs_iunlock(dp, XFS_ILOCK_EXCL);
-		xfs_trans_cancel(args.trans);
-		return error;
-	}
+	if (error)
+		goto out_cancel_unlock;
 
 	xfs_trans_ijoin(args.trans, dp, 0);
+	xfs_defer_init(args.dfops, args.firstblock);
 
-	/*
-	 * If the attribute list is non-existent or a shortform list,
-	 * upgrade it to a single-leaf-block attribute list.
-	 */
-	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
-	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
-	     dp->i_d.di_anextents == 0)) {
-
-		/*
-		 * Build initial attribute list (if required).
-		 */
-		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
-			xfs_attr_shortform_create(&args);
-
-		/*
-		 * Try to add the attr to the attribute list in
-		 * the inode.
-		 */
-		error = xfs_attr_shortform_addname(&args);
-		if (error != -ENOSPC) {
-			/*
-			 * Commit the shortform mods, and we're done.
-			 * NOTE: this is also the error path (EEXIST, etc).
-			 */
-			ASSERT(args.trans != NULL);
-
-			/*
-			 * If this is a synchronous mount, make sure that
-			 * the transaction goes to disk before returning
-			 * to the user.
-			 */
-			if (mp->m_flags & XFS_MOUNT_WSYNC)
-				xfs_trans_set_sync(args.trans);
-
-			if (!error && (flags & ATTR_KERNOTIME) == 0) {
-				xfs_trans_ichgtime(args.trans, dp,
-							XFS_ICHGTIME_CHG);
-			}
-			err2 = xfs_trans_commit(args.trans);
-			xfs_iunlock(dp, XFS_ILOCK_EXCL);
-
-			return error ? error : err2;
-		}
-
-		/*
-		 * It won't fit in the shortform, transform to a leaf block.
-		 * GROT: another possible req'mt for a double-split btree op.
-		 */
-		xfs_defer_init(args.dfops, args.firstblock);
-		error = xfs_attr_shortform_to_leaf(&args);
-		if (!error)
-			error = xfs_defer_finish(&args.trans, args.dfops, dp);
-		if (error) {
-			args.trans = NULL;
-			xfs_defer_cancel(&dfops);
-			goto out;
-		}
-
-		/*
-		 * Commit the leaf transformation.  We'll need another (linked)
-		 * transaction to add the new attribute to the leaf.
-		 */
-
-		error = xfs_trans_roll(&args.trans, dp);
-		if (error)
-			goto out;
-
-	}
-
-	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
-		error = xfs_attr_leaf_addname(&args);
-	else
-		error = xfs_attr_node_addname(&args);
+	error = xfs_attr_set_args(&args, flags, true);
 	if (error)
-		goto out;
+		goto out_cancel_defer;
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -431,22 +481,21 @@ xfs_attr_set(
 	if (mp->m_flags & XFS_MOUNT_WSYNC)
 		xfs_trans_set_sync(args.trans);
 
-	if ((flags & ATTR_KERNOTIME) == 0)
-		xfs_trans_ichgtime(args.trans, dp, XFS_ICHGTIME_CHG);
-
 	/*
 	 * Commit the last in the sequence of transactions.
 	 */
 	xfs_trans_log_inode(args.trans, dp, XFS_ILOG_CORE);
 	error = xfs_trans_commit(args.trans);
-	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return error;
 
-out:
+out_cancel_defer:
+	xfs_defer_cancel(&dfops);
+out_cancel_unlock:
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	if (args.trans)
 		xfs_trans_cancel(args.trans);
-	xfs_iunlock(dp, XFS_ILOCK_EXCL);
 	return error;
 }
 
diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 88f7edc..0707336 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -96,3 +96,46 @@ xfs_parent_create(
 
 	return xfs_parent_create_nrec(tp, child, &nrec, dfops, firstblock);
 }
+
+static int
+xfs_parent_add_nrec(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*child,
+	struct xfs_parent_name_irec *nrec,
+	struct xfs_defer_ops	*dfops,
+	xfs_fsblock_t		*firstblock)
+{
+	struct xfs_parent_name_rec rec;
+
+	rec.p_ino = cpu_to_be64(nrec->p_ino);
+	rec.p_gen = cpu_to_be32(nrec->p_gen);
+	rec.p_diroffset = cpu_to_be32(nrec->p_diroffset);
+
+	return xfs_attr_set_parent(tp, child, &rec, sizeof(rec),
+				   nrec->p_name, nrec->p_namelen,
+				   dfops, firstblock);
+}
+
+/*
+ * Add a parent record to an inode with existing parent records.
+ */
+int
+xfs_parent_add(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*parent,
+	struct xfs_inode	*child,
+	struct xfs_name		*child_name,
+	uint32_t		diroffset,
+	struct xfs_defer_ops	*dfops,
+	xfs_fsblock_t		*firstblock)
+{
+	struct xfs_parent_name_irec nrec;
+
+	nrec.p_ino = parent->i_ino;
+	nrec.p_gen = VFS_I(parent)->i_generation;
+	nrec.p_diroffset = diroffset;
+	nrec.p_name = child_name->name;
+	nrec.p_namelen = child_name->len;
+
+	return xfs_parent_add_nrec(tp, child, &nrec, dfops, firstblock);
+}
diff --git a/fs/xfs/xfs_attr.h b/fs/xfs/xfs_attr.h
index fad2fbd..17fdd5f 100644
--- a/fs/xfs/xfs_attr.h
+++ b/fs/xfs/xfs_attr.h
@@ -167,4 +167,14 @@ int xfs_attr_set_first_parent(struct xfs_trans *tp, struct xfs_inode *ip,
 			      const char *value, int valuelen,
 			      struct xfs_defer_ops *dfops,
 			      xfs_fsblock_t *firstblock);
+
+int xfs_parent_add(struct xfs_trans *tp, struct xfs_inode *parent,
+		   struct xfs_inode *child, struct xfs_name *child_name,
+		   xfs_dir2_dataptr_t diroffset, struct xfs_defer_ops *dfops,
+		   xfs_fsblock_t *firstblock);
+int xfs_attr_set_parent(struct xfs_trans *tp, struct xfs_inode *ip,
+			struct xfs_parent_name_rec *rec, int reclen,
+			const char *value, int valuelen,
+			struct xfs_defer_ops *dfops, xfs_fsblock_t *firstblock);
+
 #endif	/* __XFS_ATTR_H__ */
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3557791..09caea7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1449,6 +1449,8 @@ xfs_link(
 	struct xfs_defer_ops	dfops;
 	xfs_fsblock_t           first_block;
 	int			resblks;
+	uint32_t		diroffset;
+	bool			first_parent = false;
 
 	trace_xfs_link(tdp, target_name);
 
@@ -1465,6 +1467,25 @@ xfs_link(
 	if (error)
 		goto std_return;
 
+	/*
+	 * If we have parent pointers and there is no attribute fork (i.e. we
+	 * are linking in a O_TMPFILE created inode) we need to add the
+	 * attribute fork to the inode. Because we may have an existing data
+	 * fork, we do this before we start the link transaction as adding an
+	 * attribute fork requires it's own transaction.
+	 */
+	if (xfs_sb_version_hasparent(&mp->m_sb) && !xfs_inode_hasattr(sip)) {
+		int sf_size = sizeof(struct xfs_attr_sf_hdr) +
+				XFS_ATTR_SF_ENTSIZE_BYNAME(
+					sizeof(struct xfs_parent_name_rec),
+					target_name->len);
+		ASSERT(VFS_I(sip)->i_nlink == 0);
+		error = xfs_bmap_add_attrfork(sip, sf_size, 0);
+		if (error)
+			goto std_return;
+		first_parent = true;
+	}
+
 	resblks = XFS_LINK_SPACE_RES(mp, target_name->len);
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_link, resblks, 0, 0, &tp);
 	if (error == -ENOSPC) {
@@ -1496,8 +1517,6 @@ xfs_link(
 			goto error_return;
 	}
 
-	xfs_defer_init(&dfops, &first_block);
-
 	/*
 	 * Handle initial link state of O_TMPFILE inode
 	 */
@@ -1507,36 +1526,55 @@ xfs_link(
 			goto error_return;
 	}
 
+	xfs_defer_init(&dfops, &first_block);
 	error = xfs_dir_createname(tp, tdp, target_name, sip->i_ino,
-				   &first_block, &dfops, resblks, NULL);
+				   &first_block, &dfops, resblks, &diroffset);
 	if (error)
-		goto error_return;
+		goto out_defer_cancel;
 	xfs_trans_ichgtime(tp, tdp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
 	error = xfs_bumplink(tp, sip);
 	if (error)
-		goto error_return;
+		goto out_defer_cancel;
 
 	/*
-	 * If this is a synchronous mount, make sure that the
-	 * link transaction goes to disk before returning to
-	 * the user.
+	 * If we have parent pointers, we now need to add the parent record to
+	 * the attribute fork of the inode. If this is the initial parent
+	 * atribute, we need to create it correctly, otherwise we can just add
+	 * the parent to the inode.
+	 */
+	if (xfs_sb_version_hasparent(&mp->m_sb)) {
+		if (first_parent)
+			error = xfs_parent_create(tp, tdp, sip, target_name,
+						  diroffset, &dfops,
+						  &first_block);
+		else
+			error = xfs_parent_add(tp, tdp, sip, target_name,
+					       diroffset, &dfops,
+					       &first_block);
+		if (error)
+			goto out_defer_cancel;
+	}
+
+	/*
+	 * If this is a synchronous mount, make sure that the link transaction
+	 * goes to disk before returning to the user.
 	 */
 	if (mp->m_flags & (XFS_MOUNT_WSYNC|XFS_MOUNT_DIRSYNC))
 		xfs_trans_set_sync(tp);
 
 	error = xfs_defer_finish(&tp, &dfops, NULL);
-	if (error) {
-		xfs_defer_cancel(&dfops);
-		goto error_return;
-	}
+	if (error)
+		goto out_defer_cancel;
 
 	return xfs_trans_commit(tp);
 
- error_return:
+out_defer_cancel:
+	xfs_defer_cancel(&dfops);
+error_return:
 	xfs_trans_cancel(tp);
- std_return:
+std_return:
 	return error;
 }
 
-- 
2.7.4

