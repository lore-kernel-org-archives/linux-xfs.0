Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 001A719C540
	for <linux-xfs@vger.kernel.org>; Tue,  3 Mar 2026 00:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772497044; cv=none; b=XK0/w+9/i1qSZkAgAFwkPg/oqAukfYGf/KkxdDmvPzrVWtQfUIRP/XIBaA8/2uqQud5nTfrejBLkmYTqDHFDBDF0X48fgmnHYTxOdj8AIBSr0sByEU+6UkSDCmLfYcRJY+pgvshYh1N14bU55h3+K+PBpP6XXULFfH/PYhAe2C8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772497044; c=relaxed/simple;
	bh=IIQ1ht0oJraPhTHw1B9ABdTKJdrQOWZ15I/QtLAji8s=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mq6GPn8dyeZCE+k22I6xdlGPtptfEaHcALTH9G/XNNH6NW/UBrqX/y7pQluuM6aEE/WlfIHXM7K5KcsEKULrVZAnnNUFvNKljXShNq6wU3sYA4cMZIUxGTqZLBQzihZ6abUUr0xwm555U3DWeC2WPHu5CKLulFaDZSyavbJ08SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dEN8MxXy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dEN8MxXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A626C19423;
	Tue,  3 Mar 2026 00:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772497043;
	bh=IIQ1ht0oJraPhTHw1B9ABdTKJdrQOWZ15I/QtLAji8s=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=dEN8MxXyVFhrd16dPEeyrNLI9hJROMLIYbY7r+MtLN6HXOztbqhW0u6Yk6LBt47Rd
	 g0R9FqBNZrwvZ3shzFGivrdTmHEsvO/wxxYcCDm1DzyToznv5NmHW83RyHCM3YUF2z
	 FubpSj/l9uBxwcEd85L+v/ElDPsAqg0Q9YEgXbp5MeEPGF2U2PTpfas3VJteWb5bZl
	 IV93wIn1GWuh2YEYE0tEfL8mlEreWnBwYAoxh3esnDPMTY3kbpqKjzAsUBPPGNyuCr
	 rGAGkFf7MBSEt9CnIKRP0q+8m1CdKx59fVJyHAVsf6BY1LrUKvq6wSi5lOoXGLx8qb
	 tvrkeKmgm0fwg==
Date: Mon, 02 Mar 2026 16:17:22 -0800
Subject: [PATCH 20/36] xfs: refactor attr3 leaf table size computation
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <177249638146.457970.4355578825436469662.stgit@frogsfrogsfrogs>
In-Reply-To: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
References: <177249637597.457970.8500158485809720053.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: a165f7e7633ee0d83926d29e7909fdd8dd4dfadc

Replace all the open-coded callsites with a single static inline helper.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_da_format.h |    2 +-
 libxfs/xfs_attr_leaf.c |   57 ++++++++++++++++++++++++------------------------
 2 files changed, 30 insertions(+), 29 deletions(-)


diff --git a/libxfs/xfs_da_format.h b/libxfs/xfs_da_format.h
index 86de99e2f75707..7d55307e619fe9 100644
--- a/libxfs/xfs_da_format.h
+++ b/libxfs/xfs_da_format.h
@@ -746,7 +746,7 @@ struct xfs_attr3_leafblock {
 #define	XFS_ATTR_LEAF_NAME_ALIGN	((uint)sizeof(xfs_dablk_t))
 
 static inline int
-xfs_attr3_leaf_hdr_size(struct xfs_attr_leafblock *leafp)
+xfs_attr3_leaf_hdr_size(const struct xfs_attr_leafblock *leafp)
 {
 	if (leafp->hdr.info.magic == cpu_to_be16(XFS_ATTR3_LEAF_MAGIC))
 		return sizeof(struct xfs_attr3_leaf_hdr);
diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c
index b8aea9d73c0e4e..158864249c8888 100644
--- a/libxfs/xfs_attr_leaf.c
+++ b/libxfs/xfs_attr_leaf.c
@@ -72,6 +72,16 @@ STATIC void xfs_attr3_leaf_moveents(struct xfs_da_args *args,
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
@@ -1406,8 +1416,7 @@ xfs_attr3_leaf_add(
 	 * Search through freemap for first-fit on new name length.
 	 * (may need to figure in size of entry struct too)
 	 */
-	tablesize = (ichdr.count + 1) * sizeof(xfs_attr_leaf_entry_t)
-					+ xfs_attr3_leaf_hdr_size(leaf);
+	tablesize = xfs_attr_leaf_entries_end(ichdr.count + 1, leaf);
 	for (sum = 0, i = XFS_ATTR_LEAF_MAPSIZE - 1; i >= 0; i--) {
 		if (tablesize > ichdr.firstused) {
 			sum += ichdr.freemap[i].size;
@@ -1566,8 +1575,7 @@ xfs_attr3_leaf_add_work(
 	if (be16_to_cpu(entry->nameidx) < ichdr->firstused)
 		ichdr->firstused = be16_to_cpu(entry->nameidx);
 
-	new_end = ichdr->count * sizeof(struct xfs_attr_leaf_entry) +
-					xfs_attr3_leaf_hdr_size(leaf);
+	new_end = xfs_attr_leaf_entries_end(ichdr->count, leaf);
 	old_end = new_end - sizeof(struct xfs_attr_leaf_entry);
 
 	ASSERT(ichdr->firstused >= new_end);
@@ -1804,8 +1812,8 @@ xfs_attr3_leaf_rebalance(
 		/*
 		 * leaf2 is the destination, compact it if it looks tight.
 		 */
-		max  = ichdr2.firstused - xfs_attr3_leaf_hdr_size(leaf1);
-		max -= ichdr2.count * sizeof(xfs_attr_leaf_entry_t);
+		max = ichdr2.firstused -
+				xfs_attr_leaf_entries_end(ichdr2.count, leaf1);
 		if (space > max)
 			xfs_attr3_leaf_compact(args, &ichdr2, blk2->bp);
 
@@ -1833,8 +1841,8 @@ xfs_attr3_leaf_rebalance(
 		/*
 		 * leaf1 is the destination, compact it if it looks tight.
 		 */
-		max  = ichdr1.firstused - xfs_attr3_leaf_hdr_size(leaf1);
-		max -= ichdr1.count * sizeof(xfs_attr_leaf_entry_t);
+		max = ichdr1.firstused -
+				xfs_attr_leaf_entries_end(ichdr1.count, leaf1);
 		if (space > max)
 			xfs_attr3_leaf_compact(args, &ichdr1, blk1->bp);
 
@@ -2040,9 +2048,7 @@ xfs_attr3_leaf_toosmall(
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
@@ -2100,9 +2106,8 @@ xfs_attr3_leaf_toosmall(
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
@@ -2164,8 +2169,7 @@ xfs_attr3_leaf_remove(
 
 	ASSERT(ichdr.count > 0 && ichdr.count < args->geo->blksize / 8);
 	ASSERT(args->index >= 0 && args->index < ichdr.count);
-	ASSERT(ichdr.firstused >= ichdr.count * sizeof(*entry) +
-					xfs_attr3_leaf_hdr_size(leaf));
+	ASSERT(ichdr.firstused >= xfs_attr_leaf_entries_end(ichdr.count, leaf));
 
 	entry = &xfs_attr3_leaf_entryp(leaf)[args->index];
 
@@ -2178,8 +2182,7 @@ xfs_attr3_leaf_remove(
 	 *    find smallest free region in case we need to replace it,
 	 *    adjust any map that borders the entry table,
 	 */
-	tablesize = ichdr.count * sizeof(xfs_attr_leaf_entry_t)
-					+ xfs_attr3_leaf_hdr_size(leaf);
+	tablesize = xfs_attr_leaf_entries_end(ichdr.count, leaf);
 	tmp = ichdr.freemap[0].size;
 	before = after = -1;
 	smallest = XFS_ATTR_LEAF_MAPSIZE - 1;
@@ -2286,8 +2289,7 @@ xfs_attr3_leaf_remove(
 	 * Check if leaf is less than 50% full, caller may want to
 	 * "join" the leaf with a sibling if so.
 	 */
-	tmp = ichdr.usedbytes + xfs_attr3_leaf_hdr_size(leaf) +
-	      ichdr.count * sizeof(xfs_attr_leaf_entry_t);
+	tmp = ichdr.usedbytes + xfs_attr_leaf_entries_end(ichdr.count, leaf);
 
 	return tmp < args->geo->magicpct; /* leaf is < 37% full */
 }
@@ -2610,11 +2612,11 @@ xfs_attr3_leaf_moveents(
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
@@ -2674,8 +2676,7 @@ xfs_attr3_leaf_moveents(
 			ichdr_d->usedbytes += tmp;
 			ichdr_s->count -= 1;
 			ichdr_d->count += 1;
-			tmp = ichdr_d->count * sizeof(xfs_attr_leaf_entry_t)
-					+ xfs_attr3_leaf_hdr_size(leaf_d);
+			tmp = xfs_attr_leaf_entries_end(ichdr_d->count, leaf_d);
 			ASSERT(ichdr_d->firstused >= tmp);
 #ifdef GROT
 		}
@@ -2711,8 +2712,8 @@ xfs_attr3_leaf_moveents(
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

