Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E6446BA
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832379; cv=none; b=hqNNm372hFs66pBCRvXa1XUYrqxgFs3LBA6/9PtDMeynoy0dJsLnveobXQ2M5GZJ4NdbsxPEkZDG3jaShWhNC9mzDrJlAfnefjaosUktktA3un650N++35Tma59yyUKKLiLmEcGsQ/JRbnrjyxJubkORhw+q9IK+5HD37StJTwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832379; c=relaxed/simple;
	bh=FVZUC0SSQE3SCnLB66FJ4fLYiTCLqvyftZPxrrIHmEs=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G3oddj87alZT+IWY5DBtO9tAL8I6rjDgGvAGNIdJOGukgPTjH+axMbT8MMQejUrfDG0w/h07qerpSGx7OoxJ9/XxSTCrux3bp2FLMRwNvWxPvErR2tI1hZj51i/+8U7uweypEKCqK32amlNx6tgpzSsgDrAEdtRPddXwYKrqUwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aV2aeW6k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aV2aeW6k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2ADC4CECD;
	Wed,  2 Oct 2024 01:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832378;
	bh=FVZUC0SSQE3SCnLB66FJ4fLYiTCLqvyftZPxrrIHmEs=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=aV2aeW6k2Z0qsSHJz6vSMFm8ObWDhJMF3HiRlAqiLWNEy+FlC0ujol6SK2RyeGSux
	 w/hd19eHU5KN7djVoN+Uloe4HUXkfksYM3qEZi4wpai/ROsI0/xowlJJfkyO/r07QF
	 GwWG29wjQ2GuA73h5ifAf+N4HkYIlQqMk9LRgf6APE96kc7/mpxGYOJxmIDSwWpubI
	 7cM8gu/ag0toAUlS6js4nc7EYb1rP2k2+sZXLGwyWfrxl67ht/wH9G2PHo0Erz5ZgZ
	 4LP+m1OT0JM7LxKHzXIGy/+0bSVyGyK5y/3r5rvfKl6MQVIvYbA16PvDAR64XiNpHB
	 BEGo/Tx45BP1A==
Date: Tue, 01 Oct 2024 18:26:18 -0700
Subject: [PATCH 3/4] xfs_repair: use library functions to reset root/rbm/rsum
 inodes
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783103423.4038674.11965044394724233118.stgit@frogsfrogsfrogs>
In-Reply-To: <172783103374.4038674.1366196250873191221.stgit@frogsfrogsfrogs>
References: <172783103374.4038674.1366196250873191221.stgit@frogsfrogsfrogs>
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
 libxfs/libxfs_api_defs.h |    1 
 repair/phase6.c          |  129 ++++++++++------------------------------------
 2 files changed, 30 insertions(+), 100 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index a51c14a27..ee9794782 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -192,6 +192,7 @@
 #define xfs_inode_from_disk		libxfs_inode_from_disk
 #define xfs_inode_from_disk_ts		libxfs_inode_from_disk_ts
 #define xfs_inode_hasattr		libxfs_inode_hasattr
+#define xfs_inode_init			libxfs_inode_init
 #define xfs_inode_to_disk		libxfs_inode_to_disk
 #define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
 #define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
diff --git a/repair/phase6.c b/repair/phase6.c
index 85f122ec7..2c4f23010 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -447,20 +447,31 @@ res_failed(
 		do_error(_("xfs_trans_reserve returned %d\n"), err);
 }
 
-static inline void
-reset_inode_fields(struct xfs_inode *ip)
+/*
+ * Forcibly reinitialize a file that is a child of the superblock and has a
+ * statically defined inumber.  These files are the root of a directory tree or
+ * the realtime free space inodes.  The inode must not otherwise be in use; the
+ * data fork must be empty, and the attr fork will be reset.
+ */
+static void
+reset_sbroot_ino(
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
+		.idmap		= libxfs_nop_idmap,
+		.mode		= mode,
+		/* Root directories cannot be linked to a parent. */
+		.flags		= XFS_ICREATE_UNLINKABLE,
+	};
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
@@ -474,7 +485,6 @@ mk_rbmino(xfs_mount_t *mp)
 	int		error;
 	xfs_fileoff_t	bno;
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
-	int		times;
 	uint		blocks;
 
 	/*
@@ -491,34 +501,9 @@ mk_rbmino(xfs_mount_t *mp)
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
-	ip->i_df.if_data = NULL;
-
+	/* Reset the realtime bitmap inode. */
+	reset_sbroot_ino(tp, S_IFREG, ip);
 	ip->i_disk_size = mp->m_sb.sb_rbmblocks * mp->m_sb.sb_blocksize;
-
-	/*
-	 * commit changes
-	 */
-	libxfs_trans_ijoin(tp, ip, 0);
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = -libxfs_trans_commit(tp);
 	if (error)
@@ -729,7 +714,6 @@ mk_rsumino(xfs_mount_t *mp)
 	int		nsumblocks;
 	xfs_fileoff_t	bno;
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
-	int		times;
 	uint		blocks;
 
 	/*
@@ -746,34 +730,9 @@ mk_rsumino(xfs_mount_t *mp)
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
-	ip->i_df.if_data = NULL;
-
+	/* Reset the rt summary inode. */
+	reset_sbroot_ino(tp, S_IFREG, ip);
 	ip->i_disk_size = mp->m_rsumsize;
-
-	/*
-	 * commit changes
-	 */
-	libxfs_trans_ijoin(tp, ip, 0);
 	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = -libxfs_trans_commit(tp);
 	if (error)
@@ -829,7 +788,6 @@ mk_root_dir(xfs_mount_t *mp)
 	int		error;
 	const mode_t	mode = 0755;
 	ino_tree_node_t	*irec;
-	int		times;
 
 	ip = NULL;
 	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 10, 0, 0, &tp);
@@ -841,37 +799,8 @@ mk_root_dir(xfs_mount_t *mp)
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
-	ip->i_df.if_data = NULL;
-
-	/*
-	 * initialize the directory
-	 */
+	/* Reset the root directory. */
+	reset_sbroot_ino(tp, mode | S_IFDIR, ip);
 	libxfs_dir_init(tp, ip, ip);
 
 	error = -libxfs_trans_commit(tp);

