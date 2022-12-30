Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D15F3C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:48:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbiLaBsV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:48:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236064AbiLaBsU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:48:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A0E1DDD1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 17:48:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8111C61CCD
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD26C433EF;
        Sat, 31 Dec 2022 01:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451297;
        bh=866MGCVura50NAePvq8mxMfEJxC/c8pr3z9YHZxtUUo=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=bgfyMRmGkU5eVheyJsck4GXYjDqARNwnStFOXoh46EdmGBbtCEbBWTRa59OdqvgKT
         nXbOo1RwuKd2ASWBrlJZUbtkhKnXpIQIR+k21ZLZeTVhNcJzMsEuaPoLWCAoaDMGvf
         ECv/jbOlA5oM0VcPZNY33ka5oIGV67nIPBU8+D5FsJdoNsqiFgJu3RFCp4HQiVnsc0
         Jg/JdNRqN36MlRdIre84YMiPgngsLy8pwN+EJHA+/7KP8KyJJmwUb2RSWcp3wKOpCW
         Z6VMMfi9Nfbaxs7q0sorHnUiXctv+vIQNAhAkz0+ECIs/Lf/rsbq6ZX18LC6pYyXAV
         Dsh0hYf4liM2w==
Subject: [PATCH 01/42] xfs: prepare refcount btree cursor tracepoints for
 realtime
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:29 -0800
Message-ID: <167243870911.717073.3631164146808046063.stgit@magnolia>
In-Reply-To: <167243870849.717073.203452386730176902.stgit@magnolia>
References: <167243870849.717073.203452386730176902.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
index 0b9405749079..64f11a535763 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -64,6 +64,15 @@ xfs_rmapbt_crack_agno_opdev(
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
index c22ffe459002..4e0c40934a7f 100644
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
@@ -3230,56 +3232,60 @@ DEFINE_AG_ERROR_EVENT(xfs_ag_resv_init_error);
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
@@ -3290,6 +3296,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 	TP_ARGS(cur, irec),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(dev_t, opdev)
 		__field(xfs_agnumber_t, agno)
 		__field(enum xfs_refc_domain, domain)
 		__field(xfs_agblock_t, startblock)
@@ -3298,14 +3305,15 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
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
@@ -3321,49 +3329,52 @@ DEFINE_EVENT(xfs_refcount_extent_class, name, \
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
@@ -3376,7 +3387,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
+		xfs_refcountbt_crack_agno_opdev(cur, &__entry->agno, &__entry->opdev);
 		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
@@ -3386,9 +3397,10 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
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
@@ -3409,10 +3421,11 @@ DEFINE_EVENT(xfs_refcount_double_extent_class, name, \
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
@@ -3422,11 +3435,11 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
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
@@ -3435,11 +3448,12 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
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
@@ -3449,14 +3463,14 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
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
@@ -3465,6 +3479,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 	TP_ARGS(cur, i1, i2, i3),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(dev_t, opdev)
 		__field(xfs_agnumber_t, agno)
 		__field(enum xfs_refc_domain, i1_domain)
 		__field(xfs_agblock_t, i1_startblock)
@@ -3481,7 +3496,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
+		xfs_refcountbt_crack_agno_opdev(cur, &__entry->agno, &__entry->opdev);
 		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
 		__entry->i1_blockcount = i1->rc_blockcount;
@@ -3495,10 +3510,11 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
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
@@ -3568,21 +3584,21 @@ DECLARE_EVENT_CLASS(xfs_refcount_deferred_class,
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

