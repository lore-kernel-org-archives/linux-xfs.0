Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621A8C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:30:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lOb/j/PO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326EBC433C8;
	Sun, 31 Dec 2023 23:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065438;
	bh=NGL2hBQkPChT3WaL7u1RO1TFMYXATSWgKT41d01mT2w=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lOb/j/POnLc/rlb4JWCabsFwMKCq7Xt5fDh6XBlmhYtZnBgOu72Yv8V1SHUQzLOE/
	 ia2jqgnP6PG2T9vddbiMu3GwG1FvSTv/lRyaBdd0h9QJ/WzAJ6SMCfSk9VwlGrXVp5
	 uz0O6bVmXMyrg0bNBcTYsjts43Hne4nbFgEBqgOlhduIINAigHtM1uTE2EN3T5Jt0J
	 364/SP74T3b5LeUalDd6Ktfx/it0qW3vDJ1kig5oiyGt0T2uE8Og/EtnKxptxNlDO6
	 2kzuIxkKQpvi86iyc4p89JEeAedVoOsQG2Nu4MaxKJYvFPyYQRC0WD4Yqfk26bQF+r
	 TsMEJq8+UZvOA==
Date: Sun, 31 Dec 2023 15:30:37 -0800
Subject: [PATCH 04/58] mkfs: clean up the rtinit() function
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010001.1809361.11639524525861448693.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
References: <170405009903.1809361.17191356040741566208.stgit@frogsfrogsfrogs>
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

Clean up some of the warts in this function, like the inconsistent use
of @i for @error, missing comments, and make this more visually pleasing
by adding some whitespace between major sections.  Some things are left
untouched for the next patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c |   70 ++++++++++++++++++++++++++++------------------------------
 1 file changed, 34 insertions(+), 36 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index f9b0f837ed9..a519aaeb72b 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -750,28 +750,26 @@ parse_proto(
  */
 static void
 rtinit(
-	xfs_mount_t	*mp)
+	struct xfs_mount	*mp)
 {
-	xfs_fileoff_t	bno;
-	xfs_bmbt_irec_t	*ep;
-	int		error;
-	int		i;
-	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
-	xfs_extlen_t	nsumblocks;
-	uint		blocks;
-	int		nmap;
-	xfs_inode_t	*rbmip;
-	xfs_inode_t	*rsumip;
-	xfs_trans_t	*tp;
-	struct cred	creds;
-	struct fsxattr	fsxattrs;
+	struct cred		creds;
+	struct fsxattr		fsxattrs;
+	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
+	struct xfs_inode	*rbmip;
+	struct xfs_inode	*rsumip;
+	struct xfs_trans	*tp;
+	struct xfs_bmbt_irec	*ep;
+	xfs_fileoff_t		bno;
+	xfs_extlen_t		nsumblocks;
+	uint			blocks;
+	int			i;
+	int			nmap;
+	int			error;
 
-	/*
-	 * First, allocate the inodes.
-	 */
-	i = -libxfs_trans_alloc_rollable(mp, MKFS_BLOCKRES_INODE, &tp);
-	if (i)
-		res_failed(i);
+	/* Create the realtime bitmap inode. */
+	error = -libxfs_trans_alloc_rollable(mp, MKFS_BLOCKRES_INODE, &tp);
+	if (error)
+		res_failed(error);
 
 	memset(&creds, 0, sizeof(creds));
 	memset(&fsxattrs, 0, sizeof(fsxattrs));
@@ -792,6 +790,8 @@ rtinit(
 	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
 	libxfs_log_sb(tp);
 	mp->m_rbmip = rbmip;
+
+	/* Create the realtime summary inode. */
 	error = creatproto(&tp, NULL, S_IFREG, 1, 0, &creds, &fsxattrs,
 			&rsumip);
 	if (error) {
@@ -806,14 +806,13 @@ rtinit(
 		fail(_("Completion of the realtime summary inode failed"),
 				error);
 	mp->m_rsumip = rsumip;
-	/*
-	 * Next, give the bitmap file some zero-filled blocks.
-	 */
+
+	/* Zero the realtime bitmap. */
 	blocks = mp->m_sb.sb_rbmblocks +
 			XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
-	i = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
-	if (i)
-		res_failed(i);
+	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
+	if (error)
+		res_failed(error);
 
 	libxfs_trans_ijoin(tp, rbmip, 0);
 	bno = 0;
@@ -822,10 +821,10 @@ rtinit(
 		error = -libxfs_bmapi_write(tp, rbmip, bno,
 				(xfs_extlen_t)(mp->m_sb.sb_rbmblocks - bno),
 				0, mp->m_sb.sb_rbmblocks, map, &nmap);
-		if (error) {
+		if (error)
 			fail(_("Allocation of the realtime bitmap failed"),
 				error);
-		}
+
 		for (i = 0, ep = map; i < nmap; i++, ep++) {
 			libxfs_device_zero(mp->m_ddev_targp,
 				XFS_FSB_TO_DADDR(mp, ep->br_startblock),
@@ -839,25 +838,24 @@ rtinit(
 		fail(_("Block allocation of the realtime bitmap inode failed"),
 				error);
 
-	/*
-	 * Give the summary file some zero-filled blocks.
-	 */
+	/* Zero the summary file. */
 	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
 	blocks = nsumblocks + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
-	i = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
-	if (i)
-		res_failed(i);
+	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
+	if (error)
+		res_failed(error);
 	libxfs_trans_ijoin(tp, rsumip, 0);
+
 	bno = 0;
 	while (bno < nsumblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
 		error = -libxfs_bmapi_write(tp, rsumip, bno,
 				(xfs_extlen_t)(nsumblocks - bno),
 				0, nsumblocks, map, &nmap);
-		if (error) {
+		if (error)
 			fail(_("Allocation of the realtime summary failed"),
 				error);
-		}
+
 		for (i = 0, ep = map; i < nmap; i++, ep++) {
 			libxfs_device_zero(mp->m_ddev_targp,
 				XFS_FSB_TO_DADDR(mp, ep->br_startblock),

