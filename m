Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C11FC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:46:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbjBPUqC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:46:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbjBPUqB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:46:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7F64B53D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:45:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05F03B826BA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AB7C433EF;
        Thu, 16 Feb 2023 20:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580356;
        bh=hW6notKlRnWG3aSNHH4cucWq2VW3/Z3pkO6qkYj+7yU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=PSQynJFhjreweQbUWI3wj8mcFp+RsGsEdn9E8K7n/3NI0XphMy4tFUxtrASnrdrrk
         xUmId+JX8T4QsRKSeSn5CcLjkseP9Qy87mdgn5Sv/5GX7O8xlqNpTNGSUVcRFunyik
         YdpnibkRiMq2ejL24Cl3ndW0RXs7FPFrMSi+r1yH53dqA43ciEWB85pyXjwJJ/xawR
         XB9Kzzqyc9k2Gxz+4A1G5lyQmzoW0Iu59eG0JphFo+37f66SXYlfHgJES5ss6jp3yn
         PGZAhXmi9cJD2cN+8EFYSMGuCJgA8E+FaJe/vsv7dUroS3bS7uUG7UxEXfsemi+Ban
         o5dnE7vjoH3VA==
Date:   Thu, 16 Feb 2023 12:45:56 -0800
Subject: [PATCH 16/23] xfs: track file link count updates during live nlinks
 fsck
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874063.3474338.19044636154750907.stgit@magnolia>
In-Reply-To: <167657873813.3474338.3118516275923112371.stgit@magnolia>
References: <167657873813.3474338.3118516275923112371.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_dir2.c |    6 +
 fs/xfs/libxfs/xfs_dir2.h |    1 
 fs/xfs/scrub/common.c    |   20 ++++
 fs/xfs/scrub/common.h    |    2 
 fs/xfs/scrub/scrub.c     |   17 +++
 fs/xfs/scrub/scrub.h     |    3 +
 fs/xfs/scrub/trace.h     |   42 +++++++++
 fs/xfs/xfs_inode.c       |  226 ++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_inode.h       |   35 +++++++
 fs/xfs/xfs_mount.h       |    2 
 fs/xfs/xfs_super.c       |    2 
 fs/xfs/xfs_symlink.c     |    1 
 12 files changed, 357 insertions(+)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index c1a9394d7478..27e408d20d18 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -25,6 +25,12 @@ const struct xfs_name xfs_name_dotdot = {
 	.type	= XFS_DIR3_FT_DIR,
 };
 
+const struct xfs_name xfs_name_dot = {
+	.name	= (const unsigned char *)".",
+	.len	= 1,
+	.type	= XFS_DIR3_FT_DIR,
+};
+
 /*
  * Convert inode mode to directory entry filetype
  */
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index ff59f009d1fd..ac360c0b2fe7 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -22,6 +22,7 @@ struct xfs_dir3_icfree_hdr;
 struct xfs_dir3_icleaf_hdr;
 
 extern const struct xfs_name	xfs_name_dotdot;
+extern const struct xfs_name	xfs_name_dot;
 
 /*
  * Convert inode mode to directory entry filetype
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index dc78e28a9447..a4cfe5653880 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -961,3 +961,23 @@ xchk_start_reaping(
 	}
 	sc->flags &= ~XCHK_REAPING_DISABLED;
 }
+
+/*
+ * Enable filesystem hooks (i.e. runtime code patching) before starting a scrub
+ * operation.  Callers must not hold any locks that intersect with the CPU
+ * hotplug lock (e.g. writeback locks) because code patching must halt the CPUs
+ * to change kernel code.
+ */
+void
+xchk_fshooks_enable(
+	struct xfs_scrub	*sc,
+	unsigned int		scrub_fshooks)
+{
+	ASSERT(!(scrub_fshooks & ~XCHK_FSHOOKS_ALL));
+	ASSERT(!(sc->flags & scrub_fshooks));
+
+	if (scrub_fshooks & XCHK_FSHOOKS_DIRENTS)
+		xfs_dirent_hook_enable();
+
+	sc->flags |= scrub_fshooks;
+}
diff --git a/fs/xfs/scrub/common.h b/fs/xfs/scrub/common.h
index 5286c263ff60..423a98c39fb6 100644
--- a/fs/xfs/scrub/common.h
+++ b/fs/xfs/scrub/common.h
@@ -157,4 +157,6 @@ int xchk_metadata_inode_forks(struct xfs_scrub *sc);
 void xchk_stop_reaping(struct xfs_scrub *sc);
 void xchk_start_reaping(struct xfs_scrub *sc);
 
+void xchk_fshooks_enable(struct xfs_scrub *sc, unsigned int scrub_fshooks);
+
 #endif	/* __XFS_SCRUB_COMMON_H__ */
diff --git a/fs/xfs/scrub/scrub.c b/fs/xfs/scrub/scrub.c
index 6aedce9b67fc..871a72e22a8a 100644
--- a/fs/xfs/scrub/scrub.c
+++ b/fs/xfs/scrub/scrub.c
@@ -145,6 +145,21 @@ xchk_probe(
 
 /* Scrub setup and teardown */
 
+static inline void
+xchk_fshooks_disable(
+	struct xfs_scrub	*sc)
+{
+	if (!(sc->flags & XCHK_FSHOOKS_ALL))
+		return;
+
+	//trace_xchk_fshooks_disable(sc, sc->flags & XCHK_FSHOOKS_ALL);
+
+	if (sc->flags & XCHK_FSHOOKS_DIRENTS)
+		xfs_dirent_hook_disable();
+
+	sc->flags &= ~XCHK_FSHOOKS_ALL;
+}
+
 /* Free all the resources and finish the transactions. */
 STATIC int
 xchk_teardown(
@@ -177,6 +192,8 @@ xchk_teardown(
 		kvfree(sc->buf);
 		sc->buf = NULL;
 	}
+
+	xchk_fshooks_disable(sc);
 	return error;
 }
 
diff --git a/fs/xfs/scrub/scrub.h b/fs/xfs/scrub/scrub.h
index b4d391b4c938..484e5fb7fe7a 100644
--- a/fs/xfs/scrub/scrub.h
+++ b/fs/xfs/scrub/scrub.h
@@ -97,8 +97,11 @@ struct xfs_scrub {
 /* XCHK state flags grow up from zero, XREP state flags grown down from 2^31 */
 #define XCHK_TRY_HARDER		(1 << 0)  /* can't get resources, try again */
 #define XCHK_REAPING_DISABLED	(1 << 2)  /* background block reaping paused */
+#define XCHK_FSHOOKS_DIRENTS	(1 << 5)  /* link count live update enabled */
 #define XREP_ALREADY_FIXED	(1 << 31) /* checking our repair work */
 
+#define XCHK_FSHOOKS_ALL	(XCHK_FSHOOKS_DIRENTS)
+
 /* Metadata scrubbers */
 int xchk_tester(struct xfs_scrub *sc);
 int xchk_superblock(struct xfs_scrub *sc);
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index d97c9a40186a..979ee2789668 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -853,6 +853,48 @@ TRACE_EVENT(xchk_iscan_iget_retry_wait,
 		  __entry->retry_delay)
 );
 
+TRACE_DEFINE_ENUM(XFS_DIRENT_CHILD_DELTA);
+TRACE_DEFINE_ENUM(XFS_DIRENT_BACKREF_DELTA);
+TRACE_DEFINE_ENUM(XFS_DIRENT_SELF_DELTA);
+
+#define XFS_NLINK_DELTA_STRINGS \
+	{ XFS_DIRENT_CHILD_DELTA,	"->" }, \
+	{ XFS_DIRENT_BACKREF_DELTA,	"<-" }, \
+	{ XFS_DIRENT_SELF_DELTA,		"<>" }
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
 /* repair tracepoints */
 #if IS_ENABLED(CONFIG_XFS_ONLINE_REPAIR)
 
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 6626aa7486f1..b17e4ba3622b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -970,6 +970,117 @@ xfs_mkdir_space_res(
 	return xfs_create_space_res(mp, namelen);
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
+DEFINE_STATIC_XFS_HOOK_SWITCH(xfs_dirents_hooks_switch);
+
+void
+xfs_dirent_hook_disable(void)
+{
+	xfs_hooks_switch_off(&xfs_dirents_hooks_switch);
+}
+
+void
+xfs_dirent_hook_enable(void)
+{
+	xfs_hooks_switch_on(&xfs_dirents_hooks_switch);
+}
+
+/* Call hooks for a directory update relating to a dot dirent update. */
+static inline void
+xfs_dirent_self_delta(
+	struct xfs_inode		*dp,
+	int				delta)
+{
+	if (xfs_hooks_switched_on(&xfs_dirents_hooks_switch)) {
+		struct xfs_dirent_update_params	p = {
+			.dp		= dp,
+			.ip		= dp,
+			.delta		= delta,
+			.name		= &xfs_name_dot,
+		};
+		struct xfs_mount	*mp = dp->i_mount;
+
+		xfs_hooks_call(&mp->m_dirent_update_hooks,
+				XFS_DIRENT_SELF_DELTA, &p);
+	}
+}
+
+/* Call hooks for a directory update relating to a dotdot dirent update. */
+static inline void
+xfs_dirent_backref_delta(
+	struct xfs_inode		*dp,
+	struct xfs_inode		*ip,
+	int				delta)
+{
+	if (xfs_hooks_switched_on(&xfs_dirents_hooks_switch)) {
+		struct xfs_dirent_update_params	p = {
+			.dp		= dp,
+			.ip		= ip,
+			.delta		= delta,
+			.name		= &xfs_name_dotdot,
+		};
+		struct xfs_mount	*mp = ip->i_mount;
+
+		xfs_hooks_call(&mp->m_dirent_update_hooks,
+				XFS_DIRENT_BACKREF_DELTA, &p);
+	}
+}
+
+/* Call hooks for a directory update relating to a dirent update. */
+void
+xfs_dirent_child_delta(
+	struct xfs_inode		*dp,
+	struct xfs_inode		*ip,
+	int				delta,
+	struct xfs_name			*name)
+{
+	if (xfs_hooks_switched_on(&xfs_dirents_hooks_switch)) {
+		struct xfs_dirent_update_params	p = {
+			.dp		= dp,
+			.ip		= ip,
+			.delta		= delta,
+			.name		= name,
+		};
+		struct xfs_mount	*mp = ip->i_mount;
+
+		xfs_hooks_call(&mp->m_dirent_update_hooks,
+				XFS_DIRENT_CHILD_DELTA, &p);
+	}
+}
+
+/* Call the specified function during a directory update. */
+int
+xfs_dirent_hook_add(
+	struct xfs_mount	*mp,
+	struct xfs_dirent_hook	*hook)
+{
+	return xfs_hooks_add(&mp->m_dirent_update_hooks, &hook->delta_hook);
+}
+
+/* Stop calling the specified function during a directory update. */
+void
+xfs_dirent_hook_del(
+	struct xfs_mount	*mp,
+	struct xfs_dirent_hook	*hook)
+{
+	xfs_hooks_del(&mp->m_dirent_update_hooks, &hook->delta_hook);
+}
+#else
+# define xfs_dirent_self_delta(dp, delta)		((void)0)
+# define xfs_dirent_backref_delta(dp, ip, delta)	((void)0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 int
 xfs_create(
 	struct user_namespace	*mnt_userns,
@@ -1096,6 +1207,16 @@ xfs_create(
 			goto out_trans_cancel;
 	}
 
+	/*
+	 * Create ip with a reference from dp, and add '.' and '..' references
+	 * if it's a directory.
+	 */
+	xfs_dirent_child_delta(dp, ip, 1, name);
+	if (is_dir) {
+		xfs_dirent_self_delta(ip, 1);
+		xfs_dirent_backref_delta(dp, ip, 1);
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * create transaction goes to disk before returning to
@@ -1361,6 +1482,8 @@ xfs_link(
 			goto error_return;
 	}
 
+	xfs_dirent_child_delta(tdp, sip, 1, target_name);
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * link transaction goes to disk before returning to
@@ -2631,6 +2754,16 @@ xfs_remove(
 			goto out_trans_cancel;
 	}
 
+	/*
+	 * Drop the link from dp to ip, and if ip was a directory, remove the
+	 * '.' and '..' references since we freed the directory.
+	 */
+	xfs_dirent_child_delta(dp, ip, -1, name);
+	if (S_ISDIR(VFS_I(ip)->i_mode)) {
+		xfs_dirent_backref_delta(dp, ip, -1);
+		xfs_dirent_self_delta(ip, -1);
+	}
+
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2728,6 +2861,92 @@ xfs_sort_for_rename(
 	}
 }
 
+#ifdef CONFIG_XFS_LIVE_HOOKS
+/*
+ * Directory entry live update hooks are called with ILOCK_EXCL held on all
+ * inodes after we've committed to making all the directory updates.  Hence we
+ * do not have to call the hooks in *exactly* the same order as the rename and
+ * exchange code make the actual updates.  This is fortunate because we can
+ * simplify things quite a bit, as long as we're careful to delete old dirents
+ * before creating new ones.
+ */
+static inline void
+xfs_exchange_call_nlink_hooks(
+	struct xfs_inode	*src_dp,
+	struct xfs_name		*src_name,
+	struct xfs_inode	*src_ip,
+	struct xfs_inode	*target_dp,
+	struct xfs_name		*target_name,
+	struct xfs_inode	*target_ip)
+{
+	/* Exchange files in the source directory. */
+	xfs_dirent_child_delta(src_dp, src_ip, -1, src_name);
+	xfs_dirent_child_delta(src_dp, target_ip, 1, src_name);
+
+	/* Exchange files in the target directory. */
+	xfs_dirent_child_delta(target_dp, target_ip, -1, target_name);
+	xfs_dirent_child_delta(target_dp, src_ip, 1, target_name);
+
+	/* If the source file is a dir, update its dotdot entry. */
+	if (S_ISDIR(VFS_I(src_ip)->i_mode)) {
+		xfs_dirent_backref_delta(src_dp, src_ip, -1);
+		xfs_dirent_backref_delta(target_dp, src_ip, 1);
+	}
+
+	/* If the target file is a dir, update its dotdot entry. */
+	if (S_ISDIR(VFS_I(target_ip)->i_mode)) {
+		xfs_dirent_backref_delta(target_dp, target_ip, -1);
+		xfs_dirent_backref_delta(src_dp, target_ip, 1);
+	}
+}
+
+static inline void
+xfs_rename_call_nlink_hooks(
+	struct xfs_inode	*src_dp,
+	struct xfs_name		*src_name,
+	struct xfs_inode	*src_ip,
+	struct xfs_inode	*target_dp,
+	struct xfs_name		*target_name,
+	struct xfs_inode	*target_ip,
+	struct xfs_inode	*wip)
+{
+	/*
+	 * If there's a target file, remove it from the target directory and
+	 * move the source file to the target directory.
+	 */
+	if (target_ip)
+		xfs_dirent_child_delta(target_dp, target_ip, -1, target_name);
+	xfs_dirent_child_delta(target_dp, src_ip, 1, target_name);
+
+	/*
+	 * Remove the source file from the source directory, and possibly move
+	 * the whiteout file into its place.
+	 */
+	xfs_dirent_child_delta(src_dp, src_ip, -1, src_name);
+	if (wip)
+		xfs_dirent_child_delta(src_dp, wip, 1, src_name);
+
+	/* If the source file is a dir, update its dotdot entry. */
+	if (S_ISDIR(VFS_I(src_ip)->i_mode)) {
+		xfs_dirent_backref_delta(src_dp, src_ip, -1);
+		xfs_dirent_backref_delta(target_dp, src_ip, 1);
+	}
+
+	/*
+	 * If the target file is a dir, drop the dot and dotdot entries because
+	 * we've dropped the last reference.
+	 */
+	if (target_ip && S_ISDIR(VFS_I(target_ip)->i_mode)) {
+		ASSERT(VFS_I(target_ip)->i_nlink == 0);
+		xfs_dirent_self_delta(target_ip, -1);
+		xfs_dirent_backref_delta(target_dp, target_ip, -1);
+	}
+}
+#else
+# define xfs_exchange_call_nlink_hooks(...)	((void)0)
+# define xfs_rename_call_nlink_hooks(...)	((void)0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 static int
 xfs_finish_rename(
 	struct xfs_trans	*tp)
@@ -2861,6 +3080,9 @@ xfs_cross_rename(
 	xfs_trans_ichgtime(tp, dp1, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	xfs_trans_log_inode(tp, dp1, XFS_ILOG_CORE);
 
+	if (xfs_hooks_switched_on(&xfs_dirents_hooks_switch))
+		xfs_exchange_call_nlink_hooks(dp1, name1, ip1, dp2, name2, ip2);
+
 	return xfs_finish_rename(tp);
 
 out_trans_abort:
@@ -3338,6 +3560,10 @@ xfs_rename(
 	if (new_parent)
 		xfs_trans_log_inode(tp, target_dp, XFS_ILOG_CORE);
 
+	if (xfs_hooks_switched_on(&xfs_dirents_hooks_switch))
+		xfs_rename_call_nlink_hooks(src_dp, src_name, src_ip,
+				target_dp, target_name, target_ip, wip);
+
 	error = xfs_finish_rename(tp);
 
 	goto out_unlock;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 5735de32beeb..b7a16642a8c3 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -576,4 +576,39 @@ int xfs_ilock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_iunlock2_io_mmap(struct xfs_inode *ip1, struct xfs_inode *ip2);
 void xfs_lock_inodes(struct xfs_inode **ips, int inodes, uint lock_mode);
 
+/*
+ * Parameters for tracking bumplink and droplink operations.  The hook
+ * function arg parameter is one of these.
+ */
+enum xfs_dirent_update_type {
+	XFS_DIRENT_CHILD_DELTA,		/* parent pointing to child */
+	XFS_DIRENT_BACKREF_DELTA,		/* dotdot entries */
+	XFS_DIRENT_SELF_DELTA,		/* dot entries */
+};
+
+struct xfs_dirent_update_params {
+	const struct xfs_inode	*dp;
+	const struct xfs_inode	*ip;
+	const struct xfs_name	*name;
+	int			delta;
+};
+
+#ifdef CONFIG_XFS_LIVE_HOOKS
+void xfs_dirent_child_delta(struct xfs_inode *dp, struct xfs_inode *ip,
+		int delta, struct xfs_name *name);
+
+struct xfs_dirent_hook {
+	struct xfs_hook		delta_hook;
+};
+
+void xfs_dirent_hook_disable(void);
+void xfs_dirent_hook_enable(void);
+
+int xfs_dirent_hook_add(struct xfs_mount *mp, struct xfs_dirent_hook *hook);
+void xfs_dirent_hook_del(struct xfs_mount *mp, struct xfs_dirent_hook *hook);
+
+#else
+# define xfs_dirent_child_delta(dp, ip, delta, name)	((void)0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 #endif	/* __XFS_INODE_H__ */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 8aca2cc173ac..c08f55cc4f36 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -242,6 +242,8 @@ typedef struct xfs_mount {
 	unsigned int		*m_errortag;
 	struct xfs_kobj		m_errortag_kobj;
 #endif
+	/* Hook to feed file directory updates to an active online repair. */
+	struct xfs_hooks	m_dirent_update_hooks;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 0ac55d191f1f..0432a4a096e8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1949,6 +1949,8 @@ static int xfs_init_fs_context(
 	mp->m_logbsize = -1;
 	mp->m_allocsize_log = 16; /* 64k */
 
+	xfs_hooks_init(&mp->m_dirent_update_hooks);
+
 	/*
 	 * Copy binary VFS mount flags we are interested in.
 	 */
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index f305226109f0..77427a50a760 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -354,6 +354,7 @@ xfs_symlink(
 			goto out_trans_cancel;
 	}
 
+	xfs_dirent_child_delta(dp, ip, 1, link_name);
 
 	/*
 	 * If this is a synchronous mount, make sure that the

