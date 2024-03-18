Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A030C5A780
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798731; cv=none; b=UzjBlhKfOyhtZLarLfs6y89dH5JMROVwhGKUIIAaTvPdEnvJZqPOdNhhyh4jQQYF0K4iHhRJ11YZe/wW2Sf/+THEaOVYphZPXxneEo/5u5YxTuot24LdBh907RI3bQaCRKLq+aYQ8ZMMMdYIUw9lZTYYsLAM2dlOTYfQLY84CCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798731; c=relaxed/simple;
	bh=6HBxOMSe2KmIXNZaB7KDZPiUWNRnC7UAyq5T1TxE9vg=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xbxer5zlxfL32CoHhlvdQvKKWu/ZIyCfJNxZkHFPdbY6tlgXRG23xvvi0J7/JjV5V30Bo/ujj9atyAJWiUjJIBHGYMRAC0S4lnTxLfZG5plffi199VLwIY5mDsGovMcREawHqGVEzGLZ7JEXS65zO4KTuGCSUXuAaniuKLwb/cM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rrJuXhx2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rrJuXhx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C26C433C7;
	Mon, 18 Mar 2024 21:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798730;
	bh=6HBxOMSe2KmIXNZaB7KDZPiUWNRnC7UAyq5T1TxE9vg=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=rrJuXhx2INX7osClhqRbxq6H0s483MABvpYOgsZszZTyydzOaHCwKqgtHWnd0SUjq
	 5/MaEK/kvSxxJEeQQJeO6FKq/9C7OWp2GhLzAD9G0UADSSHEwP4BxVwN2vlDmX/9sL
	 ZlqY6QTNs2m79CgzUNgmzn9zRn4k9RoTC/c6gF8kr3udNYB9xQUGv447VDnMyLjVT1
	 Dlpu7HZU6h0BSe3uA1KhtBnKv5a4MZXKz0DMNxIEWk82VYUmpgwYs0M3er/uAQxzBO
	 CrzUDZJtTsJe/hyzlkfqj4z32mJ0A1pBjNT9NhzmutrPwr7r659NO7RR+2kddHCQIa
	 ORESEHxNBNRJQ==
Date: Mon, 18 Mar 2024 14:52:10 -0700
Subject: [PATCH 16/23] xfs: repair directory parent pointers by scanning for
 dirents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802954.3808642.8033097384972656610.stgit@frogsfrogsfrogs>
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

If parent pointers are enabled on the filesystem, we can repair the
entire dataset by walking the directories of the filesystem looking for
dirents that we can turn into parent pointers.  Once we have a full
incore dataset, we'll figure out what to do with it, but that's for a
subsequent patch.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/parent_repair.c |  425 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h         |   36 ++++
 2 files changed, 458 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index a66aaafa6c717..daf34808b3bbc 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -35,6 +35,9 @@
 #include "scrub/readdir.h"
 #include "scrub/tempfile.h"
 #include "scrub/orphanage.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/xfblob.h"
 
 /*
  * Repairing The Directory Parent Pointer
@@ -50,20 +53,71 @@
  * See the section on locking issues in dir_repair.c for more information about
  * conflicts with the VFS.  The findparent code wll keep our incore parent
  * inode up to date.
+ *
+ * If parent pointers are enabled, we instead reconstruct the parent pointer
+ * information by visiting every directory entry of every directory in the
+ * system and translating the relevant dirents into parent pointers.  In this
+ * case, it is advantageous to stash all parent pointers created from dirents
+ * from a single parent file before replaying them into the temporary file.  To
+ * save memory, the live filesystem scan reuses the findparent object.  Parent
+ * pointer repair chooses either directory scanning or findparent, but not
+ * both.
+ *
+ * When salvaging completes, the remaining stashed entries are replayed to the
+ * temporary file.  All non-parent pointer extended attributes are copied to
+ * the temporary file's extended attributes.  An atomic extent swap is used to
+ * commit the new directory blocks to the directory being repaired.  This will
+ * disrupt attrmulti cursors.
  */
 
+/* A stashed parent pointer update. */
+struct xrep_pptr {
+	/* Cookie for retrieval of the pptr name. */
+	xfblob_cookie			name_cookie;
+
+	/* Parent pointer attr key. */
+	xfs_ino_t			p_ino;
+	uint32_t			p_gen;
+
+	/* Length of the pptr name. */
+	uint8_t				namelen;
+};
+
+/*
+ * Stash up to 8 pages of recovered parent pointers in pptr_recs and
+ * pptr_names before we write them to the temp file.
+ */
+#define XREP_PARENT_MAX_STASH_BYTES	(PAGE_SIZE * 8)
+
 struct xrep_parent {
 	struct xfs_scrub	*sc;
 
+	/* Fixed-size array of xrep_pptr structures. */
+	struct xfarray		*pptr_recs;
+
+	/* Blobs containing parent pointer names. */
+	struct xfblob		*pptr_names;
+
 	/*
 	 * Information used to scan the filesystem to find the inumber of the
-	 * dotdot entry for this directory.
+	 * dotdot entry for this directory.  On filesystems without parent
+	 * pointers, we use the findparent_* functions on this object and
+	 * access only the parent_ino field directly.
+	 *
+	 * When parent pointers are enabled, the directory entry scanner uses
+	 * the iscan, hooks, and lock fields of this object directly.
+	 * @pscan.lock coordinates access to pptr_recs, pptr_names, pptr, and
+	 * pptr_scratch.  This reduces the memory requirements of this
+	 * structure.
 	 */
 	struct xrep_parent_scan_info pscan;
 
 	/* Orphanage reparenting request. */
 	struct xrep_adoption	adoption;
 
+	/* xattr key and da args for parent pointer replay. */
+	struct xfs_parent_scratch pptr_scratch;
+
 	/*
 	 * Scratch buffer for scanning dirents to create pptr xattrs.  At the
 	 * very end of the repair, it can also be used to compute the
@@ -78,6 +132,12 @@ xrep_parent_teardown(
 	struct xrep_parent	*rp)
 {
 	xrep_findparent_scan_teardown(&rp->pscan);
+	if (rp->pptr_names)
+		xfblob_destroy(rp->pptr_names);
+	rp->pptr_names = NULL;
+	if (rp->pptr_recs)
+		xfarray_destroy(rp->pptr_recs);
+	rp->pptr_recs = NULL;
 }
 
 /* Set up for a parent repair. */
@@ -86,6 +146,7 @@ xrep_setup_parent(
 	struct xfs_scrub	*sc)
 {
 	struct xrep_parent	*rp;
+	int			error;
 
 	xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
 
@@ -95,6 +156,10 @@ xrep_setup_parent(
 	rp->sc = sc;
 	sc->buf = rp;
 
+	error = xrep_tempfile_create(sc, S_IFREG);
+	if (error)
+		return error;
+
 	return xrep_orphanage_try_create(sc);
 }
 
@@ -150,6 +215,318 @@ xrep_parent_find_dotdot(
 	return error;
 }
 
+/*
+ * Add this stashed incore parent pointer to the temporary file.
+ * The caller must hold the tempdir's IOLOCK, must not hold any ILOCKs, and
+ * must not be in transaction context.
+ */
+STATIC int
+xrep_parent_replay_update(
+	struct xrep_parent	*rp,
+	const struct xrep_pptr	*pptr)
+{
+	struct xfs_scrub	*sc = rp->sc;
+	int			error;
+
+	rp->pptr.p_ino = pptr->p_ino;
+	rp->pptr.p_gen = pptr->p_gen;
+	rp->pptr.p_namelen = pptr->namelen;
+	xfs_parent_irec_hashname(sc->mp, &rp->pptr);
+
+	/* Create parent pointer. */
+	trace_xrep_parent_replay_parentadd(sc->tempip, &rp->pptr);
+
+	error = xfs_parent_set(sc->tempip, sc->ip->i_ino, &rp->pptr,
+			&rp->pptr_scratch);
+	if (error)
+		return error;
+
+	return 0;
+}
+
+/*
+ * Flush stashed parent pointer updates that have been recorded by the scanner.
+ * This is done to reduce the memory requirements of the parent pointer
+ * rebuild, since files can have a lot of hardlinks and the fs can be busy.
+ *
+ * Caller must not hold transactions or ILOCKs.  Caller must hold the tempfile
+ * IOLOCK.
+ */
+STATIC int
+xrep_parent_replay_updates(
+	struct xrep_parent	*rp)
+{
+	xfarray_idx_t		array_cur;
+	int			error;
+
+	mutex_lock(&rp->pscan.lock);
+	foreach_xfarray_idx(rp->pptr_recs, array_cur) {
+		struct xrep_pptr	pptr;
+
+		error = xfarray_load(rp->pptr_recs, array_cur, &pptr);
+		if (error)
+			goto out_unlock;
+
+		error = xfblob_load(rp->pptr_names, pptr.name_cookie,
+				rp->pptr.p_name, pptr.namelen);
+		if (error)
+			goto out_unlock;
+		rp->pptr.p_name[MAXNAMELEN - 1] = 0;
+		mutex_unlock(&rp->pscan.lock);
+
+		error = xrep_parent_replay_update(rp, &pptr);
+		if (error)
+			return error;
+
+		mutex_lock(&rp->pscan.lock);
+	}
+
+	/* Empty out both arrays now that we've added the entries. */
+	xfarray_truncate(rp->pptr_recs);
+	xfblob_truncate(rp->pptr_names);
+	mutex_unlock(&rp->pscan.lock);
+	return 0;
+out_unlock:
+	mutex_unlock(&rp->pscan.lock);
+	return error;
+}
+
+/*
+ * Remember that we want to create a parent pointer in the tempfile.  These
+ * stashed actions will be replayed later.
+ */
+STATIC int
+xrep_parent_stash_parentadd(
+	struct xrep_parent	*rp,
+	const struct xfs_name	*name,
+	const struct xfs_inode	*dp)
+{
+	struct xrep_pptr	pptr = {
+		.namelen	= name->len,
+		.p_ino		= dp->i_ino,
+		.p_gen		= VFS_IC(dp)->i_generation,
+	};
+	int			error;
+
+	trace_xrep_parent_stash_parentadd(rp->sc->tempip, dp, name);
+
+	error = xfblob_store(rp->pptr_names, &pptr.name_cookie, name->name,
+			name->len);
+	if (error)
+		return error;
+
+	return xfarray_append(rp->pptr_recs, &pptr);
+}
+
+/*
+ * Examine an entry of a directory.  If this dirent leads us back to the file
+ * whose parent pointers we're rebuilding, add a pptr to the temporary
+ * directory.
+ */
+STATIC int
+xrep_parent_scan_dirent(
+	struct xfs_scrub	*sc,
+	struct xfs_inode	*dp,
+	xfs_dir2_dataptr_t	dapos,
+	const struct xfs_name	*name,
+	xfs_ino_t		ino,
+	void			*priv)
+{
+	struct xrep_parent	*rp = priv;
+	int			error;
+
+	/* Dirent doesn't point to this directory. */
+	if (ino != rp->sc->ip->i_ino)
+		return 0;
+
+	/* No weird looking names. */
+	if (name->len == 0 || !xfs_dir2_namecheck(name->name, name->len))
+		return -EFSCORRUPTED;
+
+	/* No mismatching ftypes. */
+	if (name->type != xfs_mode_to_ftype(VFS_I(sc->ip)->i_mode))
+		return -EFSCORRUPTED;
+
+	/* Don't pick up dot or dotdot entries; we only want child dirents. */
+	if (xfs_dir2_samename(name, &xfs_name_dotdot) ||
+	    xfs_dir2_samename(name, &xfs_name_dot))
+		return 0;
+
+	/*
+	 * Transform this dirent into a parent pointer and queue it for later
+	 * addition to the temporary file.
+	 */
+	mutex_lock(&rp->pscan.lock);
+	error = xrep_parent_stash_parentadd(rp, name, dp);
+	mutex_unlock(&rp->pscan.lock);
+	return error;
+}
+
+/*
+ * Decide if we want to look for dirents in this directory.  Skip the file
+ * being repaired and any files being used to stage repairs.
+ */
+static inline bool
+xrep_parent_want_scan(
+	struct xrep_parent	*rp,
+	const struct xfs_inode	*ip)
+{
+	return ip != rp->sc->ip && !xrep_is_tempfile(ip);
+}
+
+/*
+ * Take ILOCK on a file that we want to scan.
+ *
+ * Select ILOCK_EXCL if the file is a directory with an unloaded data bmbt.
+ * Otherwise, take ILOCK_SHARED.
+ */
+static inline unsigned int
+xrep_parent_scan_ilock(
+	struct xrep_parent	*rp,
+	struct xfs_inode	*ip)
+{
+	uint			lock_mode = XFS_ILOCK_SHARED;
+
+	/* Still need to take the shared ILOCK to advance the iscan cursor. */
+	if (!xrep_parent_want_scan(rp, ip))
+		goto lock;
+
+	if (S_ISDIR(VFS_I(ip)->i_mode) && xfs_need_iread_extents(&ip->i_df)) {
+		lock_mode = XFS_ILOCK_EXCL;
+		goto lock;
+	}
+
+lock:
+	xfs_ilock(ip, lock_mode);
+	return lock_mode;
+}
+
+/*
+ * Scan this file for relevant child dirents that point to the file whose
+ * parent pointers we're rebuilding.
+ */
+STATIC int
+xrep_parent_scan_file(
+	struct xrep_parent	*rp,
+	struct xfs_inode	*ip)
+{
+	unsigned int		lock_mode;
+	int			error = 0;
+
+	lock_mode = xrep_parent_scan_ilock(rp, ip);
+
+	if (!xrep_parent_want_scan(rp, ip))
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
+		error = xchk_dir_walk(rp->sc, ip, xrep_parent_scan_dirent, rp);
+		if (error)
+			goto scan_done;
+	}
+
+scan_done:
+	xchk_iscan_mark_visited(&rp->pscan.iscan, ip);
+	xfs_iunlock(ip, lock_mode);
+	return error;
+}
+
+/* Decide if we've stashed too much pptr data in memory. */
+static inline bool
+xrep_parent_want_flush_stashed(
+	struct xrep_parent	*rp)
+{
+	unsigned long long	bytes;
+
+	bytes = xfarray_bytes(rp->pptr_recs) + xfblob_bytes(rp->pptr_names);
+	return bytes > XREP_PARENT_MAX_STASH_BYTES;
+}
+
+/*
+ * Scan all directories in the filesystem to look for dirents that we can turn
+ * into parent pointers.
+ */
+STATIC int
+xrep_parent_scan_dirtree(
+	struct xrep_parent	*rp)
+{
+	struct xfs_scrub	*sc = rp->sc;
+	struct xfs_inode	*ip;
+	int			error;
+
+	/*
+	 * Filesystem scans are time consuming.  Drop the file ILOCK and all
+	 * other resources for the duration of the scan and hope for the best.
+	 * The live update hooks will keep our scan information up to date.
+	 */
+	xchk_trans_cancel(sc);
+	if (sc->ilock_flags & (XFS_ILOCK_SHARED | XFS_ILOCK_EXCL))
+		xchk_iunlock(sc, sc->ilock_flags & (XFS_ILOCK_SHARED |
+						    XFS_ILOCK_EXCL));
+	error = xchk_trans_alloc_empty(sc);
+	if (error)
+		return error;
+
+	while ((error = xchk_iscan_iter(&rp->pscan.iscan, &ip)) == 1) {
+		bool		flush;
+
+		error = xrep_parent_scan_file(rp, ip);
+		xchk_irele(sc, ip);
+		if (error)
+			break;
+
+		/* Flush stashed pptr updates to constrain memory usage. */
+		mutex_lock(&rp->pscan.lock);
+		flush = xrep_parent_want_flush_stashed(rp);
+		mutex_unlock(&rp->pscan.lock);
+		if (flush) {
+			xchk_trans_cancel(sc);
+
+			error = xrep_tempfile_iolock_polled(sc);
+			if (error)
+				break;
+
+			error = xrep_parent_replay_updates(rp);
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
+	xchk_iscan_iter_finish(&rp->pscan.iscan);
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
+	xchk_trans_cancel(rp->sc);
+	return 0;
+}
+
 /* Reset a directory's dotdot entry, if needed. */
 STATIC int
 xrep_parent_reset_dotdot(
@@ -301,8 +678,39 @@ xrep_parent_setup_scan(
 	struct xrep_parent	*rp)
 {
 	struct xfs_scrub	*sc = rp->sc;
+	char			*descr;
+	int			error;
 
-	return xrep_findparent_scan_start(sc, &rp->pscan);
+	if (!xfs_has_parent(sc->mp))
+		return xrep_findparent_scan_start(sc, &rp->pscan);
+
+	/* Set up some staging memory for logging parent pointer updates. */
+	descr = xchk_xfile_ino_descr(sc, "parent pointer entries");
+	error = xfarray_create(descr, 0, sizeof(struct xrep_pptr),
+			&rp->pptr_recs);
+	kfree(descr);
+	if (error)
+		return error;
+
+	descr = xchk_xfile_ino_descr(sc, "parent pointer names");
+	error = xfblob_create(descr, &rp->pptr_names);
+	kfree(descr);
+	if (error)
+		goto out_recs;
+
+	error = xrep_findparent_scan_start(sc, &rp->pscan);
+	if (error)
+		goto out_names;
+
+	return 0;
+
+out_names:
+	xfblob_destroy(rp->pptr_names);
+	rp->pptr_names = NULL;
+out_recs:
+	xfarray_destroy(rp->pptr_recs);
+	rp->pptr_recs = NULL;
+	return error;
 }
 
 int
@@ -312,11 +720,22 @@ xrep_parent(
 	struct xrep_parent	*rp = sc->buf;
 	int			error;
 
+	/*
+	 * When the parent pointers feature is enabled, repairs are committed
+	 * by atomically committing a new xattr structure and reaping the old
+	 * attr fork.  Reaping requires rmap to be enabled.
+	 */
+	if (xfs_has_parent(sc->mp) && !xfs_has_rmapbt(sc->mp))
+		return -EOPNOTSUPP;
+
 	error = xrep_parent_setup_scan(rp);
 	if (error)
 		return error;
 
-	error = xrep_parent_find_dotdot(rp);
+	if (xfs_has_parent(sc->mp))
+		error = xrep_parent_scan_dirtree(rp);
+	else
+		error = xrep_parent_find_dotdot(rp);
 	if (error)
 		goto out_teardown;
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index ad3b193273b16..dc5190f4aa89b 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2813,6 +2813,42 @@ DEFINE_EVENT(xrep_pptr_class, name, \
 	TP_ARGS(ip, pptr))
 DEFINE_XREP_PPTR_EVENT(xrep_xattr_replay_parentadd);
 DEFINE_XREP_PPTR_EVENT(xrep_xattr_replay_parentremove);
+DEFINE_XREP_PPTR_EVENT(xrep_parent_replay_parentadd);
+
+DECLARE_EVENT_CLASS(xrep_pptr_scan_class,
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_inode *dp,
+		 const struct xfs_name *name),
+	TP_ARGS(ip, dp, name),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_ino_t, parent_ino)
+		__field(unsigned int, parent_gen)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, name->len)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->parent_ino = dp->i_ino;
+		__entry->parent_gen = VFS_IC(dp)->i_generation;
+		__entry->namelen = name->len;
+		memcpy(__get_str(name), name->name, name->len);
+	),
+	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->parent_ino,
+		  __entry->parent_gen,
+		  __entry->namelen,
+		  __get_str(name))
+)
+#define DEFINE_XREP_PPTR_SCAN_EVENT(name) \
+DEFINE_EVENT(xrep_pptr_scan_class, name, \
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_inode *dp, \
+		 const struct xfs_name *name), \
+	TP_ARGS(ip, dp, name))
+DEFINE_XREP_PPTR_SCAN_EVENT(xrep_parent_stash_parentadd);
 
 TRACE_EVENT(xrep_nlinks_set_record,
 	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino,

