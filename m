Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D54C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:35:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235569AbiL3Xf5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235512AbiL3Xf4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:35:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB4BD5F88
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:35:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 388ED61C31
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:35:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901EEC433EF;
        Fri, 30 Dec 2022 23:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443353;
        bh=bBqgc2DfbC9S1zLpofDidpwvl7byykE6W+rjQ1FKfUY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=eoXE7z5KthsJ1LpnpXOqkMskHUUOeKiFxpKi8gvE9XAiJhAGWyr8It1q9mIUQm6Fz
         BFodxUlrztbFzaMyC93NWdIXzYuJZ0ilDHtPSjL7OisA0s7zBSr1r/v0gjIE19oAt3
         tNm2juyglikBYp3hcwqbEL/AJaFTpGSVEAcIQb113pqN2gzBzbpEGdAq2C2AbAdRo/
         pJoQfkfA6Ao7r2n700esoHmbcmnf5Yv6BxcbWzZkpCE5YcHu5keIihuJQzrFj1Pbvz
         ddfL8h8TmBhhtdNUsFFws9fcGN2Uh5QheG0quqh9hUUKdOOWwWY9Ig3fwoyw0z3lW6
         wfHiUwM/dSPgg==
Subject: [PATCH 2/5] xfs: streamline the directory iteration code for scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:11 -0800
Message-ID: <167243839097.695835.1183184695782767344.stgit@magnolia>
In-Reply-To: <167243839062.695835.16105316950703126803.stgit@magnolia>
References: <167243839062.695835.16105316950703126803.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Currently, online scrub reuses the xfs_readdir code to walk every entry
in a directory.  This isn't awesome for performance, since we end up
cycling the directory ILOCK needlessly and coding around the particular
quirks of the VFS dir_context interface.

Create a streamlined version of readdir that keeps the ILOCK (since the
walk function isn't going to copy stuff to userspace), skips a whole lot
of directory walk cursor checks (since we start at 0 and walk to the
end) and has a sane way to return error codes.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile        |    1 
 fs/xfs/scrub/dir.c     |  173 +++++++---------------
 fs/xfs/scrub/parent.c  |   90 +++---------
 fs/xfs/scrub/readdir.c |  375 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/readdir.h |   19 ++
 5 files changed, 473 insertions(+), 185 deletions(-)
 create mode 100644 fs/xfs/scrub/readdir.c
 create mode 100644 fs/xfs/scrub/readdir.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 30e555eac02e..a762ee3cc454 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -159,6 +159,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   ialloc.o \
 				   inode.o \
 				   parent.o \
+				   readdir.o \
 				   refcount.o \
 				   rmap.o \
 				   scrub.o \
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 5b3a9edc8932..5b47d3cc8f78 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -18,6 +18,7 @@
 #include "scrub/scrub.h"
 #include "scrub/common.h"
 #include "scrub/dabtree.h"
+#include "scrub/readdir.h"
 
 /* Set us up to scrub directories. */
 int
@@ -31,115 +32,88 @@ xchk_setup_directory(
 
 /* Scrub a directory entry. */
 
-struct xchk_dir_ctx {
-	/* VFS fill-directory iterator */
-	struct dir_context	dir_iter;
-
-	struct xfs_scrub	*sc;
-};
-
-/* Check that an inode's mode matches a given DT_ type. */
+/* Check that an inode's mode matches a given XFS_DIR3_FT_* type. */
 STATIC void
 xchk_dir_check_ftype(
-	struct xchk_dir_ctx	*sdc,
+	struct xfs_scrub	*sc,
 	xfs_fileoff_t		offset,
 	struct xfs_inode	*ip,
-	int			dtype)
+	int			ftype)
 {
-	struct xfs_mount	*mp = sdc->sc->mp;
-	int			ino_dtype;
+	struct xfs_mount	*mp = sc->mp;
 
 	if (!xfs_has_ftype(mp)) {
-		if (dtype != DT_UNKNOWN && dtype != DT_DIR)
-			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
-					offset);
+		if (ftype != XFS_DIR3_FT_UNKNOWN && ftype != XFS_DIR3_FT_DIR)
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 		return;
 	}
 
-	/* Convert mode to the DT_* values that dir_emit uses. */
-	ino_dtype = xfs_dir3_get_dtype(mp,
-			xfs_mode_to_ftype(VFS_I(ip)->i_mode));
-	if (ino_dtype != dtype)
-		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
+	if (xfs_mode_to_ftype(VFS_I(ip)->i_mode) != ftype)
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 }
 
 /*
  * Scrub a single directory entry.
  *
- * We use the VFS directory iterator (i.e. readdir) to call this
- * function for every directory entry in a directory.  Once we're here,
- * we check the inode number to make sure it's sane, then we check that
- * we can look up this filename.  Finally, we check the ftype.
+ * Check the inode number to make sure it's sane, then we check that we can
+ * look up this filename.  Finally, we check the ftype.
  */
-STATIC bool
+STATIC int
 xchk_dir_actor(
-	struct dir_context	*dir_iter,
-	const char		*name,
-	int			namelen,
-	loff_t			pos,
-	u64			ino,
-	unsigned		type)
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp,
+	xfs_dir2_dataptr_t	dapos,
+	const struct xfs_name	*name,
+	xfs_ino_t		ino,
+	void			*priv)
 {
-	struct xfs_mount	*mp;
-	struct xfs_inode	*dp;
+	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_inode	*ip;
-	struct xchk_dir_ctx	*sdc;
-	struct xfs_name		xname;
 	xfs_ino_t		lookup_ino;
 	xfs_dablk_t		offset;
 	int			error = 0;
 
-	sdc = container_of(dir_iter, struct xchk_dir_ctx, dir_iter);
-	dp = sdc->sc->ip;
-	mp = dp->i_mount;
 	offset = xfs_dir2_db_to_da(mp->m_dir_geo,
-			xfs_dir2_dataptr_to_db(mp->m_dir_geo, pos));
+			xfs_dir2_dataptr_to_db(mp->m_dir_geo, dapos));
 
-	if (xchk_should_terminate(sdc->sc, &error))
-		return !error;
+	if (xchk_should_terminate(sc, &error))
+		return error;
 
 	/* Does this inode number make sense? */
 	if (!xfs_verify_dir_ino(mp, ino)) {
-		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
-		goto out;
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		return -ECANCELED;
 	}
 
 	/* Does this name make sense? */
-	if (!xfs_dir2_namecheck(name, namelen)) {
-		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
-		goto out;
+	if (!xfs_dir2_namecheck(name->name, name->len)) {
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		return -ECANCELED;
 	}
 
-	if (!strncmp(".", name, namelen)) {
+	if (!strncmp(".", name->name, name->len)) {
 		/* If this is "." then check that the inum matches the dir. */
 		if (ino != dp->i_ino)
-			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
-					offset);
-	} else if (!strncmp("..", name, namelen)) {
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+	} else if (!strncmp("..", name->name, name->len)) {
 		/*
 		 * If this is ".." in the root inode, check that the inum
 		 * matches this dir.
 		 */
 		if (dp->i_ino == mp->m_sb.sb_rootino && ino != dp->i_ino)
-			xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK,
-					offset);
+			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
 	}
 
 	/* Verify that we can look up this name by hash. */
-	xname.name = name;
-	xname.len = namelen;
-	xname.type = XFS_DIR3_FT_UNKNOWN;
-
-	error = xfs_dir_lookup(sdc->sc->tp, dp, &xname, &lookup_ino, NULL);
+	error = xchk_dir_lookup(sc, dp, name, &lookup_ino);
 	/* ENOENT means the hash lookup failed and the dir is corrupt */
 	if (error == -ENOENT)
 		error = -EFSCORRUPTED;
-	if (!xchk_fblock_process_error(sdc->sc, XFS_DATA_FORK, offset,
-			&error))
+	if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, offset, &error))
 		goto out;
 	if (lookup_ino != ino) {
-		xchk_fblock_set_corrupt(sdc->sc, XFS_DATA_FORK, offset);
-		goto out;
+		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, offset);
+		return -ECANCELED;
 	}
 
 	/*
@@ -151,27 +125,21 @@ xchk_dir_actor(
 	 * -EFSCORRUPTED or -EFSBADCRC then the child is corrupt which is a
 	 *  cross referencing error.  Any other error is an operational error.
 	 */
-	error = xchk_iget(sdc->sc, ino, &ip);
+	error = xchk_iget(sc, ino, &ip);
 	if (error == -EINVAL || error == -ENOENT) {
 		error = -EFSCORRUPTED;
-		xchk_fblock_process_error(sdc->sc, XFS_DATA_FORK, 0, &error);
+		xchk_fblock_process_error(sc, XFS_DATA_FORK, 0, &error);
 		goto out;
 	}
-	if (!xchk_fblock_xref_process_error(sdc->sc, XFS_DATA_FORK, offset,
-			&error))
+	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, offset, &error))
 		goto out;
 
-	xchk_dir_check_ftype(sdc, offset, ip, type);
-	xchk_irele(sdc->sc, ip);
+	xchk_dir_check_ftype(sc, offset, ip, name->type);
+	xchk_irele(sc, ip);
 out:
-	/*
-	 * A negative error code returned here is supposed to cause the
-	 * dir_emit caller (xfs_readdir) to abort the directory iteration
-	 * and return zero to xchk_directory.
-	 */
-	if (error == 0 && sdc->sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		return false;
-	return !error;
+	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
+		return -ECANCELED;
+	return error;
 }
 
 /* Scrub a directory btree record. */
@@ -782,14 +750,7 @@ int
 xchk_directory(
 	struct xfs_scrub	*sc)
 {
-	struct xchk_dir_ctx	sdc = {
-		.dir_iter.actor = xchk_dir_actor,
-		.dir_iter.pos = 0,
-		.sc = sc,
-	};
-	size_t			bufsize;
-	loff_t			oldpos;
-	int			error = 0;
+	int			error;
 
 	if (!S_ISDIR(VFS_I(sc->ip)->i_mode))
 		return -ENOENT;
@@ -797,7 +758,7 @@ xchk_directory(
 	/* Plausible size? */
 	if (sc->ip->i_disk_size < xfs_dir2_sf_hdr_size(0)) {
 		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
-		goto out;
+		return 0;
 	}
 
 	/* Check directory tree structure */
@@ -806,7 +767,7 @@ xchk_directory(
 		return error;
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		return error;
+		return 0;
 
 	/* Check the freespace. */
 	error = xchk_directory_blocks(sc);
@@ -814,44 +775,12 @@ xchk_directory(
 		return error;
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
-		return error;
+		return 0;
 
-	/*
-	 * Check that every dirent we see can also be looked up by hash.
-	 * Userspace usually asks for a 32k buffer, so we will too.
-	 */
-	bufsize = (size_t)min_t(loff_t, XFS_READDIR_BUFSIZE,
-			sc->ip->i_disk_size);
-
-	/*
-	 * Look up every name in this directory by hash.
-	 *
-	 * Use the xfs_readdir function to call xchk_dir_actor on
-	 * every directory entry in this directory.  In _actor, we check
-	 * the name, inode number, and ftype (if applicable) of the
-	 * entry.  xfs_readdir uses the VFS filldir functions to provide
-	 * iteration context.
-	 *
-	 * The VFS grabs a read or write lock via i_rwsem before it reads
-	 * or writes to a directory.  If we've gotten this far we've
-	 * already obtained IOLOCK_EXCL, which (since 4.10) is the same as
-	 * getting a write lock on i_rwsem.  Therefore, it is safe for us
-	 * to drop the ILOCK here in order to reuse the _readdir and
-	 * _dir_lookup routines, which do their own ILOCK locking.
-	 */
-	oldpos = 0;
-	xchk_iunlock(sc, XFS_ILOCK_EXCL);
-	while (true) {
-		error = xfs_readdir(sc->tp, sc->ip, &sdc.dir_iter, bufsize);
-		if (!xchk_fblock_process_error(sc, XFS_DATA_FORK, 0,
-				&error))
-			goto out;
-		if (oldpos == sdc.dir_iter.pos)
-			break;
-		oldpos = sdc.dir_iter.pos;
-	}
-
-out:
+	/* Look up every name in this directory by hash. */
+	error = xchk_dir_walk(sc, sc->ip, xchk_dir_actor, NULL);
+	if (error == -ECANCELED)
+		error = 0;
 	return error;
 }
 
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index 371526f4369d..84740ffee0d2 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -16,6 +16,7 @@
 #include "xfs_dir2_priv.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
+#include "scrub/readdir.h"
 
 /* Set us up to scrub parents. */
 int
@@ -30,39 +31,37 @@ xchk_setup_parent(
 /* Look for an entry in a parent pointing to this inode. */
 
 struct xchk_parent_ctx {
-	struct dir_context	dc;
 	struct xfs_scrub	*sc;
 	xfs_ino_t		ino;
 	xfs_nlink_t		nlink;
-	bool			cancelled;
 };
 
 /* Look for a single entry in a directory pointing to an inode. */
-STATIC bool
+STATIC int
 xchk_parent_actor(
-	struct dir_context	*dc,
-	const char		*name,
-	int			namelen,
-	loff_t			pos,
-	u64			ino,
-	unsigned		type)
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp,
+	xfs_dir2_dataptr_t	dapos,
+	const struct xfs_name	*name,
+	xfs_ino_t		ino,
+	void			*priv)
 {
-	struct xchk_parent_ctx	*spc;
+	struct xchk_parent_ctx	*spc = priv;
 	int			error = 0;
 
-	spc = container_of(dc, struct xchk_parent_ctx, dc);
+	/* Does this name make sense? */
+	if (!xfs_dir2_namecheck(name->name, name->len))
+		error = -EFSCORRUPTED;
+	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
+		return error;
+
 	if (spc->ino == ino)
 		spc->nlink++;
 
-	/*
-	 * If we're facing a fatal signal, bail out.  Store the cancellation
-	 * status separately because the VFS readdir code squashes error codes
-	 * into short directory reads.
-	 */
 	if (xchk_should_terminate(spc->sc, &error))
-		spc->cancelled = true;
+		return error;
 
-	return !error;
+	return 0;
 }
 
 /* Count the number of dentries in the parent dir that point to this inode. */
@@ -70,24 +69,11 @@ STATIC int
 xchk_parent_count_parent_dentries(
 	struct xfs_scrub	*sc,
 	struct xfs_inode	*parent,
-	xfs_nlink_t		*nlink)
+	struct xchk_parent_ctx	*spc)
 {
-	struct xchk_parent_ctx	spc = {
-		.dc.actor	= xchk_parent_actor,
-		.ino		= sc->ip->i_ino,
-		.sc		= sc,
-	};
-	size_t			bufsize;
-	loff_t			oldpos;
 	uint			lock_mode;
-	int			error = 0;
+	int			error;
 
-	/*
-	 * If there are any blocks, read-ahead block 0 as we're almost
-	 * certain to have the next operation be a read there.  This is
-	 * how we guarantee that the parent's extent map has been loaded,
-	 * if there is one.
-	 */
 	lock_mode = xfs_ilock_data_map_shared(parent);
 
 	/*
@@ -100,34 +86,8 @@ xchk_parent_count_parent_dentries(
 		return -EFSCORRUPTED;
 	}
 
-	if (parent->i_df.if_nextents > 0)
-		error = xfs_dir3_data_readahead(parent, 0, 0);
+	error = xchk_dir_walk(sc, parent, xchk_parent_actor, spc);
 	xfs_iunlock(parent, lock_mode);
-	if (error)
-		return error;
-
-	/*
-	 * Iterate the parent dir to confirm that there is
-	 * exactly one entry pointing back to the inode being
-	 * scanned.
-	 */
-	bufsize = (size_t)min_t(loff_t, XFS_READDIR_BUFSIZE,
-			parent->i_disk_size);
-	oldpos = 0;
-	while (true) {
-		error = xfs_readdir(sc->tp, parent, &spc.dc, bufsize);
-		if (error)
-			goto out;
-		if (spc.cancelled) {
-			error = -EAGAIN;
-			goto out;
-		}
-		if (oldpos == spc.dc.pos)
-			break;
-		oldpos = spc.dc.pos;
-	}
-	*nlink = spc.nlink;
-out:
 	return error;
 }
 
@@ -180,9 +140,13 @@ xchk_parent_validate(
 	struct xfs_scrub	*sc,
 	xfs_ino_t		parent_ino)
 {
+	struct xchk_parent_ctx	spc = {
+		.sc		= sc,
+		.ino		= sc->ip->i_ino,
+		.nlink		= 0,
+	};
 	struct xfs_inode	*dp = NULL;
 	xfs_nlink_t		expected_nlink;
-	xfs_nlink_t		nlink;
 	int			error = 0;
 
 	if (sc->sm->sm_flags & XFS_SCRUB_OFLAG_CORRUPT)
@@ -260,7 +224,7 @@ xchk_parent_validate(
 	}
 
 	/* Look for a directory entry in the parent pointing to the child. */
-	error = xchk_parent_count_parent_dentries(sc, dp, &nlink);
+	error = xchk_parent_count_parent_dentries(sc, dp, &spc);
 	if (!xchk_fblock_xref_process_error(sc, XFS_DATA_FORK, 0, &error))
 		goto out_unlock;
 
@@ -268,7 +232,7 @@ xchk_parent_validate(
 	 * Ensure that the parent has as many links to the child as the child
 	 * thinks it has to the parent.
 	 */
-	if (nlink != expected_nlink)
+	if (spc.nlink != expected_nlink)
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
 
 out_unlock:
diff --git a/fs/xfs/scrub/readdir.c b/fs/xfs/scrub/readdir.c
new file mode 100644
index 000000000000..fd888fe5151f
--- /dev/null
+++ b/fs/xfs/scrub/readdir.c
@@ -0,0 +1,375 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_trace.h"
+#include "xfs_bmap.h"
+#include "xfs_trans.h"
+#include "xfs_error.h"
+#include "scrub/scrub.h"
+#include "scrub/readdir.h"
+
+/* Call a function for every entry in a shortform directory. */
+STATIC int
+xchk_dir_walk_sf(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp,
+	xchk_dirent_fn		dirent_fn,
+	void			*priv)
+{
+	struct xfs_name		name = {
+		.name		= ".",
+		.len		= 1,
+		.type		= XFS_DIR3_FT_DIR,
+	};
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_da_geometry	*geo = mp->m_dir_geo;
+	struct xfs_dir2_sf_entry *sfep;
+	struct xfs_dir2_sf_hdr	*sfp;
+	xfs_ino_t		ino;
+	xfs_dir2_dataptr_t	dapos;
+	unsigned int		i;
+	int			error;
+
+	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
+	ASSERT(dp->i_df.if_u1.if_data != NULL);
+
+	sfp = (struct xfs_dir2_sf_hdr *)dp->i_df.if_u1.if_data;
+
+	/* dot entry */
+	dapos = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
+			geo->data_entry_offset);
+
+	error = dirent_fn(sc, dp, dapos, &name, dp->i_ino, priv);
+	if (error)
+		return error;
+
+	/* dotdot entry */
+	dapos = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
+			geo->data_entry_offset +
+			xfs_dir2_data_entsize(mp, sizeof(".") - 1));
+	ino = xfs_dir2_sf_get_parent_ino(sfp);
+	name.name = "..";
+	name.len = 2;
+
+	error = dirent_fn(sc, dp, dapos, &name, ino, priv);
+	if (error)
+		return error;
+
+	/* iterate everything else */
+	sfep = xfs_dir2_sf_firstentry(sfp);
+	for (i = 0; i < sfp->count; i++) {
+		dapos = xfs_dir2_db_off_to_dataptr(geo, geo->datablk,
+				xfs_dir2_sf_get_offset(sfep));
+		ino = xfs_dir2_sf_get_ino(mp, sfp, sfep);
+		name.name = sfep->name;
+		name.len = sfep->namelen;
+		name.type = xfs_dir2_sf_get_ftype(mp, sfep);
+
+		error = dirent_fn(sc, dp, dapos, &name, ino, priv);
+		if (error)
+			return error;
+
+		sfep = xfs_dir2_sf_nextentry(mp, sfp, sfep);
+	}
+
+	return 0;
+}
+
+/* Call a function for every entry in a block directory. */
+STATIC int
+xchk_dir_walk_block(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp,
+	xchk_dirent_fn		dirent_fn,
+	void			*priv)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_da_geometry	*geo = mp->m_dir_geo;
+	struct xfs_buf		*bp;
+	unsigned int		off, next_off, end;
+	int			error;
+
+	error = xfs_dir3_block_read(sc->tp, dp, &bp);
+	if (error)
+		return error;
+
+	/* Walk each directory entry. */
+	end = xfs_dir3_data_end_offset(geo, bp->b_addr);
+	for (off = geo->data_entry_offset; off < end; off = next_off) {
+		struct xfs_name			name = { };
+		struct xfs_dir2_data_unused	*dup = bp->b_addr + off;
+		struct xfs_dir2_data_entry	*dep = bp->b_addr + off;
+		xfs_ino_t			ino;
+		xfs_dir2_dataptr_t		dapos;
+
+		/* Skip an empty entry. */
+		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
+			next_off = off + be16_to_cpu(dup->length);
+			continue;
+		}
+
+		/* Otherwise, find the next entry and report it. */
+		next_off = off + xfs_dir2_data_entsize(mp, dep->namelen);
+		if (next_off > end)
+			break;
+
+		dapos = xfs_dir2_db_off_to_dataptr(geo, geo->datablk, off);
+		ino = be64_to_cpu(dep->inumber);
+		name.name = dep->name;
+		name.len = dep->namelen;
+		name.type = xfs_dir2_data_get_ftype(mp, dep);
+
+		error = dirent_fn(sc, dp, dapos, &name, ino, priv);
+		if (error)
+			break;
+	}
+
+	xfs_trans_brelse(sc->tp, bp);
+	return error;
+}
+
+/* Read a leaf-format directory buffer. */
+STATIC int
+xchk_read_leaf_dir_buf(
+	struct xfs_trans	*tp,
+	struct xfs_inode	*dp,
+	struct xfs_da_geometry	*geo,
+	xfs_dir2_off_t		*curoff,
+	struct xfs_buf		**bpp)
+{
+	struct xfs_iext_cursor	icur;
+	struct xfs_bmbt_irec	map;
+	struct xfs_ifork	*ifp = xfs_ifork_ptr(dp, XFS_DATA_FORK);
+	xfs_dablk_t		last_da;
+	xfs_dablk_t		map_off;
+	xfs_dir2_off_t		new_off;
+
+	*bpp = NULL;
+
+	/*
+	 * Look for mapped directory blocks at or above the current offset.
+	 * Truncate down to the nearest directory block to start the scanning
+	 * operation.
+	 */
+	last_da = xfs_dir2_byte_to_da(geo, XFS_DIR2_LEAF_OFFSET);
+	map_off = xfs_dir2_db_to_da(geo, xfs_dir2_byte_to_db(geo, *curoff));
+
+	if (!xfs_iext_lookup_extent(dp, ifp, map_off, &icur, &map))
+		return 0;
+	if (map.br_startoff >= last_da)
+		return 0;
+	xfs_trim_extent(&map, map_off, last_da - map_off);
+
+	/* Read the directory block of that first mapping. */
+	new_off = xfs_dir2_da_to_byte(geo, map.br_startoff);
+	if (new_off > *curoff)
+		*curoff = new_off;
+
+	return xfs_dir3_data_read(tp, dp, map.br_startoff, 0, bpp);
+}
+
+/* Call a function for every entry in a leaf directory. */
+STATIC int
+xchk_dir_walk_leaf(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp,
+	xchk_dirent_fn		dirent_fn,
+	void			*priv)
+{
+	struct xfs_mount	*mp = dp->i_mount;
+	struct xfs_da_geometry	*geo = mp->m_dir_geo;
+	struct xfs_buf		*bp = NULL;
+	xfs_dir2_off_t		curoff = 0;
+	unsigned int		offset = 0;
+	int			error;
+
+	/* Iterate every directory offset in this directory. */
+	while (curoff < XFS_DIR2_LEAF_OFFSET) {
+		struct xfs_name			name = { };
+		struct xfs_dir2_data_unused	*dup;
+		struct xfs_dir2_data_entry	*dep;
+		xfs_ino_t			ino;
+		unsigned int			length;
+		xfs_dir2_dataptr_t		dapos;
+
+		/*
+		 * If we have no buffer, or we're off the end of the
+		 * current buffer, need to get another one.
+		 */
+		if (!bp || offset >= geo->blksize) {
+			if (bp) {
+				xfs_trans_brelse(sc->tp, bp);
+				bp = NULL;
+			}
+
+			error = xchk_read_leaf_dir_buf(sc->tp, dp, geo, &curoff,
+					&bp);
+			if (error || !bp)
+				break;
+
+			/*
+			 * Find our position in the block.
+			 */
+			offset = geo->data_entry_offset;
+			curoff += geo->data_entry_offset;
+		}
+
+		/* Skip an empty entry. */
+		dup = bp->b_addr + offset;
+		if (be16_to_cpu(dup->freetag) == XFS_DIR2_DATA_FREE_TAG) {
+			length = be16_to_cpu(dup->length);
+			offset += length;
+			curoff += length;
+			continue;
+		}
+
+		/* Otherwise, find the next entry and report it. */
+		dep = bp->b_addr + offset;
+		length = xfs_dir2_data_entsize(mp, dep->namelen);
+
+		dapos = xfs_dir2_db_off_to_dataptr(geo, geo->datablk, offset);
+		ino = be64_to_cpu(dep->inumber);
+		name.name = dep->name;
+		name.len = dep->namelen;
+		name.type = xfs_dir2_data_get_ftype(mp, dep);
+
+		error = dirent_fn(sc, dp, dapos, &name, ino, priv);
+		if (error)
+			break;
+
+		/* Advance to the next entry. */
+		offset += length;
+		curoff += length;
+	}
+
+	if (bp)
+		xfs_trans_brelse(sc->tp, bp);
+	return error;
+}
+
+/*
+ * Call a function for every entry in a directory.
+ *
+ * Callers must hold the ILOCK.  File types are XFS_DIR3_FT_*.
+ */
+int
+xchk_dir_walk(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp,
+	xchk_dirent_fn		dirent_fn,
+	void			*priv)
+{
+	struct xfs_da_args	args = {
+		.dp		= dp,
+		.geo		= dp->i_mount->m_dir_geo,
+		.trans		= sc->tp,
+	};
+	bool			isblock;
+	int			error;
+
+	if (xfs_is_shutdown(dp->i_mount))
+		return -EIO;
+
+	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
+	ASSERT(xfs_isilocked(dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+		return xchk_dir_walk_sf(sc, dp, dirent_fn, priv);
+
+	/* dir2 functions require that the data fork is loaded */
+	error = xfs_iread_extents(sc->tp, dp, XFS_DATA_FORK);
+	if (error)
+		return error;
+
+	error = xfs_dir2_isblock(&args, &isblock);
+	if (error)
+		return error;
+
+	if (isblock)
+		return xchk_dir_walk_block(sc, dp, dirent_fn, priv);
+
+	return xchk_dir_walk_leaf(sc, dp, dirent_fn, priv);
+}
+
+/*
+ * Look up the inode number for an exact name in a directory.
+ *
+ * Callers must hold the ILOCK.  File types are XFS_DIR3_FT_*.  Names are not
+ * checked for correctness.
+ */
+int
+xchk_dir_lookup(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*name,
+	xfs_ino_t		*ino)
+{
+	struct xfs_da_args	args = {
+		.dp		= dp,
+		.geo		= dp->i_mount->m_dir_geo,
+		.trans		= sc->tp,
+		.name		= name->name,
+		.namelen	= name->len,
+		.filetype	= name->type,
+		.hashval	= xfs_dir2_hashname(dp->i_mount, name),
+		.whichfork	= XFS_DATA_FORK,
+		.op_flags	= XFS_DA_OP_OKNOENT,
+	};
+	bool			isblock, isleaf;
+	int			error;
+
+	if (xfs_is_shutdown(dp->i_mount))
+		return -EIO;
+
+	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
+	ASSERT(xfs_isilocked(dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+		error = xfs_dir2_sf_lookup(&args);
+		goto out_check_rval;
+	}
+
+	/* dir2 functions require that the data fork is loaded */
+	error = xfs_iread_extents(sc->tp, dp, XFS_DATA_FORK);
+	if (error)
+		return error;
+
+	error = xfs_dir2_isblock(&args, &isblock);
+	if (error)
+		return error;
+
+	if (isblock) {
+		error = xfs_dir2_block_lookup(&args);
+		goto out_check_rval;
+	}
+
+	error = xfs_dir2_isleaf(&args, &isleaf);
+	if (error)
+		return error;
+
+	if (isleaf) {
+		error = xfs_dir2_leaf_lookup(&args);
+		goto out_check_rval;
+	}
+
+	error = xfs_dir2_node_lookup(&args);
+
+out_check_rval:
+	if (error == -EEXIST)
+		error = 0;
+	if (!error)
+		*ino = args.inumber;
+	return error;
+}
diff --git a/fs/xfs/scrub/readdir.h b/fs/xfs/scrub/readdir.h
new file mode 100644
index 000000000000..7272f3bd28b4
--- /dev/null
+++ b/fs/xfs/scrub/readdir.h
@@ -0,0 +1,19 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2022 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_READDIR_H__
+#define __XFS_SCRUB_READDIR_H__
+
+typedef int (*xchk_dirent_fn)(struct xfs_scrub *sc, struct xfs_inode *dp,
+		xfs_dir2_dataptr_t dapos, const struct xfs_name *name,
+		xfs_ino_t ino, void *priv);
+
+int xchk_dir_walk(struct xfs_scrub *sc, struct xfs_inode *dp,
+		xchk_dirent_fn dirent_fn, void *priv);
+
+int xchk_dir_lookup(struct xfs_scrub *sc, struct xfs_inode *dp,
+		const struct xfs_name *name, xfs_ino_t *ino);
+
+#endif /* __XFS_SCRUB_READDIR_H__ */

