Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CDA51552EC
	for <linux-xfs@vger.kernel.org>; Mon, 22 Apr 2024 16:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713804003; cv=none; b=uz9tEaC1vp3VTX7NT/lIN7NutwNpnBGe8ySFGHY7dahIgtMWL/sW/XzHjK2ZCZJ9GzhciMDlpGCQ/v3w20W2lTjEg7XYjTK/vQC1lUtNz0sJNz4Gh/8JS4+LJjT+z//5HZvYz3xsdHlDMl1hkEOd5G4I6AYdPF+CuoeIL+/RyQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713804003; c=relaxed/simple;
	bh=XyDwrcC6BZKxUTZfvAdffjZfkko9ihoxhDswC2KC04s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ons8gMeL0qzU9J/y0weIZ3kYay0K1CAgif+yDkqWbs9EMNgN1pBjf1rwQOxU1GP1inJILLFe7lwqjfM7nfcRo15sNU5/4nPduqrRQ+LVIw++nVNKJjH2xPYaa2ufaCS6xvGGrrKRBBhSyJdXNztiKuFIZWmnrITn1N86exTOi5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tJJxiGud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tJJxiGud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E88C113CC;
	Mon, 22 Apr 2024 16:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713804003;
	bh=XyDwrcC6BZKxUTZfvAdffjZfkko9ihoxhDswC2KC04s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tJJxiGudoGtirUIDnkss/UTlhZAcMkhZYEhqgjZ/jTger+WRW8ZZR7imBsrT4sut8
	 1stx22d/P+0YayubamUOzfJxNhRI/pyvBOIzJ08mr2KNAXtIMSFn4+AxfBabdNPo/D
	 XBANuZ9kWcTk9fd24CVmyWMVRvIs/m4FaDmuBy49p881p2UbhuHOMjHyxLPuZjVzDr
	 jEBM2I+apoxkOttq6eBoHLc3AIlKYeAVTwQJumsosP9L4A5WqrGKPtUaHZyhTRpqfA
	 YirQGKSkNxUuz5BrdRZJL3tgKvEu2G9yH/ExmcYWqLxKMV8vSPhKZSG4sZ0Pci23t/
	 vKiyWAa4JutNw==
From: cem@kernel.org
To: linux-xfs@vger.kernel.org
Cc: djwong@kernel.org,
	hch@lst.de
Subject: [PATCH 36/67] xfs: repair refcount btrees
Date: Mon, 22 Apr 2024 18:25:58 +0200
Message-ID: <20240422163832.858420-38-cem@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240422163832.858420-2-cem@kernel.org>
References: <20240422163832.858420-2-cem@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Darrick J. Wong" <djwong@kernel.org>

Source kernel commit: 9099cd38002f8029c9a1da08e6832d1cd18e8451

Reconstruct the refcount data from the rmap btree.

Link: https://docs.kernel.org/filesystems/xfs-online-fsck-design.html#case-study-rebuilding-the-space-reference-counts
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
---
 libxfs/xfs_ag.h             |  1 +
 libxfs/xfs_btree.c          | 26 ++++++++++++++++++++++++++
 libxfs/xfs_btree.h          |  2 ++
 libxfs/xfs_refcount.c       |  8 +++-----
 libxfs/xfs_refcount.h       |  2 +-
 libxfs/xfs_refcount_btree.c | 13 ++++++++++++-
 6 files changed, 45 insertions(+), 7 deletions(-)

diff --git a/libxfs/xfs_ag.h b/libxfs/xfs_ag.h
index f16cb7a17..67c3260ee 100644
--- a/libxfs/xfs_ag.h
+++ b/libxfs/xfs_ag.h
@@ -87,6 +87,7 @@ struct xfs_perag {
 	 * verifiers while rebuilding the AG btrees.
 	 */
 	uint8_t		pagf_repair_levels[XFS_BTNUM_AGF];
+	uint8_t		pagf_repair_refcount_level;
 #endif
 
 	spinlock_t	pag_state_lock;
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index 97962fc16..0022bb641 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -5209,3 +5209,29 @@ xfs_btree_destroy_cur_caches(void)
 	xfs_rmapbt_destroy_cur_cache();
 	xfs_refcountbt_destroy_cur_cache();
 }
+
+/* Move the btree cursor before the first record. */
+int
+xfs_btree_goto_left_edge(
+	struct xfs_btree_cur	*cur)
+{
+	int			stat = 0;
+	int			error;
+
+	memset(&cur->bc_rec, 0, sizeof(cur->bc_rec));
+	error = xfs_btree_lookup(cur, XFS_LOOKUP_LE, &stat);
+	if (error)
+		return error;
+	if (!stat)
+		return 0;
+
+	error = xfs_btree_decrement(cur, 0, &stat);
+	if (error)
+		return error;
+	if (stat != 0) {
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index e0875cec4..d906324e2 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -738,4 +738,6 @@ xfs_btree_alloc_cursor(
 int __init xfs_btree_init_cur_caches(void);
 void xfs_btree_destroy_cur_caches(void);
 
+int xfs_btree_goto_left_edge(struct xfs_btree_cur *cur);
+
 #endif	/* __XFS_BTREE_H__ */
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 45f8134e4..3377fac12 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -122,11 +122,9 @@ xfs_refcount_btrec_to_irec(
 /* Simple checks for refcount records. */
 xfs_failaddr_t
 xfs_refcount_check_irec(
-	struct xfs_btree_cur		*cur,
+	struct xfs_perag		*pag,
 	const struct xfs_refcount_irec	*irec)
 {
-	struct xfs_perag		*pag = cur->bc_ag.pag;
-
 	if (irec->rc_blockcount == 0 || irec->rc_blockcount > MAXREFCEXTLEN)
 		return __this_address;
 
@@ -178,7 +176,7 @@ xfs_refcount_get_rec(
 		return error;
 
 	xfs_refcount_btrec_to_irec(rec, irec);
-	fa = xfs_refcount_check_irec(cur, irec);
+	fa = xfs_refcount_check_irec(cur->bc_ag.pag, irec);
 	if (fa)
 		return xfs_refcount_complain_bad_rec(cur, fa, irec);
 
@@ -1898,7 +1896,7 @@ xfs_refcount_recover_extent(
 	INIT_LIST_HEAD(&rr->rr_list);
 	xfs_refcount_btrec_to_irec(rec, &rr->rr_rrec);
 
-	if (xfs_refcount_check_irec(cur, &rr->rr_rrec) != NULL ||
+	if (xfs_refcount_check_irec(cur->bc_ag.pag, &rr->rr_rrec) != NULL ||
 	    XFS_IS_CORRUPT(cur->bc_mp,
 			   rr->rr_rrec.rc_domain != XFS_REFC_DOMAIN_COW)) {
 		kfree(rr);
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 783cd89ca..5c207f1c6 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -117,7 +117,7 @@ extern int xfs_refcount_has_records(struct xfs_btree_cur *cur,
 union xfs_btree_rec;
 extern void xfs_refcount_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_refcount_irec *irec);
-xfs_failaddr_t xfs_refcount_check_irec(struct xfs_btree_cur *cur,
+xfs_failaddr_t xfs_refcount_check_irec(struct xfs_perag *pag,
 		const struct xfs_refcount_irec *irec);
 extern int xfs_refcount_insert(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
diff --git a/libxfs/xfs_refcount_btree.c b/libxfs/xfs_refcount_btree.c
index bc8bd867e..ac1c3ab86 100644
--- a/libxfs/xfs_refcount_btree.c
+++ b/libxfs/xfs_refcount_btree.c
@@ -225,7 +225,18 @@ xfs_refcountbt_verify(
 
 	level = be16_to_cpu(block->bb_level);
 	if (pag && xfs_perag_initialised_agf(pag)) {
-		if (level >= pag->pagf_refcount_level)
+		unsigned int	maxlevel = pag->pagf_refcount_level;
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+		/*
+		 * Online repair could be rewriting the refcount btree, so
+		 * we'll validate against the larger of either tree while this
+		 * is going on.
+		 */
+		maxlevel = max_t(unsigned int, maxlevel,
+				pag->pagf_repair_refcount_level);
+#endif
+		if (level >= maxlevel)
 			return __this_address;
 	} else if (level >= mp->m_refc_maxlevels)
 		return __this_address;
-- 
2.44.0

