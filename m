Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6639B21219E
	for <linux-xfs@vger.kernel.org>; Tue,  5 Nov 2024 22:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730844483; cv=none; b=GYSvYUl0DoEjiyBZlfNjBRsvhhV0mOBHI/FP+oRi9TN0tYxj4bZV2gdHdHQme88v1KlfjOBpu6ZJU0EhchtSMMoBhsUJCZCxsvk9eBngv5e7W9favHA9wUjV4M3QkEeFovS9pQQ6o9cBe3vNS97zHAmw/cnyvrWNT1xmKPhq0uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730844483; c=relaxed/simple;
	bh=8Q0pzjeKgvSbrI7j1EIMw2/AiY83WGhsONqXuk9lcjc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M6VaX5039xsCJcAwd7vtN3z5zpKURDoXOk7gbFm9j3OBLicjn7waTt5CHAe18TKEWzMYcu4CIKJ1whhGXoJ4Ut+onN34+JV2lZTR/uN7KdxsRC0D3MYMvCni+p58TwB4GqzjRsgLaTUEYELDiJ0IP5iY1N89NEMB0JaxxeGQs9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jJZYn287; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jJZYn287"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428DBC4CECF;
	Tue,  5 Nov 2024 22:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730844483;
	bh=8Q0pzjeKgvSbrI7j1EIMw2/AiY83WGhsONqXuk9lcjc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=jJZYn287cpMhSynDkSYL+FybuFXAsJPQI0duMhNXS818XsWdMPaeil+/uCRM4UfQ+
	 ck/zn02kXNtvByEJXTBScV9L6f0XLvTqXrmceV+9YfqFzWxczVjICDje7GmTSE70Sy
	 tVMsRh8s3HciTigEKUnPi03Dp1fZH07fFke5WMXZh0mNIXcyDbe1NW2u9DJCf/rLGa
	 NUYb9wCY5VMwjJtwMQ+GIif+4P4Pm3kqfig/LkeL6idKtFDrj5Z5UQe1t1SM8ybyH9
	 w+QPbh9qA1pg98upvgYpeiHzELmLIiANSm4AFM+dzS0Ta3Hb2ChlVsXghhNZrInO0X
	 dYr6Bluc+wIwg==
Date: Tue, 05 Nov 2024 14:08:02 -0800
Subject: [PATCH 06/23] xfs: remove the agno argument to xfs_free_ag_extent
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173084394551.1868694.13857346412420317097.stgit@frogsfrogsfrogs>
In-Reply-To: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
References: <173084394391.1868694.10289808022146677978.stgit@frogsfrogsfrogs>
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
index 22bdbb3e9980c4..59a240b9462844 100644
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
index fcb2bad4f76e4b..b9baafba031b25 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1758,10 +1758,9 @@ DEFINE_AGF_EVENT(xfs_agf);
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
@@ -1772,8 +1771,8 @@ TRACE_EVENT(xfs_free_extent,
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

