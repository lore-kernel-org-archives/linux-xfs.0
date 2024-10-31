Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EF31BD9DC
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730417091; cv=none; b=B9WUYzK5X78mZqTKghQNVvUTUSm4ku0CtLO4/VvC+UzyTvzhAdY6kxQAzjvzltDRRKn1CDax1kAo0phenydeYRK/+wgFiefULtdNfyaLau3kp6TpTp/OokD1rhV6T58NHPjm3am/8araWI+e20VSlkHvL3TJUdU7bp9dyBbNFbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730417091; c=relaxed/simple;
	bh=xEOiA3GlXGGIbYMUXDQ9vw3RahS7fPrF7pQfmD+JO3U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=myH8vG14EfBGPhw1Lc8NDt9m8pwXeJ1yLE8WdHaZlJ3SmHzhiqGPVxftKgihxNAX+llcNSGjqEafC64eBcaMsPTcXbqNLcwT5UOkOGmMPqDZVVZ9T/0U6Y2I3WXSz7ehotZUhGH6MuoOC3x/dS/dC1EfZArF4HuiQp3El16xipM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PBGSREgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PBGSREgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A91C4CEC3;
	Thu, 31 Oct 2024 23:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730417091;
	bh=xEOiA3GlXGGIbYMUXDQ9vw3RahS7fPrF7pQfmD+JO3U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=PBGSREgzKtEXqki8ga9QTSPZXcsCSswJSpWpGhJa07O8495dlq4O5KsVOHJL6Ghu2
	 GzxxS1vh7nTLFsqloBCGnRn3Vz4yewh9ebHUsdYgz9FAVy7eyZwBCg3XmXtSOpf6Q5
	 b5Zc3hBg5irAmwnZmTYoeMtpHeYOX8+1NTkbv8QwhxRr6oH9pV3EVZk2cskedisago
	 lTDt9ZUE3dNWwfO/KaNFvRwambr58F8ONcKHpWmjpEu0MZ+TJp5g6JeARjH8M91MdU
	 Bt8DKmgTD3gqS8cZsjC3725wI0S43AfWP5dIonTjoIKk229v9aMiC3YILNSeLydj5q
	 kdvZ6Maxnj48g==
Date: Thu, 31 Oct 2024 16:24:50 -0700
Subject: [PATCH 5/6] xfs_repair: use libxfs_rtfile_initialize_blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041568178.964620.7403844353440979838.stgit@frogsfrogsfrogs>
In-Reply-To: <173041568097.964620.17809679042644398581.stgit@frogsfrogsfrogs>
References: <173041568097.964620.17809679042644398581.stgit@frogsfrogsfrogs>
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

