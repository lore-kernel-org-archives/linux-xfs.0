Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38954BE66
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 22:23:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PQlDRUvK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F3EC433C7;
	Sun, 31 Dec 2023 22:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704061404;
	bh=1IvsX4IPp7nrpqk3554fAEtHMhttE8jDcQzEddx808c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PQlDRUvKtRDHgzomGAPVwtOR6Sd5LcuFCqhiMugGKS4gCm5LoSeCH7gaAWY8m9qhj
	 shp+T5XOSMg5TlFA7kntRPHcCoVGZLKMW4IxwWU/ug3ol3SzBQBk9ZjLKKDRtOEKiB
	 uu7eUdAFDWGBXkISw3NuSzv4M3ODGBfGlbBMaO7pAAjn5jq4w2rDMVjHaS2n9+AQk4
	 d6y6Nrdb7KGv0loCQ8pz/UKiUbTNhkd7yN0HBGapLT2iD5JcG6K7EOq1TezhImLjOZ
	 B+Kug/KjgKp5WQY/pJjRp3vLmwtvSF0d3Q+/4wPoX/Z5IH0Pju/CtchARnIXtazH9T
	 T61W5TO26myMg==
Date: Sun, 31 Dec 2023 14:23:24 -0800
Subject: [PATCH 5/6] xfs_repair: port to the new refcount bag structure
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404994491.1795402.5578754783675934274.stgit@frogsfrogsfrogs>
In-Reply-To: <170404994421.1795402.5021109335646815731.stgit@frogsfrogsfrogs>
References: <170404994421.1795402.5021109335646815731.stgit@frogsfrogsfrogs>
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
---
 repair/rmap.c       |  152 +++++++++++++++------------------------------------
 repair/xfs_repair.c |    6 ++
 2 files changed, 52 insertions(+), 106 deletions(-)


diff --git a/repair/rmap.c b/repair/rmap.c
index b338cdc3bea..cc1312c5d1c 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -16,6 +16,7 @@
 #include "libfrog/platform.h"
 #include "libxfs/xfile.h"
 #include "libxfs/xfbtree.h"
+#include "rcbag.h"
 
 #undef RMAP_DEBUG
 
@@ -759,35 +760,32 @@ rmap_dump(
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
@@ -823,8 +821,6 @@ refcount_emit(
 _("Insufficient memory while recreating refcount tree."));
 }
 
-#define RMAP_NEXT(r)	((r)->rm_startblock + (r)->rm_blockcount)
-
 /* Decide if an rmap could describe a shared extent. */
 static inline bool
 rmap_shareable(
@@ -884,40 +880,6 @@ refcount_walk_rmaps(
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
@@ -927,28 +889,19 @@ next_refcount_edge(
 static int
 refcount_push_rmaps_at(
 	struct rmap_mem_cur	*rmcur,
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
-		error = refcount_walk_rmaps(rmcur->mcur, irec, have);
+		error = refcount_walk_rmaps(rmcur->mcur, rmap, have);
 		if (error)
 			return error;
 	}
@@ -968,15 +921,14 @@ refcount_push_rmaps_at(
  */
 int
 compute_refcounts(
-	struct xfs_mount		*mp,
+	struct xfs_mount	*mp,
 	xfs_agnumber_t		agno)
 {
+	struct rcbag		*rcstack;
 	struct rmap_mem_cur	rmcur;
-	struct xfs_rmap_irec	irec;
-	struct xfs_bag		*stack_top = NULL;
-	struct rmap_for_refcount *rfr;
-	uint64_t		idx;
-	uint64_t		old_stack_nr;
+	struct xfs_rmap_irec	rmap;
+	uint64_t		nr_rmaps;
+	uint64_t		old_stack_height;
 	xfs_agblock_t		sbno;	/* first bno of this rmap set */
 	xfs_agblock_t		cbno;	/* first bno of this refcount set */
 	xfs_agblock_t		nbno;	/* next bno where rmap set changes */
@@ -988,11 +940,13 @@ compute_refcounts(
 	if (ag_rmaps[agno].ar_xfbtree == NULL)
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
 
@@ -1005,86 +959,72 @@ compute_refcounts(
 	/* Process reverse mappings into refcount data. */
 	while (libxfs_btree_has_more_records(rmcur.mcur)) {
 		/* Push all rmaps with pblk == sbno onto the stack */
-		error = refcount_walk_rmaps(rmcur.mcur, &irec, &have);
+		error = refcount_walk_rmaps(rmcur.mcur, &rmap, &have);
 		if (error)
 			goto out_bag;
 		if (!have)
 			break;
-		sbno = cbno = irec.rm_startblock;
-		error = refcount_push_rmaps_at(&rmcur, agno, stack_top, sbno,
-				&irec, &have, "push0");
+		sbno = cbno = rmap.rm_startblock;
+		error = refcount_push_rmaps_at(&rmcur, rcstack, sbno, &rmap,
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
-			error = refcount_walk_rmaps(rmcur.mcur, &irec, &have);
+			error = refcount_walk_rmaps(rmcur.mcur, &rmap, &have);
 			if (error)
 				goto out_bag;
 			if (have) {
-				error = refcount_push_rmaps_at(&rmcur, agno,
-						stack_top, nbno, &irec, &have,
-						"push1");
+				error = refcount_push_rmaps_at(&rmcur, rcstack,
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
 	rmap_free_mem_cursor(NULL, &rmcur, error);
 	return error;
 }
-#undef RMAP_NEXT
 
 static int
 count_btree_records(
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index ba78dc0b8ea..bf02beba375 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -26,6 +26,7 @@
 #include "libfrog/platform.h"
 #include "bulkload.h"
 #include "quotacheck.h"
+#include "rcbag_btree.h"
 
 /*
  * option tables for getsubopt calls
@@ -1259,6 +1260,10 @@ main(int argc, char **argv)
 	phase3(mp, phase2_threads);
 	phase_end(mp, 3);
 
+	error = rcbagbt_init_cur_cache();
+	if (error)
+		do_error(_("could not allocate btree cursor memory\n"));
+
 	phase4(mp);
 	phase_end(mp, 4);
 
@@ -1271,6 +1276,7 @@ main(int argc, char **argv)
 		phase5(mp);
 	}
 	phase_end(mp, 5);
+	rcbagbt_destroy_cur_cache();
 
 	/*
 	 * Done with the block usage maps, toss them...

