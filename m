Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9293F7EF
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kFWBHu98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64061C433C8;
	Mon,  1 Jan 2024 00:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068597;
	bh=aoQ82ULdT4tH+WuWx2CcYsk7sJNhhnduY/JmaN4XE0w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=kFWBHu98APG+aIvxHc9B1Pb1YEIbIGhgfcVPYzgvoldtXxOzd6KkRSZpIgzcKXo6S
	 kxcWLoSa38u6aQI63sk66IEh9B9cUTvpAwDRGohFuN+QU0GFngOs63MkE/NtafI3ff
	 PZfpNohbiykmcbknMddp/cMma5QIl1v0NjA2j/zpSQDfek/yrqVHunAIr+oTj+u0bN
	 OuNIx4OClxkAPzbqjYv8dSsfspVvY+utTAY4eP+CCdjox0bWq80N8Eq9IeZKpcengz
	 lNU/ev1QcxXAUaMA+aPv4HAaCYwxJfhXfzYbuidrvqoP77+FW79G+sQJzG31DicMU9
	 MAIZlAQ1pEtSQ==
Date: Sun, 31 Dec 2023 16:23:16 +9900
Subject: [PATCH 2/4] mkfs: use libxfs_alloc_file_space for rtinit
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405016264.1816687.12131453143281118087.stgit@frogsfrogsfrogs>
In-Reply-To: <170405016236.1816687.16728890385158475127.stgit@frogsfrogsfrogs>
References: <170405016236.1816687.16728890385158475127.stgit@frogsfrogsfrogs>
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

Since xfs_bmapi_write can now zero newly allocated blocks, use it to
initialize the realtime inodes instead of open coding this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c |   80 +++++++++-------------------------------------------------
 1 file changed, 12 insertions(+), 68 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 5b632d31215..83888572395 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -949,43 +949,14 @@ static void
 rtbitmap_init(
 	struct xfs_mount	*mp)
 {
-	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
-	struct xfs_trans	*tp;
-	struct xfs_bmbt_irec	*ep;
-	xfs_fileoff_t		bno;
-	uint			blocks;
-	int			i;
-	int			nmap;
 	int			error;
 
-	blocks = mp->m_sb.sb_rbmblocks +
-			XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
-	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
+	error = -libxfs_alloc_file_space(mp->m_rbmip, 0,
+			mp->m_sb.sb_rbmblocks << mp->m_sb.sb_blocklog,
+			XFS_BMAPI_ZERO);
 	if (error)
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
+		fail(
+	_("Block allocation of the realtime bitmap inode failed"),
 				error);
 
 	if (xfs_has_rtgroups(mp)) {
@@ -1001,43 +972,13 @@ static void
 rtsummary_init(
 	struct xfs_mount	*mp)
 {
-	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
-	struct xfs_trans	*tp;
-	struct xfs_bmbt_irec	*ep;
-	xfs_fileoff_t		bno;
-	xfs_extlen_t		nsumblocks;
-	uint			blocks;
-	int			i;
-	int			nmap;
 	int			error;
 
-	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
-	blocks = nsumblocks + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
-	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
+	error = -libxfs_alloc_file_space(mp->m_rsumip, 0, mp->m_rsumsize,
+			XFS_BMAPI_ZERO);
 	if (error)
-		res_failed(error);
-	libxfs_trans_ijoin(tp, mp->m_rsumip, 0);
-
-	bno = 0;
-	while (bno < nsumblocks) {
-		nmap = XFS_BMAP_MAX_NMAP;
-		error = -libxfs_bmapi_write(tp, mp->m_rsumip, bno,
-				(xfs_extlen_t)(nsumblocks - bno),
-				0, nsumblocks, map, &nmap);
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
+		fail(
+	_("Block allocation of the realtime summary inode failed"),
 				error);
 
 	if (xfs_has_rtgroups(mp)) {
@@ -1143,6 +1084,9 @@ rtinit(
 			rtrmapbt_create(rtg);
 	}
 
+	if (mp->m_sb.sb_rbmblocks == 0)
+		return;
+
 	rtbitmap_init(mp);
 	rtsummary_init(mp);
 	if (xfs_has_rtgroups(mp))

