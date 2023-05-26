Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05FDBC77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:17:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbjEZCRd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbjEZCR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:17:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F4F213D
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:17:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 392B76122B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97F97C433EF;
        Fri, 26 May 2023 02:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067446;
        bh=Gw23T4eOQrq8FpkY3pjyre6c30g3Fbd2c1qxipibYnI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=PaDTUc8gjSiEorVUbbcqV83K0U/z1HYfYViR64xhbI5q5rpEtri9aKnUkZeFDEKID
         /9JQzMqAZ5keB+WyRq56OtHfaRZADg3U8Ng50B4vCUuVTTlEGQ69Lgt6ekF9PjJZZ9
         XkS57be5Z3KK++qiMOpWp/TSL+OwTvyCCEG5ZNYMlIqydBfCnmE9acavHKZ48hQV0T
         gzHfr3XqVh6A0vYZJ4j0Y/mYiYPE71KjqIn3vosi5ZFcLndNzHgmPGbT0w7ZSV1hqt
         oT4ou/kChl15HpsGk0TJngw4g5shDaurl6E0ULJraajW1XTz2SyEaBP48eu/hoHO8p
         grEKPtQbrkuPQ==
Date:   Thu, 25 May 2023 19:17:26 -0700
Subject: [PATCH 11/17] xfs: implement live updates for directory repairs
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506073453.3745075.290511236327367590.stgit@frogsfrogsfrogs>
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

While we're scanning the filesystem for parent pointers that we can turn
into dirents, we cannot hold the IOLOCK or ILOCK of the directory being
repaired.  Therefore, we need to set up a dirent hook so that we can
keep the temporary directory up to date with the rest of the filesystem.
Hence we add the ability to *remove* entries from the temporary dir.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/dir_repair.c |  221 +++++++++++++++++++++++++++++++++++++++++----
 fs/xfs/scrub/findparent.c |    8 +-
 fs/xfs/scrub/findparent.h |   10 ++
 fs/xfs/scrub/trace.h      |    2 
 4 files changed, 218 insertions(+), 23 deletions(-)


diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index 4a0ebab5e245..3a33f556616d 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -85,6 +85,12 @@
  * updates from other threads.
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
@@ -355,6 +365,34 @@ xrep_dir_stash_createname(
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
+	error = xfblob_store(rd->dir_names, &dirent.name_cookie, name->name,
+			name->len);
+	if (error)
+		return error;
+
+	return xfarray_append(rd->dir_entries, &dirent);
+}
+
 /* Allocate an in-core record to hold entries while we rebuild the dir data. */
 STATIC int
 xrep_dir_salvage_entry(
@@ -706,6 +744,43 @@ xrep_dir_replay_createname(
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
@@ -735,26 +810,64 @@ xrep_dir_replay_update(
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
-	error = xchk_dir_lookup(rd->sc, rd->sc->tempip, &name, &ino);
-	if (error != -ENOENT) {
-		ASSERT(error != -ENOENT);
+		error = xchk_dir_lookup(rd->sc, rd->sc->tempip, &name, &ino);
+		if (error != -ENOENT) {
+			ASSERT(error != -ENOENT);
+			goto out_cancel;
+		}
+#endif
+
+		error = xrep_dir_replay_createname(rd, &name, dirent->ino,
+				resblks);
+		if (error)
+			goto out_cancel;
+
+		if (name.type == XFS_DIR3_FT_DIR)
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
+		error = xchk_dir_lookup(rd->sc, rd->sc->tempip, &name, &ino);
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
+		error = xrep_dir_replay_removename(rd, &name, resblks);
+		if (error)
+			goto out_cancel;
+
+		if (name.type == XFS_DIR3_FT_DIR)
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
-	error = xrep_dir_replay_createname(rd, &name, dirent->ino, resblks);
-	if (error)
-		goto out_cancel;
-
-	if (name.type == XFS_DIR3_FT_DIR)
-		rd->subdirs++;
-	rd->dirents++;
 
 	/* Commit and unlock. */
 	error = xrep_trans_commit(rd->sc);
@@ -1270,6 +1383,71 @@ xrep_dir_scan_dirtree(
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
+	rd = container_of(nb, struct xrep_dir, pscan.hooks.dirent_hook.nb);
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
@@ -1615,6 +1793,9 @@ xrep_dir_rebuild_tree(
 	if (error)
 		return error;
 
+	if (xchk_iscan_aborted(&rd->pscan.iscan))
+		return -ECANCELED;
+
 	/*
 	 * Swap the tempdir's data fork with the file being repaired.  This
 	 * recreates the transaction and re-takes the ILOCK in the scrub
@@ -1650,7 +1831,11 @@ xrep_dir_setup_scan(
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
index 0c3940d397da..da21792758d9 100644
--- a/fs/xfs/scrub/findparent.c
+++ b/fs/xfs/scrub/findparent.c
@@ -240,9 +240,10 @@ xrep_findparent_live_update(
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
 
@@ -264,7 +265,8 @@ xrep_findparent_scan_start(
 	 * ILOCK, which means that any in-progress inode updates will finish
 	 * before we can scan the inode.
 	 */
-	xfs_hook_setup(&pscan->hooks.dirent_hook, xrep_findparent_live_update);
+	xfs_hook_setup(&pscan->hooks.dirent_hook,
+			custom_fn ? custom_fn : xrep_findparent_live_update);
 	error = xfs_dir_hook_add(sc->mp, &pscan->hooks);
 	if (error)
 		goto out_iscan;
diff --git a/fs/xfs/scrub/findparent.h b/fs/xfs/scrub/findparent.h
index 0bc3921e6ddc..cdd2e4405088 100644
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
index 96c88f4419d7..a7af7f396a5a 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -2636,6 +2636,8 @@ DEFINE_XREP_DIRENT_CLASS(xrep_dir_salvage_entry);
 DEFINE_XREP_DIRENT_CLASS(xrep_dir_stash_createname);
 DEFINE_XREP_DIRENT_CLASS(xrep_dir_replay_createname);
 DEFINE_XREP_DIRENT_CLASS(xrep_adoption_commit);
+DEFINE_XREP_DIRENT_CLASS(xrep_dir_stash_removename);
+DEFINE_XREP_DIRENT_CLASS(xrep_dir_replay_removename);
 
 TRACE_EVENT(xrep_adoption_cancel,
 	TP_PROTO(struct xfs_inode *dp, struct xfs_inode *ip, int error),

