Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76061D53C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Mar 2024 03:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711424143; cv=none; b=isYXYsSG236ltkYwpF3UwnLeQSVNUiuufysTKBImVqEWrg9yroWv81u2k3qxDwGnnkzG7MUyGD8t+FwOHnSQixu30MwjIl34RrrRKZkmepBDohWcILNnO6bfXDpB3xD62kVtcohqUoQwB7Ybs+kWDBXrPAMXVyg0bm+lGgWaVC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711424143; c=relaxed/simple;
	bh=fkRwO44f4ir6PY++bpRukMmyz9tslTr3rviZmoBUQdw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o8O0NQrkFX5cJ8I2WT96I7orFOjnGhHuhAAg0y2V2nzI0W+M/mDAOjPqLPqYD/GltrHMfsvTusmIvag7Pp09sfJxWYr1aoPoC42hSnU1cQ+TfGp6apT8j0LNcSo0mbQ3OKgIQYBAFpRqcDKzE0vn8zemkaNJOjwkRayjgi8fq38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NEBkf+XU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NEBkf+XU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF67C433C7;
	Tue, 26 Mar 2024 03:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711424143;
	bh=fkRwO44f4ir6PY++bpRukMmyz9tslTr3rviZmoBUQdw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NEBkf+XUW+1BcdoWcqT49SVv9a2f62e7VZKaaSBpq/LsiCNRMXhGQDq3p8VN5z46f
	 DZTGtsJN0gj2NHa1/tHmFNbcULbqRgMSQdqIkpJdBFOdbw8cBP74IJMh5WS1EDRIF8
	 U0Z3MNdoQdhoZAr4KHJinfStrYLKf3MZUURVY1kh0FrdomjdqcGXpGnaM+RUkjcjW1
	 5SrFryHDka7ZkAtKzcH41VQziXQ7nxR7zgyr62Jq+IHjHWveJdFUkkgLB6iDv0FOmp
	 kX2UPjuUQImqw/3vu+Cph1R1iyp/ymqsdsjCgATqxsRWXcYhN8d6cAmGUl6bwaw+Dn
	 KsmBdnbb+JPCg==
Date: Mon, 25 Mar 2024 20:35:42 -0700
Subject: [PATCH 028/110] xfs: consolidate btree block freeing tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171142131788.2215168.13481970027285706797.stgit@frogsfrogsfrogs>
In-Reply-To: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
References: <171142131228.2215168.2795743548791967397.stgit@frogsfrogsfrogs>
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

Source kernel commit: 78067b92b9096a70ca731a6cde1c286582ff03d7

Don't waste memory on extra per-btree block freeing tracepoints when we
can do it from the generic btree code.

With this patch applied, two tracepoints are collapsed into one
tracepoint, with the following effects on objdump -hx xfs.ko output:

Before:

10 __tracepoints_ptrs 00000b3c  0000000000000000  0000000000000000  00140eb0  2**2
14 __tracepoints_strings 00005453  0000000000000000  0000000000000000  00168540  2**5
29 __tracepoints 00010d90  0000000000000000  0000000000000000  0023f5e0  2**5

After:

10 __tracepoints_ptrs 00000b38  0000000000000000  0000000000000000  001412f0  2**2
14 __tracepoints_strings 00005433  0000000000000000  0000000000000000  001689a0  2**5
29 __tracepoints 00010d30  0000000000000000  0000000000000000  0023fe00  2**5

Column 3 is the section size in bytes; removing these two tracepoints
reduces the size of the ELF segments by 132 bytes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_trace.h         |    3 +--
 libxfs/xfs_btree.c          |    2 ++
 libxfs/xfs_refcount_btree.c |    2 --
 libxfs/xfs_rmap_btree.c     |    2 --
 4 files changed, 3 insertions(+), 6 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index f172b61d6a55..98819653bcb0 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -68,6 +68,7 @@
 #define trace_xfs_btree_commit_ifakeroot(a)	((void) 0)
 #define trace_xfs_btree_bload_level_geometry(a,b,c,d,e,f,g) ((void) 0)
 #define trace_xfs_btree_bload_block(a,b,c,d,e,f) ((void) 0)
+#define trace_xfs_btree_free_block(...)		((void) 0)
 
 #define trace_xfs_free_extent(a,b,c,d,e,f,g)	((void) 0)
 #define trace_xfs_agf(a,b,c,d)			((void) 0)
@@ -256,7 +257,6 @@
 #define trace_xfs_rmap_find_left_neighbor_result(...)	((void) 0)
 #define trace_xfs_rmap_lookup_le_range_result(...)	((void) 0)
 
-#define trace_xfs_rmapbt_free_block(...)	((void) 0)
 #define trace_xfs_rmapbt_alloc_block(...)	((void) 0)
 
 #define trace_xfs_ag_resv_critical(...)		((void) 0)
@@ -276,7 +276,6 @@
 #define trace_xfs_refcount_insert_error(...)	((void) 0)
 #define trace_xfs_refcount_delete(...)		((void) 0)
 #define trace_xfs_refcount_delete_error(...)	((void) 0)
-#define trace_xfs_refcountbt_free_block(...)	((void) 0)
 #define trace_xfs_refcountbt_alloc_block(...)	((void) 0)
 #define trace_xfs_refcount_rec_order_error(...)	((void) 0)
 
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index b9af447ab69d..fb36a3b69ea0 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -411,6 +411,8 @@ xfs_btree_free_block(
 {
 	int			error;
 
+	trace_xfs_btree_free_block(cur, bp);
+
 	error = cur->bc_ops->free_block(cur, bp);
 	if (!error) {
 		xfs_trans_binval(cur->bc_tp, bp);
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index ac1c3ab868e0..67551df02bde 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -106,8 +106,6 @@ xfs_refcountbt_free_block(
 	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 
-	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1);
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
 	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index d6e2fc0a3f94..7966a3e6a474 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -123,8 +123,6 @@ xfs_rmapbt_free_block(
 	int			error;
 
 	bno = xfs_daddr_to_agbno(cur->bc_mp, xfs_buf_daddr(bp));
-	trace_xfs_rmapbt_free_block(cur->bc_mp, pag->pag_agno,
-			bno, 1);
 	be32_add_cpu(&agf->agf_rmap_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
 	error = xfs_alloc_put_freelist(pag, cur->bc_tp, agbp, NULL, bno, 1);

