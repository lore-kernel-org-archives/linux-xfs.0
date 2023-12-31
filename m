Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE65BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mQGn5v4F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B867C433C7;
	Sun, 31 Dec 2023 20:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053723;
	bh=BUFAcYUgHlQmGIu66DumAHEHjfotafx4a9D/si2XWQQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mQGn5v4Fl/R5j5A4KcSufkBwWA3x2CK2EZJfOaYHP3YQs3rKVY4gpu3FW4w3zza/N
	 apmmeLPQ8hH1WgOSDdF8WU7ncj2HWmJ+SkhoNVWC7MFbty4m0XpsSa0GZ14A+QMNTx
	 8DeSeZ4bzZAdWBRPQI2KT0f7ZsrnTdIoZ6ArEXKMPrkAJ3H2xfgQKP1M9sZTu2cs1b
	 4ES8BmzyVBSZSpOtH1tvg6xxeJI599CsvgIm+EKwhb3CfHmKaqbH6ke4EywFKF3yY+
	 gATExz0rl6D7IleJANxu9fKSHZ6FHrw/rVU1wOiU8ycy5m6j6xhQPVttWQoyW1FUVt
	 nAl/oOqL3hmrg==
Date: Sun, 31 Dec 2023 12:15:23 -0800
Subject: [PATCH 7/9] xfs: consolidate btree block allocation tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Message-ID: <170404829692.1748854.1080292878740633374.stgit@frogsfrogsfrogs>
In-Reply-To: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
References: <170404829556.1748854.13886473250848576704.stgit@frogsfrogsfrogs>
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

Don't waste tracepoint segment memory on per-btree block allocation
tracepoints when we can do it from the generic btree code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c          |   20 ++++++++++++---
 fs/xfs/libxfs/xfs_refcount_btree.c |    2 -
 fs/xfs/libxfs/xfs_rmap_btree.c     |    2 -
 fs/xfs/xfs_trace.h                 |   49 +++++++++++++++++++++++++++++++++++-
 4 files changed, 64 insertions(+), 9 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 3e966182b90a9..fbed51b4462e8 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2693,6 +2693,20 @@ xfs_btree_rshift(
 	return error;
 }
 
+static inline int
+xfs_btree_alloc_block(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_ptr	*hint_block,
+	union xfs_btree_ptr		*new_block,
+	int				*stat)
+{
+	int				error;
+
+	error = cur->bc_ops->alloc_block(cur, hint_block, new_block, stat);
+	trace_xfs_btree_alloc_block(cur, new_block, *stat, error);
+	return error;
+}
+
 /*
  * Split cur/level block in half.
  * Return new block number and the key to its first
@@ -2736,7 +2750,7 @@ __xfs_btree_split(
 	xfs_btree_buf_to_ptr(cur, lbp, &lptr);
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
-	error = cur->bc_ops->alloc_block(cur, &lptr, &rptr, stat);
+	error = xfs_btree_alloc_block(cur, &lptr, &rptr, stat);
 	if (error)
 		goto error0;
 	if (*stat == 0)
@@ -3016,7 +3030,7 @@ xfs_btree_new_iroot(
 	pp = xfs_btree_ptr_addr(cur, 1, block);
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
-	error = cur->bc_ops->alloc_block(cur, pp, &nptr, stat);
+	error = xfs_btree_alloc_block(cur, pp, &nptr, stat);
 	if (error)
 		goto error0;
 	if (*stat == 0)
@@ -3116,7 +3130,7 @@ xfs_btree_new_root(
 	cur->bc_ops->init_ptr_from_cur(cur, &rptr);
 
 	/* Allocate the new block. If we can't do it, we're toast. Give up. */
-	error = cur->bc_ops->alloc_block(cur, &rptr, &lptr, stat);
+	error = xfs_btree_alloc_block(cur, &rptr, &lptr, stat);
 	if (error)
 		goto error0;
 	if (*stat == 0)
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index a346e49981ac3..f904a92d1b590 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -77,8 +77,6 @@ xfs_refcountbt_alloc_block(
 					xfs_refc_block(args.mp)));
 	if (error)
 		goto out_error;
-	trace_xfs_refcountbt_alloc_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			args.agbno, 1);
 	if (args.fsbno == NULLFSBLOCK) {
 		*stat = 0;
 		return 0;
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 0dc086bc528f7..43ff2236f6237 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -94,8 +94,6 @@ xfs_rmapbt_alloc_block(
 				       &bno, 1);
 	if (error)
 		return error;
-
-	trace_xfs_rmapbt_alloc_block(cur->bc_mp, pag->pag_agno, bno, 1);
 	if (bno == NULLAGBLOCK) {
 		*stat = 0;
 		return 0;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 5076770d9b000..3c6c8a8dfae8e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2493,6 +2493,53 @@ DEFINE_EVENT(xfs_btree_cur_class, name, \
 DEFINE_BTREE_CUR_EVENT(xfs_btree_updkeys);
 DEFINE_BTREE_CUR_EVENT(xfs_btree_overlapped_query_range);
 
+TRACE_EVENT(xfs_btree_alloc_block,
+	TP_PROTO(struct xfs_btree_cur *cur, union xfs_btree_ptr *ptr, int stat,
+		 int error),
+	TP_ARGS(cur, ptr, stat, error),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_ino_t, ino)
+		__field(xfs_btnum_t, btnum)
+		__field(int, error)
+		__field(xfs_agblock_t, agbno)
+	),
+	TP_fast_assign(
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE) {
+			__entry->agno = 0;
+			__entry->ino = cur->bc_ino.ip->i_ino;
+		} else {
+			__entry->agno = cur->bc_ag.pag->pag_agno;
+			__entry->ino = 0;
+		}
+		__entry->btnum = cur->bc_btnum;
+		__entry->error = error;
+		if (!error && stat) {
+			if (cur->bc_flags & XFS_BTREE_LONG_PTRS) {
+				xfs_fsblock_t	fsb = be64_to_cpu(ptr->l);
+
+				__entry->agno = XFS_FSB_TO_AGNO(cur->bc_mp,
+								fsb);
+				__entry->agbno = XFS_FSB_TO_AGBNO(cur->bc_mp,
+								fsb);
+			} else {
+				__entry->agbno = be32_to_cpu(ptr->s);
+			}
+		} else {
+			__entry->agbno = NULLAGBLOCK;
+		}
+	),
+	TP_printk("dev %d:%d btree %s agno 0x%x ino 0x%llx agbno 0x%x error %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __entry->agno,
+		  __entry->ino,
+		  __entry->agbno,
+		  __entry->error)
+);
+
 TRACE_EVENT(xfs_btree_free_block,
 	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_buf *bp),
 	TP_ARGS(cur, bp),
@@ -2885,7 +2932,6 @@ DEFINE_EVENT(xfs_rmapbt_class, name, \
 DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_defer);
 DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_deferred);
 
-DEFINE_BUSY_EVENT(xfs_rmapbt_alloc_block);
 DEFINE_RMAPBT_EVENT(xfs_rmap_update);
 DEFINE_RMAPBT_EVENT(xfs_rmap_insert);
 DEFINE_RMAPBT_EVENT(xfs_rmap_delete);
@@ -3243,7 +3289,6 @@ DEFINE_EVENT(xfs_refcount_triple_extent_class, name, \
 	TP_ARGS(mp, agno, i1, i2, i3))
 
 /* refcount btree tracepoints */
-DEFINE_BUSY_EVENT(xfs_refcountbt_alloc_block);
 DEFINE_AG_BTREE_LOOKUP_EVENT(xfs_refcount_lookup);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_get);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_update);

