Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B654C7D
	for <linux-xfs@vger.kernel.org>; Fri, 13 Dec 2024 01:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734051667; cv=none; b=BtWVlrXozJnhtZeFYUgJ/wUdXtcuP+y74zrWusyk0fOkEY7uCn8Qak9Wnq3lQdoN62Xw7oNkMv17Uh/L3XzgDHMBjTuhVgH2N4hcpsflF8Iw1l4nwrMxJ2IkQnMfsRDoLLYgGfWQFdFDwrNexx6I/UNdvohmTSWR1wFDomH/m60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734051667; c=relaxed/simple;
	bh=07PKpt/gZ5z0vtvWE/Ci5E1dBNdBWXCjdJS4TP4pSSY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SDb/733PsX21Lbq/vtjoIz9sr39SnI8pcahFJIbxo22AJcRursiF8RaVAlNmdlMteUL/2+GPh3Hw1X2VZ7Qnvb471nl6NoajP2Acsws5rFWEu1wUl4Ucvzv4/d2fUkg2arhF1HxbTjTFaF8SsdotRhhVncc5OiW9Ioky4jFvX4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bl5EUiJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bl5EUiJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFA20C4CECE;
	Fri, 13 Dec 2024 01:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734051667;
	bh=07PKpt/gZ5z0vtvWE/Ci5E1dBNdBWXCjdJS4TP4pSSY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Bl5EUiJSJqJuHPv8yTuOZ8fYO/ES9aumdhuDhTM8qSk/ALsIWuXFC2M242SoWJzzh
	 hGCa2OFPLBD+r7IpmD3G9e4EldM7HNsJcWv6rb2Y9C1PboPNJYrJz+16l/wyc2DQ7u
	 Ha1My0LE0NqXo4LeWEG77LFha0m4TYXtTloNb6M8iBPDcZkmqsXom3xXx2wqrci6c7
	 H5LLgF/cVOoEmJS+tz+/Qcpo87WyMHQdMuEbxT1vKFxPpDBnnQaVZq4FCmMgJW1ZHw
	 qqVcVgxRncmJCPJug1W+fyU2Igi0ITguFL4DCOOORh9YXjVx61hu8Psbnf9ZETnuxr
	 AiHGm8PBV4fYg==
Date: Thu, 12 Dec 2024 17:01:06 -0800
Subject: [PATCH 02/37] xfs: prepare rmap btree cursor tracepoints for realtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173405123347.1181370.69471894031928674.stgit@frogsfrogsfrogs>
In-Reply-To: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
References: <173405123212.1181370.1936576505332113490.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Rework the rmap btree cursor tracepoints in preparation to handle the
realtime rmap btree cursor.  Mostly this involves renaming the field to
"gbno" and extracting the group number from the cursor.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_rmap_item.c |    4 +-
 fs/xfs/xfs_trace.h     |   82 +++++++++++++++++++++++++-----------------------
 2 files changed, 44 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/xfs_rmap_item.c b/fs/xfs/xfs_rmap_item.c
index 76b3c0ed3b4f63..ac2913a7335871 100644
--- a/fs/xfs/xfs_rmap_item.c
+++ b/fs/xfs/xfs_rmap_item.c
@@ -351,10 +351,10 @@ xfs_rmap_defer_add(
 {
 	struct xfs_mount	*mp = tp->t_mountp;
 
-	trace_xfs_rmap_defer(mp, ri);
-
 	ri->ri_group = xfs_group_intent_get(mp, ri->ri_bmap.br_startblock,
 			XG_TYPE_AG);
+
+	trace_xfs_rmap_defer(mp, ri);
 	xfs_defer_add(tp, &ri->ri_list, &xfs_rmap_update_defer_type);
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index cbda663fe6e817..8b7bb1f5ae3c6f 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -14,11 +14,15 @@
  * ino: filesystem inode number
  *
  * agbno: per-AG block number in fs blocks
+ * rgbno: per-rtgroup block number in fs blocks
  * startblock: physical block number for file mappings.  This is either a
  *             segmented fsblock for data device mappings, or a rfsblock
  *             for realtime device mappings
  * fsbcount: number of blocks in an extent, in fs blocks
  *
+ * gbno: generic allocation group block number.  This is an agbno for
+ *       space in a per-AG or a rgbno for space in a realtime group.
+ *
  * daddr: physical block number in 512b blocks
  * bbcount: number of blocks in a physical extent, in 512b blocks
  *
@@ -2918,13 +2922,14 @@ DEFINE_DEFER_PENDING_ITEM_EVENT(xfs_defer_finish_item);
 /* rmap tracepoints */
 DECLARE_EVENT_CLASS(xfs_rmap_class,
 	TP_PROTO(struct xfs_btree_cur *cur,
-		 xfs_agblock_t agbno, xfs_extlen_t len, bool unwritten,
+		 xfs_agblock_t gbno, xfs_extlen_t len, bool unwritten,
 		 const struct xfs_owner_info *oinfo),
-	TP_ARGS(cur, agbno, len, unwritten, oinfo),
+	TP_ARGS(cur, gbno, len, unwritten, oinfo),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
+		__field(xfs_agblock_t, gbno)
 		__field(xfs_extlen_t, len)
 		__field(uint64_t, owner)
 		__field(uint64_t, offset)
@@ -2932,8 +2937,9 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->type = cur->bc_group->xg_type;
 		__entry->agno = cur->bc_group->xg_gno;
-		__entry->agbno = agbno;
+		__entry->gbno = gbno;
 		__entry->len = len;
 		__entry->owner = oinfo->oi_owner;
 		__entry->offset = oinfo->oi_offset;
@@ -2941,10 +2947,11 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 		if (unwritten)
 			__entry->flags |= XFS_RMAP_UNWRITTEN;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%lx",
+	TP_printk("dev %d:%d %sno 0x%x gbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%lx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
-		  __entry->agbno,
+		  __entry->gbno,
 		  __entry->len,
 		  __entry->owner,
 		  __entry->offset,
@@ -2953,9 +2960,9 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 #define DEFINE_RMAP_EVENT(name) \
 DEFINE_EVENT(xfs_rmap_class, name, \
 	TP_PROTO(struct xfs_btree_cur *cur, \
-		 xfs_agblock_t agbno, xfs_extlen_t len, bool unwritten, \
+		 xfs_agblock_t gbno, xfs_extlen_t len, bool unwritten, \
 		 const struct xfs_owner_info *oinfo), \
-	TP_ARGS(cur, agbno, len, unwritten, oinfo))
+	TP_ARGS(cur, gbno, len, unwritten, oinfo))
 
 /* btree cursor error/%ip tracepoint class */
 DECLARE_EVENT_CLASS(xfs_btree_error_class,
@@ -3018,47 +3025,36 @@ TRACE_EVENT(xfs_rmap_convert_state,
 	TP_ARGS(cur, state, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_ino_t, ino)
 		__field(int, state)
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		switch (cur->bc_ops->type) {
-		case XFS_BTREE_TYPE_INODE:
-			__entry->agno = 0;
-			__entry->ino = cur->bc_ino.ip->i_ino;
-			break;
-		case XFS_BTREE_TYPE_AG:
-			__entry->agno = cur->bc_group->xg_gno;
-			__entry->ino = 0;
-			break;
-		case XFS_BTREE_TYPE_MEM:
-			__entry->agno = 0;
-			__entry->ino = 0;
-			break;
-		}
+		__entry->type = cur->bc_group->xg_type;
+		__entry->agno = cur->bc_group->xg_gno;
 		__entry->state = state;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno 0x%x ino 0x%llx state %d caller %pS",
+	TP_printk("dev %d:%d %sno 0x%x state %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
-		  __entry->ino,
 		  __entry->state,
 		  (char *)__entry->caller_ip)
 );
 
 DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 	TP_PROTO(struct xfs_btree_cur *cur,
-		 xfs_agblock_t agbno, xfs_extlen_t len,
+		 xfs_agblock_t gbno, xfs_extlen_t len,
 		 uint64_t owner, uint64_t offset, unsigned int flags),
-	TP_ARGS(cur, agbno, len, owner, offset, flags),
+	TP_ARGS(cur, gbno, len, owner, offset, flags),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
+		__field(xfs_agblock_t, gbno)
 		__field(xfs_extlen_t, len)
 		__field(uint64_t, owner)
 		__field(uint64_t, offset)
@@ -3066,17 +3062,19 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->type = cur->bc_group->xg_type;
 		__entry->agno = cur->bc_group->xg_gno;
-		__entry->agbno = agbno;
+		__entry->gbno = gbno;
 		__entry->len = len;
 		__entry->owner = owner;
 		__entry->offset = offset;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
+	TP_printk("dev %d:%d %sno 0x%x gbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
-		  __entry->agbno,
+		  __entry->gbno,
 		  __entry->len,
 		  __entry->owner,
 		  __entry->offset,
@@ -3085,9 +3083,9 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 #define DEFINE_RMAPBT_EVENT(name) \
 DEFINE_EVENT(xfs_rmapbt_class, name, \
 	TP_PROTO(struct xfs_btree_cur *cur, \
-		 xfs_agblock_t agbno, xfs_extlen_t len, \
+		 xfs_agblock_t gbno, xfs_extlen_t len, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
-	TP_ARGS(cur, agbno, len, owner, offset, flags))
+	TP_ARGS(cur, gbno, len, owner, offset, flags))
 
 TRACE_DEFINE_ENUM(XFS_RMAP_MAP);
 TRACE_DEFINE_ENUM(XFS_RMAP_MAP_SHARED);
@@ -3104,8 +3102,9 @@ DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(unsigned long long, owner)
+		__field(enum xfs_group_type, type)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
+		__field(xfs_agblock_t, gbno)
 		__field(int, whichfork)
 		__field(xfs_fileoff_t, l_loff)
 		__field(xfs_filblks_t, l_len)
@@ -3114,9 +3113,11 @@ DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
 	),
 	TP_fast_assign(
 		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = XFS_FSB_TO_AGNO(mp, ri->ri_bmap.br_startblock);
-		__entry->agbno = XFS_FSB_TO_AGBNO(mp,
-					ri->ri_bmap.br_startblock);
+		__entry->type = ri->ri_group->xg_type;
+		__entry->agno = ri->ri_group->xg_gno;
+		__entry->gbno = xfs_fsb_to_gbno(mp,
+						ri->ri_bmap.br_startblock,
+						ri->ri_group->xg_type);
 		__entry->owner = ri->ri_owner;
 		__entry->whichfork = ri->ri_whichfork;
 		__entry->l_loff = ri->ri_bmap.br_startoff;
@@ -3124,11 +3125,12 @@ DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
 		__entry->l_state = ri->ri_bmap.br_state;
 		__entry->op = ri->ri_type;
 	),
-	TP_printk("dev %d:%d op %s agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
+	TP_printk("dev %d:%d op %s %sno 0x%x gbno 0x%x owner 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __print_symbolic(__entry->op, XFS_RMAP_INTENT_STRINGS),
+		  __print_symbolic(__entry->type, XG_TYPE_STRINGS),
 		  __entry->agno,
-		  __entry->agbno,
+		  __entry->gbno,
 		  __entry->owner,
 		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
 		  __entry->l_loff,
@@ -3993,7 +3995,7 @@ TRACE_EVENT(xfs_fsmap_mapping,
 		__entry->offset = frec->offset;
 		__entry->flags = frec->rm_flags;
 	),
-	TP_printk("dev %d:%d keydev %d:%d agno 0x%x rmapbno 0x%x start_daddr 0x%llx len_daddr 0x%llx owner 0x%llx fileoff 0x%llx flags 0x%x",
+	TP_printk("dev %d:%d keydev %d:%d agno 0x%x gbno 0x%x start_daddr 0x%llx len_daddr 0x%llx owner 0x%llx fileoff 0x%llx flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  MAJOR(__entry->keydev), MINOR(__entry->keydev),
 		  __entry->agno,

