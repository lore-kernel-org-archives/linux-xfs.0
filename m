Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07A3EC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345003AbiATASc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233210AbiATASc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:18:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86F3C061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:18:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7CDEFB81C24
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313E3C004E1;
        Thu, 20 Jan 2022 00:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637909;
        bh=N21tPlNt+54ixW34l2u2CM1atr1/ZM+rViv+mmSBB/c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RMGlaFiOEMzDMU3wcj0kh/mxIpeqOsSlRm2wh1SNP85Lu4ygiPUBclsLew6s5l0IO
         56NEQUlMiIquoW6q7YZy5a8sdbuXVUb3whBQl+5TXfV+wvd0G/AaIaiVvFQcsOc/A5
         Lb4rKwGUxGLk6hDY9bZVkCThdangik2kNj/YQOcl2o+/vrernrsKoZg0FFffOHoeLf
         yzDyLH04a+iC6/b+LsVh6nX243adT8aFNQBL1KN6qU0pFMcFSwovy1om6/2iIVOXAQ
         /+Wq/ow18EJIDXhiPY84nk5VGNlmSKXq7tW30fUSTm1jGxgOPns3+ggZDicb+lY1AK
         P9M9kVCfk9+fw==
Subject: [PATCH 12/45] xfs: make the record pointer passed to query_range
 functions const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:18:28 -0800
Message-ID: <164263790887.860211.2515446781244435975.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Source kernel commit: 159eb69dba8baf6d5b58b69936920fb311324c82

The query_range functions are supposed to call a caller-supplied
function on each record found in the dataset.  These functions don't
own the memory storing the record, so don't let them change the record.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/fsmap.c            |    8 ++++----
 libxfs/xfs_alloc.c    |    2 +-
 libxfs/xfs_alloc.h    |    6 +++---
 libxfs/xfs_btree.c    |    2 +-
 libxfs/xfs_btree.h    |    2 +-
 libxfs/xfs_ialloc.c   |    4 ++--
 libxfs/xfs_ialloc.h   |    3 ++-
 libxfs/xfs_refcount.c |    4 ++--
 libxfs/xfs_refcount.h |    2 +-
 libxfs/xfs_rmap.c     |   24 ++++++++++++------------
 libxfs/xfs_rmap.h     |    8 ++++----
 11 files changed, 33 insertions(+), 32 deletions(-)


diff --git a/db/fsmap.c b/db/fsmap.c
index 65e9f1ba..d30b832c 100644
--- a/db/fsmap.c
+++ b/db/fsmap.c
@@ -16,11 +16,11 @@ struct fsmap_info {
 
 static int
 fsmap_fn(
-	struct xfs_btree_cur	*cur,
-	struct xfs_rmap_irec	*rec,
-	void			*priv)
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
 {
-	struct fsmap_info	*info = priv;
+	struct fsmap_info		*info = priv;
 
 	dbprintf(_("%llu: %u/%u len %u owner %lld offset %llu bmbt %d attrfork %d extflag %d\n"),
 		info->nr, info->agno, rec->rm_startblock,
diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c
index 105c90b0..a7c3b079 100644
--- a/libxfs/xfs_alloc.c
+++ b/libxfs/xfs_alloc.c
@@ -3388,7 +3388,7 @@ struct xfs_alloc_query_range_info {
 STATIC int
 xfs_alloc_query_range_helper(
 	struct xfs_btree_cur		*cur,
-	union xfs_btree_rec		*rec,
+	const union xfs_btree_rec	*rec,
 	void				*priv)
 {
 	struct xfs_alloc_query_range_info	*query = priv;
diff --git a/libxfs/xfs_alloc.h b/libxfs/xfs_alloc.h
index 3554b7d4..e14c5693 100644
--- a/libxfs/xfs_alloc.h
+++ b/libxfs/xfs_alloc.h
@@ -220,9 +220,9 @@ int xfs_free_extent_fix_freelist(struct xfs_trans *tp, struct xfs_perag *pag,
 xfs_extlen_t xfs_prealloc_blocks(struct xfs_mount *mp);
 
 typedef int (*xfs_alloc_query_range_fn)(
-	struct xfs_btree_cur		*cur,
-	struct xfs_alloc_rec_incore	*rec,
-	void				*priv);
+	struct xfs_btree_cur			*cur,
+	const struct xfs_alloc_rec_incore	*rec,
+	void					*priv);
 
 int xfs_alloc_query_range(struct xfs_btree_cur *cur,
 		const struct xfs_alloc_rec_incore *low_rec,
diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c
index aedc62a5..448f6c0d 100644
--- a/libxfs/xfs_btree.c
+++ b/libxfs/xfs_btree.c
@@ -4878,7 +4878,7 @@ xfs_btree_diff_two_ptrs(
 STATIC int
 xfs_btree_has_record_helper(
 	struct xfs_btree_cur		*cur,
-	union xfs_btree_rec		*rec,
+	const union xfs_btree_rec	*rec,
 	void				*priv)
 {
 	return -ECANCELED;
diff --git a/libxfs/xfs_btree.h b/libxfs/xfs_btree.h
index 462c2585..e83836a9 100644
--- a/libxfs/xfs_btree.h
+++ b/libxfs/xfs_btree.h
@@ -471,7 +471,7 @@ unsigned long long xfs_btree_calc_size(uint *limits, unsigned long long len);
  * code on its own.
  */
 typedef int (*xfs_btree_query_range_fn)(struct xfs_btree_cur *cur,
-		union xfs_btree_rec *rec, void *priv);
+		const union xfs_btree_rec *rec, void *priv);
 
 int xfs_btree_query_range(struct xfs_btree_cur *cur,
 		const union xfs_btree_irec *low_rec,
diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 570349b8..c1f3d28a 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -69,7 +69,7 @@ xfs_inobt_update(
 void
 xfs_inobt_btrec_to_irec(
 	struct xfs_mount		*mp,
-	union xfs_btree_rec		*rec,
+	const union xfs_btree_rec	*rec,
 	struct xfs_inobt_rec_incore	*irec)
 {
 	irec->ir_startino = be32_to_cpu(rec->inobt.ir_startino);
@@ -2711,7 +2711,7 @@ struct xfs_ialloc_count_inodes {
 STATIC int
 xfs_ialloc_count_inodes_rec(
 	struct xfs_btree_cur		*cur,
-	union xfs_btree_rec		*rec,
+	const union xfs_btree_rec	*rec,
 	void				*priv)
 {
 	struct xfs_inobt_rec_incore	irec;
diff --git a/libxfs/xfs_ialloc.h b/libxfs/xfs_ialloc.h
index 9a2112b4..8b5c2b70 100644
--- a/libxfs/xfs_ialloc.h
+++ b/libxfs/xfs_ialloc.h
@@ -106,7 +106,8 @@ int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_agnumber_t agno, struct xfs_buf **bpp);
 
 union xfs_btree_rec;
-void xfs_inobt_btrec_to_irec(struct xfs_mount *mp, union xfs_btree_rec *rec,
+void xfs_inobt_btrec_to_irec(struct xfs_mount *mp,
+		const union xfs_btree_rec *rec,
 		struct xfs_inobt_rec_incore *irec);
 int xfs_ialloc_has_inodes_at_extent(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
diff --git a/libxfs/xfs_refcount.c b/libxfs/xfs_refcount.c
index 2ef00c64..1c9e7722 100644
--- a/libxfs/xfs_refcount.c
+++ b/libxfs/xfs_refcount.c
@@ -90,7 +90,7 @@ xfs_refcount_lookup_eq(
 /* Convert on-disk record to in-core format. */
 void
 xfs_refcount_btrec_to_irec(
-	union xfs_btree_rec		*rec,
+	const union xfs_btree_rec	*rec,
 	struct xfs_refcount_irec	*irec)
 {
 	irec->rc_startblock = be32_to_cpu(rec->refc.rc_startblock);
@@ -1653,7 +1653,7 @@ struct xfs_refcount_recovery {
 STATIC int
 xfs_refcount_recover_extent(
 	struct xfs_btree_cur		*cur,
-	union xfs_btree_rec		*rec,
+	const union xfs_btree_rec	*rec,
 	void				*priv)
 {
 	struct list_head		*debris = priv;
diff --git a/libxfs/xfs_refcount.h b/libxfs/xfs_refcount.h
index 9f6e9aae..02cb3aa4 100644
--- a/libxfs/xfs_refcount.h
+++ b/libxfs/xfs_refcount.h
@@ -78,7 +78,7 @@ static inline xfs_fileoff_t xfs_refcount_max_unmap(int log_res)
 extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
 union xfs_btree_rec;
-extern void xfs_refcount_btrec_to_irec(union xfs_btree_rec *rec,
+extern void xfs_refcount_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_refcount_irec *irec);
 extern int xfs_refcount_insert(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
diff --git a/libxfs/xfs_rmap.c b/libxfs/xfs_rmap.c
index 100e904d..ed7db353 100644
--- a/libxfs/xfs_rmap.c
+++ b/libxfs/xfs_rmap.c
@@ -178,8 +178,8 @@ xfs_rmap_delete(
 /* Convert an internal btree record to an rmap record. */
 int
 xfs_rmap_btrec_to_irec(
-	union xfs_btree_rec	*rec,
-	struct xfs_rmap_irec	*irec)
+	const union xfs_btree_rec	*rec,
+	struct xfs_rmap_irec		*irec)
 {
 	irec->rm_startblock = be32_to_cpu(rec->rmap.rm_startblock);
 	irec->rm_blockcount = be32_to_cpu(rec->rmap.rm_blockcount);
@@ -254,9 +254,9 @@ struct xfs_find_left_neighbor_info {
 /* For each rmap given, figure out if it matches the key we want. */
 STATIC int
 xfs_rmap_find_left_neighbor_helper(
-	struct xfs_btree_cur	*cur,
-	struct xfs_rmap_irec	*rec,
-	void			*priv)
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
 {
 	struct xfs_find_left_neighbor_info	*info = priv;
 
@@ -330,9 +330,9 @@ xfs_rmap_find_left_neighbor(
 /* For each rmap given, figure out if it matches the key we want. */
 STATIC int
 xfs_rmap_lookup_le_range_helper(
-	struct xfs_btree_cur	*cur,
-	struct xfs_rmap_irec	*rec,
-	void			*priv)
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
 {
 	struct xfs_find_left_neighbor_info	*info = priv;
 
@@ -2277,9 +2277,9 @@ struct xfs_rmap_query_range_info {
 /* Format btree record and pass to our callback. */
 STATIC int
 xfs_rmap_query_range_helper(
-	struct xfs_btree_cur	*cur,
-	union xfs_btree_rec	*rec,
-	void			*priv)
+	struct xfs_btree_cur		*cur,
+	const union xfs_btree_rec	*rec,
+	void				*priv)
 {
 	struct xfs_rmap_query_range_info	*query = priv;
 	struct xfs_rmap_irec			irec;
@@ -2706,7 +2706,7 @@ struct xfs_rmap_key_state {
 STATIC int
 xfs_rmap_has_other_keys_helper(
 	struct xfs_btree_cur		*cur,
-	struct xfs_rmap_irec		*rec,
+	const struct xfs_rmap_irec	*rec,
 	void				*priv)
 {
 	struct xfs_rmap_key_state	*rks = priv;
diff --git a/libxfs/xfs_rmap.h b/libxfs/xfs_rmap.h
index 1354efc4..fd67904e 100644
--- a/libxfs/xfs_rmap.h
+++ b/libxfs/xfs_rmap.h
@@ -134,9 +134,9 @@ int xfs_rmap_get_rec(struct xfs_btree_cur *cur, struct xfs_rmap_irec *irec,
 		int *stat);
 
 typedef int (*xfs_rmap_query_range_fn)(
-	struct xfs_btree_cur	*cur,
-	struct xfs_rmap_irec	*rec,
-	void			*priv);
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv);
 
 int xfs_rmap_query_range(struct xfs_btree_cur *cur,
 		const struct xfs_rmap_irec *low_rec,
@@ -193,7 +193,7 @@ int xfs_rmap_lookup_le_range(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 int xfs_rmap_compare(const struct xfs_rmap_irec *a,
 		const struct xfs_rmap_irec *b);
 union xfs_btree_rec;
-int xfs_rmap_btrec_to_irec(union xfs_btree_rec *rec,
+int xfs_rmap_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_rmap_irec *irec);
 int xfs_rmap_has_record(struct xfs_btree_cur *cur, xfs_agblock_t bno,
 		xfs_extlen_t len, bool *exists);

