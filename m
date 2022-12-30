Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 278BEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:02:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235846AbiLaACV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235871AbiLaACI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:02:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1BB14D14
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:02:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C89761CBA
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A005C433D2;
        Sat, 31 Dec 2022 00:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444925;
        bh=L96SDaMSnUvOdHGTqNBeKorxAphfLXx3t61Eejhfm4A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Tpqhrt+JoqzS2ufST8BkVT1InY+Lxl5pakQ3zrPUp61fkFsVIm8s41m2KRPzAV42Q
         f9YuVmHWKMuEfqipXHL2FBDlgrXJHx3MoB+8Evi8gxB/dnm6kbckiDmyz3tD2cBgnT
         7BQ2nUjmUPNw2okWKmjZ+hhNLlbScE+c9HPQb0vPYFrwx9/wM8ZVAJkncdfCibVrZw
         MPuIJQzfMhdIOzanhEmPIQhEA/3aZ9V+Cp2DW6rXfUYxep2ZB09pkG/440doPBImiL
         q0gq7XND/umjzUiNwQZ+5J52h5d0zfhSvf+otk7F8hHNa8yzIXcWY0BqdcnRkqJw/S
         Rkxz7SGjFPf7Q==
Subject: [PATCH 1/3] xfs: move orphan files to the orphanage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:19 -0800
Message-ID: <167243845982.700780.13801792170323010188.stgit@magnolia>
In-Reply-To: <167243845965.700780.5558696077743355523.stgit@magnolia>
References: <167243845965.700780.5558696077743355523.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we can't find a parent for a file, move it to the orphanage.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile              |    1 
 fs/xfs/scrub/dir_repair.c    |  101 ++++++++++
 fs/xfs/scrub/orphanage.c     |  414 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/orphanage.h     |   79 ++++++++
 fs/xfs/scrub/parent.c        |   10 +
 fs/xfs/scrub/parent_repair.c |   92 +++++++++
 fs/xfs/scrub/repair.h        |    2 
 fs/xfs/scrub/scrub.c         |    2 
 fs/xfs/scrub/scrub.h         |    4 
 fs/xfs/scrub/trace.h         |    1 
 fs/xfs/xfs_inode.c           |    6 -
 fs/xfs/xfs_inode.h           |    1 
 12 files changed, 707 insertions(+), 6 deletions(-)
 create mode 100644 fs/xfs/scrub/orphanage.c
 create mode 100644 fs/xfs/scrub/orphanage.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 5e9ffd9f1583..6d6ca775553f 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -197,6 +197,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   inode_repair.o \
 				   newbt.o \
 				   nlinks_repair.o \
+				   orphanage.o \
 				   parent_repair.o \
 				   rcbag_btree.o \
 				   rcbag.o \
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 871b14c09e86..7530819e1435 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -40,6 +40,7 @@
 #include "scrub/readdir.h"
 #include "scrub/reap.h"
 #include "scrub/parent.h"
+#include "scrub/orphanage.h"
 
 /*
  * Directory Repair
@@ -91,9 +92,15 @@ struct xrep_dir {
 	/* nlink value of the corrected directory. */
 	xfs_nlink_t		new_nlink;
 
+	/* Should we move this directory to the orphanage? */
+	bool			move_orphanage;
+
 	/* Preallocated args struct for performing dir operations */
 	struct xfs_da_args	args;
 
+	/* Orphanage reparinting request. */
+	struct xrep_orphanage_req adoption;
+
 	/* Directory entry name, plus the trailing null. */
 	char			namebuf[MAXNAMELEN];
 };
@@ -108,6 +115,10 @@ xrep_setup_directory(
 {
 	int			error;
 
+	error = xrep_orphanage_try_create(sc);
+	if (error)
+		return error;
+
 	error = xrep_tempfile_create(sc, S_IFDIR);
 	if (error)
 		return error;
@@ -1088,8 +1099,76 @@ xrep_dir_find_parent(
 	if (rd->parent_ino != NULLFSINO)
 		return 0;
 
-	/* NOTE: A future patch will deal with moving orphans. */
-	return -EFSCORRUPTED;
+	/*
+	 * Temporarily assign the root dir as the parent; we'll move this to
+	 * the orphanage after swapping the dir contents.
+	 */
+	rd->move_orphanage = true;
+	rd->parent_ino = rd->sc->mp->m_sb.sb_rootino;
+	return 0;
+}
+
+/*
+ * Move the current file to the orphanage.
+ *
+ * Caller must hold IOLOCK_EXCL on @sc->ip, and no other inode locks.  Upon
+ * successful return, the scrub transaction will have enough extra reservation
+ * to make the move; it will hold IOLOCK_EXCL and ILOCK_EXCL of @sc->ip and the
+ * orphanage; and both inodes will be ijoined.
+ */
+STATIC int
+xrep_dir_move_to_orphanage(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	int			error;
+
+	/* No orphanage?  We can't fix this. */
+	if (!sc->orphanage)
+		return -EFSCORRUPTED;
+
+	/* If we can take the orphanage's iolock then we're ready to move. */
+	if (!xrep_orphanage_ilock_nowait(sc, XFS_IOLOCK_EXCL)) {
+		xfs_ino_t	orig_parent, new_parent;
+
+		/*
+		 * We may have to drop the lock on sc->ip to try to lock the
+		 * orphanage.  Therefore, look up the old dotdot entry for
+		 * sc->ip so that we can compare it after we re-lock sc->ip.
+		 */
+		orig_parent = xrep_dotdot_lookup(sc);
+
+		xchk_iunlock(sc, sc->ilock_flags);
+		error = xrep_orphanage_iolock_two(sc);
+		if (error)
+			return error;
+
+		/*
+		 * If the parent changed or the child was unlinked while the
+		 * child directory was unlocked, we don't need to move the
+		 * child to the orphanage after all.
+		 */
+		new_parent = xrep_dotdot_lookup(sc);
+
+		if (orig_parent != new_parent || VFS_I(sc->ip)->i_nlink == 0)
+			return 0;
+	}
+
+	/*
+	 * Move the directory to the orphanage, and let scrub teardown unlock
+	 * everything for us.
+	 */
+	xrep_orphanage_compute_blkres(sc, &rd->adoption);
+
+	error = xrep_orphanage_compute_name(&rd->adoption, rd->namebuf);
+	if (error)
+		return error;
+
+	error = xrep_orphanage_adoption_prep(&rd->adoption);
+	if (error)
+		return error;
+
+	return xrep_orphanage_adopt(&rd->adoption);
 }
 
 /*
@@ -1167,6 +1246,24 @@ xrep_directory(
 
 	/* Swap in the good contents. */
 	error = xrep_dir_rebuild_tree(rd);
+	if (error || !rd->move_orphanage)
+		goto out_rd;
+
+	/*
+	 * We hold ILOCK_EXCL on both the directory and the tempdir after a
+	 * successful rebuild.  Before we can move the directory to the
+	 * orphanage, we must roll to a clean unjoined transaction and drop the
+	 * ILOCKs on the dir and the temp dir.  We still hold IOLOCK_EXCL on
+	 * the dir, so nobody will be able to access it in the mean time.
+	 */
+	error = xfs_trans_roll(&sc->tp);
+	if (error)
+		goto out_rd;
+
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+	xrep_tempfile_iunlock(sc);
+
+	error = xrep_dir_move_to_orphanage(rd);
 
 out_names:
 	if (rd->dir_names)
diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
new file mode 100644
index 000000000000..1fe7935433bf
--- /dev/null
+++ b/fs/xfs/scrub/orphanage.c
@@ -0,0 +1,414 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_inode.h"
+#include "xfs_ialloc.h"
+#include "xfs_quota.h"
+#include "xfs_trans_space.h"
+#include "xfs_dir2.h"
+#include "xfs_icache.h"
+#include "xfs_bmap.h"
+#include "xfs_bmap_btree.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/repair.h"
+#include "scrub/trace.h"
+#include "scrub/orphanage.h"
+
+#include <linux/namei.h>
+
+/* Make the orphanage owned by root. */
+STATIC int
+xrep_chown_orphanage(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp)
+{
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = sc->mp;
+	struct xfs_dquot	*udqp = NULL, *gdqp = NULL, *pdqp = NULL;
+	struct xfs_dquot	*oldu = NULL, *oldg = NULL, *oldp = NULL;
+	struct inode		*inode = VFS_I(dp);
+	int			error;
+
+	error = xfs_qm_vop_dqalloc(dp, GLOBAL_ROOT_UID, GLOBAL_ROOT_GID, 0,
+			XFS_QMOPT_QUOTALL, &udqp, &gdqp, &pdqp);
+	if (error)
+		return error;
+
+	error = xfs_trans_alloc_ichange(dp, udqp, gdqp, pdqp, true, &tp);
+	if (error)
+		goto out_dqrele;
+
+	/*
+	 * Always clear setuid/setgid on the orphanage since we don't normally
+	 * want that functionality on this directory and xfs_repair doesn't
+	 * create it this way either.  Leave the other access bits unchanged.
+	 */
+	inode->i_mode &= ~(S_ISUID | S_ISGID);
+
+	/*
+	 * Change the ownerships and register quota modifications
+	 * in the transaction.
+	 */
+	if (!uid_eq(inode->i_uid, GLOBAL_ROOT_UID)) {
+		if (XFS_IS_UQUOTA_ON(mp))
+			oldu = xfs_qm_vop_chown(tp, dp, &dp->i_udquot, udqp);
+		inode->i_uid = GLOBAL_ROOT_UID;
+	}
+	if (!gid_eq(inode->i_gid, GLOBAL_ROOT_GID)) {
+		if (XFS_IS_GQUOTA_ON(mp))
+			oldg = xfs_qm_vop_chown(tp, dp, &dp->i_gdquot, gdqp);
+		inode->i_gid = GLOBAL_ROOT_GID;
+	}
+	if (dp->i_projid != 0) {
+		if (XFS_IS_PQUOTA_ON(mp))
+			oldp = xfs_qm_vop_chown(tp, dp, &dp->i_pdquot, pdqp);
+		dp->i_projid = 0;
+	}
+
+	dp->i_diflags &= ~(XFS_DIFLAG_REALTIME | XFS_DIFLAG_RTINHERIT);
+	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+
+	XFS_STATS_INC(mp, xs_ig_attrchg);
+
+	if (xfs_has_wsync(mp))
+		xfs_trans_set_sync(tp);
+	error = xfs_trans_commit(tp);
+
+	xfs_qm_dqrele(oldu);
+	xfs_qm_dqrele(oldg);
+	xfs_qm_dqrele(oldp);
+
+out_dqrele:
+	xfs_qm_dqrele(udqp);
+	xfs_qm_dqrele(gdqp);
+	xfs_qm_dqrele(pdqp);
+	return error;
+}
+
+#define ORPHANAGE	"lost+found"
+
+/* Create the orphanage directory, and set sc->orphanage to it. */
+int
+xrep_orphanage_create(
+	struct xfs_scrub	*sc)
+{
+	struct xfs_mount	*mp = sc->mp;
+	struct dentry		*root_dentry, *orphanage_dentry;
+	struct inode		*root_inode = VFS_I(sc->mp->m_rootip);
+	struct inode		*orphanage_inode;
+	int			error;
+
+	if (xfs_is_shutdown(mp))
+		return -EIO;
+	if (xfs_is_readonly(mp)) {
+		sc->orphanage = NULL;
+		return 0;
+	}
+
+	ASSERT(sc->tp == NULL);
+	ASSERT(sc->orphanage == NULL);
+
+	/* Find the dentry for the root directory... */
+	root_dentry = d_find_alias(root_inode);
+	if (!root_dentry) {
+		error = -EFSCORRUPTED;
+		goto out;
+	}
+
+	/* ...which is a directory, right? */
+	if (!d_is_dir(root_dentry)) {
+		error = -EFSCORRUPTED;
+		goto out_dput_root;
+	}
+
+	/* Try to find the orphanage directory. */
+	inode_lock_nested(root_inode, I_MUTEX_PARENT);
+	orphanage_dentry = lookup_one_len(ORPHANAGE, root_dentry,
+			strlen(ORPHANAGE));
+	if (IS_ERR(orphanage_dentry)) {
+		error = PTR_ERR(orphanage_dentry);
+		goto out_unlock_root;
+	}
+
+	/*
+	 * Nothing found?  Call mkdir to create the orphanage.  Create the
+	 * directory without group or other-user access because we're live and
+	 * someone could have been relying partly on minimal access to a parent
+	 * directory to control access to a file we put in here.
+	 */
+	if (d_really_is_negative(orphanage_dentry)) {
+		error = vfs_mkdir(&init_user_ns, root_inode, orphanage_dentry,
+				0700);
+		if (error)
+			goto out_dput_orphanage;
+	}
+
+	/* Not a directory? Bail out. */
+	if (!d_is_dir(orphanage_dentry)) {
+		error = -ENOTDIR;
+		goto out_dput_orphanage;
+	}
+
+	/*
+	 * Grab a reference to the orphanage.  This /should/ succeed since
+	 * we hold the root directory locked and therefore nobody can delete
+	 * the orphanage.
+	 */
+	orphanage_inode = igrab(d_inode(orphanage_dentry));
+	if (!orphanage_inode) {
+		error = -ENOENT;
+		goto out_dput_orphanage;
+	}
+
+	/* Make sure the orphanage is owned by root. */
+	error = xrep_chown_orphanage(sc, XFS_I(orphanage_inode));
+	if (error)
+		goto out_dput_orphanage;
+
+	/* Stash the reference for later and bail out. */
+	sc->orphanage = XFS_I(orphanage_inode);
+	sc->orphanage_ilock_flags = 0;
+
+out_dput_orphanage:
+	dput(orphanage_dentry);
+out_unlock_root:
+	inode_unlock(VFS_I(sc->mp->m_rootip));
+out_dput_root:
+	dput(root_dentry);
+out:
+	return error;
+}
+
+void
+xrep_orphanage_ilock(
+	struct xfs_scrub	*sc,
+	unsigned int		ilock_flags)
+{
+	sc->orphanage_ilock_flags |= ilock_flags;
+	xfs_ilock(sc->orphanage, ilock_flags);
+}
+
+bool
+xrep_orphanage_ilock_nowait(
+	struct xfs_scrub	*sc,
+	unsigned int		ilock_flags)
+{
+	if (xfs_ilock_nowait(sc->orphanage, ilock_flags)) {
+		sc->orphanage_ilock_flags |= ilock_flags;
+		return true;
+	}
+
+	return false;
+}
+
+void
+xrep_orphanage_iunlock(
+	struct xfs_scrub	*sc,
+	unsigned int		ilock_flags)
+{
+	xfs_iunlock(sc->orphanage, ilock_flags);
+	sc->orphanage_ilock_flags &= ~ilock_flags;
+}
+
+/* Grab the IOLOCK of the orphanage and sc->ip. */
+int
+xrep_orphanage_iolock_two(
+	struct xfs_scrub	*sc)
+{
+	int			error = 0;
+
+	while (true) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
+		/*
+		 * Normal XFS takes the IOLOCK before grabbing a transaction.
+		 * Scrub holds a transaction, which means that we can't block
+		 * on either IOLOCK.
+		 */
+		if (xrep_orphanage_ilock_nowait(sc, XFS_IOLOCK_EXCL)) {
+			if (xchk_ilock_nowait(sc, XFS_IOLOCK_EXCL))
+				break;
+			xrep_orphanage_iunlock(sc, XFS_IOLOCK_EXCL);
+		}
+		delay(1);
+	}
+
+	return 0;
+}
+
+/* Compute block reservation needed to add sc->ip to the orphanage. */
+void
+xrep_orphanage_compute_blkres(
+	struct xfs_scrub		*sc,
+	struct xrep_orphanage_req	*orph)
+{
+	struct xfs_mount		*mp = sc->mp;
+	bool				isdir = S_ISDIR(VFS_I(sc->ip)->i_mode);
+
+	orph->sc = sc;
+	orph->orphanage_blkres = XFS_LINK_SPACE_RES(mp, MAXNAMELEN);
+	orph->child_blkres = isdir ? XFS_RENAME_SPACE_RES(mp, 2) : 0;
+}
+
+/*
+ * Compute the xfs_name for the directory entry that we're adding to the
+ * orphanage.  Caller must have the IOLOCK of the orphanage and sc->ip.
+ */
+int
+xrep_orphanage_compute_name(
+	struct xrep_orphanage_req	*orph,
+	unsigned char			*namebuf)
+{
+	struct xfs_name			*xname = &orph->xname;
+	struct xfs_scrub		*sc = orph->sc;
+	xfs_ino_t			ino;
+	unsigned int			incr = 0;
+	int				error = 0;
+
+	xname->name = namebuf;
+	xname->len = snprintf(namebuf, MAXNAMELEN, "%llu", sc->ip->i_ino);
+	xname->type = xfs_mode_to_ftype(VFS_I(sc->ip)->i_mode);
+
+	/* Make sure the filename is unique in the lost+found. */
+	error = xfs_dir_lookup(sc->tp, sc->orphanage, xname, &ino, NULL);
+	while (error == 0 && incr < 10000) {
+		xname->len = snprintf(namebuf, MAXNAMELEN, "%llu.%u",
+				sc->ip->i_ino, ++incr);
+		error = xfs_dir_lookup(sc->tp, sc->orphanage, xname, &ino,
+				NULL);
+	}
+	if (error == 0) {
+		/* We already have 10,000 entries in the orphanage? */
+		return -EFSCORRUPTED;
+	}
+
+	if (error != -ENOENT)
+		return error;
+	return 0;
+}
+
+/*
+ * Prepare to send a child to the orphanage.
+ *
+ * Reserve more space in the transaction, take the ILOCKs of the orphanage and
+ * sc->ip, join them to the transaction, and reserve quota to reparent the
+ * latter.
+ */
+int
+xrep_orphanage_adoption_prep(
+	struct xrep_orphanage_req	*orph)
+{
+	struct xfs_scrub		*sc = orph->sc;
+	int				error;
+
+	/*
+	 * Reserve space to the transaction to handle expansion of both the
+	 * orphanage and the child directory.
+	 */
+	error = xfs_trans_reserve_more(sc->tp,
+			orph->orphanage_blkres + orph->child_blkres, 0);
+	if (error)
+		return error;
+
+	xfs_lock_two_inodes(sc->orphanage, XFS_ILOCK_EXCL,
+			    sc->ip, XFS_ILOCK_EXCL);
+	sc->ilock_flags |= XFS_ILOCK_EXCL;
+	sc->orphanage_ilock_flags |= XFS_ILOCK_EXCL;
+
+	xfs_trans_ijoin(sc->tp, sc->orphanage, 0);
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	/*
+	 * Reserve enough quota in the orphan directory to add the new name.
+	 * Normally the orphanage should have user/group/project ids of zero
+	 * and hence is not subject to quota enforcement, but we're allowed to
+	 * exceed quota to reattach disconnected parts of the directory tree.
+	 */
+	error = xfs_trans_reserve_quota_nblks(sc->tp, sc->orphanage,
+			orph->orphanage_blkres, 0, true);
+	if (error)
+		return error;
+
+	/*
+	 * Reserve enough quota in the child directory to change dotdot.
+	 * Here we're also allowed to exceed file quota to repair inconsistent
+	 * metadata.
+	 */
+	if (orph->child_blkres) {
+		error = xfs_trans_reserve_quota_nblks(sc->tp, sc->ip,
+				orph->child_blkres, 0, true);
+		if (error)
+			return error;
+	}
+
+	return 0;
+}
+
+/*
+ * Move the current file to the orphanage.
+ *
+ * The caller must hold the IOLOCKs and the ILOCKs for both sc->ip and the
+ * orphanage.  The directory entry name must have been computed, and quota
+ * reserved.  The function returns with both inodes joined and ILOCKed to the
+ * transaction.
+ */
+int
+xrep_orphanage_adopt(
+	struct xrep_orphanage_req	*orph)
+{
+	struct xfs_scrub		*sc = orph->sc;
+	struct xfs_name			*xname = &orph->xname;
+	bool				isdir = S_ISDIR(VFS_I(sc->ip)->i_mode);
+	int				error;
+
+	trace_xrep_orphanage_adopt(sc->orphanage, &orph->xname, sc->ip->i_ino);
+
+	/*
+	 * Create the new name in the orphanage, and bump the link count of
+	 * the orphanage if we just added a directory.
+	 */
+	error = xfs_dir_createname(sc->tp, sc->orphanage, xname, sc->ip->i_ino,
+			orph->orphanage_blkres);
+	if (error)
+		return error;
+
+	xfs_trans_ichgtime(sc->tp, sc->orphanage,
+			XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	if (isdir)
+		xfs_bumplink(sc->tp, sc->orphanage);
+	xfs_trans_log_inode(sc->tp, sc->orphanage, XFS_ILOG_CORE);
+
+	if (!isdir)
+		return 0;
+
+	/* Replace the dotdot entry in the child directory. */
+	return xfs_dir_replace(sc->tp, sc->ip, &xfs_name_dotdot,
+			sc->orphanage->i_ino, orph->child_blkres);
+}
+
+/* Release the orphanage. */
+void
+xrep_orphanage_rele(
+	struct xfs_scrub	*sc)
+{
+	if (!sc->orphanage)
+		return;
+
+	if (sc->orphanage_ilock_flags)
+		xfs_iunlock(sc->orphanage, sc->orphanage_ilock_flags);
+
+	xchk_irele(sc, sc->orphanage);
+	sc->orphanage = NULL;
+}
diff --git a/fs/xfs/scrub/orphanage.h b/fs/xfs/scrub/orphanage.h
new file mode 100644
index 000000000000..6087d68bc68f
--- /dev/null
+++ b/fs/xfs/scrub/orphanage.h
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_ORPHANAGE_H__
+#define __XFS_SCRUB_ORPHANAGE_H__
+
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+int xrep_orphanage_create(struct xfs_scrub *sc);
+
+/*
+ * If we're doing a repair, ensure that the orphanage exists and attach it to
+ * the scrub context.
+ */
+static inline int
+xrep_orphanage_try_create(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	ASSERT(sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR);
+
+	error = xrep_orphanage_create(sc);
+	switch (error) {
+	case 0:
+	case -ENOENT:
+	case -ENOTDIR:
+	case -ENOSPC:
+		/*
+		 * If the orphanage can't be found or isn't a directory, we'll
+		 * keep going, but we won't be able to attach the file to the
+		 * orphanage if we can't find the parent.
+		 */
+		return 0;
+	}
+
+	return error;
+}
+
+int xrep_orphanage_iolock_two(struct xfs_scrub *sc);
+
+/* Information about a request to add a file to the orphanage. */
+struct xrep_orphanage_req {
+	/* Name structure; caller must provide a buffer separately. */
+	struct xfs_name		xname;
+
+	struct xfs_scrub	*sc;
+
+	/* Block reservations for orphanage and child (if directory). */
+	unsigned int		orphanage_blkres;
+	unsigned int		child_blkres;
+};
+
+static inline size_t
+xrep_orphanage_req_sizeof(void)
+{
+	return sizeof(struct xrep_orphanage_req) + MAXNAMELEN + 1;
+}
+
+void xrep_orphanage_compute_blkres(struct xfs_scrub *sc,
+		struct xrep_orphanage_req *orph);
+int xrep_orphanage_compute_name(struct xrep_orphanage_req *orph,
+		unsigned char *namebuf);
+int xrep_orphanage_adoption_prep(struct xrep_orphanage_req *orph);
+int xrep_orphanage_adopt(struct xrep_orphanage_req *orph);
+
+void xrep_orphanage_ilock(struct xfs_scrub *sc, unsigned int ilock_flags);
+bool xrep_orphanage_ilock_nowait(struct xfs_scrub *sc,
+		unsigned int ilock_flags);
+void xrep_orphanage_iunlock(struct xfs_scrub *sc, unsigned int ilock_flags);
+
+void xrep_orphanage_rele(struct xfs_scrub *sc);
+#else
+struct xrep_orphanage_req { /* empty */ };
+# define xrep_orphanage_rele(sc)
+#endif /* CONFIG_XFS_ONLINE_REPAIR */
+
+#endif /* __XFS_SCRUB_ORPHANAGE_H__ */
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index dfea3102f52f..92866f1757be 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -10,6 +10,7 @@
 #include "xfs_trans_resv.h"
 #include "xfs_mount.h"
 #include "xfs_log_format.h"
+#include "xfs_trans.h"
 #include "xfs_inode.h"
 #include "xfs_icache.h"
 #include "xfs_dir2.h"
@@ -18,12 +19,21 @@
 #include "scrub/common.h"
 #include "scrub/readdir.h"
 #include "scrub/parent.h"
+#include "scrub/repair.h"
 
 /* Set us up to scrub parents. */
 int
 xchk_setup_parent(
 	struct xfs_scrub	*sc)
 {
+	int			error;
+
+	if (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) {
+		error = xrep_setup_parent(sc);
+		if (error)
+			return error;
+	}
+
 	return xchk_setup_inode_contents(sc, 0);
 }
 
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index d83948d1fd05..ffef5de0fbe2 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -33,6 +33,7 @@
 #include "scrub/parent.h"
 #include "scrub/readdir.h"
 #include "scrub/tempfile.h"
+#include "scrub/orphanage.h"
 
 struct xrep_findparent_info {
 	/* The directory currently being scanned. */
@@ -352,6 +353,29 @@ xrep_parent_scan(
 	return 0;
 }
 
+struct xrep_parent {
+	struct xfs_scrub	*sc;
+
+	/* Orphanage reparinting request. */
+	struct xrep_orphanage_req adoption;
+
+	/* Directory entry name, plus the trailing null. */
+	char			namebuf[MAXNAMELEN];
+};
+
+/* Set up for a parent repair. */
+int
+xrep_setup_parent(
+	struct xfs_scrub	*sc)
+{
+	/* We need a buffer for the orphanage request and a name buffer. */
+	sc->buf = kvzalloc(sizeof(struct xrep_parent), XCHK_GFP_FLAGS);
+	if (!sc->buf)
+		return -ENOMEM;
+
+	return xrep_orphanage_try_create(sc);
+}
+
 /*
  * If we're the root of a directory tree, we are our own parent.  If we're an
  * unlinked directory, the parent /won't/ have a link to us.  Set the parent
@@ -409,14 +433,80 @@ xrep_parent_reset_dir(
 			spaceres);
 }
 
+/*
+ * Move the current file to the orphanage.
+ *
+ * Caller must hold IOLOCK_EXCL on @sc->ip, and no other inode locks.  Upon
+ * successful return, the scrub transaction will have enough extra reservation
+ * to make the move; it will hold IOLOCK_EXCL and ILOCK_EXCL of @sc->ip and the
+ * orphanage; and both inodes will be ijoined.
+ */
+STATIC int
+xrep_parent_move_to_orphanage(
+	struct xrep_parent	*rp)
+{
+	struct xfs_scrub	*sc = rp->sc;
+	int			error;
+
+	/* No orphanage?  We can't fix this. */
+	if (!sc->orphanage)
+		return -EFSCORRUPTED;
+
+	/* If we can take the orphanage's iolock then we're ready to move. */
+	if (!xrep_orphanage_ilock_nowait(sc, XFS_IOLOCK_EXCL)) {
+		xfs_ino_t	orig_parent, new_parent;
+
+		/*
+		 * We may have to drop the lock on sc->ip to try to lock the
+		 * orphanage.  Therefore, look up the old dotdot entry for
+		 * sc->ip so that we can compare it after we re-lock sc->ip.
+		 */
+		orig_parent = xrep_dotdot_lookup(sc);
+
+		xchk_iunlock(sc, sc->ilock_flags);
+		error = xrep_orphanage_iolock_two(sc);
+		if (error)
+			return error;
+
+		/*
+		 * If the parent changed or the child was unlinked while the
+		 * child directory was unlocked, we don't need to move the
+		 * child to the orphanage after all.
+		 */
+		new_parent = xrep_dotdot_lookup(sc);
+
+		if (orig_parent != new_parent || VFS_I(sc->ip)->i_nlink == 0)
+			return 0;
+	}
+
+	/*
+	 * Move the directory to the orphanage, and let scrub teardown unlock
+	 * everything for us.
+	 */
+	xrep_orphanage_compute_blkres(sc, &rp->adoption);
+
+	error = xrep_orphanage_compute_name(&rp->adoption, rp->namebuf);
+	if (error)
+		return error;
+
+	error = xrep_orphanage_adoption_prep(&rp->adoption);
+	if (error)
+		return error;
+
+	return xrep_orphanage_adopt(&rp->adoption);
+}
+
 int
 xrep_parent(
 	struct xfs_scrub	*sc)
 {
+	struct xrep_parent	*rp = sc->buf;
 	xfs_ino_t		parent_ino, curr_parent;
 	unsigned int		sick, checked;
 	int			error;
 
+	rp->sc = sc;
+
 	/*
 	 * Avoid sick directories.  The parent pointer scrubber dropped the
 	 * ILOCK and MMAPLOCK, but we still hold IOLOCK_EXCL on the directory.
@@ -441,7 +531,7 @@ xrep_parent(
 	if (error)
 		return error;
 	if (parent_ino == NULLFSINO)
-		return -EFSCORRUPTED;
+		return xrep_parent_move_to_orphanage(rp);
 
 reset_parent:
 	/* If the '..' entry is already set to the parent inode, we're done. */
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index acd7fccf8bee..596993b06256 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -84,6 +84,7 @@ int xrep_setup_rtsummary(struct xfs_scrub *sc, unsigned int *resblks,
 		size_t *bufsize);
 int xrep_setup_xattr(struct xfs_scrub *sc);
 int xrep_setup_directory(struct xfs_scrub *sc);
+int xrep_setup_parent(struct xfs_scrub *sc);
 
 int xrep_xattr_reset_fork(struct xfs_scrub *sc);
 
@@ -194,6 +195,7 @@ xrep_setup_nothing(
 #define xrep_setup_ag_refcountbt	xrep_setup_nothing
 #define xrep_setup_xattr		xrep_setup_nothing
 #define xrep_setup_directory		xrep_setup_nothing
+#define xrep_setup_parent		xrep_setup_nothing
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 39ad06e6b2d0..b334fd3d7706 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -27,6 +27,7 @@
 #include "scrub/health.h"
 #include "scrub/xfile.h"
 #include "scrub/tempfile.h"
+#include "scrub/orphanage.h"
 
 /*
  * Online Scrub and Repair
@@ -219,6 +220,7 @@ xchk_teardown(
 	}
 
 	xrep_tempfile_rele(sc);
+	xrep_orphanage_rele(sc);
 	xchk_fshooks_disable(sc);
 	return error;
 }
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 9c26a6092c52..d606d4f370c7 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -105,6 +105,10 @@ struct xfs_scrub {
 	/* Lock flags for @ip. */
 	uint				ilock_flags;
 
+	/* The orphanage, for stashing files that have lost their parent. */
+	uint				orphanage_ilock_flags;
+	struct xfs_inode		*orphanage;
+
 	/* A temporary file on this filesystem, for staging new metadata. */
 	struct xfs_inode		*tempip;
 	uint				temp_ilock_flags;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index d8223ec24369..ae8a5852e258 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2510,6 +2510,7 @@ DEFINE_EVENT(xrep_dirent_class, name, \
 	TP_PROTO(struct xfs_inode *dp, struct xfs_name *name, xfs_ino_t ino), \
 	TP_ARGS(dp, name, ino))
 DEFINE_XREP_DIRENT_CLASS(xrep_dir_insert_rec);
+DEFINE_XREP_DIRENT_CLASS(xrep_orphanage_adopt);
 
 DECLARE_EVENT_CLASS(xrep_parent_salvage_class,
 	TP_PROTO(struct xfs_inode *dp, xfs_ino_t ino),
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index ce55dde40d9d..85ce54a09d82 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -930,10 +930,10 @@ xfs_droplink(
 /*
  * Increment the link count on an inode & log the change.
  */
-static void
+void
 xfs_bumplink(
-	xfs_trans_t *tp,
-	xfs_inode_t *ip)
+	struct xfs_trans	*tp,
+	struct xfs_inode	*ip)
 {
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 3f6c63304ca3..34f596deb92c 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -581,6 +581,7 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
 
 void xfs_inode_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_filblks_t *dblocks, xfs_filblks_t *rblocks);

