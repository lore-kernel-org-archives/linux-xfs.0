Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6649CBA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CEgK9C5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7CBC433C8;
	Sun, 31 Dec 2023 21:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058213;
	bh=pyD4K9I0bA0CKOpzEbkELQCGkrho/POCGSeBqzu41f0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=CEgK9C5u8GibRaS1AvCHBN48BW5XbPmVKX1h8cpRp93Tn+AggmoSFOmipt1g6hmy3
	 iKDmfR+WvHPAVR4rpFLgT5Q7pDAFJKxTDKRHZDLTBZVhQ4vJPD1xUkEVZPogUNWib5
	 XV7CUhJ0EmmjFx0oPXRepYEDXl6+77UVgj551Z6KtCGRiGmetEcM8OaN0SSiThZ+YX
	 mzPJ2HVBFvKEAigqk4cJ9jTJRhTM/kX8BF1/4o1T0uw+AdxtvGEpewcGB774uXFjxP
	 aknaTGqFWg4GObzmPIZKhKpnHcMwWrR4DFD9ot1PAOZK3Ghxq1SHAiUfhzumomzSaH
	 wMnyuB/ynVzaA==
Date: Sun, 31 Dec 2023 13:30:13 -0800
Subject: [PATCH 04/10] xfs: clean up rmap log intent item tracepoint callsites
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404849298.1764703.6855611545700371019.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
References: <170404849212.1764703.16534369828563181378.stgit@frogsfrogsfrogs>
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
index b8425ae7807cc..628f337a8eee1 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2576,20 +2576,15 @@ xfs_rmap_finish_one(
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
@@ -2664,15 +2659,6 @@ __xfs_rmap_add(
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
 	ri = kmem_cache_alloc(xfs_rmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ri->ri_list);
 	ri->ri_type = type;
@@ -2680,6 +2666,8 @@ __xfs_rmap_add(
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
 
+	trace_xfs_rmap_defer(tp->t_mountp, ri);
+
 	xfs_rmap_update_get_group(tp->t_mountp, ri);
 	xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
 }
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 3a153b4801b46..f16b07d851d32 100644
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
index 21f55b0125fc4..8a990a2fa132f 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -45,6 +45,7 @@
 #include "xfs_parent.h"
 #include "xfs_imeta.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rmap.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 67c73e1d9b95c..9290a02bac99e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -89,6 +89,7 @@ struct xfs_attrlist_cursor_kern;
 struct xfs_imeta_update;
 struct xfs_rtgroup;
 struct xfs_extent_free_item;
+struct xfs_rmap_intent;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -2999,20 +3000,22 @@ DEFINE_EVENT(xfs_rmapbt_class, name, \
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
@@ -3022,21 +3025,22 @@ DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
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
@@ -3044,15 +3048,8 @@ DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
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
 

