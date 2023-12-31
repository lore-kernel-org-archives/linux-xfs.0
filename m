Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 546ABB675
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X9GEtRgb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C35C7C433C7;
	Sun, 31 Dec 2023 20:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056398;
	bh=zM2vrE1IwyghzInkt0pxx5xfYBBblp6g6+IUcF34Obo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=X9GEtRgbwVCknHK+DHHzVonMDyt46nnlEijlnWH8BEMGBQeaHlRoJKnPb8rcdGKgp
	 QLLYyp3kZS/KR3NumxWv7aDNnqRq7pX1WQLFV7pQmv4sVGflu02PvezSkYsC1HUpWe
	 LuFB43rezaSNghhVEJPtJV3d5KBkXcA1l//oYMd6WtzRWk4xmBRCoZ+tAFvx00Ij+G
	 4+w5EBJD99VHeEWDzRK2S3wuzlzy1rs9xNpOdvhBp5FIVo2i5K891X2YwMxKScxbzx
	 h5rjP2hUvwZQgEIjlDIroj3LwSBB+Ox0dFugTg6qBveIBpdZ2q6AX9PkJfnkgyeWQ0
	 jJuLoQtYLvEvQ==
Date: Sun, 31 Dec 2023 12:59:58 -0800
Subject: [PATCH 4/4] xfs: fix corruptions in the directory tree
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404842520.1757975.14709006420465050224.stgit@frogsfrogsfrogs>
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

Repair corruptions in the directory tree itself.  Cycles are broken by
removing an incoming parent->child link.  Multiply-owned directories are
fixed by pruning the extra parent -> child links  Disconnected subtrees
are reconnected to the lost and found.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Makefile               |    1 
 fs/xfs/scrub/dirtree.c        |   38 ++
 fs/xfs/scrub/dirtree.h        |   29 +
 fs/xfs/scrub/dirtree_repair.c |  824 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/orphanage.c      |    6 
 fs/xfs/scrub/orphanage.h      |    8 
 fs/xfs/scrub/repair.h         |    4 
 fs/xfs/scrub/scrub.c          |    2 
 fs/xfs/scrub/trace.h          |   23 +
 fs/xfs/xfs_inode.c            |    2 
 fs/xfs/xfs_inode.h            |    1 
 11 files changed, 930 insertions(+), 8 deletions(-)
 create mode 100644 fs/xfs/scrub/dirtree_repair.c


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 31cbc4fd88f99..c4a950ad517c9 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -204,6 +204,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   bmap_repair.o \
 				   cow_repair.o \
 				   dir_repair.o \
+				   dirtree_repair.o \
 				   findparent.o \
 				   fscounters_repair.o \
 				   ialloc_repair.o \
diff --git a/fs/xfs/scrub/dirtree.c b/fs/xfs/scrub/dirtree.c
index 18005908434ed..53fd89e48cfc6 100644
--- a/fs/xfs/scrub/dirtree.c
+++ b/fs/xfs/scrub/dirtree.c
@@ -26,6 +26,8 @@
 #include "scrub/xfblob.h"
 #include "scrub/listxattr.h"
 #include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/orphanage.h"
 #include "scrub/dirtree.h"
 
 /*
@@ -94,6 +96,12 @@ xchk_setup_dirtree(
 
 	xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
 
+	if (xchk_could_repair(sc)) {
+		error = xrep_setup_dirtree(sc);
+		if (error)
+			return error;
+	}
+
 	dl = kvzalloc(sizeof(struct xchk_dirtree), XCHK_GFP_FLAGS);
 	if (!dl)
 		return -ENOMEM;
@@ -101,6 +109,7 @@ xchk_setup_dirtree(
 	INIT_LIST_HEAD(&dl->path_list);
 	dl->root_ino = NULLFSINO;
 	dl->scan_ino = NULLFSINO;
+	dl->parent_ino = NULLFSINO;
 
 	mutex_init(&dl->lock);
 
@@ -139,7 +148,7 @@ xchk_setup_dirtree(
  * Add the parent pointer described by @dl->pptr to the given path as a new
  * step.  Returns -ELNRNG if the path is too deep.
  */
-STATIC int
+int
 xchk_dirpath_append(
 	struct xchk_dirtree		*dl,
 	struct xfs_inode		*ip,
@@ -590,6 +599,22 @@ xchk_dirpath_step_is_stale(
 	if (memcmp(dl->hook_namebuf, p->name->name, p->name->len) != 0)
 		return 0;
 
+	/*
+	 * If the update comes from the repair code itself, walk the state
+	 * machine forward.
+	 */
+	if (p->ip->i_ino == dl->scan_ino &&
+	    path->outcome == XREP_DIRPATH_ADOPTING) {
+		xchk_dirpath_set_outcome(dl, path, XREP_DIRPATH_ADOPTED);
+		return 0;
+	}
+
+	if (p->ip->i_ino == dl->scan_ino &&
+	    path->outcome == XREP_DIRPATH_DELETING) {
+		xchk_dirpath_set_outcome(dl, path, XREP_DIRPATH_DELETED);
+		return 0;
+	}
+
 	/* Exact match, scan data is out of date. */
 	trace_xchk_dirpath_changed(dl->sc, path->path_nr, step_nr, p->dp,
 			p->ip, p->name);
@@ -705,7 +730,7 @@ xchk_dirtree_reset(
  * path was too deep; -ENOSR if there were too many parent pointers; or
  * a negative errno.
  */
-STATIC int
+int
 xchk_dirtree_find_paths_to_root(
 	struct xchk_dirtree	*dl)
 {
@@ -772,7 +797,7 @@ xchk_dirtree_find_paths_to_root(
  * Figure out what to do with the paths we tried to find.  Do not call this
  * if the scan results are stale.
  */
-STATIC void
+void
 xchk_dirtree_evaluate(
 	struct xchk_dirtree		*dl,
 	struct xchk_dirtree_outcomes	*oc)
@@ -809,6 +834,13 @@ xchk_dirtree_evaluate(
 			/* This path got all the way to the root. */
 			oc->good++;
 			break;
+		case XREP_DIRPATH_DELETING:
+		case XREP_DIRPATH_DELETED:
+		case XREP_DIRPATH_ADOPTING:
+		case XREP_DIRPATH_ADOPTED:
+			/* These should not be in progress! */
+			ASSERT(0);
+			break;
 		}
 	}
 
diff --git a/fs/xfs/scrub/dirtree.h b/fs/xfs/scrub/dirtree.h
index ea374cf5f8362..a5dca42906e0e 100644
--- a/fs/xfs/scrub/dirtree.h
+++ b/fs/xfs/scrub/dirtree.h
@@ -27,6 +27,11 @@ enum xchk_dirpath_outcome {
 	XCHK_DIRPATH_LOOP,		/* cycle detected further up */
 	XCHK_DIRPATH_STALE,		/* path is stale */
 	XCHK_DIRPATH_OK,		/* path reaches the root */
+
+	XREP_DIRPATH_DELETING,		/* path is being deleted */
+	XREP_DIRPATH_DELETED,		/* path has been deleted */
+	XREP_DIRPATH_ADOPTING,		/* path is being adopted */
+	XREP_DIRPATH_ADOPTED,		/* path has been adopted */
 };
 
 /*
@@ -65,6 +70,9 @@ struct xchk_dirtree_outcomes {
 
 	/* Number of XCHK_DIRPATH_OK */
 	unsigned int			good;
+
+	/* Directory needs to be added to lost+found */
+	bool				needs_adoption;
 };
 
 struct xchk_dirtree {
@@ -80,16 +88,30 @@ struct xchk_dirtree {
 	 */
 	xfs_ino_t		scan_ino;
 
+	/*
+	 * If we start deleting redundant paths to this subdirectory, this is
+	 * the inode number of the surviving parent and the dotdot entry will
+	 * be set to this value.  If the value is NULLFSINO, then use @root_ino
+	 * as a stand-in until the orphanage can adopt the subdirectory.
+	 */
+	xfs_ino_t		parent_ino;
+
 	/* Scratch buffer for scanning pptr xattrs */
 	struct xfs_parent_scratch scratch;
 	struct xfs_parent_name_irec pptr;
 
+	/* Information for reparenting this directory. */
+	struct xrep_adoption	adoption;
+
 	/*
 	 * Hook into directory updates so that we can receive live updates
 	 * from other writer threads.
 	 */
 	struct xfs_dir_hook	hooks;
 
+	/* Parent pointer update arguments. */
+	struct xfs_parent_args	ppargs;
+
 	/* lock for everything below here */
 	struct mutex		lock;
 
@@ -139,4 +161,11 @@ xchk_dirtree_parentless(const struct xchk_dirtree *dl)
 	return false;
 }
 
+int xchk_dirtree_find_paths_to_root(struct xchk_dirtree *dl);
+int xchk_dirpath_append(struct xchk_dirtree *dl, struct xfs_inode *ip,
+		struct xchk_dirpath *path,
+		const struct xfs_parent_name_irec *pptr);
+void xchk_dirtree_evaluate(struct xchk_dirtree *dl,
+		struct xchk_dirtree_outcomes *oc);
+
 #endif /* __XFS_SCRUB_DIRTREE_H__ */
diff --git a/fs/xfs/scrub/dirtree_repair.c b/fs/xfs/scrub/dirtree_repair.c
new file mode 100644
index 0000000000000..ba35d574437d2
--- /dev/null
+++ b/fs/xfs/scrub/dirtree_repair.c
@@ -0,0 +1,824 @@
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
+#include "xfs_trans_space.h"
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
+#include "scrub/repair.h"
+#include "scrub/orphanage.h"
+#include "scrub/dirtree.h"
+#include "scrub/readdir.h"
+
+/*
+ * Directory Tree Structure Repairs
+ * ================================
+ *
+ * If we decide that the directory being scanned is participating in a
+ * directory loop, the only change we can make is to remove directory entries
+ * pointing down to @sc->ip.  If that leaves it with no parents, the directory
+ * should be adopted by the orphanage.
+ */
+
+/* Set up to repair directory loops. */
+int
+xrep_setup_dirtree(
+	struct xfs_scrub	*sc)
+{
+	return xrep_orphanage_try_create(sc);
+}
+
+/* Change the outcome of this path. */
+static inline void
+xrep_dirpath_set_outcome(
+	struct xchk_dirtree		*dl,
+	struct xchk_dirpath		*path,
+	enum xchk_dirpath_outcome	outcome)
+{
+	trace_xrep_dirpath_set_outcome(dl->sc, path->path_nr, path->nr_steps,
+			outcome);
+
+	path->outcome = outcome;
+}
+
+/* Delete all paths. */
+STATIC void
+xrep_dirtree_delete_all_paths(
+	struct xchk_dirtree		*dl,
+	struct xchk_dirtree_outcomes	*oc)
+{
+	struct xchk_dirpath		*path;
+
+	xchk_dirtree_for_each_path(dl, path) {
+		switch (path->outcome) {
+		case XCHK_DIRPATH_CORRUPT:
+		case XCHK_DIRPATH_LOOP:
+			oc->suspect--;
+			oc->bad++;
+			xrep_dirpath_set_outcome(dl, path, XCHK_DIRPATH_DELETE);
+			break;
+		case XCHK_DIRPATH_OK:
+			oc->good--;
+			oc->bad++;
+			xrep_dirpath_set_outcome(dl, path, XCHK_DIRPATH_DELETE);
+			break;
+		default:
+			break;
+		}
+	}
+
+	ASSERT(oc->suspect == 0);
+	ASSERT(oc->good == 0);
+}
+
+/* Since this is the surviving path, set the dotdot entry to this value. */
+STATIC void
+xrep_dirpath_retain_parent(
+	struct xchk_dirtree		*dl,
+	struct xchk_dirpath		*path)
+{
+	struct xchk_dirpath_step	step;
+	int				error;
+
+	error = xfarray_load(dl->path_steps, path->first_step, &step);
+	if (error)
+		return;
+
+	dl->parent_ino = step.parent_ino;
+}
+
+/* Find the one surviving path so we know how to set dotdot. */
+STATIC void
+xrep_dirtree_find_surviving_path(
+	struct xchk_dirtree		*dl,
+	struct xchk_dirtree_outcomes	*oc)
+{
+	struct xchk_dirpath		*path;
+	bool				foundit = false;
+
+	xchk_dirtree_for_each_path(dl, path) {
+		switch (path->outcome) {
+		case XCHK_DIRPATH_CORRUPT:
+		case XCHK_DIRPATH_LOOP:
+		case XCHK_DIRPATH_OK:
+			if (!foundit) {
+				xrep_dirpath_retain_parent(dl, path);
+				foundit = true;
+				continue;
+			}
+			ASSERT(foundit == false);
+			break;
+		default:
+			break;
+		}
+	}
+
+	ASSERT(oc->suspect + oc->good == 1);
+}
+
+/* Delete all paths except for the one good one. */
+STATIC void
+xrep_dirtree_keep_one_good_path(
+	struct xchk_dirtree		*dl,
+	struct xchk_dirtree_outcomes	*oc)
+{
+	struct xchk_dirpath		*path;
+	bool				foundit = false;
+
+	xchk_dirtree_for_each_path(dl, path) {
+		switch (path->outcome) {
+		case XCHK_DIRPATH_CORRUPT:
+		case XCHK_DIRPATH_LOOP:
+			oc->suspect--;
+			oc->bad++;
+			xrep_dirpath_set_outcome(dl, path, XCHK_DIRPATH_DELETE);
+			break;
+		case XCHK_DIRPATH_OK:
+			if (!foundit) {
+				xrep_dirpath_retain_parent(dl, path);
+				foundit = true;
+				continue;
+			}
+			oc->good--;
+			oc->bad++;
+			xrep_dirpath_set_outcome(dl, path, XCHK_DIRPATH_DELETE);
+			break;
+		default:
+			break;
+		}
+	}
+
+	ASSERT(oc->suspect == 0);
+	ASSERT(oc->good < 2);
+}
+
+/* Delete all paths except for one suspect one. */
+STATIC void
+xrep_dirtree_keep_one_suspect_path(
+	struct xchk_dirtree		*dl,
+	struct xchk_dirtree_outcomes	*oc)
+{
+	struct xchk_dirpath		*path;
+	bool				foundit = false;
+
+	xchk_dirtree_for_each_path(dl, path) {
+		switch (path->outcome) {
+		case XCHK_DIRPATH_CORRUPT:
+		case XCHK_DIRPATH_LOOP:
+			if (!foundit) {
+				xrep_dirpath_retain_parent(dl, path);
+				foundit = true;
+				continue;
+			}
+			oc->suspect--;
+			oc->bad++;
+			xrep_dirpath_set_outcome(dl, path, XCHK_DIRPATH_DELETE);
+			break;
+		case XCHK_DIRPATH_OK:
+			ASSERT(0);
+			break;
+		default:
+			break;
+		}
+	}
+
+	ASSERT(oc->suspect == 1);
+	ASSERT(oc->good == 0);
+}
+
+/*
+ * Figure out what to do with the paths we tried to find.  Returns -EDEADLOCK
+ * if the scan results have become stale.
+ */
+STATIC void
+xrep_dirtree_decide_fate(
+	struct xchk_dirtree		*dl,
+	struct xchk_dirtree_outcomes	*oc)
+{
+	xchk_dirtree_evaluate(dl, oc);
+
+	/* Parentless directories should not have any paths at all. */
+	if (xchk_dirtree_parentless(dl)) {
+		xrep_dirtree_delete_all_paths(dl, oc);
+		return;
+	}
+
+	/* One path is exactly the number of paths we want. */
+	if (oc->good + oc->suspect == 1) {
+		xrep_dirtree_find_surviving_path(dl, oc);
+		return;
+	}
+
+	/* Zero paths means we should reattach the subdir to the orphanage. */
+	if (oc->good + oc->suspect == 0) {
+		if (dl->sc->orphanage)
+			oc->needs_adoption = true;
+		return;
+	}
+
+	/*
+	 * Otherwise, this subdirectory has too many parents.  If there's at
+	 * least one good path, keep it and delete the others.
+	 */
+	if (oc->good > 0) {
+		xrep_dirtree_keep_one_good_path(dl, oc);
+		return;
+	}
+
+	/*
+	 * There are no good paths and there are too many suspect paths.
+	 * Keep the first suspect path and delete the rest.
+	 */
+	xrep_dirtree_keep_one_suspect_path(dl, oc);
+}
+
+/*
+ * Load the first step of this path into @step and @dl->pptr
+ * for later repair work.
+ */
+STATIC int
+xrep_dirtree_prep_path(
+	struct xchk_dirtree		*dl,
+	struct xchk_dirpath		*path,
+	struct xchk_dirpath_step	*step)
+{
+	int				error;
+
+	error = xfarray_load(dl->path_steps, path->first_step, step);
+	if (error)
+		return error;
+
+	dl->pptr.p_ino = step->parent_ino;
+	dl->pptr.p_gen = step->parent_gen;
+	dl->pptr.p_namelen = step->name_len;
+
+	return xfblob_load(dl->path_names, step->name_cookie, dl->pptr.p_name,
+			step->name_len);
+}
+
+/* Delete the VFS dentry for a removed child. */
+STATIC int
+xrep_dirtree_purge_dentry(
+	struct xchk_dirtree	*dl,
+	struct xfs_inode	*dp,
+	const struct xfs_name	*name)
+{
+	struct qstr		qname = QSTR_INIT(name->name, name->len);
+	struct dentry		*parent_dentry, *child_dentry;
+	int			error = 0;
+
+	/*
+	 * Find the dentry for the parent directory.  If there isn't one, we're
+	 * done.  Caller already holds i_rwsem for parent and child.
+	 */
+	parent_dentry = d_find_alias(VFS_I(dp));
+	if (!parent_dentry)
+		return 0;
+
+	/* The VFS thinks the parent is a directory, right? */
+	if (!d_is_dir(parent_dentry)) {
+		ASSERT(d_is_dir(parent_dentry));
+		error = -EFSCORRUPTED;
+		goto out_dput_parent;
+	}
+
+	/*
+	 * Try to find the dirent pointing to the child.  If there isn't one,
+	 * we're done.
+	 */
+	qname.hash = full_name_hash(parent_dentry, name->name, name->len);
+	child_dentry = d_lookup(parent_dentry, &qname);
+	if (!child_dentry) {
+		error = 0;
+		goto out_dput_parent;
+	}
+
+	trace_xrep_dirtree_delete_child(dp->i_mount, child_dentry);
+
+	/* Child is not a directory?  We're screwed. */
+	if (!d_is_dir(child_dentry)) {
+		ASSERT(d_is_dir(child_dentry));
+		error = -EFSCORRUPTED;
+		goto out_dput_child;
+	}
+
+	/* Replace the child dentry with a negative one. */
+	d_delete(child_dentry);
+
+out_dput_child:
+	dput(child_dentry);
+out_dput_parent:
+	dput(parent_dentry);
+	return error;
+}
+
+/*
+ * Prepare to delete a link by taking the IOLOCK of the parent and the child
+ * (scrub target).  Caller must hold IOLOCK_EXCL on @sc->ip.  Returns 0 if we
+ * took both locks, or a negative errno if we couldn't lock the parent in time.
+ */
+static inline int
+xrep_dirtree_unlink_iolock(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp)
+{
+	int			error;
+
+	ASSERT(sc->ilock_flags & XFS_IOLOCK_EXCL);
+
+	if (xfs_ilock_nowait(dp, XFS_IOLOCK_EXCL))
+		return 0;
+
+	xchk_iunlock(sc, XFS_IOLOCK_EXCL);
+	do {
+		xfs_ilock(dp, XFS_IOLOCK_EXCL);
+		if (xchk_ilock_nowait(sc, XFS_IOLOCK_EXCL))
+			break;
+		xfs_iunlock(dp, XFS_IOLOCK_EXCL);
+
+		if (xchk_should_terminate(sc, &error)) {
+			xchk_ilock(sc, XFS_IOLOCK_EXCL);
+			return error;
+		}
+
+		delay(1);
+	} while (1);
+
+	return 0;
+}
+
+/*
+ * Remove a link from the directory tree and update the dcache.  Returns
+ * -ESTALE if the scan data are now out of date.
+ */
+STATIC int
+xrep_dirtree_unlink(
+	struct xchk_dirtree		*dl,
+	struct xfs_inode		*dp,
+	struct xchk_dirpath		*path,
+	struct xchk_dirpath_step	*step)
+{
+	struct xfs_name			name = {
+		.name			= dl->pptr.p_name,
+		.len			= step->name_len,
+	};
+	struct xfs_scrub		*sc = dl->sc;
+	struct xfs_mount		*mp = sc->mp;
+	xfs_ino_t			dotdot_ino;
+	xfs_ino_t			parent_ino = dl->parent_ino;
+	unsigned int			resblks;
+	int				dontcare;
+	int				error;
+
+	/* Take IOLOCK_EXCL of the parent and child. */
+	error = xrep_dirtree_unlink_iolock(sc, dp);
+	if (error)
+		return error;
+
+	xfs_parent_args_init(mp, &dl->ppargs);
+
+	/*
+	 * Create the transaction that we need to sever the path.  Ignore
+	 * EDQUOT and ENOSPC being returned via nospace_error because the
+	 * directory code can handle a reservationless update.
+	 */
+	resblks = xfs_remove_space_res(mp, step->name_len);
+	error = xfs_trans_alloc_dir(dp, &M_RES(mp)->tr_remove, sc->ip,
+			&resblks, &sc->tp, &dontcare);
+	if (error)
+		goto out_iolock;
+
+	/*
+	 * Cancel if someone invalidate the paths while we were trying to get
+	 * the ILOCK.
+	 */
+	mutex_lock(&dl->lock);
+	if (dl->stale) {
+		mutex_unlock(&dl->lock);
+		error = -ESTALE;
+		goto out_trans_cancel;
+	}
+	xrep_dirpath_set_outcome(dl, path, XREP_DIRPATH_DELETING);
+	mutex_unlock(&dl->lock);
+
+	trace_xrep_dirtree_delete_path(dl->sc, sc->ip, path->path_nr,
+			&dl->pptr);
+
+	/*
+	 * Decide if we need to reset the dotdot entry.  Rules:
+	 *
+	 * - If there's a surviving parent, we want dotdot to point there.
+	 * - If we don't have any surviving parents, then point dotdot at the
+	 *   root dir.
+	 * - If dotdot is already set to the value we want, pass in NULLFSINO
+	 *   for no change necessary.
+	 *
+	 * Do this /before/ we dirty anything, in case the dotdot lookup
+	 * fails.
+	 */
+	error = xchk_dir_lookup(sc, sc->ip, &xfs_name_dotdot, &dotdot_ino);
+	if (error)
+		goto out_trans_cancel;
+	if (parent_ino == NULLFSINO)
+		parent_ino = dl->root_ino;
+	if (dotdot_ino == parent_ino)
+		parent_ino = NULLFSINO;
+
+	/* Drop the link from sc->ip's dotdot entry.  */
+	error = xfs_droplink(sc->tp, dp);
+	if (error)
+		goto out_trans_cancel;
+
+	/* Reset the dotdot entry to a surviving parent. */
+	if (parent_ino != NULLFSINO) {
+		error = xfs_dir_replace(sc->tp, sc->ip, &xfs_name_dotdot,
+				parent_ino, 0);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	/* Drop the link from dp to sc->ip. */
+	error = xfs_droplink(sc->tp, sc->ip);
+	if (error)
+		goto out_trans_cancel;
+
+	error = xfs_dir_removename(sc->tp, dp, &name, sc->ip->i_ino, resblks);
+	if (error) {
+		ASSERT(error != -ENOENT);
+		goto out_trans_cancel;
+	}
+
+	if (xfs_has_parent(sc->mp)) {
+		error = xfs_parent_removename(sc->tp, &dl->ppargs, dp, &name,
+				sc->ip);
+		if (error)
+			goto out_trans_cancel;
+	}
+
+	/*
+	 * Notify dirent hooks that we removed the bad link, invalidate the
+	 * dcache, and commit the repair.
+	 */
+	xfs_dir_update_hook(dp, sc->ip, -1, &name);
+	error = xrep_dirtree_purge_dentry(dl, dp, &name);
+	if (error)
+		goto out_trans_cancel;
+
+	error = xrep_trans_commit(sc);
+	goto out_ilock;
+
+out_trans_cancel:
+	xchk_trans_cancel(sc);
+out_ilock:
+	xfs_iunlock(sc->ip, XFS_ILOCK_EXCL);
+	xfs_iunlock(dp, XFS_ILOCK_EXCL);
+out_iolock:
+	xfs_iunlock(dp, XFS_IOLOCK_EXCL);
+	return error;
+}
+
+/*
+ * Delete a directory entry that points to this directory.  Returns -ESTALE
+ * if the scan data are now out of date.
+ */
+STATIC int
+xrep_dirtree_delete_path(
+	struct xchk_dirtree		*dl,
+	struct xchk_dirpath		*path)
+{
+	struct xchk_dirpath_step	step;
+	struct xfs_scrub		*sc = dl->sc;
+	struct xfs_inode		*dp;
+	int				error;
+
+	/*
+	 * Load the parent pointer and directory inode for this path, then
+	 * drop the scan lock, the ILOCK, and the transaction so that
+	 * _delete_path can reserve the proper transaction.
+	 */
+	error = xrep_dirtree_prep_path(dl, path, &step);
+	if (error)
+		return error;
+
+	error = xchk_iget(sc, step.parent_ino, &dp);
+	if (error)
+		return error;
+
+	mutex_unlock(&dl->lock);
+	xchk_trans_cancel(sc);
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+
+	/* Delete the directory link and release the parent. */
+	error = xrep_dirtree_unlink(dl, dp, path, &step);
+	xchk_irele(sc, dp);
+
+	/*
+	 * Retake all the resources we had at the beginning even if the repair
+	 * failed or the scan data are now stale.  This keeps things simple for
+	 * the caller.
+	 */
+	xchk_trans_alloc_empty(sc);
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
+	mutex_lock(&dl->lock);
+
+	if (!error && dl->stale)
+		error = -ESTALE;
+	return error;
+}
+
+/* Add a new path to represent our in-progress adoption. */
+STATIC int
+xrep_dirtree_create_adoption_path(
+	struct xchk_dirtree		*dl)
+{
+	struct xfs_scrub		*sc = dl->sc;
+	struct xchk_dirpath		*path;
+	int				error;
+
+	/*
+	 * We should have capped the number of paths at XFS_MAXLINK-1 in the
+	 * scanner.
+	 */
+	if (dl->nr_paths > XFS_MAXLINK) {
+		ASSERT(dl->nr_paths <= XFS_MAXLINK);
+		return -EFSCORRUPTED;
+	}
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
+	path->outcome = XREP_DIRPATH_ADOPTING;
+
+	/*
+	 * Record the new link that we just created in the orphanage.  Because
+	 * adoption is the last repair that we perform, we don't bother filling
+	 * in the path all the way back to the root.
+	 */
+	dl->pptr.p_ino = sc->orphanage->i_ino;
+	dl->pptr.p_gen = VFS_I(sc->orphanage)->i_generation;
+	dl->pptr.p_namelen = dl->adoption.xname.len;
+
+	error = xino_bitmap_set(&path->seen_inodes, sc->orphanage->i_ino);
+	if (error)
+		goto out_path;
+
+	trace_xrep_dirtree_create_adoption(sc, sc->ip, dl->nr_paths, &dl->pptr);
+
+	error = xchk_dirpath_append(dl, sc->ip, path, &dl->pptr);
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
+
+out_path:
+	kfree(path);
+	return error;
+}
+
+/*
+ * Prepare to move a file to the orphanage by taking the IOLOCK of the
+ * orphanage and the child (scrub target).  Caller must hold IOLOCK_EXCL on
+ * @sc->ip.  Returns 0 if we took both locks, or a negative errno if we
+ * couldn't lock the orphanage in time.
+ */
+static inline int
+xrep_dirtree_adopt_iolock(
+	struct xfs_scrub	*sc)
+{
+	int			error;
+
+	ASSERT(sc->ilock_flags & XFS_IOLOCK_EXCL);
+
+	if (xrep_orphanage_ilock_nowait(sc, XFS_IOLOCK_EXCL))
+		return 0;
+
+	xchk_iunlock(sc, XFS_IOLOCK_EXCL);
+	do {
+		xrep_orphanage_ilock(sc, XFS_IOLOCK_EXCL);
+		if (xchk_ilock_nowait(sc, XFS_IOLOCK_EXCL))
+			break;
+		xrep_orphanage_iunlock(sc, XFS_IOLOCK_EXCL);
+
+		if (xchk_should_terminate(sc, &error)) {
+			xchk_ilock(sc, XFS_IOLOCK_EXCL);
+			return error;
+		}
+
+		delay(1);
+	} while (1);
+
+	return 0;
+}
+
+/*
+ * Reattach this orphaned directory to the orphanage.  Do not call this with
+ * any resources held.  Returns -ESTALE if the scan data have become out of
+ * date.
+ */
+STATIC int
+xrep_dirtree_adopt(
+	struct xchk_dirtree		*dl)
+{
+	struct xfs_scrub		*sc = dl->sc;
+	int				error;
+
+	/* Take the IOLOCK of the orphanage and the scrub target. */
+	error = xrep_dirtree_adopt_iolock(sc);
+	if (error)
+		return error;
+
+	/*
+	 * Set up for an adoption.  The directory tree fixer runs after the
+	 * link counts have been corrected.  Therefore, we must bump the
+	 * child's link count since there will be no further opportunity to fix
+	 * errors.
+	 */
+	error = xrep_adoption_trans_alloc(sc, &dl->adoption);
+	if (error)
+		goto out_iolock;
+	dl->adoption.bump_child_nlink = true;
+
+	/* Figure out what name we're going to use here. */
+	error = xrep_adoption_compute_name(&dl->adoption, dl->pptr.p_name);
+	if (error)
+		goto out_trans;
+
+	/*
+	 * Now that we have a proposed name for the orphanage entry, create
+	 * a faux path so that the live update hook will see it.
+	 */
+	mutex_lock(&dl->lock);
+	if (dl->stale) {
+		mutex_unlock(&dl->lock);
+		error = -ESTALE;
+		goto out_trans;
+	}
+	error = xrep_dirtree_create_adoption_path(dl);
+	mutex_unlock(&dl->lock);
+	if (error)
+		goto out_trans;
+
+	/* Reparent the directory. */
+	error = xrep_adoption_move(&dl->adoption);
+	if (error)
+		goto out_trans;
+
+	/*
+	 * Commit the name and release all inode locks except for the scrub
+	 * target's IOLOCK.
+	 */
+	error = xrep_trans_commit(sc);
+	goto out_ilock;
+
+out_trans:
+	xchk_trans_cancel(sc);
+out_ilock:
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+	xrep_orphanage_iunlock(sc, XFS_ILOCK_EXCL);
+out_iolock:
+	xrep_orphanage_iunlock(sc, XFS_IOLOCK_EXCL);
+	return error;
+}
+
+/*
+ * This newly orphaned directory needs to be adopted by the orphanage.
+ * Make this happen.
+ */
+STATIC int
+xrep_dirtree_move_to_orphanage(
+	struct xchk_dirtree		*dl)
+{
+	struct xfs_scrub		*sc = dl->sc;
+	int				error;
+
+	/*
+	 * Start by dropping all the resources that we hold so that we can grab
+	 * all the resources that we need for the adoption.
+	 */
+	mutex_unlock(&dl->lock);
+	xchk_trans_cancel(sc);
+	xchk_iunlock(sc, XFS_ILOCK_EXCL);
+
+	/* Perform the adoption. */
+	error = xrep_dirtree_adopt(dl);
+
+	/*
+	 * Retake all the resources we had at the beginning even if the repair
+	 * failed or the scan data are now stale.  This keeps things simple for
+	 * the caller.
+	 */
+	xchk_trans_alloc_empty(sc);
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
+	mutex_lock(&dl->lock);
+
+	if (!error && dl->stale)
+		error = -ESTALE;
+	return error;
+}
+
+/*
+ * Try to fix all the problems.  Returns -ESTALE if the scan data have become
+ * out of date.
+ */
+STATIC int
+xrep_dirtree_fix_problems(
+	struct xchk_dirtree		*dl,
+	struct xchk_dirtree_outcomes	*oc)
+{
+	struct xchk_dirpath		*path;
+	int				error;
+
+	/* Delete all the paths we don't want. */
+	xchk_dirtree_for_each_path(dl, path) {
+		if (path->outcome != XCHK_DIRPATH_DELETE)
+			continue;
+
+		error = xrep_dirtree_delete_path(dl, path);
+		if (error)
+			return error;
+	}
+
+	/* Reparent this directory to the orphanage. */
+	if (oc->needs_adoption) {
+		if (xrep_orphanage_can_adopt(dl->sc))
+			return xrep_dirtree_move_to_orphanage(dl);
+		return -EFSCORRUPTED;
+	}
+
+	return 0;
+}
+
+/* Fix directory loops involving this directory. */
+int
+xrep_dirtree(
+	struct xfs_scrub		*sc)
+{
+	struct xchk_dirtree		*dl = sc->buf;
+	struct xchk_dirtree_outcomes	oc;
+	int				error;
+
+	/*
+	 * Prepare to fix the directory tree by retaking the scan lock.  The
+	 * order of resource acquisition is still IOLOCK -> transaction ->
+	 * ILOCK -> scan lock.
+	 */
+	mutex_lock(&dl->lock);
+	do {
+		/*
+		 * Decide what we're going to do, then do it.  An -ESTALE
+		 * return here means the scan results are invalid and we have
+		 * to walk again.
+		 */
+		if (!dl->stale) {
+			xrep_dirtree_decide_fate(dl, &oc);
+
+			trace_xrep_dirtree_decided_fate(dl, &oc);
+
+			error = xrep_dirtree_fix_problems(dl, &oc);
+			if (!error || error != -ESTALE)
+				break;
+		}
+		error = xchk_dirtree_find_paths_to_root(dl);
+		if (error == -ELNRNG || error == -ENOSR)
+			error = -EFSCORRUPTED;
+	} while (!error);
+	mutex_unlock(&dl->lock);
+
+	return error;
+}
diff --git a/fs/xfs/scrub/orphanage.c b/fs/xfs/scrub/orphanage.c
index b894b807155a7..f1711d6031613 100644
--- a/fs/xfs/scrub/orphanage.c
+++ b/fs/xfs/scrub/orphanage.c
@@ -572,6 +572,12 @@ xrep_adoption_move(
 		xfs_bumplink(sc->tp, sc->orphanage);
 	xfs_trans_log_inode(sc->tp, sc->orphanage, XFS_ILOG_CORE);
 
+	/* Bump the link count of the child. */
+	if (adopt->bump_child_nlink) {
+		xfs_bumplink(sc->tp, sc->ip);
+		xfs_trans_log_inode(sc->tp, sc->ip, XFS_ILOG_CORE);
+	}
+
 	/* Replace the dotdot entry if the child is a subdirectory. */
 	if (isdir) {
 		error = xfs_dir_replace(sc->tp, sc->ip, &xfs_name_dotdot,
diff --git a/fs/xfs/scrub/orphanage.h b/fs/xfs/scrub/orphanage.h
index 74ce0bc05c6f1..2ee0e68226618 100644
--- a/fs/xfs/scrub/orphanage.h
+++ b/fs/xfs/scrub/orphanage.h
@@ -60,6 +60,14 @@ struct xrep_adoption {
 	/* Block reservations for orphanage and child (if directory). */
 	unsigned int		orphanage_blkres;
 	unsigned int		child_blkres;
+
+	/*
+	 * Does the caller want us to bump the child link count?  This is not
+	 * needed when reattaching files that have become disconnected but have
+	 * nlink > 1.  It is necessary when changing the directory tree
+	 * structure.
+	 */
+	bool			bump_child_nlink:1;
 };
 
 bool xrep_orphanage_can_adopt(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
index 7ee5f7e5bffcb..22bce1def9393 100644
--- a/fs/xfs/scrub/repair.h
+++ b/fs/xfs/scrub/repair.h
@@ -95,6 +95,7 @@ int xrep_setup_directory(struct xfs_scrub *sc);
 int xrep_setup_parent(struct xfs_scrub *sc);
 int xrep_setup_nlinks(struct xfs_scrub *sc);
 int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *resblks);
+int xrep_setup_dirtree(struct xfs_scrub *sc);
 
 /* Repair setup functions */
 int xrep_setup_ag_allocbt(struct xfs_scrub *sc);
@@ -132,6 +133,7 @@ int xrep_xattr(struct xfs_scrub *sc);
 int xrep_directory(struct xfs_scrub *sc);
 int xrep_parent(struct xfs_scrub *sc);
 int xrep_symlink(struct xfs_scrub *sc);
+int xrep_dirtree(struct xfs_scrub *sc);
 
 #ifdef CONFIG_XFS_RT
 int xrep_rtbitmap(struct xfs_scrub *sc);
@@ -205,6 +207,7 @@ xrep_setup_nothing(
 #define xrep_setup_directory		xrep_setup_nothing
 #define xrep_setup_parent		xrep_setup_nothing
 #define xrep_setup_nlinks		xrep_setup_nothing
+#define xrep_setup_dirtree		xrep_setup_nothing
 
 #define xrep_setup_inode(sc, imap)	((void)0)
 
@@ -239,6 +242,7 @@ static inline int xrep_setup_symlink(struct xfs_scrub *sc, unsigned int *x)
 #define xrep_directory			xrep_notsupported
 #define xrep_parent			xrep_notsupported
 #define xrep_symlink			xrep_notsupported
+#define xrep_dirtree			xrep_notsupported
 
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index b6f18d61d8816..4d7116250036f 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -444,7 +444,7 @@ static const struct xchk_meta_ops meta_scrub_ops[] = {
 		.setup	= xchk_setup_dirtree,
 		.scrub	= xchk_dirtree,
 		.has	= xfs_has_parent,
-		.repair	= xrep_notsupported,
+		.repair	= xrep_dirtree,
 	},
 };
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 0d4c1580f61b7..cf209ac9b5329 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1694,6 +1694,10 @@ TRACE_DEFINE_ENUM(XCHK_DIRPATH_CORRUPT);
 TRACE_DEFINE_ENUM(XCHK_DIRPATH_LOOP);
 TRACE_DEFINE_ENUM(XCHK_DIRPATH_STALE);
 TRACE_DEFINE_ENUM(XCHK_DIRPATH_OK);
+TRACE_DEFINE_ENUM(XREP_DIRPATH_DELETING);
+TRACE_DEFINE_ENUM(XREP_DIRPATH_DELETED);
+TRACE_DEFINE_ENUM(XREP_DIRPATH_ADOPTING);
+TRACE_DEFINE_ENUM(XREP_DIRPATH_ADOPTED);
 
 #define XCHK_DIRPATH_OUTCOME_STRINGS \
 	{ XCHK_DIRPATH_SCANNING,	"scanning" }, \
@@ -1701,7 +1705,11 @@ TRACE_DEFINE_ENUM(XCHK_DIRPATH_OK);
 	{ XCHK_DIRPATH_CORRUPT,		"corrupt" }, \
 	{ XCHK_DIRPATH_LOOP,		"loop" }, \
 	{ XCHK_DIRPATH_STALE,		"stale" }, \
-	{ XCHK_DIRPATH_OK,		"ok" }
+	{ XCHK_DIRPATH_OK,		"ok" }, \
+	{ XREP_DIRPATH_DELETING,	"deleting" }, \
+	{ XREP_DIRPATH_DELETED,		"deleted" }, \
+	{ XREP_DIRPATH_ADOPTING,	"adopting" }, \
+	{ XREP_DIRPATH_ADOPTED,		"adopted" }
 
 DECLARE_EVENT_CLASS(xchk_dirpath_outcome_class,
 	TP_PROTO(struct xfs_scrub *sc, unsigned long long path_nr,
@@ -1747,6 +1755,7 @@ DECLARE_EVENT_CLASS(xchk_dirtree_evaluate_class,
 		__field(unsigned int, bad)
 		__field(unsigned int, suspect)
 		__field(unsigned int, good)
+		__field(bool, needs_adoption)
 	),
 	TP_fast_assign(
 		__entry->dev = dl->sc->mp->m_super->s_dev;
@@ -1756,15 +1765,17 @@ DECLARE_EVENT_CLASS(xchk_dirtree_evaluate_class,
 		__entry->bad = oc->bad;
 		__entry->suspect = oc->suspect;
 		__entry->good = oc->good;
+		__entry->needs_adoption = oc->needs_adoption ? 1 : 0;
 	),
-	TP_printk("dev %d:%d ino 0x%llx rootino 0x%llx nr_paths %u bad %u suspect %u good %u",
+	TP_printk("dev %d:%d ino 0x%llx rootino 0x%llx nr_paths %u bad %u suspect %u good %u adopt? %d",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->rootino,
 		  __entry->nr_paths,
 		  __entry->bad,
 		  __entry->suspect,
-		  __entry->good)
+		  __entry->good,
+		  __entry->needs_adoption)
 );
 #define DEFINE_XCHK_DIRTREE_EVALUATE_EVENT(name) \
 DEFINE_EVENT(xchk_dirtree_evaluate_class, name, \
@@ -3301,6 +3312,7 @@ DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_check_child);
 DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_check_alias);
 DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_check_dentry);
 DEFINE_REPAIR_DENTRY_EVENT(xrep_adoption_invalidate_child);
+DEFINE_REPAIR_DENTRY_EVENT(xrep_dirtree_delete_child);
 
 TRACE_EVENT(xrep_symlink_salvage_target,
 	TP_PROTO(struct xfs_inode *ip, char *target, unsigned int targetlen),
@@ -3603,6 +3615,11 @@ TRACE_EVENT(xrep_iunlink_commit_bucket,
 		  __entry->agino)
 );
 
+DEFINE_XCHK_DIRPATH_OUTCOME_EVENT(xrep_dirpath_set_outcome);
+DEFINE_XCHK_DIRTREE_EVENT(xrep_dirtree_delete_path);
+DEFINE_XCHK_DIRTREE_EVENT(xrep_dirtree_create_adoption);
+DEFINE_XCHK_DIRTREE_EVALUATE_EVENT(xrep_dirtree_decided_fate);
+
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 998df0d5dac3c..01b100e28b541 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -914,7 +914,7 @@ xfs_init_new_inode(
  * link count to go to zero, move the inode to AGI unlinked list so that it can
  * be freed when the last active reference goes away via xfs_inactive().
  */
-static int			/* error */
+int
 xfs_droplink(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*ip)
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 14c6d9e7ab975..cbde77d711b49 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -622,6 +622,7 @@ void xfs_end_io(struct work_struct *work);
 int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_remapping(struct xfs_inode *ip1, struct xfs_inode *ip2);
+int xfs_droplink(struct xfs_trans *tp, struct xfs_inode *ip);
 void xfs_bumplink(struct xfs_trans *tp, struct xfs_inode *ip);
 void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
 void xfs_sort_inodes(struct xfs_inode **i_tab, unsigned int num_inodes);

