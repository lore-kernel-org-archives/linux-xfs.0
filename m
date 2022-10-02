Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4C73C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:32:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230071AbiJBSc0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:32:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230084AbiJBSc0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:32:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47B8E3C156
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:32:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C739BB80D89
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8995AC433D6;
        Sun,  2 Oct 2022 18:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735541;
        bh=7/e1JwB9hs7EQe2EUByn+waJxhbvMLD9gXY+YKQqUu4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=erPgkrjQUiK3TGI3DtcSl42lOUdDWZ+nOCDdDqOymK+AhmFtvPqD4oVmE+kLZa9r3
         02y8qaTs4a55QqdP/yrPzF1V8zkx/DC0p44oW22gSb4q/Jus0S8LXbNxyp6z3jNys5
         935H0pJDvv+80u+MgBimhR1Z+Qnr6F2HF5VsDcdYrg8LuLPmp0B+axYrihOIUP7Ada
         hYEI+qAN+/8phouzdfEyFA23TccToRGZEixXH2PVorAv5ywA4OmRwrb24axH6/r7Wa
         qo4tRSmiMXOgaYDElZFs0Iw51rFcs0NCKUToV7I9o3M1+SqYSodj/QKnkJ791MeA5o
         ssS/QYZCz5+DQ==
Subject: [PATCH 1/5] xfs: replace xfs_btree_has_record with a general keyspace
 scanner
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:16 -0700
Message-ID: <166473481597.1084209.14598185861526380195.stgit@magnolia>
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

The current implementation of xfs_btree_has_record returns true if it
finds /any/ record within the given range.  Unfortunately, that's not
sufficient for scrub.  We want to be able to tell if a range of keyspace
for a btree is devoid of records, is totally mapped to records, or is
somewhere in between.  By forcing this to be a boolean, we were
generally missing the "in between" case and returning incorrect results.
Fix the API so that we can tell the caller which of those three is the
current state.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c          |   11 +++-
 fs/xfs/libxfs/xfs_alloc.h          |    4 +-
 fs/xfs/libxfs/xfs_alloc_btree.c    |   13 +++++
 fs/xfs/libxfs/xfs_bmap_btree.c     |   13 +++++
 fs/xfs/libxfs/xfs_btree.c          |   92 +++++++++++++++++++++++++++++++-----
 fs/xfs/libxfs/xfs_btree.h          |   15 +++++-
 fs/xfs/libxfs/xfs_ialloc_btree.c   |   14 +++++
 fs/xfs/libxfs/xfs_refcount.c       |   11 +++-
 fs/xfs/libxfs/xfs_refcount.h       |    5 +-
 fs/xfs/libxfs/xfs_refcount_btree.c |   13 +++++
 fs/xfs/libxfs/xfs_rmap.c           |   12 +++--
 fs/xfs/libxfs/xfs_rmap.h           |    4 +-
 fs/xfs/libxfs/xfs_rmap_btree.c     |   13 +++++
 fs/xfs/libxfs/xfs_types.h          |   12 +++++
 fs/xfs/scrub/alloc.c               |    6 +-
 fs/xfs/scrub/refcount.c            |    7 ++-
 fs/xfs/scrub/rmap.c                |    6 +-
 17 files changed, 209 insertions(+), 42 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index e2bdf089c0a3..f0c92093db0a 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3498,13 +3498,16 @@ xfs_alloc_query_all(
 	return xfs_btree_query_all(cur, xfs_alloc_query_range_helper, &query);
 }
 
-/* Is there a record covering a given extent? */
+/*
+ * Scan part of the keyspace of the free space and tell us if the area has no
+ * records, is fully mapped by records, or is partially filled.
+ */
 int
-xfs_alloc_has_record(
+xfs_alloc_scan_keyfill(
 	struct xfs_btree_cur	*cur,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
-	bool			*exists)
+	enum xfs_btree_keyfill	*outcome)
 {
 	union xfs_btree_irec	low;
 	union xfs_btree_irec	high;
@@ -3514,7 +3517,7 @@ xfs_alloc_has_record(
 	memset(&high, 0xFF, sizeof(high));
 	high.a.ar_startblock = bno + len - 1;
 
-	return xfs_btree_has_record(cur, &low, &high, exists);
+	return xfs_btree_scan_keyfill(cur, &low, &high, outcome);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 2c3f762dfb58..ebda867aa6f4 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
@@ -194,8 +194,8 @@ int xfs_alloc_query_range(struct xfs_btree_cur *cur,
 int xfs_alloc_query_all(struct xfs_btree_cur *cur, xfs_alloc_query_range_fn fn,
 		void *priv);
 
-int xfs_alloc_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, bool *exist);
+int xfs_alloc_scan_keyfill(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, enum xfs_btree_keyfill *outcome);
 
 typedef int (*xfs_agfl_walk_fn)(struct xfs_mount *mp, xfs_agblock_t bno,
 		void *priv);
diff --git a/fs/xfs/libxfs/xfs_alloc_btree.c b/fs/xfs/libxfs/xfs_alloc_btree.c
index 549a3cba0234..916d278204f5 100644
--- a/fs/xfs/libxfs/xfs_alloc_btree.c
+++ b/fs/xfs/libxfs/xfs_alloc_btree.c
@@ -423,6 +423,18 @@ xfs_cntbt_recs_inorder(
 		 be32_to_cpu(r2->alloc.ar_startblock));
 }
 
+STATIC bool
+xfs_allocbt_has_key_gap(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2)
+{
+	xfs_agblock_t			next;
+
+	next = be32_to_cpu(key1->alloc.ar_startblock) + 1;
+	return next != be32_to_cpu(key2->alloc.ar_startblock);
+}
+
 static const struct xfs_btree_ops xfs_bnobt_ops = {
 	.rec_len		= sizeof(xfs_alloc_rec_t),
 	.key_len		= sizeof(xfs_alloc_key_t),
@@ -443,6 +455,7 @@ static const struct xfs_btree_ops xfs_bnobt_ops = {
 	.diff_two_keys		= xfs_bnobt_diff_two_keys,
 	.keys_inorder		= xfs_bnobt_keys_inorder,
 	.recs_inorder		= xfs_bnobt_recs_inorder,
+	.has_key_gap		= xfs_allocbt_has_key_gap,
 };
 
 static const struct xfs_btree_ops xfs_cntbt_ops = {
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index cfa052d40105..d1225b957649 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -518,6 +518,18 @@ xfs_bmbt_recs_inorder(
 		xfs_bmbt_disk_get_startoff(&r2->bmbt);
 }
 
+STATIC bool
+xfs_bmbt_has_key_gap(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2)
+{
+	xfs_fileoff_t			next;
+
+	next = be64_to_cpu(key1->bmbt.br_startoff) + 1;
+	return next != be64_to_cpu(key2->bmbt.br_startoff);
+}
+
 static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.rec_len		= sizeof(xfs_bmbt_rec_t),
 	.key_len		= sizeof(xfs_bmbt_key_t),
@@ -538,6 +550,7 @@ static const struct xfs_btree_ops xfs_bmbt_ops = {
 	.buf_ops		= &xfs_bmbt_buf_ops,
 	.keys_inorder		= xfs_bmbt_keys_inorder,
 	.recs_inorder		= xfs_bmbt_recs_inorder,
+	.has_key_gap		= xfs_bmbt_has_key_gap,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 4c16c8c31fcb..5710d3ee582a 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -5008,34 +5008,100 @@ xfs_btree_diff_two_ptrs(
 	return (int64_t)be32_to_cpu(a->s) - be32_to_cpu(b->s);
 }
 
-/* If there's an extent, we're done. */
+struct xfs_btree_scan_keyfill {
+	/* Keys for the start and end of the range we want to know about. */
+	union xfs_btree_key	start_key;
+	union xfs_btree_key	end_key;
+
+	/* Highest record key we've seen so far. */
+	union xfs_btree_key	high_key;
+
+	enum xfs_btree_keyfill	outcome;
+};
+
 STATIC int
-xfs_btree_has_record_helper(
+xfs_btree_scan_keyfill_helper(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_rec	*rec,
 	void				*priv)
 {
-	return -ECANCELED;
+	union xfs_btree_key		rec_key;
+	union xfs_btree_key		rec_high_key;
+	struct xfs_btree_scan_keyfill	*info = priv;
+	int64_t				res;
+
+	cur->bc_ops->init_key_from_rec(&rec_key, rec);
+
+	if (info->outcome == XFS_BTREE_KEYFILL_EMPTY) {
+		info->outcome = XFS_BTREE_KEYFILL_SPARSE;
+
+		/* Bail if the first record starts after the start key. */
+		res = cur->bc_ops->diff_two_keys(cur, &info->start_key,
+				&rec_key);
+		if (res < 0)
+			return -ECANCELED;
+	} else {
+		/* Bail if there's a gap with the previous record. */
+		if (cur->bc_ops->has_key_gap(cur, &info->high_key, &rec_key))
+			return -ECANCELED;
+	}
+
+	/* If the current record is higher than what we've seen, remember it. */
+	cur->bc_ops->init_high_key_from_rec(&rec_high_key, rec);
+	res = cur->bc_ops->diff_two_keys(cur, &rec_high_key, &info->high_key);
+	if (res > 0)
+		info->high_key = rec_high_key; /* struct copy */
+
+	return 0;
 }
 
-/* Is there a record covering a given range of keys? */
+/*
+ * Scan part of the keyspace of a btree and tell us if the area has no records,
+ * is fully mapped by records, or is partially filled.
+ */
 int
-xfs_btree_has_record(
+xfs_btree_scan_keyfill(
 	struct xfs_btree_cur		*cur,
 	const union xfs_btree_irec	*low,
 	const union xfs_btree_irec	*high,
-	bool				*exists)
+	enum xfs_btree_keyfill		*outcome)
 {
+	struct xfs_btree_scan_keyfill	info = {
+		.outcome		= XFS_BTREE_KEYFILL_EMPTY,
+	};
+	union xfs_btree_rec		rec;
+	int64_t				res;
 	int				error;
 
+	if (!cur->bc_ops->has_key_gap)
+		return -EOPNOTSUPP;
+
+	cur->bc_rec = *low;
+	cur->bc_ops->init_rec_from_cur(cur, &rec);
+	cur->bc_ops->init_key_from_rec(&info.start_key, &rec);
+
+	cur->bc_rec = *high;
+	cur->bc_ops->init_rec_from_cur(cur, &rec);
+	cur->bc_ops->init_key_from_rec(&info.end_key, &rec);
+
 	error = xfs_btree_query_range(cur, low, high,
-			&xfs_btree_has_record_helper, NULL);
-	if (error == -ECANCELED) {
-		*exists = true;
-		return 0;
-	}
-	*exists = false;
-	return error;
+			xfs_btree_scan_keyfill_helper, &info);
+	if (error == -ECANCELED)
+		goto out;
+	if (error)
+		return error;
+
+	if (info.outcome == XFS_BTREE_KEYFILL_EMPTY)
+		goto out;
+
+	/* Did the record set go at least as far as the end? */
+	res = cur->bc_ops->diff_two_keys(cur, &info.high_key, &info.end_key);
+	if (res >= 0)
+		info.outcome = XFS_BTREE_KEYFILL_FULL;
+
+out:
+	*outcome = info.outcome;
+	return 0;
 }
 
 /* Are there more records in this btree? */
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index eef27858a013..58a05f0d1f1b 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -157,6 +157,11 @@ struct xfs_btree_ops {
 	int	(*recs_inorder)(struct xfs_btree_cur *cur,
 				const union xfs_btree_rec *r1,
 				const union xfs_btree_rec *r2);
+
+	/* decide if there's a gap in the keyspace between two keys */
+	bool	(*has_key_gap)(struct xfs_btree_cur *cur,
+			       const union xfs_btree_key *key1,
+			       const union xfs_btree_key *key2);
 };
 
 /*
@@ -540,9 +545,15 @@ void xfs_btree_get_keys(struct xfs_btree_cur *cur,
 		struct xfs_btree_block *block, union xfs_btree_key *key);
 union xfs_btree_key *xfs_btree_high_key_from_key(struct xfs_btree_cur *cur,
 		union xfs_btree_key *key);
-int xfs_btree_has_record(struct xfs_btree_cur *cur,
+typedef bool (*xfs_btree_key_gap_fn)(struct xfs_btree_cur *cur,
+		const union xfs_btree_key *key1,
+		const union xfs_btree_key *key2);
+
+int xfs_btree_scan_keyfill(struct xfs_btree_cur *cur,
 		const union xfs_btree_irec *low,
-		const union xfs_btree_irec *high, bool *exists);
+		const union xfs_btree_irec *high,
+		enum xfs_btree_keyfill *outcome);
+
 bool xfs_btree_has_more_records(struct xfs_btree_cur *cur);
 struct xfs_ifork *xfs_btree_ifork_ptr(struct xfs_btree_cur *cur);
 
diff --git a/fs/xfs/libxfs/xfs_ialloc_btree.c b/fs/xfs/libxfs/xfs_ialloc_btree.c
index 8c83e265770c..fd48b95b4f4e 100644
--- a/fs/xfs/libxfs/xfs_ialloc_btree.c
+++ b/fs/xfs/libxfs/xfs_ialloc_btree.c
@@ -380,6 +380,18 @@ xfs_inobt_recs_inorder(
 		be32_to_cpu(r2->inobt.ir_startino);
 }
 
+STATIC bool
+xfs_inobt_has_key_gap(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2)
+{
+	xfs_agino_t			next;
+
+	next = be32_to_cpu(key1->inobt.ir_startino) + XFS_INODES_PER_CHUNK;
+	return next != be32_to_cpu(key2->inobt.ir_startino);
+}
+
 static const struct xfs_btree_ops xfs_inobt_ops = {
 	.rec_len		= sizeof(xfs_inobt_rec_t),
 	.key_len		= sizeof(xfs_inobt_key_t),
@@ -399,6 +411,7 @@ static const struct xfs_btree_ops xfs_inobt_ops = {
 	.diff_two_keys		= xfs_inobt_diff_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
+	.has_key_gap		= xfs_inobt_has_key_gap,
 };
 
 static const struct xfs_btree_ops xfs_finobt_ops = {
@@ -420,6 +433,7 @@ static const struct xfs_btree_ops xfs_finobt_ops = {
 	.diff_two_keys		= xfs_inobt_diff_two_keys,
 	.keys_inorder		= xfs_inobt_keys_inorder,
 	.recs_inorder		= xfs_inobt_recs_inorder,
+	.has_key_gap		= xfs_inobt_has_key_gap,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 64b910caafaa..607fd25fda56 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -1766,13 +1766,16 @@ xfs_refcount_recover_cow_leftovers(
 	return error;
 }
 
-/* Is there a record covering a given extent? */
+/*
+ * Scan part of the keyspace of the refcount records and tell us if the area
+ * has no records, is fully mapped by records, or is partially filled.
+ */
 int
-xfs_refcount_has_record(
+xfs_refcount_scan_keyfill(
 	struct xfs_btree_cur	*cur,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
-	bool			*exists)
+	enum xfs_btree_keyfill	*outcome)
 {
 	union xfs_btree_irec	low;
 	union xfs_btree_irec	high;
@@ -1782,7 +1785,7 @@ xfs_refcount_has_record(
 	memset(&high, 0xFF, sizeof(high));
 	high.rc.rc_startblock = bno + len - 1;
 
-	return xfs_btree_has_record(cur, &low, &high, exists);
+	return xfs_btree_scan_keyfill(cur, &low, &high, outcome);
 }
 
 int __init
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index e8b322de7f3d..14b8edc289fa 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -78,8 +78,9 @@ extern int xfs_refcount_recover_cow_leftovers(struct xfs_mount *mp,
  */
 #define XFS_REFCOUNT_ITEM_OVERHEAD	32
 
-extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
-		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
+extern int xfs_refcount_scan_keyfill(struct xfs_btree_cur *cur,
+		xfs_agblock_t bno, xfs_extlen_t len,
+		enum xfs_btree_keyfill *outcome);
 union xfs_btree_rec;
 extern void xfs_refcount_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_refcount_irec *irec);
diff --git a/fs/xfs/libxfs/xfs_refcount_btree.c b/fs/xfs/libxfs/xfs_refcount_btree.c
index 316c1ec0c3c2..f7982b2ecc49 100644
--- a/fs/xfs/libxfs/xfs_refcount_btree.c
+++ b/fs/xfs/libxfs/xfs_refcount_btree.c
@@ -290,6 +290,18 @@ xfs_refcountbt_recs_inorder(
 		be32_to_cpu(r2->refc.rc_startblock);
 }
 
+STATIC bool
+xfs_refcountbt_has_key_gap(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2)
+{
+	xfs_agblock_t			next;
+
+	next = be32_to_cpu(key1->refc.rc_startblock) + 1;
+	return next != be32_to_cpu(key2->refc.rc_startblock);
+}
+
 static const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.rec_len		= sizeof(struct xfs_refcount_rec),
 	.key_len		= sizeof(struct xfs_refcount_key),
@@ -309,6 +321,7 @@ static const struct xfs_btree_ops xfs_refcountbt_ops = {
 	.diff_two_keys		= xfs_refcountbt_diff_two_keys,
 	.keys_inorder		= xfs_refcountbt_keys_inorder,
 	.recs_inorder		= xfs_refcountbt_recs_inorder,
+	.has_key_gap		= xfs_refcountbt_has_key_gap,
 };
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index 094dfc897ebc..08d47cbf4697 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -2671,13 +2671,17 @@ xfs_rmap_compare(
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
+xfs_rmap_scan_keyfill(
 	struct xfs_btree_cur	*cur,
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len,
-	bool			*exists)
+	enum xfs_btree_keyfill	*outcome)
 {
 	union xfs_btree_irec	low;
 	union xfs_btree_irec	high;
@@ -2687,7 +2691,7 @@ xfs_rmap_has_record(
 	memset(&high, 0xFF, sizeof(high));
 	high.r.rm_startblock = bno + len - 1;
 
-	return xfs_btree_has_record(cur, &low, &high, exists);
+	return xfs_btree_scan_keyfill(cur, &low, &high, outcome);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 54741a591a17..263a2dd09216 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
@@ -192,8 +192,8 @@ int xfs_rmap_compare(const struct xfs_rmap_irec *a,
 union xfs_btree_rec;
 int xfs_rmap_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
-int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
-		xfs_extlen_t len, bool *exists);
+int xfs_rmap_scan_keyfill(struct xfs_btree_cur *cur, xfs_agblock_t bno,
+		xfs_extlen_t len, enum xfs_btree_keyfill *outcome);
 int xfs_rmap_record_exists(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, const struct xfs_owner_info *oinfo,
 		bool *has_rmap);
diff --git a/fs/xfs/libxfs/xfs_rmap_btree.c b/fs/xfs/libxfs/xfs_rmap_btree.c
index e2e1f68cedf5..d64143a842ce 100644
--- a/fs/xfs/libxfs/xfs_rmap_btree.c
+++ b/fs/xfs/libxfs/xfs_rmap_btree.c
@@ -433,6 +433,18 @@ xfs_rmapbt_recs_inorder(
 	return 0;
 }
 
+STATIC bool
+xfs_rmapbt_has_key_gap(
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_key	*key1,
+	const union xfs_btree_key	*key2)
+{
+	xfs_agblock_t			next;
+
+	next = be32_to_cpu(key1->rmap.rm_startblock) + 1;
+	return next != be32_to_cpu(key2->rmap.rm_startblock);
+}
+
 static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.rec_len		= sizeof(struct xfs_rmap_rec),
 	.key_len		= 2 * sizeof(struct xfs_rmap_key),
@@ -452,6 +464,7 @@ static const struct xfs_btree_ops xfs_rmapbt_ops = {
 	.diff_two_keys		= xfs_rmapbt_diff_two_keys,
 	.keys_inorder		= xfs_rmapbt_keys_inorder,
 	.recs_inorder		= xfs_rmapbt_recs_inorder,
+	.has_key_gap		= xfs_rmapbt_has_key_gap,
 };
 
 static struct xfs_btree_cur *
diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
index a6b7d98cf68f..d63637a3b873 100644
--- a/fs/xfs/libxfs/xfs_types.h
+++ b/fs/xfs/libxfs/xfs_types.h
@@ -174,6 +174,18 @@ enum xfs_ag_resv_type {
 	XFS_AG_RESV_RMAPBT,
 };
 
+/* Results of scanning a btree keyspace to check occupancy. */
+enum xfs_btree_keyfill {
+	/* None of the keyspace maps to records. */
+	XFS_BTREE_KEYFILL_EMPTY = 0,
+
+	/* Some, but not all, of the keyspace maps to records. */
+	XFS_BTREE_KEYFILL_SPARSE,
+
+	/* The entire keyspace maps to records. */
+	XFS_BTREE_KEYFILL_FULL,
+};
+
 /*
  * Type verifier functions
  */
diff --git a/fs/xfs/scrub/alloc.c b/fs/xfs/scrub/alloc.c
index 4d9ccc15b048..d8f2ba7efa22 100644
--- a/fs/xfs/scrub/alloc.c
+++ b/fs/xfs/scrub/alloc.c
@@ -146,15 +146,15 @@ xchk_xref_is_used_space(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		len)
 {
-	bool			is_freesp;
+	enum xfs_btree_keyfill	keyfill;
 	int			error;
 
 	if (!sc->sa.bno_cur || xchk_skip_xref(sc->sm))
 		return;
 
-	error = xfs_alloc_has_record(sc->sa.bno_cur, agbno, len, &is_freesp);
+	error = xfs_alloc_scan_keyfill(sc->sa.bno_cur, agbno, len, &keyfill);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.bno_cur))
 		return;
-	if (is_freesp)
+	if (keyfill != XFS_BTREE_KEYFILL_EMPTY)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.bno_cur, 0);
 }
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 4e70cd821b62..bfd48aaceb82 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -475,15 +475,16 @@ xchk_xref_is_not_shared(
 	xfs_agblock_t		agbno,
 	xfs_extlen_t		len)
 {
-	bool			shared;
+	enum xfs_btree_keyfill	keyfill;
 	int			error;
 
 	if (!sc->sa.refc_cur || xchk_skip_xref(sc->sm))
 		return;
 
-	error = xfs_refcount_has_record(sc->sa.refc_cur, agbno, len, &shared);
+	error = xfs_refcount_scan_keyfill(sc->sa.refc_cur, agbno, len,
+			&keyfill);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.refc_cur))
 		return;
-	if (shared)
+	if (keyfill != XFS_BTREE_KEYFILL_EMPTY)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.refc_cur, 0);
 }
diff --git a/fs/xfs/scrub/rmap.c b/fs/xfs/scrub/rmap.c
index afc4f840b6bc..6525202c6a8a 100644
--- a/fs/xfs/scrub/rmap.c
+++ b/fs/xfs/scrub/rmap.c
@@ -224,15 +224,15 @@ xchk_xref_has_no_owner(
 	xfs_agblock_t		bno,
 	xfs_extlen_t		len)
 {
-	bool			has_rmap;
+	enum xfs_btree_keyfill	keyfill;
 	int			error;
 
 	if (!sc->sa.rmap_cur || xchk_skip_xref(sc->sm))
 		return;
 
-	error = xfs_rmap_has_record(sc->sa.rmap_cur, bno, len, &has_rmap);
+	error = xfs_rmap_scan_keyfill(sc->sa.rmap_cur, bno, len, &keyfill);
 	if (!xchk_should_check_xref(sc, &error, &sc->sa.rmap_cur))
 		return;
-	if (has_rmap)
+	if (keyfill != XFS_BTREE_KEYFILL_EMPTY)
 		xchk_btree_xref_set_corrupt(sc, sc->sa.rmap_cur, 0);
 }

