Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7068C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjDFT13 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjDFT12 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:27:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2F4B72A6
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:27:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5F98B63D38
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF937C433EF;
        Thu,  6 Apr 2023 19:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809245;
        bh=AYvyoXQYNQdNMEOarCFIaHGmGY1nUmDECMZr+R2TRyI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=Pn5tGHaY1Jx0hBn849kXKukG2lHZXUoxqWrCtfcwpZbbDsidAuCditm0e3cNei039
         bcVj8G1FFRxsL9Gz5triNp14elDW/GTnFV2aOIDg3fzd8y7P5+xDric5fnqZYu0M2O
         /UykvOHXFdTK96qHchbFWRJHdxXVA85/wBTfTjOJ02o0t+sPFpq3oNumabUdaR/1l4
         QfcZoIZhf420exjp+L4f52OFAMLc84FRKT/Khp7wcON/V/XOaVEP/rnRD317sKjcjB
         dBnGu71TLWTFfFjzKfUP+SFLZyZY2HXTtPR7tUWyW12/J2yVrxm387azOBEmdCGs/o
         jxs5bwzC6zwIw==
Date:   Thu, 06 Apr 2023 12:27:25 -0700
Subject: [PATCH 1/2] xfs: scrub parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080825637.615905.7214919759779348522.stgit@frogsfrogsfrogs>
In-Reply-To: <168080825622.615905.7017300233071761636.stgit@frogsfrogsfrogs>
References: <168080825622.615905.7017300233071761636.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/parent.c |  280 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 280 insertions(+)


diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index d59184a59671..02938a1fcd47 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -14,9 +14,13 @@
 #include "xfs_icache.h"
 #include "xfs_dir2.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_attr.h"
+#include "xfs_parent.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/readdir.h"
+#include "scrub/listxattr.h"
+#include "scrub/trace.h"
 
 /* Set us up to scrub parents. */
 int
@@ -231,6 +235,8 @@ xchk_parent_validate(
 	return error;
 }
 
+STATIC int xchk_parent_pptr(struct xfs_scrub *sc);
+
 /* Scrub a parent pointer. */
 int
 xchk_parent(
@@ -240,6 +246,9 @@ xchk_parent(
 	xfs_ino_t		parent_ino;
 	int			error;
 
+	if (xfs_has_parent(mp))
+		return xchk_parent_pptr(sc);
+
 	/*
 	 * If we're a directory, check that the '..' link points up to
 	 * a directory that has one entry pointing to us.
@@ -282,3 +291,274 @@ xchk_parent(
 
 	return xchk_parent_validate(sc, parent_ino);
 }
+
+/*
+ * Checking of Parent Pointers
+ * ===========================
+ *
+ * On filesystems with directory parent pointers, we check the referential
+ * integrity by visiting each parent pointer of a child file and checking that
+ * the directory referenced by the pointer actually has a dirent pointing back
+ * to the child file.
+ */
+
+struct xchk_pptrs {
+	struct xfs_scrub	*sc;
+
+	/* Scratch buffer for scanning pptr xattrs */
+	struct xfs_parent_name_irec pptr;
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
+	struct xchk_pptrs	*pp = priv;
+	struct xfs_inode	*dp = NULL;
+	const struct xfs_parent_name_rec *rec = (const void *)name;
+	unsigned int		lockmode;
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
+out_pp:
+	kvfree(pp);
+	return error;
+}

