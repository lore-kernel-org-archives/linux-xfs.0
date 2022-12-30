Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9432DC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231473AbiLaCGq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbiLaCGo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:06:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BFE6241
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:06:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C244461CBE
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF92C433D2;
        Sat, 31 Dec 2022 02:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672452402;
        bh=6p/HQENhwwRwAc3lTMystmH8qmDZTk+GRDPJX/K5PO0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=NQhQAYcbQfe/oJS+uMNp2/QAcC++mgYdN+I9WNnumXjqny72oZdjLuytavBjgtTJB
         DOI3lGtNigWOO9n+xaf7DklHY/CdWWdY1nHnZCeB+L0P0XkLYn+MUw+84VwWbf9Juk
         mY/qjy83mPK6XHQKwo8D6ZodArC35dH40z8cptMVkmuQrWR1aJu8HKFYUBXg9je/dh
         HFwpRbCSp2+iKvPziPAu4jPMJ18AZ/q5FDH9OQG1GjeE6BPxdihIukNQfDOxZBgP3p
         byHBco1NNSMYQ2Y7hVDaujCKDgmrWf+EcFJ++05vdUJIpdQxflfdGxyFIg6V7Si1df
         RH3xUBKTAPvlw==
Subject: [PATCH 14/26] libxfs: remove libxfs_dir_ialloc
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:19:14 -0800
Message-ID: <167243875488.723621.14958888136379368561.stgit@magnolia>
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
 include/xfs_inode.h      |   15 ++-----
 libxfs/inode.c           |   79 ++++++++-------------------------------
 libxfs/libxfs_api_defs.h |    1 
 mkfs/proto.c             |   94 +++++++++++++++++++++++++++++++++++++---------
 repair/phase6.c          |   48 +++++++++++++----------
 5 files changed, 124 insertions(+), 113 deletions(-)


diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index 4e8a3dc6fd8..03add740fa7 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -268,17 +268,6 @@ static inline bool xfs_is_always_cow_inode(struct xfs_inode *ip)
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
 
@@ -286,6 +275,10 @@ extern void	libxfs_trans_ichgtime(struct xfs_trans *,
 				struct xfs_inode *, int);
 extern int	libxfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
 
+int libxfs_icreate(struct xfs_trans *tp, xfs_ino_t ino,
+		const struct xfs_icreate_args *args, struct xfs_inode **ipp);
+void libxfs_icreate_args_rootfile(struct xfs_icreate_args *args, umode_t mode);
+
 extern struct timespec64 current_time(struct inode *inode);
 
 /* Inode Cache Interfaces */
diff --git a/libxfs/inode.c b/libxfs/inode.c
index d311abafd79..c1fb622f306 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -179,7 +179,7 @@ xfs_inode_init(
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
  */
-static int
+int
 libxfs_icreate(
 	struct xfs_trans	*tp,
 	xfs_ino_t		ino,
@@ -198,6 +198,22 @@ libxfs_icreate(
 	return 0;
 }
 
+/* Set up inode attributes for newly created internal files. */
+void
+libxfs_icreate_args_rootfile(
+	struct xfs_icreate_args	*args,
+	umode_t			mode)
+{
+	args->mnt_userns = NULL;
+	args->uid = make_kuid(0);
+	args->gid = make_kgid(0);
+	args->prid = 0;
+	args->mode = mode;
+	args->flags = XFS_ICREATE_ARGS_FORCE_UID |
+		      XFS_ICREATE_ARGS_FORCE_GID |
+		      XFS_ICREATE_ARGS_FORCE_MODE;
+}
+
 /*
  * Writes a modified inode's changes out to the inode's on disk home.
  * Originally based on xfs_iflush_int() from xfs_inode.c in the kernel.
@@ -265,67 +281,6 @@ libxfs_iflush_int(
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
index 5752733a833..782a551ee1c 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -91,6 +91,7 @@
 #define xfs_da_shrink_inode		libxfs_da_shrink_inode
 #define xfs_defer_cancel		libxfs_defer_cancel
 #define xfs_defer_finish		libxfs_defer_finish
+#define xfs_dialloc			libxfs_dialloc
 #define xfs_dinode_calc_crc		libxfs_dinode_calc_crc
 #define xfs_dinode_good_version		libxfs_dinode_good_version
 #define xfs_dinode_verify		libxfs_dinode_verify
diff --git a/mkfs/proto.c b/mkfs/proto.c
index bd306f95568..b60def70652 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -351,6 +351,65 @@ newdirectory(
 		fail(_("directory create error"), error);
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
@@ -450,7 +509,6 @@ parseproto(
 	mode |= val;
 	creds.cr_uid = (int)getnum(getstr(pp), 0, 0, false);
 	creds.cr_gid = (int)getnum(getstr(pp), 0, 0, false);
-	creds.cr_flags = CRED_FORCE_GID;
 	xname.name = (unsigned char *)name;
 	xname.len = name ? strlen(name) : 0;
 	xname.type = 0;
@@ -459,8 +517,8 @@ parseproto(
 	case IF_REGULAR:
 		buf = newregfile(pp, &len);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
-					   &creds, fsxp, &ip);
+		error = creatproto(&tp, pip, mode | S_IFREG, 1, 0, &creds,
+				fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
 		writefile(tp, ip, buf, len);
@@ -483,8 +541,8 @@ parseproto(
 		}
 		tp = getres(mp, XFS_B_TO_FSB(mp, llen));
 
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
-					  &creds, fsxp, &ip);
+		error = creatproto(&tp, pip, mode | S_IFREG, 1, 0, &creds,
+				fsxp, &ip);
 		if (error)
 			fail(_("Inode pre-allocation failed"), error);
 
@@ -504,7 +562,7 @@ parseproto(
 		tp = getres(mp, 0);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFBLK, 1,
+		error = creatproto(&tp, pip, mode | S_IFBLK, 1,
 				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
 		if (error) {
 			fail(_("Inode allocation failed"), error);
@@ -519,7 +577,7 @@ parseproto(
 		tp = getres(mp, 0);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFCHR, 1,
+		error = creatproto(&tp, pip, mode | S_IFCHR, 1,
 				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
@@ -531,8 +589,8 @@ parseproto(
 
 	case IF_FIFO:
 		tp = getres(mp, 0);
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFIFO, 1, 0,
-				&creds, fsxp, &ip);
+		error = creatproto(&tp, pip, mode | S_IFIFO, 1, 0, &creds,
+				fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
@@ -543,8 +601,8 @@ parseproto(
 		buf = getstr(pp);
 		len = (int)strlen(buf);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFLNK, 1, 0,
-				&creds, fsxp, &ip);
+		error = creatproto(&tp, pip, mode | S_IFLNK, 1, 0, &creds,
+				fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
 		writesymlink(tp, ip, buf, len);
@@ -554,8 +612,8 @@ parseproto(
 		break;
 	case IF_DIRECTORY:
 		tp = getres(mp, 0);
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFDIR, 1, 0,
-				&creds, fsxp, &ip);
+		error = creatproto(&tp, pip, mode | S_IFDIR, 1, 0, &creds,
+				fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
 		inc_nlink(VFS_I(ip));		/* account for . */
@@ -646,14 +704,14 @@ rtinit(
 
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
@@ -663,8 +721,8 @@ rtinit(
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
index 75b0e06b31a..e7e2bf3f475 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -19,8 +19,6 @@
 #include "progress.h"
 #include "versions.h"
 
-static struct cred		zerocr;
-static struct fsxattr 		zerofsx;
 static xfs_ino_t		orphanage_ino;
 
 /*
@@ -873,19 +871,25 @@ mk_root_dir(xfs_mount_t *mp)
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
+
+	libxfs_icreate_args_rootfile(&args, mode);
 
 	/*
 	 * check for an existing lost+found first, if it exists, return
@@ -898,6 +902,7 @@ mk_orphanage(xfs_mount_t *mp)
 		do_error(_("%d - couldn't iget root inode to obtain %s\n"),
 			i, ORPHANAGE);
 
+	args.pip = pip;
 	xname.name = (unsigned char *)ORPHANAGE;
 	xname.len = strlen(ORPHANAGE);
 	xname.type = XFS_DIR3_FT_DIR;
@@ -922,14 +927,15 @@ mk_orphanage(xfs_mount_t *mp)
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
-	inc_nlink(VFS_I(ip));		/* account for . */
-	ino = ip->i_ino;
+
+	error = -libxfs_icreate(tp, ino, &args, &ip);
+	if (error)
+		do_error(_("%s inode initialization failed %d\n"),
+			ORPHANAGE, error);
 
 	irec = find_inode_rec(mp,
 			XFS_INO_TO_AGNO(mp, ino),
@@ -3207,8 +3213,6 @@ phase6(xfs_mount_t *mp)
 	ino_tree_node_t		*irec;
 	int			i;
 
-	memset(&zerocr, 0, sizeof(struct cred));
-	memset(&zerofsx, 0, sizeof(struct fsxattr));
 	orphanage_ino = 0;
 
 	do_log(_("Phase 6 - check inode connectivity...\n"));

