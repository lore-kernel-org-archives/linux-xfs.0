Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD074C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qg4bY5eN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4325AC433C7;
	Sun, 31 Dec 2023 22:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704060967;
	bh=DqKy2GD2NNPOyzzRHBJxy+9bw/DGIpw3kalFeyTLV2o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Qg4bY5eNtX8rf0rCRWoPNpQgfSv2pT4M50g1Yay2ZEUENO0zc+tDFYe8MAhXPsahy
	 BFSOPELAD0TLq+2Mz6im6EV9swlyk/RzwzLdlufKCXywei2keX3MBQFWpK9B7uEDFF
	 bPQ1RDDjYEO/oJqO3qFkYM003v4J5jMgRcPz++K4L5MTt5un5maKqcICILnf2XhKfG
	 r0exVqiJkFJJNNksd0MpKC4xyoz1SX9N5L9rhiCiZ7ge+5CuE1zTl3CHp13ViZ3uvw
	 V9DRikNpljplV6o/G+Q4C2AyTWGlQxcMuAtyB3YoogPmZ83wRbUO24PNsE2C5wrI0s
	 UitlOKAZQ9a1g==
Date: Sun, 31 Dec 2023 14:16:06 -0800
Subject: [PATCH 06/10] xfs: consolidate btree block freeing tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404992862.1794490.1545761667302582844.stgit@frogsfrogsfrogs>
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

Don't waste tracepoint segment memory on per-btree block freeing
tracepoints when we can do it from the generic btree code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trace.h         |    3 +--
 libxfs/xfs_btree.c          |    2 ++
 libxfs/xfs_refcount_btree.c |    2 --
 libxfs/xfs_rmap_btree.c     |    2 --
 4 files changed, 3 insertions(+), 6 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index f172b61d6a5..98819653bcb 100644
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
index 4b4099c5635..14587e52840 100644
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
index ac1c3ab868e..67551df02bd 100644
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
index d6e2fc0a3f9..7966a3e6a47 100644
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

