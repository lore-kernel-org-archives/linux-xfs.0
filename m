Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF33519ABC6
	for <linux-xfs@vger.kernel.org>; Fri,  6 Dec 2024 23:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733527910; cv=none; b=ifXQqN0AgbR6PQ9wyx4jO8oGYs/CAAsoszc83Bj9cPf8fYkSH8R5FHvCKy8a0sTaPYshUScT+QmA9UG/h0JFuK+ThjH3LqpM3OIaMmx5cqrekFYGBRJNAwCIuOL3/AbN+raLKQUH+QBVMAh7Iv1QKJtFiXVfiMwmct/4yWLKa6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733527910; c=relaxed/simple;
	bh=vrMPnrRaYRkiNdG4MiJxqqLdOmx09Sodwja2ZkB02Lc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hAuwFFJ+biCAUomX79o6ycjvnoW5WH5BWEoxUKSWIPh9EkVn+AW8GBAmyKftFT1FwvNn84dMwH/xUfMc2EMX4st+b09pJMDVnhuLIPRYBuoNA1CBEvoGChDZVjS27IufHWgMOuqk6qTaNQ9fjGOLKg2BFN4ZaSDR6+AgS5osLiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qlwrpCYl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qlwrpCYl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D976C4CED1;
	Fri,  6 Dec 2024 23:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733527910;
	bh=vrMPnrRaYRkiNdG4MiJxqqLdOmx09Sodwja2ZkB02Lc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qlwrpCYlud1JgRjER5/Ct8gZWhSeMxqLOwRf7xgg5IzFi6JrdbLFej3pDDP/OY04I
	 fatOrK/cYBvFG9GLVq/N17aIovmzz2xzUWOJDwC+v4nlim2QrIu+jcr4x1OlgUxraq
	 vHTixM2kBnMAby3ilVDgbrZECtEjqiRYlgta0sTirpUuD5iDJhTjDXnWf+WITXNuJB
	 fa8nFrL7Aeqsj8GrhMJuzDop09tEEiHdhSs4a1a+F9hIM0qDiA8T5kQUuyajngW9PZ
	 bby/5nvdosMDzupunjJtyz/KmQLLDXfHsne973nIXF3yNlFuvXDw0YjLcvND05IGoL
	 noNEGTzMKeoRA==
Date: Fri, 06 Dec 2024 15:31:49 -0800
Subject: [PATCH 06/36] xfs: remove the agno argument to xfs_free_ag_extent
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173352746974.121772.17151135890289334210.stgit@frogsfrogsfrogs>
In-Reply-To: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
References: <173352746825.121772.11414387759505707402.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: db129fa01113f767d5b7a6fd339114a962023464

xfs_free_ag_extent already has a pointer to the pag structure through
the agf buffer.  Use that instead of passing the redundant argument,
and do the same for the tracepoint.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 include/xfs_trace.h |    2 +-
 libxfs/defer_item.c |    4 ++--
 libxfs/xfs_alloc.c  |   10 ++++------
 libxfs/xfs_alloc.h  |    5 ++---
 4 files changed, 9 insertions(+), 12 deletions(-)


diff --git a/include/xfs_trace.h b/include/xfs_trace.h
index f6d6a6ea1af9e1..ba51419b3df3d3 100644
--- a/include/xfs_trace.h
+++ b/include/xfs_trace.h
@@ -79,7 +79,7 @@
 #define trace_xfs_btree_free_block(...)		((void) 0)
 #define trace_xfs_btree_alloc_block(...)	((void) 0)
 
-#define trace_xfs_free_extent(a,b,c,d,e,f,g)	((void) 0)
+#define trace_xfs_free_extent(...)		((void) 0)
 #define trace_xfs_agf(a,b,c,d)			((void) 0)
 #define trace_xfs_read_agf(a,b)			((void) 0)
 #define trace_xfs_alloc_read_agf(a,b)		((void) 0)
diff --git a/libxfs/defer_item.c b/libxfs/defer_item.c
index 2b48ed14d67bcb..d5e075362ababe 100644
--- a/libxfs/defer_item.c
+++ b/libxfs/defer_item.c
@@ -181,8 +181,8 @@ xfs_agfl_free_finish_item(
 
 	error = xfs_alloc_read_agf(xefi->xefi_pag, tp, 0, &agbp);
 	if (!error)
-		error = xfs_free_ag_extent(tp, agbp, xefi->xefi_pag->pag_agno,
-				agbno, 1, &oinfo, XFS_AG_RESV_AGFL);
+		error = xfs_free_ag_extent(tp, agbp, agbno, 1, &oinfo,
+				XFS_AG_RESV_AGFL);
 
 	xfs_extent_free_cancel_item(item);
 	return error;
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 355f8ef1a872d3..1f4740cced73a1 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -2033,7 +2033,6 @@ int
 xfs_free_ag_extent(
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
-	xfs_agnumber_t			agno,
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len,
 	const struct xfs_owner_info	*oinfo,
@@ -2354,19 +2353,19 @@ xfs_free_ag_extent(
 	 * Update the freespace totals in the ag and superblock.
 	 */
 	error = xfs_alloc_update_counters(tp, agbp, len);
-	xfs_ag_resv_free_extent(agbp->b_pag, type, tp, len);
+	xfs_ag_resv_free_extent(pag, type, tp, len);
 	if (error)
 		goto error0;
 
 	XFS_STATS_INC(mp, xs_freex);
 	XFS_STATS_ADD(mp, xs_freeb, len);
 
-	trace_xfs_free_extent(mp, agno, bno, len, type, haveleft, haveright);
+	trace_xfs_free_extent(pag, bno, len, type, haveleft, haveright);
 
 	return 0;
 
  error0:
-	trace_xfs_free_extent(mp, agno, bno, len, type, -1, -1);
+	trace_xfs_free_extent(pag, bno, len, type, -1, -1);
 	if (bno_cur)
 		xfs_btree_del_cursor(bno_cur, XFS_BTREE_ERROR);
 	if (cnt_cur)
@@ -4006,8 +4005,7 @@ __xfs_free_extent(
 		goto err_release;
 	}
 
-	error = xfs_free_ag_extent(tp, agbp, pag->pag_agno, agbno, len, oinfo,
-			type);
+	error = xfs_free_ag_extent(tp, agbp, agbno, len, oinfo, type);
 	if (error)
 		goto err_release;
 
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 0165452e7cd055..88fbce5001185f 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -79,9 +79,8 @@ int xfs_alloc_put_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
 		struct xfs_buf *agfbp, struct xfs_buf *agflbp,
 		xfs_agblock_t bno, int btreeblk);
 int xfs_free_ag_extent(struct xfs_trans *tp, struct xfs_buf *agbp,
-		xfs_agnumber_t agno, xfs_agblock_t bno,
-		xfs_extlen_t len, const struct xfs_owner_info *oinfo,
-		enum xfs_ag_resv_type type);
+		xfs_agblock_t bno, xfs_extlen_t len,
+		const struct xfs_owner_info *oinfo, enum xfs_ag_resv_type type);
 
 /*
  * Compute and fill in value of m_alloc_maxlevels.

