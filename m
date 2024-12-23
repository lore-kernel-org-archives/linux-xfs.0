Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904502837B
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 23:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734994865; cv=none; b=HdWvNkY7F9xjY3ldLbvjcHmlIjOZiee/B+bYuHSbrXL01RjdPHxSkpCXjcFyVdaZN0mAPaIFm0QMTWepihiDKj1pgAD12YMHcBk1G/xaFG0/4PfsoZFIsbssxs83kbvUEnqN3vG2W7yrVHUuU00Jejdi17q9VrEF5msGoaD+SOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734994865; c=relaxed/simple;
	bh=Z/5mEe0s8Y5uJE9GkSsnWI/fWPNaJwg9Xcptz7rZlHU=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V5BuZh0bRrNKJsvOzK6zK3OqFmeoGB705jmv+tfxfEcqmtPT1z4pDOHtb0okPz3oqfJ1y4ch8ZIqKZRSnawx/rbA8dTV+JcmvQ489nAMQBJ5gacY2UBm/0AGYJ8GdLOXEIKpaUC7hJUBbg5V8poVmUcaUDhvRecl6PkH6nsji8c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PtXgz+he; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PtXgz+he"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE3CC4CED3;
	Mon, 23 Dec 2024 23:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734994865;
	bh=Z/5mEe0s8Y5uJE9GkSsnWI/fWPNaJwg9Xcptz7rZlHU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PtXgz+heRnseYzORVbOn4RToJWyCU9lCSE4gFRAYLipPmYCnhtJdqbrnYKJgOrXxE
	 gKPPSYKp7PkkURPNgj8bELxNUNzsQh4VbPwotMPa8bu1yJJr8BvZeI8NzJIQblPYf1
	 L9kyBYY5LY+DB7Bko5bQ/d6Xgtw4oXQrGf4MfF3OenhlVx2lrZkRzRh8X2iwIo9GJX
	 DRbYfBlc7Sm127JTOCfUKyjslRkdvN/mUCHlmyhZ4MvDhaMqu/lsIaOd69bFoMjWT/
	 +acj6bKjlLC5qHfZzHOK9cFt2hajwYm44qd3/5zneKgpxMzl0kibMlgJ3GGJsSjmWb
	 XUI+sDNYcgXRg==
Date: Mon, 23 Dec 2024 15:01:04 -0800
Subject: [PATCH 17/37] xfs: wire up getfsmap to the realtime reverse mapping
 btree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173499419009.2380130.10964364350161071585.stgit@frogsfrogsfrogs>
In-Reply-To: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
References: <173499418610.2380130.12548657506222792394.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_fsmap.c |  174 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 173 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 3290dd8524a69a..3e3ef16f65a335 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -26,6 +26,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_ag.h"
 #include "xfs_rtgroup.h"
+#include "xfs_rtrmap_btree.h"
 
 /* Convert an xfs_fsmap to an fsmap. */
 static void
@@ -832,6 +833,174 @@ xfs_getfsmap_rtdev_rtbitmap(
 
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
+	struct xfs_fsmap_irec		frec = {
+		.owner			= rec->rm_owner,
+		.offset			= rec->rm_offset,
+		.rm_flags		= rec->rm_flags,
+		.rec_key		= rec->rm_startblock,
+	};
+	struct xfs_getfsmap_info	*info = priv;
+
+	return xfs_getfsmap_group_helper(info, cur->bc_tp, cur->bc_group,
+			rec->rm_startblock, rec->rm_blockcount, &frec);
+}
+
+/* Actually query the rtrmap btree. */
+STATIC int
+xfs_getfsmap_rtdev_rmapbt_query(
+	struct xfs_trans		*tp,
+	struct xfs_getfsmap_info	*info,
+	struct xfs_btree_cur		**curpp)
+{
+	struct xfs_rtgroup		*rtg = to_rtg(info->group);
+
+	/* Query the rtrmapbt */
+	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_RMAP);
+	*curpp = xfs_rtrmapbt_init_cursor(tp, rtg);
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
+	struct xfs_rtgroup		*rtg = NULL;
+	struct xfs_btree_cur		*bt_cur = NULL;
+	xfs_rtblock_t			start_rtb;
+	xfs_rtblock_t			end_rtb;
+	xfs_rgnumber_t			start_rg, end_rg;
+	uint64_t			eofs;
+	int				error = 0;
+
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	if (keys[0].fmr_physical >= eofs)
+		return 0;
+	start_rtb = xfs_daddr_to_rtb(mp, keys[0].fmr_physical);
+	end_rtb = xfs_daddr_to_rtb(mp, min(eofs - 1, keys[1].fmr_physical));
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
+	info->low.rm_startblock = xfs_rtb_to_rgbno(mp, start_rtb);
+
+	info->high.rm_startblock = -1U;
+	info->high.rm_owner = ULLONG_MAX;
+	info->high.rm_offset = ULLONG_MAX;
+	info->high.rm_blockcount = 0;
+	info->high.rm_flags = XFS_RMAP_KEY_FLAGS | XFS_RMAP_REC_FLAGS;
+
+	start_rg = xfs_rtb_to_rgno(mp, start_rtb);
+	end_rg = xfs_rtb_to_rgno(mp, end_rtb);
+
+	while ((rtg = xfs_rtgroup_next_range(mp, rtg, start_rg, end_rg))) {
+		/*
+		 * Set the rtgroup high key from the fsmap high key if this
+		 * is the last rtgroup that we're querying.
+		 */
+		info->group = rtg_group(rtg);
+		if (rtg_rgno(rtg) == end_rg) {
+			info->high.rm_startblock =
+				xfs_rtb_to_rgbno(mp, end_rtb);
+			info->high.rm_offset =
+				XFS_BB_TO_FSBT(mp, keys[1].fmr_offset);
+			error = xfs_fsmap_owner_to_rmap(&info->high, &keys[1]);
+			if (error)
+				break;
+			xfs_getfsmap_set_irec_flags(&info->high, &keys[1]);
+		}
+
+		if (bt_cur) {
+			xfs_rtgroup_unlock(to_rtg(bt_cur->bc_group),
+					XFS_RTGLOCK_RMAP);
+			xfs_btree_del_cursor(bt_cur, XFS_BTREE_NOERROR);
+			bt_cur = NULL;
+		}
+
+		trace_xfs_fsmap_low_group_key(mp, info->dev, rtg_rgno(rtg),
+				&info->low);
+		trace_xfs_fsmap_high_group_key(mp, info->dev, rtg_rgno(rtg),
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
+		if (rtg_rgno(rtg) == start_rg)
+			memset(&info->low, 0, sizeof(info->low));
+
+		/*
+		 * If this is the last rtgroup, report any gap at the end of it
+		 * before we drop the reference to the perag when the loop
+		 * terminates.
+		 */
+		if (rtg_rgno(rtg) == end_rg) {
+			info->last = true;
+			error = xfs_getfsmap_rtdev_rmapbt_helper(bt_cur,
+					&info->high, info);
+			if (error)
+				break;
+		}
+		info->group = NULL;
+	}
+
+	if (bt_cur) {
+		xfs_rtgroup_unlock(to_rtg(bt_cur->bc_group),
+				XFS_RTGLOCK_RMAP);
+		xfs_btree_del_cursor(bt_cur, error < 0 ? XFS_BTREE_ERROR :
+							 XFS_BTREE_NOERROR);
+	}
+
+	/* loop termination case */
+	if (rtg) {
+		info->group = NULL;
+		xfs_rtgroup_rele(rtg);
+	}
+
+	return error;
+}
 #endif /* CONFIG_XFS_RT */
 
 /* Do we recognize the device? */
@@ -971,7 +1140,10 @@ xfs_getfsmap(
 	if (mp->m_rtdev_targp) {
 		handlers[2].nr_sectors = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
 		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
-		handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
+		if (use_rmap)
+			handlers[2].fn = xfs_getfsmap_rtdev_rmapbt;
+		else
+			handlers[2].fn = xfs_getfsmap_rtdev_rtbitmap;
 	}
 #endif /* CONFIG_XFS_RT */
 

