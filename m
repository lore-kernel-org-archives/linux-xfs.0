Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAEF1C2E
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832410; cv=none; b=XwIdkTUULz9X11SlvO1ZI5AfyEjoEf9v/8pP5oW8DB08tMI7jHDr0wVCPimM4hgWHz6dxzWOB9eQ6PGEDqkvrmZZfA+oZnECYr+PfWaE4clo2tXOCpwf/Nr9j9Qr5efrjPJIVNvqQ+JWWefjklE/6aHrZ19nczdcHOjOtohOr6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832410; c=relaxed/simple;
	bh=/Pa1Pb0kQ7f3+pp35ls/QyNQCL1eprE9+JzA51RTlhY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RagZApA5EJQeoqNXEGGn2fJDp+1icmygDKhwM5qhICfbtUXWHENP+ziFDHJnPyVBUYJjeetkgbrEgSdfj5DjD2CHA5kmMTJ23WX81i+qQ1k8l/azsDgdqsjiiSMU49pTQ38r4IRhvdOhfBkcKLKHakVRs3924VHvcUjrD4e3KgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nL2NOFrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nL2NOFrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDCBFC4CEC6;
	Wed,  2 Oct 2024 01:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832410;
	bh=/Pa1Pb0kQ7f3+pp35ls/QyNQCL1eprE9+JzA51RTlhY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=nL2NOFrDzgLlZmSqO2HzwzNdtoleLJsXD/ECGi/wy8nSFYu0kz8vBm9/ygmSG0/u6
	 Z2zsqtnvV7bMEQgB7wdKl5xN4bpUGj8UgxytMKrYnTZsR4Em0J9hP5YenkuNk7hj3U
	 K/8FJXbrydVIgJg9S6Ay9UO2Zs/WNJOXm5aGmgsVVMtdfu2IxE2rJQzst35VbyrXcY
	 xIxkVvjIg2I6VmlQRlFvKXPXnC80pDztEQl280OwCdW5mNn3459391dmgvHyrO2fyc
	 A9q1NmY5Uq+hVogcF4FRYWPlEpSETfGIFeN/Xc3CY5mYXQTlM25/mrBKf59gbqcrTv
	 ip2V8W6RWoyfg==
Date: Tue, 01 Oct 2024 18:26:49 -0700
Subject: [PATCH 1/2] mkfs: clean up the rtinit() function
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783103735.4038865.17704760289119478.stgit@frogsfrogsfrogs>
In-Reply-To: <172783103720.4038865.18392358908456498224.stgit@frogsfrogsfrogs>
References: <172783103720.4038865.18392358908456498224.stgit@frogsfrogsfrogs>
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
index 251e3a9ee..65072f7b5 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -755,28 +755,26 @@ parse_proto(
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
@@ -796,6 +794,8 @@ rtinit(
 	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
 	libxfs_log_sb(tp);
 	mp->m_rbmip = rbmip;
+
+	/* Create the realtime summary inode. */
 	error = creatproto(&tp, NULL, S_IFREG, 0, &creds, &fsxattrs, &rsumip);
 	if (error) {
 		fail(_("Realtime summary inode allocation failed"), error);
@@ -809,14 +809,13 @@ rtinit(
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
@@ -825,10 +824,10 @@ rtinit(
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
@@ -842,25 +841,24 @@ rtinit(
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

