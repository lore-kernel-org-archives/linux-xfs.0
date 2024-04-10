Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94918621
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 01:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712711068; cv=none; b=Ag9nHvxE6NTIU9dNqpdSu63pbXFME4uF899RUprtWTjz28gNanzrk8gN87a3H01S6iB8+ASeS2BingEGpKiz7pgYcjEiDw1+RILS4EpBeLp90pVHVCyAN80Uw/9L8t/C9FLtzj4UlG30pYdrUDrW9L2KBx0c5DQRhkh521yO+9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712711068; c=relaxed/simple;
	bh=ps/A9aHet6AzObqWr3J43LQYWiDi/3LhsfxDziEVRfo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cT32IOWkum6bbCwqVOUdw9NuZXX6r6X+1hpu+ErIMuJ0xIjlpmEzqlwV7N1pJ5kLvFqJi9ZVEj65oa4NSSmK+P80lAv5lHHummvv04r1ZtafhIWCfhnqYVOlJcF1wd1wBydf6KUNKA5H9mWOKCnSShz9l66YycGbxru7sYJPYK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pNPawsvn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pNPawsvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A23BC433F1;
	Wed, 10 Apr 2024 01:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712711068;
	bh=ps/A9aHet6AzObqWr3J43LQYWiDi/3LhsfxDziEVRfo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=pNPawsvnFfKet+TkAKti442MvdL0g4f8hsFS2RXFf21rUrphszQC3VClFzmhSI1//
	 sz2MMX7fBmdf2wUyNd+n80SVX8M8YRVJhNCTHo4BqoI4dsSj6/8ggM/649yQXJQY+h
	 AoOe5x4rPR8YY6vWI9T/3Qg4Ve3irW0ZavBl7LQ2/uAbvAW9DQBSNu6E5p1sxU2pZE
	 4IGn2MgEOsk28Fs6b1E5wQB911HxJbzWdlfCCEpUnqlK3OwS8yIzU7C1F834DJ7eaw
	 lRuRsduYm/6iqCuqED/qzZRQkTUOu9mYKKAaRM4VCYxr3xqFLYxe60D3U/ODx3PXkE
	 SYKrF7LuyjNLg==
Date: Tue, 09 Apr 2024 18:04:27 -0700
Subject: [PATCH 03/14] xfs: repair directories by scanning directory parent
 pointers
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: catherine.hoang@oracle.com, hch@lst.de, allison.henderson@oracle.com,
 linux-xfs@vger.kernel.org
Message-ID: <171270971037.3632937.13617384622023653070.stgit@frogsfrogsfrogs>
In-Reply-To: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
References: <171270970952.3632937.3716036526502072405.stgit@frogsfrogsfrogs>
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
 fs/xfs/scrub/dir_repair.c |  344 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 338 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 575397aef1f7a..d7b84d69510a4 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -28,6 +28,7 @@
 #include "xfs_exchmaps.h"
 #include "xfs_exchrange.h"
 #include "xfs_ag.h"
+#include "xfs_parent.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -43,6 +44,7 @@
 #include "scrub/reap.h"
 #include "scrub/findparent.h"
 #include "scrub/orphanage.h"
+#include "scrub/listxattr.h"
 
 /*
  * Directory Repair
@@ -57,6 +59,15 @@
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
@@ -112,7 +123,15 @@ struct xrep_dir {
 
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
 
@@ -763,28 +782,35 @@ xrep_dir_replay_updates(
 	int			error;
 
 	/* Add all the salvaged dirents to the temporary directory. */
+	mutex_lock(&rd->pscan.lock);
 	foreach_xfarray_idx(rd->dir_entries, array_cur) {
 		struct xrep_dirent	dirent;
 
 		error = xfarray_load(rd->dir_entries, array_cur, &dirent);
 		if (error)
-			return error;
+			goto out_unlock;
 
 		error = xfblob_loadname(rd->dir_names, dirent.name_cookie,
 				&rd->xname, dirent.namelen);
 		if (error)
-			return error;
+			goto out_unlock;
 		rd->xname.type = dirent.ftype;
+		mutex_unlock(&rd->pscan.lock);
 
 		error = xrep_dir_replay_update(rd, &rd->xname, &dirent);
 		if (error)
 			return error;
+		mutex_lock(&rd->pscan.lock);
 	}
 
 	/* Empty out both arrays now that we've added the entries. */
 	xfarray_truncate(rd->dir_entries);
 	xfblob_truncate(rd->dir_names);
+	mutex_unlock(&rd->pscan.lock);
 	return 0;
+out_unlock:
+	mutex_unlock(&rd->pscan.lock);
+	return error;
 }
 
 /*
@@ -995,6 +1021,266 @@ xrep_dir_salvage_entries(
 }
 
 
+/*
+ * Examine a parent pointer of a file.  If it leads us back to the directory
+ * that we're rebuilding, create an incore dirent from the parent pointer and
+ * stash it.
+ */
+STATIC int
+xrep_dir_scan_pptr(
+	struct xfs_scrub		*sc,
+	struct xfs_inode		*ip,
+	unsigned int			attr_flags,
+	const unsigned char		*name,
+	unsigned int			namelen,
+	const void			*value,
+	unsigned int			valuelen,
+	void				*priv)
+{
+	struct xfs_name			xname = {
+		.name			= name,
+		.len			= namelen,
+		.type			= xfs_mode_to_ftype(VFS_I(ip)->i_mode),
+	};
+	xfs_ino_t			parent_ino;
+	uint32_t			parent_gen;
+	struct xrep_dir			*rd = priv;
+	int				ret;
+
+	/*
+	 * Ignore parent pointers that point back to a different dir, list the
+	 * wrong generation number, or are invalid.
+	 */
+	ret = xfs_parent_from_xattr(sc->mp, attr_flags, name, namelen,
+			value, valuelen, &parent_ino, &parent_gen);
+	if (ret != 1)
+		return ret;
+
+	if (parent_ino != sc->ip->i_ino ||
+	    parent_gen != VFS_I(sc->ip)->i_generation)
+		return 0;
+
+	mutex_lock(&rd->pscan.lock);
+	ret = xrep_dir_stash_createname(rd, &xname, ip->i_ino);
+	mutex_unlock(&rd->pscan.lock);
+	return ret;
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
+	error = xchk_xattr_walk(rd->sc, ip, xrep_dir_scan_pptr, rd);
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
@@ -1194,6 +1480,45 @@ xrep_dir_set_nlink(
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
@@ -1296,8 +1621,12 @@ xrep_dir_rebuild_tree(
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
 
@@ -1482,7 +1811,10 @@ xrep_directory(
 	if (error)
 		return error;
 
-	error = xrep_dir_salvage_entries(rd);
+	if (xfs_has_parent(sc->mp))
+		error = xrep_dir_scan_dirtree(rd);
+	else
+		error = xrep_dir_salvage_entries(rd);
 	if (error)
 		goto out_teardown;
 

