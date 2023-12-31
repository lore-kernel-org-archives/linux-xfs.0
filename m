Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0150BA2B
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 21:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LS3Orhu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81372C433C7;
	Sun, 31 Dec 2023 21:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704056758;
	bh=crvR0aRbhcT7iThC3ttTg/qCBWA57n0Y38S5HFLzY8c=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=LS3Orhu4ZSNXX7YGytFjFsYklEktU/91vMT1gFx/itnJ/2g4tALLV/ngwKEuPmmei
	 PSmykOUO7sdPi0c61JuX3ukfq1GFtUf6h617cJ/NUwAe9iRsxZU73sEUtb1zCzoCjj
	 mIaKCEX/FN7iqOLQJX45UNNahMiCr+Y/Pr8hwCeDXOqY5fvDjJL8cDVJyK8pxHPQ+4
	 lJuKa369ATeoQcvfTBIiJlYHdo1Y464rxsshgQH8BFFldFlCm86efAvTBkM3ieZnIx
	 96dc5MSidzgPpbw8EIt54pmHIJee9X0sqaEnfCa9HrHnktHRYxtJ+yy3OrViItwTSa
	 dknXXfgHnwFgw==
Date: Sun, 31 Dec 2023 13:05:58 -0800
Subject: [PATCH 20/21] xfs: move dirent update hooks to xfs_dir2.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170404844375.1759932.16350666215379013455.stgit@frogsfrogsfrogs>
In-Reply-To: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
References: <170404844006.1759932.2866067666813443603.stgit@frogsfrogsfrogs>
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

Move the directory entry update hook code to xfs_dir2 so that it is
mostly consolidated with the higher level directory functions.  Retain
the exports so that online fsck can still send notifications through the
hooks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_dir2.c |  125 ++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/libxfs/xfs_dir2.h |   24 +++++++++
 fs/xfs/scrub/common.c    |    1 
 fs/xfs/xfs_inode.c       |  108 ----------------------------------------
 fs/xfs/xfs_inode.h       |   25 ---------
 fs/xfs/xfs_symlink.c     |    2 -
 6 files changed, 145 insertions(+), 140 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 0ec653d1d5b8d..a8a611e60ed08 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -788,6 +788,72 @@ xfs_dir2_compname(
 	return xfs_da_compname(args, name, len);
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
 /*
  * Given a directory @dp, a newly allocated inode @ip, and a @name, link @ip
  * into @dp under the given @name.  If @ip is a directory, it will be
@@ -829,7 +895,12 @@ xfs_dir_create_child(
 	 * If we have parent pointers, we need to add the attribute containing
 	 * the parent information now.
 	 */
-	return xfs_parent_add(tp, du->ppargs, dp, name, ip);
+	error = xfs_parent_add(tp, du->ppargs, dp, name, ip);
+	if (error)
+		return error;
+
+	xfs_dir_update_hook(dp, ip, 1, name);
+	return 0;
 }
 
 /*
@@ -887,7 +958,12 @@ xfs_dir_add_child(
 	 * attribute, we need to create it correctly, otherwise we can just add
 	 * the parent to the inode.
 	 */
-	return xfs_parent_add(tp, du->ppargs, dp, name, ip);
+	error = xfs_parent_add(tp, du->ppargs, dp, name, ip);
+	if (error)
+		return error;
+
+	xfs_dir_update_hook(dp, ip, 1, name);
+	return 0;
 }
 
 /*
@@ -962,7 +1038,12 @@ xfs_dir_remove_child(
 	}
 
 	/* Remove parent pointer. */
-	return xfs_parent_remove(tp, du->ppargs, dp, name, ip);
+	error = xfs_parent_remove(tp, du->ppargs, dp, name, ip);
+	if (error)
+		return error;
+
+	xfs_dir_update_hook(dp, ip, -1, name);
+	return 0;
 }
 
 /*
@@ -1078,8 +1159,24 @@ xfs_dir_exchange_children(
 	if (error)
 		return error;
 
-	return xfs_parent_replace(tp, du2->ppargs, dp2, name2, dp1, name1,
+	error = xfs_parent_replace(tp, du2->ppargs, dp2, name2, dp1, name1,
 			ip2);
+	if (error)
+		return error;
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
+	return 0;
 }
 
 /*
@@ -1294,6 +1391,24 @@ xfs_dir_rename_children(
 	if (error)
 		return error;
 
-	return xfs_parent_remove(tp, du_tgt->ppargs, target_dp, target_name,
+	error = xfs_parent_remove(tp, du_tgt->ppargs, target_dp, target_name,
 			target_ip);
+	if (error)
+		return error;
+
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
+	if (du_wip->ip)
+		xfs_dir_update_hook(src_dp, du_wip->ip, 1, src_name);
+	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 5e8b18f3f0036..57b124abb17f4 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -293,6 +293,30 @@ static inline unsigned char xfs_ascii_ci_xfrm(unsigned char c)
 	return c;
 }
 
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
+#else
+# define xfs_dir_update_hook(dp, ip, delta, name)	((void)0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 struct xfs_parent_args;
 
 struct xfs_dir_update {
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 9a8bd6f050af9..74be3b7341b51 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -26,6 +26,7 @@
 #include "xfs_da_format.h"
 #include "xfs_da_btree.h"
 #include "xfs_dir2_priv.h"
+#include "xfs_dir2.h"
 #include "xfs_attr.h"
 #include "xfs_reflink.h"
 #include "xfs_ag.h"
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1a87ccf4e0474..bafa13ae3c1d7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -663,72 +663,6 @@ xfs_icreate_args_rootfile(
 		args->flags |= XFS_ICREATE_ARGS_INIT_XATTRS;
 }
 
-#ifdef CONFIG_XFS_LIVE_HOOKS
-/*
- * Use a static key here to reduce the overhead of directory live update hooks.
- * If the compiler supports jump labels, the static branch will be replaced by
- * a nop sled when there are no hook users.  Online fsck is currently the only
- * caller, so this is a reasonable tradeoff.
- *
- * Note: Patching the kernel code requires taking the cpu hotplug lock.  Other
- * parts of the kernel allocate memory with that lock held, which means that
- * XFS callers cannot hold any locks that might be used by memory reclaim or
- * writeback when calling the static_branch_{inc,dec} functions.
- */
-DEFINE_STATIC_XFS_HOOK_SWITCH(xfs_dir_hooks_switch);
-
-void
-xfs_dir_hook_disable(void)
-{
-	xfs_hooks_switch_off(&xfs_dir_hooks_switch);
-}
-
-void
-xfs_dir_hook_enable(void)
-{
-	xfs_hooks_switch_on(&xfs_dir_hooks_switch);
-}
-
-/* Call hooks for a directory update relating to a child dirent update. */
-inline void
-xfs_dir_update_hook(
-	struct xfs_inode		*dp,
-	struct xfs_inode		*ip,
-	int				delta,
-	const struct xfs_name		*name)
-{
-	if (xfs_hooks_switched_on(&xfs_dir_hooks_switch)) {
-		struct xfs_dir_update_params	p = {
-			.dp		= dp,
-			.ip		= ip,
-			.delta		= delta,
-			.name		= name,
-		};
-		struct xfs_mount	*mp = ip->i_mount;
-
-		xfs_hooks_call(&mp->m_dir_update_hooks, 0, &p);
-	}
-}
-
-/* Call the specified function during a directory update. */
-int
-xfs_dir_hook_add(
-	struct xfs_mount	*mp,
-	struct xfs_dir_hook	*hook)
-{
-	return xfs_hooks_add(&mp->m_dir_update_hooks, &hook->dirent_hook);
-}
-
-/* Stop calling the specified function during a directory update. */
-void
-xfs_dir_hook_del(
-	struct xfs_mount	*mp,
-	struct xfs_dir_hook	*hook)
-{
-	xfs_hooks_del(&mp->m_dir_update_hooks, &hook->dirent_hook);
-}
-#endif /* CONFIG_XFS_LIVE_HOOKS */
-
 int
 xfs_icreate_dqalloc(
 	const struct xfs_icreate_args	*args,
@@ -841,12 +775,6 @@ xfs_create(
 	if (error)
 		goto out_trans_cancel;
 
-	/*
-	 * Create ip with a reference from dp, and add '.' and '..' references
-	 * if it's a directory.
-	 */
-	xfs_dir_update_hook(dp, du.ip, 1, name);
-
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * create transaction goes to disk before returning to
@@ -1060,8 +988,6 @@ xfs_link(
 	if (error)
 		goto error_return;
 
-	xfs_dir_update_hook(tdp, sip, 1, target_name);
-
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * link transaction goes to disk before returning to
@@ -2120,12 +2046,6 @@ xfs_remove(
 	if (error)
 		goto out_trans_cancel;
 
-	/*
-	 * Drop the link from dp to ip, and if ip was a directory, remove the
-	 * '.' and '..' references since we freed the directory.
-	 */
-	xfs_dir_update_hook(dp, ip, -1, name);
-
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * remove transaction goes to disk before returning to
@@ -2282,19 +2202,6 @@ xfs_cross_rename(
 	if (error)
 		goto out_trans_abort;
 
-	/*
-	 * Inform our hook clients that we've finished an exchange operation as
-	 * follows: removed the source and target files from their directories;
-	 * added the target to the source directory; and added the source to
-	 * the target directory.  All inodes are locked, so it's ok to model a
-	 * rename this way so long as we say we deleted entries before we add
-	 * new ones.
-	 */
-	xfs_dir_update_hook(dp1, ip1, -1, name1);
-	xfs_dir_update_hook(dp2, ip2, -1, name2);
-	xfs_dir_update_hook(dp1, ip2, 1, name1);
-	xfs_dir_update_hook(dp2, ip1, 1, name2);
-
 	return xfs_finish_rename(tp);
 
 out_trans_abort:
@@ -2577,21 +2484,6 @@ xfs_rename(
 		VFS_I(du_wip.ip)->i_state &= ~I_LINKABLE;
 	}
 
-	/*
-	 * Inform our hook clients that we've finished a rename operation as
-	 * follows: removed the source and target files from their directories;
-	 * that we've added the source to the target directory; and finally
-	 * that we've added the whiteout, if there was one.  All inodes are
-	 * locked, so it's ok to model a rename this way so long as we say we
-	 * deleted entries before we add new ones.
-	 */
-	if (target_ip)
-		xfs_dir_update_hook(target_dp, target_ip, -1, target_name);
-	xfs_dir_update_hook(src_dp, src_ip, -1, src_name);
-	xfs_dir_update_hook(target_dp, src_ip, 1, target_name);
-	if (du_wip.ip)
-		xfs_dir_update_hook(src_dp, du_wip.ip, 1, src_name);
-
 	error = xfs_finish_rename(tp);
 	nospace_error = 0;
 	goto out_unlock;
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 6433492e7301f..cc6a075505636 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -630,31 +630,6 @@ void xfs_inode_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
 		xfs_filblks_t *dblocks, xfs_filblks_t *rblocks);
 unsigned int xfs_inode_alloc_unitsize(struct xfs_inode *ip);
 
-struct xfs_dir_update_params {
-	const struct xfs_inode	*dp;
-	const struct xfs_inode	*ip;
-	const struct xfs_name	*name;
-	int			delta;
-};
-
-#ifdef CONFIG_XFS_LIVE_HOOKS
-void xfs_dir_update_hook(struct xfs_inode *dp, struct xfs_inode *ip,
-		int delta, const struct xfs_name *name);
-
-struct xfs_dir_hook {
-	struct xfs_hook		dirent_hook;
-};
-
-void xfs_dir_hook_disable(void);
-void xfs_dir_hook_enable(void);
-
-int xfs_dir_hook_add(struct xfs_mount *mp, struct xfs_dir_hook *hook);
-void xfs_dir_hook_del(struct xfs_mount *mp, struct xfs_dir_hook *hook);
-
-#else
-# define xfs_dir_update_hook(dp, ip, delta, name)	((void)0)
-#endif /* CONFIG_XFS_LIVE_HOOKS */
-
 void xfs_icreate_args_inherit(struct xfs_icreate_args *args,
 		struct xfs_inode *dp, struct mnt_idmap *idmap, umode_t mode,
 		bool init_xattrs);
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index a923160a7dae0..e7936858dfcf5 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -204,8 +204,6 @@ xfs_symlink(
 	if (error)
 		goto out_trans_cancel;
 
-	xfs_dir_update_hook(dp, du.ip, 1, link_name);
-
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * symlink transaction goes to disk before returning to

