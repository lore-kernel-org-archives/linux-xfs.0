Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F002BA2E
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ly9sWAlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2076EC433C8;
	Sun, 31 Dec 2023 21:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704058605;
	bh=LCiWiR2RYSfvCMtpj/Mt7ciKi1qyfJdt8/ve70ssa58=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Ly9sWAljdgMEyWckLvftEcpbr/Dz3ZG3oNIyx13NKkRGiNP1s0Z9TrKPYTAWrmGzK
	 HBlCcQGE0X6g2doBq0cLygwKzJhUoJzj6vmBONy76H1GlArMpJZ4buiOE7qdGHxfLE
	 OSlBvDxz5X0h8PssrlLJocxBTevj5lfoFUU5NH0pd8KgliAD48WCXCdh/kirn3YhGO
	 K5IrS6boEVWt2XRpvj+lQKPTQeDmVMVrsbe4WoMVnkHIk+XxDjcbXjlBcWcx2+P3SL
	 tKwYCUefQkiCEhgySMDf5jsQz/7otRlNP5qFxhIQHU9qBEphmpn7oRE5SF3E3MnOAS
	 ABpeabHjNMkbg==
Date: Sun, 31 Dec 2023 13:36:44 -0800
Subject: [PATCH 19/39] xfs: wire up getfsmap to the realtime reverse mapping
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404850206.1764998.3851642767596046037.stgit@frogsfrogsfrogs>
In-Reply-To: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
References: <170404849811.1764998.10873316890301599216.stgit@frogsfrogsfrogs>
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

Connect the getfsmap ioctl to the realtime rmapbt.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsmap.c |  194 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 191 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 34769cb35c908..b0eabc76eb28a 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -25,6 +25,8 @@
 #include "xfs_alloc_btree.h"
 #include "xfs_rtbitmap.h"
 #include "xfs_ag.h"
+#include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
 static void
@@ -158,6 +160,7 @@ struct xfs_getfsmap_info {
 	struct xfs_fsmap_head	*head;
 	struct fsmap		*fsmap_recs;	/* mapping records */
 	struct xfs_buf		*agf_bp;	/* AGF, for refcount queries */
+	struct xfs_rtgroup	*rtg;		/* rt group info, if needed */
 	struct xfs_perag	*pag;		/* AG info, if applicable */
 	xfs_daddr_t		next_daddr;	/* next daddr we expect */
 	/* daddr of low fsmap key when we're using the rtbitmap */
@@ -338,8 +341,14 @@ xfs_getfsmap_helper(
 	if (info->head->fmh_entries >= info->head->fmh_count)
 		return -ECANCELED;
 
-	trace_xfs_fsmap_mapping(mp, info->dev,
-			info->pag ? info->pag->pag_agno : NULLAGNUMBER, rec);
+	if (info->pag)
+		trace_xfs_fsmap_mapping(mp, info->dev, info->pag->pag_agno,
+				rec);
+	else if (info->rtg)
+		trace_xfs_fsmap_mapping(mp, info->dev, info->rtg->rtg_rgno,
+				rec);
+	else
+		trace_xfs_fsmap_mapping(mp, info->dev, NULLAGNUMBER, rec);
 
 	fmr.fmr_device = info->dev;
 	fmr.fmr_physical = rec_daddr;
@@ -784,6 +793,181 @@ xfs_getfsmap_rtdev_rtbitmap(
 	xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
 	return error;
 }
+
+/* Transform a realtime rmapbt record into a fsmap */
+STATIC int
+xfs_getfsmap_rtdev_rmapbt_helper(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_rmap_irec	*rec,
+	void				*priv)
+{
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_getfsmap_info	*info = priv;
+	xfs_rtblock_t			rtbno;
+	xfs_daddr_t			rec_daddr;
+
+	rtbno = xfs_rgbno_to_rtb(mp, cur->bc_ino.rtg->rtg_rgno,
+			rec->rm_startblock);
+	rec_daddr = xfs_rtb_to_daddr(mp, rtbno);
+
+	return xfs_getfsmap_helper(cur->bc_tp, info, rec, rec_daddr, 0);
+}
+
+/* Actually query the rtrmap btree. */
+STATIC int
+xfs_getfsmap_rtdev_rmapbt_query(
+	struct xfs_trans		*tp,
+	struct xfs_getfsmap_info	*info,
+	struct xfs_btree_cur		**curpp)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+
+	/* Report any gap at the end of the last rtgroup. */
+	if (info->last)
+		return xfs_getfsmap_rtdev_rmapbt_helper(*curpp, &info->high,
+				info);
+
+	/* Query the rtrmapbt */
+	xfs_rtgroup_lock(NULL, info->rtg, XFS_RTGLOCK_RMAP);
+	*curpp = xfs_rtrmapbt_init_cursor(mp, tp, info->rtg,
+			info->rtg->rtg_rmapip);
+	return xfs_rmap_query_range(*curpp, &info->low, &info->high,
+			xfs_getfsmap_rtdev_rmapbt_helper, info);
+}
+
+/* Execute a getfsmap query against the realtime device rmapbt. */
+STATIC int
+xfs_getfsmap_rtdev_rmapbt(
+	struct xfs_trans		*tp,
+	const struct xfs_fsmap		*keys,
+	struct xfs_getfsmap_info	*info)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_rtgroup		*rtg;
+	struct xfs_btree_cur		*bt_cur = NULL;
+	xfs_rtblock_t			start_rtb;
+	xfs_rtblock_t			end_rtb;
+	xfs_rgnumber_t			start_rg, end_rg;
+	uint64_t			eofs;
+	int				error = 0;
+
+	eofs = XFS_FSB_TO_BB(mp, xfs_rtx_to_rtb(mp, mp->m_sb.sb_rextents));
+	if (keys[0].fmr_physical >= eofs)
+		return 0;
+	start_rtb = XFS_BB_TO_FSBT(mp, keys[0].fmr_physical);
+	end_rtb = XFS_BB_TO_FSB(mp, min(eofs - 1, keys[1].fmr_physical));
+
+	info->missing_owner = XFS_FMR_OWN_FREE;
+
+	/*
+	 * Convert the fsmap low/high keys to rtgroup based keys.  Initialize
+	 * low to the fsmap low key and max out the high key to the end
+	 * of the rtgroup.
+	 */
+	info->low.rm_offset = XFS_BB_TO_FSBT(mp, keys[0].fmr_offset);
+	error = xfs_fsmap_owner_to_rmap(&info->low, &keys[0]);
+	if (error)
+		return error;
+	info->low.rm_blockcount = XFS_BB_TO_FSBT(mp, keys[0].fmr_length);
+	xfs_getfsmap_set_irec_flags(&info->low, &keys[0]);
+
+	/* Adjust the low key if we are continuing from where we left off. */
+	if (info->low.rm_blockcount == 0) {
+		/* No previous record from which to continue */
+	} else if (rmap_not_shareable(mp, &info->low)) {
+		/* Last record seen was an unshareable extent */
+		info->low.rm_owner = 0;
+		info->low.rm_offset = 0;
+
+		start_rtb += info->low.rm_blockcount;
+		if (xfs_rtb_to_daddr(mp, start_rtb) >= eofs)
+			return 0;
+	} else {
+		/* Last record seen was a shareable file data extent */
+		info->low.rm_offset += info->low.rm_blockcount;
+	}
+	info->low.rm_startblock = xfs_rtb_to_rgbno(mp, start_rtb, &start_rg);
+
+	info->high.rm_startblock = -1U;
+	info->high.rm_owner = ULLONG_MAX;
+	info->high.rm_offset = ULLONG_MAX;
+	info->high.rm_blockcount = 0;
+	info->high.rm_flags = XFS_RMAP_KEY_FLAGS | XFS_RMAP_REC_FLAGS;
+
+	end_rg = xfs_rtb_to_rgno(mp, end_rtb);
+
+	for_each_rtgroup_range(mp, start_rg, end_rg, rtg) {
+		/*
+		 * Set the rtgroup high key from the fsmap high key if this
+		 * is the last rtgroup that we're querying.
+		 */
+		info->rtg = rtg;
+		if (rtg->rtg_rgno == end_rg) {
+			xfs_rgnumber_t	junk;
+
+			info->high.rm_startblock = xfs_rtb_to_rgbno(mp,
+					end_rtb, &junk);
+			info->high.rm_offset = XFS_BB_TO_FSBT(mp,
+					keys[1].fmr_offset);
+			error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
+			if (error)
+				break;
+			xfs_getfsmap_set_irec_flags(&info->high, &keys[1]);
+		}
+
+		if (bt_cur) {
+			xfs_rtgroup_unlock(bt_cur->bc_ino.rtg,
+					XFS_RTGLOCK_RMAP);
+			xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+			bt_cur = NULL;
+		}
+
+		trace_xfs_fsmap_low_key(mp, info->dev, rtg->rtg_rgno,
+				&info->low);
+		trace_xfs_fsmap_high_key(mp, info->dev, rtg->rtg_rgno,
+				&info->high);
+
+		error = xfs_getfsmap_rtdev_rmapbt_query(tp, info, &bt_cur);
+		if (error)
+			break;
+
+		/*
+		 * Set the rtgroup low key to the start of the rtgroup prior to
+		 * moving on to the next rtgroup.
+		 */
+		if (rtg->rtg_rgno == start_rg)
+			memset(&info->low, 0, sizeof(info->low));
+
+		/*
+		 * If this is the last rtgroup, report any gap at the end of it
+		 * before we drop the reference to the perag when the loop
+		 * terminates.
+		 */
+		if (rtg->rtg_rgno == end_rg) {
+			info->last = true;
+			error = xfs_getfsmap_rtdev_rmapbt_query(tp, info,
+					&bt_cur);
+			if (error)
+				break;
+		}
+		info->rtg = NULL;
+	}
+
+	if (bt_cur) {
+		xfs_rtgroup_unlock(bt_cur->bc_ino.rtg, XFS_RTGLOCK_RMAP);
+		xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
+							 XFS_BTREE_NOERROR);
+	}
+	if (info->rtg) {
+		xfs_rtgroup_rele(info->rtg);
+		info->rtg = NULL;
+	} else if (rtg) {
+		/* loop termination case */
+		xfs_rtgroup_rele(rtg);
+	}
+
+	return error;
+}
 #endif /* CONFIG_XFS_RT */
 
 /* Do we recognize the device? */
@@ -916,7 +1100,10 @@ xfs_getfsmap(
 #ifdef CONFIG_XFS_RT
 	if (mp->m_rtdev_targp) {
 		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
-		handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
+		if (use_rmap)
+			handlers[2].fn = xfs_getfsmap_rtdev_rmapbt;
+		else
+			handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
 	}
 #endif /* CONFIG_XFS_RT */
 
@@ -983,6 +1170,7 @@ xfs_getfsmap(
 		info.dev = handlers[i].dev;
 		info.last = false;
 		info.pag = NULL;
+		info.rtg = NULL;
 		info.low_daddr = -1ULL;
 		info.low.rm_blockcount = 0;
 		error = handlers[i].fn(tp, dkeys, &info);

