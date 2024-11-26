Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7FAF946C;
	Tue, 26 Nov 2024 01:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732584346; cv=none; b=FfvIgxRx/KOHmpFQB7qWfJxzv1xfd3vFv8LmZYHWMXrgMPrdANoYbfljFyzxasNU2aOs5R773MWcV8mfIyqqcDTPJQNbYsxokdJ7cTRKZ/HFfv321tOhk4QA8fIFSb19Sp/2IJuNSwa8GZFBeF8kwL0perEo5+7iyiTofHMyCA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732584346; c=relaxed/simple;
	bh=hXAq9p/Jf6bf4ZMMvEx6UyR0/luXHzK6s2KR1Z7rWj8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ad8mpakSPmO97FMD5bG+KpPptI/zmblJgR0Dd20LO87lxzxoOaI5/5NfCTvE80wG76dEpVAx1m8orxqa0l7QrRDsyLJAsDi7gz8hMozXv+PIq+DafF4fGNvPmxOBdZG/awUBdQvJs4+kuVafLfu4x8uX9ovkpNsOwPPraeWrVOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HltGL60Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HltGL60Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16566C4CECE;
	Tue, 26 Nov 2024 01:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732584346;
	bh=hXAq9p/Jf6bf4ZMMvEx6UyR0/luXHzK6s2KR1Z7rWj8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HltGL60ZqzAmjVie7oYsq32gfvg/l6Qqkwc9f8tSggT+e/8lwc7mPL5nvnq1zzRqM
	 oY7WknqK0xJbhaLSvjoLAXq1C+JO5sRSfx83ac55jCxd4t88jMLKNCj0qbPiuQ1PM9
	 c5QT0gCVO4mwE7yNL9gwL+Zbs8AEeIxym265H7Uf89EXEJsCodzQ/Lpg18Q/vE340e
	 0roE3PNmfzVnzmceYM3uLjKbBToyqQ38r5cHHSlBFRzsmHuP97hlsA3k68SRTBs37C
	 Z30aDTEWVmuqfrVbWKUh8x8TJlh3Z+A/zPlmk1qPOdtbV59zakyGiV7PsfSwebGv/k
	 hR0q9YxcgEwYg==
Date: Mon, 25 Nov 2024 17:25:45 -0800
Subject: [PATCH 04/21] xfs: return a 64-bit block count from
 xfs_btree_count_blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: stable@vger.kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173258397871.4032920.47151735139743461.stgit@frogsfrogsfrogs>
In-Reply-To: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
References: <173258397748.4032920.4159079744952779287.stgit@frogsfrogsfrogs>
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
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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
index a59bbe767a7dc4..0836fea2d6d814 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -103,7 +103,7 @@ xfs_bmap_count_blocks(
 	struct xfs_mount	*mp = ip->i_mount;
 	struct xfs_ifork	*ifp = xfs_ifork_ptr(ip, whichfork);
 	struct xfs_btree_cur	*cur;
-	xfs_extlen_t		btblocks = 0;
+	xfs_filblks_t		btblocks = 0;
 	int			error;
 
 	*nextents = 0;

