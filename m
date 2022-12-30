Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66A43C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235663AbiL3Wmu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:42:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235643AbiL3Wmt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:42:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF8212D26
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:42:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8ED2A61C0D
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:42:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5123C433EF;
        Fri, 30 Dec 2022 22:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440167;
        bh=dM2AEKjt8EwaTyFWo+mOwnS+5EJkFqCFN6DODO5Xj/w=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=VNWT/tYnNBqDV7Vp81QUQ5IY/qF7CWwXZcgmKccTlqA9XKtfBsw/mZLhkryBow/Dk
         yngU/Qb3iv9zt9/kA5rShqIAjK37pHKHAAwbRxPcvRzE7GsI1wXqz7xDGDJbcV+leS
         SBm2oUqiO8BDEL/xozurBxpqwNL/aITevsQ1p6MjMiYp0XC13tOTNIltXOqzfvIwa5
         BdrKuE8z+M+ggEiSu00+Ea4INXrnhte+niN1EEVfWFqqaT2JMEPmUmU4IRj61lBDkS
         ixHN3njIM9tgM78vBSPyBk2lbkRRmaeC1DYk/Q8o+r4iTWSXA/pYFcTbwPamyD6q0S
         +d9Xlr169t+GQ==
Subject: [PATCH 4/6] xfs: implement masked btree key comparisons for
 _has_records scans
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:25 -0800
Message-ID: <167243828569.684405.7652578761965882499.stgit@magnolia>
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

For keyspace fullness scans, we want to be able to mask off the parts of
the key that we don't care about.  For most btree types we /do/ want the
full keyspace, but for checking that a given space usage also has a full
complement of rmapbt records (even if different/multiple owners) we need
this masking so that we only track sparseness of rm_startblock, not the
whole keyspace (which is extremely sparse).

Augment the ->diff_two_keys and ->keys_contiguous helpers to take a
third union xfs_btree_key argument, and wire up xfs_rmap_has_records to
pass this through.  This third "mask" argument should contain a nonzero
value in each structure field that should be used in the key comparisons
done during the scan.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c          |    2 +
 fs/xfs/libxfs/xfs_alloc_btree.c    |   18 ++++++++++---
 fs/xfs/libxfs/xfs_bmap_btree.c     |   10 ++++++-
 fs/xfs/libxfs/xfs_btree.c          |   24 ++++++++++++++---
 fs/xfs/libxfs/xfs_btree.h          |   50 ++++++++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   12 ++++++---
 fs/xfs/libxfs/xfs_refcount.c       |    2 +
 fs/xfs/libxfs/xfs_refcount_btree.c |   12 ++++++---
 fs/xfs/libxfs/xfs_rmap.c           |    5 +++-
 fs/xfs/libxfs/xfs_rmap_btree.c     |   47 +++++++++++++++++++++++-----------
 10 files changed, 142 insertions(+), 40 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 31f61d88878d..e0ddae7a62ec 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3549,7 +3549,7 @@ xfs_alloc_has_records(
 	memset(&high, 0xFF, sizeof(high));
 	high.a.ar_startblock = bno + len - 1;
 
-	return xfs_btree_has_records(cur, &low, &high, outcome);
+	return xfs_btree_has_records(cur, &low, &high, NULL, outcome);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 46fe70ab0a0e..a91e2a81ba2c 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -260,20 +260,27 @@ STATIC int64_t
 xfs_bnobt_diff_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
-	const union xfs_btree_key	*k2)
+	const union xfs_btree_key	*k2,
+	const union xfs_btree_key	*mask)
 {
+	ASSERT(!mask || mask->alloc.ar_startblock);
+
 	return (int64_t)be32_to_cpu(k1->alloc.ar_startblock) -
-			  be32_to_cpu(k2->alloc.ar_startblock);
+			be32_to_cpu(k2->alloc.ar_startblock);
 }
 
 STATIC int64_t
 xfs_cntbt_diff_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
-	const union xfs_btree_key	*k2)
+	const union xfs_btree_key	*k2,
+	const union xfs_btree_key	*mask)
 {
 	int64_t				diff;
 
+	ASSERT(!mask || (mask->alloc.ar_blockcount &&
+			 mask->alloc.ar_startblock));
+
 	diff =  be32_to_cpu(k1->alloc.ar_blockcount) -
 		be32_to_cpu(k2->alloc.ar_blockcount);
 	if (diff)
@@ -427,8 +434,11 @@ STATIC enum xbtree_key_contig
 xfs_allocbt_keys_contiguous(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key1,
-	const union xfs_btree_key	*key2)
+	const union xfs_btree_key	*key2,
+	const union xfs_btree_key	*mask)
 {
+	ASSERT(!mask || mask->alloc.ar_startblock);
+
 	return xbtree_key_contig(be32_to_cpu(key1->alloc.ar_startblock),
 				 be32_to_cpu(key2->alloc.ar_startblock));
 }
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 45b5696fe8cb..e53c5bd42e86 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -400,11 +400,14 @@ STATIC int64_t
 xfs_bmbt_diff_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
-	const union xfs_btree_key	*k2)
+	const union xfs_btree_key	*k2,
+	const union xfs_btree_key	*mask)
 {
 	uint64_t			a = be64_to_cpu(k1->bmbt.br_startoff);
 	uint64_t			b = be64_to_cpu(k2->bmbt.br_startoff);
 
+	ASSERT(!mask || mask->bmbt.br_startoff);
+
 	/*
 	 * Note: This routine previously casted a and b to int64 and subtracted
 	 * them to generate a result.  This lead to problems if b was the
@@ -522,8 +525,11 @@ STATIC enum xbtree_key_contig
 xfs_bmbt_keys_contiguous(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key1,
-	const union xfs_btree_key	*key2)
+	const union xfs_btree_key	*key2,
+	const union xfs_btree_key	*mask)
 {
+	ASSERT(!mask || mask->bmbt.br_startoff);
+
 	return xbtree_key_contig(be64_to_cpu(key1->bmbt.br_startoff),
 				 be64_to_cpu(key2->bmbt.br_startoff));
 }
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 2258af10e41a..99b79de7efcd 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -5016,6 +5016,9 @@ struct xfs_btree_has_records {
 	union xfs_btree_key		start_key;
 	union xfs_btree_key		end_key;
 
+	/* Mask for key comparisons, if desired. */
+	const union xfs_btree_key	*key_mask;
+
 	/* Highest record key we've seen so far. */
 	union xfs_btree_key		high_key;
 
@@ -5043,7 +5046,8 @@ xfs_btree_has_records_helper(
 		 * then there is a hole at the start of the search range.
 		 * Classify this as sparse and stop immediately.
 		 */
-		if (xfs_btree_keycmp_lt(cur, &info->start_key, &rec_key))
+		if (xfs_btree_masked_keycmp_lt(cur, &info->start_key, &rec_key,
+					info->key_mask))
 			return -ECANCELED;
 	} else {
 		/*
@@ -5054,7 +5058,7 @@ xfs_btree_has_records_helper(
 		 * signal corruption.
 		 */
 		key_contig = cur->bc_ops->keys_contiguous(cur, &info->high_key,
-					&rec_key);
+					&rec_key, info->key_mask);
 		if (key_contig == XBTREE_KEY_OVERLAP &&
 				!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
 			return -EFSCORRUPTED;
@@ -5067,7 +5071,8 @@ xfs_btree_has_records_helper(
 	 * remember it for later.
 	 */
 	cur->bc_ops->init_high_key_from_rec(&rec_high_key, rec);
-	if (xfs_btree_keycmp_gt(cur, &rec_high_key, &info->high_key))
+	if (xfs_btree_masked_keycmp_gt(cur, &rec_high_key, &info->high_key,
+				info->key_mask))
 		info->high_key = rec_high_key; /* struct copy */
 
 	return 0;
@@ -5078,16 +5083,26 @@ xfs_btree_has_records_helper(
  * map to any records; is fully mapped to records; or is partially mapped to
  * records.  This is the btree record equivalent to determining if a file is
  * sparse.
+ *
+ * For most btree types, the record scan should use all available btree key
+ * fields to compare the keys encountered.  These callers should pass NULL for
+ * @mask.  However, some callers (e.g.  scanning physical space in the rmapbt)
+ * want to ignore some part of the btree record keyspace when performing the
+ * comparison.  These callers should pass in a union xfs_btree_key object with
+ * the fields that *should* be a part of the comparison set to any nonzero
+ * value, and the rest zeroed.
  */
 int
 xfs_btree_has_records(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_irec	*low,
 	const union xfs_btree_irec	*high,
+	const union xfs_btree_key	*mask,
 	enum xbtree_recpacking		*outcome)
 {
 	struct xfs_btree_has_records	info = {
 		.outcome		= XBTREE_RECPACKING_EMPTY,
+		.key_mask		= mask,
 	};
 	int				error;
 
@@ -5115,7 +5130,8 @@ xfs_btree_has_records(
 	 * the end of the search range, classify this as full.  Otherwise,
 	 * there is a hole at the end of the search range.
 	 */
-	if (xfs_btree_keycmp_ge(cur, &info.high_key, &info.end_key))
+	if (xfs_btree_masked_keycmp_ge(cur, &info.high_key, &info.end_key,
+				mask))
 		info.outcome = XBTREE_RECPACKING_FULL;
 
 out:
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 66431f351bb2..a2aa36b23e25 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -161,11 +161,14 @@ struct xfs_btree_ops {
 
 	/*
 	 * Difference between key2 and key1 -- positive if key1 > key2,
-	 * negative if key1 < key2, and zero if equal.
+	 * negative if key1 < key2, and zero if equal.  If the @mask parameter
+	 * is non NULL, each key field to be used in the comparison must
+	 * contain a nonzero value.
 	 */
 	int64_t (*diff_two_keys)(struct xfs_btree_cur *cur,
 				 const union xfs_btree_key *key1,
-				 const union xfs_btree_key *key2);
+				 const union xfs_btree_key *key2,
+				 const union xfs_btree_key *mask);
 
 	const struct xfs_buf_ops	*buf_ops;
 
@@ -187,10 +190,13 @@ struct xfs_btree_ops {
 	 * @key1 < K < @key2.  To determine if two btree records are
 	 * immediately adjacent, @key1 should be the high key of the first
 	 * record and @key2 should be the low key of the second record.
+	 * If the @mask parameter is non NULL, each key field to be used in the
+	 * comparison must contain a nonzero value.
 	 */
 	enum xbtree_key_contig (*keys_contiguous)(struct xfs_btree_cur *cur,
 			       const union xfs_btree_key *key1,
-			       const union xfs_btree_key *key2);
+			       const union xfs_btree_key *key2,
+			       const union xfs_btree_key *mask);
 };
 
 /*
@@ -581,6 +587,7 @@ typedef bool (*xfs_btree_key_gap_fn)(struct xfs_btree_cur *cur,
 int xfs_btree_has_records(struct xfs_btree_cur *cur,
 		const union xfs_btree_irec *low,
 		const union xfs_btree_irec *high,
+		const union xfs_btree_key *mask,
 		enum xbtree_recpacking *outcome);
 
 bool xfs_btree_has_more_records(struct xfs_btree_cur *cur);
@@ -593,7 +600,7 @@ xfs_btree_keycmp_lt(
 	const union xfs_btree_key	*key1,
 	const union xfs_btree_key	*key2)
 {
-	return cur->bc_ops->diff_two_keys(cur, key1, key2) < 0;
+	return cur->bc_ops->diff_two_keys(cur, key1, key2, NULL) < 0;
 }
 
 static inline bool
@@ -602,7 +609,7 @@ xfs_btree_keycmp_gt(
 	const union xfs_btree_key	*key1,
 	const union xfs_btree_key	*key2)
 {
-	return cur->bc_ops->diff_two_keys(cur, key1, key2) > 0;
+	return cur->bc_ops->diff_two_keys(cur, key1, key2, NULL) > 0;
 }
 
 static inline bool
@@ -611,7 +618,7 @@ xfs_btree_keycmp_eq(
 	const union xfs_btree_key	*key1,
 	const union xfs_btree_key	*key2)
 {
-	return cur->bc_ops->diff_two_keys(cur, key1, key2) == 0;
+	return cur->bc_ops->diff_two_keys(cur, key1, key2, NULL) == 0;
 }
 
 static inline bool
@@ -641,6 +648,37 @@ xfs_btree_keycmp_ne(
 	return !xfs_btree_keycmp_eq(cur, key1, key2);
 }
 
+/* Masked key comparison helpers */
+static inline bool
+xfs_btree_masked_keycmp_lt(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2,
+	const union xfs_btree_key	*mask)
+{
+	return cur->bc_ops->diff_two_keys(cur, key1, key2, mask) < 0;
+}
+
+static inline bool
+xfs_btree_masked_keycmp_gt(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2,
+	const union xfs_btree_key	*mask)
+{
+	return cur->bc_ops->diff_two_keys(cur, key1, key2, mask) > 0;
+}
+
+static inline bool
+xfs_btree_masked_keycmp_ge(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2,
+	const union xfs_btree_key	*mask)
+{
+	return !xfs_btree_masked_keycmp_lt(cur, key1, key2, mask);
+}
+
 /* Does this cursor point to the last block in the given level? */
 static inline bool
 xfs_btree_islastblock(
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index e59bd6d3db03..2b7571d50afb 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -269,10 +269,13 @@ STATIC int64_t
 xfs_inobt_diff_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
-	const union xfs_btree_key	*k2)
+	const union xfs_btree_key	*k2,
+	const union xfs_btree_key	*mask)
 {
+	ASSERT(!mask || mask->inobt.ir_startino);
+
 	return (int64_t)be32_to_cpu(k1->inobt.ir_startino) -
-			  be32_to_cpu(k2->inobt.ir_startino);
+			be32_to_cpu(k2->inobt.ir_startino);
 }
 
 static xfs_failaddr_t
@@ -387,8 +390,11 @@ STATIC enum xbtree_key_contig
 xfs_inobt_keys_contiguous(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key1,
-	const union xfs_btree_key	*key2)
+	const union xfs_btree_key	*key2,
+	const union xfs_btree_key	*mask)
 {
+	ASSERT(!mask || mask->inobt.ir_startino);
+
 	return xbtree_key_contig(be32_to_cpu(key1->inobt.ir_startino),
 				 be32_to_cpu(key2->inobt.ir_startino));
 }
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 94377b59ba44..c1c65774dcc2 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -2019,7 +2019,7 @@ xfs_refcount_has_records(
 	high.rc.rc_startblock = bno + len - 1;
 	low.rc.rc_domain = high.rc.rc_domain = domain;
 
-	return xfs_btree_has_records(cur, &low, &high, outcome);
+	return xfs_btree_has_records(cur, &low, &high, NULL, outcome);
 }
 
 int __init
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 26e28ac24238..2ec45e2ffbe1 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -202,10 +202,13 @@ STATIC int64_t
 xfs_refcountbt_diff_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
-	const union xfs_btree_key	*k2)
+	const union xfs_btree_key	*k2,
+	const union xfs_btree_key	*mask)
 {
+	ASSERT(!mask || mask->refc.rc_startblock);
+
 	return (int64_t)be32_to_cpu(k1->refc.rc_startblock) -
-			  be32_to_cpu(k2->refc.rc_startblock);
+			be32_to_cpu(k2->refc.rc_startblock);
 }
 
 STATIC xfs_failaddr_t
@@ -304,8 +307,11 @@ STATIC enum xbtree_key_contig
 xfs_refcountbt_keys_contiguous(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key1,
-	const union xfs_btree_key	*key2)
+	const union xfs_btree_key	*key2,
+	const union xfs_btree_key	*mask)
 {
+	ASSERT(!mask || mask->refc.rc_startblock);
+
 	return xbtree_key_contig(be32_to_cpu(key1->refc.rc_startblock),
 				 be32_to_cpu(key2->refc.rc_startblock));
 }
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index e616b964f11c..308b81f321eb 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2721,6 +2721,9 @@ xfs_rmap_has_records(
 	xfs_extlen_t		len,
 	enum xbtree_recpacking	*outcome)
 {
+	union xfs_btree_key	mask = {
+		.rmap.rm_startblock = cpu_to_be32(-1U),
+	};
 	union xfs_btree_irec	low;
 	union xfs_btree_irec	high;
 
@@ -2729,7 +2732,7 @@ xfs_rmap_has_records(
 	memset(&high, 0xFF, sizeof(high));
 	high.r.rm_startblock = bno + len - 1;
 
-	return xfs_btree_has_records(cur, &low, &high, outcome);
+	return xfs_btree_has_records(cur, &low, &high, &mask, outcome);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index 1733865026d4..2c90a05ca814 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -273,31 +273,43 @@ STATIC int64_t
 xfs_rmapbt_diff_two_keys(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*k1,
-	const union xfs_btree_key	*k2)
+	const union xfs_btree_key	*k2,
+	const union xfs_btree_key	*mask)
 {
 	const struct xfs_rmap_key	*kp1 = &k1->rmap;
 	const struct xfs_rmap_key	*kp2 = &k2->rmap;
 	int64_t				d;
 	__u64				x, y;
 
+	/* Doesn't make sense to mask off the physical space part */
+	ASSERT(!mask || mask->rmap.rm_startblock);
+
 	d = (int64_t)be32_to_cpu(kp1->rm_startblock) -
-		       be32_to_cpu(kp2->rm_startblock);
+		     be32_to_cpu(kp2->rm_startblock);
 	if (d)
 		return d;
 
-	x = be64_to_cpu(kp1->rm_owner);
-	y = be64_to_cpu(kp2->rm_owner);
-	if (x > y)
-		return 1;
-	else if (y > x)
-		return -1;
+	if (!mask || mask->rmap.rm_owner) {
+		x = be64_to_cpu(kp1->rm_owner);
+		y = be64_to_cpu(kp2->rm_owner);
+		if (x > y)
+			return 1;
+		else if (y > x)
+			return -1;
+	}
+
+	if (!mask || mask->rmap.rm_offset) {
+		/* Doesn't make sense to allow offset but not owner */
+		ASSERT(!mask || mask->rmap.rm_owner);
+
+		x = offset_keymask(be64_to_cpu(kp1->rm_offset));
+		y = offset_keymask(be64_to_cpu(kp2->rm_offset));
+		if (x > y)
+			return 1;
+		else if (y > x)
+			return -1;
+	}
 
-	x = offset_keymask(be64_to_cpu(kp1->rm_offset));
-	y = offset_keymask(be64_to_cpu(kp2->rm_offset));
-	if (x > y)
-		return 1;
-	else if (y > x)
-		return -1;
 	return 0;
 }
 
@@ -448,13 +460,18 @@ STATIC enum xbtree_key_contig
 xfs_rmapbt_keys_contiguous(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key1,
-	const union xfs_btree_key	*key2)
+	const union xfs_btree_key	*key2,
+	const union xfs_btree_key	*mask)
 {
+	ASSERT(!mask || mask->rmap.rm_startblock);
+
 	/*
 	 * We only support checking contiguity of the physical space component.
 	 * If any callers ever need more specificity than that, they'll have to
 	 * implement it here.
 	 */
+	ASSERT(!mask || (!mask->rmap.rm_owner && !mask->rmap.rm_offset));
+
 	return xbtree_key_contig(be32_to_cpu(key1->rmap.rm_startblock),
 				 be32_to_cpu(key2->rmap.rm_startblock));
 }

