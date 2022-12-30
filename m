Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 212A4C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:36:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235576AbiL3Xga (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:36:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235574AbiL3Xg3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:36:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFC4A46C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:36:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05353B81D97
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:36:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB94C433EF;
        Fri, 30 Dec 2022 23:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672443384;
        bh=OJg6P45MfTCN9Jbwr0OChdeD+hpZ2zBPRlYHwWwLevw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Q76NH8BMyAcv9UZ2Ek/PuQljlIDpywEFAiReCKiD/dLNTce5hdVp2cZY2CqaUWQ7G
         hJIreSJAp3Bd/RXSLWI6dKpqjwjqpPz9r6VNApM0FAGd95gVRht6Qbh6pVcZLupWxQ
         3AJ9oDkyqt2InpCchQSIet2ryUVHypRdeaFfNhPf1b+wucWT75ZSY5vSpSVHUdtLED
         vlfdriTx/djAaRSFTbZx8RgwENykSWY0/XjS7xOaFzUSskY5Pe2PMuKwnlNy32a+u+
         uTFOmJPzXKOltSMbpdDgNPUgC4jgm2NFMu0cr+TYl1ZOvQNXRo/Wdr+eHYLqqDEZYJ
         YkVgsh1zK1E8w==
Subject: [PATCH 4/5] xfs: track file link count updates during live nlinks
 fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:13:11 -0800
Message-ID: <167243839126.695835.5384912207839415316.stgit@magnolia>
In-Reply-To: <167243839062.695835.16105316950703126803.stgit@magnolia>
References: <167243839062.695835.16105316950703126803.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Create the necessary hooks in the file create/unlink/rename code so that
our live nlink scrub code can stay up to date with the rest of the
filesystem.  This will be the means to keep our shadow link count
information up to date while the scan runs in real time.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/common.c |    3 +
 fs/xfs/scrub/nlinks.c |  120 ++++++++++++++++++++++++++++
 fs/xfs/scrub/nlinks.h |    6 +
 fs/xfs/scrub/scrub.c  |    3 +
 fs/xfs/scrub/scrub.h  |    4 +
 fs/xfs/scrub/trace.h  |   43 ++++++++++
 fs/xfs/xfs_inode.c    |  210 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h    |   35 ++++++++
 fs/xfs/xfs_mount.h    |    2 
 fs/xfs/xfs_super.c    |    2 
 fs/xfs/xfs_symlink.c  |    1 
 11 files changed, 426 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 9f418e30f5a3..ef2dd59d0ac9 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -1287,5 +1287,8 @@ xchk_fshooks_enable(
 	if (scrub_fshooks & XCHK_FSHOOKS_QUOTA)
 		xfs_dqtrx_hook_enable();
 
+	if (scrub_fshooks & XCHK_FSHOOKS_NLINKS)
+		xfs_nlink_hook_enable();
+
 	sc->flags |= scrub_fshooks;
 }
diff --git a/fs/xfs/scrub/nlinks.c b/fs/xfs/scrub/nlinks.c
index f97c46bdd06c..49ac7904896f 100644
--- a/fs/xfs/scrub/nlinks.c
+++ b/fs/xfs/scrub/nlinks.c
@@ -43,8 +43,7 @@ int
 xchk_setup_nlinks(
 	struct xfs_scrub	*sc)
 {
-	/* Not ready for general consumption yet. */
-	return -EOPNOTSUPP;
+	xchk_fshooks_enable(sc, XCHK_FSHOOKS_NLINKS);
 
 	sc->buf = kzalloc(sizeof(struct xchk_nlink_ctrs), XCHK_GFP_FLAGS);
 	if (!sc->buf)
@@ -63,6 +62,21 @@ xchk_setup_nlinks(
  * must be taken with certain errno values (i.e. EFSBADCRC, EFSCORRUPTED,
  * ECANCELED) that are absorbed into a scrub state flag update by
  * xchk_*_process_error.
+ *
+ * Because we are scanning a live filesystem, it's possible that another thread
+ * will try to update the link counts for an inode that we've already scanned.
+ * This will cause our counts to be incorrect.  Therefore, we hook all inode
+ * link count updates when the change is made to the incore inode.  By
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
 
 /* Update incore link count information.  Caller must hold the nlinks lock. */
@@ -104,6 +118,91 @@ xchk_nlinks_update_incore(
 	return error;
 }
 
+/*
+ * Apply a link count change from the regular filesystem into our shadow link
+ * count structure.
+ */
+STATIC int
+xchk_nlinks_live_update(
+	struct xfs_hook			*delta_hook,
+	unsigned long			action,
+	void				*data)
+{
+	struct xfs_nlink_delta_params	*p = data;
+	struct xchk_nlink_ctrs		*xnc;
+	const struct xfs_inode		*scan_dir = p->dp;
+	int				error;
+
+	xnc = container_of(delta_hook, struct xchk_nlink_ctrs, hooks.delta_hook);
+
+	/*
+	 * Back links between a parent directory and a child subdirectory are
+	 * accounted to the incore data when the child is scanned, so we only
+	 * want live backref updates if the child has been scanned.  For all
+	 * other links (forward and dot) we accept the live update for the
+	 * parent directory.
+	 */
+	if (action == XFS_BACKREF_NLINK_DELTA)
+		scan_dir = p->ip;
+
+	/* Ignore the live update if the directory hasn't been scanned yet. */
+	if (!xchk_iscan_want_live_update(&xnc->collect_iscan, scan_dir->i_ino))
+		return NOTIFY_DONE;
+
+	trace_xchk_nlinks_live_update(xnc->sc->mp, p->dp, action, p->ip->i_ino,
+			p->delta, p->name->name, p->name->len);
+
+	mutex_lock(&xnc->lock);
+
+	if (action == XFS_DIRENT_NLINK_DELTA) {
+		const struct inode	*inode = &p->ip->i_vnode;
+
+		/*
+		 * This is an update of a forward link from dp to ino.
+		 * Increment the number of parents linking into ino.  If the
+		 * forward link is to a subdirectory, increment the number of
+		 * child links of dp.
+		 */
+		error = xchk_nlinks_update_incore(xnc, p->ip->i_ino, p->delta,
+				0, 0);
+		if (error)
+			goto out_abort;
+
+		if (S_ISDIR(inode->i_mode)) {
+			error = xchk_nlinks_update_incore(xnc, p->dp->i_ino, 0,
+					0, p->delta);
+			if (error)
+				goto out_abort;
+		}
+	} else if (action == XFS_SELF_NLINK_DELTA) {
+		/*
+		 * This is an update to the dot entry.  Increment the number of
+		 * child links of dp.
+		 */
+		error = xchk_nlinks_update_incore(xnc, p->dp->i_ino, 0, 0,
+				p->delta);
+		if (error)
+			goto out_abort;
+	} else if (action == XFS_BACKREF_NLINK_DELTA) {
+		/*
+		 * This is an update to the dotdot entry.  Increment the number
+		 * of backrefs pointing back to dp (from ip).
+		 */
+		error = xchk_nlinks_update_incore(xnc, p->dp->i_ino, 0,
+				p->delta, 0);
+		if (error)
+			goto out_abort;
+	}
+
+	mutex_unlock(&xnc->lock);
+	return NOTIFY_DONE;
+
+out_abort:
+	xchk_iscan_abort(&xnc->collect_iscan);
+	mutex_unlock(&xnc->lock);
+	return NOTIFY_DONE;
+}
+
 /* Bump the observed link count for the inode referenced by this entry. */
 STATIC int
 xchk_nlinks_collect_dirent(
@@ -720,6 +819,11 @@ xchk_nlinks_teardown_scan(
 {
 	struct xchk_nlink_ctrs	*xnc = priv;
 
+	/* Discourage any hook functions that might be running. */
+	xchk_iscan_abort(&xnc->collect_iscan);
+
+	xfs_nlink_hook_del(xnc->sc->mp, &xnc->hooks);
+
 	xfarray_destroy(xnc->nlinks);
 	xnc->nlinks = NULL;
 
@@ -765,6 +869,18 @@ xchk_nlinks_setup_scan(
 	if (error)
 		goto out_teardown;
 
+	/*
+	 * Hook into the bumplink/droplink code.  The hook only triggers for
+	 * inodes that were already scanned, and the scanner thread takes each
+	 * inode's ILOCK, which means that any in-progress inode updates will
+	 * finish before we can scan the inode.
+	 */
+	ASSERT(sc->flags & XCHK_FSHOOKS_NLINKS);
+	xfs_hook_setup(&xnc->hooks.delta_hook, xchk_nlinks_live_update);
+	error = xfs_nlink_hook_add(mp, &xnc->hooks);
+	if (error)
+		goto out_teardown;
+
 	/* Use deferred cleanup to pass the inode link count data to repair. */
 	sc->buf_cleanup = xchk_nlinks_teardown_scan;
 	return 0;
diff --git a/fs/xfs/scrub/nlinks.h b/fs/xfs/scrub/nlinks.h
index 30fa7dd93029..69cf556b15a3 100644
--- a/fs/xfs/scrub/nlinks.h
+++ b/fs/xfs/scrub/nlinks.h
@@ -22,6 +22,12 @@ struct xchk_nlink_ctrs {
 	 */
 	struct xchk_iscan	collect_iscan;
 	struct xchk_iscan	compare_iscan;
+
+	/*
+	 * Hook into bumplink/droplink so that we can receive live updates
+	 * from other writer threads.
+	 */
+	struct xfs_nlink_hook	hooks;
 };
 
 /*
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 8fdd38dbb9f4..7e06aa98ca82 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -161,6 +161,9 @@ xchk_fshooks_disable(
 	if (sc->flags & XCHK_FSHOOKS_QUOTA)
 		xfs_dqtrx_hook_disable();
 
+	if (sc->flags & XCHK_FSHOOKS_NLINKS)
+		xfs_nlink_hook_disable();
+
 	sc->flags &= ~XCHK_FSHOOKS_ALL;
 }
 
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index d39b2b95352a..da9da6245475 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -122,11 +122,13 @@ struct xfs_scrub {
 #define XCHK_FSHOOKS_DRAIN	(1 << 2)  /* defer ops draining enabled */
 #define XCHK_NEED_DRAIN		(1 << 3)  /* scrub needs to use intent drain */
 #define XCHK_FSHOOKS_QUOTA	(1 << 4)  /* quota live update enabled */
+#define XCHK_FSHOOKS_NLINKS	(1 << 5)  /* link count live update enabled */
 #define XREP_RESET_PERAG_RESV	(1 << 30) /* must reset AG space reservation */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
 #define XCHK_FSHOOKS_ALL	(XCHK_FSHOOKS_DRAIN | \
-				 XCHK_FSHOOKS_QUOTA)
+				 XCHK_FSHOOKS_QUOTA | \
+				 XCHK_FSHOOKS_NLINKS)
 
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 508698d356d2..25acfff8fe6b 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -115,6 +115,7 @@ TRACE_DEFINE_ENUM(XFS_SCRUB_TYPE_NLINKS);
 	{ XCHK_FSHOOKS_DRAIN,			"fshooks_drain" }, \
 	{ XCHK_NEED_DRAIN,			"need_drain" }, \
 	{ XCHK_FSHOOKS_QUOTA,			"fshooks_quota" }, \
+	{ XCHK_FSHOOKS_NLINKS,			"fshooks_nlinks" }, \
 	{ XREP_RESET_PERAG_RESV,		"reset_perag_resv" }, \
 	{ XREP_ALREADY_FIXED,			"already_fixed" }
 
@@ -1172,6 +1173,48 @@ TRACE_EVENT(xchk_nlinks_collect_metafile,
 		  __entry->ino)
 );
 
+TRACE_DEFINE_ENUM(XFS_DIRENT_NLINK_DELTA);
+TRACE_DEFINE_ENUM(XFS_BACKREF_NLINK_DELTA);
+TRACE_DEFINE_ENUM(XFS_SELF_NLINK_DELTA);
+
+#define XFS_NLINK_DELTA_STRINGS \
+	{ XFS_DIRENT_NLINK_DELTA,	"->" }, \
+	{ XFS_BACKREF_NLINK_DELTA,	"<-" }, \
+	{ XFS_SELF_NLINK_DELTA,		"<>" }
+
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
+	TP_printk("dev %d:%d dir 0x%llx %s ino 0x%llx nlink_delta %d name '%.*s'",
+		  MAJOR(__entry->dev), MINOR(__entry->dev),
+		  __entry->dir,
+		  __print_symbolic(__entry->action, XFS_NLINK_DELTA_STRINGS),
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
index eebdbc55d078..d6eeb59217b4 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -938,6 +938,117 @@ xfs_bumplink(
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
+#ifdef CONFIG_XFS_LIVE_HOOKS
+/*
+ * Use a static key here to reduce the overhead of link count live updates.  If
+ * the compiler supports jump labels, the static branch will be replaced by a
+ * nop sled when there are no hook users.  Online fsck is currently the only
+ * caller, so this is a reasonable tradeoff.
+ *
+ * Note: Patching the kernel code requires taking the cpu hotplug lock.  Other
+ * parts of the kernel allocate memory with that lock held, which means that
+ * XFS callers cannot hold any locks that might be used by memory reclaim or
+ * writeback when calling the static_branch_{inc,dec} functions.
+ */
+DEFINE_STATIC_XFS_HOOK_SWITCH(xfs_nlinks_hooks_switch);
+
+void
+xfs_nlink_hook_disable(void)
+{
+	xfs_hooks_switch_off(&xfs_nlinks_hooks_switch);
+}
+
+void
+xfs_nlink_hook_enable(void)
+{
+	xfs_hooks_switch_on(&xfs_nlinks_hooks_switch);
+}
+
+/* Call hooks for a link count update relating to a dot dirent update. */
+static inline void
+xfs_nlink_self_delta(
+	struct xfs_inode		*dp,
+	int				delta)
+{
+	if (xfs_hooks_switched_on(&xfs_nlinks_hooks_switch)) {
+		struct xfs_nlink_delta_params	p = {
+			.dp		= dp,
+			.ip		= dp,
+			.delta		= delta,
+			.name		= &xfs_name_dot,
+		};
+		struct xfs_mount	*mp = dp->i_mount;
+
+		xfs_hooks_call(&mp->m_nlink_delta_hooks, XFS_SELF_NLINK_DELTA,
+				&p);
+	}
+}
+
+/* Call hooks for a link count update relating to a dotdot dirent update. */
+static inline void
+xfs_nlink_backref_delta(
+	struct xfs_inode		*dp,
+	struct xfs_inode		*ip,
+	int				delta)
+{
+	if (xfs_hooks_switched_on(&xfs_nlinks_hooks_switch)) {
+		struct xfs_nlink_delta_params	p = {
+			.dp		= dp,
+			.ip		= ip,
+			.delta		= delta,
+			.name		= &xfs_name_dotdot,
+		};
+		struct xfs_mount	*mp = ip->i_mount;
+
+		xfs_hooks_call(&mp->m_nlink_delta_hooks, XFS_BACKREF_NLINK_DELTA,
+				&p);
+	}
+}
+
+/* Call hooks for a link count update relating to a dirent update. */
+void
+xfs_nlink_dirent_delta(
+	struct xfs_inode		*dp,
+	struct xfs_inode		*ip,
+	int				delta,
+	struct xfs_name			*name)
+{
+	if (xfs_hooks_switched_on(&xfs_nlinks_hooks_switch)) {
+		struct xfs_nlink_delta_params	p = {
+			.dp		= dp,
+			.ip		= ip,
+			.delta		= delta,
+			.name		= name,
+		};
+		struct xfs_mount	*mp = ip->i_mount;
+
+		xfs_hooks_call(&mp->m_nlink_delta_hooks, XFS_DIRENT_NLINK_DELTA,
+				&p);
+	}
+}
+
+/* Call the specified function during a link count update. */
+int
+xfs_nlink_hook_add(
+	struct xfs_mount	*mp,
+	struct xfs_nlink_hook	*hook)
+{
+	return xfs_hooks_add(&mp->m_nlink_delta_hooks, &hook->delta_hook);
+}
+
+/* Stop calling the specified function during a link count update. */
+void
+xfs_nlink_hook_del(
+	struct xfs_mount	*mp,
+	struct xfs_nlink_hook	*hook)
+{
+	xfs_hooks_del(&mp->m_nlink_delta_hooks, &hook->delta_hook);
+}
+#else
+# define xfs_nlink_self_delta(dp, delta)		((void)0)
+# define xfs_nlink_backref_delta(dp, ip, delta)		((void)0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 int
 xfs_create(
 	struct user_namespace	*mnt_userns,
@@ -1046,6 +1157,16 @@ xfs_create(
 		xfs_bumplink(tp, dp);
 	}
 
+	/*
+	 * Create ip with a reference from dp, and add '.' and '..' references
+	 * if it's a directory.
+	 */
+	xfs_nlink_dirent_delta(dp, ip, 1, name);
+	if (is_dir) {
+		xfs_nlink_self_delta(ip, 1);
+		xfs_nlink_backref_delta(dp, ip, 1);
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * create transaction goes to disk before returning to
@@ -1258,6 +1379,7 @@ xfs_link(
 	xfs_trans_log_inode(tp, tdp, XFS_ILOG_CORE);
 
 	xfs_bumplink(tp, sip);
+	xfs_nlink_dirent_delta(tdp, sip, 1, target_name);
 
 	/*
 	 * If this is a synchronous mount, make sure that the
@@ -2486,6 +2608,16 @@ xfs_remove(
 		goto out_trans_cancel;
 	}
 
+	/*
+	 * Drop the link from dp to ip, and if ip was a directory, remove the
+	 * '.' and '..' references since we freed the directory.
+	 */
+	xfs_nlink_dirent_delta(dp, ip, -1, name);
+	if (S_ISDIR(VFS_I(ip)->i_mode)) {
+		xfs_nlink_backref_delta(dp, ip, -1);
+		xfs_nlink_self_delta(ip, -1);
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2560,6 +2692,75 @@ xfs_sort_for_rename(
 	}
 }
 
+#ifdef CONFIG_XFS_LIVE_HOOKS
+static inline void
+xfs_rename_call_nlink_hooks(
+	struct xfs_inode	*src_dp,
+	struct xfs_name		*src_name,
+	struct xfs_inode	*src_ip,
+	struct xfs_inode	*target_dp,
+	struct xfs_name		*target_name,
+	struct xfs_inode	*target_ip,
+	struct xfs_inode	*wip,
+	unsigned int		flags)
+{
+	/* If we added a whiteout, add the reference from src_dp. */
+	if (wip)
+		xfs_nlink_dirent_delta(src_dp, wip, 1, src_name);
+
+	/* Move the src_ip forward link from src_dp to target_dp. */
+	xfs_nlink_dirent_delta(src_dp, src_ip, -1, src_name);
+	xfs_nlink_dirent_delta(target_dp, src_ip, 1, target_name);
+
+	/*
+	 * If src_ip is a dir, move its '..' back link from src_dp to
+	 * target_dp.
+	 */
+	if (S_ISDIR(VFS_I(src_ip)->i_mode)) {
+		xfs_nlink_backref_delta(src_dp, src_ip, -1);
+		xfs_nlink_backref_delta(target_dp, src_ip, 1);
+	}
+
+	if (!target_ip)
+		return;
+
+	if (flags & RENAME_EXCHANGE) {
+		/* Move the target_ip forward link from target_dp to src_dp. */
+		xfs_nlink_dirent_delta(target_dp, target_ip, -1, target_name);
+		xfs_nlink_dirent_delta(src_dp, target_ip, 1, target_name);
+
+		/*
+		 * If target_ip is a dir, move its '..' back link from
+		 * target_dp to src_dp.
+		 */
+		if (S_ISDIR(VFS_I(target_ip)->i_mode)) {
+			xfs_nlink_backref_delta(target_dp, target_ip, -1);
+			xfs_nlink_backref_delta(src_dp, target_ip, 1);
+		}
+
+		return;
+	}
+
+	/* Drop target_ip's forward link from target_dp. */
+	xfs_nlink_dirent_delta(target_dp, target_ip, -1, target_name);
+
+	if (!S_ISDIR(VFS_I(target_ip)->i_mode))
+		return;
+
+	/*
+	 * If target_ip was a dir, drop the '.' and '..' references since that
+	 * was the last reference.
+	 */
+	ASSERT(VFS_I(target_ip)->i_nlink == 0);
+	xfs_nlink_self_delta(target_ip, -1);
+	xfs_nlink_backref_delta(target_dp, target_ip, -1);
+}
+#else
+# define xfs_rename_call_nlink_hooks(src_dp, src_name, src_ip, target_dp, \
+				     target_name, target_ip, wip, flags) \
+		((void)0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 static int
 xfs_finish_rename(
 	struct xfs_trans	*tp)
@@ -2676,6 +2877,11 @@ xfs_cross_rename(
 	}
 	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
+
+	if (xfs_hooks_switched_on(&xfs_nlinks_hooks_switch))
+		xfs_rename_call_nlink_hooks(dp1, name1, ip1, dp2, name2, ip2,
+				NULL, RENAME_EXCHANGE);
+
 	return xfs_finish_rename(tp);
 
 out_trans_abort:
@@ -3059,6 +3265,10 @@ xfs_rename(
 	if (new_parent)
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
+	if (xfs_hooks_switched_on(&xfs_nlinks_hooks_switch))
+		xfs_rename_call_nlink_hooks(src_dp, src_name, src_ip,
+				target_dp, target_name, target_ip, wip, flags);
+
 	error = xfs_finish_rename(tp);
 	if (wip)
 		xfs_irele(wip);
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 57c459f8e669..926e4dd566d0 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -578,4 +578,39 @@ void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_inode_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_filblks_t *dblocks, xfs_filblks_t *rblocks);
 
+/*
+ * Parameters for tracking bumplink and droplink operations.  The hook
+ * function arg parameter is one of these.
+ */
+enum xfs_nlink_delta_type {
+	XFS_DIRENT_NLINK_DELTA,		/* parent pointing to child */
+	XFS_BACKREF_NLINK_DELTA,		/* dotdot entries */
+	XFS_SELF_NLINK_DELTA,		/* dot entries */
+};
+
+struct xfs_nlink_delta_params {
+	const struct xfs_inode	*dp;
+	const struct xfs_inode	*ip;
+	const struct xfs_name	*name;
+	int			delta;
+};
+
+#ifdef CONFIG_XFS_LIVE_HOOKS
+void xfs_nlink_dirent_delta(struct xfs_inode *dp, struct xfs_inode *ip,
+		int delta, struct xfs_name *name);
+
+struct xfs_nlink_hook {
+	struct xfs_hook		delta_hook;
+};
+
+void xfs_nlink_hook_disable(void);
+void xfs_nlink_hook_enable(void);
+
+int xfs_nlink_hook_add(struct xfs_mount *mp, struct xfs_nlink_hook *hook);
+void xfs_nlink_hook_del(struct xfs_mount *mp, struct xfs_nlink_hook *hook);
+
+#else
+# define xfs_nlink_dirent_delta(dp, ip, delta, name)	((void)0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 8aca2cc173ac..ec8b185d45f8 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -242,6 +242,8 @@ typedef struct xfs_mount {
 	unsigned int		*m_errortag;
 	struct xfs_kobj		m_errortag_kobj;
 #endif
+	/* Hook to feed file link count updates to an active online repair. */
+	struct xfs_hooks	m_nlink_delta_hooks;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0c4b73e9b29d..020ff2d93f23 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1944,6 +1944,8 @@ static int xfs_init_fs_context(
 	mp->m_logbsize = -1;
 	mp->m_allocsize_log = 16; /* 64k */
 
+	xfs_hooks_init(&mp->m_nlink_delta_hooks);
+
 	/*
 	 * Copy binary VFS mount flags we are interested in.
 	 */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8389f3ef88ef..8241c0fcd0ba 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -319,6 +319,7 @@ xfs_symlink(
 		goto out_trans_cancel;
 	xfs_trans_ichgtime(tp, dp, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
+	xfs_nlink_dirent_delta(dp, ip, 1, link_name);
 
 	/*
 	 * If this is a synchronous mount, make sure that the

