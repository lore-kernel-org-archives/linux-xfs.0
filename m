Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7F37EE
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aTodIhOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D376C433C8;
	Mon,  1 Jan 2024 00:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068441;
	bh=gZed8OOJnTwhuniXlz1J2LT8I9K6Y5wINqSPMnH7TT4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aTodIhOdoUf7lDExIbKGK/FYzSb7CyjQlNGKgEXCKtTI7BVW1fYVkYWmQxQG7W2I1
	 5V2EMSdOcKBKCcZcQPGBSxLSnvvayIWwlLRckDfrIiR30n48G6AXTPz0/n/TzIVUw9
	 nzXdgTmw5YPOVf+WRDdrmc1plCo3t3dxAEOYgG1VnD0v4DBECwuljGpaJ7kSrkh4py
	 T8tqoshMxoz6V4WnQ0XQZFUDMh3cVmnIOpBYTQkJPnUEfJipmvvx9XyESr05blUqTX
	 il0cOsv7CG2OttUdIsoZEVtGSlNzXUMcNnELRTjjlcu6y+PtQVz9O7r94FL7k6bQST
	 Uvm926kypdN0w==
Date: Sun, 31 Dec 2023 16:20:40 +9900
Subject: [PATCH 39/47] xfs_repair: check existing realtime rmapbt entries
 against observed rmaps
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405015833.1815505.14998533920029160.stgit@frogsfrogsfrogs>
In-Reply-To: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
References: <170405015275.1815505.16749821217116487639.stgit@frogsfrogsfrogs>
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
metadata scan, check those observations against the realtime rmap btree
(particularly if we're in -n mode) to detect rtrmapbt problems.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase4.c |   12 +++
 repair/rmap.c   |  262 ++++++++++++++++++++++++++++++++++++++++++++-----------
 repair/rmap.h   |    2 
 3 files changed, 223 insertions(+), 53 deletions(-)


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
index b7e7fbe3f47..5ac7188f12e 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -17,6 +17,7 @@
 #include "libxfs/xfile.h"
 #include "libxfs/xfbtree.h"
 #include "rcbag.h"
+#include "prefetch.h"
 
 #undef RMAP_DEBUG
 
@@ -682,6 +683,26 @@ rmap_add_fixed_ag_rec(
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
@@ -1331,62 +1352,25 @@ rmap_is_good(
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
-	clear_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
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
@@ -1401,15 +1385,15 @@ _("Could not read reverse-mapping record for (%u/%u).\n"),
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
@@ -1422,12 +1406,12 @@ _("Missing reverse-mapping record for (%u/%u) %slen %u owner %"PRId64" \
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
@@ -1437,7 +1421,7 @@ _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
 				(tmp.rm_flags & XFS_RMAP_BMBT_BLOCK) ?
 					_("bmbt ") : "",
 				tmp.rm_offset,
-				agno, rm_rec.rm_startblock,
+				group, rm_rec.rm_startblock,
 				(rm_rec.rm_flags & XFS_RMAP_UNWRITTEN) ?
 					_("unwritten ") : "",
 				rm_rec.rm_blockcount,
@@ -1450,8 +1434,61 @@ _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
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
+	clear_bit(XFS_AGSTATE_AGF_INIT, &pag->pag_opstate);
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
@@ -1459,6 +1496,125 @@ _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
 	rmap_free_mem_cursor(NULL, &rm_cur, error);
 }
 
+/*
+ * Thread-safe version of xfs_imeta_iget.
+ *
+ * In the kernel, xfs_imeta_iget requires a transaction so that the untrusted
+ * lookup will not livelock the mount process if the inobt contains a cycle.
+ * However, the userspace buffer cache only locks buffers if it's told to.
+ * That only happens when prefetch is enabled.
+ *
+ * Depending on allocation patterns, realtime metadata inodes can share the
+ * same inode cluster buffer.  We don't want libxfs_trans_bjoin in racing iget
+ * calls to corrupt the incore buffer state, so we impose our own lock here.
+ * Evidently support orgs will sometimes use no-prefetch lockless mode as a
+ * last resort if repair gets stuck on a buffer lock elsewhere.
+ */
+static inline int
+threadsafe_imeta_iget(
+	struct xfs_mount	*mp,
+	xfs_ino_t		ino,
+	struct xfs_inode	**ipp)
+{
+	static pthread_mutex_t	lock = PTHREAD_MUTEX_INITIALIZER;
+	struct xfs_trans	*tp;
+	int			error;
+
+	error = -libxfs_trans_alloc_empty(mp, &tp);
+	if (error)
+		return error;
+
+	if (do_prefetch) {
+		error = -libxfs_imeta_iget(tp, ino, XFS_DIR3_FT_REG_FILE, ipp);
+	} else {
+		pthread_mutex_lock(&lock);
+		error = -libxfs_imeta_iget(tp, ino, XFS_DIR3_FT_REG_FILE, ipp);
+		pthread_mutex_unlock(&lock);
+	}
+	libxfs_trans_cancel(tp);
+
+	return error;
+}
+
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
+	error = threadsafe_imeta_iget(mp, ar->rg_rmap_ino, &ip);
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
+	if (xfs_inode_has_attr_fork(ip) &&
+	    !(xfs_has_metadir(mp) && xfs_has_parent(mp))) {
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
index dd55ba3cc29..dcd834ef242 100644
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

