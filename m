Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6EA7C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:16:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235788AbiLaAQK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:16:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiLaAQI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:16:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5CFED2FB
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:16:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4492661CFF
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A65C433EF;
        Sat, 31 Dec 2022 00:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672445766;
        bh=qeXNhsw60/wHLjJzIB2pnq8PI1ZZTFCxgwbm+xK8NPM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ew2WtKViEAwgHXOjvSmiJwKprzz2n8N1VMAroB6UXBQwuF/tLofNTAbnaJLJpPeAG
         5UavUDLnjZ0Fro9jQ8XoZ78exjms3+l+kC0XRXuXTFEIeWwdxc02cyno9nsBNL3UQp
         shfs7xyEHCeYFyGDuLvb1DamGGTnn4uETDx4kTUkTFU9nIyCZdmEw7i4397q/2FDzR
         HfaL4EXgvFpmt0vsQxuusuPEvQ1T/pYCF55gpTRVyOn7fyNeFCZg52hyDJvYsE0j52
         pq0zj3S8/JLUm/p7UQRJIwYKnl5nSIai8gwUprQ6bxxX5k0tb0S4Y4Xj2S8iF+bsxc
         CPnDSbgvalPHw==
Subject: [PATCH 5/6] xfs_repair: reduce rmap bag memory usage when creating
 refcounts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:17:49 -0800
Message-ID: <167243866956.712584.15741057579594555921.stgit@magnolia>
In-Reply-To: <167243866890.712584.9795710743681868714.stgit@magnolia>
References: <167243866890.712584.9795710743681868714.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
---
 repair/rmap.c |   74 ++++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 44 insertions(+), 30 deletions(-)


diff --git a/repair/rmap.c b/repair/rmap.c
index 0a29a615afa..87123f5331d 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -35,6 +35,13 @@ struct xfs_ag_rmap {
 	struct xfs_slab	*ar_refcount_items;	/* refcount items, p4-5 */
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
@@ -786,16 +793,14 @@ static void
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
@@ -874,30 +879,33 @@ rmap_dump(
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
 
@@ -1006,15 +1014,15 @@ next_refcount_edge(
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
@@ -1049,8 +1057,14 @@ refcount_push_rmaps_at(
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
 		error = refcount_walk_rmaps(rmcur->mcur, irec, have);
@@ -1079,7 +1093,7 @@ compute_refcounts(
 	struct rmap_mem_cur	rmcur;
 	struct xfs_rmap_irec	irec;
 	struct xfs_bag		*stack_top = NULL;
-	struct xfs_rmap_irec	*rmap;
+	struct rmap_for_refcount *rfr;
 	uint64_t		idx;
 	uint64_t		old_stack_nr;
 	xfs_agblock_t		sbno;	/* first bno of this rmap set */
@@ -1095,7 +1109,7 @@ compute_refcounts(
 	if (error)
 		return error;
 
-	error = init_bag(&stack_top, sizeof(struct xfs_rmap_irec));
+	error = init_bag(&stack_top, sizeof(struct rmap_for_refcount));
 	if (error)
 		goto out_cur;
 
@@ -1132,10 +1146,10 @@ compute_refcounts(
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

