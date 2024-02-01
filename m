Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D5D8526E
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816412; cv=none; b=KXo6UB3+GB79Jf8t+jFH/Dtz8QHXLGsH61i0eFV9y6/nMZFaWgwpKKxeeDV4vJFVIUMcs2rzBIPjruN2iWIqt16v5+FNSjM/KJPe32GBVRr3rFQuO51N8/fFTEPJW+ajlgMa59EzhP/utLvtb6WbPZbqRrThH7e/YPFEQqTgWBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816412; c=relaxed/simple;
	bh=OXKaGWap8N2fthbT1UuR2zuhfWVsyi0ixByB/ka5E80=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=niAg2zGwdDXqRzVQg61vBKNvnPlJtEzn8q537Z6fjacYhIN7dscaTQN3loZR5VtjZcx+zQFF8tWhXUbbnrkfwCy04CDbEIh63JRDsavG5xJ2su0RS24gxK+c/drgEGdUjuO6cYCGhsIrpdJk4VL/VfE+AaBtr7VutAAJrM5GOTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C+wUAb8l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C+wUAb8l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DE6C433C7;
	Thu,  1 Feb 2024 19:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816412;
	bh=OXKaGWap8N2fthbT1UuR2zuhfWVsyi0ixByB/ka5E80=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C+wUAb8lmRmBRhc2NW6BgAKZLFQ5CTy9jutJZaBG/UZCZFI/UNB5OKKa2f/cd9Cm7
	 N0PPvwRQWr1wTVGOzc5oQnYSulD3N8hoGoWWK9Dw5m6A7hT4LoqWz/mklf8gbyy5g0
	 q6JHhXXzyoxC4R/yhLhDJe1Gl/GKOotcBIsQi1XpiYT5dU5F1iHcgtx8ry6yclPI75
	 u6kwiBJuNuP1xPH2rejzN/7oipGG2KEKHI+tmYVLiZmfIzWho0n2naocZFJhAG5fZn
	 mIf7foZ09KlvAuIJDw9FLox6hMv7tA8E2sW0NvmiGWi5O+SMNK+tFZRWEqjEAtHTkE
	 FQMuosGoROu5g==
Date: Thu, 01 Feb 2024 11:40:11 -0800
Subject: [PATCH 02/23] xfs: consolidate btree block allocation tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681333967.1604831.8930919341410005794.stgit@frogsfrogsfrogs>
In-Reply-To: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
References: <170681333879.1604831.1274408743361215078.stgit@frogsfrogsfrogs>
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

With this patch applied, two tracepoints are collapsed into one
tracepoint, with the following effects on objdump -hx xfs.ko output:

Before:

 10 __tracepoints_ptrs 00000b38  0000000000000000  0000000000000000  001412f0  2**2
 14 __tracepoints_strings 00005433  0000000000000000  0000000000000000  001689a0  2**5
 29 __tracepoints 00010d30  0000000000000000  0000000000000000  0023fe00  2**5

After:

 10 __tracepoints_ptrs 00000b34  0000000000000000  0000000000000000  001417b0  2**2
 14 __tracepoints_strings 00005413  0000000000000000  0000000000000000  00168e80  2**5
 29 __tracepoints 00010cd0  0000000000000000  0000000000000000  00240760  2**5

Column 3 is the section size in bytes; removing these two tracepoints
reduces the size of the ELF segments by 132 bytes.

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
index 383b8ff59a81a..b76a3551d8716 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2496,6 +2496,53 @@ DEFINE_EVENT(xfs_btree_cur_class, name, \
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
@@ -2888,7 +2935,6 @@ DEFINE_EVENT(xfs_rmapbt_class, name, \
 DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_defer);
 DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_deferred);
 
-DEFINE_BUSY_EVENT(xfs_rmapbt_alloc_block);
 DEFINE_RMAPBT_EVENT(xfs_rmap_update);
 DEFINE_RMAPBT_EVENT(xfs_rmap_insert);
 DEFINE_RMAPBT_EVENT(xfs_rmap_delete);
@@ -3246,7 +3292,6 @@ DEFINE_EVENT(xfs_refcount_triple_extent_class, name, \
 	TP_ARGS(mp, agno, i1, i2, i3))
 
 /* refcount btree tracepoints */
-DEFINE_BUSY_EVENT(xfs_refcountbt_alloc_block);
 DEFINE_AG_BTREE_LOOKUP_EVENT(xfs_refcount_lookup);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_get);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_update);

