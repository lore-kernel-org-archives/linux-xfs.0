Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D531A3AB9
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838277; cv=none; b=s45Pd+G9zyVOhU6Iql3zRUsq8gDW7wzRnL3fEsqQ/9is2VCM+QZByOtg6toJtNIEIMxjn8Cr3JBb8cww52NB0LV8otzjb4G7aZg7HNkphqw4GAP1z+CfiQqbsqD0MMlAwa6i1nNG7g0nogJcQw9n6b5W+9oxy56l1DNB30SBRyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838277; c=relaxed/simple;
	bh=xEOiA3GlXGGIbYMUXDQ9vw3RahS7fPrF7pQfmD+JO3U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jA/oFuHTk08Pd1vQJWTjE00KEyeXJWUksmCGhNVH5mydy9EW3IrjN4y0FN3c6T7Gz7ZLZL2K7LFamXGqHMvkrii3p1tpBYGw3d05K71mrEJVt1G1K19qCkd+x+yva0jhRGXvnMZWtKUq+DoVArUqcSgZ/9lHEpVSrE+lb6nllpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aoygsbbB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aoygsbbB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED53C4CEC3;
	Fri, 25 Oct 2024 06:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729838277;
	bh=xEOiA3GlXGGIbYMUXDQ9vw3RahS7fPrF7pQfmD+JO3U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aoygsbbBo+duZE0mdecCeePx2Dp4iKog0eWawBiMToPnZ1E9sSABP3z9B7PG945ut
	 A6OssoEnaRnhm+wJCMsHPqQhsZzDWCChI5PRXckWS5EMzLlvCsuZWbSvovR7m9Iply
	 LnwM0TL4HZ3mjFELNAlGr8qfN75J41eGyFQylNiPh+06c/LBBvKZ+ZoM2Da3ijiNtE
	 +InkOks9pz8BEE8IEsUz5DgWsOXDCqrzYKTpSK0E2X3bG/ebRUZZlGdZdLb485yCoz
	 sHG9WU/0eklXLs+8mii7QjJA1rdr91v5Zm8yGSiAeYOoAB/HqbuO0Qsqd8HZMzAO5X
	 ZsbyLyeTlg2Ag==
Date: Thu, 24 Oct 2024 23:37:56 -0700
Subject: [PATCH 5/6] xfs_repair: use libxfs_rtfile_initialize_blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983774514.3041643.10169739076819272552.stgit@frogsfrogsfrogs>
In-Reply-To: <172983774433.3041643.7410184047224484972.stgit@frogsfrogsfrogs>
References: <172983774433.3041643.7410184047224484972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Christoph Hellwig <hch@lst.de>

Use libxfs_rtfile_initialize_blocks to write the re-computed rtbitmap
and rtsummary contents.  This removes duplicate code and prepares for
even more sharing once the rtgroup features adds a metadata header to
the rtbitmap and rtsummary blocks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |  168 ++++++++++---------------------------------------------
 1 file changed, 32 insertions(+), 136 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index c96b50cf6a69dd..310a2b9c07bff0 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -547,157 +547,60 @@ mk_rbmino(xfs_mount_t *mp)
 	libxfs_irele(ip);
 }
 
-static int
-fill_rbmino(xfs_mount_t *mp)
+static void
+fill_rbmino(
+	struct xfs_mount	*mp)
 {
-	struct xfs_buf	*bp;
-	xfs_trans_t	*tp;
-	xfs_inode_t	*ip;
-	union xfs_rtword_raw	*bmp;
-	int		nmap;
-	int		error;
-	xfs_fileoff_t	bno;
-	xfs_bmbt_irec_t	map;
-
-	bmp = btmcompute;
-	bno = 0;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
+	int			error;
 
 	error = -libxfs_trans_alloc_rollable(mp, 10, &tp);
 	if (error)
 		res_failed(error);
 
 	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rbmino, 0, &ip);
-	if (error) {
+	libxfs_trans_cancel(tp);
+	if (error)
 		do_error(
-		_("couldn't iget realtime bitmap inode -- error - %d\n"),
-			error);
-	}
-
-	while (bno < mp->m_sb.sb_rbmblocks)  {
-		struct xfs_rtalloc_args	args = {
-			.mp		= mp,
-			.tp		= tp,
-		};
-		union xfs_rtword_raw	*ondisk;
-
-		/*
-		 * fill the file one block at a time
-		 */
-		nmap = 1;
-		error = -libxfs_bmapi_write(tp, ip, bno, 1, 0, 1, &map, &nmap);
-		if (error || nmap != 1) {
-			do_error(
-	_("couldn't map realtime bitmap block %" PRIu64 ", error = %d\n"),
-				bno, error);
-		}
-
-		ASSERT(map.br_startblock != HOLESTARTBLOCK);
-
-		error = -libxfs_trans_read_buf(
-				mp, tp, mp->m_dev,
-				XFS_FSB_TO_DADDR(mp, map.br_startblock),
-				XFS_FSB_TO_BB(mp, 1), 1, &bp, NULL);
-
-		if (error) {
-			do_warn(
-_("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime bitmap inode %" PRIu64 "\n"),
-				bno, map.br_startblock, mp->m_sb.sb_rbmino);
-			return(1);
-		}
+_("couldn't iget realtime bitmap inode, error %d\n"), error);
 
-		args.rbmbp = bp;
-		ondisk = xfs_rbmblock_wordptr(&args, 0);
-		memcpy(ondisk, bmp, mp->m_blockwsize << XFS_WORDLOG);
-
-		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
-
-		bmp += mp->m_blockwsize;
-		bno++;
-	}
-
-	libxfs_trans_ijoin(tp, ip, 0);
-	error = -libxfs_trans_commit(tp);
+	error = -libxfs_rtfile_initialize_blocks(ip, 0, mp->m_sb.sb_rbmblocks,
+			btmcompute);
 	if (error)
-		do_error(_("%s: commit failed, error %d\n"), __func__, error);
+		do_error(
+_("couldn't re-initialize realtime bitmap inode, error %d\n"), error);
+
 	libxfs_irele(ip);
-	return(0);
 }
 
-static int
-fill_rsumino(xfs_mount_t *mp)
+static void
+fill_rsumino(
+	struct xfs_mount	*mp)
 {
-	struct xfs_buf	*bp;
-	xfs_trans_t	*tp;
-	xfs_inode_t	*ip;
-	union xfs_suminfo_raw *smp;
-	int		nmap;
-	int		error;
-	xfs_fileoff_t	bno;
-	xfs_bmbt_irec_t	map;
-
-	smp = sumcompute;
-	bno = 0;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
+	int			error;
 
 	error = -libxfs_trans_alloc_rollable(mp, 10, &tp);
 	if (error)
 		res_failed(error);
 
 	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rsumino, 0, &ip);
-	if (error) {
+	libxfs_trans_cancel(tp);
+	if (error)
 		do_error(
-		_("couldn't iget realtime summary inode -- error - %d\n"),
-			error);
-	}
-
-	while (bno < mp->m_rsumblocks)  {
-		struct xfs_rtalloc_args	args = {
-			.mp		= mp,
-			.tp		= tp,
-		};
-		union xfs_suminfo_raw	*ondisk;
-
-		/*
-		 * fill the file one block at a time
-		 */
-		nmap = 1;
-		error = -libxfs_bmapi_write(tp, ip, bno, 1, 0, 1, &map, &nmap);
-		if (error || nmap != 1) {
-			do_error(
-	_("couldn't map realtime summary inode block %" PRIu64 ", error = %d\n"),
-				bno, error);
-		}
-
-		ASSERT(map.br_startblock != HOLESTARTBLOCK);
-
-		error = -libxfs_trans_read_buf(
-				mp, tp, mp->m_dev,
-				XFS_FSB_TO_DADDR(mp, map.br_startblock),
-				XFS_FSB_TO_BB(mp, 1), 1, &bp, NULL);
-
-		if (error) {
-			do_warn(
-_("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode %" PRIu64 "\n"),
-				bno, map.br_startblock, mp->m_sb.sb_rsumino);
-			libxfs_irele(ip);
-			return(1);
-		}
+_("couldn't iget realtime summary inode, error %d\n"), error);
 
-		args.sumbp = bp;
-		ondisk = xfs_rsumblock_infoptr(&args, 0);
-		memcpy(ondisk, smp, mp->m_blockwsize << XFS_WORDLOG);
-
-		libxfs_trans_log_buf(tp, bp, 0, mp->m_sb.sb_blocksize - 1);
-
-		smp += mp->m_blockwsize;
-		bno++;
-	}
-
-	libxfs_trans_ijoin(tp, ip, 0);
-	error = -libxfs_trans_commit(tp);
+	mp->m_rsumip = ip;
+	error = -libxfs_rtfile_initialize_blocks(ip, 0, mp->m_rsumblocks,
+			sumcompute);
+	mp->m_rsumip = NULL;
 	if (error)
-		do_error(_("%s: commit failed, error %d\n"), __func__, error);
+		do_error(
+_("couldn't re-initialize realtime summary inode, error %d\n"), error);
+
 	libxfs_irele(ip);
-	return(0);
 }
 
 static void
@@ -3302,15 +3205,8 @@ phase6(xfs_mount_t *mp)
 	if (!no_modify)  {
 		do_log(
 _("        - resetting contents of realtime bitmap and summary inodes\n"));
-		if (fill_rbmino(mp))  {
-			do_warn(
-			_("Warning:  realtime bitmap may be inconsistent\n"));
-		}
-
-		if (fill_rsumino(mp))  {
-			do_warn(
-			_("Warning:  realtime bitmap may be inconsistent\n"));
-		}
+		fill_rbmino(mp);
+		fill_rsumino(mp);
 	}
 
 	mark_standalone_inodes(mp);

