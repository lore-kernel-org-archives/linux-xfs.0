Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E41A91F60A
	for <linux-xfs@vger.kernel.org>; Wed, 27 Mar 2024 02:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711505060; cv=none; b=aXjr3hVCneRo9jBIVkFf8zyM+jJtfMdPFpmKq6h+qxszkuAYvTkcChuO8RW0f6e0MHYy0pYccAGCh+dvUBF5xbV9KxTrc8aSs88OkWEWWHlzO70Tk9QiOHjeMUQY+55+Q4aIiD1aajUBf1TxYkcO1zC2y1X/x0pW0PxxNE7uvc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711505060; c=relaxed/simple;
	bh=hHgSUCZ/XDPMkBx4EoK8Ki1r0lbezlkb/WViFt3gfis=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qA27AfJZ2Tx2xl1tWeJr+0FFyVItLFelMWPgj7G/waNdQeClbVBTxg0EGm9vnAvSrngTl+7opxYrF7310OlyYiSGs6ykfdaTovk2oldiT90pLSAyFl7KVy5inYZUjBg5WIXwSYH3edpBrvDa0FUSbFuZNVIomUj5yx8bTbrpVV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iXTRh/ty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iXTRh/ty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8391DC433C7;
	Wed, 27 Mar 2024 02:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711505059;
	bh=hHgSUCZ/XDPMkBx4EoK8Ki1r0lbezlkb/WViFt3gfis=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=iXTRh/tyE+7xV55BPeUXjxfSSG7RxoMegAU48FPZpSsZjkjIsavl2bNiEKtKv4Ut1
	 Q50ItHdBl0wzMOGsAJF4n2ah5CAXM5P6/KnaiP8BU3ZzWhyNi7w7hdShuLjLW/Jwqo
	 oj6vDuFG+yvIU2z8uuU/a5aBxxk+6QsWbroGGykYMn3a9l9aURx4rEQKxe+g1BI0TY
	 qmWz1rozkUlYhd9hX2fhVoZNFLVbPjU7UEnEms4MWohtpkRAhSD06xX7lFtWQANTGd
	 3oMo2ddHq56fQMqLqbHZVj9FYBIVxvA/Sxs6ldl8ZqNbtXs+Y2F9S8/+HTvH9tlZ9U
	 GiIQNg1+ZbcCw==
Date: Tue, 26 Mar 2024 19:04:19 -0700
Subject: [PATCH 3/5] xfs: scan the filesystem to repair a directory dotdot
 entry
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171150383579.3217994.13834775773373219763.stgit@frogsfrogsfrogs>
In-Reply-To: <171150383515.3217994.11426825010369201405.stgit@frogsfrogsfrogs>
References: <171150383515.3217994.11426825010369201405.stgit@frogsfrogsfrogs>
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

Teach the online directory repair code to scan the filesystem so that we
can set the dotdot entry when we're rebuilding a directory.  This
involves dropping ILOCK on the directory that we're repairing, which
means that the VFS can sneak in and tell us to update dotdot at any
time.  Deal with these races by using a dirent hook to absorb dotdot
updates, and be careful not to check the scan results until after we've
retaken the ILOCK.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/Makefile           |    1 
 fs/xfs/scrub/dir_repair.c |   70 +++++---
 fs/xfs/scrub/findparent.c |  412 +++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/findparent.h |   49 +++++
 fs/xfs/scrub/iscan.c      |   18 ++
 fs/xfs/scrub/iscan.h      |    1 
 fs/xfs/scrub/trace.h      |    1 
 7 files changed, 528 insertions(+), 24 deletions(-)
 create mode 100644 fs/xfs/scrub/findparent.c
 create mode 100644 fs/xfs/scrub/findparent.h


diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 5c9449e14f743..3c754777ec288 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -199,6 +199,7 @@ xfs-y				+= $(addprefix scrub/, \
 				   bmap_repair.o \
 				   cow_repair.o \
 				   dir_repair.o \
+				   findparent.o \
 				   fscounters_repair.o \
 				   ialloc_repair.o \
 				   inode_repair.o \
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index f565f0d158bf7..8b6ebf0697397 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -38,8 +38,10 @@
 #include "scrub/xfile.h"
 #include "scrub/xfarray.h"
 #include "scrub/xfblob.h"
+#include "scrub/iscan.h"
 #include "scrub/readdir.h"
 #include "scrub/reap.h"
+#include "scrub/findparent.h"
 
 /*
  * Directory Repair
@@ -108,10 +110,10 @@ struct xrep_dir {
 	struct xfs_da_args	args;
 
 	/*
-	 * This is the parent that we're going to set on the reconstructed
-	 * directory.
+	 * Information used to scan the filesystem to find the inumber of the
+	 * dotdot entry for this directory.
 	 */
-	xfs_ino_t		parent_ino;
+	struct xrep_parent_scan_info pscan;
 
 	/* How many subdirectories did we find? */
 	uint64_t		subdirs;
@@ -130,6 +132,7 @@ xrep_dir_teardown(
 {
 	struct xrep_dir		*rd = sc->buf;
 
+	xrep_findparent_scan_teardown(&rd->pscan);
 	xfblob_destroy(rd->dir_names);
 	xfarray_destroy(rd->dir_entries);
 }
@@ -142,6 +145,8 @@ xrep_setup_directory(
 	struct xrep_dir		*rd;
 	int			error;
 
+	xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
+
 	error = xrep_tempfile_create(sc, S_IFDIR);
 	if (error)
 		return error;
@@ -177,8 +182,8 @@ xrep_dir_self_parent(
 }
 
 /*
- * Look up the dotdot entry.  Returns NULLFSINO if we don't know what to do.
- * The next patch will check this more carefully.
+ * Look up the dotdot entry and confirm that it's really the parent.
+ * Returns NULLFSINO if we don't know what to do.
  */
 static inline xfs_ino_t
 xrep_dir_lookup_parent(
@@ -194,37 +199,39 @@ xrep_dir_lookup_parent(
 	if (!xfs_verify_dir_ino(sc->mp, ino))
 		return NULLFSINO;
 
+	error = xrep_findparent_confirm(sc, &ino);
+	if (error)
+		return NULLFSINO;
+
 	return ino;
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
 	xfs_ino_t		ino;
 
-	ino = xrep_dir_self_parent(rd);
+	ino = xrep_findparent_self_reference(rd->sc);
 	if (ino != NULLFSINO) {
-		rd->parent_ino = ino;
+		xrep_findparent_scan_finish_early(&rd->pscan, ino);
 		return 0;
 	}
 
 	ino = xrep_dir_lookup_parent(rd);
 	if (ino != NULLFSINO) {
-		rd->parent_ino = ino;
+		xrep_findparent_scan_finish_early(&rd->pscan, ino);
 		return 0;
 	}
 
-	/* NOTE: A future patch will deal with moving orphans. */
-	return -EFSCORRUPTED;
+	/*
+	 * A full filesystem scan is the last resort.  On a busy filesystem,
+	 * the scan can fail with -EBUSY if we cannot grab IOLOCKs.  That means
+	 * that we don't know what who the parent is, so we should return to
+	 * userspace.
+	 */
+	return xrep_findparent_scan(&rd->pscan);
 }
 
 /*
@@ -933,6 +940,10 @@ xrep_dir_salvage_entries(
 	 * the directory until we're ready for the exchange operation.  Reads
 	 * will return -EIO without shutting down the fs, so we're ok with
 	 * that.
+	 *
+	 * The VFS can change dotdot on us, but the findparent scan will keep
+	 * our incore parent inode up to date.  See the note on locking issues
+	 * for more details.
 	 */
 	error = xrep_trans_commit(sc);
 	if (error)
@@ -1156,6 +1167,14 @@ xrep_dir_swap(
 	if (rd->subdirs + 2 > XFS_MAXLINK)
 		return -EFSCORRUPTED;
 
+	/*
+	 * If we never found the parent for this directory, we can't fix this
+	 * directory.
+	 */
+	ASSERT(sc->ilock_flags & XFS_ILOCK_EXCL);
+	if (rd->pscan.parent_ino == NULLFSINO)
+		return -EFSCORRUPTED;
+
 	/*
 	 * Reset the temporary directory's '..' entry to point to the parent
 	 * that we found.  The temporary directory was created with the root
@@ -1165,9 +1184,9 @@ xrep_dir_swap(
 	 * It's also possible that this replacement could also expand a sf
 	 * tempdir into block format.
 	 */
-	if (rd->parent_ino != sc->mp->m_rootip->i_ino) {
+	if (rd->pscan.parent_ino != sc->mp->m_rootip->i_ino) {
 		error = xrep_dir_replace(rd, rd->sc->tempip, &xfs_name_dotdot,
-				rd->parent_ino, rd->tx.req.resblks);
+				rd->pscan.parent_ino, rd->tx.req.resblks);
 		if (error)
 			return error;
 	}
@@ -1226,7 +1245,7 @@ xrep_dir_rebuild_tree(
 	struct xfs_scrub	*sc = rd->sc;
 	int			error;
 
-	trace_xrep_dir_rebuild_tree(sc->ip, rd->parent_ino);
+	trace_xrep_dir_rebuild_tree(sc->ip, rd->pscan.parent_ino);
 
 	/*
 	 * Take the IOLOCK on the temporary file so that we can run dir
@@ -1283,8 +1302,6 @@ xrep_dir_setup_scan(
 	char			*descr;
 	int			error;
 
-	rd->parent_ino = NULLFSINO;
-
 	/* Set up some staging memory for salvaging dirents. */
 	descr = xchk_xfile_ino_descr(sc, "directory entries");
 	error = xfarray_create(descr, 0, sizeof(struct xrep_dirent),
@@ -1299,8 +1316,15 @@ xrep_dir_setup_scan(
 	if (error)
 		goto out_xfarray;
 
+	error = xrep_findparent_scan_start(sc, &rd->pscan);
+	if (error)
+		goto out_xfblob;
+
 	return 0;
 
+out_xfblob:
+	xfblob_destroy(rd->dir_names);
+	rd->dir_names = NULL;
 out_xfarray:
 	xfarray_destroy(rd->dir_entries);
 	rd->dir_entries = NULL;
diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
new file mode 100644
index 0000000000000..7b3ec8d7d6cc9
--- /dev/null
+++ b/fs/xfs/scrub/findparent.c
@@ -0,0 +1,412 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
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
+#include "xfs_exchmaps.h"
+#include "scrub/xfs_scrub.h"
+#include "scrub/scrub.h"
+#include "scrub/common.h"
+#include "scrub/trace.h"
+#include "scrub/repair.h"
+#include "scrub/iscan.h"
+#include "scrub/findparent.h"
+#include "scrub/readdir.h"
+#include "scrub/tempfile.h"
+
+/*
+ * Finding the Parent of a Directory
+ * =================================
+ *
+ * Directories have parent pointers, in the sense that each directory contains
+ * a dotdot entry that points to the single allowed parent.  The brute force
+ * way to find the parent of a given directory is to scan every directory in
+ * the filesystem looking for a child dirent that references this directory.
+ *
+ * This module wraps the process of scanning the directory tree.  It requires
+ * that @sc->ip is the directory whose parent we want to find, and that the
+ * caller hold only the IOLOCK on that directory.  The scan itself needs to
+ * take the ILOCK of each directory visited.
+ *
+ * Because we cannot hold @sc->ip's ILOCK during a scan of the whole fs, it is
+ * necessary to use dirent hook to update the parent scan results.  Callers
+ * must not read the scan results without re-taking @sc->ip's ILOCK.
+ *
+ * There are a few shortcuts that we can take to avoid scanning the entire
+ * filesystem, such as noticing directory tree roots.
+ */
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
+	/* Optional scan information for a xrep_findparent_scan call. */
+	struct xrep_parent_scan_info *parent_scan;
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
+
+	if (fpi->parent_scan)
+		xrep_findparent_scan_found(fpi->parent_scan, fpi->dp->i_ino);
+
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
+	/*
+	 * Scan the directory to see if there it contains an entry pointing to
+	 * the directory that we are repairing.
+	 */
+	lock_mode = xfs_ilock_data_map_shared(dp);
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
+	 * We cannot complete our parent pointer scan if a directory looks as
+	 * though it has been zapped by the inode record repair code.
+	 */
+	if (xchk_dir_looks_zapped(dp)) {
+		error = -EBUSY;
+		goto out_unlock;
+	}
+
+	error = xchk_dir_walk(sc, dp, xrep_findparent_dirent, fpi);
+	if (error)
+		goto out_unlock;
+
+out_unlock:
+	xfs_iunlock(dp, lock_mode);
+	return error;
+}
+
+/*
+ * Update this directory's dotdot pointer based on ongoing dirent updates.
+ */
+STATIC int
+xrep_findparent_live_update(
+	struct notifier_block		*nb,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_dir_update_params	*p = data;
+	struct xrep_parent_scan_info	*pscan;
+	struct xfs_scrub		*sc;
+
+	pscan = container_of(nb, struct xrep_parent_scan_info,
+			dhook.dirent_hook.nb);
+	sc = pscan->sc;
+
+	/*
+	 * If @p->ip is the subdirectory that we're interested in and we've
+	 * already scanned @p->dp, update the dotdot target inumber to the
+	 * parent inode.
+	 */
+	if (p->ip->i_ino == sc->ip->i_ino &&
+	    xchk_iscan_want_live_update(&pscan->iscan, p->dp->i_ino)) {
+		if (p->delta > 0) {
+			xrep_findparent_scan_found(pscan, p->dp->i_ino);
+		} else {
+			xrep_findparent_scan_found(pscan, NULLFSINO);
+		}
+	}
+
+	return NOTIFY_DONE;
+}
+
+/*
+ * Set up a scan to find the parent of a directory.  The provided dirent hook
+ * will be called when there is a dotdot update for the inode being repaired.
+ */
+int
+xrep_findparent_scan_start(
+	struct xfs_scrub		*sc,
+	struct xrep_parent_scan_info	*pscan)
+{
+	int				error;
+
+	if (!(sc->flags & XCHK_FSGATES_DIRENTS)) {
+		ASSERT(sc->flags & XCHK_FSGATES_DIRENTS);
+		return -EINVAL;
+	}
+
+	pscan->sc = sc;
+	pscan->parent_ino = NULLFSINO;
+
+	mutex_init(&pscan->lock);
+
+	xchk_iscan_start(sc, 30000, 100, &pscan->iscan);
+
+	/*
+	 * Hook into the dirent update code.  The hook only operates on inodes
+	 * that were already scanned, and the scanner thread takes each inode's
+	 * ILOCK, which means that any in-progress inode updates will finish
+	 * before we can scan the inode.
+	 */
+	xfs_dir_hook_setup(&pscan->dhook, xrep_findparent_live_update);
+	error = xfs_dir_hook_add(sc->mp, &pscan->dhook);
+	if (error)
+		goto out_iscan;
+
+	return 0;
+out_iscan:
+	xchk_iscan_teardown(&pscan->iscan);
+	mutex_destroy(&pscan->lock);
+	return error;
+}
+
+/*
+ * Scan the entire filesystem looking for a parent inode for the inode being
+ * scrubbed.  @sc->ip must not be the root of a directory tree.  Callers must
+ * not hold a dirty transaction or any lock that would interfere with taking
+ * an ILOCK.
+ *
+ * Returns 0 with @pscan->parent_ino set to the parent that we found.
+ * Returns 0 with @pscan->parent_ino set to NULLFSINO if we found no parents.
+ * Returns the usual negative errno if something else happened.
+ */
+int
+xrep_findparent_scan(
+	struct xrep_parent_scan_info	*pscan)
+{
+	struct xrep_findparent_info	fpi = {
+		.sc			= pscan->sc,
+		.found_parent		= NULLFSINO,
+		.parent_scan		= pscan,
+	};
+	struct xfs_scrub		*sc = pscan->sc;
+	int				ret;
+
+	ASSERT(S_ISDIR(VFS_IC(sc->ip)->i_mode));
+
+	while ((ret = xchk_iscan_iter(&pscan->iscan, &fpi.dp)) == 1) {
+		if (S_ISDIR(VFS_I(fpi.dp)->i_mode))
+			ret = xrep_findparent_walk_directory(&fpi);
+		else
+			ret = 0;
+		xchk_iscan_mark_visited(&pscan->iscan, fpi.dp);
+		xchk_irele(sc, fpi.dp);
+		if (ret)
+			break;
+
+		if (xchk_should_terminate(sc, &ret))
+			break;
+	}
+	xchk_iscan_iter_finish(&pscan->iscan);
+
+	return ret;
+}
+
+/* Tear down a parent scan. */
+void
+xrep_findparent_scan_teardown(
+	struct xrep_parent_scan_info	*pscan)
+{
+	xfs_dir_hook_del(pscan->sc->mp, &pscan->dhook);
+	xchk_iscan_teardown(&pscan->iscan);
+	mutex_destroy(&pscan->lock);
+}
+
+/* Finish a parent scan early. */
+void
+xrep_findparent_scan_finish_early(
+	struct xrep_parent_scan_info	*pscan,
+	xfs_ino_t			ino)
+{
+	xrep_findparent_scan_found(pscan, ino);
+	xchk_iscan_finish_early(&pscan->iscan);
+}
+
+/*
+ * Confirm that the directory @parent_ino actually contains a directory entry
+ * pointing to the child @sc->ip->ino.  This function returns one of several
+ * ways:
+ *
+ * Returns 0 with @parent_ino unchanged if the parent was confirmed.
+ * Returns 0 with @parent_ino set to NULLFSINO if the parent was not valid.
+ * Returns the usual negative errno if something else happened.
+ */
+int
+xrep_findparent_confirm(
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
+ * If we're the root of a directory tree, we are our own parent.  If we're an
+ * unlinked directory, the parent /won't/ have a link to us.  Set the parent
+ * directory to the root for both cases.  Returns NULLFSINO if we don't know
+ * what to do.
+ */
+xfs_ino_t
+xrep_findparent_self_reference(
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
diff --git a/fs/xfs/scrub/findparent.h b/fs/xfs/scrub/findparent.h
new file mode 100644
index 0000000000000..d946bc81f34e6
--- /dev/null
+++ b/fs/xfs/scrub/findparent.h
@@ -0,0 +1,49 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2020-2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_SCRUB_FINDPARENT_H__
+#define __XFS_SCRUB_FINDPARENT_H__
+
+struct xrep_parent_scan_info {
+	struct xfs_scrub	*sc;
+
+	/* Inode scan cursor. */
+	struct xchk_iscan	iscan;
+
+	/* Hook to capture directory entry updates. */
+	struct xfs_dir_hook	dhook;
+
+	/* Lock protecting parent_ino. */
+	struct mutex		lock;
+
+	/* Parent inode that we've found. */
+	xfs_ino_t		parent_ino;
+
+	bool			lookup_parent;
+};
+
+int xrep_findparent_scan_start(struct xfs_scrub *sc,
+		struct xrep_parent_scan_info *pscan);
+int xrep_findparent_scan(struct xrep_parent_scan_info *pscan);
+void xrep_findparent_scan_teardown(struct xrep_parent_scan_info *pscan);
+
+static inline void
+xrep_findparent_scan_found(
+	struct xrep_parent_scan_info	*pscan,
+	xfs_ino_t			ino)
+{
+	mutex_lock(&pscan->lock);
+	pscan->parent_ino = ino;
+	mutex_unlock(&pscan->lock);
+}
+
+void xrep_findparent_scan_finish_early(struct xrep_parent_scan_info *pscan,
+		xfs_ino_t ino);
+
+int xrep_findparent_confirm(struct xfs_scrub *sc, xfs_ino_t *parent_ino);
+
+xfs_ino_t xrep_findparent_self_reference(struct xfs_scrub *sc);
+
+#endif /* __XFS_SCRUB_FINDPARENT_H__ */
diff --git a/fs/xfs/scrub/iscan.c b/fs/xfs/scrub/iscan.c
index ec3478bc505ef..71a04f3bd91c1 100644
--- a/fs/xfs/scrub/iscan.c
+++ b/fs/xfs/scrub/iscan.c
@@ -243,6 +243,17 @@ xchk_iscan_finish(
 	mutex_unlock(&iscan->lock);
 }
 
+/* Mark an inode scan finished before we actually scan anything. */
+void
+xchk_iscan_finish_early(
+	struct xchk_iscan	*iscan)
+{
+	ASSERT(iscan->cursor_ino == iscan->scan_start_ino);
+	ASSERT(iscan->__visited_ino == iscan->scan_start_ino);
+
+	xchk_iscan_finish(iscan);
+}
+
 /*
  * Advance ino to the next inode that the inobt thinks is allocated, being
  * careful to jump to the next AG if we've reached the right end of this AG's
@@ -402,8 +413,13 @@ xchk_iscan_iget(
 		 * It's possible that this inode has lost all of its links but
 		 * hasn't yet been inactivated.  If we don't have a transaction
 		 * or it's not writable, flush the inodegc workers and wait.
+		 * If we have a non-empty transaction, we must not block on
+		 * inodegc, which allocates its own transactions.
 		 */
-		xfs_inodegc_flush(mp);
+		if (sc->tp && !(sc->tp->t_flags & XFS_TRANS_NO_WRITECOUNT))
+			xfs_inodegc_push(mp);
+		else
+			xfs_inodegc_flush(mp);
 		return xchk_iscan_iget_retry(iscan, true);
 	}
 
diff --git a/fs/xfs/scrub/iscan.h b/fs/xfs/scrub/iscan.h
index 71f657552dfac..4c442fce2d8f5 100644
--- a/fs/xfs/scrub/iscan.h
+++ b/fs/xfs/scrub/iscan.h
@@ -73,6 +73,7 @@ xchk_iscan_abort(struct xchk_iscan *iscan)
 
 void xchk_iscan_start(struct xfs_scrub *sc, unsigned int iget_timeout,
 		unsigned int iget_retry_delay, struct xchk_iscan *iscan);
+void xchk_iscan_finish_early(struct xchk_iscan *iscan);
 void xchk_iscan_teardown(struct xchk_iscan *iscan);
 
 int xchk_iscan_iter(struct xchk_iscan *iscan, struct xfs_inode **ipp);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index db0caef0748ab..8a254180de4f9 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2605,6 +2605,7 @@ DEFINE_EVENT(xrep_parent_salvage_class, name, \
 	TP_PROTO(struct xfs_inode *dp, xfs_ino_t ino), \
 	TP_ARGS(dp, ino))
 DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_dir_salvaged_parent);
+DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_findparent_dirent);
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 

