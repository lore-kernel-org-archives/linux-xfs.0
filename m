Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36BF1B3925
	for <linux-xfs@vger.kernel.org>; Mon, 12 Oct 2026 06:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791784890; cv=none; b=FXuq+AUSDPYWZEE2a0LuKZk2/r2eue+i1LTp123sUT99m7k10Y6/dZYQqFv4s+jmUG4wCbQO+2nWhKiSDa70AKjnfxuaeQms+tyPsduD3CWXmuGByzDql3F0XrKtOESK1hqQu/MNjIfANtCqBFmiFYUZuopG3+NXLRFjQr2PIos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791784890; c=relaxed/simple;
	bh=3Nvz4KKsRgv1RSomjM9TTMp+M9up22M0TTzpMOMzFKQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tlqzIinztuQgMLZB4C8z937oeT5Guoao7BWRVU4+TInrUxyeW8gE7VoP7leTeVt9lnt93IwNuTHV/dk2joy2isT0jBIILkEDZulalFP5pgHirdiwwNu7MMseabCnen9DZjSx5VnY/Oww9Fmi0iUpied3VfTtFzCRPWzvHEKsJfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mmLLl4JT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mmLLl4JT"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4DBAC1F0089B;
	Mon, 12 Oct 2026 06:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791784888;
	bh=7tfW2ffBSXQ+714ww6K3g3qbqJdax2qxNU+MqusJrjA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=mmLLl4JT/VAANol8CC/MrOXyJELvUuNBLHjCTHT26JEsBgrTHDCf08D9wxng2+LXY
	 upeXYAu73qJaRxK5SvEbuQJqJF183Q0V7bAH6v1stAuQyDCGDTpw89nF6uxGBtQBCp
	 ji2RXPaEa06pBvRkXZiRCwUIzfV32Qr0BSZKPs5apVPioB75vwtidDg8Ka4DnKpNsC
	 S4L/cY1HFV5MX6PqE1HaGqtgUgpl0o3wDyXRWQSsvN/SSALxWERkIIa22NgllWshiE
	 zXlYL1g0Ld9tQaYR1m/XojhQlYtwjJWo9LJAgTQf9tnrODgFmipCmyC8i+4jQ8wC5b
	 nMxUlCmwvgrMA==
Date: Sun, 11 Oct 2026 23:01:27 -0700
Subject: [PATCH 10/12] xfs: drop unnecessary sa parameter from xchk_ag init
 functions
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <179178066014.1058822.8802191247645588099.stgit@frogsfrogsfrogs>
In-Reply-To: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
References: <179178065713.1058822.6886680430162106741.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Drop the sa parameter because it's always the same value.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/scrub/common.h            |   17 +++++++----------
 fs/xfs/scrub/agheader.c          |   16 ++++++++--------
 fs/xfs/scrub/alloc_repair.c      |    2 +-
 fs/xfs/scrub/bmap.c              |    4 ++--
 fs/xfs/scrub/bmap_repair.c       |    2 +-
 fs/xfs/scrub/btree.c             |    4 ++--
 fs/xfs/scrub/common.c            |   28 +++++++++++++++-------------
 fs/xfs/scrub/cow_repair.c        |    2 +-
 fs/xfs/scrub/fscounters.c        |    4 ++--
 fs/xfs/scrub/ialloc_repair.c     |    2 +-
 fs/xfs/scrub/inode.c             |    4 ++--
 fs/xfs/scrub/refcount_repair.c   |    2 +-
 fs/xfs/scrub/repair.c            |    2 +-
 fs/xfs/scrub/rmap_repair.c       |    4 ++--
 fs/xfs/scrub/rtrefcount.c        |    4 ++--
 fs/xfs/scrub/rtrefcount_repair.c |    2 +-
 fs/xfs/scrub/rtrmap_repair.c     |    2 +-
 fs/xfs/scrub/scrub.c             |    2 +-
 18 files changed, 51 insertions(+), 52 deletions(-)


diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index f0f073a9341337..8478f3a9bed33d 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -109,9 +109,8 @@ xchk_ino_dqattach(struct xfs_scrub *sc)
 int xchk_setup_fscounters(struct xfs_scrub *sc);
 int xchk_setup_nlinks(struct xfs_scrub *sc);
 
-void xchk_ag_free(struct xfs_scrub *sc, struct xchk_ag *sa);
-int xchk_ag_init(struct xfs_scrub *sc, xfs_agnumber_t agno,
-		struct xchk_ag *sa);
+void xchk_ag_free(struct xfs_scrub *sc);
+int xchk_ag_init(struct xfs_scrub *sc, xfs_agnumber_t agno);
 int xchk_perag_drain_and_lock(struct xfs_scrub *sc);
 
 /*
@@ -122,10 +121,9 @@ int xchk_perag_drain_and_lock(struct xfs_scrub *sc);
 static inline int
 xchk_ag_init_existing(
 	struct xfs_scrub	*sc,
-	xfs_agnumber_t		agno,
-	struct xchk_ag		*sa)
+	xfs_agnumber_t		agno)
 {
-	int			error = xchk_ag_init(sc, agno, sa);
+	int			error = xchk_ag_init(sc, agno);
 
 	return error == -ENOENT ? -EFSCORRUPTED : error;
 }
@@ -165,10 +163,9 @@ void xchk_rtgroup_free(struct xfs_scrub *sc, struct xchk_rt *sr);
 # define xchk_rtgroup_free(sc, sr)			do { } while (0)
 #endif /* CONFIG_XFS_RT */
 
-int xchk_ag_read_headers(struct xfs_scrub *sc, xfs_agnumber_t agno,
-		struct xchk_ag *sa);
-void xchk_ag_btcur_free(struct xchk_ag *sa);
-void xchk_ag_btcur_init(struct xfs_scrub *sc, struct xchk_ag *sa);
+int xchk_ag_read_headers(struct xfs_scrub *sc, xfs_agnumber_t agno);
+void xchk_ag_btcur_free(struct xfs_scrub *sc);
+void xchk_ag_btcur_init(struct xfs_scrub *sc);
 int xchk_count_rmap_ownedby_ag(struct xfs_scrub *sc, struct xfs_btree_cur *cur,
 		const struct xfs_owner_info *oinfo, xfs_filblks_t *blocks);
 
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index a765d3e5e0686b..be59b0b495472f 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -47,7 +47,7 @@ xchk_superblock_xref(
 
 	agbno = XFS_SB_BLOCK(mp);
 
-	error = xchk_ag_init_existing(sc, agno, &sc->sa);
+	error = xchk_ag_init_existing(sc, agno);
 	if (!xchk_xref_process_error(sc, agno, agbno, &error))
 		return;
 
@@ -56,7 +56,7 @@ xchk_superblock_xref(
 	xchk_xref_is_only_owned_by(sc, agbno, 1, &XFS_RMAP_OINFO_FS);
 	xchk_xref_is_not_shared(sc, agbno, 1);
 	xchk_xref_is_not_cow_staging(sc, agbno, 1);
-	xchk_ag_free(sc, &sc->sa);
+	xchk_ag_free(sc);
 }
 
 /*
@@ -615,7 +615,7 @@ xchk_agf_xref(
 
 	agbno = XFS_AGF_BLOCK(mp);
 
-	xchk_ag_btcur_init(sc, &sc->sa);
+	xchk_ag_btcur_init(sc);
 
 	xchk_xref_is_used_space(sc, agbno, 1);
 	xchk_agf_xref_freeblks(sc);
@@ -648,7 +648,7 @@ xchk_agf(
 	int			level;
 	int			error = 0;
 
-	error = xchk_ag_read_headers(sc, agno, &sc->sa);
+	error = xchk_ag_read_headers(sc, agno);
 	if (!xchk_process_error(sc, agno, XFS_AGF_BLOCK(sc->mp), &error))
 		goto out;
 	xchk_buffer_recheck(sc, sc->sa.agf_bp);
@@ -803,7 +803,7 @@ xchk_agfl_xref(
 
 	agbno = XFS_AGFL_BLOCK(mp);
 
-	xchk_ag_btcur_init(sc, &sc->sa);
+	xchk_ag_btcur_init(sc);
 
 	xchk_xref_is_used_space(sc, agbno, 1);
 	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
@@ -831,7 +831,7 @@ xchk_agfl(
 	int			error;
 
 	/* Lock the AGF and AGI so that nobody can touch this AG. */
-	error = xchk_ag_read_headers(sc, agno, &sc->sa);
+	error = xchk_ag_read_headers(sc, agno);
 	if (!xchk_process_error(sc, agno, XFS_AGFL_BLOCK(sc->mp), &error))
 		return error;
 	if (!sc->sa.agf_bp)
@@ -958,7 +958,7 @@ xchk_agi_xref(
 
 	agbno = XFS_AGI_BLOCK(mp);
 
-	xchk_ag_btcur_init(sc, &sc->sa);
+	xchk_ag_btcur_init(sc);
 
 	xchk_xref_is_used_space(sc, agbno, 1);
 	xchk_xref_is_not_inode_chunk(sc, agbno, 1);
@@ -1072,7 +1072,7 @@ xchk_agi(
 	int			level;
 	int			error = 0;
 
-	error = xchk_ag_read_headers(sc, agno, &sc->sa);
+	error = xchk_ag_read_headers(sc, agno);
 	if (!xchk_process_error(sc, agno, XFS_AGI_BLOCK(sc->mp), &error))
 		goto out;
 	xchk_buffer_recheck(sc, sc->sa.agi_bp);
diff --git a/fs/xfs/scrub/alloc_repair.c b/fs/xfs/scrub/alloc_repair.c
index 854cfbbd9ecf4f..2f60e4b517596e 100644
--- a/fs/xfs/scrub/alloc_repair.c
+++ b/fs/xfs/scrub/alloc_repair.c
@@ -406,7 +406,7 @@ xrep_abt_find_freespace(
 err_agfl:
 	xfs_trans_brelse(sc->tp, agfl_bp);
 err:
-	xchk_ag_btcur_free(&sc->sa);
+	xchk_ag_btcur_free(sc);
 	xagb_bitmap_destroy(&ra->not_allocbt_blocks);
 	return error;
 }
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 428be9ecdcd4d4..8447f711ca2c51 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -396,7 +396,7 @@ xchk_bmap_iextent_xref(
 	agbno = XFS_FSB_TO_AGBNO(mp, irec->br_startblock);
 	len = irec->br_blockcount;
 
-	error = xchk_ag_init_existing(info->sc, agno, &info->sc->sa);
+	error = xchk_ag_init_existing(info->sc, agno);
 	if (!xchk_fblock_process_error(info->sc, info->whichfork,
 			irec->br_startoff, &error))
 		goto out_free;
@@ -440,7 +440,7 @@ xchk_bmap_iextent_xref(
 	}
 
 out_free:
-	xchk_ag_free(info->sc, &info->sc->sa);
+	xchk_ag_free(info->sc);
 }
 
 /*
diff --git a/fs/xfs/scrub/bmap_repair.c b/fs/xfs/scrub/bmap_repair.c
index 5b422f5e13c21c..4d9ac54d5dfc11 100644
--- a/fs/xfs/scrub/bmap_repair.c
+++ b/fs/xfs/scrub/bmap_repair.c
@@ -364,7 +364,7 @@ xrep_bmap_scan_ag(
 		return error;
 
 	error = xfs_rmap_query_all(sc->sa.rmap_cur, xrep_bmap_walk_rmap, rb);
-	xchk_ag_free(sc, &sc->sa);
+	xchk_ag_free(sc);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index ce8c9c1aaa3102..42769514118eda 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -397,7 +397,7 @@ xchk_btree_check_block_owner(
 	 */
 	init_sa = bs->cur->bc_ops->type != XFS_BTREE_TYPE_AG;
 	if (init_sa) {
-		error = xchk_ag_init_existing(bs->sc, agno, &bs->sc->sa);
+		error = xchk_ag_init_existing(bs->sc, agno);
 		if (!xchk_btree_xref_process_error(bs->sc, bs->cur,
 				level, &error))
 			goto out_free;
@@ -418,7 +418,7 @@ xchk_btree_check_block_owner(
 
 out_free:
 	if (init_sa)
-		xchk_ag_free(bs->sc, &bs->sc->sa);
+		xchk_ag_free(bs->sc);
 
 	return error;
 }
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index a61895872072d1..82cda70e4169ae 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -578,10 +578,10 @@ xchk_perag_drain_and_lock(
 int
 xchk_ag_read_headers(
 	struct xfs_scrub	*sc,
-	xfs_agnumber_t		agno,
-	struct xchk_ag		*sa)
+	xfs_agnumber_t		agno)
 {
 	struct xfs_mount	*mp = sc->mp;
+	struct xchk_ag		*sa = &sc->sa;
 
 	ASSERT(!sa->pag);
 	sa->pag = xfs_perag_get(mp, agno);
@@ -594,8 +594,10 @@ xchk_ag_read_headers(
 /* Release all the AG btree cursors. */
 void
 xchk_ag_btcur_free(
-	struct xchk_ag		*sa)
+	struct xfs_scrub	*sc)
 {
+	struct xchk_ag		*sa = &sc->sa;
+
 	if (sa->refc_cur)
 		xfs_btree_del_cursor(sa->refc_cur, XFS_BTREE_ERROR);
 	if (sa->rmap_cur)
@@ -620,10 +622,10 @@ xchk_ag_btcur_free(
 /* Initialize all the btree cursors for an AG. */
 void
 xchk_ag_btcur_init(
-	struct xfs_scrub	*sc,
-	struct xchk_ag		*sa)
+	struct xfs_scrub	*sc)
 {
 	struct xfs_mount	*mp = sc->mp;
+	struct xchk_ag		*sa = &sc->sa;
 
 	if (sa->agf_bp) {
 		/* Set up a bnobt cursor for cross-referencing. */
@@ -675,10 +677,11 @@ xchk_ag_btcur_init(
 /* Release the AG header context and btree cursors. */
 void
 xchk_ag_free(
-	struct xfs_scrub	*sc,
-	struct xchk_ag		*sa)
+	struct xfs_scrub	*sc)
 {
-	xchk_ag_btcur_free(sa);
+	struct xchk_ag		*sa = &sc->sa;
+
+	xchk_ag_btcur_free(sc);
 	xrep_reset_perag_resv(sc);
 	if (sa->agf_bp) {
 		xfs_trans_brelse(sc->tp, sa->agf_bp);
@@ -704,16 +707,15 @@ xchk_ag_free(
 int
 xchk_ag_init(
 	struct xfs_scrub	*sc,
-	xfs_agnumber_t		agno,
-	struct xchk_ag		*sa)
+	xfs_agnumber_t		agno)
 {
 	int			error;
 
-	error = xchk_ag_read_headers(sc, agno, sa);
+	error = xchk_ag_read_headers(sc, agno);
 	if (error)
 		return error;
 
-	xchk_ag_btcur_init(sc, sa);
+	xchk_ag_btcur_init(sc);
 	return 0;
 }
 
@@ -958,7 +960,7 @@ xchk_setup_ag_btree(
 	if (error)
 		return error;
 
-	return xchk_ag_init(sc, sc->sm->sm_agno, &sc->sa);
+	return xchk_ag_init(sc, sc->sm->sm_agno);
 }
 
 /* Push everything out of the log onto disk. */
diff --git a/fs/xfs/scrub/cow_repair.c b/fs/xfs/scrub/cow_repair.c
index f2e650c6f7afdf..5a209194ba97eb 100644
--- a/fs/xfs/scrub/cow_repair.c
+++ b/fs/xfs/scrub/cow_repair.c
@@ -340,7 +340,7 @@ xrep_cow_find_bad(
 				xc->irec.br_blockcount);
 
 out_sa:
-	xchk_ag_free(sc, &sc->sa);
+	xchk_ag_free(sc);
 out_pag:
 	xfs_perag_put(pag);
 	return error;
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index c055b73d268058..b9d0c3559d28f6 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -265,7 +265,7 @@ xchk_fscount_btreeblks(
 	xfs_filblks_t		blocks;
 	int			error;
 
-	error = xchk_ag_init_existing(sc, agno, &sc->sa);
+	error = xchk_ag_init_existing(sc, agno);
 	if (error)
 		goto out_free;
 
@@ -280,7 +280,7 @@ xchk_fscount_btreeblks(
 	fsc->fdblocks += blocks - 1;
 
 out_free:
-	xchk_ag_free(sc, &sc->sa);
+	xchk_ag_free(sc);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/ialloc_repair.c b/fs/xfs/scrub/ialloc_repair.c
index f0f2232a9686d8..146b3fec6d347c 100644
--- a/fs/xfs/scrub/ialloc_repair.c
+++ b/fs/xfs/scrub/ialloc_repair.c
@@ -475,7 +475,7 @@ xrep_ibt_find_inodes(
 	/* Collect all reverse mappings for inode blocks. */
 	xrep_ag_btcur_init(sc);
 	error = xfs_rmap_query_all(sc->sa.rmap_cur, xrep_ibt_walk_rmap, ri);
-	xchk_ag_btcur_free(&sc->sa);
+	xchk_ag_btcur_free(sc);
 	if (error)
 		return error;
 
diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index ac42867acbc4c9..6cded1eb6c2b6f 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -740,7 +740,7 @@ xchk_inode_xref(
 	agno = XFS_INO_TO_AGNO(sc->mp, ino);
 	agbno = XFS_INO_TO_AGBNO(sc->mp, ino);
 
-	error = xchk_ag_init_existing(sc, agno, &sc->sa);
+	error = xchk_ag_init_existing(sc, agno);
 	if (!xchk_xref_process_error(sc, agno, agbno, &error))
 		goto out_free;
 
@@ -752,7 +752,7 @@ xchk_inode_xref(
 	xchk_inode_xref_bmap(sc, dip);
 
 out_free:
-	xchk_ag_free(sc, &sc->sa);
+	xchk_ag_free(sc);
 }
 
 /*
diff --git a/fs/xfs/scrub/refcount_repair.c b/fs/xfs/scrub/refcount_repair.c
index aa29d7a27abaa8..36b5e2a92cfdae 100644
--- a/fs/xfs/scrub/refcount_repair.c
+++ b/fs/xfs/scrub/refcount_repair.c
@@ -503,7 +503,7 @@ xrep_refc_find_refcounts(
 out_bag:
 	rcbag_free(&rcstack);
 out_cur:
-	xchk_ag_btcur_free(&sc->sa);
+	xchk_ag_btcur_free(sc);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 88494e79340ef8..32bd8259cedb65 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -68,7 +68,7 @@ xrep_attempt(
 
 	trace_xrep_attempt(XFS_I(file_inode(sc->file)), sc->sm, error);
 
-	xchk_ag_btcur_free(&sc->sa);
+	xchk_ag_btcur_free(sc);
 	xchk_rtgroup_btcur_free(&sc->sr);
 
 	/* Repair whatever's broken. */
diff --git a/fs/xfs/scrub/rmap_repair.c b/fs/xfs/scrub/rmap_repair.c
index aac9e534df798f..f88d7b62098b2b 100644
--- a/fs/xfs/scrub/rmap_repair.c
+++ b/fs/xfs/scrub/rmap_repair.c
@@ -926,7 +926,7 @@ xrep_rmap_find_rmaps(
 
 	error = xrep_rmap_find_log_rmaps(rr);
 end_agscan:
-	xchk_ag_btcur_free(&sc->sa);
+	xchk_ag_btcur_free(sc);
 	if (error)
 		return error;
 
@@ -1169,7 +1169,7 @@ xrep_rmap_reserve_space(
 	/* Emit rmaps for everything in the free space bitmap. */
 	xrep_ag_btcur_init(rr->sc);
 	error = xrep_rmap_stash_bitmap(rr, &freesp_blocks, &XFS_RMAP_OINFO_AG);
-	xchk_ag_btcur_free(&rr->sc->sa);
+	xchk_ag_btcur_free(rr->sc);
 
 out_bitmap:
 	xagb_bitmap_destroy(&freesp_blocks);
diff --git a/fs/xfs/scrub/rtrefcount.c b/fs/xfs/scrub/rtrefcount.c
index c312096e410561..824783e4f0e193 100644
--- a/fs/xfs/scrub/rtrefcount.c
+++ b/fs/xfs/scrub/rtrefcount.c
@@ -531,7 +531,7 @@ xchk_rtrefcount_count_agblocks(
 	xfs_filblks_t		agblocks = 0;
 	int			error;
 
-	error = xchk_ag_init_existing(sc, agno, &sc->sa);
+	error = xchk_ag_init_existing(sc, agno);
 	if (error)
 		goto out_free;
 
@@ -552,7 +552,7 @@ xchk_rtrefcount_count_agblocks(
 
 	*blocks += agblocks;
 out_free:
-	xchk_ag_free(sc, &sc->sa);
+	xchk_ag_free(sc);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/rtrefcount_repair.c b/fs/xfs/scrub/rtrefcount_repair.c
index e7f6d71695fd68..2e773febffd78e 100644
--- a/fs/xfs/scrub/rtrefcount_repair.c
+++ b/fs/xfs/scrub/rtrefcount_repair.c
@@ -425,7 +425,7 @@ xrep_rtrefc_scan_ag(
 		return error;
 
 	error = xfs_rmap_query_all(sc->sa.rmap_cur, xrep_rtrefc_walk_rmap, rr);
-	xchk_ag_free(sc, &sc->sa);
+	xchk_ag_free(sc);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/rtrmap_repair.c b/fs/xfs/scrub/rtrmap_repair.c
index 755675460cb8a4..726ef89ab2f10b 100644
--- a/fs/xfs/scrub/rtrmap_repair.c
+++ b/fs/xfs/scrub/rtrmap_repair.c
@@ -418,7 +418,7 @@ xrep_rtrmap_scan_ag(
 		return error;
 
 	error = xfs_rmap_query_all(sc->sa.rmap_cur, xrep_rtrmap_walk_rmap, rr);
-	xchk_ag_free(sc, &sc->sa);
+	xchk_ag_free(sc);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 12c228b7f4770d..9dbd16546e8c8b 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -229,7 +229,7 @@ xchk_teardown(
 	struct xfs_scrub	*sc,
 	int			error)
 {
-	xchk_ag_free(sc, &sc->sa);
+	xchk_ag_free(sc);
 	xchk_rtgroup_btcur_free(&sc->sr);
 
 	if (sc->tp) {

