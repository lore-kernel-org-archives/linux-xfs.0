Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:59916 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726833AbeH1XSB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Aug 2018 19:18:01 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7SJJDlJ080917
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:56 GMT
Received: from aserv0021.oracle.com (aserv0021.oracle.com [141.146.126.233])
        by userp2120.oracle.com with ESMTP id 2m2yrq5thn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:55 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserv0021.oracle.com (8.14.4/8.14.4) with ESMTP id w7SJOtQO011458
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:55 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id w7SJOtsq003474
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:55 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v8 11/28] xfs: Roll delayed attr operations by returning EAGAIN
Date: Tue, 28 Aug 2018 12:22:24 -0700
Message-Id: <1535484161-11059-12-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
References: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch modifies xfs_attr_set_args to return -EAGAIN
when a transaction needs to be rolled.  A state parameter
is used to keep track of where we left off before the return.
All functions currently calling xfs_attr_set_args are modified
to use the deferred attr operation, or handle the -EAGAIN
return code

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 43 ++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_attr.h |  2 +-
 fs/xfs/xfs_attr_item.c   | 41 ++++++++++++++++++++++++++++++------
 fs/xfs/xfs_trans.h       |  2 ++
 fs/xfs/xfs_trans_attr.c  | 55 ++++++++++++++++++++++++++++--------------------
 5 files changed, 103 insertions(+), 40 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 09c0de8..0e5bce9 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -237,12 +237,20 @@ int
 xfs_attr_set_args(
 	struct xfs_da_args	*args,
 	struct xfs_buf          **leaf_bp,
+	xfs_attr_state_t	*state,
 	bool			roll_trans)
 {
 	struct xfs_inode	*dp = args->dp;
 	int			error = 0;
 	int			sf_size;
 
+	switch (*state) {
+	case (XFS_ATTR_STATE1):
+		goto state1;
+	case (XFS_ATTR_STATE2):
+		goto state2;
+	}
+
 	/*
 	 * New inodes setting the parent pointer attr will
 	 * not have an attribute fork yet. So set the attribute
@@ -263,7 +271,6 @@ xfs_attr_set_args(
 	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
 	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
 	     dp->i_d.di_anextents == 0)) {
-
 		/*
 		 * Build initial attribute list (if required).
 		 */
@@ -277,6 +284,9 @@ xfs_attr_set_args(
 		if (error != -ENOSPC)
 			goto out;
 
+		*state = XFS_ATTR_STATE1;
+		return -EAGAIN;
+state1:
 		/*
 		 * It won't fit in the shortform, transform to a leaf block.
 		 * GROT: another possible req'mt for a double-split btree op.
@@ -285,14 +295,14 @@ xfs_attr_set_args(
 		if (error)
 			goto out;
 
-		if (roll_trans) {
-			/*
-			 * Prevent the leaf buffer from being unlocked so that a
-			 * concurrent AIL push cannot grab the half-baked leaf
-			 * buffer and run into problems with the write verifier.
-			 */
-			xfs_trans_bhold(args->trans, *leaf_bp);
+		/*
+		 * Prevent the leaf buffer from being unlocked so that a
+		 * concurrent AIL push cannot grab the half-baked leaf
+		 * buffer and run into problems with the write verifier.
+		 */
+		xfs_trans_bhold(args->trans, *leaf_bp);
 
+		if (roll_trans) {
 			error = xfs_defer_finish(&args->trans);
 			if (error)
 				goto out;
@@ -308,6 +318,12 @@ xfs_attr_set_args(
 			xfs_trans_bjoin(args->trans, *leaf_bp);
 			*leaf_bp = NULL;
 		}
+
+		*state = XFS_ATTR_STATE2;
+		return -EAGAIN;
+state2:
+		if (*leaf_bp != NULL)
+			xfs_trans_brelse(args->trans, *leaf_bp);
 	}
 
 	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
@@ -440,7 +456,9 @@ xfs_attr_set(
 	}
 
 	xfs_trans_ijoin(args.trans, dp, 0);
-	error = xfs_attr_set_args(&args, &leaf_bp, true);
+
+	error = xfs_attr_set_deferred(dp, args.trans, name, strlen(name),
+			value, valuelen, flags);
 	if (error)
 		goto out;
 
@@ -570,8 +588,13 @@ xfs_attr_remove(
 	 */
 	xfs_trans_ijoin(args.trans, dp, 0);
 
-	error = xfs_attr_remove_args(&args, true);
+	error = xfs_has_attr(&args);
+	if (error)
+		goto out;
+
 
+	error = xfs_attr_remove_deferred(dp, args.trans,
+			name, strlen(name), flags);
 	if (error)
 		goto out;
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 38ba5df..76fad8f 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -178,7 +178,7 @@ int xfs_attr_get(struct xfs_inode *ip, const unsigned char *name,
 int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 		 unsigned char *value, int valuelen, int flags);
 int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp,
-		 bool roll_trans);
+		 xfs_attr_state_t *state, bool roll_trans);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
 int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args, bool roll_trans);
diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 56fc0b0..b8db2da 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -475,8 +475,11 @@ xfs_attri_recover(
 	struct xfs_attri_log_format	*attrp;
 	struct xfs_trans_res		tres;
 	int				local;
-	int				error = 0;
+	int				error, err2 = 0;
 	int				rsvd = 0;
+	xfs_attr_state_t		state = 0;
+	struct xfs_buf			*leaf_bp = NULL;
+
 
 	ASSERT(!test_bit(XFS_ATTRI_RECOVERED, &attrip->flags));
 
@@ -551,14 +554,40 @@ xfs_attri_recover(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
 	xfs_trans_ijoin(args.trans, ip, 0);
-	error = xfs_trans_attr(&args, attrdp, attrp->alfi_op_flags);
-	if (error)
-		goto abort_error;
 
+	do {
+		leaf_bp = NULL;
+
+		error = xfs_trans_attr(&args, attrdp, &leaf_bp, &state,
+				attrp->alfi_op_flags);
+		if (error && error != -EAGAIN)
+			goto abort_error;
+
+		xfs_trans_log_inode(args.trans, ip,
+				XFS_ILOG_CORE | XFS_ILOG_ADATA);
+
+		err2 = xfs_trans_commit(args.trans);
+		if (err2) {
+			error = err2;
+			goto abort_error;
+		}
+
+		if (error == -EAGAIN) {
+			err2 = xfs_trans_alloc(mp, &tres, args.total, 0,
+				XFS_TRANS_PERM_LOG_RES, &args.trans);
+			if (err2) {
+				error = err2;
+				goto abort_error;
+			}
+			xfs_trans_ijoin(args.trans, ip, 0);
+		}
+
+	} while (error == -EAGAIN);
+
+	if (leaf_bp)
+		xfs_trans_brelse(args.trans, leaf_bp);
 
 	set_bit(XFS_ATTRI_RECOVERED, &attrip->flags);
-	xfs_trans_log_inode(args.trans, ip, XFS_ILOG_CORE | XFS_ILOG_ADATA);
-	error = xfs_trans_commit(args.trans);
 	xfs_iunlock(ip, XFS_ILOCK_EXCL);
 	return error;
 
diff --git a/fs/xfs/xfs_trans.h b/fs/xfs/xfs_trans.h
index 433bada..cc38d45 100644
--- a/fs/xfs/xfs_trans.h
+++ b/fs/xfs/xfs_trans.h
@@ -240,6 +240,8 @@ xfs_trans_get_attrd(struct xfs_trans *tp,
 		    struct xfs_attri_log_item *attrip);
 int xfs_trans_attr(	struct xfs_da_args *args,
 			struct xfs_attrd_log_item *attrdp,
+			struct xfs_buf **leaf_bp,
+			void *state,
 			uint32_t attr_op_flags);
 
 int		xfs_trans_commit(struct xfs_trans *);
diff --git a/fs/xfs/xfs_trans_attr.c b/fs/xfs/xfs_trans_attr.c
index 87607b2..db6cb6d 100644
--- a/fs/xfs/xfs_trans_attr.c
+++ b/fs/xfs/xfs_trans_attr.c
@@ -67,10 +67,11 @@ int
 xfs_trans_attr(
 	struct xfs_da_args		*args,
 	struct xfs_attrd_log_item	*attrdp,
+	struct xfs_buf			**leaf_bp,
+	void				*state,
 	uint32_t			op_flags)
 {
 	int				error;
-	struct xfs_buf			*leaf_bp = NULL;
 
 	error = xfs_qm_dqattach_locked(args->dp, 0);
 	if (error)
@@ -79,7 +80,8 @@ xfs_trans_attr(
 	switch (op_flags) {
 		case XFS_ATTR_OP_FLAGS_SET:
 			args->op_flags |= XFS_DA_OP_ADDNAME;
-			error = xfs_attr_set_args(args,&leaf_bp, false);
+			error = xfs_attr_set_args(args, leaf_bp,
+					(xfs_attr_state_t *)state, false);
 			break;
 		case XFS_ATTR_OP_FLAGS_REMOVE:
 			ASSERT(XFS_IFORK_Q((args->dp)));
@@ -89,11 +91,6 @@ xfs_trans_attr(
 			error = -EFSCORRUPTED;
 	}
 
-	if (error) {
-		if (leaf_bp)
-			xfs_trans_brelse(args->trans, leaf_bp);
-	}
-
 	/*
 	 * Mark the transaction dirty, even on error. This ensures the
 	 * transaction is aborted, which:
@@ -195,27 +192,39 @@ xfs_attr_finish_item(
 	char				*name_value;
 	int				error;
 	int				local;
-	struct xfs_da_args		args;
+	struct xfs_da_args		*args;
 
 	attr = container_of(item, struct xfs_attr_item, xattri_list);
-	name_value = ((char *)attr) + sizeof(struct xfs_attr_item);
-
-	error = xfs_attr_args_init(&args, attr->xattri_ip, name_value,
-					attr->xattri_flags);
-	if (error)
-		goto out;
+	args = &attr->xattri_args;
+
+	if (attr->xattri_state == 0) {
+		/* Only need to initialize args context once */
+		name_value = ((char *)attr) + sizeof(struct xfs_attr_item);
+		error = xfs_attr_args_init(args, attr->xattri_ip, name_value,
+						attr->xattri_flags);
+		if (error)
+			goto out;
+
+		args->hashval = xfs_da_hashname(args->name, args->namelen);
+		args->value = &name_value[attr->xattri_name_len];
+		args->valuelen = attr->xattri_value_len;
+		args->op_flags = XFS_DA_OP_OKNOENT;
+		args->total = xfs_attr_calc_size(args, &local);
+		attr->xattri_leaf_bp = NULL;
+	}
 
-	args.hashval = xfs_da_hashname(args.name, args.namelen);
-	args.value = &name_value[attr->xattri_name_len];
-	args.valuelen = attr->xattri_value_len;
-	args.op_flags = XFS_DA_OP_OKNOENT;
-	args.total = xfs_attr_calc_size(&args, &local);
-	args.trans = tp;
+	/*
+	 * Always reset trans after EAGAIN cycle
+	 * since the transaction is new
+	 */
+	args->trans = tp;
 
-	error = xfs_trans_attr(&args, done_item,
-			attr->xattri_op_flags);
+	error = xfs_trans_attr(args, done_item, &attr->xattri_leaf_bp,
+			&attr->xattri_state, attr->xattri_op_flags);
 out:
-	kmem_free(attr);
+	if (error != -EAGAIN)
+		kmem_free(attr);
+
 	return error;
 }
 
-- 
2.7.4
