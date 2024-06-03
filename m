Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702B3137C33
	for <linux-xfs@vger.kernel.org>; Mon,  3 Jun 2024 19:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717442821; cv=none; b=r+TBs3BRxBReeYxCW1RgaXDpK/lWMpagkHsErGoYI03do82P73zqjzgcHoJgTfF7/Nne7mVWnwIPdL24zsKoWVA2gYTzdaojG25f4KicNZJgt3wSpQVfG9e+OHZFxNIfHFBXoebEDyuYkYCch9lnx/7jT6NMfo+RKSSIJE1P8D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717442821; c=relaxed/simple;
	bh=DV5MwsF4X3DuHyGkMZD7wyM71nCwYgJleEPN5sA6IyA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CugUgUQLiWmnknSw/UVMZ/gfZuduRKMQ9/6n2F+M124VokJiNXtXcnwTN/z2oBjVjumeD4KOAhjOs8BLv/t9le2oGjk6y1RGLiP1jiQ+wXhl0f6l7VHBbfS1MvLvU7TUd64CH5H3vsGvqinPgWZfSRzAw18Wuv03ZJUQ0w3KqHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cGqwSofk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cGqwSofk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A55CC2BD10;
	Mon,  3 Jun 2024 19:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717442821;
	bh=DV5MwsF4X3DuHyGkMZD7wyM71nCwYgJleEPN5sA6IyA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cGqwSofkVSdl3Rpr6rL+OZkgvfEzHXn0ERtIYqlOwiyQOTVC41x46bZDhl2FZS8L+
	 D6KlfWjx8PBa9xeXCCUZPYEzfqo4GkWyefV1yVzI0STMmm0A6EpqLl0hAfzgrZ6rWk
	 kJmQ5e41C4a4UqTW+a/zzMKuT7z4SyoXUeNezzWzze+CbaqJMcaYND0Z9vOCv7pLaQ
	 xj6A0CkdQsCBNB2YBjsneYz2LSbcNR+FdlB3hCbkeslBjKsU7GoOUVARML3APbH/+l
	 7+al1iE/McWcaQZUzq0iy1y5cKEwJHvtSjUhdGUhC61aX8AdY9jMswTp1CjXVX7Xn3
	 inngEU9mz0b8g==
Date: Mon, 03 Jun 2024 12:27:00 -0700
Subject: [PATCH 3/4] xfs_repair: port to the new refcount bag structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171744043533.1450408.12687964316396569028.stgit@frogsfrogsfrogs>
In-Reply-To: <171744043484.1450408.1711608371281603052.stgit@frogsfrogsfrogs>
References: <171744043484.1450408.1711608371281603052.stgit@frogsfrogsfrogs>
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

Port the refcount record generating code to use the new refcount bag
data structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/rmap.c       |  150 +++++++++++++++------------------------------------
 repair/xfs_repair.c |    6 ++
 2 files changed, 51 insertions(+), 105 deletions(-)


diff --git a/repair/rmap.c b/repair/rmap.c
index 519633278..7cb3a315a 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -14,6 +14,7 @@
 #include "rmap.h"
 #include "libfrog/bitmap.h"
 #include "libfrog/platform.h"
+#include "rcbag.h"
 
 #undef RMAP_DEBUG
 
@@ -749,35 +750,32 @@ rmap_dump(
  * reflink inode flag, if the stack depth is greater than 1.
  */
 static void
-mark_inode_rl(
+mark_reflink_inodes(
 	struct xfs_mount	*mp,
-	struct xfs_bag		*rmaps)
+	struct rcbag		*rcstack)
 {
-	struct rmap_for_refcount *rfr;
+	struct rcbag_iter	rciter;
 	struct ino_tree_node	*irec;
-	int			off;
-	uint64_t		idx;
 
-	if (bag_count(rmaps) < 2)
-		return;
-
-	/* Reflink flag accounting */
-	foreach_bag_ptr(rmaps, idx, rfr) {
+	rcbag_ino_iter_start(rcstack, &rciter);
+	while (rcbag_ino_iter(rcstack, &rciter) == 1) {
 		xfs_agnumber_t	agno;
 		xfs_agino_t	agino;
+		int		off;
 
-		ASSERT(!XFS_RMAP_NON_INODE_OWNER(rfr->rm_owner));
+		ASSERT(!XFS_RMAP_NON_INODE_OWNER(rciter.ino));
 
-		agno = XFS_INO_TO_AGNO(mp, rfr->rm_owner);
-		agino = XFS_INO_TO_AGINO(mp, rfr->rm_owner);
+		agno = XFS_INO_TO_AGNO(mp, rciter.ino);
+		agino = XFS_INO_TO_AGINO(mp, rciter.ino);
 
 		pthread_mutex_lock(&ag_locks[agno].lock);
 		irec = find_inode_rec(mp, agno, agino);
-		off = get_inode_offset(mp, rfr->rm_owner, irec);
+		off = get_inode_offset(mp, rciter.ino, irec);
 		/* lock here because we might go outside this ag */
 		set_inode_is_rl(irec, off);
 		pthread_mutex_unlock(&ag_locks[agno].lock);
 	}
+	rcbag_ino_iter_stop(rcstack, &rciter);
 }
 
 /*
@@ -812,8 +810,6 @@ refcount_emit(
 _("Insufficient memory while recreating refcount tree."));
 }
 
-#define RMAP_NEXT(r)	((r)->rm_startblock + (r)->rm_blockcount)
-
 /* Decide if an rmap could describe a shared extent. */
 static inline bool
 rmap_shareable(
@@ -873,40 +869,6 @@ refcount_walk_rmaps(
 	return 0;
 }
 
-/*
- * Find the next block where the refcount changes, given the next rmap we
- * looked at and the ones we're already tracking.
- */
-static inline int
-next_refcount_edge(
-	struct xfs_bag		*stack_top,
-	struct xfs_rmap_irec	*next_rmap,
-	bool			next_valid,
-	xfs_agblock_t		*nbnop)
-{
-	struct rmap_for_refcount *rfr;
-	uint64_t		idx;
-	xfs_agblock_t		nbno = NULLAGBLOCK;
-
-	if (next_valid)
-		nbno = next_rmap->rm_startblock;
-
-	foreach_bag_ptr(stack_top, idx, rfr)
-		nbno = min(nbno, RMAP_NEXT(rfr));
-
-	/*
-	 * We should have found /something/ because either next_rrm is the next
-	 * interesting rmap to look at after emitting this refcount extent, or
-	 * there are other rmaps in rmap_bag contributing to the current
-	 * sharing count.  But if something is seriously wrong, bail out.
-	 */
-	if (nbno == NULLAGBLOCK)
-		return EFSCORRUPTED;
-
-	*nbnop = nbno;
-	return 0;
-}
-
 /*
  * Walk forward through the rmap btree to collect all rmaps starting at
  * @bno in @rmap_bag.  These represent the file(s) that share ownership of
@@ -916,28 +878,19 @@ next_refcount_edge(
 static int
 refcount_push_rmaps_at(
 	struct xfs_btree_cur	*rmcur,
-	xfs_agnumber_t		agno,
-	struct xfs_bag		*stack_top,
+	struct rcbag		*stack,
 	xfs_agblock_t		bno,
-	struct xfs_rmap_irec	*irec,
+	struct xfs_rmap_irec	*rmap,
 	bool			*have,
 	const char		*tag)
 {
 	int			have_gt;
 	int			error;
 
-	while (*have && irec->rm_startblock == bno) {
-		struct rmap_for_refcount	rfr = {
-			.rm_startblock		= irec->rm_startblock,
-			.rm_blockcount		= irec->rm_blockcount,
-			.rm_owner		= irec->rm_owner,
-		};
+	while (*have && rmap->rm_startblock == bno) {
+		rcbag_add(stack, rmap);
 
-		rmap_dump(tag, agno, &rfr);
-		error = bag_add(stack_top, &rfr);
-		if (error)
-			return error;
-		error = refcount_walk_rmaps(rmcur, irec, have);
+		error = refcount_walk_rmaps(rmcur, rmap, have);
 		if (error)
 			return error;
 	}
@@ -961,11 +914,10 @@ compute_refcounts(
 	xfs_agnumber_t		agno)
 {
 	struct xfs_btree_cur	*rmcur;
-	struct xfs_rmap_irec	irec;
-	struct xfs_bag		*stack_top = NULL;
-	struct rmap_for_refcount *rfr;
-	uint64_t		idx;
-	uint64_t		old_stack_nr;
+	struct rcbag		*rcstack;
+	struct xfs_rmap_irec	rmap;
+	uint64_t		nr_rmaps;
+	uint64_t		old_stack_height;
 	xfs_agblock_t		sbno;	/* first bno of this rmap set */
 	xfs_agblock_t		cbno;	/* first bno of this refcount set */
 	xfs_agblock_t		nbno;	/* next bno where rmap set changes */
@@ -977,11 +929,13 @@ compute_refcounts(
 	if (!rmaps_has_observations(&ag_rmaps[agno]))
 		return 0;
 
+	nr_rmaps = rmap_record_count(mp, agno);
+
 	error = rmap_init_mem_cursor(mp, NULL, agno, &rmcur);
 	if (error)
 		return error;
 
-	error = init_bag(&stack_top, sizeof(struct rmap_for_refcount));
+	error = rcbag_init(mp, nr_rmaps, &rcstack);
 	if (error)
 		goto out_cur;
 
@@ -994,86 +948,72 @@ compute_refcounts(
 	/* Process reverse mappings into refcount data. */
 	while (libxfs_btree_has_more_records(rmcur)) {
 		/* Push all rmaps with pblk == sbno onto the stack */
-		error = refcount_walk_rmaps(rmcur, &irec, &have);
+		error = refcount_walk_rmaps(rmcur, &rmap, &have);
 		if (error)
 			goto out_bag;
 		if (!have)
 			break;
-		sbno = cbno = irec.rm_startblock;
-		error = refcount_push_rmaps_at(rmcur, agno, stack_top, sbno,
-				&irec, &have, "push0");
+		sbno = cbno = rmap.rm_startblock;
+		error = refcount_push_rmaps_at(rmcur, rcstack, sbno, &rmap,
+				&have, "push0");
 		if (error)
 			goto out_bag;
-		mark_inode_rl(mp, stack_top);
+		mark_reflink_inodes(mp, rcstack);
 
 		/* Set nbno to the bno of the next refcount change */
-		error = next_refcount_edge(stack_top, &irec, have, &nbno);
-		if (error)
-			goto out_bag;
+		rcbag_next_edge(rcstack, &rmap, have, &nbno);
 
 		/* Emit reverse mappings, if needed */
 		ASSERT(nbno > sbno);
-		old_stack_nr = bag_count(stack_top);
+		old_stack_height = rcbag_count(rcstack);
 
 		/* While stack isn't empty... */
-		while (bag_count(stack_top)) {
+		while (rcbag_count(rcstack) > 0) {
 			/* Pop all rmaps that end at nbno */
-			foreach_bag_ptr_reverse(stack_top, idx, rfr) {
-				if (RMAP_NEXT(rfr) != nbno)
-					continue;
-				rmap_dump("pop", agno, rfr);
-				error = bag_remove(stack_top, idx);
-				if (error)
-					goto out_bag;
-			}
+			rcbag_remove_ending_at(rcstack, nbno);
 
 			/* Push array items that start at nbno */
-			error = refcount_walk_rmaps(rmcur, &irec, &have);
+			error = refcount_walk_rmaps(rmcur, &rmap, &have);
 			if (error)
 				goto out_bag;
 			if (have) {
-				error = refcount_push_rmaps_at(rmcur, agno,
-						stack_top, nbno, &irec, &have,
-						"push1");
+				error = refcount_push_rmaps_at(rmcur, rcstack,
+						nbno, &rmap, &have, "push1");
 				if (error)
 					goto out_bag;
 			}
-			mark_inode_rl(mp, stack_top);
+			mark_reflink_inodes(mp, rcstack);
 
 			/* Emit refcount if necessary */
 			ASSERT(nbno > cbno);
-			if (bag_count(stack_top) != old_stack_nr) {
-				if (old_stack_nr > 1) {
+			if (rcbag_count(rcstack) != old_stack_height) {
+				if (old_stack_height > 1) {
 					refcount_emit(mp, agno, cbno,
-						      nbno - cbno,
-						      old_stack_nr);
+							nbno - cbno,
+							old_stack_height);
 				}
 				cbno = nbno;
 			}
 
 			/* Stack empty, go find the next rmap */
-			if (bag_count(stack_top) == 0)
+			if (rcbag_count(rcstack) == 0)
 				break;
-			old_stack_nr = bag_count(stack_top);
+			old_stack_height = rcbag_count(rcstack);
 			sbno = nbno;
 
 			/* Set nbno to the bno of the next refcount change */
-			error = next_refcount_edge(stack_top, &irec, have,
-					&nbno);
-			if (error)
-				goto out_bag;
+			rcbag_next_edge(rcstack, &rmap, have, &nbno);
 
 			/* Emit reverse mappings, if needed */
 			ASSERT(nbno > sbno);
 		}
 	}
 out_bag:
-	free_bag(&stack_top);
+	rcbag_free(&rcstack);
 out_cur:
 	libxfs_btree_del_cursor(rmcur, error);
 	return error;
 }
-#undef RMAP_NEXT
 
 static int
 count_btree_records(
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index f8c37c632..cf7749643 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -26,6 +26,7 @@
 #include "libfrog/platform.h"
 #include "bulkload.h"
 #include "quotacheck.h"
+#include "rcbag_btree.h"
 
 /*
  * option tables for getsubopt calls
@@ -1297,6 +1298,10 @@ main(int argc, char **argv)
 	phase3(mp, phase2_threads);
 	phase_end(mp, 3);
 
+	error = rcbagbt_init_cur_cache();
+	if (error)
+		do_error(_("could not allocate btree cursor memory\n"));
+
 	phase4(mp);
 	phase_end(mp, 4);
 
@@ -1309,6 +1314,7 @@ main(int argc, char **argv)
 		phase5(mp);
 	}
 	phase_end(mp, 5);
+	rcbagbt_destroy_cur_cache();
 
 	/*
 	 * Done with the block usage maps, toss them...

