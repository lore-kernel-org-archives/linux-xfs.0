Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3545237E306
	for <linux-xfs@vger.kernel.org>; Wed, 21 Jan 2026 06:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768977509; cv=none; b=EQdCQs1Ly2RtPaYmhNZcsuOI2sdTNDKgCXkZ9fV0Gdlkmd+XthUdqaQIwtds/zsjwTduwdu0wCK3IpjB8LkQofdEVdbqoPvL2srIwdu3VU71MQvzBxk1pMMlDXaqYeXe1kPRLm4gtsXXk/armDQkmiMmcvKdYS95WsCFt0P5Zr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768977509; c=relaxed/simple;
	bh=IUZEwLwydaeaIp3zhz5J1KnSKnycDSVIbgr+NUQF/EE=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pxmn+yPXRXu5RuOUK9stgiIEiG4hpUNKDPhEypAU0S2EowjlX3nzOdPm5w3BZqsV+apDpBCfkZ7a5El/80WvZDeUPYpgWWQlPbGWm9oCKANCpzKN0PswsVSA9xnHSV1nxhvqaGg80Be7BiAU3Qv8MMiIVpAUfWxeoMN4LsImip8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SpBrN5uO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SpBrN5uO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7960C116D0;
	Wed, 21 Jan 2026 06:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768977508;
	bh=IUZEwLwydaeaIp3zhz5J1KnSKnycDSVIbgr+NUQF/EE=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SpBrN5uOudvgB2IULIgkYIlXxuGsM5pnZu6dSt5nq6kT/JCEMdsQVVtYUDe7ahMDz
	 CXuAxsK316WKPc189s3ARFp6CkPwbx3U6wkMVZ5iHE+9m92Yx1b7G5Md7fD/vRv5p1
	 DLB5KJl7xgeTMSltXPxXrBeVIQ8B6L3QxZt2D8coXgi6oFLR4JT/cgoB4ienOtqCZb
	 YiAQ6RNG5CH3jYb/fB8PeO5FIe8qDgJaRmlrHmr+6bmoN14laEj5V9DM0JzrbRIJBf
	 02Q6jZF+UZ+auma8Yoeei3GuML2qsD7akfz0OtKUBj19PyEogTHtnhIsuEGOMHfTR2
	 7bak7iWSuHT4w==
Date: Tue, 20 Jan 2026 22:38:28 -0800
Subject: [PATCH 3/6] xfs: refactor attr3 leaf table size computation
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176897695620.202569.7698466645036313818.stgit@frogsfrogsfrogs>
In-Reply-To: <176897695523.202569.10735226881884087217.stgit@frogsfrogsfrogs>
References: <176897695523.202569.10735226881884087217.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Replace all the open-coded callsites with a single static inline helper.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_da_format.h |    2 +
 fs/xfs/libxfs/xfs_attr_leaf.c |   57 +++++++++++++++++++++--------------------
 2 files changed, 30 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_da_format.h b/fs/xfs/libxfs/xfs_da_format.h
index 86de99e2f75707..7d55307e619fe9 100644
--- a/fs/xfs/libxfs/xfs_da_format.h
+++ b/fs/xfs/libxfs/xfs_da_format.h
@@ -746,7 +746,7 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_LEAF_NAME_ALIGN	((uint)sizeof(xfs_dablk_t))
 
 static inline int
-xfs_attr3_leaf_hdr_size(struct xfs_attr_leafblock *leafp)
+xfs_attr3_leaf_hdr_size(const struct xfs_attr_leafblock *leafp)
 {
 	if (leafp->hdr.info.magic == cpu_to_be16(XFS_ATTR3_LEAF_MAGIC))
 		return sizeof(struct xfs_attr3_leaf_hdr);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index b858e3c2ad50a2..776064eac5a090 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -75,6 +75,16 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
 			int move_count);
 STATIC int xfs_attr_leaf_entsize(xfs_attr_leafblock_t *leaf, int index);
 
+/* Compute the byte offset of the end of the leaf entry array. */
+static inline int
+xfs_attr_leaf_entries_end(
+	unsigned int			hdrcount,
+	const struct xfs_attr_leafblock	*leaf)
+{
+	return hdrcount * sizeof(struct xfs_attr_leaf_entry) +
+			xfs_attr3_leaf_hdr_size(leaf);
+}
+
 /*
  * attr3 block 'firstused' conversion helpers.
  *
@@ -1409,8 +1419,7 @@ xfs_attr3_leaf_add(
 	 * Search through freemap for first-fit on new name length.
 	 * (may need to figure in size of entry struct too)
 	 */
-	tablesize = (ichdr.count + 1) * sizeof(xfs_attr_leaf_entry_t)
-					+ xfs_attr3_leaf_hdr_size(leaf);
+	tablesize = xfs_attr_leaf_entries_end(ichdr.count + 1, leaf);
 	for (sum = 0, i = XFS_ATTR_LEAF_MAPSIZE - 1; i >= 0; i--) {
 		if (tablesize > ichdr.firstused) {
 			sum += ichdr.freemap[i].size;
@@ -1569,8 +1578,7 @@ xfs_attr3_leaf_add_work(
 	if (be16_to_cpu(entry->nameidx) < ichdr->firstused)
 		ichdr->firstused = be16_to_cpu(entry->nameidx);
 
-	new_end = ichdr->count * sizeof(struct xfs_attr_leaf_entry) +
-					xfs_attr3_leaf_hdr_size(leaf);
+	new_end = xfs_attr_leaf_entries_end(ichdr->count, leaf);
 	old_end = new_end - sizeof(struct xfs_attr_leaf_entry);
 
 	ASSERT(ichdr->firstused >= new_end);
@@ -1807,8 +1815,8 @@ xfs_attr3_leaf_rebalance(
 		/*
 		 * leaf2 is the destination, compact it if it looks tight.
 		 */
-		max  = ichdr2.firstused - xfs_attr3_leaf_hdr_size(leaf1);
-		max -= ichdr2.count * sizeof(xfs_attr_leaf_entry_t);
+		max = ichdr2.firstused -
+				xfs_attr_leaf_entries_end(ichdr2.count, leaf1);
 		if (space > max)
 			xfs_attr3_leaf_compact(args, &ichdr2, blk2->bp);
 
@@ -1836,8 +1844,8 @@ xfs_attr3_leaf_rebalance(
 		/*
 		 * leaf1 is the destination, compact it if it looks tight.
 		 */
-		max  = ichdr1.firstused - xfs_attr3_leaf_hdr_size(leaf1);
-		max -= ichdr1.count * sizeof(xfs_attr_leaf_entry_t);
+		max = ichdr1.firstused -
+				xfs_attr_leaf_entries_end(ichdr1.count, leaf1);
 		if (space > max)
 			xfs_attr3_leaf_compact(args, &ichdr1, blk1->bp);
 
@@ -2043,9 +2051,7 @@ xfs_attr3_leaf_toosmall(
 	blk = &state->path.blk[ state->path.active-1 ];
 	leaf = blk->bp->b_addr;
 	xfs_attr3_leaf_hdr_from_disk(state->args->geo, &ichdr, leaf);
-	bytes = xfs_attr3_leaf_hdr_size(leaf) +
-		ichdr.count * sizeof(xfs_attr_leaf_entry_t) +
-		ichdr.usedbytes;
+	bytes = xfs_attr_leaf_entries_end(ichdr.count, leaf) + ichdr.usedbytes;
 	if (bytes > (state->args->geo->blksize >> 1)) {
 		*action = 0;	/* blk over 50%, don't try to join */
 		return 0;
@@ -2103,9 +2109,8 @@ xfs_attr3_leaf_toosmall(
 		bytes = state->args->geo->blksize -
 			(state->args->geo->blksize >> 2) -
 			ichdr.usedbytes - ichdr2.usedbytes -
-			((ichdr.count + ichdr2.count) *
-					sizeof(xfs_attr_leaf_entry_t)) -
-			xfs_attr3_leaf_hdr_size(leaf);
+			xfs_attr_leaf_entries_end(ichdr.count + ichdr2.count,
+					leaf);
 
 		xfs_trans_brelse(state->args->trans, bp);
 		if (bytes >= 0)
@@ -2167,8 +2172,7 @@ xfs_attr3_leaf_remove(
 
 	ASSERT(ichdr.count > 0 && ichdr.count < args->geo->blksize / 8);
 	ASSERT(args->index >= 0 && args->index < ichdr.count);
-	ASSERT(ichdr.firstused >= ichdr.count * sizeof(*entry) +
-					xfs_attr3_leaf_hdr_size(leaf));
+	ASSERT(ichdr.firstused >= xfs_attr_leaf_entries_end(ichdr.count, leaf));
 
 	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
 
@@ -2181,8 +2185,7 @@ xfs_attr3_leaf_remove(
 	 *    find smallest free region in case we need to replace it,
 	 *    adjust any map that borders the entry table,
 	 */
-	tablesize = ichdr.count * sizeof(xfs_attr_leaf_entry_t)
-					+ xfs_attr3_leaf_hdr_size(leaf);
+	tablesize = xfs_attr_leaf_entries_end(ichdr.count, leaf);
 	tmp = ichdr.freemap[0].size;
 	before = after = -1;
 	smallest = XFS_ATTR_LEAF_MAPSIZE - 1;
@@ -2289,8 +2292,7 @@ xfs_attr3_leaf_remove(
 	 * Check if leaf is less than 50% full, caller may want to
 	 * "join" the leaf with a sibling if so.
 	 */
-	tmp = ichdr.usedbytes + xfs_attr3_leaf_hdr_size(leaf) +
-	      ichdr.count * sizeof(xfs_attr_leaf_entry_t);
+	tmp = ichdr.usedbytes + xfs_attr_leaf_entries_end(ichdr.count, leaf);
 
 	return tmp < args->geo->magicpct; /* leaf is < 37% full */
 }
@@ -2613,11 +2615,11 @@ xfs_attr3_leaf_moveents(
 	       ichdr_s->magic == XFS_ATTR3_LEAF_MAGIC);
 	ASSERT(ichdr_s->magic == ichdr_d->magic);
 	ASSERT(ichdr_s->count > 0 && ichdr_s->count < args->geo->blksize / 8);
-	ASSERT(ichdr_s->firstused >= (ichdr_s->count * sizeof(*entry_s))
-					+ xfs_attr3_leaf_hdr_size(leaf_s));
+	ASSERT(ichdr_s->firstused >=
+			xfs_attr_leaf_entries_end(ichdr_s->count, leaf_s));
 	ASSERT(ichdr_d->count < args->geo->blksize / 8);
-	ASSERT(ichdr_d->firstused >= (ichdr_d->count * sizeof(*entry_d))
-					+ xfs_attr3_leaf_hdr_size(leaf_d));
+	ASSERT(ichdr_d->firstused >=
+			xfs_attr_leaf_entries_end(ichdr_d->count, leaf_d));
 
 	ASSERT(start_s < ichdr_s->count);
 	ASSERT(start_d <= ichdr_d->count);
@@ -2677,8 +2679,7 @@ xfs_attr3_leaf_moveents(
 			ichdr_d->usedbytes += tmp;
 			ichdr_s->count -= 1;
 			ichdr_d->count += 1;
-			tmp = ichdr_d->count * sizeof(xfs_attr_leaf_entry_t)
-					+ xfs_attr3_leaf_hdr_size(leaf_d);
+			tmp = xfs_attr_leaf_entries_end(ichdr_d->count, leaf_d);
 			ASSERT(ichdr_d->firstused >= tmp);
 #ifdef GROT
 		}
@@ -2714,8 +2715,8 @@ xfs_attr3_leaf_moveents(
 	/*
 	 * Fill in the freemap information
 	 */
-	ichdr_d->freemap[0].base = xfs_attr3_leaf_hdr_size(leaf_d);
-	ichdr_d->freemap[0].base += ichdr_d->count * sizeof(xfs_attr_leaf_entry_t);
+	ichdr_d->freemap[0].base =
+		xfs_attr_leaf_entries_end(ichdr_d->count, leaf_d);
 	ichdr_d->freemap[0].size = ichdr_d->firstused - ichdr_d->freemap[0].base;
 	ichdr_d->freemap[1].base = 0;
 	ichdr_d->freemap[2].base = 0;

