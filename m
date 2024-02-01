Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7B32B9B3
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816396; cv=none; b=jPWD2G+pHRY6FMUkfnaixzsmMfJiaOuoblGDwMU/EO0Pqy68qy2tJSeAtljbzg/UB9OscLxO+LttqaqK9GsK+tqIA5veyUJi6suSZMCAfp+GuZ93MjOLvI84jtdxUEnwDml7lHHNDs9U4x/MlemKq21vmHPE1Bah9rZoypPrFrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816396; c=relaxed/simple;
	bh=9SvK2lfNDvNUV80F6lq+P5qmUVpM+RYXbUJKhlOhokA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AuEP4jPdyziH1BJOfoChN1vjYjCi7xFBQZdnLGSX5JcZjJRg4e4yOYxIF7wJNdbQczqQ5n/0qCESGMYHp9xFJ2+gdxNHULgniNO7l1KYo3h5EPI25bKnq3ZW90VpdL51AwNNCaGXARqVNjCczwRz8YGBuaKj0eWUSnwhoAzWeoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMXjrnU3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMXjrnU3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F830C433F1;
	Thu,  1 Feb 2024 19:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816396;
	bh=9SvK2lfNDvNUV80F6lq+P5qmUVpM+RYXbUJKhlOhokA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WMXjrnU3ECGgzrGDV6PlK9Aihch35lx0jqMoMdfXtQ6A+sLpgnE9KMraVIDcFaL6y
	 D43aM5IXjwusVBPpGajz0R3I3Ob+UV2WrUhlA5gsrNwyecRKKd30xwOBwML+3G0tVw
	 UDBv4urE7naT3t0KkoPEzTGvDOOi68v37KLpDjv2KRA/l8SpV4PZ/9j8MgVWwaXTxe
	 GaK//ExjH+wh/541QEllU5+m3N9l7zpoNEE0J6VQPZP2eIgqwHL10KUoAgbOXLn4t9
	 zIeUcseZG04+MiBYop0OzZrHRobgv171wuk4RWTZkc7rxPi15pfjpRQUBIin+beAjU
	 oiv8Vru+HrcjQ==
Date: Thu, 01 Feb 2024 11:39:55 -0800
Subject: [PATCH 01/23] xfs: consolidate btree block freeing tracepoints
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681333951.1604831.13726435982237623887.stgit@frogsfrogsfrogs>
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

Don't waste memory on extra per-btree block freeing tracepoints when we
can do it from the generic btree code.

With this patch applied, two tracepoints are collapsed into one
tracepoint, with the following effects on objdump -hx xfs.ko output:

Before:

 10 __tracepoints_ptrs 00000b3c  0000000000000000  0000000000000000  00140eb0  2**2
 14 __tracepoints_strings 00005453  0000000000000000  0000000000000000  00168540  2**5
 29 __tracepoints 00010d90  0000000000000000  0000000000000000  0023f5e0  2**5

After:

 10 __tracepoints_ptrs 00000b38  0000000000000000  0000000000000000  001412f0  2**2
 14 __tracepoints_strings 00005433  0000000000000000  0000000000000000  001689a0  2**5
 29 __tracepoints 00010d30  0000000000000000  0000000000000000  0023fe00  2**5

Column 3 is the section size in bytes; removing these two tracepoints
reduces the size of the ELF segments by 132 bytes.

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
index b78c8be57b2d4..383b8ff59a81a 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -2496,6 +2496,36 @@ DEFINE_EVENT(xfs_btree_cur_class, name, \
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
 
@@ -2859,7 +2889,6 @@ DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_defer);
 DEFINE_RMAP_DEFERRED_EVENT(xfs_rmap_deferred);
 
 DEFINE_BUSY_EVENT(xfs_rmapbt_alloc_block);
-DEFINE_BUSY_EVENT(xfs_rmapbt_free_block);
 DEFINE_RMAPBT_EVENT(xfs_rmap_update);
 DEFINE_RMAPBT_EVENT(xfs_rmap_insert);
 DEFINE_RMAPBT_EVENT(xfs_rmap_delete);
@@ -3218,7 +3247,6 @@ DEFINE_EVENT(xfs_refcount_triple_extent_class, name, \
 
 /* refcount btree tracepoints */
 DEFINE_BUSY_EVENT(xfs_refcountbt_alloc_block);
-DEFINE_BUSY_EVENT(xfs_refcountbt_free_block);
 DEFINE_AG_BTREE_LOOKUP_EVENT(xfs_refcount_lookup);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_get);
 DEFINE_REFCOUNT_EXTENT_EVENT(xfs_refcount_update);

