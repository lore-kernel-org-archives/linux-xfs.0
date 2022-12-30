Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD655C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:42:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235664AbiL3WmU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:42:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235643AbiL3WmT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:42:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75E2412D26
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:42:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26A40B81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:42:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C7DC433D2;
        Fri, 30 Dec 2022 22:42:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672440135;
        bh=hS6CdRHLmiEYIZVpPEvqdqxJ6vaFblLL80Ztwy0UZQE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ZFFVRclgYmhmnvH1Dw9F/7gz8GK8GwS9CgUcntqCNSLvsuLUQY+zCrQWbDGP4Dnts
         059i3uiR2vi5uenuME6YyCra8sniGDuVEdKnA+qcT+O9RuGxkzvM3gpv8X55PPg1St
         VyYw5jX7EG9Vt4PaZ7m2DqcHKWhnq9utIM7NUhH6caOz02xjLVnZh2FnTom+Yfyo+l
         6hXLnwgYnX6rZrCeYRllY7acEPjw8Zsj0mfZ5IwwWMfU1AsrT7BmYsc0gGpVlFq7Jf
         eGssvNPtH4eKeijD8vKp3RXYjxnT316PEQYn5NNMee+iXO79/plWtmusAMBAvW/Jrq
         U7Bjoi2TBXm1A==
Subject: [PATCH 2/6] xfs: refactor ->diff_two_keys callsites
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:25 -0800
Message-ID: <167243828539.684405.9965186059519901615.stgit@magnolia>
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

Create wrapper functions around ->diff_two_keys so that we don't have to
remember what the return values mean, and adjust some of the code
comments to reflect the longtime code behavior.  We're going to
introduce more uses of ->diff_two_keys in the next patch, so reduce the
cognitive load for readers by doing this refactoring now.

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |   61 +++++++++++++++++++--------------------------
 fs/xfs/libxfs/xfs_btree.h |   55 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/btree.c      |   24 +++++++++---------
 3 files changed, 93 insertions(+), 47 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index d02634c44bff..7661d5bc1650 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2067,8 +2067,7 @@ xfs_btree_get_leaf_keys(
 		for (n = 2; n <= xfs_btree_get_numrecs(block); n++) {
 			rec = xfs_btree_rec_addr(cur, n, block);
 			cur->bc_ops->init_high_key_from_rec(&hkey, rec);
-			if (cur->bc_ops->diff_two_keys(cur, &hkey, &max_hkey)
-					> 0)
+			if (xfs_btree_keycmp_gt(cur, &hkey, &max_hkey))
 				max_hkey = hkey;
 		}
 
@@ -2096,7 +2095,7 @@ xfs_btree_get_node_keys(
 		max_hkey = xfs_btree_high_key_addr(cur, 1, block);
 		for (n = 2; n <= xfs_btree_get_numrecs(block); n++) {
 			hkey = xfs_btree_high_key_addr(cur, n, block);
-			if (cur->bc_ops->diff_two_keys(cur, hkey, max_hkey) > 0)
+			if (xfs_btree_keycmp_gt(cur, hkey, max_hkey))
 				max_hkey = hkey;
 		}
 
@@ -2183,8 +2182,8 @@ __xfs_btree_updkeys(
 		nlkey = xfs_btree_key_addr(cur, ptr, block);
 		nhkey = xfs_btree_high_key_addr(cur, ptr, block);
 		if (!force_all &&
-		    !(cur->bc_ops->diff_two_keys(cur, nlkey, lkey) != 0 ||
-		      cur->bc_ops->diff_two_keys(cur, nhkey, hkey) != 0))
+		    xfs_btree_keycmp_eq(cur, nlkey, lkey) &&
+		    xfs_btree_keycmp_eq(cur, nhkey, hkey))
 			break;
 		xfs_btree_copy_keys(cur, nlkey, lkey, 1);
 		xfs_btree_log_keys(cur, bp, ptr, ptr);
@@ -4702,7 +4701,6 @@ xfs_btree_simple_query_range(
 {
 	union xfs_btree_rec		*recp;
 	union xfs_btree_key		rec_key;
-	int64_t				diff;
 	int				stat;
 	bool				firstrec = true;
 	int				error;
@@ -4732,20 +4730,17 @@ xfs_btree_simple_query_range(
 		if (error || !stat)
 			break;
 
-		/* Skip if high_key(rec) < low_key. */
+		/* Skip if low_key > high_key(rec). */
 		if (firstrec) {
 			cur->bc_ops->init_high_key_from_rec(&rec_key, recp);
 			firstrec = false;
-			diff = cur->bc_ops->diff_two_keys(cur, low_key,
-					&rec_key);
-			if (diff > 0)
+			if (xfs_btree_keycmp_gt(cur, low_key, &rec_key))
 				goto advloop;
 		}
 
-		/* Stop if high_key < low_key(rec). */
+		/* Stop if low_key(rec) > high_key. */
 		cur->bc_ops->init_key_from_rec(&rec_key, recp);
-		diff = cur->bc_ops->diff_two_keys(cur, &rec_key, high_key);
-		if (diff > 0)
+		if (xfs_btree_keycmp_gt(cur, &rec_key, high_key))
 			break;
 
 		/* Callback */
@@ -4799,8 +4794,6 @@ xfs_btree_overlapped_query_range(
 	union xfs_btree_key		*hkp;
 	union xfs_btree_rec		*recp;
 	struct xfs_btree_block		*block;
-	int64_t				ldiff;
-	int64_t				hdiff;
 	int				level;
 	struct xfs_buf			*bp;
 	int				i;
@@ -4840,25 +4833,23 @@ xfs_btree_overlapped_query_range(
 					block);
 
 			cur->bc_ops->init_high_key_from_rec(&rec_hkey, recp);
-			ldiff = cur->bc_ops->diff_two_keys(cur, &rec_hkey,
-					low_key);
-
 			cur->bc_ops->init_key_from_rec(&rec_key, recp);
-			hdiff = cur->bc_ops->diff_two_keys(cur, high_key,
-					&rec_key);
 
 			/*
+			 * If (query's high key < record's low key), then there
+			 * are no more interesting records in this block.  Pop
+			 * up to the leaf level to find more record blocks.
+			 *
 			 * If (record's high key >= query's low key) and
 			 *    (query's high key >= record's low key), then
 			 * this record overlaps the query range; callback.
 			 */
-			if (ldiff >= 0 && hdiff >= 0) {
-				error = fn(cur, recp, priv);
-				if (error)
-					break;
-			} else if (hdiff < 0) {
-				/* Record is larger than high key; pop. */
+			if (xfs_btree_keycmp_lt(cur, high_key, &rec_key))
 				goto pop_up;
+			if (xfs_btree_keycmp_ge(cur, &rec_hkey, low_key)) {
+				error = fn(cur, recp, priv);
+				if (error)
+					break;
 			}
 			cur->bc_levels[level].ptr++;
 			continue;
@@ -4870,15 +4861,18 @@ xfs_btree_overlapped_query_range(
 				block);
 		pp = xfs_btree_ptr_addr(cur, cur->bc_levels[level].ptr, block);
 
-		ldiff = cur->bc_ops->diff_two_keys(cur, hkp, low_key);
-		hdiff = cur->bc_ops->diff_two_keys(cur, high_key, lkp);
-
 		/*
+		 * If (query's high key < pointer's low key), then there are no
+		 * more interesting keys in this block.  Pop up one leaf level
+		 * to continue looking for records.
+		 *
 		 * If (pointer's high key >= query's low key) and
 		 *    (query's high key >= pointer's low key), then
 		 * this record overlaps the query range; follow pointer.
 		 */
-		if (ldiff >= 0 && hdiff >= 0) {
+		if (xfs_btree_keycmp_lt(cur, high_key, lkp))
+			goto pop_up;
+		if (xfs_btree_keycmp_ge(cur, hkp, low_key)) {
 			level--;
 			error = xfs_btree_lookup_get_block(cur, level, pp,
 					&block);
@@ -4893,9 +4887,6 @@ xfs_btree_overlapped_query_range(
 #endif
 			cur->bc_levels[level].ptr = 1;
 			continue;
-		} else if (hdiff < 0) {
-			/* The low key is larger than the upper range; pop. */
-			goto pop_up;
 		}
 		cur->bc_levels[level].ptr++;
 	}
@@ -4957,8 +4948,8 @@ xfs_btree_query_range(
 	xfs_btree_key_from_irec(cur, &high_key, high_rec);
 	xfs_btree_key_from_irec(cur, &low_key, low_rec);
 
-	/* Enforce low key < high key. */
-	if (cur->bc_ops->diff_two_keys(cur, &low_key, &high_key) > 0)
+	/* Enforce low key <= high key. */
+	if (!xfs_btree_keycmp_le(cur, &low_key, &high_key))
 		return -EINVAL;
 
 	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 29c4b4ccb909..f5aa4b893ee7 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -546,6 +546,61 @@ int xfs_btree_has_record(struct xfs_btree_cur *cur,
 bool xfs_btree_has_more_records(struct xfs_btree_cur *cur);
 struct xfs_ifork *xfs_btree_ifork_ptr(struct xfs_btree_cur *cur);
 
+/* Key comparison helpers */
+static inline bool
+xfs_btree_keycmp_lt(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2)
+{
+	return cur->bc_ops->diff_two_keys(cur, key1, key2) < 0;
+}
+
+static inline bool
+xfs_btree_keycmp_gt(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2)
+{
+	return cur->bc_ops->diff_two_keys(cur, key1, key2) > 0;
+}
+
+static inline bool
+xfs_btree_keycmp_eq(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2)
+{
+	return cur->bc_ops->diff_two_keys(cur, key1, key2) == 0;
+}
+
+static inline bool
+xfs_btree_keycmp_le(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2)
+{
+	return !xfs_btree_keycmp_gt(cur, key1, key2);
+}
+
+static inline bool
+xfs_btree_keycmp_ge(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2)
+{
+	return !xfs_btree_keycmp_lt(cur, key1, key2);
+}
+
+static inline bool
+xfs_btree_keycmp_ne(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2)
+{
+	return !xfs_btree_keycmp_eq(cur, key1, key2);
+}
+
 /* Does this cursor point to the last block in the given level? */
 static inline bool
 xfs_btree_islastblock(
diff --git a/fs/xfs/scrub/btree.c b/fs/xfs/scrub/btree.c
index 2dfa3e1d5841..8ae42dff632f 100644
--- a/fs/xfs/scrub/btree.c
+++ b/fs/xfs/scrub/btree.c
@@ -161,20 +161,20 @@ xchk_btree_rec(
 	if (cur->bc_nlevels == 1)
 		return;
 
-	/* Is this at least as large as the parent low key? */
+	/* Is low_key(rec) at least as large as the parent low key? */
 	cur->bc_ops->init_key_from_rec(&key, rec);
 	keyblock = xfs_btree_get_block(cur, 1, &bp);
 	keyp = xfs_btree_key_addr(cur, cur->bc_levels[1].ptr, keyblock);
-	if (cur->bc_ops->diff_two_keys(cur, &key, keyp) < 0)
+	if (xfs_btree_keycmp_lt(cur, &key, keyp))
 		xchk_btree_set_corrupt(bs->sc, cur, 1);
 
 	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
 		return;
 
-	/* Is this no larger than the parent high key? */
+	/* Is high_key(rec) no larger than the parent high key? */
 	cur->bc_ops->init_high_key_from_rec(&hkey, rec);
 	keyp = xfs_btree_high_key_addr(cur, cur->bc_levels[1].ptr, keyblock);
-	if (cur->bc_ops->diff_two_keys(cur, keyp, &hkey) < 0)
+	if (xfs_btree_keycmp_lt(cur, keyp, &hkey))
 		xchk_btree_set_corrupt(bs->sc, cur, 1);
 }
 
@@ -209,20 +209,20 @@ xchk_btree_key(
 	if (level + 1 >= cur->bc_nlevels)
 		return;
 
-	/* Is this at least as large as the parent low key? */
+	/* Is this block's low key at least as large as the parent low key? */
 	keyblock = xfs_btree_get_block(cur, level + 1, &bp);
 	keyp = xfs_btree_key_addr(cur, cur->bc_levels[level + 1].ptr, keyblock);
-	if (cur->bc_ops->diff_two_keys(cur, key, keyp) < 0)
+	if (xfs_btree_keycmp_lt(cur, key, keyp))
 		xchk_btree_set_corrupt(bs->sc, cur, level);
 
 	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
 		return;
 
-	/* Is this no larger than the parent high key? */
+	/* Is this block's high key no larger than the parent high key? */
 	key = xfs_btree_high_key_addr(cur, cur->bc_levels[level].ptr, block);
 	keyp = xfs_btree_high_key_addr(cur, cur->bc_levels[level + 1].ptr,
 			keyblock);
-	if (cur->bc_ops->diff_two_keys(cur, keyp, key) < 0)
+	if (xfs_btree_keycmp_lt(cur, keyp, key))
 		xchk_btree_set_corrupt(bs->sc, cur, level);
 }
 
@@ -557,7 +557,7 @@ xchk_btree_block_check_keys(
 	parent_block = xfs_btree_get_block(cur, level + 1, &bp);
 	parent_low_key = xfs_btree_key_addr(cur, cur->bc_levels[level + 1].ptr,
 			parent_block);
-	if (cur->bc_ops->diff_two_keys(cur, &block_key, parent_low_key)) {
+	if (xfs_btree_keycmp_ne(cur, &block_key, parent_low_key)) {
 		xchk_btree_set_corrupt(bs->sc, bs->cur, level);
 		return;
 	}
@@ -569,7 +569,7 @@ xchk_btree_block_check_keys(
 	parent_high_key = xfs_btree_high_key_addr(cur,
 			cur->bc_levels[level + 1].ptr, parent_block);
 	block_high_key = xfs_btree_high_key_from_key(cur, &block_key);
-	if (cur->bc_ops->diff_two_keys(cur, block_high_key, parent_high_key))
+	if (xfs_btree_keycmp_ne(cur, block_high_key, parent_high_key))
 		xchk_btree_set_corrupt(bs->sc, bs->cur, level);
 }
 
@@ -661,7 +661,7 @@ xchk_btree_block_keys(
 	parent_keys = xfs_btree_key_addr(cur, cur->bc_levels[level + 1].ptr,
 			parent_block);
 
-	if (cur->bc_ops->diff_two_keys(cur, &block_keys, parent_keys) != 0)
+	if (xfs_btree_keycmp_ne(cur, &block_keys, parent_keys))
 		xchk_btree_set_corrupt(bs->sc, cur, 1);
 
 	if (!(cur->bc_flags & XFS_BTREE_OVERLAPPING))
@@ -672,7 +672,7 @@ xchk_btree_block_keys(
 	high_pk = xfs_btree_high_key_addr(cur, cur->bc_levels[level + 1].ptr,
 			parent_block);
 
-	if (cur->bc_ops->diff_two_keys(cur, high_bk, high_pk) != 0)
+	if (xfs_btree_keycmp_ne(cur, high_bk, high_pk))
 		xchk_btree_set_corrupt(bs->sc, cur, 1);
 }
 

