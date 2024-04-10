Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68445EC2
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712710959; cv=none; b=TJT8zoMjdRYC2zNEPMFapX/nU1IOuSapyBOEzPFLegpbsXzkxiqQeRul2p1UAxIUgOojCO22rBKocZcPu/ds22BxJOs6pm19pDZZIJiXjvIvbnn7ZdyYO56QKia0uT9s39TgEKSmfEFWODlshLyVdAKY8OtW61WSSzDHeXvfDHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712710959; c=relaxed/simple;
	bh=NeHtEgvVqOyxaPWjOAfw+wsV5WkN/y9mg1X24axCWk0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lDroYNjxTEgn5DK67k2bVFEoqaUf24B3CEN7PA3TomT6LJ8D1y1LfdwfPLJo3J4/Ewju4wSuOyDxCfUfkwuNXX/VnsOUh4iSCHaD1yXgOJo6gCJnRb8Wi1q6KNPfNeWtWUyihjd6ITMDMeFHEHCPzMgfeAVKqFPlVITBC2A8/IQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cj97Q2re; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cj97Q2re"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB2DC433F1;
	Wed, 10 Apr 2024 01:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712710958;
	bh=NeHtEgvVqOyxaPWjOAfw+wsV5WkN/y9mg1X24axCWk0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cj97Q2reOJSQ5HSRvhGcfGRVhfs7wxhOv7HFgpnwagdQGeDPkEVNkL89ZglUMS4WV
	 DyOyrVfumQdvjMm9YSYmBh9znV5/jR3C0aKH6H/VN9NWxG0V0puum5PXnFIP/8uull
	 /aw1MyoQceZXItdPQCWeE18L0pOvCxfggYgqHweXA9N/Lq+UYghuaQHu1Y8D+QrQoS
	 B1IW+33giuWOEH9qijT5oRmslxGL9pXaW6IlxWlVsR0Eq1hmJnv6gvmEQD0eCl4clv
	 pPij74XoTZesCmMQDDFBxxqq2vvIIUE4KJslbrCtrJp6xJRQqxi4qYVgxJsCwqj1xW
	 I4HN6hRuee81A==
Date: Tue, 09 Apr 2024 18:02:38 -0700
Subject: [PATCH 3/7] xfs: scrub parent pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270970517.3632713.14790309685305343360.stgit@frogsfrogsfrogs>
In-Reply-To: <171270970449.3632713.16827511408040390390.stgit@frogsfrogsfrogs>
References: <171270970449.3632713.16827511408040390390.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/parent.c |  367 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 367 insertions(+)


diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index acb6282c3d148..966e106c1fe6d 100644
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
@@ -197,6 +201,366 @@ xchk_parent_validate(
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
+	struct xfs_scrub		*sc,
+	struct xfs_inode		*ip,
+	unsigned int			attr_flags,
+	const unsigned char		*name,
+	unsigned int			namelen,
+	const void			*value,
+	unsigned int			valuelen,
+	void				*priv)
+{
+	struct xchk_pptrs		*pp = priv;
+	xfs_ino_t			parent_ino;
+	int				ret;
+
+	ret = xfs_parent_from_xattr(sc->mp, attr_flags, name, namelen,
+			value, valuelen, &parent_ino, NULL);
+	if (ret < 0)
+		return ret;
+
+	if (ret == 1 && pp->parent_ino == parent_ino)
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
+	error = xchk_xattr_walk(sc, sc->ip, xchk_parent_scan_dotdot, pp);
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
+	const struct xfs_name	*xname,
+	struct xfs_inode	*dp)
+{
+	struct xfs_scrub	*sc = pp->sc;
+	xfs_ino_t		child_ino;
+	int			error;
+
+	/*
+	 * Use the name attached to this parent pointer to look up the
+	 * directory entry in the alleged parent.
+	 */
+	error = xchk_dir_lookup(sc, dp, xname, &child_ino);
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
+	struct xchk_pptrs	*pp,
+	const struct xfs_parent_rec	*pptr,
+	struct xfs_inode	**dpp)
+{
+	struct xfs_scrub	*sc = pp->sc;
+	struct xfs_inode	*ip;
+	xfs_ino_t		parent_ino = be64_to_cpu(pptr->p_ino);
+	int			error;
+
+	/* Validate inode number. */
+	error = xfs_dir_ino_validate(sc->mp, parent_ino);
+	if (error) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return -ECANCELED;
+	}
+
+	error = xchk_iget(sc, parent_ino, &ip);
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
+	if (VFS_I(ip)->i_generation != be32_to_cpu(pptr->p_gen)) {
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
+	struct xfs_name		xname = {
+		.name		= name,
+		.len		= namelen,
+	};
+	struct xchk_pptrs	*pp = priv;
+	struct xfs_inode	*dp = NULL;
+	const struct xfs_parent_rec *pptr_rec = value;
+	xfs_ino_t		parent_ino;
+	unsigned int		lockmode;
+	int			ret;
+
+	ret = xfs_parent_from_xattr(sc->mp, attr_flags, name, namelen,
+			value, valuelen, &parent_ino, NULL);
+	if (ret < 0) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return -ECANCELED;
+	}
+	if (ret != 1)
+		return 0;
+
+	/* No self-referential parent pointers. */
+	if (parent_ino == sc->ip->i_ino) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return -ECANCELED;
+	}
+
+	pp->pptrs_found++;
+
+	ret = xchk_parent_iget(pp, pptr_rec, &dp);
+	if (ret)
+		return ret;
+	if (!dp)
+		return 0;
+
+	/* Try to lock the inode. */
+	lockmode = xchk_parent_lock_dir(sc, dp);
+	if (!lockmode) {
+		xchk_set_incomplete(sc);
+		ret = -ECANCELED;
+		goto out_rele;
+	}
+
+	ret = xchk_parent_dirent(pp, &xname, dp);
+	if (ret)
+		goto out_unlock;
+
+out_unlock:
+	xfs_iunlock(dp, lockmode);
+out_rele:
+	xchk_irele(sc, dp);
+	return ret;
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
@@ -206,6 +570,9 @@ xchk_parent(
 	xfs_ino_t		parent_ino;
 	int			error = 0;
 
+	if (xfs_has_parent(mp))
+		return xchk_parent_pptr(sc);
+
 	/*
 	 * If we're a directory, check that the '..' link points up to
 	 * a directory that has one entry pointing to us.

