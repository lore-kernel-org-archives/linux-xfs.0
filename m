Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23F7C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:09:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236166AbiLaCJi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiLaCJh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:09:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39329140F1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:09:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7820B81DFC
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2701C433D2;
        Sat, 31 Dec 2022 02:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452573;
        bh=LQqOvMlEi3PkCBFvlEluAMPPlFqrq368itpPuJd+jjY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RQP8SOR7HVtBVdBHWQ9Eeh2vUXZO55/UFpwTX8yP8e2jv8DH1z7a8ksMeQG8+vvWZ
         xZAKBwdo6rUCo9sgsbWnJzne6cpPvjQSAJSXI+zIRWQlwe2tzwnUFiEUHsDyFJX4bi
         ci3dxS/XqB54TU4gdwFQhfjCNdBFOcu8UxwokDX/cSpxN3p3hR5rQjWjFC6rUNyRYc
         prNpKzw5Iw/Up5bB+kwQdliW0Ove3x9tptzeXVKl4CFNTIErIXMhcxiioDDzzeE0XG
         9JCGykf9zHL/u8/rCgG9H6NW/S/Dnq+oFmcSLNadQU7yTepPqwFhOC89aN1KEmHhJa
         TGNW/yOAFpbwQ==
Subject: [PATCH 25/26] xfs_repair: use library functions to reset
 root/rbm/rsum inodes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:16 -0800
Message-ID: <167243875616.723621.2958131470455642479.stgit@magnolia>
In-Reply-To: <167243875315.723621.17759760420120912799.stgit@magnolia>
References: <167243875315.723621.17759760420120912799.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use the iroot reset function to reset root inodes instead of open-coding
the reset routine.  While we're at it, fix a longstanding memory leak if
the inode being reset actually had an xattr fork full of mappings.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    2 +
 repair/phase6.c          |  126 +++++++++-------------------------------------
 2 files changed, 28 insertions(+), 100 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 782a551ee1c..2b2b958d8a9 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -133,6 +133,7 @@
 #define xfs_dquot_verify		libxfs_dquot_verify
 
 #define xfs_finobt_calc_reserves	libxfs_finobt_calc_reserves
+#define xfs_fixed_inode_reset		libxfs_fixed_inode_reset
 #define xfs_free_extent			libxfs_free_extent
 #define xfs_free_perag			libxfs_free_perag
 #define xfs_fs_geometry			libxfs_fs_geometry
@@ -159,6 +160,7 @@
 #define xfs_inobt_stage_cursor		libxfs_inobt_stage_cursor
 #define xfs_inode_from_disk		libxfs_inode_from_disk
 #define xfs_inode_from_disk_ts		libxfs_inode_from_disk_ts
+#define xfs_inode_init			libxfs_inode_init
 #define xfs_inode_to_disk		libxfs_inode_to_disk
 #define xfs_inode_validate_cowextsize	libxfs_inode_validate_cowextsize
 #define xfs_inode_validate_extsize	libxfs_inode_validate_extsize
diff --git a/repair/phase6.c b/repair/phase6.c
index 0c24cfbf144..5765c2b1250 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -445,20 +445,28 @@ res_failed(
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
+	libxfs_icreate_args_rootfile(&args, mode);
+
+	/* Erase the attr fork since libxfs_inode_init won't do it for us. */
 	ip->i_forkoff = 0;
-	ip->i_diflags = 0;
-	ip->i_diflags2 = 0;
-	ip->i_crtime.tv_sec = 0;
-	ip->i_crtime.tv_nsec = 0;
+	libxfs_ifork_zap_attr(ip);
+
+	libxfs_inode_init(tp, &args, ip);
 }
 
 static void
@@ -472,7 +480,6 @@ mk_rbmino(xfs_mount_t *mp)
 	int		error;
 	xfs_fileoff_t	bno;
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
-	int		times;
 	uint		blocks;
 
 	/*
@@ -489,34 +496,9 @@ mk_rbmino(xfs_mount_t *mp)
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
@@ -711,7 +693,6 @@ mk_rsumino(xfs_mount_t *mp)
 	int		nsumblocks;
 	xfs_fileoff_t	bno;
 	xfs_bmbt_irec_t	map[XFS_BMAP_MAX_NMAP];
-	int		times;
 	uint		blocks;
 
 	/*
@@ -728,34 +709,9 @@ mk_rsumino(xfs_mount_t *mp)
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
@@ -811,7 +767,6 @@ mk_root_dir(xfs_mount_t *mp)
 	int		error;
 	const mode_t	mode = 0755;
 	ino_tree_node_t	*irec;
-	int		times;
 
 	ip = NULL;
 	i = -libxfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 10, 0, 0, &tp);
@@ -823,37 +778,8 @@ mk_root_dir(xfs_mount_t *mp)
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

