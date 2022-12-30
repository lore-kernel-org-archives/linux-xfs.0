Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5E78C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:51:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236258AbiLaCvb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236266AbiLaCvW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:51:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC4C11178
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:51:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33F99B81E70
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:51:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A54C433EF;
        Sat, 31 Dec 2022 02:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455079;
        bh=iXowG9CO/imiN9oaY/ZxxxWsxkc2u/yTtXxTvwF8gqU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kMQ60p62GfKaMXEbhEoo4D+dhn3rjBa/AQPYNzBYDqLtpHWJye0EcraMJgxuAI2Oc
         76k7dLsHvDDiMP588IAkyGL3KYVKrTbVjIWIDOo7TunHQNeWrT9SftEq8AhrEFXvPS
         367vZBWTGIFdMdtuNucsBs5gGQVIakEafQc1atdhYDqT2jpkXSlogP5g3krHqbJPLM
         GU6OKI9i7etQ3Y7oDnJoitTpxHLzijE1ku6BGDDMB+VW5/wguIAnUd1Af7T0J+RcJ1
         A1CPGspdu9W9hhuyzY+VTG+nMFhX4XeTZzGPdHhpntDgEe7Yxo2v+NjfTO7MjkZm/f
         v9z0n5tUmNGeQ==
Subject: [PATCH 34/41] xfs_repair: check existing realtime rmapbt entries
 against observed rmaps
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:00 -0800
Message-ID: <167243880045.732820.18434518096342618956.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Once we've finished collecting reverse mapping observations from the
metadata scan, check those observations against the realtime rmap btree
(particularly if we're in -n mode) to detect rtrmapbt problems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase4.c |   12 +++
 repair/rmap.c   |  221 ++++++++++++++++++++++++++++++++++++++++++-------------
 repair/rmap.h   |    2 
 3 files changed, 182 insertions(+), 53 deletions(-)


diff --git a/repair/phase4.c b/repair/phase4.c
index cfdea1460e5..b0cb805f30c 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -155,6 +155,16 @@ check_rmap_btrees(
 	rmaps_verify_btree(wq->wq_ctx, agno);
 }
 
+static void
+check_rtrmap_btrees(
+	struct workqueue *wq,
+	xfs_agnumber_t	agno,
+	void		*arg)
+{
+	rmap_add_fixed_rtgroup_rec(wq->wq_ctx, agno);
+	rtrmaps_verify_btree(wq->wq_ctx, agno);
+}
+
 static void
 compute_ag_refcounts(
 	struct workqueue*wq,
@@ -207,6 +217,8 @@ process_rmap_data(
 	create_work_queue(&wq, mp, platform_nproc());
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		queue_work(&wq, check_rmap_btrees, i, NULL);
+	for (i = 0; i < mp->m_sb.sb_rgcount; i++)
+		queue_work(&wq, check_rtrmap_btrees, i, NULL);
 	destroy_work_queue(&wq);
 
 	if (!xfs_has_reflink(mp))
diff --git a/repair/rmap.c b/repair/rmap.c
index 4d7ed98ad17..9795f0ec577 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -675,6 +675,26 @@ rmap_add_fixed_ag_rec(
 	}
 }
 
+/* Add this realtime group's fixed metadata to the incore data. */
+void
+rmap_add_fixed_rtgroup_rec(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	struct xfs_rmap_irec	rmap = {
+		.rm_startblock	= 0,
+		.rm_blockcount	= mp->m_sb.sb_rextsize,
+		.rm_owner	= XFS_RMAP_OWN_FS,
+		.rm_offset	= 0,
+		.rm_flags	= 0,
+	};
+
+	if (!rmap_needs_work(mp))
+		return;
+
+	rmap_add_mem_rec(mp, true, rgno, &rmap);
+}
+
 /*
  * Copy the per-AG btree reverse-mapping data into the rmapbt.
  *
@@ -1324,62 +1344,25 @@ rmap_is_good(
 #undef NEXTP
 #undef NEXTL
 
-/*
- * Compare the observed reverse mappings against what's in the ag btree.
- */
-void
-rmaps_verify_btree(
-	struct xfs_mount	*mp,
-	xfs_agnumber_t		agno)
+static int
+rmap_compare_records(
+	struct rmap_mem_cur	*rm_cur,
+	struct xfs_btree_cur	*bt_cur,
+	unsigned int		group)
 {
-	struct rmap_mem_cur	rm_cur;
 	struct xfs_rmap_irec	rm_rec;
 	struct xfs_rmap_irec	tmp;
-	struct xfs_btree_cur	*bt_cur = NULL;
-	struct xfs_buf		*agbp = NULL;
-	struct xfs_perag	*pag = NULL;
 	int			have;
 	int			error;
 
-	if (!xfs_has_rmapbt(mp) || add_rmapbt)
-		return;
-	if (rmapbt_suspect) {
-		if (no_modify && agno == 0)
-			do_warn(_("would rebuild corrupt rmap btrees.\n"));
-		return;
-	}
-
-	/* Create cursors to rmap structures */
-	error = rmap_init_mem_cursor(mp, NULL, false, agno, &rm_cur);
-	if (error) {
-		do_warn(_("Not enough memory to check reverse mappings.\n"));
-		return;
-	}
-
-	pag = libxfs_perag_get(mp, agno);
-	error = -libxfs_alloc_read_agf(pag, NULL, 0, &agbp);
-	if (error) {
-		do_warn(_("Could not read AGF %u to check rmap btree.\n"),
-				agno);
-		goto err_pag;
-	}
-
-	/* Leave the per-ag data "uninitialized" since we rewrite it later */
-	pag->pagf_init = 0;
-
-	bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, pag);
-	if (!bt_cur) {
-		do_warn(_("Not enough memory to check reverse mappings.\n"));
-		goto err_agf;
-	}
-
-	while ((error = rmap_get_mem_rec(&rm_cur, &rm_rec)) == 1) {
+	while ((error = rmap_get_mem_rec(rm_cur, &rm_rec)) == 1) {
 		error = rmap_lookup(bt_cur, &rm_rec, &tmp, &have);
 		if (error) {
 			do_warn(
 _("Could not read reverse-mapping record for (%u/%u).\n"),
-					agno, rm_rec.rm_startblock);
-			goto err_cur;
+					group,
+					rm_rec.rm_startblock);
+			return error;
 		}
 
 		/*
@@ -1394,15 +1377,15 @@ _("Could not read reverse-mapping record for (%u/%u).\n"),
 			if (error) {
 				do_warn(
 _("Could not read reverse-mapping record for (%u/%u).\n"),
-						agno, rm_rec.rm_startblock);
-				goto err_cur;
+						group, rm_rec.rm_startblock);
+				return error;
 			}
 		}
 		if (!have) {
 			do_warn(
 _("Missing reverse-mapping record for (%u/%u) %slen %u owner %"PRId64" \
 %s%soff %"PRIu64"\n"),
-				agno, rm_rec.rm_startblock,
+				group, rm_rec.rm_startblock,
 				(rm_rec.rm_flags & XFS_RMAP_UNWRITTEN) ?
 					_("unwritten ") : "",
 				rm_rec.rm_blockcount,
@@ -1415,12 +1398,12 @@ _("Missing reverse-mapping record for (%u/%u) %slen %u owner %"PRId64" \
 			continue;
 		}
 
-		/* Compare each refcount observation against the btree's */
+		/* Compare each rmap observation against the btree's */
 		if (!rmap_is_good(&rm_rec, &tmp)) {
 			do_warn(
 _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
 %"PRIu64"; should be (%u/%u) %slen %u owner %"PRId64" %s%soff %"PRIu64"\n"),
-				agno, tmp.rm_startblock,
+				group, tmp.rm_startblock,
 				(tmp.rm_flags & XFS_RMAP_UNWRITTEN) ?
 					_("unwritten ") : "",
 				tmp.rm_blockcount,
@@ -1430,7 +1413,7 @@ _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
 				(tmp.rm_flags & XFS_RMAP_BMBT_BLOCK) ?
 					_("bmbt ") : "",
 				tmp.rm_offset,
-				agno, rm_rec.rm_startblock,
+				group, rm_rec.rm_startblock,
 				(rm_rec.rm_flags & XFS_RMAP_UNWRITTEN) ?
 					_("unwritten ") : "",
 				rm_rec.rm_blockcount,
@@ -1443,8 +1426,61 @@ _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
 		}
 	}
 
+	return error;
+}
+
+/*
+ * Compare the observed reverse mappings against what's in the ag btree.
+ */
+void
+rmaps_verify_btree(
+	struct xfs_mount	*mp,
+	xfs_agnumber_t		agno)
+{
+	struct rmap_mem_cur	rm_cur;
+	struct xfs_btree_cur	*bt_cur = NULL;
+	struct xfs_buf		*agbp = NULL;
+	struct xfs_perag	*pag = NULL;
+	int			error;
+
+	if (!xfs_has_rmapbt(mp) || add_rmapbt)
+		return;
+	if (rmapbt_suspect) {
+		if (no_modify && agno == 0)
+			do_warn(_("would rebuild corrupt rmap btrees.\n"));
+		return;
+	}
+
+	/* Create cursors to rmap structures */
+	error = rmap_init_mem_cursor(mp, NULL, false, agno, &rm_cur);
+	if (error) {
+		do_warn(_("Not enough memory to check reverse mappings.\n"));
+		return;
+	}
+
+	pag = libxfs_perag_get(mp, agno);
+	error = -libxfs_alloc_read_agf(pag, NULL, 0, &agbp);
+	if (error) {
+		do_warn(_("Could not read AGF %u to check rmap btree.\n"),
+				agno);
+		goto err_pag;
+	}
+
+	/* Leave the per-ag data "uninitialized" since we rewrite it later */
+	pag->pagf_init = 0;
+
+	bt_cur = libxfs_rmapbt_init_cursor(mp, NULL, agbp, pag);
+	if (!bt_cur) {
+		do_warn(_("Not enough memory to check reverse mappings.\n"));
+		goto err_agf;
+	}
+
+	error = rmap_compare_records(&rm_cur, bt_cur, agno);
+	if (error)
+		goto err_cur;
+
 err_cur:
-	libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+	libxfs_btree_del_cursor(bt_cur, error);
 err_agf:
 	libxfs_buf_relse(agbp);
 err_pag:
@@ -1452,6 +1488,85 @@ _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
 	rmap_free_mem_cursor(NULL, &rm_cur, error);
 }
 
+/*
+ * Compare the observed reverse mappings against what's in the rtgroup btree.
+ */
+void
+rtrmaps_verify_btree(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	struct rmap_mem_cur	rm_cur;
+	struct xfs_btree_cur	*bt_cur = NULL;
+	struct xfs_rtgroup	*rtg = NULL;
+	struct xfs_ag_rmap	*ar = rmaps_for_group(true, rgno);
+	struct xfs_inode	*ip = NULL;
+	int			error;
+
+	if (!xfs_has_rmapbt(mp) || add_rmapbt)
+		return;
+	if (rmapbt_suspect) {
+		if (no_modify && rgno == 0)
+			do_warn(_("would rebuild corrupt rmap btrees.\n"));
+		return;
+	}
+
+	/* Create cursors to rmap structures */
+	error = rmap_init_mem_cursor(mp, NULL, true, rgno, &rm_cur);
+	if (error) {
+		do_warn(_("Not enough memory to check reverse mappings.\n"));
+		return;
+	}
+
+	rtg = libxfs_rtgroup_get(mp, rgno);
+	if (!rtg) {
+		do_warn(_("Could not load rtgroup %u.\n"), rgno);
+		goto err_rcur;
+	}
+
+	error = -libxfs_imeta_iget(mp, ar->rg_rmap_ino, XFS_DIR3_FT_REG_FILE,
+				&ip);
+	if (error) {
+		do_warn(
+_("Could not load rtgroup %u rmap inode, error %d.\n"),
+				rgno, error);
+		goto err_rtg;
+	}
+
+	if (ip->i_df.if_format != XFS_DINODE_FMT_RMAP) {
+		do_warn(
+_("rtgroup %u rmap inode has wrong format 0x%x, expected 0x%x\n"),
+				rgno, ip->i_df.if_format,
+				XFS_DINODE_FMT_RMAP);
+		goto err_ino;
+	}
+
+	if (xfs_inode_has_attr_fork(ip)) {
+		do_warn(
+_("rtgroup %u rmap inode should not have extended attributes\n"), rgno);
+		goto err_ino;
+	}
+
+	bt_cur = libxfs_rtrmapbt_init_cursor(mp, NULL, rtg, ip);
+	if (!bt_cur) {
+		do_warn(_("Not enough memory to check reverse mappings.\n"));
+		goto err_ino;
+	}
+
+	error = rmap_compare_records(&rm_cur, bt_cur, rgno);
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
+	rmap_free_mem_cursor(NULL, &rm_cur, error);
+}
+
 /*
  * Compare the key fields of two rmap records -- positive if key1 > key2,
  * negative if key1 < key2, and zero if equal.
diff --git a/repair/rmap.h b/repair/rmap.h
index 0cb5759086b..c7c09046a8a 100644
--- a/repair/rmap.h
+++ b/repair/rmap.h
@@ -21,6 +21,7 @@ void rmap_add_bmbt_rec(struct xfs_mount *mp, xfs_ino_t ino, int whichfork,
 bool rmaps_are_mergeable(struct xfs_rmap_irec *r1, struct xfs_rmap_irec *r2);
 
 void rmap_add_fixed_ag_rec(struct xfs_mount *mp, xfs_agnumber_t agno);
+void rmap_add_fixed_rtgroup_rec(struct xfs_mount *mp, xfs_rgnumber_t rgno);
 
 int rmap_add_agbtree_mapping(struct xfs_mount *mp, xfs_agnumber_t agno,
 		xfs_agblock_t agbno, xfs_extlen_t len, uint64_t owner);
@@ -30,6 +31,7 @@ uint64_t rmap_record_count(struct xfs_mount *mp, bool isrt,
 		xfs_agnumber_t agno);
 extern void rmap_avoid_check(struct xfs_mount *mp);
 void rmaps_verify_btree(struct xfs_mount *mp, xfs_agnumber_t agno);
+void rtrmaps_verify_btree(struct xfs_mount *mp, xfs_rgnumber_t rgno);
 
 extern int64_t rmap_diffkeys(struct xfs_rmap_irec *kp1,
 		struct xfs_rmap_irec *kp2);

