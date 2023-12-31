Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1078BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xd8MumhO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84691C433C7;
	Sun, 31 Dec 2023 21:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704057994;
	bh=2Hb+GgPPiWa5gEnEZZkUbKnLFVutFHHFxMnbJ1jWvSA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Xd8MumhOnfgZBgoY+xDgE1PCrFGIDQ5cQLEBggydJ9U4KSBp7p+RSvTzB9XXoIxvY
	 bUfQb90rV3/d/Q8K/OkxvtUB54nVjO6EvEJHgUYa76RNLZLCUc5nfttpPGxNqfhPsG
	 6BVbS9jb08/UwpECJxIwCoNjjAv5XxQ/khunfYJ0vkAzSMgBTje3d5zSElsjucRgbP
	 gROtLc3sqc0aSYe0D7o5+Q8w9M1SkEiOlwit/jEGSwDOdk5sGJIzNzzlGK6CWdzMNV
	 WzhpjrQ7+Oj5fBwrpzOWVnSswOaTpYzp273413x9FBTtI3iezTRXw8qxtMBdCWeVM2
	 7sahL4rpCK8Kg==
Date: Sun, 31 Dec 2023 13:26:34 -0800
Subject: [PATCH 1/9] xfs: clean up extent free log intent item tracepoint
 callsites
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404848351.1764329.7793913875638606493.stgit@frogsfrogsfrogs>
In-Reply-To: <170404848314.1764329.10362480227353094080.stgit@frogsfrogsfrogs>
References: <170404848314.1764329.10362480227353094080.stgit@frogsfrogsfrogs>
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
index ac31b62e70177..0d8cddb1b41ce 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2573,7 +2573,7 @@ xfs_defer_agfl_block(
 	xefi->xefi_owner = oinfo->oi_owner;
 	xefi->xefi_agresv = XFS_AG_RESV_AGFL;
 
-	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
+	trace_xfs_agfl_free_defer(mp, xefi);
 
 	xfs_extent_free_get_group(mp, xefi);
 	xfs_defer_add(tp, &xefi->xefi_list, &xfs_agfl_free_defer_type);
@@ -2635,9 +2635,8 @@ xfs_defer_extent_free(
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
index 1d1185fca6a58..190d6a69e40b0 100644
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
index db5d2b20b36fc..aafc0735e20ac 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -88,6 +88,7 @@ struct xfs_parent_name_irec;
 struct xfs_attrlist_cursor_kern;
 struct xfs_imeta_update;
 struct xfs_rtgroup;
+struct xfs_extent_free_item;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -2762,41 +2763,37 @@ DEFINE_DEFER_PENDING_EVENT(xfs_defer_item_pause);
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

