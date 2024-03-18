Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B6DB5A782
	for <linux-xfs@vger.kernel.org>; Mon, 18 Mar 2024 21:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710798699; cv=none; b=RsJQtSrqLzaB94wpNPbIGCuu04logomGaqaCU8RtokxYleHDVL+mBFWhGDgCeTlb3hrEecIKxXD7STk0ZlTWm6KkN9lz20NXF9Zw+IeqZk0q4AzhL0pVDZwbj+YbkmX9eyKWjunG+TX6g7idfJJzWMItdOAinD1zM2SQMIo4oGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710798699; c=relaxed/simple;
	bh=M/9SlBXav59QIBPOMZgyfELaQ4GiyTIUDQcn7y7g+LA=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KZMpJDrFF0EYO7TgGqyqDQH2kGKIH4+qRJFdSPjeb1CtFwVe1bi7aIEGdWfIgtrExuZZrcWXg+yrIoTrMl6iQbSWIf1TkGkTJ+HTeJlis8eRJkV2FfMygPpTXIA32Qtq1f/mnfkTo10BiM/Lad88xPnYPABFH46RUFJpxHv2iUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nu2movHI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nu2movHI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37A03C433C7;
	Mon, 18 Mar 2024 21:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710798699;
	bh=M/9SlBXav59QIBPOMZgyfELaQ4GiyTIUDQcn7y7g+LA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Nu2movHIaQOXrAa8LPH/2H9Ppow6mchD/EmouFxIF6ty82LeIhq6A7hdWWuTB46Kj
	 2l41/9fFyak2iia8S8PXje7fcGkMuPjnCLs7Y/GpsrDzxuoYcx+FzeeXBm6rzoj6Yn
	 rzUvDX9782CKNC5KGhPxG/QQ6hnrq/OxQcThN6Mp2tht+dZNPFTS9Dq5bVCP5Uoh9B
	 x3boOAWScFLWHbru/3HVnXDyWogwzodXhlE4QpEp/aVQtqKw4IhjlhS92b+RN4CyCm
	 A08KuFeLgzQ32/0Ja51xq+bW/mGkG+2WEmicVefdDvfjygD4bmIuiGbMHbRO1zSpRd
	 FG8FQK7RyJKLg==
Date: Mon, 18 Mar 2024 14:51:38 -0700
Subject: [PATCH 14/23] xfs: replay unlocked parent pointer updates that accrue
 during xattr repair
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: allison.henderson@oracle.com, catherine.hoang@oracle.com,
 linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171079802922.3808642.9684893830023871707.stgit@frogsfrogsfrogs>
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

There are a few places where the extended attribute repair code drops
the ILOCK to apply stashed xattrs to the temporary file.  Although
setxattr and removexattr are still locked out because we retain our hold
on the IOLOCK, this doesn't prevent renames from updating parent
pointers, because the VFS doesn't take i_rwsem on children that are
being moved.

Therefore, set up a dirent hook to capture parent pointer updates for
this file, and replay(?) the updates.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/attr_repair.c |  456 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h       |   71 +++++++
 2 files changed, 525 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 2661bc97e9900..18672823d75aa 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -96,6 +96,56 @@ struct xrep_xattr {
 
 	/* Number of attributes that we are salvaging. */
 	unsigned long long	attrs_found;
+
+	/* Can we flush stashed attrs to the tempfile? */
+	bool			can_flush;
+
+	/* Did the live update fail, and hence the repair is now out of date? */
+	bool			live_update_aborted;
+
+	/* Lock protecting parent pointer updates */
+	struct mutex		lock;
+
+	/* Fixed-size array of xrep_xattr_pptr structures. */
+	struct xfarray		*pptr_recs;
+
+	/* Blobs containing parent pointer names. */
+	struct xfblob		*pptr_names;
+
+	/* Hook to capture parent pointer updates. */
+	struct xfs_dir_hook	dhook;
+
+	/* xattr key and da args for parent pointer replay. */
+	struct xfs_parent_scratch pptr_scratch;
+
+	/*
+	 * Scratch buffer for scanning dirents to create pptr xattrs.  At the
+	 * very end of the repair, it can also be used to compute the
+	 * lost+found filename if we need to reparent the file.
+	 */
+	struct xfs_parent_name_irec pptr;
+};
+
+/* Create a parent pointer in the tempfile. */
+#define XREP_XATTR_PPTR_ADD	(1)
+
+/* Remove a parent pointer from the tempfile. */
+#define XREP_XATTR_PPTR_REMOVE	(2)
+
+/* A stashed parent pointer update. */
+struct xrep_xattr_pptr {
+	/* Cookie for retrieval of the pptr name. */
+	xfblob_cookie		name_cookie;
+
+	/* Parent pointer attr key. */
+	xfs_ino_t		p_ino;
+	uint32_t		p_gen;
+
+	/* Length of the pptr name. */
+	uint8_t			namelen;
+
+	/* XREP_XATTR_PPTR_{ADD,REMOVE} */
+	uint8_t			action;
 };
 
 /* Set up to recreate the extended attributes. */
@@ -103,6 +153,9 @@ int
 xrep_setup_xattr(
 	struct xfs_scrub	*sc)
 {
+	if (xfs_has_parent(sc->mp))
+		xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
+
 	return xrep_tempfile_create(sc, S_IFREG);
 }
 
@@ -716,11 +769,122 @@ xrep_xattr_want_flush_stashed(
 {
 	unsigned long long	bytes;
 
+	if (!rx->can_flush)
+		return false;
+
 	bytes = xfarray_bytes(rx->xattr_records) +
 		xfblob_bytes(rx->xattr_blobs);
 	return bytes > XREP_XATTR_MAX_STASH_BYTES;
 }
 
+/*
+ * Did we observe rename changing parent pointer xattrs while we were flushing
+ * salvaged attrs?
+ */
+static inline bool
+xrep_xattr_saw_pptr_conflict(
+	struct xrep_xattr	*rx)
+{
+	bool			ret;
+
+	ASSERT(rx->can_flush);
+
+	if (!xfs_has_parent(rx->sc->mp))
+		return false;
+
+	ASSERT(xfs_isilocked(rx->sc->ip, XFS_ILOCK_EXCL));
+
+	mutex_lock(&rx->lock);
+	ret = xfarray_bytes(rx->pptr_recs) > 0;
+	mutex_unlock(&rx->lock);
+
+	return ret;
+}
+
+/*
+ * Reset the entire repair state back to initial conditions, now that we've
+ * detected a parent pointer update to the attr structure while we were
+ * flushing salvaged attrs.  See the locking notes in dir_repair.c for more
+ * information on why this is all necessary.
+ */
+STATIC int
+xrep_xattr_full_reset(
+	struct xrep_xattr	*rx)
+{
+	struct xfs_scrub	*sc = rx->sc;
+	struct xfs_attr_sf_hdr	*hdr;
+	struct xfs_ifork	*ifp = &sc->tempip->i_af;
+	int			error;
+
+	trace_xrep_xattr_full_reset(sc->ip, sc->tempip);
+
+	/* The temporary file's data fork had better not be in btree format. */
+	if (sc->tempip->i_df.if_format == XFS_DINODE_FMT_BTREE) {
+		ASSERT(0);
+		return -EIO;
+	}
+
+	/*
+	 * We begin in transaction context with sc->ip ILOCKed but not joined
+	 * to the transaction.  To reset to the initial state, we must hold
+	 * sc->ip's ILOCK to prevent rename from updating parent pointer
+	 * information and the tempfile's ILOCK to clear its contents.
+	 */
+	xchk_iunlock(rx->sc, XFS_ILOCK_EXCL);
+	xrep_tempfile_ilock_both(sc);
+	xfs_trans_ijoin(sc->tp, sc->ip, 0);
+	xfs_trans_ijoin(sc->tp, sc->tempip, 0);
+
+	/*
+	 * Free all the blocks of the attr fork of the temp file, and reset
+	 * it back to local format.
+	 */
+	if (xfs_ifork_has_extents(&sc->tempip->i_af)) {
+		error = xrep_reap_ifork(sc, sc->tempip, XFS_ATTR_FORK);
+		if (error)
+			return error;
+
+		ASSERT(ifp->if_bytes == 0);
+		ifp->if_format = XFS_DINODE_FMT_LOCAL;
+		xfs_idata_realloc(sc->tempip, sizeof(*hdr), XFS_ATTR_FORK);
+	}
+
+	/* Reinitialize the attr fork to an empty shortform structure. */
+	hdr = ifp->if_data;
+	memset(hdr, 0, sizeof(*hdr));
+	hdr->totsize = cpu_to_be16(sizeof(*hdr));
+	xfs_trans_log_inode(sc->tp, sc->tempip, XFS_ILOG_CORE | XFS_ILOG_ADATA);
+
+	/*
+	 * Roll this transaction to commit our reset ondisk.  The tempfile
+	 * should no longer be joined to the transaction, so we drop its ILOCK.
+	 * This should leave us in transaction context with sc->ip ILOCKed but
+	 * not joined to the transaction.
+	 */
+	error = xrep_roll_trans(sc);
+	if (error)
+		return error;
+	xrep_tempfile_iunlock(sc);
+
+	/*
+	 * Erase any accumulated parent pointer updates now that we've erased
+	 * the tempfile's attr fork.  We're resetting the entire repair state
+	 * back to where we were initially, except now we won't flush salvaged
+	 * xattrs until the very end.
+	 */
+	mutex_lock(&rx->lock);
+	xfarray_truncate(rx->pptr_recs);
+	xfblob_truncate(rx->pptr_names);
+	mutex_unlock(&rx->lock);
+
+	rx->can_flush = false;
+	rx->attrs_found = 0;
+
+	ASSERT(xfarray_bytes(rx->xattr_records) == 0);
+	ASSERT(xfblob_bytes(rx->xattr_blobs) == 0);
+	return 0;
+}
+
 /* Extract as many attribute keys and values as we can. */
 STATIC int
 xrep_xattr_recover(
@@ -735,6 +899,7 @@ xrep_xattr_recover(
 	int			nmap;
 	int			error;
 
+restart:
 	/*
 	 * Iterate each xattr leaf block in the attr fork to scan them for any
 	 * attributes that we might salvage.
@@ -773,6 +938,14 @@ xrep_xattr_recover(
 				error = xrep_xattr_flush_stashed(rx);
 				if (error)
 					return error;
+
+				if (xrep_xattr_saw_pptr_conflict(rx)) {
+					error = xrep_xattr_full_reset(rx);
+					if (error)
+						return error;
+
+					goto restart;
+				}
 			}
 		}
 	}
@@ -932,6 +1105,195 @@ xrep_xattr_salvage_attributes(
 	return xrep_xattr_flush_stashed(rx);
 }
 
+/*
+ * Add this stashed incore parent pointer to the temporary file.  The caller
+ * must hold the tempdir's IOLOCK, must not hold any ILOCKs, and must not be in
+ * transaction context.
+ */
+STATIC int
+xrep_xattr_replay_pptr_update(
+	struct xrep_xattr	*rx,
+	const struct xrep_xattr_pptr	*pptr)
+{
+	struct xfs_scrub	*sc = rx->sc;
+	int			error;
+
+	rx->pptr.p_ino = pptr->p_ino;
+	rx->pptr.p_gen = pptr->p_gen;
+	rx->pptr.p_namelen = pptr->namelen;
+	xfs_parent_irec_hashname(sc->mp, &rx->pptr);
+
+	switch (pptr->action) {
+	case XREP_XATTR_PPTR_ADD:
+		/* Create parent pointer. */
+		trace_xrep_xattr_replay_parentadd(sc->tempip, &rx->pptr);
+
+		error = xfs_parent_set(sc->tempip, sc->ip->i_ino, &rx->pptr,
+				&rx->pptr_scratch);
+		if (error) {
+			ASSERT(error != -EEXIST);
+			return error;
+		}
+		break;
+	case XREP_XATTR_PPTR_REMOVE:
+		/* Remove parent pointer. */
+		trace_xrep_xattr_replay_parentremove(sc->tempip, &rx->pptr);
+
+		error = xfs_parent_unset(sc->tempip, sc->ip->i_ino, &rx->pptr,
+				&rx->pptr_scratch);
+		if (error) {
+			ASSERT(error != -ENOATTR);
+			return error;
+		}
+		break;
+	default:
+		ASSERT(0);
+		return -EIO;
+	}
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
+xrep_xattr_replay_pptr_updates(
+	struct xrep_xattr	*rx)
+{
+	xfarray_idx_t		array_cur;
+	int			error;
+
+	mutex_lock(&rx->lock);
+	foreach_xfarray_idx(rx->pptr_recs, array_cur) {
+		struct xrep_xattr_pptr	pptr;
+
+		error = xfarray_load(rx->pptr_recs, array_cur, &pptr);
+		if (error)
+			goto out_unlock;
+
+		error = xfblob_load(rx->pptr_names, pptr.name_cookie,
+				rx->pptr.p_name, pptr.namelen);
+		if (error)
+			goto out_unlock;
+		rx->pptr.p_name[MAXNAMELEN - 1] = 0;
+		mutex_unlock(&rx->lock);
+
+		error = xrep_xattr_replay_pptr_update(rx, &pptr);
+		if (error)
+			return error;
+
+		mutex_lock(&rx->lock);
+	}
+
+	/* Empty out both arrays now that we've added the entries. */
+	xfarray_truncate(rx->pptr_recs);
+	xfblob_truncate(rx->pptr_names);
+	mutex_unlock(&rx->lock);
+	return 0;
+out_unlock:
+	mutex_unlock(&rx->lock);
+	return error;
+}
+
+/*
+ * Remember that we want to create a parent pointer in the tempfile.  These
+ * stashed actions will be replayed later.
+ */
+STATIC int
+xrep_xattr_stash_parentadd(
+	struct xrep_xattr	*rx,
+	const struct xfs_name	*name,
+	const struct xfs_inode	*dp)
+{
+	struct xrep_xattr_pptr	pptr = {
+		.action		= XREP_XATTR_PPTR_ADD,
+		.namelen	= name->len,
+		.p_ino		= dp->i_ino,
+		.p_gen		= VFS_IC(dp)->i_generation,
+	};
+	int			error;
+
+	trace_xrep_xattr_stash_parentadd(rx->sc->tempip, dp, name);
+
+	error = xfblob_store(rx->pptr_names, &pptr.name_cookie, name->name,
+			name->len);
+	if (error)
+		return error;
+
+	return xfarray_append(rx->pptr_recs, &pptr);
+}
+
+/*
+ * Remember that we want to remove a parent pointer from the tempfile.  These
+ * stashed actions will be replayed later.
+ */
+STATIC int
+xrep_xattr_stash_parentremove(
+	struct xrep_xattr	*rx,
+	const struct xfs_name	*name,
+	const struct xfs_inode	*dp)
+{
+	struct xrep_xattr_pptr	pptr = {
+		.action		= XREP_XATTR_PPTR_REMOVE,
+		.namelen	= name->len,
+		.p_ino		= dp->i_ino,
+		.p_gen		= VFS_IC(dp)->i_generation,
+	};
+	int			error;
+
+	trace_xrep_xattr_stash_parentremove(rx->sc->tempip, dp, name);
+
+	error = xfblob_store(rx->pptr_names, &pptr.name_cookie, name->name,
+			name->len);
+	if (error)
+		return error;
+
+	return xfarray_append(rx->pptr_recs, &pptr);
+}
+
+/*
+ * Capture dirent updates being made by other threads.  We will have to replay
+ * the parent pointer updates before exchanging attr forks.
+ */
+STATIC int
+xrep_xattr_live_dirent_update(
+	struct notifier_block		*nb,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_dir_update_params	*p = data;
+	struct xrep_xattr		*rx;
+	struct xfs_scrub		*sc;
+	int				error;
+
+	rx = container_of(nb, struct xrep_xattr, dhook.dirent_hook.nb);
+	sc = rx->sc;
+
+	/*
+	 * This thread updated a dirent that points to the file that we're
+	 * repairing, so stash the update for replay against the temporary
+	 * file.
+	 */
+	if (p->ip->i_ino != sc->ip->i_ino)
+		return NOTIFY_DONE;
+
+	mutex_lock(&rx->lock);
+	if (p->delta > 0)
+		error = xrep_xattr_stash_parentadd(rx, p->name, p->dp);
+	else
+		error = xrep_xattr_stash_parentremove(rx, p->name, p->dp);
+	if (error)
+		rx->live_update_aborted = true;
+	mutex_unlock(&rx->lock);
+	return NOTIFY_DONE;
+}
+
 /*
  * Prepare both inodes' attribute forks for an exchange.  Promote the tempfile
  * from short format to leaf format, and if the file being repaired has a short
@@ -1035,6 +1397,45 @@ xrep_xattr_swap(
 	return xrep_tempexch_contents(sc, tx);
 }
 
+/*
+ * Finish replaying stashed parent pointer updates, allocate a transaction for
+ * exchanging extent mappings, and take the ILOCKs of both files before we
+ * commit the new extended attribute structure.
+ */
+STATIC int
+xrep_xattr_finalize_tempfile(
+	struct xrep_xattr	*rx)
+{
+	struct xfs_scrub	*sc = rx->sc;
+	int			error;
+
+	if (!xfs_has_parent(sc->mp))
+		return xrep_tempexch_trans_alloc(sc, XFS_ATTR_FORK, &rx->tx);
+
+	/*
+	 * Repair relies on the ILOCK to quiesce all possible xattr updates.
+	 * Replay all queued parent pointer updates into the tempfile before
+	 * exchanging the contents, even if that means dropping the ILOCKs and
+	 * the transaction.
+	 */
+	do {
+		error = xrep_xattr_replay_pptr_updates(rx);
+		if (error)
+			return error;
+
+		error = xrep_tempexch_trans_alloc(sc, XFS_ATTR_FORK, &rx->tx);
+		if (error)
+			return error;
+
+		if (xfarray_length(rx->pptr_recs) == 0)
+			break;
+
+		xchk_trans_cancel(sc);
+		xrep_tempfile_iunlock_both(sc);
+	} while (!xchk_should_terminate(sc, &error));
+	return error;
+}
+
 /*
  * Exchange the new extended attribute data (which we created in the tempfile)
  * with the file being repaired.
@@ -1087,8 +1488,12 @@ xrep_xattr_rebuild_tree(
 	if (error)
 		return error;
 
-	/* Allocate exchange transaction and lock both inodes. */
-	error = xrep_tempexch_trans_alloc(rx->sc, XFS_ATTR_FORK, &rx->tx);
+	/*
+	 * Allocate transaction, lock inodes, and make sure that we've replayed
+	 * all the stashed parent pointer updates to the temp file.  After this
+	 * point, we're ready to exchange attr fork mappings.
+	 */
+	error = xrep_xattr_finalize_tempfile(rx);
 	if (error)
 		return error;
 
@@ -1129,8 +1534,15 @@ STATIC void
 xrep_xattr_teardown(
 	struct xrep_xattr	*rx)
 {
+	if (xfs_has_parent(rx->sc->mp))
+		xfs_dir_hook_del(rx->sc->mp, &rx->dhook);
+	if (rx->pptr_names)
+		xfblob_destroy(rx->pptr_names);
+	if (rx->pptr_recs)
+		xfarray_destroy(rx->pptr_recs);
 	xfblob_destroy(rx->xattr_blobs);
 	xfarray_destroy(rx->xattr_records);
+	mutex_destroy(&rx->lock);
 	kfree(rx);
 }
 
@@ -1149,6 +1561,9 @@ xrep_xattr_setup_scan(
 	if (!rx)
 		return -ENOMEM;
 	rx->sc = sc;
+	rx->can_flush = true;
+
+	mutex_init(&rx->lock);
 
 	/*
 	 * Allocate enough memory to handle loading local attr values from the
@@ -1176,11 +1591,43 @@ xrep_xattr_setup_scan(
 	if (error)
 		goto out_keys;
 
+	if (xfs_has_parent(sc->mp)) {
+		ASSERT(sc->flags & XCHK_FSGATES_DIRENTS);
+
+		descr = xchk_xfile_ino_descr(sc,
+				"xattr retained parent pointer entries");
+		error = xfarray_create(descr, 0,
+				sizeof(struct xrep_xattr_pptr),
+				&rx->pptr_recs);
+		kfree(descr);
+		if (error)
+			goto out_values;
+
+		descr = xchk_xfile_ino_descr(sc,
+				"xattr retained parent pointer names");
+		error = xfblob_create(descr, &rx->pptr_names);
+		kfree(descr);
+		if (error)
+			goto out_pprecs;
+
+		xfs_dir_hook_setup(&rx->dhook, xrep_xattr_live_dirent_update);
+		error = xfs_dir_hook_add(sc->mp, &rx->dhook);
+		if (error)
+			goto out_ppnames;
+	}
+
 	*rxp = rx;
 	return 0;
+out_ppnames:
+	xfblob_destroy(rx->pptr_names);
+out_pprecs:
+	xfarray_destroy(rx->pptr_recs);
+out_values:
+	xfblob_destroy(rx->xattr_blobs);
 out_keys:
 	xfarray_destroy(rx->xattr_records);
 out_rx:
+	mutex_destroy(&rx->lock);
 	kfree(rx);
 	return error;
 }
@@ -1217,6 +1664,11 @@ xrep_xattr(
 	if (error)
 		goto out_scan;
 
+	if (rx->live_update_aborted) {
+		error = -EIO;
+		goto out_scan;
+	}
+
 	/* Last chance to abort before we start committing fixes. */
 	if (xchk_should_terminate(sc, &error))
 		goto out_scan;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 8d212406a7461..ad3b193273b16 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2597,6 +2597,43 @@ DEFINE_EVENT(xrep_xattr_class, name, \
 	TP_ARGS(ip, arg_ip))
 DEFINE_XREP_XATTR_EVENT(xrep_xattr_rebuild_tree);
 DEFINE_XREP_XATTR_EVENT(xrep_xattr_reset_fork);
+DEFINE_XREP_XATTR_EVENT(xrep_xattr_full_reset);
+
+DECLARE_EVENT_CLASS(xrep_xattr_pptr_scan_class,
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
+#define DEFINE_XREP_XATTR_PPTR_SCAN_EVENT(name) \
+DEFINE_EVENT(xrep_xattr_pptr_scan_class, name, \
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_inode *dp, \
+		 const struct xfs_name *name), \
+	TP_ARGS(ip, dp, name))
+DEFINE_XREP_XATTR_PPTR_SCAN_EVENT(xrep_xattr_stash_parentadd);
+DEFINE_XREP_XATTR_PPTR_SCAN_EVENT(xrep_xattr_stash_parentremove);
 
 TRACE_EVENT(xrep_dir_recover_dirblock,
 	TP_PROTO(struct xfs_inode *dp, xfs_dablk_t dabno, uint32_t magic,
@@ -2743,6 +2780,40 @@ DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_dir_salvaged_parent);
 DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_findparent_dirent);
 DEFINE_XREP_PARENT_SALVAGE_EVENT(xrep_findparent_from_dcache);
 
+DECLARE_EVENT_CLASS(xrep_pptr_class,
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_parent_name_irec *pptr),
+	TP_ARGS(ip, pptr),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, ino)
+		__field(xfs_ino_t, parent_ino)
+		__field(unsigned int, parent_gen)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, pptr->p_namelen)
+	),
+	TP_fast_assign(
+		__entry->dev = ip->i_mount->m_super->s_dev;
+		__entry->ino = ip->i_ino;
+		__entry->parent_ino = pptr->p_ino;
+		__entry->parent_gen = pptr->p_gen;
+		__entry->namelen = pptr->p_namelen;
+		memcpy(__get_str(name), pptr->p_name, pptr->p_namelen);
+	),
+	TP_printk("dev %d:%d ino 0x%llx parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->ino,
+		  __entry->parent_ino,
+		  __entry->parent_gen,
+		  __entry->namelen,
+		  __get_str(name))
+)
+#define DEFINE_XREP_PPTR_EVENT(name) \
+DEFINE_EVENT(xrep_pptr_class, name, \
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_parent_name_irec *pptr), \
+	TP_ARGS(ip, pptr))
+DEFINE_XREP_PPTR_EVENT(xrep_xattr_replay_parentadd);
+DEFINE_XREP_PPTR_EVENT(xrep_xattr_replay_parentremove);
+
 TRACE_EVENT(xrep_nlinks_set_record,
 	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino,
 		 const struct xchk_nlink *obs),

