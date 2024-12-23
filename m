Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA9482837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734995193; cv=none; b=JsR+TPnsMgSQLH1AZ/oxpaCVkykiztqgsZxWDNBuuuScfAtgQf/3SSSDQIbCyoMyRVRsPzkZSDQmRlxaDI8yogN29Kd1gLwVeSvmd8rflr15ec1BUxlqnHNBsI4zWM1gS93Og7tCRouCEtezWKCZC8rgDOGxKNZ3KgEHnaLtgIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734995193; c=relaxed/simple;
	bh=QBA9XSPJrZgJGhXQmr4phvUEQdYz3U7OI3v/85PPfOE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NVmdCyDyTILLua8KwCp/4ZJqsedPFi0k2WCrhwLGEtQjYOaQTttj6z7NeJ1+QYtqsUvXG5NL8CMqorvCZAfzQL1vQeaxQ082ihCrR/5x/3Flq+gaRn3jc8Z/4VYHk0rok96NjPv3XRZlv7uy9767Aav8TLKecdwT2bIvP6pmaGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WkqI5e11; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WkqI5e11"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE21C4CED3;
	Mon, 23 Dec 2024 23:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734995193;
	bh=QBA9XSPJrZgJGhXQmr4phvUEQdYz3U7OI3v/85PPfOE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WkqI5e11fXOExb9HweRJMoCK64m0bPLl9hQ9SX4GuKCBOieaezhjS8MBWT5abGdtc
	 Zf77TlxMy+T6OihQw6OzyOdwhTMXXmZPR0kdb2iwZqRTRUCXqLULui44FeXKuryF8t
	 iI754LXHyW8VIb6/7geAg/HOqtcWJO4V1ProiHiqzUogmkNBGiSoVB/Yky3IDuKrKz
	 agFd8GT/Vuz7GQlh+hIKqf2aTFHOBDZOyMwYXmI3tFj3gJ2/pTdtwXUvGCf3vxb8wa
	 e6cUOcdZNgTqcZCpl0emthnIBT19ayrd+O59jbqd+Ajv5cam11PDSxZAV4nyploIMd
	 +9A6HBOmImZsg==
Date: Mon, 23 Dec 2024 15:06:33 -0800
Subject: [PATCH 01/43] xfs: prepare refcount btree cursor tracepoints for
 realtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499419954.2381378.7550110750467205416.stgit@frogsfrogsfrogs>
In-Reply-To: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
References: <173499419823.2381378.11636144864040727907.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_refcount_item.c |    4 +-
 fs/xfs/xfs_trace.h         |  111 +++++++++++++++++++++++++++-----------------
 2 files changed, 70 insertions(+), 45 deletions(-)


diff --git a/fs/xfs/xfs_refcount_item.c b/fs/xfs/xfs_refcount_item.c
index bede1c96c33011..c807c4b90c44e3 100644
--- a/fs/xfs/xfs_refcount_item.c
+++ b/fs/xfs/xfs_refcount_item.c
@@ -328,9 +328,9 @@ xfs_refcount_defer_add(
 {
 	struct xfs_mount		*mp = tp->t_mountp;
 
-	trace_xfs_refcount_defer(mp, ri);
-
 	ri->ri_group = xfs_group_intent_get(mp, ri->ri_startblock, XG_TYPE_AG);
+
+	trace_xfs_refcount_defer(mp, ri);
 	xfs_defer_add(tp, &ri->ri_list, &xfs_refcount_update_defer_type);
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 84cdc145e2d96a..4fe689410eb6ae 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3305,56 +3305,62 @@ TRACE_EVENT(xfs_ag_resv_init_error,
 /* refcount tracepoint classes */
 
 DECLARE_EVENT_CLASS(xfs_refcount_class,
-	TP_PROTO(struct xfs_btree_cur *cur, xfs_agblock_t agbno,
+	TP_PROTO(struct xfs_btree_cur *cur, xfs_agblock_t gbno,
 		xfs_extlen_t len),
-	TP_ARGS(cur, agbno, len),
+	TP_ARGS(cur, gbno, len),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
+		__field(xfs_agblock_t, gbno)
 		__field(xfs_extlen_t, len)
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->type = cur->bc_group->xg_type;
 		__entry->agno = cur->bc_group->xg_gno;
-		__entry->agbno = agbno;
+		__entry->gbno = gbno;
 		__entry->len = len;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x",
+	TP_printk("dev %d:%d %sno 0x%x gbno 0x%x fsbcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
-		  __entry->agbno,
+		  __entry->gbno,
 		  __entry->len)
 );
 #define DEFINE_REFCOUNT_EVENT(name) \
 DEFINE_EVENT(xfs_refcount_class, name, \
-	TP_PROTO(struct xfs_btree_cur *cur, xfs_agblock_t agbno, \
+	TP_PROTO(struct xfs_btree_cur *cur, xfs_agblock_t gbno, \
 		xfs_extlen_t len), \
-	TP_ARGS(cur, agbno, len))
+	TP_ARGS(cur, gbno, len))
 
 TRACE_DEFINE_ENUM(XFS_LOOKUP_EQi);
 TRACE_DEFINE_ENUM(XFS_LOOKUP_LEi);
 TRACE_DEFINE_ENUM(XFS_LOOKUP_GEi);
 TRACE_EVENT(xfs_refcount_lookup,
-	TP_PROTO(struct xfs_btree_cur *cur, xfs_agblock_t agbno,
+	TP_PROTO(struct xfs_btree_cur *cur, xfs_agblock_t gbno,
 		xfs_lookup_t dir),
-	TP_ARGS(cur, agbno, dir),
+	TP_ARGS(cur, gbno, dir),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
+		__field(xfs_agblock_t, gbno)
 		__field(xfs_lookup_t, dir)
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->type = cur->bc_group->xg_type;
 		__entry->agno = cur->bc_group->xg_gno;
-		__entry->agbno = agbno;
+		__entry->gbno = gbno;
 		__entry->dir = dir;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x cmp %s(%d)",
+	TP_printk("dev %d:%d %sno 0x%x gbno 0x%x cmp %s(%d)",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
-		  __entry->agbno,
+		  __entry->gbno,
 		  __print_symbolic(__entry->dir, XFS_AG_BTREE_CMP_FORMAT_STR),
 		  __entry->dir)
 )
@@ -3365,6 +3371,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 	TP_ARGS(cur, irec),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
 		__field(enum xfs_refc_domain, domain)
 		__field(xfs_agblock_t, startblock)
@@ -3373,14 +3380,16 @@ DECLARE_EVENT_CLASS(xfs_refcount_extent_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->type = cur->bc_group->xg_type;
 		__entry->agno = cur->bc_group->xg_gno;
 		__entry->domain = irec->rc_domain;
 		__entry->startblock = irec->rc_startblock;
 		__entry->blockcount = irec->rc_blockcount;
 		__entry->refcount = irec->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u",
+	TP_printk("dev %d:%d %sno 0x%x dom %s gbno 0x%x fsbcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
 		  __print_symbolic(__entry->domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->startblock,
@@ -3396,49 +3405,53 @@ DEFINE_EVENT(xfs_refcount_extent_class, name, \
 /* single-rcext and an agbno tracepoint class */
 DECLARE_EVENT_CLASS(xfs_refcount_extent_at_class,
 	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *irec,
-		 xfs_agblock_t agbno),
-	TP_ARGS(cur, irec, agbno),
+		 xfs_agblock_t gbno),
+	TP_ARGS(cur, irec, gbno),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
 		__field(enum xfs_refc_domain, domain)
 		__field(xfs_agblock_t, startblock)
 		__field(xfs_extlen_t, blockcount)
 		__field(xfs_nlink_t, refcount)
-		__field(xfs_agblock_t, agbno)
+		__field(xfs_agblock_t, gbno)
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->type = cur->bc_group->xg_type;
 		__entry->agno = cur->bc_group->xg_gno;
 		__entry->domain = irec->rc_domain;
 		__entry->startblock = irec->rc_startblock;
 		__entry->blockcount = irec->rc_blockcount;
 		__entry->refcount = irec->rc_refcount;
-		__entry->agbno = agbno;
+		__entry->gbno = gbno;
 	),
-	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u @ agbno 0x%x",
+	TP_printk("dev %d:%d %sno 0x%x dom %s gbno 0x%x fsbcount 0x%x refcount %u @ gbno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
 		  __print_symbolic(__entry->domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->startblock,
 		  __entry->blockcount,
 		  __entry->refcount,
-		  __entry->agbno)
+		  __entry->gbno)
 )
 
 #define DEFINE_REFCOUNT_EXTENT_AT_EVENT(name) \
 DEFINE_EVENT(xfs_refcount_extent_at_class, name, \
 	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *irec, \
-		 xfs_agblock_t agbno), \
-	TP_ARGS(cur, irec, agbno))
+		 xfs_agblock_t gbno), \
+	TP_ARGS(cur, irec, gbno))
 
 /* double-rcext tracepoint class */
 DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *i1,
-		struct xfs_refcount_irec *i2),
+		 struct xfs_refcount_irec *i2),
 	TP_ARGS(cur, i1, i2),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
 		__field(enum xfs_refc_domain, i1_domain)
 		__field(xfs_agblock_t, i1_startblock)
@@ -3451,6 +3464,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->type = cur->bc_group->xg_type;
 		__entry->agno = cur->bc_group->xg_gno;
 		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
@@ -3461,9 +3475,10 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_class,
 		__entry->i2_blockcount = i2->rc_blockcount;
 		__entry->i2_refcount = i2->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u -- "
-		  "dom %s agbno 0x%x fsbcount 0x%x refcount %u",
+	TP_printk("dev %d:%d %sno 0x%x dom %s gbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "dom %s gbno 0x%x fsbcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
 		  __print_symbolic(__entry->i1_domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->i1_startblock,
@@ -3484,10 +3499,11 @@ DEFINE_EVENT(xfs_refcount_double_extent_class, name, \
 /* double-rcext and an agbno tracepoint class */
 DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *i1,
-		 struct xfs_refcount_irec *i2, xfs_agblock_t agbno),
-	TP_ARGS(cur, i1, i2, agbno),
+		 struct xfs_refcount_irec *i2, xfs_agblock_t gbno),
+	TP_ARGS(cur, i1, i2, gbno),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
 		__field(enum xfs_refc_domain, i1_domain)
 		__field(xfs_agblock_t, i1_startblock)
@@ -3497,10 +3513,11 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 		__field(xfs_agblock_t, i2_startblock)
 		__field(xfs_extlen_t, i2_blockcount)
 		__field(xfs_nlink_t, i2_refcount)
-		__field(xfs_agblock_t, agbno)
+		__field(xfs_agblock_t, gbno)
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->type = cur->bc_group->xg_type;
 		__entry->agno = cur->bc_group->xg_gno;
 		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
@@ -3510,11 +3527,12 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 		__entry->i2_startblock = i2->rc_startblock;
 		__entry->i2_blockcount = i2->rc_blockcount;
 		__entry->i2_refcount = i2->rc_refcount;
-		__entry->agbno = agbno;
+		__entry->gbno = gbno;
 	),
-	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u -- "
-		  "dom %s agbno 0x%x fsbcount 0x%x refcount %u @ agbno 0x%x",
+	TP_printk("dev %d:%d %sno 0x%x dom %s gbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "dom %s gbno 0x%x fsbcount 0x%x refcount %u @ gbno 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
 		  __print_symbolic(__entry->i1_domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->i1_startblock,
@@ -3524,14 +3542,14 @@ DECLARE_EVENT_CLASS(xfs_refcount_double_extent_at_class,
 		  __entry->i2_startblock,
 		  __entry->i2_blockcount,
 		  __entry->i2_refcount,
-		  __entry->agbno)
+		  __entry->gbno)
 )
 
 #define DEFINE_REFCOUNT_DOUBLE_EXTENT_AT_EVENT(name) \
 DEFINE_EVENT(xfs_refcount_double_extent_at_class, name, \
 	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_refcount_irec *i1, \
-		struct xfs_refcount_irec *i2, xfs_agblock_t agbno), \
-	TP_ARGS(cur, i1, i2, agbno))
+		struct xfs_refcount_irec *i2, xfs_agblock_t gbno), \
+	TP_ARGS(cur, i1, i2, gbno))
 
 /* triple-rcext tracepoint class */
 DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
@@ -3540,6 +3558,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 	TP_ARGS(cur, i1, i2, i3),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
 		__field(enum xfs_refc_domain, i1_domain)
 		__field(xfs_agblock_t, i1_startblock)
@@ -3556,6 +3575,7 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->type = cur->bc_group->xg_type;
 		__entry->agno = cur->bc_group->xg_gno;
 		__entry->i1_domain = i1->rc_domain;
 		__entry->i1_startblock = i1->rc_startblock;
@@ -3570,10 +3590,11 @@ DECLARE_EVENT_CLASS(xfs_refcount_triple_extent_class,
 		__entry->i3_blockcount = i3->rc_blockcount;
 		__entry->i3_refcount = i3->rc_refcount;
 	),
-	TP_printk("dev %d:%d agno 0x%x dom %s agbno 0x%x fsbcount 0x%x refcount %u -- "
-		  "dom %s agbno 0x%x fsbcount 0x%x refcount %u -- "
-		  "dom %s agbno 0x%x fsbcount 0x%x refcount %u",
+	TP_printk("dev %d:%d %sno 0x%x dom %s gbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "dom %s gbno 0x%x fsbcount 0x%x refcount %u -- "
+		  "dom %s gbno 0x%x fsbcount 0x%x refcount %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
 		  __print_symbolic(__entry->i1_domain, XFS_REFC_DOMAIN_STRINGS),
 		  __entry->i1_startblock,
@@ -3641,23 +3662,27 @@ DECLARE_EVENT_CLASS(xfs_refcount_deferred_class,
 	TP_ARGS(mp, refc),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
 		__field(int, op)
-		__field(xfs_agblock_t, agbno)
+		__field(xfs_agblock_t, gbno)
 		__field(xfs_extlen_t, len)
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = XFS_FSB_TO_AGNO(mp, refc->ri_startblock);
+		__entry->type = refc->ri_group->xg_type;
+		__entry->agno = refc->ri_group->xg_gno;
 		__entry->op = refc->ri_type;
-		__entry->agbno = XFS_FSB_TO_AGBNO(mp, refc->ri_startblock);
+		__entry->gbno = xfs_fsb_to_gbno(mp, refc->ri_startblock,
+						   refc->ri_group->xg_type);
 		__entry->len = refc->ri_blockcount;
 	),
-	TP_printk("dev %d:%d op %s agno 0x%x agbno 0x%x fsbcount 0x%x",
+	TP_printk("dev %d:%d op %s %sno 0x%x gbno 0x%x fsbcount 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->op, XFS_REFCOUNT_INTENT_STRINGS),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
-		  __entry->agbno,
+		  __entry->gbno,
 		  __entry->len)
 );
 #define DEFINE_REFCOUNT_DEFERRED_EVENT(name) \

