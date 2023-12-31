Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0198C2CC
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ii/rP9Js"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE15CC433C8;
	Sun, 31 Dec 2023 23:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065375;
	bh=fmEPu9V0E5wTOj2srj+Tyy87Fa+0W14gUAEbeCVkcbA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=ii/rP9JsPApj8Xqtlp6z/w55xcUpA/+7hBLKg7c4VCnFBnhU9iAs2cz6oJya6A78C
	 OdX4povokJcaBJ6Ztn8KVVUxwWYBqis31jWwd2SJLVkAQucWGsu2ARVNVwerTAkxMp
	 QjAqgr56opGBNpVW9O75ZQWYsMg8ZLObWGJvhWHpIWDmqsNI25vOnRm33JXSKfgCDs
	 EWJ1h+gAzEFqfe+rucEHCQkghc1d6MLNYWRSm/5GpluPAFhzjHsSCJGXQ/276LVHqi
	 Q4kc39KuTyIJSOva1QB89bf76BHJ8z47sBUqDI3r/ubcRgufHbnzLaeVarHJMozgk8
	 Qv1zhU4vUqa4g==
Date: Sun, 31 Dec 2023 15:29:35 -0800
Subject: [PATCH 28/28] xfs_repair: use library functions for orphanage
 creation
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009548.1808635.4399771188613950313.stgit@frogsfrogsfrogs>
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

Use new library functions to create lost+found.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/phase6.c          |   60 +++++++++++++++++-----------------------------
 2 files changed, 23 insertions(+), 38 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 72c6d65d75f..3ac0afec41f 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -134,6 +134,7 @@
 #define xfs_dir2_shrink_inode		libxfs_dir2_shrink_inode
 
 #define xfs_dir_createname		libxfs_dir_createname
+#define xfs_dir_create_child		libxfs_dir_create_child
 #define xfs_dir_init			libxfs_dir_init
 #define xfs_dir_ino_validate		libxfs_dir_ino_validate
 #define xfs_dir_lookup			libxfs_dir_lookup
diff --git a/repair/phase6.c b/repair/phase6.c
index 88f1b8f106e..6a3c5e2a37a 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -822,9 +822,15 @@ mk_orphanage(
 	struct xfs_icreate_args	args = {
 		.nlink		= 2,
 	};
+	struct xfs_name		xname = {
+		.name		= ORPHANAGE,
+		.len		= strlen(ORPHANAGE),
+		.type		= XFS_DIR3_FT_DIR,
+	};
+	struct xfs_dir_update	du = {
+		.name		= &xname,
+	};
 	struct xfs_trans	*tp;
-	struct xfs_inode	*ip;
-	struct xfs_inode	*pip;
 	struct ino_tree_node	*irec;
 	xfs_ino_t		ino;
 	int			ino_offset = 0;
@@ -832,10 +838,8 @@ mk_orphanage(
 	int			error;
 	int			nres;
 	const umode_t		mode = S_IFDIR | 0755;
-	struct xfs_name		xname;
-	struct xfs_parent_args	*ppargs;
 
-	i = -libxfs_parent_start(mp, &ppargs);
+	i = -libxfs_parent_start(mp, &du.ppargs);
 	if (i)
 		do_error(_("%d - couldn't allocate parent pointer for %s\n"),
 			i, ORPHANAGE);
@@ -848,17 +852,14 @@ mk_orphanage(
 	 * would have been cleared in phase3 and phase4.
 	 */
 
-	i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &pip);
+	i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &du.dp);
 	if (i)
 		do_error(_("%d - couldn't iget root inode to obtain %s\n"),
 			i, ORPHANAGE);
 
-	args.pip = pip;
-	xname.name = (unsigned char *)ORPHANAGE;
-	xname.len = strlen(ORPHANAGE);
-	xname.type = XFS_DIR3_FT_DIR;
+	args.pip = du.dp;
 
-	if (libxfs_dir_lookup(NULL, pip, &xname, &ino, NULL) == 0)
+	if (libxfs_dir_lookup(NULL, du.dp, &xname, &ino, NULL) == 0)
 		return ino;
 
 	/*
@@ -869,21 +870,12 @@ mk_orphanage(
 	if (i)
 		res_failed(i);
 
-	/*
-	 * use iget/ijoin instead of trans_iget because the ialloc
-	 * wrapper can commit the transaction and start a new one
-	 */
-/*	i = -libxfs_iget(mp, NULL, mp->m_sb.sb_rootino, 0, &pip);
-	if (i)
-		do_error(_("%d - couldn't iget root inode to make %s\n"),
-			i, ORPHANAGE);*/
-
 	error = -libxfs_dialloc(&tp, mp->m_sb.sb_rootino, mode, &ino);
 	if (error)
 		do_error(_("%s inode allocation failed %d\n"),
 			ORPHANAGE, error);
 
-	error = -libxfs_icreate(tp, ino, &args, &ip);
+	error = -libxfs_icreate(tp, ino, &args, &du.ip);
 	if (error)
 		do_error(_("%s inode initialization failed %d\n"),
 			ORPHANAGE, error);
@@ -921,46 +913,38 @@ mk_orphanage(
 	 * now that we know the transaction will stay around,
 	 * add the root inode to it
 	 */
-	libxfs_trans_ijoin(tp, pip, 0);
+	libxfs_trans_ijoin(tp, du.dp, 0);
 
 	/*
 	 * create the actual entry
 	 */
-	error = -libxfs_dir_createname(tp, pip, &xname, ip->i_ino, nres);
+	error = -libxfs_dir_create_child(tp, nres, &du);
 	if (error)
 		do_error(
 		_("can't make %s, createname error %d\n"),
 			ORPHANAGE, error);
-	add_parent_ptr(ip->i_ino, ORPHANAGE, pip);
 
-	error = -libxfs_parent_add(tp, ppargs, pip, &xname, ip);
-	if (error)
-		do_error(
- _("committing %s parent pointer failed, error %d.\n"),
-				ORPHANAGE, error);
+	/* Remember this for the pptr scan later */
+	add_parent_ptr(du.ip->i_ino, ORPHANAGE, du.dp);
 
 	/*
-	 * bump up the link count in the root directory to account
-	 * for .. in the new directory, and update the irec copy of the
+	 * We bumped up the link count in the root directory to account
+	 * for .. in the new directory, so now update the irec copy of the
 	 * on-disk nlink so we don't fail the link count check later.
 	 */
-	libxfs_bumplink(tp, pip);
 	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, mp->m_sb.sb_rootino),
 				  XFS_INO_TO_AGINO(mp, mp->m_sb.sb_rootino));
 	add_inode_ref(irec, 0);
 	set_inode_disk_nlinks(irec, 0, get_inode_disk_nlinks(irec, 0) + 1);
 
-	libxfs_trans_log_inode(tp, pip, XFS_ILOG_CORE);
-	libxfs_dir_init(tp, ip, pip);
-	libxfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = -libxfs_trans_commit(tp);
 	if (error) {
 		do_error(_("%s directory creation failed -- bmapf error %d\n"),
 			ORPHANAGE, error);
 	}
-	libxfs_irele(ip);
-	libxfs_irele(pip);
-	libxfs_parent_finish(mp, ppargs);
+	libxfs_irele(du.ip);
+	libxfs_irele(du.dp);
+	libxfs_parent_finish(mp, du.ppargs);
 
 	return(ino);
 }

