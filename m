Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8596219CA9
	for <linux-xfs@vger.kernel.org>; Thu, 17 Oct 2024 18:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729190922; cv=none; b=uvOy4ucwg73Pu1sIGgybSyaO0aJj7DjQ3F9wZR62ncShIYz+EEKA1CpdJIELcWIAKVA9iwqdY0je+gpuPHjiRTttQFetyUqIiN14Ww71/EDdRLz/bOKIMtTx6DIbyQd276h6BAHXc8x35OTF4BiU5XRwjI18luiLVTCPLnjG6H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729190922; c=relaxed/simple;
	bh=yw1pDrOuVy7b0qLWfgKfS5K58ODR9GvGpY56Da7rI80=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DjRGfFHFBxKqVuqYtPm9k5DHs5Jii2WxHKwRe7Ys6w3/+ESgJCD24k/lKhSISh6N6POzn8pGKAJ7XREkE40Ke5SqJGoqDaMqIOFkbbbYSWoZGIJMgLPUdlliUrsCzYoYJCwgNxP2T7qsy2VkVn0ZtzEOHZFQLV2+ELt8mrvX8Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GRsPrRVk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GRsPrRVk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477CFC4CEC3;
	Thu, 17 Oct 2024 18:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729190922;
	bh=yw1pDrOuVy7b0qLWfgKfS5K58ODR9GvGpY56Da7rI80=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GRsPrRVkUNddNZN/YfqigOq7ULaQnw6T1NB0H+h/K4FJxoayt2aHCB9TEETeakSDm
	 lIbB1jmJLAPbn69yTO5Ht81I6koMHkC7lm35YSTpkAVqUT7jFPYWfPea8x+MZJsGiO
	 z0zOZ1jUyFLCRn1SnGTTVewuNjv6V4EjWAVXPklGVgvT3AnHUmVGzl4vQkpwHqgbyg
	 Rz8F5Zi6kSyPlgpi39gm6k6a7/tvAeJev1NiDHo10T0DISPE7BLxafzMHce86GpFAk
	 p7/vVICEvMmSrBHmc0qvCj6uxuD6v9Cl5lTgXcBEDCWC90S2UouwQW9jcrtGsbGgSR
	 v8GEi8G2XoNsQ==
Date: Thu, 17 Oct 2024 11:48:41 -0700
Subject: [PATCH 05/22] xfs: remove the agno argument to xfs_free_ag_extent
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172919067942.3449971.15518708397140259240.stgit@frogsfrogsfrogs>
In-Reply-To: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
References: <172919067797.3449971.379113456204553803.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

xfs_free_ag_extent already has a pointer to the pag structure through
the agf buffer.  Use that instead of passing the redundant argument,
and do the same for the tracepoint.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |   10 ++++------
 fs/xfs/libxfs/xfs_alloc.h |    5 ++---
 fs/xfs/xfs_extfree_item.c |    4 ++--
 fs/xfs/xfs_trace.h        |   11 +++++------
 4 files changed, 13 insertions(+), 17 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 04f64cf9777e21..d36044baa4d65a 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2037,7 +2037,6 @@ int
 xfs_free_ag_extent(
 	struct xfs_trans		*tp,
 	struct xfs_buf			*agbp,
-	xfs_agnumber_t			agno,
 	xfs_agblock_t			bno,
 	xfs_extlen_t			len,
 	const struct xfs_owner_info	*oinfo,
@@ -2358,19 +2357,19 @@ xfs_free_ag_extent(
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
@@ -4012,8 +4011,7 @@ __xfs_free_extent(
 		goto err_release;
 	}
 
-	error = xfs_free_ag_extent(tp, agbp, pag->pag_agno, agbno, len, oinfo,
-			type);
+	error = xfs_free_ag_extent(tp, agbp, agbno, len, oinfo, type);
 	if (error)
 		goto err_release;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 0165452e7cd055..88fbce5001185f 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
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
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index abffc74a924f77..7f1be08dbc1123 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -547,8 +547,8 @@ xfs_agfl_free_finish_item(
 
 	error = xfs_alloc_read_agf(xefi->xefi_pag, tp, 0, &agbp);
 	if (!error)
-		error = xfs_free_ag_extent(tp, agbp, xefi->xefi_pag->pag_agno,
-				agbno, 1, &oinfo, XFS_AG_RESV_AGFL);
+		error = xfs_free_ag_extent(tp, agbp, agbno, 1, &oinfo,
+				XFS_AG_RESV_AGFL);
 
 	xfs_efd_add_extent(efdp, xefi);
 	xfs_extent_free_cancel_item(&xefi->xefi_list);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ee9f0b1f548dc1..3d29329db0dfbd 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1763,10 +1763,9 @@ DEFINE_AGF_EVENT(xfs_agf);
 DEFINE_AGF_EVENT(xfs_agfl_reset);
 
 TRACE_EVENT(xfs_free_extent,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, xfs_agblock_t agbno,
-		 xfs_extlen_t len, enum xfs_ag_resv_type resv, int haveleft,
-		 int haveright),
-	TP_ARGS(mp, agno, agbno, len, resv, haveleft, haveright),
+	TP_PROTO(struct xfs_perag *pag, xfs_agblock_t agbno, xfs_extlen_t len,
+		 enum xfs_ag_resv_type resv, int haveleft, int haveright),
+	TP_ARGS(pag, agbno, len, resv, haveleft, haveright),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -1777,8 +1776,8 @@ TRACE_EVENT(xfs_free_extent,
 		__field(int, haveright)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->agbno = agbno;
 		__entry->len = len;
 		__entry->resv = resv;

