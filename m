Return-Path: <SRS0=v9Pv=2W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CCE6C2D0CE
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:16:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1AF47206E4
	for <linux-xfs@archiver.kernel.org>; Wed,  1 Jan 2020 01:16:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="hsojDXzN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727170AbgAABQc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 31 Dec 2019 20:16:32 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:57102 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727132AbgAABQc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 31 Dec 2019 20:16:32 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0011EP98112620
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:16:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=6dQ5zAPk6FB3P5ErqJLpvsWHIg///lZWkwY6AT0Fn3U=;
 b=hsojDXzNtpnI3UC+tI3QduwNdsYJuT8wkRadvhP3PDheUEiMf/Y7Ea+BBpsGO3YbkJkm
 hHZD2Y+7m5LqVxn+HjXDzKQtp2PiQETHlX+zO10Iv0nW5DF8HzOg2pJfwiLXERA3Mxbo
 znOSx4kCh8+MQa3Sbe2sSRg/kO+RkQxxNaw0sHA6Dw911wN9Fg9luzan1ocnlL1kSgBT
 SilM4llx/pFgWAtV7FVEzFW89qBITrTvWzxjTkcw1qFNzTHcec5VaYqzDaBHipk8DOOI
 nmnYhI4SGXu70jThiKgfWDiKwvJXcZ8YUdx8ufm5sfjnn+L/T8nW0RQ0g4y7ddms88nD OA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 2x5xftk2n9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:16:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00118wqN172101
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:16:29 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 2x8gj91apu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Wed, 01 Jan 2020 01:16:29 +0000
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 0011GSDq001672
        for <linux-xfs@vger.kernel.org>; Wed, 1 Jan 2020 01:16:29 GMT
Received: from localhost (/10.159.150.156)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 31 Dec 2019 17:16:28 -0800
Subject: [PATCH 01/21] xfs: make iroot_realloc a btree function
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 31 Dec 2019 17:16:26 -0800
Message-ID: <157784138596.1368137.4941197849810187069.stgit@magnolia>
In-Reply-To: <157784137939.1368137.1149711841610071256.stgit@magnolia>
References: <157784137939.1368137.1149711841610071256.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=3 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001010009
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9487 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=3 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001010010
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

For btrees that are rooted in the inode core, we have to have a
function to resize the root.  This is fairly specific to each
btree type, so make xfs_iroot_realloc a per-btree function.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_bmap.c       |    6 +-
 fs/xfs/libxfs/xfs_bmap_btree.c |  139 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_bmap_btree.h |    2 +
 fs/xfs/libxfs/xfs_btree.c      |   12 +--
 fs/xfs/libxfs/xfs_btree.h      |    7 ++
 fs/xfs/libxfs/xfs_inode_fork.c |  130 -------------------------------------
 fs/xfs/libxfs/xfs_inode_fork.h |    1 
 7 files changed, 155 insertions(+), 142 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 172a1848cba0..6a52e24a0466 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -641,7 +641,7 @@ xfs_bmap_btree_to_extents(
 	xfs_trans_binval(tp, cbp);
 	if (cur->bc_bufs[0] == cbp)
 		cur->bc_bufs[0] = NULL;
-	xfs_iroot_realloc(ip, -1, whichfork);
+	cur->bc_ops->iroot_realloc(cur, -1);
 	ASSERT(ifp->if_broot == NULL);
 	ASSERT((ifp->if_flags & XFS_IFBROOT) == 0);
 	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
@@ -686,7 +686,7 @@ xfs_bmap_extents_to_btree(
 	 * Make space in the inode incore. This needs to be undone if we fail
 	 * to expand the root.
 	 */
-	xfs_iroot_realloc(ip, 1, whichfork);
+	xfs_bmbt_iroot_realloc(ip, 1, whichfork);
 	ifp->if_flags |= XFS_IFBROOT;
 
 	/*
@@ -790,7 +790,7 @@ xfs_bmap_extents_to_btree(
 out_unreserve_dquot:
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 out_root_realloc:
-	xfs_iroot_realloc(ip, -1, whichfork);
+	cur->bc_ops->iroot_realloc(cur, -1);
 	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
 	ASSERT(ifp->if_broot == NULL);
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index e9c1e2862df5..7158a90e56d3 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -410,6 +410,144 @@ xfs_bmbt_diff_two_keys(
 	return 0;
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
+	xfs_inode_t		*ip,
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
+	if (rec_diff == 0) {
+		return;
+	}
+
+	ifp = XFS_IFORK_PTR(ip, whichfork);
+	if (rec_diff > 0) {
+		/*
+		 * If there wasn't any memory allocated before, just
+		 * allocate it now and get out.
+		 */
+		if (ifp->if_broot_bytes == 0) {
+			new_size = XFS_BMAP_BROOT_SPACE_CALC(mp, rec_diff);
+			ifp->if_broot = kmem_alloc(new_size, KM_NOFS);
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
+				KM_NOFS);
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
+		new_broot = kmem_alloc(new_size, KM_NOFS);
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
+	return;
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
@@ -528,6 +666,7 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.key_diff		= xfs_bmbt_key_diff,
 	.diff_two_keys		= xfs_bmbt_diff_two_keys,
 	.buf_ops		= &xfs_bmbt_buf_ops,
+	.iroot_realloc		= __xfs_bmbt_iroot_realloc,
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
 };
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.h b/fs/xfs/libxfs/xfs_bmap_btree.h
index 0b20736808a3..69afabf3f5dd 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.h
+++ b/fs/xfs/libxfs/xfs_bmap_btree.h
@@ -114,5 +114,7 @@ void xfs_bmbt_commit_staged_btree(struct xfs_btree_cur *cur, int whichfork);
 
 extern unsigned long long xfs_bmbt_calc_size(struct xfs_mount *mp,
 		unsigned long long len);
+extern void xfs_bmbt_iroot_realloc(struct xfs_inode *ip, int rec_diff,
+		int whichfork);
 
 #endif	/* __XFS_BMAP_BTREE_H__ */
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index a0dd4d893c11..464ae3eafe16 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -3007,9 +3007,7 @@ xfs_btree_new_iroot(
 
 	xfs_btree_copy_ptrs(cur, pp, &nptr, 1);
 
-	xfs_iroot_realloc(cur->bc_private.b.ip,
-			  1 - xfs_btree_get_numrecs(cblock),
-			  cur->bc_private.b.whichfork);
+	cur->bc_ops->iroot_realloc(cur, 1 - xfs_btree_get_numrecs(cblock));
 
 	xfs_btree_setbuf(cur, level, cbp);
 
@@ -3178,7 +3176,7 @@ xfs_btree_make_block_unfull(
 
 		if (numrecs < cur->bc_ops->get_dmaxrecs(cur, level)) {
 			/* A root block that can be made bigger. */
-			xfs_iroot_realloc(ip, 1, cur->bc_private.b.whichfork);
+			cur->bc_ops->iroot_realloc(cur, 1);
 			*stat = 1;
 		} else {
 			/* A root block that needs replacing */
@@ -3584,8 +3582,7 @@ xfs_btree_kill_iroot(
 
 	index = numrecs - cur->bc_ops->get_maxrecs(cur, level);
 	if (index) {
-		xfs_iroot_realloc(cur->bc_private.b.ip, index,
-				  cur->bc_private.b.whichfork);
+		cur->bc_ops->iroot_realloc(cur, index);
 		block = ifp->if_broot;
 	}
 
@@ -3782,8 +3779,7 @@ xfs_btree_delrec(
 	 */
 	if (level == cur->bc_nlevels - 1) {
 		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
-			xfs_iroot_realloc(cur->bc_private.b.ip, -1,
-					  cur->bc_private.b.whichfork);
+			cur->bc_ops->iroot_realloc(cur, -1);
 
 			error = xfs_btree_kill_iroot(cur);
 			if (error)
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 6708ab2433cf..4bf6eadf9b0a 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -149,6 +149,13 @@ struct xfs_btree_ops {
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
index 1ac9796fd86c..b66d34c99787 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -333,136 +333,6 @@ xfs_iformat_btree(
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
-			ifp->if_broot = kmem_alloc(new_size, KM_NOFS);
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
-				KM_NOFS);
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
-		new_broot = kmem_alloc(new_size, KM_NOFS);
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
index 370ac0b099f0..fe9109f88a4c 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -100,7 +100,6 @@ void		xfs_ifork_reset(struct xfs_ifork *ifp);
 void		xfs_idestroy_fork(struct xfs_inode *, int);
 void		xfs_idata_realloc(struct xfs_inode *ip, int64_t byte_diff,
 				int whichfork);
-void		xfs_iroot_realloc(struct xfs_inode *, int, int);
 int		xfs_iread_extents(struct xfs_trans *, struct xfs_inode *, int);
 int		xfs_iextents_copy(struct xfs_inode *, struct xfs_bmbt_rec *,
 				  int);

