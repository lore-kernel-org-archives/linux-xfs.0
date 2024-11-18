Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63339153BE4;
	Mon, 18 Nov 2024 23:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731971134; cv=none; b=khoy7Wpl2ki2JfHrpJ7uWw+ypsXxcMT4QJ7v5iTSKKAfa9gqTFUiNAGHK9SLTJ7WG/UclcShT1hLJygqtPtDSohNOFS1SeIExTWqJUlnnvI989A0ZIRL9vmXFRnt+1313m7FOxGToswRdjUYSb9D5cn/sKx7v9FdIX0jNPmF/mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731971134; c=relaxed/simple;
	bh=Z1R38SnehH6MB09rjsLVKG/DpEtCFdEVtBvmiBtwzRs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VWP5FJmgnQ7zHwrRYZWT5NXEqCjtp3rVri76E3/uGN5vD14L3Yrn6cDE+O/qKE63ZDcUopsVCckEZeOfQ1h0YPbVivLGixxL4mOm4NxdLwVXV34WFwf2z0MZlr3p+ldNn9FvtrbDZLeoiStG6vXLUCZKc0CdMJx+AsjAlbNfXq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gUhqpemS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gUhqpemS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8875C4CECC;
	Mon, 18 Nov 2024 23:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731971134;
	bh=Z1R38SnehH6MB09rjsLVKG/DpEtCFdEVtBvmiBtwzRs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=gUhqpemSRhq6NmCLcWYN18N2Wa9W887z1dlvusLtaDPCBPNNHVRbQbDXaWCswy/F+
	 F6R661Ec3+//MB7HuFbalcax38JfD5b6WyFO6v7M3W4vJSa0V6HYyQUpTrcCf9tbVj
	 nB/tnNaGlHnJgG0Pb5qME5MB9ydPHewgjTWkDn9HxowI2f1206Tt/JysbDLxnrWaE4
	 aZGMeGnarCWbwoT9q0eM/O79qdBaZWiwDTqQkWN1rTd5rLDZunKULek7mXOZtdsL3i
	 53Dsk2fM+Cbhrgzqxgqmr0XNTWVXlyZ4TfRq1xeWrPjCEMEH9N1/TFfrs7qogOLOMI
	 5fRdffg/Se6TQ==
Date: Mon, 18 Nov 2024 15:05:33 -0800
Subject: [PATCH 04/10] xfs: return a 64-bit block count from
 xfs_btree_count_blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: stable@vger.kernel.org, linux-xfs@vger.kernel.org
Message-ID: <173197084481.911325.2907716202971546808.stgit@frogsfrogsfrogs>
In-Reply-To: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
References: <173197084388.911325.10473700839283408918.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

With the nrext64 feature enabled, it's possible for a data fork to have
2^48 extent mappings.  Even with a 64k fsblock size, that maps out to
a bmbt containing more than 2^32 blocks.  Therefore, this predicate must
return a u64 count to avoid an integer wraparound that will cause scrub
to do the wrong thing.

It's unlikely that any such filesystem currently exists, because the
incore bmbt would consume more than 64GB of kernel memory on its own,
and so far nobody except me has driven a filesystem that far, judging
from the lack of complaints.

Cc: <stable@vger.kernel.org> # v5.19
Fixes: df9ad5cc7a5240 ("xfs: Introduce macros to represent new maximum extent counts for data/attr forks")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c        |    4 ++--
 fs/xfs/libxfs/xfs_btree.h        |    2 +-
 fs/xfs/libxfs/xfs_ialloc_btree.c |    4 +++-
 fs/xfs/scrub/agheader.c          |    6 +++---
 fs/xfs/scrub/agheader_repair.c   |    6 +++---
 fs/xfs/scrub/fscounters.c        |    2 +-
 fs/xfs/scrub/ialloc.c            |    4 ++--
 fs/xfs/scrub/refcount.c          |    2 +-
 fs/xfs/xfs_bmap_util.c           |    2 +-
 9 files changed, 17 insertions(+), 15 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2b5fc5fd16435d..c748866ef92368 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -5144,7 +5144,7 @@ xfs_btree_count_blocks_helper(
 	int			level,
 	void			*data)
 {
-	xfs_extlen_t		*blocks = data;
+	xfs_filblks_t		*blocks = data;
 	(*blocks)++;
 
 	return 0;
@@ -5154,7 +5154,7 @@ xfs_btree_count_blocks_helper(
 int
 xfs_btree_count_blocks(
 	struct xfs_btree_cur	*cur,
-	xfs_extlen_t		*blocks)
+	xfs_filblks_t		*blocks)
 {
 	*blocks = 0;
 	return xfs_btree_visit_blocks(cur, xfs_btree_count_blocks_helper,
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 3b739459ebb0f4..c5bff273cae255 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -484,7 +484,7 @@ typedef int (*xfs_btree_visit_blocks_fn)(struct xfs_btree_cur *cur, int level,
 int xfs_btree_visit_blocks(struct xfs_btree_cur *cur,
 		xfs_btree_visit_blocks_fn fn, unsigned int flags, void *data);
 
-int xfs_btree_count_blocks(struct xfs_btree_cur *cur, xfs_extlen_t *blocks);
+int xfs_btree_count_blocks(struct xfs_btree_cur *cur, xfs_filblks_t *blocks);
 
 union xfs_btree_rec *xfs_btree_rec_addr(struct xfs_btree_cur *cur, int n,
 		struct xfs_btree_block *block);
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 9b34896dd1a32f..6f270d8f4270cb 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -744,6 +744,7 @@ xfs_finobt_count_blocks(
 {
 	struct xfs_buf		*agbp = NULL;
 	struct xfs_btree_cur	*cur;
+	xfs_filblks_t		blocks;
 	int			error;
 
 	error = xfs_ialloc_read_agi(pag, tp, 0, &agbp);
@@ -751,9 +752,10 @@ xfs_finobt_count_blocks(
 		return error;
 
 	cur = xfs_finobt_init_cursor(pag, tp, agbp);
-	error = xfs_btree_count_blocks(cur, tree_blocks);
+	error = xfs_btree_count_blocks(cur, &blocks);
 	xfs_btree_del_cursor(cur, error);
 	xfs_trans_brelse(tp, agbp);
+	*tree_blocks = blocks;
 
 	return error;
 }
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index 61f80a6410c738..1d41b85478da9d 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -458,7 +458,7 @@ xchk_agf_xref_btreeblks(
 {
 	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
 	struct xfs_mount	*mp = sc->mp;
-	xfs_agblock_t		blocks;
+	xfs_filblks_t		blocks;
 	xfs_agblock_t		btreeblks;
 	int			error;
 
@@ -507,7 +507,7 @@ xchk_agf_xref_refcblks(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_agf		*agf = sc->sa.agf_bp->b_addr;
-	xfs_agblock_t		blocks;
+	xfs_filblks_t		blocks;
 	int			error;
 
 	if (!sc->sa.refc_cur)
@@ -840,7 +840,7 @@ xchk_agi_xref_fiblocks(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_agi		*agi = sc->sa.agi_bp->b_addr;
-	xfs_agblock_t		blocks;
+	xfs_filblks_t		blocks;
 	int			error = 0;
 
 	if (!xfs_has_inobtcounts(sc->mp))
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 0fad0baaba2f69..b45d2b32051a63 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -256,7 +256,7 @@ xrep_agf_calc_from_btrees(
 	struct xfs_agf		*agf = agf_bp->b_addr;
 	struct xfs_mount	*mp = sc->mp;
 	xfs_agblock_t		btreeblks;
-	xfs_agblock_t		blocks;
+	xfs_filblks_t		blocks;
 	int			error;
 
 	/* Update the AGF counters from the bnobt. */
@@ -946,7 +946,7 @@ xrep_agi_calc_from_btrees(
 	if (error)
 		goto err;
 	if (xfs_has_inobtcounts(mp)) {
-		xfs_agblock_t	blocks;
+		xfs_filblks_t	blocks;
 
 		error = xfs_btree_count_blocks(cur, &blocks);
 		if (error)
@@ -959,7 +959,7 @@ xrep_agi_calc_from_btrees(
 	agi->agi_freecount = cpu_to_be32(freecount);
 
 	if (xfs_has_finobt(mp) && xfs_has_inobtcounts(mp)) {
-		xfs_agblock_t	blocks;
+		xfs_filblks_t	blocks;
 
 		cur = xfs_finobt_init_cursor(sc->sa.pag, sc->tp, agi_bp);
 		error = xfs_btree_count_blocks(cur, &blocks);
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 4a50f8e0004092..ca23cf4db6c5ef 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -261,7 +261,7 @@ xchk_fscount_btreeblks(
 	struct xchk_fscounters	*fsc,
 	xfs_agnumber_t		agno)
 {
-	xfs_extlen_t		blocks;
+	xfs_filblks_t		blocks;
 	int			error;
 
 	error = xchk_ag_init_existing(sc, agno, &sc->sa);
diff --git a/fs/xfs/scrub/ialloc.c b/fs/xfs/scrub/ialloc.c
index abad54c3621d44..4dc7c83dc08a40 100644
--- a/fs/xfs/scrub/ialloc.c
+++ b/fs/xfs/scrub/ialloc.c
@@ -650,8 +650,8 @@ xchk_iallocbt_xref_rmap_btreeblks(
 	struct xfs_scrub	*sc)
 {
 	xfs_filblks_t		blocks;
-	xfs_extlen_t		inobt_blocks = 0;
-	xfs_extlen_t		finobt_blocks = 0;
+	xfs_filblks_t		inobt_blocks = 0;
+	xfs_filblks_t		finobt_blocks = 0;
 	int			error;
 
 	if (!sc->sa.ino_cur || !sc->sa.rmap_cur ||
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 2b6be75e942415..1c5e45cc64190c 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -491,7 +491,7 @@ xchk_refcount_xref_rmap(
 	struct xfs_scrub	*sc,
 	xfs_filblks_t		cow_blocks)
 {
-	xfs_extlen_t		refcbt_blocks = 0;
+	xfs_filblks_t		refcbt_blocks = 0;
 	xfs_filblks_t		blocks;
 	int			error;
 
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 1fe676710394e1..d08505bdfe17a3 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -112,7 +112,7 @@ xfs_bmap_count_blocks(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_cur	*cur;
-	xfs_extlen_t		btblocks = 0;
+	xfs_filblks_t		btblocks = 0;
 	int			error;
 
 	*nextents = 0;

