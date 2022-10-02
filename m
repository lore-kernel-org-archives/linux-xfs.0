Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6107CC433F5
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:32:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbiJBSct (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbiJBScs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:32:48 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 457223C171
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:32:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 7E31ACE0A4A
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:32:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C61C433D6;
        Sun,  2 Oct 2022 18:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735562;
        bh=iwjzVtXnPEOWjcmgJutIABkLQzUhP3JgwiK6IM9PORw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=V1td0/I8kH2TJl+/bQeOyuTOZNDVX0xWAHFsIEB0Q72+nn+/sTUVTyHOVS7ft6U6A
         YM4XsQnx0V3jxhuHnjTvRjhCi+m1Ke/RlpLZfMneGAwqGeO0F2y8exPh2kLSeWkfaO
         0v/qnLSJJd0oIhca1ICU2+9QjCc2YxTztRPFnrlTgY9lo1YP/zZwQ1tCTpsRs4Fc41
         K4QVoZpCGP3K4er8QzA8movu8hQTSdp7t3UIdqaPd7pRHK23eIHDK1lbhX55bI+ngR
         ED1GdGyQeqTw18XHuJF6B3Xk4Y9dPXA9uICj6dxIx0LsSplz7oIC0q1N+0389w6EyF
         JeU2sQcZVKv7A==
Subject: [PATCH 3/5] xfs: mask key comparisons for keyspace fill scans
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:16 -0700
Message-ID: <166473481626.1084209.13610255473278160434.stgit@magnolia>
In-Reply-To: <166473481572.1084209.5434516873607335909.stgit@magnolia>
References: <166473481572.1084209.5434516873607335909.stgit@magnolia>
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

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c          |    2 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |    5 +++-
 fs/xfs/libxfs/xfs_bmap_btree.c     |    5 +++-
 fs/xfs/libxfs/xfs_btree.c          |   41 +++++++++++++++++++++++++++----
 fs/xfs/libxfs/xfs_btree.h          |   10 +++++++-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |    7 ++++-
 fs/xfs/libxfs/xfs_refcount.c       |    2 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |    5 +++-
 fs/xfs/libxfs/xfs_rmap.c           |    7 +++++
 fs/xfs/libxfs/xfs_rmap_btree.c     |   48 +++++++++++++++++++++++++++++++++---
 10 files changed, 114 insertions(+), 18 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index f0c92093db0a..0ce1f914f7cc 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3517,7 +3517,7 @@ xfs_alloc_scan_keyfill(
 	memset(&high, 0xFF, sizeof(high));
 	high.a.ar_startblock = bno + len - 1;
 
-	return xfs_btree_scan_keyfill(cur, &low, &high, outcome);
+	return xfs_btree_scan_keyfill(cur, &low, &high, NULL, outcome);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 916d278204f5..4a69d767a32b 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -427,10 +427,13 @@ STATIC bool
 xfs_allocbt_has_key_gap(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key1,
-	const union xfs_btree_key	*key2)
+	const union xfs_btree_key	*key2,
+	const union xfs_btree_key	*mask)
 {
 	xfs_agblock_t			next;
 
+	ASSERT(!mask || mask->alloc.ar_startblock);
+
 	next = be32_to_cpu(key1->alloc.ar_startblock) + 1;
 	return next != be32_to_cpu(key2->alloc.ar_startblock);
 }
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index d1225b957649..81433a027912 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -522,10 +522,13 @@ STATIC bool
 xfs_bmbt_has_key_gap(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key1,
-	const union xfs_btree_key	*key2)
+	const union xfs_btree_key	*key2,
+	const union xfs_btree_key	*mask)
 {
 	xfs_fileoff_t			next;
 
+	ASSERT(!mask || mask->bmbt.br_startoff);
+
 	next = be64_to_cpu(key1->bmbt.br_startoff) + 1;
 	return next != be64_to_cpu(key2->bmbt.br_startoff);
 }
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index edea6db8d8e4..6fbce2f3c17e 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -5020,12 +5020,33 @@ struct xfs_btree_scan_keyfill {
 	union xfs_btree_key	start_key;
 	union xfs_btree_key	end_key;
 
+	/* Mask for key comparisons, if desired. */
+	union xfs_btree_key	*key_mask;
+
 	/* Highest record key we've seen so far. */
 	union xfs_btree_key	high_key;
 
 	enum xfs_btree_keyfill	outcome;
 };
 
+STATIC int64_t
+xfs_btree_diff_two_masked_keys(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2,
+	const union xfs_btree_key	*mask)
+{
+	union xfs_btree_key		mk1, mk2;
+
+	if (likely(!mask))
+		return cur->bc_ops->diff_two_keys(cur, key1, key2);
+
+	cur->bc_ops->mask_key(cur, &mk1, key1, mask);
+	cur->bc_ops->mask_key(cur, &mk2, key2, mask);
+
+	return cur->bc_ops->diff_two_keys(cur, &mk1, &mk2);
+}
+
 STATIC int
 xfs_btree_scan_keyfill_helper(
 	struct xfs_btree_cur		*cur,
@@ -5043,19 +5064,22 @@ xfs_btree_scan_keyfill_helper(
 		info->outcome = XFS_BTREE_KEYFILL_SPARSE;
 
 		/* Bail if the first record starts after the start key. */
-		res = cur->bc_ops->diff_two_keys(cur, &info->start_key,
-				&rec_key);
+		res = xfs_btree_diff_two_masked_keys(cur, &info->start_key,
+				&rec_key, info->key_mask);
 		if (res < 0)
 			return -ECANCELED;
 	} else {
 		/* Bail if there's a gap with the previous record. */
-		if (cur->bc_ops->has_key_gap(cur, &info->high_key, &rec_key))
+		if (cur->bc_ops->has_key_gap(cur, &info->high_key, &rec_key,
+					info->key_mask))
 			return -ECANCELED;
 	}
 
 	/* If the current record is higher than what we've seen, remember it. */
 	cur->bc_ops->init_high_key_from_rec(&rec_high_key, rec);
-	res = cur->bc_ops->diff_two_keys(cur, &rec_high_key, &info->high_key);
+
+	res = xfs_btree_diff_two_masked_keys(cur, &rec_high_key,
+			&info->high_key, info->key_mask);
 	if (res > 0)
 		info->high_key = rec_high_key; /* struct copy */
 
@@ -5071,11 +5095,13 @@ xfs_btree_scan_keyfill(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_irec	*low,
 	const union xfs_btree_irec	*high,
+	const union xfs_btree_irec	*mask,
 	enum xfs_btree_keyfill		*outcome)
 {
 	struct xfs_btree_scan_keyfill	info = {
 		.outcome		= XFS_BTREE_KEYFILL_EMPTY,
 	};
+	union xfs_btree_key		key_mask;
 	int64_t				res;
 	int				error;
 
@@ -5084,6 +5110,10 @@ xfs_btree_scan_keyfill(
 
 	xfs_btree_key_from_irec(cur, &info.start_key, low);
 	xfs_btree_key_from_irec(cur, &info.end_key, high);
+	if (mask) {
+		xfs_btree_key_from_irec(cur, &key_mask, mask);
+		info.key_mask = &key_mask;
+	}
 
 	error = xfs_btree_query_range(cur, low, high,
 			xfs_btree_scan_keyfill_helper, &info);
@@ -5096,7 +5126,8 @@ xfs_btree_scan_keyfill(
 		goto out;
 
 	/* Did the record set go at least as far as the end? */
-	res = cur->bc_ops->diff_two_keys(cur, &info.high_key, &info.end_key);
+	res = xfs_btree_diff_two_masked_keys(cur, &info.high_key,
+			&info.end_key, info.key_mask);
 	if (res >= 0)
 		info.outcome = XFS_BTREE_KEYFILL_FULL;
 
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 58a05f0d1f1b..99baa8283049 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -158,10 +158,17 @@ struct xfs_btree_ops {
 				const union xfs_btree_rec *r1,
 				const union xfs_btree_rec *r2);
 
+	/* mask a key for us */
+	void	(*mask_key)(struct xfs_btree_cur *cur,
+			    union xfs_btree_key *out_key,
+			    const union xfs_btree_key *in_key,
+			    const union xfs_btree_key *mask);
+
 	/* decide if there's a gap in the keyspace between two keys */
 	bool	(*has_key_gap)(struct xfs_btree_cur *cur,
 			       const union xfs_btree_key *key1,
-			       const union xfs_btree_key *key2);
+			       const union xfs_btree_key *key2,
+			       const union xfs_btree_key *mask);
 };
 
 /*
@@ -552,6 +559,7 @@ typedef bool (*xfs_btree_key_gap_fn)(struct xfs_btree_cur *cur,
 int xfs_btree_scan_keyfill(struct xfs_btree_cur *cur,
 		const union xfs_btree_irec *low,
 		const union xfs_btree_irec *high,
+		const union xfs_btree_irec *mask,
 		enum xfs_btree_keyfill *outcome);
 
 bool xfs_btree_has_more_records(struct xfs_btree_cur *cur);
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index fd48b95b4f4e..d429ca8d9dd8 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -384,11 +384,14 @@ STATIC bool
 xfs_inobt_has_key_gap(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key1,
-	const union xfs_btree_key	*key2)
+	const union xfs_btree_key	*key2,
+	const union xfs_btree_key	*mask)
 {
 	xfs_agino_t			next;
 
-	next = be32_to_cpu(key1->inobt.ir_startino) + XFS_INODES_PER_CHUNK;
+	ASSERT(!mask || mask->inobt.ir_startino);
+
+	next = be32_to_cpu(key1->inobt.ir_startino) + 1;
 	return next != be32_to_cpu(key2->inobt.ir_startino);
 }
 
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 607fd25fda56..3ce77c9d2504 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1785,7 +1785,7 @@ xfs_refcount_scan_keyfill(
 	memset(&high, 0xFF, sizeof(high));
 	high.rc.rc_startblock = bno + len - 1;
 
-	return xfs_btree_scan_keyfill(cur, &low, &high, outcome);
+	return xfs_btree_scan_keyfill(cur, &low, &high, NULL, outcome);
 }
 
 int __init
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index f7982b2ecc49..301d036f7081 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -294,10 +294,13 @@ STATIC bool
 xfs_refcountbt_has_key_gap(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key1,
-	const union xfs_btree_key	*key2)
+	const union xfs_btree_key	*key2,
+	const union xfs_btree_key	*mask)
 {
 	xfs_agblock_t			next;
 
+	ASSERT(!mask || mask->refc.rc_startblock);
+
 	next = be32_to_cpu(key1->refc.rc_startblock) + 1;
 	return next != be32_to_cpu(key2->refc.rc_startblock);
 }
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 08d47cbf4697..4c123b6dd080 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2685,13 +2685,18 @@ xfs_rmap_scan_keyfill(
 {
 	union xfs_btree_irec	low;
 	union xfs_btree_irec	high;
+	union xfs_btree_irec	mask;
+
+	/* Only care about space scans here */
+	memset(&mask, 0, sizeof(low));
+	memset(&mask.r.rm_startblock, 0xFF, sizeof(mask.r.rm_startblock));
 
 	memset(&low, 0, sizeof(low));
 	low.r.rm_startblock = bno;
 	memset(&high, 0xFF, sizeof(high));
 	high.r.rm_startblock = bno + len - 1;
 
-	return xfs_btree_scan_keyfill(cur, &low, &high, outcome);
+	return xfs_btree_scan_keyfill(cur, &low, &high, &mask, outcome);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index d64143a842ce..9ca60f709c4b 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -433,16 +433,55 @@ xfs_rmapbt_recs_inorder(
 	return 0;
 }
 
+STATIC void
+xfs_rmapbt_mask_key(
+	struct xfs_btree_cur		*cur,
+	union xfs_btree_key		*out_key,
+	const union xfs_btree_key	*in_key,
+	const union xfs_btree_key	*mask)
+{
+	memset(out_key, 0, sizeof(union xfs_btree_key));
+
+	if (mask->rmap.rm_startblock)
+		out_key->rmap.rm_startblock = in_key->rmap.rm_startblock;
+	if (mask->rmap.rm_owner)
+		out_key->rmap.rm_owner = in_key->rmap.rm_owner;
+	if (mask->rmap.rm_offset)
+		out_key->rmap.rm_offset = in_key->rmap.rm_offset;
+}
+
 STATIC bool
 xfs_rmapbt_has_key_gap(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_key	*key1,
-	const union xfs_btree_key	*key2)
+	const union xfs_btree_key	*key2,
+	const union xfs_btree_key	*mask)
 {
-	xfs_agblock_t			next;
+	bool				reflink = xfs_has_reflink(cur->bc_mp);
+	uint64_t			x, y;
 
-	next = be32_to_cpu(key1->rmap.rm_startblock) + 1;
-	return next != be32_to_cpu(key2->rmap.rm_startblock);
+	if (mask->rmap.rm_offset) {
+		x = be64_to_cpu(key1->rmap.rm_offset) + 1;
+		y = be64_to_cpu(key2->rmap.rm_offset);
+		if ((reflink && x < y) || (!reflink && x != y))
+			return true;
+	}
+
+	if (mask->rmap.rm_owner) {
+		x = be64_to_cpu(key1->rmap.rm_owner) + 1;
+		y = be64_to_cpu(key2->rmap.rm_owner);
+		if ((reflink && x < y) || (!reflink && x != y))
+			return true;
+	}
+
+	if (mask->rmap.rm_startblock) {
+		x = be32_to_cpu(key1->rmap.rm_startblock) + 1;
+		y = be32_to_cpu(key2->rmap.rm_startblock);
+		if ((reflink && x < y) || (!reflink && x != y))
+			return true;
+	}
+
+	return false;
 }
 
 static const struct xfs_btree_ops xfs_rmapbt_ops = {
@@ -465,6 +504,7 @@ static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
 	.recs_inorder		= xfs_rmapbt_recs_inorder,
 	.has_key_gap		= xfs_rmapbt_has_key_gap,
+	.mask_key		= xfs_rmapbt_mask_key,
 };
 
 static struct xfs_btree_cur *

