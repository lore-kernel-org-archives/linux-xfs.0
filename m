Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4701A4F2F
	for <linux-xfs@vger.kernel.org>; Fri, 25 Oct 2024 06:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729838262; cv=none; b=QGvqEjJagIDOCAbZZWeoprIZBRTiZnLjsz1vmn/EFv65MMFeqY1nAcev5aNjPcxRX+VlgvOB+k4YIaBz16cxFcg0YoxvkxIFA6Oqy12vCSlGa5U0nFca2bxk8ByWRg0Jx+w8oAdbNsARr00KUHchXH+2ol4/LSuwp9+Vzp6t3Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729838262; c=relaxed/simple;
	bh=HrJ28cuS1uvF/SMNvwsDMxgAV5KLnCXbMMF7GvmCmKw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V+7a8CxkUBmq+fN3ZNgN+xZUlxodNRIYPJ/tA2eFllZIHiIHuTtXkPsu+HIN7mDffMiubNgDVS7/NWV02CqAW1oI4QE/XC4qYbnA4/0JzYvCvK6ghdH5SFDXUkl7U8BJv8DYw8FzixECeY9cMwHnT0fH89Gf+1ig5xVYzq9P8T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=czTovTc/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="czTovTc/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64608C4CEC3;
	Fri, 25 Oct 2024 06:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729838261;
	bh=HrJ28cuS1uvF/SMNvwsDMxgAV5KLnCXbMMF7GvmCmKw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=czTovTc/HCNq2tiu3GtBTXr3epkpLYxtjubkMA4xUtD0AJRI09ur0KsWitbH7rPM+
	 TODeL0R2RwiG+C0aFJtH4i6Qcnz5hL9tvJqsFzfO/fVNAyXCOFh5078ir5DbQev8PT
	 ThVBQfUX9WO3M7enFsGYTOH8IG1hf54mRYUDdB+SyVR70IJFqlD9Xcu3bYvbqp6fzO
	 KmQSy7luxClEV/Vv8QOBb7cy5XEPEmk5Nv1ewIXCUINfr6mNFMMzecpOLlMF0DPbKa
	 RfZw/vqVF5cD9EVq7Ro3cP3y+Ck5uC/aWb6UiVSZ1adj+0PxL9ehOLJ08iGUoDpVSh
	 BecINNwWNU2WA==
Date: Thu, 24 Oct 2024 23:37:40 -0700
Subject: [PATCH 4/6] mkfs: use xfs_rtfile_initialize_blocks
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <172983774500.3041643.17973290321317681320.stgit@frogsfrogsfrogs>
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

Use the new libxfs helper for initializing the rtbitmap/summary files
for rtgroup-enabled file systems.  Also skip the zeroing of the blocks
for rtgroup file systems as we'll overwrite every block instantly.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 
 mkfs/proto.c             |  106 +++++++---------------------------------------
 2 files changed, 17 insertions(+), 90 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 7c08d766623c0c..c5682504e41a66 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -263,6 +263,7 @@
 #define xfs_suminfo_add			libxfs_suminfo_add
 #define xfs_suminfo_get			libxfs_suminfo_get
 #define xfs_rtsummary_wordcount		libxfs_rtsummary_wordcount
+#define xfs_rtfile_initialize_blocks	libxfs_rtfile_initialize_blocks
 
 #define xfs_rtfree_extent		libxfs_rtfree_extent
 #define xfs_rtfree_blocks		libxfs_rtfree_blocks
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 9d21f027c0b174..d8eb6ca33672bd 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -819,94 +819,6 @@ rtsummary_create(
 	ihold(VFS_I(ip));
 }
 
-/* Zero the realtime bitmap. */
-static void
-rtbitmap_init(
-	struct xfs_mount	*mp)
-{
-	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
-	struct xfs_trans	*tp;
-	struct xfs_bmbt_irec	*ep;
-	xfs_fileoff_t		bno;
-	uint			blocks;
-	int			i;
-	int			nmap;
-	int			error;
-
-	blocks = mp->m_sb.sb_rbmblocks +
-			XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
-	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
-	if (error)
-		res_failed(error);
-
-	libxfs_trans_ijoin(tp, mp->m_rbmip, 0);
-	bno = 0;
-	while (bno < mp->m_sb.sb_rbmblocks) {
-		nmap = XFS_BMAP_MAX_NMAP;
-		error = -libxfs_bmapi_write(tp, mp->m_rbmip, bno,
-				(xfs_extlen_t)(mp->m_sb.sb_rbmblocks - bno),
-				0, mp->m_sb.sb_rbmblocks, map, &nmap);
-		if (error)
-			fail(_("Allocation of the realtime bitmap failed"),
-				error);
-
-		for (i = 0, ep = map; i < nmap; i++, ep++) {
-			libxfs_device_zero(mp->m_ddev_targp,
-				XFS_FSB_TO_DADDR(mp, ep->br_startblock),
-				XFS_FSB_TO_BB(mp, ep->br_blockcount));
-			bno += ep->br_blockcount;
-		}
-	}
-
-	error = -libxfs_trans_commit(tp);
-	if (error)
-		fail(_("Block allocation of the realtime bitmap inode failed"),
-				error);
-}
-
-/* Zero the realtime summary file. */
-static void
-rtsummary_init(
-	struct xfs_mount	*mp)
-{
-	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
-	struct xfs_trans	*tp;
-	struct xfs_bmbt_irec	*ep;
-	xfs_fileoff_t		bno;
-	uint			blocks;
-	int			i;
-	int			nmap;
-	int			error;
-
-	blocks = mp->m_rsumblocks + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
-	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
-	if (error)
-		res_failed(error);
-	libxfs_trans_ijoin(tp, mp->m_rsumip, 0);
-
-	bno = 0;
-	while (bno < mp->m_rsumblocks) {
-		nmap = XFS_BMAP_MAX_NMAP;
-		error = -libxfs_bmapi_write(tp, mp->m_rsumip, bno,
-				(xfs_extlen_t)(mp->m_rsumblocks - bno),
-				0, mp->m_rsumblocks, map, &nmap);
-		if (error)
-			fail(_("Allocation of the realtime summary failed"),
-				error);
-
-		for (i = 0, ep = map; i < nmap; i++, ep++) {
-			libxfs_device_zero(mp->m_ddev_targp,
-				XFS_FSB_TO_DADDR(mp, ep->br_startblock),
-				XFS_FSB_TO_BB(mp, ep->br_blockcount));
-			bno += ep->br_blockcount;
-		}
-	}
-	error = -libxfs_trans_commit(tp);
-	if (error)
-		fail(_("Block allocation of the realtime summary inode failed"),
-				error);
-}
-
 /*
  * Free the whole realtime area using transactions.
  * Do one transaction per bitmap block.
@@ -920,6 +832,22 @@ rtfreesp_init(
 	xfs_rtxnum_t		ertx;
 	int			error;
 
+	/*
+	 * First zero the realtime bitmap and summary files.
+	 */
+	error = -libxfs_rtfile_initialize_blocks(mp->m_rbmip, 0,
+			mp->m_sb.sb_rbmblocks, NULL);
+	if (error)
+		fail(_("Initialization of rtbitmap inode failed"), error);
+
+	error = -libxfs_rtfile_initialize_blocks(mp->m_rsumip, 0,
+			mp->m_rsumblocks, NULL);
+	if (error)
+		fail(_("Initialization of rtsummary inode failed"), error);
+
+	/*
+	 * Then free the blocks into the allocator, one bitmap block at a time.
+	 */
 	for (rtx = 0; rtx < mp->m_sb.sb_rextents; rtx = ertx) {
 		error = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate,
 				0, 0, 0, &tp);
@@ -953,8 +881,6 @@ rtinit(
 	create_sb_metadata_file(mp, rtbitmap_create);
 	create_sb_metadata_file(mp, rtsummary_create);
 
-	rtbitmap_init(mp);
-	rtsummary_init(mp);
 	rtfreesp_init(mp);
 }
 

