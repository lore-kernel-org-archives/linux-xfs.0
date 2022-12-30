Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A63FC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbiL3Xri (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235597AbiL3Xrh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:47:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F03064FA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:47:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2890B81DCA
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744EDC433D2;
        Fri, 30 Dec 2022 23:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444053;
        bh=P08CS1puQ7aRJX1SfhHHHIlJx0H15bGJGQ+3W9RfZ9o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=tyYAkLgBiSswgpxIuGbmfumHklsZaAAsBqMERWk646R4eoQ8aEfuQCvyRmqpo0zX3
         IH/sQroohKbzZIxX286g/ne5sEbHnG5luAbnYHCwV0/czHTBqh1BS8zeFZ2cL09Ykk
         ZIW4WXll1shfWIFcTbSo3Nkn2TTAkgN8fzcyJK1FQO+xXFHbUVvEPBlv59R3ocNW7d
         pHBenzwuVR+OAf8pLNE3HD9N4aaF3Z33MvExSSRdO/lvPezykG0Pfq8AEGnywpcZbA
         vjsrWgv/4BbV0OjV3+OTWCE5y+r9Zw21vDqL0nJXW4TbF9SCbyU7occvxqIji0uz75
         pi9LBUA63Xhmg==
Subject: [PATCH 2/3] xfs: clean up bmap log intent item tracepoint callsites
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:41 -0800
Message-ID: <167243842153.698982.12181041541568925759.stgit@magnolia>
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

Pass the incore bmap structure to the tracepoints instead of open-coding
the argument passing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   19 +++-------------
 fs/xfs/libxfs/xfs_bmap.h |    4 +++
 fs/xfs/xfs_trace.c       |    1 +
 fs/xfs/xfs_trace.h       |   54 ++++++++++++++++++++--------------------------
 4 files changed, 32 insertions(+), 46 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 9b99669be43d..ce12a1fd3209 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6213,15 +6213,6 @@ __xfs_bmap_add(
 {
 	struct xfs_bmap_intent		*bi;
 
-	trace_xfs_bmap_defer(tp->t_mountp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, bmap->br_startblock),
-			type,
-			XFS_FSB_TO_AGBNO(tp->t_mountp, bmap->br_startblock),
-			ip->i_ino, whichfork,
-			bmap->br_startoff,
-			bmap->br_blockcount,
-			bmap->br_state);
-
 	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&bi->bi_list);
 	bi->bi_type = type;
@@ -6229,6 +6220,8 @@ __xfs_bmap_add(
 	bi->bi_whichfork = whichfork;
 	bi->bi_bmap = *bmap;
 
+	trace_xfs_bmap_defer(bi);
+
 	xfs_bmap_update_get_group(tp->t_mountp, bi);
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_BMAP, &bi->bi_list);
 	return 0;
@@ -6274,13 +6267,7 @@ xfs_bmap_finish_one(
 
 	ASSERT(tp->t_firstblock == NULLFSBLOCK);
 
-	trace_xfs_bmap_deferred(tp->t_mountp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, bmap->br_startblock),
-			bi->bi_type,
-			XFS_FSB_TO_AGBNO(tp->t_mountp, bmap->br_startblock),
-			bi->bi_owner->i_ino, bi->bi_whichfork,
-			bmap->br_startoff, bmap->br_blockcount,
-			bmap->br_state);
+	trace_xfs_bmap_deferred(bi);
 
 	if (WARN_ON_ONCE(bi->bi_whichfork != XFS_DATA_FORK)) {
 		xfs_bmap_mark_sick(bi->bi_owner, bi->bi_whichfork);
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index bbda4a77cb69..276ffd098c9e 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -226,6 +226,10 @@ enum xfs_bmap_intent_type {
 	XFS_BMAP_UNMAP,
 };
 
+#define XFS_BMAP_INTENT_STRINGS \
+	{ XFS_BMAP_MAP,		"map" }, \
+	{ XFS_BMAP_UNMAP,	"unmap" }
+
 struct xfs_bmap_intent {
 	struct list_head			bi_list;
 	enum xfs_bmap_intent_type		bi_type;
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 2d49310fb912..c9a5d8087b63 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -39,6 +39,7 @@
 #include "scrub/xfile.h"
 #include "scrub/xfbtree.h"
 #include "xfs_btree_mem.h"
+#include "xfs_bmap.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 66f3a2803dd4..b65b7969a1d3 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -77,6 +77,7 @@ struct xfs_inobt_rec_incore;
 union xfs_btree_ptr;
 struct xfs_dqtrx;
 struct xfs_icwalk;
+struct xfs_bmap_intent;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -2962,16 +2963,12 @@ DEFINE_RMAPBT_EVENT(xfs_rmap_find_right_neighbor_result);
 DEFINE_RMAPBT_EVENT(xfs_rmap_find_left_neighbor_result);
 
 /* deferred bmbt updates */
+TRACE_DEFINE_ENUM(XFS_BMAP_MAP);
+TRACE_DEFINE_ENUM(XFS_BMAP_UNMAP);
+
 DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 int op,
-		 xfs_agblock_t agbno,
-		 xfs_ino_t ino,
-		 int whichfork,
-		 xfs_fileoff_t offset,
-		 xfs_filblks_t len,
-		 xfs_exntst_t state),
-	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state),
+	TP_PROTO(struct xfs_bmap_intent *bi),
+	TP_ARGS(bi),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -2984,22 +2981,26 @@ DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
 		__field(int, op)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->ino = ino;
-		__entry->agbno = agbno;
-		__entry->whichfork = whichfork;
-		__entry->l_loff = offset;
-		__entry->l_len = len;
-		__entry->l_state = state;
-		__entry->op = op;
+		struct xfs_inode	*ip = bi->bi_owner;
+
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->agno = XFS_FSB_TO_AGNO(ip->i_mount,
+					bi->bi_bmap.br_startblock);
+		__entry->ino = ip->i_ino;
+		__entry->agbno = XFS_FSB_TO_AGBNO(ip->i_mount,
+					bi->bi_bmap.br_startblock);
+		__entry->whichfork = bi->bi_whichfork;
+		__entry->l_loff = bi->bi_bmap.br_startoff;
+		__entry->l_len = bi->bi_bmap.br_blockcount;
+		__entry->l_state = bi->bi_bmap.br_state;
+		__entry->op = bi->bi_type;
 	),
-	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
+	TP_printk("dev %d:%d op %s ino 0x%llx agno 0x%x agbno 0x%x %s fileoff 0x%llx fsbcount 0x%llx state %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->op,
+		  __print_symbolic(__entry->op, XFS_BMAP_INTENT_STRINGS),
+		  __entry->ino,
 		  __entry->agno,
 		  __entry->agbno,
-		  __entry->ino,
 		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
 		  __entry->l_loff,
 		  __entry->l_len,
@@ -3007,15 +3008,8 @@ DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
 );
 #define DEFINE_BMAP_DEFERRED_EVENT(name) \
 DEFINE_EVENT(xfs_bmap_deferred_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 int op, \
-		 xfs_agblock_t agbno, \
-		 xfs_ino_t ino, \
-		 int whichfork, \
-		 xfs_fileoff_t offset, \
-		 xfs_filblks_t len, \
-		 xfs_exntst_t state), \
-	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state))
+	TP_PROTO(struct xfs_bmap_intent *bi), \
+	TP_ARGS(bi))
 DEFINE_BMAP_DEFERRED_EVENT(xfs_bmap_defer);
 DEFINE_BMAP_DEFERRED_EVENT(xfs_bmap_deferred);
 

