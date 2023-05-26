Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3274FC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:15:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjEZCPZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:15:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229727AbjEZCPY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:15:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4ADD135
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:15:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59E026122B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:15:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCC31C433EF;
        Fri, 26 May 2023 02:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067321;
        bh=y5kX6E16xebkM21FTOZ5GSG8U7yJKC81uCkAuwZ1jDc=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=unn7XA2lZYo6cdqBO/GPxiOUDfB7uCURmbyVpdts65UN2rN/D/9XGl2K7strvvy6h
         o/P8VKXmSebJsk33j2gEvpYe/1sI00MUBg+0xcPSmFCAfEP3420aGROJ7ZiTQ34YZN
         wLvcQRFySxHFyrlNe0uviMGOnIgpvqbeNUEr+QdY85XcMteQcT+qcgRGI3aXKPKk0t
         ww3UzzKNkbGlPbNZyCPiL6Q9A5toBuLyDc/rddmGxwe/8YLFn2DTjbFBLR/zQGYZuG
         vbxI//4ysKY6x4uP6bERPk+cKJiKl4oR+igwhakZzi7b55M/yKdka+JBn7pFm4g5sD
         2+1bwCCpeHyxw==
Date:   Thu, 25 May 2023 19:15:21 -0700
Subject: [PATCH 03/17] xfs: scrub parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506073339.3745075.6501855510146805677.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
References: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Actually check parent pointers now.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/parent.c |  341 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 341 insertions(+)


diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 333a1c8d7062..6427f4f14022 100644
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
@@ -197,6 +201,340 @@ xchk_parent_validate(
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
+/* Look up the dotdot entry so that we can check it as we walk the pptrs. */
+STATIC int
+xchk_parent_dotdot(
+	struct xchk_pptrs	*pp)
+{
+	struct xfs_scrub	*sc = pp->sc;
+	int			error;
+
+	if (!S_ISDIR(VFS_I(sc->ip)->i_mode)) {
+		pp->parent_ino = NULLFSINO;
+		return 0;
+	}
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
+	if (sc->ip == sc->mp->m_rootip && sc->ip->i_ino != pp->parent_ino)
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
+
+	return 0;
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
+	/*
+	 * If we're scanning a directory, we should only ever encounter a
+	 * single parent pointer, and it should match the dotdot entry.  We set
+	 * the parent_ino from the dotdot entry before the scan, so compare it
+	 * now.
+	 */
+	if (!S_ISDIR(VFS_I(sc->ip)->i_mode))
+		return 0;
+
+	if (pp->parent_ino != dp->i_ino) {
+		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
+		return 0;
+	}
+
+	pp->parent_ino = NULLFSINO;
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
+	/* Ignore incomplete xattrs */
+	if (attr_flags & XFS_ATTR_INCOMPLETE)
+		return 0;
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
+	/*
+	 * Check all the parent pointers of this file, including the dotdot
+	 * entry if there is one.
+	 */
+	error = xchk_parent_dotdot(pp);
+	if (error)
+		goto out_pp;
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
+	 * If the parent pointers aren't corrupt, complain if the number of
+	 * parent pointers doesn't match the link count.
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
@@ -206,6 +544,9 @@ xchk_parent(
 	xfs_ino_t		parent_ino;
 	int			error = 0;
 
+	if (xfs_has_parent(mp))
+		return xchk_parent_pptr(sc);
+
 	/*
 	 * If we're a directory, check that the '..' link points up to
 	 * a directory that has one entry pointing to us.

