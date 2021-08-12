Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB4CBC4338F
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:31:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9678860C3E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Aug 2021 23:31:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234367AbhHLXcG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Aug 2021 19:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230244AbhHLXcG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 12 Aug 2021 19:32:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45A9C6103E;
        Thu, 12 Aug 2021 23:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628811100;
        bh=4HwMAtScl7QonE/2QZ0x53owaIKvsa3+bqU+BvTQOkc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=B4SKXIBwpwmmMrHCNIibetplWSyTTofODSJzsEKmSeQqzC0R0BUKpuNsXS7aLd9uO
         BV/eY+SIZ+BmQ0d96UAqWmvPD66qI4CHe8zTb8F+8bq1QjLpPyJYvSUmnvFXgWva7w
         rCKhWWS8txAEsBqwwQ4XdoOplWOqnJk5mn5qjrgA9GlGdvPLYUk7ue7Bhdwkc0O4S4
         0b+flvJ9VRvwNtX3wiIUbFdqgBn5Vfnh2M6y6aR2rHzT8zfWlBKxO06oEutXGv8Zh+
         8396aWPBGXlIVQbm6/pf5UYIuR4fo5v8l8IXRyzyNpKmAcPnT1X+b10wh+PXLKfM+k
         dVR1tY+6KhdNQ==
Subject: [PATCH 03/10] xfs: make the record pointer passed to query_range
 functions const
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 12 Aug 2021 16:31:40 -0700
Message-ID: <162881109994.1695493.15186624863084945329.stgit@magnolia>
In-Reply-To: <162881108307.1695493.3416792932772498160.stgit@magnolia>
References: <162881108307.1695493.3416792932772498160.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The query_range functions are supposed to call a caller-supplied
function on each record found in the dataset.  These functions don't
own the memory storing the record, so don't let them change the record.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_alloc.c      |    2 +-
 fs/xfs/libxfs/xfs_alloc.h      |    6 +++---
 fs/xfs/libxfs/xfs_btree.c      |    2 +-
 fs/xfs/libxfs/xfs_btree.h      |    2 +-
 fs/xfs/libxfs/xfs_ialloc.c     |    4 ++--
 fs/xfs/libxfs/xfs_ialloc.h     |    3 ++-
 fs/xfs/libxfs/xfs_refcount.c   |    4 ++--
 fs/xfs/libxfs/xfs_refcount.h   |    2 +-
 fs/xfs/libxfs/xfs_rmap.c       |   24 ++++++++++++------------
 fs/xfs/libxfs/xfs_rmap.h       |    8 ++++----
 fs/xfs/scrub/agheader.c        |    2 +-
 fs/xfs/scrub/agheader_repair.c |    4 ++--
 fs/xfs/scrub/bmap.c            |   27 +++++++++++++++------------
 fs/xfs/scrub/common.c          |    2 +-
 fs/xfs/scrub/refcount.c        |    2 +-
 fs/xfs/scrub/repair.c          |    2 +-
 fs/xfs/scrub/rtbitmap.c        |    2 +-
 fs/xfs/xfs_fsmap.c             |   14 +++++++-------
 fs/xfs/xfs_rtalloc.h           |    6 +++---
 fs/xfs/xfs_trace.h             |    4 ++--
 20 files changed, 63 insertions(+), 59 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index d5ee19ae02eb..8cc6c1671901 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -3392,7 +3392,7 @@ struct xfs_alloc_query_range_info {
 STATIC int
 xfs_alloc_query_range_helper(
 	struct xfs_btree_cur		*cur,
-	union xfs_btree_rec		*rec,
+	const union xfs_btree_rec	*rec,
 	void				*priv)
 {
 	struct xfs_alloc_query_range_info	*query = priv;
diff --git a/fs/xfs/libxfs/xfs_alloc.h b/fs/xfs/libxfs/xfs_alloc.h
index 3554b7d420f0..e14c56938bac 100644
--- a/fs/xfs/libxfs/xfs_alloc.h
+++ b/fs/xfs/libxfs/xfs_alloc.h
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
diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index c91f084e555e..bc15d90ff7a2 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -4877,7 +4877,7 @@ xfs_btree_diff_two_ptrs(
 STATIC int
 xfs_btree_has_record_helper(
 	struct xfs_btree_cur		*cur,
-	union xfs_btree_rec		*rec,
+	const union xfs_btree_rec	*rec,
 	void				*priv)
 {
 	return -ECANCELED;
diff --git a/fs/xfs/libxfs/xfs_btree.h b/fs/xfs/libxfs/xfs_btree.h
index 462c25857a26..e83836a984e4 100644
--- a/fs/xfs/libxfs/xfs_btree.h
+++ b/fs/xfs/libxfs/xfs_btree.h
@@ -471,7 +471,7 @@ unsigned long long xfs_btree_calc_size(uint *limits, unsigned long long len);
  * code on its own.
  */
 typedef int (*xfs_btree_query_range_fn)(struct xfs_btree_cur *cur,
-		union xfs_btree_rec *rec, void *priv);
+		const union xfs_btree_rec *rec, void *priv);
 
 int xfs_btree_query_range(struct xfs_btree_cur *cur,
 		const union xfs_btree_irec *low_rec,
diff --git a/fs/xfs/libxfs/xfs_ialloc.c b/fs/xfs/libxfs/xfs_ialloc.c
index 19eb7ec0103f..99b331983e9b 100644
--- a/fs/xfs/libxfs/xfs_ialloc.c
+++ b/fs/xfs/libxfs/xfs_ialloc.c
@@ -74,7 +74,7 @@ xfs_inobt_update(
 void
 xfs_inobt_btrec_to_irec(
 	struct xfs_mount		*mp,
-	union xfs_btree_rec		*rec,
+	const union xfs_btree_rec	*rec,
 	struct xfs_inobt_rec_incore	*irec)
 {
 	irec->ir_startino = be32_to_cpu(rec->inobt.ir_startino);
@@ -2716,7 +2716,7 @@ struct xfs_ialloc_count_inodes {
 STATIC int
 xfs_ialloc_count_inodes_rec(
 	struct xfs_btree_cur		*cur,
-	union xfs_btree_rec		*rec,
+	const union xfs_btree_rec	*rec,
 	void				*priv)
 {
 	struct xfs_inobt_rec_incore	irec;
diff --git a/fs/xfs/libxfs/xfs_ialloc.h b/fs/xfs/libxfs/xfs_ialloc.h
index 9a2112b4ad5e..8b5c2b709022 100644
--- a/fs/xfs/libxfs/xfs_ialloc.h
+++ b/fs/xfs/libxfs/xfs_ialloc.h
@@ -106,7 +106,8 @@ int xfs_read_agi(struct xfs_mount *mp, struct xfs_trans *tp,
 		xfs_agnumber_t agno, struct xfs_buf **bpp);
 
 union xfs_btree_rec;
-void xfs_inobt_btrec_to_irec(struct xfs_mount *mp, union xfs_btree_rec *rec,
+void xfs_inobt_btrec_to_irec(struct xfs_mount *mp,
+		const union xfs_btree_rec *rec,
 		struct xfs_inobt_rec_incore *irec);
 int xfs_ialloc_has_inodes_at_extent(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
diff --git a/fs/xfs/libxfs/xfs_refcount.c b/fs/xfs/libxfs/xfs_refcount.c
index 860a0c9801ba..5f46dbe8c8d9 100644
--- a/fs/xfs/libxfs/xfs_refcount.c
+++ b/fs/xfs/libxfs/xfs_refcount.c
@@ -91,7 +91,7 @@ xfs_refcount_lookup_eq(
 /* Convert on-disk record to in-core format. */
 void
 xfs_refcount_btrec_to_irec(
-	union xfs_btree_rec		*rec,
+	const union xfs_btree_rec	*rec,
 	struct xfs_refcount_irec	*irec)
 {
 	irec->rc_startblock = be32_to_cpu(rec->refc.rc_startblock);
@@ -1654,7 +1654,7 @@ struct xfs_refcount_recovery {
 STATIC int
 xfs_refcount_recover_extent(
 	struct xfs_btree_cur		*cur,
-	union xfs_btree_rec		*rec,
+	const union xfs_btree_rec	*rec,
 	void				*priv)
 {
 	struct list_head		*debris = priv;
diff --git a/fs/xfs/libxfs/xfs_refcount.h b/fs/xfs/libxfs/xfs_refcount.h
index 9f6e9aae4da0..02cb3aa405be 100644
--- a/fs/xfs/libxfs/xfs_refcount.h
+++ b/fs/xfs/libxfs/xfs_refcount.h
@@ -78,7 +78,7 @@ static inline xfs_fileoff_t xfs_refcount_max_unmap(int log_res)
 extern int xfs_refcount_has_record(struct xfs_btree_cur *cur,
 		xfs_agblock_t bno, xfs_extlen_t len, bool *exists);
 union xfs_btree_rec;
-extern void xfs_refcount_btrec_to_irec(union xfs_btree_rec *rec,
+extern void xfs_refcount_btrec_to_irec(const union xfs_btree_rec *rec,
 		struct xfs_refcount_irec *irec);
 extern int xfs_refcount_insert(struct xfs_btree_cur *cur,
 		struct xfs_refcount_irec *irec, int *stat);
diff --git a/fs/xfs/libxfs/xfs_rmap.c b/fs/xfs/libxfs/xfs_rmap.c
index c38342b27935..76dc79f85dff 100644
--- a/fs/xfs/libxfs/xfs_rmap.c
+++ b/fs/xfs/libxfs/xfs_rmap.c
@@ -179,8 +179,8 @@ xfs_rmap_delete(
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
@@ -255,9 +255,9 @@ struct xfs_find_left_neighbor_info {
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
 
@@ -331,9 +331,9 @@ xfs_rmap_find_left_neighbor(
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
 
@@ -2278,9 +2278,9 @@ struct xfs_rmap_query_range_info {
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
@@ -2707,7 +2707,7 @@ struct xfs_rmap_key_state {
 STATIC int
 xfs_rmap_has_other_keys_helper(
 	struct xfs_btree_cur		*cur,
-	struct xfs_rmap_irec		*rec,
+	const struct xfs_rmap_irec	*rec,
 	void				*priv)
 {
 	struct xfs_rmap_key_state	*rks = priv;
diff --git a/fs/xfs/libxfs/xfs_rmap.h b/fs/xfs/libxfs/xfs_rmap.h
index 1354efc4ddab..fd67904ed446 100644
--- a/fs/xfs/libxfs/xfs_rmap.h
+++ b/fs/xfs/libxfs/xfs_rmap.h
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
diff --git a/fs/xfs/scrub/agheader.c b/fs/xfs/scrub/agheader.c
index efd8b5a9f6b2..f99a92f361d7 100644
--- a/fs/xfs/scrub/agheader.c
+++ b/fs/xfs/scrub/agheader.c
@@ -357,7 +357,7 @@ xchk_superblock(
 STATIC int
 xchk_agf_record_bno_lengths(
 	struct xfs_btree_cur		*cur,
-	struct xfs_alloc_rec_incore	*rec,
+	const struct xfs_alloc_rec_incore *rec,
 	void				*priv)
 {
 	xfs_extlen_t			*blocks = priv;
diff --git a/fs/xfs/scrub/agheader_repair.c b/fs/xfs/scrub/agheader_repair.c
index 87da9bca8e57..83ef97aa1cab 100644
--- a/fs/xfs/scrub/agheader_repair.c
+++ b/fs/xfs/scrub/agheader_repair.c
@@ -70,7 +70,7 @@ struct xrep_agf_allocbt {
 STATIC int
 xrep_agf_walk_allocbt(
 	struct xfs_btree_cur		*cur,
-	struct xfs_alloc_rec_incore	*rec,
+	const struct xfs_alloc_rec_incore *rec,
 	void				*priv)
 {
 	struct xrep_agf_allocbt		*raa = priv;
@@ -443,7 +443,7 @@ struct xrep_agfl {
 STATIC int
 xrep_agfl_walk_rmap(
 	struct xfs_btree_cur	*cur,
-	struct xfs_rmap_irec	*rec,
+	const struct xfs_rmap_irec *rec,
 	void			*priv)
 {
 	struct xrep_agfl	*ra = priv;
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 678afceeb16b..ea701f5ca32b 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -473,10 +473,11 @@ struct xchk_bmap_check_rmap_info {
 STATIC int
 xchk_bmap_check_rmap(
 	struct xfs_btree_cur		*cur,
-	struct xfs_rmap_irec		*rec,
+	const struct xfs_rmap_irec	*rec,
 	void				*priv)
 {
 	struct xfs_bmbt_irec		irec;
+	struct xfs_rmap_irec		check_rec;
 	struct xchk_bmap_check_rmap_info	*sbcri = priv;
 	struct xfs_ifork		*ifp;
 	struct xfs_scrub		*sc = sbcri->sc;
@@ -510,28 +511,30 @@ xchk_bmap_check_rmap(
 	 * length, so we have to loop through the bmbt to make sure that the
 	 * entire rmap is covered by bmbt records.
 	 */
+	check_rec = *rec;
 	while (have_map) {
-		if (irec.br_startoff != rec->rm_offset)
+		if (irec.br_startoff != check_rec.rm_offset)
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
-					rec->rm_offset);
+					check_rec.rm_offset);
 		if (irec.br_startblock != XFS_AGB_TO_FSB(sc->mp,
-				cur->bc_ag.pag->pag_agno, rec->rm_startblock))
+				cur->bc_ag.pag->pag_agno,
+				check_rec.rm_startblock))
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
-					rec->rm_offset);
-		if (irec.br_blockcount > rec->rm_blockcount)
+					check_rec.rm_offset);
+		if (irec.br_blockcount > check_rec.rm_blockcount)
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
-					rec->rm_offset);
+					check_rec.rm_offset);
 		if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
 			break;
-		rec->rm_startblock += irec.br_blockcount;
-		rec->rm_offset += irec.br_blockcount;
-		rec->rm_blockcount -= irec.br_blockcount;
-		if (rec->rm_blockcount == 0)
+		check_rec.rm_startblock += irec.br_blockcount;
+		check_rec.rm_offset += irec.br_blockcount;
+		check_rec.rm_blockcount -= irec.br_blockcount;
+		if (check_rec.rm_blockcount == 0)
 			break;
 		have_map = xfs_iext_next_extent(ifp, &sbcri->icur, &irec);
 		if (!have_map)
 			xchk_fblock_set_corrupt(sc, sbcri->whichfork,
-					rec->rm_offset);
+					check_rec.rm_offset);
 	}
 
 out:
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 691cf243c2c9..439f035a3a30 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -324,7 +324,7 @@ struct xchk_rmap_ownedby_info {
 STATIC int
 xchk_count_rmap_ownedby_irec(
 	struct xfs_btree_cur		*cur,
-	struct xfs_rmap_irec		*rec,
+	const struct xfs_rmap_irec	*rec,
 	void				*priv)
 {
 	struct xchk_rmap_ownedby_info	*sroi = priv;
diff --git a/fs/xfs/scrub/refcount.c b/fs/xfs/scrub/refcount.c
index 7014b7408bad..c547e5ca3207 100644
--- a/fs/xfs/scrub/refcount.c
+++ b/fs/xfs/scrub/refcount.c
@@ -91,7 +91,7 @@ struct xchk_refcnt_check {
 STATIC int
 xchk_refcountbt_rmap_check(
 	struct xfs_btree_cur		*cur,
-	struct xfs_rmap_irec		*rec,
+	const struct xfs_rmap_irec	*rec,
 	void				*priv)
 {
 	struct xchk_refcnt_check	*refchk = priv;
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 7431e181d001..ebe3c08b4478 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -833,7 +833,7 @@ xrep_findroot_block(
 STATIC int
 xrep_findroot_rmap(
 	struct xfs_btree_cur		*cur,
-	struct xfs_rmap_irec		*rec,
+	const struct xfs_rmap_irec	*rec,
 	void				*priv)
 {
 	struct xrep_findroot		*ri = priv;
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 37c0e2266c85..8fa012057405 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -41,7 +41,7 @@ xchk_setup_rt(
 STATIC int
 xchk_rtbitmap_rec(
 	struct xfs_trans	*tp,
-	struct xfs_rtalloc_rec	*rec,
+	const struct xfs_rtalloc_rec *rec,
 	void			*priv)
 {
 	struct xfs_scrub	*sc = priv;
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 5a67e543f9d0..fe376b8fc7f6 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -111,8 +111,8 @@ xfs_fsmap_owner_to_rmap(
 /* Convert an rmapbt owner into an fsmap owner. */
 static int
 xfs_fsmap_owner_from_rmap(
-	struct xfs_fsmap	*dest,
-	struct xfs_rmap_irec	*src)
+	struct xfs_fsmap		*dest,
+	const struct xfs_rmap_irec	*src)
 {
 	dest->fmr_flags = 0;
 	if (!XFS_RMAP_NON_INODE_OWNER(src->rm_owner)) {
@@ -192,7 +192,7 @@ STATIC int
 xfs_getfsmap_is_shared(
 	struct xfs_trans		*tp,
 	struct xfs_getfsmap_info	*info,
-	struct xfs_rmap_irec		*rec,
+	const struct xfs_rmap_irec	*rec,
 	bool				*stat)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
@@ -245,7 +245,7 @@ STATIC int
 xfs_getfsmap_helper(
 	struct xfs_trans		*tp,
 	struct xfs_getfsmap_info	*info,
-	struct xfs_rmap_irec		*rec,
+	const struct xfs_rmap_irec	*rec,
 	xfs_daddr_t			rec_daddr)
 {
 	struct xfs_fsmap		fmr;
@@ -347,7 +347,7 @@ xfs_getfsmap_helper(
 STATIC int
 xfs_getfsmap_datadev_helper(
 	struct xfs_btree_cur		*cur,
-	struct xfs_rmap_irec		*rec,
+	const struct xfs_rmap_irec	*rec,
 	void				*priv)
 {
 	struct xfs_mount		*mp = cur->bc_mp;
@@ -365,7 +365,7 @@ xfs_getfsmap_datadev_helper(
 STATIC int
 xfs_getfsmap_datadev_bnobt_helper(
 	struct xfs_btree_cur		*cur,
-	struct xfs_alloc_rec_incore	*rec,
+	const struct xfs_alloc_rec_incore *rec,
 	void				*priv)
 {
 	struct xfs_mount		*mp = cur->bc_mp;
@@ -451,7 +451,7 @@ xfs_getfsmap_logdev(
 STATIC int
 xfs_getfsmap_rtdev_rtbitmap_helper(
 	struct xfs_trans		*tp,
-	struct xfs_rtalloc_rec		*rec,
+	const struct xfs_rtalloc_rec	*rec,
 	void				*priv)
 {
 	struct xfs_mount		*mp = tp->t_mountp;
diff --git a/fs/xfs/xfs_rtalloc.h b/fs/xfs/xfs_rtalloc.h
index 51097cb24311..91b00289509b 100644
--- a/fs/xfs/xfs_rtalloc.h
+++ b/fs/xfs/xfs_rtalloc.h
@@ -22,9 +22,9 @@ struct xfs_rtalloc_rec {
 };
 
 typedef int (*xfs_rtalloc_query_range_fn)(
-	struct xfs_trans	*tp,
-	struct xfs_rtalloc_rec	*rec,
-	void			*priv);
+	struct xfs_trans		*tp,
+	const struct xfs_rtalloc_rec	*rec,
+	void				*priv);
 
 #ifdef CONFIG_XFS_RT
 /*
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 84199e29845d..7e04a6adb349 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -3395,7 +3395,7 @@ DEFINE_INODE_ERROR_EVENT(xfs_swap_extent_rmap_error);
 /* fsmap traces */
 DECLARE_EVENT_CLASS(xfs_fsmap_class,
 	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_agnumber_t agno,
-		 struct xfs_rmap_irec *rmap),
+		 const struct xfs_rmap_irec *rmap),
 	TP_ARGS(mp, keydev, agno, rmap),
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
@@ -3430,7 +3430,7 @@ DECLARE_EVENT_CLASS(xfs_fsmap_class,
 #define DEFINE_FSMAP_EVENT(name) \
 DEFINE_EVENT(xfs_fsmap_class, name, \
 	TP_PROTO(struct xfs_mount *mp, u32 keydev, xfs_agnumber_t agno, \
-		 struct xfs_rmap_irec *rmap), \
+		 const struct xfs_rmap_irec *rmap), \
 	TP_ARGS(mp, keydev, agno, rmap))
 DEFINE_FSMAP_EVENT(xfs_fsmap_low_key);
 DEFINE_FSMAP_EVENT(xfs_fsmap_high_key);

