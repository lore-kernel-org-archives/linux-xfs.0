Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4203C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:49:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjBPUt1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229741AbjBPUt0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:49:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BB154BEB7
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:49:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 85AA1CE2D74
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3FDC433EF;
        Thu, 16 Feb 2023 20:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580561;
        bh=TN3kl8Ja2i+7Qu2b/WcQO5Tym3PdYBOpDnxhjJFWgbI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=SWnyeazEr25LFSsXknLH9BoSd7+TD5CnKtjNBCaOzakekgomP6qBNwHYtrx09APXp
         B45z26jiaAEUP2vzuGFn0U9D3OJ0n5XVMUJJV1ZyMmj2UxOImXGEYELCe3PRnZ/u6u
         QCHH/JyQiPtpgwNpNUkSzXPnTixTVDBIyZYMpHT771VV7i/jfQFzWZJK5f+idNyBRP
         aJ5AIfXBCxDbfQw9fF1urY0jbss6PWRPMo5O6ylaLpV8eK9Z7kfWjgdbYqnVC2EqRn
         e2cRENUIAQd3TzdtpjzOmw6xJVZrzemmeBUSWWOpm6gZ1AnWrhime4iA3DWINSmpEq
         trkFT0EYeT7CA==
Date:   Thu, 16 Feb 2023 12:49:21 -0800
Subject: [PATCH 6/7] xfs: add hooks to do directory updates
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874554.3474898.13161459001017692488.stgit@magnolia>
In-Reply-To: <167657874461.3474898.12919390014293805981.stgit@magnolia>
References: <167657874461.3474898.12919390014293805981.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While we're scanning the filesystem, we still need to keep the tempdir
up to date with whatever changes get made to the you know what.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c  |    2 -
 fs/xfs/libxfs/xfs_dir2.h  |    2 -
 fs/xfs/scrub/dir_repair.c |   94 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 96 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 27e408d20d18..8bed71a5e9cc 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -440,7 +440,7 @@ int
 xfs_dir_removename(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
-	struct xfs_name		*name,
+	const struct xfs_name	*name,
 	xfs_ino_t		ino,
 	xfs_extlen_t		total,		/* bmap's total block count */
 	xfs_dir2_dataptr_t	*offset)	/* OUT: offset in directory */
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index ac360c0b2fe7..6ed86b7bd13c 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -46,7 +46,7 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
-				struct xfs_name *name, xfs_ino_t ino,
+				const struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot,
 				xfs_dir2_dataptr_t *offset);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index a6576a29e784..25af002df1da 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -124,6 +124,9 @@ struct xrep_dir {
 	/* Mutex protecting dir_entries, dir_names, and parent_ino. */
 	struct mutex		lock;
 
+	/* Hook to capture directory entry updates. */
+	struct xfs_dirent_hook	hooks;
+
 	/*
 	 * This is the dotdot inumber that we're going to set on the
 	 * reconstructed directory.
@@ -141,6 +144,7 @@ xrep_dir_teardown(
 {
 	struct xrep_dir		*rd = sc->buf;
 
+	xfs_dirent_hook_del(sc->mp, &rd->hooks);
 	xchk_iscan_finish(&rd->iscan);
 	mutex_destroy(&rd->lock);
 	xfblob_destroy(rd->dir_names);
@@ -155,6 +159,8 @@ xrep_setup_directory(
 	struct xrep_dir		*rd;
 	int			error;
 
+	xchk_fshooks_enable(sc, XCHK_FSHOOKS_DIRENTS);
+
 	error = xrep_tempfile_create(sc, S_IFDIR);
 	if (error)
 		return error;
@@ -832,6 +838,12 @@ xrep_dir_rebuild_tree(
 	if (error)
 		return error;
 
+	/*
+	 * Abort the inode scan so that the live hooks won't stash any more
+	 * directory updates.
+	 */
+	xchk_iscan_abort(&rd->iscan);
+
 	error = xrep_dir_replay_updates(rd);
 	if (error)
 		return error;
@@ -875,6 +887,72 @@ xrep_dir_rebuild_tree(
 	return xrep_dir_replay_updates(rd);
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
+	struct xfs_dirent_update_params	*p = data;
+	struct xrep_dir			*rd;
+	struct xfs_scrub		*sc;
+	int				error = 0;
+
+	rd = container_of(nb, struct xrep_dir, hooks.delta_hook.nb);
+	sc = rd->sc;
+
+	if (action != XFS_DIRENT_CHILD_DELTA)
+		return NOTIFY_DONE;
+
+	/*
+	 * This thread updated a dirent in the directory that we're rebuilding,
+	 * so stash the update for replay against the temporary directory.
+	 */
+	if (p->dp->i_ino == sc->ip->i_ino &&
+	    xchk_iscan_want_live_update(&rd->iscan, p->ip->i_ino)) {
+		mutex_lock(&rd->lock);
+		if (p->delta > 0)
+			error = xrep_dir_add_dirent(rd, p->name, p->ip->i_ino,
+					p->diroffset);
+		else
+			error = xrep_dir_remove_dirent(rd, p->name,
+					p->ip->i_ino, p->diroffset);
+		mutex_unlock(&rd->lock);
+		if (error)
+			goto out_abort;
+	}
+
+	/*
+	 * This thread updated a dirent that points to the directory that we're
+	 * rebuilding, so remember the new dotdot target.
+	 */
+	if (p->ip->i_ino == sc->ip->i_ino &&
+	    xchk_iscan_want_live_update(&rd->iscan, p->dp->i_ino)) {
+		mutex_lock(&rd->lock);
+		if (p->delta > 0) {
+			trace_xrep_dir_add_dirent(sc->tempip, &xfs_name_dotdot,
+					p->dp->i_ino, 0);
+
+			rd->parent_ino = p->dp->i_ino;
+		} else {
+			trace_xrep_dir_remove_dirent(sc->tempip,
+					&xfs_name_dotdot, NULLFSINO, 0);
+
+			rd->parent_ino = NULLFSINO;
+		}
+		mutex_unlock(&rd->lock);
+	}
+
+	return NOTIFY_DONE;
+out_abort:
+	xchk_iscan_abort(&rd->iscan);
+	return NOTIFY_DONE;
+}
+
 /* Set up the filesystem scan so we can regenerate directory entries. */
 STATIC int
 xrep_dir_setup_scan(
@@ -897,8 +975,24 @@ xrep_dir_setup_scan(
 	/* Retry iget every tenth of a second for up to 30 seconds. */
 	xchk_iscan_start(&rd->iscan, 30000, 100);
 
+	/*
+	 * Hook into the dirent update code.  The hook only operates on inodes
+	 * that were already scanned, and the scanner thread takes each inode's
+	 * ILOCK, which means that any in-progress inode updates will finish
+	 * before we can scan the inode.
+	 */
+	ASSERT(sc->flags & XCHK_FSHOOKS_DIRENTS);
+	xfs_hook_setup(&rd->hooks.delta_hook, xrep_dir_live_update);
+	error = xfs_dirent_hook_add(sc->mp, &rd->hooks);
+	if (error)
+		goto out_scan;
+
 	return 0;
 
+out_scan:
+	xchk_iscan_finish(&rd->iscan);
+	mutex_destroy(&rd->lock);
+	xfblob_destroy(rd->dir_names);
 out_entries:
 	xfarray_destroy(rd->dir_entries);
 	return error;

