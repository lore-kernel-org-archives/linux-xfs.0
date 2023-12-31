Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41127C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pOrfueJX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94EC6C433C7;
	Sun, 31 Dec 2023 23:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065469;
	bh=nmfSL3DhT/bHIIvXnob4elbU6kmAeTcVyQDNYjViMF8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pOrfueJXjqwn50iBzkbcS1TqOn5HL/061QIqONMfqAPVDF1vK4dQqIoyV8vpBh6Hr
	 IP+MMJ5pJVB6jD5QSf758z0OckPhjJzCKG+5oJ47SFLhaK5a5N88Ix00MhQZ3XEW3b
	 Wtz4bXzR3qj8mr8HMhwTFBreA1oKzP8j4c+ASxnYUhD9OMi4ohlGdzz3yu3fORL1BK
	 mNgA6xw4StbZ1aK+RZ/6ZXO7DIY7dPDzDuFGink5xcKtzqe5a/cUk8UyuOLjOC5slU
	 nGa5EDAaS7x8HV9nYIFwZ6YMcYJtL0NgvifpeZhE49oZb693KcE+jHzNkqdiXEe1PZ
	 iEmw5XuEMWyYA==
Date: Sun, 31 Dec 2023 15:31:09 -0800
Subject: [PATCH 06/58] mkfs: break up the rest of the rtinit() function
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010027.1809361.17884123990207975871.stgit@frogsfrogsfrogs>
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

Break up this really long function into smaller functions that each do
one thing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c |   89 ++++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 64 insertions(+), 25 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index 8ae0aba777c..2eff1f32173 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -745,27 +745,15 @@ parse_proto(
 	parseproto(mp, NULL, fsx, pp, NULL);
 }
 
-/*
- * Allocate the realtime bitmap and summary inodes, and fill in data if any.
- */
+/* Create the realtime bitmap inode. */
 static void
-rtinit(
+rtbitmap_create(
 	struct xfs_mount	*mp)
 {
 	struct xfs_imeta_update	upd;
-	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
 	struct xfs_inode	*rbmip;
-	struct xfs_inode	*rsumip;
-	struct xfs_trans	*tp;
-	struct xfs_bmbt_irec	*ep;
-	xfs_fileoff_t		bno;
-	xfs_extlen_t		nsumblocks;
-	uint			blocks;
-	int			i;
-	int			nmap;
 	int			error;
 
-	/* Create the realtime bitmap inode. */
 	error = -libxfs_imeta_start_create(mp, &XFS_IMETA_RTBITMAP, &upd);
 	if (error)
 		res_failed(error);
@@ -777,15 +765,24 @@ rtinit(
 	rbmip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
 	rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
 	inode_set_atime(VFS_I(rbmip), 0, 0);
-	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
+	libxfs_trans_log_inode(upd.tp, rbmip, XFS_ILOG_CORE);
 
 	error = -libxfs_imeta_commit_update(&upd);
 	if (error)
 		fail(_("Completion of the realtime bitmap inode failed"),
 				error);
 	mp->m_rbmip = rbmip;
+}
+
+/* Create the realtime summary inode. */
+static void
+rtsummary_create(
+	struct xfs_mount	*mp)
+{
+	struct xfs_imeta_update	upd;
+	struct xfs_inode	*rsumip;
+	int			error;
 
-	/* Create the realtime summary inode. */
 	error = -libxfs_imeta_start_create(mp, &XFS_IMETA_RTSUMMARY, &upd);
 	if (error)
 		res_failed(error);
@@ -795,26 +792,40 @@ rtinit(
 		fail(_("Realtime summary inode allocation failed"), error);
 
 	rsumip->i_disk_size = mp->m_rsumsize;
-	libxfs_trans_log_inode(tp, rsumip, XFS_ILOG_CORE);
+	libxfs_trans_log_inode(upd.tp, rsumip, XFS_ILOG_CORE);
 
 	error = -libxfs_imeta_commit_update(&upd);
 	if (error)
 		fail(_("Completion of the realtime summary inode failed"),
 				error);
 	mp->m_rsumip = rsumip;
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
@@ -833,19 +844,34 @@ rtinit(
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
@@ -863,8 +889,6 @@ rtinit(
 	if (error)
 		fail(_("Block allocation of the realtime summary inode failed"),
 				error);
-
-	rtfreesp_init(mp);
 }
 
 /*
@@ -903,6 +927,21 @@ rtfreesp_init(
 	}
 }
 
+/*
+ * Allocate the realtime bitmap and summary inodes, and fill in data if any.
+ */
+static void
+rtinit(
+	struct xfs_mount	*mp)
+{
+	rtbitmap_create(mp);
+	rtsummary_create(mp);
+
+	rtbitmap_init(mp);
+	rtsummary_init(mp);
+	rtfreesp_init(mp);
+}
+
 static long
 filesize(
 	int		fd)

