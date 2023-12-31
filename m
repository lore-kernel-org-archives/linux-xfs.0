Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4100C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ECO7d3dG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C077CC433C7;
	Sun, 31 Dec 2023 22:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060982;
	bh=EuggvKQM0SmRJKDQjs8dEkmRjeonn0dzTcC/S68dugg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ECO7d3dGWboIAPpTl/5LF5JA4sFk+wIlAl7KC9fm0xtCSHzcpzhuqbm2oxN6674Xm
	 fbH7gv05Iv5/Dm46pDgJS0op8rrzeMAWcxK71JlzuLlPoGtWb82apyeA5vZES2/RTm
	 amZzMrjRo4cKRNYDE/yovbpmjM+/6KxpUQwU+WzlIMx6tKj6vSLJGKGfXyPwOu7uew
	 Je4KGIxihzpDwM+vJV2+bMHg1AHU0lf88ymqsITzOzd2PcivrU+qJUgewT1xefll0D
	 qSjGJvgAdFicFL17keUDTB+KFQ/outhjIpGc7XzMDQSAp/13k8UkumVQzJ07ILFiRq
	 jcQChzZ5JuvMQ==
Date: Sun, 31 Dec 2023 14:16:22 -0800
Subject: [PATCH 07/10] xfs: consolidate btree block allocation tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404992876.1794490.2448801849529161019.stgit@frogsfrogsfrogs>
In-Reply-To: <170404992774.1794490.2226231791872978170.stgit@frogsfrogsfrogs>
References: <170404992774.1794490.2226231791872978170.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Don't waste tracepoint segment memory on per-btree block allocation
tracepoints when we can do it from the generic btree code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trace.h         |    4 +---
 libxfs/xfs_btree.c          |   20 +++++++++++++++++---
 libxfs/xfs_refcount_btree.c |    2 --
 libxfs/xfs_rmap_btree.c     |    2 --
 4 files changed, 18 insertions(+), 10 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index 98819653bcb..e7cbd0d9d41 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -69,6 +69,7 @@
 #define trace_xfs_btree_bload_level_geometry(a,b,c,d,e,f,g) ((void) 0)
 #define trace_xfs_btree_bload_block(a,b,c,d,e,f) ((void) 0)
 #define trace_xfs_btree_free_block(...)		((void) 0)
+#define trace_xfs_btree_alloc_block(...)	((void) 0)
 
 #define trace_xfs_free_extent(a,b,c,d,e,f,g)	((void) 0)
 #define trace_xfs_agf(a,b,c,d)			((void) 0)
@@ -257,8 +258,6 @@
 #define trace_xfs_rmap_find_left_neighbor_result(...)	((void) 0)
 #define trace_xfs_rmap_lookup_le_range_result(...)	((void) 0)
 
-#define trace_xfs_rmapbt_alloc_block(...)	((void) 0)
-
 #define trace_xfs_ag_resv_critical(...)		((void) 0)
 #define trace_xfs_ag_resv_needed(...)		((void) 0)
 #define trace_xfs_ag_resv_free(...)		((void) 0)
@@ -276,7 +275,6 @@
 #define trace_xfs_refcount_insert_error(...)	((void) 0)
 #define trace_xfs_refcount_delete(...)		((void) 0)
 #define trace_xfs_refcount_delete_error(...)	((void) 0)
-#define trace_xfs_refcountbt_alloc_block(...)	((void) 0)
 #define trace_xfs_refcount_rec_order_error(...)	((void) 0)
 
 #define trace_xfs_refcount_lookup(...)		((void) 0)
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 14587e52840..d47847db3db 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -2690,6 +2690,20 @@ xfs_btree_rshift(
 	return error;
 }
 
+static inline int
+xfs_btree_alloc_block(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*hint_block,
+	union xfs_btree_ptr		*new_block,
+	int				*stat)
+{
+	int				error;
+
+	error = cur->bc_ops->alloc_block(cur, hint_block, new_block, stat);
+	trace_xfs_btree_alloc_block(cur, new_block, *stat, error);
+	return error;
+}
+
 /*
  * Split cur/level block in half.
  * Return new block number and the key to its first
@@ -2733,7 +2747,7 @@ __xfs_btree_split(
 	xfs_btree_buf_to_ptr(cur, lbp, &lptr);
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
-	error = cur->bc_ops->alloc_block(cur, &lptr, &rptr, stat);
+	error = xfs_btree_alloc_block(cur, &lptr, &rptr, stat);
 	if (error)
 		goto error0;
 	if (*stat == 0)
@@ -3013,7 +3027,7 @@ xfs_btree_new_iroot(
 	pp = xfs_btree_ptr_addr(cur, 1, block);
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
-	error = cur->bc_ops->alloc_block(cur, pp, &nptr, stat);
+	error = xfs_btree_alloc_block(cur, pp, &nptr, stat);
 	if (error)
 		goto error0;
 	if (*stat == 0)
@@ -3113,7 +3127,7 @@ xfs_btree_new_root(
 	cur->bc_ops->init_ptr_from_cur(cur, &rptr);
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
-	error = cur->bc_ops->alloc_block(cur, &rptr, &lptr, stat);
+	error = xfs_btree_alloc_block(cur, &rptr, &lptr, stat);
 	if (error)
 		goto error0;
 	if (*stat == 0)
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index 67551df02bd..9a3c2270c25 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -76,8 +76,6 @@ xfs_refcountbt_alloc_block(
 					xfs_refc_block(args.mp)));
 	if (error)
 		goto out_error;
-	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			args.agbno, 1);
 	if (args.fsbno == NULLFSBLOCK) {
 		*stat = 0;
 		return 0;
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index 7966a3e6a47..e894a22e087 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -92,8 +92,6 @@ xfs_rmapbt_alloc_block(
 				       &bno, 1);
 	if (error)
 		return error;
-
-	trace_xfs_rmapbt_alloc_block(cur->bc_mp, pag->pag_agno, bno, 1);
 	if (bno == NULLAGBLOCK) {
 		*stat = 0;
 		return 0;

