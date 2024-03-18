Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4A959B4F
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798668; cv=none; b=UJ157OFRxxL5dZTkQgmt/vfsndNMIlm/+t60WqYo7Xm2UQARl5GDsiw+oEqStNRFvCLlECegZUMwLm3nAAbAyUNoiFtrnwS/YwTkwWqPsMdXvoFNNqh5jkU30+tOOxGhW+EtY9p+RhGLSUwuEDSDY7hwaoHcQDtQ8TIjbic2AXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798668; c=relaxed/simple;
	bh=KHznJH7cAb7Eq7s7V+w0LkwSqEBrnrTDQ44CdABlttM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bwp1akfSDLdCwNFyAgNHhZI4cpN2LW6MGEfE7YHmlSnlSOQoORxjMdfsd+qMcReqCOC4y7tt/gg6uFVKLShAey7gkjSE6z0Orb6rPaVWvkNS6FbnzkICjVyWeIBEDIrEr7mnXyggJ2syKEJbhuUI/PVo0HgFf3LH/4VmkTAY8jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QpHEaNQa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QpHEaNQa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CBAC43390;
	Mon, 18 Mar 2024 21:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798668;
	bh=KHznJH7cAb7Eq7s7V+w0LkwSqEBrnrTDQ44CdABlttM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QpHEaNQaVAdd1qq/Piwag65+Y7PgXT0+r2uyYdbzkw+yDfZ0PecayEPqFTEqyMo6M
	 WWY4iuE9vKc/dvUUaxVWEl2OH5YqaPUGBHwTl+mKzmpvjRkF1kSgQu2nDmlBVYTBoH
	 0VsZoFN651gDrb/UnMt7pYAzt0EF8K26edpYb+g4HGePc2ePBqCTOT81BaLa2lKSKh
	 l+a9JzKYTuu4BBo0PHypzKMTKNveQAFE1dVAEnSUvdZVg+87I/jkO0UHi6zcMJjd3c
	 hEBQmSoZSgoHqb513Qb7Sdszbd8Sg7TkJ5gbmDm6B3Am2mN/sKg3ReedLyYKpGKmIv
	 F9HKh8x+97Ydw==
Date: Mon, 18 Mar 2024 14:51:07 -0700
Subject: [PATCH 12/23] xfs: repair directories by scanning directory parent
 pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802889.3808642.10320183473647313977.stgit@frogsfrogsfrogs>
In-Reply-To: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
References: <171079802637.3808642.13167687091088855153.stgit@frogsfrogsfrogs>
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

For filesystems with parent pointers, scan the entire filesystem looking
for parent pointers that target the directory we're rebuilding instead
of trying to salvage whatever we can from the directory data blocks.
This will be more robust than salvaging, but there's more code to come.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir_repair.c |  328 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 324 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index e89703d1123cd..caa92a7c4563b 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -44,6 +44,7 @@
 #include "scrub/reap.h"
 #include "scrub/findparent.h"
 #include "scrub/orphanage.h"
+#include "scrub/listxattr.h"
 
 /*
  * Directory Repair
@@ -58,6 +59,15 @@
  * being repaired and the temporary directory, and will later become important
  * for parent pointer scanning.
  *
+ * If parent pointers are enabled on this filesystem, we instead reconstruct
+ * the directory by visiting each parent pointer of each file in the filesystem
+ * and translating the relevant parent pointer records into dirents.  In this
+ * case, it is advantageous to stash all directory entries created from parent
+ * pointers for a single child file before replaying them into the temporary
+ * directory.  To save memory, the live filesystem scan reuses the findparent
+ * fields.  Directory repair chooses either parent pointer scanning or
+ * directory entry salvaging, but not both.
+ *
  * Directory entries added to the temporary directory do not elevate the link
  * counts of the inodes found.  When salvaging completes, the remaining stashed
  * entries are replayed to the temporary directory.  An atomic mapping exchange
@@ -113,7 +123,15 @@ struct xrep_dir {
 
 	/*
 	 * Information used to scan the filesystem to find the inumber of the
-	 * dotdot entry for this directory.
+	 * dotdot entry for this directory.  For directory salvaging when
+	 * parent pointers are not enabled, we use the findparent_* functions
+	 * on this object and access only the parent_ino field directly.
+	 *
+	 * When parent pointers are enabled, however, the pptr scanner uses the
+	 * iscan, hooks, lock, and parent_ino fields of this object directly.
+	 * @pscan.lock coordinates access to dir_entries, dir_names,
+	 * parent_ino, subdirs, dirents, and args.  This reduces the memory
+	 * requirements of this structure.
 	 */
 	struct xrep_parent_scan_info pscan;
 
@@ -1004,6 +1022,262 @@ xrep_dir_salvage_entries(
 }
 
 
+/*
+ * Examine a parent pointer of a file.  If it leads us back to the directory
+ * that we're rebuilding, create an incore dirent from the parent pointer and
+ * stash it.
+ */
+STATIC int
+xrep_dir_scan_pptr(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*ip,
+	const struct xfs_parent_name_irec *pptr,
+	void			*priv)
+{
+	struct xfs_name		xname;
+	struct xrep_dir		*rd = priv;
+	int			error;
+
+	/*
+	 * Ignore parent pointers that point back to a different dir, list the
+	 * wrong generation number, or are invalid.
+	 */
+	if (pptr->p_ino != sc->ip->i_ino ||
+	    pptr->p_gen != VFS_I(sc->ip)->i_generation ||
+	    !xfs_parent_verify_irec(sc->mp, pptr))
+		return 0;
+
+	/*
+	 * Transform this parent pointer into a dirent and queue it for later
+	 * addition to the temporary directory.
+	 */
+	xname.name = pptr->p_name;
+	xname.len = pptr->p_namelen;
+	xname.type = xfs_mode_to_ftype(VFS_I(ip)->i_mode);
+
+	mutex_lock(&rd->pscan.lock);
+	error = xrep_dir_stash_createname(rd, &xname, ip->i_ino);
+	mutex_unlock(&rd->pscan.lock);
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
+	if (xfs_dir2_samename(name, &xfs_name_dotdot) ||
+	    xfs_dir2_samename(name, &xfs_name_dot))
+		return 0;
+
+	trace_xrep_dir_stash_createname(sc->tempip, &xfs_name_dotdot,
+			dp->i_ino);
+
+	xrep_findparent_scan_found(&rd->pscan, dp->i_ino);
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
+	/*
+	 * If the extended attributes look as though they has been zapped by
+	 * the inode record repair code, we cannot scan for parent pointers.
+	 */
+	if (xchk_pptr_looks_zapped(ip)) {
+		error = -EBUSY;
+		goto scan_done;
+	}
+
+	error = xchk_pptr_walk(rd->sc, ip, xrep_dir_scan_pptr, &rd->pptr, rd);
+	if (error)
+		goto scan_done;
+
+	if (S_ISDIR(VFS_I(ip)->i_mode)) {
+		/*
+		 * If the directory looks as though it has been zapped by the
+		 * inode record repair code, we cannot scan for child dirents.
+		 */
+		if (xchk_dir_looks_zapped(ip)) {
+			error = -EBUSY;
+			goto scan_done;
+		}
+
+		error = xchk_dir_walk(rd->sc, ip, xrep_dir_scan_dirent, rd);
+		if (error)
+			goto scan_done;
+	}
+
+scan_done:
+	xchk_iscan_mark_visited(&rd->pscan.iscan, ip);
+	xfs_iunlock(ip, lock_mode);
+	return error;
+}
+
+/*
+ * Scan all files in the filesystem for parent pointers that we can turn into
+ * replacement dirents, and a dirent that we can use to set the dotdot pointer.
+ */
+STATIC int
+xrep_dir_scan_dirtree(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	struct xfs_inode	*ip;
+	int			error;
+
+	/* Roots of directory trees are their own parents. */
+	if (sc->ip == sc->mp->m_rootip)
+		xrep_findparent_scan_found(&rd->pscan, sc->ip->i_ino);
+
+	/*
+	 * Filesystem scans are time consuming.  Drop the directory ILOCK and
+	 * all other resources for the duration of the scan and hope for the
+	 * best.  The live update hooks will keep our scan information up to
+	 * date even though we've dropped the locks.
+	 */
+	xchk_trans_cancel(sc);
+	if (sc->ilock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL))
+		xchk_iunlock(sc, sc->ilock_flags & (XFS_ILOCK_SHARED |
+						    XFS_ILOCK_EXCL));
+	error = xchk_trans_alloc_empty(sc);
+	if (error)
+		return error;
+
+	while ((error = xchk_iscan_iter(&rd->pscan.iscan, &ip)) == 1) {
+		bool		flush;
+
+		error = xrep_dir_scan_file(rd, ip);
+		xchk_irele(sc, ip);
+		if (error)
+			break;
+
+		/* Flush stashed dirent updates to constrain memory usage. */
+		mutex_lock(&rd->pscan.lock);
+		flush = xrep_dir_want_flush_stashed(rd);
+		mutex_unlock(&rd->pscan.lock);
+		if (flush) {
+			xchk_trans_cancel(sc);
+
+			error = xrep_tempfile_iolock_polled(sc);
+			if (error)
+				break;
+
+			mutex_lock(&rd->pscan.lock);
+			error = xrep_dir_replay_updates(rd);
+			mutex_unlock(&rd->pscan.lock);
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
+	xchk_iscan_iter_finish(&rd->pscan.iscan);
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
+	/*
+	 * Cancel the empty transaction so that we can (later) use the atomic
+	 * file mapping exchange functions to lock files and commit the new
+	 * directory.
+	 */
+	xchk_trans_cancel(rd->sc);
+	return 0;
+}
+
 /*
  * Free all the directory blocks and reset the data fork.  The caller must
  * join the inode to the transaction.  This function returns with the inode
@@ -1203,6 +1477,45 @@ xrep_dir_set_nlink(
 	return 0;
 }
 
+/*
+ * Finish replaying stashed dirent updates, allocate a transaction for
+ * exchanging data fork mappings, and take the ILOCKs of both directories
+ * before we commit the new directory structure.
+ */
+STATIC int
+xrep_dir_finalize_tempdir(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	int			error;
+
+	if (!xfs_has_parent(sc->mp))
+		return xrep_tempexch_trans_alloc(sc, XFS_DATA_FORK, &rd->tx);
+
+	/*
+	 * Repair relies on the ILOCK to quiesce all possible dirent updates.
+	 * Replay all queued dirent updates into the tempdir before exchanging
+	 * the contents, even if that means dropping the ILOCKs and the
+	 * transaction.
+	 */
+	do {
+		error = xrep_dir_replay_updates(rd);
+		if (error)
+			return error;
+
+		error = xrep_tempexch_trans_alloc(sc, XFS_DATA_FORK, &rd->tx);
+		if (error)
+			return error;
+
+		if (xfarray_length(rd->dir_entries) == 0)
+			break;
+
+		xchk_trans_cancel(sc);
+		xrep_tempfile_iunlock_both(sc);
+	} while (!xchk_should_terminate(sc, &error));
+	return error;
+}
+
 /* Exchange the temporary directory's data fork with the one being repaired. */
 STATIC int
 xrep_dir_swap(
@@ -1305,8 +1618,12 @@ xrep_dir_rebuild_tree(
 	if (error)
 		return error;
 
-	/* Allocate transaction and ILOCK the scrub file and the temp file. */
-	error = xrep_tempexch_trans_alloc(sc, XFS_DATA_FORK, &rd->tx);
+	/*
+	 * Allocate transaction, lock inodes, and make sure that we've replayed
+	 * all the stashed dirent updates to the tempdir.  After this point,
+	 * we're ready to exchange data fork mappings.
+	 */
+	error = xrep_dir_finalize_tempdir(rd);
 	if (error)
 		return error;
 
@@ -1491,7 +1808,10 @@ xrep_directory(
 	if (error)
 		return error;
 
-	error = xrep_dir_salvage_entries(rd);
+	if (xfs_has_parent(sc->mp))
+		error = xrep_dir_scan_dirtree(rd);
+	else
+		error = xrep_dir_salvage_entries(rd);
 	if (error)
 		goto out_teardown;
 

