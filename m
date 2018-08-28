Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:38962 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727130AbeH1XSA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Aug 2018 19:18:00 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w7SJJDsm125075
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:55 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by aserp2120.oracle.com with ESMTP id 2m2y2pdwjn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:55 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w7SJOsSF031968
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:54 GMT
Received: from abhmp0018.oracle.com (abhmp0018.oracle.com [141.146.116.24])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w7SJOs96014905
        for <linux-xfs@vger.kernel.org>; Tue, 28 Aug 2018 19:24:54 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v8 09/28] xfs: Add xfs_has_attr and subroutines
Date: Tue, 28 Aug 2018 12:22:22 -0700
Message-Id: <1535484161-11059-10-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
References: <1535484161-11059-1-git-send-email-allison.henderson@oracle.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

This patch adds a new functions to check for the existence of
an attribute.  Subroutines are also added to handle the cases
of leaf blocks, nodes or shortform.  We will need this later
for delayed attributes since delayed operations cannot return
error codes.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c      | 80 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_attr.h      |  1 +
 fs/xfs/libxfs/xfs_attr_leaf.c | 34 ++++++++++++++++++
 fs/xfs/libxfs/xfs_attr_leaf.h |  1 +
 4 files changed, 116 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index afcb4e9..09c0de8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -52,6 +52,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args, bool roll_trans);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args, bool roll_trans);
+STATIC int xfs_leaf_has_attr(xfs_da_args_t *args);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -59,6 +60,7 @@ STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args, bool roll_trans);
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args, bool roll_trans);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args, bool roll_trans);
+STATIC int xfs_attr_node_hasname(xfs_da_args_t *args);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 
@@ -320,6 +322,29 @@ xfs_attr_set_args(
 }
 
 /*
+ * Return successful if attr is found, or ENOATTR if not
+ */
+int
+xfs_has_attr(
+	struct xfs_da_args      *args)
+{
+	struct xfs_inode        *dp = args->dp;
+	int                     error;
+
+	if (!xfs_inode_hasattr(dp))
+		error = -ENOATTR;
+	else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
+		error = xfs_shortform_has_attr(args);
+	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+		error = xfs_leaf_has_attr(args);
+	else
+		error = xfs_attr_node_hasname(args);
+
+	return error;
+}
+
+/*
  * Remove the attribute specified in @args.
  */
 int
@@ -857,6 +882,31 @@ xfs_attr_leaf_addname(
 }
 
 /*
+ * Return successful if attr is found, or ENOATTR if not
+ */
+STATIC int
+xfs_leaf_has_attr(
+	struct xfs_da_args      *args)
+{
+	struct xfs_inode        *dp;
+	struct xfs_buf          *bp;
+	int                     error = 0;
+
+	dp = args->dp;
+	args->blkno = 0;
+	error = xfs_attr3_leaf_read(args->trans, args->dp,
+			args->blkno, -1, &bp);
+	if (error)
+		return error;
+
+	error = xfs_attr3_leaf_lookup_int(bp, args);
+	error = (error == -ENOATTR) ? -ENOATTR : 0;
+	xfs_trans_brelse(args->trans, bp);
+
+	return error;
+}
+
+/*
  * Remove a name from the leaf attribute list structure
  *
  * This leaf block cannot have a "remote" value, we only call this routine
@@ -1192,6 +1242,36 @@ xfs_attr_node_addname(
 }
 
 /*
+ * Return successful if attr is found, or ENOATTR if not
+ */
+STATIC int
+xfs_attr_node_hasname(
+	struct xfs_da_args	*args)
+{
+	struct xfs_da_state	*state;
+	struct xfs_inode	*dp;
+	int			retval, error;
+
+	/*
+	 * Tie a string around our finger to remind us where we are.
+	 */
+	dp = args->dp;
+	state = xfs_da_state_alloc();
+	state->args = args;
+	state->mp = dp->i_mount;
+
+	/*
+	 * Search to see if name exists, and get back a pointer to it.
+	 */
+	error = xfs_da3_node_lookup_int(state, &retval);
+	if (error || (retval != -EEXIST)) {
+		if (error == 0)
+			error = retval;
+	}
+	return error;
+}
+
+/*
  * Remove a name from a B-tree attribute list.
  *
  * This will involve walking down the Btree, and may involve joining
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 5c49120..dcf1794 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -165,6 +165,7 @@ int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp,
 		 bool roll_trans);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
+int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args, bool roll_trans);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index d127f2c..43fafa9 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -624,6 +624,40 @@ xfs_attr_fork_remove(
 }
 
 /*
+ * Return successful if attr is found, or ENOATTR if not
+ */
+int
+xfs_shortform_has_attr(xfs_da_args_t *args)
+{
+	xfs_attr_shortform_t *sf;
+	xfs_attr_sf_entry_t *sfe;
+	int base, size = 0, end, i;
+	xfs_mount_t *mp;
+	xfs_inode_t *dp;
+
+	dp = args->dp;
+	mp = dp->i_mount;
+	base = sizeof(xfs_attr_sf_hdr_t);
+	sf = (xfs_attr_shortform_t *)dp->i_afp->if_u1.if_data;
+	sfe = &sf->list[0];
+	end = sf->hdr.count;
+	for (i = 0; i < end; sfe = XFS_ATTR_SF_NEXTENTRY(sfe),
+			base += size, i++) {
+		size = XFS_ATTR_SF_ENTSIZE(sfe);
+		if (sfe->namelen != args->namelen)
+			continue;
+		if (memcmp(sfe->nameval, args->name, args->namelen) != 0)
+			continue;
+		if (!xfs_attr_namesp_match(args->flags, sfe->flags))
+			continue;
+		break;
+	}
+	if (i == end)
+		return -ENOATTR;
+	return 0;
+}
+
+/*
  * Remove an attribute from the shortform attribute list structure.
  */
 int
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.h b/fs/xfs/libxfs/xfs_attr_leaf.h
index 9d830ec..98dd169 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.h
+++ b/fs/xfs/libxfs/xfs_attr_leaf.h
@@ -39,6 +39,7 @@ int	xfs_attr_shortform_getvalue(struct xfs_da_args *args);
 int	xfs_attr_shortform_to_leaf(struct xfs_da_args *args,
 			struct xfs_buf **leaf_bp);
 int	xfs_attr_shortform_remove(struct xfs_da_args *args);
+int	xfs_shortform_has_attr(struct xfs_da_args *args);
 int	xfs_attr_shortform_allfit(struct xfs_buf *bp, struct xfs_inode *dp);
 int	xfs_attr_shortform_bytesfit(struct xfs_inode *dp, int bytes);
 xfs_failaddr_t xfs_attr_shortform_verify(struct xfs_inode *ip);
-- 
2.7.4
