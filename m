Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4751C2C5
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:25:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WSIXeogO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B3DC433C7;
	Sun, 31 Dec 2023 23:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065157;
	bh=nLxQ2PsIh4AmZC0hFjE+zdRP84bJliw4Y1vWIAAR4MM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WSIXeogOrFwPnQOUrL6Y/zZige60J9ZqBpX0O3i2GACYKPvJZzvGkeD8Eo1yB4oT9
	 vz28gB45vNorMymBOY4DrejnHEsmNYHWQbtTGd9jIxY96Bn6DR+s5iZXLoYco7WFfP
	 z91w4WI2XfxdwPcDh8OMWcLXXsrxtiiqEMtAGcMntP4VqAVTScWf2V4Z8p8wWvpx81
	 PXBw002M9TTBVy2nxqcuG58FbDN6wTLNyp4TFN7rTo3NuUuHTqG1GgOVSSncfiTg+d
	 cP4Es6OeZESUQiV8MDD4/6xcuXZepAVhPTSO40+yQ0aQ0M7AhpIk+6A3QdVorn2S3c
	 s/vbhP0Eej16g==
Date: Sun, 31 Dec 2023 15:25:56 -0800
Subject: [PATCH 14/28] libxfs: remove libxfs_dir_ialloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009363.1808635.14074101153027501414.stgit@frogsfrogsfrogs>
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

This function no longer exists in the kernel, and it's not really needed
in userspace either.  There are two users of it: repair and mkfs.
Repair passes in zeroed cred and fsxattr structures so it can call
libxfs_dialloc and libxfs_icreate directly.  For mkfs we'll move the
guts of libxfs_dir_ialloc into proto.c as a creatproto function that
takes care of all that, and move struct cred to mkfs since it's now the
only user.

This gets us ready to hoist the rest of the inode initialization code to
libxfs for metadata directories.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/iunlink.c             |   18 +++++++--
 include/xfs_inode.h      |   16 ++------
 libxfs/inode.c           |   86 ++++++++++-------------------------------
 libxfs/libxfs_api_defs.h |    1 
 mkfs/proto.c             |   97 +++++++++++++++++++++++++++++++++++++---------
 repair/phase6.c          |   50 +++++++++++++-----------
 6 files changed, 147 insertions(+), 121 deletions(-)


diff --git a/db/iunlink.c b/db/iunlink.c
index d87562e3b0a..af452d028bd 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -309,10 +309,15 @@ static int
 create_unlinked(
 	struct xfs_mount	*mp)
 {
-	struct cred		cr = { };
-	struct fsxattr		fsx = { };
+	struct xfs_icreate_args	args = {
+		.mode		= S_IFREG | 0600,
+		.flags		= XFS_ICREATE_ARGS_FORCE_UID |
+				  XFS_ICREATE_ARGS_FORCE_GID |
+				  XFS_ICREATE_ARGS_FORCE_MODE,
+	};
 	struct xfs_inode	*ip;
 	struct xfs_trans	*tp;
+	xfs_ino_t		ino;
 	unsigned int		resblks;
 	int			error;
 
@@ -324,8 +329,13 @@ create_unlinked(
 		return error;
 	}
 
-	error = -libxfs_dir_ialloc(&tp, NULL, S_IFREG | 0600, 0, 0, &cr, &fsx,
-			&ip);
+	error = -libxfs_dialloc(&tp, 0, args.mode, &ino);
+	if (error) {
+		dbprintf(_("alloc inode: %s\n"), strerror(error));
+		goto out_cancel;
+	}
+
+	error = -libxfs_icreate(tp, ino, &args, &ip);
 	if (error) {
 		dbprintf(_("create inode: %s\n"), strerror(error));
 		goto out_cancel;
diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 45d53d1eb00..e0bf5dcc2c2 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -371,17 +371,6 @@ static inline bool xfs_is_always_cow_inode(struct xfs_inode *ip)
 	return false;
 }
 
-/* Always set the child's GID to this value, even if the parent is setgid. */
-#define CRED_FORCE_GID	(1U << 0)
-struct cred {
-	uid_t		cr_uid;
-	gid_t		cr_gid;
-	unsigned int	cr_flags;
-};
-
-extern int	libxfs_dir_ialloc (struct xfs_trans **, struct xfs_inode *,
-				mode_t, nlink_t, xfs_dev_t, struct cred *,
-				struct fsxattr *, struct xfs_inode **);
 extern void	libxfs_trans_inode_alloc_buf (struct xfs_trans *,
 				struct xfs_buf *);
 
@@ -391,6 +380,11 @@ extern int	libxfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
 
 void libxfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
 
+int libxfs_icreate(struct xfs_trans *tp, xfs_ino_t ino,
+		const struct xfs_icreate_args *args, struct xfs_inode **ipp);
+void libxfs_icreate_args_rootfile(struct xfs_icreate_args *args,
+		struct xfs_mount *mp, umode_t mode, bool init_xattrs);
+
 /* Inode Cache Interfaces */
 extern int	libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 				uint, struct xfs_inode **);
diff --git a/libxfs/inode.c b/libxfs/inode.c
index 3d92e888a16..17bdc0bffb2 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -193,7 +193,7 @@ xfs_inode_init(
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
  */
-static int
+int
 libxfs_icreate(
 	struct xfs_trans	*tp,
 	xfs_ino_t		ino,
@@ -216,6 +216,26 @@ libxfs_icreate(
 	return 0;
 }
 
+/* Set up inode attributes for newly created internal files. */
+void
+libxfs_icreate_args_rootfile(
+	struct xfs_icreate_args	*args,
+	struct xfs_mount	*mp,
+	umode_t			mode,
+	bool			init_xattrs)
+{
+	args->idmap = NULL;
+	args->uid = make_kuid(0);
+	args->gid = make_kgid(0);
+	args->prid = 0;
+	args->mode = mode;
+	args->flags = XFS_ICREATE_ARGS_FORCE_UID |
+		      XFS_ICREATE_ARGS_FORCE_GID |
+		      XFS_ICREATE_ARGS_FORCE_MODE;
+	if (init_xattrs)
+		args->flags |= XFS_ICREATE_ARGS_INIT_XATTRS;
+}
+
 /*
  * Writes a modified inode's changes out to the inode's on disk home.
  * Originally based on xfs_iflush_int() from xfs_inode.c in the kernel.
@@ -283,70 +303,6 @@ libxfs_iflush_int(
 	return 0;
 }
 
-/*
- * Wrapper around call to libxfs_ialloc. Takes care of committing and
- * allocating a new transaction as needed.
- *
- * Originally there were two copies of this code - one in mkfs, the
- * other in repair - now there is just the one.
- */
-int
-libxfs_dir_ialloc(
-	struct xfs_trans	**tpp,
-	struct xfs_inode	*dp,
-	mode_t			mode,
-	nlink_t			nlink,
-	xfs_dev_t		rdev,
-	struct cred		*cr,
-	struct fsxattr		*fsx,
-	struct xfs_inode	**ipp)
-{
-	struct xfs_icreate_args	args = {
-		.pip		= dp,
-		.uid		= make_kuid(cr->cr_uid),
-		.gid		= make_kgid(cr->cr_gid),
-		.prid		= dp ? libxfs_get_initial_prid(dp) : 0,
-		.nlink		= nlink,
-		.rdev		= rdev,
-		.mode		= mode,
-		.flags		= XFS_ICREATE_ARGS_FORCE_UID |
-				  XFS_ICREATE_ARGS_FORCE_GID |
-				  XFS_ICREATE_ARGS_FORCE_MODE,
-	};
-	struct xfs_inode	*ip;
-	xfs_ino_t		parent_ino = dp ? dp->i_ino : 0;
-	xfs_ino_t		ino;
-	int			error;
-
-	if (dp && xfs_has_parent(dp->i_mount))
-		args.flags |= XFS_ICREATE_ARGS_INIT_XATTRS;
-
-	/*
-	 * Call the space management code to pick the on-disk inode to be
-	 * allocated.
-	 */
-	error = xfs_dialloc(tpp, parent_ino, mode, &ino);
-	if (error)
-		return error;
-
-	error = libxfs_icreate(*tpp, ino, &args, ipp);
-	if (error || dp)
-		return error;
-
-	/* If there is no parent dir, initialize the file from fsxattr data. */
-	ip = *ipp;
-	ip->i_projid = fsx->fsx_projid;
-	ip->i_extsize = fsx->fsx_extsize;
-	ip->i_diflags = xfs_flags2diflags(ip, fsx->fsx_xflags);
-
-	if (xfs_has_v3inodes(ip->i_mount)) {
-		ip->i_diflags2 = xfs_flags2diflags2(ip, fsx->fsx_xflags);
-		ip->i_cowextsize = fsx->fsx_cowextsize;
-	}
-	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
-	return 0;
-}
-
 /*
  * Inode cache stubs.
  */
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index 575bf45a211..7e4d4c008cf 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -101,6 +101,7 @@
 #define xfs_da_shrink_inode		libxfs_da_shrink_inode
 #define xfs_defer_cancel		libxfs_defer_cancel
 #define xfs_defer_finish		libxfs_defer_finish
+#define xfs_dialloc			libxfs_dialloc
 #define xfs_dinode_calc_crc		libxfs_dinode_calc_crc
 #define xfs_dinode_good_version		libxfs_dinode_good_version
 #define xfs_dinode_verify		libxfs_dinode_verify
diff --git a/mkfs/proto.c b/mkfs/proto.c
index cc06bdfaf57..bb262390536 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -402,6 +402,68 @@ newpptr(
 	return ret;
 }
 
+struct cred {
+	uid_t		cr_uid;
+	gid_t		cr_gid;
+};
+
+static int
+creatproto(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*dp,
+	mode_t			mode,
+	nlink_t			nlink,
+	xfs_dev_t		rdev,
+	struct cred		*cr,
+	struct fsxattr		*fsx,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_icreate_args	args = {
+		.pip		= dp,
+		.uid		= make_kuid(cr->cr_uid),
+		.gid		= make_kgid(cr->cr_gid),
+		.prid		= dp ? libxfs_get_initial_prid(dp) : 0,
+		.nlink		= nlink,
+		.rdev		= rdev,
+		.mode		= mode,
+		.flags		= XFS_ICREATE_ARGS_FORCE_UID |
+				  XFS_ICREATE_ARGS_FORCE_GID |
+				  XFS_ICREATE_ARGS_FORCE_MODE,
+	};
+	struct xfs_inode	*ip;
+	xfs_ino_t		parent_ino = dp ? dp->i_ino : 0;
+	xfs_ino_t		ino;
+	int			error;
+
+	if (dp && xfs_has_parent(dp->i_mount))
+		args.flags |= XFS_ICREATE_ARGS_INIT_XATTRS;
+
+	/*
+	 * Call the space management code to pick the on-disk inode to be
+	 * allocated.
+	 */
+	error = -libxfs_dialloc(tpp, parent_ino, mode, &ino);
+	if (error)
+		return error;
+
+	error = -libxfs_icreate(*tpp, ino, &args, ipp);
+	if (error || dp)
+		return error;
+
+	/* If there is no parent dir, initialize the file from fsxattr data. */
+	ip = *ipp;
+	ip->i_projid = fsx->fsx_projid;
+	ip->i_extsize = fsx->fsx_extsize;
+	ip->i_diflags = xfs_flags2diflags(ip, fsx->fsx_xflags);
+
+	if (xfs_has_v3inodes(ip->i_mount)) {
+		ip->i_diflags2 = xfs_flags2diflags2(ip, fsx->fsx_xflags);
+		ip->i_cowextsize = fsx->fsx_cowextsize;
+	}
+	libxfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
+	return 0;
+}
+
 static void
 parseproto(
 	xfs_mount_t	*mp,
@@ -502,7 +564,6 @@ parseproto(
 	mode |= val;
 	creds.cr_uid = (int)getnum(getstr(pp), 0, 0, false);
 	creds.cr_gid = (int)getnum(getstr(pp), 0, 0, false);
-	creds.cr_flags = CRED_FORCE_GID;
 	xname.name = (unsigned char *)name;
 	xname.len = name ? strlen(name) : 0;
 	xname.type = 0;
@@ -512,8 +573,8 @@ parseproto(
 		buf = newregfile(pp, &len);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
 		ppargs = newpptr(mp);
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
-					   &creds, fsxp, &ip);
+		error = creatproto(&tp, pip, mode | S_IFREG, 1, 0, &creds,
+				fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
 		writefile(tp, ip, buf, len);
@@ -536,8 +597,8 @@ parseproto(
 		}
 		tp = getres(mp, XFS_B_TO_FSB(mp, llen));
 		ppargs = newpptr(mp);
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
-					  &creds, fsxp, &ip);
+		error = creatproto(&tp, pip, mode | S_IFREG, 1, 0, &creds,
+				fsxp, &ip);
 		if (error)
 			fail(_("Inode pre-allocation failed"), error);
 
@@ -559,7 +620,7 @@ parseproto(
 		ppargs = newpptr(mp);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFBLK, 1,
+		error = creatproto(&tp, pip, mode | S_IFBLK, 1,
 				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
 		if (error) {
 			fail(_("Inode allocation failed"), error);
@@ -575,7 +636,7 @@ parseproto(
 		ppargs = newpptr(mp);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFCHR, 1,
+		error = creatproto(&tp, pip, mode | S_IFCHR, 1,
 				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
@@ -588,8 +649,8 @@ parseproto(
 	case IF_FIFO:
 		tp = getres(mp, 0);
 		ppargs = newpptr(mp);
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFIFO, 1, 0,
-				&creds, fsxp, &ip);
+		error = creatproto(&tp, pip, mode | S_IFIFO, 1, 0, &creds,
+				fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
@@ -601,8 +662,8 @@ parseproto(
 		len = (int)strlen(buf);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
 		ppargs = newpptr(mp);
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFLNK, 1, 0,
-				&creds, fsxp, &ip);
+		error = creatproto(&tp, pip, mode | S_IFLNK, 1, 0, &creds,
+				fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
 		writesymlink(tp, ip, buf, len);
@@ -612,8 +673,8 @@ parseproto(
 		break;
 	case IF_DIRECTORY:
 		tp = getres(mp, 0);
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFDIR, 1, 0,
-				&creds, fsxp, &ip);
+		error = creatproto(&tp, pip, mode | S_IFDIR, 1, 0, &creds,
+				fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
 		libxfs_bumplink(tp, ip);		/* account for . */
@@ -711,14 +772,14 @@ rtinit(
 
 	memset(&creds, 0, sizeof(creds));
 	memset(&fsxattrs, 0, sizeof(fsxattrs));
-	error = -libxfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
-					&creds, &fsxattrs, &rbmip);
+	error = creatproto(&tp, NULL, S_IFREG, 1, 0, &creds, &fsxattrs,
+			&rbmip);
 	if (error) {
 		fail(_("Realtime bitmap inode allocation failed"), error);
 	}
 	/*
 	 * Do our thing with rbmip before allocating rsumip,
-	 * because the next call to ialloc() may
+	 * because the next call to createproto may
 	 * commit the transaction in which rbmip was allocated.
 	 */
 	mp->m_sb.sb_rbmino = rbmip->i_ino;
@@ -728,8 +789,8 @@ rtinit(
 	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
 	libxfs_log_sb(tp);
 	mp->m_rbmip = rbmip;
-	error = -libxfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
-					&creds, &fsxattrs, &rsumip);
+	error = creatproto(&tp, NULL, S_IFREG, 1, 0, &creds, &fsxattrs,
+			&rsumip);
 	if (error) {
 		fail(_("Realtime summary inode allocation failed"), error);
 	}
diff --git a/repair/phase6.c b/repair/phase6.c
index 5e95dabbe09..51e1ea92dd6 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -20,8 +20,6 @@
 #include "versions.h"
 #include "repair/pptr.h"
 
-static struct cred		zerocr;
-static struct fsxattr 		zerofsx;
 static xfs_ino_t		orphanage_ino;
 
 /*
@@ -890,26 +888,32 @@ mk_root_dir(xfs_mount_t *mp)
  * orphanage name == lost+found
  */
 static xfs_ino_t
-mk_orphanage(xfs_mount_t *mp)
+mk_orphanage(
+	struct xfs_mount	*mp)
 {
-	xfs_ino_t	ino;
-	xfs_trans_t	*tp;
-	xfs_inode_t	*ip;
-	xfs_inode_t	*pip;
-	ino_tree_node_t	*irec;
-	int		ino_offset = 0;
-	int		i;
-	int		error;
-	const int	mode = 0755;
-	int		nres;
-	struct xfs_name	xname;
-	struct xfs_parent_args *ppargs;
+	struct xfs_icreate_args	args = {
+		.nlink		= 2,
+	};
+	struct xfs_trans	*tp;
+	struct xfs_inode	*ip;
+	struct xfs_inode	*pip;
+	struct ino_tree_node	*irec;
+	xfs_ino_t		ino;
+	int			ino_offset = 0;
+	int			i;
+	int			error;
+	int			nres;
+	const umode_t		mode = S_IFDIR | 0755;
+	struct xfs_name		xname;
+	struct xfs_parent_args	*ppargs;
 
 	i = -libxfs_parent_start(mp, &ppargs);
 	if (i)
 		do_error(_("%d - couldn't allocate parent pointer for %s\n"),
 			i, ORPHANAGE);
 
+	libxfs_icreate_args_rootfile(&args, mp, mode, xfs_has_parent(mp));
+
 	/*
 	 * check for an existing lost+found first, if it exists, return
 	 * its inode. Otherwise, we can create it. Bad lost+found inodes
@@ -921,6 +925,7 @@ mk_orphanage(xfs_mount_t *mp)
 		do_error(_("%d - couldn't iget root inode to obtain %s\n"),
 			i, ORPHANAGE);
 
+	args.pip = pip;
 	xname.name = (unsigned char *)ORPHANAGE;
 	xname.len = strlen(ORPHANAGE);
 	xname.type = XFS_DIR3_FT_DIR;
@@ -945,14 +950,15 @@ mk_orphanage(xfs_mount_t *mp)
 		do_error(_("%d - couldn't iget root inode to make %s\n"),
 			i, ORPHANAGE);*/
 
-	error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFDIR,
-					1, 0, &zerocr, &zerofsx, &ip);
-	if (error) {
+	error = -libxfs_dialloc(&tp, mp->m_sb.sb_rootino, mode, &ino);
+	if (error)
 		do_error(_("%s inode allocation failed %d\n"),
 			ORPHANAGE, error);
-	}
-	libxfs_bumplink(tp, ip);		/* account for . */
-	ino = ip->i_ino;
+
+	error = -libxfs_icreate(tp, ino, &args, &ip);
+	if (error)
+		do_error(_("%s inode initialization failed %d\n"),
+			ORPHANAGE, error);
 
 	irec = find_inode_rec(mp,
 			XFS_INO_TO_AGNO(mp, ino),
@@ -3331,8 +3337,6 @@ phase6(xfs_mount_t *mp)
 
 	parent_ptr_init(mp);
 
-	memset(&zerocr, 0, sizeof(struct cred));
-	memset(&zerofsx, 0, sizeof(struct fsxattr));
 	orphanage_ino = 0;
 
 	do_log(_("Phase 6 - check inode connectivity...\n"));

