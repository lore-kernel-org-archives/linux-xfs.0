Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D94C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:29:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B3TFo6eZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F54C433C7;
	Sun, 31 Dec 2023 23:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065360;
	bh=YWNLKbLBHO6N1tQcT/XS1zwJ32TOLBHe9R2DvzERx0U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=B3TFo6eZZkWwGKGHd8khKMT9wQZAyfNJDcbaAXfa/FkcKCVroA4WrwiU67k9iZ+Qv
	 FOLJWlhUfxlXPY02czUe++rke/t5NgiKzIuBJ06j/KrTdN2vuUfHTjGoFc/d4PiSjO
	 tae/Ckr8uz6swZFAu7g5EdrHUZ/LslrvEZGH5pSWnbwuZ98JjfJqS2aKMX8neg4rIS
	 6vQLpjDLfr1BL9/0oVyLsirKDYDNjKolcYr6sLFfxYCSJrSlnqVvzj8gqKknlKTfWw
	 Q9Js9gfxoJOuMy2mrcpVJwtx/xUifL2t1VtPbIkgniuf/x4JClpMiH0iYVfjMrWYD6
	 Xkup1o/HM91bQ==
Date: Sun, 31 Dec 2023 15:29:19 -0800
Subject: [PATCH 27/28] xfs_repair: use library functions to reset
 root/rbm/rsum inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009534.1808635.17083440586166937691.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
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

Use the iroot reset function to reset root inodes instead of open-coding
the reset routine.  While we're at it, fix a longstanding memory leak if
the inode being reset actually had an xattr fork full of mappings.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 +
 repair/phase6.c          |  127 ++++++++++------------------------------------
 2 files changed, 29 insertions(+), 100 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 58c643d7535..72c6d65d75f 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -148,6 +148,7 @@
 #define xfs_droplink			libxfs_droplink
 
 #define xfs_finobt_calc_reserves	libxfs_finobt_calc_reserves
+#define xfs_fixed_inode_reset		libxfs_fixed_inode_reset
 #define xfs_free_extent			libxfs_free_extent
 #define xfs_free_extent_later		libxfs_free_extent_later
 #define xfs_free_perag			libxfs_free_perag
@@ -177,6 +178,7 @@
 #define xfs_inode_from_disk		libxfs_inode_from_disk
 #define xfs_inode_from_disk_ts		libxfs_inode_from_disk_ts
 #define xfs_inode_hasattr		libxfs_inode_hasattr
+#define xfs_inode_init			libxfs_inode_init
 #define xfs_inode_to_disk		libxfs_inode_to_disk
 #define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
 #define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
diff --git a/repair/phase6.c b/repair/phase6.c
index 13f2fb2290b..88f1b8f106e 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -446,20 +446,29 @@ res_failed(
 		do_error(_("xfs_trans_reserve returned %d\n"), err);
 }
 
-static inline void
-reset_inode_fields(struct xfs_inode *ip)
+/*
+ * Forcibly reinitialize a fixed-location inode, such as a filesystem root
+ * directory or the realtime metadata inodes.  The inode must not otherwise be
+ * in use; the data fork must be empty, and the attr fork will be reset.
+ */
+static void
+reset_root_ino(
+	struct xfs_trans	*tp,
+	umode_t			mode,
+	struct xfs_inode	*ip)
 {
-	ip->i_projid = 0;
-	ip->i_disk_size = 0;
-	ip->i_nblocks = 0;
-	ip->i_extsize = 0;
-	ip->i_cowextsize = 0;
-	ip->i_flushiter = 0;
+	struct xfs_icreate_args	args = {
+		.nlink			= S_ISDIR(mode) ? 2 : 1,
+	};
+
+	libxfs_icreate_args_rootfile(&args, ip->i_mount, mode, false);
+
+	/* Erase the attr fork since libxfs_inode_init won't do it for us. */
 	ip->i_forkoff = 0;
-	ip->i_diflags = 0;
-	ip->i_diflags2 = 0;
-	ip->i_crtime.tv_sec = 0;
-	ip->i_crtime.tv_nsec = 0;
+	libxfs_ifork_zap_attr(ip);
+
+	libxfs_trans_ijoin(tp, ip, 0);
+	libxfs_inode_init(tp, &args, ip);
 }
 
 static void
@@ -473,7 +482,6 @@ mk_rbmino(xfs_mount_t *mp)
 	int		error;
 	xfs_fileoff_t	bno;
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
-	int		times;
 	uint		blocks;
 
 	/*
@@ -490,34 +498,9 @@ mk_rbmino(xfs_mount_t *mp)
 			error);
 	}
 
-	reset_inode_fields(ip);
-
-	VFS_I(ip)->i_mode = S_IFREG;
-	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
-	libxfs_ifork_zap_attr(ip);
-
-	set_nlink(VFS_I(ip), 1);	/* account for sb ptr */
-
-	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
-	if (xfs_has_v3inodes(mp)) {
-		VFS_I(ip)->i_version = 1;
-		ip->i_diflags2 = 0;
-		times |= XFS_ICHGTIME_CREATE;
-	}
-	libxfs_trans_ichgtime(tp, ip, times);
-
-	/*
-	 * now the ifork
-	 */
-	ip->i_df.if_bytes = 0;
-	ip->i_df.if_u1.if_root = NULL;
-
+	/* Reset the realtime bitmap inode. */
+	reset_root_ino(tp, S_IFREG, ip);
 	ip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
-
-	/*
-	 * commit changes
-	 */
-	libxfs_trans_ijoin(tp, ip, 0);
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = -libxfs_trans_commit(tp);
 	if (error)
@@ -728,7 +711,6 @@ mk_rsumino(xfs_mount_t *mp)
 	int		nsumblocks;
 	xfs_fileoff_t	bno;
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
-	int		times;
 	uint		blocks;
 
 	/*
@@ -745,34 +727,9 @@ mk_rsumino(xfs_mount_t *mp)
 			error);
 	}
 
-	reset_inode_fields(ip);
-
-	VFS_I(ip)->i_mode = S_IFREG;
-	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
-	libxfs_ifork_zap_attr(ip);
-
-	set_nlink(VFS_I(ip), 1);	/* account for sb ptr */
-
-	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
-	if (xfs_has_v3inodes(mp)) {
-		VFS_I(ip)->i_version = 1;
-		ip->i_diflags2 = 0;
-		times |= XFS_ICHGTIME_CREATE;
-	}
-	libxfs_trans_ichgtime(tp, ip, times);
-
-	/*
-	 * now the ifork
-	 */
-	ip->i_df.if_bytes = 0;
-	ip->i_df.if_u1.if_root = NULL;
-
+	/* Reset the rt summary inode. */
+	reset_root_ino(tp, S_IFREG, ip);
 	ip->i_disk_size = mp->m_rsumsize;
-
-	/*
-	 * commit changes
-	 */
-	libxfs_trans_ijoin(tp, ip, 0);
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = -libxfs_trans_commit(tp);
 	if (error)
@@ -828,7 +785,6 @@ mk_root_dir(xfs_mount_t *mp)
 	int		error;
 	const mode_t	mode = 0755;
 	ino_tree_node_t	*irec;
-	int		times;
 
 	ip = NULL;
 	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 10, 0, 0, &tp);
@@ -840,37 +796,8 @@ mk_root_dir(xfs_mount_t *mp)
 		do_error(_("could not iget root inode -- error - %d\n"), error);
 	}
 
-	/*
-	 * take care of the core since we didn't call the libxfs ialloc function
-	 * (comment changed to avoid tangling xfs/437)
-	 */
-	reset_inode_fields(ip);
-
-	VFS_I(ip)->i_mode = mode|S_IFDIR;
-	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
-	libxfs_ifork_zap_attr(ip);
-
-	set_nlink(VFS_I(ip), 2);	/* account for . and .. */
-
-	times = XFS_ICHGTIME_CHG | XFS_ICHGTIME_MOD;
-	if (xfs_has_v3inodes(mp)) {
-		VFS_I(ip)->i_version = 1;
-		ip->i_diflags2 = 0;
-		times |= XFS_ICHGTIME_CREATE;
-	}
-	libxfs_trans_ichgtime(tp, ip, times);
-	libxfs_trans_ijoin(tp, ip, 0);
-	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
-
-	/*
-	 * now the ifork
-	 */
-	ip->i_df.if_bytes = 0;
-	ip->i_df.if_u1.if_root = NULL;
-
-	/*
-	 * initialize the directory
-	 */
+	/* Reset the root directory. */
+	reset_root_ino(tp, mode | S_IFDIR, ip);
 	libxfs_dir_init(tp, ip, ip);
 
 	error = -libxfs_trans_commit(tp);

