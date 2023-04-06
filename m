Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFAB2C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjDFT06 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:26:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236612AbjDFT05 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:26:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA106E82
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:26:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 44853644B7
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:26:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3853C433EF;
        Thu,  6 Apr 2023 19:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809214;
        bh=1xhgTle3q4G7L7vousn6l2/1AeAZvVpp4joJcfEjY1I=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=RcgmXjNr6i5t5Ce+xquFckyQjdMFKylAVFunZqrjKTdoVHBBunnCOnapGqhZiWMlJ
         sHQLdb/RIoijbZwEUK0RCIsf/8KnnM6n3TwGRfWNnJKKR1xTgqTvqhOQisnKcMfG+g
         hU88BpFkiNgFN9+vqtSJ+C++TdERt6ynJAGsHZkKlgvQexYE5RueesCdJebGpC/c0D
         hvegKD5xHo3MXidgIyOm9jgYcz8I1v7SZKXGwma+1cKakp1/SCWy67YOnEx0F3unjU
         +/cbV+MpcSAwJchAttgcIIyLznYLWznb9dIMpzDgjqSsUKjLu51FZfNQhpFg8ua0zN
         ShGJ1q/ltgANw==
Date:   Thu, 06 Apr 2023 12:26:54 -0700
Subject: [PATCH 2/3] xfs: add hooks to do directory updates
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080825309.615785.18004899715979653929.stgit@frogsfrogsfrogs>
In-Reply-To: <168080825278.615785.11418750801629760336.stgit@frogsfrogsfrogs>
References: <168080825278.615785.11418750801629760336.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_dir2.c  |    2 +
 fs/xfs/libxfs/xfs_dir2.h  |    2 +
 fs/xfs/scrub/dir_repair.c |   90 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 92 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index a73573d47b13..825a8cd9ee57 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -435,7 +435,7 @@ int
 xfs_dir_removename(
 	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
-	struct xfs_name		*name,
+	const struct xfs_name	*name,
 	xfs_ino_t		ino,
 	xfs_extlen_t		total)		/* bmap's total block count */
 {
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 15a36cf7ae87..d394bcd5e82c 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -46,7 +46,7 @@ extern int xfs_dir_lookup(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t *inum,
 				struct xfs_name *ci_name);
 extern int xfs_dir_removename(struct xfs_trans *tp, struct xfs_inode *dp,
-				struct xfs_name *name, xfs_ino_t ino,
+				const struct xfs_name *name, xfs_ino_t ino,
 				xfs_extlen_t tot);
 extern int xfs_dir_replace(struct xfs_trans *tp, struct xfs_inode *dp,
 				const struct xfs_name *name, xfs_ino_t inum,
diff --git a/fs/xfs/scrub/dir_repair.c b/fs/xfs/scrub/dir_repair.c
index a1f2bca53655..c484e6f36ca0 100644
--- a/fs/xfs/scrub/dir_repair.c
+++ b/fs/xfs/scrub/dir_repair.c
@@ -121,6 +121,9 @@ struct xrep_dir {
 	/* Mutex protecting dir_entries, dir_names, and parent_ino. */
 	struct mutex		lock;
 
+	/* Hook to capture directory entry updates. */
+	struct xfs_dirent_hook	hooks;
+
 	/*
 	 * This is the dotdot inumber that we're going to set on the
 	 * reconstructed directory.
@@ -138,6 +141,7 @@ xrep_dir_teardown(
 {
 	struct xrep_dir		*rd = sc->buf;
 
+	xfs_dirent_hook_del(sc->mp, &rd->hooks);
 	xchk_iscan_teardown(&rd->iscan);
 	mutex_destroy(&rd->lock);
 	xfblob_destroy(rd->dir_names);
@@ -152,6 +156,8 @@ xrep_setup_directory(
 	struct xrep_dir		*rd;
 	int			error;
 
+	xchk_fshooks_enable(sc, XCHK_FSHOOKS_DIRENTS);
+
 	error = xrep_tempfile_create(sc, S_IFDIR);
 	if (error)
 		return error;
@@ -899,6 +905,74 @@ xrep_dir_rebuild_tree(
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
+	/*
+	 * This thread updated a child dirent in the directory that we're
+	 * rebuilding.  Stash the update for replay against the temporary
+	 * directory.
+	 */
+	if (action == XFS_DIRENT_CHILD_DELTA &&
+	    p->dp->i_ino == sc->ip->i_ino &&
+	    xchk_iscan_want_live_update(&rd->iscan, p->ip->i_ino)) {
+		mutex_lock(&rd->lock);
+		if (p->delta > 0)
+			error = xrep_dir_add_dirent(rd, p->name, p->ip->i_ino);
+		else
+			error = xrep_dir_remove_dirent(rd, p->name,
+					p->ip->i_ino);
+		mutex_unlock(&rd->lock);
+		if (error)
+			goto out_abort;
+	}
+
+	/*
+	 * This thread updated another directory's child dirent that points to
+	 * the directory that we're rebuilding, so remember the new dotdot
+	 * target.
+	 */
+	if (action == XFS_DIRENT_BACKREF_DELTA &&
+	    p->ip->i_ino == sc->ip->i_ino &&
+	    xchk_iscan_want_live_update(&rd->iscan, p->dp->i_ino)) {
+		if (p->delta > 0) {
+			trace_xrep_dir_add_dirent(sc->tempip, &xfs_name_dotdot,
+					p->dp->i_ino);
+
+			mutex_lock(&rd->lock);
+			rd->parent_ino = p->dp->i_ino;
+			mutex_unlock(&rd->lock);
+		} else {
+			trace_xrep_dir_remove_dirent(sc->tempip,
+					&xfs_name_dotdot, NULLFSINO);
+
+			mutex_lock(&rd->lock);
+			rd->parent_ino = NULLFSINO;
+			mutex_unlock(&rd->lock);
+		}
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
@@ -921,8 +995,24 @@ xrep_dir_setup_scan(
 	/* Retry iget every tenth of a second for up to 30 seconds. */
 	xchk_iscan_start(sc, 30000, 100, &rd->iscan);
 
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
+	xchk_iscan_teardown(&rd->iscan);
+	mutex_destroy(&rd->lock);
+	xfblob_destroy(rd->dir_names);
 out_entries:
 	xfarray_destroy(rd->dir_entries);
 	return error;

