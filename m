Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC207C6EB
	for <linux-xfs@vger.kernel.org>; Thu, 20 Jun 2024 23:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718924649; cv=none; b=JdIpG94xyzF4TlbJ9zSPJVwrGea1ToOF5mX7eJhNY93k9nQ6E0bGMf1f4ONPbIDs64FxtCKzbCVc94BBhBHvnMWWJXf+FTnWOfuLmN6QsehkT41ooNzV8tFTERDNdhy+Vu0KPORf94eNQUmWh8lHejoP1AR4wXNWN3/Z4Yo0aEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718924649; c=relaxed/simple;
	bh=VfmA4h1asL7/Ph1DfPkpRVX/H/BLGhWETEqoUSqHK04=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AB8dTijP5dvX1LfuiQbApP5p5eo4NEzjUyv1jKLge2qO+J7hW6cFAyY5OwmOy72ZjkXC/YM5L/dBMB6+lrzSx3834/oDCsUBg4GiVe7BHN5i8UuP0TPRW+SOZwKvFaLtsL0yqinrsWRZBTId5kriVV7cuOBjNWSLyPF6jjMDVaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vi6Ec0XT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vi6Ec0XT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6C65C2BD10;
	Thu, 20 Jun 2024 23:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718924648;
	bh=VfmA4h1asL7/Ph1DfPkpRVX/H/BLGhWETEqoUSqHK04=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Vi6Ec0XTgjleWj83LblMJWWJVkPZQa/nPADRU9fjBbQB3S7lwmJm4rHGDR0tzlDkP
	 FVWOw7yX+nCERhnmj+tdJoJV+4SOQx5NrARiYgrbHa3pbv5toGZBTarsi+1vDTCRRm
	 oguOxiRjaVzX/H15q1u/VDoPPzUHwqfQdUeK311LFMjseolMUfPuvIl+KaOy1mIFFd
	 JySeAnby+RuQKL8eMZtGTJEGkyCgmkYvm6kPq1oZ7AAKudDN3+TsGoKpeg6xuJYJ56
	 bW/jLVjuJ5ZTa7fizn8KM6DzaNElSqOq4l9O7L1epovzN7/P6/TwVLEXt9SBHn8iep
	 Wjmfp3mEvGT8g==
Date: Thu, 20 Jun 2024 16:04:08 -0700
Subject: [PATCH 22/24] xfs: move dirent update hooks to xfs_dir2.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Message-ID: <171892418278.3183075.2874879886308264652.stgit@frogsfrogsfrogs>
In-Reply-To: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
References: <171892417831.3183075.10759987417835165626.stgit@frogsfrogsfrogs>
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
 fs/xfs/libxfs/xfs_dir2.c |  104 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/libxfs/xfs_dir2.h |   25 ++++++++++
 fs/xfs/scrub/common.c    |    1 
 fs/xfs/xfs_inode.c       |  117 ----------------------------------------------
 fs/xfs/xfs_inode.h       |   25 ----------
 fs/xfs/xfs_symlink.c     |    2 -
 6 files changed, 130 insertions(+), 144 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 34b63ba2e4f71..202468223bf94 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -762,6 +762,81 @@ xfs_dir2_compname(
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
+
+/* Configure directory update hook functions. */
+void
+xfs_dir_hook_setup(
+	struct xfs_dir_hook	*hook,
+	notifier_fn_t		mod_fn)
+{
+	xfs_hook_setup(&hook->dirent_hook, mod_fn);
+}
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 /*
  * Given a directory @dp, a newly allocated inode @ip, and a @name, link @ip
  * into @dp under the given @name.  If @ip is a directory, it will be
@@ -809,6 +884,7 @@ xfs_dir_create_child(
 			return error;
 	}
 
+	xfs_dir_update_hook(dp, ip, 1, name);
 	return 0;
 }
 
@@ -873,6 +949,7 @@ xfs_dir_add_child(
 			return error;
 	}
 
+	xfs_dir_update_hook(dp, ip, 1, name);
 	return 0;
 }
 
@@ -954,6 +1031,7 @@ xfs_dir_remove_child(
 			return error;
 	}
 
+	xfs_dir_update_hook(dp, ip, -1, name);
 	return 0;
 }
 
@@ -1079,6 +1157,18 @@ xfs_dir_exchange_children(
 			return error;
 	}
 
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
 	return 0;
 }
 
@@ -1305,5 +1395,19 @@ xfs_dir_rename_children(
 			return error;
 	}
 
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
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index df6d4bbe3d6f9..576068ed81fac 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -309,6 +309,31 @@ static inline unsigned char xfs_ascii_ci_xfrm(unsigned char c)
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
+void xfs_dir_hook_setup(struct xfs_dir_hook *hook, notifier_fn_t mod_fn);
+#else
+# define xfs_dir_update_hook(dp, ip, delta, name)	((void)0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 struct xfs_parent_args;
 
 struct xfs_dir_update {
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 1ad8ec63a7f44..22f5f1a9d3f09 100644
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
index 99bd811b309d8..d79a191ed6068 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -600,81 +600,6 @@ xfs_icreate(
 	return 0;
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
-
-/* Configure directory update hook functions. */
-void
-xfs_dir_hook_setup(
-	struct xfs_dir_hook	*hook,
-	notifier_fn_t		mod_fn)
-{
-	xfs_hook_setup(&hook->dirent_hook, mod_fn);
-}
-#endif /* CONFIG_XFS_LIVE_HOOKS */
-
 /* Return dquots for the ids that will be assigned to a new file. */
 int
 xfs_icreate_dqalloc(
@@ -798,12 +723,6 @@ xfs_create(
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
@@ -1025,8 +944,6 @@ xfs_link(
 	if (error)
 		goto error_return;
 
-	xfs_dir_update_hook(tdp, sip, 1, target_name);
-
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * link transaction goes to disk before returning to
@@ -2079,12 +1996,6 @@ xfs_remove(
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
@@ -2241,19 +2152,6 @@ xfs_cross_rename(
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
@@ -2535,21 +2433,6 @@ xfs_rename(
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
index 5ee044674c3ab..51defdebef30e 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -632,31 +632,6 @@ void xfs_inode_count_blocks(struct xfs_trans *tp, struct xfs_inode *ip,
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
-void xfs_dir_hook_setup(struct xfs_dir_hook *hook, notifier_fn_t mod_fn);
-#else
-# define xfs_dir_update_hook(dp, ip, delta, name)	((void)0)
-#endif /* CONFIG_XFS_LIVE_HOOKS */
-
 int xfs_icreate_dqalloc(const struct xfs_icreate_args *args,
 		struct xfs_dquot **udqpp, struct xfs_dquot **gdqpp,
 		struct xfs_dquot **pdqpp);
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index c0f5c2e1f215b..77f19e2f66e07 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -200,8 +200,6 @@ xfs_symlink(
 	if (error)
 		goto out_trans_cancel;
 
-	xfs_dir_update_hook(dp, du.ip, 1, link_name);
-
 	/*
 	 * If this is a synchronous mount, make sure that the
 	 * symlink transaction goes to disk before returning to

