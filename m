Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79424C2C0
	for <linux-xfs@vger.kernel.org>; Sun, 31 Dec 2023 23:28:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q2oTPeHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2023C433C8;
	Sun, 31 Dec 2023 23:28:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704065329;
	bh=rUds+lLAQJqBdVnd4pr1TZzvbKqRvhntmgDEYeNyupk=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Q2oTPeHONnFiEAHJaiIKwo78gDq4VH24eiSA5BCF6sNak9V60ExdZHep0DDRpjSfo
	 CXVJmbreD6XU5WtHMeGRU3m2cgewjGOnU2izOEpROMGXLEIevbYbWPgg/eDCdX3nvo
	 /c6lL0tsN5E6NCpgl1SwLz+oj4Ji3kvyaZpGsHa400ivjY9dpYvpk//SHg52dTp4lE
	 4vinrsZuRO/CB76m3AEEbvrpNRJF2x8j2+BdUXd26f/eA1ZzcgD0zj6Ivrd/k1bcFA
	 GY1Xh/fhxmGpq8p1ZFO655dB0edytrmr/ZkO0mwao5KL28GN1B0W7OXCa53hInBRcC
	 ajN3U69DXuUJg==
Date: Sun, 31 Dec 2023 15:28:48 -0800
Subject: [PATCH 25/28] xfs: move dirent update hooks to xfs_dir2.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: cem@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <170405009508.1808635.13510398899941438968.stgit@frogsfrogsfrogs>
In-Reply-To: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
References: <170405009159.1808635.10158480820888604007.stgit@frogsfrogsfrogs>
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
 libxfs/xfs_dir2.c |  125 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 libxfs/xfs_dir2.h |   24 ++++++++++
 2 files changed, 144 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index 7a1d55dff69..bfdbcc3cd3e 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
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
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index 5e8b18f3f00..57b124abb17 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
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

