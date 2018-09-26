Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:48560 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727157AbeIZQiC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Sep 2018 12:38:02 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id w8QANgRb037003
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:46 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2120.oracle.com with ESMTP id 2mnvtur9be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:46 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id w8QAPj2J027109
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:45 GMT
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id w8QAPju2018421
        for <linux-xfs@vger.kernel.org>; Wed, 26 Sep 2018 10:25:45 GMT
From: Allison Henderson <allison.henderson@oracle.com>
Subject: [PATCH v3 08/30] xfsprogs: Add xfs_has_attr and subroutines
Date: Wed, 26 Sep 2018 03:23:11 -0700
Message-Id: <1537957413-10630-9-git-send-email-allison.henderson@oracle.com>
In-Reply-To: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
References: <1537957413-10630-1-git-send-email-allison.henderson@oracle.com>
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
 libxfs/xfs_attr.c      | 78 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_attr.h      |  1 +
 libxfs/xfs_attr_leaf.c | 33 +++++++++++++++++++++
 libxfs/xfs_attr_leaf.h |  1 +
 4 files changed, 113 insertions(+)

diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index d50b5a1..ad0c5cd 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -48,6 +48,7 @@ STATIC int xfs_attr_shortform_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_get(xfs_da_args_t *args);
 STATIC int xfs_attr_leaf_addname(xfs_da_args_t *args, bool roll_trans);
 STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args, bool roll_trans);
+STATIC int xfs_leaf_has_attr(xfs_da_args_t *args);
 
 /*
  * Internal routines when attribute list is more than one block.
@@ -55,6 +56,7 @@ STATIC int xfs_attr_leaf_removename(xfs_da_args_t *args, bool roll_trans);
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args, bool roll_trans);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args, bool roll_trans);
+STATIC int xfs_attr_node_hasname(xfs_da_args_t *args);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
 STATIC int xfs_attr_refillstate(xfs_da_state_t *state);
 
@@ -316,6 +318,29 @@ out:
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
@@ -853,6 +878,29 @@ out_defer_cancel:
 }
 
 /*
+ * Return successful if attr is found, or ENOATTR if not
+ */
+STATIC int
+xfs_leaf_has_attr(
+	struct xfs_da_args      *args)
+{
+	struct xfs_buf          *bp;
+	int                     error = 0;
+
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
@@ -1188,6 +1236,36 @@ out_defer_cancel:
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
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 6e546a1..1225c42 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -162,6 +162,7 @@ int xfs_attr_set(struct xfs_inode *dp, const unsigned char *name,
 int xfs_attr_set_args(struct xfs_da_args *args, struct xfs_buf **leaf_bp,
 		 bool roll_trans);
 int xfs_attr_remove(struct xfs_inode *dp, const unsigned char *name, int flags);
+int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args, bool roll_trans);
 int xfs_attr_list(struct xfs_inode *dp, char *buffer, int bufsize,
 		  int flags, struct attrlist_cursor_kern *cursor);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index 60444d0..d84cd59 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -619,6 +619,39 @@ xfs_attr_fork_remove(
 }
 
 /*
+ * Return successful if attr is found, or ENOATTR if not
+ */
+int
+xfs_shortform_has_attr(
+	struct xfs_da_args	 *args)
+{
+	struct xfs_attr_shortform *sf;
+	struct xfs_attr_sf_entry *sfe;
+	int			base = sizeof(struct xfs_attr_sf_hdr);
+	int			size = 0;
+	int			end;
+	int			i;
+
+	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
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
diff --git a/libxfs/xfs_attr_leaf.h b/libxfs/xfs_attr_leaf.h
index 9d830ec..98dd169 100644
--- a/libxfs/xfs_attr_leaf.h
+++ b/libxfs/xfs_attr_leaf.h
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
