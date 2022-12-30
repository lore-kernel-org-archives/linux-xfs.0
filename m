Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C020FC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235484AbiLaABl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:01:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235843AbiLaABk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:01:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBCD362C1
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 16:01:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89E3FB81DE0
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 00:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B9FC433D2;
        Sat, 31 Dec 2022 00:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672444894;
        bh=Qv3dC4OXix5FY/52t6DjiCW75eMh3VUutPpFaPwfRDU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=L4g+A5jGCeDNzefeZPUbr+EtKXMIk/wUPtE1cIVXewYWJae9NGtttoVC0cfY7OZId
         gzfudXJarF0mSsOVGpP0Hv09pxvoKAGVLX5UTgLSdo+gHvLBsh6zfLUxHr8Dq3DHLN
         To9WdFDKSBFLqLpSerwCP1cAzZVPtzOOAGUZVVFuMubrzjnRY3PKeYFcGI1WjfYv/j
         3UmUFplSh1ynB0wrW0w7wenwxQUsA9PCUKDfhVH2f4jewPrAZHN2asek8YLdynb9D7
         iPyTtfBnmGQSFzvaaxD8yBmiISXOt7mmJyIhUTVPSv/kftc5XXA7jRW8oBHbxGqa3T
         jxsqGOflRg4rw==
Subject: [PATCH 2/3] xfs: online repair of parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:16 -0800
Message-ID: <167243845669.700660.16777361167512483905.stgit@magnolia>
In-Reply-To: <167243845636.700660.17331865239070788293.stgit@magnolia>
References: <167243845636.700660.17331865239070788293.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the online repair code to fix directory '..' entries (aka
directory parent pointers).  Since this requires us to know how to scan
every dirent in every directory on the filesystem, we can reuse the
parent scanner components to validate (or find!) the correct parent
entry when rebuilding directories too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile              |    1 
 fs/xfs/scrub/dir_repair.c    |   66 +++----
 fs/xfs/scrub/iscan.c         |    7 +
 fs/xfs/scrub/iscan.h         |    3 
 fs/xfs/scrub/parent.c        |    3 
 fs/xfs/scrub/parent.h        |   16 ++
 fs/xfs/scrub/parent_repair.c |  417 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h        |    2 
 fs/xfs/scrub/scrub.c         |    2 
 fs/xfs/scrub/trace.h         |    2 
 10 files changed, 483 insertions(+), 36 deletions(-)
 create mode 100644 fs/xfs/scrub/parent.h
 create mode 100644 fs/xfs/scrub/parent_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 43536f1b351e..5e9ffd9f1583 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -197,6 +197,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   inode_repair.o \
 				   newbt.o \
 				   nlinks_repair.o \
+				   parent_repair.o \
 				   rcbag_btree.o \
 				   rcbag.o \
 				   reap.o \
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 99d8ce8528c5..e2de2fc24ba0 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -39,6 +39,7 @@
 #include "scrub/xfblob.h"
 #include "scrub/readdir.h"
 #include "scrub/reap.h"
+#include "scrub/parent.h"
 
 /*
  * Directory Repair
@@ -1010,50 +1011,36 @@ xrep_dir_rebuild_tree(
 }
 
 /*
- * If we're the root of a directory tree, we are our own parent.  If we're an
- * unlinked directory, the parent /won't/ have a link to us.  Set the parent
- * directory to the root for both cases.  Returns NULLFSINO if we don't know
- * what to do.
- */
-static inline xfs_ino_t
-xrep_dir_self_parent(
-	struct xrep_dir		*rd)
-{
-	struct xfs_scrub	*sc = rd->sc;
-
-	if (sc->ip->i_ino == sc->mp->m_sb.sb_rootino)
-		return sc->mp->m_sb.sb_rootino;
-
-	if (VFS_I(sc->ip)->i_nlink == 0)
-		return sc->mp->m_sb.sb_rootino;
-
-	return NULLFSINO;
-}
-
-/*
- * Look up the dotdot entry.  Returns NULLFSINO if we don't know what to do.
- * The next patch will check this more carefully.
+ * Look up the dotdot entry and confirm that it's really the parent.
+ * Returns NULLFSINO if we don't know what to do.
  */
 static inline xfs_ino_t
 xrep_dir_lookup_parent(
 	struct xrep_dir		*rd)
 {
-	return xrep_dotdot_lookup(rd->sc);
+	struct xfs_scrub	*sc = rd->sc;
+	xfs_ino_t		parent_ino;
+	int			error;
+
+	parent_ino = xrep_dotdot_lookup(sc);
+	if (parent_ino == NULLFSINO)
+		return parent_ino;
+
+	error = xrep_parent_confirm(sc, &parent_ino);
+	if (error)
+		return NULLFSINO;
+
+	return parent_ino;
 }
 
-/*
- * Try to find the parent of the directory being repaired.
- *
- * NOTE: This function will someday be augmented by the directory parent repair
- * code, which will know how to check the parent and scan the filesystem if
- * we cannot find anything.  Inode scans will have to be done before we start
- * salvaging directory entries, so we do this now.
- */
+/* Try to find the parent of the directory being repaired. */
 STATIC int
 xrep_dir_find_parent(
 	struct xrep_dir		*rd)
 {
-	rd->parent_ino = xrep_dir_self_parent(rd);
+	int			error;
+
+	rd->parent_ino = xrep_parent_self_reference(rd->sc);
 	if (rd->parent_ino != NULLFSINO)
 		return 0;
 
@@ -1061,6 +1048,19 @@ xrep_dir_find_parent(
 	if (rd->parent_ino != NULLFSINO)
 		return 0;
 
+	/*
+	 * A full filesystem scan is the last resort.  On a busy filesystem,
+	 * the scan can fail with -EBUSY if we cannot grab IOLOCKs.  That means
+	 * that we don't know what who the parent is, so we should return to
+	 * userspace.
+	 */
+	error = xrep_parent_scan(rd->sc, &rd->parent_ino);
+	if (error)
+		return error;
+
+	if (rd->parent_ino != NULLFSINO)
+		return 0;
+
 	/* NOTE: A future patch will deal with moving orphans. */
 	return -EFSCORRUPTED;
 }
diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
index e3db6a64338b..8cf486dfde19 100644
--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -342,8 +342,13 @@ xchk_iscan_iget(
 		 * It's possible that this inode has lost all of its links but
 		 * hasn't yet been inactivated.  If we don't have a transaction
 		 * or it's not writable, flush the inodegc workers and wait.
+		 * Otherwise, we have a dirty transaction in progress and the
+		 * best we can do is to queue the inodegc workers.
 		 */
-		xfs_inodegc_flush(mp);
+		if (!iscan->iget_nowait)
+			xfs_inodegc_flush(mp);
+		else
+			xfs_inodegc_push(mp);
 		return xchk_iscan_iget_retry(mp, iscan, true);
 	}
 
diff --git a/fs/xfs/scrub/iscan.h b/fs/xfs/scrub/iscan.h
index 947176620bc3..f10b71d9cec4 100644
--- a/fs/xfs/scrub/iscan.h
+++ b/fs/xfs/scrub/iscan.h
@@ -32,6 +32,9 @@ struct xchk_iscan {
 
 	/* Wait this many ms to retry an iget. */
 	unsigned int		iget_retry_delay;
+
+	/* True if we cannot allow iget to wait indefinitely. */
+	bool			iget_nowait:1;
 };
 
 /* Set if the scan has been aborted due to some event in the fs. */
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 58d012252015..dfea3102f52f 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -17,6 +17,7 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/readdir.h"
+#include "scrub/parent.h"
 
 /* Set us up to scrub parents. */
 int
@@ -95,7 +96,7 @@ xchk_parent_count_parent_dentries(
  * Try to iolock the parent dir @dp in shared mode and the child dir @sc->ip
  * exclusively.
  */
-STATIC int
+int
 xchk_parent_lock_two_dirs(
 	struct xfs_scrub	*sc,
 	struct xfs_inode	*dp)
diff --git a/fs/xfs/scrub/parent.h b/fs/xfs/scrub/parent.h
new file mode 100644
index 000000000000..e1979f5bb001
--- /dev/null
+++ b/fs/xfs/scrub/parent.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_PARENT_H__
+#define __XFS_SCRUB_PARENT_H__
+
+int xchk_parent_lock_two_dirs(struct xfs_scrub *sc, struct xfs_inode *dp);
+
+int xrep_parent_confirm(struct xfs_scrub *sc, xfs_ino_t *parent_ino);
+int xrep_parent_scan(struct xfs_scrub *sc, xfs_ino_t *parent_ino);
+
+xfs_ino_t xrep_parent_self_reference(struct xfs_scrub *sc);
+
+#endif /* __XFS_SCRUB_PARENT_H__ */
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
new file mode 100644
index 000000000000..d275c2129176
--- /dev/null
+++ b/fs/xfs/scrub/parent_repair.c
@@ -0,0 +1,417 @@
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
+#include "xfs_defer.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_dir2.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_trans_space.h"
+#include "xfs_health.h"
+#include "xfs_swapext.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/iscan.h"
+#include "scrub/parent.h"
+#include "scrub/readdir.h"
+#include "scrub/tempfile.h"
+
+struct xrep_findparent_info {
+	/* The directory currently being scanned. */
+	struct xfs_inode	*dp;
+
+	/*
+	 * Scrub context.  We're looking for a @dp containing a directory
+	 * entry pointing to sc->ip->i_ino.
+	 */
+	struct xfs_scrub	*sc;
+
+	/*
+	 * Parent that we've found for sc->ip.  If we're scanning the entire
+	 * directory tree, we need this to ensure that we only find /one/
+	 * parent directory.
+	 */
+	xfs_ino_t		found_parent;
+
+	/*
+	 * This is set to true if @found_parent was not observed directly from
+	 * the directory scan but by noticing a change in dotdot entries after
+	 * cycling the sc->ip IOLOCK.
+	 */
+	bool			parent_tentative;
+};
+
+/*
+ * If this directory entry points to the scrub target inode, then the directory
+ * we're scanning is the parent of the scrub target inode.
+ */
+STATIC int
+xrep_findparent_dirent(
+	struct xfs_scrub		*sc,
+	struct xfs_inode		*dp,
+	xfs_dir2_dataptr_t		dapos,
+	const struct xfs_name		*name,
+	xfs_ino_t			ino,
+	void				*priv)
+{
+	struct xrep_findparent_info	*fpi = priv;
+	int				error = 0;
+
+	if (xchk_should_terminate(fpi->sc, &error))
+		return error;
+
+	if (ino != fpi->sc->ip->i_ino)
+		return 0;
+
+	/* Ignore garbage directory entry names. */
+	if (name->len == 0 || !xfs_dir2_namecheck(name->name, name->len))
+		return -EFSCORRUPTED;
+
+	/*
+	 * Ignore dotdot and dot entries -- we're looking for parent -> child
+	 * links only.
+	 */
+	if (name->name[0] == '.' && (name->len == 1 ||
+				     (name->len == 2 && name->name[1] == '.')))
+		return 0;
+
+	/* Uhoh, more than one parent for a dir? */
+	if (fpi->found_parent != NULLFSINO &&
+	    !(fpi->parent_tentative && fpi->found_parent == fpi->dp->i_ino)) {
+		trace_xrep_findparent_dirent(fpi->sc->ip, 0);
+		return -EFSCORRUPTED;
+	}
+
+	/* We found a potential parent; remember this. */
+	trace_xrep_findparent_dirent(fpi->sc->ip, fpi->dp->i_ino);
+	fpi->found_parent = fpi->dp->i_ino;
+	fpi->parent_tentative = false;
+	return 0;
+}
+
+/*
+ * If this is a directory, walk the dirents looking for any that point to the
+ * scrub target inode.
+ */
+STATIC int
+xrep_findparent_walk_directory(
+	struct xrep_findparent_info	*fpi)
+{
+	struct xfs_scrub		*sc = fpi->sc;
+	struct xfs_inode		*dp = fpi->dp;
+	unsigned int			lock_mode;
+	int				error = 0;
+
+	/*
+	 * The inode being scanned cannot be its own parent, nor can any
+	 * temporary directory we created to stage this repair.
+	 */
+	if (dp == sc->ip || dp == sc->tempip)
+		return 0;
+
+	/*
+	 * Similarly, temporary files created to stage a repair cannot be the
+	 * parent of this inode.
+	 */
+	if (xrep_is_tempfile(dp))
+		return 0;
+
+	/* Try to lock dp; if we can, we're ready to scan! */
+	if (!xfs_ilock_nowait(dp, XFS_IOLOCK_SHARED)) {
+		xfs_ino_t	orig_parent, new_parent;
+
+		/*
+		 * We may have to drop the lock on sc->ip to try to lock dp.
+		 * Therefore, look up the old dotdot entry for sc->ip so that
+		 * we can compare it after we re-lock sc->ip.
+		 */
+		orig_parent = xrep_dotdot_lookup(sc);
+
+		error = xchk_parent_lock_two_dirs(sc, dp);
+		if (error)
+			return error;
+
+		/*
+		 * It is possible that sc->ip got moved elsewhere in the
+		 * directory tree if we dropped sc->ip to grab dp.  Note that
+		 * rename operations replace the dotdot entry without checking
+		 * the old value.
+		 *
+		 * If the dotdot entry was wrong but there really was only one
+		 * parent of sc->ip, then the dotdot entry could now be
+		 * correct.  Record this new parent as a tentative parent and
+		 * keep scanning.  If there are more parents of this directory,
+		 * we must not touch anything.
+		 */
+		new_parent = xrep_dotdot_lookup(sc);
+
+		if (orig_parent != new_parent || VFS_I(sc->ip)->i_nlink == 0) {
+			fpi->found_parent = new_parent;
+			fpi->parent_tentative = true;
+		}
+	}
+
+	/*
+	 * If this directory is known to be sick, we cannot scan it reliably
+	 * and must abort.
+	 */
+	if (xfs_inode_has_sickness(dp, XFS_SICK_INO_CORE |
+				       XFS_SICK_INO_BMBTD |
+				       XFS_SICK_INO_DIR)) {
+		error = -EFSCORRUPTED;
+		goto out_unlock;
+	}
+
+	/*
+	 * Scan the directory to see if there it contains an entry pointing to
+	 * the directory that we are repairing.
+	 */
+	lock_mode = xfs_ilock_data_map_shared(dp);
+
+	/*
+	 * We cannot complete our parent pointer scan if a directory looks as
+	 * though it has been zapped by the inode record repair code.
+	 */
+	if (xchk_dir_looks_zapped(dp))
+		error = -EFSCORRUPTED;
+	if (!error)
+		error = xchk_dir_walk(sc, dp, xrep_findparent_dirent, fpi);
+	xfs_iunlock(dp, lock_mode);
+	if (error)
+		goto out_unlock;
+
+out_unlock:
+	xfs_iunlock(dp, XFS_IOLOCK_SHARED);
+	return error;
+}
+
+/*
+ * Confirm that the directory @parent_ino actually contains a directory entry
+ * pointing to the child @sc->ip->ino.  This function returns one of several
+ * ways:
+ *
+ * Returns 0 with @parent_ino unchanged if the parent was confirmed.
+ * Returns 0 with a different @parent_ino if we had to cycle inode locks to
+ * walk the alleged parent and the child's '..' entry was changed in the mean
+ * time.
+ * Returns 0 with @parent_ino set to NULLFSINO if the parent was not valid.
+ * Returns the usual negative errno if something else happened.
+ */
+int
+xrep_parent_confirm(
+	struct xfs_scrub	*sc,
+	xfs_ino_t		*parent_ino)
+{
+	struct xrep_findparent_info fpi = {
+		.sc		= sc,
+		.found_parent	= NULLFSINO,
+	};
+	int			error;
+
+	/*
+	 * The root directory always points to itself.  Unlinked dirs can point
+	 * anywhere, so we point them at the root dir too.
+	 */
+	if (sc->ip == sc->mp->m_rootip || VFS_I(sc->ip)->i_nlink == 0) {
+		*parent_ino = sc->mp->m_sb.sb_rootino;
+		return 0;
+	}
+
+	/* Reject garbage parent inode numbers and self-referential parents. */
+	if (*parent_ino == NULLFSINO)
+	       return 0;
+	if (!xfs_verify_dir_ino(sc->mp, *parent_ino) ||
+	    *parent_ino == sc->ip->i_ino) {
+		*parent_ino = NULLFSINO;
+		return 0;
+	}
+
+	error = xchk_iget(sc, *parent_ino, &fpi.dp);
+	if (error)
+		return error;
+
+	if (!S_ISDIR(VFS_I(fpi.dp)->i_mode)) {
+		*parent_ino = NULLFSINO;
+		goto out_rele;
+	}
+
+	error = xrep_findparent_walk_directory(&fpi);
+	if (error)
+		goto out_rele;
+
+	*parent_ino = fpi.found_parent;
+out_rele:
+	xchk_irele(sc, fpi.dp);
+	return error;
+}
+
+/*
+ * Scan the entire filesystem looking for a parent inode for the inode being
+ * scrubbed.  @sc->ip must not be the root of a directory tree.
+ *
+ * Returns 0 with @parent_ino set to the parent that we found, or the current
+ * value of the child's '..' entry, if it changed when we had to drop the
+ * child's IOLOCK.
+ * Returns 0 with @parent_ino set to NULLFSINO if we didn't find anything.
+ * Returns the usual negative errno if something else happened.
+ */
+int
+xrep_parent_scan(
+	struct xfs_scrub		*sc,
+	xfs_ino_t			*parent_ino)
+{
+	struct xrep_findparent_info	fpi = {
+		.sc			= sc,
+		.found_parent		= NULLFSINO,
+	};
+	struct xchk_iscan		iscan = { };
+	int				ret;
+
+	/*
+	 * The caller holds a non-empty transaction and a directory ILOCK.
+	 * Hence we cannot block the system indefinitely in iget, so we will
+	 * retry rapidly for up to five seconds before aborting the operation.
+	 */
+	iscan.iget_nowait = true;
+	xchk_iscan_start(&iscan, 5000, 1);
+
+	while ((ret = xchk_iscan_iter(sc, &iscan, &fpi.dp)) == 1) {
+		if (S_ISDIR(VFS_I(fpi.dp)->i_mode))
+			ret = xrep_findparent_walk_directory(&fpi);
+		else
+			ret = 0;
+		xchk_iscan_mark_visited(&iscan, fpi.dp);
+		xchk_irele(sc, fpi.dp);
+		if (ret)
+			break;
+
+		if (xchk_should_terminate(sc, &ret))
+			break;
+	}
+	xchk_iscan_finish(&iscan);
+	if (ret)
+		return ret;
+
+	*parent_ino = fpi.found_parent;
+	return 0;
+}
+
+/*
+ * If we're the root of a directory tree, we are our own parent.  If we're an
+ * unlinked directory, the parent /won't/ have a link to us.  Set the parent
+ * directory to the root for both cases.  Returns NULLFSINO if we don't know
+ * what to do.
+ */
+xfs_ino_t
+xrep_parent_self_reference(
+	struct xfs_scrub	*sc)
+{
+	if (sc->ip->i_ino == sc->mp->m_sb.sb_rootino)
+		return sc->mp->m_sb.sb_rootino;
+
+	if (VFS_I(sc->ip)->i_nlink == 0)
+		return sc->mp->m_sb.sb_rootino;
+
+	return NULLFSINO;
+}
+
+/*
+ * Repairing The Directory Parent Pointer
+ * ======================================
+ *
+ * Currently, only directories support parent pointers (in the form of '..'
+ * entries), so we simply scan the filesystem and update the '..' entry.
+ *
+ * Note that because the only parent pointer is the dotdot entry, we won't
+ * touch an unhealthy directory, since the directory repair code is perfectly
+ * capable of rebuilding a directory with the proper parent inode.
+ */
+
+/* Replace a directory's parent '..' pointer. */
+STATIC int
+xrep_parent_reset_dir(
+	struct xfs_scrub	*sc,
+	xfs_ino_t		parent_ino)
+{
+	unsigned int		spaceres;
+	int			error;
+
+	trace_xrep_parent_reset_dir(sc->ip, parent_ino);
+
+	/*
+	 * Reserve more space just in case we have to expand the dir.  We're
+	 * allowed to exceed quota to repair inconsistent metadata.
+	 */
+	spaceres = XFS_RENAME_SPACE_RES(sc->mp, 2);
+	error = xfs_trans_reserve_more_inode(sc->tp, sc->ip, spaceres, 0,
+			true);
+	if (error)
+		return error;
+
+	/* Replace the dotdot entry. */
+	return xfs_dir_replace(sc->tp, sc->ip, &xfs_name_dotdot, parent_ino,
+			spaceres);
+}
+
+int
+xrep_parent(
+	struct xfs_scrub	*sc)
+{
+	xfs_ino_t		parent_ino, curr_parent;
+	unsigned int		sick, checked;
+	int			error;
+
+	/*
+	 * Avoid sick directories.  The parent pointer scrubber dropped the
+	 * ILOCK and MMAPLOCK, but we still hold IOLOCK_EXCL on the directory.
+	 * There shouldn't be anyone else clearing the directory's sick status.
+	 */
+	xfs_inode_measure_sickness(sc->ip, &sick, &checked);
+	if (sick & XFS_SICK_INO_DIR)
+		return -EFSCORRUPTED;
+
+	parent_ino = xrep_parent_self_reference(sc);
+	if (parent_ino != NULLFSINO)
+		goto reset_parent;
+
+	/* Scan the entire filesystem for a parent. */
+	error = xrep_parent_scan(sc, &parent_ino);
+	if (error)
+		return error;
+	if (parent_ino == NULLFSINO)
+		return -EFSCORRUPTED;
+
+reset_parent:
+	/* If the '..' entry is already set to the parent inode, we're done. */
+	curr_parent = xrep_dotdot_lookup(sc);
+	if (curr_parent != NULLFSINO && curr_parent == parent_ino)
+		return 0;
+
+	/* Last chance to abort before we start committing fixes. */
+	if (xchk_should_terminate(sc, &error))
+		return error;
+
+	/* Re-take the ILOCK, we're going to need it to modify the dir. */
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+
+	return xrep_parent_reset_dir(sc, parent_ino);
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 5fccc9c81d8f..acd7fccf8bee 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -122,6 +122,7 @@ int xrep_nlinks(struct xfs_scrub *sc);
 int xrep_fscounters(struct xfs_scrub *sc);
 int xrep_xattr(struct xfs_scrub *sc);
 int xrep_directory(struct xfs_scrub *sc);
+int xrep_parent(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
@@ -234,6 +235,7 @@ xrep_setup_rtsummary(
 #define xrep_rtsummary			xrep_notsupported
 #define xrep_xattr			xrep_notsupported
 #define xrep_directory			xrep_notsupported
+#define xrep_parent			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 1695e9d2f104..39ad06e6b2d0 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -345,7 +345,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_parent,
 		.scrub	= xchk_parent,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_parent,
 	},
 	[XFS_SCRUB_TYPE_RTBITMAP] = {	/* realtime bitmap */
 		.type	= ST_FS,
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index b35b7d5a3767..b27abaa84d11 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2476,6 +2476,7 @@ DEFINE_EVENT(xrep_dir_class, name, \
 	TP_ARGS(dp, parent_ino))
 DEFINE_XREP_DIR_CLASS(xrep_dir_rebuild_tree);
 DEFINE_XREP_DIR_CLASS(xrep_dir_reset_fork);
+DEFINE_XREP_DIR_CLASS(xrep_parent_reset_dir);
 
 DECLARE_EVENT_CLASS(xrep_dirent_class,
 	TP_PROTO(struct xfs_inode *dp, struct xfs_name *name, xfs_ino_t ino),
@@ -2533,6 +2534,7 @@ DEFINE_EVENT(xrep_parent_salvage_class, name, \
 	TP_PROTO(struct xfs_inode *dp, xfs_ino_t ino), \
 	TP_ARGS(dp, ino))
 DEFINE_XREP_PARENT_SALVAGE_CLASS(xrep_dir_salvaged_parent);
+DEFINE_XREP_PARENT_SALVAGE_CLASS(xrep_findparent_dirent);
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 

