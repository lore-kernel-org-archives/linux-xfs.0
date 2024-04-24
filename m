Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 276C213B583
	for <linux-xfs@vger.kernel.org>; Wed, 24 Apr 2024 03:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713929029; cv=none; b=eWPlm3vC4HHu7QRKbFE1hxrmDV1Yrs4gh+RVYVdsfu0oSrQTRv0fdwuvpJKwb7aVGe/RXXUc4Gowmk05c4UieI/EtFwlVHnySrFTkdI6jybywy+TAXSoTVmEd0p1aif/dRSu1ZFDLstchrQ9dx05QpGdcZOwS9nmiBlLurR+4QQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713929029; c=relaxed/simple;
	bh=M3p5b8qCLAq/LSWTxEtY70SQFAMn/R0s9YRyhLz1YN8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VI1THckYDhnLiT9P7jqKYd010wHNapCR8YTNBdAFA1WWwljwU1YsK0ULPFjWxTP0o1RbsebpP0f9qpZxNl26crS+D8xiQjF3yAHOgJiBzR5NA+Le1BoYMODZiR6plL04y7G9AeEe3Cu79FOtXYXzqeRvrvRVnxGfEOjlxv6m1Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YbqFqXQC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YbqFqXQC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE316C2BD11;
	Wed, 24 Apr 2024 03:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713929029;
	bh=M3p5b8qCLAq/LSWTxEtY70SQFAMn/R0s9YRyhLz1YN8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=YbqFqXQCefoUcHnXj1/UVqxkqpnqz8MDUsmLNoeueoq5akxTrpGNpvB4sOW6V5Zs5
	 sAYaA9ElqSGAolHQmE0IO89u5cMMCdjNh0uGOGdI6PGd1l/xro45XAjMGD0mJaJsbo
	 ZmcBiBmgxYy3zziKjzGw5QL+6zNTzmW61XG2CXiHKCclkyUA3Yurn7nyoJyyWepfUy
	 edFbJfHG3eweLSWuZYyB8kf/cNxFkJjI+BL/whqM2l8LJYZJ3oRQBeHPK7EuRr2xKP
	 HJHDfiWTJLeZ7tIhzHPrV0cPI6B278dwmrXheQW/pN/RmseHkMTPy+jM3aF+lq3E1D
	 OVNTW3sSq7N6A==
Date: Tue, 23 Apr 2024 20:23:48 -0700
Subject: [PATCH 06/16] xfs: implement live updates for directory repairs
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, chandanbabu@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, catherine.hoang@oracle.com,
 allison.henderson@oracle.com, hch@lst.de, linux-xfs@vger.kernel.org
Message-ID: <171392784752.1906420.3091486781507727818.stgit@frogsfrogsfrogs>
In-Reply-To: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
References: <171392784611.1906420.2159865382920841289.stgit@frogsfrogsfrogs>
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

While we're scanning the filesystem for parent pointers that we can turn
into dirents, we cannot hold the IOLOCK or ILOCK of the directory being
repaired.  Therefore, we need to set up a dirent hook so that we can
keep the temporary directory up to date with the rest of the filesystem.
Hence we add the ability to *remove* entries from the temporary dir.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/scrub/dir_repair.c |  220 +++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/scrub/findparent.c |   10 +-
 fs/xfs/scrub/findparent.h |   10 ++
 fs/xfs/scrub/trace.h      |    2 
 4 files changed, 219 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 4e6b0e88b996..60e31da4451e 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -85,6 +85,12 @@
  * other threads.
  */
 
+/* Create a dirent in the tempdir. */
+#define XREP_DIRENT_ADD		(1)
+
+/* Remove a dirent from the tempdir. */
+#define XREP_DIRENT_REMOVE	(2)
+
 /* Directory entry to be restored in the new directory. */
 struct xrep_dirent {
 	/* Cookie for retrieval of the dirent name. */
@@ -98,6 +104,9 @@ struct xrep_dirent {
 
 	/* File type of the dirent. */
 	uint8_t			ftype;
+
+	/* XREP_DIRENT_{ADD,REMOVE} */
+	uint8_t			action;
 };
 
 /*
@@ -339,6 +348,7 @@ xrep_dir_stash_createname(
 	xfs_ino_t		ino)
 {
 	struct xrep_dirent	dirent = {
+		.action		= XREP_DIRENT_ADD,
 		.ino		= ino,
 		.namelen	= name->len,
 		.ftype		= name->type,
@@ -354,6 +364,33 @@ xrep_dir_stash_createname(
 	return xfarray_append(rd->dir_entries, &dirent);
 }
 
+/*
+ * Remember that we want to remove a dirent from the tempdir.  These stashed
+ * actions will be replayed later.
+ */
+STATIC int
+xrep_dir_stash_removename(
+	struct xrep_dir		*rd,
+	const struct xfs_name	*name,
+	xfs_ino_t		ino)
+{
+	struct xrep_dirent	dirent = {
+		.action		= XREP_DIRENT_REMOVE,
+		.ino		= ino,
+		.namelen	= name->len,
+		.ftype		= name->type,
+	};
+	int			error;
+
+	trace_xrep_dir_stash_removename(rd->sc->tempip, name, ino);
+
+	error = xfblob_storename(rd->dir_names, &dirent.name_cookie, name);
+	if (error)
+		return error;
+
+	return xfarray_append(rd->dir_entries, &dirent);
+}
+
 /* Allocate an in-core record to hold entries while we rebuild the dir data. */
 STATIC int
 xrep_dir_salvage_entry(
@@ -705,6 +742,43 @@ xrep_dir_replay_createname(
 	return xfs_dir2_node_addname(&rd->args);
 }
 
+/* Replay a stashed removename onto the temporary directory. */
+STATIC int
+xrep_dir_replay_removename(
+	struct xrep_dir		*rd,
+	const struct xfs_name	*name,
+	xfs_extlen_t		total)
+{
+	struct xfs_inode	*dp = rd->args.dp;
+	bool			is_block, is_leaf;
+	int			error;
+
+	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
+
+	xrep_dir_init_args(rd, dp, name);
+	rd->args.op_flags = 0;
+	rd->args.total = total;
+
+	trace_xrep_dir_replay_removename(dp, name, 0);
+
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
+		return xfs_dir2_sf_removename(&rd->args);
+
+	error = xfs_dir2_isblock(&rd->args, &is_block);
+	if (error)
+		return error;
+	if (is_block)
+		return xfs_dir2_block_removename(&rd->args);
+
+	error = xfs_dir2_isleaf(&rd->args, &is_leaf);
+	if (error)
+		return error;
+	if (is_leaf)
+		return xfs_dir2_leaf_removename(&rd->args);
+
+	return xfs_dir2_node_removename(&rd->args);
+}
+
 /*
  * Add this stashed incore directory entry to the temporary directory.
  * The caller must hold the tempdir's IOLOCK, must not hold any ILOCKs, and
@@ -732,26 +806,64 @@ xrep_dir_replay_update(
 	xrep_tempfile_ilock(rd->sc);
 	xfs_trans_ijoin(rd->sc->tp, rd->sc->tempip, 0);
 
-	/*
-	 * Create a replacement dirent in the temporary directory.  Note that
-	 * _createname doesn't check for existing entries.  There shouldn't be
-	 * any in the temporary dir, but we'll verify this in debug mode.
-	 */
+	switch (dirent->action) {
+	case XREP_DIRENT_ADD:
+		/*
+		 * Create a replacement dirent in the temporary directory.
+		 * Note that _createname doesn't check for existing entries.
+		 * There shouldn't be any in the temporary dir, but we'll
+		 * verify this in debug mode.
+		 */
 #ifdef DEBUG
-	error = xchk_dir_lookup(rd->sc, rd->sc->tempip, xname, &ino);
-	if (error != -ENOENT) {
-		ASSERT(error != -ENOENT);
+		error = xchk_dir_lookup(rd->sc, rd->sc->tempip, xname, &ino);
+		if (error != -ENOENT) {
+			ASSERT(error != -ENOENT);
+			goto out_cancel;
+		}
+#endif
+
+		error = xrep_dir_replay_createname(rd, xname, dirent->ino,
+				resblks);
+		if (error)
+			goto out_cancel;
+
+		if (xname->type == XFS_DIR3_FT_DIR)
+			rd->subdirs++;
+		rd->dirents++;
+		break;
+	case XREP_DIRENT_REMOVE:
+		/*
+		 * Remove a dirent from the temporary directory.  Note that
+		 * _removename doesn't check the inode target of the exist
+		 * entry.  There should be a perfect match in the temporary
+		 * dir, but we'll verify this in debug mode.
+		 */
+#ifdef DEBUG
+		error = xchk_dir_lookup(rd->sc, rd->sc->tempip, xname, &ino);
+		if (error) {
+			ASSERT(error != 0);
+			goto out_cancel;
+		}
+		if (ino != dirent->ino) {
+			ASSERT(ino == dirent->ino);
+			error = -EIO;
+			goto out_cancel;
+		}
+#endif
+
+		error = xrep_dir_replay_removename(rd, xname, resblks);
+		if (error)
+			goto out_cancel;
+
+		if (xname->type == XFS_DIR3_FT_DIR)
+			rd->subdirs--;
+		rd->dirents--;
+		break;
+	default:
+		ASSERT(0);
+		error = -EIO;
 		goto out_cancel;
 	}
-#endif
-
-	error = xrep_dir_replay_createname(rd, xname, dirent->ino, resblks);
-	if (error)
-		goto out_cancel;
-
-	if (xname->type == XFS_DIR3_FT_DIR)
-		rd->subdirs++;
-	rd->dirents++;
 
 	/* Commit and unlock. */
 	error = xrep_trans_commit(rd->sc);
@@ -1284,6 +1396,71 @@ xrep_dir_scan_dirtree(
 	return 0;
 }
 
+/*
+ * Capture dirent updates being made by other threads which are relevant to the
+ * directory being repaired.
+ */
+STATIC int
+xrep_dir_live_update(
+	struct notifier_block		*nb,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_dir_update_params	*p = data;
+	struct xrep_dir			*rd;
+	struct xfs_scrub		*sc;
+	int				error = 0;
+
+	rd = container_of(nb, struct xrep_dir, pscan.dhook.dirent_hook.nb);
+	sc = rd->sc;
+
+	/*
+	 * This thread updated a child dirent in the directory that we're
+	 * rebuilding.  Stash the update for replay against the temporary
+	 * directory.
+	 */
+	if (p->dp->i_ino == sc->ip->i_ino &&
+	    xchk_iscan_want_live_update(&rd->pscan.iscan, p->ip->i_ino)) {
+		mutex_lock(&rd->pscan.lock);
+		if (p->delta > 0)
+			error = xrep_dir_stash_createname(rd, p->name,
+					p->ip->i_ino);
+		else
+			error = xrep_dir_stash_removename(rd, p->name,
+					p->ip->i_ino);
+		mutex_unlock(&rd->pscan.lock);
+		if (error)
+			goto out_abort;
+	}
+
+	/*
+	 * This thread updated another directory's child dirent that points to
+	 * the directory that we're rebuilding, so remember the new dotdot
+	 * target.
+	 */
+	if (p->ip->i_ino == sc->ip->i_ino &&
+	    xchk_iscan_want_live_update(&rd->pscan.iscan, p->dp->i_ino)) {
+		if (p->delta > 0) {
+			trace_xrep_dir_stash_createname(sc->tempip,
+					&xfs_name_dotdot,
+					p->dp->i_ino);
+
+			xrep_findparent_scan_found(&rd->pscan, p->dp->i_ino);
+		} else {
+			trace_xrep_dir_stash_removename(sc->tempip,
+					&xfs_name_dotdot,
+					rd->pscan.parent_ino);
+
+			xrep_findparent_scan_found(&rd->pscan, NULLFSINO);
+		}
+	}
+
+	return NOTIFY_DONE;
+out_abort:
+	xchk_iscan_abort(&rd->pscan.iscan);
+	return NOTIFY_DONE;
+}
+
 /*
  * Free all the directory blocks and reset the data fork.  The caller must
  * join the inode to the transaction.  This function returns with the inode
@@ -1633,6 +1810,9 @@ xrep_dir_rebuild_tree(
 	if (error)
 		return error;
 
+	if (xchk_iscan_aborted(&rd->pscan.iscan))
+		return -ECANCELED;
+
 	/*
 	 * Exchange the tempdir's data fork with the file being repaired.  This
 	 * recreates the transaction and re-takes the ILOCK in the scrub
@@ -1688,7 +1868,11 @@ xrep_dir_setup_scan(
 	if (error)
 		goto out_xfarray;
 
-	error = xrep_findparent_scan_start(sc, &rd->pscan);
+	if (xfs_has_parent(sc->mp))
+		error = __xrep_findparent_scan_start(sc, &rd->pscan,
+				xrep_dir_live_update);
+	else
+		error = xrep_findparent_scan_start(sc, &rd->pscan);
 	if (error)
 		goto out_xfblob;
 
diff --git a/fs/xfs/scrub/findparent.c b/fs/xfs/scrub/findparent.c
index 712dd73e4789..c78422ad757b 100644
--- a/fs/xfs/scrub/findparent.c
+++ b/fs/xfs/scrub/findparent.c
@@ -238,9 +238,10 @@ xrep_findparent_live_update(
  * will be called when there is a dotdot update for the inode being repaired.
  */
 int
-xrep_findparent_scan_start(
+__xrep_findparent_scan_start(
 	struct xfs_scrub		*sc,
-	struct xrep_parent_scan_info	*pscan)
+	struct xrep_parent_scan_info	*pscan,
+	notifier_fn_t			custom_fn)
 {
 	int				error;
 
@@ -262,7 +263,10 @@ xrep_findparent_scan_start(
 	 * ILOCK, which means that any in-progress inode updates will finish
 	 * before we can scan the inode.
 	 */
-	xfs_dir_hook_setup(&pscan->dhook, xrep_findparent_live_update);
+	if (custom_fn)
+		xfs_dir_hook_setup(&pscan->dhook, custom_fn);
+	else
+		xfs_dir_hook_setup(&pscan->dhook, xrep_findparent_live_update);
 	error = xfs_dir_hook_add(sc->mp, &pscan->dhook);
 	if (error)
 		goto out_iscan;
diff --git a/fs/xfs/scrub/findparent.h b/fs/xfs/scrub/findparent.h
index 501f99d3164e..d998c7a88152 100644
--- a/fs/xfs/scrub/findparent.h
+++ b/fs/xfs/scrub/findparent.h
@@ -24,8 +24,14 @@ struct xrep_parent_scan_info {
 	bool			lookup_parent;
 };
 
-int xrep_findparent_scan_start(struct xfs_scrub *sc,
-		struct xrep_parent_scan_info *pscan);
+int __xrep_findparent_scan_start(struct xfs_scrub *sc,
+		struct xrep_parent_scan_info *pscan,
+		notifier_fn_t custom_fn);
+static inline int xrep_findparent_scan_start(struct xfs_scrub *sc,
+		struct xrep_parent_scan_info *pscan)
+{
+	return __xrep_findparent_scan_start(sc, pscan, NULL);
+}
 int xrep_findparent_scan(struct xrep_parent_scan_info *pscan);
 void xrep_findparent_scan_teardown(struct xrep_parent_scan_info *pscan);
 
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 4b968df3d840..64db413b1888 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2692,6 +2692,8 @@ DEFINE_XREP_DIRENT_EVENT(xrep_dir_salvage_entry);
 DEFINE_XREP_DIRENT_EVENT(xrep_dir_stash_createname);
 DEFINE_XREP_DIRENT_EVENT(xrep_dir_replay_createname);
 DEFINE_XREP_DIRENT_EVENT(xrep_adoption_reparent);
+DEFINE_XREP_DIRENT_EVENT(xrep_dir_stash_removename);
+DEFINE_XREP_DIRENT_EVENT(xrep_dir_replay_removename);
 
 DECLARE_EVENT_CLASS(xrep_adoption_class,
 	TP_PROTO(struct xfs_inode *dp, struct xfs_inode *ip, bool moved),

