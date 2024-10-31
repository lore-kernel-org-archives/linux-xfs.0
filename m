Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597441BD9DC
	for <linux-xfs@vger.kernel.org>; Thu, 31 Oct 2024 23:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730417107; cv=none; b=V0YfYFoI7PL++kvOUdnAqWYWbOLKUGYPxVWZ+20nGzO6C6nGx+6QtY3BVlOrtv1ZhwqvbgPCikCUNnNwy1HlTiH6SOuZmfB32iTfFY64G+eWVPZUFFU6w83r/dZzo4n5WkdsSwklRV0rTWdnfHfOmejh7KIn4mr3Y2vCHWtxdko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730417107; c=relaxed/simple;
	bh=rMS04JzWbTA10NoNgT1uDwTz6/mlMY+uwx8e75a0h5c=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z7kMb0tkxHAka05z55cFGGMOSvzCMmi+AxXgufV8Qi4K2+z3ShtGtNrjkDbMjiZQXuo2ZwBzzWtWi+UG/gIa7a3PaXop9uXqrSuH+hmjyKi/BL2ADyZMJS0vX9MSgBlTnx22BzNuIFNfpkbK9j60i3rSwMqUTJthBKa6v6vdJrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZbIvu+yD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZbIvu+yD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5A10C4CEC3;
	Thu, 31 Oct 2024 23:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730417106;
	bh=rMS04JzWbTA10NoNgT1uDwTz6/mlMY+uwx8e75a0h5c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ZbIvu+yDazZN/Xjm0/qO4YidZBc14r/RHERV13G5+9bI6pRF11f/xCOomfCGDqaCu
	 teuMS2rA8BaAaIwYVSuTlm/xbrCsLk/BMnOaIA/UmB5EBywuenoSpw1ncxb/ukNSBN
	 ZfkZ0Pu41chfXTlm0FS5ZFgdQhIpuZp3flcX0edxpj/KKF5YRZm+YAA3xl+gSf96IH
	 0jC6xaC0y+RyGKt5qpmgOIMC+YtaVpszf+YAei0715cCdsYDlqSX80rqY7Fey9i8Jz
	 cXDPuROT81bkPKJwzEeMzsJp9QiuH2V4ccKnNuwMPRDhMwbuuBTYpzPg0q9SXKNdy7
	 fOKMDkSNkl+zQ==
Date: Thu, 31 Oct 2024 16:25:06 -0700
Subject: [PATCH 6/6] xfs_repair: stop preallocating blocks in mk_rbmino and
 mk_rsumino
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173041568193.964620.8976369035012357193.stgit@frogsfrogsfrogs>
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

Now that repair is using libxfs_rtfile_initialize_blocks to write to the
rtbitmap and rtsummary inodes, space allocation is already taken care of
that helper and there is no need to preallocate it.  Remove the code to
do so.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |  116 +++++++------------------------------------------------
 1 file changed, 14 insertions(+), 102 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 310a2b9c07bff0..630617ef8ab8fe 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -475,24 +475,16 @@ reset_sbroot_ino(
 }
 
 static void
-mk_rbmino(xfs_mount_t *mp)
+mk_rbmino(
+	struct xfs_mount	*mp)
 {
-	xfs_trans_t	*tp;
-	xfs_inode_t	*ip;
-	xfs_bmbt_irec_t	*ep;
-	int		i;
-	int		nmap;
-	int		error;
-	xfs_fileoff_t	bno;
-	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
-	uint		blocks;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
+	int			error;
 
-	/*
-	 * first set up inode
-	 */
-	i = -libxfs_trans_alloc_rollable(mp, 10, &tp);
-	if (i)
-		res_failed(i);
+	error = -libxfs_trans_alloc_rollable(mp, 10, &tp);
+	if (error)
+		res_failed(error);
 
 	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rbmino, 0, &ip);
 	if (error) {
@@ -508,42 +500,6 @@ mk_rbmino(xfs_mount_t *mp)
 	error = -libxfs_trans_commit(tp);
 	if (error)
 		do_error(_("%s: commit failed, error %d\n"), __func__, error);
-
-	/*
-	 * then allocate blocks for file and fill with zeroes (stolen
-	 * from mkfs)
-	 */
-	blocks = mp->m_sb.sb_rbmblocks +
-			XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
-	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
-	if (error)
-		res_failed(error);
-
-	libxfs_trans_ijoin(tp, ip, 0);
-	bno = 0;
-	while (bno < mp->m_sb.sb_rbmblocks) {
-		nmap = XFS_BMAP_MAX_NMAP;
-		error = -libxfs_bmapi_write(tp, ip, bno,
-			  (xfs_extlen_t)(mp->m_sb.sb_rbmblocks - bno),
-			  0, mp->m_sb.sb_rbmblocks, map, &nmap);
-		if (error) {
-			do_error(
-			_("couldn't allocate realtime bitmap, error = %d\n"),
-				error);
-		}
-		for (i = 0, ep = map; i < nmap; i++, ep++) {
-			libxfs_device_zero(mp->m_ddev_targp,
-				XFS_FSB_TO_DADDR(mp, ep->br_startblock),
-				XFS_FSB_TO_BB(mp, ep->br_blockcount));
-			bno += ep->br_blockcount;
-		}
-	}
-	error = -libxfs_trans_commit(tp);
-	if (error) {
-		do_error(
-		_("allocation of the realtime bitmap failed, error = %d\n"),
-			error);
-	}
 	libxfs_irele(ip);
 }
 
@@ -606,22 +562,13 @@ _("couldn't re-initialize realtime summary inode, error %d\n"), error);
 static void
 mk_rsumino(xfs_mount_t *mp)
 {
-	xfs_trans_t	*tp;
-	xfs_inode_t	*ip;
-	xfs_bmbt_irec_t	*ep;
-	int		i;
-	int		nmap;
-	int		error;
-	xfs_fileoff_t	bno;
-	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
-	uint		blocks;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
+	int			error;
 
-	/*
-	 * first set up inode
-	 */
-	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 10, 0, 0, &tp);
-	if (i)
-		res_failed(i);
+	error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 10, 0, 0, &tp);
+	if (error)
+		res_failed(error);
 
 	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rsumino, 0, &ip);
 	if (error) {
@@ -637,41 +584,6 @@ mk_rsumino(xfs_mount_t *mp)
 	error = -libxfs_trans_commit(tp);
 	if (error)
 		do_error(_("%s: commit failed, error %d\n"), __func__, error);
-
-	/*
-	 * then allocate blocks for file and fill with zeroes (stolen
-	 * from mkfs)
-	 */
-	blocks = mp->m_rsumblocks + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
-	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
-	if (error)
-		res_failed(error);
-
-	libxfs_trans_ijoin(tp, ip, 0);
-	bno = 0;
-	while (bno < mp->m_rsumblocks) {
-		nmap = XFS_BMAP_MAX_NMAP;
-		error = -libxfs_bmapi_write(tp, ip, bno,
-			  (xfs_extlen_t)(mp->m_rsumblocks - bno),
-			  0, mp->m_rsumblocks, map, &nmap);
-		if (error) {
-			do_error(
-		_("couldn't allocate realtime summary inode, error = %d\n"),
-				error);
-		}
-		for (i = 0, ep = map; i < nmap; i++, ep++) {
-			libxfs_device_zero(mp->m_ddev_targp,
-				      XFS_FSB_TO_DADDR(mp, ep->br_startblock),
-				      XFS_FSB_TO_BB(mp, ep->br_blockcount));
-			bno += ep->br_blockcount;
-		}
-	}
-	error = -libxfs_trans_commit(tp);
-	if (error) {
-		do_error(
-	_("allocation of the realtime summary ino failed, error = %d\n"),
-			error);
-	}
 	libxfs_irele(ip);
 }
 

