Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1E8BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AukRP9tZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C8A6C433C7;
	Sun, 31 Dec 2023 21:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058323;
	bh=c3GESBwV5Msrc2DvrFSLXu0jpElY4QhuV0MVBd8433A=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=AukRP9tZBQJAPYS0pcmPaavkvbMSUPfiC73oMMiBIh+FAvE0uP3TS+o6LFbZU7Jnw
	 /M44em7lctKdnIYQDEjefa2eIs+HgsenlMjV/KQ1Sk3YsATIOHaSNR9WL2VdPioRXs
	 22N0M+R5whNNqqFbHaO1kchfYHQvlH5uFt2oMFiTg5jwhQ2G3Tnx2SUhE+hnAFjf+N
	 AQLvng6xPUZdf3uTqAVxDitDFDKQ7LtzjQvAbYz1EU4cdw8dPIYNLiGNoUr/iTMSYp
	 fdYrvc5qIVgGdDKYluJ5yQNuhOuf8DVuhkNp3ivxA3mhZC1MLWkHyRUcosyxHeD45D
	 XskBgguOdxg8g==
Date: Sun, 31 Dec 2023 13:32:03 -0800
Subject: [PATCH 01/39] xfs: prepare rmap btree cursor tracepoints for realtime
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404849916.1764998.16216956664784728981.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

Rework the rmap btree cursor tracepoints in preparation to handle the
realtime rmap btree cursor.  Mostly this involves renaming the field to
"rmapbno" and extracting the group number from the cursor when possible.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trace.c |   18 ++++++++++++++++
 fs/xfs/xfs_trace.h |   58 +++++++++++++++++++++++++++-------------------------
 2 files changed, 48 insertions(+), 28 deletions(-)


diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 8a990a2fa132f..f35927ebe2450 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -47,6 +47,24 @@
 #include "xfs_rtgroup.h"
 #include "xfs_rmap.h"
 
+static inline void
+xfs_rmapbt_crack_agno_opdev(
+	struct xfs_btree_cur	*cur,
+	xfs_agnumber_t		*agno,
+	dev_t			*opdev)
+{
+	if (cur->bc_flags & XFS_BTREE_IN_XFILE) {
+		*agno = 0;
+		*opdev = xfbtree_target(cur->bc_mem.xfbtree)->bt_dev;
+	} else if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+		*agno = cur->bc_ino.rtg->rtg_rgno;
+		*opdev = cur->bc_mp->m_rtdev_targp->bt_dev;
+	} else {
+		*agno = cur->bc_ag.pag->pag_agno;
+		*opdev = cur->bc_mp->m_super->s_dev;
+	}
+}
+
 /*
  * We include this last to have the helpers above available for the trace
  * event implementations.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 9290a02bac99e..43ecf98f86558 100644
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
+ * rmapbno: physical block number for a reverse mapping.  This is an agbno for
+ *          per-AG rmap btrees or a rgbno for realtime rmap btrees.
+ *
  * daddr: physical block number in 512b blocks
  * bbcount: number of blocks in a physical extent, in 512b blocks
  *
@@ -2840,13 +2844,14 @@ DEFINE_DEFER_PENDING_ITEM_EVENT(xfs_defer_finish_item);
 /* rmap tracepoints */
 DECLARE_EVENT_CLASS(xfs_rmap_class,
 	TP_PROTO(struct xfs_btree_cur *cur,
-		 xfs_agblock_t agbno, xfs_extlen_t len, bool unwritten,
+		 xfs_agblock_t rmapbno, xfs_extlen_t len, bool unwritten,
 		 const struct xfs_owner_info *oinfo),
-	TP_ARGS(cur, agbno, len, unwritten, oinfo),
+	TP_ARGS(cur, rmapbno, len, unwritten, oinfo),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(dev_t, opdev)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
+		__field(xfs_agblock_t, rmapbno)
 		__field(xfs_extlen_t, len)
 		__field(uint64_t, owner)
 		__field(uint64_t, offset)
@@ -2854,8 +2859,8 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
-		__entry->agbno = agbno;
+		xfs_rmapbt_crack_agno_opdev(cur, &__entry->agno, &__entry->opdev);
+		__entry->rmapbno = rmapbno;
 		__entry->len = len;
 		__entry->owner = oinfo->oi_owner;
 		__entry->offset = oinfo->oi_offset;
@@ -2863,10 +2868,11 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 		if (unwritten)
 			__entry->flags |= XFS_RMAP_UNWRITTEN;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%lx",
+	TP_printk("dev %d:%d opdev %d:%d agno 0x%x rmapbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%lx",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->opdev), MINOR(__entry->opdev),
 		  __entry->agno,
-		  __entry->agbno,
+		  __entry->rmapbno,
 		  __entry->len,
 		  __entry->owner,
 		  __entry->offset,
@@ -2875,9 +2881,9 @@ DECLARE_EVENT_CLASS(xfs_rmap_class,
 #define DEFINE_RMAP_EVENT(name) \
 DEFINE_EVENT(xfs_rmap_class, name, \
 	TP_PROTO(struct xfs_btree_cur *cur, \
-		 xfs_agblock_t agbno, xfs_extlen_t len, bool unwritten, \
+		 xfs_agblock_t rmapbno, xfs_extlen_t len, bool unwritten, \
 		 const struct xfs_owner_info *oinfo), \
-	TP_ARGS(cur, agbno, len, unwritten, oinfo))
+	TP_ARGS(cur, rmapbno, len, unwritten, oinfo))
 
 /* btree cursor error/%ip tracepoint class */
 DECLARE_EVENT_CLASS(xfs_btree_error_class,
@@ -2936,40 +2942,35 @@ TRACE_EVENT(xfs_rmap_convert_state,
 	TP_ARGS(cur, state, caller_ip),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(dev_t, opdev)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_ino_t, ino)
 		__field(int, state)
 		__field(unsigned long, caller_ip)
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
-			__entry->agno = 0;
-			__entry->ino = cur->bc_ino.ip->i_ino;
-		} else {
-			__entry->agno = cur->bc_ag.pag->pag_agno;
-			__entry->ino = 0;
-		}
+		xfs_rmapbt_crack_agno_opdev(cur, &__entry->agno, &__entry->opdev);
 		__entry->state = state;
 		__entry->caller_ip = caller_ip;
 	),
-	TP_printk("dev %d:%d agno 0x%x ino 0x%llx state %d caller %pS",
+	TP_printk("dev %d:%d opdev %d:%d agno 0x%x state %d caller %pS",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->opdev), MINOR(__entry->opdev),
 		  __entry->agno,
-		  __entry->ino,
 		  __entry->state,
 		  (char *)__entry->caller_ip)
 );
 
 DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 	TP_PROTO(struct xfs_btree_cur *cur,
-		 xfs_agblock_t agbno, xfs_extlen_t len,
+		 xfs_agblock_t rmapbno, xfs_extlen_t len,
 		 uint64_t owner, uint64_t offset, unsigned int flags),
-	TP_ARGS(cur, agbno, len, owner, offset, flags),
+	TP_ARGS(cur, rmapbno, len, owner, offset, flags),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
+		__field(dev_t, opdev)
 		__field(xfs_agnumber_t, agno)
-		__field(xfs_agblock_t, agbno)
+		__field(xfs_agblock_t, rmapbno)
 		__field(xfs_extlen_t, len)
 		__field(uint64_t, owner)
 		__field(uint64_t, offset)
@@ -2977,17 +2978,18 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 	),
 	TP_fast_assign(
 		__entry->dev = cur->bc_mp->m_super->s_dev;
-		__entry->agno = cur->bc_ag.pag->pag_agno;
-		__entry->agbno = agbno;
+		xfs_rmapbt_crack_agno_opdev(cur, &__entry->agno, &__entry->opdev);
+		__entry->rmapbno = rmapbno;
 		__entry->len = len;
 		__entry->owner = owner;
 		__entry->offset = offset;
 		__entry->flags = flags;
 	),
-	TP_printk("dev %d:%d agno 0x%x agbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
+	TP_printk("dev %d:%d opdev %d:%d agno 0x%x rmapbno 0x%x fsbcount 0x%x owner 0x%llx fileoff 0x%llx flags 0x%x",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  MAJOR(__entry->opdev), MINOR(__entry->opdev),
 		  __entry->agno,
-		  __entry->agbno,
+		  __entry->rmapbno,
 		  __entry->len,
 		  __entry->owner,
 		  __entry->offset,
@@ -2996,9 +2998,9 @@ DECLARE_EVENT_CLASS(xfs_rmapbt_class,
 #define DEFINE_RMAPBT_EVENT(name) \
 DEFINE_EVENT(xfs_rmapbt_class, name, \
 	TP_PROTO(struct xfs_btree_cur *cur, \
-		 xfs_agblock_t agbno, xfs_extlen_t len, \
+		 xfs_agblock_t rmapbno, xfs_extlen_t len, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
-	TP_ARGS(cur, agbno, len, owner, offset, flags))
+	TP_ARGS(cur, rmapbno, len, owner, offset, flags))
 
 TRACE_DEFINE_ENUM(XFS_RMAP_MAP);
 TRACE_DEFINE_ENUM(XFS_RMAP_MAP_SHARED);

