Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 490CBC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235595AbiL3XrX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbiL3XrW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:47:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2A01DF30
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:47:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49E45B81D67
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:47:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7107C433EF;
        Fri, 30 Dec 2022 23:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444038;
        bh=4xYLnLSvpgQ8mUTjva9gJQU99gLXEHWurLQRaFus5Ho=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=P62991yxS3wK+tphyQzyeMzYp1tLHFdYz/dMpWekHVIns2Thl/4+bMvSLr+ObxF0e
         dwLjJ3ektE3LTkHfRBmhlJbaOQ5VSyyWLGrL1LB2k/ILMT9fEEH2g/wIPZWUsAdrvh
         1ohCU1aHCJd/hZisj2aDDdCw2AIjReg2J2b4aDYqsMOyU4sgUPuwo3I+9sHU/DV5Ye
         q/J0/+2+3C9p7EwMO8S37xiH6wInuIFJYN+uYrffVyN4kgE6mlwYp0UbVd9U+7HkBu
         +UxcfgQsiQK4yheBrf04ZeuJ3eh8MBdm25y/r3AGXg6+nrRFuHRomHz9PMrG9+jiXO
         lO+wGDt6q3q+g==
Subject: [PATCH 1/3] xfs: split tracepoint classes for deferred items
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:41 -0800
Message-ID: <167243842138.698982.165641797655054613.stgit@magnolia>
In-Reply-To: <167243842121.698982.2011083519163197266.stgit@magnolia>
References: <167243842121.698982.2011083519163197266.stgit@magnolia>
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
index 6bb15f820120..66f3a2803dd4 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2677,94 +2677,6 @@ DEFINE_EVENT(xfs_defer_pending_class, name, \
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
@@ -2780,11 +2692,42 @@ DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_finish);
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
@@ -2946,7 +2889,60 @@ DEFINE_EVENT(xfs_rmapbt_class, name, \
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
 
@@ -2966,7 +2962,60 @@ DEFINE_RMAPBT_EVENT(xfs_rmap_find_right_neighbor_result);
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
 
@@ -3343,7 +3392,39 @@ DEFINE_AG_ERROR_EVENT(xfs_refcount_find_right_extent_error);
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
 

