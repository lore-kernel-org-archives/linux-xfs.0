Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3185FBA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BO79uhHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A546CC433C7;
	Sun, 31 Dec 2023 20:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054036;
	bh=rQGQp0+f9lXPwoOY6wtfp6XAkwuKdD+yLvyPUm9wz6I=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=BO79uhHnv2fAwA0t+ZEp+sZIPvT+8piDWe47/BS6iwORebEPXmi3CK6k1rHhLyI0l
	 6YAu4/y73Bh5Shwhzjo094BeiFjWSElekFBQWv49xAFiXEPbaWSev0JqZcpABuIZ7F
	 U6c2j8rVaxHPnam1l79R4NRVXNpKd4AS/DyaFwfM/cD/4gjyKmSeskS6xRmvYRUx5f
	 JC1OrsVO+0+xPF0xMyTJX0TcxkrhKApTtgjHvS7dx1hMkjhNhCXOAtak6IMNuZXpO5
	 qtFwKCSnHpxxK4y/1Ipa9S6+4KgGuhk938kL10JrwhSMwQNuoDg4C+JL0gHB/s799z
	 FxVrFuZFRPkLQ==
Date: Sun, 31 Dec 2023 12:20:36 -0800
Subject: [PATCH 1/7] xfs: split tracepoint classes for deferred items
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404831441.1749708.11833404272521238326.stgit@frogsfrogsfrogs>
In-Reply-To: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
References: <170404831410.1749708.14664484779809794342.stgit@frogsfrogsfrogs>
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

We're about to start adding support for deferred log intent items for
realtime extents, so split these four types into separate classes so
that we can customize them as the transition happens.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trace.h |  273 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 177 insertions(+), 96 deletions(-)


diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 1690f518ae74b..fa829d1a8ecae 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2658,94 +2658,6 @@ DEFINE_EVENT(xfs_defer_pending_class, name, \
 	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_pending *dfp), \
 	TP_ARGS(mp, dfp))
 
-DECLARE_EVENT_CLASS(xfs_phys_extent_deferred_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 int type, xfs_agblock_t agbno, xfs_extlen_t len),
-	TP_ARGS(mp, agno, type, agbno, len),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
-		__field(int, type)
-		__field(xfs_agblock_t, agbno)
-		__field(xfs_extlen_t, len)
-	),
-	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->type = type;
-		__entry->agbno = agbno;
-		__entry->len = len;
-	),
-	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x fsbcount 0x%x",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->type,
-		  __entry->agno,
-		  __entry->agbno,
-		  __entry->len)
-);
-#define DEFINE_PHYS_EXTENT_DEFERRED_EVENT(name) \
-DEFINE_EVENT(xfs_phys_extent_deferred_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 int type, \
-		 xfs_agblock_t bno, \
-		 xfs_extlen_t len), \
-	TP_ARGS(mp, agno, type, bno, len))
-
-DECLARE_EVENT_CLASS(xfs_map_extent_deferred_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 int op,
-		 xfs_agblock_t agbno,
-		 xfs_ino_t ino,
-		 int whichfork,
-		 xfs_fileoff_t offset,
-		 xfs_filblks_t len,
-		 xfs_exntst_t state),
-	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state),
-	TP_STRUCT__entry(
-		__field(dev_t, dev)
-		__field(xfs_agnumber_t, agno)
-		__field(xfs_ino_t, ino)
-		__field(xfs_agblock_t, agbno)
-		__field(int, whichfork)
-		__field(xfs_fileoff_t, l_loff)
-		__field(xfs_filblks_t, l_len)
-		__field(xfs_exntst_t, l_state)
-		__field(int, op)
-	),
-	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->ino = ino;
-		__entry->agbno = agbno;
-		__entry->whichfork = whichfork;
-		__entry->l_loff = offset;
-		__entry->l_len = len;
-		__entry->l_state = state;
-		__entry->op = op;
-	),
-	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
-		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->op,
-		  __entry->agno,
-		  __entry->agbno,
-		  __entry->ino,
-		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
-		  __entry->l_loff,
-		  __entry->l_len,
-		  __entry->l_state)
-);
-#define DEFINE_MAP_EXTENT_DEFERRED_EVENT(name) \
-DEFINE_EVENT(xfs_map_extent_deferred_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 int op, \
-		 xfs_agblock_t agbno, \
-		 xfs_ino_t ino, \
-		 int whichfork, \
-		 xfs_fileoff_t offset, \
-		 xfs_filblks_t len, \
-		 xfs_exntst_t state), \
-	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state))
-
 DEFINE_DEFER_EVENT(xfs_defer_cancel);
 DEFINE_DEFER_EVENT(xfs_defer_trans_roll);
 DEFINE_DEFER_EVENT(xfs_defer_trans_abort);
@@ -2764,11 +2676,42 @@ DEFINE_DEFER_PENDING_EVENT(xfs_defer_isolate_paused);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_item_pause);
 DEFINE_DEFER_PENDING_EVENT(xfs_defer_item_unpause);
 
-#define DEFINE_BMAP_FREE_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
-DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_defer);
-DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_bmap_free_deferred);
-DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_agfl_free_defer);
-DEFINE_BMAP_FREE_DEFERRED_EVENT(xfs_agfl_free_deferred);
+DECLARE_EVENT_CLASS(xfs_free_extent_deferred_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 int type, xfs_agblock_t agbno, xfs_extlen_t len),
+	TP_ARGS(mp, agno, type, agbno, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(int, type)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->type = type;
+		__entry->agbno = agbno;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x fsbcount 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->type,
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len)
+);
+#define DEFINE_FREE_EXTENT_DEFERRED_EVENT(name) \
+DEFINE_EVENT(xfs_free_extent_deferred_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 int type, \
+		 xfs_agblock_t bno, \
+		 xfs_extlen_t len), \
+	TP_ARGS(mp, agno, type, bno, len))
+DEFINE_FREE_EXTENT_DEFERRED_EVENT(xfs_bmap_free_defer);
+DEFINE_FREE_EXTENT_DEFERRED_EVENT(xfs_bmap_free_deferred);
+DEFINE_FREE_EXTENT_DEFERRED_EVENT(xfs_agfl_free_defer);
+DEFINE_FREE_EXTENT_DEFERRED_EVENT(xfs_agfl_free_deferred);
 
 DECLARE_EVENT_CLASS(xfs_defer_pending_item_class,
 	TP_PROTO(struct xfs_mount *mp, struct xfs_defer_pending *dfp,
@@ -2933,7 +2876,60 @@ DEFINE_EVENT(xfs_rmapbt_class, name, \
 		 uint64_t owner, uint64_t offset, unsigned int flags), \
 	TP_ARGS(mp, agno, agbno, len, owner, offset, flags))
 
-#define DEFINE_RMAP_DEFERRED_EVENT DEFINE_MAP_EXTENT_DEFERRED_EVENT
+DECLARE_EVENT_CLASS(xfs_rmap_deferred_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 int op,
+		 xfs_agblock_t agbno,
+		 xfs_ino_t ino,
+		 int whichfork,
+		 xfs_fileoff_t offset,
+		 xfs_filblks_t len,
+		 xfs_exntst_t state),
+	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_ino_t, ino)
+		__field(xfs_agblock_t, agbno)
+		__field(int, whichfork)
+		__field(xfs_fileoff_t, l_loff)
+		__field(xfs_filblks_t, l_len)
+		__field(xfs_exntst_t, l_state)
+		__field(int, op)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->ino = ino;
+		__entry->agbno = agbno;
+		__entry->whichfork = whichfork;
+		__entry->l_loff = offset;
+		__entry->l_len = len;
+		__entry->l_state = state;
+		__entry->op = op;
+	),
+	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->op,
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->ino,
+		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
+		  __entry->l_loff,
+		  __entry->l_len,
+		  __entry->l_state)
+);
+#define DEFINE_RMAP_DEFERRED_EVENT(name) \
+DEFINE_EVENT(xfs_rmap_deferred_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 int op, \
+		 xfs_agblock_t agbno, \
+		 xfs_ino_t ino, \
+		 int whichfork, \
+		 xfs_fileoff_t offset, \
+		 xfs_filblks_t len, \
+		 xfs_exntst_t state), \
+	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state))
 DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_defer);
 DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_deferred);
 
@@ -2953,7 +2949,60 @@ DEFINE_RMAPBT_EVENT(xfs_rmap_find_right_neighbor_result);
 DEFINE_RMAPBT_EVENT(xfs_rmap_find_left_neighbor_result);
 
 /* deferred bmbt updates */
-#define DEFINE_BMAP_DEFERRED_EVENT	DEFINE_RMAP_DEFERRED_EVENT
+DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 int op,
+		 xfs_agblock_t agbno,
+		 xfs_ino_t ino,
+		 int whichfork,
+		 xfs_fileoff_t offset,
+		 xfs_filblks_t len,
+		 xfs_exntst_t state),
+	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_ino_t, ino)
+		__field(xfs_agblock_t, agbno)
+		__field(int, whichfork)
+		__field(xfs_fileoff_t, l_loff)
+		__field(xfs_filblks_t, l_len)
+		__field(xfs_exntst_t, l_state)
+		__field(int, op)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->ino = ino;
+		__entry->agbno = agbno;
+		__entry->whichfork = whichfork;
+		__entry->l_loff = offset;
+		__entry->l_len = len;
+		__entry->l_state = state;
+		__entry->op = op;
+	),
+	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->op,
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->ino,
+		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
+		  __entry->l_loff,
+		  __entry->l_len,
+		  __entry->l_state)
+);
+#define DEFINE_BMAP_DEFERRED_EVENT(name) \
+DEFINE_EVENT(xfs_bmap_deferred_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 int op, \
+		 xfs_agblock_t agbno, \
+		 xfs_ino_t ino, \
+		 int whichfork, \
+		 xfs_fileoff_t offset, \
+		 xfs_filblks_t len, \
+		 xfs_exntst_t state), \
+	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state))
 DEFINE_BMAP_DEFERRED_EVENT(xfs_bmap_defer);
 DEFINE_BMAP_DEFERRED_EVENT(xfs_bmap_deferred);
 
@@ -3330,7 +3379,39 @@ DEFINE_AG_ERROR_EVENT(xfs_refcount_find_right_extent_error);
 DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared);
 DEFINE_AG_EXTENT_EVENT(xfs_refcount_find_shared_result);
 DEFINE_AG_ERROR_EVENT(xfs_refcount_find_shared_error);
-#define DEFINE_REFCOUNT_DEFERRED_EVENT DEFINE_PHYS_EXTENT_DEFERRED_EVENT
+
+DECLARE_EVENT_CLASS(xfs_refcount_deferred_class,
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
+		 int type, xfs_agblock_t agbno, xfs_extlen_t len),
+	TP_ARGS(mp, agno, type, agbno, len),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(int, type)
+		__field(xfs_agblock_t, agbno)
+		__field(xfs_extlen_t, len)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->agno = agno;
+		__entry->type = type;
+		__entry->agbno = agbno;
+		__entry->len = len;
+	),
+	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x fsbcount 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->type,
+		  __entry->agno,
+		  __entry->agbno,
+		  __entry->len)
+);
+#define DEFINE_REFCOUNT_DEFERRED_EVENT(name) \
+DEFINE_EVENT(xfs_refcount_deferred_class, name, \
+	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
+		 int type, \
+		 xfs_agblock_t bno, \
+		 xfs_extlen_t len), \
+	TP_ARGS(mp, agno, type, bno, len))
 DEFINE_REFCOUNT_DEFERRED_EVENT(xfs_refcount_defer);
 DEFINE_REFCOUNT_DEFERRED_EVENT(xfs_refcount_deferred);
 

