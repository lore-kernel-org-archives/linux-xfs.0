Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6334F1FDA
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832223; cv=none; b=g/alQIbvUZT5ncE01sY2fMR4o8e4BneBM0K+d1Qj7llJjrjMjGI1/9Q7nergamcsMOdr9HabKSdxgsMRN6iYBSb9fo34SqfGK2K7pvlOr1jcO5WLSj8OERwaTXOCWTchY4hYz9DwuGfaOMuIMGsUKeuVfOf/pqcN9bciZMOPu5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832223; c=relaxed/simple;
	bh=36HtdNJg8aRRJr2K+9/+8Oh31ZGj4RMrpDLzEElxqsk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u2sdihj9yjBsSGrGsOecVmT/CNexTgB+nLZcqqTpQGJC7p9/umnMuc6XlkKvlV48p1s7UBOSwCsf4p5zCNsdWOyKrQSGTFaZg0RhH4SXFCT8VUchokRVC8cpv0S/t7Hx27cmClnZxctLzWVaXmHNeucPxtERpRQr6GhJhGudzJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XMF4RGOs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XMF4RGOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E830EC4CEC6;
	Wed,  2 Oct 2024 01:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832223;
	bh=36HtdNJg8aRRJr2K+9/+8Oh31ZGj4RMrpDLzEElxqsk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XMF4RGOsQKv9d85MnNh99jC392UsCB8BNHoWbkpNfknIT34Anbqrgx75h0p6IRawr
	 ESfhsXAxud2BAiLBBlgskhOoBb7OmiRfmjLGcgI3Bkyg2Hzp1rfJbA5ZtAYQtesnKd
	 QcBsUeh1OfLby+kV8TuNgyJ7Ib1U3jxRVgzwltPhaJ/P6b6WvxpGuLd4iWgPRYxtWW
	 wAmA4pJbQARi5LjBPv+eR4B+1yZdJjbYl3KIXmkNPY7pCpKVyKX56UzJDKPuQSSmgC
	 hCFItTvoSQ8gDJ7JlmmI6nDCfg84Xs3yvSzaI18epJDRCwHalJLABnbhXiQoE0Er3Q
	 cPypmN58cT9+Q==
Date: Tue, 01 Oct 2024 18:23:42 -0700
Subject: [PATCH 61/64] xfs: get rid of xfs_ag_resv_rmapbt_alloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Long Li <leo.lilong@huawei.com>, Christoph Hellwig <hch@lst.de>,
 Chandan Babu R <chandanbabu@kernel.org>, linux-xfs@vger.kernel.org
Message-ID: <172783102699.4036371.12665817369897867618.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Long Li <leo.lilong@huawei.com>

Source kernel commit: 49cdc4e834e46d7c11a91d7adcfa04f56d19efaf

The pag in xfs_ag_resv_rmapbt_alloc() is already held when the struct
xfs_btree_cur is initialized in xfs_rmapbt_init_cursor(), so there is no
need to get pag again.

On the other hand, in xfs_rmapbt_free_block(), the similar function
xfs_ag_resv_rmapbt_free() was removed in commit 92a005448f6f ("xfs: get
rid of unnecessary xfs_perag_{get,put} pairs"), xfs_ag_resv_rmapbt_alloc()
was left because scrub used it, but now scrub has removed it. Therefore,
we could get rid of xfs_ag_resv_rmapbt_alloc() just like the rmap free
block, make the code cleaner.

Signed-off-by: Long Li <leo.lilong@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Chandan Babu R <chandanbabu@kernel.org>
---
 libxfs/xfs_ag_resv.h    |   19 -------------------
 libxfs/xfs_rmap_btree.c |    7 ++++++-
 2 files changed, 6 insertions(+), 20 deletions(-)


diff --git a/libxfs/xfs_ag_resv.h b/libxfs/xfs_ag_resv.h
index ff20ed93d..f247eeff7 100644
--- a/libxfs/xfs_ag_resv.h
+++ b/libxfs/xfs_ag_resv.h
@@ -33,23 +33,4 @@ xfs_perag_resv(
 	}
 }
 
-/*
- * RMAPBT reservation accounting wrappers. Since rmapbt blocks are sourced from
- * the AGFL, they are allocated one at a time and the reservation updates don't
- * require a transaction.
- */
-static inline void
-xfs_ag_resv_rmapbt_alloc(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
-{
-	struct xfs_alloc_arg	args = { NULL };
-	struct xfs_perag	*pag;
-
-	args.len = 1;
-	pag = xfs_perag_get(mp, agno);
-	xfs_ag_resv_alloc_extent(pag, XFS_AG_RESV_RMAPBT, &args);
-	xfs_perag_put(pag);
-}
-
 #endif	/* __XFS_AG_RESV_H__ */
diff --git a/libxfs/xfs_rmap_btree.c b/libxfs/xfs_rmap_btree.c
index a2730e29c..f1732b72d 100644
--- a/libxfs/xfs_rmap_btree.c
+++ b/libxfs/xfs_rmap_btree.c
@@ -87,6 +87,7 @@ xfs_rmapbt_alloc_block(
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
 	struct xfs_perag	*pag = cur->bc_ag.pag;
+	struct xfs_alloc_arg    args = { .len = 1 };
 	int			error;
 	xfs_agblock_t		bno;
 
@@ -106,7 +107,11 @@ xfs_rmapbt_alloc_block(
 	be32_add_cpu(&agf->agf_rmap_blocks, 1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
 
-	xfs_ag_resv_rmapbt_alloc(cur->bc_mp, pag->pag_agno);
+	/*
+	 * Since rmapbt blocks are sourced from the AGFL, they are allocated one
+	 * at a time and the reservation updates don't require a transaction.
+	 */
+	xfs_ag_resv_alloc_extent(pag, XFS_AG_RESV_RMAPBT, &args);
 
 	*stat = 1;
 	return 0;

