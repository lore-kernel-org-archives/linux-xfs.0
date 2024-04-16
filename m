Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA544C98
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 01:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713231498; cv=none; b=NOrbDjVUa5VM69b6yVrykTBeukZyrNQYIUKeT03slh28xxcrBNuNmDAfoV2H1dTNMF4JDVkjClv/zwMwKDm1EdOwNUEhMNVVoir0w86HylVeE3PLv1wbuvtjQxeM6/QUgWCGsQgcrLV5f/sEJe+EhfenC5skmrYePbj94WUaPl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713231498; c=relaxed/simple;
	bh=6O7Ggf7JzqHZg7Q0ffJ/qrOXmfSvGaBoZbUNMz6M+MQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r3padXhDArBxYfS5x96ZGROcGvQ0nHIF2Z5DnkvBSlTzOkV02OdvP8p8MlSEUVrzsDZdg8J7yi3FVqXumwBUj7dTgtWM3qEUGqF40Z4/jA96CPouCw/2aUecWKMi75m/bQ0ylORAVyMRF+mSiLVy7FJzOolATFwDzbfzEYHczaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RRAnJNDt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RRAnJNDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC7C7C113CC;
	Tue, 16 Apr 2024 01:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713231497;
	bh=6O7Ggf7JzqHZg7Q0ffJ/qrOXmfSvGaBoZbUNMz6M+MQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RRAnJNDtUoBP74MvFRRIlEnfo563MFQ5I/KNK9KySPiBOTxtbp2QazoLZpWYtCVdj
	 7nWgfSoLIZtPPUGsAnijd8e+k+2ToLDocKNnuVOmLCGMkuQtSUKvxeoDx92NtdV6op
	 +O4Cd6nyEXuXMzTotVukBnRVbzyB6ZJTvd9flMV5pfw6mTViSWqokaxp0rPVDakv8x
	 1yqVV1/+1trQ6seCh1FinbXj1gZM8oBcHqDSROG2MOo2IgnPHy5xd0f+mKMfTsy81w
	 +ZYbis9nG+UMdJiBYnYj6HpvaVhBMmLbP8c9MxFIvVBL9LtZ7vqwOyeVe1TXACdpwx
	 KvAyd+smrWM9Q==
Date: Mon, 15 Apr 2024 18:38:17 -0700
Subject: [PATCH 09/17] xfs: repair directory parent pointers by scanning for
 dirents
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, allison.henderson@oracle.com,
 hch@infradead.org, linux-xfs@vger.kernel.org, catherine.hoang@oracle.com,
 hch@lst.de
Message-ID: <171323029330.253068.15711120554583959440.stgit@frogsfrogsfrogs>
In-Reply-To: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/parent_repair.c |  414 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h         |   36 ++++
 2 files changed, 447 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 63590e1b35060..b4084a9f0e9c8 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -24,6 +24,7 @@
 #include "xfs_trans_space.h"
 #include "xfs_health.h"
 #include "xfs_exchmaps.h"
+#include "xfs_parent.h"
 #include "scrub/xfs_scrub.h"
 #include "scrub/scrub.h"
 #include "scrub/common.h"
@@ -34,6 +35,9 @@
 #include "scrub/readdir.h"
 #include "scrub/tempfile.h"
 #include "scrub/orphanage.h"
+#include "scrub/xfile.h"
+#include "scrub/xfarray.h"
+#include "scrub/xfblob.h"
 
 /*
  * Repairing The Directory Parent Pointer
@@ -49,14 +53,61 @@
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
+	xfblob_cookie		name_cookie;
+
+	/* Parent pointer record. */
+	struct xfs_parent_rec	pptr_rec;
+
+	/* Length of the pptr name. */
+	uint8_t			namelen;
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
 
@@ -66,6 +117,9 @@ struct xrep_parent {
 	/* Directory entry name, plus the trailing null. */
 	struct xfs_name		xname;
 	unsigned char		namebuf[MAXNAMELEN];
+
+	/* Scratch buffer for scanning pptr xattrs */
+	struct xfs_da_args	pptr_args;
 };
 
 /* Tear down all the incore stuff we created. */
@@ -74,6 +128,12 @@ xrep_parent_teardown(
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
@@ -82,6 +142,7 @@ xrep_setup_parent(
 	struct xfs_scrub	*sc)
 {
 	struct xrep_parent	*rp;
+	int			error;
 
 	xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
 
@@ -92,6 +153,10 @@ xrep_setup_parent(
 	rp->xname.name = rp->namebuf;
 	sc->buf = rp;
 
+	error = xrep_tempfile_create(sc, S_IFREG);
+	if (error)
+		return error;
+
 	return xrep_orphanage_try_create(sc);
 }
 
@@ -147,6 +212,307 @@ xrep_parent_find_dotdot(
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
+	const struct xfs_name	*xname,
+	struct xrep_pptr	*pptr)
+{
+	struct xfs_scrub	*sc = rp->sc;
+
+	/* Create parent pointer. */
+	trace_xrep_parent_replay_parentadd(sc->tempip, xname, &pptr->pptr_rec);
+
+	return xfs_parent_set(sc->tempip, sc->ip->i_ino, xname,
+			&pptr->pptr_rec, &rp->pptr_args);
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
+		error = xfblob_loadname(rp->pptr_names, pptr.name_cookie,
+				&rp->xname, pptr.namelen);
+		if (error)
+			goto out_unlock;
+		rp->xname.len = pptr.namelen;
+		mutex_unlock(&rp->pscan.lock);
+
+		error = xrep_parent_replay_update(rp, &rp->xname, &pptr);
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
+	};
+	int			error;
+
+	trace_xrep_parent_stash_parentadd(rp->sc->tempip, dp, name);
+
+	xfs_inode_to_parent_rec(&pptr.pptr_rec, dp);
+	error = xfblob_storename(rp->pptr_names, &pptr.name_cookie, name);
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
@@ -298,8 +664,39 @@ xrep_parent_setup_scan(
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
@@ -309,11 +706,22 @@ xrep_parent(
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
index 68532f686eeb1..10c2a8d10058b 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2820,6 +2820,42 @@ DEFINE_EVENT(xrep_pptr_class, name, \
 	TP_ARGS(ip, name, pptr))
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

