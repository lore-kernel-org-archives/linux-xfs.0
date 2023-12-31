Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29824C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c7tOdHDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02AAC433C7;
	Sun, 31 Dec 2023 23:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065454;
	bh=JqErQyL0PWBnQ8EM+Lh1JOtfnTWnt37370HC9jZqgdA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=c7tOdHDFr/lhM7cQ+w7i6ltu1Fwu8la0P1KflOPPO13akxiUf6NOWn4gt3W1Pp0lM
	 by6r4eIRY0A1rnD5YOjdfHqN7iCf5cbSZoWoyiAcsXeodlSB9PbHpG1OLwIzVjfmBq
	 IqQfxgX0VXJdrH/63IvM1Vwx5WEfft4wsI0x/LZ2OCb2xeOPPHTCuFo/hKn6X+uiBj
	 B1XkPgvGQIZD/qePVBn5YB4wJ5k2xiHFGayRcs3EvfzZZyEOwuoWM8K1VL8cJVU9jC
	 amV7PwtF+B6gK7XEY8a4nO0YFdb8Fn5H0+T0dkM1v+/Q3c3zKUASUVIbijxTs6j3VB
	 iov/DseUT2ujA==
Date: Sun, 31 Dec 2023 15:30:53 -0800
Subject: [PATCH 05/58] libxfs: convert all users to libxfs_imeta_create
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405010014.1809361.6997364246808217554.stgit@frogsfrogsfrogs>
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

Convert all open-coded sb metadata inode pointer logging to use
libxfs_imeta_create to create metadata inodes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/proto.c |   44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)


diff --git a/mkfs/proto.c b/mkfs/proto.c
index a519aaeb72b..8ae0aba777c 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -752,8 +752,7 @@ static void
 rtinit(
 	struct xfs_mount	*mp)
 {
-	struct cred		creds;
-	struct fsxattr		fsxattrs;
+	struct xfs_imeta_update	upd;
 	struct xfs_bmbt_irec	map[XFS_BMAP_MAX_NMAP];
 	struct xfs_inode	*rbmip;
 	struct xfs_inode	*rsumip;
@@ -767,41 +766,38 @@ rtinit(
 	int			error;
 
 	/* Create the realtime bitmap inode. */
-	error = -libxfs_trans_alloc_rollable(mp, MKFS_BLOCKRES_INODE, &tp);
+	error = -libxfs_imeta_start_create(mp, &XFS_IMETA_RTBITMAP, &upd);
 	if (error)
 		res_failed(error);
 
-	memset(&creds, 0, sizeof(creds));
-	memset(&fsxattrs, 0, sizeof(fsxattrs));
-	error = creatproto(&tp, NULL, S_IFREG, 1, 0, &creds, &fsxattrs,
-			&rbmip);
-	if (error) {
+	error = -libxfs_imeta_create(&upd, S_IFREG, &rbmip);
+	if (error)
 		fail(_("Realtime bitmap inode allocation failed"), error);
-	}
-	/*
-	 * Do our thing with rbmip before allocating rsumip,
-	 * because the next call to createproto may
-	 * commit the transaction in which rbmip was allocated.
-	 */
-	mp->m_sb.sb_rbmino = rbmip->i_ino;
+
 	rbmip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
-	rbmip->i_diflags = XFS_DIFLAG_NEWRTBM;
+	rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
 	inode_set_atime(VFS_I(rbmip), 0, 0);
 	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
-	libxfs_log_sb(tp);
+
+	error = -libxfs_imeta_commit_update(&upd);
+	if (error)
+		fail(_("Completion of the realtime bitmap inode failed"),
+				error);
 	mp->m_rbmip = rbmip;
 
 	/* Create the realtime summary inode. */
-	error = creatproto(&tp, NULL, S_IFREG, 1, 0, &creds, &fsxattrs,
-			&rsumip);
-	if (error) {
+	error = -libxfs_imeta_start_create(mp, &XFS_IMETA_RTSUMMARY, &upd);
+	if (error)
+		res_failed(error);
+
+	error = -libxfs_imeta_create(&upd, S_IFREG, &rsumip);
+	if (error)
 		fail(_("Realtime summary inode allocation failed"), error);
-	}
-	mp->m_sb.sb_rsumino = rsumip->i_ino;
+
 	rsumip->i_disk_size = mp->m_rsumsize;
 	libxfs_trans_log_inode(tp, rsumip, XFS_ILOG_CORE);
-	libxfs_log_sb(tp);
-	error = -libxfs_trans_commit(tp);
+
+	error = -libxfs_imeta_commit_update(&upd);
 	if (error)
 		fail(_("Completion of the realtime summary inode failed"),
 				error);

