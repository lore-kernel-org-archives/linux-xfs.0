Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11884C2DE
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r+U2I5Cw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5790C433C9;
	Sun, 31 Dec 2023 20:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056351;
	bh=b4bOLwh/r2Jm8nRLqkeC0Ti+uAmGfIDqkKEdE5y9WIg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=r+U2I5CwZ2CdqaOR+NeBfMgXqPfy1HA2QaPVrV0ro/u7JQo/uwvnkKyNMK74sv7GM
	 ldDKBE3MgHJLKOyyUoeLCYc61rOAvU/Uirh24CxViY3X7XR+u23HrlHlsWmEp9S6+A
	 djX9QqeL4mrTiZcFKCSUCjGRn17aW85LdCWiiOT8W8/xo3dVvp/oAz9V8U5VZ1dp8C
	 tKAktj+Gtm7406D7ObLdI+p1v3pBzMLu+W+bLKDem8teHNPdd5Gg4W8fn2jirrVLG1
	 myaUQCriGli0BmDuBrYbEyS+ZuBqIegp8EYyfQsk4WO8EGAjLymHHCgsU+v2XrrRcW
	 uK+dFNsVehJWA==
Date: Sun, 31 Dec 2023 12:59:11 -0800
Subject: [PATCH 1/4] xfs: teach online scrub to find directory tree structure
 problems
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404842471.1757975.5930428996421254767.stgit@frogsfrogsfrogs>
In-Reply-To: <170404842446.1757975.532228960833173146.stgit@frogsfrogsfrogs>
References: <170404842446.1757975.532228960833173146.stgit@frogsfrogsfrogs>
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

Create a new scrubber that detects corruptions within the directory tree
structure itself.  It can detect directories with multiple parents;
loops within the directory tree; and directory loops not accessible from
the root.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile           |    1 
 fs/xfs/libxfs/xfs_fs.h    |    3 
 fs/xfs/scrub/common.h     |    1 
 fs/xfs/scrub/dirtree.c    |  749 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/dirtree.h    |  123 +++++++
 fs/xfs/scrub/ino_bitmap.h |   37 ++
 fs/xfs/scrub/scrub.c      |    7 
 fs/xfs/scrub/scrub.h      |    1 
 fs/xfs/scrub/stats.c      |    1 
 fs/xfs/scrub/trace.c      |    4 
 fs/xfs/scrub/trace.h      |  188 +++++++++++
 fs/xfs/scrub/xfarray.h    |    1 
 12 files changed, 1114 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/scrub/dirtree.c
 create mode 100644 fs/xfs/scrub/dirtree.h
 create mode 100644 fs/xfs/scrub/ino_bitmap.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 52ef808359966..31cbc4fd88f99 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -163,6 +163,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   common.o \
 				   dabtree.o \
 				   dir.o \
+				   dirtree.o \
 				   fscounters.o \
 				   health.o \
 				   ialloc.o \
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index efa68a2d82a1d..48f38694f1232 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -719,9 +719,10 @@ struct xfs_scrub_metadata {
 #define XFS_SCRUB_TYPE_QUOTACHECK 25	/* quota counters */
 #define XFS_SCRUB_TYPE_NLINKS	26	/* inode link counts */
 #define XFS_SCRUB_TYPE_HEALTHY	27	/* everything checked out ok */
+#define XFS_SCRUB_TYPE_DIRTREE	28	/* directory tree structure */
 
 /* Number of scrub subcommands. */
-#define XFS_SCRUB_TYPE_NR	28
+#define XFS_SCRUB_TYPE_NR	29
 
 /* i: Repair this metadata. */
 #define XFS_SCRUB_IFLAG_REPAIR		(1u << 0)
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 298669ca2eb92..c3a580a5d7c7d 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -92,6 +92,7 @@ int xchk_setup_directory(struct xfs_scrub *sc);
 int xchk_setup_xattr(struct xfs_scrub *sc);
 int xchk_setup_symlink(struct xfs_scrub *sc);
 int xchk_setup_parent(struct xfs_scrub *sc);
+int xchk_setup_dirtree(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
 int xchk_setup_rtbitmap(struct xfs_scrub *sc);
 int xchk_setup_rtsummary(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
new file mode 100644
index 0000000000000..9edaf89f46fdf
--- /dev/null
+++ b/fs/xfs/scrub/dirtree.c
@@ -0,0 +1,749 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
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
+#include "xfs_icache.h"
+#include "xfs_dir2.h"
+#include "xfs_dir2_priv.h"
+#include "xfs_attr.h"
+#include "xfs_parent.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/bitmap.h"
+#include "scrub/ino_bitmap.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/xfblob.h"
+#include "scrub/listxattr.h"
+#include "scrub/trace.h"
+#include "scrub/dirtree.h"
+
+/*
+ * Directory Tree Structure Validation
+ * ===================================
+ *
+ * Validating the tree qualities of the directory tree structure can be
+ * difficult.  If the tree is frozen, running a depth (or breadth) first search
+ * and marking a bitmap suffices to determine if there is a cycle.  XORing the
+ * mark bitmap with the inode bitmap afterwards tells us if there are
+ * disconnected cycles.  If the tree is not frozen, directory updates can move
+ * subtrees across the scanner wavefront, which complicates the design greatly.
+ *
+ * Directory parent pointers change that by enabling an incremental approach to
+ * validation of the tree structure.  Instead of using one thread to scan the
+ * entire filesystem, we instead can have multiple threads walking individual
+ * subdirectories upwards to the root.  Each scanner thread must be able to
+ * take the IOLOCK of the directory that it is examining to prevent that
+ * directory from being moved within the tree.  This was not possible prior to
+ * Linux 6.5 because the VFS did not take i_rwsem when moving subdirectories.
+ *
+ * If the walk terminates without reaching the root, we know the path is
+ * disconnected and ought to be attached to the lost and found.  If on the walk
+ * we find the same subdir that we're scanning, we know this is a cycle and
+ * should delete an incoming edge.  If we find multiple paths to the root, we
+ * know to delete an incoming edge.
+ *
+ * There are two big hitches with this approach: first, all file link counts
+ * must be correct to prevent other writers from doing the wrong thing with the
+ * directory tree structure.  Second, because we're walking upwards in a tree
+ * of arbitrary depth, we cannot hold all the ILOCKs.  Instead, we will use a
+ * directory update hook to invalidate the scan results if one of the paths
+ * we've scanned has changed.
+ */
+
+/* Clean up the dirtree checking resources. */
+STATIC void
+xchk_dirtree_buf_cleanup(
+	void			*buf)
+{
+	struct xchk_dirtree	*dl = buf;
+	struct xchk_dirpath	*path, *n;
+
+	xchk_dirtree_for_each_path_safe(dl, path, n) {
+		list_del_init(&path->list);
+		xino_bitmap_destroy(&path->seen_inodes);
+		kfree(path);
+	}
+
+	xfblob_destroy(dl->path_names);
+	xfarray_destroy(dl->path_steps);
+	mutex_destroy(&dl->lock);
+}
+
+/* Set us up to look for directory loops. */
+int
+xchk_setup_dirtree(
+	struct xfs_scrub	*sc)
+{
+	struct xchk_dirtree	*dl;
+	char			*descr;
+	int			error;
+
+	dl = kvzalloc(sizeof(struct xchk_dirtree), XCHK_GFP_FLAGS);
+	if (!dl)
+		return -ENOMEM;
+	dl->sc = sc;
+	INIT_LIST_HEAD(&dl->path_list);
+	dl->root_ino = NULLFSINO;
+
+	mutex_init(&dl->lock);
+
+	descr = xchk_xfile_ino_descr(sc, "dirtree path steps");
+	error = xfarray_create(descr, 0, sizeof(struct xchk_dirpath_step),
+			&dl->path_steps);
+	kfree(descr);
+	if (error)
+		goto out_dl;
+
+	descr = xchk_xfile_ino_descr(sc, "dirtree path names");
+	error = xfblob_create(descr, &dl->path_names);
+	kfree(descr);
+	if (error)
+		goto out_steps;
+
+	error = xchk_setup_inode_contents(sc, 0);
+	if (error)
+		goto out_names;
+
+	sc->buf = dl;
+	sc->buf_cleanup = xchk_dirtree_buf_cleanup;
+	return 0;
+
+out_names:
+	xfblob_destroy(dl->path_names);
+out_steps:
+	xfarray_destroy(dl->path_steps);
+out_dl:
+	mutex_destroy(&dl->lock);
+	kvfree(dl);
+	return error;
+}
+
+/*
+ * Add the parent pointer described by @dl->pptr to the given path as a new
+ * step.  Returns -ELNRNG if the path is too deep.
+ */
+STATIC int
+xchk_dirpath_append(
+	struct xchk_dirtree		*dl,
+	struct xfs_inode		*ip,
+	struct xchk_dirpath		*path,
+	const struct xfs_parent_name_irec *pptr)
+{
+	struct xchk_dirpath_step	step = {
+		.parent_ino		= pptr->p_ino,
+		.parent_gen		= pptr->p_gen,
+		.name_len		= pptr->p_namelen,
+	};
+	int				error;
+
+	/*
+	 * If this path is more than 2 billion steps long, this directory tree
+	 * is too far gone to fix.
+	 */
+	if (path->nr_steps >= XFS_MAXLINK)
+		return -ELNRNG;
+
+	error = xfblob_store(dl->path_names, &step.name_cookie,
+			dl->pptr.p_name, dl->pptr.p_namelen);
+	if (error)
+		return error;
+
+	error = xino_bitmap_set(&path->seen_inodes, ip->i_ino);
+	if (error)
+		return error;
+
+	error = xfarray_append(dl->path_steps, &step);
+	if (error)
+		return error;
+
+	path->nr_steps++;
+	return 0;
+}
+
+/*
+ * Create an xchk_path for each parent pointer of the directory that we're
+ * scanning.  For each path created, we will eventually try to walk towards the
+ * root with the goal of deleting all parents except for one that leads to the
+ * root.
+ *
+ * Returns -EFSCORRUPTED to signal that the inode being scanned has a corrupt
+ * parent pointer and hence there's no point in continuing; or -ENOSR if there
+ * are too many parent pointers for this directory.
+ */
+STATIC int
+xchk_dirtree_create_path(
+	struct xfs_scrub		*sc,
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	void				*priv)
+{
+	struct xchk_dirtree		*dl = priv;
+	struct xchk_dirpath		*path;
+	int				error;
+
+	if (!xfs_parent_verify_irec(sc->mp, pptr))
+		return -EFSCORRUPTED;
+
+	/*
+	 * If there are more than 2 billion actual parent pointers for this
+	 * subdirectory, this fs is too far gone to fix.
+	 */
+	if (dl->nr_paths >= XFS_MAXLINK)
+		return -ENOSR;
+
+	trace_xchk_dirtree_create_path(sc, ip, dl->nr_paths, pptr);
+
+	/*
+	 * Create a new xchk_path structure to remember this parent pointer
+	 * and record the first name step.
+	 */
+	path = kmalloc(sizeof(struct xchk_dirpath), XCHK_GFP_FLAGS);
+	if (!path)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&path->list);
+	xino_bitmap_init(&path->seen_inodes);
+	path->nr_steps = 0;
+	path->outcome = XCHK_DIRPATH_SCANNING;
+
+	error = xchk_dirpath_append(dl, sc->ip, path, pptr);
+	if (error)
+		goto out_path;
+
+	path->first_step = xfarray_length(dl->path_steps) - 1;
+	path->second_step = XFARRAY_NULLIDX;
+	path->path_nr = dl->nr_paths;
+
+	list_add_tail(&path->list, &dl->path_list);
+	dl->nr_paths++;
+	return 0;
+out_path:
+	kfree(path);
+	return error;
+}
+
+/*
+ * Validate that the first step of this path still has a corresponding
+ * parent pointer in @sc->ip.  We probably dropped @sc->ip's ILOCK while
+ * walking towards the roots, which is why this is necessary.
+ *
+ * This function has a side effect of loading the first parent pointer of this
+ * path into the parent pointer scratch pad.  This prepares us to walk up the
+ * directory tree towards the root.  Returns -ESTALE if the scan data is now
+ * out of date.
+ */
+STATIC int
+xchk_dirpath_revalidate(
+	struct xchk_dirtree		*dl,
+	struct xchk_dirpath		*path)
+{
+	struct xchk_dirpath_step	step;
+	struct xfs_scrub		*sc = dl->sc;
+	int				error;
+
+	error = xfarray_load(dl->path_steps, path->first_step, &step);
+	if (error)
+		return error;
+
+	/*
+	 * Check that this parent pointer is still attached to the inode that
+	 * we're scanning/
+	 */
+	dl->pptr.p_ino = step.parent_ino;
+	dl->pptr.p_gen = step.parent_gen;
+	dl->pptr.p_namelen = step.name_len;
+
+	error = xfblob_load(dl->path_names, step.name_cookie, dl->pptr.p_name,
+			step.name_len);
+	if (error)
+		return error;
+	xfs_parent_irec_hashname(sc->mp, &dl->pptr);
+
+	/*
+	 * Look up the parent pointer that corresponds to the start of this
+	 * path.  If the parent pointer has disappeared on us, dump all the
+	 * scan results and try again.
+	 */
+	error = xfs_parent_lookup(sc->tp, sc->ip, &dl->pptr, &dl->scratch);
+	if (error == -ENOATTR) {
+		trace_xchk_dirpath_disappeared(dl->sc, sc->ip, path->path_nr,
+				path->first_step, &dl->pptr);
+		dl->stale = true;
+		return -ESTALE;
+	}
+
+	return error;
+}
+
+/*
+ * Walk the parent pointers of a directory at the end of a path and record
+ * the parent that we find.
+ */
+STATIC int
+xchk_dirpath_find_next_step(
+	struct xfs_scrub		*sc,
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	void				*priv)
+{
+	unsigned int			*parents_found = priv;
+
+	if (!xfs_parent_verify_irec(sc->mp, pptr))
+		return -EFSCORRUPTED;
+
+	/*
+	 * If we've already set @dl->pptr.p_ino, then this directory has
+	 * multiple parents.  Signal this back to the caller via -EMLINK.
+	 */
+	if (*parents_found > 0)
+		return -EMLINK;
+
+	(*parents_found)++;
+	return 0;
+}
+
+/* Set and log the outcome of a path walk. */
+static inline void
+xchk_dirpath_set_outcome(
+	struct xchk_dirtree		*dl,
+	struct xchk_dirpath		*path,
+	enum xchk_dirpath_outcome	outcome)
+{
+	trace_xchk_dirpath_set_outcome(dl->sc, path->path_nr, path->nr_steps,
+			outcome);
+
+	path->outcome = outcome;
+}
+
+/*
+ * Scan the directory at the end of this path for its parent directory link.
+ * If we find one, extend the path.  Returns -ESTALE if the scan data out of
+ * date.  Returns -EFSCORRUPTED if the parent pointer is bad; or -ELNRNG if
+ * the path got too deep.
+ */
+STATIC int
+xchk_dirpath_step_up(
+	struct xchk_dirtree	*dl,
+	struct xchk_dirpath	*path)
+{
+	struct xfs_scrub	*sc = dl->sc;
+	struct xfs_inode	*dp;
+	unsigned int		lock_mode;
+	unsigned int		parents_found = 0;
+	int			error;
+
+	/* Grab and lock the parent directory. */
+	error = xchk_iget(sc, dl->pptr.p_ino, &dp);
+	if (error)
+		return error;
+
+	lock_mode = xfs_ilock_attr_map_shared(dp);
+	mutex_lock(&dl->lock);
+
+	if (dl->stale) {
+		error = -ESTALE;
+		goto out_scanlock;
+	}
+
+	/* We've reached the root directory; the path is ok. */
+	if (dl->pptr.p_ino == dl->root_ino) {
+		xchk_dirpath_set_outcome(dl, path, XCHK_DIRPATH_OK);
+		error = 0;
+		goto out_scanlock;
+	}
+
+	/*
+	 * The inode being scanned is its own distant ancestor!  Get rid of
+	 * this path.
+	 */
+	if (dl->pptr.p_ino == sc->ip->i_ino) {
+		xchk_dirpath_set_outcome(dl, path, XCHK_DIRPATH_DELETE);
+		error = 0;
+		goto out_scanlock;
+	}
+
+	/*
+	 * We've seen this inode before during the path walk.  There's a loop
+	 * above us in the directory tree.  This probably means that we cannot
+	 * continue, but let's keep walking paths to get a full picture.
+	 */
+	if (xino_bitmap_test(&path->seen_inodes, dl->pptr.p_ino)) {
+		xchk_dirpath_set_outcome(dl, path, XCHK_DIRPATH_LOOP);
+		error = 0;
+		goto out_scanlock;
+	}
+
+	/* The handle encoded in the parent pointer must match. */
+	if (VFS_I(dp)->i_generation != dl->pptr.p_gen) {
+		trace_xchk_dirpath_badgen(dl->sc, dp, path->path_nr,
+				path->nr_steps, &dl->pptr);
+		error = -EFSCORRUPTED;
+		goto out_scanlock;
+	}
+
+	/* Parent pointer must point up to a directory. */
+	if (!S_ISDIR(VFS_I(dp)->i_mode)) {
+		trace_xchk_dirpath_nondir_parent(dl->sc, dp, path->path_nr,
+				path->nr_steps, &dl->pptr);
+		error = -EFSCORRUPTED;
+		goto out_scanlock;
+	}
+
+	/* Parent cannot be an unlinked directory. */
+	if (VFS_I(dp)->i_nlink == 0) {
+		trace_xchk_dirpath_unlinked_parent(dl->sc, dp, path->path_nr,
+				path->nr_steps, &dl->pptr);
+		error = -EFSCORRUPTED;
+		goto out_scanlock;
+	}
+
+	/*
+	 * If the extended attributes look as though they has been zapped by
+	 * the inode record repair code, we cannot scan for parent pointers.
+	 */
+	if (xchk_pptr_looks_zapped(dp)) {
+		error = -EBUSY;
+		xchk_set_incomplete(sc);
+		goto out_scanlock;
+	}
+
+	/*
+	 * Walk the parent pointers of @dp to find the parent of this directory
+	 * to find the next step in our walk.  If we find that @dp has exactly
+	 * one parent, the parent pointer information will be in @dl->pptr.
+	 */
+	mutex_unlock(&dl->lock);
+	error = xchk_pptr_walk(sc, dp, xchk_dirpath_find_next_step, &dl->pptr,
+			&parents_found);
+	mutex_lock(&dl->lock);
+	if (error == -EFSCORRUPTED || error == -EMLINK ||
+	    (!error && parents_found == 0)) {
+		/*
+		 * Further up the directory tree from @sc->ip, we found a
+		 * corrupt parent pointer, multiple parent pointers while
+		 * finding this directory's parent, or zero parents despite
+		 * having a nonzero link count.  Keep looking for other paths.
+		 */
+		xchk_dirpath_set_outcome(dl, path, XCHK_DIRPATH_CORRUPT);
+		error = 0;
+		goto out_scanlock;
+	}
+	if (error)
+		goto out_scanlock;
+
+	if (dl->stale) {
+		error = -ESTALE;
+		goto out_scanlock;
+	}
+
+	trace_xchk_dirpath_found_next_step(sc, dp, path->path_nr,
+			path->nr_steps, &dl->pptr);
+
+	/* Append to the path steps */
+	error = xchk_dirpath_append(dl, dp, path, &dl->pptr);
+	if (error)
+		goto out_scanlock;
+
+	if (path->second_step == XFARRAY_NULLIDX)
+		path->second_step = xfarray_length(dl->path_steps) - 1;
+
+out_scanlock:
+	mutex_unlock(&dl->lock);
+	xfs_iunlock(dp, lock_mode);
+	xchk_irele(sc, dp);
+	return error;
+}
+
+/*
+ * Walk the directory tree upwards towards what is hopefully the root
+ * directory, recording path steps as we go.  Returns -ESTALE if the scan data
+ * are out of date.  Returns -EFSCORRUPTED only if the direct parent pointer of
+ * @sc->ip associated with this path is corrupt.
+ */
+STATIC int
+xchk_dirpath_walk_upwards(
+	struct xchk_dirtree	*dl,
+	struct xchk_dirpath	*path)
+{
+	struct xfs_scrub	*sc = dl->sc;
+	int			error;
+
+	ASSERT(sc->ilock_flags & XFS_ILOCK_EXCL);
+
+	/* Reload the start of this path and make sure it's still there. */
+	error = xchk_dirpath_revalidate(dl, path);
+	if (error)
+		return error;
+
+	trace_xchk_dirpath_walk_upwards(sc, sc->ip, path->path_nr, &dl->pptr);
+
+	/*
+	 * The inode being scanned is its own direct ancestor!
+	 * Get rid of this path.
+	 */
+	if (dl->pptr.p_ino == sc->ip->i_ino) {
+		xchk_dirpath_set_outcome(dl, path, XCHK_DIRPATH_DELETE);
+		return 0;
+	}
+
+	/*
+	 * Drop ILOCK_EXCL on the inode being scanned.  We still hold
+	 * IOLOCK_EXCL on it, so it cannot move around or be renamed.
+	 *
+	 * Beyond this point we're walking up the directory tree, which means
+	 * that we can acquire and drop the ILOCK on an alias of sc->ip.  The
+	 * ILOCK state is no longer tracked in the scrub context.  Hence we
+	 * must drop @sc->ip's ILOCK during the walk.
+	 */
+	mutex_unlock(&dl->lock);
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+
+	/*
+	 * Take the first step in the walk towards the root by checking the
+	 * start of this path, which is a direct parent pointer of @sc->ip.
+	 * If we see any kind of error here (including corruptions), the parent
+	 * pointer of @sc->ip is corrupt.  Stop the whole scan.
+	 */
+	error = xchk_dirpath_step_up(dl, path);
+	if (error) {
+		xchk_ilock(sc, XFS_ILOCK_EXCL);
+		mutex_lock(&dl->lock);
+		return error;
+	}
+
+	/*
+	 * Take steps upward from the second step in this path towards the
+	 * root.  If we hit corruption errors here, there's a problem
+	 * *somewhere* in the path, but we don't need to stop scanning.
+	 */
+	while (!error && path->outcome == XCHK_DIRPATH_SCANNING)
+		error = xchk_dirpath_step_up(dl, path);
+
+	/* Retake the locks we had, mark paths, etc. */
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
+	mutex_lock(&dl->lock);
+	if (error == -EFSCORRUPTED) {
+		xchk_dirpath_set_outcome(dl, path, XCHK_DIRPATH_CORRUPT);
+		error = 0;
+	}
+	if (!error && dl->stale)
+		return -ESTALE;
+	return error;
+}
+
+/* Delete all the collected path information. */
+STATIC void
+xchk_dirtree_reset(
+	void			*buf)
+{
+	struct xchk_dirtree	*dl = buf;
+	struct xchk_dirpath	*path, *n;
+
+	ASSERT(dl->sc->ilock_flags & XFS_ILOCK_EXCL);
+
+	xchk_dirtree_for_each_path_safe(dl, path, n) {
+		list_del_init(&path->list);
+		xino_bitmap_destroy(&path->seen_inodes);
+		kfree(path);
+	}
+	dl->nr_paths = 0;
+
+	xfarray_truncate(dl->path_steps);
+	xfblob_truncate(dl->path_names);
+
+	dl->stale = false;
+}
+
+/*
+ * For each parent pointer of this subdir, trace a path upwards towards the
+ * root directory and record what we find.  Returns 0 for success;
+ * -EFSCORRUPTED if walking the parent pointers of @sc->ip failed, -ELNRNG if a
+ * path was too deep; -ENOSR if there were too many parent pointers; or
+ * a negative errno.
+ */
+STATIC int
+xchk_dirtree_find_paths_to_root(
+	struct xchk_dirtree	*dl)
+{
+	struct xfs_scrub	*sc = dl->sc;
+	struct xchk_dirpath	*path;
+	int			error = 0;
+
+	do {
+		if (xchk_should_terminate(sc, &error))
+			return error;
+
+		xchk_dirtree_reset(dl);
+
+		/*
+		 * If the extended attributes look as though they has been
+		 * zapped by the inode record repair code, we cannot scan for
+		 * parent pointers.
+		 */
+		if (xchk_pptr_looks_zapped(sc->ip)) {
+			xchk_set_incomplete(sc);
+			return -EBUSY;
+		}
+
+		/*
+		 * Create path walk contexts for each parent of the directory
+		 * that is being scanned.  Directories are supposed to have
+		 * only one parent, but this is how we detect multiple parents.
+		 */
+		error = xchk_pptr_walk(sc, sc->ip, xchk_dirtree_create_path,
+				&dl->pptr, dl);
+		if (error)
+			return error;
+
+		xchk_dirtree_for_each_path(dl, path) {
+			/*
+			 * Try to walk up each path to the root.  This enables
+			 * us to find directory loops in ancestors, and the
+			 * like.
+			 */
+			error = xchk_dirpath_walk_upwards(dl, path);
+			if (error == -EFSCORRUPTED) {
+				/*
+				 * A parent pointer of @sc->ip is bad, don't
+				 * bother continuing.
+				 */
+				break;
+			}
+			if (error == -ESTALE) {
+				/* This had better be an invalidation. */
+				ASSERT(dl->stale);
+				break;
+			}
+			if (error)
+				return error;
+		}
+	} while (dl->stale);
+
+	return error;
+}
+
+/*
+ * Figure out what to do with the paths we tried to find.  Do not call this
+ * if the scan results are stale.
+ */
+STATIC void
+xchk_dirtree_evaluate(
+	struct xchk_dirtree		*dl,
+	struct xchk_dirtree_outcomes	*oc)
+{
+	struct xchk_dirpath		*path;
+
+	ASSERT(!dl->stale);
+
+	/* Scan the paths we have to decide what to do. */
+	memset(oc, 0, sizeof(struct xchk_dirtree_outcomes));
+	xchk_dirtree_for_each_path(dl, path) {
+		trace_xchk_dirpath_evaluate_path(dl->sc, path->path_nr,
+				path->nr_steps, path->outcome);
+
+		switch (path->outcome) {
+		case XCHK_DIRPATH_SCANNING:
+			/* shouldn't get here */
+			ASSERT(0);
+			break;
+		case XCHK_DIRPATH_DELETE:
+			/* This one is already going away. */
+			oc->bad++;
+			break;
+		case XCHK_DIRPATH_CORRUPT:
+		case XCHK_DIRPATH_LOOP:
+			/* Couldn't find the end of this path. */
+			oc->suspect++;
+			break;
+		case XCHK_DIRPATH_STALE:
+			/* shouldn't get here either */
+			ASSERT(0);
+			break;
+		case XCHK_DIRPATH_OK:
+			/* This path got all the way to the root. */
+			oc->good++;
+			break;
+		}
+	}
+
+	trace_xchk_dirtree_evaluate(dl, oc);
+}
+
+/* Look for directory loops. */
+int
+xchk_dirtree(
+	struct xfs_scrub		*sc)
+{
+	struct xchk_dirtree_outcomes	oc;
+	struct xchk_dirtree		*dl = sc->buf;
+	int				error;
+
+	/*
+	 * Nondirectories do not point downwards to other files, so they cannot
+	 * cause a cycle in the directory tree.
+	 */
+	if (!S_ISDIR(VFS_I(sc->ip)->i_mode))
+		return -ENOENT;
+
+	ASSERT(xfs_has_parent(sc->mp));
+
+	/* Find the root of the directory tree. */
+	dl->root_ino = sc->mp->m_rootip->i_ino;
+
+	trace_xchk_dirtree_start(sc->ip, sc->sm, 0);
+
+	mutex_lock(&dl->lock);
+
+	/* Trace each parent pointer's path to the root. */
+	error = xchk_dirtree_find_paths_to_root(dl);
+	if (error == -EFSCORRUPTED || error == -ELNRNG || error == -ENOSR) {
+		/*
+		 * Don't bother walking the paths if the xattr structure or the
+		 * parent pointers are corrupt; this scan cannot be completed
+		 * without full information.
+		 */
+		xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
+		error = 0;
+		goto out_scanlock;
+	}
+	if (error == -EBUSY) {
+		/*
+		 * We couldn't scan some directory's parent pointers because
+		 * the attr fork looked like it had been zapped.  The
+		 * scan was marked incomplete, so no further error code
+		 * is necessary.
+		 */
+		error = 0;
+		goto out_scanlock;
+	}
+	if (error)
+		goto out_scanlock;
+
+	/* Assess what we found in our path evaluation. */
+	xchk_dirtree_evaluate(dl, &oc);
+	if (xchk_dirtree_parentless(dl)) {
+		if (oc.good || oc.bad || oc.suspect)
+			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+	} else {
+		if (oc.bad || oc.good + oc.suspect != 1)
+			xchk_ino_set_corrupt(sc, sc->ip->i_ino);
+		if (oc.suspect)
+			xchk_ino_xref_set_corrupt(sc, sc->ip->i_ino);
+	}
+
+out_scanlock:
+	mutex_unlock(&dl->lock);
+	trace_xchk_dirtree_done(sc->ip, sc->sm, error);
+	return error;
+}
diff --git a/fs/xfs/scrub/dirtree.h b/fs/xfs/scrub/dirtree.h
new file mode 100644
index 0000000000000..a7797b618ec3f
--- /dev/null
+++ b/fs/xfs/scrub/dirtree.h
@@ -0,0 +1,123 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_DIRTREE_H__
+#define __XFS_SCRUB_DIRTREE_H__
+
+/*
+ * Each of these represents one parent pointer path step in a chain going
+ * up towards the directory tree root.  These are stored inside an xfarray.
+ */
+struct xchk_dirpath_step {
+	/* Directory entry name associated with this parent link. */
+	xfblob_cookie		name_cookie;
+	unsigned int		name_len;
+
+	/* Handle of the parent directory. */
+	unsigned int		parent_gen;
+	xfs_ino_t		parent_ino;
+};
+
+enum xchk_dirpath_outcome {
+	XCHK_DIRPATH_SCANNING = 0,	/* still being put together */
+	XCHK_DIRPATH_DELETE,		/* delete this path */
+	XCHK_DIRPATH_CORRUPT,		/* corruption detected in path */
+	XCHK_DIRPATH_LOOP,		/* cycle detected further up */
+	XCHK_DIRPATH_STALE,		/* path is stale */
+	XCHK_DIRPATH_OK,		/* path reaches the root */
+};
+
+/*
+ * Each of these represents one parent pointer path out of the directory being
+ * scanned.  These exist in-core, and hopefully there aren't more than a
+ * handful of them.
+ */
+struct xchk_dirpath {
+	struct list_head	list;
+
+	/* Index of the first step in this path. */
+	xfarray_idx_t		first_step;
+
+	/* Index of the second step in this path. */
+	xfarray_idx_t		second_step;
+
+	/* Inodes seen while walking this path. */
+	struct xino_bitmap	seen_inodes;
+
+	/* Number of steps in this path. */
+	unsigned int		nr_steps;
+
+	/* Which path is this? */
+	unsigned int		path_nr;
+
+	/* What did we conclude from following this path? */
+	enum xchk_dirpath_outcome outcome;
+};
+
+struct xchk_dirtree_outcomes {
+	/* Number of XCHK_DIRPATH_DELETE */
+	unsigned int			bad;
+
+	/* Number of XCHK_DIRPATH_CORRUPT or XCHK_DIRPATH_LOOP */
+	unsigned int			suspect;
+
+	/* Number of XCHK_DIRPATH_OK */
+	unsigned int			good;
+};
+
+struct xchk_dirtree {
+	struct xfs_scrub	*sc;
+
+	/* Root inode that we're looking for. */
+	xfs_ino_t		root_ino;
+
+	/* Scratch buffer for scanning pptr xattrs */
+	struct xfs_parent_scratch scratch;
+	struct xfs_parent_name_irec pptr;
+
+	/* lock for everything below here */
+	struct mutex		lock;
+
+	/*
+	 * All path steps observed during this scan.  Each of the path
+	 * steps for a particular pathwalk are recorded in sequential
+	 * order in the xfarray.  A pathwalk ends either with a step
+	 * pointing to the root directory (success) or pointing to NULLFSINO
+	 * (loop detected, empty dir detected, etc).
+	 */
+	struct xfarray		*path_steps;
+
+	/* All names observed during this scan. */
+	struct xfblob		*path_names;
+
+	/* All paths being tracked by this scanner. */
+	struct list_head	path_list;
+
+	/* Number of paths in path_list. */
+	unsigned int		nr_paths;
+
+	/* Have the path data been invalidated by a concurrent update? */
+	bool			stale:1;
+};
+
+#define xchk_dirtree_for_each_path_safe(dl, path, n) \
+	list_for_each_entry_safe((path), (n), &(dl)->path_list, list)
+
+#define xchk_dirtree_for_each_path(dl, path) \
+	list_for_each_entry((path), &(dl)->path_list, list)
+
+static inline bool
+xchk_dirtree_parentless(const struct xchk_dirtree *dl)
+{
+	struct xfs_scrub	*sc = dl->sc;
+
+	if (sc->ip == sc->mp->m_rootip)
+		return true;
+	if (VFS_I(sc->ip)->i_nlink == 0)
+		return true;
+	return false;
+}
+
+#endif /* __XFS_SCRUB_DIRTREE_H__ */
diff --git a/fs/xfs/scrub/ino_bitmap.h b/fs/xfs/scrub/ino_bitmap.h
new file mode 100644
index 0000000000000..1300833679abf
--- /dev/null
+++ b/fs/xfs/scrub/ino_bitmap.h
@@ -0,0 +1,37 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2023-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_INO_BITMAP_H__
+#define __XFS_SCRUB_INO_BITMAP_H__
+
+/* Bitmaps, but for type-checked for xfs_ino_t */
+
+struct xino_bitmap {
+	struct xbitmap64	inobitmap;
+};
+
+static inline void xino_bitmap_init(struct xino_bitmap *bitmap)
+{
+	xbitmap64_init(&bitmap->inobitmap);
+}
+
+static inline void xino_bitmap_destroy(struct xino_bitmap *bitmap)
+{
+	xbitmap64_destroy(&bitmap->inobitmap);
+}
+
+static inline int xino_bitmap_set(struct xino_bitmap *bitmap, xfs_ino_t ino)
+{
+	return xbitmap64_set(&bitmap->inobitmap, ino, 1);
+}
+
+static inline int xino_bitmap_test(struct xino_bitmap *bitmap, xfs_ino_t ino)
+{
+	uint64_t	len = 1;
+
+	return xbitmap64_test(&bitmap->inobitmap, ino, &len);
+}
+
+#endif	/* __XFS_SCRUB_INO_BITMAP_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index d9c6d54ffad7f..b6f18d61d8816 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -439,6 +439,13 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.scrub	= xchk_health_record,
 		.repair = xrep_notsupported,
 	},
+	[XFS_SCRUB_TYPE_DIRTREE] = {	/* directory tree structure */
+		.type	= ST_INODE,
+		.setup	= xchk_setup_dirtree,
+		.scrub	= xchk_dirtree,
+		.has	= xfs_has_parent,
+		.repair	= xrep_notsupported,
+	},
 };
 
 static int
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 665da3e3c1af1..ec685ef425778 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -185,6 +185,7 @@ int xchk_directory(struct xfs_scrub *sc);
 int xchk_xattr(struct xfs_scrub *sc);
 int xchk_symlink(struct xfs_scrub *sc);
 int xchk_parent(struct xfs_scrub *sc);
+int xchk_dirtree(struct xfs_scrub *sc);
 #ifdef CONFIG_XFS_RT
 int xchk_rtbitmap(struct xfs_scrub *sc);
 int xchk_rtsummary(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/stats.c b/fs/xfs/scrub/stats.c
index b4ef1ebe28ab8..fd92df6389ac8 100644
--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -79,6 +79,7 @@ static const char *name_map[XFS_SCRUB_TYPE_NR] = {
 	[XFS_SCRUB_TYPE_FSCOUNTERS]	= "fscounters",
 	[XFS_SCRUB_TYPE_QUOTACHECK]	= "quotacheck",
 	[XFS_SCRUB_TYPE_NLINKS]		= "nlinks",
+	[XFS_SCRUB_TYPE_DIRTREE]	= "dirtree",
 };
 
 /* Format the scrub stats into a text buffer, similar to pcp style. */
diff --git a/fs/xfs/scrub/trace.c b/fs/xfs/scrub/trace.c
index 9fe1491adbb51..994a910eead80 100644
--- a/fs/xfs/scrub/trace.c
+++ b/fs/xfs/scrub/trace.c
@@ -30,6 +30,10 @@
 #include "scrub/nlinks.h"
 #include "scrub/fscounters.h"
 #include "scrub/xfbtree.h"
+#include "scrub/bitmap.h"
+#include "scrub/ino_bitmap.h"
+#include "scrub/xfblob.h"
+#include "scrub/dirtree.h"
 
 /* Figure out which block the btree cursor was pointing to. */
 static inline xfs_fsblock_t
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 10e2d6544c5ad..f5dddbc4d8594 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -29,6 +29,9 @@ struct xfbtree;
 struct xfbtree_config;
 struct xfs_rmap_update_params;
 struct xfs_parent_name_irec;
+enum xchk_dirpath_outcome;
+struct xchk_dirtree;
+struct xchk_dirtree_outcomes;
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
@@ -76,6 +79,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_FSCOUNTERS);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_QUOTACHECK);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_NLINKS);
 TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
+TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_DIRTREE);
 
 #define XFS_SCRUB_TYPE_STRINGS \
 	{ XFS_SCRUB_TYPE_PROBE,		"probe" }, \
@@ -105,7 +109,8 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_HEALTHY);
 	{ XFS_SCRUB_TYPE_FSCOUNTERS,	"fscounters" }, \
 	{ XFS_SCRUB_TYPE_QUOTACHECK,	"quotacheck" }, \
 	{ XFS_SCRUB_TYPE_NLINKS,	"nlinks" }, \
-	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }
+	{ XFS_SCRUB_TYPE_HEALTHY,	"healthy" }, \
+	{ XFS_SCRUB_TYPE_DIRTREE,	"dirtree" }
 
 #define XFS_SCRUB_FLAG_STRINGS \
 	{ XFS_SCRUB_IFLAG_REPAIR,		"repair" }, \
@@ -173,6 +178,8 @@ DEFINE_EVENT(xchk_class, name, \
 DEFINE_SCRUB_EVENT(xchk_start);
 DEFINE_SCRUB_EVENT(xchk_done);
 DEFINE_SCRUB_EVENT(xchk_deadlock_retry);
+DEFINE_SCRUB_EVENT(xchk_dirtree_start);
+DEFINE_SCRUB_EVENT(xchk_dirtree_done);
 DEFINE_SCRUB_EVENT(xrep_attempt);
 DEFINE_SCRUB_EVENT(xrep_done);
 
@@ -1587,6 +1594,185 @@ DEFINE_XCHK_PPTR_EVENT(xchk_parent_defer);
 DEFINE_XCHK_PPTR_EVENT(xchk_parent_slowpath);
 DEFINE_XCHK_PPTR_EVENT(xchk_parent_ultraslowpath);
 
+DECLARE_EVENT_CLASS(xchk_dirtree_class,
+	TP_PROTO(struct xfs_scrub *sc, struct xfs_inode *ip,
+		 unsigned int path_nr,
+		 const struct xfs_parent_name_irec *pptr),
+	TP_ARGS(sc, ip, path_nr, pptr),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, path_nr)
+		__field(xfs_ino_t, child_ino)
+		__field(unsigned int, child_gen)
+		__field(xfs_ino_t, parent_ino)
+		__field(unsigned int, parent_gen)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, pptr->p_namelen)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->path_nr = path_nr;
+		__entry->child_ino = ip->i_ino;
+		__entry->child_gen = VFS_I(ip)->i_generation;
+		__entry->parent_ino = pptr->p_ino;
+		__entry->parent_gen = pptr->p_gen;
+		__entry->namelen = pptr->p_namelen;
+		memcpy(__get_str(name), pptr->p_name, pptr->p_namelen);
+	),
+	TP_printk("dev %d:%d path %u child_ino 0x%llx child_gen 0x%x parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->path_nr,
+		  __entry->child_ino,
+		  __entry->child_gen,
+		  __entry->parent_ino,
+		  __entry->parent_gen,
+		  __entry->namelen,
+		  __get_str(name))
+);
+#define DEFINE_XCHK_DIRTREE_EVENT(name) \
+DEFINE_EVENT(xchk_dirtree_class, name, \
+	TP_PROTO(struct xfs_scrub *sc, struct xfs_inode *ip, \
+		 unsigned int path_nr, \
+		 const struct xfs_parent_name_irec *pptr), \
+	TP_ARGS(sc, ip, path_nr, pptr))
+DEFINE_XCHK_DIRTREE_EVENT(xchk_dirtree_create_path);
+DEFINE_XCHK_DIRTREE_EVENT(xchk_dirpath_walk_upwards);
+
+DECLARE_EVENT_CLASS(xchk_dirpath_class,
+	TP_PROTO(struct xfs_scrub *sc, struct xfs_inode *ip,
+		unsigned int path_nr, unsigned int step_nr,
+		 const struct xfs_parent_name_irec *pptr),
+	TP_ARGS(sc, ip, path_nr, step_nr, pptr),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned int, path_nr)
+		__field(unsigned int, step_nr)
+		__field(xfs_ino_t, child_ino)
+		__field(unsigned int, child_gen)
+		__field(xfs_ino_t, parent_ino)
+		__field(unsigned int, parent_gen)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, pptr->p_namelen)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->path_nr = path_nr;
+		__entry->step_nr = step_nr;
+		__entry->child_ino = ip->i_ino;
+		__entry->child_gen = VFS_I(ip)->i_generation;
+		__entry->parent_ino = pptr->p_ino;
+		__entry->parent_gen = pptr->p_gen;
+		__entry->namelen = pptr->p_namelen;
+		memcpy(__get_str(name), pptr->p_name, pptr->p_namelen);
+	),
+	TP_printk("dev %d:%d path %u step %u child_ino 0x%llx child_gen 0x%x parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->path_nr,
+		  __entry->step_nr,
+		  __entry->child_ino,
+		  __entry->child_gen,
+		  __entry->parent_ino,
+		  __entry->parent_gen,
+		  __entry->namelen,
+		  __get_str(name))
+);
+#define DEFINE_XCHK_DIRPATH_EVENT(name) \
+DEFINE_EVENT(xchk_dirpath_class, name, \
+	TP_PROTO(struct xfs_scrub *sc, struct xfs_inode *ip, \
+		 unsigned int path_nr, unsigned int step_nr, \
+		 const struct xfs_parent_name_irec *pptr), \
+	TP_ARGS(sc, ip, path_nr, step_nr, pptr))
+DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_disappeared);
+DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_badgen);
+DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_nondir_parent);
+DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_unlinked_parent);
+DEFINE_XCHK_DIRPATH_EVENT(xchk_dirpath_found_next_step);
+
+TRACE_DEFINE_ENUM(XCHK_DIRPATH_SCANNING);
+TRACE_DEFINE_ENUM(XCHK_DIRPATH_DELETE);
+TRACE_DEFINE_ENUM(XCHK_DIRPATH_CORRUPT);
+TRACE_DEFINE_ENUM(XCHK_DIRPATH_LOOP);
+TRACE_DEFINE_ENUM(XCHK_DIRPATH_STALE);
+TRACE_DEFINE_ENUM(XCHK_DIRPATH_OK);
+
+#define XCHK_DIRPATH_OUTCOME_STRINGS \
+	{ XCHK_DIRPATH_SCANNING,	"scanning" }, \
+	{ XCHK_DIRPATH_DELETE,		"delete" }, \
+	{ XCHK_DIRPATH_CORRUPT,		"corrupt" }, \
+	{ XCHK_DIRPATH_LOOP,		"loop" }, \
+	{ XCHK_DIRPATH_STALE,		"stale" }, \
+	{ XCHK_DIRPATH_OK,		"ok" }
+
+DECLARE_EVENT_CLASS(xchk_dirpath_outcome_class,
+	TP_PROTO(struct xfs_scrub *sc, unsigned long long path_nr,
+		 unsigned int nr_steps, \
+		 unsigned int outcome),
+	TP_ARGS(sc, path_nr, nr_steps, outcome),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(unsigned long long, path_nr)
+		__field(unsigned int, nr_steps)
+		__field(unsigned int, outcome)
+	),
+	TP_fast_assign(
+		__entry->dev = sc->mp->m_super->s_dev;
+		__entry->path_nr = path_nr;
+		__entry->nr_steps = nr_steps;
+		__entry->outcome = outcome;
+	),
+	TP_printk("dev %d:%d path %llu steps %u outcome %s",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->path_nr,
+		  __entry->nr_steps,
+		  __print_symbolic(__entry->outcome, XCHK_DIRPATH_OUTCOME_STRINGS))
+);
+#define DEFINE_XCHK_DIRPATH_OUTCOME_EVENT(name) \
+DEFINE_EVENT(xchk_dirpath_outcome_class, name, \
+	TP_PROTO(struct xfs_scrub *sc, unsigned long long path_nr, \
+		 unsigned int nr_steps, \
+		 unsigned int outcome), \
+	TP_ARGS(sc, path_nr, nr_steps, outcome))
+DEFINE_XCHK_DIRPATH_OUTCOME_EVENT(xchk_dirpath_set_outcome);
+DEFINE_XCHK_DIRPATH_OUTCOME_EVENT(xchk_dirpath_evaluate_path);
+
+DECLARE_EVENT_CLASS(xchk_dirtree_evaluate_class,
+	TP_PROTO(const struct xchk_dirtree *dl,
+		 const struct xchk_dirtree_outcomes *oc),
+	TP_ARGS(dl, oc),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_ino_t, rootino)
+		__field(unsigned int, nr_paths)
+		__field(unsigned int, bad)
+		__field(unsigned int, suspect)
+		__field(unsigned int, good)
+	),
+	TP_fast_assign(
+		__entry->dev = dl->sc->mp->m_super->s_dev;
+		__entry->ino = dl->sc->ip->i_ino;
+		__entry->rootino = dl->root_ino;
+		__entry->nr_paths = dl->nr_paths;
+		__entry->bad = oc->bad;
+		__entry->suspect = oc->suspect;
+		__entry->good = oc->good;
+	),
+	TP_printk("dev %d:%d ino 0x%llx rootino 0x%llx nr_paths %u bad %u suspect %u good %u",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->rootino,
+		  __entry->nr_paths,
+		  __entry->bad,
+		  __entry->suspect,
+		  __entry->good)
+);
+#define DEFINE_XCHK_DIRTREE_EVALUATE_EVENT(name) \
+DEFINE_EVENT(xchk_dirtree_evaluate_class, name, \
+	TP_PROTO(const struct xchk_dirtree *dl, \
+		 const struct xchk_dirtree_outcomes *oc), \
+	TP_ARGS(dl, oc))
+DEFINE_XCHK_DIRTREE_EVALUATE_EVENT(xchk_dirtree_evaluate);
+
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 
diff --git a/fs/xfs/scrub/xfarray.h b/fs/xfs/scrub/xfarray.h
index f06af7eb484ec..6652070716095 100644
--- a/fs/xfs/scrub/xfarray.h
+++ b/fs/xfs/scrub/xfarray.h
@@ -8,6 +8,7 @@
 
 /* xfile array index type, along with cursor initialization */
 typedef uint64_t		xfarray_idx_t;
+#define XFARRAY_NULLIDX		((__force xfarray_idx_t)-1ULL)
 #define XFARRAY_CURSOR_INIT	((__force xfarray_idx_t)0)
 
 /* Iterate each index of an xfile array. */

