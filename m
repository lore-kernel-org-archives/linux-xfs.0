Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F8D85289
	for <linux-xfs@vger.kernel.org>; Thu,  1 Feb 2024 19:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706816990; cv=none; b=ujJQtDvQHvenrj2TeTNylNKUgb4roPhQoW9XfPzFvQZUrlzjhGVPpTR5W8hHpWYCC5mP3loiZtyEG46SgKxg6xdojgC6RqBhLnQ1GtPyz1bvMG+zlsvFdgm9bKku/BPy9EgI6pY+gIKOJtbKAHEn2TbbBHwz3mrc9156YO99iY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706816990; c=relaxed/simple;
	bh=qOuaPcnkqS/DVfQHcmsn1jdNj0KFPoS9PA8Q4H6sHO4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GMzmv0ih0hLr5ZEZa0rNsw0u/kxrPRE4nhnIsJ93oiq/sF8fn9PUYWXHda5CCVXgkUbSdF3ucFq/b2I/R/SQE6AFw7mQuQpj8zc34DhKqJuULFFbtmv1orbQK9+x2O38qE4oy1OM3FGI32f5o5dxp4wpak3vk+DZOPplwxaM6Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u17nPGQc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u17nPGQc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2E1C433C7;
	Thu,  1 Feb 2024 19:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706816990;
	bh=qOuaPcnkqS/DVfQHcmsn1jdNj0KFPoS9PA8Q4H6sHO4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=u17nPGQcDixAUQJVku9VjovgO3sKAldoRF5aS+R5sEPINbecgAiSzqklTaR0K3dA2
	 g++UtIxtstGcJlXAKTQTW0Zdk1Ckrwab4dHLGjzzi+fV/tuorm2ym5juDDSRV4IOb2
	 20swkF4PjYITiWbJ4fVl+x7bs/aKjlqgQIciX4mQnDggNETYg3fz4roxdMRqPmqsLD
	 AOvFKnsUvO8X7C4gVC6Fawnqyn+wcvCqby57Rr1tbhcN6zYhjcWRYy9UWROGEtMlgS
	 m19LS4xrk4Ehe6GqU09cMR5qw9J1GCp8V2PL8Mph5E2hzlYdB6mBjzqXBJJobrCNnr
	 cw6QeiS1ySqqQ==
Date: Thu, 01 Feb 2024 11:49:50 -0800
Subject: [PATCH 16/27] xfs: split the agf_roots and agf_levels arrays
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <170681335044.1605438.15493685442671084965.stgit@frogsfrogsfrogs>
In-Reply-To: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
References: <170681334718.1605438.17032954797722239513.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Using arrays of largely unrelated fields that use the btree number
as index is not very robust.  Split the arrays into three separate
fields instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_ag.c          |   13 +++++-----
 fs/xfs/libxfs/xfs_ag.h          |    8 ++++--
 fs/xfs/libxfs/xfs_alloc.c       |   49 ++++++++++++++-----------------------
 fs/xfs/libxfs/xfs_alloc_btree.c |   52 ++++++++++++++++++++++++++-------------
 fs/xfs/libxfs/xfs_format.h      |   21 ++++++++--------
 fs/xfs/libxfs/xfs_rmap_btree.c  |   17 ++++++-------
 fs/xfs/scrub/agheader.c         |   12 +++++----
 fs/xfs/scrub/agheader_repair.c  |   30 ++++++++---------------
 fs/xfs/scrub/alloc_repair.c     |   18 ++++++--------
 fs/xfs/xfs_trace.h              |   10 +++-----
 10 files changed, 111 insertions(+), 119 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
index 02d8c1caa26a8..5c35babc30de7 100644
--- a/fs/xfs/libxfs/xfs_ag.c
+++ b/fs/xfs/libxfs/xfs_ag.c
@@ -669,14 +669,13 @@ xfs_agfblock_init(
 	agf->agf_versionnum = cpu_to_be32(XFS_AGF_VERSION);
 	agf->agf_seqno = cpu_to_be32(id->agno);
 	agf->agf_length = cpu_to_be32(id->agsize);
-	agf->agf_roots[XFS_BTNUM_BNOi] = cpu_to_be32(XFS_BNO_BLOCK(mp));
-	agf->agf_roots[XFS_BTNUM_CNTi] = cpu_to_be32(XFS_CNT_BLOCK(mp));
-	agf->agf_levels[XFS_BTNUM_BNOi] = cpu_to_be32(1);
-	agf->agf_levels[XFS_BTNUM_CNTi] = cpu_to_be32(1);
+	agf->agf_bno_root = cpu_to_be32(XFS_BNO_BLOCK(mp));
+	agf->agf_cnt_root = cpu_to_be32(XFS_CNT_BLOCK(mp));
+	agf->agf_bno_level = cpu_to_be32(1);
+	agf->agf_cnt_level = cpu_to_be32(1);
 	if (xfs_has_rmapbt(mp)) {
-		agf->agf_roots[XFS_BTNUM_RMAPi] =
-					cpu_to_be32(XFS_RMAP_BLOCK(mp));
-		agf->agf_levels[XFS_BTNUM_RMAPi] = cpu_to_be32(1);
+		agf->agf_rmap_root = cpu_to_be32(XFS_RMAP_BLOCK(mp));
+		agf->agf_rmap_level = cpu_to_be32(1);
 		agf->agf_rmap_blocks = cpu_to_be32(1);
 	}
 
diff --git a/fs/xfs/libxfs/xfs_ag.h b/fs/xfs/libxfs/xfs_ag.h
index 77c0fa2bb510c..19eddba098941 100644
--- a/fs/xfs/libxfs/xfs_ag.h
+++ b/fs/xfs/libxfs/xfs_ag.h
@@ -36,8 +36,9 @@ struct xfs_perag {
 	atomic_t	pag_active_ref;	/* active reference count */
 	wait_queue_head_t pag_active_wq;/* woken active_ref falls to zero */
 	unsigned long	pag_opstate;
-	uint8_t		pagf_levels[XFS_BTNUM_AGF];
-					/* # of levels in bno & cnt btree */
+	uint8_t		pagf_bno_level;	/* # of levels in bno btree */
+	uint8_t		pagf_cnt_level;	/* # of levels in cnt btree */
+	uint8_t		pagf_rmap_level;/* # of levels in rmap btree */
 	uint32_t	pagf_flcount;	/* count of blocks in freelist */
 	xfs_extlen_t	pagf_freeblks;	/* total free blocks */
 	xfs_extlen_t	pagf_longest;	/* longest free space */
@@ -86,7 +87,8 @@ struct xfs_perag {
 	 * Alternate btree heights so that online repair won't trip the write
 	 * verifiers while rebuilding the AG btrees.
 	 */
-	uint8_t		pagf_repair_levels[XFS_BTNUM_AGF];
+	uint8_t		pagf_repair_bno_level;
+	uint8_t		pagf_repair_cnt_level;
 	uint8_t		pagf_repair_refcount_level;
 #endif
 
diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 91553a54dc30a..7300dc2195896 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -2335,8 +2335,9 @@ xfs_alloc_min_freelist(
 	struct xfs_perag	*pag)
 {
 	/* AG btrees have at least 1 level. */
-	static const uint8_t	fake_levels[XFS_BTNUM_AGF] = {1, 1, 1};
-	const uint8_t		*levels = pag ? pag->pagf_levels : fake_levels;
+	const unsigned int	bno_level = pag ? pag->pagf_bno_level : 1;
+	const unsigned int	cnt_level = pag ? pag->pagf_cnt_level : 1;
+	const unsigned int	rmap_level = pag ? pag->pagf_rmap_level : 1;
 	unsigned int		min_free;
 
 	ASSERT(mp->m_alloc_maxlevels > 0);
@@ -2363,16 +2364,12 @@ xfs_alloc_min_freelist(
 	 */
 
 	/* space needed by-bno freespace btree */
-	min_free = min_t(unsigned int, levels[XFS_BTNUM_BNOi] + 1,
-				       mp->m_alloc_maxlevels) * 2 - 2;
+	min_free = min(bno_level + 1, mp->m_alloc_maxlevels) * 2 - 2;
 	/* space needed by-size freespace btree */
-	min_free += min_t(unsigned int, levels[XFS_BTNUM_CNTi] + 1,
-				       mp->m_alloc_maxlevels) * 2 - 2;
+	min_free += min(cnt_level + 1, mp->m_alloc_maxlevels) * 2 - 2;
 	/* space needed reverse mapping used space btree */
 	if (xfs_has_rmapbt(mp))
-		min_free += min_t(unsigned int, levels[XFS_BTNUM_RMAPi] + 1,
-						mp->m_rmap_maxlevels) * 2 - 2;
-
+		min_free += min(rmap_level + 1, mp->m_rmap_maxlevels) * 2 - 2;
 	return min_free;
 }
 
@@ -3056,8 +3053,8 @@ xfs_alloc_log_agf(
 		offsetof(xfs_agf_t, agf_versionnum),
 		offsetof(xfs_agf_t, agf_seqno),
 		offsetof(xfs_agf_t, agf_length),
-		offsetof(xfs_agf_t, agf_roots[0]),
-		offsetof(xfs_agf_t, agf_levels[0]),
+		offsetof(xfs_agf_t, agf_bno_root),   /* also cnt/rmap root */
+		offsetof(xfs_agf_t, agf_bno_level),  /* also cnt/rmap levels */
 		offsetof(xfs_agf_t, agf_flfirst),
 		offsetof(xfs_agf_t, agf_fllast),
 		offsetof(xfs_agf_t, agf_flcount),
@@ -3236,12 +3233,10 @@ xfs_agf_verify(
 	    be32_to_cpu(agf->agf_freeblks) > agf_length)
 		return __this_address;
 
-	if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) < 1 ||
-	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) < 1 ||
-	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) >
-						mp->m_alloc_maxlevels ||
-	    be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]) >
-						mp->m_alloc_maxlevels)
+	if (be32_to_cpu(agf->agf_bno_level) < 1 ||
+	    be32_to_cpu(agf->agf_cnt_level) < 1 ||
+	    be32_to_cpu(agf->agf_bno_level) > mp->m_alloc_maxlevels ||
+	    be32_to_cpu(agf->agf_cnt_level) > mp->m_alloc_maxlevels)
 		return __this_address;
 
 	if (xfs_has_lazysbcount(mp) &&
@@ -3252,9 +3247,8 @@ xfs_agf_verify(
 		if (be32_to_cpu(agf->agf_rmap_blocks) > agf_length)
 			return __this_address;
 
-		if (be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) < 1 ||
-		    be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]) >
-							mp->m_rmap_maxlevels)
+		if (be32_to_cpu(agf->agf_rmap_level) < 1 ||
+		    be32_to_cpu(agf->agf_rmap_level) > mp->m_rmap_maxlevels)
 			return __this_address;
 	}
 
@@ -3380,12 +3374,9 @@ xfs_alloc_read_agf(
 		pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
 		pag->pagf_flcount = be32_to_cpu(agf->agf_flcount);
 		pag->pagf_longest = be32_to_cpu(agf->agf_longest);
-		pag->pagf_levels[XFS_BTNUM_BNOi] =
-			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
-		pag->pagf_levels[XFS_BTNUM_CNTi] =
-			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
-		pag->pagf_levels[XFS_BTNUM_RMAPi] =
-			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
+		pag->pagf_bno_level = be32_to_cpu(agf->agf_bno_level);
+		pag->pagf_cnt_level = be32_to_cpu(agf->agf_cnt_level);
+		pag->pagf_rmap_level = be32_to_cpu(agf->agf_rmap_level);
 		pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
 		if (xfs_agfl_needs_reset(pag->pag_mount, agf))
 			set_bit(XFS_AGSTATE_AGFL_NEEDS_RESET, &pag->pag_opstate);
@@ -3414,10 +3405,8 @@ xfs_alloc_read_agf(
 		ASSERT(pag->pagf_btreeblks == be32_to_cpu(agf->agf_btreeblks));
 		ASSERT(pag->pagf_flcount == be32_to_cpu(agf->agf_flcount));
 		ASSERT(pag->pagf_longest == be32_to_cpu(agf->agf_longest));
-		ASSERT(pag->pagf_levels[XFS_BTNUM_BNOi] ==
-		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]));
-		ASSERT(pag->pagf_levels[XFS_BTNUM_CNTi] ==
-		       be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]));
+		ASSERT(pag->pagf_bno_level == be32_to_cpu(agf->agf_bno_level));
+		ASSERT(pag->pagf_cnt_level == be32_to_cpu(agf->agf_cnt_level));
 	}
 #endif
 	if (agfbpp)
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 99859803bb0b8..6c09573a98a9a 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -38,13 +38,18 @@ xfs_allocbt_set_root(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	int			btnum = cur->bc_btnum;
 
 	ASSERT(ptr->s != 0);
 
-	agf->agf_roots[btnum] = ptr->s;
-	be32_add_cpu(&agf->agf_levels[btnum], inc);
-	cur->bc_ag.pag->pagf_levels[btnum] += inc;
+	if (cur->bc_btnum == XFS_BTNUM_BNO) {
+		agf->agf_bno_root = ptr->s;
+		be32_add_cpu(&agf->agf_bno_level, inc);
+		cur->bc_ag.pag->pagf_bno_level += inc;
+	} else {
+		agf->agf_cnt_root = ptr->s;
+		be32_add_cpu(&agf->agf_cnt_level, inc);
+		cur->bc_ag.pag->pagf_cnt_level += inc;
+	}
 
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
 }
@@ -226,7 +231,10 @@ xfs_allocbt_init_ptr_from_cur(
 
 	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 
-	ptr->s = agf->agf_roots[cur->bc_btnum];
+	if (cur->bc_btnum == XFS_BTNUM_BNO)
+		ptr->s = agf->agf_bno_root;
+	else
+		ptr->s = agf->agf_cnt_root;
 }
 
 STATIC int64_t
@@ -299,7 +307,6 @@ xfs_allocbt_verify(
 	struct xfs_perag	*pag = bp->b_pag;
 	xfs_failaddr_t		fa;
 	unsigned int		level;
-	xfs_btnum_t		btnum = XFS_BTNUM_BNOi;
 
 	if (!xfs_verify_magic(bp, block->bb_magic))
 		return __this_address;
@@ -320,21 +327,27 @@ xfs_allocbt_verify(
 	 * against.
 	 */
 	level = be16_to_cpu(block->bb_level);
-	if (bp->b_ops->magic[0] == cpu_to_be32(XFS_ABTC_MAGIC))
-		btnum = XFS_BTNUM_CNTi;
 	if (pag && xfs_perag_initialised_agf(pag)) {
-		unsigned int	maxlevel = pag->pagf_levels[btnum];
+		unsigned int	maxlevel, repair_maxlevel = 0;
 
-#ifdef CONFIG_XFS_ONLINE_REPAIR
 		/*
 		 * Online repair could be rewriting the free space btrees, so
 		 * we'll validate against the larger of either tree while this
 		 * is going on.
 		 */
-		maxlevel = max_t(unsigned int, maxlevel,
-				 pag->pagf_repair_levels[btnum]);
+		if (bp->b_ops->magic[0] == cpu_to_be32(XFS_ABTC_MAGIC)) {
+			maxlevel = pag->pagf_cnt_level;
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+			repair_maxlevel = pag->pagf_repair_cnt_level;
 #endif
-		if (level >= maxlevel)
+		} else {
+			maxlevel = pag->pagf_bno_level;
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+			repair_maxlevel = pag->pagf_repair_bno_level;
+#endif
+		}
+
+		if (level >= max(maxlevel, repair_maxlevel))
 			return __this_address;
 	} else if (level >= mp->m_alloc_maxlevels)
 		return __this_address;
@@ -542,8 +555,8 @@ xfs_allocbt_init_cursor(
 		struct xfs_agf		*agf = agbp->b_addr;
 
 		cur->bc_nlevels = (btnum == XFS_BTNUM_BNO) ?
-			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]) :
-			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
+			be32_to_cpu(agf->agf_bno_level) :
+			be32_to_cpu(agf->agf_cnt_level);
 	}
 	return cur;
 }
@@ -563,8 +576,13 @@ xfs_allocbt_commit_staged_btree(
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
 
-	agf->agf_roots[cur->bc_btnum] = cpu_to_be32(afake->af_root);
-	agf->agf_levels[cur->bc_btnum] = cpu_to_be32(afake->af_levels);
+	if (cur->bc_btnum == XFS_BTNUM_BNO) {
+		agf->agf_bno_root = cpu_to_be32(afake->af_root);
+		agf->agf_bno_level = cpu_to_be32(afake->af_levels);
+	} else {
+		agf->agf_cnt_root = cpu_to_be32(afake->af_root);
+		agf->agf_cnt_level = cpu_to_be32(afake->af_levels);
+	}
 	xfs_alloc_log_agf(tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
 
 	xfs_btree_commit_afakeroot(cur, tp, agbp);
diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
index 382ab1e71c0b6..2b2f9050fbfbb 100644
--- a/fs/xfs/libxfs/xfs_format.h
+++ b/fs/xfs/libxfs/xfs_format.h
@@ -477,15 +477,9 @@ xfs_is_quota_inode(struct xfs_sb *sbp, xfs_ino_t ino)
 #define	XFS_AGI_GOOD_VERSION(v)	((v) == XFS_AGI_VERSION)
 
 /*
- * Btree number 0 is bno, 1 is cnt, 2 is rmap. This value gives the size of the
- * arrays below.
- */
-#define	XFS_BTNUM_AGF	((int)XFS_BTNUM_RMAPi + 1)
-
-/*
- * The second word of agf_levels in the first a.g. overlaps the EFS
- * superblock's magic number.  Since the magic numbers valid for EFS
- * are > 64k, our value cannot be confused for an EFS superblock's.
+ * agf_cnt_level in the first AGF overlaps the EFS superblock's magic number.
+ * Since the magic numbers valid for EFS are > 64k, our value cannot be confused
+ * for an EFS superblock.
  */
 
 typedef struct xfs_agf {
@@ -499,8 +493,13 @@ typedef struct xfs_agf {
 	/*
 	 * Freespace and rmap information
 	 */
-	__be32		agf_roots[XFS_BTNUM_AGF];	/* root blocks */
-	__be32		agf_levels[XFS_BTNUM_AGF];	/* btree levels */
+	__be32		agf_bno_root;	/* bnobt root block */
+	__be32		agf_cnt_root;	/* cntbt root block */
+	__be32		agf_rmap_root;	/* rmapbt root block */
+
+	__be32		agf_bno_level;	/* bnobt btree levels */
+	__be32		agf_cnt_level;	/* cntbt btree levels */
+	__be32		agf_rmap_level;	/* rmapbt btree levels */
 
 	__be32		agf_flfirst;	/* first freelist block's index */
 	__be32		agf_fllast;	/* last freelist block's index */
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index b0da31f49ca8c..e050d7342d6c9 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -65,13 +65,12 @@ xfs_rmapbt_set_root(
 {
 	struct xfs_buf		*agbp = cur->bc_ag.agbp;
 	struct xfs_agf		*agf = agbp->b_addr;
-	int			btnum = cur->bc_btnum;
 
 	ASSERT(ptr->s != 0);
 
-	agf->agf_roots[btnum] = ptr->s;
-	be32_add_cpu(&agf->agf_levels[btnum], inc);
-	cur->bc_ag.pag->pagf_levels[btnum] += inc;
+	agf->agf_rmap_root = ptr->s;
+	be32_add_cpu(&agf->agf_rmap_level, inc);
+	cur->bc_ag.pag->pagf_rmap_level += inc;
 
 	xfs_alloc_log_agf(cur->bc_tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS);
 }
@@ -222,7 +221,7 @@ xfs_rmapbt_init_ptr_from_cur(
 
 	ASSERT(cur->bc_ag.pag->pag_agno == be32_to_cpu(agf->agf_seqno));
 
-	ptr->s = agf->agf_roots[cur->bc_btnum];
+	ptr->s = agf->agf_rmap_root;
 }
 
 /*
@@ -342,7 +341,7 @@ xfs_rmapbt_verify(
 
 	level = be16_to_cpu(block->bb_level);
 	if (pag && xfs_perag_initialised_agf(pag)) {
-		if (level >= pag->pagf_levels[XFS_BTNUM_RMAPi])
+		if (level >= pag->pagf_rmap_level)
 			return __this_address;
 	} else if (level >= mp->m_rmap_maxlevels)
 		return __this_address;
@@ -523,7 +522,7 @@ xfs_rmapbt_init_cursor(
 	if (agbp) {
 		struct xfs_agf		*agf = agbp->b_addr;
 
-		cur->bc_nlevels = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
+		cur->bc_nlevels = be32_to_cpu(agf->agf_rmap_level);
 	}
 	return cur;
 }
@@ -543,8 +542,8 @@ xfs_rmapbt_commit_staged_btree(
 
 	ASSERT(cur->bc_flags & XFS_BTREE_STAGING);
 
-	agf->agf_roots[cur->bc_btnum] = cpu_to_be32(afake->af_root);
-	agf->agf_levels[cur->bc_btnum] = cpu_to_be32(afake->af_levels);
+	agf->agf_rmap_root = cpu_to_be32(afake->af_root);
+	agf->agf_rmap_level = cpu_to_be32(afake->af_levels);
 	agf->agf_rmap_blocks = cpu_to_be32(afake->af_blocks);
 	xfs_alloc_log_agf(tp, agbp, XFS_AGF_ROOTS | XFS_AGF_LEVELS |
 				    XFS_AGF_RMAP_BLOCKS);
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 6c6e5eba42c8b..e954f07679dd7 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -556,28 +556,28 @@ xchk_agf(
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 	/* Check the AGF btree roots and levels */
-	agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]);
+	agbno = be32_to_cpu(agf->agf_bno_root);
 	if (!xfs_verify_agbno(pag, agbno))
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
-	agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]);
+	agbno = be32_to_cpu(agf->agf_cnt_root);
 	if (!xfs_verify_agbno(pag, agbno))
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
-	level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]);
+	level = be32_to_cpu(agf->agf_bno_level);
 	if (level <= 0 || level > mp->m_alloc_maxlevels)
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
-	level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]);
+	level = be32_to_cpu(agf->agf_cnt_level);
 	if (level <= 0 || level > mp->m_alloc_maxlevels)
 		xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
 	if (xfs_has_rmapbt(mp)) {
-		agbno = be32_to_cpu(agf->agf_roots[XFS_BTNUM_RMAP]);
+		agbno = be32_to_cpu(agf->agf_rmap_root);
 		if (!xfs_verify_agbno(pag, agbno))
 			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 
-		level = be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAP]);
+		level = be32_to_cpu(agf->agf_rmap_level);
 		if (level <= 0 || level > mp->m_rmap_maxlevels)
 			xchk_block_set_corrupt(sc, sc->sa.agf_bp);
 	}
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 26bd1ff68f1be..e4dd4fe84c5f9 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -174,8 +174,7 @@ xrep_agf_find_btrees(
 	 * We relied on the rmapbt to reconstruct the AGF.  If we get a
 	 * different root then something's seriously wrong.
 	 */
-	if (fab[XREP_AGF_RMAPBT].root !=
-	    be32_to_cpu(old_agf->agf_roots[XFS_BTNUM_RMAPi]))
+	if (fab[XREP_AGF_RMAPBT].root != be32_to_cpu(old_agf->agf_rmap_root))
 		return -EFSCORRUPTED;
 
 	/* We must find the refcountbt root if that feature is enabled. */
@@ -224,20 +223,14 @@ xrep_agf_set_roots(
 	struct xfs_agf			*agf,
 	struct xrep_find_ag_btree	*fab)
 {
-	agf->agf_roots[XFS_BTNUM_BNOi] =
-			cpu_to_be32(fab[XREP_AGF_BNOBT].root);
-	agf->agf_levels[XFS_BTNUM_BNOi] =
-			cpu_to_be32(fab[XREP_AGF_BNOBT].height);
+	agf->agf_bno_root = cpu_to_be32(fab[XREP_AGF_BNOBT].root);
+	agf->agf_bno_level = cpu_to_be32(fab[XREP_AGF_BNOBT].height);
 
-	agf->agf_roots[XFS_BTNUM_CNTi] =
-			cpu_to_be32(fab[XREP_AGF_CNTBT].root);
-	agf->agf_levels[XFS_BTNUM_CNTi] =
-			cpu_to_be32(fab[XREP_AGF_CNTBT].height);
+	agf->agf_cnt_root = cpu_to_be32(fab[XREP_AGF_CNTBT].root);
+	agf->agf_cnt_level = cpu_to_be32(fab[XREP_AGF_CNTBT].height);
 
-	agf->agf_roots[XFS_BTNUM_RMAPi] =
-			cpu_to_be32(fab[XREP_AGF_RMAPBT].root);
-	agf->agf_levels[XFS_BTNUM_RMAPi] =
-			cpu_to_be32(fab[XREP_AGF_RMAPBT].height);
+	agf->agf_rmap_root = cpu_to_be32(fab[XREP_AGF_RMAPBT].root);
+	agf->agf_rmap_level = cpu_to_be32(fab[XREP_AGF_RMAPBT].height);
 
 	if (xfs_has_reflink(sc->mp)) {
 		agf->agf_refcount_root =
@@ -333,12 +326,9 @@ xrep_agf_commit_new(
 	pag->pagf_btreeblks = be32_to_cpu(agf->agf_btreeblks);
 	pag->pagf_freeblks = be32_to_cpu(agf->agf_freeblks);
 	pag->pagf_longest = be32_to_cpu(agf->agf_longest);
-	pag->pagf_levels[XFS_BTNUM_BNOi] =
-			be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNOi]);
-	pag->pagf_levels[XFS_BTNUM_CNTi] =
-			be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNTi]);
-	pag->pagf_levels[XFS_BTNUM_RMAPi] =
-			be32_to_cpu(agf->agf_levels[XFS_BTNUM_RMAPi]);
+	pag->pagf_bno_level = be32_to_cpu(agf->agf_bno_level);
+	pag->pagf_cnt_level = be32_to_cpu(agf->agf_cnt_level);
+	pag->pagf_rmap_level = be32_to_cpu(agf->agf_rmap_level);
 	pag->pagf_refcount_level = be32_to_cpu(agf->agf_refcount_level);
 	set_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
 
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 544c53d450ce2..0ef27aacbf25c 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -687,8 +687,8 @@ xrep_abt_reset_counters(
 	 * height values before re-initializing the perag info from the updated
 	 * AGF to capture all the new values.
 	 */
-	pag->pagf_repair_levels[XFS_BTNUM_BNOi] = pag->pagf_levels[XFS_BTNUM_BNOi];
-	pag->pagf_repair_levels[XFS_BTNUM_CNTi] = pag->pagf_levels[XFS_BTNUM_CNTi];
+	pag->pagf_repair_bno_level = pag->pagf_bno_level;
+	pag->pagf_repair_cnt_level = pag->pagf_cnt_level;
 
 	/* Reinitialize with the values we just logged. */
 	return xrep_reinit_pagf(sc);
@@ -768,10 +768,8 @@ xrep_abt_build_new_trees(
 	 * height so that we don't trip the verifiers when writing the new
 	 * btree blocks to disk.
 	 */
-	pag->pagf_repair_levels[XFS_BTNUM_BNOi] =
-					ra->new_bnobt.bload.btree_height;
-	pag->pagf_repair_levels[XFS_BTNUM_CNTi] =
-					ra->new_cntbt.bload.btree_height;
+	pag->pagf_repair_bno_level = ra->new_bnobt.bload.btree_height;
+	pag->pagf_repair_cnt_level = ra->new_cntbt.bload.btree_height;
 
 	/* Load the free space by length tree. */
 	ra->array_cur = XFARRAY_CURSOR_INIT;
@@ -810,8 +808,8 @@ xrep_abt_build_new_trees(
 	return xrep_roll_ag_trans(sc);
 
 err_levels:
-	pag->pagf_repair_levels[XFS_BTNUM_BNOi] = 0;
-	pag->pagf_repair_levels[XFS_BTNUM_CNTi] = 0;
+	pag->pagf_repair_bno_level = 0;
+	pag->pagf_repair_cnt_level = 0;
 err_cur:
 	xfs_btree_del_cursor(cnt_cur, error);
 	xfs_btree_del_cursor(bno_cur, error);
@@ -841,8 +839,8 @@ xrep_abt_remove_old_trees(
 	 * Now that we've zapped all the old allocbt blocks we can turn off
 	 * the alternate height mechanism.
 	 */
-	pag->pagf_repair_levels[XFS_BTNUM_BNOi] = 0;
-	pag->pagf_repair_levels[XFS_BTNUM_CNTi] = 0;
+	pag->pagf_repair_bno_level = 0;
+	pag->pagf_repair_cnt_level = 0;
 	return 0;
 }
 
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index f02247f8f185c..824e6dfe103a6 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1710,12 +1710,10 @@ DECLARE_EVENT_CLASS(xfs_agf_class,
 		__entry->agno = be32_to_cpu(agf->agf_seqno),
 		__entry->flags = flags;
 		__entry->length = be32_to_cpu(agf->agf_length),
-		__entry->bno_root = be32_to_cpu(agf->agf_roots[XFS_BTNUM_BNO]),
-		__entry->cnt_root = be32_to_cpu(agf->agf_roots[XFS_BTNUM_CNT]),
-		__entry->bno_level =
-				be32_to_cpu(agf->agf_levels[XFS_BTNUM_BNO]),
-		__entry->cnt_level =
-				be32_to_cpu(agf->agf_levels[XFS_BTNUM_CNT]),
+		__entry->bno_root = be32_to_cpu(agf->agf_bno_root),
+		__entry->cnt_root = be32_to_cpu(agf->agf_cnt_root),
+		__entry->bno_level = be32_to_cpu(agf->agf_bno_level),
+		__entry->cnt_level = be32_to_cpu(agf->agf_cnt_level),
 		__entry->flfirst = be32_to_cpu(agf->agf_flfirst),
 		__entry->fllast = be32_to_cpu(agf->agf_fllast),
 		__entry->flcount = be32_to_cpu(agf->agf_flcount),

