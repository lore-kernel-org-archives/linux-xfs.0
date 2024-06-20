Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1D8147C74
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718925024; cv=none; b=pOVHBSLctznTHOKmItjTUgY5ve8Hz9tnd2Gz4cqU4ne4uiMDmFTeA/nFfdVepxJZcu/xwMPOkbqfMQFkkS46UIdLT4v1iZqpVZBoFW62SPb3eNwM5wiXaJEgqO5mc3pNKTEIFkQAXbvumoNFK7pxRz8yGoWfiqJUmYVsHgwqoSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718925024; c=relaxed/simple;
	bh=aGOv23waCZGm+eo3tnji7q0liNVjNxlYQMD6w3O9uPQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q31jk58DrrG32lBYRIvyGKQ3Yr/tnnBdTvw+QAbwfZyFXaTYXlL9ttMCjqDJ/eI4yQ1x1xbqQGMNRrV8LMiDxDGlm2mvhDNMbuhYka9OIZ5iJBBP74T7Lk7nyJpXxtREe/aYbbb6I19GcrRFL+FTl4bq5TGxqimawkOq0I3uw8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BalZ7Dxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BalZ7Dxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1348C4AF08;
	Thu, 20 Jun 2024 23:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718925023;
	bh=aGOv23waCZGm+eo3tnji7q0liNVjNxlYQMD6w3O9uPQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BalZ7Dxm1cxl3Gfq1U8HFlbiNyryVjXkric3bKnAORoNBa3RW6B9IDDz0qgOf+E+a
	 TKqj8OqZQheaxBhWHgS5KgFVyVLEz8kOSvvMzyS6eH9N7JEjk3W+sCHrYoJm3aUBgw
	 DhYLkYsVhLP4yMKj1o1NoXDxy+T3ew70z19Yl59tydS5sXdDk/xg/kA9sc1Ir41qXq
	 4BLksVhz+w7BQDa2OJlBXhzivaMAreGvCjFAb/teWyN3Ea7gZXQVvC30uiYbaaanez
	 m3Jng7mSZLsMa/EtWeoaC5jqul/YHhIe6P5yYFbUnq7OIpQ8exwOrMdvEMrY4XLYz1
	 JThq2V2Bb7+vQ==
Date: Thu, 20 Jun 2024 16:10:23 -0700
Subject: [PATCH 04/10] xfs: clean up refcount log intent item tracepoint
 callsites
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419841.3184748.9309858987645162456.stgit@frogsfrogsfrogs>
In-Reply-To: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
References: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
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

Pass the incore refcount intent structure to the tracepoints instead of
open-coding the argument passing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |   14 +++-------
 fs/xfs/libxfs/xfs_refcount.h |    6 ++++
 fs/xfs/xfs_trace.c           |    1 +
 fs/xfs/xfs_trace.h           |   59 +++++++++++++-----------------------------
 4 files changed, 29 insertions(+), 51 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index b777762494e7f..c0572bb86cdb8 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1367,9 +1367,7 @@ xfs_refcount_finish_one(
 
 	bno = XFS_FSB_TO_AGBNO(mp, ri->ri_startblock);
 
-	trace_xfs_refcount_deferred(mp, XFS_FSB_TO_AGNO(mp, ri->ri_startblock),
-			ri->ri_type, XFS_FSB_TO_AGBNO(mp, ri->ri_startblock),
-			ri->ri_blockcount);
+	trace_xfs_refcount_deferred(mp, ri);
 
 	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE))
 		return -EIO;
@@ -1432,8 +1430,7 @@ xfs_refcount_finish_one(
 		return -EFSCORRUPTED;
 	}
 	if (!error && ri->ri_blockcount > 0)
-		trace_xfs_refcount_finish_one_leftover(mp, ri->ri_pag->pag_agno,
-				ri->ri_type, bno, ri->ri_blockcount);
+		trace_xfs_refcount_finish_one_leftover(mp, ri);
 	return error;
 }
 
@@ -1449,11 +1446,6 @@ __xfs_refcount_add(
 {
 	struct xfs_refcount_intent	*ri;
 
-	trace_xfs_refcount_defer(tp->t_mountp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, startblock),
-			type, XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
-			blockcount);
-
 	ri = kmem_cache_alloc(xfs_refcount_intent_cache,
 			GFP_KERNEL | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ri->ri_list);
@@ -1461,6 +1453,8 @@ __xfs_refcount_add(
 	ri->ri_startblock = startblock;
 	ri->ri_blockcount = blockcount;
 
+	trace_xfs_refcount_defer(tp->t_mountp, ri);
+
 	xfs_refcount_update_get_group(tp->t_mountp, ri);
 	xfs_defer_add(tp, &ri->ri_list, &xfs_refcount_update_defer_type);
 }
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 9b56768a590c0..01a20621192ed 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -48,6 +48,12 @@ enum xfs_refcount_intent_type {
 	XFS_REFCOUNT_FREE_COW,
 };
 
+#define XFS_REFCOUNT_INTENT_STRINGS \
+	{ XFS_REFCOUNT_INCREASE,	"incr" }, \
+	{ XFS_REFCOUNT_DECREASE,	"decr" }, \
+	{ XFS_REFCOUNT_ALLOC_COW,	"alloc_cow" }, \
+	{ XFS_REFCOUNT_FREE_COW,	"free_cow" }
+
 struct xfs_refcount_intent {
 	struct list_head			ri_list;
 	struct xfs_perag			*ri_pag;
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 9bf95c9f7942a..dd0ce46089194 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -43,6 +43,7 @@
 #include "xfs_exchrange.h"
 #include "xfs_parent.h"
 #include "xfs_rmap.h"
+#include "xfs_refcount.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f1f2f661d64db..654ad6f574680 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -92,6 +92,7 @@ struct xfs_parent_irec;
 struct xfs_attrlist_cursor_kern;
 struct xfs_extent_free_item;
 struct xfs_rmap_intent;
+struct xfs_refcount_intent;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -3474,66 +3475,42 @@ DEFINE_REFCOUNT_EVENT(xfs_refcount_find_shared);
 DEFINE_REFCOUNT_EVENT(xfs_refcount_find_shared_result);
 DEFINE_BTREE_ERROR_EVENT(xfs_refcount_find_shared_error);
 
+TRACE_DEFINE_ENUM(XFS_REFCOUNT_INCREASE);
+TRACE_DEFINE_ENUM(XFS_REFCOUNT_DECREASE);
+TRACE_DEFINE_ENUM(XFS_REFCOUNT_ALLOC_COW);
+TRACE_DEFINE_ENUM(XFS_REFCOUNT_FREE_COW);
+
 DECLARE_EVENT_CLASS(xfs_refcount_deferred_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 int type, xfs_agblock_t agbno, xfs_extlen_t len),
-	TP_ARGS(mp, agno, type, agbno, len),
+	TP_PROTO(struct xfs_mount *mp, struct xfs_refcount_intent *refc),
+	TP_ARGS(mp, refc),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
-		__field(int, type)
+		__field(int, op)
 		__field(xfs_agblock_t, agbno)
 		__field(xfs_extlen_t, len)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->type = type;
-		__entry->agbno = agbno;
-		__entry->len = len;
+		__entry->agno = XFS_FSB_TO_AGNO(mp, refc->ri_startblock);
+		__entry->op = refc->ri_type;
+		__entry->agbno = XFS_FSB_TO_AGBNO(mp, refc->ri_startblock);
+		__entry->len = refc->ri_blockcount;
 	),
-	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x fsbcount 0x%x",
+	TP_printk("dev %d:%d op %s agno 0x%x agbno 0x%x fsbcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->type,
+		  __print_symbolic(__entry->op, XFS_REFCOUNT_INTENT_STRINGS),
 		  __entry->agno,
 		  __entry->agbno,
 		  __entry->len)
 );
 #define DEFINE_REFCOUNT_DEFERRED_EVENT(name) \
 DEFINE_EVENT(xfs_refcount_deferred_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 int type, \
-		 xfs_agblock_t bno, \
-		 xfs_extlen_t len), \
-	TP_ARGS(mp, agno, type, bno, len))
+	TP_PROTO(struct xfs_mount *mp, struct xfs_refcount_intent *refc), \
+	TP_ARGS(mp, refc))
 DEFINE_REFCOUNT_DEFERRED_EVENT(xfs_refcount_defer);
 DEFINE_REFCOUNT_DEFERRED_EVENT(xfs_refcount_deferred);
-
-TRACE_EVENT(xfs_refcount_finish_one_leftover,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 int type, xfs_agblock_t agbno, xfs_extlen_t len),
-	TP_ARGS(mp, agno, type, agbno, len),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
-		__field(int, type)
-		__field(xfs_agblock_t, agbno)
-		__field(xfs_extlen_t, len)
-	),
-	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->type = type;
-		__entry->agbno = agbno;
-		__entry->len = len;
-	),
-	TP_printk("dev %d:%d type %d agno 0x%x agbno 0x%x fsbcount 0x%x",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->type,
-		  __entry->agno,
-		  __entry->agbno,
-		  __entry->len)
-);
+DEFINE_REFCOUNT_DEFERRED_EVENT(xfs_refcount_finish_one_leftover);
 
 /* simple inode-based error/%ip tracepoint class */
 DECLARE_EVENT_CLASS(xfs_inode_error_class,

