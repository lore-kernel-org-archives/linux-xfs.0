Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4992E55E41
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798544; cv=none; b=W+xsn5Qm9Mq83hUcoewqWkwcFWRTACkuxQKfs0bwQ3H4XSQPmP29/3IoinhjDBtrBzZUaUUx/D2dCzRPRlPB6ryq8kK3ZEWjVA0JE6e8/kPjM8pAybJqht+OXNjdz3O9v4aT5YM1xvokrA9El7LIkX6G10AeGpzsdA+zv7cek0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798544; c=relaxed/simple;
	bh=DFsEN+kMWF9xa9lAejan4dDw+nqwfuMkYCgtMmc6p2k=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T7t1KrQ0W6zn5c70/YXHgprORwFKRXX0mbkmmgJbP1eUakD12cfo1SjHiCkFglzzAk8GibYcPawYPyc9TEoIl8zdKvyL4nI+mCP3ECIEHv04T3ypDQncMs2cYXoJ1eQkqQhttbL3Afu02UDzgYNSiGoe8ZVtEXVf54BgXg13/2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P8oQ3vbq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P8oQ3vbq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79F8C433F1;
	Mon, 18 Mar 2024 21:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798542;
	bh=DFsEN+kMWF9xa9lAejan4dDw+nqwfuMkYCgtMmc6p2k=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=P8oQ3vbqV5gpud0lC2cJHfDQztkzadDMfio3SYYRUnKeOkeYqead+c3+xjD3HlXW3
	 ZXYtOCf5wwkWKhF3A1ugH46vI2DmLnZlDotgwc52FvUsTZETxgOAtoUwPHgZ1umzHc
	 VyWfYZGm4YhVTyjxFOMACNFmhx2U4N2nUznouf2v+qvr/c7/c7ZBM3KMjkx/y2LtDs
	 ZPjPn+TqA+kF2vxs0/D4BrReeyxYz1uF/89YAVZRWqRrmhwmU4h7ATKvUmCLswOdb5
	 8Ud8573v+FNJ/8lWSy/hVlNbiIAogZgIJU5DEkScQXkUjZw3+hKswVAnEjMG7kfQ8n
	 jhT/qQ+dpgv0Q==
Date: Mon, 18 Mar 2024 14:49:02 -0700
Subject: [PATCH 04/23] xfs: scrub parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802759.3808642.17539096119488882149.stgit@frogsfrogsfrogs>
In-Reply-To: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
References: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
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

Actually check parent pointers now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/parent.c |  385 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 385 insertions(+)


diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index acb6282c3d148..7a5c57cdf93e4 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -15,11 +15,15 @@
 #include "xfs_icache.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_attr.h"
+#include "xfs_parent.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/readdir.h"
 #include "scrub/tempfile.h"
 #include "scrub/repair.h"
+#include "scrub/listxattr.h"
+#include "scrub/trace.h"
 
 /* Set us up to scrub parents. */
 int
@@ -197,6 +201,384 @@ xchk_parent_validate(
 	return error;
 }
 
+/*
+ * Checking of Parent Pointers
+ * ===========================
+ *
+ * On filesystems with directory parent pointers, we check the referential
+ * integrity by visiting each parent pointer of a child file and checking that
+ * the directory referenced by the pointer actually has a dirent pointing
+ * forward to the child file.
+ */
+
+struct xchk_pptrs {
+	struct xfs_scrub	*sc;
+
+	/* Scratch buffer for scanning pptr xattrs */
+	struct xfs_parent_name_irec pptr;
+
+	/* How many parent pointers did we find at the end? */
+	unsigned long long	pptrs_found;
+
+	/* Parent of this directory. */
+	xfs_ino_t		parent_ino;
+};
+
+/* Does this parent pointer match the dotdot entry? */
+STATIC int
+xchk_parent_scan_dotdot(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	const struct xfs_parent_name_irec *pptr,
+	void			*priv)
+{
+	struct xchk_pptrs	*pp = priv;
+
+	if (pp->parent_ino == pptr->p_ino &&
+	    xfs_parent_verify_irec(sc->mp, pptr))
+		return -ECANCELED;
+
+	return 0;
+}
+
+/* Look up the dotdot entry so that we can check it as we walk the pptrs. */
+STATIC int
+xchk_parent_pptr_and_dotdot(
+	struct xchk_pptrs	*pp)
+{
+	struct xfs_scrub	*sc = pp->sc;
+	int			error;
+
+	/* Look up '..' */
+	error = xchk_dir_lookup(sc, sc->ip, &xfs_name_dotdot, &pp->parent_ino);
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error))
+		return error;
+	if (!xfs_verify_dir_ino(sc->mp, pp->parent_ino)) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		return 0;
+	}
+
+	/* Is this the root dir?  Then '..' must point to itself. */
+	if (sc->ip == sc->mp->m_rootip) {
+		if (sc->ip->i_ino != pp->parent_ino)
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+		return 0;
+	}
+
+	/*
+	 * If this is now an unlinked directory, the dotdot value is
+	 * meaningless as long as it points to a valid inode.
+	 */
+	if (VFS_I(sc->ip)->i_nlink == 0)
+		return 0;
+
+	if (pp->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return 0;
+
+	/* Otherwise, walk the pptrs again, and check. */
+	error = xchk_pptr_walk(sc, sc->ip, xchk_parent_scan_dotdot, &pp->pptr,
+			pp);
+	if (error == -ECANCELED) {
+		/* Found a parent pointer that matches dotdot. */
+		return 0;
+	}
+	if (!error || error == -EFSCORRUPTED) {
+		/* Found a broken parent pointer or no match. */
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return 0;
+	}
+	return error;
+}
+
+/*
+ * Try to lock a parent directory for checking dirents.  Returns the inode
+ * flags for the locks we now hold, or zero if we failed.
+ */
+STATIC unsigned int
+xchk_parent_lock_dir(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp)
+{
+	if (!xfs_ilock_nowait(dp, XFS_IOLOCK_SHARED))
+		return 0;
+
+	if (!xfs_ilock_nowait(dp, XFS_ILOCK_SHARED)) {
+		xfs_iunlock(dp, XFS_IOLOCK_SHARED);
+		return 0;
+	}
+
+	if (!xfs_need_iread_extents(&dp->i_df))
+		return XFS_IOLOCK_SHARED | XFS_ILOCK_SHARED;
+
+	xfs_iunlock(dp, XFS_ILOCK_SHARED);
+
+	if (!xfs_ilock_nowait(dp, XFS_ILOCK_EXCL)) {
+		xfs_iunlock(dp, XFS_IOLOCK_SHARED);
+		return 0;
+	}
+
+	return XFS_IOLOCK_SHARED | XFS_ILOCK_EXCL;
+}
+
+/* Check the forward link (dirent) associated with this parent pointer. */
+STATIC int
+xchk_parent_dirent(
+	struct xchk_pptrs	*pp,
+	struct xfs_inode	*dp)
+{
+	struct xfs_name		xname = {
+		.name		= pp->pptr.p_name,
+		.len		= pp->pptr.p_namelen,
+	};
+	struct xfs_scrub	*sc = pp->sc;
+	xfs_ino_t		child_ino;
+	int			error;
+
+	/*
+	 * Use the name attached to this parent pointer to look up the
+	 * directory entry in the alleged parent.
+	 */
+	error = xchk_dir_lookup(sc, dp, &xname, &child_ino);
+	if (error == -ENOENT) {
+		xchk_fblock_xref_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return 0;
+	}
+	if (!xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0, &error))
+		return error;
+
+	/* Does the inode number match? */
+	if (child_ino != sc->ip->i_ino) {
+		xchk_fblock_xref_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return 0;
+	}
+
+	return 0;
+}
+
+/* Try to grab a parent directory. */
+STATIC int
+xchk_parent_iget(
+	struct xchk_pptrs		*pp,
+	struct xfs_inode		**dpp)
+{
+	struct xfs_scrub		*sc = pp->sc;
+	struct xfs_inode		*ip;
+	int				error;
+
+	/* Validate inode number. */
+	error = xfs_dir_ino_validate(sc->mp, pp->pptr.p_ino);
+	if (error) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return -ECANCELED;
+	}
+
+	error = xchk_iget(sc, pp->pptr.p_ino, &ip);
+	if (error == -EINVAL || error == -ENOENT) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return -ECANCELED;
+	}
+	if (!xchk_fblock_xref_process_error(sc, XFS_ATTR_FORK, 0, &error))
+		return error;
+
+	/* The parent must be a directory. */
+	if (!S_ISDIR(VFS_I(ip)->i_mode)) {
+		xchk_fblock_xref_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		goto out_rele;
+	}
+
+	/* Validate generation number. */
+	if (VFS_I(ip)->i_generation != pp->pptr.p_gen) {
+		xchk_fblock_xref_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		goto out_rele;
+	}
+
+	*dpp = ip;
+	return 0;
+out_rele:
+	xchk_irele(sc, ip);
+	return 0;
+}
+
+/*
+ * Walk an xattr of a file.  If this xattr is a parent pointer, follow it up
+ * to a parent directory and check that the parent has a dirent pointing back
+ * to us.
+ */
+STATIC int
+xchk_parent_scan_attr(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	void			*priv)
+{
+	struct xfs_name		dname = {
+		.name		= value,
+		.len		= valuelen,
+	};
+	struct xchk_pptrs	*pp = priv;
+	struct xfs_inode	*dp = NULL;
+	const struct xfs_parent_name_rec *rec = (const void *)name;
+	unsigned int		lockmode;
+	xfs_dahash_t		computed_hash;
+	int			error;
+
+	/* Ignore anything that isn't a parent pointer. */
+	if (!(attr_flags & XFS_ATTR_PARENT))
+		return 0;
+
+	/* Does the ondisk parent pointer structure make sense? */
+	if (!xfs_parent_namecheck(sc->mp, rec, namelen, attr_flags)) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return -ECANCELED;
+	}
+
+	if (!xfs_parent_valuecheck(sc->mp, value, valuelen)) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return -ECANCELED;
+	}
+
+	xfs_parent_irec_from_disk(&pp->pptr, rec, value, valuelen);
+
+	if (!xfs_parent_verify_irec(sc->mp, &pp->pptr)) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return -ECANCELED;
+	}
+
+	/* No self-referential parent pointers. */
+	if (pp->pptr.p_ino == sc->ip->i_ino) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return -ECANCELED;
+	}
+
+	/*
+	 * If the namehash of the dirent name encoded in the parent pointer
+	 * attr value doesn't match the namehash in the parent pointer key,
+	 * the parent pointer is corrupt.
+	 */
+	computed_hash = xfs_dir2_hashname(ip->i_mount, &dname);
+	if (pp->pptr.p_namehash != computed_hash) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return -ECANCELED;
+	}
+	pp->pptrs_found++;
+
+	error = xchk_parent_iget(pp, &dp);
+	if (error)
+		return error;
+	if (!dp)
+		return 0;
+
+	/* Try to lock the inode. */
+	lockmode = xchk_parent_lock_dir(sc, dp);
+	if (!lockmode) {
+		xchk_set_incomplete(sc);
+		error = -ECANCELED;
+		goto out_rele;
+	}
+
+	error = xchk_parent_dirent(pp, dp);
+	if (error)
+		goto out_unlock;
+
+out_unlock:
+	xfs_iunlock(dp, lockmode);
+out_rele:
+	xchk_irele(sc, dp);
+	return error;
+}
+
+/*
+ * Compare the number of parent pointers to the link count.  For
+ * non-directories these should be the same.  For unlinked directories the
+ * count should be zero; for linked directories, it should be nonzero.
+ */
+STATIC int
+xchk_parent_count_pptrs(
+	struct xchk_pptrs	*pp)
+{
+	struct xfs_scrub	*sc = pp->sc;
+
+	if (S_ISDIR(VFS_I(sc->ip)->i_mode)) {
+		if (sc->ip == sc->mp->m_rootip)
+			pp->pptrs_found++;
+
+		if (VFS_I(sc->ip)->i_nlink == 0 && pp->pptrs_found > 0)
+			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		else if (VFS_I(sc->ip)->i_nlink > 0 &&
+			 pp->pptrs_found == 0)
+			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+	} else {
+		if (VFS_I(sc->ip)->i_nlink != pp->pptrs_found)
+			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+	}
+
+	return 0;
+}
+
+/* Check parent pointers of a file. */
+STATIC int
+xchk_parent_pptr(
+	struct xfs_scrub	*sc)
+{
+	struct xchk_pptrs	*pp;
+	int			error;
+
+	pp = kvzalloc(sizeof(struct xchk_pptrs), XCHK_GFP_FLAGS);
+	if (!pp)
+		return -ENOMEM;
+	pp->sc = sc;
+
+	error = xchk_xattr_walk(sc, sc->ip, xchk_parent_scan_attr, pp);
+	if (error == -ECANCELED) {
+		error = 0;
+		goto out_pp;
+	}
+	if (error)
+		goto out_pp;
+
+	if (pp->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out_pp;
+
+	/*
+	 * For subdirectories, make sure the dotdot entry references the same
+	 * inode as the parent pointers.
+	 *
+	 * If we're scanning a /consistent/ directory, there should only be
+	 * one parent pointer, and it should point to the same directory as
+	 * the dotdot entry.
+	 *
+	 * However, a corrupt directory tree might feature a subdirectory with
+	 * multiple parents.  The directory loop scanner is responsible for
+	 * correcting that kind of problem, so for now we only validate that
+	 * the dotdot entry matches /one/ of the parents.
+	 */
+	if (S_ISDIR(VFS_I(sc->ip)->i_mode)) {
+		error = xchk_parent_pptr_and_dotdot(pp);
+		if (error)
+			goto out_pp;
+	}
+
+	if (pp->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		goto out_pp;
+
+	/*
+	 * Complain if the number of parent pointers doesn't match the link
+	 * count.  This could be a sign of missing parent pointers (or an
+	 * incorrect link count).
+	 */
+	error = xchk_parent_count_pptrs(pp);
+	if (error)
+		goto out_pp;
+
+out_pp:
+	kvfree(pp);
+	return error;
+}
+
 /* Scrub a parent pointer. */
 int
 xchk_parent(
@@ -206,6 +588,9 @@ xchk_parent(
 	xfs_ino_t		parent_ino;
 	int			error = 0;
 
+	if (xfs_has_parent(mp))
+		return xchk_parent_pptr(sc);
+
 	/*
 	 * If we're a directory, check that the '..' link points up to
 	 * a directory that has one entry pointing to us.

