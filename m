Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5BC8F5E
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831568; cv=none; b=MGN1P1wdN/0ZKhhzf6vkBU8cnUw6flGrC2V5D9YUNm5G/6oOm0Eo0g07mLcG7rNQc50AJrIbaY4CzTaw/cWvfja777YylhmIixkDRLqBRMYmCdc0NUa5paB2v2pn+egqurq2WJIQLTZM5yB/5hwv8SO2xmBXnS/qluQGneXpOtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831568; c=relaxed/simple;
	bh=BgI7SK5WM+FUFqAyN1Cjk5W7GtVUS0Nx2+qzE+wk96U=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iBUcdXZvYiyF7ZSLiVFC6w1Y7L/mnJpxE0B5zyYx4963DXY9MDI7zkbp6ZxStuuaScWY5dtmH+7zqrxw2XGVAkJhaxvXlH2adfbIA9k7JbrNphmIc/iiaPGa9RqYaEb7AiaRcKJk8uNcQ9CA+I2j/hkIJE+5TgmF1yH5oT/8mLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lU6nXp5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lU6nXp5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF3B9C4CECD;
	Wed,  2 Oct 2024 01:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831567;
	bh=BgI7SK5WM+FUFqAyN1Cjk5W7GtVUS0Nx2+qzE+wk96U=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=lU6nXp5aK6L4J8qIZD5pttAoDHvnaWgHNWlv3anXAFZacJLg1RpDcJPe+j084ee7Z
	 N2nCbcSn9AJAVRH8Hv205g6LDtLyhtBqOEg4jzQdAIjNltzrZkAXRzwD5d5VUqCOmW
	 BCypDMT5lKJYLifqngGV+NXq1T5UglJUJUh0p6bEjrgF1v/+w7phXhGb36t4z5jm1/
	 SRotEj6LoMd9KE01aWR576h5pX+boPUNvyBQONtFAzq1VKDBDtR4U2mVGWjkwuapa4
	 3cCxVlwHaETeDNdBQgt8KWlMXdFiCjN6aoCWj+DCys8zcF5tUhu81tee7fkjAy2H48
	 s04NZhZoxdvUg==
Date: Tue, 01 Oct 2024 18:12:47 -0700
Subject: [PATCH 19/64] libxfs: remove libxfs_dir_ialloc
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <172783102067.4036371.13779727724559423333.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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
xfs_repair and xfs_db do not have useful cred and fsxattr structures so
they can call libxfs_dialloc and libxfs_icreate directly.  For mkfs
we'll move the guts of libxfs_dir_ialloc into proto.c as a creatproto
function that handles setting user/group ids, and move struct cred to
mkfs since it's now the only user.

This gets us ready to hoist the rest of the inode initialization code to
libxfs for metadata directories.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/iunlink.c             |   17 ++++++--
 include/xfs_inode.h      |   14 +------
 libxfs/inode.c           |   77 ------------------------------------
 libxfs/libxfs_api_defs.h |    1 
 mkfs/proto.c             |   98 +++++++++++++++++++++++++++++++++++++---------
 repair/phase6.c          |   60 +++++++++++++---------------
 6 files changed, 125 insertions(+), 142 deletions(-)


diff --git a/db/iunlink.c b/db/iunlink.c
index 3163036e6..fcc824d9a 100644
--- a/db/iunlink.c
+++ b/db/iunlink.c
@@ -312,10 +312,14 @@ static int
 create_unlinked(
 	struct xfs_mount	*mp)
 {
-	struct cred		cr = { };
-	struct fsxattr		fsx = { };
+	struct xfs_icreate_args	args = {
+		.idmap		= libxfs_nop_idmap,
+		.mode		= S_IFREG | 0600,
+		.flags		= XFS_ICREATE_TMPFILE,
+	};
 	struct xfs_inode	*ip;
 	struct xfs_trans	*tp;
+	xfs_ino_t		ino;
 	unsigned int		resblks;
 	int			error;
 
@@ -327,8 +331,13 @@ create_unlinked(
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
index d2f391ea8..1f9b07a53 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -399,17 +399,6 @@ static inline bool xfs_is_always_cow_inode(struct xfs_inode *ip)
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
 
@@ -419,6 +408,9 @@ extern int	libxfs_iflush_int (struct xfs_inode *, struct xfs_buf *);
 
 void libxfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
 
+int libxfs_icreate(struct xfs_trans *tp, xfs_ino_t ino,
+		const struct xfs_icreate_args *args, struct xfs_inode **ipp);
+
 /* Inode Cache Interfaces */
 extern int	libxfs_iget(struct xfs_mount *, struct xfs_trans *, xfs_ino_t,
 				uint, struct xfs_inode **);
diff --git a/libxfs/inode.c b/libxfs/inode.c
index dda9b778d..eb71f90bc 100644
--- a/libxfs/inode.c
+++ b/libxfs/inode.c
@@ -212,7 +212,7 @@ xfs_inode_init(
  * Initialise a newly allocated inode and return the in-core inode to the
  * caller locked exclusively.
  */
-static int
+int
 libxfs_icreate(
 	struct xfs_trans	*tp,
 	xfs_ino_t		ino,
@@ -302,81 +302,6 @@ libxfs_iflush_int(
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
-		.mode		= mode,
-	};
-	struct xfs_inode	*ip;
-	struct inode		*inode;
-	xfs_ino_t		parent_ino = dp ? dp->i_ino : 0;
-	xfs_ino_t		ino;
-	int			error;
-
-	if (dp && xfs_has_parent(dp->i_mount))
-		args.flags |= XFS_ICREATE_INIT_XATTRS;
-
-	/* Only devices get rdev numbers */
-	switch (mode & S_IFMT) {
-	case S_IFCHR:
-	case S_IFBLK:
-		args.rdev = rdev;
-		break;
-	}
-
-	/*
-	 * Call the space management code to pick the on-disk inode to be
-	 * allocated.
-	 */
-	error = xfs_dialloc(tpp, parent_ino, mode, &ino);
-	if (error)
-		return error;
-
-	error = libxfs_icreate(*tpp, ino, &args, &ip);
-	if (error)
-		return error;
-
-	inode = VFS_I(ip);
-	i_uid_write(inode, cr->cr_uid);
-	if (cr->cr_flags & CRED_FORCE_GID)
-		i_gid_write(inode, cr->cr_gid);
-	set_nlink(inode, nlink);
-
-	/* If there is no parent dir, initialize the file from fsxattr data. */
-	if (dp == NULL) {
-		ip->i_projid = fsx->fsx_projid;
-		ip->i_extsize = fsx->fsx_extsize;
-		ip->i_diflags = xfs_flags2diflags(ip, fsx->fsx_xflags);
-
-		if (xfs_has_v3inodes(ip->i_mount)) {
-			ip->i_diflags2 = xfs_flags2diflags2(ip,
-							fsx->fsx_xflags);
-			ip->i_cowextsize = fsx->fsx_cowextsize;
-		}
-	}
-
-	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
-	*ipp = ip;
-	return 0;
-}
-
 /*
  * Inode cache stubs.
  */
diff --git a/libxfs/libxfs_api_defs.h b/libxfs/libxfs_api_defs.h
index a507904f2..903f7dc69 100644
--- a/libxfs/libxfs_api_defs.h
+++ b/libxfs/libxfs_api_defs.h
@@ -117,6 +117,7 @@
 #define xfs_da_shrink_inode		libxfs_da_shrink_inode
 #define xfs_defer_cancel		libxfs_defer_cancel
 #define xfs_defer_finish		libxfs_defer_finish
+#define xfs_dialloc			libxfs_dialloc
 #define xfs_dinode_calc_crc		libxfs_dinode_calc_crc
 #define xfs_dinode_good_version		libxfs_dinode_good_version
 #define xfs_dinode_verify		libxfs_dinode_verify
diff --git a/mkfs/proto.c b/mkfs/proto.c
index 8e16eb150..58edc59f7 100644
--- a/mkfs/proto.c
+++ b/mkfs/proto.c
@@ -405,6 +405,70 @@ newpptr(
 	return ret;
 }
 
+struct cred {
+	uid_t			cr_uid;
+	gid_t			cr_gid;
+};
+
+static int
+creatproto(
+	struct xfs_trans	**tpp,
+	struct xfs_inode	*dp,
+	mode_t			mode,
+	xfs_dev_t		rdev,
+	struct cred		*cr,
+	struct fsxattr		*fsx,
+	struct xfs_inode	**ipp)
+{
+	struct xfs_icreate_args	args = {
+		.idmap		= libxfs_nop_idmap,
+		.pip		= dp,
+		.rdev		= rdev,
+		.mode		= mode,
+	};
+	struct xfs_inode	*ip;
+	struct inode		*inode;
+	xfs_ino_t		parent_ino = dp ? dp->i_ino : 0;
+	xfs_ino_t		ino;
+	int			error;
+
+	if (dp && xfs_has_parent(dp->i_mount))
+		args.flags |= XFS_ICREATE_INIT_XATTRS;
+
+	/*
+	 * Call the space management code to pick the on-disk inode to be
+	 * allocated.
+	 */
+	error = -libxfs_dialloc(tpp, parent_ino, mode, &ino);
+	if (error)
+		return error;
+
+	error = -libxfs_icreate(*tpp, ino, &args, &ip);
+	if (error)
+		return error;
+
+	inode = VFS_I(ip);
+	i_uid_write(inode, cr->cr_uid);
+	i_gid_write(inode, cr->cr_gid);
+
+	/* If there is no parent dir, initialize the file from fsxattr data. */
+	if (dp == NULL) {
+		ip->i_projid = fsx->fsx_projid;
+		ip->i_extsize = fsx->fsx_extsize;
+		ip->i_diflags = xfs_flags2diflags(ip, fsx->fsx_xflags);
+
+		if (xfs_has_v3inodes(ip->i_mount)) {
+			ip->i_diflags2 = xfs_flags2diflags2(ip,
+							fsx->fsx_xflags);
+			ip->i_cowextsize = fsx->fsx_cowextsize;
+		}
+	}
+
+	libxfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
+	*ipp = ip;
+	return 0;
+}
+
 static void
 parseproto(
 	xfs_mount_t	*mp,
@@ -505,7 +569,6 @@ parseproto(
 	mode |= val;
 	creds.cr_uid = (int)getnum(getstr(pp), 0, 0, false);
 	creds.cr_gid = (int)getnum(getstr(pp), 0, 0, false);
-	creds.cr_flags = CRED_FORCE_GID;
 	xname.name = (unsigned char *)name;
 	xname.len = name ? strlen(name) : 0;
 	xname.type = 0;
@@ -515,8 +578,8 @@ parseproto(
 		buf = newregfile(pp, &len);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
 		ppargs = newpptr(mp);
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
-					   &creds, fsxp, &ip);
+		error = creatproto(&tp, pip, mode | S_IFREG, 0, &creds, fsxp,
+				&ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
 		writefile(tp, ip, buf, len);
@@ -539,8 +602,8 @@ parseproto(
 		}
 		tp = getres(mp, XFS_B_TO_FSB(mp, llen));
 		ppargs = newpptr(mp);
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFREG, 1, 0,
-					  &creds, fsxp, &ip);
+		error = creatproto(&tp, pip, mode | S_IFREG, 0, &creds, fsxp,
+				&ip);
 		if (error)
 			fail(_("Inode pre-allocation failed"), error);
 
@@ -562,7 +625,7 @@ parseproto(
 		ppargs = newpptr(mp);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFBLK, 1,
+		error = creatproto(&tp, pip, mode | S_IFBLK,
 				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
 		if (error) {
 			fail(_("Inode allocation failed"), error);
@@ -578,7 +641,7 @@ parseproto(
 		ppargs = newpptr(mp);
 		majdev = getnum(getstr(pp), 0, 0, false);
 		mindev = getnum(getstr(pp), 0, 0, false);
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFCHR, 1,
+		error = creatproto(&tp, pip, mode | S_IFCHR,
 				IRIX_MKDEV(majdev, mindev), &creds, fsxp, &ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
@@ -591,8 +654,8 @@ parseproto(
 	case IF_FIFO:
 		tp = getres(mp, 0);
 		ppargs = newpptr(mp);
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFIFO, 1, 0,
-				&creds, fsxp, &ip);
+		error = creatproto(&tp, pip, mode | S_IFIFO, 0, &creds, fsxp,
+				&ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
 		libxfs_trans_ijoin(tp, pip, 0);
@@ -604,8 +667,8 @@ parseproto(
 		len = (int)strlen(buf);
 		tp = getres(mp, XFS_B_TO_FSB(mp, len));
 		ppargs = newpptr(mp);
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFLNK, 1, 0,
-				&creds, fsxp, &ip);
+		error = creatproto(&tp, pip, mode | S_IFLNK, 0, &creds, fsxp,
+				&ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
 		writesymlink(tp, ip, buf, len);
@@ -615,11 +678,10 @@ parseproto(
 		break;
 	case IF_DIRECTORY:
 		tp = getres(mp, 0);
-		error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFDIR, 1, 0,
-				&creds, fsxp, &ip);
+		error = creatproto(&tp, pip, mode | S_IFDIR, 0, &creds, fsxp,
+				&ip);
 		if (error)
 			fail(_("Inode allocation failed"), error);
-		libxfs_bumplink(tp, ip);		/* account for . */
 		if (!pip) {
 			pip = ip;
 			mp->m_sb.sb_rootino = ip->i_ino;
@@ -714,14 +776,13 @@ rtinit(
 
 	memset(&creds, 0, sizeof(creds));
 	memset(&fsxattrs, 0, sizeof(fsxattrs));
-	error = -libxfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
-					&creds, &fsxattrs, &rbmip);
+	error = creatproto(&tp, NULL, S_IFREG, 0, &creds, &fsxattrs, &rbmip);
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
@@ -731,8 +792,7 @@ rtinit(
 	libxfs_trans_log_inode(tp, rbmip, XFS_ILOG_CORE);
 	libxfs_log_sb(tp);
 	mp->m_rbmip = rbmip;
-	error = -libxfs_dir_ialloc(&tp, NULL, S_IFREG, 1, 0,
-					&creds, &fsxattrs, &rsumip);
+	error = creatproto(&tp, NULL, S_IFREG, 0, &creds, &fsxattrs, &rsumip);
 	if (error) {
 		fail(_("Realtime summary inode allocation failed"), error);
 	}
diff --git a/repair/phase6.c b/repair/phase6.c
index ad067ba0a..7a5694284 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -20,8 +20,6 @@
 #include "versions.h"
 #include "repair/pptr.h"
 
-static struct cred		zerocr;
-static struct fsxattr 		zerofsx;
 static xfs_ino_t		orphanage_ino;
 
 /*
@@ -891,20 +889,27 @@ mk_root_dir(xfs_mount_t *mp)
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
-	struct xfs_parent_args *ppargs = NULL;
+	struct xfs_icreate_args	args = {
+		.idmap		= libxfs_nop_idmap,
+		.mode		= S_IFDIR | 0755,
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
+	struct xfs_name		xname;
+	struct xfs_parent_args	*ppargs = NULL;
+
+	if (xfs_has_parent(mp))
+		args.flags |= XFS_ICREATE_INIT_XATTRS;
 
 	i = -libxfs_parent_start(mp, &ppargs);
 	if (i)
@@ -922,6 +927,7 @@ mk_orphanage(xfs_mount_t *mp)
 		do_error(_("%d - couldn't iget root inode to obtain %s\n"),
 			i, ORPHANAGE);
 
+	args.pip = pip;
 	xname.name = (unsigned char *)ORPHANAGE;
 	xname.len = strlen(ORPHANAGE);
 	xname.type = XFS_DIR3_FT_DIR;
@@ -939,23 +945,15 @@ mk_orphanage(xfs_mount_t *mp)
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
-	error = -libxfs_dir_ialloc(&tp, pip, mode|S_IFDIR,
-					1, 0, &zerocr, &zerofsx, &ip);
-	if (error) {
+	error = -libxfs_dialloc(&tp, mp->m_sb.sb_rootino, args.mode, &ino);
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
@@ -3344,8 +3342,6 @@ phase6(xfs_mount_t *mp)
 
 	parent_ptr_init(mp);
 
-	memset(&zerocr, 0, sizeof(struct cred));
-	memset(&zerofsx, 0, sizeof(struct fsxattr));
 	orphanage_ino = 0;
 
 	do_log(_("Phase 6 - check inode connectivity...\n"));

