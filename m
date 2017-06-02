Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29554 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751147AbdFBVYY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Jun 2017 17:24:24 -0400
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id v52LON1b009624
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:24:23 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id v52LOM0i008365
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:24:23 GMT
Received: from abhmp0009.oracle.com (abhmp0009.oracle.com [141.146.116.15])
        by aserv0121.oracle.com (8.13.8/8.13.8) with ESMTP id v52LOKsu030888
        for <linux-xfs@vger.kernel.org>; Fri, 2 Jun 2017 21:24:21 GMT
Subject: [PATCH 03/13] xfs: always compile the btree inorder check functions
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 02 Jun 2017 14:24:18 -0700
Message-ID: <149643865870.23065.16385676974970966766.stgit@birch.djwong.org>
In-Reply-To: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
References: <149643863965.23065.10505493683913299340.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The btree record and key inorder check functions will be used by the
btree scrubber code, so make sure they're always built.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_alloc_btree.c    |    6 ------
 fs/xfs/libxfs/xfs_bmap_btree.c     |    4 ----
 fs/xfs/libxfs/xfs_btree.h          |    2 --
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    6 ------
 fs/xfs/libxfs/xfs_refcount_btree.c |    4 ----
 fs/xfs/libxfs/xfs_rmap_btree.c     |    4 ----
 6 files changed, 26 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 5020cbc..cfde0a0 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -395,7 +395,6 @@ const struct xfs_buf_ops xfs_allocbt_buf_ops = {
 };
 
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_bnobt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -442,7 +441,6 @@ xfs_cntbt_recs_inorder(
 		 be32_to_cpu(r1->alloc.ar_startblock) <
 		 be32_to_cpu(r2->alloc.ar_startblock));
 }
-#endif /* DEBUG */
 
 static const struct xfs_btree_ops xfs_bnobt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
@@ -462,10 +460,8 @@ static const struct xfs_btree_ops xfs_bnobt_ops = {
 	.key_diff		= xfs_bnobt_key_diff,
 	.buf_ops		= &xfs_allocbt_buf_ops,
 	.diff_two_keys		= xfs_bnobt_diff_two_keys,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_bnobt_keys_inorder,
 	.recs_inorder		= xfs_bnobt_recs_inorder,
-#endif
 };
 
 static const struct xfs_btree_ops xfs_cntbt_ops = {
@@ -486,10 +482,8 @@ static const struct xfs_btree_ops xfs_cntbt_ops = {
 	.key_diff		= xfs_cntbt_key_diff,
 	.buf_ops		= &xfs_allocbt_buf_ops,
 	.diff_two_keys		= xfs_cntbt_diff_two_keys,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_cntbt_keys_inorder,
 	.recs_inorder		= xfs_cntbt_recs_inorder,
-#endif
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 5e2b3dc..e23495e 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -687,7 +687,6 @@ const struct xfs_buf_ops xfs_bmbt_buf_ops = {
 };
 
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_bmbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -708,7 +707,6 @@ xfs_bmbt_recs_inorder(
 		xfs_bmbt_disk_get_blockcount(&r1->bmbt) <=
 		xfs_bmbt_disk_get_startoff(&r2->bmbt);
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
@@ -726,10 +724,8 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.init_ptr_from_cur	= xfs_bmbt_init_ptr_from_cur,
 	.key_diff		= xfs_bmbt_key_diff,
 	.buf_ops		= &xfs_bmbt_buf_ops,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
-#endif
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 0a931f6..177a364 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -163,7 +163,6 @@ struct xfs_btree_ops {
 
 	const struct xfs_buf_ops	*buf_ops;
 
-#if defined(DEBUG) || defined(XFS_WARN)
 	/* check that k1 is lower than k2 */
 	int	(*keys_inorder)(struct xfs_btree_cur *cur,
 				union xfs_btree_key *k1,
@@ -173,7 +172,6 @@ struct xfs_btree_ops {
 	int	(*recs_inorder)(struct xfs_btree_cur *cur,
 				union xfs_btree_rec *r1,
 				union xfs_btree_rec *r2);
-#endif
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index ed52d99..6b1ddeb 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -302,7 +302,6 @@ const struct xfs_buf_ops xfs_inobt_buf_ops = {
 	.verify_write = xfs_inobt_write_verify,
 };
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_inobt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -322,7 +321,6 @@ xfs_inobt_recs_inorder(
 	return be32_to_cpu(r1->inobt.ir_startino) + XFS_INODES_PER_CHUNK <=
 		be32_to_cpu(r2->inobt.ir_startino);
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_inobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
@@ -339,10 +337,8 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
 	.init_ptr_from_cur	= xfs_inobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
 	.buf_ops		= &xfs_inobt_buf_ops,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
-#endif
 };
 
 static const struct xfs_btree_ops xfs_finobt_ops = {
@@ -360,10 +356,8 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
 	.init_ptr_from_cur	= xfs_finobt_init_ptr_from_cur,
 	.key_diff		= xfs_inobt_key_diff,
 	.buf_ops		= &xfs_inobt_buf_ops,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
-#endif
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 65c222a..3c59dd3 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -285,7 +285,6 @@ const struct xfs_buf_ops xfs_refcountbt_buf_ops = {
 	.verify_write		= xfs_refcountbt_write_verify,
 };
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_refcountbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -306,7 +305,6 @@ xfs_refcountbt_recs_inorder(
 		be32_to_cpu(r1->refc.rc_blockcount) <=
 		be32_to_cpu(r2->refc.rc_startblock);
 }
-#endif
 
 static const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
@@ -325,10 +323,8 @@ static const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.key_diff		= xfs_refcountbt_key_diff,
 	.buf_ops		= &xfs_refcountbt_buf_ops,
 	.diff_two_keys		= xfs_refcountbt_diff_two_keys,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_refcountbt_keys_inorder,
 	.recs_inorder		= xfs_refcountbt_recs_inorder,
-#endif
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index c5b4a1c8..9d9c919 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -377,7 +377,6 @@ const struct xfs_buf_ops xfs_rmapbt_buf_ops = {
 	.verify_write		= xfs_rmapbt_write_verify,
 };
 
-#if defined(DEBUG) || defined(XFS_WARN)
 STATIC int
 xfs_rmapbt_keys_inorder(
 	struct xfs_btree_cur	*cur,
@@ -437,7 +436,6 @@ xfs_rmapbt_recs_inorder(
 		return 1;
 	return 0;
 }
-#endif	/* DEBUG */
 
 static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
@@ -456,10 +454,8 @@ static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.key_diff		= xfs_rmapbt_key_diff,
 	.buf_ops		= &xfs_rmapbt_buf_ops,
 	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
-#if defined(DEBUG) || defined(XFS_WARN)
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
 	.recs_inorder		= xfs_rmapbt_recs_inorder,
-#endif
 };
 
 /*

