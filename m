Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F634C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:47:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231435AbiLaBrt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:47:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236064AbiLaBrs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:47:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D81111DDD3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:47:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 749C261CC6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A5CC433D2;
        Sat, 31 Dec 2022 01:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451266;
        bh=qH22dh3BXzIYKcXNBx+CZIyiQjxlewuKcZ486+d94UY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gNmy55wHSn/YLNQze5kuDa+lmoerIT9wWchEipi74BmXwVT1fED1MV26AJ8EmRisI
         hYWoY71EE7/69XM9o69CAYV2N4Fc6XAmM9iOxOGp/doMDwcnF42JUm/tiGvZOuo5/d
         CCGB3keNfgLoTpPm3gXQl0MmNrdfExeptsHZEspEfWTt2g4Yko8m+rT6hFiOt3y4+h
         5z+7FEm+hPHDmslHULfv8QCOxcUDSpcu40xetMQ8Ix3+gCfe2oDhVh+iqvqAXFWs3U
         rL4KwfmXH3Spn1mWAXi445DJOoYY+3ay5Nem11BjF9DG2F8x51KwXDiPojqzlUi3o2
         bKgXs5lAT5D8w==
Subject: [PATCH 4/5] xfs: clean up refcount log intent item tracepoint
 callsites
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:25 -0800
Message-ID: <167243870501.716629.14870719836589439822.stgit@magnolia>
In-Reply-To: <167243870440.716629.17983217257958002785.stgit@magnolia>
References: <167243870440.716629.17983217257958002785.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index 4c6ed75059c8..3d2269c6855a 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1369,9 +1369,7 @@ xfs_refcount_finish_one(
 
 	bno = XFS_FSB_TO_AGBNO(mp, ri->ri_startblock);
 
-	trace_xfs_refcount_deferred(mp, XFS_FSB_TO_AGNO(mp, ri->ri_startblock),
-			ri->ri_type, XFS_FSB_TO_AGBNO(mp, ri->ri_startblock),
-			ri->ri_blockcount);
+	trace_xfs_refcount_deferred(mp, ri);
 
 	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_REFCOUNT_FINISH_ONE))
 		return -EIO;
@@ -1434,8 +1432,7 @@ xfs_refcount_finish_one(
 		return -EFSCORRUPTED;
 	}
 	if (!error && ri->ri_blockcount > 0)
-		trace_xfs_refcount_finish_one_leftover(mp, ri->ri_pag->pag_agno,
-				ri->ri_type, bno, ri->ri_blockcount);
+		trace_xfs_refcount_finish_one_leftover(mp, ri);
 	return error;
 }
 
@@ -1451,11 +1448,6 @@ __xfs_refcount_add(
 {
 	struct xfs_refcount_intent	*ri;
 
-	trace_xfs_refcount_defer(tp->t_mountp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, startblock),
-			type, XFS_FSB_TO_AGBNO(tp->t_mountp, startblock),
-			blockcount);
-
 	ri = kmem_cache_alloc(xfs_refcount_intent_cache,
 			GFP_NOFS | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&ri->ri_list);
@@ -1463,6 +1455,8 @@ __xfs_refcount_add(
 	ri->ri_startblock = startblock;
 	ri->ri_blockcount = blockcount;
 
+	trace_xfs_refcount_defer(tp->t_mountp, ri);
+
 	xfs_refcount_update_get_group(tp->t_mountp, ri);
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_REFCOUNT, &ri->ri_list);
 }
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 9563eb91be17..7713bb908bdc 100644
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
index ae35868e0638..0b9405749079 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -44,6 +44,7 @@
 #include "xfs_xchgrange.h"
 #include "xfs_rtgroup.h"
 #include "xfs_rmap.h"
+#include "xfs_refcount.h"
 
 static inline void
 xfs_rmapbt_crack_agno_opdev(
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 233c611b6018..c22ffe459002 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -89,6 +89,7 @@ struct xfs_swapext_req;
 struct xfs_rtgroup;
 struct xfs_extent_free_item;
 struct xfs_rmap_intent;
+struct xfs_refcount_intent;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -3555,66 +3556,42 @@ DEFINE_REFCOUNT_EVENT(xfs_refcount_find_shared);
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

