Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 231B4C7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:28:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229610AbjDFT2P (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:28:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjDFT2O (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:28:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B5DC3
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:28:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 18CFF64AD2
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A60FC433EF;
        Thu,  6 Apr 2023 19:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809292;
        bh=cMVIVPC9cEuJ5RWzoH3K8KhdbYU9YPJE/25jFJs/Ljk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=tdLksaYtyCOTINHcuFHuBAeLPaOzYGvws+IGF9f2pAwP3E65EQ4IodRYC8dH3sVy3
         Da4EnIC9rg8TQHUXed2QgPlFoEzA1vi4KiW7UzxrbQM9LryBLl4i1rjJ1eTUV/AS3S
         2uKsfXxotxl6wXJY9/k7p00JJXi3JRoTTAlXKsdvkTOsdglst9smhzAV7l+sHL6csm
         /vljT0DkZqKkV6ZjojzJ50j0OK9LRS69v+q3gMO5wz9cWgxZxJ0nU0fMHs6mV+7WsJ
         xbDtGCpR+gFa3zXN3kJnwoBooiM5bpRdRan67ka3RCSK+iAbYu4sG+qEwSWmvDlu1S
         UvQzyRua5qPtg==
Date:   Thu, 06 Apr 2023 12:28:12 -0700
Subject: [PATCH 2/3] xfs: repair parent pointers with live scan hooks
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080825984.616003.8681337233162585710.stgit@frogsfrogsfrogs>
In-Reply-To: <168080825953.616003.8753146482699125345.stgit@frogsfrogsfrogs>
References: <168080825953.616003.8753146482699125345.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_parent.c   |   19 ++++++++
 fs/xfs/libxfs/xfs_parent.h   |    4 ++
 fs/xfs/scrub/parent_repair.c |  100 ++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/trace.h         |    2 +
 4 files changed, 125 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_parent.c b/fs/xfs/libxfs/xfs_parent.c
index 59fe4181bedd..bf3989f519cd 100644
--- a/fs/xfs/libxfs/xfs_parent.c
+++ b/fs/xfs/libxfs/xfs_parent.c
@@ -375,3 +375,22 @@ xfs_parent_set(
 
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
+	xfs_parent_irec_to_disk(&scr->rec, pptr);
+	xfs_parent_scratch_init(NULL, ip, pptr, scr);
+	scr->args.op_flags |= XFS_DA_OP_REMOVE;
+
+	return xfs_attr_set(&scr->args);
+}
diff --git a/fs/xfs/libxfs/xfs_parent.h b/fs/xfs/libxfs/xfs_parent.h
index da8dc689221c..b4f45803ebf5 100644
--- a/fs/xfs/libxfs/xfs_parent.h
+++ b/fs/xfs/libxfs/xfs_parent.h
@@ -115,4 +115,8 @@ int xfs_parent_set(struct xfs_inode *ip,
 		const struct xfs_parent_name_irec *pptr,
 		struct xfs_parent_scratch *scratch);
 
+int xfs_parent_unset(struct xfs_inode *ip,
+		const struct xfs_parent_name_irec *rec,
+		struct xfs_parent_scratch *scratch);
+
 #endif	/* __XFS_PARENT_H__ */
diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 30d2a81e4df2..293d9e931018 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -118,6 +118,9 @@ struct xrep_pptrs {
 	/* Mutex protecting parent_ptrs, pptr_names. */
 	struct mutex		lock;
 
+	/* Hook to capture directory entry updates. */
+	struct xfs_dirent_hook	hooks;
+
 	/* Stashed parent pointer updates. */
 	struct xfarray		*parent_ptrs;
 
@@ -130,6 +133,7 @@ static void
 xrep_pptr_teardown(
 	struct xrep_pptrs	*rp)
 {
+	xfs_dirent_hook_del(rp->sc->mp, &rp->hooks);
 	xchk_iscan_teardown(&rp->iscan);
 	mutex_destroy(&rp->lock);
 	xfblob_destroy(rp->pptr_names);
@@ -144,6 +148,8 @@ xrep_setup_parent(
 	struct xrep_pptrs	*rp;
 	int			error;
 
+	xchk_fshooks_enable(sc, XCHK_FSHOOKS_DIRENTS);
+
 	error = xrep_tempfile_create(sc, S_IFREG);
 	if (error)
 		return error;
@@ -184,6 +190,12 @@ xrep_pptr_replay_update(
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
@@ -265,6 +277,34 @@ xrep_pptr_add_pointer(
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
+	const struct xfs_inode	*dp)
+{
+	struct xrep_pptr	pptr = {
+		.action		= XREP_PPTR_REMOVE,
+		.namelen	= name->len,
+		.p_ino		= dp->i_ino,
+		.p_gen		= VFS_IC(dp)->i_generation,
+	};
+	int			error;
+
+	trace_xrep_pptr_remove_pointer(rp->sc->tempip, dp, name);
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
@@ -553,6 +593,50 @@ xrep_pptr_rebuild_tree(
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
+			error = xrep_pptr_add_pointer(rp, p->name, p->dp);
+		else
+			error = xrep_pptr_remove_pointer(rp, p->name, p->dp);
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
@@ -576,8 +660,24 @@ xrep_pptr_setup_scan(
 	/* Retry iget every tenth of a second for up to 30 seconds. */
 	xchk_iscan_start(sc, 30000, 100, &rp->iscan);
 
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
+	xchk_iscan_teardown(&rp->iscan);
+	mutex_destroy(&rp->lock);
+	xfblob_destroy(rp->pptr_names);
 out_entries:
 	xfarray_destroy(rp->parent_ptrs);
 	return error;
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index caf8d343926e..5b070c177d48 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1372,6 +1372,7 @@ DEFINE_EVENT(xrep_pptr_class, name, \
 	TP_PROTO(struct xfs_inode *ip, const struct xfs_parent_name_irec *pptr), \
 	TP_ARGS(ip, pptr))
 DEFINE_XREP_PPTR_CLASS(xrep_pptr_createname);
+DEFINE_XREP_PPTR_CLASS(xrep_pptr_removename);
 DEFINE_XREP_PPTR_CLASS(xrep_pptr_dumpname);
 
 DECLARE_EVENT_CLASS(xrep_pptr_scan_class,
@@ -1408,6 +1409,7 @@ DEFINE_EVENT(xrep_pptr_scan_class, name, \
 		 const struct xfs_name *name), \
 	TP_ARGS(ip, dp, name))
 DEFINE_XREP_PPTR_SCAN_CLASS(xrep_pptr_add_pointer);
+DEFINE_XREP_PPTR_SCAN_CLASS(xrep_pptr_remove_pointer);
 
 #endif /* IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR) */
 

