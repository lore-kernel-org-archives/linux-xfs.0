Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4737BC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:42:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbiL3Wmf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:42:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235643AbiL3Wme (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:42:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7247917058
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:42:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F398461C15
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 586BAC433D2;
        Fri, 30 Dec 2022 22:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440151;
        bh=JmLsEWxp5dVqB+Tpw/Tr2kmHzgTfl9z48IWGfq/EeqA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TGxoB/QFxgqjqehSjsSSG61i//DclGQMT5n3QUPfaf0kdxt0JDPC0EFizWjzTqjiJ
         AmA90MQaryzrgfEW7qugKcNFuliNI1OY+gpSYQsu5z+eioP4p6fwp8uXsKGrT3gfh6
         1iOBOZLfTkl87/iHE++wV3r6eHXT9Rgr0i6wAkOJMkmETdnZ0mzecBwu7IQml/u8Oz
         SD4mWzcTh41CAEDyPqYGX5RwhbUDE6A3AiLUUZv/FmOYFEOOo+a9IsJxCpzQZNUHGM
         78iFo2mIuI1FJ5zvliHeOjoLjpub/uGi+c/OEYvrCpbspFDXmAhZ59QR8TpKoWQ2i7
         TshQpI5zJT3Vg==
Subject: [PATCH 3/6] xfs: replace xfs_btree_has_record with a general keyspace
 scanner
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:25 -0800
Message-ID: <167243828553.684405.15179826032508718113.stgit@magnolia>
In-Reply-To: <167243828503.684405.18151259725784634316.stgit@magnolia>
References: <167243828503.684405.18151259725784634316.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The current implementation of xfs_btree_has_record returns true if it
finds /any/ record within the given range.  Unfortunately, that's not
sufficient for scrub.  We want to be able to tell if a range of keyspace
for a btree is devoid of records, is totally mapped to records, or is
somewhere in between.  By forcing this to be a boolean, we conflated
sparseness and fullness, which caused scrub to return incorrect results.
Fix the API so that we can tell the caller which of those three is the
current state.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c          |   11 ++--
 fs/xfs/libxfs/xfs_alloc.h          |    4 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |   12 ++++
 fs/xfs/libxfs/xfs_bmap_btree.c     |   11 ++++
 fs/xfs/libxfs/xfs_btree.c          |  108 ++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_btree.h          |   44 ++++++++++++++-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   12 ++++
 fs/xfs/libxfs/xfs_refcount.c       |   11 ++--
 fs/xfs/libxfs/xfs_refcount.h       |    4 +
 fs/xfs/libxfs/xfs_refcount_btree.c |   11 ++++
 fs/xfs/libxfs/xfs_rmap.c           |   12 +++-
 fs/xfs/libxfs/xfs_rmap.h           |    4 +
 fs/xfs/libxfs/xfs_rmap_btree.c     |   16 +++++
 fs/xfs/libxfs/xfs_types.h          |   12 ++++
 fs/xfs/scrub/alloc.c               |    6 +-
 fs/xfs/scrub/refcount.c            |    8 +--
 fs/xfs/scrub/rmap.c                |    6 +-
 17 files changed, 249 insertions(+), 43 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 8dcefff1db33..31f61d88878d 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3530,13 +3530,16 @@ xfs_alloc_query_all(
 	return xfs_btree_query_all(cur, xfs_alloc_query_range_helper, &query);
 }
 
-/* Is there a record covering a given extent? */
+/*
+ * Scan part of the keyspace of the free space and tell us if the area has no
+ * records, is fully mapped by records, or is partially filled.
+ */
 int
-xfs_alloc_has_record(
+xfs_alloc_has_records(
 	struct xfs_btree_cur	*cur,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
-	bool			*exists)
+	enum xbtree_recpacking	*outcome)
 {
 	union xfs_btree_irec	low;
 	union xfs_btree_irec	high;
@@ -3546,7 +3549,7 @@ xfs_alloc_has_record(
 	memset(&high, 0xFF, sizeof(high));
 	high.a.ar_startblock = bno + len - 1;
 
-	return xfs_btree_has_record(cur, &low, &high, exists);
+	return xfs_btree_has_records(cur, &low, &high, outcome);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index becd06e5d0b8..6d17f8d36a37 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -202,8 +202,8 @@ int xfs_alloc_query_range(struct xfs_btree_cur *cur,
 int xfs_alloc_query_all(struct xfs_btree_cur *cur, xfs_alloc_query_range_fn fn,
 		void *priv);
 
-int xfs_alloc_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, bool *exist);
+int xfs_alloc_has_records(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, enum xbtree_recpacking *outcome);
 
 typedef int (*xfs_agfl_walk_fn)(struct xfs_mount *mp, xfs_agblock_t bno,
 		void *priv);
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 0e78e00e02f9..46fe70ab0a0e 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -423,6 +423,16 @@ xfs_cntbt_recs_inorder(
 		 be32_to_cpu(r2->alloc.ar_startblock));
 }
 
+STATIC enum xbtree_key_contig
+xfs_allocbt_keys_contiguous(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2)
+{
+	return xbtree_key_contig(be32_to_cpu(key1->alloc.ar_startblock),
+				 be32_to_cpu(key2->alloc.ar_startblock));
+}
+
 static const struct xfs_btree_ops xfs_bnobt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
@@ -443,6 +453,7 @@ static const struct xfs_btree_ops xfs_bnobt_ops = {
 	.diff_two_keys		= xfs_bnobt_diff_two_keys,
 	.keys_inorder		= xfs_bnobt_keys_inorder,
 	.recs_inorder		= xfs_bnobt_recs_inorder,
+	.keys_contiguous	= xfs_allocbt_keys_contiguous,
 };
 
 static const struct xfs_btree_ops xfs_cntbt_ops = {
@@ -465,6 +476,7 @@ static const struct xfs_btree_ops xfs_cntbt_ops = {
 	.diff_two_keys		= xfs_cntbt_diff_two_keys,
 	.keys_inorder		= xfs_cntbt_keys_inorder,
 	.recs_inorder		= xfs_cntbt_recs_inorder,
+	.keys_contiguous	= NULL, /* not needed right now */
 };
 
 /* Allocate most of a new allocation btree cursor. */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index cfa052d40105..45b5696fe8cb 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -518,6 +518,16 @@ xfs_bmbt_recs_inorder(
 		xfs_bmbt_disk_get_startoff(&r2->bmbt);
 }
 
+STATIC enum xbtree_key_contig
+xfs_bmbt_keys_contiguous(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2)
+{
+	return xbtree_key_contig(be64_to_cpu(key1->bmbt.br_startoff),
+				 be64_to_cpu(key2->bmbt.br_startoff));
+}
+
 static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
@@ -538,6 +548,7 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.buf_ops		= &xfs_bmbt_buf_ops,
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
+	.keys_contiguous	= xfs_bmbt_keys_contiguous,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 7661d5bc1650..2258af10e41a 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -5011,34 +5011,116 @@ xfs_btree_diff_two_ptrs(
 	return (int64_t)be32_to_cpu(a->s) - be32_to_cpu(b->s);
 }
 
-/* If there's an extent, we're done. */
+struct xfs_btree_has_records {
+	/* Keys for the start and end of the range we want to know about. */
+	union xfs_btree_key		start_key;
+	union xfs_btree_key		end_key;
+
+	/* Highest record key we've seen so far. */
+	union xfs_btree_key		high_key;
+
+	enum xbtree_recpacking		outcome;
+};
+
 STATIC int
-xfs_btree_has_record_helper(
+xfs_btree_has_records_helper(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_rec	*rec,
 	void				*priv)
 {
-	return -ECANCELED;
+	union xfs_btree_key		rec_key;
+	union xfs_btree_key		rec_high_key;
+	struct xfs_btree_has_records	*info = priv;
+	enum xbtree_key_contig		key_contig;
+
+	cur->bc_ops->init_key_from_rec(&rec_key, rec);
+
+	if (info->outcome == XBTREE_RECPACKING_EMPTY) {
+		info->outcome = XBTREE_RECPACKING_SPARSE;
+
+		/*
+		 * If the first record we find does not overlap the start key,
+		 * then there is a hole at the start of the search range.
+		 * Classify this as sparse and stop immediately.
+		 */
+		if (xfs_btree_keycmp_lt(cur, &info->start_key, &rec_key))
+			return -ECANCELED;
+	} else {
+		/*
+		 * If a subsequent record does not overlap with the any record
+		 * we've seen so far, there is a hole in the middle of the
+		 * search range.  Classify this as sparse and stop.
+		 * If the keys overlap and this btree does not allow overlap,
+		 * signal corruption.
+		 */
+		key_contig = cur->bc_ops->keys_contiguous(cur, &info->high_key,
+					&rec_key);
+		if (key_contig == XBTREE_KEY_OVERLAP &&
+				!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
+			return -EFSCORRUPTED;
+		if (key_contig == XBTREE_KEY_GAP)
+			return -ECANCELED;
+	}
+
+	/*
+	 * If high_key(rec) is larger than any other high key we've seen,
+	 * remember it for later.
+	 */
+	cur->bc_ops->init_high_key_from_rec(&rec_high_key, rec);
+	if (xfs_btree_keycmp_gt(cur, &rec_high_key, &info->high_key))
+		info->high_key = rec_high_key; /* struct copy */
+
+	return 0;
 }
 
-/* Is there a record covering a given range of keys? */
+/*
+ * Scan part of the keyspace of a btree and tell us if that keyspace does not
+ * map to any records; is fully mapped to records; or is partially mapped to
+ * records.  This is the btree record equivalent to determining if a file is
+ * sparse.
+ */
 int
-xfs_btree_has_record(
+xfs_btree_has_records(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_irec	*low,
 	const union xfs_btree_irec	*high,
-	bool				*exists)
+	enum xbtree_recpacking		*outcome)
 {
+	struct xfs_btree_has_records	info = {
+		.outcome		= XBTREE_RECPACKING_EMPTY,
+	};
 	int				error;
 
+	/* Not all btrees support this operation. */
+	if (!cur->bc_ops->keys_contiguous) {
+		ASSERT(0);
+		return -EOPNOTSUPP;
+	}
+
+	xfs_btree_key_from_irec(cur, &info.start_key, low);
+	xfs_btree_key_from_irec(cur, &info.end_key, high);
+
 	error = xfs_btree_query_range(cur, low, high,
-			&xfs_btree_has_record_helper, NULL);
-	if (error == -ECANCELED) {
-		*exists = true;
-		return 0;
-	}
-	*exists = false;
-	return error;
+			xfs_btree_has_records_helper, &info);
+	if (error == -ECANCELED)
+		goto out;
+	if (error)
+		return error;
+
+	if (info.outcome == XBTREE_RECPACKING_EMPTY)
+		goto out;
+
+	/*
+	 * If the largest high_key(rec) we saw during the walk is greater than
+	 * the end of the search range, classify this as full.  Otherwise,
+	 * there is a hole at the end of the search range.
+	 */
+	if (xfs_btree_keycmp_ge(cur, &info.high_key, &info.end_key))
+		info.outcome = XBTREE_RECPACKING_FULL;
+
+out:
+	*outcome = info.outcome;
+	return 0;
 }
 
 /* Are there more records in this btree? */
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index f5aa4b893ee7..66431f351bb2 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -90,6 +90,27 @@ uint32_t xfs_btree_magic(int crc, xfs_btnum_t btnum);
 #define XFS_BTREE_STATS_ADD(cur, stat, val)	\
 	XFS_STATS_ADD_OFF((cur)->bc_mp, (cur)->bc_statoff + __XBTS_ ## stat, val)
 
+enum xbtree_key_contig {
+	XBTREE_KEY_GAP = 0,
+	XBTREE_KEY_CONTIGUOUS,
+	XBTREE_KEY_OVERLAP,
+};
+
+/*
+ * Decide if these two numeric btree key fields are contiguous, overlapping,
+ * or if there's a gap between them.  @x should be the field from the high
+ * key and @y should be the field from the low key.
+ */
+static inline enum xbtree_key_contig xbtree_key_contig(uint64_t x, uint64_t y)
+{
+	x++;
+	if (x < y)
+		return XBTREE_KEY_GAP;
+	if (x == y)
+		return XBTREE_KEY_CONTIGUOUS;
+	return XBTREE_KEY_OVERLAP;
+}
+
 struct xfs_btree_ops {
 	/* size of the key and record structures */
 	size_t	key_len;
@@ -157,6 +178,19 @@ struct xfs_btree_ops {
 	int	(*recs_inorder)(struct xfs_btree_cur *cur,
 				const union xfs_btree_rec *r1,
 				const union xfs_btree_rec *r2);
+
+	/*
+	 * Are these two btree keys immediately adjacent?
+	 *
+	 * Given two btree keys @key1 and @key2, decide if it is impossible for
+	 * there to be a third btree key K satisfying the relationship
+	 * @key1 < K < @key2.  To determine if two btree records are
+	 * immediately adjacent, @key1 should be the high key of the first
+	 * record and @key2 should be the low key of the second record.
+	 */
+	enum xbtree_key_contig (*keys_contiguous)(struct xfs_btree_cur *cur,
+			       const union xfs_btree_key *key1,
+			       const union xfs_btree_key *key2);
 };
 
 /*
@@ -540,9 +574,15 @@ void xfs_btree_get_keys(struct xfs_btree_cur *cur,
 		struct xfs_btree_block *block, union xfs_btree_key *key);
 union xfs_btree_key *xfs_btree_high_key_from_key(struct xfs_btree_cur *cur,
 		union xfs_btree_key *key);
-int xfs_btree_has_record(struct xfs_btree_cur *cur,
+typedef bool (*xfs_btree_key_gap_fn)(struct xfs_btree_cur *cur,
+		const union xfs_btree_key *key1,
+		const union xfs_btree_key *key2);
+
+int xfs_btree_has_records(struct xfs_btree_cur *cur,
 		const union xfs_btree_irec *low,
-		const union xfs_btree_irec *high, bool *exists);
+		const union xfs_btree_irec *high,
+		enum xbtree_recpacking *outcome);
+
 bool xfs_btree_has_more_records(struct xfs_btree_cur *cur);
 struct xfs_ifork *xfs_btree_ifork_ptr(struct xfs_btree_cur *cur);
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index e849faae405a..e59bd6d3db03 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -383,6 +383,16 @@ xfs_inobt_recs_inorder(
 		be32_to_cpu(r2->inobt.ir_startino);
 }
 
+STATIC enum xbtree_key_contig
+xfs_inobt_keys_contiguous(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2)
+{
+	return xbtree_key_contig(be32_to_cpu(key1->inobt.ir_startino),
+				 be32_to_cpu(key2->inobt.ir_startino));
+}
+
 static const struct xfs_btree_ops xfs_inobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
@@ -402,6 +412,7 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
 	.diff_two_keys		= xfs_inobt_diff_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
+	.keys_contiguous	= xfs_inobt_keys_contiguous,
 };
 
 static const struct xfs_btree_ops xfs_finobt_ops = {
@@ -423,6 +434,7 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
 	.diff_two_keys		= xfs_inobt_diff_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
+	.keys_contiguous	= xfs_inobt_keys_contiguous,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 335f84bef81c..94377b59ba44 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1998,14 +1998,17 @@ xfs_refcount_recover_cow_leftovers(
 	return error;
 }
 
-/* Is there a record covering a given extent? */
+/*
+ * Scan part of the keyspace of the refcount records and tell us if the area
+ * has no records, is fully mapped by records, or is partially filled.
+ */
 int
-xfs_refcount_has_record(
+xfs_refcount_has_records(
 	struct xfs_btree_cur	*cur,
 	enum xfs_refc_domain	domain,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
-	bool			*exists)
+	enum xbtree_recpacking	*outcome)
 {
 	union xfs_btree_irec	low;
 	union xfs_btree_irec	high;
@@ -2016,7 +2019,7 @@ xfs_refcount_has_record(
 	high.rc.rc_startblock = bno + len - 1;
 	low.rc.rc_domain = high.rc.rc_domain = domain;
 
-	return xfs_btree_has_record(cur, &low, &high, exists);
+	return xfs_btree_has_records(cur, &low, &high, outcome);
 }
 
 int __init
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index fc0b58d4c379..783cd89ca195 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -111,9 +111,9 @@ extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
  */
 #define XFS_REFCOUNT_ITEM_OVERHEAD	32
 
-extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
+extern int xfs_refcount_has_records(struct xfs_btree_cur *cur,
 		enum xfs_refc_domain domain, xfs_agblock_t bno,
-		xfs_extlen_t len, bool *exists);
+		xfs_extlen_t len, enum xbtree_recpacking *outcome);
 union xfs_btree_rec;
 extern void xfs_refcount_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_refcount_irec *irec);
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index f5bdac3cf19f..26e28ac24238 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -300,6 +300,16 @@ xfs_refcountbt_recs_inorder(
 		be32_to_cpu(r2->refc.rc_startblock);
 }
 
+STATIC enum xbtree_key_contig
+xfs_refcountbt_keys_contiguous(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2)
+{
+	return xbtree_key_contig(be32_to_cpu(key1->refc.rc_startblock),
+				 be32_to_cpu(key2->refc.rc_startblock));
+}
+
 static const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
 	.key_len		= sizeof(struct xfs_refcount_key),
@@ -319,6 +329,7 @@ static const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.diff_two_keys		= xfs_refcountbt_diff_two_keys,
 	.keys_inorder		= xfs_refcountbt_keys_inorder,
 	.recs_inorder		= xfs_refcountbt_recs_inorder,
+	.keys_contiguous	= xfs_refcountbt_keys_contiguous,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index da008d317f83..e616b964f11c 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2709,13 +2709,17 @@ xfs_rmap_compare(
 		return 0;
 }
 
-/* Is there a record covering a given extent? */
+/*
+ * Scan the physical storage part of the keyspace of the reverse mapping index
+ * and tell us if the area has no records, is fully mapped by records, or is
+ * partially filled.
+ */
 int
-xfs_rmap_has_record(
+xfs_rmap_has_records(
 	struct xfs_btree_cur	*cur,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
-	bool			*exists)
+	enum xbtree_recpacking	*outcome)
 {
 	union xfs_btree_irec	low;
 	union xfs_btree_irec	high;
@@ -2725,7 +2729,7 @@ xfs_rmap_has_record(
 	memset(&high, 0xFF, sizeof(high));
 	high.r.rm_startblock = bno + len - 1;
 
-	return xfs_btree_has_record(cur, &low, &high, exists);
+	return xfs_btree_has_records(cur, &low, &high, outcome);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 7fb298bcc15f..4cbe50cf522e 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -198,8 +198,8 @@ xfs_failaddr_t xfs_rmap_btrec_to_irec(const union xfs_btree_rec *rec,
 xfs_failaddr_t xfs_rmap_check_irec(struct xfs_btree_cur *cur,
 		const struct xfs_rmap_irec *irec);
 
-int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, bool *exists);
+int xfs_rmap_has_records(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, enum xbtree_recpacking *outcome);
 int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, const struct xfs_owner_info *oinfo,
 		bool *has_rmap);
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index e18f89a68da9..1733865026d4 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -444,6 +444,21 @@ xfs_rmapbt_recs_inorder(
 	return 0;
 }
 
+STATIC enum xbtree_key_contig
+xfs_rmapbt_keys_contiguous(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2)
+{
+	/*
+	 * We only support checking contiguity of the physical space component.
+	 * If any callers ever need more specificity than that, they'll have to
+	 * implement it here.
+	 */
+	return xbtree_key_contig(be32_to_cpu(key1->rmap.rm_startblock),
+				 be32_to_cpu(key2->rmap.rm_startblock));
+}
+
 static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
@@ -463,6 +478,7 @@ static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
 	.recs_inorder		= xfs_rmapbt_recs_inorder,
+	.keys_contiguous	= xfs_rmapbt_keys_contiguous,
 };
 
 static struct xfs_btree_cur *
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index 5ebdda7e1078..851220021484 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -204,6 +204,18 @@ enum xfs_ag_resv_type {
 	XFS_AG_RESV_RMAPBT,
 };
 
+/* Results of scanning a btree keyspace to check occupancy. */
+enum xbtree_recpacking {
+	/* None of the keyspace maps to records. */
+	XBTREE_RECPACKING_EMPTY = 0,
+
+	/* Some, but not all, of the keyspace maps to records. */
+	XBTREE_RECPACKING_SPARSE,
+
+	/* The entire keyspace maps to records. */
+	XBTREE_RECPACKING_FULL,
+};
+
 /*
  * Type verifier functions
  */
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index fb4f96716f6a..c72001f6bad9 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -144,15 +144,15 @@ xchk_xref_is_used_space(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		len)
 {
-	bool			is_freesp;
+	enum xbtree_recpacking	outcome;
 	int			error;
 
 	if (!sc->sa.bno_cur || xchk_skip_xref(sc->sm))
 		return;
 
-	error = xfs_alloc_has_record(sc->sa.bno_cur, agbno, len, &is_freesp);
+	error = xfs_alloc_has_records(sc->sa.bno_cur, agbno, len, &outcome);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.bno_cur))
 		return;
-	if (is_freesp)
+	if (outcome != XBTREE_RECPACKING_EMPTY)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.bno_cur, 0);
 }
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index c2ae5a328a6d..220b2850659e 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -457,16 +457,16 @@ xchk_xref_is_not_shared(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		len)
 {
-	bool			shared;
+	enum xbtree_recpacking	outcome;
 	int			error;
 
 	if (!sc->sa.refc_cur || xchk_skip_xref(sc->sm))
 		return;
 
-	error = xfs_refcount_has_record(sc->sa.refc_cur, XFS_REFC_DOMAIN_SHARED,
-			agbno, len, &shared);
+	error = xfs_refcount_has_records(sc->sa.refc_cur,
+			XFS_REFC_DOMAIN_SHARED, agbno, len, &outcome);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.refc_cur))
 		return;
-	if (shared)
+	if (outcome != XBTREE_RECPACKING_EMPTY)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 }
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index 215730a9d9bf..9ac3bc760d6c 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -219,15 +219,15 @@ xchk_xref_has_no_owner(
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len)
 {
-	bool			has_rmap;
+	enum xbtree_recpacking	outcome;
 	int			error;
 
 	if (!sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
 		return;
 
-	error = xfs_rmap_has_record(sc->sa.rmap_cur, bno, len, &has_rmap);
+	error = xfs_rmap_has_records(sc->sa.rmap_cur, bno, len, &outcome);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		return;
-	if (has_rmap)
+	if (outcome != XBTREE_RECPACKING_EMPTY)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
 }

