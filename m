Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 779797EE
	for <linux-xfs@vger.kernel.org>; Mon,  1 Jan 2024 00:23:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQcaBlXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080B3C433C7;
	Mon,  1 Jan 2024 00:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704068613;
	bh=a5oZHdy1ViwEXbSdSxjLeI9mC+Oh+G1l8QCDPmTW9GU=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=SQcaBlXw4vXGvFcugU3tOR3gZkZcJtVnFwAivaCPxkK+SMrme6J+eUpXUj/SSfh06
	 KTl5w0KPdyRFQFrk67kiJwUUA5gw/Mi4XAmijItYk9TFKuBm7CKtmmztqz0xgQ2eJV
	 BgQAJ5oTmzr+SqSYmRt6ovg6fCE2b4VE2cNDOLJ/9yM4Fu/zO3zmNGo/RgKpNVYVCD
	 Ht6yCjOdGn0IUn6g+CpoKtTCQfiMpe0zSks0KxX3Hy1w/Ro/+4PZjA6g7OxQgLGrhY
	 +wFiHhkWxKjXYvKhsD4lM0wNQO8l1yFkbnPGYix355qzEj0SmPjMlC2Xvtrgs7l1kE
	 5yqvcTwaNZ50g==
Date: Sun, 31 Dec 2023 16:23:32 +9900
Subject: [PATCH 3/4] xfs_repair: use libxfs_alloc_file_space to reallocate rt
 metadata
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405016277.1816687.11077687941234807759.stgit@frogsfrogsfrogs>
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

Now that libxfs_alloc_file_space can allocate and zero blocks, use it to
repair the realtime metadata instead of open-coding all this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   76 +++++++------------------------------------------------
 1 file changed, 10 insertions(+), 66 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index fd862362f1d..c9974623d12 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -736,15 +736,9 @@ mk_rbmino(
 	struct xfs_mount	*mp)
 {
 	struct xfs_imeta_update	upd = { };
-	struct xfs_trans	*tp = NULL;
 	struct xfs_inode	*ip = NULL;
-	struct xfs_bmbt_irec	*ep;
 	int			i;
-	int			nmap;
 	int			error;
-	xfs_fileoff_t		bno;
-	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
-	uint			blocks;
 
 	/* Reset the realtime bitmap inode. */
 	if (!xfs_has_metadir(mp)) {
@@ -779,36 +773,15 @@ mk_rbmino(
 	 * then allocate blocks for file and fill with zeroes (stolen
 	 * from mkfs)
 	 */
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
+	if (mp->m_sb.sb_rbmblocks) {
+		error = -libxfs_alloc_file_space(ip, 0,
+				mp->m_sb.sb_rbmblocks << mp->m_sb.sb_blocklog,
+				XFS_BMAPI_ZERO);
 		if (error) {
 			do_error(
-			_("couldn't allocate realtime bitmap, error = %d\n"),
+	_("allocation of the realtime bitmap failed, error = %d\n"),
 				error);
 		}
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
 	}
 	libxfs_irele(ip);
 }
@@ -996,16 +969,9 @@ mk_rsumino(
 	struct xfs_mount	*mp)
 {
 	struct xfs_imeta_update	upd = { };
-	struct xfs_trans	*tp = NULL;
 	struct xfs_inode	*ip = NULL;
-	struct xfs_bmbt_irec	*ep;
 	int			i;
-	int			nmap;
 	int			error;
-	int			nsumblocks;
-	xfs_fileoff_t		bno;
-	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
-	uint			blocks;
 
 	/* Reset the realtime summary inode. */
 	if (!xfs_has_metadir(mp)) {
@@ -1040,36 +1006,14 @@ mk_rsumino(
 	 * then allocate blocks for file and fill with zeroes (stolen
 	 * from mkfs)
 	 */
-	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
-	blocks = nsumblocks + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
-	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
-	if (error)
-		res_failed(error);
-
-	libxfs_trans_ijoin(tp, ip, 0);
-	bno = 0;
-	while (bno < nsumblocks) {
-		nmap = XFS_BMAP_MAX_NMAP;
-		error = -libxfs_bmapi_write(tp, ip, bno,
-			  (xfs_extlen_t)(nsumblocks - bno),
-			  0, nsumblocks, map, &nmap);
+	if (mp->m_rsumsize) {
+		error = -libxfs_alloc_file_space(ip, 0, mp->m_rsumsize,
+				XFS_BMAPI_ZERO);
 		if (error) {
 			do_error(
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
 	_("allocation of the realtime summary ino failed, error = %d\n"),
-			error);
+				error);
+		}
 	}
 	libxfs_irele(ip);
 }

