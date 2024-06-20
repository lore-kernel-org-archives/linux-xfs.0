Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FCD913CF82
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924993; cv=none; b=GsflEjTWf91izxGeiZyyj8tVq8wDcI+Vh34Vnzr6GP4eRnhH3KR5A3zdrkAmwXe1DeHGvO2gxgAsxPT4UNAg8PY3IBAY1aU9uSugzwucEec+fNXqMqv2p6sjTv6rydtS0YiKtwp1+P1Cwmtz9gFWTPgxQs5r4r7ULkGs56YGPQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924993; c=relaxed/simple;
	bh=VRTAqEfBP7a+PnSAMt4Xct8Wt7PHuMUvMAkgSHFFyEQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iUlTii4ZhyGGeFg5j9F5a0rofQe/Mgf+0flV8u9lyO66mNn+Ggtz+MhpILg/blxffDQ79G8frSsLQG9nKUaKvSvvNCm+lLSD1n+6KG3AKsniiLiZzmTz3bD2k0Mu1xq8UV0ZTa8a3mx5bKI47501/pHLLdPfpyI/8uTNmNXdc5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uwjnArFD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uwjnArFD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6B95C2BD10;
	Thu, 20 Jun 2024 23:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924992;
	bh=VRTAqEfBP7a+PnSAMt4Xct8Wt7PHuMUvMAkgSHFFyEQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=uwjnArFD/5br6NT6XofML6tnEYRbkLy0kdRevPFi4S4Sf48s93SZTVK2Oiv+eDIRZ
	 t0OUJjUb8gR850fAVsiCpB7007FKYx7A+ljyTtpypb4Gx7t1Tx37MSHZLR6ytos4F3
	 eAuDf1RMeu522ut7vLOAXiYhMUKI1ijJ4/G5lBoZN09vYXg+G6LkA8CP89UC0zORZT
	 4MAE4gRLTpZkjJxpyRx32yENtciATf9xUVygnIPf2aOgKVxJoFIXJ5FvXE4Ud+bMKp
	 6BjkaLeH3yRkivXSK5+iRrKEUBm91lZHXRkeHWLQHAihYIAxM/0DTM3rNjbIjAF3PT
	 2kXNt59qtE8Hg==
Date: Thu, 20 Jun 2024 16:09:52 -0700
Subject: [PATCH 02/10] xfs: create specialized classes for refcount
 tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892419806.3184748.4482333777418540364.stgit@frogsfrogsfrogs>
In-Reply-To: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
References: <171892419746.3184748.6406153597005839426.stgit@frogsfrogsfrogs>
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
index 77acd311aa55c..1916f8281450e 100644
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
@@ -1262,11 +1262,9 @@ xfs_refcount_adjust(
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
@@ -1526,8 +1524,7 @@ xfs_refcount_find_shared(
 	int				have;
 	int				error;
 
-	trace_xfs_refcount_find_shared(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			agbno, aglen);
+	trace_xfs_refcount_find_shared(cur, agbno, aglen);
 
 	/* By default, skip the whole range */
 	*fbno = NULLAGBLOCK;
@@ -1614,8 +1611,7 @@ xfs_refcount_find_shared(
 	}
 
 done:
-	trace_xfs_refcount_find_shared_result(cur->bc_mp,
-			cur->bc_ag.pag->pag_agno, *fbno, *flen);
+	trace_xfs_refcount_find_shared_result(cur, *fbno, *flen);
 
 out_error:
 	if (error)
@@ -1833,8 +1829,7 @@ __xfs_refcount_cow_alloc(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen)
 {
-	trace_xfs_refcount_cow_increase(rcur->bc_mp, rcur->bc_ag.pag->pag_agno,
-			agbno, aglen);
+	trace_xfs_refcount_cow_increase(rcur, agbno, aglen);
 
 	/* Add refcount btree reservation */
 	return xfs_refcount_adjust_cow(rcur, agbno, aglen,
@@ -1850,8 +1845,7 @@ __xfs_refcount_cow_free(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		aglen)
 {
-	trace_xfs_refcount_cow_decrease(rcur->bc_mp, rcur->bc_ag.pag->pag_agno,
-			agbno, aglen);
+	trace_xfs_refcount_cow_decrease(rcur, agbno, aglen);
 
 	/* Remove refcount btree reservation */
 	return xfs_refcount_adjust_cow(rcur, agbno, aglen,
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ffaf5d7382363..23bf9193a7afd 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3147,17 +3147,41 @@ DEFINE_AG_ERROR_EVENT(xfs_ag_resv_init_error);
 
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
@@ -3165,8 +3189,8 @@ DECLARE_EVENT_CLASS(xfs_ag_btree_lookup_class,
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
@@ -3178,12 +3202,6 @@ DECLARE_EVENT_CLASS(xfs_ag_btree_lookup_class,
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
@@ -3427,7 +3445,6 @@ DEFINE_EVENT(xfs_refcount_triple_extent_class, name, \
 	TP_ARGS(mp, agno, i1, i2, i3))
 
 /* refcount btree tracepoints */
-DEFINE_AG_BTREE_LOOKUP_EVENT(xfs_refcount_lookup);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_get);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_update);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_insert);
@@ -3437,10 +3454,10 @@ DEFINE_BTREE_ERROR_EVENT(xfs_refcount_delete_error);
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
@@ -3460,8 +3477,8 @@ DEFINE_BTREE_ERROR_EVENT(xfs_refcount_find_left_extent_error);
 DEFINE_BTREE_ERROR_EVENT(xfs_refcount_find_right_extent_error);
 
 /* reflink helpers */
-DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared);
-DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared_result);
+DEFINE_REFCOUNT_EVENT(xfs_refcount_find_shared);
+DEFINE_REFCOUNT_EVENT(xfs_refcount_find_shared_result);
 DEFINE_BTREE_ERROR_EVENT(xfs_refcount_find_shared_error);
 
 DECLARE_EVENT_CLASS(xfs_refcount_deferred_class,

