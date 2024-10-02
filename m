Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8061F1103
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 01:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727831755; cv=none; b=BebptpTP56S4ZAFlc1STROSIAnkl/CUGiHZwBy0E1lL8RGNl74lHBnkNh4pi18kMSed7CpHlo72iwiGGnEByvcyzKJWsDUsOs+0sFdhnuOVXHQ2fLkrs0zuteSWJ8VIH/moujJPNFdlV6LGvT/Co+BhEMkEQxoT+uju1kkl2ijk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727831755; c=relaxed/simple;
	bh=/RbGkjgEeGYdgllsclxqUMR4Rc10eBtuQj96ShBq8YM=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kql8MA+OFD2BTXaxoTnqlgHihdj7TrrIP0Qtu8PolK3phk8HYPSJj9uTU5xke3IsMTsCUu/MOmcM2pHhNG9SxReStKNueHGHqLM8LCM5eqUSFVacDFBb7MXWVgcB+KWtQFSGNaVMk2iOYjz+OiJO63bRYd0hIV5sl4f7n5tmVSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DBw7AGZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBw7AGZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69A6C4CED1;
	Wed,  2 Oct 2024 01:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727831755;
	bh=/RbGkjgEeGYdgllsclxqUMR4Rc10eBtuQj96ShBq8YM=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=DBw7AGZWb6rNjh70YJSodNuyncy2bYUuRaOEPwoF2MVqgJQrRp5PtV6tnk+lzvewK
	 EdfMq0sizZ4q1H5NCGgqftj3GCyB4JCX/U72/xjosHeenOl0cK4TrPah2Axvl5h9eT
	 LtvumIXWTS8DxF66TyAQAy8alVDuBMYjC7QB8EMYkon8qHu11s1WbEYdS/HPYEp4eR
	 WYkVIaXUCn8ePb1vI+TtVO3c9ZuqQF65yuPaDwc/RZhRCB6PcaJa61593cy1V81g2U
	 0F3mZM7lZFVk6mShP1pZm03bV5EkNumPMICkP3tSfam4D7uur8wpJvLDuoeufZjIRo
	 hgTw4wSexOrYw==
Date: Tue, 01 Oct 2024 18:15:54 -0700
Subject: [PATCH 31/64] xfs: move dirent update hooks to xfs_dir2.c
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org, cem@kernel.org
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Message-ID: <172783102249.4036371.2695826082675791518.stgit@frogsfrogsfrogs>
In-Reply-To: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
References: <172783101710.4036371.10020616537589726441.stgit@frogsfrogsfrogs>
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

Source kernel commit: 62bbf50bea21b1c76990fd1bae58a65660a11c27

Move the directory entry update hook code to xfs_dir2 so that it is
mostly consolidated with the higher level directory functions.  Retain
the exports so that online fsck can still send notifications through the
hooks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_dir2.c |  104 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_dir2.h |   25 +++++++++++++
 2 files changed, 129 insertions(+)


diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c
index c2bab8f03..0b026d5f5 100644
--- a/libxfs/xfs_dir2.c
+++ b/libxfs/xfs_dir2.c
@@ -761,6 +761,81 @@ xfs_dir2_compname(
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
@@ -808,6 +883,7 @@ xfs_dir_create_child(
 			return error;
 	}
 
+	xfs_dir_update_hook(dp, ip, 1, name);
 	return 0;
 }
 
@@ -872,6 +948,7 @@ xfs_dir_add_child(
 			return error;
 	}
 
+	xfs_dir_update_hook(dp, ip, 1, name);
 	return 0;
 }
 
@@ -953,6 +1030,7 @@ xfs_dir_remove_child(
 			return error;
 	}
 
+	xfs_dir_update_hook(dp, ip, -1, name);
 	return 0;
 }
 
@@ -1078,6 +1156,18 @@ xfs_dir_exchange_children(
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
 
@@ -1304,5 +1394,19 @@ xfs_dir_rename_children(
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
diff --git a/libxfs/xfs_dir2.h b/libxfs/xfs_dir2.h
index df6d4bbe3..576068ed8 100644
--- a/libxfs/xfs_dir2.h
+++ b/libxfs/xfs_dir2.h
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

