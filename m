Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26A4138A;
	Sat, 24 Feb 2024 01:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708737506; cv=none; b=TZfvjIRKFKmWbGzpP98oZfhyeXmyGWlwa9zs/aIAl9RIgR9VOYdVN4CWI/oi7c69uuaaA1uzQ6Upp/en6B0F4q9fj9yg5dVTIHXEW7Ei482TzvO+ClJ78Yn0VtBODPdK/Ua317x+tPj0YKzgh77hsOK9JPdREW+sRE4fJtsou14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708737506; c=relaxed/simple;
	bh=dr5n0qNUMHb+lAcoc923a7rGhNrn8TfRo0P3GSKudBc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X8EkS8t41CVSVE39B6YbusV7s31yHSbR79r/IrffY9EKnTEP6TdecNs2yCVhzLcTAqK8muTsUY9CEDf3NNpxUE8oqOzOtLuUO7BfmVys0yARywirL/hZsY27YkupaY966eXorbA2Hd/G64uzFmiJ6ovxihtw8dwYJ7QilGxSTHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QFXDHW/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QFXDHW/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E37C433C7;
	Sat, 24 Feb 2024 01:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708737506;
	bh=dr5n0qNUMHb+lAcoc923a7rGhNrn8TfRo0P3GSKudBc=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=QFXDHW/e3g8A0dkuF5Bim+e/cpjoCGSvRi6kPqu0U1rqchcAVYGx2w82YoJrxgQFY
	 hGulRP6ec7DM86IsRqocPJxGeZanV6D6FoWReRA95UlQoZ1pN78af09ZVeNNrB5DZ7
	 f/7CZaM7eTqRBVkz/a09q9/bfuvAaV7oFnxXSwEkuzhQUnvm6rVoEu3XJ1UXZtls+T
	 y6PEvmzoXUlBUAsuqY3MaXK+/BqzfrO0lujB3dnPr5STBw9quiP3lKhnDvrsiq/Snl
	 tRA5o3pky3/7+R8AAQMtFCkceLfEJMiKIkJwMoIr+hB55cp2w7xmKJHmmdRfmv7iUR
	 YNTbSNC13ztZg==
Date: Fri, 23 Feb 2024 17:18:25 -0800
Subject: [PATCH 3/8] xfs: create a filesystem shutdown hook
From: "Darrick J. Wong" <djwong@kernel.org>
To: kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org
Message-ID: <170873669913.1861872.6763071331514594527.stgit@frogsfrogsfrogs>
In-Reply-To: <170873669843.1861872.1241932246549132485.stgit@frogsfrogsfrogs>
References: <170873669843.1861872.1241932246549132485.stgit@frogsfrogsfrogs>
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

Create a hook so that health monitoring can report filesystem shutdown
events to userspace.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsops.h |   14 +++++++++++++
 fs/xfs/xfs_mount.h |    3 +++
 fs/xfs/xfs_super.c |    1 +
 4 files changed, 75 insertions(+)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index a2929a0e0367e..ac2960c44bb84 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -483,6 +483,61 @@ xfs_fs_goingdown(
 	return 0;
 }
 
+#ifdef CONFIG_XFS_LIVE_HOOKS
+DEFINE_STATIC_XFS_HOOK_SWITCH(xfs_shutdown_hooks_switch);
+
+void
+xfs_shutdown_hook_disable(void)
+{
+	xfs_hooks_switch_off(&xfs_shutdown_hooks_switch);
+}
+
+void
+xfs_shutdown_hook_enable(void)
+{
+	xfs_hooks_switch_on(&xfs_shutdown_hooks_switch);
+}
+
+/* Call downstream hooks for a filesystem shutdown. */
+static inline void
+xfs_shutdown_hook(
+	struct xfs_mount		*mp,
+	uint32_t			flags)
+{
+	if (xfs_hooks_switched_on(&xfs_shutdown_hooks_switch))
+		xfs_hooks_call(&mp->m_shutdown_hooks, flags, NULL);
+}
+
+/* Call the specified function during a shutdown update. */
+int
+xfs_shutdown_hook_add(
+	struct xfs_mount		*mp,
+	struct xfs_shutdown_hook	*hook)
+{
+	return xfs_hooks_add(&mp->m_shutdown_hooks, &hook->shutdown_hook);
+}
+
+/* Stop calling the specified function during a shutdown update. */
+void
+xfs_shutdown_hook_del(
+	struct xfs_mount		*mp,
+	struct xfs_shutdown_hook	*hook)
+{
+	xfs_hooks_del(&mp->m_shutdown_hooks, &hook->shutdown_hook);
+}
+
+/* Configure shutdown update hook functions. */
+void
+xfs_shutdown_hook_setup(
+	struct xfs_shutdown_hook	*hook,
+	notifier_fn_t			mod_fn)
+{
+	xfs_hook_setup(&hook->shutdown_hook, mod_fn);
+}
+#else
+# define xfs_shutdown_hook(...)		((void)0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 /*
  * Force a shutdown of the filesystem instantly while keeping the filesystem
  * consistent. We don't do an unmount here; just shutdown the shop, make sure
@@ -541,6 +596,8 @@ xfs_do_force_shutdown(
 		"Please unmount the filesystem and rectify the problem(s)");
 	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
 		xfs_stack_trace();
+
+	xfs_shutdown_hook(mp, flags);
 }
 
 /*
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 3e2f73bcf8314..59df17decfbbf 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -14,4 +14,18 @@ int xfs_fs_goingdown(struct xfs_mount *mp, uint32_t inflags);
 int xfs_fs_reserve_ag_blocks(struct xfs_mount *mp);
 void xfs_fs_unreserve_ag_blocks(struct xfs_mount *mp);
 
+#ifdef CONFIG_XFS_LIVE_HOOKS
+struct xfs_shutdown_hook {
+	struct xfs_hook			shutdown_hook;
+};
+
+void xfs_shutdown_hook_disable(void);
+void xfs_shutdown_hook_enable(void);
+
+int xfs_shutdown_hook_add(struct xfs_mount *mp, struct xfs_shutdown_hook *hook);
+void xfs_shutdown_hook_del(struct xfs_mount *mp, struct xfs_shutdown_hook *hook);
+void xfs_shutdown_hook_setup(struct xfs_shutdown_hook *hook,
+		notifier_fn_t mod_fn);
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 #endif	/* __XFS_FSOPS_H__ */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 316240b79a1e9..f1db647b94871 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -287,6 +287,9 @@ typedef struct xfs_mount {
 	/* Hook to feed health events to a daemon. */
 	struct xfs_hooks	m_health_update_hooks;
 
+	/* Hook to feed shutdown events to a daemon. */
+	struct xfs_hooks	m_shutdown_hooks;
+
 	struct xfs_timestats	m_timestats;
 } xfs_mount_t;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 23dbb67a1344d..1ed848a3706be 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2081,6 +2081,7 @@ static int xfs_init_fs_context(
 	mp->m_allocsize_log = 16; /* 64k */
 
 	xfs_hooks_init(&mp->m_dir_update_hooks);
+	xfs_hooks_init(&mp->m_shutdown_hooks);
 	xfs_hooks_init(&mp->m_health_update_hooks);
 	xfs_timestats_init(mp);
 

