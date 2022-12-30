Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7CE9C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236087AbiLaBeu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:34:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236116AbiLaBet (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:34:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79BEF1E3CE
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:34:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C33F6B81E0A
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D02C433EF;
        Sat, 31 Dec 2022 01:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672450484;
        bh=Pah5anWnrvyNYsFUiNVPxzlUMMaRZXC1CtzpQWxDA1E=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gmGnOiCwYpmrIeZCmon9uZsd1ETPeXDqEqLB1S0hL4I04OrF8eofp+FbbGTxzpvlL
         EJoxtj3f1gblyVpzmgufYhj1A9eceFnjfDwPisNRCUJdgx/v44o0sVXQ3mzpGvA2VU
         cf/rwTrmhi+PAgZKTIzgutm62YozjGBWEaYlLeiTE9dDgnAFfl5PRreupCoApXKN2O
         PKM29iuyqvnBq6EAhUDnldmtvETnkfHlp7OyY/uEjtb4vvgF4pf03hBSnvC+lf21F1
         3H/AfYiZWhwEMEWVFw8D0NloyjSlYhtgZ8OdzeWHQ9jMzeLjdlDCq4j7wLib0dQfYw
         GRg5qRGpn9PoQ==
Subject: [PATCH 1/2] xfs: clean up extent free log intent item tracepoint
 callsites
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:05 -0800
Message-ID: <167243868534.714498.1611693606749841148.stgit@magnolia>
In-Reply-To: <167243868517.714498.12799285534857942283.stgit@magnolia>
References: <167243868517.714498.12799285534857942283.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Pass the incore EFI structure to the tracepoints instead of open-coding
the argument passing.  This cleans up the call sites a bit.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c |    7 +++----
 fs/xfs/libxfs/xfs_alloc.h |    1 -
 fs/xfs/xfs_extfree_item.c |    6 ++----
 fs/xfs/xfs_trace.h        |   33 +++++++++++++++------------------
 4 files changed, 20 insertions(+), 27 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 550d0e3c8528..b9aef7937a2c 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2587,7 +2587,7 @@ xfs_defer_agfl_block(
 	xefi->xefi_blockcount = 1;
 	xefi->xefi_owner = oinfo->oi_owner;
 
-	trace_xfs_agfl_free_defer(mp, agno, 0, agbno, 1);
+	trace_xfs_agfl_free_defer(mp, xefi);
 
 	xfs_extent_free_get_group(mp, xefi);
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_AGFL_FREE, &xefi->xefi_list);
@@ -2641,9 +2641,8 @@ __xfs_free_extent_later(
 	} else {
 		xefi->xefi_owner = XFS_RMAP_OWN_NULL;
 	}
-	trace_xfs_bmap_free_defer(mp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, bno), 0,
-			XFS_FSB_TO_AGBNO(tp->t_mountp, bno), len);
+
+	trace_xfs_extent_free_defer(mp, xefi);
 
 	xfs_extent_free_get_group(mp, xefi);
 	xfs_defer_add(tp, XFS_DEFER_OPS_TYPE_FREE, &xefi->xefi_list);
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 5b05c8bfa60a..83b92c3b3452 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -255,7 +255,6 @@ xfs_free_extent_later(
 	__xfs_free_extent_later(tp, bno, len, oinfo, false);
 }
 
-
 extern struct kmem_cache	*xfs_extfree_item_cache;
 
 int __init xfs_extfree_intent_init_cache(void);
diff --git a/fs/xfs/xfs_extfree_item.c b/fs/xfs/xfs_extfree_item.c
index cec637de322e..e23af5ee16b1 100644
--- a/fs/xfs/xfs_extfree_item.c
+++ b/fs/xfs/xfs_extfree_item.c
@@ -361,8 +361,7 @@ xfs_trans_free_extent(
 	if (xefi->xefi_flags & XFS_EFI_BMBT_BLOCK)
 		oinfo.oi_flags |= XFS_OWNER_INFO_BMBT_BLOCK;
 
-	trace_xfs_bmap_free_deferred(tp->t_mountp, xefi->xefi_pag->pag_agno, 0,
-			agbno, xefi->xefi_blockcount);
+	trace_xfs_extent_free_deferred(mp, xefi);
 
 	error = __xfs_free_extent(tp, xefi->xefi_pag, agbno,
 			xefi->xefi_blockcount, &oinfo, XFS_AG_RESV_NONE,
@@ -558,8 +557,7 @@ xfs_agfl_free_finish_item(
 	agbno = XFS_FSB_TO_AGBNO(mp, xefi->xefi_startblock);
 	oinfo.oi_owner = xefi->xefi_owner;
 
-	trace_xfs_agfl_free_deferred(mp, xefi->xefi_pag->pag_agno, 0, agbno,
-			xefi->xefi_blockcount);
+	trace_xfs_agfl_free_deferred(mp, xefi);
 
 	error = xfs_alloc_read_agf(xefi->xefi_pag, tp, 0, &agbp);
 	if (!error)
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 0b5748546c4c..698616531ea0 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -83,6 +83,7 @@ struct xfs_bmap_intent;
 struct xfs_swapext_intent;
 struct xfs_swapext_req;
 struct xfs_rtgroup;
+struct xfs_extent_free_item;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -2761,41 +2762,37 @@ DEFINE_DEFER_PENDING_EVENT(xfs_defer_pending_abort);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_relog_intent);
 
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

