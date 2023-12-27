Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDCE31362
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OKWMy4fH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AA97C433C7;
	Mon,  1 Jan 2024 00:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704069301;
	bh=VDSSXF/UqFWdXoRt6gQABgLyjg/6NQ+YK6xBBmm9vek=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=OKWMy4fH+WL5kcm/5vYz9RyLHSS3jWc6Zg+Ov9bZ+qYvXklN6OhhAUN2DMHPRWo+3
	 6scTxqIu5cVEc4aotj+g8zBwXozDMjJTUCtJ2Ww5AX5HL/xBvYTt8VclaG6MNXJ/uS
	 wPqZWMkfqDlE3fQsLAC0QyhqRAKG7JtSEi4sMGwRpUF09SpChid8lz+Yvn4wmeLSRr
	 xdM9pEnopU96k9wFb0RzIFDB395DDyOQJYi/Yq3vnhdCFF+L2fdBb6KDrQjOyXi9Ec
	 8jtRcD+dLFPAJdcg9igzdqh4s34/A2GJxDFOEnQuzavEB1oZ6Q50R0jd+vCpa1f9Sm
	 RpsFAzl5e4gLA==
Date: Sun, 31 Dec 2023 16:35:01 +9900
Subject: [PATCH 34/42] xfs_repair: check existing realtime refcountbt entries
 against observed refcounts
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405017580.1817107.15301166244033034772.stgit@frogsfrogsfrogs>
In-Reply-To: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
References: <170405017092.1817107.5442809166380700367.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

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
 repair/rmap.c            |  196 +++++++++++++++++++++++++++++++++++-----------
 repair/rmap.h            |    4 +
 5 files changed, 166 insertions(+), 48 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 36e09b3a237..cfa70778262 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -295,6 +295,7 @@
 
 #define xfs_rtrefcountbt_create_path	libxfs_rtrefcountbt_create_path
 #define xfs_rtrefcountbt_droot_maxrecs	libxfs_rtrefcountbt_droot_maxrecs
+#define xfs_rtrefcountbt_init_cursor	libxfs_rtrefcountbt_init_cursor
 #define xfs_rtrefcountbt_maxlevels_ondisk	libxfs_rtrefcountbt_maxlevels_ondisk
 #define xfs_rtrefcountbt_maxrecs	libxfs_rtrefcountbt_maxrecs
 
diff --git a/repair/agbtree.c b/repair/agbtree.c
index a401c80da38..90863b0dd7d 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -746,7 +746,7 @@ build_refcount_tree(
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
index 38a508ced16..51431808db2 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1942,10 +1942,11 @@ refcount_record_count(
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
@@ -1970,56 +1971,18 @@ refcount_avoid_check(
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
-	clear_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
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
@@ -2030,7 +1993,7 @@ check_refcounts(
 			do_warn(
 _("Could not read reference count record for (%u/%u).\n"),
 					agno, rl_rec->rc_startblock);
-			goto err_cur;
+			return error;
 		}
 		if (!have) {
 			do_warn(
@@ -2045,7 +2008,7 @@ _("Missing reference count record for (%u/%u) len %u count %u\n"),
 			do_warn(
 _("Could not read reference count record for (%u/%u).\n"),
 					agno, rl_rec->rc_startblock);
-			goto err_cur;
+			return error;
 		}
 		if (!i) {
 			do_warn(
@@ -2075,6 +2038,59 @@ _("Incorrect reference count: saw (%u/%u) len %u nlinks %u; should be (%u/%u) le
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
+		do_warn(_("Could not read AGF %u to check refcount btree.\n"),
+				agno);
+		goto err_pag;
+	}
+
+	/* Leave the per-ag data "uninitialized" since we rewrite it later */
+	clear_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
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
@@ -2084,6 +2100,94 @@ _("Incorrect reference count: saw (%u/%u) len %u nlinks %u; should be (%u/%u) le
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
+	error = threadsafe_imeta_iget(mp, ar->rg_refcount_ino, &ip);
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
+	if (xfs_inode_has_attr_fork(ip) &&
+	    !(xfs_has_metadir(mp) && xfs_has_parent(mp))) {
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
index 9663b3e3a20..45560805a4e 100644
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

