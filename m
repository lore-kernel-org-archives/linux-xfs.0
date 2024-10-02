Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B86312107
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832425; cv=none; b=J4cPbx3lCRlYzI1FgNTtPWnJm6tQXnEwWI9X0yO9AuC8+7/kb+F79Fj98PwnIWr5yRX6zmaOMeZIO7HxGI8hXnDTUXWZJWtL2ArsDcoE1SGxAIQ3ebVHPChMeOjaWLKS6iN2fd9d5hzPovo1VKwyRdkTN975kM/Gzacm/BUoRoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832425; c=relaxed/simple;
	bh=OwWLOTx99JRpd9xhihB5/KWQYf+lxks9MWcPndeT82k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ooN1QyUlShqIglvO4XHFSIFcajArmvIXh9VPDGZTh4+tfxR4KIE9RPBH/6Zs+Lp9jESEwKjs+VdpQ2ZTA1OsdUOA109SDyGhXmsSbwyPRi99mkIP9hGeI2tNjZ3lUYZUZQsWdsyzkpd45jSEnSKeITLznbetl1zMPydog5EzAnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mNhZTeUZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mNhZTeUZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F35C4CEC6;
	Wed,  2 Oct 2024 01:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832425;
	bh=OwWLOTx99JRpd9xhihB5/KWQYf+lxks9MWcPndeT82k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=mNhZTeUZUJC7X0wtm35FhehuEbdFI/e45b7i72neCx/mRXM1g/KUSxhojspn7zE5V
	 swTwA1YNGXpdZc34NI9oZ5+PiZ0J5Wue7euo9qC9fLPs9SrJmzxW/FBAijroU87250
	 dzvRGBIRFTq2xNQIfl/rAjBbqa7ZByHShw1xK9QxkCA0M8mDAlTGfRBxZoLVu45fjQ
	 IOzKzO5m6qOxt5TWfz8OPsy7NIu/38dl/wvCWUY7ejelCWecC0ogxSHtjQ/XlE3LSd
	 6uFUOiqS8aAzTkF9xZbXqTt9e9rLqIe6DsrWqSmkLg+l6Q2KGNf4vZK28EhaKRfgyB
	 VtypfYdD/ADcQ==
Date: Tue, 01 Oct 2024 18:27:05 -0700
Subject: [PATCH 2/2] mkfs: break up the rest of the rtinit() function
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783103750.4038865.17327935292927158281.stgit@frogsfrogsfrogs>
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

Break up this really long function into smaller functions that each do
one thing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c |  160 ++++++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 106 insertions(+), 54 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 65072f7b5..8a51bfb26 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -750,78 +750,102 @@ parse_proto(
 	parseproto(mp, NULL, fsx, pp, NULL);
 }
 
-/*
- * Allocate the realtime bitmap and summary inodes, and fill in data if any.
- */
+/* Create a sb-rooted metadata file. */
 static void
-rtinit(
-	struct xfs_mount	*mp)
+create_sb_metadata_file(
+	struct xfs_mount	*mp,
+	void			(*create)(struct xfs_inode *ip))
 {
-	struct cred		creds;
-	struct fsxattr		fsxattrs;
-	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
-	struct xfs_inode	*rbmip;
-	struct xfs_inode	*rsumip;
+	struct xfs_icreate_args	args = {
+		.mode		= S_IFREG,
+		.flags		= XFS_ICREATE_UNLINKABLE,
+	};
 	struct xfs_trans	*tp;
-	struct xfs_bmbt_irec	*ep;
-	xfs_fileoff_t		bno;
-	xfs_extlen_t		nsumblocks;
-	uint			blocks;
-	int			i;
-	int			nmap;
+	struct xfs_inode	*ip = NULL;
+	xfs_ino_t		ino;
 	int			error;
 
-	/* Create the realtime bitmap inode. */
 	error = -libxfs_trans_alloc_rollable(mp, MKFS_BLOCKRES_INODE, &tp);
 	if (error)
 		res_failed(error);
 
-	memset(&creds, 0, sizeof(creds));
-	memset(&fsxattrs, 0, sizeof(fsxattrs));
-	error = creatproto(&tp, NULL, S_IFREG, 0, &creds, &fsxattrs, &rbmip);
-	if (error) {
-		fail(_("Realtime bitmap inode allocation failed"), error);
-	}
-	/*
-	 * Do our thing with rbmip before allocating rsumip,
-	 * because the next call to createproto may
-	 * commit the transaction in which rbmip was allocated.
-	 */
-	mp->m_sb.sb_rbmino = rbmip->i_ino;
-	rbmip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
-	rbmip->i_diflags = XFS_DIFLAG_NEWRTBM;
-	inode_set_atime(VFS_I(rbmip), 0, 0);
-	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
-	libxfs_log_sb(tp);
-	mp->m_rbmip = rbmip;
+	error = -libxfs_dialloc(&tp, 0, args.mode, &ino);
+	if (error)
+		goto fail;
+
+	error = -libxfs_icreate(tp, ino, &args, &ip);
+	if (error)
+		goto fail;
 
-	/* Create the realtime summary inode. */
-	error = creatproto(&tp, NULL, S_IFREG, 0, &creds, &fsxattrs, &rsumip);
-	if (error) {
-		fail(_("Realtime summary inode allocation failed"), error);
-	}
-	mp->m_sb.sb_rsumino = rsumip->i_ino;
-	rsumip->i_disk_size = mp->m_rsumsize;
-	libxfs_trans_log_inode(tp, rsumip, XFS_ILOG_CORE);
+	create(ip);
+
+	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	libxfs_log_sb(tp);
+
 	error = -libxfs_trans_commit(tp);
 	if (error)
-		fail(_("Completion of the realtime summary inode failed"),
-				error);
-	mp->m_rsumip = rsumip;
+		goto fail;
+
+fail:
+	if (ip)
+		libxfs_irele(ip);
+	if (error)
+		fail(_("Realtime inode allocation failed"), error);
+}
+
+static void
+rtbitmap_create(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	ip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
+	ip->i_diflags |= XFS_DIFLAG_NEWRTBM;
+	inode_set_atime(VFS_I(ip), 0, 0);
+
+	mp->m_sb.sb_rbmino = ip->i_ino;
+	mp->m_rbmip = ip;
+	ihold(VFS_I(ip));
+}
+
+static void
+rtsummary_create(
+	struct xfs_inode	*ip)
+{
+	struct xfs_mount	*mp = ip->i_mount;
+
+	ip->i_disk_size = mp->m_rsumsize;
+
+	mp->m_sb.sb_rsumino = ip->i_ino;
+	mp->m_rsumip = ip;
+	ihold(VFS_I(ip));
+}
+
+/* Zero the realtime bitmap. */
+static void
+rtbitmap_init(
+	struct xfs_mount	*mp)
+{
+	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
+	struct xfs_trans	*tp;
+	struct xfs_bmbt_irec	*ep;
+	xfs_fileoff_t		bno;
+	uint			blocks;
+	int			i;
+	int			nmap;
+	int			error;
 
-	/* Zero the realtime bitmap. */
 	blocks = mp->m_sb.sb_rbmblocks +
 			XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
 	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
 	if (error)
 		res_failed(error);
 
-	libxfs_trans_ijoin(tp, rbmip, 0);
+	libxfs_trans_ijoin(tp, mp->m_rbmip, 0);
 	bno = 0;
 	while (bno < mp->m_sb.sb_rbmblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
-		error = -libxfs_bmapi_write(tp, rbmip, bno,
+		error = -libxfs_bmapi_write(tp, mp->m_rbmip, bno,
 				(xfs_extlen_t)(mp->m_sb.sb_rbmblocks - bno),
 				0, mp->m_sb.sb_rbmblocks, map, &nmap);
 		if (error)
@@ -840,19 +864,34 @@ rtinit(
 	if (error)
 		fail(_("Block allocation of the realtime bitmap inode failed"),
 				error);
+}
+
+/* Zero the realtime summary file. */
+static void
+rtsummary_init(
+	struct xfs_mount	*mp)
+{
+	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
+	struct xfs_trans	*tp;
+	struct xfs_bmbt_irec	*ep;
+	xfs_fileoff_t		bno;
+	xfs_extlen_t		nsumblocks;
+	uint			blocks;
+	int			i;
+	int			nmap;
+	int			error;
 
-	/* Zero the summary file. */
 	nsumblocks = mp->m_rsumsize >> mp->m_sb.sb_blocklog;
 	blocks = nsumblocks + XFS_BM_MAXLEVELS(mp, XFS_DATA_FORK) - 1;
 	error = -libxfs_trans_alloc_rollable(mp, blocks, &tp);
 	if (error)
 		res_failed(error);
-	libxfs_trans_ijoin(tp, rsumip, 0);
+	libxfs_trans_ijoin(tp, mp->m_rsumip, 0);
 
 	bno = 0;
 	while (bno < nsumblocks) {
 		nmap = XFS_BMAP_MAX_NMAP;
-		error = -libxfs_bmapi_write(tp, rsumip, bno,
+		error = -libxfs_bmapi_write(tp, mp->m_rsumip, bno,
 				(xfs_extlen_t)(nsumblocks - bno),
 				0, nsumblocks, map, &nmap);
 		if (error)
@@ -870,8 +909,6 @@ rtinit(
 	if (error)
 		fail(_("Block allocation of the realtime summary inode failed"),
 				error);
-
-	rtfreesp_init(mp);
 }
 
 /*
@@ -910,6 +947,21 @@ rtfreesp_init(
 	}
 }
 
+/*
+ * Allocate the realtime bitmap and summary inodes, and fill in data if any.
+ */
+static void
+rtinit(
+	struct xfs_mount	*mp)
+{
+	create_sb_metadata_file(mp, rtbitmap_create);
+	create_sb_metadata_file(mp, rtsummary_create);
+
+	rtbitmap_init(mp);
+	rtsummary_init(mp);
+	rtfreesp_init(mp);
+}
+
 static long
 filesize(
 	int		fd)

