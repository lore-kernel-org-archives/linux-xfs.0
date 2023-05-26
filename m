Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D8D3C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:17:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjEZCRw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230465AbjEZCRv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:17:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495E8195
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:17:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C27FE64C1F
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CE9DC433D2;
        Fri, 26 May 2023 02:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067462;
        bh=Cu6RIaUetzIu5qH4wnYCYMbEo0d/7+YSxIl+XoQNygo=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=D3ZNk5SKFKIHhiOG1UB5YWcTzTbU2WZX8AVp2ZsHY0mrbLSP466tjo99fiEQvsnOy
         pRE/2bqAZkTOfupwCiGZL8Pw6M0gwLASJoD7L03HmRymuWRRCJjitBlNVf5ddjvCsa
         tbZWFdHXwiggIQD8TV6WmNhlkaea24m+crb5ujtX+h+N5e4Wfd90Xhfmdz3qCnIXlC
         WC3yfpsBNOb2Bl5ltgia5J4IQGOllCGywCrbjzmzkJRpO3bBV8otg0STUtVHfMnlYk
         BQFBJ93NJuXzHpSSY40mb5l6XzfhWzNH3zWrsawTD4//3Eonm0KQgXYHg++E8WSdrX
         vIqeEGcudevdw==
Date:   Thu, 25 May 2023 19:17:41 -0700
Subject: [PATCH 12/17] xfs: replay unlocked parent pointer updates that accrue
 during xattr repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506073467.3745075.6649237914783332833.stgit@frogsfrogsfrogs>
In-Reply-To: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
References: <168506073275.3745075.7865645835865818396.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

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
 fs/xfs/scrub/attr_repair.c |  451 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h       |   72 +++++++
 2 files changed, 521 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/scrub/attr_repair.c b/fs/xfs/scrub/attr_repair.c
index 489abe1f028a..23bc72773e33 100644
--- a/fs/xfs/scrub/attr_repair.c
+++ b/fs/xfs/scrub/attr_repair.c
@@ -95,6 +95,56 @@ struct xrep_xattr {
 
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
+	struct xfs_dir_hook	hooks;
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
@@ -102,6 +152,9 @@ int
 xrep_setup_xattr(
 	struct xfs_scrub	*sc)
 {
+	if (xfs_has_parent(sc->mp))
+		xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
+
 	return xrep_tempfile_create(sc, S_IFREG);
 }
 
@@ -712,11 +765,122 @@ xrep_xattr_want_flush_stashed(
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
+	hdr = (struct xfs_attr_sf_hdr *)ifp->if_u1.if_data;
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
@@ -731,6 +895,7 @@ xrep_xattr_recover(
 	int			nmap;
 	int			error;
 
+restart:
 	/*
 	 * Iterate each xattr leaf block in the attr fork to scan them for any
 	 * attributes that we might salvage.
@@ -769,6 +934,14 @@ xrep_xattr_recover(
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
@@ -933,6 +1106,195 @@ xrep_xattr_salvage_attributes(
 	return xrep_xattr_flush_stashed(rx);
 }
 
+/*
+ * Add this stashed incore parent pointer to the temporary file.
+ * The caller must hold the tempdir's IOLOCK, must not hold any ILOCKs, and
+ * must not be in transaction context.
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
+ * the parent pointer updates before swapping attr forks.
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
+	rx = container_of(nb, struct xrep_xattr, hooks.dirent_hook.nb);
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
  * Prepare both inodes' attribute forks for extent swapping.  Promote the
  * tempfile from short format to leaf format, and if the file being repaired
@@ -1035,6 +1397,44 @@ xrep_xattr_swap(
 	return xrep_tempswap_contents(sc, tx);
 }
 
+/*
+ * Finish replaying stashed parent pointer updates, allocate a transaction for
+ * swapping extents, and take the ILOCKs of both files before we commit the new
+ * extended attribute structure.
+ */
+STATIC int
+xrep_xattr_finalize_tempfile(
+	struct xrep_xattr	*rx)
+{
+	struct xfs_scrub	*sc = rx->sc;
+	int			error;
+
+	if (!xfs_has_parent(sc->mp))
+		return xrep_tempswap_trans_alloc(sc, XFS_ATTR_FORK, &rx->tx);
+
+	do {
+		error = xrep_xattr_replay_pptr_updates(rx);
+		if (error)
+			return error;
+
+		error = xrep_tempswap_trans_alloc(sc, XFS_ATTR_FORK, &rx->tx);
+		if (error)
+			return error;
+
+		/*
+		 * We rely on the ILOCK to quiesce all parent pointer updates
+		 * because the VFS does not take the IOLOCK when moving a
+		 * directory child during a rename.
+		 */
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
  * Swap the new extended attribute data (which we created in the tempfile) into
  * the file being repaired.
@@ -1086,8 +1486,12 @@ xrep_xattr_rebuild_tree(
 	if (error)
 		return error;
 
-	/* Allocate swapext transaction and lock both inodes. */
-	error = xrep_tempswap_trans_alloc(rx->sc, XFS_ATTR_FORK, &rx->tx);
+	/*
+	 * Allocate transaction, lock inodes, and make sure that we've replayed
+	 * all the stashed parent pointer updates to the temp file.  After this
+	 * point, we're ready to swapext.
+	 */
+	error = xrep_xattr_finalize_tempfile(rx);
 	if (error)
 		return error;
 
@@ -1116,8 +1520,15 @@ STATIC void
 xrep_xattr_teardown(
 	struct xrep_xattr	*rx)
 {
+	if (xfs_has_parent(rx->sc->mp))
+		xfs_dir_hook_del(rx->sc->mp, &rx->hooks);
+	if (rx->pptr_names)
+		xfblob_destroy(rx->pptr_names);
+	if (rx->pptr_recs)
+		xfarray_destroy(rx->pptr_recs);
 	xfblob_destroy(rx->xattr_blobs);
 	xfarray_destroy(rx->xattr_records);
+	mutex_destroy(&rx->lock);
 	kfree(rx);
 }
 
@@ -1135,6 +1546,9 @@ xrep_xattr_setup_scan(
 	if (!rx)
 		return -ENOMEM;
 	rx->sc = sc;
+	rx->can_flush = true;
+
+	mutex_init(&rx->lock);
 
 	/*
 	 * Allocate enough memory to handle loading local attr values from the
@@ -1158,11 +1572,39 @@ xrep_xattr_setup_scan(
 	if (error)
 		goto out_keys;
 
+	if (xfs_has_parent(sc->mp)) {
+		ASSERT(sc->flags & XCHK_FSGATES_DIRENTS);
+
+		error = xfarray_create(sc->mp, "xattr parent pointer entries",
+				0, sizeof(struct xrep_xattr_pptr),
+				&rx->pptr_recs);
+		if (error)
+			goto out_values;
+
+		error = xfblob_create(sc->mp, "xattr parent pointer names",
+				&rx->pptr_names);
+		if (error)
+			goto out_pprecs;
+
+		xfs_hook_setup(&rx->hooks.dirent_hook,
+				xrep_xattr_live_dirent_update);
+		error = xfs_dir_hook_add(sc->mp, &rx->hooks);
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
@@ -1199,6 +1641,11 @@ xrep_xattr(
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
index a7af7f396a5a..cbbd8863bab0 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -27,6 +27,7 @@ struct xchk_fscounters;
 struct xfbtree;
 struct xfbtree_config;
 struct xfs_rmap_update_params;
+struct xfs_parent_name_irec;
 
 /*
  * ftrace's __print_symbolic requires that all enum values be wrapped in the
@@ -2546,6 +2547,43 @@ DEFINE_EVENT(xrep_xattr_class, name, \
 	TP_ARGS(ip, arg_ip))
 DEFINE_XREP_XATTR_CLASS(xrep_xattr_rebuild_tree);
 DEFINE_XREP_XATTR_CLASS(xrep_xattr_reset_fork);
+DEFINE_XREP_XATTR_CLASS(xrep_xattr_full_reset);
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
+#define DEFINE_XREP_XATTR_PPTR_SCAN_CLASS(name) \
+DEFINE_EVENT(xrep_xattr_pptr_scan_class, name, \
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_inode *dp, \
+		 const struct xfs_name *name), \
+	TP_ARGS(ip, dp, name))
+DEFINE_XREP_XATTR_PPTR_SCAN_CLASS(xrep_xattr_stash_parentadd);
+DEFINE_XREP_XATTR_PPTR_SCAN_CLASS(xrep_xattr_stash_parentremove);
 
 TRACE_EVENT(xrep_dir_recover_dirblock,
 	TP_PROTO(struct xfs_inode *dp, xfs_dablk_t dabno, uint32_t magic,
@@ -2687,6 +2725,40 @@ DEFINE_XREP_PARENT_SALVAGE_CLASS(xrep_dir_salvaged_parent);
 DEFINE_XREP_PARENT_SALVAGE_CLASS(xrep_findparent_dirent);
 DEFINE_XREP_PARENT_SALVAGE_CLASS(xrep_findparent_from_dcache);
 
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
+#define DEFINE_XREP_PPTR_CLASS(name) \
+DEFINE_EVENT(xrep_pptr_class, name, \
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_parent_name_irec *pptr), \
+	TP_ARGS(ip, pptr))
+DEFINE_XREP_PPTR_CLASS(xrep_xattr_replay_parentadd);
+DEFINE_XREP_PPTR_CLASS(xrep_xattr_replay_parentremove);
+
 TRACE_EVENT(xrep_nlinks_set_record,
 	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino,
 		 const struct xchk_nlink *obs),

