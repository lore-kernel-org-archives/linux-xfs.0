Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4A92107
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607186; cv=none; b=JdslVsENq9ArcIckLKsB/aMNfEa4F7Z6Rl49LwUGnTnaw/sFJRMGhZO1MdnV1K6Gbc0EZeK/oYCN8zh/HKqPXUjkXTCPNOyrDP8n2By59CPBdij/GRo4Ube+V6S2Epu12HH3nFZIfcGHixwlvqIhV6qUc5PRVjn2OM6T4HGv/HE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607186; c=relaxed/simple;
	bh=HwqtZtp0VsiHbp7/jGxsIwn+2bRE9q82oJzNhnzxF9o=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=plBbbkoRaKdTWPu/bO/RejI8ZB51wVHGyBHeB4Gc+DF8N1W54OxAxSNesJQs7yYcdT/DZBC9IzgsrkvWakm56AtoVWJmru2PRXXiW4tQgjXNcdhpXWdgfVbMPPSRjl6dJeVZANqQguo45lRYEYNaAFYD4HtWWogNzCnyuPE2/k8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MyHKHECf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MyHKHECf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69EF3C4CEC5;
	Fri, 11 Oct 2024 00:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607186;
	bh=HwqtZtp0VsiHbp7/jGxsIwn+2bRE9q82oJzNhnzxF9o=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=MyHKHECf2oqqtSxyewTgs258T+soL+ymcxfqx39xwXGhx2ga2uXjSABXc5BJ9cHgz
	 7Jc4yUPUxOJK/zOXkoVjUzt2c9vUztmy/KzjbT+gQ7x/8V7zItJoSP+RPq/jtOpgzE
	 HRNqwUzYX9xb3uqq9Iut+QzpxjoCmm1yRnPUs9wK054ne1qaSnxWiaWlQ1yPJsCXJH
	 AfvZsSpfemFcsOw1uu6Zc9LRxIcgG4wgGhFVErpWhA9HaAcXyNSkVqUWVxeeIvURnr
	 4FI45DECy1qX27oa6Cg8QtQdOmReeB/xwa0t71UbH7+tdZr5IFFTcWtcChedGasdfU
	 dISzWnDJogmPA==
Date: Thu, 10 Oct 2024 17:39:45 -0700
Subject: [PATCH 08/25] xfs: remove the agno argument to xfs_free_ag_extent
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640545.4175438.11702277501626894038.stgit@frogsfrogsfrogs>
In-Reply-To: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
References: <172860640343.4175438.4901957495273325461.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
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
index 59326f84f6a571..fcfb03abbe16a2 100644
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
@@ -4015,8 +4014,7 @@ __xfs_free_extent(
 		goto err_release;
 	}
 
-	error = xfs_free_ag_extent(tp, agbp, pag->pag_agno, agbno, len, oinfo,
-			type);
+	error = xfs_free_ag_extent(tp, agbp, agbno, len, oinfo, type);
 	if (error)
 		goto err_release;
 
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index fae170825be064..90a7fd59762092 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -81,9 +81,8 @@ int xfs_alloc_put_freelist(struct xfs_perag *pag, struct xfs_trans *tp,
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

