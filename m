Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8112B1E2313
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730416419; cv=none; b=ktU2AP+a9PWMWnn3BUSOWD1DdHKCG7qXcMRwHJ67WPdaVUi6GSShci3lJOj+QAD1k3H9B6Va+t5YOaDx56PRE8mKoml9BQ2VaxIrIwEdo46W84HcarIsTwt0FMU9pf8nOc7I8cnuFghwAD61t0m0iKYplcXz6uNJUMWMh3qOBVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730416419; c=relaxed/simple;
	bh=OMxzYsbIJD+uw4JocWoS2/benWEaVdp+QZf8tOsxbuk=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i8w/sYD15+5UxQYHbtEyaYB6FulGGso4PrHd0C0gsgfSN4a+GDqZpW87LPKAQpIc0sHr2l1X2sKxT72F9jI6H6DxwUDbtn4uf/4AXKlEdJeE/LKWwOJxc/In8e4H53Zr2zH9qsKAncQWmwubZuIFldIdOsiJIZqa3Kt9OF3m4Nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ub1SvTCg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ub1SvTCg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565F1C4CED3;
	Thu, 31 Oct 2024 23:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730416419;
	bh=OMxzYsbIJD+uw4JocWoS2/benWEaVdp+QZf8tOsxbuk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ub1SvTCgSJb7XTqCb84IOzJa6G+jTO7SmN4Shre3Kup7c7zIminplt1wIbyKsF71I
	 O++hAUo2wBZz60MdhNDQWHj0OdCBUHaId/KXJVIjpJbekTK0nzZQ/NM24XwqgFnOo1
	 +SkZMQ1C+vRazNk3kLw43jH1z3q6rek0MB3daerKnFpfrDYC50GwnOKRk0KJ3gIr+G
	 trkIJwouud2t63r9pdnZMJOSiMOi6136Z+L2DOcoLMsg0UKkc1nm2Ln7wuVYXX9oMQ
	 b1f1k1LBKgAcxKYpuhpaWHYU7GEv08Y3vTgkS82oLZIXFHXNZzVSTkD7QoLtQ2cYjR
	 FDhID26xTmukw==
Date: Thu, 31 Oct 2024 16:13:38 -0700
Subject: [PATCH 19/41] xfs: replace m_rsumsize with m_rsumblocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041566208.962545.13909277438256627573.stgit@frogsfrogsfrogs>
In-Reply-To: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
References: <173041565874.962545.15559186670255081566.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Source kernel commit: 33912286cb1956920712aba8cb6f38e434824357

Track the RT summary file size in blocks, just like the RT bitmap
file.  While we have users of both units, blocks are used slightly
more often and this matches the bitmap file for consistency.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c              |    2 +-
 include/xfs_mount.h     |    2 +-
 libxfs/init.c           |    4 +---
 libxfs/xfs_rtbitmap.c   |    2 +-
 libxfs/xfs_trans_resv.c |    2 +-
 mkfs/proto.c            |   12 +++++-------
 repair/dinode.c         |    7 ++++---
 repair/phase6.c         |   16 ++++++----------
 repair/rt.c             |    4 ++--
 9 files changed, 22 insertions(+), 29 deletions(-)


diff --git a/db/check.c b/db/check.c
index 00ef3c1d4b508c..0e91fded0c4236 100644
--- a/db/check.c
+++ b/db/check.c
@@ -1958,7 +1958,7 @@ init(
 
 		dbmap[c] = xcalloc(mp->m_sb.sb_rblocks, sizeof(**dbmap));
 		inomap[c] = xcalloc(mp->m_sb.sb_rblocks, sizeof(**inomap));
-		words = mp->m_rsumsize >> XFS_WORDLOG;
+		words = XFS_FSB_TO_B(mp, mp->m_rsumblocks) >> XFS_WORDLOG;
 		sumfile = xcalloc(words, sizeof(union xfs_suminfo_raw));
 		sumcompute = xcalloc(words, sizeof(union xfs_suminfo_raw));
 	}
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index a60474a8db3f22..7571df12fba3f8 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -50,7 +50,7 @@ typedef struct xfs_mount {
 	xfs_agnumber_t		m_maxagi;	/* highest inode alloc group */
         struct xfs_ino_geometry	m_ino_geo;	/* inode geometry */
 	uint			m_rsumlevels;	/* rt summary levels */
-	uint			m_rsumsize;	/* size of rt summary, bytes */
+	xfs_filblks_t		m_rsumblocks;	/* size of rt summary, FSBs */
 	/*
 	 * Optional cache of rt summary level per bitmap block with the
 	 * invariant that m_rsum_cache[bbno] <= the minimum i for which
diff --git a/libxfs/init.c b/libxfs/init.c
index 90a539e04161bb..6ab5ef54bb69cb 100644
--- a/libxfs/init.c
+++ b/libxfs/init.c
@@ -293,7 +293,6 @@ rtmount_init(
 {
 	struct xfs_buf	*bp;	/* buffer for last block of subvolume */
 	xfs_daddr_t	d;	/* address of last block of subvolume */
-	unsigned int	rsumblocks;
 	int		error;
 
 	if (mp->m_sb.sb_rblocks == 0)
@@ -319,9 +318,8 @@ rtmount_init(
 		return -1;
 	}
 	mp->m_rsumlevels = mp->m_sb.sb_rextslog + 1;
-	rsumblocks = xfs_rtsummary_blockcount(mp, mp->m_rsumlevels,
+	mp->m_rsumblocks = xfs_rtsummary_blockcount(mp, mp->m_rsumlevels,
 			mp->m_sb.sb_rbmblocks);
-	mp->m_rsumsize = XFS_FSB_TO_B(mp, rsumblocks);
 	mp->m_rbmip = mp->m_rsumip = NULL;
 
 	/*
diff --git a/libxfs/xfs_rtbitmap.c b/libxfs/xfs_rtbitmap.c
index 1c657da907132e..cff3030d1662b7 100644
--- a/libxfs/xfs_rtbitmap.c
+++ b/libxfs/xfs_rtbitmap.c
@@ -160,7 +160,7 @@ xfs_rtsummary_read_buf(
 {
 	struct xfs_mount		*mp = args->mp;
 
-	if (XFS_IS_CORRUPT(mp, block >= XFS_B_TO_FSB(mp, mp->m_rsumsize))) {
+	if (XFS_IS_CORRUPT(mp, block >= mp->m_rsumblocks)) {
 		xfs_rt_mark_sick(args->mp, XFS_SICK_RT_SUMMARY);
 		return -EFSCORRUPTED;
 	}
diff --git a/libxfs/xfs_trans_resv.c b/libxfs/xfs_trans_resv.c
index 6b87bf4d554c6a..156f9578d281a0 100644
--- a/libxfs/xfs_trans_resv.c
+++ b/libxfs/xfs_trans_resv.c
@@ -915,7 +915,7 @@ xfs_calc_growrtfree_reservation(
 	return xfs_calc_buf_res(1, mp->m_sb.sb_sectsize) +
 		xfs_calc_inode_res(mp, 2) +
 		xfs_calc_buf_res(1, mp->m_sb.sb_blocksize) +
-		xfs_calc_buf_res(1, mp->m_rsumsize);
+		xfs_calc_buf_res(1, XFS_FSB_TO_B(mp, mp->m_rsumblocks));
 }
 
 /*
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 42ac3e10929b52..06010980c5b313 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -813,7 +813,7 @@ rtsummary_create(
 {
 	struct xfs_mount	*mp = ip->i_mount;
 
-	ip->i_disk_size = mp->m_rsumsize;
+	ip->i_disk_size = mp->m_rsumblocks * mp->m_sb.sb_blocksize;
 
 	mp->m_sb.sb_rsumino = ip->i_ino;
 	mp->m_rsumip = ip;
@@ -874,25 +874,23 @@ rtsummary_init(
 	struct xfs_trans	*tp;
 	struct xfs_bmbt_irec	*ep;
 	xfs_fileoff_t		bno;
-	xfs_extlen_t		nsumblocks;
 	uint			blocks;
 	int			i;
 	int			nmap;
 	int			error;
 
-	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
-	blocks = nsumblocks + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
+	blocks = mp->m_rsumblocks + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
 	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
 	if (error)
 		res_failed(error);
 	libxfs_trans_ijoin(tp, mp->m_rsumip, 0);
 
 	bno = 0;
-	while (bno < nsumblocks) {
+	while (bno < mp->m_rsumblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
 		error = -libxfs_bmapi_write(tp, mp->m_rsumip, bno,
-				(xfs_extlen_t)(nsumblocks - bno),
-				0, nsumblocks, map, &nmap);
+				(xfs_extlen_t)(mp->m_rsumblocks - bno),
+				0, mp->m_rsumblocks, map, &nmap);
 		if (error)
 			fail(_("Allocation of the realtime summary failed"),
 				error);
diff --git a/repair/dinode.c b/repair/dinode.c
index e36de9bf1a1be0..aae3cb7a40b981 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -1736,10 +1736,11 @@ _("realtime bitmap inode %" PRIu64 " has bad size %" PRId64 " (should be %" PRIu
 		break;
 
 	case XR_INO_RTSUM:
-		if (size != mp->m_rsumsize)  {
+		if (size != XFS_FSB_TO_B(mp, mp->m_rsumblocks))  {
 			do_warn(
-_("realtime summary inode %" PRIu64 " has bad size %" PRId64 " (should be %d)\n"),
-				lino, size, mp->m_rsumsize);
+_("realtime summary inode %" PRIu64 " has bad size %" PRIu64 " (should be %" PRIu64 ")\n"),
+				lino, size,
+				XFS_FSB_TO_B(mp, mp->m_rsumblocks));
 			return 1;
 		}
 		break;
diff --git a/repair/phase6.c b/repair/phase6.c
index b48f18b06a5c81..c96b50cf6a69dd 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -633,12 +633,10 @@ fill_rsumino(xfs_mount_t *mp)
 	int		nmap;
 	int		error;
 	xfs_fileoff_t	bno;
-	xfs_fileoff_t	end_bno;
 	xfs_bmbt_irec_t	map;
 
 	smp = sumcompute;
 	bno = 0;
-	end_bno = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
 
 	error = -libxfs_trans_alloc_rollable(mp, 10, &tp);
 	if (error)
@@ -651,7 +649,7 @@ fill_rsumino(xfs_mount_t *mp)
 			error);
 	}
 
-	while (bno < end_bno)  {
+	while (bno < mp->m_rsumblocks)  {
 		struct xfs_rtalloc_args	args = {
 			.mp		= mp,
 			.tp		= tp,
@@ -711,7 +709,6 @@ mk_rsumino(xfs_mount_t *mp)
 	int		i;
 	int		nmap;
 	int		error;
-	int		nsumblocks;
 	xfs_fileoff_t	bno;
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
 	uint		blocks;
@@ -732,7 +729,7 @@ mk_rsumino(xfs_mount_t *mp)
 
 	/* Reset the rt summary inode. */
 	reset_sbroot_ino(tp, S_IFREG, ip);
-	ip->i_disk_size = mp->m_rsumsize;
+	ip->i_disk_size = mp->m_rsumblocks * mp->m_sb.sb_blocksize;
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = -libxfs_trans_commit(tp);
 	if (error)
@@ -742,19 +739,18 @@ mk_rsumino(xfs_mount_t *mp)
 	 * then allocate blocks for file and fill with zeroes (stolen
 	 * from mkfs)
 	 */
-	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
-	blocks = nsumblocks + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
+	blocks = mp->m_rsumblocks + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
 	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
 	if (error)
 		res_failed(error);
 
 	libxfs_trans_ijoin(tp, ip, 0);
 	bno = 0;
-	while (bno < nsumblocks) {
+	while (bno < mp->m_rsumblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
 		error = -libxfs_bmapi_write(tp, ip, bno,
-			  (xfs_extlen_t)(nsumblocks - bno),
-			  0, nsumblocks, map, &nmap);
+			  (xfs_extlen_t)(mp->m_rsumblocks - bno),
+			  0, mp->m_rsumblocks, map, &nmap);
 		if (error) {
 			do_error(
 		_("couldn't allocate realtime summary inode, error = %d\n"),
diff --git a/repair/rt.c b/repair/rt.c
index 879946ab0b154e..721c363cc1dd10 100644
--- a/repair/rt.c
+++ b/repair/rt.c
@@ -33,7 +33,7 @@ rtinit(xfs_mount_t *mp)
 		do_error(
 	_("couldn't allocate memory for incore realtime bitmap.\n"));
 
-	wordcnt = mp->m_rsumsize >> XFS_WORDLOG;
+	wordcnt = XFS_FSB_TO_B(mp, mp->m_rsumblocks) >> XFS_WORDLOG;
 	sumcompute = calloc(wordcnt, sizeof(union xfs_suminfo_raw));
 	if (!sumcompute)
 		do_error(
@@ -228,5 +228,5 @@ check_rtsummary(
 		return;
 
 	check_rtfile_contents(mp, "rtsummary", mp->m_sb.sb_rsumino, sumcompute,
-			XFS_B_TO_FSB(mp, mp->m_rsumsize));
+			mp->m_rsumblocks);
 }

