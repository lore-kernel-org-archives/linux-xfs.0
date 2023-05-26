Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182E3C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:11:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbjEZBL4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjEZBLz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:11:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081B8194
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:11:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CE1C64C27
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:11:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF772C433D2;
        Fri, 26 May 2023 01:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685063512;
        bh=vRcGgfls0jjtvpwFaK5tAyMRgaFoD4BczZzLlnVMXVQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=f10d6/Z/U7NCRFv8ervyoQMzZ1i+Gk5xQMtyS6l3Mgy2ujNGLAA2b4Wouzo6m5dis
         wlIrxnrSydVhasQU+QQXIzqL/u7I4kQ0cAhCZRA5cy9tN5D0GlqeWAHBRBO0MUgqQ/
         iIdyzD7aPVYYIg/q9dI8dF+KHg96f04TSNbsiM226orOKae+lZHDHqHaYloO9cKrbr
         zGUIDGYB4i23a5lZOflO3f8PwiYv/D8wRsJwynxZf/p+FBSyVqz8tEj/umNQbxsLMT
         LZMTPoHs3fnoB3gfj8DZcyPO2kxFqEeb0qGhTQTuC0jK+Sd2NhEUDp/uku3rflZ0ZM
         GknIpAQQs9OLg==
Date:   Thu, 25 May 2023 18:11:52 -0700
Subject: [PATCH 2/3] xfs: clean up bmap log intent item tracepoint callsites
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506063518.3733930.8492026462069627004.stgit@frogsfrogsfrogs>
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
index 875b1d9576ac..1479168cccc3 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6185,15 +6185,6 @@ __xfs_bmap_add(
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
@@ -6201,6 +6192,8 @@ __xfs_bmap_add(
 	bi->bi_whichfork = whichfork;
 	bi->bi_bmap = *bmap;
 
+	trace_xfs_bmap_defer(bi);
+
 	xfs_bmap_update_get_group(tp->t_mountp, bi);
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_BMAP, &bi->bi_list);
 	return 0;
@@ -6246,13 +6239,7 @@ xfs_bmap_finish_one(
 
 	ASSERT(tp->t_highest_agno == NULLAGNUMBER);
 
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
index 2ceb6c20bbfa..9477f4eeb87d 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -233,6 +233,10 @@ enum xfs_bmap_intent_type {
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
index 2e20b1edcab8..27a7901e2973 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -78,6 +78,7 @@ union xfs_btree_ptr;
 struct xfs_dqtrx;
 struct xfs_icwalk;
 struct xfs_perag;
+struct xfs_bmap_intent;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -2970,16 +2971,12 @@ DEFINE_RMAPBT_EVENT(xfs_rmap_find_right_neighbor_result);
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
@@ -2992,22 +2989,26 @@ DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
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
@@ -3015,15 +3016,8 @@ DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
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
 

