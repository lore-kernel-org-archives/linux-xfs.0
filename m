Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 810C65256
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728607405; cv=none; b=e9MTU+lvYfWo4KFqXzt5LMaZWV6406F9VVsq7zjpeHf2z5j1MoeEIPLEUPTt6Pu/lXCxiFWeyBUqNcIlL51Xar1HawEArfvT1+UkFQcjcOah5smIpGob3COkXMfJuK9tmc5NBqf3mgvtm10sHDa8touhFi1XLa6mLIGdvuWnTg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728607405; c=relaxed/simple;
	bh=oP8YyPbY/LjWkNfkurCz6SmDqb2I8li3/xTtQ1Za32Q=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=j8t4Zh0DhtrKz3CkG4EEZbq4hpqAdmv9VP8Dwl8Yoo8mn73OCrNTYRUE8/miNqfOX8qBOtJO0XazYla9AHFFU1PHzEr9XdHBSha5qTPq+U4LvnZ5r16aaEEihy439ec06OcVaI3IGSnTK4opSaVwpCG+IPlfZdVws1fWiukLMjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qf61xUQk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qf61xUQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AA9C4CEC5;
	Fri, 11 Oct 2024 00:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728607405;
	bh=oP8YyPbY/LjWkNfkurCz6SmDqb2I8li3/xTtQ1Za32Q=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=qf61xUQkkT7NMGtSy9DgGNrP/oVbtXDGixzy/Fr06qTzUoCZBo1R5s7q/FGMmdI6f
	 JdVBIIJ1hOfDEOhRAF2Icbn4Yjohs62Hsj8HQHspCRS+QZg1fMLzp8hD/68h36dKBm
	 XOICvLq1Qie96LARmTwfb47fZhuRfDz5Wy8u7sgoQPorqN+/o1ZWaHdiU3ss58JaQL
	 SQvZknogeNjW2cknrN0kUA2fp46jXuW2LIQQ92h7blOasW5XZOOehS10HTLScUGXqt
	 xKAwCgRZ8Z2OH6jnrZO1V4CpvUE4JPc7UPoZXcZXtmORSCxe6VLRUoeiqTVKAVCSfb
	 1GnRS0E2VTmqQ==
Date: Thu, 10 Oct 2024 17:43:24 -0700
Subject: [PATCH 22/25] xfs: pass the pag to the xrep_newbt_extent_class
 tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860640790.4175438.14514449143968123995.stgit@frogsfrogsfrogs>
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

This requires moving a few of the callsites a little bit to ensure that
we already have the reference, but allows for the decoding to only happen
when tracing is actually enabled, and cleans up the callsites a bit.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/alloc_repair.c |    8 ++++----
 fs/xfs/scrub/newbt.c        |   29 +++++++++++++----------------
 fs/xfs/scrub/trace.h        |   16 +++++++---------
 3 files changed, 24 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 30295898cc8a63..6fd0e193f0b739 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -484,8 +484,8 @@ xrep_abt_reserve_space(
 		ASSERT(arec.ar_blockcount <= UINT_MAX);
 		len = min_t(unsigned int, arec.ar_blockcount, desired);
 
-		trace_xrep_newbt_alloc_ag_blocks(sc->mp, sc->sa.pag->pag_agno,
-				arec.ar_startblock, len, XFS_RMAP_OWN_AG);
+		trace_xrep_newbt_alloc_ag_blocks(sc->sa.pag, arec.ar_startblock,
+				len, XFS_RMAP_OWN_AG);
 
 		error = xrep_newbt_add_extent(&ra->new_bnobt, sc->sa.pag,
 				arec.ar_startblock, len);
@@ -554,8 +554,8 @@ xrep_abt_dispose_one(
 	if (free_aglen == 0)
 		return 0;
 
-	trace_xrep_newbt_free_blocks(sc->mp, resv->pag->pag_agno, free_agbno,
-			free_aglen, ra->new_bnobt.oinfo.oi_owner);
+	trace_xrep_newbt_free_blocks(resv->pag, free_agbno, free_aglen,
+			ra->new_bnobt.oinfo.oi_owner);
 
 	error = __xfs_free_extent(sc->tp, resv->pag, free_agbno, free_aglen,
 			&ra->new_bnobt.oinfo, XFS_AG_RESV_IGNORE, true);
diff --git a/fs/xfs/scrub/newbt.c b/fs/xfs/scrub/newbt.c
index baa00e1cf81ab2..81cad6c4fe6d9d 100644
--- a/fs/xfs/scrub/newbt.c
+++ b/fs/xfs/scrub/newbt.c
@@ -250,16 +250,15 @@ xrep_newbt_alloc_ag_blocks(
 			return -ENOSPC;
 
 		agno = XFS_FSB_TO_AGNO(mp, args.fsbno);
-
-		trace_xrep_newbt_alloc_ag_blocks(mp, agno,
-				XFS_FSB_TO_AGBNO(mp, args.fsbno), args.len,
-				xnr->oinfo.oi_owner);
-
 		if (agno != sc->sa.pag->pag_agno) {
 			ASSERT(agno == sc->sa.pag->pag_agno);
 			return -EFSCORRUPTED;
 		}
 
+		trace_xrep_newbt_alloc_ag_blocks(sc->sa.pag,
+				XFS_FSB_TO_AGBNO(mp, args.fsbno), args.len,
+				xnr->oinfo.oi_owner);
+
 		error = xrep_newbt_add_blocks(xnr, sc->sa.pag, &args);
 		if (error)
 			return error;
@@ -325,16 +324,16 @@ xrep_newbt_alloc_file_blocks(
 
 		agno = XFS_FSB_TO_AGNO(mp, args.fsbno);
 
-		trace_xrep_newbt_alloc_file_blocks(mp, agno,
-				XFS_FSB_TO_AGBNO(mp, args.fsbno), args.len,
-				xnr->oinfo.oi_owner);
-
 		pag = xfs_perag_get(mp, agno);
 		if (!pag) {
 			ASSERT(0);
 			return -EFSCORRUPTED;
 		}
 
+		trace_xrep_newbt_alloc_file_blocks(pag,
+				XFS_FSB_TO_AGBNO(mp, args.fsbno), args.len,
+				xnr->oinfo.oi_owner);
+
 		error = xrep_newbt_add_blocks(xnr, pag, &args);
 		xfs_perag_put(pag);
 		if (error)
@@ -383,8 +382,8 @@ xrep_newbt_free_extent(
 		 * space reservation, let the existing EFI free the entire
 		 * space extent.
 		 */
-		trace_xrep_newbt_free_blocks(sc->mp, resv->pag->pag_agno,
-				free_agbno, free_aglen, xnr->oinfo.oi_owner);
+		trace_xrep_newbt_free_blocks(resv->pag, free_agbno, free_aglen,
+				xnr->oinfo.oi_owner);
 		xfs_alloc_commit_autoreap(sc->tp, &resv->autoreap);
 		return 1;
 	}
@@ -401,8 +400,8 @@ xrep_newbt_free_extent(
 	if (free_aglen == 0)
 		return 0;
 
-	trace_xrep_newbt_free_blocks(sc->mp, resv->pag->pag_agno, free_agbno,
-			free_aglen, xnr->oinfo.oi_owner);
+	trace_xrep_newbt_free_blocks(resv->pag, free_agbno, free_aglen,
+			xnr->oinfo.oi_owner);
 
 	ASSERT(xnr->resv != XFS_AG_RESV_AGFL);
 	ASSERT(xnr->resv != XFS_AG_RESV_IGNORE);
@@ -514,7 +513,6 @@ xrep_newbt_claim_block(
 	union xfs_btree_ptr	*ptr)
 {
 	struct xrep_newbt_resv	*resv;
-	struct xfs_mount	*mp = cur->bc_mp;
 	xfs_agblock_t		agbno;
 
 	/*
@@ -539,8 +537,7 @@ xrep_newbt_claim_block(
 	if (resv->used == resv->len)
 		list_move_tail(&resv->list, &xnr->resv_list);
 
-	trace_xrep_newbt_claim_block(mp, resv->pag->pag_agno, agbno, 1,
-			xnr->oinfo.oi_owner);
+	trace_xrep_newbt_claim_block(resv->pag, agbno, 1, xnr->oinfo.oi_owner);
 
 	if (cur->bc_ops->ptr_len == XFS_BTREE_LONG_PTR_LEN)
 		ptr->l = cpu_to_be64(xfs_agbno_to_fsb(resv->pag, agbno));
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 0da641f046f3a7..16c275cb6520de 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2272,10 +2272,9 @@ TRACE_EVENT(xrep_reset_counters,
 )
 
 DECLARE_EVENT_CLASS(xrep_newbt_extent_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_extlen_t len,
-		 int64_t owner),
-	TP_ARGS(mp, agno, agbno, len, owner),
+	TP_PROTO(const struct xfs_perag *pag, xfs_agblock_t agbno,
+		 xfs_extlen_t len, int64_t owner),
+	TP_ARGS(pag, agbno, len, owner),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -2284,8 +2283,8 @@ DECLARE_EVENT_CLASS(xrep_newbt_extent_class,
 		__field(int64_t, owner)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = pag->pag_mount->m_super->s_dev;
+		__entry->agno = pag->pag_agno;
 		__entry->agbno = agbno;
 		__entry->len = len;
 		__entry->owner = owner;
@@ -2299,10 +2298,9 @@ DECLARE_EVENT_CLASS(xrep_newbt_extent_class,
 );
 #define DEFINE_NEWBT_EXTENT_EVENT(name) \
 DEFINE_EVENT(xrep_newbt_extent_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 xfs_agblock_t agbno, xfs_extlen_t len, \
+	TP_PROTO(struct xfs_perag *pag, xfs_agblock_t agbno, xfs_extlen_t len, \
 		 int64_t owner), \
-	TP_ARGS(mp, agno, agbno, len, owner))
+	TP_ARGS(pag, agbno, len, owner))
 DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_alloc_ag_blocks);
 DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_alloc_file_blocks);
 DEFINE_NEWBT_EXTENT_EVENT(xrep_newbt_free_blocks);

