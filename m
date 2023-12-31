Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFA5ABE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sucpEeB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C8F0C433C7;
	Sun, 31 Dec 2023 21:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058965;
	bh=oaT2OHDixu4lriZpuCcREqi8xelC243GBF+NRjW/Cls=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=sucpEeB+jfV+ceUcZbiNBCG6PCo3qvA+XZ1074yNgjkrMWC8JEhzCfDyhwOyYpsUO
	 fRa45T5qszFYTonJUHQ03cjNIn2bZxmgzPlK+WicFeuTSA4kesaH6T3+Me/tGRViqN
	 XLqZyb/pNHQ25wgRM6Op65W2ucZOcBid3uyW+4iKOHcAQwfZaE+FF5SpNnflU1oa8U
	 qNAxEQNcMWLGSpmDVlBU8JDkqpNcE/jBdDW9LqoszGGZptaGOFtRpTFtUkgQyelb7/
	 OP1Ya4rc+CdojLSPeGlh6CcaRd1bMGlrImTqsm2GxhHuedOtRFiKf2oHbniLHjgOJd
	 8F8+p0JTrVzkA==
Date: Sun, 31 Dec 2023 13:42:44 -0800
Subject: [PATCH 03/10] xfs: prepare refcount btree tracepoints for widening
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850943.1765989.16069161423092945599.stgit@frogsfrogsfrogs>
In-Reply-To: <170404850874.1765989.3728283509894891914.stgit@frogsfrogsfrogs>
References: <170404850874.1765989.3728283509894891914.stgit@frogsfrogsfrogs>
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
index 199199da3f210..afb68349cb95d 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -183,7 +183,7 @@ xfs_refcount_get_rec(
 	if (fa)
 		return xfs_refcount_complain_bad_rec(cur, fa, irec);
 
-	trace_xfs_refcount_get(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
+	trace_xfs_refcount_get(cur, irec);
 	return 0;
 }
 
@@ -201,7 +201,7 @@ xfs_refcount_update(
 	uint32_t		start;
 	int			error;
 
-	trace_xfs_refcount_update(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
+	trace_xfs_refcount_update(cur, irec);
 
 	start = xfs_refcount_encode_startblock(irec->rc_startblock,
 			irec->rc_domain);
@@ -228,7 +228,7 @@ xfs_refcount_insert(
 {
 	int				error;
 
-	trace_xfs_refcount_insert(cur->bc_mp, cur->bc_ag.pag->pag_agno, irec);
+	trace_xfs_refcount_insert(cur, irec);
 
 	cur->bc_rec.rc.rc_startblock = irec->rc_startblock;
 	cur->bc_rec.rc.rc_blockcount = irec->rc_blockcount;
@@ -273,7 +273,7 @@ xfs_refcount_delete(
 		error = -EFSCORRUPTED;
 		goto out_error;
 	}
-	trace_xfs_refcount_delete(cur->bc_mp, cur->bc_ag.pag->pag_agno, &irec);
+	trace_xfs_refcount_delete(cur, &irec);
 	error = xfs_btree_delete(cur, i);
 	if (XFS_IS_CORRUPT(cur->bc_mp, *i != 1)) {
 		xfs_btree_mark_sick(cur);
@@ -410,8 +410,7 @@ xfs_refcount_split_extent(
 		return 0;
 
 	*shape_changed = true;
-	trace_xfs_refcount_split_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			&rcext, agbno);
+	trace_xfs_refcount_split_extent(cur, &rcext, agbno);
 
 	/* Establish the right extent. */
 	tmp = rcext;
@@ -454,8 +453,7 @@ xfs_refcount_merge_center_extents(
 	int				error;
 	int				found_rec;
 
-	trace_xfs_refcount_merge_center_extents(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, left, center, right);
+	trace_xfs_refcount_merge_center_extents(cur, left, center, right);
 
 	ASSERT(left->rc_domain == center->rc_domain);
 	ASSERT(right->rc_domain == center->rc_domain);
@@ -536,8 +534,7 @@ xfs_refcount_merge_left_extent(
 	int				error;
 	int				found_rec;
 
-	trace_xfs_refcount_merge_left_extent(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, left, cleft);
+	trace_xfs_refcount_merge_left_extent(cur, left, cleft);
 
 	ASSERT(left->rc_domain == cleft->rc_domain);
 
@@ -601,8 +598,7 @@ xfs_refcount_merge_right_extent(
 	int				error;
 	int				found_rec;
 
-	trace_xfs_refcount_merge_right_extent(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, cright, right);
+	trace_xfs_refcount_merge_right_extent(cur, cright, right);
 
 	ASSERT(right->rc_domain == cright->rc_domain);
 
@@ -741,8 +737,7 @@ xfs_refcount_find_left_extents(
 		cleft->rc_refcount = 1;
 		cleft->rc_domain = domain;
 	}
-	trace_xfs_refcount_find_left_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			left, cleft, agbno);
+	trace_xfs_refcount_find_left_extent(cur, left, cleft, agbno);
 	return error;
 
 out_error:
@@ -835,8 +830,8 @@ xfs_refcount_find_right_extents(
 		cright->rc_refcount = 1;
 		cright->rc_domain = domain;
 	}
-	trace_xfs_refcount_find_right_extent(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			cright, right, agbno + aglen);
+	trace_xfs_refcount_find_right_extent(cur, cright, right,
+			agbno + aglen);
 	return error;
 
 out_error:
@@ -1139,8 +1134,7 @@ xfs_refcount_adjust_extents(
 			tmp.rc_refcount = 1 + adj;
 			tmp.rc_domain = XFS_REFC_DOMAIN_SHARED;
 
-			trace_xfs_refcount_modify_extent(cur->bc_mp,
-					cur->bc_ag.pag->pag_agno, &tmp);
+			trace_xfs_refcount_modify_extent(cur, &tmp);
 
 			/*
 			 * Either cover the hole (increment) or
@@ -1205,8 +1199,7 @@ xfs_refcount_adjust_extents(
 		if (ext.rc_refcount == MAXREFCOUNT)
 			goto skip;
 		ext.rc_refcount += adj;
-		trace_xfs_refcount_modify_extent(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, &ext);
+		trace_xfs_refcount_modify_extent(cur, &ext);
 		cur->bc_ag.refc.nr_ops++;
 		if (ext.rc_refcount > 1) {
 			error = xfs_refcount_update(cur, &ext);
@@ -1721,8 +1714,7 @@ xfs_refcount_adjust_cow_extents(
 		tmp.rc_refcount = 1;
 		tmp.rc_domain = XFS_REFC_DOMAIN_COW;
 
-		trace_xfs_refcount_modify_extent(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, &tmp);
+		trace_xfs_refcount_modify_extent(cur, &tmp);
 
 		error = xfs_refcount_insert(cur, &tmp,
 				&found_tmp);
@@ -1753,8 +1745,7 @@ xfs_refcount_adjust_cow_extents(
 		}
 
 		ext.rc_refcount = 0;
-		trace_xfs_refcount_modify_extent(cur->bc_mp,
-				cur->bc_ag.pag->pag_agno, &ext);
+		trace_xfs_refcount_modify_extent(cur, &ext);
 		error = xfs_refcount_delete(cur, &found_rec);
 		if (error)
 			goto out_error;
@@ -1988,9 +1979,6 @@ xfs_refcount_recover_cow_leftovers(
 		if (error)
 			goto out_free;
 
-		trace_xfs_refcount_recover_extent(mp, pag->pag_agno,
-				&rr->rr_rrec);
-
 		/* Free the orphan record */
 		fsb = XFS_AGB_TO_FSB(mp, pag->pag_agno,
 				rr->rr_rrec.rc_startblock);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c4589285c6ec2..095d7f8a0e707 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3289,9 +3289,8 @@ TRACE_EVENT(xfs_refcount_lookup,
 
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
@@ -3301,8 +3300,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
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
@@ -3319,15 +3318,14 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 
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
@@ -3338,8 +3336,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
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
@@ -3358,15 +3356,15 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
 
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
@@ -3380,8 +3378,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
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
@@ -3407,16 +3405,15 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 
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
@@ -3431,8 +3428,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
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
@@ -3460,17 +3457,15 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 
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
@@ -3488,8 +3483,8 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
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
@@ -3524,10 +3519,9 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 
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
@@ -3545,7 +3539,6 @@ DEFINE_REFCOUNT_EVENT(xfs_refcount_cow_increase);
 DEFINE_REFCOUNT_EVENT(xfs_refcount_cow_decrease);
 DEFINE_REFCOUNT_TRIPLE_EXTENT_EVENT(xfs_refcount_merge_center_extents);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_modify_extent);
-DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_recover_extent);
 DEFINE_REFCOUNT_EXTENT_AT_EVENT(xfs_refcount_split_extent);
 DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_merge_left_extent);
 DEFINE_REFCOUNT_DOUBLE_EXTENT_EVENT(xfs_refcount_merge_right_extent);

