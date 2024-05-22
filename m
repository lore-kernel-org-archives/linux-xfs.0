Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893F92C9D
	for <linux-xfs@vger.kernel.org>; Wed, 22 May 2024 03:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716348146; cv=none; b=mTLjcCg1EUJKstlK3YqgkUkH4LfUDfUbQjZt2b5GfOzBCvoKzT+ynEEMWuteDuQmmv76UHjs0UVG09Tl1Q1aVR87HtyopZRd9H2H1W3jgozGYzZ9qGbc2N581j/AC85DJjof++yEitT7twU+Y0xWy/y5Uc6JSp9z67RpjJD3sJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716348146; c=relaxed/simple;
	bh=ERfZSpqqP3dUJpWhiqfZq5NWZd1sdtP2ghwX/XjKE0s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dBNEy2u0EecUGdv/p8Ra+1QbsAN96x26ULW90QJUkGJl/QirYn4EnIQq8Yl9+eEQ+H2AGnviyVaDacE2R1hyV2hRgBnhrJtac/mPP5Ny6FK2wZq+U5fjOmTckEFC+tt/uOvYSvudz7m6gv20qTUFpjsiQXFQrHJusXKYri4NiPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ew2QtIid; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ew2QtIid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2DAC2BD11;
	Wed, 22 May 2024 03:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1716348146;
	bh=ERfZSpqqP3dUJpWhiqfZq5NWZd1sdtP2ghwX/XjKE0s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ew2QtIidvUgscV5ZS32qHd3CFurimgdxO3N6Ky0bBt34el6xUcK9Mve9R2kFIsU68
	 rr3r4c2ZgBZbWZR0tE/62amDDJIl7QiHtIJl/Pt/ZRGWEAW/m46nKPo9XId0T+gUR6
	 BuCVtSw9BL9CSCfOxOnbMI9IeZhJ4bznYEi5Oveb58cOiQgCxqR6oIJh2gBX8wnNTs
	 RS8Xjj4VLyQ4JOkO2gfXOrPB1mwwIfY1grcwzzFSUqOdoMdxhAnBVKmAndWon8hC72
	 lpAQtbyvvYFDBDgXub1gjj2LshFx4UKiDZyWym2FxsiwKroE8AWIA5tj1iJKVcVn3P
	 WTP0xuF2HzjtQ==
Date: Tue, 21 May 2024 20:22:25 -0700
Subject: [PATCH 5/6] xfs_repair: reduce rmap bag memory usage when creating
 refcounts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <171634535462.2483278.10385029560476840841.stgit@frogsfrogsfrogs>
In-Reply-To: <171634535383.2483278.14868148193055852399.stgit@frogsfrogsfrogs>
References: <171634535383.2483278.14868148193055852399.stgit@frogsfrogsfrogs>
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

The algorithm that computes reference count records uses a "bag"
structure to remember the rmap records corresponding to the current
block.  In the previous patch we converted the bag structure to store
actual rmap records instead of pointers to rmap records owned by another
structure as part of preparing for converting this algorithm to use
in-memory rmap btrees.

However, the memory usage of the bag structure is now excessive -- we
only need the physical extent and inode owner information to generate
refcount records and mark inodes that require the reflink flag.  IOWs,
the flags and offset fields are unnecessary.  Create a custom structure
for the bag, which halves its memory usage.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 repair/rmap.c |   74 ++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 30 deletions(-)


diff --git a/repair/rmap.c b/repair/rmap.c
index f58773cb3..f34e42300 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -46,6 +46,13 @@ struct xfs_ag_rmap {
 	struct xfs_slab		*ar_refcount_items;
 };
 
+/* Only the parts of struct xfs_rmap_irec that we need to compute refcounts. */
+struct rmap_for_refcount {
+	xfs_agblock_t	rm_startblock;
+	xfs_extlen_t	rm_blockcount;
+	uint64_t	rm_owner;
+};
+
 static struct xfs_ag_rmap *ag_rmaps;
 bool rmapbt_suspect;
 static bool refcbt_suspect;
@@ -777,16 +784,14 @@ static void
 rmap_dump(
 	const char		*msg,
 	xfs_agnumber_t		agno,
-	struct xfs_rmap_irec	*rmap)
+	const struct rmap_for_refcount *rfr)
 {
-	printf("%s: %p agno=%u pblk=%llu own=%lld lblk=%llu len=%u flags=0x%x\n",
-		msg, rmap,
+	printf("%s: %p agno=%u agbno=%llu owner=%lld fsbcount=%u\n",
+		msg, rfr,
 		(unsigned int)agno,
-		(unsigned long long)rmap->rm_startblock,
-		(unsigned long long)rmap->rm_owner,
-		(unsigned long long)rmap->rm_offset,
-		(unsigned int)rmap->rm_blockcount,
-		(unsigned int)rmap->rm_flags);
+		(unsigned long long)rfr->rm_startblock,
+		(unsigned long long)rfr->rm_owner,
+		(unsigned int)rfr->rm_blockcount);
 }
 #else
 # define rmap_dump(m, a, r)
@@ -865,30 +870,33 @@ rmap_dump(
  */
 static void
 mark_inode_rl(
-	struct xfs_mount		*mp,
+	struct xfs_mount	*mp,
 	struct xfs_bag		*rmaps)
 {
-	xfs_agnumber_t		iagno;
-	struct xfs_rmap_irec	*rmap;
+	struct rmap_for_refcount *rfr;
 	struct ino_tree_node	*irec;
 	int			off;
 	uint64_t		idx;
-	xfs_agino_t		ino;
 
 	if (bag_count(rmaps) < 2)
 		return;
 
 	/* Reflink flag accounting */
-	foreach_bag_ptr(rmaps, idx, rmap) {
-		ASSERT(!XFS_RMAP_NON_INODE_OWNER(rmap->rm_owner));
-		iagno = XFS_INO_TO_AGNO(mp, rmap->rm_owner);
-		ino = XFS_INO_TO_AGINO(mp, rmap->rm_owner);
-		pthread_mutex_lock(&ag_locks[iagno].lock);
-		irec = find_inode_rec(mp, iagno, ino);
-		off = get_inode_offset(mp, rmap->rm_owner, irec);
+	foreach_bag_ptr(rmaps, idx, rfr) {
+		xfs_agnumber_t	agno;
+		xfs_agino_t	agino;
+
+		ASSERT(!XFS_RMAP_NON_INODE_OWNER(rfr->rm_owner));
+
+		agno = XFS_INO_TO_AGNO(mp, rfr->rm_owner);
+		agino = XFS_INO_TO_AGINO(mp, rfr->rm_owner);
+
+		pthread_mutex_lock(&ag_locks[agno].lock);
+		irec = find_inode_rec(mp, agno, agino);
+		off = get_inode_offset(mp, rfr->rm_owner, irec);
 		/* lock here because we might go outside this ag */
 		set_inode_is_rl(irec, off);
-		pthread_mutex_unlock(&ag_locks[iagno].lock);
+		pthread_mutex_unlock(&ag_locks[agno].lock);
 	}
 }
 
@@ -996,15 +1004,15 @@ next_refcount_edge(
 	bool			next_valid,
 	xfs_agblock_t		*nbnop)
 {
-	struct xfs_rmap_irec	*rmap;
+	struct rmap_for_refcount *rfr;
 	uint64_t		idx;
 	xfs_agblock_t		nbno = NULLAGBLOCK;
 
 	if (next_valid)
 		nbno = next_rmap->rm_startblock;
 
-	foreach_bag_ptr(stack_top, idx, rmap)
-		nbno = min(nbno, RMAP_NEXT(rmap));
+	foreach_bag_ptr(stack_top, idx, rfr)
+		nbno = min(nbno, RMAP_NEXT(rfr));
 
 	/*
 	 * We should have found /something/ because either next_rrm is the next
@@ -1039,8 +1047,14 @@ refcount_push_rmaps_at(
 	int			error;
 
 	while (*have && irec->rm_startblock == bno) {
-		rmap_dump(tag, agno, irec);
-		error = bag_add(stack_top, irec);
+		struct rmap_for_refcount	rfr = {
+			.rm_startblock		= irec->rm_startblock,
+			.rm_blockcount		= irec->rm_blockcount,
+			.rm_owner		= irec->rm_owner,
+		};
+
+		rmap_dump(tag, agno, &rfr);
+		error = bag_add(stack_top, &rfr);
 		if (error)
 			return error;
 		error = refcount_walk_rmaps(rmcur, irec, have);
@@ -1069,7 +1083,7 @@ compute_refcounts(
 	struct xfs_btree_cur	*rmcur;
 	struct xfs_rmap_irec	irec;
 	struct xfs_bag		*stack_top = NULL;
-	struct xfs_rmap_irec	*rmap;
+	struct rmap_for_refcount *rfr;
 	uint64_t		idx;
 	uint64_t		old_stack_nr;
 	xfs_agblock_t		sbno;	/* first bno of this rmap set */
@@ -1085,7 +1099,7 @@ compute_refcounts(
 	if (error)
 		return error;
 
-	error = init_bag(&stack_top, sizeof(struct xfs_rmap_irec));
+	error = init_bag(&stack_top, sizeof(struct rmap_for_refcount));
 	if (error)
 		goto out_cur;
 
@@ -1122,10 +1136,10 @@ compute_refcounts(
 		/* While stack isn't empty... */
 		while (bag_count(stack_top)) {
 			/* Pop all rmaps that end at nbno */
-			foreach_bag_ptr_reverse(stack_top, idx, rmap) {
-				if (RMAP_NEXT(rmap) != nbno)
+			foreach_bag_ptr_reverse(stack_top, idx, rfr) {
+				if (RMAP_NEXT(rfr) != nbno)
 					continue;
-				rmap_dump("pop", agno, rmap);
+				rmap_dump("pop", agno, rfr);
 				error = bag_remove(stack_top, idx);
 				if (error)
 					goto out_bag;

