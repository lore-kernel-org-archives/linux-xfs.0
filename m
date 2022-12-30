Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58488C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbiLaDDD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236258AbiLaDDB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:03:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E60615F27
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 19:03:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E99BE61D13
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 03:02:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51FF5C433D2;
        Sat, 31 Dec 2022 03:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455779;
        bh=GtR/6eRIWNjpZsNCjEDlUOGMmuHE74lOpRDg6InXxwE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jEuu+eF3rhozJ8RJ5uTJB4OG1irynArRqM+k99yBsgJoGqQjQgBKYRlSKHB4K25Ad
         +WEM/qNJzqCN8ydddmOzexunTNRQwDZXkVreQf7ks4nOZGtz4tb+07qg77t6IirsP7
         ZUKdGY8+yTZbw2dZZ8/IGkqnvy1eg3F2eO6d9qnV4ai+f19Xi3+HNsWjKqFPFsoCh1
         97Qh5/+IjG7yPzigZ6myD4uBX2YcEqkGNcf3RIJsVKUrYUL4L3nUOEsJ/2zOw02+Ed
         xvujpBGo7I5cqkuO3MI3soi/g4lHyUJoDFXFQGJsmdMCocnuhPn+3VWB6AVnroMqEw
         l5e12eqb25DFA==
Subject: [PATCH 34/41] xfs_repair: check existing realtime refcountbt entries
 against observed refcounts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:12 -0800
Message-ID: <167243881220.734096.12899307970773271970.stgit@magnolia>
In-Reply-To: <167243880752.734096.171910706541747310.stgit@magnolia>
References: <167243880752.734096.171910706541747310.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Once we've finished collecting reverse mapping observations from the
metadata scan, check those observations against the realtime refcount
btree (particularly if we're in -n mode) to detect rtrefcountbt
problems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 
 repair/agbtree.c         |    2 
 repair/phase4.c          |   11 +++
 repair/rmap.c            |  200 +++++++++++++++++++++++++++++++++++-----------
 repair/rmap.h            |    4 +
 5 files changed, 170 insertions(+), 48 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index a1c6efd5ca9..7f52993aee4 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -252,6 +252,7 @@
 
 #define xfs_rtrefcountbt_create_path	libxfs_rtrefcountbt_create_path
 #define xfs_rtrefcountbt_droot_maxrecs	libxfs_rtrefcountbt_droot_maxrecs
+#define xfs_rtrefcountbt_init_cursor	libxfs_rtrefcountbt_init_cursor
 #define xfs_rtrefcountbt_maxlevels_ondisk	libxfs_rtrefcountbt_maxlevels_ondisk
 #define xfs_rtrefcountbt_maxrecs	libxfs_rtrefcountbt_maxrecs
 
diff --git a/repair/agbtree.c b/repair/agbtree.c
index e340e9cfc04..1eabce0104f 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -738,7 +738,7 @@ build_refcount_tree(
 {
 	int			error;
 
-	error = init_refcount_cursor(agno, &btr->slab_cursor);
+	error = init_refcount_cursor(false, agno, &btr->slab_cursor);
 	if (error)
 		do_error(
 _("Insufficient memory to construct refcount cursor.\n"));
diff --git a/repair/phase4.c b/repair/phase4.c
index e90533689e0..8d97b63b2ce 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -219,6 +219,15 @@ check_refcount_btrees(
 	check_refcounts(wq->wq_ctx, agno);
 }
 
+static void
+check_rt_refcount_btrees(
+	struct workqueue	*wq,
+	xfs_agnumber_t		agno,
+	void			*arg)
+{
+	check_rtrefcounts(wq->wq_ctx, agno);
+}
+
 static void
 process_rmap_data(
 	struct xfs_mount	*mp)
@@ -251,6 +260,8 @@ process_rmap_data(
 		queue_work(&wq, process_inode_reflink_flags, i, NULL);
 		queue_work(&wq, check_refcount_btrees, i, NULL);
 	}
+	for (i = 0; i < mp->m_sb.sb_rgcount; i++)
+		queue_work(&wq, check_rt_refcount_btrees, i, NULL);
 	destroy_work_queue(&wq);
 }
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 85fc05945c6..21062e4ac49 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1883,10 +1883,11 @@ refcount_record_count(
  */
 int
 init_refcount_cursor(
+	bool			isrt,
 	xfs_agnumber_t		agno,
 	struct xfs_slab_cursor	**cur)
 {
-	struct xfs_ag_rmap	*x = rmaps_for_group(false, agno);
+	struct xfs_ag_rmap	*x = rmaps_for_group(isrt, agno);
 
 	return init_slab_cursor(x->ar_refcount_items, NULL, cur);
 }
@@ -1911,56 +1912,18 @@ refcount_avoid_check(
 	refcbt_suspect = true;
 }
 
-/*
- * Compare the observed reference counts against what's in the ag btree.
- */
-void
-check_refcounts(
-	struct xfs_mount		*mp,
+static int
+check_refcount_records(
+	struct xfs_slab_cursor		*rl_cur,
+	struct xfs_btree_cur		*bt_cur,
 	xfs_agnumber_t			agno)
 {
 	struct xfs_refcount_irec	tmp;
-	struct xfs_slab_cursor		*rl_cur;
-	struct xfs_btree_cur		*bt_cur = NULL;
-	struct xfs_buf			*agbp = NULL;
-	struct xfs_perag		*pag = NULL;
 	struct xfs_refcount_irec	*rl_rec;
-	int				have;
 	int				i;
+	int				have;
 	int				error;
 
-	if (!xfs_has_reflink(mp) || add_reflink)
-		return;
-	if (refcbt_suspect) {
-		if (no_modify && agno == 0)
-			do_warn(_("would rebuild corrupt refcount btrees.\n"));
-		return;
-	}
-
-	/* Create cursors to refcount structures */
-	error = init_refcount_cursor(agno, &rl_cur);
-	if (error) {
-		do_warn(_("Not enough memory to check refcount data.\n"));
-		return;
-	}
-
-	pag = libxfs_perag_get(mp, agno);
-	error = -libxfs_alloc_read_agf(pag, NULL, 0, &agbp);
-	if (error) {
-		do_warn(_("Could not read AGF %u to check refcount btree.\n"),
-				agno);
-		goto err_pag;
-	}
-
-	/* Leave the per-ag data "uninitialized" since we rewrite it later */
-	pag->pagf_init = 0;
-
-	bt_cur = libxfs_refcountbt_init_cursor(mp, NULL, agbp, pag);
-	if (!bt_cur) {
-		do_warn(_("Not enough memory to check refcount data.\n"));
-		goto err_agf;
-	}
-
 	rl_rec = pop_slab_cursor(rl_cur);
 	while (rl_rec) {
 		/* Look for a refcount record in the btree */
@@ -1971,7 +1934,7 @@ check_refcounts(
 			do_warn(
 _("Could not read reference count record for (%u/%u).\n"),
 					agno, rl_rec->rc_startblock);
-			goto err_cur;
+			return error;
 		}
 		if (!have) {
 			do_warn(
@@ -1986,7 +1949,7 @@ _("Missing reference count record for (%u/%u) len %u count %u\n"),
 			do_warn(
 _("Could not read reference count record for (%u/%u).\n"),
 					agno, rl_rec->rc_startblock);
-			goto err_cur;
+			return error;
 		}
 		if (!i) {
 			do_warn(
@@ -2016,6 +1979,63 @@ _("Incorrect reference count: saw (%u/%u) len %u nlinks %u; should be (%u/%u) le
 		rl_rec = pop_slab_cursor(rl_cur);
 	}
 
+	return 0;
+}
+
+/*
+ * Compare the observed reference counts against what's in the ag btree.
+ */
+void
+check_refcounts(
+	struct xfs_mount		*mp,
+	xfs_agnumber_t			agno)
+{
+	struct xfs_slab_cursor		*rl_cur;
+	struct xfs_btree_cur		*bt_cur = NULL;
+	struct xfs_buf			*agbp = NULL;
+	struct xfs_perag		*pag = NULL;
+	int				error;
+
+	if (!xfs_has_reflink(mp) || add_reflink)
+		return;
+	if (refcbt_suspect) {
+		if (no_modify && agno == 0)
+			do_warn(_("would rebuild corrupt refcount btrees.\n"));
+		return;
+	}
+
+	/* Create cursors to refcount structures */
+	error = init_refcount_cursor(false, agno, &rl_cur);
+	if (error) {
+		do_warn(_("Not enough memory to check refcount data.\n"));
+		return;
+	}
+
+	pag = libxfs_perag_get(mp, agno);
+	error = -libxfs_alloc_read_agf(pag, NULL, 0, &agbp);
+	if (error) {
+		do_warn(
+_("Could not read AGF %u to check refcount btree.\n"),
+				agno);
+		goto err_pag;
+	}
+
+	/*
+	 * Leave the per-ag data "uninitialized" since we rewrite it
+	 * later.
+	 */
+	pag->pagf_init = 0;
+
+	bt_cur = libxfs_refcountbt_init_cursor(mp, NULL, agbp, pag);
+	if (!bt_cur) {
+		do_warn(_("Not enough memory to check refcount data.\n"));
+		goto err_agf;
+	}
+
+	error = check_refcount_records(rl_cur, bt_cur, agno);
+	if (error)
+		goto err_cur;
+
 err_cur:
 	libxfs_btree_del_cursor(bt_cur, error);
 err_agf:
@@ -2025,6 +2045,94 @@ _("Incorrect reference count: saw (%u/%u) len %u nlinks %u; should be (%u/%u) le
 	free_slab_cursor(&rl_cur);
 }
 
+/*
+ * Compare the observed reference counts against what's in the ondisk btree.
+ */
+void
+check_rtrefcounts(
+	struct xfs_mount		*mp,
+	xfs_rgnumber_t			rgno)
+{
+	struct xfs_slab_cursor		*rl_cur;
+	struct xfs_btree_cur		*bt_cur = NULL;
+	struct xfs_rtgroup		*rtg = NULL;
+	struct xfs_inode		*ip = NULL;
+	struct xfs_ag_rmap		*ar = rmaps_for_group(true, rgno);
+	int				error;
+
+	if (!xfs_has_reflink(mp) || add_reflink)
+		return;
+	if (refcbt_suspect) {
+		if (no_modify && rgno == 0)
+			do_warn(_("would rebuild corrupt refcount btrees.\n"));
+		return;
+	}
+	if (mp->m_sb.sb_rblocks == 0) {
+		if (rmap_record_count(mp, true, rgno) != 0)
+			do_error(_("realtime refcounts but no rtdev?\n"));
+		return;
+	}
+
+	/* Create cursors to refcount structures */
+	error = init_refcount_cursor(true, rgno, &rl_cur);
+	if (error) {
+		do_warn(_("Not enough memory to check refcount data.\n"));
+		return;
+	}
+
+	rtg = libxfs_rtgroup_get(mp, rgno);
+	if (!rtg) {
+		do_warn(_("Could not load rtgroup %u.\n"), rgno);
+		goto err_rcur;
+	}
+
+	error = -libxfs_imeta_iget(mp, ar->rg_refcount_ino,
+			XFS_DIR3_FT_REG_FILE, &ip);
+	if (error) {
+		do_warn(
+_("Cannot load rtgroup %u refcount inode 0x%llx, error %d.\n"),
+				rgno,
+				(unsigned long long)ar->rg_refcount_ino,
+				error);
+		goto err_rtg;
+	}
+
+	if (ip->i_df.if_format != XFS_DINODE_FMT_REFCOUNT) {
+		do_warn(
+_("rtgroup %u refcount inode has wrong format 0x%x, expected 0x%x\n"),
+				rgno,
+				ip->i_df.if_format,
+				XFS_DINODE_FMT_REFCOUNT);
+		goto err_ino;
+	}
+
+	if (xfs_inode_has_attr_fork(ip)) {
+		do_warn(
+_("rtgroup %u refcount inode should not have extended attributes\n"),
+				rgno);
+		goto err_ino;
+	}
+
+	bt_cur = libxfs_rtrefcountbt_init_cursor(mp, NULL, rtg, ip);
+	if (!bt_cur) {
+		do_warn(_("Not enough memory to check refcount data.\n"));
+		goto err_ino;
+	}
+
+	error = check_refcount_records(rl_cur, bt_cur, rgno);
+	if (error)
+		goto err_cur;
+
+err_cur:
+	libxfs_btree_del_cursor(bt_cur, error);
+err_ino:
+	libxfs_imeta_irele(ip);
+err_rtg:
+	libxfs_rtgroup_put(rtg);
+err_rcur:
+	free_slab_cursor(&rl_cur);
+}
+
 /*
  * Regenerate the AGFL so that we don't run out of it while rebuilding the
  * rmap btree.  If skip_rmapbt is true, don't update the rmapbt (most probably
diff --git a/repair/rmap.h b/repair/rmap.h
index 4d20d90812b..9e7a4968588 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -40,9 +40,11 @@ extern void rmap_high_key_from_rec(struct xfs_rmap_irec *rec,
 
 int compute_refcounts(struct xfs_mount *mp, bool isrt, xfs_agnumber_t agno);
 uint64_t refcount_record_count(struct xfs_mount *mp, xfs_agnumber_t agno);
-extern int init_refcount_cursor(xfs_agnumber_t, struct xfs_slab_cursor **);
+int init_refcount_cursor(bool isrt, xfs_agnumber_t agno,
+		struct xfs_slab_cursor **pcur);
 extern void refcount_avoid_check(struct xfs_mount *mp);
 void check_refcounts(struct xfs_mount *mp, xfs_agnumber_t agno);
+void check_rtrefcounts(struct xfs_mount *mp, xfs_rgnumber_t rgno);
 
 extern void record_inode_reflink_flag(struct xfs_mount *, struct xfs_dinode *,
 	xfs_agnumber_t, xfs_agino_t, xfs_ino_t);

