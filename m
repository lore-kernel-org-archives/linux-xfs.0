Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8172417C9
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 23:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882841; cv=none; b=UG8Th2zBEoPH/uVzCq5quFyeVrk+ghKPUSTkVz0ANjb1MwNmSdeyYT1s16+88jOPtmX4e8S3aYlWy90WppAnE8Kv8ObpfRKZFdiTDHLM5tOhyrnsUhL+EJUNQvqWc53Cj4/Z3QPNXKrYc/OFSG5bwTRrGq1J/v8AJWzhg9rWQaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882841; c=relaxed/simple;
	bh=xxBJRip+9xi0Kjp/o1xfpnQmgLV0zakVD/a4p5JfOBI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cv5W8pjoTelSC1/3rkRWIYf6pmIACREY67lYHRModctuY91lEDSqE8jViExDWmS/WUgXH02CdBz2vQ+/0PJU5qxqqwiLRWTQQmB2BKjkScPd+cWb0Rh4gqlC9qskS1epkZwcbL7xp8AScqyAHvti/bcZMZlHB5Rjr+84qrpJsbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QDD7WHhP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QDD7WHhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23142C4CEDD;
	Thu,  6 Feb 2025 23:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882841;
	bh=xxBJRip+9xi0Kjp/o1xfpnQmgLV0zakVD/a4p5JfOBI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QDD7WHhPd2gLB8YelmrQejot2rtb8II5nM8P8xPw6uerh31S3fKZpSM6o7jA45kMl
	 DnT3vb6zEk0Hi5uYq4nTmuYitBd+fEUtsDS4B8ceICfsdYhy/6YgzUGP7Npa8+CNvW
	 MyrtnOHQ+vumyiK+WrH6nX2ZNFz+2O41C+UItwhRO7H99hY+FMkVmUH8I/vfm8gnAG
	 T04YeTYYobkTjuKWMnNo3AmCDKPBLiUZ9iQLxHX2azozXIvEkD+k9d0gtDSM8L6++n
	 cslaH6Az6bnUwcrjy8hnXvJDTQyxjnFowsi78xP7vK5KRhFRqeik4YsDIfxpQfjyOg
	 hmBJF80IdV8Nw==
Date: Thu, 06 Feb 2025 15:00:40 -0800
Subject: [PATCH 15/22] xfs_repair: check existing realtime refcountbt entries
 against observed refcounts
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888089162.2741962.5490397729857671375.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
References: <173888088900.2741962.15299153246552129567.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 
 repair/agbtree.c         |    2 
 repair/phase4.c          |   13 +++
 repair/rmap.c            |  197 +++++++++++++++++++++++++++++++++++-----------
 repair/rmap.h            |    4 +
 5 files changed, 169 insertions(+), 48 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 0dc6f0350dd0f6..b5a39856bc1e80 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -322,6 +322,7 @@
 
 #define xfs_rtrefcountbt_calc_reserves	libxfs_rtrefcountbt_calc_reserves
 #define xfs_rtrefcountbt_droot_maxrecs	libxfs_rtrefcountbt_droot_maxrecs
+#define xfs_rtrefcountbt_init_cursor	libxfs_rtrefcountbt_init_cursor
 #define xfs_rtrefcountbt_maxlevels_ondisk	libxfs_rtrefcountbt_maxlevels_ondisk
 #define xfs_rtrefcountbt_maxrecs	libxfs_rtrefcountbt_maxrecs
 
diff --git a/repair/agbtree.c b/repair/agbtree.c
index 2135147fcf9354..01066130767cb6 100644
--- a/repair/agbtree.c
+++ b/repair/agbtree.c
@@ -747,7 +747,7 @@ build_refcount_tree(
 {
 	int			error;
 
-	error = init_refcount_cursor(agno, &btr->slab_cursor);
+	error = init_refcount_cursor(false, agno, &btr->slab_cursor);
 	if (error)
 		do_error(
 _("Insufficient memory to construct refcount cursor.\n"));
diff --git a/repair/phase4.c b/repair/phase4.c
index 4cfad1a6911764..b752b4c871ea83 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -223,6 +223,15 @@ check_refcount_btrees(
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
@@ -259,6 +268,10 @@ process_rmap_data(
 		queue_work(&wq, process_inode_reflink_flags, i, NULL);
 		queue_work(&wq, check_refcount_btrees, i, NULL);
 	}
+	if (xfs_has_rtreflink(mp)) {
+		for (i = 0; i < mp->m_sb.sb_rgcount; i++)
+			queue_work(&wq, check_rt_refcount_btrees, i, NULL);
+	}
 	destroy_work_queue(&wq);
 }
 
diff --git a/repair/rmap.c b/repair/rmap.c
index 64a9f06d0ee915..638e5ea92278cb 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -1694,10 +1694,11 @@ refcount_record_count(
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
@@ -1714,56 +1715,18 @@ refcount_avoid_check(
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
 
-	if (!xfs_has_reflink(mp))
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
@@ -1774,7 +1737,7 @@ check_refcounts(
 			do_warn(
 _("Could not read reference count record for (%u/%u).\n"),
 					agno, rl_rec->rc_startblock);
-			goto err_cur;
+			return error;
 		}
 		if (!have) {
 			do_warn(
@@ -1789,7 +1752,7 @@ _("Missing reference count record for (%u/%u) len %u count %u\n"),
 			do_warn(
 _("Could not read reference count record for (%u/%u).\n"),
 					agno, rl_rec->rc_startblock);
-			goto err_cur;
+			return error;
 		}
 		if (!i) {
 			do_warn(
@@ -1819,6 +1782,59 @@ _("Incorrect reference count: saw (%u/%u) len %u nlinks %u; should be (%u/%u) le
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
+	if (!xfs_has_reflink(mp))
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
@@ -1828,6 +1844,95 @@ _("Incorrect reference count: saw (%u/%u) len %u nlinks %u; should be (%u/%u) le
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
+	int				error;
+
+	if (!xfs_has_reflink(mp))
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
+	ip = rtg_refcount(rtg);
+	if (!ip) {
+		do_warn(_("Could not find rtgroup %u refcount inode.\n"),
+			rgno);
+		goto err_rtg;
+	}
+
+	if (ip->i_df.if_format != XFS_DINODE_FMT_META_BTREE) {
+		do_warn(
+_("rtgroup %u refcount inode has wrong format 0x%x, expected 0x%x\n"),
+				rgno, ip->i_df.if_format,
+				XFS_DINODE_FMT_META_BTREE);
+		goto err_rtg;
+	}
+
+	if (ip->i_metatype != XFS_METAFILE_RTREFCOUNT) {
+		do_warn(
+_("rtgroup %u refcount inode has wrong metatype 0x%x, expected 0x%x\n"),
+				rgno, ip->i_df.if_format,
+				XFS_METAFILE_RTREFCOUNT);
+		goto err_rtg;
+	}
+
+	if (xfs_inode_has_attr_fork(ip) &&
+	    !(xfs_has_metadir(mp) && xfs_has_parent(mp))) {
+		do_warn(
+_("rtgroup %u refcount inode should not have extended attributes\n"),
+				rgno);
+		goto err_rtg;
+	}
+
+	bt_cur = libxfs_rtrefcountbt_init_cursor(NULL, rtg);
+	if (!bt_cur) {
+		do_warn(_("Not enough memory to check refcount data.\n"));
+		goto err_rtg;
+	}
+
+	error = check_refcount_records(rl_cur, bt_cur, rgno);
+	if (error)
+		goto err_cur;
+
+err_cur:
+	libxfs_btree_del_cursor(bt_cur, error);
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
index 98f2891692a6f8..80e82a4ac4c008 100644
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

