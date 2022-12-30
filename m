Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3B25C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:36:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236029AbiLaBgh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:36:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbiLaBgg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:36:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EA3D104
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:36:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA71E61CC3
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FDF9C433D2;
        Sat, 31 Dec 2022 01:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450594;
        bh=s4ReDM+aQFYpMa7aBbGKMnBMMR80nsz4Aq553d0EKzM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LpMbg+maw5+0ZxWce6TlmbHfdfOxpQjAXsMBQUYKUrZWzA1q7JQhZiHtZha90aX7E
         +wvkmTC59Zs1uGjwkkJVJF6oDZWJ7g9NgKUfXFfU7doZN8zkXG8/xVXyIONB3WD51b
         aHM5QU5Wq2ikpsElInQoIQPKPJ0TMEAmNSz6EtgsXpuVkf8qbA1u9jO5ALq2bAWJr/
         wEUUr4a5EzKzcu9Z8nkK9FatRjXlUVpWCr4OsKQpkgZHPfpRLGbfepZHrGZspzKfPR
         I/rYxAOEHTrqYh6e6iqQFYdGMnSCfVAY+qSGWIQfFcy1Es0crS/37oHlMrTnknKEIf
         0cInAhtT8h37A==
Subject: [PATCH 4/5] xfs: clean up rmap log intent item tracepoint callsites
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:12 -0800
Message-ID: <167243869218.714954.9157591086284063825.stgit@magnolia>
In-Reply-To: <167243869156.714954.12346064053546135919.stgit@magnolia>
References: <167243869156.714954.12346064053546135919.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Pass the incore rmap structure to the tracepoints instead of open-coding
the argument passing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_rmap.c |   16 ++-----------
 fs/xfs/libxfs/xfs_rmap.h |   10 ++++++++
 fs/xfs/xfs_trace.c       |    1 +
 fs/xfs/xfs_trace.h       |   57 ++++++++++++++++++++++------------------------
 4 files changed, 41 insertions(+), 43 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 065cb95a1ce7..9ad3e5077f34 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2590,10 +2590,7 @@ xfs_rmap_finish_one(
 
 	bno = XFS_FSB_TO_AGBNO(mp, ri->ri_bmap.br_startblock);
 
-	trace_xfs_rmap_deferred(mp, ri->ri_pag->pag_agno, ri->ri_type, bno,
-			ri->ri_owner, ri->ri_whichfork,
-			ri->ri_bmap.br_startoff, ri->ri_bmap.br_blockcount,
-			ri->ri_bmap.br_state);
+	trace_xfs_rmap_deferred(mp, ri);
 
 	if (XFS_TEST_ERROR(false, mp, XFS_ERRTAG_RMAP_FINISH_ONE))
 		return -EIO;
@@ -2668,15 +2665,6 @@ __xfs_rmap_add(
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
@@ -2684,6 +2672,8 @@ __xfs_rmap_add(
 	ri->ri_whichfork = whichfork;
 	ri->ri_bmap = *bmap;
 
+	trace_xfs_rmap_defer(tp->t_mountp, ri);
+
 	xfs_rmap_update_get_group(tp->t_mountp, ri);
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_RMAP, &ri->ri_list);
 }
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 2a9265218f1d..36af4de506c7 100644
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
index 36109a57fca6..d7ede15110e8 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -43,6 +43,7 @@
 #include "xfs_swapext.h"
 #include "xfs_xchgrange.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rmap.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 3130b8def8ec..fd067e1e28db 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -84,6 +84,7 @@ struct xfs_swapext_intent;
 struct xfs_swapext_req;
 struct xfs_rtgroup;
 struct xfs_extent_free_item;
+struct xfs_rmap_intent;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -2995,20 +2996,22 @@ DEFINE_EVENT(xfs_rmapbt_class, name, \
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
@@ -3018,21 +3021,22 @@ DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
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
@@ -3040,15 +3044,8 @@ DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
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
 

