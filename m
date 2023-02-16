Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E41EFC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjBPUuo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:50:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbjBPUun (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:50:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215334BEA8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:50:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3AA4B826BA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:50:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929E6C4339B;
        Thu, 16 Feb 2023 20:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580639;
        bh=BjXskKv6etkdv7OMYrD8YZlpMK0atoJeGGQq6hZuloU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=ReyhUynvCAKwaBMzvrK1on60VD9QH3Vgdwlg7YCmXLQC/OXMfHebSMFiqzBz1/6Vy
         LRJSfLURJlN4QFMZrfKTx2eibuuxhmLI9dZ+UlcG/llzJqvD9s/sHnXrin1JTUBS5H
         5GVYg2J40Bv+NR7gPOigs0cCx1SsRjHNinY+GNyC1AqTlUa4K3PqxS/uU928uA5Cx/
         shzzltbSP48u6XaMEXKeMK/mW5B78CiDjKYgdoXJ6wc7WzIr7DoJcBvz7trahSj0hM
         ZrUwYxbaLfRPeH36FCqech4jiw70wR9hIekZwwGoR+LK8gxBii+C9Bb/bZ/KVG2Lzd
         2qaxb2rj27TeA==
Date:   Thu, 16 Feb 2023 12:50:39 -0800
Subject: [PATCH 2/3] xfs: repair parent pointers with live scan hooks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657875226.3475204.3377228223242591216.stgit@magnolia>
In-Reply-To: <167657875195.3475204.16384027586557102765.stgit@magnolia>
References: <167657875195.3475204.16384027586557102765.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use the nlink hooks to keep our tempfile's parent pointers up to date.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_parent.c   |   25 ++++++++++
 fs/xfs/libxfs/xfs_parent.h   |    4 ++
 fs/xfs/scrub/parent_repair.c |  110 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h         |    2 +
 4 files changed, 141 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 5f07bd3debee..a2575bf44c89 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -363,3 +363,28 @@ xfs_parent_set(
 
 	return xfs_attr_set(&scr->args);
 }
+
+/*
+ * Remove the parent pointer (@rec -> @name) from @ip immediately.  Caller must
+ * not have a transaction or hold the ILOCK.  The update will not use logged
+ * xattrs.  This is for specialized repair functions only.  The scratchpad need
+ * not be initialized.
+ */
+int
+xfs_parent_unset(
+	struct xfs_inode		*ip,
+	const struct xfs_parent_name_irec *pptr,
+	struct xfs_parent_scratch	*scr)
+{
+	xfs_parent_irec_to_disk(&scr->rec, NULL, NULL, pptr);
+
+	memset(&scr->args, 0, sizeof(struct xfs_da_args));
+	scr->args.attr_filter	= XFS_ATTR_PARENT;
+	scr->args.dp		= ip;
+	scr->args.geo		= ip->i_mount->m_attr_geo;
+	scr->args.name		= (const unsigned char *)&scr->rec;
+	scr->args.namelen	= sizeof(struct xfs_parent_name_rec);
+	scr->args.whichfork	= XFS_ATTR_FORK;
+
+	return xfs_attr_set(&scr->args);
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index effbccdf6b0e..a7fc621b82c4 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -117,4 +117,8 @@ int xfs_parent_set(struct xfs_inode *ip,
 		const struct xfs_parent_name_irec *pptr,
 		struct xfs_parent_scratch *scratch);
 
+int xfs_parent_unset(struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *rec,
+		struct xfs_parent_scratch *scratch);
+
 #endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index d80d1a466c02..4aec32081c6d 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -119,6 +119,9 @@ struct xrep_pptrs {
 	/* Mutex protecting parent_ptrs, pptr_names. */
 	struct mutex		lock;
 
+	/* Hook to capture directory entry updates. */
+	struct xfs_dirent_hook	hooks;
+
 	/* Stashed parent pointer updates. */
 	struct xfarray		*parent_ptrs;
 
@@ -131,6 +134,7 @@ static void
 xrep_pptr_teardown(
 	struct xrep_pptrs	*rp)
 {
+	xfs_dirent_hook_del(rp->sc->mp, &rp->hooks);
 	xchk_iscan_finish(&rp->iscan);
 	mutex_destroy(&rp->lock);
 	xfblob_destroy(rp->pptr_names);
@@ -145,6 +149,8 @@ xrep_setup_parent(
 	struct xrep_pptrs	*rp;
 	int			error;
 
+	xchk_fshooks_enable(sc, XCHK_FSHOOKS_DIRENTS);
+
 	error = xrep_tempfile_create(sc, S_IFREG);
 	if (error)
 		return error;
@@ -185,6 +191,12 @@ xrep_pptr_replay_update(
 		trace_xrep_pptr_createname(sc->tempip, &rp->pptr);
 
 		return xfs_parent_set(sc->tempip, &rp->pptr, &rp->pptr_scratch);
+	} else if (pptr->action == XREP_PPTR_REMOVE) {
+		/* Remove parent pointer. */
+		trace_xrep_pptr_removename(sc->tempip, &rp->pptr);
+
+		return xfs_parent_unset(sc->tempip, &rp->pptr,
+				&rp->pptr_scratch);
 	}
 
 	ASSERT(0);
@@ -268,6 +280,36 @@ xrep_pptr_add_pointer(
 	return xfarray_append(rp->parent_ptrs, &pptr);
 }
 
+/*
+ * Remember that we want to remove a parent pointer from the tempfile.  These
+ * stashed actions will be replayed later.
+ */
+STATIC int
+xrep_pptr_remove_pointer(
+	struct xrep_pptrs	*rp,
+	const struct xfs_name	*name,
+	const struct xfs_inode	*dp,
+	xfs_dir2_dataptr_t	diroffset)
+{
+	struct xrep_pptr	pptr = {
+		.action		= XREP_PPTR_REMOVE,
+		.namelen	= name->len,
+		.p_ino		= dp->i_ino,
+		.p_gen		= VFS_IC(dp)->i_generation,
+		.p_diroffset	= diroffset,
+	};
+	int			error;
+
+	trace_xrep_pptr_remove_pointer(rp->sc->tempip, dp, diroffset, name);
+
+	error = xfblob_store(rp->pptr_names, &pptr.name_cookie, name->name,
+			name->len);
+	if (error)
+		return error;
+
+	return xfarray_append(rp->parent_ptrs, &pptr);
+}
+
 /*
  * Examine an entry of a directory.  If this dirent leads us back to the file
  * whose parent pointers we're rebuilding, add a pptr to the temporary
@@ -500,6 +542,12 @@ xrep_pptr_rebuild_tree(
 	if (error)
 		return error;
 
+	/*
+	 * Abort the inode scan so that the live hooks won't stash any more
+	 * directory updates.
+	 */
+	xchk_iscan_abort(&rp->iscan);
+
 	error = xrep_pptr_replay_updates(rp);
 	if (error)
 		return error;
@@ -522,6 +570,52 @@ xrep_pptr_rebuild_tree(
 	return xchk_xattr_walk(sc, sc->tempip, xrep_pptr_dump_tempptr, rp);
 }
 
+/*
+ * Capture dirent updates being made by other threads which are relevant to the
+ * file being repaired.
+ */
+STATIC int
+xrep_pptr_live_update(
+	struct notifier_block		*nb,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_dirent_update_params	*p = data;
+	struct xrep_pptrs		*rp;
+	struct xfs_scrub		*sc;
+	int				error;
+
+	rp = container_of(nb, struct xrep_pptrs, hooks.delta_hook.nb);
+	sc = rp->sc;
+
+	if (action != XFS_DIRENT_CHILD_DELTA)
+		return NOTIFY_DONE;
+
+	/*
+	 * This thread updated a dirent that points to the file that we're
+	 * repairing, so stash the update for replay against the temporary
+	 * file.
+	 */
+	if (p->ip->i_ino == sc->ip->i_ino &&
+	    xchk_iscan_want_live_update(&rp->iscan, p->dp->i_ino)) {
+		mutex_lock(&rp->lock);
+		if (p->delta > 0)
+			error = xrep_pptr_add_pointer(rp, p->name, p->dp,
+					p->diroffset);
+		else
+			error = xrep_pptr_remove_pointer(rp, p->name, p->dp,
+					p->diroffset);
+		mutex_unlock(&rp->lock);
+		if (error)
+			goto out_abort;
+	}
+
+	return NOTIFY_DONE;
+out_abort:
+	xchk_iscan_abort(&rp->iscan);
+	return NOTIFY_DONE;
+}
+
 /* Set up the filesystem scan so we can look for pptrs. */
 STATIC int
 xrep_pptr_setup_scan(
@@ -545,8 +639,24 @@ xrep_pptr_setup_scan(
 	/* Retry iget every tenth of a second for up to 30 seconds. */
 	xchk_iscan_start(&rp->iscan, 30000, 100);
 
+	/*
+	 * Hook into the dirent update code.  The hook only operates on inodes
+	 * that were already scanned, and the scanner thread takes each inode's
+	 * ILOCK, which means that any in-progress inode updates will finish
+	 * before we can scan the inode.
+	 */
+	ASSERT(sc->flags & XCHK_FSHOOKS_DIRENTS);
+	xfs_hook_setup(&rp->hooks.delta_hook, xrep_pptr_live_update);
+	error = xfs_dirent_hook_add(sc->mp, &rp->hooks);
+	if (error)
+		goto out_scan;
+
 	return 0;
 
+out_scan:
+	xchk_iscan_finish(&rp->iscan);
+	mutex_destroy(&rp->lock);
+	xfblob_destroy(rp->pptr_names);
 out_entries:
 	xfarray_destroy(rp->parent_ptrs);
 	return error;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 1fb9832a113a..283a1cedf368 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1354,6 +1354,7 @@ DEFINE_EVENT(xrep_pptr_class, name, \
 	TP_PROTO(struct xfs_inode *ip, const struct xfs_parent_name_irec *pptr), \
 	TP_ARGS(ip, pptr))
 DEFINE_XREP_PPTR_CLASS(xrep_pptr_createname);
+DEFINE_XREP_PPTR_CLASS(xrep_pptr_removename);
 DEFINE_XREP_PPTR_CLASS(xrep_pptr_dumpname);
 
 DECLARE_EVENT_CLASS(xrep_pptr_scan_class,
@@ -1393,6 +1394,7 @@ DEFINE_EVENT(xrep_pptr_scan_class, name, \
 		 unsigned int diroffset, const struct xfs_name *name), \
 	TP_ARGS(ip, dp, diroffset, name))
 DEFINE_XREP_PPTR_SCAN_CLASS(xrep_pptr_add_pointer);
+DEFINE_XREP_PPTR_SCAN_CLASS(xrep_pptr_remove_pointer);
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 

