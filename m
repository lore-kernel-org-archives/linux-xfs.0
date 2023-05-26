Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CD6C7EE29
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 01:36:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232288AbjEZBgK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 21:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjEZBgJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 21:36:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55040189
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 18:36:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D444561A8E
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 01:36:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A233C433D2;
        Fri, 26 May 2023 01:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685064965;
        bh=ag1V+DJtMeaqr8r1GPnS0AE9wFbSK7123HvCP2uLwG0=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=e3pDVscoXjBXpuD9W5lJfJuZV9/L2r7/Kq6BjPKvncag5bofNCCBPu5bwotkwBdxQ
         Q5DbNjynl2/ZRB9pXvLEkFq/wO9BgnlV9kR1X7SEOKyHv0xEi+OCY8Xs2bSxZwzcUV
         QH7cZwRvoIg3sQ/90zR8mekIkDE2J8gTmpZGftfQ7AFXG6h7T7TApXwNdLORp0os0O
         vuz3/mRlgjFb+0o2pP0bjOJWkSv5vGF9A/HaOG7hKpfQXQZ9SxwC+jR6+ntRHJ9WmR
         7Xvq2Gr4o+z92TRhkqEtIxMX2LEqLjn5fBfHIc6PUOV4Q6cNhXPAOP5nnRmXWEK1QO
         FjWt++tkUMFzQ==
Date:   Thu, 25 May 2023 18:36:04 -0700
Subject: [PATCH 1/3] xfs: move orphan files to the orphanage
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506067657.3737779.462252544266038497.stgit@frogsfrogsfrogs>
In-Reply-To: <168506067639.3737779.12844625794200417040.stgit@frogsfrogsfrogs>
References: <168506067639.3737779.12844625794200417040.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we're repairing a directory structure or fixing the dotdot entry of
a subdirectory, it's possible that we won't ever find a parent for the
subdirectory.  When this is the case, move it to the orphanage, aka
/lost+found.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile              |    1 
 fs/xfs/scrub/dir_repair.c    |  129 +++++++++++-
 fs/xfs/scrub/orphanage.c     |  448 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/orphanage.h     |   73 +++++++
 fs/xfs/scrub/parent_repair.c |   94 ++++++++-
 fs/xfs/scrub/scrub.c         |    2 
 fs/xfs/scrub/scrub.h         |    4 
 fs/xfs/scrub/trace.h         |   23 ++
 fs/xfs/xfs_inode.c           |    6 -
 fs/xfs/xfs_inode.h           |    1 
 10 files changed, 764 insertions(+), 17 deletions(-)
 create mode 100644 fs/xfs/scrub/orphanage.c
 create mode 100644 fs/xfs/scrub/orphanage.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ac0da07428c8..e52cd4ccf8d6 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -200,6 +200,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   inode_repair.o \
 				   newbt.o \
 				   nlinks_repair.o \
+				   orphanage.o \
 				   parent_repair.o \
 				   rcbag_btree.o \
 				   rcbag.o \
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 215a8c1ce5e3..60578de031ca 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -42,6 +42,7 @@
 #include "scrub/readdir.h"
 #include "scrub/reap.h"
 #include "scrub/findparent.h"
+#include "scrub/orphanage.h"
 
 /*
  * Directory Repair
@@ -115,12 +116,21 @@ struct xrep_dir {
 	 */
 	struct xrep_parent_scan_info pscan;
 
+	/*
+	 * Context information for attaching this directory to the lost+found
+	 * if this directory does not have a parent.
+	 */
+	struct xrep_adoption	adoption;
+
 	/* How many subdirectories did we find? */
 	uint64_t		subdirs;
 
 	/* How many dirents did we find? */
 	unsigned int		dirents;
 
+	/* Should we move this directory to the orphanage? */
+	bool			move_orphanage;
+
 	/* Directory entry name, plus the trailing null. */
 	unsigned char		namebuf[MAXNAMELEN];
 };
@@ -147,6 +157,10 @@ xrep_setup_directory(
 
 	xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
 
+	error = xrep_orphanage_try_create(sc);
+	if (error)
+		return error;
+
 	error = xrep_tempfile_create(sc, S_IFDIR);
 	if (error)
 		return error;
@@ -1136,10 +1150,8 @@ xrep_dir_set_nlink(
 	/*
 	 * The directory is not on the incore unlinked list, which means that
 	 * it needs to be reachable via the directory tree.  Update the nlink
-	 * with our observed link count.
-	 *
-	 * XXX: A subsequent patch will handle parentless directories by moving
-	 * them to the lost and found instead of aborting the repair.
+	 * with our observed link count.  If the directory has no parent, it
+	 * will be moved to the orphanage.
 	 */
 	if (!xfs_inode_on_unlinked_list(dp)) {
 		xrep_set_nlink(sc->ip, rd->subdirs + 2);
@@ -1152,6 +1164,7 @@ xrep_dir_set_nlink(
 	 * inactivate when the last reference drops.
 	 */
 	if (rd->dirents == 0) {
+		rd->move_orphanage = false;
 		xrep_set_nlink(sc->ip, 0);
 		return 0;
 	}
@@ -1160,7 +1173,8 @@ xrep_dir_set_nlink(
 	 * The directory is on the unlinked list and we found dirents.  This
 	 * directory needs to be reachable via the directory tree.  Remove the
 	 * dir from the unlinked list and update nlink with the observed link
-	 * count.
+	 * count.  If the directory has no parent, it will be moved to the
+	 * orphanage.
 	 */
 	pag = xfs_perag_get(sc->mp, XFS_INO_TO_AGNO(sc->mp, dp->i_ino));
 	if (!pag) {
@@ -1187,12 +1201,16 @@ xrep_dir_swap(
 	int			error = 0;
 
 	/*
-	 * If we never found the parent for this directory, we can't fix this
-	 * directory.
+	 * If we never found the parent for this directory, temporarily assign
+	 * the root dir as the parent; we'll move this to the orphanage after
+	 * swapping the dir contents.  We hold the ILOCK of the dir being
+	 * repaired, so we're not worried about racy updates of dotdot.
 	 */
 	ASSERT(sc->ilock_flags & XFS_ILOCK_EXCL);
-	if (rd->pscan.parent_ino == NULLFSINO)
-		return -EFSCORRUPTED;
+	if (rd->pscan.parent_ino == NULLFSINO) {
+		rd->move_orphanage = true;
+		rd->pscan.parent_ino = rd->sc->mp->m_sb.sb_rootino;
+	}
 
 	/*
 	 * Reset the temporary directory's '..' entry to point to the parent
@@ -1326,6 +1344,93 @@ xrep_dir_setup_scan(
 	return error;
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
+xrep_dir_move_to_orphanage(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	xfs_ino_t		orig_parent, new_parent;
+	int			error;
+
+	/* No orphanage?  We can't fix this. */
+	if (!sc->orphanage)
+		return -EFSCORRUPTED;
+
+	/*
+	 * We are about to drop the ILOCK on sc->ip to lock the orphanage and
+	 * prepare for the adoption.  Therefore, look up the old dotdot entry
+	 * for sc->ip so that we can compare it after we re-lock sc->ip.
+	 */
+	error = xchk_dir_lookup(sc, sc->ip, &xfs_name_dotdot, &orig_parent);
+	if (error)
+		return error;
+
+	/*
+	 * We hold ILOCK_EXCL on both the directory and the tempdir after a
+	 * successful rebuild.  Before we can move the directory to the
+	 * orphanage, we must roll to a clean unjoined transaction.
+	 */
+	error = xfs_trans_roll(&sc->tp);
+	if (error)
+		return error;
+
+	/*
+	 * Because the orphanage is just another directory in the filesystem,
+	 * we must take its IOLOCK to coordinate with the VFS.  We cannot take
+	 * an IOLOCK while holding an ILOCK, so we must drop them all.  We may
+	 * have to drop the IOLOCK as well.
+	 */
+	xrep_tempfile_iunlock_both(sc);
+
+	error = xrep_adoption_init(sc, &rd->adoption);
+	if (error)
+		return error;
+
+	if (!xrep_orphanage_ilock_nowait(sc, XFS_IOLOCK_EXCL)) {
+		xchk_iunlock(sc, sc->ilock_flags);
+		error = xrep_orphanage_iolock_two(sc);
+		if (error)
+			goto err_adoption;
+	}
+
+	/* Prepare for the adoption and lock both down. */
+	error = xrep_adoption_prep(&rd->adoption);
+	if (error)
+		goto err_adoption;
+
+	error = xrep_adoption_compute_name(&rd->adoption, rd->namebuf);
+	if (error)
+		goto err_adoption;
+
+	/*
+	 * Now that we've reacquired the ILOCK on sc->ip, look up the dotdot
+	 * entry again.  If the parent changed or the child was unlinked while
+	 * the child directory was unlocked, we don't need to move the child to
+	 * the orphanage after all.
+	 */
+	error = xchk_dir_lookup(sc, sc->ip, &xfs_name_dotdot, &new_parent);
+	if (error)
+		goto err_adoption;
+	if (orig_parent != new_parent || VFS_I(sc->ip)->i_nlink == 0) {
+		error = 0;
+		goto err_adoption;
+	}
+
+	/* Attach to the orphanage. */
+	return xrep_adoption_commit(&rd->adoption);
+err_adoption:
+	xrep_adoption_cancel(&rd->adoption, error);
+	return error;
+}
+
 /*
  * Repair the directory metadata.
  *
@@ -1364,6 +1469,12 @@ xrep_directory(
 	if (error)
 		goto out_teardown;
 
+	if (rd->move_orphanage) {
+		error = xrep_dir_move_to_orphanage(rd);
+		if (error)
+			goto out_teardown;
+	}
+
 out_teardown:
 	xrep_dir_teardown(sc);
 	return error;
diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
new file mode 100644
index 000000000000..aece4f94398e
--- /dev/null
+++ b/fs/xfs/scrub/orphanage.c
@@ -0,0 +1,448 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2021-2023 Oracle.  All Rights Reserved.
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
+#include "scrub/readdir.h"
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
+		error = vfs_mkdir(&nop_mnt_idmap, root_inode, orphanage_dentry,
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
+/*
+ * Set up the adoption structure and compute the block reservations needed to
+ * add sc->ip to the orphanage.
+ */
+int
+xrep_adoption_init(
+	struct xfs_scrub	*sc,
+	struct xrep_adoption	*adopt)
+{
+	struct xfs_mount	*mp = sc->mp;
+	unsigned int		child_blkres = 0;
+
+	adopt->sc = sc;
+	adopt->orphanage_blkres = XFS_LINK_SPACE_RES(mp, MAXNAMELEN);
+	if (S_ISDIR(VFS_I(sc->ip)->i_mode))
+		child_blkres = XFS_RENAME_SPACE_RES(sc->mp,
+							xfs_name_dotdot.len);
+	adopt->child_blkres = child_blkres;
+	return 0;
+}
+
+/*
+ * Compute the xfs_name for the directory entry that we're adding to the
+ * orphanage.  Caller must hold ILOCKs of sc->ip and the orphanage and must not
+ * reuse namebuf until the adoption completes or is cancelled.
+ */
+int
+xrep_adoption_compute_name(
+	struct xrep_adoption	*adopt,
+	unsigned char		*namebuf)
+{
+	struct xfs_name		*xname = &adopt->xname;
+	struct xfs_scrub	*sc = adopt->sc;
+	xfs_ino_t		ino;
+	unsigned int		incr = 0;
+	int			error = 0;
+
+	xname->name = namebuf;
+	xname->len = snprintf(namebuf, MAXNAMELEN, "%llu", sc->ip->i_ino);
+	xname->type = xfs_mode_to_ftype(VFS_I(sc->ip)->i_mode);
+
+	/* Make sure the filename is unique in the lost+found. */
+	error = xchk_dir_lookup(sc, sc->orphanage, xname, &ino);
+	while (error == 0 && incr < 10000) {
+		xname->len = snprintf(namebuf, MAXNAMELEN, "%llu.%u",
+				sc->ip->i_ino, ++incr);
+		error = xchk_dir_lookup(sc, sc->orphanage, xname, &ino);
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
+ * latter.  Caller must hold the IOLOCK of the orphanage and sc->ip.
+ */
+int
+xrep_adoption_prep(
+	struct xrep_adoption	*adopt)
+{
+	struct xfs_scrub	*sc = adopt->sc;
+	int			error;
+
+	/*
+	 * Reserve space to the transaction to handle expansion of both the
+	 * orphanage and the child directory.
+	 */
+	error = xfs_trans_reserve_more(sc->tp,
+			adopt->orphanage_blkres + adopt->child_blkres, 0);
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
+			adopt->orphanage_blkres, 0, true);
+	if (error)
+		return error;
+
+	/*
+	 * Reserve enough quota in the child directory to change dotdot.
+	 * Here we're also allowed to exceed file quota to repair inconsistent
+	 * metadata.
+	 */
+	if (adopt->child_blkres) {
+		error = xfs_trans_reserve_quota_nblks(sc->tp, sc->ip,
+				adopt->child_blkres, 0, true);
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
+xrep_adoption_commit(
+	struct xrep_adoption	*adopt)
+{
+	struct xfs_scrub	*sc = adopt->sc;
+	struct xfs_name		*xname = &adopt->xname;
+	bool			isdir = S_ISDIR(VFS_I(sc->ip)->i_mode);
+	int			error;
+
+	trace_xrep_adoption_commit(sc->orphanage, &adopt->xname, sc->ip->i_ino);
+
+	/*
+	 * Create the new name in the orphanage, and bump the link count of
+	 * the orphanage if we just added a directory.
+	 */
+	error = xfs_dir_createname(sc->tp, sc->orphanage, xname, sc->ip->i_ino,
+			adopt->orphanage_blkres);
+	if (error)
+		return error;
+
+	xfs_trans_ichgtime(sc->tp, sc->orphanage,
+			XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
+	if (isdir)
+		xfs_bumplink(sc->tp, sc->orphanage);
+	xfs_trans_log_inode(sc->tp, sc->orphanage, XFS_ILOG_CORE);
+
+	/* Replace the dotdot entry in the child directory. */
+	if (isdir) {
+		error = xfs_dir_replace(sc->tp, sc->ip, &xfs_name_dotdot,
+				sc->orphanage->i_ino, adopt->child_blkres);
+		if (error)
+			return error;
+	}
+
+	/*
+	 * Notify dirent hooks that we moved the file to /lost+found, and
+	 * finish all the deferred work so that we know the adoption is fully
+	 * recorded in the log.
+	 */
+	xfs_dir_update_hook(sc->orphanage, sc->ip, 1, xname);
+	return xrep_defer_finish(sc);
+}
+
+/* Cancel a proposed relocation of a file to the orphanage. */
+void
+xrep_adoption_cancel(
+	struct xrep_adoption	*adopt,
+	int			error)
+{
+	struct xfs_scrub	*sc = adopt->sc;
+
+	/*
+	 * Setting up (and hence cancelling) an adoption is the last thing that
+	 * repair code does.  Hence we don't bother giving back the quota or
+	 * space reservations or unlock the inodes.  Later when we have incore
+	 * state to manage, we'll need to give that back.
+	 */
+	trace_xrep_adoption_cancel(sc->orphanage, sc->ip, error);
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
index 000000000000..31f068198c8a
--- /dev/null
+++ b/fs/xfs/scrub/orphanage.h
@@ -0,0 +1,73 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2021-2023 Oracle.  All Rights Reserved.
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
+struct xrep_adoption {
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
+int xrep_adoption_init(struct xfs_scrub *sc, struct xrep_adoption *adopt);
+int xrep_adoption_compute_name(struct xrep_adoption *adopt,
+		unsigned char *namebuf);
+int xrep_adoption_prep(struct xrep_adoption *adopt);
+int xrep_adoption_commit(struct xrep_adoption *adopt);
+void xrep_adoption_cancel(struct xrep_adoption *adopt, int error);
+
+void xrep_orphanage_ilock(struct xfs_scrub *sc, unsigned int ilock_flags);
+bool xrep_orphanage_ilock_nowait(struct xfs_scrub *sc,
+		unsigned int ilock_flags);
+void xrep_orphanage_iunlock(struct xfs_scrub *sc, unsigned int ilock_flags);
+
+void xrep_orphanage_rele(struct xfs_scrub *sc);
+#else
+struct xrep_adoption { /* empty */ };
+# define xrep_orphanage_rele(sc)
+#endif /* CONFIG_XFS_ONLINE_REPAIR */
+
+#endif /* __XFS_SCRUB_ORPHANAGE_H__ */
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 0343b1fdbeeb..e0ac7336c1ac 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -32,6 +32,8 @@
 #include "scrub/iscan.h"
 #include "scrub/findparent.h"
 #include "scrub/readdir.h"
+#include "scrub/tempfile.h"
+#include "scrub/orphanage.h"
 
 /*
  * Repairing The Directory Parent Pointer
@@ -57,6 +59,12 @@ struct xrep_parent {
 	 * dotdot entry for this directory.
 	 */
 	struct xrep_parent_scan_info pscan;
+
+	/* Orphanage reparenting request. */
+	struct xrep_adoption	adoption;
+
+	/* Directory entry name, plus the trailing null. */
+	unsigned char		namebuf[MAXNAMELEN];
 };
 
 /* Tear down all the incore stuff we created. */
@@ -82,7 +90,7 @@ xrep_setup_parent(
 	rp->sc = sc;
 	sc->buf = rp;
 
-	return 0;
+	return xrep_orphanage_try_create(sc);
 }
 
 /*
@@ -171,6 +179,84 @@ xrep_parent_reset_dotdot(
 			rp->pscan.parent_ino, spaceres);
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
+	xfs_ino_t		orig_parent, new_parent;
+	int			error;
+
+	/* No orphanage?  We can't fix this. */
+	if (!sc->orphanage)
+		return -EFSCORRUPTED;
+
+	/*
+	 * We are about to drop the ILOCK on sc->ip to lock the orphanage and
+	 * prepare for the adoption.  Therefore, look up the old dotdot entry
+	 * for sc->ip so that we can compare it after we re-lock sc->ip.
+	 */
+	error = xchk_dir_lookup(sc, sc->ip, &xfs_name_dotdot, &orig_parent);
+	if (error)
+		return error;
+
+	/*
+	 * Because the orphanage is just another directory in the filesystem,
+	 * we must take its IOLOCK to coordinate with the VFS.  We cannot take
+	 * an IOLOCK while holding an ILOCK, so we must drop the ILOCK.  We
+	 * may have to drop the IOLOCK as well.
+	 */
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+
+	error = xrep_adoption_init(sc, &rp->adoption);
+	if (error)
+		return error;
+
+	/* If we can take the orphanage's iolock then we're ready to move. */
+	if (!xrep_orphanage_ilock_nowait(sc, XFS_IOLOCK_EXCL)) {
+		xchk_iunlock(sc, sc->ilock_flags);
+		error = xrep_orphanage_iolock_two(sc);
+		if (error)
+			goto err_adoption;
+	}
+
+	/* Prepare for the adoption and lock both down. */
+	error = xrep_adoption_prep(&rp->adoption);
+	if (error)
+		goto err_adoption;
+
+	error = xrep_adoption_compute_name(&rp->adoption, rp->namebuf);
+	if (error)
+		goto err_adoption;
+
+	/*
+	 * Now that we've reacquired the ILOCK on sc->ip, look up the dotdot
+	 * entry again.  If the parent changed or the child was unlinked while
+	 * the child directory was unlocked, we don't need to move the child to
+	 * the orphanage after all.
+	 */
+	error = xchk_dir_lookup(sc, sc->ip, &xfs_name_dotdot, &new_parent);
+	if (error)
+		goto err_adoption;
+	if (orig_parent != new_parent || VFS_I(sc->ip)->i_nlink == 0) {
+		error = 0;
+		goto err_adoption;
+	}
+
+	return xrep_adoption_commit(&rp->adoption);
+err_adoption:
+	xrep_adoption_cancel(&rp->adoption, error);
+	return error;
+}
+
 /*
  * Commit the new parent pointer structure (currently only the dotdot entry) to
  * the file that we're repairing.
@@ -179,10 +265,8 @@ STATIC int
 xrep_parent_rebuild_tree(
 	struct xrep_parent	*rp)
 {
-	if (rp->pscan.parent_ino == NULLFSINO) {
-		/* Cannot fix orphaned directories yet. */
-		return -EFSCORRUPTED;
-	}
+	if (rp->pscan.parent_ino == NULLFSINO)
+		return xrep_parent_move_to_orphanage(rp);
 
 	return xrep_parent_reset_dotdot(rp);
 }
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 52404558ac99..f90223b909a2 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -28,6 +28,7 @@
 #include "scrub/health.h"
 #include "scrub/xfile.h"
 #include "scrub/tempfile.h"
+#include "scrub/orphanage.h"
 
 /*
  * Online Scrub and Repair
@@ -221,6 +222,7 @@ xchk_teardown(
 	}
 
 	xrep_tempfile_rele(sc);
+	xrep_orphanage_rele(sc);
 	xchk_fsgates_disable(sc);
 	return error;
 }
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index e3a53c3a13a3..6f23edcac5cd 100644
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
index 260720500440..abf8d1fad537 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2517,6 +2517,29 @@ DEFINE_EVENT(xrep_dirent_class, name, \
 DEFINE_XREP_DIRENT_CLASS(xrep_dir_salvage_entry);
 DEFINE_XREP_DIRENT_CLASS(xrep_dir_stash_createname);
 DEFINE_XREP_DIRENT_CLASS(xrep_dir_replay_createname);
+DEFINE_XREP_DIRENT_CLASS(xrep_adoption_commit);
+
+TRACE_EVENT(xrep_adoption_cancel,
+	TP_PROTO(struct xfs_inode *dp, struct xfs_inode *ip, int error),
+	TP_ARGS(dp, ip, error),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dir_ino)
+		__field(xfs_ino_t, child_ino)
+		__field(int, error)
+	),
+	TP_fast_assign(
+		__entry->dev = dp->i_mount->m_super->s_dev;
+		__entry->dir_ino = dp->i_ino;
+		__entry->child_ino = ip->i_ino;
+		__entry->error = error;
+	),
+	TP_printk("dev %d:%d dir 0x%llx child 0x%llx error %d",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dir_ino,
+		  __entry->child_ino,
+		  __entry->error)
+);
 
 DECLARE_EVENT_CLASS(xrep_parent_salvage_class,
 	TP_PROTO(struct xfs_inode *dp, xfs_ino_t ino),
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 2fd55c2f1b82..c5d2dae9c00b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -928,10 +928,10 @@ xfs_droplink(
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
index 2fe629eede76..f5794e3045ae 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -601,6 +601,7 @@ void xfs_end_io(struct work_struct *work);
 
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
+void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
 
 void xfs_inode_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_filblks_t *dblocks, xfs_filblks_t *rblocks);

