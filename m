Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B3E5C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjBPUtN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:49:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjBPUtM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:49:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A0E4BEA8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:49:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85FA1B829AB
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:49:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 198E2C433D2;
        Thu, 16 Feb 2023 20:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580546;
        bh=X9PXrtj8hR+byid9VmjGsqDgjdirDc7tNfm/3pOXrQM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=dxkiU/I3wU2Dz5WKUhA6DNW9prxnAhqObVDKH+jZqsYxLjtbD2pg0qLlRsAA3uH0x
         NRERLsDFrlXJIjUUOXE2+MyubOPbkGEniYVDJpOfw9AZ2+9V7wQ3d2kgjU/NqZLLB5
         S5L2/NDAPopsb+tr3lItb0jyOqPqmXTnY2nDgLf1rqUad4xU2w1PQJW0ALKUMcm/pM
         cBgCZnkBpingwGPt82/yXTzdESpppj+FGJKKlBH7XHQvjpbFzPDIOfTSGIpRZfphgD
         BgL1yEXLE5DKh7UmNfAKfF+qhrxumbcuZDdDYmS6f/NQobk520kYQWOPJGdbNNoy7n
         ZzhGxxCHjA6dw==
Date:   Thu, 16 Feb 2023 12:49:05 -0800
Subject: [PATCH 5/7] xfs: reconstruct directories from parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874540.3474898.6037173918747447444.stgit@magnolia>
In-Reply-To: <167657874461.3474898.12919390014293805981.stgit@magnolia>
References: <167657874461.3474898.12919390014293805981.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use the filesystem scanning infrastructure to walk the filesystem
looking for parent pointers and child dirents that reference the
directory that we're rebuilding.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile           |    1 
 fs/xfs/scrub/common.c     |   15 +
 fs/xfs/scrub/common.h     |   28 +
 fs/xfs/scrub/dir.c        |    9 
 fs/xfs/scrub/dir_repair.c |  940 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/repair.h     |   16 +
 fs/xfs/scrub/scrub.c      |    2 
 fs/xfs/scrub/tempfile.c   |   42 ++
 fs/xfs/scrub/tempfile.h   |    2 
 fs/xfs/scrub/trace.c      |    1 
 fs/xfs/scrub/trace.h      |   67 +++
 11 files changed, 1122 insertions(+), 1 deletion(-)
 create mode 100644 fs/xfs/scrub/dir_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 6a30b145491d..a32f6da27a86 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -178,6 +178,7 @@ xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 ifeq ($(CONFIG_XFS_ONLINE_REPAIR),y)
 xfs-y				+= $(addprefix scrub/, \
 				   agheader_repair.o \
+				   dir_repair.o \
 				   repair.o \
 				   tempfile.o \
 				   xfblob.o \
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 2874da088e8d..17a9bc610a76 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -551,6 +551,21 @@ xchk_ag_init(
 
 /* Per-scrubber setup functions */
 
+void
+xchk_trans_cancel(
+	struct xfs_scrub	*sc)
+{
+	xfs_trans_cancel(sc->tp);
+	sc->tp = NULL;
+}
+
+int
+xchk_trans_alloc_empty(
+	struct xfs_scrub	*sc)
+{
+	return xfs_trans_alloc_empty(sc->mp, &sc->tp);
+}
+
 /*
  * Grab an empty transaction so that we can re-grab locked buffers if
  * one of our btrees turns out to be cyclic.
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 423a98c39fb6..7720982adfc6 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -31,6 +31,9 @@ xchk_should_terminate(
 	return false;
 }
 
+void xchk_trans_cancel(struct xfs_scrub *sc);
+int xchk_trans_alloc_empty(struct xfs_scrub *sc);
+
 int xchk_trans_alloc(struct xfs_scrub *sc, uint resblks);
 bool xchk_process_error(struct xfs_scrub *sc, xfs_agnumber_t agno,
 		xfs_agblock_t bno, int *error);
@@ -159,4 +162,29 @@ void xchk_start_reaping(struct xfs_scrub *sc);
 
 void xchk_fshooks_enable(struct xfs_scrub *sc, unsigned int scrub_fshooks);
 
+#ifdef CONFIG_XFS_ONLINE_REPAIR
+/* Decide if a repair is required. */
+static inline bool xchk_needs_repair(const struct xfs_scrub_metadata *sm)
+{
+	return sm->sm_flags & (XFS_SCRUB_OFLAG_CORRUPT |
+			       XFS_SCRUB_OFLAG_XCORRUPT |
+			       XFS_SCRUB_OFLAG_PREEN);
+}
+
+/*
+ * "Should we prepare for a repair?"
+ *
+ * Return true if the caller permits us to repair metadata and we're not
+ * setting up for a post-repair evaluation.
+ */
+static inline bool xchk_could_repair(const struct xfs_scrub *sc)
+{
+	return (sc->sm->sm_flags & XFS_SCRUB_IFLAG_REPAIR) &&
+		!(sc->flags & XREP_ALREADY_FIXED);
+}
+#else
+# define xchk_needs_repair(sc)		(false)
+# define xchk_could_repair(sc)		(false)
+#endif /* CONFIG_XFS_ONLINE_REPAIR */
+
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 06783e4b95ad..d720f1e143dd 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -19,12 +19,21 @@
 #include "scrub/common.h"
 #include "scrub/dabtree.h"
 #include "scrub/readdir.h"
+#include "scrub/repair.h"
 
 /* Set us up to scrub directories. */
 int
 xchk_setup_directory(
 	struct xfs_scrub	*sc)
 {
+	int			error;
+
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_directory(sc);
+		if (error)
+			return error;
+	}
+
 	return xchk_setup_inode_contents(sc, 0);
 }
 
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
new file mode 100644
index 000000000000..a6576a29e784
--- /dev/null
+++ b/fs/xfs/scrub/dir_repair.c
@@ -0,0 +1,940 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2023 Oracle.  All Rights Reserved.
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
+#include "xfs_dir2_priv.h"
+#include "xfs_bmap.h"
+#include "xfs_quota.h"
+#include "xfs_bmap_btree.h"
+#include "xfs_trans_space.h"
+#include "xfs_bmap_util.h"
+#include "xfs_attr.h"
+#include "xfs_parent.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/tempfile.h"
+#include "scrub/iscan.h"
+#include "scrub/readdir.h"
+#include "scrub/listxattr.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/xfblob.h"
+
+/*
+ * Directory Repairs
+ * =================
+ *
+ * Reconstruct a directory by visiting each parent pointer of each file in the
+ * filesystem and translating the relevant pptrs into dirents.  Translation
+ * occurs by adding new dirents to a temporary directory, which formats the
+ * ondisk directory blocks.  In the final version of this code, we'll use the
+ * atomic extent swap code to exchange the entire directory structure of the
+ * file being repaired and the temporary, but for this PoC we omit the commit
+ * to reduce the amount of code that has to be ported.
+ *
+ * Because we have to scan the entire filesystem, the next patch introduces the
+ * inode scan and live update hooks so that the rebuilder can be kept aware of
+ * filesystem updates being made to this directory by other threads.  Directory
+ * entry translation therefore requires two steps to avoid problems with lock
+ * contention and to keep ondisk tempdir updates out of the hook path.
+ *
+ * Every time the filesystem scanner or the live update hook code encounter a
+ * directory operation relevant to this rebuilder, they will write a record of
+ * the createname/removename operation to an xfarray.  Dirent names are stored
+ * in an xfblob structure.  At opportune times, these stashed updates will be
+ * read from the xfarray and committed (individually) to the temporary
+ * directory.
+ *
+ * When the filesystem scan is complete, we relock both the directory and the
+ * tempdir, and finish any stashed operations.  At that point, we are
+ * theoretically ready to exchange the directory data fork mappings.  This
+ * cannot happen until two patchsets get merged: the first allows callers to
+ * specify the owning inode number explicitly; and the second is the atomic
+ * extent swap series.
+ *
+ * For now we'll simply compare the two directories and complain about
+ * discrepancies.
+ */
+
+/* Maximum memory usage for the tempdir log, in bytes. */
+#define MAX_DIRENT_STASH_SIZE	(32ULL << 10)
+
+/* Create a dirent in the tempdir. */
+#define XREP_DIRENT_ADD		(1)
+
+/* Remove a dirent from the tempdir. */
+#define XREP_DIRENT_REMOVE	(2)
+
+/* A stashed dirent update. */
+struct xrep_dirent {
+	/* Cookie for retrieval of the dirent name. */
+	xfblob_cookie		name_cookie;
+
+	/* Child inode number. */
+	xfs_ino_t		ino;
+
+	/* Directory offset that we want.  We're not going to get it. */
+	xfs_dir2_dataptr_t	diroffset;
+
+	/* Length of the dirent name. */
+	uint8_t			namelen;
+
+	/* File type of the dirent. */
+	uint8_t			ftype;
+
+	/* XREP_DIRENT_{ADD,REMOVE} */
+	uint8_t			action;
+};
+
+struct xrep_dir {
+	struct xfs_scrub	*sc;
+
+	/* Inode scan cursor. */
+	struct xchk_iscan	iscan;
+
+	/* Preallocated args struct for performing dir operations */
+	struct xfs_da_args	args;
+
+	/* Stashed directory entry updates. */
+	struct xfarray		*dir_entries;
+
+	/* Directory entry names. */
+	struct xfblob		*dir_names;
+
+	/* Mutex protecting dir_entries, dir_names, and parent_ino. */
+	struct mutex		lock;
+
+	/*
+	 * This is the dotdot inumber that we're going to set on the
+	 * reconstructed directory.
+	 */
+	xfs_ino_t		parent_ino;
+
+	/* Scratch buffer for scanning pptr xattrs */
+	struct xfs_parent_name_irec pptr;
+};
+
+/* Tear down all the incore stuff we created. */
+static void
+xrep_dir_teardown(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_dir		*rd = sc->buf;
+
+	xchk_iscan_finish(&rd->iscan);
+	mutex_destroy(&rd->lock);
+	xfblob_destroy(rd->dir_names);
+	xfarray_destroy(rd->dir_entries);
+}
+
+/* Set up for a directory repair. */
+int
+xrep_setup_directory(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_dir		*rd;
+	int			error;
+
+	error = xrep_tempfile_create(sc, S_IFDIR);
+	if (error)
+		return error;
+
+	rd = kvzalloc(sizeof(struct xrep_dir), XCHK_GFP_FLAGS);
+	if (!rd)
+		return -ENOMEM;
+
+	sc->buf = rd;
+	rd->sc = sc;
+	rd->parent_ino = NULLFSINO;
+	return 0;
+}
+
+/* Are these two directory names the same? */
+static inline bool
+xrep_dir_samename(
+	const struct xfs_name	*n1,
+	const struct xfs_name	*n2)
+{
+	return n1->len == n2->len && !memcmp(n1->name, n2->name, n1->len);
+}
+
+/*
+ * Look up the inode number for an exact name in a directory.
+ *
+ * Callers must hold the ILOCK.  File types are XFS_DIR3_FT_*.  Names are not
+ * checked for correctness.  This initializes rd->args.
+ */
+STATIC int
+xrep_dir_lookup(
+	struct xrep_dir		*rd,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*name,
+	xfs_ino_t		*ino)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	bool			isblock, isleaf;
+	int			error;
+
+	if (xfs_is_shutdown(dp->i_mount))
+		return -EIO;
+
+	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
+	ASSERT(xfs_isilocked(dp, XFS_ILOCK_SHARED | XFS_ILOCK_EXCL));
+
+	memset(&rd->args, 0, sizeof(struct xfs_da_args));
+	rd->args.dp		= dp;
+	rd->args.geo		= sc->mp->m_dir_geo;
+	rd->args.hashval	= xfs_dir2_hashname(dp->i_mount, name);
+	rd->args.namelen	= name->len;
+	rd->args.name		= name->name;
+	rd->args.op_flags	= XFS_DA_OP_OKNOENT;
+	rd->args.trans		= sc->tp;
+	rd->args.whichfork	= XFS_DATA_FORK;
+
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
+		error = xfs_dir2_sf_lookup(&rd->args);
+		goto out_check_rval;
+	}
+
+	/* dir2 functions require that the data fork is loaded */
+	error = xfs_iread_extents(sc->tp, dp, XFS_DATA_FORK);
+	if (error)
+		return error;
+
+	error = xfs_dir2_isblock(&rd->args, &isblock);
+	if (error)
+		return error;
+
+	if (isblock) {
+		error = xfs_dir2_block_lookup(&rd->args);
+		goto out_check_rval;
+	}
+
+	error = xfs_dir2_isleaf(&rd->args, &isleaf);
+	if (error)
+		return error;
+
+	if (isleaf) {
+		error = xfs_dir2_leaf_lookup(&rd->args);
+		goto out_check_rval;
+	}
+
+	error = xfs_dir2_node_lookup(&rd->args);
+
+out_check_rval:
+	if (error == -EEXIST)
+		error = 0;
+	if (!error)
+		*ino = rd->args.inumber;
+	return error;
+}
+
+/* Create a directory entry, having filled out most of rd->args via lookup. */
+STATIC int
+xrep_dir_createname(
+	struct xrep_dir		*rd,
+	const struct xfs_name	*name,
+	xfs_ino_t		inum,
+	xfs_extlen_t		total,
+	xfs_dir2_dataptr_t	diroffset)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	struct xfs_inode	*dp = rd->args.dp;
+	bool			is_block, is_leaf;
+	int			error;
+
+	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
+
+	error = xfs_dir_ino_validate(sc->mp, inum);
+	if (error)
+		return error;
+
+	trace_xrep_dir_createname(dp, name, inum, diroffset);
+
+	/* reset cmpresult as if we haven't done a lookup */
+	rd->args.cmpresult = XFS_CMP_DIFFERENT;
+	rd->args.filetype = name->type;
+	rd->args.inumber = inum;
+	rd->args.op_flags = XFS_DA_OP_ADDNAME | XFS_DA_OP_OKNOENT;
+	rd->args.total = total;
+
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+		return xfs_dir2_sf_addname(&rd->args);
+
+	error = xfs_dir2_isblock(&rd->args, &is_block);
+	if (error)
+		return error;
+	if (is_block)
+		return xfs_dir2_block_addname(&rd->args);
+
+	error = xfs_dir2_isleaf(&rd->args, &is_leaf);
+	if (error)
+		return error;
+	if (is_leaf)
+		return xfs_dir2_leaf_addname(&rd->args);
+
+	return xfs_dir2_node_addname(&rd->args);
+}
+
+/* Remove a directory entry, having filled out rd->args via lookup. */
+STATIC int
+xrep_dir_removename(
+	struct xrep_dir		*rd,
+	const struct xfs_name	*name,
+	xfs_extlen_t		total,
+	xfs_dir2_dataptr_t	diroffset)
+{
+	struct xfs_inode	*dp = rd->args.dp;
+	bool			is_block, is_leaf;
+	int			error;
+
+	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
+
+	/* reset cmpresult as if we haven't done a lookup */
+	rd->args.cmpresult = XFS_CMP_DIFFERENT;
+	rd->args.op_flags = 0;
+	rd->args.total = total;
+
+	trace_xrep_dir_removename(dp, name, rd->args.inumber, diroffset);
+
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+		return xfs_dir2_sf_removename(&rd->args);
+
+	error = xfs_dir2_isblock(&rd->args, &is_block);
+	if (error)
+		return error;
+	if (is_block)
+		return xfs_dir2_block_removename(&rd->args);
+
+	error = xfs_dir2_isleaf(&rd->args, &is_leaf);
+	if (error)
+		return error;
+	if (is_leaf)
+		return xfs_dir2_leaf_removename(&rd->args);
+
+	return xfs_dir2_node_removename(&rd->args);
+}
+
+/* Update the temporary directory with a stashed update. */
+STATIC int
+xrep_dir_replay_update(
+	struct xrep_dir			*rd,
+	const struct xrep_dirent	*dirent)
+{
+	struct xfs_name			xname = {
+		.len			= dirent->namelen,
+		.type			= dirent->ftype,
+		.name			= rd->pptr.p_name,
+	};
+	struct xfs_scrub		*sc = rd->sc;
+	struct xfs_mount		*mp = sc->mp;
+	xfs_ino_t			child_ino;
+	uint				resblks;
+	int				error;
+
+	if (dirent->action == XREP_DIRENT_REMOVE)
+		resblks = XFS_DIRREMOVE_SPACE_RES(mp);
+	else
+		resblks = XFS_DIRENTER_SPACE_RES(mp, dirent->namelen);
+
+	error = xchk_trans_alloc(sc, resblks);
+	if (error)
+		return error;
+
+	error = xrep_tempfile_ilock_polled(sc);
+	if (error) {
+		xchk_trans_cancel(rd->sc);
+		return error;
+	}
+
+	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
+
+	error = xrep_dir_lookup(rd, sc->tempip, &xname, &child_ino);
+	if (dirent->action == XREP_DIRENT_REMOVE) {
+		/* Remove this dirent.  The lookup must succeed. */
+		if (error)
+			goto out_cancel;
+		if (child_ino != dirent->ino) {
+			error = -ENOENT;
+			goto out_cancel;
+		}
+
+		error = xrep_dir_removename(rd, &xname, resblks,
+				dirent->diroffset);
+	} else {
+		/* Add this dirent.  The lookup must not succeed. */
+		if (error == 0)
+			error = -EEXIST;
+		if (error != -ENOENT)
+			goto out_cancel;
+
+		error = xrep_dir_createname(rd, &xname, dirent->ino, resblks,
+				dirent->diroffset);
+	}
+	if (error)
+		goto out_cancel;
+
+	error = xrep_trans_commit(sc);
+	goto out_ilock;
+
+out_cancel:
+	xchk_trans_cancel(rd->sc);
+out_ilock:
+	xrep_tempfile_iunlock(rd->sc);
+	return error;
+}
+
+/*
+ * Flush stashed dirent updates that have been recorded by the scanner.  This
+ * is done to reduce the memory requirements of the directory rebuild, since
+ * directories can contain up to 32GB of directory data.
+ *
+ * Caller must not hold transactions or ILOCKs.  Caller must hold the tempdir
+ * IOLOCK.
+ */
+STATIC int
+xrep_dir_replay_updates(
+	struct xrep_dir		*rd)
+{
+	xfarray_idx_t		array_cur;
+	int			error;
+
+	mutex_lock(&rd->lock);
+	foreach_xfarray_idx(rd->dir_entries, array_cur) {
+		struct xrep_dirent	dirent;
+
+		error = xfarray_load(rd->dir_entries, array_cur, &dirent);
+		if (error)
+			goto out_unlock;
+
+		error = xfblob_load(rd->dir_names, dirent.name_cookie,
+				rd->pptr.p_name, dirent.namelen);
+		if (error)
+			goto out_unlock;
+		rd->pptr.p_name[MAXNAMELEN - 1] = 0;
+		mutex_unlock(&rd->lock);
+
+		error = xrep_dir_replay_update(rd, &dirent);
+		if (error)
+			return error;
+
+		mutex_lock(&rd->lock);
+	}
+
+	/* Empty out both arrays now that we've added the entries. */
+	xfarray_truncate(rd->dir_entries);
+	xfblob_truncate(rd->dir_names);
+	mutex_unlock(&rd->lock);
+	return 0;
+out_unlock:
+	mutex_unlock(&rd->lock);
+	return error;
+}
+
+/*
+ * Remember that we want to create a dirent in the tempdir.  These stashed
+ * actions will be replayed later.
+ */
+STATIC int
+xrep_dir_add_dirent(
+	struct xrep_dir		*rd,
+	const struct xfs_name	*name,
+	xfs_ino_t		ino,
+	xfs_dir2_dataptr_t	diroffset)
+{
+	struct xrep_dirent	dirent = {
+		.action		= XREP_DIRENT_ADD,
+		.ino		= ino,
+		.namelen	= name->len,
+		.ftype		= name->type,
+		.diroffset	= diroffset,
+	};
+	int			error;
+
+	trace_xrep_dir_add_dirent(rd->sc->tempip, name, ino, diroffset);
+
+	error = xfblob_store(rd->dir_names, &dirent.name_cookie, name->name,
+			name->len);
+	if (error)
+		return error;
+
+	return xfarray_append(rd->dir_entries, &dirent);
+}
+
+/*
+ * Remember that we want to remove a dirent from the tempdir.  These stashed
+ * actions will be replayed later.
+ */
+STATIC int
+xrep_dir_remove_dirent(
+	struct xrep_dir		*rd,
+	const struct xfs_name	*name,
+	xfs_ino_t		ino,
+	xfs_dir2_dataptr_t	diroffset)
+{
+	struct xrep_dirent	dirent = {
+		.action		= XREP_DIRENT_REMOVE,
+		.ino		= ino,
+		.namelen	= name->len,
+		.ftype		= name->type,
+		.diroffset	= diroffset,
+	};
+	int			error;
+
+	trace_xrep_dir_remove_dirent(rd->sc->tempip, name, ino, diroffset);
+
+	error = xfblob_store(rd->dir_names, &dirent.name_cookie, name->name,
+			name->len);
+	if (error)
+		return error;
+
+	return xfarray_append(rd->dir_entries, &dirent);
+}
+
+/*
+ * Examine an xattr of a file.  If this xattr is a parent pointer that leads us
+ * back to the directory that we're rebuilding, add a dirent to the temporary
+ * directory.
+ */
+STATIC int
+xrep_dir_scan_parent_pointer(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	unsigned int		attr_flags,
+	const unsigned char	*name,
+	unsigned int		namelen,
+	const void		*value,
+	unsigned int		valuelen,
+	void			*priv)
+{
+	struct xfs_name		xname;
+	struct xrep_dir		*rd = priv;
+	const struct xfs_parent_name_rec *rec = (const void *)name;
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
+	if (!xfs_parent_namecheck(sc->mp, rec, namelen, attr_flags) ||
+	    !xfs_parent_valuecheck(sc->mp, value, valuelen))
+		return -EFSCORRUPTED;
+
+	xfs_parent_irec_from_disk(&rd->pptr, rec, value, valuelen);
+
+	/* Ignore parent pointers that point back to a different dir. */
+	if (rd->pptr.p_ino != sc->ip->i_ino ||
+	    rd->pptr.p_gen != VFS_I(sc->ip)->i_generation)
+		return 0;
+
+	/*
+	 * Transform this parent pointer into a dirent and queue it for later
+	 * addition to the temporary directory.
+	 */
+	xname.name = rd->pptr.p_name;
+	xname.len = rd->pptr.p_namelen;
+	xname.type = xfs_mode_to_ftype(VFS_I(ip)->i_mode);
+
+	mutex_lock(&rd->lock);
+	error = xrep_dir_add_dirent(rd, &xname, ip->i_ino,
+			rd->pptr.p_diroffset);
+	mutex_unlock(&rd->lock);
+	return error;
+}
+
+/*
+ * If this child dirent points to the directory being repaired, remember that
+ * fact so that we can reset the dotdot entry if necessary.
+ */
+STATIC int
+xrep_dir_scan_dirent(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp,
+	xfs_dir2_dataptr_t	dapos,
+	const struct xfs_name	*name,
+	xfs_ino_t		ino,
+	void			*priv)
+{
+	struct xrep_dir		*rd = priv;
+
+	/* Dirent doesn't point to this directory. */
+	if (ino != rd->sc->ip->i_ino)
+		return 0;
+
+	/* Ignore garbage inum. */
+	if (!xfs_verify_dir_ino(rd->sc->mp, ino))
+		return 0;
+
+	/* No weird looking names. */
+	if (name->len >= MAXNAMELEN || name->len <= 0)
+		return 0;
+
+	/* Don't pick up dot or dotdot entries; we only want child dirents. */
+	if (xrep_dir_samename(name, &xfs_name_dotdot) ||
+	    xrep_dir_samename(name, &xfs_name_dot))
+		return 0;
+
+	trace_xrep_dir_replacename(sc->tempip, &xfs_name_dotdot, dp->i_ino, 0);
+
+	mutex_lock(&rd->lock);
+	rd->parent_ino = dp->i_ino;
+	mutex_unlock(&rd->lock);
+	return 0;
+}
+
+/*
+ * Decide if we want to look for child dirents or parent pointers in this file.
+ * Skip the dir being repaired and any files being used to stage repairs.
+ */
+static inline bool
+xrep_dir_want_scan(
+	struct xrep_dir		*rd,
+	const struct xfs_inode	*ip)
+{
+	return ip != rd->sc->ip && !xrep_is_tempfile(ip);
+}
+
+/*
+ * Take ILOCK on a file that we want to scan.
+ *
+ * Select ILOCK_EXCL if the file is a directory with an unloaded data bmbt or
+ * has an unloaded attr bmbt.  Otherwise, take ILOCK_SHARED.
+ */
+static inline unsigned int
+xrep_dir_scan_ilock(
+	struct xrep_dir		*rd,
+	struct xfs_inode	*ip)
+{
+	uint			lock_mode = XFS_ILOCK_SHARED;
+
+	/* Need to take the shared ILOCK to advance the iscan cursor. */
+	if (!xrep_dir_want_scan(rd, ip))
+		goto lock;
+
+	if (S_ISDIR(VFS_I(ip)->i_mode) && xfs_need_iread_extents(&ip->i_df)) {
+		lock_mode = XFS_ILOCK_EXCL;
+		goto lock;
+	}
+
+	if (xfs_inode_has_attr_fork(ip) && xfs_need_iread_extents(&ip->i_af))
+		lock_mode = XFS_ILOCK_EXCL;
+
+lock:
+	xfs_ilock(ip, lock_mode);
+	return lock_mode;
+}
+
+/*
+ * Scan this file for relevant child dirents or parent pointers that point to
+ * the directory we're rebuilding.
+ */
+STATIC int
+xrep_dir_scan_file(
+	struct xrep_dir		*rd,
+	struct xfs_inode	*ip)
+{
+	unsigned int		lock_mode;
+	int			error = 0;
+
+	lock_mode = xrep_dir_scan_ilock(rd, ip);
+
+	if (!xrep_dir_want_scan(rd, ip))
+		goto scan_done;
+
+	error = xchk_xattr_walk(rd->sc, ip, xrep_dir_scan_parent_pointer, rd);
+	if (error)
+		goto scan_done;
+
+	if (S_ISDIR(VFS_I(ip)->i_mode)) {
+		error = xchk_dir_walk(rd->sc, ip, xrep_dir_scan_dirent, rd);
+		if (error)
+			goto scan_done;
+	}
+
+scan_done:
+	xchk_iscan_mark_visited(&rd->iscan, ip);
+	xfs_iunlock(ip, lock_mode);
+	return error;
+}
+
+/* Scan all files in the filesystem for dirents. */
+STATIC int
+xrep_dir_scan_dirtree(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	struct xfs_inode	*ip;
+	int			error;
+
+	/*
+	 * Filesystem scans are time consuming.  Drop the directory ILOCK and
+	 * all other resources for the duration of the scan and hope for the
+	 * best.
+	 */
+	xchk_trans_cancel(sc);
+	if (sc->ilock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL))
+		xchk_iunlock(sc, sc->ilock_flags & (XFS_ILOCK_SHARED |
+						    XFS_ILOCK_EXCL));
+	error = xchk_trans_alloc_empty(sc);
+	if (error)
+		return error;
+
+	while ((error = xchk_iscan_iter(sc, &rd->iscan, &ip)) == 1) {
+		uint64_t	mem_usage;
+
+		error = xrep_dir_scan_file(rd, ip);
+		xchk_irele(sc, ip);
+		if (error)
+			break;
+
+		/* Flush stashed dirent updates to constrain memory usage. */
+		mutex_lock(&rd->lock);
+		mem_usage = xfarray_bytes(rd->dir_entries) +
+			     xfblob_bytes(rd->dir_names);
+		mutex_unlock(&rd->lock);
+		if (mem_usage >= MAX_DIRENT_STASH_SIZE) {
+			xchk_trans_cancel(sc);
+
+			error = xrep_tempfile_iolock_polled(sc);
+			if (error)
+				break;
+
+			error = xrep_dir_replay_updates(rd);
+			xrep_tempfile_iounlock(sc);
+			if (error)
+				break;
+
+			error = xchk_trans_alloc_empty(sc);
+			if (error)
+				break;
+		}
+
+		if (xchk_should_terminate(sc, &error))
+			break;
+	}
+	if (error) {
+		/*
+		 * If we couldn't grab an inode that was busy with a state
+		 * change, change the error code so that we exit to userspace
+		 * as quickly as possible.
+		 */
+		if (error == -EBUSY)
+			return -ECANCELED;
+		return error;
+	}
+
+	return 0;
+}
+
+/* Dump a dirent from the temporary dir. */
+STATIC int
+xrep_dir_dump_tempdir(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp,
+	xfs_dir2_dataptr_t	dapos,
+	const struct xfs_name	*name,
+	xfs_ino_t		ino,
+	void			*priv)
+{
+	struct xrep_dir		*rd = priv;
+	bool			child = true;
+	int			error;
+
+	/*
+	 * The tempdir was created with a dotdot entry pointing to the root
+	 * directory.  Substitute whatever inode number we found during the
+	 * filesystem scan.
+	 *
+	 * The tempdir was also created with a dot entry pointing to itself.
+	 * Substitute the inode number of the directory being repaired.  A
+	 * prerequisite for the real repair code is a patchset to allow dir
+	 * callers to set the owner (and dot entry in the case of sf -> block
+	 * conversion) explicitly.
+	 *
+	 * I've chosen not to port the owner setting patchset or the swapext
+	 * patchset for this PoC, which is why we build the tempdir, compare
+	 * the contents, and drop the tempdir.
+	 */
+	if (xrep_dir_samename(name, &xfs_name_dotdot)) {
+		child = false;
+		ino = rd->parent_ino;
+	}
+	if (xrep_dir_samename(name, &xfs_name_dot)) {
+		child = false;
+		ino = sc->ip->i_ino;
+	}
+
+	trace_xrep_dir_dumpname(sc->tempip, name, ino, dapos);
+
+	if (!child)
+		return 0;
+
+	/*
+	 * Set ourselves up to free every dirent in the tempdir because
+	 * directory inactivation won't do it for us.  The rest of the online
+	 * fsck patchset provides us a means to swap the directory structure
+	 * and reap it responsibly, but I didn't feel like porting all that.
+	 */
+	mutex_lock(&rd->lock);
+	error = xrep_dir_remove_dirent(rd, name, ino, dapos);
+	mutex_unlock(&rd->lock);
+	return error;
+}
+
+/*
+ * "Commit" the new directory structure to the file that we're repairing.
+ *
+ * In the final version, we'd swap the new directory contents (which we created
+ * in the tempfile) into the directory being repaired.  For now we just lock
+ * the temporary dir and dump what we found.
+ */
+STATIC int
+xrep_dir_rebuild_tree(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	int			error = 0;
+
+	/*
+	 * Replay the last of the stashed dirent updates.  We still hold the
+	 * IOLOCK_EXCL of the directory that we're repairing and the temporary
+	 * directory.
+	 */
+	xchk_trans_cancel(sc);
+
+	ASSERT(sc->ilock_flags & XFS_IOLOCK_EXCL);
+	error = xrep_tempfile_iolock_polled(sc);
+	if (error)
+		return error;
+
+	error = xrep_dir_replay_updates(rd);
+	if (error)
+		return error;
+
+	if (sc->ip == sc->mp->m_rootip) {
+		/* Should not have found any parent of the root directory. */
+		ASSERT(rd->parent_ino == NULLFSINO);
+		rd->parent_ino = sc->mp->m_rootip->i_ino;
+	} else if (rd->parent_ino == NULLFSINO) {
+		/*
+		 * Should have found a parent somewhere unless this is an
+		 * unlinked directory.
+		 */
+		ASSERT(VFS_I(sc->ip)->i_nlink == 0);
+		rd->parent_ino = rd->sc->mp->m_sb.sb_rootino;
+	}
+
+	/*
+	 * At this point, we've quiesced both directories and should be ready
+	 * to commit the new contents.
+	 *
+	 * We don't have atomic swapext here, so all we do is dump the dirents
+	 * that we found to the ftrace buffer and {ab,re}use the dirent update
+	 * stashing mechanism to schedule deletion of every dirent in the
+	 * temporary directory to avoid leaking directory blocks.
+	 */
+	error = xchk_trans_alloc_empty(sc);
+	if (error)
+		return error;
+
+	trace_xrep_dir_rebuild_tree(sc->ip, rd->parent_ino);
+
+	xrep_tempfile_ilock(sc);
+	error = xchk_dir_walk(sc, sc->tempip, xrep_dir_dump_tempdir, rd);
+	if (error)
+		return error;
+
+	xrep_tempfile_iunlock(sc);
+	xchk_trans_cancel(sc);
+
+	return xrep_dir_replay_updates(rd);
+}
+
+/* Set up the filesystem scan so we can regenerate directory entries. */
+STATIC int
+xrep_dir_setup_scan(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	int			error;
+
+	error = xfarray_create(sc->mp, "directory entries", 0,
+			sizeof(struct xrep_dirent), &rd->dir_entries);
+	if (error)
+		return error;
+
+	error = xfblob_create(sc->mp, "dirent names", &rd->dir_names);
+	if (error)
+		goto out_entries;
+
+	mutex_init(&rd->lock);
+
+	/* Retry iget every tenth of a second for up to 30 seconds. */
+	xchk_iscan_start(&rd->iscan, 30000, 100);
+
+	return 0;
+
+out_entries:
+	xfarray_destroy(rd->dir_entries);
+	return error;
+}
+
+/*
+ * Repair the directory metadata.
+ *
+ * XXX: Is it necessary to check the dcache for this directory to make sure
+ * that we always recreate every cached entry?
+ */
+int
+xrep_directory(
+	struct xfs_scrub	*sc)
+{
+	struct xrep_dir		*rd = sc->buf;
+	int			error = 0;
+
+	/* We require directory parent pointers to rebuild anything. */
+	if (!xfs_has_parent(sc->mp))
+		return -EOPNOTSUPP;
+
+	error = xrep_dir_setup_scan(rd);
+	if (error)
+		goto out;
+
+	error = xrep_dir_scan_dirtree(rd);
+	if (error)
+		goto out_finish_scan;
+
+	error = xrep_dir_rebuild_tree(rd);
+	if (error)
+		goto out_finish_scan;
+
+out_finish_scan:
+	xrep_dir_teardown(sc);
+out:
+	return error;
+}
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 840f74ec431c..ff254ff9b86d 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -30,6 +30,16 @@ int xrep_init_btblock(struct xfs_scrub *sc, xfs_fsblock_t fsb,
 		struct xfs_buf **bpp, xfs_btnum_t btnum,
 		const struct xfs_buf_ops *ops);
 
+static inline int
+xrep_trans_commit(
+	struct xfs_scrub	*sc)
+{
+	int			error = xfs_trans_commit(sc->tp);
+
+	sc->tp = NULL;
+	return error;
+}
+ 
 struct xbitmap;
 
 int xrep_fix_freelist(struct xfs_scrub *sc, bool can_shrink);
@@ -57,6 +67,8 @@ int xrep_find_ag_btree_roots(struct xfs_scrub *sc, struct xfs_buf *agf_bp,
 void xrep_force_quotacheck(struct xfs_scrub *sc, xfs_dqtype_t type);
 int xrep_ino_dqattach(struct xfs_scrub *sc);
 
+int xrep_setup_directory(struct xfs_scrub *sc);
+
 /* Metadata repairers */
 
 int xrep_probe(struct xfs_scrub *sc);
@@ -64,6 +76,7 @@ int xrep_superblock(struct xfs_scrub *sc);
 int xrep_agf(struct xfs_scrub *sc);
 int xrep_agfl(struct xfs_scrub *sc);
 int xrep_agi(struct xfs_scrub *sc);
+int xrep_directory(struct xfs_scrub *sc);
 
 #else
 
@@ -83,11 +96,14 @@ xrep_calc_ag_resblks(
 	return 0;
 }
 
+#define xrep_setup_directory(sc)	(0)
+
 #define xrep_probe			xrep_notsupported
 #define xrep_superblock			xrep_notsupported
 #define xrep_agf			xrep_notsupported
 #define xrep_agfl			xrep_notsupported
 #define xrep_agi			xrep_notsupported
+#define xrep_directory			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index a19ea7fdd510..b2a8de449d11 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -299,7 +299,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.type	= ST_INODE,
 		.setup	= xchk_setup_directory,
 		.scrub	= xchk_directory,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_directory,
 	},
 	[XFS_SCRUB_TYPE_XATTR] = {	/* extended attributes */
 		.type	= ST_INODE,
diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 91875d4bb67f..fa47e3423763 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -136,6 +136,7 @@ xrep_tempfile_create(
 	xfs_setup_iops(sc->tempip);
 	xfs_finish_inode_setup(sc->tempip);
 
+	xfs_iunlock(sc->tempip, XFS_ILOCK_EXCL);
 	sc->temp_ilock_flags = 0;
 	return error;
 
@@ -149,6 +150,7 @@ xrep_tempfile_create(
 	 */
 	if (sc->tempip) {
 		xfs_finish_inode_setup(sc->tempip);
+		xfs_iunlock(sc->tempip, XFS_ILOCK_EXCL);
 		xchk_irele(sc, sc->tempip);
 	}
 out_release_dquots:
@@ -172,6 +174,26 @@ xrep_tempfile_iolock_nowait(
 	return false;
 }
 
+/*
+ * Take the temporary file's IOLOCK while holding a different inode's IOLOCK.
+ * In theory nobody else should hold the tempfile's IOLOCK, but we use trylock
+ * to avoid deadlocks and lockdep.
+ */
+int
+xrep_tempfile_iolock_polled(
+	struct xfs_scrub	*sc)
+{
+	int			error = 0;
+
+	while (!xrep_tempfile_iolock_nowait(sc)) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+		delay(1);
+	}
+
+	return 0;
+}
+
 /* Release IOLOCK_EXCL on the temporary file. */
 void
 xrep_tempfile_iounlock(
@@ -203,6 +225,26 @@ xrep_tempfile_ilock_nowait(
 	return false;
 }
 
+/*
+ * Take the temporary file's ILOCK while holding a different inode's ILOCK.  In
+ * theory nobody else should hold the tempfile's ILOCK, but we use trylock to
+ * avoid deadlocks and lockdep.
+ */
+int
+xrep_tempfile_ilock_polled(
+	struct xfs_scrub	*sc)
+{
+	int			error = 0;
+
+	while (!xrep_tempfile_ilock_nowait(sc)) {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+		delay(1);
+	}
+
+	return 0;
+}
+
 /* Unlock ILOCK_EXCL on the temporary file after an update. */
 void
 xrep_tempfile_iunlock(
diff --git a/fs/xfs/scrub/tempfile.h b/fs/xfs/scrub/tempfile.h
index e2f493b5d3d9..1e61d8e1ddce 100644
--- a/fs/xfs/scrub/tempfile.h
+++ b/fs/xfs/scrub/tempfile.h
@@ -11,10 +11,12 @@ int xrep_tempfile_create(struct xfs_scrub *sc, uint16_t mode);
 void xrep_tempfile_rele(struct xfs_scrub *sc);
 
 bool xrep_tempfile_iolock_nowait(struct xfs_scrub *sc);
+int xrep_tempfile_iolock_polled(struct xfs_scrub *sc);
 void xrep_tempfile_iounlock(struct xfs_scrub *sc);
 
 void xrep_tempfile_ilock(struct xfs_scrub *sc);
 bool xrep_tempfile_ilock_nowait(struct xfs_scrub *sc);
+int xrep_tempfile_ilock_polled(struct xfs_scrub *sc);
 void xrep_tempfile_iunlock(struct xfs_scrub *sc);
 bool xrep_is_tempfile(const struct xfs_inode *ip);
 #else
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 83e8a64c95d4..61b51617fbb4 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -17,6 +17,7 @@
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
 #include "scrub/iscan.h"
+#include "xfs_da_format.h"
 
 /* Figure out which block the btree cursor was pointing to. */
 static inline xfs_fsblock_t
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 0c27eb197f83..cbf914bce6db 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1182,6 +1182,73 @@ TRACE_EVENT(xrep_tempfile_create,
 		  __entry->temp_inum)
 );
 
+DECLARE_EVENT_CLASS(xrep_dirent_class,
+	TP_PROTO(struct xfs_inode *dp, const struct xfs_name *name,
+		 xfs_ino_t ino, unsigned int diroffset),
+	TP_ARGS(dp, name, ino, diroffset),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dir_ino)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, name->len)
+		__field(xfs_ino_t, ino)
+		__field(uint8_t, ftype)
+		__field(unsigned int, diroffset)
+	),
+	TP_fast_assign(
+		__entry->dev = dp->i_mount->m_super->s_dev;
+		__entry->dir_ino = dp->i_ino;
+		__entry->namelen = name->len;
+		memcpy(__get_str(name), name->name, name->len);
+		__entry->ino = ino;
+		__entry->ftype = name->type;
+		__entry->diroffset = diroffset;
+	),
+	TP_printk("dev %d:%d dir 0x%llx dapos 0x%x ftype %s name '%.*s' ino 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dir_ino,
+		  __entry->diroffset,
+		  __print_symbolic(__entry->ftype, XFS_DIR3_FTYPE_STR),
+		  __entry->namelen,
+		  __get_str(name),
+		  __entry->ino)
+)
+#define DEFINE_XREP_DIRENT_CLASS(name) \
+DEFINE_EVENT(xrep_dirent_class, name, \
+	TP_PROTO(struct xfs_inode *dp, const struct xfs_name *name, \
+		 xfs_ino_t ino, unsigned int diroffset), \
+	TP_ARGS(dp, name, ino, diroffset))
+DEFINE_XREP_DIRENT_CLASS(xrep_dir_add_dirent);
+DEFINE_XREP_DIRENT_CLASS(xrep_dir_remove_dirent);
+DEFINE_XREP_DIRENT_CLASS(xrep_dir_createname);
+DEFINE_XREP_DIRENT_CLASS(xrep_dir_removename);
+DEFINE_XREP_DIRENT_CLASS(xrep_dir_replacename);
+DEFINE_XREP_DIRENT_CLASS(xrep_dir_dumpname);
+
+DECLARE_EVENT_CLASS(xrep_dir_class,
+	TP_PROTO(struct xfs_inode *dp, xfs_ino_t parent_ino),
+	TP_ARGS(dp, parent_ino),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dir_ino)
+		__field(xfs_ino_t, parent_ino)
+	),
+	TP_fast_assign(
+		__entry->dev = dp->i_mount->m_super->s_dev;
+		__entry->dir_ino = dp->i_ino;
+		__entry->parent_ino = parent_ino;
+	),
+	TP_printk("dev %d:%d dir 0x%llx parent 0x%llx",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dir_ino,
+		  __entry->parent_ino)
+)
+#define DEFINE_XREP_DIR_CLASS(name) \
+DEFINE_EVENT(xrep_dir_class, name, \
+	TP_PROTO(struct xfs_inode *dp, xfs_ino_t parent_ino), \
+	TP_ARGS(dp, parent_ino))
+DEFINE_XREP_DIR_CLASS(xrep_dir_rebuild_tree);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 #endif /* _TRACE_XFS_SCRUB_TRACE_H */

