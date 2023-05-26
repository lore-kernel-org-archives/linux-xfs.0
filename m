Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AD46C77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjEZBLt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjEZBLs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:11:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE7419C
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:11:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABDED60C3F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:11:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C095C433D2;
        Fri, 26 May 2023 01:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063497;
        bh=AMDtmPg/3hwBadg8xbicB98/n4WzzknpEvmPRwFCy+4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=hO8CtNzrsiNO7MaF9uALvvIGlLHN6WFWkFNTeHbXdaMNf8Xmi7ZzCdVJWYgNJwwIY
         V5iLtSGboR9yKU95CUtEqo5Bts83OT9wdFQwoN+BcC2VwIJN28BcIBXcpy1ZisgKkl
         dXqEppTZnLSPlew1fmDTR/t/2naTNBub1/2yM+g7BwT1gCuSeMzDOO6cL5/380tHR/
         0LZBFEP00Y1kIVtj5PeGLEIM4GpVyysM04P64yjmUKC9FFAl49FNNTLUdPGcxxzpx0
         v2Y3XWtxiwzVsGHyiyMjm7VXBoqQcc9VN1pITWtG9oq/9gpSRavewJFtmcDbUAEKt6
         0NyC2S48cIkMw==
Date:   Thu, 25 May 2023 18:11:36 -0700
Subject: [PATCH 1/3] xfs: split tracepoint classes for deferred items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506063504.3733930.13997697712800734423.stgit@frogsfrogsfrogs>
In-Reply-To: <168506063487.3733930.3765429104183077810.stgit@frogsfrogsfrogs>
References: <168506063487.3733930.3765429104183077810.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

We're about to start adding support for deferred log intent items for
realtime extents, so split these four types into separate classes so
that we can customize them as the transition happens.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trace.h |  273 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 177 insertions(+), 96 deletions(-)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ff4b14034cd0..2e20b1edcab8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2685,94 +2685,6 @@ DEFINE_EVENT(xfs_defer_pending_class, name, \
 	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_pending *dfp), \
 	TP_ARGS(mp, dfp))
 
-DECLARE_EVENT_CLASS(xfs_phys_extent_deferred_class,
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
-	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x fsbcount 0x%x",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->type,
-		  __entry->agno,
-		  __entry->agbno,
-		  __entry->len)
-);
-#define DEFINE_PHYS_EXTENT_DEFERRED_EVENT(name) \
-DEFINE_EVENT(xfs_phys_extent_deferred_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 int type, \
-		 xfs_agblock_t bno, \
-		 xfs_extlen_t len), \
-	TP_ARGS(mp, agno, type, bno, len))
-
-DECLARE_EVENT_CLASS(xfs_map_extent_deferred_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 int op,
-		 xfs_agblock_t agbno,
-		 xfs_ino_t ino,
-		 int whichfork,
-		 xfs_fileoff_t offset,
-		 xfs_filblks_t len,
-		 xfs_exntst_t state),
-	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
-		__field(xfs_ino_t, ino)
-		__field(xfs_agblock_t, agbno)
-		__field(int, whichfork)
-		__field(xfs_fileoff_t, l_loff)
-		__field(xfs_filblks_t, l_len)
-		__field(xfs_exntst_t, l_state)
-		__field(int, op)
-	),
-	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->ino = ino;
-		__entry->agbno = agbno;
-		__entry->whichfork = whichfork;
-		__entry->l_loff = offset;
-		__entry->l_len = len;
-		__entry->l_state = state;
-		__entry->op = op;
-	),
-	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->op,
-		  __entry->agno,
-		  __entry->agbno,
-		  __entry->ino,
-		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
-		  __entry->l_loff,
-		  __entry->l_len,
-		  __entry->l_state)
-);
-#define DEFINE_MAP_EXTENT_DEFERRED_EVENT(name) \
-DEFINE_EVENT(xfs_map_extent_deferred_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 int op, \
-		 xfs_agblock_t agbno, \
-		 xfs_ino_t ino, \
-		 int whichfork, \
-		 xfs_fileoff_t offset, \
-		 xfs_filblks_t len, \
-		 xfs_exntst_t state), \
-	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state))
-
 DEFINE_DEFER_EVENT(xfs_defer_cancel);
 DEFINE_DEFER_EVENT(xfs_defer_trans_roll);
 DEFINE_DEFER_EVENT(xfs_defer_trans_abort);
@@ -2788,11 +2700,42 @@ DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_relog_intent);
 
-#define DEFINE_BMAP_FREE_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
-DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_defer);
-DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_deferred);
-DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_agfl_free_defer);
-DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_agfl_free_deferred);
+DECLARE_EVENT_CLASS(xfs_free_extent_deferred_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 int type, xfs_agblock_t agbno, xfs_extlen_t len),
+	TP_ARGS(mp, agno, type, agbno, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(int, type)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->type = type;
+		__entry->agbno = agbno;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x fsbcount 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->type,
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len)
+);
+#define DEFINE_FREE_EXTENT_DEFERRED_EVENT(name) \
+DEFINE_EVENT(xfs_free_extent_deferred_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 int type, \
+		 xfs_agblock_t bno, \
+		 xfs_extlen_t len), \
+	TP_ARGS(mp, agno, type, bno, len))
+DEFINE_FREE_EXTENT_DEFERRED_EVENT(xfs_bmap_free_defer);
+DEFINE_FREE_EXTENT_DEFERRED_EVENT(xfs_bmap_free_deferred);
+DEFINE_FREE_EXTENT_DEFERRED_EVENT(xfs_agfl_free_defer);
+DEFINE_FREE_EXTENT_DEFERRED_EVENT(xfs_agfl_free_deferred);
 
 DECLARE_EVENT_CLASS(xfs_defer_pending_item_class,
 	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_pending *dfp,
@@ -2954,7 +2897,60 @@ DEFINE_EVENT(xfs_rmapbt_class, name, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
 	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
 
-#define DEFINE_RMAP_DEFERRED_EVENT DEFINE_MAP_EXTENT_DEFERRED_EVENT
+DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 int op,
+		 xfs_agblock_t agbno,
+		 xfs_ino_t ino,
+		 int whichfork,
+		 xfs_fileoff_t offset,
+		 xfs_filblks_t len,
+		 xfs_exntst_t state),
+	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_ino_t, ino)
+		__field(xfs_agblock_t, agbno)
+		__field(int, whichfork)
+		__field(xfs_fileoff_t, l_loff)
+		__field(xfs_filblks_t, l_len)
+		__field(xfs_exntst_t, l_state)
+		__field(int, op)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->ino = ino;
+		__entry->agbno = agbno;
+		__entry->whichfork = whichfork;
+		__entry->l_loff = offset;
+		__entry->l_len = len;
+		__entry->l_state = state;
+		__entry->op = op;
+	),
+	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->op,
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->ino,
+		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
+		  __entry->l_loff,
+		  __entry->l_len,
+		  __entry->l_state)
+);
+#define DEFINE_RMAP_DEFERRED_EVENT(name) \
+DEFINE_EVENT(xfs_rmap_deferred_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 int op, \
+		 xfs_agblock_t agbno, \
+		 xfs_ino_t ino, \
+		 int whichfork, \
+		 xfs_fileoff_t offset, \
+		 xfs_filblks_t len, \
+		 xfs_exntst_t state), \
+	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state))
 DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_defer);
 DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_deferred);
 
@@ -2974,7 +2970,60 @@ DEFINE_RMAPBT_EVENT(xfs_rmap_find_right_neighbor_result);
 DEFINE_RMAPBT_EVENT(xfs_rmap_find_left_neighbor_result);
 
 /* deferred bmbt updates */
-#define DEFINE_BMAP_DEFERRED_EVENT	DEFINE_RMAP_DEFERRED_EVENT
+DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 int op,
+		 xfs_agblock_t agbno,
+		 xfs_ino_t ino,
+		 int whichfork,
+		 xfs_fileoff_t offset,
+		 xfs_filblks_t len,
+		 xfs_exntst_t state),
+	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_ino_t, ino)
+		__field(xfs_agblock_t, agbno)
+		__field(int, whichfork)
+		__field(xfs_fileoff_t, l_loff)
+		__field(xfs_filblks_t, l_len)
+		__field(xfs_exntst_t, l_state)
+		__field(int, op)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->ino = ino;
+		__entry->agbno = agbno;
+		__entry->whichfork = whichfork;
+		__entry->l_loff = offset;
+		__entry->l_len = len;
+		__entry->l_state = state;
+		__entry->op = op;
+	),
+	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->op,
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->ino,
+		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
+		  __entry->l_loff,
+		  __entry->l_len,
+		  __entry->l_state)
+);
+#define DEFINE_BMAP_DEFERRED_EVENT(name) \
+DEFINE_EVENT(xfs_bmap_deferred_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 int op, \
+		 xfs_agblock_t agbno, \
+		 xfs_ino_t ino, \
+		 int whichfork, \
+		 xfs_fileoff_t offset, \
+		 xfs_filblks_t len, \
+		 xfs_exntst_t state), \
+	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state))
 DEFINE_BMAP_DEFERRED_EVENT(xfs_bmap_defer);
 DEFINE_BMAP_DEFERRED_EVENT(xfs_bmap_deferred);
 
@@ -3351,7 +3400,39 @@ DEFINE_AG_ERROR_EVENT(xfs_refcount_find_right_extent_error);
 DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared);
 DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared_result);
 DEFINE_AG_ERROR_EVENT(xfs_refcount_find_shared_error);
-#define DEFINE_REFCOUNT_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
+
+DECLARE_EVENT_CLASS(xfs_refcount_deferred_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 int type, xfs_agblock_t agbno, xfs_extlen_t len),
+	TP_ARGS(mp, agno, type, agbno, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(int, type)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->type = type;
+		__entry->agbno = agbno;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x fsbcount 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->type,
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len)
+);
+#define DEFINE_REFCOUNT_DEFERRED_EVENT(name) \
+DEFINE_EVENT(xfs_refcount_deferred_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 int type, \
+		 xfs_agblock_t bno, \
+		 xfs_extlen_t len), \
+	TP_ARGS(mp, agno, type, bno, len))
 DEFINE_REFCOUNT_DEFERRED_EVENT(xfs_refcount_defer);
 DEFINE_REFCOUNT_DEFERRED_EVENT(xfs_refcount_deferred);
 

