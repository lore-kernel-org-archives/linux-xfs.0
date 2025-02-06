Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5088A2417C2
	for <linux-xfs@vger.kernel.org>; Thu,  6 Feb 2025 22:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738882482; cv=none; b=MVhzrTAT8pIusS5qEwaaJf7tGzwt1m9BqMw/sdhuXsKsREVqx0hlAxFccmn7ExPex3ac0kiR5is9b0cCcuVk4y765uKabgEplfHUK4PKv1CLUJtpYRz5uHeE4XRI5RHSirFSrGWxMtssbAFKLE05JkSHFMYXR8GqjfcwvyzQYGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738882482; c=relaxed/simple;
	bh=nW2CLIoeSdAm1XoF+FA4FCg9tA0I+c1rEV1kmHcRBBM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=py9UCTh6rsR9RDtXC8HM2s3acT5cMEMHgaNzQ82hc/N7IwM35li1d3sXU0TIiaA1RabNqsNIba5f2SzOAS84gEyYBYH5rO0fvGUGByy2zpnRQ7mNQFy99s9lYbihs3Q/8VhixxM3x9iP9zEiaz40p66xnJb14mllBCPwSIlZtEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Op7uWPkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Op7uWPkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B871CC4CEDD;
	Thu,  6 Feb 2025 22:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738882481;
	bh=nW2CLIoeSdAm1XoF+FA4FCg9tA0I+c1rEV1kmHcRBBM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Op7uWPknp3WVJaF8P09giM8Kaeo7/CbvmqS/yfUW1u5cqj3iWNt+75lA281705eNu
	 XuvBpTvTmgk9Kt5/+jZO4O8UdvdOrXOP7cJrR5Fq8QiUP7uQj/X5XTDc+TVjmTgYUu
	 w/jGT3u/ot4q0GBJHWWspZmwFGN4MInwUcM3w3H+vt72ZXhg53N3vMAHTo1rspiNBB
	 ohJZLbVSJOba+BABX4G0PFvnqPRpYaz2QVJsTqrgeFE4zr8JG/xgZnFULxD4mPlYB8
	 y8OCwoFW/aMjMg3o8lb0Q1N9y5IoUUU2W5Q1A+OtgVubdaht3jViTCgMpRXa2Lx/+Z
	 fLwZnZtqmb/FQ==
Date: Thu, 06 Feb 2025 14:54:41 -0800
Subject: [PATCH 19/27] xfs_repair: check existing realtime rmapbt entries
 against observed rmaps
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173888088387.2741033.18417535290564732679.stgit@frogsfrogsfrogs>
In-Reply-To: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 repair/phase4.c |   14 +++
 repair/rmap.c   |  226 ++++++++++++++++++++++++++++++++++++++++++-------------
 repair/rmap.h   |    2 
 3 files changed, 188 insertions(+), 54 deletions(-)


diff --git a/repair/phase4.c b/repair/phase4.c
index 728d9ed84cdc7a..29efa58af33178 100644
--- a/repair/phase4.c
+++ b/repair/phase4.c
@@ -159,6 +159,16 @@ check_rmap_btrees(
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
@@ -211,6 +221,10 @@ process_rmap_data(
 	create_work_queue(&wq, mp, platform_nproc());
 	for (i = 0; i < mp->m_sb.sb_agcount; i++)
 		queue_work(&wq, check_rmap_btrees, i, NULL);
+	if (xfs_has_rtrmapbt(mp)) {
+		for (i = 0; i < mp->m_sb.sb_rgcount; i++)
+			queue_work(&wq, check_rtrmap_btrees, i, NULL);
+	}
 	destroy_work_queue(&wq);
 
 	if (!xfs_has_reflink(mp))
diff --git a/repair/rmap.c b/repair/rmap.c
index 8656c8df3cbc83..a40851b4d0dc69 100644
--- a/repair/rmap.c
+++ b/repair/rmap.c
@@ -16,6 +16,7 @@
 #include "libfrog/platform.h"
 #include "rcbag.h"
 #include "rt.h"
+#include "prefetch.h"
 
 #undef RMAP_DEBUG
 
@@ -195,8 +196,6 @@ rmaps_init(
 
 	for (i = 0; i < mp->m_sb.sb_rgcount; i++)
 		rmaps_init_rt(mp, i, &rg_rmaps[i]);
-
-	discover_rtgroup_inodes(mp);
 }
 
 /*
@@ -573,6 +572,27 @@ rmap_add_fixed_ag_rec(
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
+	if (xfs_has_rtsb(mp) && rgno == 0)
+		rmap_add_mem_rec(mp, true, rgno, &rmap);
+}
+
 /*
  * Copy the per-AG btree reverse-mapping data into the rmapbt.
  *
@@ -1213,62 +1233,25 @@ rmap_is_good(
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
+	struct xfs_btree_cur	*rm_cur,
+	struct xfs_btree_cur	*bt_cur,
+	unsigned int		group)
 {
-	struct xfs_btree_cur	*rm_cur;
 	struct xfs_rmap_irec	rm_rec;
 	struct xfs_rmap_irec	tmp;
-	struct xfs_btree_cur	*bt_cur = NULL;
-	struct xfs_buf		*agbp = NULL;
-	struct xfs_perag	*pag = NULL;
 	int			have;
 	int			error;
 
-	if (!xfs_has_rmapbt(mp))
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
 	while ((error = rmap_get_mem_rec(rm_cur, &rm_rec)) == 1) {
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
@@ -1283,15 +1266,15 @@ _("Could not read reverse-mapping record for (%u/%u).\n"),
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
@@ -1304,12 +1287,12 @@ _("Missing reverse-mapping record for (%u/%u) %slen %u owner %"PRId64" \
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
@@ -1319,7 +1302,7 @@ _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
 				(tmp.rm_flags & XFS_RMAP_BMBT_BLOCK) ?
 					_("bmbt ") : "",
 				tmp.rm_offset,
-				agno, rm_rec.rm_startblock,
+				group, rm_rec.rm_startblock,
 				(rm_rec.rm_flags & XFS_RMAP_UNWRITTEN) ?
 					_("unwritten ") : "",
 				rm_rec.rm_blockcount,
@@ -1332,8 +1315,61 @@ _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
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
+	struct xfs_btree_cur	*rm_cur;
+	struct xfs_btree_cur	*bt_cur = NULL;
+	struct xfs_buf		*agbp = NULL;
+	struct xfs_perag	*pag = NULL;
+	int			error;
+
+	if (!xfs_has_rmapbt(mp))
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
+	error = rmap_compare_records(rm_cur, bt_cur, agno);
+	if (error)
+		goto err_cur;
+
 err_cur:
-	libxfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+	libxfs_btree_del_cursor(bt_cur, error);
 err_agf:
 	libxfs_buf_relse(agbp);
 err_pag:
@@ -1341,6 +1377,88 @@ _("Incorrect reverse-mapping: saw (%u/%u) %slen %u owner %"PRId64" %s%soff \
 	libxfs_btree_del_cursor(rm_cur, error);
 }
 
+/*
+ * Compare the observed reverse mappings against what's in the rtgroup btree.
+ */
+void
+rtrmaps_verify_btree(
+	struct xfs_mount	*mp,
+	xfs_rgnumber_t		rgno)
+{
+	struct xfs_btree_cur	*rm_cur;
+	struct xfs_btree_cur	*bt_cur = NULL;
+	struct xfs_rtgroup	*rtg = NULL;
+	struct xfs_inode	*ip = NULL;
+	int			error;
+
+	if (!xfs_has_rmapbt(mp))
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
+	ip = rtg_rmap(rtg);
+	if (!ip) {
+		do_warn(_("Could not find rtgroup %u rmap inode.\n"), rgno);
+		goto err_rtg;
+	}
+
+	if (ip->i_df.if_format != XFS_DINODE_FMT_META_BTREE) {
+		do_warn(
+_("rtgroup %u rmap inode has wrong format 0x%x, expected 0x%x\n"),
+				rgno, ip->i_df.if_format,
+				XFS_DINODE_FMT_META_BTREE);
+		goto err_rtg;
+	}
+
+	if (ip->i_metatype != XFS_METAFILE_RTRMAP) {
+		do_warn(
+_("rtgroup %u rmap inode has wrong metatype 0x%x, expected 0x%x\n"),
+				rgno, ip->i_df.if_format,
+				XFS_METAFILE_RTRMAP);
+		goto err_rtg;
+	}
+
+	if (xfs_inode_has_attr_fork(ip) &&
+	    !(xfs_has_metadir(mp) && xfs_has_parent(mp))) {
+		do_warn(
+_("rtgroup %u rmap inode should not have extended attributes\n"), rgno);
+		goto err_rtg;
+	}
+
+	bt_cur = libxfs_rtrmapbt_init_cursor(NULL, rtg);
+	if (!bt_cur) {
+		do_warn(_("Not enough memory to check reverse mappings.\n"));
+		goto err_rtg;
+	}
+
+	error = rmap_compare_records(rm_cur, bt_cur, rgno);
+	if (error)
+		goto err_cur;
+
+err_cur:
+	libxfs_btree_del_cursor(bt_cur, error);
+err_rtg:
+	libxfs_rtgroup_put(rtg);
+err_rcur:
+	libxfs_btree_del_cursor(rm_cur, error);
+}
+
 /*
  * Compare the key fields of two rmap records -- positive if key1 > key2,
  * negative if key1 < key2, and zero if equal.
diff --git a/repair/rmap.h b/repair/rmap.h
index b5c8b4f0bef794..ebda561e59bc8f 100644
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

