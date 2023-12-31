Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C7EBE4A
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:42:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fCLUxXku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BA0C433C8;
	Sun, 31 Dec 2023 21:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058949;
	bh=SB6TsR4D6W0aPqDBTEwkB5weaDSMDJFSv1Atsu6dD7U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=fCLUxXkujpJrGqOXWWo+QximyumFgZGJFZDlZptIi2sImqyKKnQcb/kCmc8uPhif9
	 rcRVzUuvD8DvSV1L3jb2QmyuZ2dZmpUArKbMfXI5QZvjdcgcAhhG6nW6kJ2HVMZB8c
	 poyCyy+uIg+XrIAX7ANrazGzcWmtUQQOSi1fB8P1nPHvY9b7W8WSyTgGzKpvbYToPn
	 HncmV9wTGTfF8XlqtXDxlBKC7lbzkt3jlNtdnvbmkWS8hYHLUeEGetzjTqmDMpM+Iu
	 2Gt/SrQpIfb3VpivxmdBRBZ5HFoCux1dUVd7cLibGVlpX6s05rcH8c9R61b9k42Xjb
	 LN0E8INMnYqDw==
Date: Sun, 31 Dec 2023 13:42:29 -0800
Subject: [PATCH 02/10] xfs: create specialized classes for refcount
 tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850927.1765989.7626763780839844963.stgit@frogsfrogsfrogs>
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
index b7fe286589063..199199da3f210 100644
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
index 925e87772f3d0..c4589285c6ec2 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3232,17 +3232,41 @@ DEFINE_AG_ERROR_EVENT(xfs_ag_resv_init_error);
 
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
@@ -3250,8 +3274,8 @@ DECLARE_EVENT_CLASS(xfs_ag_btree_lookup_class,
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
@@ -3263,12 +3287,6 @@ DECLARE_EVENT_CLASS(xfs_ag_btree_lookup_class,
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
@@ -3512,7 +3530,6 @@ DEFINE_EVENT(xfs_refcount_triple_extent_class, name, \
 	TP_ARGS(mp, agno, i1, i2, i3))
 
 /* refcount btree tracepoints */
-DEFINE_AG_BTREE_LOOKUP_EVENT(xfs_refcount_lookup);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_get);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_update);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_insert);
@@ -3522,10 +3539,10 @@ DEFINE_BTREE_ERROR_EVENT(xfs_refcount_delete_error);
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
@@ -3545,8 +3562,8 @@ DEFINE_BTREE_ERROR_EVENT(xfs_refcount_find_left_extent_error);
 DEFINE_BTREE_ERROR_EVENT(xfs_refcount_find_right_extent_error);
 
 /* reflink helpers */
-DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared);
-DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared_result);
+DEFINE_REFCOUNT_EVENT(xfs_refcount_find_shared);
+DEFINE_REFCOUNT_EVENT(xfs_refcount_find_shared_result);
 DEFINE_BTREE_ERROR_EVENT(xfs_refcount_find_shared_error);
 
 DECLARE_EVENT_CLASS(xfs_refcount_deferred_class,

