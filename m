Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FBA613FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688285; cv=none; b=AEarqV0LC2fNLypz1L/ce/kk/nMMFNwugHr+BCduhihGXkKTUgICFK90nUlYin5rVH1D8VaMvQ8BJtkUsM1pG7ELq3lEkPljxFemGZWx4Zi60dDOo/4AhTTnn3Iomj6UuRLfqcdOyydBFLDEMza30eJuq15Y97wezT/OiO6ATmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688285; c=relaxed/simple;
	bh=rITO614x3bjweEZx+igIx+iOphWDnfQg9W705lo2+Aw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lW8WjHdKrwPMcREmzaaueOU4TWH+oZF+Z7oG+kIrPlhUk2K3JrjBey+T4ZD+PQqSlYgN9HKfkRzG+1SmvGNzGhyYuTEnJCT7rhdvRUWwesV1X5bLN8XaM1dWjmrGeY3+vCtgNK8bmnHPjcxMOZ59jhIX2maicxYjcXLfTN5VoTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d4YNJhkW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d4YNJhkW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD8B7C4CED2;
	Tue, 31 Dec 2024 23:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688284;
	bh=rITO614x3bjweEZx+igIx+iOphWDnfQg9W705lo2+Aw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=d4YNJhkWDqPIrwzuOLgHYFu9v2o9zswqYVEgVH1t3tj8RItxXxpdyYsdAO2Gw95xA
	 ZqmSP+kFZWLS/O5EDqsL1Qc8RDUEOXEmmgtyVvWjhYb+GKMSGK9qdgJSCZRWAqut3u
	 3Us5rG90vmKKfviOMe6HYIZAtnOmzI/3XefUtEaIwMEOebtbWQ4ECd7efekWRWUJXV
	 RONsqC+WzajyLSXoKrdpqc5ooWbL9XIRSfhJOdme3Pku4s3+xv+Dd4EzPoVVYhKayR
	 cI8BSnx6fFE9COM32ImVrPDvOXPhywotx1co5xEmwPGWVmpzgh/gpTiBsnD+MGuTtv
	 VKju3QqvisQfQ==
Date: Tue, 31 Dec 2024 15:38:04 -0800
Subject: [PATCH 1/4] xfs: export realtime refcount information
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754232.2704719.3818969425291903972.stgit@frogsfrogsfrogs>
In-Reply-To: <173568754204.2704719.1892779733633851572.stgit@frogsfrogsfrogs>
References: <173568754204.2704719.1892779733633851572.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Add support for reporting space refcount information from the realtime
volume.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_fsrefs.c |  405 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 405 insertions(+)


diff --git a/fs/xfs/xfs_fsrefs.c b/fs/xfs/xfs_fsrefs.c
index 85e109dba20f99..d5b77fe79b2653 100644
--- a/fs/xfs/xfs_fsrefs.c
+++ b/fs/xfs/xfs_fsrefs.c
@@ -478,6 +478,395 @@ xfs_fsrefs_logdev(
 	return xfs_fsrefs_helper(tp, info, &frec);
 }
 
+#ifdef CONFIG_XFS_RT
+/* Synthesize fsrefs records from rtbitmap records. */
+STATIC int
+xfs_fsrefs_rtdev_bitmap_helper(
+	struct xfs_rtgroup		*rtg,
+	struct xfs_trans		*tp,
+	const struct xfs_rtalloc_rec	*rec,
+	void				*priv)
+{
+	struct xfs_fsrefs_irec		frec = {
+		.refcount		= 1,
+	};
+	struct xfs_mount		*mp = rtg_mount(rtg);
+	struct xfs_fsrefs_info		*info = priv;
+	xfs_rtblock_t			next_rtb, rec_rtb, rtb;
+	xfs_rgnumber_t			next_rgno;
+	xfs_rgblock_t			next_rgbno;
+	xfs_rgblock_t			rec_rgbno;
+
+	/* Translate the free space record to group and block number. */
+	rec_rtb = xfs_rtx_to_rtb(rtg, rec->ar_startext);
+	rec_rgbno = xfs_rtb_to_rgbno(mp, rec_rtb);
+
+	/*
+	 * Figure out if there's a gap between the last fsrefs record we
+	 * emitted and this free extent.  If there is, report the gap as a
+	 * refcount==1 record.
+	 */
+	next_rtb = xfs_daddr_to_rtb(mp, info->next_daddr);
+	next_rgno = xfs_rtb_to_rgno(mp, next_rtb);
+	next_rgbno = xfs_rtb_to_rgbno(mp, next_rtb);
+
+	ASSERT(next_rgno >= info->group->xg_gno);
+	ASSERT(rec_rgbno >= next_rgbno);
+
+	/*
+	 * If we've already moved on to the next rtgroup, we don't have any
+	 * fsrefs records to synthesize.
+	 */
+	if (next_rgno > info->group->xg_gno)
+		return 0;
+
+	rtb = xfs_rtx_to_rtb(rtg, rec->ar_startext + rec->ar_extcount);
+	info->next_daddr = xfs_rtb_to_daddr(mp, rtb);
+
+	if (rec_rtb == next_rtb)
+		return 0;
+
+	/* Emit a record for the in-use space. */
+	frec.start_daddr = xfs_rtb_to_daddr(mp, next_rtb);
+	frec.len_daddr = XFS_FSB_TO_BB(mp, rec_rgbno - next_rgbno);
+	frec.rec_key = next_rgbno;
+	return xfs_fsrefs_helper(tp, info, &frec);
+}
+
+/* Emit records to fill a gap in the refcount btree with singly-owned blocks. */
+STATIC int
+xfs_fsrefs_rtdev_fill_refcount_gap(
+	struct xfs_trans		*tp,
+	struct xfs_fsrefs_info		*info,
+	xfs_rgblock_t			rgbno)
+{
+	struct xfs_rtalloc_rec		high = { 0 };
+	struct xfs_mount		*mp = tp->t_mountp;
+	struct xfs_rtgroup		*rtg = to_rtg(info->group);
+	xfs_rtblock_t			start_rtbno =
+			xfs_daddr_to_rtb(mp, info->next_daddr);
+	xfs_rtblock_t			end_rtbno =
+			xfs_rgbno_to_rtb(rtg, rgbno);
+	xfs_rtxnum_t			low_rtx;
+	xfs_daddr_t			rec_daddr;
+	int				error;
+
+	ASSERT(xfs_rtb_to_rgno(mp, start_rtbno) == info->group->xg_gno);
+
+	low_rtx = xfs_rtb_to_rtx(mp, start_rtbno);
+	if (rgbno == -1U) {
+		/*
+		 * If the caller passes in an all 1s high key to signify the
+		 * end of the group, set the extent to all 1s as well.
+		 */
+		high.ar_startext = -1ULL;
+	} else {
+		high.ar_startext = xfs_rtb_to_rtx(mp,
+				end_rtbno + mp->m_sb.sb_rextsize - 1);
+	}
+	if (low_rtx >= high.ar_startext)
+		return 0;
+
+	error = xfs_rtalloc_query_range(rtg, tp, low_rtx, high.ar_startext,
+			xfs_fsrefs_rtdev_bitmap_helper, info);
+	if (error)
+		return error;
+
+	/*
+	 * Synthesize records for single-owner extents between the last
+	 * fsrefcount record emitted and the end of the query range.
+	 */
+	high.ar_startext = min(high.ar_startext, rtg->rtg_extents);
+	rec_daddr = xfs_rtb_to_daddr(mp, xfs_rtx_to_rtb(rtg, high.ar_startext));
+	if (info->next_daddr > rec_daddr)
+		return 0;
+
+	info->last = true;
+	return xfs_fsrefs_rtdev_bitmap_helper(rtg, tp, &high, info);
+}
+
+/* Transform a absolute-startblock refcount (rtdev, logdev) into a fsrefs */
+STATIC int
+xfs_fsrefs_rtdev_refcountbt_helper(
+	struct xfs_btree_cur		*cur,
+	const struct xfs_refcount_irec	*rec,
+	void				*priv)
+{
+	struct xfs_fsrefs_irec		frec = {
+		.refcount		= rec->rc_refcount,
+		.rec_key		= rec->rc_startblock,
+	};
+	struct xfs_mount		*mp = cur->bc_mp;
+	struct xfs_fsrefs_info		*info = priv;
+	struct xfs_rtgroup		*rtg = to_rtg(info->group);
+	xfs_rtblock_t			rec_rtbno;
+	int				error;
+
+	/*
+	 * Stop once we get to the CoW staging extents; they're all shoved to
+	 * the right side of the btree and were already covered by the rtbitmap
+	 * scan.
+	 */
+	if (rec->rc_domain != XFS_REFC_DOMAIN_SHARED)
+		return -ECANCELED;
+
+	/* Report on any gaps first */
+	error = xfs_fsrefs_rtdev_fill_refcount_gap(cur->bc_tp, info,
+			rec->rc_startblock);
+	if (error)
+		return error;
+
+	/* Report the refcount record from the refcount btree. */
+	rec_rtbno = xfs_rgbno_to_rtb(rtg, rec->rc_startblock);
+	frec.start_daddr = xfs_rtb_to_daddr(mp, rec_rtbno);
+	frec.len_daddr = XFS_FSB_TO_BB(mp, rec->rc_blockcount);
+	info->next_daddr = xfs_rtb_to_daddr(mp, rec_rtbno + rec->rc_blockcount);
+	return xfs_fsrefs_helper(cur->bc_tp, info, &frec);
+}
+
+#define XFS_RTGLOCK_FSREFS	(XFS_RTGLOCK_BITMAP | XFS_RTGLOCK_REFCOUNT)
+
+/* Execute a getfsrefs query against the realtime device. */
+STATIC int
+xfs_fsrefs_rtdev(
+	struct xfs_trans	*tp,
+	const struct xfs_fsrefs	*keys,
+	struct xfs_fsrefs_info	*info)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_rtgroup	*rtg = NULL, *locked_rtg = NULL;
+	xfs_rtblock_t		start_rtbno;
+	xfs_rtblock_t		end_rtbno;
+	xfs_rgnumber_t		start_rg;
+	xfs_rgnumber_t		end_rg;
+	uint64_t		eofs;
+	int			error = 0;
+
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	if (keys[0].fcr_physical >= eofs)
+		return 0;
+	start_rtbno = xfs_daddr_to_rtb(mp, keys[0].fcr_physical);
+	end_rtbno = xfs_daddr_to_rtb(mp, min(eofs - 1, keys[1].fcr_physical));
+
+	info->refc_cur = info->bno_cur = NULL;
+
+	/*
+	 * Convert the fsrefs low/high keys to rtgroup based keys.  Initialize
+	 * low to the fsrefs low key and max out the high key to the end of the
+	 * rtgroup.
+	 */
+	info->low.rc_startblock = xfs_rtb_to_rgbno(mp, start_rtbno);
+	info->low.rc_blockcount = XFS_BB_TO_FSBT(mp, keys[0].fcr_length);
+	info->low.rc_refcount = 0;
+	info->low.rc_domain = XFS_REFC_DOMAIN_SHARED;
+
+	/* Adjust the low key if we are continuing from where we left off. */
+	if (info->low.rc_blockcount > 0) {
+		info->low.rc_startblock += info->low.rc_blockcount;
+
+		start_rtbno += info->low.rc_blockcount;
+		if (xfs_rtb_to_daddr(mp, start_rtbno) >= eofs)
+			return 0;
+	}
+
+	info->high.rc_startblock = -1U;
+	info->high.rc_blockcount = 0;
+	info->high.rc_refcount = 0;
+	info->high.rc_domain = XFS_REFC_DOMAIN_SHARED;
+
+	start_rg = xfs_rtb_to_rgno(mp, start_rtbno);
+	end_rg = xfs_rtb_to_rgno(mp, end_rtbno);
+
+	/* Query each rtgroup */
+	while ((rtg = xfs_rtgroup_next_range(mp, rtg, start_rg, end_rg))) {
+		info->group = rtg_group(rtg);
+
+		/*
+		 * Set the rtgroup high key from the fsrefs high key if this
+		 * is the last rtgroup that we're querying.
+		 */
+		if (rtg_rgno(rtg) == end_rg)
+			info->high.rc_startblock = xfs_rtb_to_rgbno(mp,
+					end_rtbno);
+
+		if (info->refc_cur) {
+			xfs_btree_del_cursor(info->refc_cur, XFS_BTREE_NOERROR);
+			info->refc_cur = NULL;
+		}
+		if (locked_rtg)
+			xfs_rtgroup_unlock(locked_rtg, XFS_RTGLOCK_FSREFS);
+
+		trace_xfs_fsrefs_low_group_key(mp, info->dev, info->group,
+				&info->low);
+		trace_xfs_fsrefs_high_group_key(mp, info->dev, info->group,
+				&info->high);
+
+		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_FSREFS);
+		locked_rtg = rtg;
+
+		/*
+		 * Fill the query with refcount records and synthesize
+		 * singly-owned block records from free space data.
+		 */
+		if (xfs_has_rtreflink(mp)) {
+			info->refc_cur = xfs_rtrefcountbt_init_cursor(tp, rtg);
+
+			error = xfs_refcount_query_range(info->refc_cur,
+					&info->low, &info->high,
+					xfs_fsrefs_rtdev_refcountbt_helper,
+					info);
+			if (error && error != -ECANCELED)
+				break;
+		}
+
+		/*
+		 * Synthesize refcount==1 records from the free space data
+		 * between the end of the last fsrefs record reported and the
+		 * end of the range.  If we don't have refcount support, the
+		 * starting point will be the start of the query range.
+		 */
+		error = xfs_fsrefs_rtdev_fill_refcount_gap(tp, info,
+				info->high.rc_startblock);
+		if (error)
+			break;
+
+		/*
+		 * Set the rtgroup low key to the start of the rtgroup prior to
+		 * moving on to the next rtgroup.
+		 */
+		if (rtg_rgno(rtg) == start_rg)
+			memset(&info->low, 0, sizeof(info->low));
+		info->group = NULL;
+	}
+
+	if (info->refc_cur) {
+		xfs_btree_del_cursor(info->refc_cur, error);
+		info->refc_cur = NULL;
+	}
+	if (locked_rtg)
+		xfs_rtgroup_unlock(locked_rtg, XFS_RTGLOCK_FSREFS);
+	if (info->group) {
+		xfs_rtgroup_rele(rtg);
+		info->group = NULL;
+	} else if (rtg) {
+		/* loop termination case */
+		xfs_rtgroup_rele(rtg);
+	}
+
+	return error;
+}
+
+/* Synthesize fsrefs records from 64-bit rtbitmap records. */
+STATIC int
+xfs_fsrefs_rtdev_nogroups_helper(
+	struct xfs_rtgroup		*rtg,
+	struct xfs_trans		*tp,
+	const struct xfs_rtalloc_rec	*rec,
+	void				*priv)
+{
+	struct xfs_fsrefs_irec		frec = {
+		.refcount		= 1,
+	};
+	struct xfs_mount		*mp = rtg_mount(rtg);
+	struct xfs_fsrefs_info		*info = priv;
+	xfs_rtblock_t			next_rtb, rec_rtb, rtb;
+
+	/* Translate the free space record to group and block number. */
+	rec_rtb = xfs_rtx_to_rtb(rtg, rec->ar_startext);
+
+	/*
+	 * Figure out if there's a gap between the last fsrefs record we
+	 * emitted and this free extent.  If there is, report the gap as a
+	 * refcount==1 record.
+	 */
+	next_rtb = xfs_daddr_to_rtb(mp, info->next_daddr);
+
+	ASSERT(rec_rtb >= next_rtb);
+
+	rtb = xfs_rtx_to_rtb(rtg, rec->ar_startext + rec->ar_extcount);
+	info->next_daddr = xfs_rtb_to_daddr(mp, rtb);
+
+	if (rec_rtb == next_rtb)
+		return 0;
+
+	/* Emit records for the in-use space. */
+	frec.start_daddr = xfs_rtb_to_daddr(mp, next_rtb);
+	frec.len_daddr = xfs_rtb_to_daddr(mp, rec_rtb - next_rtb);
+	return xfs_fsrefs_helper(tp, info, &frec);
+}
+
+/*
+ * Synthesize refcount information from the rtbitmap for a pre-rtgroups
+ * filesystem.
+ */
+STATIC int
+xfs_fsrefs_rtdev_nogroups(
+	struct xfs_trans	*tp,
+	const struct xfs_fsrefs	*keys,
+	struct xfs_fsrefs_info	*info)
+{
+	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_rtgroup	*rtg = NULL;
+	xfs_rtblock_t		start_rtbno;
+	xfs_rtblock_t		end_rtbno;
+	xfs_rtxnum_t		low_rtx;
+	xfs_rtxnum_t		high_rtx;
+	uint64_t		eofs;
+	int			error = 0;
+
+	eofs = XFS_FSB_TO_BB(mp, mp->m_sb.sb_rblocks);
+	if (keys[0].fcr_physical >= eofs)
+		return 0;
+	start_rtbno = xfs_daddr_to_rtb(mp, keys[0].fcr_physical);
+	end_rtbno = xfs_daddr_to_rtb(mp, min(eofs - 1, keys[1].fcr_physical));
+
+	info->refc_cur = info->bno_cur = NULL;
+
+	/*
+	 * Convert the fsrefs low/high keys to rtgroup based keys.  Initialize
+	 * low to the fsrefs low key and max out the high key to the end of the
+	 * rtgroup.
+	 */
+	info->low_daddr = keys[0].fcr_physical;
+
+	/* Adjust the low key if we are continuing from where we left off. */
+	if (keys[0].fcr_length > 0) {
+		info->low_daddr += keys[0].fcr_length;
+		if (info->low_daddr >= eofs)
+			return 0;
+	}
+
+	rtg = xfs_rtgroup_grab(mp, 0);
+	if (!rtg)
+		return -EFSCORRUPTED;
+
+	info->group = rtg_group(rtg);
+
+	trace_xfs_fsrefs_low_linear_key(mp, info->dev, start_rtbno);
+	trace_xfs_fsrefs_high_linear_key(mp, info->dev, end_rtbno);
+
+	xfs_rtgroup_lock(rtg, XFS_RTGLOCK_BITMAP);
+
+	/*
+	 * Walk the whole rtbitmap.  Without rtgroups, the startext values can
+	 * be more than 32-bits wide, which is why we need this separate
+	 * implementation.
+	 */
+	low_rtx = xfs_rtb_to_rtx(mp, start_rtbno);
+	high_rtx = xfs_rtb_to_rtx(mp, end_rtbno + mp->m_sb.sb_rextsize - 1);
+	if (low_rtx < high_rtx)
+		error = xfs_rtalloc_query_range(rtg, tp, low_rtx, high_rtx,
+				xfs_fsrefs_rtdev_nogroups_helper, info);
+
+	info->group = NULL;
+
+	xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_BITMAP);
+	xfs_rtgroup_rele(rtg);
+
+	return error;
+}
+#endif
+
 /* Do we recognize the device? */
 STATIC bool
 xfs_fsrefs_is_valid_device(
@@ -515,7 +904,14 @@ xfs_fsrefs_check_keys(
 	return false;
 }
 
+/*
+ * There are only two devices if we didn't configure RT devices at build time.
+ */
+#ifdef CONFIG_XFS_RT
+#define XFS_GETFSREFS_DEVS	3
+#else
 #define XFS_GETFSREFS_DEVS	2
+#endif /* CONFIG_XFS_RT */
 
 /*
  * Get filesystem's extent refcounts as described in head, and format for
@@ -569,6 +965,15 @@ xfs_getfsrefs(
 		handlers[1].dev = new_encode_dev(mp->m_logdev_targp->bt_dev);
 		handlers[1].fn = xfs_fsrefs_logdev;
 	}
+#ifdef CONFIG_XFS_RT
+	if (mp->m_rtdev_targp) {
+		handlers[2].dev = new_encode_dev(mp->m_rtdev_targp->bt_dev);
+		if (xfs_has_rtgroups(mp))
+			handlers[2].fn = xfs_fsrefs_rtdev;
+		else
+			handlers[2].fn = xfs_fsrefs_rtdev_nogroups;
+	}
+#endif /* CONFIG_XFS_RT */
 
 	xfs_sort(handlers, XFS_GETFSREFS_DEVS, sizeof(struct xfs_fsrefs_dev),
 			xfs_fsrefs_dev_compare);

