Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB67FBA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 20:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J+QOAbcR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410F6C433C7;
	Sun, 31 Dec 2023 20:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056164;
	bh=NpcDrm8AHsyt+wGTzzxf3TveO6DvfZSjuPyVO6fz8NA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=J+QOAbcRmJ8khZMxn06uN0UMJRZSn+dXyIdstwUTtyur6w3c8DgCGMErS/+7Mbq05
	 bN4xha8rTKrsorm+U+Bo6Xc/QUV6S42C6XO/auEva70wth9yJKTs2Un+5S4xrxC8kd
	 JIkNGVbtpW5v905qWkDQLtygirLq5tmu4L63fFqCFaA1ergd6pLXbIo6IMGmH0xgER
	 JkrCLmw+O3vmp5ibk9t0EwxRJxnTUH6dgGru2qAk2TK2hO47hNtdGNLCZKQLdb1a/+
	 U8TJohGpM0o2ux4ptOx5w9e6a3XT+Z99uGdIzH3H0/YFI0+Ha+dUUUnluz/ibPqy6a
	 LmmtgxIbAKvfg==
Date: Sun, 31 Dec 2023 12:56:03 -0800
Subject: [PATCH 11/22] xfs: repair directories by scanning directory parent
 pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <170404841924.1757392.7346522989217789457.stgit@frogsfrogsfrogs>
In-Reply-To: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
References: <170404841699.1757392.2057683072581072853.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/dir_repair.c |  327 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 323 insertions(+), 4 deletions(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 13a1a3ef5e714..cae22ad33bca3 100644
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
  * entries are replayed to the temporary directory.  An atomic extent swap is
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
 
@@ -1003,6 +1021,261 @@ xrep_dir_salvage_entries(
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
+	 * extent swap helpers to lock files and commit the new directory.
+	 */
+	xchk_trans_cancel(rd->sc);
+	return 0;
+}
+
 /*
  * Free all the directory blocks and reset the data fork.  The caller must
  * join the inode to the transaction.  This function returns with the inode
@@ -1201,6 +1474,45 @@ xrep_dir_set_nlink(
 	return 0;
 }
 
+/*
+ * Finish replaying stashed dirent updates, allocate a transaction for swapping
+ * extents, and take the ILOCKs of both directories before we commit the new
+ * directory structure.
+ */
+STATIC int
+xrep_dir_finalize_tempdir(
+	struct xrep_dir		*rd)
+{
+	struct xfs_scrub	*sc = rd->sc;
+	int			error;
+
+	if (!xfs_has_parent(sc->mp))
+		return xrep_tempswap_trans_alloc(sc, XFS_DATA_FORK, &rd->tx);
+
+	/*
+	 * Repair relies on the ILOCK to quiesce all possible dirent updates.
+	 * Replay all queued dirent updates into the tempdir before swapping
+	 * the contents, even if that means dropping the ILOCKs and the
+	 * transaction.
+	 */
+	do {
+		error = xrep_dir_replay_updates(rd);
+		if (error)
+			return error;
+
+		error = xrep_tempswap_trans_alloc(sc, XFS_DATA_FORK, &rd->tx);
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
 /* Swap the temporary directory's data fork with the one being repaired. */
 STATIC int
 xrep_dir_swap(
@@ -1300,8 +1612,12 @@ xrep_dir_rebuild_tree(
 	if (error)
 		return error;
 
-	/* Allocate transaction and ILOCK the scrub file and the temp file. */
-	error = xrep_tempswap_trans_alloc(sc, XFS_DATA_FORK, &rd->tx);
+	/*
+	 * Allocate transaction, lock inodes, and make sure that we've replayed
+	 * all the stashed dirent updates to the tempdir.  After this point,
+	 * we're ready to swapext.
+	 */
+	error = xrep_dir_finalize_tempdir(rd);
 	if (error)
 		return error;
 
@@ -1486,7 +1802,10 @@ xrep_directory(
 	if (error)
 		return error;
 
-	error = xrep_dir_salvage_entries(rd);
+	if (xfs_has_parent(sc->mp))
+		error = xrep_dir_scan_dirtree(rd);
+	else
+		error = xrep_dir_salvage_entries(rd);
 	if (error)
 		goto out_teardown;
 

