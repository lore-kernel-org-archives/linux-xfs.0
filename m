Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B79667C6EB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924867; cv=none; b=kd5xgVRkID7ZRNA+7xI4n29GA8RKhZLSxgo44uz2DvmBEXjohYTSSAUmC54Lc3OSiwDDMWao/1Z8LHwOG5hYz3bNQP61zmi8RZku+E1kPi1LIblX9dhecz7WVM2LJp0NZxiDlHTBcsX/mFqhDZr0B5HsqJCoUMiae5vI1rnpimk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924867; c=relaxed/simple;
	bh=/eHaD+XH2de0tGu6FNhU1nm3iAYdFNSLpYPjF+KKZZ0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DMW91dUjemKNq89ubmtlsT22nC9Mx7QS05PuCIBNcoMJ9zU6qMe/C4k4luDtngsD6htHdRoPR6LO/3vyJN8U1Z8vd6kWqi/TEYhScf+YTU+gBYIPiqD1rV8ZPuFHQEcNm5r41yjleH4aao/K8uA6MDJULApUBo63ivQV2aVfqV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V2ena+Uc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V2ena+Uc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 856EFC32781;
	Thu, 20 Jun 2024 23:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924867;
	bh=/eHaD+XH2de0tGu6FNhU1nm3iAYdFNSLpYPjF+KKZZ0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=V2ena+UctAp+rsxr/thfWm/FXwxKBMNwLvFFnobs0TysTtFJ25PVOfoW+qJD02+LV
	 YENvksoT3BI8xkQS86PvIk8AcNgiKawovvONHVT5P4peg9rlqxyZBsn/ircT+YaIfs
	 FeOa7AfWcApz+3vn0uJgDo+YfncEWaTz28Qye3wNrBC/YVIekib93LWDBxe+BKaSow
	 XDkRLUL3a+Vc8E8wDt8lmvMmh3k4zB15j17obWtsJ9ITFihr9LEHwdyzLcD7KuOrvf
	 nUao2Uc2Mnpovfbr4xZ8DwxzmQr1tL1dKQae0JskcVtkVOZ9MzyPeSOqh4u1PO12wj
	 5hsdrzszkAJLw==
Date: Thu, 20 Jun 2024 16:07:47 -0700
Subject: [PATCH 3/9] xfs: clean up rmap log intent item tracepoint callsites
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419284.3184396.11763392908999434569.stgit@frogsfrogsfrogs>
In-Reply-To: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
References: <171892419209.3184396.10441735798864910501.stgit@frogsfrogsfrogs>
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

Pass the incore rmap structure to the tracepoints instead of open-coding
the argument passing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |   22 ++++--------------
 fs/xfs/libxfs/xfs_rmap.h |   10 ++++++++
 fs/xfs/xfs_trace.c       |    1 +
 fs/xfs/xfs_trace.h       |   57 ++++++++++++++++++++++------------------------
 4 files changed, 43 insertions(+), 47 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index ce8ea3c842839..637a4b1db9b98 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2585,20 +2585,15 @@ xfs_rmap_finish_one(
 	struct xfs_rmap_intent		*ri,
 	struct xfs_btree_cur		**pcur)
 {
+	struct xfs_owner_info		oinfo;
 	struct xfs_mount		*mp = tp->t_mountp;
 	struct xfs_btree_cur		*rcur;
 	struct xfs_buf			*agbp = NULL;
-	int				error = 0;
-	struct xfs_owner_info		oinfo;
 	xfs_agblock_t			bno;
 	bool				unwritten;
+	int				error = 0;
 
-	bno = XFS_FSB_TO_AGBNO(mp, ri->ri_bmap.br_startblock);
-
-	trace_xfs_rmap_deferred(mp, ri->ri_pag->pag_agno, ri->ri_type, bno,
-			ri->ri_owner, ri->ri_whichfork,
-			ri->ri_bmap.br_startoff, ri->ri_bmap.br_blockcount,
-			ri->ri_bmap.br_state);
+	trace_xfs_rmap_deferred(mp, ri);
 
 	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_RMAP_FINISH_ONE))
 		return -EIO;
@@ -2673,15 +2668,6 @@ __xfs_rmap_add(
 {
 	struct xfs_rmap_intent		*ri;
 
-	trace_xfs_rmap_defer(tp->t_mountp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, bmap->br_startblock),
-			type,
-			XFS_FSB_TO_AGBNO(tp->t_mountp, bmap->br_startblock),
-			owner, whichfork,
-			bmap->br_startoff,
-			bmap->br_blockcount,
-			bmap->br_state);
-
 	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ri->ri_list);
 	ri->ri_type = type;
@@ -2689,6 +2675,8 @@ __xfs_rmap_add(
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
 
+	trace_xfs_rmap_defer(tp->t_mountp, ri);
+
 	xfs_rmap_update_get_group(tp->t_mountp, ri);
 	xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
 }
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 9d01fe689497b..731c97137b5a0 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -157,6 +157,16 @@ enum xfs_rmap_intent_type {
 	XFS_RMAP_FREE,
 };
 
+#define XFS_RMAP_INTENT_STRINGS \
+	{ XFS_RMAP_MAP,			"map" }, \
+	{ XFS_RMAP_MAP_SHARED,		"map_shared" }, \
+	{ XFS_RMAP_UNMAP,		"unmap" }, \
+	{ XFS_RMAP_UNMAP_SHARED,	"unmap_shared" }, \
+	{ XFS_RMAP_CONVERT,		"cvt" }, \
+	{ XFS_RMAP_CONVERT_SHARED,	"cvt_shared" }, \
+	{ XFS_RMAP_ALLOC,		"alloc" }, \
+	{ XFS_RMAP_FREE,		"free" }
+
 struct xfs_rmap_intent {
 	struct list_head			ri_list;
 	enum xfs_rmap_intent_type		ri_type;
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 9c7fbaae2717d..9bf95c9f7942a 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -42,6 +42,7 @@
 #include "xfs_exchmaps.h"
 #include "xfs_exchrange.h"
 #include "xfs_parent.h"
+#include "xfs_rmap.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 95ea53060bc6d..3ca4605927068 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -91,6 +91,7 @@ struct xfs_getparents;
 struct xfs_parent_irec;
 struct xfs_attrlist_cursor_kern;
 struct xfs_extent_free_item;
+struct xfs_rmap_intent;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -2929,20 +2930,22 @@ DEFINE_EVENT(xfs_rmapbt_class, name, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
 	TP_ARGS(cur, agbno, len, owner, offset, flags))
 
+TRACE_DEFINE_ENUM(XFS_RMAP_MAP);
+TRACE_DEFINE_ENUM(XFS_RMAP_MAP_SHARED);
+TRACE_DEFINE_ENUM(XFS_RMAP_UNMAP);
+TRACE_DEFINE_ENUM(XFS_RMAP_UNMAP_SHARED);
+TRACE_DEFINE_ENUM(XFS_RMAP_CONVERT);
+TRACE_DEFINE_ENUM(XFS_RMAP_CONVERT_SHARED);
+TRACE_DEFINE_ENUM(XFS_RMAP_ALLOC);
+TRACE_DEFINE_ENUM(XFS_RMAP_FREE);
+
 DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 int op,
-		 xfs_agblock_t agbno,
-		 xfs_ino_t ino,
-		 int whichfork,
-		 xfs_fileoff_t offset,
-		 xfs_filblks_t len,
-		 xfs_exntst_t state),
-	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state),
+	TP_PROTO(struct xfs_mount *mp, struct xfs_rmap_intent *ri),
+	TP_ARGS(mp, ri),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(unsigned long long, owner)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_ino_t, ino)
 		__field(xfs_agblock_t, agbno)
 		__field(int, whichfork)
 		__field(xfs_fileoff_t, l_loff)
@@ -2952,21 +2955,22 @@ DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->ino = ino;
-		__entry->agbno = agbno;
-		__entry->whichfork = whichfork;
-		__entry->l_loff = offset;
-		__entry->l_len = len;
-		__entry->l_state = state;
-		__entry->op = op;
+		__entry->agno = XFS_FSB_TO_AGNO(mp, ri->ri_bmap.br_startblock);
+		__entry->agbno = XFS_FSB_TO_AGBNO(mp,
+					ri->ri_bmap.br_startblock);
+		__entry->owner = ri->ri_owner;
+		__entry->whichfork = ri->ri_whichfork;
+		__entry->l_loff = ri->ri_bmap.br_startoff;
+		__entry->l_len = ri->ri_bmap.br_blockcount;
+		__entry->l_state = ri->ri_bmap.br_state;
+		__entry->op = ri->ri_type;
 	),
-	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
+	TP_printk("dev %d:%d op %s agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->op,
+		  __print_symbolic(__entry->op, XFS_RMAP_INTENT_STRINGS),
 		  __entry->agno,
 		  __entry->agbno,
-		  __entry->ino,
+		  __entry->owner,
 		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
 		  __entry->l_loff,
 		  __entry->l_len,
@@ -2974,15 +2978,8 @@ DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
 );
 #define DEFINE_RMAP_DEFERRED_EVENT(name) \
 DEFINE_EVENT(xfs_rmap_deferred_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 int op, \
-		 xfs_agblock_t agbno, \
-		 xfs_ino_t ino, \
-		 int whichfork, \
-		 xfs_fileoff_t offset, \
-		 xfs_filblks_t len, \
-		 xfs_exntst_t state), \
-	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state))
+	TP_PROTO(struct xfs_mount *mp, struct xfs_rmap_intent *ri), \
+	TP_ARGS(mp, ri))
 DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_defer);
 DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_deferred);
 

