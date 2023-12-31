Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F9DC2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GszBo6nD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CDDC433C7;
	Sun, 31 Dec 2023 23:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704066048;
	bh=KpsHVfLM0Z7bKtM2Xb7zuRQ0txlVnlDKg3L4DCVW8oY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=GszBo6nD3BCHAvNAXKBeBbavOOZmT4loxSNwxP7OEisI7p+N69QNrs5YeUWoygIy+
	 P1mX7keVJEu/HFnm+lU6Xfq93qieT2He1fOab16p84LG31vOgwnCE0o1qtqOnmq/Vn
	 UlpiweQ1YBrv+Z0TJuVue8sUcUqCL9PjRVFdBR/hn9lXrZMko7CIUc9wKFWmshmZGe
	 KmKcnrXZPGMX1cFsRTDGfuRWna6p3jCGeWt1Yi34ViHroazzdd6pcC25VRPkgfKEt1
	 efJu5HE18PasqMwXVLRkzGk7nKFuZca22FTfaTsGKbHXy/CMa9q1Lqt8/rvy3jAkki
	 kfBNcCVBslmBw==
Date: Sun, 31 Dec 2023 15:40:47 -0800
Subject: [PATCH 43/58] xfs_repair: refactor grabbing realtime metadata inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010520.1809361.17407986062622776380.stgit@frogsfrogsfrogs>
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

Create a helper function to grab a realtime metadata inode.  When
metadir arrives, the bitmap and summary inodes can float, so we'll
turn this function into a "load or allocate" function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/phase6.c |   90 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 53 insertions(+), 37 deletions(-)


diff --git a/repair/phase6.c b/repair/phase6.c
index 017c46f43af..afb09ff7232 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -471,18 +471,37 @@ reset_root_ino(
 	libxfs_inode_init(tp, &args, ip);
 }
 
+/* Load a realtime metadata inode from disk and reset it. */
+static int
+ensure_rtino(
+	struct xfs_trans		*tp,
+	xfs_ino_t			ino,
+	struct xfs_inode		**ipp)
+{
+	struct xfs_mount		*mp = tp->t_mountp;
+	int				error;
+
+	error = -libxfs_iget(mp, tp, ino, 0, ipp);
+	if (error)
+		return error;
+
+	reset_root_ino(tp, S_IFREG, *ipp);
+	return 0;
+}
+
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
+	struct xfs_bmbt_irec	*ep;
+	int			i;
+	int			nmap;
+	int			error;
+	xfs_fileoff_t		bno;
+	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
+	uint			blocks;
 
 	/*
 	 * first set up inode
@@ -491,15 +510,13 @@ mk_rbmino(xfs_mount_t *mp)
 	if (i)
 		res_failed(i);
 
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rbmino, 0, &ip);
-	if (error) {
-		do_error(
-		_("couldn't iget realtime bitmap inode -- error - %d\n"),
-			error);
-	}
-
 	/* Reset the realtime bitmap inode. */
-	reset_root_ino(tp, S_IFREG, ip);
+	error = ensure_rtino(tp, mp->m_sb.sb_rbmino, &ip);
+	if (error) {
+		do_error(
+		_("couldn't iget realtime bitmap inode -- error - %d\n"),
+			error);
+	}
 	ip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = -libxfs_trans_commit(tp);
@@ -700,18 +717,19 @@ _("can't access block %" PRIu64 " (fsbno %" PRIu64 ") of realtime summary inode
 }
 
 static void
-mk_rsumino(xfs_mount_t *mp)
+mk_rsumino(
+	struct xfs_mount	*mp)
 {
-	xfs_trans_t	*tp;
-	xfs_inode_t	*ip;
-	xfs_bmbt_irec_t	*ep;
-	int		i;
-	int		nmap;
-	int		error;
-	int		nsumblocks;
-	xfs_fileoff_t	bno;
-	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
-	uint		blocks;
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
+	struct xfs_bmbt_irec	*ep;
+	int			i;
+	int			nmap;
+	int			error;
+	int			nsumblocks;
+	xfs_fileoff_t		bno;
+	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
+	uint			blocks;
 
 	/*
 	 * first set up inode
@@ -720,15 +738,13 @@ mk_rsumino(xfs_mount_t *mp)
 	if (i)
 		res_failed(i);
 
-	error = -libxfs_iget(mp, tp, mp->m_sb.sb_rsumino, 0, &ip);
-	if (error) {
-		do_error(
-		_("couldn't iget realtime summary inode -- error - %d\n"),
-			error);
-	}
-
 	/* Reset the rt summary inode. */
-	reset_root_ino(tp, S_IFREG, ip);
+	error = ensure_rtino(tp, mp->m_sb.sb_rsumino, &ip);
+	if (error) {
+		do_error(
+		_("couldn't iget realtime summary inode -- error - %d\n"),
+			error);
+	}
 	ip->i_disk_size = mp->m_rsumsize;
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = -libxfs_trans_commit(tp);

