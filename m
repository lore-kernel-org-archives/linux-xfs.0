Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8B74C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:47:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236056AbiLaBrV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:47:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbiLaBrT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:47:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8E61DDD3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:47:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18C02B81DEE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE665C433D2;
        Sat, 31 Dec 2022 01:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451235;
        bh=IBdwgTEf0ZsUeoyne1EQWuSmbPZQ75/b5Beu0JXZh6I=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eW472ypcdtsxEgiFgfOTnvUPX3k4qp/pvDnX+kA9GiepXICXxOCJN649wd9gOQeyD
         DzveC+FqNLTBTZqP13xOeHTE+BowUbft68IKS6SeIX/IjucjURdahNVwR5WsUaydfF
         RVMb5Qav+9Dg9MdQv7BUzz1S2I5Ro+bsikOQSpkPwvJD3nszPWwc6W8lMkiV8DZcL/
         59LmSk747e60zC/qOt2/6HgPBpt0TK4x/bXDhLwIGiG/IZu0s0GMtoRLzwx6ZoCB5m
         T3NrJlWTsIKIjb9s2ksgXyeGvWNS/AMgq4BCOE7bcsWl9QXoGoQWss0B7z2cvF1df1
         F9rkKzU9XnZcA==
Subject: [PATCH 2/5] xfs: create specialized classes for refcount tracepoints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:24 -0800
Message-ID: <167243870473.716629.6474319882227995580.stgit@magnolia>
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

The only user of the "ag" tracepoint event classes is the refcount
btree, so rename them to make that obvious and make them take the btree
cursor to simplify the arguments.  This will save us a lot of trouble
later on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |   24 ++++++-----------
 fs/xfs/xfs_trace.h           |   61 +++++++++++++++++++++++++++---------------
 2 files changed, 48 insertions(+), 37 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index b77d40631e60..1d181561a9ff 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -51,7 +51,7 @@ xfs_refcount_lookup_le(
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+	trace_xfs_refcount_lookup(cur,
 			xfs_refcount_encode_startblock(bno, domain),
 			XFS_LOOKUP_LE);
 	cur->bc_rec.rc.rc_startblock = bno;
@@ -71,7 +71,7 @@ xfs_refcount_lookup_ge(
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+	trace_xfs_refcount_lookup(cur,
 			xfs_refcount_encode_startblock(bno, domain),
 			XFS_LOOKUP_GE);
 	cur->bc_rec.rc.rc_startblock = bno;
@@ -91,7 +91,7 @@ xfs_refcount_lookup_eq(
 	xfs_agblock_t		bno,
 	int			*stat)
 {
-	trace_xfs_refcount_lookup(cur->bc_mp, cur->bc_ag.pag->pag_agno,
+	trace_xfs_refcount_lookup(cur,
 			xfs_refcount_encode_startblock(bno, domain),
 			XFS_LOOKUP_LE);
 	cur->bc_rec.rc.rc_startblock = bno;
@@ -1264,11 +1264,9 @@ xfs_refcount_adjust(
 	int			error;
 
 	if (adj == XFS_REFCOUNT_ADJUST_INCREASE)
-		trace_xfs_refcount_increase(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, *agbno, *aglen);
+		trace_xfs_refcount_increase(cur, *agbno, *aglen);
 	else
-		trace_xfs_refcount_decrease(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, *agbno, *aglen);
+		trace_xfs_refcount_decrease(cur, *agbno, *aglen);
 
 	/*
 	 * Ensure that no rcextents cross the boundary of the adjustment range.
@@ -1528,8 +1526,7 @@ xfs_refcount_find_shared(
 	int				have;
 	int				error;
 
-	trace_xfs_refcount_find_shared(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			agbno, aglen);
+	trace_xfs_refcount_find_shared(cur, agbno, aglen);
 
 	/* By default, skip the whole range */
 	*fbno = NULLAGBLOCK;
@@ -1616,8 +1613,7 @@ xfs_refcount_find_shared(
 	}
 
 done:
-	trace_xfs_refcount_find_shared_result(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, *fbno, *flen);
+	trace_xfs_refcount_find_shared_result(cur, *fbno, *flen);
 
 out_error:
 	if (error)
@@ -1835,8 +1831,7 @@ __xfs_refcount_cow_alloc(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen)
 {
-	trace_xfs_refcount_cow_increase(rcur->bc_mp, rcur->bc_ag.pag->pag_agno,
-			agbno, aglen);
+	trace_xfs_refcount_cow_increase(rcur, agbno, aglen);
 
 	/* Add refcount btree reservation */
 	return xfs_refcount_adjust_cow(rcur, agbno, aglen,
@@ -1852,8 +1847,7 @@ __xfs_refcount_cow_free(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen)
 {
-	trace_xfs_refcount_cow_decrease(rcur->bc_mp, rcur->bc_ag.pag->pag_agno,
-			agbno, aglen);
+	trace_xfs_refcount_cow_decrease(rcur, agbno, aglen);
 
 	/* Remove refcount btree reservation */
 	return xfs_refcount_adjust_cow(rcur, agbno, aglen,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d6da679ebaba..a5686b53ca80 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3228,17 +3228,41 @@ DEFINE_AG_ERROR_EVENT(xfs_ag_resv_init_error);
 
 /* refcount tracepoint classes */
 
-/* reuse the discard trace class for agbno/aglen-based traces */
-#define DEFINE_AG_EXTENT_EVENT(name) DEFINE_DISCARD_EVENT(name)
+DECLARE_EVENT_CLASS(xfs_refcount_class,
+	TP_PROTO(struct xfs_btree_cur *cur, xfs_agblock_t agbno,
+		xfs_extlen_t len),
+	TP_ARGS(cur, agbno, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->agno = cur->bc_ag.pag->pag_agno;
+		__entry->agbno = agbno;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len)
+);
+#define DEFINE_REFCOUNT_EVENT(name) \
+DEFINE_EVENT(xfs_refcount_class, name, \
+	TP_PROTO(struct xfs_btree_cur *cur, xfs_agblock_t agbno, \
+		xfs_extlen_t len), \
+	TP_ARGS(cur, agbno, len))
 
-/* ag btree lookup tracepoint class */
 TRACE_DEFINE_ENUM(XFS_LOOKUP_EQi);
 TRACE_DEFINE_ENUM(XFS_LOOKUP_LEi);
 TRACE_DEFINE_ENUM(XFS_LOOKUP_GEi);
-DECLARE_EVENT_CLASS(xfs_ag_btree_lookup_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 xfs_agblock_t agbno, xfs_lookup_t dir),
-	TP_ARGS(mp, agno, agbno, dir),
+TRACE_EVENT(xfs_refcount_lookup,
+	TP_PROTO(struct xfs_btree_cur *cur, xfs_agblock_t agbno,
+		xfs_lookup_t dir),
+	TP_ARGS(cur, agbno, dir),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -3246,8 +3270,8 @@ DECLARE_EVENT_CLASS(xfs_ag_btree_lookup_class,
 		__field(xfs_lookup_t, dir)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->agno = cur->bc_ag.pag->pag_agno;
 		__entry->agbno = agbno;
 		__entry->dir = dir;
 	),
@@ -3259,12 +3283,6 @@ DECLARE_EVENT_CLASS(xfs_ag_btree_lookup_class,
 		  __entry->dir)
 )
 
-#define DEFINE_AG_BTREE_LOOKUP_EVENT(name) \
-DEFINE_EVENT(xfs_ag_btree_lookup_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 xfs_agblock_t agbno, xfs_lookup_t dir), \
-	TP_ARGS(mp, agno, agbno, dir))
-
 /* single-rcext tracepoint class */
 DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
@@ -3508,7 +3526,6 @@ DEFINE_EVENT(xfs_refcount_triple_extent_class, name, \
 	TP_ARGS(mp, agno, i1, i2, i3))
 
 /* refcount btree tracepoints */
-DEFINE_AG_BTREE_LOOKUP_EVENT(xfs_refcount_lookup);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_get);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_update);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_insert);
@@ -3518,10 +3535,10 @@ DEFINE_BTREE_ERROR_EVENT(xfs_refcount_delete_error);
 DEFINE_BTREE_ERROR_EVENT(xfs_refcount_update_error);
 
 /* refcount adjustment tracepoints */
-DEFINE_AG_EXTENT_EVENT(xfs_refcount_increase);
-DEFINE_AG_EXTENT_EVENT(xfs_refcount_decrease);
-DEFINE_AG_EXTENT_EVENT(xfs_refcount_cow_increase);
-DEFINE_AG_EXTENT_EVENT(xfs_refcount_cow_decrease);
+DEFINE_REFCOUNT_EVENT(xfs_refcount_increase);
+DEFINE_REFCOUNT_EVENT(xfs_refcount_decrease);
+DEFINE_REFCOUNT_EVENT(xfs_refcount_cow_increase);
+DEFINE_REFCOUNT_EVENT(xfs_refcount_cow_decrease);
 DEFINE_REFCOUNT_TRIPLE_EXTENT_EVENT(xfs_refcount_merge_center_extents);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_modify_extent);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_recover_extent);
@@ -3541,8 +3558,8 @@ DEFINE_BTREE_ERROR_EVENT(xfs_refcount_find_left_extent_error);
 DEFINE_BTREE_ERROR_EVENT(xfs_refcount_find_right_extent_error);
 
 /* reflink helpers */
-DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared);
-DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared_result);
+DEFINE_REFCOUNT_EVENT(xfs_refcount_find_shared);
+DEFINE_REFCOUNT_EVENT(xfs_refcount_find_shared_result);
 DEFINE_BTREE_ERROR_EVENT(xfs_refcount_find_shared_error);
 
 DECLARE_EVENT_CLASS(xfs_refcount_deferred_class,

