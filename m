Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97749BE47
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YIP7ZvnM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 691ACC433C8;
	Sun, 31 Dec 2023 21:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704059090;
	bh=uzp84HMzlj1HZJam2UQAD3CxwT5mdpLTTCgCQNChfcc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YIP7ZvnMeC46rxf2C4Voefub09izL2/FLOmD+7Ej8hyVjLyzLKMHNDFYfXd/EAl2C
	 squgOu/efmrRrA/7+4WxvKl5IU41p8lr9+FCmoA7pwX5KHAOCGHMMyLHJtrUOoSDFO
	 TvrLuGyy6xxH8byyOJD3ugKxQqOiPDeTsFHL6dt1dJpS/sQVptQ1LAGrEcVId+REW1
	 L57ZiFj95HCpysVl05BWxViicleeONSLawaA/9XKjB0ibhi+taux6I9aoQhMrgNdf1
	 o8TDz7bri8hJGMrmZCmhQcgWuWtY44bAi9g++1PAf+iX838IKBvGu57+iDmQrt4S3Y
	 Br0+ntDVdIFYw==
Date: Sun, 31 Dec 2023 13:44:49 -0800
Subject: [PATCH 01/44] xfs: prepare refcount btree cursor tracepoints for
 realtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404851597.1766284.13553805852762895833.stgit@frogsfrogsfrogs>
In-Reply-To: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
References: <170404851479.1766284.4860754291017677928.stgit@frogsfrogsfrogs>
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

Rework the refcount btree cursor tracepoints in preparation to handle the
realtime refcount btree cursor.  Mostly this involves renaming the field to
"refcbno" and extracting the group number from the cursor when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trace.c |    9 ++++
 fs/xfs/xfs_trace.h |  114 ++++++++++++++++++++++++++++++----------------------
 2 files changed, 74 insertions(+), 49 deletions(-)


diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index fe34d7c3882f3..cb712873ce927 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -66,6 +66,15 @@ xfs_rmapbt_crack_agno_opdev(
 	}
 }
 
+static inline void
+xfs_refcountbt_crack_agno_opdev(
+	struct xfs_btree_cur	*cur,
+	xfs_agnumber_t		*agno,
+	dev_t			*opdev)
+{
+	return xfs_rmapbt_crack_agno_opdev(cur, agno, opdev);
+}
+
 /*
  * We include this last to have the helpers above available for the trace
  * event implementations.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index c8227f44a97c0..fd4170a6aea43 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -22,6 +22,8 @@
  *
  * rmapbno: physical block number for a reverse mapping.  This is an agbno for
  *          per-AG rmap btrees or a rgbno for realtime rmap btrees.
+ * refcbno: physical block number for a refcount record.  This is an agbno for
+ *          per-AG refcount btrees or a rgbno for realtime refcount btrees.
  *
  * daddr: physical block number in 512b blocks
  * bbcount: number of blocks in a physical extent, in 512b blocks
@@ -3234,56 +3236,60 @@ DEFINE_AG_ERROR_EVENT(xfs_ag_resv_init_error);
 /* refcount tracepoint classes */
 
 DECLARE_EVENT_CLASS(xfs_refcount_class,
-	TP_PROTO(struct xfs_btree_cur *cur, xfs_agblock_t agbno,
+	TP_PROTO(struct xfs_btree_cur *cur, xfs_agblock_t refcbno,
 		xfs_extlen_t len),
-	TP_ARGS(cur, agbno, len),
+	TP_ARGS(cur, refcbno, len),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(dev_t, opdev)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
+		__field(xfs_agblock_t, refcbno)
 		__field(xfs_extlen_t, len)
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
-		__entry->agbno = agbno;
+		xfs_refcountbt_crack_agno_opdev(cur, &__entry->agno, &__entry->opdev);
+		__entry->refcbno = refcbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x",
+	TP_printk("dev %d:%d opdev %d:%d agno 0x%x refcbno 0x%x fsbcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->opdev), MINOR(__entry->opdev),
 		  __entry->agno,
-		  __entry->agbno,
+		  __entry->refcbno,
 		  __entry->len)
 );
 #define DEFINE_REFCOUNT_EVENT(name) \
 DEFINE_EVENT(xfs_refcount_class, name, \
-	TP_PROTO(struct xfs_btree_cur *cur, xfs_agblock_t agbno, \
+	TP_PROTO(struct xfs_btree_cur *cur, xfs_agblock_t refcbno, \
 		xfs_extlen_t len), \
-	TP_ARGS(cur, agbno, len))
+	TP_ARGS(cur, refcbno, len))
 
 TRACE_DEFINE_ENUM(XFS_LOOKUP_EQi);
 TRACE_DEFINE_ENUM(XFS_LOOKUP_LEi);
 TRACE_DEFINE_ENUM(XFS_LOOKUP_GEi);
 TRACE_EVENT(xfs_refcount_lookup,
-	TP_PROTO(struct xfs_btree_cur *cur, xfs_agblock_t agbno,
+	TP_PROTO(struct xfs_btree_cur *cur, xfs_agblock_t refcbno,
 		xfs_lookup_t dir),
-	TP_ARGS(cur, agbno, dir),
+	TP_ARGS(cur, refcbno, dir),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(dev_t, opdev)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
+		__field(xfs_agblock_t, refcbno)
 		__field(xfs_lookup_t, dir)
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
-		__entry->agbno = agbno;
+		xfs_refcountbt_crack_agno_opdev(cur, &__entry->agno, &__entry->opdev);
+		__entry->refcbno = refcbno;
 		__entry->dir = dir;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x cmp %s(%d)",
+	TP_printk("dev %d:%d opdev %d:%d agno 0x%x refcbno 0x%x cmp %s(%d)",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->opdev), MINOR(__entry->opdev),
 		  __entry->agno,
-		  __entry->agbno,
+		  __entry->refcbno,
 		  __print_symbolic(__entry->dir, XFS_AG_BTREE_CMP_FORMAT_STR),
 		  __entry->dir)
 )
@@ -3294,6 +3300,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 	TP_ARGS(cur, irec),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(dev_t, opdev)
 		__field(xfs_agnumber_t, agno)
 		__field(enum xfs_refc_domain, domain)
 		__field(xfs_agblock_t, startblock)
@@ -3302,14 +3309,15 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
+		xfs_refcountbt_crack_agno_opdev(cur, &__entry->agno, &__entry->opdev);
 		__entry->domain = irec->rc_domain;
 		__entry->startblock = irec->rc_startblock;
 		__entry->blockcount = irec->rc_blockcount;
 		__entry->refcount = irec->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u",
+	TP_printk("dev %d:%d opdev %d:%d agno 0x%x dom %s refcbno 0x%x fsbcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->opdev), MINOR(__entry->opdev),
 		  __entry->agno,
 		  __print_symbolic(__entry->domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->startblock,
@@ -3325,49 +3333,52 @@ DEFINE_EVENT(xfs_refcount_extent_class, name, \
 /* single-rcext and an agbno tracepoint class */
 DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
 	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *irec,
-		 xfs_agblock_t agbno),
-	TP_ARGS(cur, irec, agbno),
+		 xfs_agblock_t refcbno),
+	TP_ARGS(cur, irec, refcbno),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(dev_t, opdev)
 		__field(xfs_agnumber_t, agno)
 		__field(enum xfs_refc_domain, domain)
 		__field(xfs_agblock_t, startblock)
 		__field(xfs_extlen_t, blockcount)
 		__field(xfs_nlink_t, refcount)
-		__field(xfs_agblock_t, agbno)
+		__field(xfs_agblock_t, refcbno)
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
+		xfs_refcountbt_crack_agno_opdev(cur, &__entry->agno, &__entry->opdev);
 		__entry->domain = irec->rc_domain;
 		__entry->startblock = irec->rc_startblock;
 		__entry->blockcount = irec->rc_blockcount;
 		__entry->refcount = irec->rc_refcount;
-		__entry->agbno = agbno;
+		__entry->refcbno = refcbno;
 	),
-	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u @ agbno 0x%x",
+	TP_printk("dev %d:%d opdev %d:%d agno 0x%x dom %s refcbno 0x%x fsbcount 0x%x refcount %u @ refcbno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->opdev), MINOR(__entry->opdev),
 		  __entry->agno,
 		  __print_symbolic(__entry->domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->startblock,
 		  __entry->blockcount,
 		  __entry->refcount,
-		  __entry->agbno)
+		  __entry->refcbno)
 )
 
 #define DEFINE_REFCOUNT_EXTENT_AT_EVENT(name) \
 DEFINE_EVENT(xfs_refcount_extent_at_class, name, \
 	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *irec, \
-		 xfs_agblock_t agbno), \
-	TP_ARGS(cur, irec, agbno))
+		 xfs_agblock_t refcbno), \
+	TP_ARGS(cur, irec, refcbno))
 
 /* double-rcext tracepoint class */
 DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *i1,
-		struct xfs_refcount_irec *i2),
+		 struct xfs_refcount_irec *i2),
 	TP_ARGS(cur, i1, i2),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(dev_t, opdev)
 		__field(xfs_agnumber_t, agno)
 		__field(enum xfs_refc_domain, i1_domain)
 		__field(xfs_agblock_t, i1_startblock)
@@ -3380,7 +3391,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
+		xfs_refcountbt_crack_agno_opdev(cur, &__entry->agno, &__entry->opdev);
 		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
@@ -3390,9 +3401,10 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 		__entry->i2_blockcount = i2->rc_blockcount;
 		__entry->i2_refcount = i2->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u -- "
-		  "dom %s agbno 0x%x fsbcount 0x%x refcount %u",
+	TP_printk("dev %d:%d opdev %d:%d agno 0x%x dom %s refcbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "dom %s refcbno 0x%x fsbcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->opdev), MINOR(__entry->opdev),
 		  __entry->agno,
 		  __print_symbolic(__entry->i1_domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->i1_startblock,
@@ -3413,10 +3425,11 @@ DEFINE_EVENT(xfs_refcount_double_extent_class, name, \
 /* double-rcext and an agbno tracepoint class */
 DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *i1,
-		 struct xfs_refcount_irec *i2, xfs_agblock_t agbno),
-	TP_ARGS(cur, i1, i2, agbno),
+		 struct xfs_refcount_irec *i2, xfs_agblock_t refcbno),
+	TP_ARGS(cur, i1, i2, refcbno),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(dev_t, opdev)
 		__field(xfs_agnumber_t, agno)
 		__field(enum xfs_refc_domain, i1_domain)
 		__field(xfs_agblock_t, i1_startblock)
@@ -3426,11 +3439,11 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 		__field(xfs_agblock_t, i2_startblock)
 		__field(xfs_extlen_t, i2_blockcount)
 		__field(xfs_nlink_t, i2_refcount)
-		__field(xfs_agblock_t, agbno)
+		__field(xfs_agblock_t, refcbno)
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
+		xfs_refcountbt_crack_agno_opdev(cur, &__entry->agno, &__entry->opdev);
 		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
@@ -3439,11 +3452,12 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 		__entry->i2_startblock = i2->rc_startblock;
 		__entry->i2_blockcount = i2->rc_blockcount;
 		__entry->i2_refcount = i2->rc_refcount;
-		__entry->agbno = agbno;
+		__entry->refcbno = refcbno;
 	),
-	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u -- "
-		  "dom %s agbno 0x%x fsbcount 0x%x refcount %u @ agbno 0x%x",
+	TP_printk("dev %d:%d opdev %d:%d agno 0x%x dom %s refcbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "dom %s refcbno 0x%x fsbcount 0x%x refcount %u @ refcbno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->opdev), MINOR(__entry->opdev),
 		  __entry->agno,
 		  __print_symbolic(__entry->i1_domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->i1_startblock,
@@ -3453,14 +3467,14 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 		  __entry->i2_startblock,
 		  __entry->i2_blockcount,
 		  __entry->i2_refcount,
-		  __entry->agbno)
+		  __entry->refcbno)
 )
 
 #define DEFINE_REFCOUNT_DOUBLE_EXTENT_AT_EVENT(name) \
 DEFINE_EVENT(xfs_refcount_double_extent_at_class, name, \
 	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *i1, \
-		struct xfs_refcount_irec *i2, xfs_agblock_t agbno), \
-	TP_ARGS(cur, i1, i2, agbno))
+		struct xfs_refcount_irec *i2, xfs_agblock_t refcbno), \
+	TP_ARGS(cur, i1, i2, refcbno))
 
 /* triple-rcext tracepoint class */
 DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
@@ -3469,6 +3483,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 	TP_ARGS(cur, i1, i2, i3),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(dev_t, opdev)
 		__field(xfs_agnumber_t, agno)
 		__field(enum xfs_refc_domain, i1_domain)
 		__field(xfs_agblock_t, i1_startblock)
@@ -3485,7 +3500,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
+		xfs_refcountbt_crack_agno_opdev(cur, &__entry->agno, &__entry->opdev);
 		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
@@ -3499,10 +3514,11 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 		__entry->i3_blockcount = i3->rc_blockcount;
 		__entry->i3_refcount = i3->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u -- "
-		  "dom %s agbno 0x%x fsbcount 0x%x refcount %u -- "
-		  "dom %s agbno 0x%x fsbcount 0x%x refcount %u",
+	TP_printk("dev %d:%d opdev %d:%d agno 0x%x dom %s refcbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "dom %s refcbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "dom %s refcbno 0x%x fsbcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->opdev), MINOR(__entry->opdev),
 		  __entry->agno,
 		  __print_symbolic(__entry->i1_domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->i1_startblock,
@@ -3572,21 +3588,21 @@ DECLARE_EVENT_CLASS(xfs_refcount_deferred_class,
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
 		__field(int, op)
-		__field(xfs_agblock_t, agbno)
+		__field(xfs_agblock_t, refcbno)
 		__field(xfs_extlen_t, len)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
 		__entry->agno = XFS_FSB_TO_AGNO(mp, refc->ri_startblock);
 		__entry->op = refc->ri_type;
-		__entry->agbno = XFS_FSB_TO_AGBNO(mp, refc->ri_startblock);
+		__entry->refcbno = XFS_FSB_TO_AGBNO(mp, refc->ri_startblock);
 		__entry->len = refc->ri_blockcount;
 	),
-	TP_printk("dev %d:%d op %s agno 0x%x agbno 0x%x fsbcount 0x%x",
+	TP_printk("dev %d:%d op %s agno 0x%x refcbno 0x%x fsbcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->op, XFS_REFCOUNT_INTENT_STRINGS),
 		  __entry->agno,
-		  __entry->agbno,
+		  __entry->refcbno,
 		  __entry->len)
 );
 #define DEFINE_REFCOUNT_DEFERRED_EVENT(name) \

