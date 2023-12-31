Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCB9EBA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WG0JpGkc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447FDC433C7;
	Sun, 31 Dec 2023 20:20:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704054052;
	bh=pzFS7FP+M90yO7wOJIFSXQrUpx6kuQo9ubIhwhW+XRU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WG0JpGkc+6BE5KPpzqbqRDKJmEVf3rU+COAUx8l0IMZKOU75t9ugiHHuMSXJzWFtJ
	 KcO8DgrDnYvqHMj05JlWCk6qOHvoY7p4bUcAp2gfPthuprKxrTzy+sq/4NuKLwysIS
	 ZQA/IW0e7eObseqFAf4v6q0TcrpQaodrlj6WJKljmAQlB/S/2IZ5KA0GQUjkxBN1nJ
	 AiEOpmuviWzbjX4TOgEgjQSCUnPWnwWmwa33jvTdOSwu6R2e00JLX6GSAPoG8STMUd
	 PkTBJnPSz2RjcFXXHdBPtA3kxyGVNeRZAfF4ebMtM7od17zoBBPUfQNh5JqQdTLI50
	 gZtdYnOxsXYcg==
Date: Sun, 31 Dec 2023 12:20:51 -0800
Subject: [PATCH 2/7] xfs: clean up bmap log intent item tracepoint callsites
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404831457.1749708.3486156175042539563.stgit@frogsfrogsfrogs>
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

Pass the incore bmap structure to the tracepoints instead of open-coding
the argument passing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c |   19 +++-------------
 fs/xfs/libxfs/xfs_bmap.h |    4 +++
 fs/xfs/xfs_trace.c       |    1 +
 fs/xfs/xfs_trace.h       |   54 ++++++++++++++++++++--------------------------
 4 files changed, 32 insertions(+), 46 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ae98f7e41ca7f..0e506e83b4a62 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -6169,15 +6169,6 @@ __xfs_bmap_add(
 {
 	struct xfs_bmap_intent		*bi;
 
-	trace_xfs_bmap_defer(tp->t_mountp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, bmap->br_startblock),
-			type,
-			XFS_FSB_TO_AGBNO(tp->t_mountp, bmap->br_startblock),
-			ip->i_ino, whichfork,
-			bmap->br_startoff,
-			bmap->br_blockcount,
-			bmap->br_state);
-
 	bi = kmem_cache_alloc(xfs_bmap_intent_cache, GFP_NOFS | __GFP_NOFAIL);
 	INIT_LIST_HEAD(&bi->bi_list);
 	bi->bi_type = type;
@@ -6185,6 +6176,8 @@ __xfs_bmap_add(
 	bi->bi_whichfork = whichfork;
 	bi->bi_bmap = *bmap;
 
+	trace_xfs_bmap_defer(bi);
+
 	xfs_bmap_update_get_group(tp->t_mountp, bi);
 	xfs_defer_add(tp, &bi->bi_list, &xfs_bmap_update_defer_type);
 	return 0;
@@ -6230,13 +6223,7 @@ xfs_bmap_finish_one(
 
 	ASSERT(tp->t_highest_agno == NULLAGNUMBER);
 
-	trace_xfs_bmap_deferred(tp->t_mountp,
-			XFS_FSB_TO_AGNO(tp->t_mountp, bmap->br_startblock),
-			bi->bi_type,
-			XFS_FSB_TO_AGBNO(tp->t_mountp, bmap->br_startblock),
-			bi->bi_owner->i_ino, bi->bi_whichfork,
-			bmap->br_startoff, bmap->br_blockcount,
-			bmap->br_state);
+	trace_xfs_bmap_deferred(bi);
 
 	if (WARN_ON_ONCE(bi->bi_whichfork != XFS_DATA_FORK)) {
 		xfs_bmap_mark_sick(bi->bi_owner, bi->bi_whichfork);
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 9dd631bc2dc72..b477f92c8508e 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -230,6 +230,10 @@ enum xfs_bmap_intent_type {
 	XFS_BMAP_UNMAP,
 };
 
+#define XFS_BMAP_INTENT_STRINGS \
+	{ XFS_BMAP_MAP,		"map" }, \
+	{ XFS_BMAP_UNMAP,	"unmap" }
+
 struct xfs_bmap_intent {
 	struct list_head			bi_list;
 	enum xfs_bmap_intent_type		bi_type;
diff --git a/fs/xfs/xfs_trace.c b/fs/xfs/xfs_trace.c
index 2d49310fb9128..c9a5d8087b63c 100644
--- a/fs/xfs/xfs_trace.c
+++ b/fs/xfs/xfs_trace.c
@@ -39,6 +39,7 @@
 #include "scrub/xfile.h"
 #include "scrub/xfbtree.h"
 #include "xfs_btree_mem.h"
+#include "xfs_bmap.h"
 
 /*
  * We include this last to have the helpers above available for the trace
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index fa829d1a8ecae..52e54ec267cb8 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -78,6 +78,7 @@ union xfs_btree_ptr;
 struct xfs_dqtrx;
 struct xfs_icwalk;
 struct xfs_perag;
+struct xfs_bmap_intent;
 
 #define XFS_ATTR_FILTER_FLAGS \
 	{ XFS_ATTR_ROOT,	"ROOT" }, \
@@ -2949,16 +2950,12 @@ DEFINE_RMAPBT_EVENT(xfs_rmap_find_right_neighbor_result);
 DEFINE_RMAPBT_EVENT(xfs_rmap_find_left_neighbor_result);
 
 /* deferred bmbt updates */
+TRACE_DEFINE_ENUM(XFS_BMAP_MAP);
+TRACE_DEFINE_ENUM(XFS_BMAP_UNMAP);
+
 DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno,
-		 int op,
-		 xfs_agblock_t agbno,
-		 xfs_ino_t ino,
-		 int whichfork,
-		 xfs_fileoff_t offset,
-		 xfs_filblks_t len,
-		 xfs_exntst_t state),
-	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state),
+	TP_PROTO(struct xfs_bmap_intent *bi),
+	TP_ARGS(bi),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_agnumber_t, agno)
@@ -2971,22 +2968,26 @@ DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
 		__field(int, op)
 	),
 	TP_fast_assign(
-		__entry->dev = mp->m_super->s_dev;
-		__entry->agno = agno;
-		__entry->ino = ino;
-		__entry->agbno = agbno;
-		__entry->whichfork = whichfork;
-		__entry->l_loff = offset;
-		__entry->l_len = len;
-		__entry->l_state = state;
-		__entry->op = op;
+		struct xfs_inode	*ip = bi->bi_owner;
+
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->agno = XFS_FSB_TO_AGNO(ip->i_mount,
+					bi->bi_bmap.br_startblock);
+		__entry->ino = ip->i_ino;
+		__entry->agbno = XFS_FSB_TO_AGBNO(ip->i_mount,
+					bi->bi_bmap.br_startblock);
+		__entry->whichfork = bi->bi_whichfork;
+		__entry->l_loff = bi->bi_bmap.br_startoff;
+		__entry->l_len = bi->bi_bmap.br_blockcount;
+		__entry->l_state = bi->bi_bmap.br_state;
+		__entry->op = bi->bi_type;
 	),
-	TP_printk("dev %d:%d op %d agno 0x%x agbno 0x%x owner 0x%llx %s fileoff 0x%llx fsbcount 0x%llx state %d",
+	TP_printk("dev %d:%d op %s ino 0x%llx agno 0x%x agbno 0x%x %s fileoff 0x%llx fsbcount 0x%llx state %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
-		  __entry->op,
+		  __print_symbolic(__entry->op, XFS_BMAP_INTENT_STRINGS),
+		  __entry->ino,
 		  __entry->agno,
 		  __entry->agbno,
-		  __entry->ino,
 		  __print_symbolic(__entry->whichfork, XFS_WHICHFORK_STRINGS),
 		  __entry->l_loff,
 		  __entry->l_len,
@@ -2994,15 +2995,8 @@ DECLARE_EVENT_CLASS(xfs_bmap_deferred_class,
 );
 #define DEFINE_BMAP_DEFERRED_EVENT(name) \
 DEFINE_EVENT(xfs_bmap_deferred_class, name, \
-	TP_PROTO(struct xfs_mount *mp, xfs_agnumber_t agno, \
-		 int op, \
-		 xfs_agblock_t agbno, \
-		 xfs_ino_t ino, \
-		 int whichfork, \
-		 xfs_fileoff_t offset, \
-		 xfs_filblks_t len, \
-		 xfs_exntst_t state), \
-	TP_ARGS(mp, agno, op, agbno, ino, whichfork, offset, len, state))
+	TP_PROTO(struct xfs_bmap_intent *bi), \
+	TP_ARGS(bi))
 DEFINE_BMAP_DEFERRED_EVENT(xfs_bmap_defer);
 DEFINE_BMAP_DEFERRED_EVENT(xfs_bmap_deferred);
 

