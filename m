Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC43B671
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LxPKBX35"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17CDCC433C7;
	Sun, 31 Dec 2023 20:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704053708;
	bh=oYmn+hy5F/ViDytNdl7QxqrWDXlEBKyLl0w7Ykbx6TU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LxPKBX35tEAeMqMKKhQBgu37BwjSPnD9Y5SVqDMkN0EKTRy8gGi6ZT5rxg9PaV90Z
	 JlsA6DmWNoPri9knTehTYjlrvuINJrPBPkYNGRH3lVV+wo+wzMJPeo8lyvKlyw/uGB
	 W9ykfoLg+n+7QNb6Awj00PcFYU5k+Ot5ZN0sgzXA0oeHdZ17DRJsOu1AApxB01f62W
	 5+vvB8YoGbCBxzra702wQAgA5uUD2Bk6rXBMA5cSocNS7Ltdzek5vygNi/RCl0cDHi
	 NdbqWhELXKzPgEV7JQwWEDoLXy/VeR/Gy3wrCCJOudwuzt4qzyK56lIKZENRGRCgFL
	 kSm8zpoRzlKiQ==
Date: Sun, 31 Dec 2023 12:15:07 -0800
Subject: [PATCH 6/9] xfs: consolidate btree block freeing tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, willy@infradead.org
Message-ID: <170404829675.1748854.18135934618780501542.stgit@frogsfrogsfrogs>
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

Don't waste tracepoint segment memory on per-btree block freeing
tracepoints when we can do it from the generic btree code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c          |    2 ++
 fs/xfs/libxfs/xfs_refcount_btree.c |    2 --
 fs/xfs/libxfs/xfs_rmap_btree.c     |    2 --
 fs/xfs/xfs_trace.h                 |   32 ++++++++++++++++++++++++++++++--
 4 files changed, 32 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 28ba528086888..3e966182b90a9 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -414,6 +414,8 @@ xfs_btree_free_block(
 {
 	int			error;
 
+	trace_xfs_btree_free_block(cur, bp);
+
 	error = cur->bc_ops->free_block(cur, bp);
 	if (!error) {
 		xfs_trans_binval(cur->bc_tp, bp);
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 0d80bd99147cc..a346e49981ac3 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -107,8 +107,6 @@ xfs_refcountbt_free_block(
 	struct xfs_agf		*agf = agbp->b_addr;
 	xfs_fsblock_t		fsbno = XFS_DADDR_TO_FSB(mp, xfs_buf_daddr(bp));
 
-	trace_xfs_refcountbt_free_block(cur->bc_mp, cur->bc_ag.pag->pag_agno,
-			XFS_FSB_TO_AGBNO(cur->bc_mp, fsbno), 1);
 	be32_add_cpu(&agf->agf_refcount_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_REFCOUNT_BLOCKS);
 	return xfs_free_extent_later(cur->bc_tp, fsbno, 1,
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 6c81b20e97d21..0dc086bc528f7 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -125,8 +125,6 @@ xfs_rmapbt_free_block(
 	int			error;
 
 	bno = xfs_daddr_to_agbno(cur->bc_mp, xfs_buf_daddr(bp));
-	trace_xfs_rmapbt_free_block(cur->bc_mp, pag->pag_agno,
-			bno, 1);
 	be32_add_cpu(&agf->agf_rmap_blocks, -1);
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_RMAP_BLOCKS);
 	error = xfs_alloc_put_freelist(pag, cur->bc_tp, agbp, NULL, bno, 1);
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 7d075e426c5d0..5076770d9b000 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2493,6 +2493,36 @@ DEFINE_EVENT(xfs_btree_cur_class, name, \
 DEFINE_BTREE_CUR_EVENT(xfs_btree_updkeys);
 DEFINE_BTREE_CUR_EVENT(xfs_btree_overlapped_query_range);
 
+TRACE_EVENT(xfs_btree_free_block,
+	TP_PROTO(struct xfs_btree_cur *cur, struct xfs_buf *bp),
+	TP_ARGS(cur, bp),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_agnumber_t, agno)
+		__field(xfs_ino_t, ino)
+		__field(xfs_btnum_t, btnum)
+		__field(xfs_agblock_t, agbno)
+	),
+	TP_fast_assign(
+		__entry->dev = cur->bc_mp->m_super->s_dev;
+		__entry->agno = xfs_daddr_to_agno(cur->bc_mp,
+							xfs_buf_daddr(bp));
+		if (cur->bc_flags & XFS_BTREE_ROOT_IN_INODE)
+			__entry->ino = cur->bc_ino.ip->i_ino;
+		else
+			__entry->ino = 0;
+		__entry->btnum = cur->bc_btnum;
+		__entry->agbno = xfs_daddr_to_agbno(cur->bc_mp,
+							xfs_buf_daddr(bp));
+	),
+	TP_printk("dev %d:%d btree %s agno 0x%x ino 0x%llx agbno 0x%x",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __print_symbolic(__entry->btnum, XFS_BTNUM_STRINGS),
+		  __entry->agno,
+		  __entry->ino,
+		  __entry->agbno)
+);
+
 /* deferred ops */
 struct xfs_defer_pending;
 
@@ -2856,7 +2886,6 @@ DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_defer);
 DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_deferred);
 
 DEFINE_BUSY_EVENT(xfs_rmapbt_alloc_block);
-DEFINE_BUSY_EVENT(xfs_rmapbt_free_block);
 DEFINE_RMAPBT_EVENT(xfs_rmap_update);
 DEFINE_RMAPBT_EVENT(xfs_rmap_insert);
 DEFINE_RMAPBT_EVENT(xfs_rmap_delete);
@@ -3215,7 +3244,6 @@ DEFINE_EVENT(xfs_refcount_triple_extent_class, name, \
 
 /* refcount btree tracepoints */
 DEFINE_BUSY_EVENT(xfs_refcountbt_alloc_block);
-DEFINE_BUSY_EVENT(xfs_refcountbt_free_block);
 DEFINE_AG_BTREE_LOOKUP_EVENT(xfs_refcount_lookup);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_get);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_update);

