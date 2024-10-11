Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FDB4A1E
	for <linux-xfs@vger.kernel.org>; Fri, 11 Oct 2024 00:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728608329; cv=none; b=TaPc6HQ/tOaEZXwXjUmMIaBdDWjV5caebqH7o9iwGMMf9vrhOvI0Y+fFoMHzztdPyH4H4gAITaH+M210oTk1dk9D5Acx+EMXoCa5cFKFZHXaKCb5NYYVPQTjTULyN6r+e1HiJ01KnriRw/F7ZJeXjIoDKr+Z2lkghlCn4SJ/9A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728608329; c=relaxed/simple;
	bh=9xKO+8cb6NRqX/ww5ueMPLL29WB7la28tpdZKvsS7hs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mpbsYVs7by/jS1YaPMoOamCbNvej/dfPYkPg/Bq0H05XYKyiW+ufYxmuqr6pPglB0Y78YcdWHBHUoQJ6hyQOh8qxnk5b5YFpa7P9XO0/wv2pOp7JAKKvBV67YWxRUOgDhLshemvmaGPfXMdLxKwww7m9bNSvXOktJe4LG+J2bOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IV/kJN6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IV/kJN6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10954C4CEC5;
	Fri, 11 Oct 2024 00:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728608329;
	bh=9xKO+8cb6NRqX/ww5ueMPLL29WB7la28tpdZKvsS7hs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=IV/kJN6awxcCaAyqnT8fEL6DXFjvffrmx8+FlHZMH+HT6mfSapCfMdxSy52+BYlay
	 PCn5Hxx/dzYbHGbeelpVB2rPErQFqebiJXo637bNjprUxbAm1+Kd6ILZMw/YJUN29P
	 nfeApAyflqOOG5VMwdLZP7oc71LSKMg7TAoaWOF53g1taukuZaZE/ljgYfSoqWUsdC
	 qvbPeV6y7k3+oVksxPvXIh8I+xjT5tQ7Zg10RahGeSMd6vaRqyiJ+Zff4uMFtfYqar
	 YZoUGXQd70Gj9rF0qvePgMsn5tP8lTUCj8cXWr9dG06Pp+A2sZoBcud3rtaEHcFJKS
	 9T1Q0GYAh/F6w==
Date: Thu, 10 Oct 2024 17:58:48 -0700
Subject: [PATCH 12/21] xfs: move RT bitmap and summary information to the
 rtgroup
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172860643152.4177836.12017737680381138382.stgit@frogsfrogsfrogs>
In-Reply-To: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
References: <172860642881.4177836.4401344305682380131.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Move the pointers to the RT bitmap and summary inodes as well as the
summary cache to the rtgroups structure to prepare for having a
separate bitmap and summary inodes for each rtgroup.

Code using the inodes now needs to operate on a rtgroup.  Where easily
possible such code is converted to iterate over all rtgroups, else
rtgroup 0 (the only one that can currently exist) is hardcoded.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_bmap.c        |   13 +-
 fs/xfs/libxfs/xfs_rtbitmap.c    |  142 ++++++------------
 fs/xfs/libxfs/xfs_rtbitmap.h    |   64 +++-----
 fs/xfs/libxfs/xfs_rtgroup.c     |   80 ++++++++--
 fs/xfs/libxfs/xfs_rtgroup.h     |   14 ++
 fs/xfs/scrub/bmap.c             |   13 ++
 fs/xfs/scrub/fscounters.c       |   25 ++-
 fs/xfs/scrub/repair.c           |    2 
 fs/xfs/scrub/rtbitmap.c         |   45 +++---
 fs/xfs/scrub/rtsummary.c        |   93 ++++++------
 fs/xfs/scrub/rtsummary_repair.c |    7 +
 fs/xfs/scrub/scrub.c            |    4 -
 fs/xfs/xfs_discard.c            |   45 ++++--
 fs/xfs/xfs_fsmap.c              |   75 ++++++---
 fs/xfs/xfs_mount.h              |   10 -
 fs/xfs/xfs_qm.c                 |   13 +-
 fs/xfs/xfs_rtalloc.c            |  312 ++++++++++++++++++---------------------
 17 files changed, 500 insertions(+), 457 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index ca9b0ea115c893..61314813ad9970 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -5173,19 +5173,26 @@ xfs_bmap_free_rtblocks(
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
 
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 27a4472402bacd..c54ac160b90994 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -90,12 +90,12 @@ xfs_rtbuf_get(
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
 
@@ -503,6 +503,7 @@ xfs_rtmodify_summary(
 {
 	struct xfs_mount	*mp = args->mp;
 	xfs_rtsumoff_t		so = xfs_rtsumoffs(mp, log, bbno);
+	uint8_t			*rsum_cache = args->rtg->rtg_rsum_cache;
 	unsigned int		infoword;
 	xfs_suminfo_t		val;
 	int			error;
@@ -514,11 +515,11 @@ xfs_rtmodify_summary(
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
@@ -737,7 +738,7 @@ xfs_rtfree_range(
 	/*
 	 * Find the next allocated block (end of allocated extent).
 	 */
-	error = xfs_rtfind_forw(args, end, mp->m_sb.sb_rextents - 1,
+	error = xfs_rtfind_forw(args, end, args->rtg->rtg_extents - 1,
 			&postblock);
 	if (error)
 		return error;
@@ -961,19 +962,22 @@ xfs_rtcheck_alloc_range(
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
@@ -996,13 +1000,13 @@ xfs_rtfree_extent(
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
@@ -1018,6 +1022,7 @@ xfs_rtfree_extent(
 int
 xfs_rtfree_blocks(
 	struct xfs_trans	*tp,
+	struct xfs_rtgroup	*rtg,
 	xfs_fsblock_t		rtbno,
 	xfs_filblks_t		rtlen)
 {
@@ -1038,21 +1043,23 @@ xfs_rtfree_blocks(
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
@@ -1060,10 +1067,10 @@ xfs_rtalloc_query_range(
 
 	if (start > end)
 		return -EINVAL;
-	if (start == end || start >= mp->m_sb.sb_rextents)
+	if (start == end || start >= rtg->rtg_extents)
 		return 0;
 
-	end = min(end, mp->m_sb.sb_rextents - 1);
+	end = min(end, rtg->rtg_extents - 1);
 
 	/* Iterate the bitmap, looking for discrepancies. */
 	while (start <= end) {
@@ -1086,7 +1093,7 @@ xfs_rtalloc_query_range(
 			rec.ar_startext = start;
 			rec.ar_extcount = rtend - start + 1;
 
-			error = fn(mp, tp, &rec, priv);
+			error = fn(rtg, tp, &rec, priv);
 			if (error)
 				break;
 		}
@@ -1101,26 +1108,27 @@ xfs_rtalloc_query_range(
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
@@ -1161,65 +1169,6 @@ xfs_rtsummary_blockcount(
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
@@ -1260,21 +1209,25 @@ xfs_rtfile_alloc_blocks(
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
@@ -1306,12 +1259,13 @@ xfs_rtfile_initialize_block(
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
@@ -1319,8 +1273,8 @@ xfs_rtfile_initialize_blocks(
 		xfs_filblks_t		i;
 		int			error;
 
-		error = xfs_rtfile_alloc_blocks(ip, offset_fsb,
-				end_fsb - offset_fsb, &map);
+		error = xfs_rtfile_alloc_blocks(rtg->rtg_inodes[type],
+				offset_fsb, end_fsb - offset_fsb, &map);
 		if (error)
 			return error;
 
@@ -1330,7 +1284,7 @@ xfs_rtfile_initialize_blocks(
 		 * Do this one block per transaction, to keep it simple.
 		 */
 		for (i = 0; i < map.br_blockcount; i++) {
-			error = xfs_rtfile_initialize_block(ip,
+			error = xfs_rtfile_initialize_block(rtg, type,
 					map.br_startblock + i, data);
 			if (error)
 				return error;
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.h b/fs/xfs/libxfs/xfs_rtbitmap.h
index 140513d1d6bcf1..b3cbc56aa255ed 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.h
+++ b/fs/xfs/libxfs/xfs_rtbitmap.h
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
diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
index dac5d5b51aed05..028ba400b62966 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.c
+++ b/fs/xfs/libxfs/xfs_rtgroup.c
@@ -140,10 +140,16 @@ xfs_rtgroup_lock(
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
@@ -156,10 +162,12 @@ xfs_rtgroup_unlock(
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
@@ -175,8 +183,12 @@ xfs_rtgroup_trans_join(
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
@@ -241,6 +253,14 @@ struct xfs_rtginode_ops {
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
@@ -280,7 +300,6 @@ xfs_rtginode_load(
 	struct xfs_trans	*tp)
 {
 	struct xfs_mount	*mp = tp->t_mountp;
-	const char		*path;
 	struct xfs_inode	*ip;
 	const struct xfs_rtginode_ops *ops = &xfs_rtginode_ops[type];
 	int			error;
@@ -288,15 +307,36 @@ xfs_rtginode_load(
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
diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 2ef028c88f102f..c8cee08afa2c4a 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
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
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 64168f2e42220a..008630b2b75263 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -19,6 +19,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
+#include "xfs_rtgroup.h"
 #include "xfs_health.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -314,8 +315,20 @@ xchk_bmap_rt_iextent_xref(
 	struct xchk_bmap_info	*info,
 	struct xfs_bmbt_irec	*irec)
 {
+	int			error;
+
+	error = xchk_rtgroup_init_existing(info->sc,
+			xfs_rtb_to_rgno(ip->i_mount, irec->br_startblock),
+			&info->sc->sr);
+	if (!xchk_fblock_process_error(info->sc, info->whichfork,
+			irec->br_startoff, &error))
+		return;
+
+	xchk_rtgroup_lock(&info->sc->sr, XCHK_RTGLOCK_ALL);
 	xchk_xref_is_used_rt_space(info->sc, irec->br_startblock,
 			irec->br_blockcount);
+
+	xchk_rtgroup_free(info->sc, &info->sc->sr);
 }
 
 /* Cross-reference a single datadev extent record. */
diff --git a/fs/xfs/scrub/fscounters.c b/fs/xfs/scrub/fscounters.c
index 28db0c83819c20..4a50f8e0004092 100644
--- a/fs/xfs/scrub/fscounters.c
+++ b/fs/xfs/scrub/fscounters.c
@@ -19,6 +19,7 @@
 #include "xfs_rtbitmap.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -386,7 +387,7 @@ xchk_fscount_aggregate_agcounts(
 #ifdef CONFIG_XFS_RT
 STATIC int
 xchk_fscount_add_frextent(
-	struct xfs_mount		*mp,
+	struct xfs_rtgroup		*rtg,
 	struct xfs_trans		*tp,
 	const struct xfs_rtalloc_rec	*rec,
 	void				*priv)
@@ -407,6 +408,7 @@ xchk_fscount_count_frextents(
 	struct xchk_fscounters	*fsc)
 {
 	struct xfs_mount	*mp = sc->mp;
+	struct xfs_rtgroup	*rtg = NULL;
 	int			error;
 
 	fsc->frextents = 0;
@@ -414,19 +416,20 @@ xchk_fscount_count_frextents(
 	if (!xfs_has_realtime(mp))
 		return 0;
 
-	xfs_rtbitmap_lock_shared(sc->mp, XFS_RBMLOCK_BITMAP);
-	error = xfs_rtalloc_query_all(sc->mp, sc->tp,
-			xchk_fscount_add_frextent, fsc);
-	if (error) {
-		xchk_set_incomplete(sc);
-		goto out_unlock;
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
+		error = xfs_rtalloc_query_all(rtg, sc->tp,
+				xchk_fscount_add_frextent, fsc);
+		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
+		if (error) {
+			xchk_set_incomplete(sc);
+			xfs_rtgroup_rele(rtg);
+			return error;
+		}
 	}
 
 	fsc->frextents_delayed = percpu_counter_sum(&mp->m_delalloc_rtextents);
-
-out_unlock:
-	xfs_rtbitmap_unlock_shared(sc->mp, XFS_RBMLOCK_BITMAP);
-	return error;
+	return 0;
 }
 #else
 STATIC int
diff --git a/fs/xfs/scrub/repair.c b/fs/xfs/scrub/repair.c
index 5fdd00029cd6c0..3fa009126170e6 100644
--- a/fs/xfs/scrub/repair.c
+++ b/fs/xfs/scrub/repair.c
@@ -21,7 +21,7 @@
 #include "xfs_rmap.h"
 #include "xfs_rmap_btree.h"
 #include "xfs_refcount_btree.h"
-#include "xfs_rtgroup.h"
+#include "xfs_rtbitmap.h"
 #include "xfs_extent_busy.h"
 #include "xfs_ag.h"
 #include "xfs_ag_resv.h"
diff --git a/fs/xfs/scrub/rtbitmap.c b/fs/xfs/scrub/rtbitmap.c
index 46583517377ffa..c68de973e5f26c 100644
--- a/fs/xfs/scrub/rtbitmap.c
+++ b/fs/xfs/scrub/rtbitmap.c
@@ -35,6 +35,10 @@ xchk_setup_rtbitmap(
 		return -ENOMEM;
 	sc->buf = rtb;
 
+	error = xchk_rtgroup_init(sc, sc->sm->sm_agno, &sc->sr);
+	if (error)
+		return error;
+
 	if (xchk_could_repair(sc)) {
 		error = xrep_setup_rtbitmap(sc, rtb);
 		if (error)
@@ -45,7 +49,8 @@ xchk_setup_rtbitmap(
 	if (error)
 		return error;
 
-	error = xchk_install_live_inode(sc, sc->mp->m_rbmip);
+	error = xchk_install_live_inode(sc,
+			sc->sr.rtg->rtg_inodes[XFS_RTGI_BITMAP]);
 	if (error)
 		return error;
 
@@ -53,18 +58,18 @@ xchk_setup_rtbitmap(
 	if (error)
 		return error;
 
-	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTBITMAP);
-
 	/*
 	 * Now that we've locked the rtbitmap, we can't race with growfsrt
 	 * trying to expand the bitmap or change the size of the rt volume.
 	 * Hence it is safe to compute and check the geometry values.
 	 */
+	xchk_rtgroup_lock(&sc->sr, XFS_RTGLOCK_BITMAP);
 	if (mp->m_sb.sb_rblocks) {
 		rtb->rextents = xfs_rtb_to_rtx(mp, mp->m_sb.sb_rblocks);
 		rtb->rextslog = xfs_compute_rextslog(rtb->rextents);
 		rtb->rbmblocks = xfs_rtbitmap_blockcount(mp, rtb->rextents);
 	}
+
 	return 0;
 }
 
@@ -73,11 +78,12 @@ xchk_setup_rtbitmap(
 /* Scrub a free extent record from the realtime bitmap. */
 STATIC int
 xchk_rtbitmap_rec(
-	struct xfs_mount	*mp,
+	struct xfs_rtgroup	*rtg,
 	struct xfs_trans	*tp,
 	const struct xfs_rtalloc_rec *rec,
 	void			*priv)
 {
+	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_scrub	*sc = priv;
 	xfs_rtblock_t		startblock;
 	xfs_filblks_t		blockcount;
@@ -140,18 +146,20 @@ xchk_rtbitmap(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_mount	*mp = sc->mp;
+	struct xfs_rtgroup	*rtg = sc->sr.rtg;
+	struct xfs_inode	*rbmip = rtg->rtg_inodes[XFS_RTGI_BITMAP];
 	struct xchk_rtbitmap	*rtb = sc->buf;
 	int			error;
 
 	/* Is sb_rextents correct? */
 	if (mp->m_sb.sb_rextents != rtb->rextents) {
-		xchk_ino_set_corrupt(sc, mp->m_rbmip->i_ino);
+		xchk_ino_set_corrupt(sc, rbmip->i_ino);
 		return 0;
 	}
 
 	/* Is sb_rextslog correct? */
 	if (mp->m_sb.sb_rextslog != rtb->rextslog) {
-		xchk_ino_set_corrupt(sc, mp->m_rbmip->i_ino);
+		xchk_ino_set_corrupt(sc, rbmip->i_ino);
 		return 0;
 	}
 
@@ -160,17 +168,17 @@ xchk_rtbitmap(
 	 * case can we exceed 4bn bitmap blocks since the super field is a u32.
 	 */
 	if (rtb->rbmblocks > U32_MAX) {
-		xchk_ino_set_corrupt(sc, mp->m_rbmip->i_ino);
+		xchk_ino_set_corrupt(sc, rbmip->i_ino);
 		return 0;
 	}
 	if (mp->m_sb.sb_rbmblocks != rtb->rbmblocks) {
-		xchk_ino_set_corrupt(sc, mp->m_rbmip->i_ino);
+		xchk_ino_set_corrupt(sc, rbmip->i_ino);
 		return 0;
 	}
 
 	/* The bitmap file length must be aligned to an fsblock. */
-	if (mp->m_rbmip->i_disk_size & mp->m_blockmask) {
-		xchk_ino_set_corrupt(sc, mp->m_rbmip->i_ino);
+	if (rbmip->i_disk_size & mp->m_blockmask) {
+		xchk_ino_set_corrupt(sc, rbmip->i_ino);
 		return 0;
 	}
 
@@ -179,8 +187,8 @@ xchk_rtbitmap(
 	 * growfsrt expands the bitmap file before updating sb_rextents, so the
 	 * file can be larger than sb_rbmblocks.
 	 */
-	if (mp->m_rbmip->i_disk_size < XFS_FSB_TO_B(mp, rtb->rbmblocks)) {
-		xchk_ino_set_corrupt(sc, mp->m_rbmip->i_ino);
+	if (rbmip->i_disk_size < XFS_FSB_TO_B(mp, rtb->rbmblocks)) {
+		xchk_ino_set_corrupt(sc, rbmip->i_ino);
 		return 0;
 	}
 
@@ -193,7 +201,7 @@ xchk_rtbitmap(
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
 		return error;
 
-	error = xfs_rtalloc_query_all(mp, sc->tp, xchk_rtbitmap_rec, sc);
+	error = xfs_rtalloc_query_all(rtg, sc->tp, xchk_rtbitmap_rec, sc);
 	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
 		return error;
 
@@ -207,6 +215,8 @@ xchk_xref_is_used_rt_space(
 	xfs_rtblock_t		rtbno,
 	xfs_extlen_t		len)
 {
+	struct xfs_rtgroup	*rtg = sc->sr.rtg;
+	struct xfs_inode	*rbmip = rtg->rtg_inodes[XFS_RTGI_BITMAP];
 	xfs_rtxnum_t		startext;
 	xfs_rtxnum_t		endext;
 	bool			is_free;
@@ -217,13 +227,10 @@ xchk_xref_is_used_rt_space(
 
 	startext = xfs_rtb_to_rtx(sc->mp, rtbno);
 	endext = xfs_rtb_to_rtx(sc->mp, rtbno + len - 1);
-	xfs_ilock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
-	error = xfs_rtalloc_extent_is_free(sc->mp, sc->tp, startext,
+	error = xfs_rtalloc_extent_is_free(rtg, sc->tp, startext,
 			endext - startext + 1, &is_free);
 	if (!xchk_should_check_xref(sc, &error, NULL))
-		goto out_unlock;
+		return;
 	if (is_free)
-		xchk_ino_xref_set_corrupt(sc, sc->mp->m_rbmip->i_ino);
-out_unlock:
-	xfs_iunlock(sc->mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
+		xchk_ino_xref_set_corrupt(sc, rbmip->i_ino);
 }
diff --git a/fs/xfs/scrub/rtsummary.c b/fs/xfs/scrub/rtsummary.c
index 7c7366c98338b0..cda5e836862178 100644
--- a/fs/xfs/scrub/rtsummary.c
+++ b/fs/xfs/scrub/rtsummary.c
@@ -18,6 +18,7 @@
 #include "xfs_bmap.h"
 #include "xfs_sb.h"
 #include "xfs_exchmaps.h"
+#include "xfs_rtgroup.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/trace.h"
@@ -46,12 +47,19 @@ xchk_setup_rtsummary(
 	struct xchk_rtsummary	*rts;
 	int			error;
 
+	if (xchk_need_intent_drain(sc))
+		xchk_fsgates_enable(sc, XCHK_FSGATES_DRAIN);
+
 	rts = kvzalloc(struct_size(rts, words, mp->m_blockwsize),
 			XCHK_GFP_FLAGS);
 	if (!rts)
 		return -ENOMEM;
 	sc->buf = rts;
 
+	error = xchk_rtgroup_init(sc, sc->sm->sm_agno, &sc->sr);
+	if (error)
+		return error;
+
 	if (xchk_could_repair(sc)) {
 		error = xrep_setup_rtsummary(sc, rts);
 		if (error)
@@ -73,7 +81,8 @@ xchk_setup_rtsummary(
 	if (error)
 		return error;
 
-	error = xchk_install_live_inode(sc, mp->m_rsumip);
+	error = xchk_install_live_inode(sc,
+			sc->sr.rtg->rtg_inodes[XFS_RTGI_SUMMARY]);
 	if (error)
 		return error;
 
@@ -81,20 +90,17 @@ xchk_setup_rtsummary(
 	if (error)
 		return error;
 
-	/*
-	 * Locking order requires us to take the rtbitmap first.  We must be
-	 * careful to unlock it ourselves when we are done with the rtbitmap
-	 * file since the scrub infrastructure won't do that for us.  Only
-	 * then we can lock the rtsummary inode.
-	 */
-	xfs_ilock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
-	xchk_ilock(sc, XFS_ILOCK_EXCL | XFS_ILOCK_RTSUM);
-
 	/*
 	 * Now that we've locked the rtbitmap and rtsummary, we can't race with
 	 * growfsrt trying to expand the summary or change the size of the rt
 	 * volume.  Hence it is safe to compute and check the geometry values.
+	 *
+	 * Note that there is no strict requirement for an exclusive lock on the
+	 * summary here, but to keep the locking APIs simple we lock both inodes
+	 * exclusively here.  If we ever start caring about running concurrent
+	 * fsmap with scrub this could be changed.
 	 */
+	xchk_rtgroup_lock(&sc->sr, XFS_RTGLOCK_BITMAP);
 	if (mp->m_sb.sb_rblocks) {
 		int		rextslog;
 
@@ -105,6 +111,7 @@ xchk_setup_rtsummary(
 		rts->rsumblocks = xfs_rtsummary_blockcount(mp, rts->rsumlevels,
 				rts->rbmblocks);
 	}
+
 	return 0;
 }
 
@@ -155,11 +162,12 @@ xchk_rtsum_inc(
 /* Update the summary file to reflect the free extent that we've accumulated. */
 STATIC int
 xchk_rtsum_record_free(
-	struct xfs_mount		*mp,
+	struct xfs_rtgroup		*rtg,
 	struct xfs_trans		*tp,
 	const struct xfs_rtalloc_rec	*rec,
 	void				*priv)
 {
+	struct xfs_mount		*mp = rtg_mount(rtg);
 	struct xfs_scrub		*sc = priv;
 	xfs_fileoff_t			rbmoff;
 	xfs_rtblock_t			rtbno;
@@ -182,7 +190,8 @@ xchk_rtsum_record_free(
 	rtlen = xfs_rtx_to_rtb(mp, rec->ar_extcount);
 
 	if (!xfs_verify_rtbext(mp, rtbno, rtlen)) {
-		xchk_ino_xref_set_corrupt(sc, mp->m_rbmip->i_ino);
+		xchk_ino_xref_set_corrupt(sc,
+				rtg->rtg_inodes[XFS_RTGI_BITMAP]->i_ino);
 		return -EFSCORRUPTED;
 	}
 
@@ -204,15 +213,16 @@ xchk_rtsum_compute(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_mount	*mp = sc->mp;
+	struct xfs_rtgroup	*rtg = sc->sr.rtg;
 	unsigned long long	rtbmp_blocks;
 
 	/* If the bitmap size doesn't match the computed size, bail. */
 	rtbmp_blocks = xfs_rtbitmap_blockcount(mp, mp->m_sb.sb_rextents);
-	if (XFS_FSB_TO_B(mp, rtbmp_blocks) != mp->m_rbmip->i_disk_size)
+	if (XFS_FSB_TO_B(mp, rtbmp_blocks) !=
+	    rtg->rtg_inodes[XFS_RTGI_BITMAP]->i_disk_size)
 		return -EFSCORRUPTED;
 
-	return xfs_rtalloc_query_all(sc->mp, sc->tp, xchk_rtsum_record_free,
-			sc);
+	return xfs_rtalloc_query_all(rtg, sc->tp, xchk_rtsum_record_free, sc);
 }
 
 /* Compare the rtsummary file against the one we computed. */
@@ -231,8 +241,9 @@ xchk_rtsum_compare(
 	xfs_rtsumoff_t		sumoff = 0;
 	int			error = 0;
 
-	rts->args.mp = sc->mp;
+	rts->args.mp = mp;
 	rts->args.tp = sc->tp;
+	rts->args.rtg = sc->sr.rtg;
 
 	/* Mappings may not cross or lie beyond EOF. */
 	endoff = XFS_B_TO_FSB(mp, ip->i_disk_size);
@@ -299,31 +310,34 @@ xchk_rtsummary(
 	struct xfs_scrub	*sc)
 {
 	struct xfs_mount	*mp = sc->mp;
+	struct xfs_rtgroup	*rtg = sc->sr.rtg;
+	struct xfs_inode	*rbmip = rtg->rtg_inodes[XFS_RTGI_BITMAP];
+	struct xfs_inode	*rsumip = rtg->rtg_inodes[XFS_RTGI_SUMMARY];
 	struct xchk_rtsummary	*rts = sc->buf;
-	int			error = 0;
+	int			error;
 
 	/* Is sb_rextents correct? */
 	if (mp->m_sb.sb_rextents != rts->rextents) {
-		xchk_ino_set_corrupt(sc, mp->m_rbmip->i_ino);
-		goto out_rbm;
+		xchk_ino_set_corrupt(sc, rbmip->i_ino);
+		return 0;
 	}
 
 	/* Is m_rsumlevels correct? */
 	if (mp->m_rsumlevels != rts->rsumlevels) {
-		xchk_ino_set_corrupt(sc, mp->m_rsumip->i_ino);
-		goto out_rbm;
+		xchk_ino_set_corrupt(sc, rsumip->i_ino);
+		return 0;
 	}
 
 	/* Is m_rsumsize correct? */
 	if (mp->m_rsumblocks != rts->rsumblocks) {
-		xchk_ino_set_corrupt(sc, mp->m_rsumip->i_ino);
-		goto out_rbm;
+		xchk_ino_set_corrupt(sc, rsumip->i_ino);
+		return 0;
 	}
 
 	/* The summary file length must be aligned to an fsblock. */
-	if (mp->m_rsumip->i_disk_size & mp->m_blockmask) {
-		xchk_ino_set_corrupt(sc, mp->m_rsumip->i_ino);
-		goto out_rbm;
+	if (rsumip->i_disk_size & mp->m_blockmask) {
+		xchk_ino_set_corrupt(sc, rsumip->i_ino);
+		return 0;
 	}
 
 	/*
@@ -331,15 +345,15 @@ xchk_rtsummary(
 	 * growfsrt expands the summary file before updating sb_rextents, so
 	 * the file can be larger than rsumsize.
 	 */
-	if (mp->m_rsumip->i_disk_size < XFS_FSB_TO_B(mp, rts->rsumblocks)) {
-		xchk_ino_set_corrupt(sc, mp->m_rsumip->i_ino);
-		goto out_rbm;
+	if (rsumip->i_disk_size < XFS_FSB_TO_B(mp, rts->rsumblocks)) {
+		xchk_ino_set_corrupt(sc, rsumip->i_ino);
+		return 0;
 	}
 
 	/* Invoke the fork scrubber. */
 	error = xchk_metadata_inode_forks(sc);
 	if (error || (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT))
-		goto out_rbm;
+		return error;
 
 	/* Construct the new summary file from the rtbitmap. */
 	error = xchk_rtsum_compute(sc);
@@ -348,23 +362,12 @@ xchk_rtsummary(
 		 * EFSCORRUPTED means the rtbitmap is corrupt, which is an xref
 		 * error since we're checking the summary file.
 		 */
-		xchk_ino_xref_set_corrupt(sc, mp->m_rbmip->i_ino);
-		error = 0;
-		goto out_rbm;
+		xchk_ino_set_corrupt(sc, rbmip->i_ino);
+		return 0;
 	}
 	if (error)
-		goto out_rbm;
+		return error;
 
 	/* Does the computed summary file match the actual rtsummary file? */
-	error = xchk_rtsum_compare(sc);
-
-out_rbm:
-	/*
-	 * Unlock the rtbitmap since we're done with it.  All other writers of
-	 * the rt free space metadata grab the bitmap and summary ILOCKs in
-	 * that order, so we're still protected against allocation activities
-	 * even if we continue on to the repair function.
-	 */
-	xfs_iunlock(mp->m_rbmip, XFS_ILOCK_SHARED | XFS_ILOCK_RTBITMAP);
-	return error;
+	return xchk_rtsum_compare(sc);
 }
diff --git a/fs/xfs/scrub/rtsummary_repair.c b/fs/xfs/scrub/rtsummary_repair.c
index 7deeb948cb7027..1688380988007f 100644
--- a/fs/xfs/scrub/rtsummary_repair.c
+++ b/fs/xfs/scrub/rtsummary_repair.c
@@ -76,8 +76,9 @@ xrep_rtsummary_prep_buf(
 	union xfs_suminfo_raw	*ondisk;
 	int			error;
 
-	rts->args.mp = sc->mp;
+	rts->args.mp = mp;
 	rts->args.tp = sc->tp;
+	rts->args.rtg = sc->sr.rtg;
 	rts->args.sumbp = bp;
 	ondisk = xfs_rsumblock_infoptr(&rts->args, 0);
 	rts->args.sumbp = NULL;
@@ -162,8 +163,8 @@ xrep_rtsummary(
 		return error;
 
 	/* Reset incore state and blow out the summary cache. */
-	if (mp->m_rsum_cache)
-		memset(mp->m_rsum_cache, 0xFF, mp->m_sb.sb_rbmblocks);
+	if (sc->sr.rtg->rtg_rsum_cache)
+		memset(sc->sr.rtg->rtg_rsum_cache, 0xFF, mp->m_sb.sb_rbmblocks);
 
 	mp->m_rsumlevels = rts->rsumlevels;
 	mp->m_rsumblocks = rts->rsumblocks;
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 9d9990d5c6c482..910825d4b61a29 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -384,13 +384,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.repair	= xrep_parent,
 	},
 	[XFS_SCRUB_TYPE_RTBITMAP] = {	/* realtime bitmap */
-		.type	= ST_FS,
+		.type	= ST_RTGROUP,
 		.setup	= xchk_setup_rtbitmap,
 		.scrub	= xchk_rtbitmap,
 		.repair	= xrep_rtbitmap,
 	},
 	[XFS_SCRUB_TYPE_RTSUM] = {	/* realtime summary */
-		.type	= ST_FS,
+		.type	= ST_RTGROUP,
 		.setup	= xchk_setup_rtsummary,
 		.scrub	= xchk_rtsummary,
 		.repair	= xrep_rtsummary,
diff --git a/fs/xfs/xfs_discard.c b/fs/xfs/xfs_discard.c
index ca19d57b78e693..d4f42395d67e9c 100644
--- a/fs/xfs/xfs_discard.c
+++ b/fs/xfs/xfs_discard.c
@@ -507,7 +507,7 @@ xfs_discard_rtdev_extents(
 
 static int
 xfs_trim_gather_rtextent(
-	struct xfs_mount		*mp,
+	struct xfs_rtgroup		*rtg,
 	struct xfs_trans		*tp,
 	const struct xfs_rtalloc_rec	*rec,
 	void				*priv)
@@ -526,12 +526,12 @@ xfs_trim_gather_rtextent(
 		return -ECANCELED;
 	}
 
-	rbno = xfs_rtx_to_rtb(mp, rec->ar_startext);
-	rlen = xfs_rtx_to_rtb(mp, rec->ar_extcount);
+	rbno = xfs_rtx_to_rtb(rtg_mount(rtg), rec->ar_startext);
+	rlen = xfs_rtx_to_rtb(rtg_mount(rtg), rec->ar_extcount);
 
 	/* Ignore too small. */
 	if (rlen < tr->minlen_fsb) {
-		trace_xfs_discard_rttoosmall(mp, rbno, rlen);
+		trace_xfs_discard_rttoosmall(rtg_mount(rtg), rbno, rlen);
 		return 0;
 	}
 
@@ -550,11 +550,12 @@ xfs_trim_gather_rtextent(
 
 static int
 xfs_trim_rtextents(
-	struct xfs_mount	*mp,
+	struct xfs_rtgroup	*rtg,
 	xfs_rtxnum_t		low,
 	xfs_rtxnum_t		high,
 	xfs_daddr_t		minlen)
 {
+	struct xfs_mount	*mp = rtg_mount(rtg);
 	struct xfs_trim_rtdev	tr = {
 		.minlen_fsb	= XFS_BB_TO_FSB(mp, minlen),
 		.extent_list	= LIST_HEAD_INIT(tr.extent_list),
@@ -572,25 +573,25 @@ xfs_trim_rtextents(
 	 */
 	do {
 		tr.stop_rtx = low + (mp->m_sb.sb_blocksize * NBBY);
-		xfs_rtbitmap_lock_shared(mp, XFS_RBMLOCK_BITMAP);
-		error = xfs_rtalloc_query_range(mp, tp, low, high,
+		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
+		error = xfs_rtalloc_query_range(rtg, tp, low, high,
 				xfs_trim_gather_rtextent, &tr);
 
 		if (error == -ECANCELED)
 			error = 0;
 		if (error) {
-			xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
+			xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
 			xfs_discard_free_rtdev_extents(&tr);
 			break;
 		}
 
 		if (list_empty(&tr.extent_list)) {
-			xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
+			xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
 			break;
 		}
 
 		error = xfs_discard_rtdev_extents(mp, &tr);
-		xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
+		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
 		if (error)
 			break;
 
@@ -610,6 +611,9 @@ xfs_trim_rtdev_extents(
 {
 	xfs_rtblock_t		start_rtbno, end_rtbno;
 	xfs_rtxnum_t		start_rtx, end_rtx;
+	xfs_rgnumber_t		start_rgno, end_rgno;
+	int			last_error = 0, error;
+	struct xfs_rtgroup	*rtg = NULL;
 
 	/* Shift the start and end downwards to match the rt device. */
 	start_rtbno = xfs_daddr_to_rtb(mp, start);
@@ -618,14 +622,33 @@ xfs_trim_rtdev_extents(
 	else
 		start_rtbno = 0;
 	start_rtx = xfs_rtb_to_rtx(mp, start_rtbno);
+	start_rgno = xfs_rtb_to_rgno(mp, start_rtbno);
 
 	end_rtbno = xfs_daddr_to_rtb(mp, end);
 	if (end_rtbno <= mp->m_sb.sb_dblocks)
 		return 0;
 	end_rtbno -= mp->m_sb.sb_dblocks;
 	end_rtx = xfs_rtb_to_rtx(mp, end_rtbno + mp->m_sb.sb_rextsize - 1);
+	end_rgno = xfs_rtb_to_rgno(mp, end_rtbno);
 
-	return xfs_trim_rtextents(mp, start_rtx, end_rtx, minlen);
+	while ((rtg = xfs_rtgroup_next_range(mp, rtg, start_rgno, end_rgno))) {
+		xfs_rtxnum_t	rtg_end = rtg->rtg_extents;
+
+		if (rtg_rgno(rtg) == end_rgno)
+			rtg_end = min(rtg_end, end_rtx);
+
+		error = xfs_trim_rtextents(rtg, start_rtx, rtg_end, minlen);
+		if (error)
+			last_error = error;
+
+		if (xfs_trim_should_stop()) {
+			xfs_rtgroup_rele(rtg);
+			break;
+		}
+		start_rtx = 0;
+	}
+
+	return last_error;
 }
 #else
 # define xfs_trim_rtdev_extents(...)	(-EOPNOTSUPP)
diff --git a/fs/xfs/xfs_fsmap.c b/fs/xfs/xfs_fsmap.c
index 526a91470ff7d4..b2d2121faaabb3 100644
--- a/fs/xfs/xfs_fsmap.c
+++ b/fs/xfs/xfs_fsmap.c
@@ -712,7 +712,7 @@ xfs_getfsmap_logdev(
 /* Transform a rtbitmap "record" into a fsmap */
 STATIC int
 xfs_getfsmap_rtdev_rtbitmap_helper(
-	struct xfs_mount		*mp,
+	struct xfs_rtgroup		*rtg,
 	struct xfs_trans		*tp,
 	const struct xfs_rtalloc_rec	*rec,
 	void				*priv)
@@ -720,6 +720,7 @@ xfs_getfsmap_rtdev_rtbitmap_helper(
 	struct xfs_fsmap_irec		frec = {
 		.owner			= XFS_RMAP_OWN_NULL, /* "free" */
 	};
+	struct xfs_mount		*mp = rtg_mount(rtg);
 	struct xfs_getfsmap_info	*info = priv;
 	xfs_rtblock_t			rtbno;
 
@@ -751,10 +752,11 @@ xfs_getfsmap_rtdev_rtbitmap(
 	const struct xfs_fsmap		*keys,
 	struct xfs_getfsmap_info	*info)
 {
-
-	struct xfs_rtalloc_rec		ahigh = { 0 };
 	struct xfs_mount		*mp = tp->t_mountp;
 	xfs_rtblock_t			start_rtbno, end_rtbno;
+	xfs_rtxnum_t			start_rtx, end_rtx;
+	xfs_rgnumber_t			start_rgno, end_rgno;
+	struct xfs_rtgroup		*rtg = NULL;
 	uint64_t			eofs;
 	int				error;
 
@@ -772,36 +774,61 @@ xfs_getfsmap_rtdev_rtbitmap(
 		if (info->low_daddr >= eofs)
 			return 0;
 	}
+	start_rtx = xfs_rtb_to_rtx(mp, start_rtbno);
+	start_rgno = xfs_rtb_to_rgno(mp, start_rtbno);
 
 	end_rtbno = xfs_daddr_to_rtb(mp, min(eofs - 1, keys[1].fmr_physical));
+	end_rgno = xfs_rtb_to_rgno(mp, end_rtbno);
 
 	trace_xfs_fsmap_low_linear_key(mp, info->dev, start_rtbno);
 	trace_xfs_fsmap_high_linear_key(mp, info->dev, end_rtbno);
 
-	xfs_rtbitmap_lock_shared(mp, XFS_RBMLOCK_BITMAP);
+	end_rtx = -1ULL;
 
-	/*
-	 * Set up query parameters to return free rtextents covering the range
-	 * we want.
-	 */
-	error = xfs_rtalloc_query_range(mp, tp, xfs_rtb_to_rtx(mp, start_rtbno),
-			xfs_rtb_to_rtxup(mp, end_rtbno),
-			xfs_getfsmap_rtdev_rtbitmap_helper, info);
-	if (error)
-		goto err;
+	while ((rtg = xfs_rtgroup_next_range(mp, rtg, start_rgno, end_rgno))) {
+		if (rtg_rgno(rtg) == end_rgno)
+			end_rtx = xfs_rtb_to_rtx(mp,
+					end_rtbno + mp->m_sb.sb_rextsize - 1);
 
-	/*
-	 * Report any gaps at the end of the rtbitmap by simulating a null
-	 * rmap starting at the block after the end of the query range.
-	 */
-	info->last = true;
-	ahigh.ar_startext = min(mp->m_sb.sb_rextents, high);
+		info->group = &rtg->rtg_group;
+		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
+		error = xfs_rtalloc_query_range(rtg, tp, start_rtx, end_rtx,
+				xfs_getfsmap_rtdev_rtbitmap_helper, info);
+		if (error)
+			break;
+
+		/*
+		 * Report any gaps at the end of the rtbitmap by simulating a
+		 * zero-length free extent starting at the rtx after the end
+		 * of the query range.
+		 */
+		if (rtg_rgno(rtg) == end_rgno) {
+			struct xfs_rtalloc_rec	ahigh = {
+				.ar_startext	= min(end_rtx + 1,
+						      rtg->rtg_extents),
+			};
+
+			info->last = true;
+			error = xfs_getfsmap_rtdev_rtbitmap_helper(rtg, tp,
+					&ahigh, info);
+			if (error)
+				break;
+		}
+
+		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
+		info->group = NULL;
+		start_rtx = 0;
+	}
+
+	/* loop termination case */
+	if (rtg) {
+		if (info->group) {
+			xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
+			info->group = NULL;
+		}
+		xfs_rtgroup_rele(rtg);
+	}
 
-	error = xfs_getfsmap_rtdev_rtbitmap_helper(mp, tp, &ahigh, info);
-	if (error)
-		goto err;
-err:
-	xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
 	return error;
 }
 #endif /* CONFIG_XFS_RT */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b5424a5fb48524..f07c91b3225cf9 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -94,8 +94,6 @@ typedef struct xfs_mount {
 	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
 	struct xfs_da_geometry	*m_attr_geo;	/* attribute block geometry */
 	struct xlog		*m_log;		/* log specific stuff */
-	struct xfs_inode	*m_rbmip;	/* pointer to bitmap inode */
-	struct xfs_inode	*m_rsumip;	/* pointer to summary inode */
 	struct xfs_inode	*m_rootip;	/* pointer to root directory */
 	struct xfs_inode	*m_metadirip;	/* ptr to metadata directory */
 	struct xfs_inode	*m_rtdirip;	/* ptr to realtime metadir */
@@ -104,14 +102,6 @@ typedef struct xfs_mount {
 	struct xfs_buftarg	*m_logdev_targp;/* log device */
 	struct xfs_buftarg	*m_rtdev_targp;	/* rt device */
 	void __percpu		*m_inodegc;	/* percpu inodegc structures */
-
-	/*
-	 * Optional cache of rt summary level per bitmap block with the
-	 * invariant that m_rsum_cache[bbno] > the maximum i for which
-	 * rsum[i][bbno] != 0, or 0 if rsum[i][bbno] == 0 for all i.
-	 * Reads and writes are serialized by the rsumip inode lock.
-	 */
-	uint8_t			*m_rsum_cache;
 	struct xfs_mru_cache	*m_filestream;  /* per-mount filestream data */
 	struct workqueue_struct *m_buf_workqueue;
 	struct workqueue_struct	*m_unwritten_workqueue;
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 3663c4f89ed8a1..28b1420bac1dd2 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -215,10 +215,15 @@ static void
 xfs_qm_unmount_rt(
 	struct xfs_mount	*mp)
 {
-	if (mp->m_rbmip)
-		xfs_qm_dqdetach(mp->m_rbmip);
-	if (mp->m_rsumip)
-		xfs_qm_dqdetach(mp->m_rsumip);
+	struct xfs_rtgroup	*rtg = xfs_rtgroup_grab(mp, 0);
+
+	if (!rtg)
+		return;
+	if (rtg->rtg_inodes[XFS_RTGI_BITMAP])
+		xfs_qm_dqdetach(rtg->rtg_inodes[XFS_RTGI_BITMAP]);
+	if (rtg->rtg_inodes[XFS_RTGI_SUMMARY])
+		xfs_qm_dqdetach(rtg->rtg_inodes[XFS_RTGI_SUMMARY]);
+	xfs_rtgroup_rele(rtg);
 }
 
 /*
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 9a451f88bf4647..7d7dd057f057f1 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -42,14 +42,14 @@ xfs_rtany_summary(
 	xfs_fileoff_t		bbno,	/* bitmap block number */
 	int			*maxlog) /* out: max log2 extent size free */
 {
-	struct xfs_mount	*mp = args->mp;
+	uint8_t			*rsum_cache = args->rtg->rtg_rsum_cache;
 	int			error;
 	int			log;	/* loop counter, log2 of ext. size */
 	xfs_suminfo_t		sum;	/* summary data */
 
-	/* There are no extents at levels >= m_rsum_cache[bbno]. */
-	if (mp->m_rsum_cache) {
-		high = min(high, mp->m_rsum_cache[bbno] - 1);
+	/* There are no extents at levels >= rsum_cache[bbno]. */
+	if (rsum_cache) {
+		high = min(high, rsum_cache[bbno] - 1);
 		if (low > high) {
 			*maxlog = -1;
 			return 0;
@@ -81,12 +81,11 @@ xfs_rtany_summary(
 	*maxlog = -1;
 out:
 	/* There were no extents at levels > log. */
-	if (mp->m_rsum_cache && log + 1 < mp->m_rsum_cache[bbno])
-		mp->m_rsum_cache[bbno] = log + 1;
+	if (rsum_cache && log + 1 < rsum_cache[bbno])
+		rsum_cache[bbno] = log + 1;
 	return 0;
 }
 
-
 /*
  * Copy and transform the summary file, given the old and new
  * parameters in the mount structures.
@@ -153,7 +152,7 @@ xfs_rtallocate_range(
 	/*
 	 * Find the next allocated block (end of free extent).
 	 */
-	error = xfs_rtfind_forw(args, end, mp->m_sb.sb_rextents - 1,
+	error = xfs_rtfind_forw(args, end, args->rtg->rtg_extents - 1,
 			&postblock);
 	if (error)
 		return error;
@@ -215,14 +214,14 @@ xfs_rtalloc_align_len(
  */
 static inline xfs_rtxlen_t
 xfs_rtallocate_clamp_len(
-	struct xfs_mount	*mp,
+	struct xfs_rtgroup	*rtg,
 	xfs_rtxnum_t		startrtx,
 	xfs_rtxlen_t		rtxlen,
 	xfs_rtxlen_t		prod)
 {
 	xfs_rtxlen_t		ret;
 
-	ret = min(mp->m_sb.sb_rextents, startrtx + rtxlen) - startrtx;
+	ret = min(rtg->rtg_extents, startrtx + rtxlen) - startrtx;
 	return xfs_rtalloc_align_len(ret, prod);
 }
 
@@ -257,10 +256,11 @@ xfs_rtallocate_extent_block(
 	 * Loop over all the extents starting in this bitmap block up to the
 	 * end of the rt volume, looking for one that's long enough.
 	 */
-	end = min(mp->m_sb.sb_rextents, xfs_rbmblock_to_rtx(mp, bbno + 1)) - 1;
+	end = min(args->rtg->rtg_extents, xfs_rbmblock_to_rtx(mp, bbno + 1)) -
+		1;
 	for (i = xfs_rbmblock_to_rtx(mp, bbno); i <= end; i++) {
 		/* Make sure we don't scan off the end of the rt volume. */
-		scanlen = xfs_rtallocate_clamp_len(mp, i, maxlen, prod);
+		scanlen = xfs_rtallocate_clamp_len(args->rtg, i, maxlen, prod);
 		if (scanlen < minlen)
 			break;
 
@@ -345,7 +345,6 @@ xfs_rtallocate_extent_exact(
 	xfs_rtxlen_t		prod,	/* extent product factor */
 	xfs_rtxnum_t		*rtx)	/* out: start rtext allocated */
 {
-	struct xfs_mount	*mp = args->mp;
 	xfs_rtxnum_t		next;	/* next rtext to try (dummy) */
 	xfs_rtxlen_t		alloclen; /* candidate length */
 	xfs_rtxlen_t		scanlen; /* number of free rtx to look for */
@@ -356,7 +355,7 @@ xfs_rtallocate_extent_exact(
 	ASSERT(maxlen % prod == 0);
 
 	/* Make sure we don't run off the end of the rt volume. */
-	scanlen = xfs_rtallocate_clamp_len(mp, start, maxlen, prod);
+	scanlen = xfs_rtallocate_clamp_len(args->rtg, start, maxlen, prod);
 	if (scanlen < minlen)
 		return -ENOSPC;
 
@@ -417,11 +416,10 @@ xfs_rtallocate_extent_near(
 	ASSERT(maxlen % prod == 0);
 
 	/*
-	 * If the block number given is off the end, silently set it to
-	 * the last block.
+	 * If the block number given is off the end, silently set it to the last
+	 * block.
 	 */
-	if (start >= mp->m_sb.sb_rextents)
-		start = mp->m_sb.sb_rextents - 1;
+	start = min(start, args->rtg->rtg_extents - 1);
 
 	/*
 	 * Try the exact allocation first.
@@ -661,21 +659,22 @@ xfs_rtunmount_rtg(
 
 	for (i = 0; i < XFS_RTGI_MAX; i++)
 		xfs_rtginode_irele(&rtg->rtg_inodes[i]);
+	kvfree(rtg->rtg_rsum_cache);
 }
 
 static int
 xfs_alloc_rsum_cache(
-	struct xfs_mount	*mp,
+	struct xfs_rtgroup	*rtg,
 	xfs_extlen_t		rbmblocks)
 {
 	/*
 	 * The rsum cache is initialized to the maximum value, which is
 	 * trivially an upper bound on the maximum level with any free extents.
 	 */
-	mp->m_rsum_cache = kvmalloc(rbmblocks, GFP_KERNEL);
-	if (!mp->m_rsum_cache)
+	rtg->rtg_rsum_cache = kvmalloc(rbmblocks, GFP_KERNEL);
+	if (!rtg->rtg_rsum_cache)
 		return -ENOMEM;
-	memset(mp->m_rsum_cache, -1, rbmblocks);
+	memset(rtg->rtg_rsum_cache, -1, rbmblocks);
 	return 0;
 }
 
@@ -714,17 +713,20 @@ xfs_growfs_rt_fixup_extsize(
 
 static int
 xfs_growfs_rt_bmblock(
-	struct xfs_mount	*mp,
+	struct xfs_rtgroup	*rtg,
 	xfs_rfsblock_t		nrblocks,
 	xfs_agblock_t		rextsize,
 	xfs_fileoff_t		bmbno)
 {
-	struct xfs_inode	*rbmip = mp->m_rbmip;
-	struct xfs_inode	*rsumip = mp->m_rsumip;
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_inode	*rbmip = rtg->rtg_inodes[XFS_RTGI_BITMAP];
+	struct xfs_inode	*rsumip = rtg->rtg_inodes[XFS_RTGI_SUMMARY];
 	struct xfs_rtalloc_args	args = {
 		.mp		= mp,
+		.rtg		= rtg,
 	};
 	struct xfs_rtalloc_args	nargs = {
+		.rtg		= rtg,
 	};
 	struct xfs_mount	*nmp;
 	xfs_rfsblock_t		nrblocks_step;
@@ -750,6 +752,7 @@ xfs_growfs_rt_bmblock(
 	nmp->m_rsumlevels = nmp->m_sb.sb_rextslog + 1;
 	nmp->m_rsumblocks = xfs_rtsummary_blockcount(mp, nmp->m_rsumlevels,
 			nmp->m_sb.sb_rbmblocks);
+	rtg->rtg_extents = xfs_rtgroup_extents(nmp, rtg_rgno(rtg));
 
 	/*
 	 * Recompute the growfsrt reservation from the new rsumsize, so that the
@@ -762,8 +765,8 @@ xfs_growfs_rt_bmblock(
 		goto out_free;
 	nargs.tp = args.tp;
 
-	xfs_rtbitmap_lock(mp);
-	xfs_rtbitmap_trans_join(args.tp);
+	xfs_rtgroup_lock(args.rtg, XFS_RTGLOCK_BITMAP);
+	xfs_rtgroup_trans_join(args.tp, args.rtg, XFS_RTGLOCK_BITMAP);
 
 	/*
 	 * Update the bitmap inode's size ondisk and incore.  We need to update
@@ -865,8 +868,9 @@ xfs_growfs_rt_bmblock(
  */
 static xfs_fileoff_t
 xfs_last_rt_bmblock(
-	struct xfs_mount	*mp)
+	struct xfs_rtgroup	*rtg)
 {
+	struct xfs_mount	*mp = rtg_mount(rtg);
 	xfs_fileoff_t		bmbno = mp->m_sb.sb_rbmblocks;
 
 	/* Skip the current block if it is exactly full. */
@@ -880,13 +884,14 @@ xfs_last_rt_bmblock(
  */
 static int
 xfs_growfs_rt_alloc_blocks(
-	struct xfs_mount	*mp,
+	struct xfs_rtgroup	*rtg,
 	xfs_rfsblock_t		nrblocks,
 	xfs_agblock_t		rextsize,
 	xfs_extlen_t		*nrbmblocks)
 {
-	struct xfs_inode	*rbmip = mp->m_rbmip;
-	struct xfs_inode	*rsumip = mp->m_rsumip;
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_inode	*rbmip = rtg->rtg_inodes[XFS_RTGI_BITMAP];
+	struct xfs_inode	*rsumip = rtg->rtg_inodes[XFS_RTGI_SUMMARY];
 	xfs_rtxnum_t		nrextents = div_u64(nrblocks, rextsize);
 	xfs_extlen_t		orbmblocks;
 	xfs_extlen_t		orsumblocks;
@@ -904,14 +909,66 @@ xfs_growfs_rt_alloc_blocks(
 	nrsumblocks = xfs_rtsummary_blockcount(mp,
 		xfs_compute_rextslog(nrextents) + 1, *nrbmblocks);
 
-	error = xfs_rtfile_initialize_blocks(rbmip, orbmblocks,
+	error = xfs_rtfile_initialize_blocks(rtg, XFS_RTGI_BITMAP, orbmblocks,
 			*nrbmblocks, NULL);
 	if (error)
 		return error;
-	return xfs_rtfile_initialize_blocks(rsumip, orsumblocks,
+	return xfs_rtfile_initialize_blocks(rtg, XFS_RTGI_SUMMARY, orsumblocks,
 			nrsumblocks, NULL);
 }
 
+static int
+xfs_growfs_rtg(
+	struct xfs_mount	*mp,
+	xfs_rfsblock_t		nrblocks,
+	xfs_agblock_t		rextsize)
+{
+	uint8_t			*old_rsum_cache = NULL;
+	xfs_extlen_t		bmblocks;
+	xfs_fileoff_t		bmbno;
+	struct xfs_rtgroup	*rtg;
+	int			error;
+
+	rtg = xfs_rtgroup_grab(mp, 0);
+	if (!rtg)
+		return -EINVAL;
+
+	error = xfs_growfs_rt_alloc_blocks(rtg, nrblocks, rextsize, &bmblocks);
+	if (error)
+		goto out_rele;
+
+	if (bmblocks != rtg_mount(rtg)->m_sb.sb_rbmblocks) {
+		old_rsum_cache = rtg->rtg_rsum_cache;
+		error = xfs_alloc_rsum_cache(rtg, bmblocks);
+		if (error)
+			goto out_rele;
+	}
+
+	for (bmbno = xfs_last_rt_bmblock(rtg); bmbno < bmblocks; bmbno++) {
+		error = xfs_growfs_rt_bmblock(rtg, nrblocks, rextsize, bmbno);
+		if (error)
+			goto out_error;
+	}
+
+	if (old_rsum_cache)
+		kvfree(old_rsum_cache);
+	xfs_rtgroup_rele(rtg);
+	return 0;
+
+out_error:
+	/*
+	 * Reset rtg_extents to the old value if adding more blocks failed.
+	 */
+	rtg->rtg_extents = xfs_rtgroup_extents(rtg_mount(rtg), rtg_rgno(rtg));
+	if (old_rsum_cache) {
+		kvfree(rtg->rtg_rsum_cache);
+		rtg->rtg_rsum_cache = old_rsum_cache;
+	}
+out_rele:
+	xfs_rtgroup_rele(rtg);
+	return error;
+}
+
 /*
  * Grow the realtime area of the filesystem.
  */
@@ -920,14 +977,12 @@ xfs_growfs_rt(
 	xfs_mount_t	*mp,		/* mount point for filesystem */
 	xfs_growfs_rt_t	*in)		/* growfs rt input struct */
 {
-	xfs_fileoff_t	bmbno;		/* bitmap block number */
-	struct xfs_buf	*bp;		/* temporary buffer */
-	int		error;		/* error return value */
-	xfs_extlen_t	nrbmblocks;	/* new number of rt bitmap blocks */
-	xfs_rtxnum_t	nrextents;	/* new number of realtime extents */
-	xfs_extlen_t	nrsumblocks;	/* new number of summary blocks */
-	uint8_t		*rsum_cache;	/* old summary cache */
-	xfs_agblock_t	old_rextsize = mp->m_sb.sb_rextsize;
+	xfs_rtxnum_t		nrextents;
+	xfs_extlen_t		nrbmblocks;
+	xfs_extlen_t		nrsumblocks;
+	struct xfs_buf		*bp;
+	xfs_agblock_t		old_rextsize = mp->m_sb.sb_rextsize;
+	int			error;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -938,15 +993,9 @@ xfs_growfs_rt(
 
 	if (!mutex_trylock(&mp->m_growlock))
 		return -EWOULDBLOCK;
-	/*
-	 * Mount should fail if the rt bitmap/summary files don't load, but
-	 * we'll check anyway.
-	 */
-	error = -EINVAL;
-	if (!mp->m_rbmip || !mp->m_rsumip)
-		goto out_unlock;
 
 	/* Shrink not supported. */
+	error = -EINVAL;
 	if (in->newblocks <= mp->m_sb.sb_rblocks)
 		goto out_unlock;
 	/* Can only change rt extent size when adding rt volume. */
@@ -980,10 +1029,9 @@ xfs_growfs_rt(
 	 * Calculate new parameters.  These are the final values to be reached.
 	 */
 	nrextents = div_u64(in->newblocks, in->extsize);
-	if (nrextents == 0) {
-		error = -EINVAL;
+	error = -EINVAL;
+	if (nrextents == 0)
 		goto out_unlock;
-	}
 	nrbmblocks = xfs_rtbitmap_blockcount(mp, nrextents);
 	nrsumblocks = xfs_rtsummary_blockcount(mp,
 			xfs_compute_rextslog(nrextents) + 1, nrbmblocks);
@@ -993,55 +1041,22 @@ xfs_growfs_rt(
 	 * the log.  This prevents us from getting a log overflow,
 	 * since we'll log basically the whole summary file at once.
 	 */
-	if (nrsumblocks > (mp->m_sb.sb_logblocks >> 1)) {
-		error = -EINVAL;
+	if (nrsumblocks > (mp->m_sb.sb_logblocks >> 1))
 		goto out_unlock;
-	}
 
-	error = xfs_growfs_rt_alloc_blocks(mp, in->newblocks, in->extsize,
-			&nrbmblocks);
+	error = xfs_growfs_rtg(mp, in->newblocks, in->extsize);
 	if (error)
 		goto out_unlock;
 
-	rsum_cache = mp->m_rsum_cache;
-	if (nrbmblocks != mp->m_sb.sb_rbmblocks) {
-		error = xfs_alloc_rsum_cache(mp, nrbmblocks);
-		if (error)
-			goto out_unlock;
-	}
-
-	/* Initialize the free space bitmap one bitmap block at a time. */
-	for (bmbno = xfs_last_rt_bmblock(mp); bmbno < nrbmblocks; bmbno++) {
-		error = xfs_growfs_rt_bmblock(mp, in->newblocks, in->extsize,
-				bmbno);
-		if (error)
-			goto out_free;
-	}
-
 	if (old_rextsize != in->extsize) {
 		error = xfs_growfs_rt_fixup_extsize(mp);
 		if (error)
-			goto out_free;
+			goto out_unlock;
 	}
 
 	/* Update secondary superblocks now the physical grow has completed */
 	error = xfs_update_secondary_sbs(mp);
 
-out_free:
-	/*
-	 * If we had to allocate a new rsum_cache, we either need to free the
-	 * old one (if we succeeded) or free the new one and restore the old one
-	 * (if there was an error).
-	 */
-	if (rsum_cache != mp->m_rsum_cache) {
-		if (error) {
-			kvfree(mp->m_rsum_cache);
-			mp->m_rsum_cache = rsum_cache;
-		} else {
-			kvfree(rsum_cache);
-		}
-	}
-
 out_unlock:
 	mutex_unlock(&mp->m_growlock);
 	return error;
@@ -1070,7 +1085,7 @@ xfs_rtmount_init(
 	mp->m_rsumlevels = sbp->sb_rextslog + 1;
 	mp->m_rsumblocks = xfs_rtsummary_blockcount(mp, mp->m_rsumlevels,
 			mp->m_sb.sb_rbmblocks);
-	mp->m_rbmip = mp->m_rsumip = NULL;
+
 	/*
 	 * Check that the realtime section is an ok size.
 	 */
@@ -1094,7 +1109,7 @@ xfs_rtmount_init(
 
 static int
 xfs_rtalloc_count_frextent(
-	struct xfs_mount		*mp,
+	struct xfs_rtgroup		*rtg,
 	struct xfs_trans		*tp,
 	const struct xfs_rtalloc_rec	*rec,
 	void				*priv)
@@ -1116,12 +1131,16 @@ xfs_rtalloc_reinit_frextents(
 	uint64_t		val = 0;
 	int			error;
 
-	xfs_rtbitmap_lock_shared(mp, XFS_RBMLOCK_BITMAP);
-	error = xfs_rtalloc_query_all(mp, NULL, xfs_rtalloc_count_frextent,
-			&val);
-	xfs_rtbitmap_unlock_shared(mp, XFS_RBMLOCK_BITMAP);
-	if (error)
-		return error;
+	struct xfs_rtgroup	*rtg = NULL;
+
+	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
+		xfs_rtgroup_lock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
+		error = xfs_rtalloc_query_all(rtg, NULL, xfs_rtalloc_count_frextent,
+				&val);
+		xfs_rtgroup_unlock(rtg, XFS_RTGLOCK_BITMAP_SHARED);
+		if (error)
+			return error;
+	}
 
 	spin_lock(&mp->m_sb_lock);
 	mp->m_sb.sb_frextents = val;
@@ -1160,17 +1179,6 @@ xfs_rtmount_iread_extents(
 	return error;
 }
 
-static void
-xfs_rtgroup_unmount_inodes(
-	struct xfs_mount	*mp)
-{
-	struct xfs_rtgroup	*rtg = NULL;
-
-	while ((rtg = xfs_rtgroup_next(mp, rtg)))
-		xfs_rtunmount_rtg(rtg);
-	xfs_rtginode_irele(&mp->m_rtdirip);
-}
-
 static int
 xfs_rtmount_rtg(
 	struct xfs_mount	*mp,
@@ -1194,7 +1202,7 @@ xfs_rtmount_rtg(
 		}
 	}
 
-	return 0;
+	return xfs_alloc_rsum_cache(rtg, mp->m_sb.sb_rbmblocks);
 }
 
 /*
@@ -1206,7 +1214,6 @@ xfs_rtmount_inodes(
 	struct xfs_mount	*mp)
 {
 	struct xfs_trans	*tp;
-	struct xfs_sb		*sbp = &mp->m_sb;
 	struct xfs_rtgroup	*rtg = NULL;
 	int			error;
 
@@ -1214,57 +1221,22 @@ xfs_rtmount_inodes(
 	if (error)
 		return error;
 
-	error = xfs_trans_metafile_iget(tp, mp->m_sb.sb_rbmino,
-			XFS_METAFILE_RTBITMAP, &mp->m_rbmip);
-	if (xfs_metadata_is_sick(error))
-		xfs_rt_mark_sick(mp, XFS_SICK_RT_BITMAP);
-	if (error)
-		goto out_trans;
-	ASSERT(mp->m_rbmip != NULL);
-
-	error = xfs_rtmount_iread_extents(tp, mp->m_rbmip, XFS_ILOCK_RTBITMAP);
-	if (error)
-		goto out_rele_bitmap;
-
-	error = xfs_trans_metafile_iget(tp, mp->m_sb.sb_rsumino,
-			XFS_METAFILE_RTSUMMARY, &mp->m_rsumip);
-	if (xfs_metadata_is_sick(error))
-		xfs_rt_mark_sick(mp, XFS_SICK_RT_SUMMARY);
-	if (error)
-		goto out_rele_bitmap;
-	ASSERT(mp->m_rsumip != NULL);
-
-	error = xfs_rtmount_iread_extents(tp, mp->m_rsumip, XFS_ILOCK_RTSUM);
-	if (error)
-		goto out_rele_summary;
-
 	if (xfs_has_rtgroups(mp) && mp->m_sb.sb_rgcount > 0) {
 		error = xfs_rtginode_load_parent(tp);
 		if (error)
-			goto out_rele_summary;
+			goto out_cancel;
 	}
 
 	while ((rtg = xfs_rtgroup_next(mp, rtg))) {
 		error = xfs_rtmount_rtg(mp, tp, rtg);
 		if (error) {
 			xfs_rtgroup_rele(rtg);
-			goto out_rele_inodes;
+			xfs_rtunmount_inodes(mp);
+			break;
 		}
 	}
 
-	error = xfs_alloc_rsum_cache(mp, sbp->sb_rbmblocks);
-	if (error)
-		goto out_rele_inodes;
-	xfs_trans_cancel(tp);
-	return 0;
-
-out_rele_inodes:
-	xfs_rtgroup_unmount_inodes(mp);
-out_rele_summary:
-	xfs_irele(mp->m_rsumip);
-out_rele_bitmap:
-	xfs_irele(mp->m_rbmip);
-out_trans:
+out_cancel:
 	xfs_trans_cancel(tp);
 	return error;
 }
@@ -1273,13 +1245,11 @@ void
 xfs_rtunmount_inodes(
 	struct xfs_mount	*mp)
 {
-	kvfree(mp->m_rsum_cache);
+	struct xfs_rtgroup	*rtg = NULL;
 
-	xfs_rtgroup_unmount_inodes(mp);
-	if (mp->m_rbmip)
-		xfs_irele(mp->m_rbmip);
-	if (mp->m_rsumip)
-		xfs_irele(mp->m_rsumip);
+	while ((rtg = xfs_rtgroup_next(mp, rtg)))
+		xfs_rtunmount_rtg(rtg);
+	xfs_rtginode_irele(&mp->m_rtdirip);
 }
 
 /*
@@ -1291,28 +1261,29 @@ xfs_rtunmount_inodes(
  */
 static xfs_rtxnum_t
 xfs_rtpick_extent(
-	xfs_mount_t		*mp,		/* file system mount point */
-	xfs_trans_t		*tp,		/* transaction pointer */
+	struct xfs_rtgroup	*rtg,
+	struct xfs_trans	*tp,
 	xfs_rtxlen_t		len)		/* allocation length (rtextents) */
 {
-	xfs_rtxnum_t		b;		/* result rtext */
+	struct xfs_mount	*mp = rtg_mount(rtg);
+	struct xfs_inode	*rbmip = rtg->rtg_inodes[XFS_RTGI_BITMAP];
+	xfs_rtxnum_t		b = 0;		/* result rtext */
 	int			log2;		/* log of sequence number */
 	uint64_t		resid;		/* residual after log removed */
 	uint64_t		seq;		/* sequence number of file creation */
 	struct timespec64	ts;		/* timespec in inode */
 
-	xfs_assert_ilocked(mp->m_rbmip, XFS_ILOCK_EXCL);
+	xfs_assert_ilocked(rbmip, XFS_ILOCK_EXCL);
 
-	ts = inode_get_atime(VFS_I(mp->m_rbmip));
-	if (!(mp->m_rbmip->i_diflags & XFS_DIFLAG_NEWRTBM)) {
-		mp->m_rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
+	ts = inode_get_atime(VFS_I(rbmip));
+	if (!(rbmip->i_diflags & XFS_DIFLAG_NEWRTBM)) {
+		rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
 		seq = 0;
 	} else {
 		seq = ts.tv_sec;
 	}
-	if ((log2 = xfs_highbit64(seq)) == -1)
-		b = 0;
-	else {
+	log2 = xfs_highbit64(seq);
+	if (log2 != -1) {
 		resid = seq - (1ULL << log2);
 		b = (mp->m_sb.sb_rextents * ((resid << 1) + 1ULL)) >>
 		    (log2 + 1);
@@ -1322,8 +1293,8 @@ xfs_rtpick_extent(
 			b = mp->m_sb.sb_rextents - len;
 	}
 	ts.tv_sec = seq + 1;
-	inode_set_atime_to_ts(VFS_I(mp->m_rbmip), ts);
-	xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
+	inode_set_atime_to_ts(VFS_I(rbmip), ts);
+	xfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
 	return b;
 }
 
@@ -1378,12 +1349,16 @@ xfs_rtallocate(
 	xfs_rtxlen_t		len = 0;
 	int			error = 0;
 
+	args.rtg = xfs_rtgroup_grab(args.mp, 0);
+	if (!args.rtg)
+		return -ENOSPC;
+
 	/*
 	 * Lock out modifications to both the RT bitmap and summary inodes.
 	 */
 	if (!*rtlocked) {
-		xfs_rtbitmap_lock(args.mp);
-		xfs_rtbitmap_trans_join(tp);
+		xfs_rtgroup_lock(args.rtg, XFS_RTGLOCK_BITMAP);
+		xfs_rtgroup_trans_join(tp, args.rtg, XFS_RTGLOCK_BITMAP);
 		*rtlocked = true;
 	}
 
@@ -1394,7 +1369,7 @@ xfs_rtallocate(
 	if (bno_hint)
 		start = xfs_rtb_to_rtx(args.mp, bno_hint);
 	else if (initial_user_data)
-		start = xfs_rtpick_extent(args.mp, tp, maxlen);
+		start = xfs_rtpick_extent(args.rtg, tp, maxlen);
 
 	if (start) {
 		error = xfs_rtallocate_extent_near(&args, start, minlen, maxlen,
@@ -1428,6 +1403,7 @@ xfs_rtallocate(
 	*blen = xfs_rtxlen_to_extlen(args.mp, len);
 
 out_release:
+	xfs_rtgroup_rele(args.rtg);
 	xfs_rtbuf_cache_relse(&args);
 	return error;
 }

