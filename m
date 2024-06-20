Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D31C17C6EB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924695; cv=none; b=NFlbQni+6InZDntphwbZKOqXE07+/ujIByADA4jVPvwuayZ4O5oQz0Bkvo+zr+AYoH2dFa8KAr6S/ZcRLgNMovMa7v6f1OPIZ+X2B10HBQbWY+KqUu3V1P0ZRHRACJQEASc/mg37NqQiWFmnchGWfOZUzvgL/HaB6Amq0W9iqPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924695; c=relaxed/simple;
	bh=mzUIO6yu/rElfLdx0PwPgQDR+yF5ZC/H6BJ65rUZSyo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J9A10eZdgrkpbKkjGJV/cWPCtDhrYsYI6Nhg266nyld+ZpI2MQjZkYOFx3Acee4i/oE6xQ2F7b6ADu6qNqSA+2ZGhSQ2AeOLdequL+qQWC854WLx7narjEaIXssaaR8EeHxJwzcGjm1hLGbedmLsGkl9Y3vlNp8j+dem6Mrsrjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FWs+ZcP1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FWs+ZcP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAD14C32781;
	Thu, 20 Jun 2024 23:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924695;
	bh=mzUIO6yu/rElfLdx0PwPgQDR+yF5ZC/H6BJ65rUZSyo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=FWs+ZcP1LoR8bL/Ju2Uq4Ktg5gxnFc9F7CFxuHm8MCk4JsnvVQmMV6bGP6/njR8Xh
	 EMqTPegtoixWQkiRtPKa5kNcgYDmAqUJxsX4OqN5/zeJ/50YKc+Umk9THH5/BFFCwg
	 jS5RRddzZGnSlXE3NFzTnOPAVlANOp06MhQZqvrlzAR8tpEyVIuJS0B74OXzLQ1Crn
	 QgNax15DPt1VlUqxVcpoYWynx6MSBxphRv+U361lex1LoSznNX6PfIXgCgRnouN0cy
	 JBhe4W7faTRgPefEOtjShARQmCpBAy+r4BfMMb2A6m7YOpok7C0LR7KtQSJkzJUwOB
	 qrOfOhzbX2E+A==
Date: Thu, 20 Jun 2024 16:04:55 -0700
Subject: [PATCH 1/9] xfs: clean up extent free log intent item tracepoint
 callsites
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418712.3183906.13356447364652197747.stgit@frogsfrogsfrogs>
In-Reply-To: <171892418670.3183906.4770669498640039656.stgit@frogsfrogsfrogs>
References: <171892418670.3183906.4770669498640039656.stgit@frogsfrogsfrogs>
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

Pass the incore EFI structure to the tracepoints instead of open-coding
the argument passing.  This cleans up the call sites a bit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |    7 +++----
 fs/xfs/xfs_extfree_item.c |    6 ++----
 fs/xfs/xfs_trace.h        |   33 +++++++++++++++------------------
 3 files changed, 20 insertions(+), 26 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 6c55a6e88eba3..9a8110e530b55 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2570,7 +2570,7 @@ xfs_defer_agfl_block(
 	xefi->xefi_owner = oinfo->oi_owner;
 	xefi->xefi_agresv = XFS_AG_RESV_AGFL;
 
-	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
+	trace_xfs_agfl_free_defer(mp, xefi);
 
 	xfs_extent_free_get_group(mp, xefi);
 	xfs_defer_add(tp, &xefi->xefi_list, &xfs_agfl_free_defer_type);
@@ -2632,9 +2632,8 @@ xfs_defer_extent_free(
 	} else {
 		xefi->xefi_owner = XFS_RMAP_OWN_NULL;
 	}
-	trace_xfs_bmap_free_defer(mp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, bno), 0,
-			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
+
+	trace_xfs_extent_free_defer(mp, xefi);
 
 	xfs_extent_free_get_group(mp, xefi);
 	*dfpp = xfs_defer_add(tp, &xefi->xefi_list, &xfs_extent_free_defer_type);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index 8c382f092332c..5d5628903e16f 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -464,8 +464,7 @@ xfs_extent_free_finish_item(
 	if (xefi->xefi_flags & XFS_EFI_BMBT_BLOCK)
 		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
 
-	trace_xfs_bmap_free_deferred(tp->t_mountp, xefi->xefi_pag->pag_agno, 0,
-			agbno, xefi->xefi_blockcount);
+	trace_xfs_extent_free_deferred(mp, xefi);
 
 	/*
 	 * If we need a new transaction to make progress, the caller will log a
@@ -542,8 +541,7 @@ xfs_agfl_free_finish_item(
 	agbno = XFS_FSB_TO_AGBNO(mp, xefi->xefi_startblock);
 	oinfo.oi_owner = xefi->xefi_owner;
 
-	trace_xfs_agfl_free_deferred(mp, xefi->xefi_pag->pag_agno, 0, agbno,
-			xefi->xefi_blockcount);
+	trace_xfs_agfl_free_deferred(mp, xefi);
 
 	error = xfs_alloc_read_agf(xefi->xefi_pag, tp, 0, &agbp);
 	if (!error)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 25ff6fe1eb6c8..438e88a9fd1d3 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -90,6 +90,7 @@ struct xfs_exchrange;
 struct xfs_getparents;
 struct xfs_parent_irec;
 struct xfs_attrlist_cursor_kern;
+struct xfs_extent_free_item;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -2681,41 +2682,37 @@ DEFINE_DEFER_PENDING_EVENT(xfs_defer_item_pause);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_item_unpause);
 
 DECLARE_EVENT_CLASS(xfs_free_extent_deferred_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 int type, xfs_agblock_t agbno, xfs_extlen_t len),
-	TP_ARGS(mp, agno, type, agbno, len),
+	TP_PROTO(struct xfs_mount *mp, struct xfs_extent_free_item *free),
+	TP_ARGS(mp, free),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
-		__field(int, type)
 		__field(xfs_agblock_t, agbno)
 		__field(xfs_extlen_t, len)
+		__field(unsigned int, flags)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->type = type;
-		__entry->agbno = agbno;
-		__entry->len = len;
+		__entry->agno = XFS_FSB_TO_AGNO(mp, free->xefi_startblock);
+		__entry->agbno = XFS_FSB_TO_AGBNO(mp, free->xefi_startblock);
+		__entry->len = free->xefi_blockcount;
+		__entry->flags = free->xefi_flags;
 	),
-	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x fsbcount 0x%x",
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->type,
 		  __entry->agno,
 		  __entry->agbno,
-		  __entry->len)
+		  __entry->len,
+		  __entry->flags)
 );
 #define DEFINE_FREE_EXTENT_DEFERRED_EVENT(name) \
 DEFINE_EVENT(xfs_free_extent_deferred_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 int type, \
-		 xfs_agblock_t bno, \
-		 xfs_extlen_t len), \
-	TP_ARGS(mp, agno, type, bno, len))
-DEFINE_FREE_EXTENT_DEFERRED_EVENT(xfs_bmap_free_defer);
-DEFINE_FREE_EXTENT_DEFERRED_EVENT(xfs_bmap_free_deferred);
+	TP_PROTO(struct xfs_mount *mp, struct xfs_extent_free_item *free), \
+	TP_ARGS(mp, free))
 DEFINE_FREE_EXTENT_DEFERRED_EVENT(xfs_agfl_free_defer);
 DEFINE_FREE_EXTENT_DEFERRED_EVENT(xfs_agfl_free_deferred);
+DEFINE_FREE_EXTENT_DEFERRED_EVENT(xfs_extent_free_defer);
+DEFINE_FREE_EXTENT_DEFERRED_EVENT(xfs_extent_free_deferred);
 
 DECLARE_EVENT_CLASS(xfs_defer_pending_item_class,
 	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_pending *dfp,

