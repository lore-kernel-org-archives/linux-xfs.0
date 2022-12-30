Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBED4C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:47:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236054AbiLaBrh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:47:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231435AbiLaBrf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:47:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E4A81DDD3
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:47:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94C44B81DEE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5415CC433D2;
        Sat, 31 Dec 2022 01:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451251;
        bh=L6vIPQv3JfLbyTZBLOiNxo9CF7q6P+ZMX1SVMV4MVX8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eTPWU8s3Q5K4QI4IowXgEtH+4GqtmCoLLojwnJbqIX9LIzeVwd5VbJb3t2G10dB1i
         Fg+8WMLKSl0WOlfjatzaKJN6/ivnAsMy6yQSfJpgjaWFGg0So1dw4mp7vSvl27mIsq
         ix3EyGmV8fw5ZR8oGUkGuHFDtecW9Da8F8BagYb2YKrmyuKb67wtBjLfyUWkTKWiU1
         KE/PuYJ8kVtqa7AJYfwpUQXtF25zw15d22OlP7POWnr702tjf1flhaK7C7TCqM1uKr
         SnZcGvSPvQaJXdxo9QWS7uJ4Bn5S2n4bRsj/PPOxu5ju2OSfU5NZkIKQ4ZZXBCqAQc
         YX/01foDeDmcA==
Subject: [PATCH 3/5] xfs: prepare refcount btree tracepoints for widening
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:24 -0800
Message-ID: <167243870487.716629.10920845342789966780.stgit@magnolia>
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

Prepare the rest of refcount btree tracepoints for use with realtime
reflink by making them take the btree cursor object as a parameter.
This will save us a lot of trouble later on.

Remove the xfs_refcount_recover_extent tracepoint since it's already
covered by other refcount tracepoints.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_refcount.c |   42 ++++++++-------------
 fs/xfs/xfs_trace.h           |   83 +++++++++++++++++++-----------------------
 2 files changed, 53 insertions(+), 72 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 1d181561a9ff..4c6ed75059c8 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -191,7 +191,7 @@ xfs_refcount_get_rec(
 	if (fa)
 		return xfs_refcount_complain_bad_rec(cur, fa, irec);
 
-	trace_xfs_refcount_get(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
+	trace_xfs_refcount_get(cur, irec);
 	return 0;
 }
 
@@ -209,7 +209,7 @@ xfs_refcount_update(
 	uint32_t		start;
 	int			error;
 
-	trace_xfs_refcount_update(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
+	trace_xfs_refcount_update(cur, irec);
 
 	start = xfs_refcount_encode_startblock(irec->rc_startblock,
 			irec->rc_domain);
@@ -236,7 +236,7 @@ xfs_refcount_insert(
 {
 	int				error;
 
-	trace_xfs_refcount_insert(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
+	trace_xfs_refcount_insert(cur, irec);
 
 	cur->bc_rec.rc.rc_startblock = irec->rc_startblock;
 	cur->bc_rec.rc.rc_blockcount = irec->rc_blockcount;
@@ -281,7 +281,7 @@ xfs_refcount_delete(
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
-	trace_xfs_refcount_delete(cur->bc_mp, cur->bc_ag.pag->pag_agno, &irec);
+	trace_xfs_refcount_delete(cur, &irec);
 	error = xfs_btree_delete(cur, i);
 	if (XFS_IS_CORRUPT(cur->bc_mp, *i != 1)) {
 		xfs_btree_mark_sick(cur);
@@ -418,8 +418,7 @@ xfs_refcount_split_extent(
 		return 0;
 
 	*shape_changed = true;
-	trace_xfs_refcount_split_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			&rcext, agbno);
+	trace_xfs_refcount_split_extent(cur, &rcext, agbno);
 
 	/* Establish the right extent. */
 	tmp = rcext;
@@ -462,8 +461,7 @@ xfs_refcount_merge_center_extents(
 	int				error;
 	int				found_rec;
 
-	trace_xfs_refcount_merge_center_extents(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, left, center, right);
+	trace_xfs_refcount_merge_center_extents(cur, left, center, right);
 
 	ASSERT(left->rc_domain == center->rc_domain);
 	ASSERT(right->rc_domain == center->rc_domain);
@@ -544,8 +542,7 @@ xfs_refcount_merge_left_extent(
 	int				error;
 	int				found_rec;
 
-	trace_xfs_refcount_merge_left_extent(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, left, cleft);
+	trace_xfs_refcount_merge_left_extent(cur, left, cleft);
 
 	ASSERT(left->rc_domain == cleft->rc_domain);
 
@@ -609,8 +606,7 @@ xfs_refcount_merge_right_extent(
 	int				error;
 	int				found_rec;
 
-	trace_xfs_refcount_merge_right_extent(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, cright, right);
+	trace_xfs_refcount_merge_right_extent(cur, cright, right);
 
 	ASSERT(right->rc_domain == cright->rc_domain);
 
@@ -749,8 +745,7 @@ xfs_refcount_find_left_extents(
 		cleft->rc_refcount = 1;
 		cleft->rc_domain = domain;
 	}
-	trace_xfs_refcount_find_left_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			left, cleft, agbno);
+	trace_xfs_refcount_find_left_extent(cur, left, cleft, agbno);
 	return error;
 
 out_error:
@@ -843,8 +838,8 @@ xfs_refcount_find_right_extents(
 		cright->rc_refcount = 1;
 		cright->rc_domain = domain;
 	}
-	trace_xfs_refcount_find_right_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			cright, right, agbno + aglen);
+	trace_xfs_refcount_find_right_extent(cur, cright, right,
+			agbno + aglen);
 	return error;
 
 out_error:
@@ -1147,8 +1142,7 @@ xfs_refcount_adjust_extents(
 			tmp.rc_refcount = 1 + adj;
 			tmp.rc_domain = XFS_REFC_DOMAIN_SHARED;
 
-			trace_xfs_refcount_modify_extent(cur->bc_mp,
-					cur->bc_ag.pag->pag_agno, &tmp);
+			trace_xfs_refcount_modify_extent(cur, &tmp);
 
 			/*
 			 * Either cover the hole (increment) or
@@ -1210,8 +1204,7 @@ xfs_refcount_adjust_extents(
 		if (ext.rc_refcount == MAXREFCOUNT)
 			goto skip;
 		ext.rc_refcount += adj;
-		trace_xfs_refcount_modify_extent(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, &ext);
+		trace_xfs_refcount_modify_extent(cur, &ext);
 		cur->bc_ag.refc.nr_ops++;
 		if (ext.rc_refcount > 1) {
 			error = xfs_refcount_update(cur, &ext);
@@ -1723,8 +1716,7 @@ xfs_refcount_adjust_cow_extents(
 		tmp.rc_refcount = 1;
 		tmp.rc_domain = XFS_REFC_DOMAIN_COW;
 
-		trace_xfs_refcount_modify_extent(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, &tmp);
+		trace_xfs_refcount_modify_extent(cur, &tmp);
 
 		error = xfs_refcount_insert(cur, &tmp,
 				&found_tmp);
@@ -1755,8 +1747,7 @@ xfs_refcount_adjust_cow_extents(
 		}
 
 		ext.rc_refcount = 0;
-		trace_xfs_refcount_modify_extent(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, &ext);
+		trace_xfs_refcount_modify_extent(cur, &ext);
 		error = xfs_refcount_delete(cur, &found_rec);
 		if (error)
 			goto out_error;
@@ -1989,9 +1980,6 @@ xfs_refcount_recover_cow_leftovers(
 		if (error)
 			goto out_free;
 
-		trace_xfs_refcount_recover_extent(mp, pag->pag_agno,
-				&rr->rr_rrec);
-
 		/* Free the orphan record */
 		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno,
 				rr->rr_rrec.rc_startblock);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index a5686b53ca80..233c611b6018 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3285,9 +3285,8 @@ TRACE_EVENT(xfs_refcount_lookup,
 
 /* single-rcext tracepoint class */
 DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 struct xfs_refcount_irec *irec),
-	TP_ARGS(mp, agno, irec),
+	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *irec),
+	TP_ARGS(cur, irec),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -3297,8 +3296,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 		__field(xfs_nlink_t, refcount)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->agno = cur->bc_ag.pag->pag_agno;
 		__entry->domain = irec->rc_domain;
 		__entry->startblock = irec->rc_startblock;
 		__entry->blockcount = irec->rc_blockcount;
@@ -3315,15 +3314,14 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 
 #define DEFINE_REFCOUNT_EXTENT_EVENT(name) \
 DEFINE_EVENT(xfs_refcount_extent_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 struct xfs_refcount_irec *irec), \
-	TP_ARGS(mp, agno, irec))
+	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *irec), \
+	TP_ARGS(cur, irec))
 
 /* single-rcext and an agbno tracepoint class */
 DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 struct xfs_refcount_irec *irec, xfs_agblock_t agbno),
-	TP_ARGS(mp, agno, irec, agbno),
+	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *irec,
+		 xfs_agblock_t agbno),
+	TP_ARGS(cur, irec, agbno),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -3334,8 +3332,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
 		__field(xfs_agblock_t, agbno)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->agno = cur->bc_ag.pag->pag_agno;
 		__entry->domain = irec->rc_domain;
 		__entry->startblock = irec->rc_startblock;
 		__entry->blockcount = irec->rc_blockcount;
@@ -3354,15 +3352,15 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
 
 #define DEFINE_REFCOUNT_EXTENT_AT_EVENT(name) \
 DEFINE_EVENT(xfs_refcount_extent_at_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 struct xfs_refcount_irec *irec, xfs_agblock_t agbno), \
-	TP_ARGS(mp, agno, irec, agbno))
+	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *irec, \
+		 xfs_agblock_t agbno), \
+	TP_ARGS(cur, irec, agbno))
 
 /* double-rcext tracepoint class */
 DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 struct xfs_refcount_irec *i1, struct xfs_refcount_irec *i2),
-	TP_ARGS(mp, agno, i1, i2),
+	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *i1,
+		struct xfs_refcount_irec *i2),
+	TP_ARGS(cur, i1, i2),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -3376,8 +3374,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 		__field(xfs_nlink_t, i2_refcount)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->agno = cur->bc_ag.pag->pag_agno;
 		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
@@ -3403,16 +3401,15 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 
 #define DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(name) \
 DEFINE_EVENT(xfs_refcount_double_extent_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 struct xfs_refcount_irec *i1, struct xfs_refcount_irec *i2), \
-	TP_ARGS(mp, agno, i1, i2))
+	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *i1, \
+		 struct xfs_refcount_irec *i2), \
+	TP_ARGS(cur, i1, i2))
 
 /* double-rcext and an agbno tracepoint class */
 DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 struct xfs_refcount_irec *i1, struct xfs_refcount_irec *i2,
-		 xfs_agblock_t agbno),
-	TP_ARGS(mp, agno, i1, i2, agbno),
+	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *i1,
+		 struct xfs_refcount_irec *i2, xfs_agblock_t agbno),
+	TP_ARGS(cur, i1, i2, agbno),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -3427,8 +3424,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 		__field(xfs_agblock_t, agbno)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->agno = cur->bc_ag.pag->pag_agno;
 		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
@@ -3456,17 +3453,15 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 
 #define DEFINE_REFCOUNT_DOUBLE_EXTENT_AT_EVENT(name) \
 DEFINE_EVENT(xfs_refcount_double_extent_at_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 struct xfs_refcount_irec *i1, struct xfs_refcount_irec *i2, \
-		 xfs_agblock_t agbno), \
-	TP_ARGS(mp, agno, i1, i2, agbno))
+	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *i1, \
+		struct xfs_refcount_irec *i2, xfs_agblock_t agbno), \
+	TP_ARGS(cur, i1, i2, agbno))
 
 /* triple-rcext tracepoint class */
 DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 struct xfs_refcount_irec *i1, struct xfs_refcount_irec *i2,
-		 struct xfs_refcount_irec *i3),
-	TP_ARGS(mp, agno, i1, i2, i3),
+	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *i1,
+		struct xfs_refcount_irec *i2, struct xfs_refcount_irec *i3),
+	TP_ARGS(cur, i1, i2, i3),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -3484,8 +3479,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 		__field(xfs_nlink_t, i3_refcount)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->agno = cur->bc_ag.pag->pag_agno;
 		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
@@ -3520,10 +3515,9 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 
 #define DEFINE_REFCOUNT_TRIPLE_EXTENT_EVENT(name) \
 DEFINE_EVENT(xfs_refcount_triple_extent_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 struct xfs_refcount_irec *i1, struct xfs_refcount_irec *i2, \
-		 struct xfs_refcount_irec *i3), \
-	TP_ARGS(mp, agno, i1, i2, i3))
+	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *i1, \
+		struct xfs_refcount_irec *i2, struct xfs_refcount_irec *i3), \
+	TP_ARGS(cur, i1, i2, i3))
 
 /* refcount btree tracepoints */
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_get);
@@ -3541,7 +3535,6 @@ DEFINE_REFCOUNT_EVENT(xfs_refcount_cow_increase);
 DEFINE_REFCOUNT_EVENT(xfs_refcount_cow_decrease);
 DEFINE_REFCOUNT_TRIPLE_EXTENT_EVENT(xfs_refcount_merge_center_extents);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_modify_extent);
-DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_recover_extent);
 DEFINE_REFCOUNT_EXTENT_AT_EVENT(xfs_refcount_split_extent);
 DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_merge_left_extent);
 DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_merge_right_extent);

