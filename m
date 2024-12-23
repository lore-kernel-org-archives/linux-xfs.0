Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EEB1422AB
	for <linux-xfs@vger.kernel.org>; Mon, 23 Dec 2024 21:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734991188; cv=none; b=n7ZpnDR5xvLzvC55DJhjvVYQ9IOHc/M0oWsylamKt/XybwTfahL64RiJSSkSwxa3UdMHX1ufEi//MsOw+3j2nMBSNHehGKBA57vh/g3iILlXknSanapNk925U9ualklkoMJvqZABhnw1rbx5pb1TdtyYZpMpX9Db9C4vKZbwSAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734991188; c=relaxed/simple;
	bh=RmiioTmAVwWSLJlX+F/RrbgNAu8trt7CR2htQdjg6BI=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hq12gCTNXceUTD74kXln57FBjImTpLmHfQSvqCz0yj5C2YlvY2GKBXwWrSBpQQeVbG3XlqkGJHB6ftk2JaHEbUsZFKSmR33Q6P1aUjf1+HZpdQtxJXpMkQiSetKTcc8J3tsiIoE3q2P2j6/laBPp4E93pX9kguz+gWS3EihoIqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XbZII5L1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XbZII5L1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73AEBC4CED3;
	Mon, 23 Dec 2024 21:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734991187;
	bh=RmiioTmAVwWSLJlX+F/RrbgNAu8trt7CR2htQdjg6BI=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=XbZII5L1RpebrP55eOcCO7zqvy0YNFxyHfGAkDROHkjGn5khurEwG9bN7WdDYxeYu
	 CJYT0Pkoi/jm9sCFn4IHcIpYsOcqw4gz/LzlOwj8Hns5WB23wAlr68rw89qKzWLtRp
	 7tlbI0EHBLbax+N0SjQeR+tH1io/VllfCWh5A2mXR7rZpeDaex4kOlsxNO4o90txgd
	 MAVxCygLiDXiuz2W/hQyiccFz7TnwnQgbxmf+xdJULTGy/+OeGsLmcJOXN7G1P6B/y
	 gxl++ADeYW0nfsHcb3Q+ZPzhTif3HYW4s9gElnIQQ5YFiUSidKDvPLbt8EK6fJfCAD
	 BlugDXGoyz/Zw==
Date: Mon, 23 Dec 2024 13:59:47 -0800
Subject: [PATCH 06/52] xfs: move RT bitmap and summary information to the
 rtgroup
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: hch@lst.de, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <173498942586.2295836.14976960801111018041.stgit@frogsfrogsfrogs>
In-Reply-To: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
References: <173498942411.2295836.4988904181656691611.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: e3088ae2dcae3c15d03d7970d4926c8095fd8c7c

Move the pointers to the RT bitmap and summary inodes as well as the
summary cache to the rtgroups structure to prepare for having a
separate bitmap and summary inodes for each rtgroup.

Code using the inodes now needs to operate on a rtgroup.  Where easily
possible such code is converted to iterate over all rtgroups, else
rtgroup 0 (the only one that can currently exist) is hardcoded.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_mount.h      |    9 --
 libxfs/init.c            |    7 --
 libxfs/libxfs_api_defs.h |   10 ++
 libxfs/xfs_bmap.c        |   13 ++-
 libxfs/xfs_rtbitmap.c    |  142 +++++++++++---------------------
 libxfs/xfs_rtbitmap.h    |   64 +++++----------
 libxfs/xfs_rtgroup.c     |   80 ++++++++++++++----
 libxfs/xfs_rtgroup.h     |   14 +++
 mkfs/proto.c             |   33 +++++--
 repair/phase6.c          |  203 +++++++++++++++++++++++-----------------------
 repair/rt.c              |   34 +-------
 repair/rt.h              |    4 -
 12 files changed, 294 insertions(+), 319 deletions(-)


diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 14d640b1511cab..7406825cf7f57a 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -83,15 +83,6 @@ typedef struct xfs_mount {
 	uint			m_rsumlevels;	/* rt summary levels */
 	xfs_filblks_t		m_rsumblocks;	/* size of rt summary, FSBs */
 	uint32_t		m_rgblocks;	/* size of rtgroup in rtblocks */
-	/*
-	 * Optional cache of rt summary level per bitmap block with the
-	 * invariant that m_rsum_cache[bbno] <= the minimum i for which
-	 * rsum[i][bbno] != 0. Reads and writes are serialized by the rsumip
-	 * inode lock.
-	 */
-	uint8_t			*m_rsum_cache;
-	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
-	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
 	struct xfs_inode	*m_metadirip;	/* ptr to metadata directory */
 	struct xfs_inode	*m_rtdirip;	/* ptr to realtime metadir */
 	struct xfs_buftarg	*m_ddev_targp;
diff --git a/libxfs/init.c b/libxfs/init.c
index 1a8084108f0778..5ec01537faac6b 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -326,7 +326,6 @@ rtmount_init(
 	mp->m_rsumlevels = mp->m_sb.sb_rextslog + 1;
 	mp->m_rsumblocks = xfs_rtsummary_blockcount(mp, mp->m_rsumlevels,
 			mp->m_sb.sb_rbmblocks);
-	mp->m_rbmip = mp->m_rsumip = NULL;
 
 	/*
 	 * Allow debugger to be run without the realtime device present.
@@ -855,13 +854,9 @@ libxfs_rtmount_destroy(
 	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
 		for (i = 0; i < XFS_RTGI_MAX; i++)
 			libxfs_rtginode_irele(&rtg->rtg_inodes[i]);
+		kvfree(rtg->rtg_rsum_cache);
 	}
 	libxfs_rtginode_irele(&mp->m_rtdirip);
-	if (mp->m_rsumip)
-		libxfs_irele(mp->m_rsumip);
-	if (mp->m_rbmip)
-		libxfs_irele(mp->m_rbmip);
-	mp->m_rsumip = mp->m_rbmip = NULL;
 }
 
 /* Flush a device and report on writes that didn't make it to stable storage. */
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 83e31a507aca6f..c869a4b0a46551 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -274,12 +274,22 @@
 #define xfs_rmap_query_all		libxfs_rmap_query_all
 #define xfs_rmap_query_range		libxfs_rmap_query_range
 
+#define xfs_rtbitmap_create		libxfs_rtbitmap_create
 #define xfs_rtbitmap_getword		libxfs_rtbitmap_getword
 #define xfs_rtbitmap_setword		libxfs_rtbitmap_setword
 #define xfs_rtbitmap_wordcount		libxfs_rtbitmap_wordcount
+#define xfs_rtginode_create		libxfs_rtginode_create
 #define xfs_rtginode_irele		libxfs_rtginode_irele
+#define xfs_rtginode_load		libxfs_rtginode_load
+#define xfs_rtginode_load_parent	libxfs_rtginode_load_parent
+#define xfs_rtginode_metafile_type	libxfs_rtginode_metafile_type
+#define xfs_rtginode_mkdir_parent	libxfs_rtginode_mkdir_parent
+#define xfs_rtginode_name		libxfs_rtginode_name
+#define xfs_rtsummary_create		libxfs_rtsummary_create
 
 #define xfs_rtgroup_alloc		libxfs_rtgroup_alloc
+#define xfs_rtgroup_grab		libxfs_rtgroup_grab
+#define xfs_rtgroup_rele		libxfs_rtgroup_rele
 
 #define xfs_suminfo_add			libxfs_suminfo_add
 #define xfs_suminfo_get			libxfs_suminfo_get
diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c
index 949546f3eba470..cebf5479189280 100644
--- a/libxfs/xfs_bmap.c
+++ b/libxfs/xfs_bmap.c
@@ -5115,19 +5115,26 @@ xfs_bmap_free_rtblocks(
 	struct xfs_trans	*tp,
 	struct xfs_bmbt_irec	*del)
 {
+	struct xfs_rtgroup	*rtg;
 	int			error;
 
+	rtg = xfs_rtgroup_grab(tp->t_mountp, 0);
+	if (!rtg)
+		return -EIO;
+
 	/*
 	 * Ensure the bitmap and summary inodes are locked and joined to the
 	 * transaction before modifying them.
 	 */
 	if (!(tp->t_flags & XFS_TRANS_RTBITMAP_LOCKED)) {
 		tp->t_flags |= XFS_TRANS_RTBITMAP_LOCKED;
-		xfs_rtbitmap_lock(tp->t_mountp);
-		xfs_rtbitmap_trans_join(tp);
+		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_BITMAP);
+		xfs_rtgroup_trans_join(tp, rtg, XFS_RTGLOCK_BITMAP);
 	}
 
-	error = xfs_rtfree_blocks(tp, del->br_startblock, del->br_blockcount);
+	error = xfs_rtfree_blocks(tp, rtg, del->br_startblock,
+			del->br_blockcount);
+	xfs_rtgroup_rele(rtg);
 	return error;
 }
 
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index cff3030d1662b7..e4d0646ba19bfd 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -88,12 +88,12 @@ xfs_rtbuf_get(
 	if (issum) {
 		cbpp = &args->sumbp;
 		coffp = &args->sumoff;
-		ip = mp->m_rsumip;
+		ip = args->rtg->rtg_inodes[XFS_RTGI_SUMMARY];
 		type = XFS_BLFT_RTSUMMARY_BUF;
 	} else {
 		cbpp = &args->rbmbp;
 		coffp = &args->rbmoff;
-		ip = mp->m_rbmip;
+		ip = args->rtg->rtg_inodes[XFS_RTGI_BITMAP];
 		type = XFS_BLFT_RTBITMAP_BUF;
 	}
 
@@ -501,6 +501,7 @@ xfs_rtmodify_summary(
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_rtsumoff_t		so = xfs_rtsumoffs(mp, log, bbno);
+	uint8_t			*rsum_cache = args->rtg->rtg_rsum_cache;
 	unsigned int		infoword;
 	xfs_suminfo_t		val;
 	int			error;
@@ -512,11 +513,11 @@ xfs_rtmodify_summary(
 	infoword = xfs_rtsumoffs_to_infoword(mp, so);
 	val = xfs_suminfo_add(args, infoword, delta);
 
-	if (mp->m_rsum_cache) {
-		if (val == 0 && log + 1 == mp->m_rsum_cache[bbno])
-			mp->m_rsum_cache[bbno] = log;
-		if (val != 0 && log >= mp->m_rsum_cache[bbno])
-			mp->m_rsum_cache[bbno] = log + 1;
+	if (rsum_cache) {
+		if (val == 0 && log + 1 == rsum_cache[bbno])
+			rsum_cache[bbno] = log;
+		if (val != 0 && log >= rsum_cache[bbno])
+			rsum_cache[bbno] = log + 1;
 	}
 
 	xfs_trans_log_rtsummary(args, infoword);
@@ -735,7 +736,7 @@ xfs_rtfree_range(
 	/*
 	 * Find the next allocated block (end of allocated extent).
 	 */
-	error = xfs_rtfind_forw(args, end, mp->m_sb.sb_rextents - 1,
+	error = xfs_rtfind_forw(args, end, args->rtg->rtg_extents - 1,
 			&postblock);
 	if (error)
 		return error;
@@ -959,19 +960,22 @@ xfs_rtcheck_alloc_range(
 int
 xfs_rtfree_extent(
 	struct xfs_trans	*tp,	/* transaction pointer */
+	struct xfs_rtgroup	*rtg,
 	xfs_rtxnum_t		start,	/* starting rtext number to free */
 	xfs_rtxlen_t		len)	/* length of extent freed */
 {
 	struct xfs_mount	*mp = tp->t_mountp;
+	struct xfs_inode	*rbmip = rtg->rtg_inodes[XFS_RTGI_BITMAP];
 	struct xfs_rtalloc_args	args = {
 		.mp		= mp,
 		.tp		= tp,
+		.rtg		= rtg,
 	};
 	int			error;
 	struct timespec64	atime;
 
-	ASSERT(mp->m_rbmip->i_itemp != NULL);
-	xfs_assert_ilocked(mp->m_rbmip, XFS_ILOCK_EXCL);
+	ASSERT(rbmip->i_itemp != NULL);
+	xfs_assert_ilocked(rbmip, XFS_ILOCK_EXCL);
 
 	error = xfs_rtcheck_alloc_range(&args, start, len);
 	if (error)
@@ -994,13 +998,13 @@ xfs_rtfree_extent(
 	 */
 	if (tp->t_frextents_delta + mp->m_sb.sb_frextents ==
 	    mp->m_sb.sb_rextents) {
-		if (!(mp->m_rbmip->i_diflags & XFS_DIFLAG_NEWRTBM))
-			mp->m_rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
+		if (!(rbmip->i_diflags & XFS_DIFLAG_NEWRTBM))
+			rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
 
-		atime = inode_get_atime(VFS_I(mp->m_rbmip));
+		atime = inode_get_atime(VFS_I(rbmip));
 		atime.tv_sec = 0;
-		inode_set_atime_to_ts(VFS_I(mp->m_rbmip), atime);
-		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
+		inode_set_atime_to_ts(VFS_I(rbmip), atime);
+		xfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
 	}
 	error = 0;
 out:
@@ -1016,6 +1020,7 @@ xfs_rtfree_extent(
 int
 xfs_rtfree_blocks(
 	struct xfs_trans	*tp,
+	struct xfs_rtgroup	*rtg,
 	xfs_fsblock_t		rtbno,
 	xfs_filblks_t		rtlen)
 {
@@ -1036,21 +1041,23 @@ xfs_rtfree_blocks(
 		return -EIO;
 	}
 
-	return xfs_rtfree_extent(tp, xfs_rtb_to_rtx(mp, rtbno),
-			xfs_rtb_to_rtx(mp, rtlen));
+	return xfs_rtfree_extent(tp, rtg, xfs_rtb_to_rtx(mp, rtbno),
+			xfs_extlen_to_rtxlen(mp, rtlen));
 }
 
 /* Find all the free records within a given range. */
 int
 xfs_rtalloc_query_range(
-	struct xfs_mount		*mp,
+	struct xfs_rtgroup		*rtg,
 	struct xfs_trans		*tp,
 	xfs_rtxnum_t			start,
 	xfs_rtxnum_t			end,
 	xfs_rtalloc_query_range_fn	fn,
 	void				*priv)
 {
+	struct xfs_mount		*mp = rtg_mount(rtg);
 	struct xfs_rtalloc_args		args = {
+		.rtg			= rtg,
 		.mp			= mp,
 		.tp			= tp,
 	};
@@ -1058,10 +1065,10 @@ xfs_rtalloc_query_range(
 
 	if (start > end)
 		return -EINVAL;
-	if (start == end || start >= mp->m_sb.sb_rextents)
+	if (start == end || start >= rtg->rtg_extents)
 		return 0;
 
-	end = min(end, mp->m_sb.sb_rextents - 1);
+	end = min(end, rtg->rtg_extents - 1);
 
 	/* Iterate the bitmap, looking for discrepancies. */
 	while (start <= end) {
@@ -1084,7 +1091,7 @@ xfs_rtalloc_query_range(
 			rec.ar_startext = start;
 			rec.ar_extcount = rtend - start + 1;
 
-			error = fn(mp, tp, &rec, priv);
+			error = fn(rtg, tp, &rec, priv);
 			if (error)
 				break;
 		}
@@ -1099,26 +1106,27 @@ xfs_rtalloc_query_range(
 /* Find all the free records. */
 int
 xfs_rtalloc_query_all(
-	struct xfs_mount		*mp,
+	struct xfs_rtgroup		*rtg,
 	struct xfs_trans		*tp,
 	xfs_rtalloc_query_range_fn	fn,
 	void				*priv)
 {
-	return xfs_rtalloc_query_range(mp, tp, 0, mp->m_sb.sb_rextents - 1, fn,
+	return xfs_rtalloc_query_range(rtg, tp, 0, rtg->rtg_extents - 1, fn,
 			priv);
 }
 
 /* Is the given extent all free? */
 int
 xfs_rtalloc_extent_is_free(
-	struct xfs_mount		*mp,
+	struct xfs_rtgroup		*rtg,
 	struct xfs_trans		*tp,
 	xfs_rtxnum_t			start,
 	xfs_rtxlen_t			len,
 	bool				*is_free)
 {
 	struct xfs_rtalloc_args		args = {
-		.mp			= mp,
+		.mp			= rtg_mount(rtg),
+		.rtg			= rtg,
 		.tp			= tp,
 	};
 	xfs_rtxnum_t			end;
@@ -1159,65 +1167,6 @@ xfs_rtsummary_blockcount(
 	return XFS_B_TO_FSB(mp, rsumwords << XFS_WORDLOG);
 }
 
-/* Lock both realtime free space metadata inodes for a freespace update. */
-void
-xfs_rtbitmap_lock(
-	struct xfs_mount	*mp)
-{
-	xfs_ilock(mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
-	xfs_ilock(mp->m_rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
-}
-
-/*
- * Join both realtime free space metadata inodes to the transaction.  The
- * ILOCKs will be released on transaction commit.
- */
-void
-xfs_rtbitmap_trans_join(
-	struct xfs_trans	*tp)
-{
-	xfs_trans_ijoin(tp, tp->t_mountp->m_rbmip, XFS_ILOCK_EXCL);
-	xfs_trans_ijoin(tp, tp->t_mountp->m_rsumip, XFS_ILOCK_EXCL);
-}
-
-/* Unlock both realtime free space metadata inodes after a freespace update. */
-void
-xfs_rtbitmap_unlock(
-	struct xfs_mount	*mp)
-{
-	xfs_iunlock(mp->m_rsumip, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
-	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
-}
-
-/*
- * Lock the realtime free space metadata inodes for a freespace scan.  Callers
- * must walk metadata blocks in order of increasing file offset.
- */
-void
-xfs_rtbitmap_lock_shared(
-	struct xfs_mount	*mp,
-	unsigned int		rbmlock_flags)
-{
-	if (rbmlock_flags & XFS_RBMLOCK_BITMAP)
-		xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
-
-	if (rbmlock_flags & XFS_RBMLOCK_SUMMARY)
-		xfs_ilock(mp->m_rsumip, XFS_ILOCK_SHARED | XFS_ILOCK_RTSUM);
-}
-
-/* Unlock the realtime free space metadata inodes after a freespace scan. */
-void
-xfs_rtbitmap_unlock_shared(
-	struct xfs_mount	*mp,
-	unsigned int		rbmlock_flags)
-{
-	if (rbmlock_flags & XFS_RBMLOCK_SUMMARY)
-		xfs_iunlock(mp->m_rsumip, XFS_ILOCK_SHARED | XFS_ILOCK_RTSUM);
-
-	if (rbmlock_flags & XFS_RBMLOCK_BITMAP)
-		xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
-}
-
 static int
 xfs_rtfile_alloc_blocks(
 	struct xfs_inode	*ip,
@@ -1258,21 +1207,25 @@ xfs_rtfile_alloc_blocks(
 /* Get a buffer for the block. */
 static int
 xfs_rtfile_initialize_block(
-	struct xfs_inode	*ip,
+	struct xfs_rtgroup	*rtg,
+	enum xfs_rtg_inodes	type,
 	xfs_fsblock_t		fsbno,
 	void			*data)
 {
-	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_inode	*ip = rtg->rtg_inodes[type];
 	struct xfs_trans	*tp;
 	struct xfs_buf		*bp;
 	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
 	enum xfs_blft		buf_type;
 	int			error;
 
-	if (ip == mp->m_rsumip)
-		buf_type = XFS_BLFT_RTSUMMARY_BUF;
-	else
+	if (type == XFS_RTGI_BITMAP)
 		buf_type = XFS_BLFT_RTBITMAP_BUF;
+	else if (type == XFS_RTGI_SUMMARY)
+		buf_type = XFS_BLFT_RTSUMMARY_BUF;
+	else
+		return -EINVAL;
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_growrtzero, 0, 0, 0, &tp);
 	if (error)
@@ -1304,12 +1257,13 @@ xfs_rtfile_initialize_block(
  */
 int
 xfs_rtfile_initialize_blocks(
-	struct xfs_inode	*ip,		/* inode (bitmap/summary) */
+	struct xfs_rtgroup	*rtg,
+	enum xfs_rtg_inodes	type,
 	xfs_fileoff_t		offset_fsb,	/* offset to start from */
 	xfs_fileoff_t		end_fsb,	/* offset to allocate to */
 	void			*data)		/* data to fill the blocks */
 {
-	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_mount	*mp = rtg_mount(rtg);
 	const size_t		copylen = mp->m_blockwsize << XFS_WORDLOG;
 
 	while (offset_fsb < end_fsb) {
@@ -1317,8 +1271,8 @@ xfs_rtfile_initialize_blocks(
 		xfs_filblks_t		i;
 		int			error;
 
-		error = xfs_rtfile_alloc_blocks(ip, offset_fsb,
-				end_fsb - offset_fsb, &map);
+		error = xfs_rtfile_alloc_blocks(rtg->rtg_inodes[type],
+				offset_fsb, end_fsb - offset_fsb, &map);
 		if (error)
 			return error;
 
@@ -1328,7 +1282,7 @@ xfs_rtfile_initialize_blocks(
 		 * Do this one block per transaction, to keep it simple.
 		 */
 		for (i = 0; i < map.br_blockcount; i++) {
-			error = xfs_rtfile_initialize_block(ip,
+			error = xfs_rtfile_initialize_block(rtg, type,
 					map.br_startblock + i, data);
 			if (error)
 				return error;
diff --git a/libxfs/xfs_rtbitmap.h b/libxfs/xfs_rtbitmap.h
index 140513d1d6bcf1..b3cbc56aa255ed 100644
--- a/libxfs/xfs_rtbitmap.h
+++ b/libxfs/xfs_rtbitmap.h
@@ -6,7 +6,10 @@
 #ifndef __XFS_RTBITMAP_H__
 #define	__XFS_RTBITMAP_H__
 
+#include "xfs_rtgroup.h"
+
 struct xfs_rtalloc_args {
+	struct xfs_rtgroup	*rtg;
 	struct xfs_mount	*mp;
 	struct xfs_trans	*tp;
 
@@ -268,7 +271,7 @@ struct xfs_rtalloc_rec {
 };
 
 typedef int (*xfs_rtalloc_query_range_fn)(
-	struct xfs_mount		*mp,
+	struct xfs_rtgroup		*rtg,
 	struct xfs_trans		*tp,
 	const struct xfs_rtalloc_rec	*rec,
 	void				*priv);
@@ -291,53 +294,37 @@ int xfs_rtmodify_summary(struct xfs_rtalloc_args *args, int log,
 		xfs_fileoff_t bbno, int delta);
 int xfs_rtfree_range(struct xfs_rtalloc_args *args, xfs_rtxnum_t start,
 		xfs_rtxlen_t len);
-int xfs_rtalloc_query_range(struct xfs_mount *mp, struct xfs_trans *tp,
+int xfs_rtalloc_query_range(struct xfs_rtgroup *rtg, struct xfs_trans *tp,
 		xfs_rtxnum_t start, xfs_rtxnum_t end,
 		xfs_rtalloc_query_range_fn fn, void *priv);
-int xfs_rtalloc_query_all(struct xfs_mount *mp, struct xfs_trans *tp,
-			  xfs_rtalloc_query_range_fn fn,
-			  void *priv);
-int xfs_rtalloc_extent_is_free(struct xfs_mount *mp, struct xfs_trans *tp,
-			       xfs_rtxnum_t start, xfs_rtxlen_t len,
-			       bool *is_free);
-/*
- * Free an extent in the realtime subvolume.  Length is expressed in
- * realtime extents, as is the block number.
- */
-int					/* error */
-xfs_rtfree_extent(
-	struct xfs_trans	*tp,	/* transaction pointer */
-	xfs_rtxnum_t		start,	/* starting rtext number to free */
-	xfs_rtxlen_t		len);	/* length of extent freed */
-
+int xfs_rtalloc_query_all(struct xfs_rtgroup *rtg, struct xfs_trans *tp,
+		xfs_rtalloc_query_range_fn fn, void *priv);
+int xfs_rtalloc_extent_is_free(struct xfs_rtgroup *rtg, struct xfs_trans *tp,
+		xfs_rtxnum_t start, xfs_rtxlen_t len, bool *is_free);
+int xfs_rtfree_extent(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
+		xfs_rtxnum_t start, xfs_rtxlen_t len);
 /* Same as above, but in units of rt blocks. */
-int xfs_rtfree_blocks(struct xfs_trans *tp, xfs_fsblock_t rtbno,
-		xfs_filblks_t rtlen);
+int xfs_rtfree_blocks(struct xfs_trans *tp, struct xfs_rtgroup *rtg,
+		xfs_fsblock_t rtbno, xfs_filblks_t rtlen);
 
 xfs_filblks_t xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t
 		rtextents);
 xfs_filblks_t xfs_rtsummary_blockcount(struct xfs_mount *mp,
 		unsigned int rsumlevels, xfs_extlen_t rbmblocks);
 
-int xfs_rtfile_initialize_blocks(struct xfs_inode *ip,
-		xfs_fileoff_t offset_fsb, xfs_fileoff_t end_fsb, void *data);
+int xfs_rtfile_initialize_blocks(struct xfs_rtgroup *rtg,
+		enum xfs_rtg_inodes type, xfs_fileoff_t offset_fsb,
+		xfs_fileoff_t end_fsb, void *data);
 
-void xfs_rtbitmap_lock(struct xfs_mount *mp);
-void xfs_rtbitmap_unlock(struct xfs_mount *mp);
-void xfs_rtbitmap_trans_join(struct xfs_trans *tp);
-
-/* Lock the rt bitmap inode in shared mode */
-#define XFS_RBMLOCK_BITMAP	(1U << 0)
-/* Lock the rt summary inode in shared mode */
-#define XFS_RBMLOCK_SUMMARY	(1U << 1)
-
-void xfs_rtbitmap_lock_shared(struct xfs_mount *mp,
-		unsigned int rbmlock_flags);
-void xfs_rtbitmap_unlock_shared(struct xfs_mount *mp,
-		unsigned int rbmlock_flags);
 #else /* CONFIG_XFS_RT */
 # define xfs_rtfree_extent(t,b,l)			(-ENOSYS)
-# define xfs_rtfree_blocks(t,rb,rl)			(-ENOSYS)
+
+static inline int xfs_rtfree_blocks(struct xfs_trans *tp,
+		struct xfs_rtgroup *rtg, xfs_fsblock_t rtbno,
+		xfs_filblks_t rtlen)
+{
+	return -ENOSYS;
+}
 # define xfs_rtalloc_query_range(m,t,l,h,f,p)		(-ENOSYS)
 # define xfs_rtalloc_query_all(m,t,f,p)			(-ENOSYS)
 # define xfs_rtbitmap_read_buf(a,b)			(-ENOSYS)
@@ -351,11 +338,6 @@ xfs_rtbitmap_blockcount(struct xfs_mount *mp, xfs_rtbxlen_t rtextents)
 	return 0;
 }
 # define xfs_rtsummary_blockcount(mp, l, b)		(0)
-# define xfs_rtbitmap_lock(mp)			do { } while (0)
-# define xfs_rtbitmap_trans_join(tp)		do { } while (0)
-# define xfs_rtbitmap_unlock(mp)		do { } while (0)
-# define xfs_rtbitmap_lock_shared(mp, lf)	do { } while (0)
-# define xfs_rtbitmap_unlock_shared(mp, lf)	do { } while (0)
 #endif /* CONFIG_XFS_RT */
 
 #endif /* __XFS_RTBITMAP_H__ */
diff --git a/libxfs/xfs_rtgroup.c b/libxfs/xfs_rtgroup.c
index 09dd0c2ed8769c..41c794718e06c9 100644
--- a/libxfs/xfs_rtgroup.c
+++ b/libxfs/xfs_rtgroup.c
@@ -160,10 +160,16 @@ xfs_rtgroup_lock(
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
 	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
 
-	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
-		xfs_rtbitmap_lock(rtg_mount(rtg));
-	else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED)
-		xfs_rtbitmap_lock_shared(rtg_mount(rtg), XFS_RBMLOCK_BITMAP);
+	if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
+		/*
+		 * Lock both realtime free space metadata inodes for a freespace
+		 * update.
+		 */
+		xfs_ilock(rtg->rtg_inodes[XFS_RTGI_BITMAP], XFS_ILOCK_EXCL);
+		xfs_ilock(rtg->rtg_inodes[XFS_RTGI_SUMMARY], XFS_ILOCK_EXCL);
+	} else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) {
+		xfs_ilock(rtg->rtg_inodes[XFS_RTGI_BITMAP], XFS_ILOCK_SHARED);
+	}
 }
 
 /* Unlock metadata inodes associated with this rt group. */
@@ -176,10 +182,12 @@ xfs_rtgroup_unlock(
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) ||
 	       !(rtglock_flags & XFS_RTGLOCK_BITMAP));
 
-	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
-		xfs_rtbitmap_unlock(rtg_mount(rtg));
-	else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED)
-		xfs_rtbitmap_unlock_shared(rtg_mount(rtg), XFS_RBMLOCK_BITMAP);
+	if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
+		xfs_iunlock(rtg->rtg_inodes[XFS_RTGI_SUMMARY], XFS_ILOCK_EXCL);
+		xfs_iunlock(rtg->rtg_inodes[XFS_RTGI_BITMAP], XFS_ILOCK_EXCL);
+	} else if (rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED) {
+		xfs_iunlock(rtg->rtg_inodes[XFS_RTGI_BITMAP], XFS_ILOCK_SHARED);
+	}
 }
 
 /*
@@ -195,8 +203,12 @@ xfs_rtgroup_trans_join(
 	ASSERT(!(rtglock_flags & ~XFS_RTGLOCK_ALL_FLAGS));
 	ASSERT(!(rtglock_flags & XFS_RTGLOCK_BITMAP_SHARED));
 
-	if (rtglock_flags & XFS_RTGLOCK_BITMAP)
-		xfs_rtbitmap_trans_join(tp);
+	if (rtglock_flags & XFS_RTGLOCK_BITMAP) {
+		xfs_trans_ijoin(tp, rtg->rtg_inodes[XFS_RTGI_BITMAP],
+				XFS_ILOCK_EXCL);
+		xfs_trans_ijoin(tp, rtg->rtg_inodes[XFS_RTGI_SUMMARY],
+				XFS_ILOCK_EXCL);
+	}
 }
 
 #ifdef CONFIG_PROVE_LOCKING
@@ -261,6 +273,14 @@ struct xfs_rtginode_ops {
 };
 
 static const struct xfs_rtginode_ops xfs_rtginode_ops[XFS_RTGI_MAX] = {
+	[XFS_RTGI_BITMAP] = {
+		.name		= "bitmap",
+		.metafile_type	= XFS_METAFILE_RTBITMAP,
+	},
+	[XFS_RTGI_SUMMARY] = {
+		.name		= "summary",
+		.metafile_type	= XFS_METAFILE_RTSUMMARY,
+	},
 };
 
 /* Return the shortname of this rtgroup inode. */
@@ -300,7 +320,6 @@ xfs_rtginode_load(
 	struct xfs_trans	*tp)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	const char		*path;
 	struct xfs_inode	*ip;
 	const struct xfs_rtginode_ops *ops = &xfs_rtginode_ops[type];
 	int			error;
@@ -308,15 +327,36 @@ xfs_rtginode_load(
 	if (!xfs_rtginode_enabled(rtg, type))
 		return 0;
 
-	if (!mp->m_rtdirip)
-		return -EFSCORRUPTED;
-
-	path = xfs_rtginode_path(rtg_rgno(rtg), type);
-	if (!path)
-		return -ENOMEM;
-	error = xfs_metadir_load(tp, mp->m_rtdirip, path, ops->metafile_type,
-			&ip);
-	kfree(path);
+	if (!xfs_has_rtgroups(mp)) {
+		xfs_ino_t	ino;
+
+		switch (type) {
+		case XFS_RTGI_BITMAP:
+			ino = mp->m_sb.sb_rbmino;
+			break;
+		case XFS_RTGI_SUMMARY:
+			ino = mp->m_sb.sb_rsumino;
+			break;
+		default:
+			/* None of the other types exist on !rtgroups */
+			return 0;
+		}
+
+		error = xfs_trans_metafile_iget(tp, ino, ops->metafile_type,
+				&ip);
+	} else {
+		const char	*path;
+
+		if (!mp->m_rtdirip)
+			return -EFSCORRUPTED;
+
+		path = xfs_rtginode_path(rtg_rgno(rtg), type);
+		if (!path)
+			return -ENOMEM;
+		error = xfs_metadir_load(tp, mp->m_rtdirip, path,
+				ops->metafile_type, &ip);
+		kfree(path);
+	}
 
 	if (error)
 		return error;
diff --git a/libxfs/xfs_rtgroup.h b/libxfs/xfs_rtgroup.h
index 2c894df723a786..3732f65ba8a1f6 100644
--- a/libxfs/xfs_rtgroup.h
+++ b/libxfs/xfs_rtgroup.h
@@ -12,6 +12,9 @@ struct xfs_mount;
 struct xfs_trans;
 
 enum xfs_rtg_inodes {
+	XFS_RTGI_BITMAP,	/* allocation bitmap */
+	XFS_RTGI_SUMMARY,	/* allocation summary */
+
 	XFS_RTGI_MAX,
 };
 
@@ -26,10 +29,19 @@ struct xfs_rtgroup {
 	struct xfs_group	rtg_group;
 
 	/* per-rtgroup metadata inodes */
-	struct xfs_inode	*rtg_inodes[1 /* hack */];
+	struct xfs_inode	*rtg_inodes[XFS_RTGI_MAX];
 
 	/* Number of blocks in this group */
 	xfs_rtxnum_t		rtg_extents;
+
+	/*
+	 * Cache of rt summary level per bitmap block with the invariant that
+	 * rtg_rsum_cache[bbno] > the maximum i for which rsum[i][bbno] != 0,
+	 * or 0 if rsum[i][bbno] == 0 for all i.
+	 *
+	 * Reads and writes are serialized by the rsumip inode lock.
+	 */
+	uint8_t			*rtg_rsum_cache;
 };
 
 static inline struct xfs_rtgroup *to_rtg(struct xfs_group *xg)
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 7a0493ec71cfd9..55182bf50fd399 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -946,9 +946,11 @@ parse_proto(
 /* Create a sb-rooted metadata file. */
 static void
 create_sb_metadata_file(
-	struct xfs_mount	*mp,
+	struct xfs_rtgroup	*rtg,
+	enum xfs_rtg_inodes	type,
 	void			(*create)(struct xfs_inode *ip))
 {
+	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_icreate_args	args = {
 		.mode		= S_IFREG,
 		.flags		= XFS_ICREATE_UNLINKABLE,
@@ -978,6 +980,8 @@ create_sb_metadata_file(
 	error = -libxfs_trans_commit(tp);
 	if (error)
 		goto fail;
+	rtg->rtg_inodes[type] = ip;
+	return;
 
 fail:
 	if (ip)
@@ -997,8 +1001,6 @@ rtbitmap_create(
 	inode_set_atime(VFS_I(ip), 0, 0);
 
 	mp->m_sb.sb_rbmino = ip->i_ino;
-	mp->m_rbmip = ip;
-	ihold(VFS_I(ip));
 }
 
 static void
@@ -1010,8 +1012,6 @@ rtsummary_create(
 	ip->i_disk_size = mp->m_rsumblocks * mp->m_sb.sb_blocksize;
 
 	mp->m_sb.sb_rsumino = ip->i_ino;
-	mp->m_rsumip = ip;
-	ihold(VFS_I(ip));
 }
 
 /*
@@ -1020,8 +1020,9 @@ rtsummary_create(
  */
 static void
 rtfreesp_init(
-	struct xfs_mount	*mp)
+	struct xfs_rtgroup	*rtg)
 {
+	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_trans	*tp;
 	xfs_rtxnum_t		rtx;
 	xfs_rtxnum_t		ertx;
@@ -1030,12 +1031,12 @@ rtfreesp_init(
 	/*
 	 * First zero the realtime bitmap and summary files.
 	 */
-	error = -libxfs_rtfile_initialize_blocks(mp->m_rbmip, 0,
+	error = -libxfs_rtfile_initialize_blocks(rtg, XFS_RTGI_BITMAP, 0,
 			mp->m_sb.sb_rbmblocks, NULL);
 	if (error)
 		fail(_("Initialization of rtbitmap inode failed"), error);
 
-	error = -libxfs_rtfile_initialize_blocks(mp->m_rsumip, 0,
+	error = -libxfs_rtfile_initialize_blocks(rtg, XFS_RTGI_SUMMARY, 0,
 			mp->m_rsumblocks, NULL);
 	if (error)
 		fail(_("Initialization of rtsummary inode failed"), error);
@@ -1049,11 +1050,11 @@ rtfreesp_init(
 		if (error)
 			res_failed(error);
 
-		libxfs_trans_ijoin(tp, mp->m_rbmip, 0);
+		libxfs_trans_ijoin(tp, rtg->rtg_inodes[XFS_RTGI_BITMAP], 0);
 		ertx = min(mp->m_sb.sb_rextents,
 			   rtx + NBBY * mp->m_sb.sb_blocksize);
 
-		error = -libxfs_rtfree_extent(tp, rtx,
+		error = -libxfs_rtfree_extent(tp, rtg, rtx,
 				(xfs_rtxlen_t)(ertx - rtx));
 		if (error) {
 			fail(_("Error initializing the realtime space"),
@@ -1073,10 +1074,16 @@ static void
 rtinit(
 	struct xfs_mount	*mp)
 {
-	create_sb_metadata_file(mp, rtbitmap_create);
-	create_sb_metadata_file(mp, rtsummary_create);
+	struct xfs_rtgroup	*rtg = NULL;
 
-	rtfreesp_init(mp);
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		create_sb_metadata_file(rtg, XFS_RTGI_BITMAP,
+				rtbitmap_create);
+		create_sb_metadata_file(rtg, XFS_RTGI_SUMMARY,
+				rtsummary_create);
+
+		rtfreesp_init(rtg);
+	}
 }
 
 static off_t
diff --git a/repair/phase6.c b/repair/phase6.c
index 44677096873a54..41342d884ce37a 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -491,98 +491,85 @@ mark_ino_metadata(
 	set_inode_is_meta(irec, get_inode_offset(mp, ino, irec));
 }
 
-/* Load a realtime freespace metadata inode from disk and reset it. */
-static int
-ensure_rtino(
-	struct xfs_trans		*tp,
-	enum xfs_metafile_type		metafile_type,
-	struct xfs_inode		**ipp)
-{
-	struct xfs_mount		*mp = tp->t_mountp;
-	xfs_ino_t			ino;
-	int				error;
-
-	switch (metafile_type) {
-	case XFS_METAFILE_RTBITMAP:
-		ino = mp->m_sb.sb_rbmino;
-		break;
-	case XFS_METAFILE_RTSUMMARY:
-		ino = mp->m_sb.sb_rsumino;
-		break;
-	default:
-		ASSERT(0);
-		return -EFSCORRUPTED;
-	}
-
-	/*
-	 * Don't use metafile iget here because we're resetting sb-rooted
-	 * inodes that live at fixed inumbers, but these inodes could be in
-	 * an arbitrary state.
-	 */
-	error = -libxfs_iget(mp, tp, ino, 0, ipp);
-	if (error)
-		return error;
-
-	reset_sbroot_ino(tp, S_IFREG, *ipp);
-	if (xfs_has_metadir(mp))
-		libxfs_metafile_set_iflag(tp, *ipp, metafile_type);
-	return 0;
-}
-
+/* (Re)create a missing sb-rooted rt freespace inode. */
 static void
-mk_rbmino(
-	struct xfs_mount	*mp)
+mk_rtino(
+	struct xfs_rtgroup	*rtg,
+	enum xfs_rtg_inodes	type)
 {
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_inode	*ip = rtg->rtg_inodes[type];
 	struct xfs_trans	*tp;
-	struct xfs_inode	*ip;
+	enum xfs_metafile_type	metafile_type =
+		libxfs_rtginode_metafile_type(type);
 	int			error;
 
 	error = -libxfs_trans_alloc_rollable(mp, 10, &tp);
 	if (error)
 		res_failed(error);
 
-	/* Reset the realtime bitmap inode. */
-	error = ensure_rtino(tp, XFS_METAFILE_RTBITMAP, &ip);
-	if (error) {
-		do_error(
-		_("couldn't iget realtime bitmap inode -- error - %d\n"),
-			error);
+	if (!ip) {
+		xfs_ino_t	rootino = mp->m_sb.sb_rootino;
+		xfs_ino_t	ino = NULLFSINO;
+
+		if (xfs_has_metadir(mp))
+			rootino++;
+
+		switch (type) {
+		case XFS_RTGI_BITMAP:
+			mp->m_sb.sb_rbmino = rootino + 1;
+			ino = mp->m_sb.sb_rbmino;
+			break;
+		case XFS_RTGI_SUMMARY:
+			mp->m_sb.sb_rsumino = rootino + 2;
+			ino = mp->m_sb.sb_rsumino;
+			break;
+		default:
+			break;
+		}
+
+		/*
+		 * Don't use metafile iget here because we're resetting
+		 * sb-rooted inodes that live at fixed inumbers, but these
+		 * inodes could be in an arbitrary state.
+		 */
+		error = -libxfs_iget(mp, tp, ino, 0, &ip);
+		if (error) {
+			do_error(
+_("couldn't iget realtime %s inode -- error - %d\n"),
+					libxfs_rtginode_name(type),
+					error);
+		}
+
+		rtg->rtg_inodes[type] = ip;
 	}
 
-	ip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
-	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-	error = -libxfs_trans_commit(tp);
-	if (error)
-		do_error(_("%s: commit failed, error %d\n"), __func__, error);
-	libxfs_irele(ip);
-}
-
-static void
-mk_rsumino(
-	struct xfs_mount	*mp)
-{
-	struct xfs_trans	*tp;
-	struct xfs_inode	*ip;
-	int			error;
-
-	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 10, 0, 0, &tp);
-	if (error)
-		res_failed(error);
-
-	/* Reset the rt summary inode. */
-	error = ensure_rtino(tp, XFS_METAFILE_RTSUMMARY, &ip);
-	if (error) {
-		do_error(
-		_("couldn't iget realtime summary inode -- error - %d\n"),
-			error);
+	reset_sbroot_ino(tp, S_IFREG, ip);
+	if (xfs_has_metadir(mp))
+		libxfs_metafile_set_iflag(tp, ip, metafile_type);
+
+	switch (type) {
+	case XFS_RTGI_BITMAP:
+		ip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
+		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+		error = 0;
+		break;
+	case XFS_RTGI_SUMMARY:
+		ip->i_disk_size = mp->m_rsumblocks * mp->m_sb.sb_blocksize;
+		libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+		error = 0;
+		break;
+	default:
+		error = EINVAL;
 	}
 
-	ip->i_disk_size = mp->m_rsumblocks * mp->m_sb.sb_blocksize;
-	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	if (error)
+		do_error(_("%s inode re-initialization failed for rtgroup %u\n"),
+			libxfs_rtginode_name(type), rtg_rgno(rtg));
+
 	error = -libxfs_trans_commit(tp);
 	if (error)
 		do_error(_("%s: commit failed, error %d\n"), __func__, error);
-	libxfs_irele(ip);
 }
 
 /* Initialize a root directory. */
@@ -3219,6 +3206,43 @@ traverse_ags(
 	do_inode_prefetch(mp, ag_stride, traverse_function, false, true);
 }
 
+static void
+reset_rt_sb_inodes(
+	struct xfs_mount	*mp)
+{
+	struct xfs_rtgroup	*rtg;
+
+	if (no_modify) {
+		if (need_rbmino)
+			do_warn(_("would reinitialize realtime bitmap inode\n"));
+		if (need_rsumino)
+			do_warn(_("would reinitialize realtime summary inode\n"));
+		return;
+	}
+
+	rtg = libxfs_rtgroup_grab(mp, 0);
+
+	if (need_rbmino)  {
+		do_warn(_("reinitializing realtime bitmap inode\n"));
+		mk_rtino(rtg, XFS_RTGI_BITMAP);
+		need_rbmino = 0;
+	}
+
+	if (need_rsumino)  {
+		do_warn(_("reinitializing realtime summary inode\n"));
+		mk_rtino(rtg, XFS_RTGI_SUMMARY);
+		need_rsumino = 0;
+	}
+
+	do_log(
+_("        - resetting contents of realtime bitmap and summary inodes\n"));
+
+	fill_rtbitmap(rtg);
+	fill_rtsummary(rtg);
+
+	libxfs_rtgroup_rele(rtg);
+}
+
 void
 phase6(xfs_mount_t *mp)
 {
@@ -3267,32 +3291,7 @@ phase6(xfs_mount_t *mp)
 		do_warn(_("would reinitialize metadata root directory\n"));
 	}
 
-	if (need_rbmino)  {
-		if (!no_modify)  {
-			do_warn(_("reinitializing realtime bitmap inode\n"));
-			mk_rbmino(mp);
-			need_rbmino = 0;
-		} else  {
-			do_warn(_("would reinitialize realtime bitmap inode\n"));
-		}
-	}
-
-	if (need_rsumino)  {
-		if (!no_modify)  {
-			do_warn(_("reinitializing realtime summary inode\n"));
-			mk_rsumino(mp);
-			need_rsumino = 0;
-		} else  {
-			do_warn(_("would reinitialize realtime summary inode\n"));
-		}
-	}
-
-	if (!no_modify)  {
-		do_log(
-_("        - resetting contents of realtime bitmap and summary inodes\n"));
-		fill_rtbitmap(mp);
-		fill_rtsummary(mp);
-	}
+	reset_rt_sb_inodes(mp);
 
 	mark_standalone_inodes(mp);
 
diff --git a/repair/rt.c b/repair/rt.c
index d0a171020c4b49..711891a724b076 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -69,8 +69,6 @@ _("couldn't allocate memory for incore realtime bitmap.\n"));
 		do_error(
 _("couldn't allocate memory for incore realtime summary info.\n"));
 
-	ASSERT(mp->m_rbmip == NULL);
-
 	/*
 	 * Slower but simple, don't play around with trying to set things one
 	 * word at a time, just set bit as required.  Have to track start and
@@ -234,46 +232,26 @@ check_rtsummary(
 
 void
 fill_rtbitmap(
-	struct xfs_mount	*mp)
+	struct xfs_rtgroup	*rtg)
 {
-	struct xfs_inode	*ip;
 	int			error;
 
-	error = -libxfs_metafile_iget(mp, mp->m_sb.sb_rbmino,
-			XFS_METAFILE_RTBITMAP, &ip);
-	if (error)
-		do_error(
-_("couldn't iget realtime bitmap inode, error %d\n"), error);
-
-	error = -libxfs_rtfile_initialize_blocks(ip, 0, mp->m_sb.sb_rbmblocks,
-			btmcompute);
+	error = -libxfs_rtfile_initialize_blocks(rtg, XFS_RTGI_BITMAP,
+			0, rtg_mount(rtg)->m_sb.sb_rbmblocks, btmcompute);
 	if (error)
 		do_error(
 _("couldn't re-initialize realtime bitmap inode, error %d\n"), error);
-
-	libxfs_irele(ip);
 }
 
 void
 fill_rtsummary(
-	struct xfs_mount	*mp)
+	struct xfs_rtgroup	*rtg)
 {
-	struct xfs_inode	*ip;
 	int			error;
 
-	error = -libxfs_metafile_iget(mp, mp->m_sb.sb_rsumino,
-			XFS_METAFILE_RTSUMMARY, &ip);
-	if (error)
-		do_error(
-_("couldn't iget realtime summary inode, error %d\n"), error);
-
-	mp->m_rsumip = ip;
-	error = -libxfs_rtfile_initialize_blocks(ip, 0, mp->m_rsumblocks,
-			sumcompute);
-	mp->m_rsumip = NULL;
+	error = -libxfs_rtfile_initialize_blocks(rtg, XFS_RTGI_SUMMARY,
+			0, rtg_mount(rtg)->m_rsumblocks, sumcompute);
 	if (error)
 		do_error(
 _("couldn't re-initialize realtime summary inode, error %d\n"), error);
-
-	libxfs_irele(ip);
 }
diff --git a/repair/rt.h b/repair/rt.h
index f8caa5dc874ec2..9d837de65a7dfc 100644
--- a/repair/rt.h
+++ b/repair/rt.h
@@ -10,7 +10,7 @@ void generate_rtinfo(struct xfs_mount *mp);
 void check_rtbitmap(struct xfs_mount *mp);
 void check_rtsummary(struct xfs_mount *mp);
 
-void fill_rtbitmap(struct xfs_mount *mp);
-void fill_rtsummary(struct xfs_mount *mp);
+void fill_rtbitmap(struct xfs_rtgroup *rtg);
+void fill_rtsummary(struct xfs_rtgroup *rtg);
 
 #endif /* _XFS_REPAIR_RT_H_ */

