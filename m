Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D497B1B0418
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688378; cv=none; b=HQdivox6ESSR0GsOhtHgbB/60vZ2fnHmxcfSnAUJD78N2smYiY9Q9FbDFOvA8N1u1ZO+09tTjHkbnocpMASAtBLb7Eb+Q85vGWM7RrfvsL7exq+MrQuAfYkqjSmNNo9ZUKME+2tnDIH3x8IE9nxXqPXeRBZV6gvT3w4oDaj+B1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688378; c=relaxed/simple;
	bh=PoBuSyub+8zLJpF8DRtWEE/GFVI3KxKjUyEoqjLLl0Y=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IoYbVhnMYQTHalYQGqagahu2UIOdrcYsVlIx/rRq6hQUWcOBA5kcXkIKBxUBsi3UgMxAmUIxDlXkSmqlLhtqv743R4A4xzY/hdi7AikoV7Ocrx8oi1U+FSvKXJNW4re78eAZrTx4NeVPBAXpEBvBXGddJCB+J0XEVRBeUQBlk8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cTCBCmHa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cTCBCmHa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2081C4CED2;
	Tue, 31 Dec 2024 23:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688378;
	bh=PoBuSyub+8zLJpF8DRtWEE/GFVI3KxKjUyEoqjLLl0Y=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=cTCBCmHaeoEdiu7rExLDnFHmkRx/knL1HpBjXOXnoWk8OIzjzDRn6kzdONs7se56g
	 r7gMfUARpMZ+27cgikUduLQaNzYrUGuJzXb7VZpOwmJLnr9jGg+pP2dtHAHlUNd2oR
	 7weAAnE52D1IVbP61t8z6ll/joyWE0cga34arPQtrv9ED8xC8NidZrgmuCiws3/Kbk
	 5JnXIbyUbbhagsxiweRiqA7LJIIJXenco59jquIDEbycZ0zfHYuUBEiUSvfzoxEI2/
	 8y3JvFnrh8nI0wUJ6e9m7GX1rlmgYR4Y68AwILb1D5SYuy0ct2yJ/9eLRk4sZFs19H
	 rHtSpAjuPyVtQ==
Date: Tue, 31 Dec 2024 15:39:38 -0800
Subject: [PATCH 03/16] xfs: create a filesystem shutdown hook
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754794.2704911.7718279790539710344.stgit@frogsfrogsfrogs>
In-Reply-To: <173568754700.2704911.10879727466774074251.stgit@frogsfrogsfrogs>
References: <173568754700.2704911.10879727466774074251.stgit@frogsfrogsfrogs>
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

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_fsops.c |   57 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_fsops.h |   14 +++++++++++++
 fs/xfs/xfs_mount.h |    3 +++
 fs/xfs/xfs_super.c |    1 +
 4 files changed, 75 insertions(+)


diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index 150979c8333530..439e76f38ed42e 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -480,6 +480,61 @@ xfs_fs_goingdown(
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
@@ -538,6 +593,8 @@ xfs_do_force_shutdown(
 		"Please unmount the filesystem and rectify the problem(s)");
 	if (xfs_error_level >= XFS_ERRLEVEL_HIGH)
 		xfs_stack_trace();
+
+	xfs_shutdown_hook(mp, flags);
 }
 
 /*
diff --git a/fs/xfs/xfs_fsops.h b/fs/xfs/xfs_fsops.h
index 9d23c361ef56e4..7f6f876de072b1 100644
--- a/fs/xfs/xfs_fsops.h
+++ b/fs/xfs/xfs_fsops.h
@@ -15,4 +15,18 @@ int xfs_fs_goingdown(struct xfs_mount *mp, uint32_t inflags);
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
index df5e4a48af72b7..a8c81c4ccb2000 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -343,6 +343,9 @@ typedef struct xfs_mount {
 
 	/* Hook to feed health events to a daemon. */
 	struct xfs_hooks	m_health_update_hooks;
+
+	/* Hook to feed shutdown events to a daemon. */
+	struct xfs_hooks	m_shutdown_hooks;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index e4789dfe1a369e..71aa97a5d1dcaa 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2182,6 +2182,7 @@ xfs_init_fs_context(
 	mp->m_allocsize_log = 16; /* 64k */
 
 	xfs_hooks_init(&mp->m_dir_update_hooks);
+	xfs_hooks_init(&mp->m_shutdown_hooks);
 	xfs_hooks_init(&mp->m_health_update_hooks);
 
 	fc->s_fs_info = mp;

