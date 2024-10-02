Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B8055227
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727832394; cv=none; b=CgcK89g2Kt+WVTiGS7rZWI7FL++71B6O1XZTgKxYx8/6lbwbo/j85cZQ2GjUy6ss/XWhp7/4cZ6Yo9h9sML/Ak9waBt1HEl2hnla+IyiDxL62wO27XknxSG+lvwCdeO2uNRj7z+p19Dg38TqvJNBSWgNpJCqgTkk59UOnm9yKnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727832394; c=relaxed/simple;
	bh=17xRBm9NEQC/bwtFPZTggGZ5uQqd40Bo4mSA5sCX8Hw=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lGyG8IAf2p6UG8iJbuk4Um4Z9nfVmda7sdT5VZDmjT133GAj4dA7L2ymv7f0CUBCrPKootWJwKYCliQP7J0F1x//bKJ2iJLLTo96zAXVD8If0T7RLrQ/PRSUSwxeqSaroJQqdoOnsmLV8iF4UioBBKcyuZUdmFpr0HYI0/bUwMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C76nSkLU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C76nSkLU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667F6C4CEC6;
	Wed,  2 Oct 2024 01:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727832394;
	bh=17xRBm9NEQC/bwtFPZTggGZ5uQqd40Bo4mSA5sCX8Hw=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=C76nSkLULRErh4+a23WeVXJXX8yLmuyy0UlESnUZSqe/2K/4G5YCAAUFIxRggZFLR
	 YtiyamUByekyZ+GoB+1OSRx9nZeFFquJbKoLAwkY009dgU3BJjFVtjgfMCJznAEHg/
	 XJL1/9z6PXHGqshoeonEo84J4R+fPkftlf5dUczi+uIOY2KrG1PKwquqvy8ICWY18Z
	 4MmEbUCcPDky9F89QTS9uGh5ezyPm5OX0uq9NbBRBYoB3aELZIIc975Znt1U7KauIG
	 11efxJEBL7rJL3/l5eGNcBQZIBrbTUh8+mX2EQ5AwoU2xT5P8Hx3Y8oMdYFbctWs7F
	 qHjEh4C7Fb1bA==
Date: Tue, 01 Oct 2024 18:26:34 -0700
Subject: [PATCH 4/4] xfs_repair: use library functions for orphanage creation
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783103438.4038674.13322754481588384282.stgit@frogsfrogsfrogs>
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

Use new library functions to create lost+found.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/libxfs_api_defs.h |    1 +
 repair/phase6.c          |   53 ++++++++++++++++++----------------------------
 2 files changed, 22 insertions(+), 32 deletions(-)


diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index ee9794782..a4173e5f7 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -148,6 +148,7 @@
 #define xfs_dir2_shrink_inode		libxfs_dir2_shrink_inode
 
 #define xfs_dir_createname		libxfs_dir_createname
+#define xfs_dir_create_child		libxfs_dir_create_child
 #define xfs_dir_init			libxfs_dir_init
 #define xfs_dir_ino_validate		libxfs_dir_ino_validate
 #define xfs_dir_lookup			libxfs_dir_lookup
diff --git a/repair/phase6.c b/repair/phase6.c
index 2c4f23010..ba28edaa4 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -826,19 +826,23 @@ mk_orphanage(
 		.idmap		= libxfs_nop_idmap,
 		.mode		= S_IFDIR | 0755,
 	};
+	struct xfs_name		xname = {
+		.name		= (unsigned char *)ORPHANAGE,
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
 	int			i;
 	int			error;
 	int			nres;
-	struct xfs_name		xname;
-	struct xfs_parent_args	*ppargs = NULL;
 
-	i = -libxfs_parent_start(mp, &ppargs);
+	i = -libxfs_parent_start(mp, &du.ppargs);
 	if (i)
 		do_error(_("%d - couldn't allocate parent pointer for %s\n"),
 			i, ORPHANAGE);
@@ -849,18 +853,15 @@ mk_orphanage(
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
 
 	/* If the lookup of /lost+found succeeds, return the inumber. */
-	error = -libxfs_dir_lookup(NULL, pip, &xname, &ino, NULL);
+	error = -libxfs_dir_lookup(NULL, du.dp, &xname, &ino, NULL);
 	if (error == 0)
 		goto out_pip;
 
@@ -877,7 +878,7 @@ mk_orphanage(
 		do_error(_("%s inode allocation failed %d\n"),
 			ORPHANAGE, error);
 
-	error = -libxfs_icreate(tp, ino, &args, &ip);
+	error = -libxfs_icreate(tp, ino, &args, &du.ip);
 	if (error)
 		do_error(_("%s inode initialization failed %d\n"),
 			ORPHANAGE, error);
@@ -915,49 +916,37 @@ mk_orphanage(
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
-	add_parent_ptr(ip->i_ino, (unsigned char *)ORPHANAGE, pip, false);
-
-	if (ppargs) {
-		error = -libxfs_parent_addname(tp, ppargs, pip, &xname, ip);
-		if (error)
-			do_error(
- _("can't make %s, parent addname error %d\n"),
-					ORPHANAGE, error);
-	}
+	add_parent_ptr(du.ip->i_ino, (unsigned char *)ORPHANAGE, du.dp, false);
 
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
+	libxfs_irele(du.ip);
 out_pip:
-	libxfs_irele(pip);
-	libxfs_parent_finish(mp, ppargs);
+	libxfs_irele(du.dp);
+	libxfs_parent_finish(mp, du.ppargs);
 
 	return(ino);
 }

