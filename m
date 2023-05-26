Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1A7DC77B7A
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 00:59:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbjEZA7n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 20:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjEZA7n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 20:59:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2471612E
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 17:59:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F00E64B7B
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 00:59:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0890FC433EF;
        Fri, 26 May 2023 00:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685062779;
        bh=VCa4C+hCLKIXbiJgeEWN6jGhTCh59du1nGQz1LBjZlk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=p7X2yjoNkUJMJiSP9rTP4NtsLEHrnyqBb1o/O1npEw55tc5sbt85rOJlka8r3WnSn
         rvCHXEGDtuMKPTR2eP4b2MaJwMVY/a9Pp/7P/7ezKuNoDRj4Ll6KwefbtxNV+x1nNZ
         FleIagfgqMX+xui7GpimmqDSiYvn4VuZ7Af5Z2ZJNLc+SGqqd2Gb89MW/+ValaTkTs
         MrQIeBIW/LBB/09c5b2aViVf1IqYzPxkQAXeAh6ZhgoDJdcvb0f7BM0npsEWc6Zgqd
         3o5EzDFR2ki2DovpJz7cLLCl7ZjAJoodB4/+GjQAAz0QefKnt+x4H+yS5YKAi0gy37
         an5DTY8R14LOA==
Date:   Thu, 25 May 2023 17:59:38 -0700
Subject: [PATCH 3/5] xfs: track directory entry updates during live nlinks
 fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <168506060314.3731332.8984120593715734683.stgit@frogsfrogsfrogs>
In-Reply-To: <168506060263.3731332.723936389513300302.stgit@frogsfrogsfrogs>
References: <168506060263.3731332.723936389513300302.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create the necessary hooks in the directory operations
(create/link/unlink/rename) code so that our live nlink scrub code can
stay up to date with link count updates in the rest of the filesystem.
This will be the means to keep our shadow link count information up to
date while the scan runs in real time.

In online fsck part 2, we'll use these same hooks to handle repairs
to directories and parent pointer information.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |    3 +
 fs/xfs/scrub/nlinks.c |  166 ++++++++++++++++++++++++++++++++++---------------
 fs/xfs/scrub/nlinks.h |   11 +++
 fs/xfs/scrub/scrub.c  |    3 +
 fs/xfs/scrub/scrub.h  |    4 +
 fs/xfs/scrub/trace.h  |   33 ++++++++++
 fs/xfs/xfs_inode.c    |  108 ++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h    |   31 +++++++++
 fs/xfs/xfs_mount.h    |    2 +
 fs/xfs/xfs_super.c    |    2 +
 fs/xfs/xfs_symlink.c  |    1 
 11 files changed, 310 insertions(+), 54 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 95626b7b6364..e98d86f74a94 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1299,5 +1299,8 @@ xchk_fsgates_enable(
 	if (scrub_fsgates & XCHK_FSGATES_QUOTA)
 		xfs_dqtrx_hook_enable();
 
+	if (scrub_fsgates & XCHK_FSGATES_DIRENTS)
+		xfs_dir_hook_enable();
+
 	sc->flags |= scrub_fsgates;
 }
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index fde7522eb532..5f608905165e 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -43,8 +43,7 @@ int
 xchk_setup_nlinks(
 	struct xfs_scrub	*sc)
 {
-	/* Not ready for general consumption yet. */
-	return -EOPNOTSUPP;
+	xchk_fsgates_enable(sc, XCHK_FSGATES_DIRENTS);
 
 	sc->buf = kzalloc(sizeof(struct xchk_nlink_ctrs), XCHK_GFP_FLAGS);
 	if (!sc->buf)
@@ -63,27 +62,36 @@ xchk_setup_nlinks(
  * must be taken with certain errno values (i.e. EFSBADCRC, EFSCORRUPTED,
  * ECANCELED) that are absorbed into a scrub state flag update by
  * xchk_*_process_error.
+ *
+ * Because we are scanning a live filesystem, it's possible that another thread
+ * will try to update the link counts for an inode that we've already scanned.
+ * This will cause our counts to be incorrect.  Therefore, we hook all
+ * directory entry updates because that is when link count updates occur.  By
+ * shadowing transaction updates in this manner, live nlink check can ensure by
+ * locking the inode and the shadow structure that its own copies are not out
+ * of date.  Because the hook code runs in a different process context from the
+ * scrub code and the scrub state flags are not accessed atomically, failures
+ * in the hook code must abort the iscan and the scrubber must notice the
+ * aborted scan and set the incomplete flag.
+ *
+ * Note that we use jump labels and srcu notifier hooks to minimize the
+ * overhead when live nlinks is /not/ running.  Locking order for nlink
+ * observations is inode ILOCK -> iscan_lock/xchk_nlink_ctrs lock.
  */
 
-/* Add a delta to an nlink counter, being careful about integer overlow. */
-static inline int
+/*
+ * Add a delta to an nlink counter, being careful about integer overflow.
+ * Clamp the value to U32_MAX because the ondisk format does not handle
+ * link counts any higher.
+ */
+static inline void
 careful_add(
 	xfs_nlink_t	*nlinkp,
 	int		delta)
 {
 	uint64_t	new_value = (uint64_t)(*nlinkp) + delta;
 
-	if (new_value > U32_MAX) {
-		/*
-		 * We found a link count value that is large enough to overflow
-		 * an incore counter.  Cancel this scrub and let userspace know
-		 * that the check was incomplete.
-		 */
-		return -ECANCELED;
-	}
-
-	*nlinkp = new_value;
-	return 0;
+	*nlinkp = min_t(uint64_t, new_value, U32_MAX);
 }
 
 /* Update incore link count information.  Caller must hold the nlinks lock. */
@@ -108,21 +116,9 @@ xchk_nlinks_update_incore(
 	trace_xchk_nlinks_update_incore(xnc->sc->mp, ino, &nl, parents_delta,
 			backrefs_delta, children_delta);
 
-	if (parents_delta) {
-		error = careful_add(&nl.parents, parents_delta);
-		if (error)
-			return error;
-	}
-	if (backrefs_delta) {
-		error = careful_add(&nl.backrefs, backrefs_delta);
-		if (error)
-			return error;
-	}
-	if (children_delta) {
-		error = careful_add(&nl.children, children_delta);
-		if (error)
-			return error;
-	}
+	careful_add(&nl.parents, parents_delta);
+	careful_add(&nl.backrefs, backrefs_delta);
+	careful_add(&nl.children, children_delta);
 
 	nl.flags |= XCHK_NLINK_WRITTEN;
 	error = xfarray_store(xnc->nlinks, ino, &nl);
@@ -137,6 +133,63 @@ xchk_nlinks_update_incore(
 	return error;
 }
 
+/*
+ * Apply a link count change from the regular filesystem into our shadow link
+ * count structure based on a directory update in progress.
+ */
+STATIC int
+xchk_nlinks_live_update(
+	struct notifier_block		*nb,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_dir_update_params	*p = data;
+	struct xchk_nlink_ctrs		*xnc;
+	int				error;
+
+	xnc = container_of(nb, struct xchk_nlink_ctrs, hooks.dirent_hook.nb);
+
+	trace_xchk_nlinks_live_update(xnc->sc->mp, p->dp, action, p->ip->i_ino,
+			p->delta, p->name->name, p->name->len);
+
+	/*
+	 * If we've already scanned @dp, update the number of parents that link
+	 * to @ip.  If @ip is a subdirectory, update the number of child links
+	 * going out of @dp.
+	 */
+	if (xchk_iscan_want_live_update(&xnc->collect_iscan, p->dp->i_ino)) {
+		mutex_lock(&xnc->lock);
+		error = xchk_nlinks_update_incore(xnc, p->ip->i_ino, p->delta,
+				0, 0);
+		if (!error && S_ISDIR(VFS_IC(p->ip)->i_mode))
+			error = xchk_nlinks_update_incore(xnc, p->dp->i_ino, 0,
+					0, p->delta);
+		mutex_unlock(&xnc->lock);
+		if (error)
+			goto out_abort;
+	}
+
+	/*
+	 * If @ip is a subdirectory and we've already scanned it, update the
+	 * number of backrefs pointing to @dp.
+	 */
+	if (S_ISDIR(VFS_IC(p->ip)->i_mode) &&
+	    xchk_iscan_want_live_update(&xnc->collect_iscan, p->ip->i_ino)) {
+		mutex_lock(&xnc->lock);
+		error = xchk_nlinks_update_incore(xnc, p->dp->i_ino, 0,
+				p->delta, 0);
+		mutex_unlock(&xnc->lock);
+		if (error)
+			goto out_abort;
+	}
+
+	return NOTIFY_DONE;
+
+out_abort:
+	xchk_iscan_abort(&xnc->collect_iscan);
+	return NOTIFY_DONE;
+}
+
 /* Bump the observed link count for the inode referenced by this entry. */
 STATIC int
 xchk_nlinks_collect_dirent(
@@ -216,12 +269,11 @@ xchk_nlinks_collect_dirent(
 	}
 
 	/*
-	 * If this dirent is a forward link to a subdirectory or the dot entry,
-	 * increment the number of child links of dp.
+	 * If this dirent is a forward link to a subdirectory, increment the
+	 * number of child links of dp.
 	 */
-	if (!dotdot && name->type == XFS_DIR3_FT_DIR) {
-		error = xchk_nlinks_update_incore(xnc, dp->i_ino, 0, 0,
-				1);
+	if (!dot && !dotdot && name->type == XFS_DIR3_FT_DIR) {
+		error = xchk_nlinks_update_incore(xnc, dp->i_ino, 0, 0, 1);
 		if (error)
 			goto out_unlock;
 	}
@@ -498,13 +550,13 @@ xchk_nlinks_compare_inode(
 	 * entries in this directory, take advantage of the fact that on a
 	 * consistent ftype=0 filesystem, the number of subdirectory
 	 * backreferences (dotdot entries) pointing towards this directory
-	 * should be one less than the number of subdirectory entries in the
+	 * should be equal to the number of subdirectory entries in the
 	 * directory.
 	 */
 	if (!xfs_has_ftype(sc->mp) && S_ISDIR(VFS_I(ip)->i_mode))
-		obs.children = obs.backrefs + 1;
+		obs.children = obs.backrefs;
 
-	total_links = xchk_nlink_total(&obs);
+	total_links = xchk_nlink_total(ip, &obs);
 	actual_nlink = VFS_I(ip)->i_nlink;
 
 	trace_xchk_nlinks_compare_inode(sc->mp, ip, &obs);
@@ -530,16 +582,11 @@ xchk_nlinks_compare_inode(
 		 * The collection phase ignores directories with zero link
 		 * count, so we ignore them here too.
 		 *
-		 * Linked directories must have at least one child (dot entry).
-		 */
-		if (obs.children < 1)
-			xchk_ino_set_corrupt(sc, ip->i_ino);
-		/*
 		 * The number of subdirectory backreferences (dotdot entries)
-		 * pointing towards this directory should be one less than the
+		 * pointing towards this directory should be equal to the
 		 * number of subdirectory entries in the directory.
 		 */
-		if (obs.children != obs.backrefs + 1)
+		if (obs.children != obs.backrefs)
 			xchk_ino_xref_set_corrupt(sc, ip->i_ino);
 	} else {
 		/*
@@ -560,15 +607,12 @@ xchk_nlinks_compare_inode(
 	if (ip == sc->mp->m_rootip) {
 		/*
 		 * For the root of a directory tree, both the '.' and '..'
-		 * entries should point to the root directory.  The dot entry
-		 * is counted as a child subdirectory (like any directory).
-		 * The dotdot entry is counted as a parent of the root /and/
-		 * a backref of the root directory.
+		 * entries should point to the root directory.  The dotdot
+		 * entry is counted as a parent of the root /and/ a backref of
+		 * the root directory.
 		 */
 		if (obs.parents != 1)
 			xchk_ino_set_corrupt(sc, ip->i_ino);
-		if (obs.children < 1)
-			xchk_ino_set_corrupt(sc, ip->i_ino);
 	} else if (actual_nlink > 0) {
 		/*
 		 * Linked files that are not the root directory should have at
@@ -649,7 +693,7 @@ xchk_nlinks_compare_inum(
 	 * If we can't grab the inode, the link count had better be zero.  We
 	 * still hold the AGI to prevent inode allocation/freeing.
 	 */
-	if (xchk_nlink_total(&obs) != 0) {
+	if (xchk_nlink_total(NULL, &obs) != 0) {
 		xchk_ino_set_corrupt(xnc->sc, ino);
 		error = -ECANCELED;
 	}
@@ -763,6 +807,11 @@ xchk_nlinks_teardown_scan(
 {
 	struct xchk_nlink_ctrs	*xnc = priv;
 
+	/* Discourage any hook functions that might be running. */
+	xchk_iscan_abort(&xnc->collect_iscan);
+
+	xfs_dir_hook_del(xnc->sc->mp, &xnc->hooks);
+
 	xfarray_destroy(xnc->nlinks);
 	xnc->nlinks = NULL;
 
@@ -808,6 +857,19 @@ xchk_nlinks_setup_scan(
 	if (error)
 		goto out_teardown;
 
+	/*
+	 * Hook into the directory entry code so that we can capture updates to
+	 * file link counts.  The hook only triggers for inodes that were
+	 * already scanned, and the scanner thread takes each inode's ILOCK,
+	 * which means that any in-progress inode updates will finish before we
+	 * can scan the inode.
+	 */
+	ASSERT(sc->flags & XCHK_FSGATES_DIRENTS);
+	xfs_hook_setup(&xnc->hooks.dirent_hook, xchk_nlinks_live_update);
+	error = xfs_dir_hook_add(mp, &xnc->hooks);
+	if (error)
+		goto out_teardown;
+
 	/* Use deferred cleanup to pass the inode link count data to repair. */
 	sc->buf_cleanup = xchk_nlinks_teardown_scan;
 	return 0;
diff --git a/fs/xfs/scrub/nlinks.h b/fs/xfs/scrub/nlinks.h
index 421c572d304b..34c59075b72c 100644
--- a/fs/xfs/scrub/nlinks.h
+++ b/fs/xfs/scrub/nlinks.h
@@ -22,6 +22,12 @@ struct xchk_nlink_ctrs {
 	 */
 	struct xchk_iscan	collect_iscan;
 	struct xchk_iscan	compare_iscan;
+
+	/*
+	 * Hook into directory updates so that we can receive live updates
+	 * from other writer threads.
+	 */
+	struct xfs_dir_hook	hooks;
 };
 
 /*
@@ -80,10 +86,13 @@ struct xchk_nlink {
 
 /* Compute total link count, using large enough variables to detect overflow. */
 static inline uint64_t
-xchk_nlink_total(const struct xchk_nlink *live)
+xchk_nlink_total(struct xfs_inode *ip, const struct xchk_nlink *live)
 {
 	uint64_t	ret = live->parents;
 
+	/* Add one link count for the dot entry of any linked directory. */
+	if (ip && S_ISDIR(VFS_I(ip)->i_mode) && VFS_I(ip)->i_nlink)
+		ret++;
 	return ret + live->children;
 }
 
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 4baa3972c6c4..244fa9157d71 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -161,6 +161,9 @@ xchk_fsgates_disable(
 	if (sc->flags & XCHK_FSGATES_QUOTA)
 		xfs_dqtrx_hook_disable();
 
+	if (sc->flags & XCHK_FSGATES_DIRENTS)
+		xfs_dir_hook_disable();
+
 	sc->flags &= ~XCHK_FSGATES_ALL;
 }
 
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index 002edeca3539..99b48e996d51 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -121,6 +121,7 @@ struct xfs_scrub {
 #define XCHK_FSGATES_DRAIN	(1 << 2)  /* defer ops draining enabled */
 #define XCHK_NEED_DRAIN		(1 << 3)  /* scrub needs to drain defer ops */
 #define XCHK_FSGATES_QUOTA	(1 << 4)  /* quota live update enabled */
+#define XCHK_FSGATES_DIRENTS	(1 << 5)  /* directory live update enabled */
 #define XREP_RESET_PERAG_RESV	(1 << 30) /* must reset AG space reservation */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
@@ -131,7 +132,8 @@ struct xfs_scrub {
  * must be enabled during scrub setup and can only be torn down afterwards.
  */
 #define XCHK_FSGATES_ALL	(XCHK_FSGATES_DRAIN | \
-				 XCHK_FSGATES_QUOTA)
+				 XCHK_FSGATES_QUOTA | \
+				 XCHK_FSGATES_DIRENTS)
 
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 3c835826c42e..0870edd76a5e 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -114,6 +114,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_NLINKS);
 	{ XCHK_FSGATES_DRAIN,			"fsgates_drain" }, \
 	{ XCHK_NEED_DRAIN,			"need_drain" }, \
 	{ XCHK_FSGATES_QUOTA,			"fsgates_quota" }, \
+	{ XCHK_FSGATES_DIRENTS,			"fsgates_dirents" }, \
 	{ XREP_RESET_PERAG_RESV,		"reset_perag_resv" }, \
 	{ XREP_ALREADY_FIXED,			"already_fixed" }
 
@@ -1229,6 +1230,38 @@ TRACE_EVENT(xchk_nlinks_collect_metafile,
 		  __entry->ino)
 );
 
+TRACE_EVENT(xchk_nlinks_live_update,
+	TP_PROTO(struct xfs_mount *mp, const struct xfs_inode *dp,
+		 int action, xfs_ino_t ino, int delta,
+		 const char *name, unsigned int namelen),
+	TP_ARGS(mp, dp, action, ino, delta, name, namelen),
+	TP_STRUCT__entry(
+		__field(dev_t, dev)
+		__field(xfs_ino_t, dir)
+		__field(int, action)
+		__field(xfs_ino_t, ino)
+		__field(int, delta)
+		__field(unsigned int, namelen)
+		__dynamic_array(char, name, namelen)
+	),
+	TP_fast_assign(
+		__entry->dev = mp->m_super->s_dev;
+		__entry->dir = dp ? dp->i_ino : NULLFSINO;
+		__entry->action = action;
+		__entry->ino = ino;
+		__entry->delta = delta;
+		__entry->namelen = namelen;
+		memcpy(__get_str(name), name, namelen);
+	),
+	TP_printk("dev %d:%d dir 0x%llx ino 0x%llx nlink_delta %d name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dir,
+		  __entry->ino,
+		  __entry->delta,
+		  __entry->namelen,
+		  __get_str(name))
+);
+
 TRACE_EVENT(xchk_nlinks_check_zero,
 	TP_PROTO(struct xfs_mount *mp, xfs_ino_t ino,
 		 const struct xchk_nlink *live),
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index e259693e683f..60f764d665c6 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -938,6 +938,72 @@ xfs_bumplink(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
+#ifdef CONFIG_XFS_LIVE_HOOKS
+/*
+ * Use a static key here to reduce the overhead of directory live update hooks.
+ * If the compiler supports jump labels, the static branch will be replaced by
+ * a nop sled when there are no hook users.  Online fsck is currently the only
+ * caller, so this is a reasonable tradeoff.
+ *
+ * Note: Patching the kernel code requires taking the cpu hotplug lock.  Other
+ * parts of the kernel allocate memory with that lock held, which means that
+ * XFS callers cannot hold any locks that might be used by memory reclaim or
+ * writeback when calling the static_branch_{inc,dec} functions.
+ */
+DEFINE_STATIC_XFS_HOOK_SWITCH(xfs_dir_hooks_switch);
+
+void
+xfs_dir_hook_disable(void)
+{
+	xfs_hooks_switch_off(&xfs_dir_hooks_switch);
+}
+
+void
+xfs_dir_hook_enable(void)
+{
+	xfs_hooks_switch_on(&xfs_dir_hooks_switch);
+}
+
+/* Call hooks for a directory update relating to a child dirent update. */
+inline void
+xfs_dir_update_hook(
+	struct xfs_inode		*dp,
+	struct xfs_inode		*ip,
+	int				delta,
+	const struct xfs_name		*name)
+{
+	if (xfs_hooks_switched_on(&xfs_dir_hooks_switch)) {
+		struct xfs_dir_update_params	p = {
+			.dp		= dp,
+			.ip		= ip,
+			.delta		= delta,
+			.name		= name,
+		};
+		struct xfs_mount	*mp = ip->i_mount;
+
+		xfs_hooks_call(&mp->m_dir_update_hooks, 0, &p);
+	}
+}
+
+/* Call the specified function during a directory update. */
+int
+xfs_dir_hook_add(
+	struct xfs_mount	*mp,
+	struct xfs_dir_hook	*hook)
+{
+	return xfs_hooks_add(&mp->m_dir_update_hooks, &hook->dirent_hook);
+}
+
+/* Stop calling the specified function during a directory update. */
+void
+xfs_dir_hook_del(
+	struct xfs_mount	*mp,
+	struct xfs_dir_hook	*hook)
+{
+	xfs_hooks_del(&mp->m_dir_update_hooks, &hook->dirent_hook);
+}
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 int
 xfs_create(
 	struct mnt_idmap	*idmap,
@@ -1046,6 +1112,12 @@ xfs_create(
 		xfs_bumplink(tp, dp);
 	}
 
+	/*
+	 * Create ip with a reference from dp, and add '.' and '..' references
+	 * if it's a directory.
+	 */
+	xfs_dir_update_hook(dp, ip, 1, name);
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * create transaction goes to disk before returning to
@@ -1258,6 +1330,7 @@ xfs_link(
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
 	xfs_bumplink(tp, sip);
+	xfs_dir_update_hook(tdp, sip, 1, target_name);
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -2486,6 +2559,12 @@ xfs_remove(
 		goto out_trans_cancel;
 	}
 
+	/*
+	 * Drop the link from dp to ip, and if ip was a directory, remove the
+	 * '.' and '..' references since we freed the directory.
+	 */
+	xfs_dir_update_hook(dp, ip, -1, name);
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2676,6 +2755,20 @@ xfs_cross_rename(
 	}
 	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
+
+	/*
+	 * Inform our hook clients that we've finished an exchange operation as
+	 * follows: removed the source and target files from their directories;
+	 * added the target to the source directory; and added the source to
+	 * the target directory.  All inodes are locked, so it's ok to model a
+	 * rename this way so long as we say we deleted entries before we add
+	 * new ones.
+	 */
+	xfs_dir_update_hook(dp1, ip1, -1, name1);
+	xfs_dir_update_hook(dp2, ip2, -1, name2);
+	xfs_dir_update_hook(dp1, ip2, 1, name1);
+	xfs_dir_update_hook(dp2, ip1, 1, name2);
+
 	return xfs_finish_rename(tp);
 
 out_trans_abort:
@@ -3059,6 +3152,21 @@ xfs_rename(
 	if (new_parent)
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
+	/*
+	 * Inform our hook clients that we've finished a rename operation as
+	 * follows: removed the source and target files from their directories;
+	 * that we've added the source to the target directory; and finally
+	 * that we've added the whiteout, if there was one.  All inodes are
+	 * locked, so it's ok to model a rename this way so long as we say we
+	 * deleted entries before we add new ones.
+	 */
+	if (target_ip)
+		xfs_dir_update_hook(target_dp, target_ip, -1, target_name);
+	xfs_dir_update_hook(src_dp, src_ip, -1, src_name);
+	xfs_dir_update_hook(target_dp, src_ip, 1, target_name);
+	if (wip)
+		xfs_dir_update_hook(src_dp, wip, 1, src_name);
+
 	error = xfs_finish_rename(tp);
 	if (wip)
 		xfs_irele(wip);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 998af9e4e3dd..f80f4761892a 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -153,6 +153,12 @@ static inline struct inode *VFS_I(struct xfs_inode *ip)
 	return &ip->i_vnode;
 }
 
+/* convert from const xfs inode to const vfs inode */
+static inline const struct inode *VFS_IC(const struct xfs_inode *ip)
+{
+	return &ip->i_vnode;
+}
+
 /*
  * For regular files we only update the on-disk filesize when actually
  * writing data back to disk.  Until then only the copy in the VFS inode
@@ -578,4 +584,29 @@ void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_inode_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_filblks_t *dblocks, xfs_filblks_t *rblocks);
 
+struct xfs_dir_update_params {
+	const struct xfs_inode	*dp;
+	const struct xfs_inode	*ip;
+	const struct xfs_name	*name;
+	int			delta;
+};
+
+#ifdef CONFIG_XFS_LIVE_HOOKS
+void xfs_dir_update_hook(struct xfs_inode *dp, struct xfs_inode *ip,
+		int delta, const struct xfs_name *name);
+
+struct xfs_dir_hook {
+	struct xfs_hook		dirent_hook;
+};
+
+void xfs_dir_hook_disable(void);
+void xfs_dir_hook_enable(void);
+
+int xfs_dir_hook_add(struct xfs_mount *mp, struct xfs_dir_hook *hook);
+void xfs_dir_hook_del(struct xfs_mount *mp, struct xfs_dir_hook *hook);
+
+#else
+# define xfs_dir_update_hook(dp, ip, delta, name)	((void)0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index aaaf5ec13492..fc8d4de55cd1 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -244,6 +244,8 @@ typedef struct xfs_mount {
 	unsigned int		*m_errortag;
 	struct xfs_kobj		m_errortag_kobj;
 #endif
+	/* Hook to feed dirent updates to an active online repair. */
+	struct xfs_hooks	m_dir_update_hooks;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 83930f24ab48..67ebb9d5ed21 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1966,6 +1966,8 @@ static int xfs_init_fs_context(
 	mp->m_logbsize = -1;
 	mp->m_allocsize_log = 16; /* 64k */
 
+	xfs_hooks_init(&mp->m_dir_update_hooks);
+
 	/*
 	 * Copy binary VFS mount flags we are interested in.
 	 */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 85e433df6a3f..bfe81cb50c46 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -319,6 +319,7 @@ xfs_symlink(
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+	xfs_dir_update_hook(dp, ip, 1, link_name);
 
 	/*
 	 * If this is a synchronous mount, make sure that the

