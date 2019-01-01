Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:40452 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728414AbfAACYc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 31 Dec 2018 21:24:32 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.22/8.16.0.22) with SMTP id x012OEEr178970
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:24:30 GMT
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
        by userp2120.oracle.com with ESMTP id 2pp1jqx46k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 01 Jan 2019 02:24:30 +0000
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by userv0021.oracle.com (8.14.4/8.14.4) with ESMTP id x012OT2Y032637
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:24:30 GMT
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x012OTIp028114
        for <linux-xfs@vger.kernel.org>; Tue, 1 Jan 2019 02:24:29 GMT
Subject: [PATCH 01/20] xfs: make iroot_realloc a btree function
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Mon, 31 Dec 2018 18:24:21 -0800
Message-ID: <154630946112.8108.11098138800910059087.stgit@magnolia>
In-Reply-To: <154630945466.8108.16578904812191021263.stgit@magnolia>
References: <154630945466.8108.16578904812191021263.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

For btrees that are rooted in the inode core, we have to have a
function to resize the root.  This is fairly specific to each
btree type, so make xfs_iroot_realloc a per-btree function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |    6 +-
 fs/xfs/libxfs/xfs_bmap_btree.c |  137 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap_btree.h |    2 +
 fs/xfs/libxfs/xfs_btree.c      |   12 +---
 fs/xfs/libxfs/xfs_btree.h      |    7 ++
 fs/xfs/libxfs/xfs_inode_fork.c |  130 --------------------------------------
 fs/xfs/libxfs/xfs_inode_fork.h |    1 
 7 files changed, 153 insertions(+), 142 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e151685b57d3..ed66a61422ce 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -631,7 +631,7 @@ xfs_bmap_btree_to_extents(
 	xfs_trans_binval(tp, cbp);
 	if (cur->bc_bufs[0] == cbp)
 		cur->bc_bufs[0] = NULL;
-	xfs_iroot_realloc(ip, -1, whichfork);
+	cur->bc_ops->iroot_realloc(cur, -1);
 	ASSERT(ifp->if_broot == NULL);
 	ASSERT((ifp->if_flags & XFS_IFBROOT) == 0);
 	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
@@ -676,7 +676,7 @@ xfs_bmap_extents_to_btree(
 	 * Make space in the inode incore. This needs to be undone if we fail
 	 * to expand the root.
 	 */
-	xfs_iroot_realloc(ip, 1, whichfork);
+	xfs_bmbt_iroot_realloc(ip, 1, whichfork);
 	ifp->if_flags |= XFS_IFBROOT;
 
 	/*
@@ -779,7 +779,7 @@ xfs_bmap_extents_to_btree(
 out_unreserve_dquot:
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 out_root_realloc:
-	xfs_iroot_realloc(ip, -1, whichfork);
+	cur->bc_ops->iroot_realloc(cur, -1);
 	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
 	ASSERT(ifp->if_broot == NULL);
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index cdb74d2e2a43..4f7e566dd4bd 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -407,6 +407,142 @@ xfs_bmbt_diff_two_keys(
 			  be64_to_cpu(k2->bmbt.br_startoff);
 }
 
+/*
+ * Reallocate the space for if_broot based on the number of records
+ * being added or deleted as indicated in rec_diff.  Move the records
+ * and pointers in if_broot to fit the new size.  When shrinking this
+ * will eliminate holes between the records and pointers created by
+ * the caller.  When growing this will create holes to be filled in
+ * by the caller.
+ *
+ * The caller must not request to add more records than would fit in
+ * the on-disk inode root.  If the if_broot is currently NULL, then
+ * if we are adding records, one will be allocated.  The caller must also
+ * not request that the number of records go below zero, although
+ * it can go to zero.
+ *
+ * ip -- the inode whose if_broot area is changing
+ * ext_diff -- the change in the number of records, positive or negative,
+ *	 requested for the if_broot array.
+ */
+void
+xfs_bmbt_iroot_realloc(
+	struct xfs_inode	*ip,
+	int			rec_diff,
+	int			whichfork)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+	int			cur_max;
+	struct xfs_ifork	*ifp;
+	struct xfs_btree_block	*new_broot;
+	int			new_max;
+	size_t			new_size;
+	char			*np;
+	char			*op;
+
+	/*
+	 * Handle the degenerate case quietly.
+	 */
+	if (rec_diff == 0)
+		return;
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	if (rec_diff > 0) {
+		/*
+		 * If there wasn't any memory allocated before, just
+		 * allocate it now and get out.
+		 */
+		if (ifp->if_broot_bytes == 0) {
+			new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
+			ifp->if_broot = kmem_alloc(new_size, KM_SLEEP | KM_NOFS);
+			ifp->if_broot_bytes = (int)new_size;
+			return;
+		}
+
+		/*
+		 * If there is already an existing if_broot, then we need
+		 * to realloc() it and shift the pointers to their new
+		 * location.  The records don't change location because
+		 * they are kept butted up against the btree block header.
+		 */
+		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
+		new_max = cur_max + rec_diff;
+		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
+		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
+				KM_SLEEP | KM_NOFS);
+		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
+						     ifp->if_broot_bytes);
+		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
+						     (int)new_size);
+		ifp->if_broot_bytes = (int)new_size;
+		ASSERT(XFS_BMAP_BMDR_SPACE(ifp->if_broot) <=
+			XFS_IFORK_SIZE(ip, whichfork));
+		memmove(np, op, cur_max * (uint)sizeof(xfs_fsblock_t));
+		return;
+	}
+
+	/*
+	 * rec_diff is less than 0.  In this case, we are shrinking the
+	 * if_broot buffer.  It must already exist.  If we go to zero
+	 * records, just get rid of the root and clear the status bit.
+	 */
+	ASSERT((ifp->if_broot != NULL) && (ifp->if_broot_bytes > 0));
+	cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
+	new_max = cur_max + rec_diff;
+	ASSERT(new_max >= 0);
+	if (new_max > 0)
+		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
+	else
+		new_size = 0;
+	if (new_size > 0) {
+		new_broot = kmem_alloc(new_size, KM_SLEEP | KM_NOFS);
+		/*
+		 * First copy over the btree block header.
+		 */
+		memcpy(new_broot, ifp->if_broot,
+			XFS_BMBT_BLOCK_LEN(ip->i_mount));
+	} else {
+		new_broot = NULL;
+		ifp->if_flags &= ~XFS_IFBROOT;
+	}
+
+	/*
+	 * Only copy the records and pointers if there are any.
+	 */
+	if (new_max > 0) {
+		/*
+		 * First copy the records.
+		 */
+		op = (char *)XFS_BMBT_REC_ADDR(mp, ifp->if_broot, 1);
+		np = (char *)XFS_BMBT_REC_ADDR(mp, new_broot, 1);
+		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_rec_t));
+
+		/*
+		 * Then copy the pointers.
+		 */
+		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
+						     ifp->if_broot_bytes);
+		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, new_broot, 1,
+						     (int)new_size);
+		memcpy(np, op, new_max * (uint)sizeof(xfs_fsblock_t));
+	}
+	kmem_free(ifp->if_broot);
+	ifp->if_broot = new_broot;
+	ifp->if_broot_bytes = (int)new_size;
+	if (ifp->if_broot)
+		ASSERT(XFS_BMAP_BMDR_SPACE(ifp->if_broot) <=
+			XFS_IFORK_SIZE(ip, whichfork));
+}
+
+STATIC void
+__xfs_bmbt_iroot_realloc(
+	struct xfs_btree_cur	*cur,
+	int			rec_diff)
+{
+	return xfs_bmbt_iroot_realloc(cur->bc_private.b.ip, rec_diff,
+			cur->bc_private.b.whichfork);
+}
+
 static xfs_failaddr_t
 xfs_bmbt_verify(
 	struct xfs_buf		*bp)
@@ -526,6 +662,7 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.key_diff		= xfs_bmbt_key_diff,
 	.diff_two_keys		= xfs_bmbt_diff_two_keys,
 	.buf_ops		= &xfs_bmbt_buf_ops,
+	.iroot_realloc		= __xfs_bmbt_iroot_realloc,
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
 };
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 29b407d053b4..ae347f4c4b60 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -108,5 +108,7 @@ extern struct xfs_btree_cur *xfs_bmbt_init_cursor(struct xfs_mount *,
 
 extern unsigned long long xfs_bmbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
+extern void xfs_bmbt_iroot_realloc(struct xfs_inode *ip, int rec_diff,
+		int whichfork);
 
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index bbdae2b4559f..caf49f233e56 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3001,9 +3001,7 @@ xfs_btree_new_iroot(
 
 	xfs_btree_copy_ptrs(cur, pp, &nptr, 1);
 
-	xfs_iroot_realloc(cur->bc_private.b.ip,
-			  1 - xfs_btree_get_numrecs(cblock),
-			  cur->bc_private.b.whichfork);
+	cur->bc_ops->iroot_realloc(cur, 1 - xfs_btree_get_numrecs(cblock));
 
 	xfs_btree_setbuf(cur, level, cbp);
 
@@ -3172,7 +3170,7 @@ xfs_btree_make_block_unfull(
 
 		if (numrecs < cur->bc_ops->get_dmaxrecs(cur, level)) {
 			/* A root block that can be made bigger. */
-			xfs_iroot_realloc(ip, 1, cur->bc_private.b.whichfork);
+			cur->bc_ops->iroot_realloc(cur, 1);
 			*stat = 1;
 		} else {
 			/* A root block that needs replacing */
@@ -3574,8 +3572,7 @@ xfs_btree_kill_iroot(
 
 	index = numrecs - cur->bc_ops->get_maxrecs(cur, level);
 	if (index) {
-		xfs_iroot_realloc(cur->bc_private.b.ip, index,
-				  cur->bc_private.b.whichfork);
+		cur->bc_ops->iroot_realloc(cur, index);
 		block = ifp->if_broot;
 	}
 
@@ -3772,8 +3769,7 @@ xfs_btree_delrec(
 	 */
 	if (level == cur->bc_nlevels - 1) {
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
-			xfs_iroot_realloc(cur->bc_private.b.ip, -1,
-					  cur->bc_private.b.whichfork);
+			cur->bc_ops->iroot_realloc(cur, -1);
 
 			error = xfs_btree_kill_iroot(cur);
 			if (error)
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index e3b3e9dce5da..59f3e42397fb 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -148,6 +148,13 @@ struct xfs_btree_ops {
 				   union xfs_btree_key *key1,
 				   union xfs_btree_key *key2);
 
+	/*
+	 * Reallocate the space for if_broot based on the number of records
+	 * being added or deleted as indicated in rec_diff.
+	 */
+	void (*iroot_realloc)(struct xfs_btree_cur *cur,
+			      int rec_diff);
+
 	const struct xfs_buf_ops	*buf_ops;
 
 	/* check that k1 is lower than k2 */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index f9acf1d436f6..cfb68d4befc4 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -321,136 +321,6 @@ xfs_iformat_btree(
 	return 0;
 }
 
-/*
- * Reallocate the space for if_broot based on the number of records
- * being added or deleted as indicated in rec_diff.  Move the records
- * and pointers in if_broot to fit the new size.  When shrinking this
- * will eliminate holes between the records and pointers created by
- * the caller.  When growing this will create holes to be filled in
- * by the caller.
- *
- * The caller must not request to add more records than would fit in
- * the on-disk inode root.  If the if_broot is currently NULL, then
- * if we are adding records, one will be allocated.  The caller must also
- * not request that the number of records go below zero, although
- * it can go to zero.
- *
- * ip -- the inode whose if_broot area is changing
- * ext_diff -- the change in the number of records, positive or negative,
- *	 requested for the if_broot array.
- */
-void
-xfs_iroot_realloc(
-	xfs_inode_t		*ip,
-	int			rec_diff,
-	int			whichfork)
-{
-	struct xfs_mount	*mp = ip->i_mount;
-	int			cur_max;
-	struct xfs_ifork	*ifp;
-	struct xfs_btree_block	*new_broot;
-	int			new_max;
-	size_t			new_size;
-	char			*np;
-	char			*op;
-
-	/*
-	 * Handle the degenerate case quietly.
-	 */
-	if (rec_diff == 0) {
-		return;
-	}
-
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-	if (rec_diff > 0) {
-		/*
-		 * If there wasn't any memory allocated before, just
-		 * allocate it now and get out.
-		 */
-		if (ifp->if_broot_bytes == 0) {
-			new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
-			ifp->if_broot = kmem_alloc(new_size, KM_SLEEP | KM_NOFS);
-			ifp->if_broot_bytes = (int)new_size;
-			return;
-		}
-
-		/*
-		 * If there is already an existing if_broot, then we need
-		 * to realloc() it and shift the pointers to their new
-		 * location.  The records don't change location because
-		 * they are kept butted up against the btree block header.
-		 */
-		cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
-		new_max = cur_max + rec_diff;
-		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
-		ifp->if_broot = kmem_realloc(ifp->if_broot, new_size,
-				KM_SLEEP | KM_NOFS);
-		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
-						     ifp->if_broot_bytes);
-		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
-						     (int)new_size);
-		ifp->if_broot_bytes = (int)new_size;
-		ASSERT(XFS_BMAP_BMDR_SPACE(ifp->if_broot) <=
-			XFS_IFORK_SIZE(ip, whichfork));
-		memmove(np, op, cur_max * (uint)sizeof(xfs_fsblock_t));
-		return;
-	}
-
-	/*
-	 * rec_diff is less than 0.  In this case, we are shrinking the
-	 * if_broot buffer.  It must already exist.  If we go to zero
-	 * records, just get rid of the root and clear the status bit.
-	 */
-	ASSERT((ifp->if_broot != NULL) && (ifp->if_broot_bytes > 0));
-	cur_max = xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0);
-	new_max = cur_max + rec_diff;
-	ASSERT(new_max >= 0);
-	if (new_max > 0)
-		new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, new_max);
-	else
-		new_size = 0;
-	if (new_size > 0) {
-		new_broot = kmem_alloc(new_size, KM_SLEEP | KM_NOFS);
-		/*
-		 * First copy over the btree block header.
-		 */
-		memcpy(new_broot, ifp->if_broot,
-			XFS_BMBT_BLOCK_LEN(ip->i_mount));
-	} else {
-		new_broot = NULL;
-		ifp->if_flags &= ~XFS_IFBROOT;
-	}
-
-	/*
-	 * Only copy the records and pointers if there are any.
-	 */
-	if (new_max > 0) {
-		/*
-		 * First copy the records.
-		 */
-		op = (char *)XFS_BMBT_REC_ADDR(mp, ifp->if_broot, 1);
-		np = (char *)XFS_BMBT_REC_ADDR(mp, new_broot, 1);
-		memcpy(np, op, new_max * (uint)sizeof(xfs_bmbt_rec_t));
-
-		/*
-		 * Then copy the pointers.
-		 */
-		op = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, ifp->if_broot, 1,
-						     ifp->if_broot_bytes);
-		np = (char *)XFS_BMAP_BROOT_PTR_ADDR(mp, new_broot, 1,
-						     (int)new_size);
-		memcpy(np, op, new_max * (uint)sizeof(xfs_fsblock_t));
-	}
-	kmem_free(ifp->if_broot);
-	ifp->if_broot = new_broot;
-	ifp->if_broot_bytes = (int)new_size;
-	if (ifp->if_broot)
-		ASSERT(XFS_BMAP_BMDR_SPACE(ifp->if_broot) <=
-			XFS_IFORK_SIZE(ip, whichfork));
-	return;
-}
-
-
 /*
  * This is called when the amount of space needed for if_data
  * is increased or decreased.  The change in size is indicated by
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 60361d2d74a1..8de3dc0fffb3 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -94,7 +94,6 @@ void		xfs_iflush_fork(struct xfs_inode *, struct xfs_dinode *,
 				struct xfs_inode_log_item *, int);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
 void		xfs_idata_realloc(struct xfs_inode *, int, int);
-void		xfs_iroot_realloc(struct xfs_inode *, int, int);
 int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
 int		xfs_iextents_copy(struct xfs_inode *, struct xfs_bmbt_rec *,
 				  int);
