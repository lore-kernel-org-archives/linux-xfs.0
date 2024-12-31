Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AD813FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688394; cv=none; b=i7JRZvO0JyZeqMEVlZUj+MUt0yfZgyrVDdcuhnW/sSsYr2NFXmCk2IQfLDWlqTiRFtGSKbF5MlGojUEdT85ZC1H2k/dIjB10Sj5yvtJg/qeyDh+L9M7NbR24T6YiYBFy4U+00ozMJVnMUmFAvtFvbCxHOTotPdWCaHWbzBT009Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688394; c=relaxed/simple;
	bh=Mu/xVmYiOZu6FP9uxHXeUZ3vNuoUv5PvE5WxF9nzIEQ=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b5BgMZUwmcVz26CqJRx/C4XBRl8t/Fnwnehlu0clD0eX0X8rna9Wd+p3FNg5MqmT+BReiszNrr0LtAE70djVB02Fzb6YUVYxP2UuZlybJb3uA9eqQTfblDSMDrWM0e6stcGCWeQA9hS9S+RIccfGqcuqQHvPFsTiBxs2lxZCKVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WW76uK3o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WW76uK3o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51D26C4CED2;
	Tue, 31 Dec 2024 23:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688394;
	bh=Mu/xVmYiOZu6FP9uxHXeUZ3vNuoUv5PvE5WxF9nzIEQ=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WW76uK3oYwwFNxgvUjow1ylEluZZRRO55zfIBFxr1WeIZgzNNSW2RLtifc5PMlHFd
	 lVM4VpxhC3BRXtKxtaOpWjqo8gzP6Sn2iBugM5780f5c4HlijSfH/c/EuI3/1b4+Zm
	 tRzISgJqNUuK2rn4WqWfoFbb2GpLbTIbk48f1GiuYuYVMfmg3LvO0SiZ0bg+Bh+NOQ
	 XC2EB/lkb5I4d/BXhXsGx/jSOCxaMufyzLgycObSD8A3lcYbb3Y5jtAEXQLHbLDB7e
	 mT3xBDn4HxUUm+pSd3om67MVAZC8UFQKl0REXukXJWks3B/ONPjFun7+riOTjbAmvr
	 xR55ukbfYMGcQ==
Date: Tue, 31 Dec 2024 15:39:53 -0800
Subject: [PATCH 04/16] xfs: create hooks for media errors
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754811.2704911.2065068508446949767.stgit@frogsfrogsfrogs>
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

Set up a media error event hook so that we can send events to userspace.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_mount.h          |    3 ++
 fs/xfs/xfs_notify_failure.c |   86 ++++++++++++++++++++++++++++++++++++++++---
 fs/xfs/xfs_notify_failure.h |   38 +++++++++++++++++++
 fs/xfs/xfs_super.c          |    1 +
 4 files changed, 122 insertions(+), 6 deletions(-)


diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a8c81c4ccb2000..3fcfdaaf199315 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -346,6 +346,9 @@ typedef struct xfs_mount {
 
 	/* Hook to feed shutdown events to a daemon. */
 	struct xfs_hooks	m_shutdown_hooks;
+
+	/* Hook to feed media error events to a daemon. */
+	struct xfs_hooks	m_media_error_hooks;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index ed8d8ed42f0a2c..ea68c7e61bb585 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -27,6 +27,73 @@
 #include <linux/dax.h>
 #include <linux/fs.h>
 
+#ifdef CONFIG_XFS_LIVE_HOOKS
+DEFINE_STATIC_XFS_HOOK_SWITCH(xfs_media_error_hooks_switch);
+
+void
+xfs_media_error_hook_disable(void)
+{
+	xfs_hooks_switch_off(&xfs_media_error_hooks_switch);
+}
+
+void
+xfs_media_error_hook_enable(void)
+{
+	xfs_hooks_switch_on(&xfs_media_error_hooks_switch);
+}
+
+/* Call downstream hooks for a media error. */
+static inline void
+xfs_media_error_hook(
+	struct xfs_mount		*mp,
+	enum xfs_failed_device		fdev,
+	xfs_daddr_t			daddr,
+	uint64_t			bbcount,
+	bool				pre_remove)
+{
+	if (xfs_hooks_switched_on(&xfs_media_error_hooks_switch)) {
+		struct xfs_media_error_params p = {
+			.mp		= mp,
+			.fdev		= fdev,
+			.daddr		= daddr,
+			.bbcount	= bbcount,
+			.pre_remove	= pre_remove,
+		};
+
+		xfs_hooks_call(&mp->m_media_error_hooks, 0, &p);
+	}
+}
+
+/* Call the specified function during a media error. */
+int
+xfs_media_error_hook_add(
+	struct xfs_mount		*mp,
+	struct xfs_media_error_hook	*hook)
+{
+	return xfs_hooks_add(&mp->m_media_error_hooks, &hook->error_hook);
+}
+
+/* Stop calling the specified function during a media error. */
+void
+xfs_media_error_hook_del(
+	struct xfs_mount		*mp,
+	struct xfs_media_error_hook	*hook)
+{
+	xfs_hooks_del(&mp->m_media_error_hooks, &hook->error_hook);
+}
+
+/* Configure media error hook functions. */
+void
+xfs_media_error_hook_setup(
+	struct xfs_media_error_hook	*hook,
+	notifier_fn_t			mod_fn)
+{
+	xfs_hook_setup(&hook->error_hook, mod_fn);
+}
+#else
+# define xfs_media_error_hook(...)		((void)0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 struct xfs_failure_info {
 	xfs_agblock_t		startblock;
 	xfs_extlen_t		blockcount;
@@ -215,6 +282,9 @@ xfs_dax_notify_logdev_failure(
 	if (error)
 		return error;
 
+	xfs_media_error_hook(mp, XFS_FAILED_LOGDEV, daddr, bblen,
+			mf_flags & MF_MEM_PRE_REMOVE);
+
 	/*
 	 * In the pre-remove case the failure notification is attempting to
 	 * trigger a force unmount.  The expectation is that the device is
@@ -248,17 +318,21 @@ xfs_dax_notify_dev_failure(
 	uint64_t		bblen;
 	struct xfs_group	*xg = NULL;
 
+	error = xfs_dax_translate_range(type == XG_TYPE_RTG ?
+			mp->m_rtdev_targp : mp->m_ddev_targp,
+			offset, len, &daddr, &bblen);
+	if (error)
+		return error;
+
+	xfs_media_error_hook(mp, type == XG_TYPE_RTG ?
+			XFS_FAILED_RTDEV : XFS_FAILED_DATADEV,
+			daddr, bblen, mf_flags & MF_MEM_PRE_REMOVE);
+
 	if (!xfs_has_rmapbt(mp)) {
 		xfs_debug(mp, "notify_failure() needs rmapbt enabled!");
 		return -EOPNOTSUPP;
 	}
 
-	error = xfs_dax_translate_range(type == XG_TYPE_RTG ?
-			mp->m_rtdev_targp : mp->m_ddev_targp,
-			offset, len, &daddr, &bblen);
-	if (error)
-		return error;
-
 	if (type == XG_TYPE_RTG) {
 		start_bno = xfs_daddr_to_rtb(mp, daddr);
 		end_bno = xfs_daddr_to_rtb(mp, daddr + bblen - 1);
diff --git a/fs/xfs/xfs_notify_failure.h b/fs/xfs/xfs_notify_failure.h
index 41108044d35d47..835d4af504d832 100644
--- a/fs/xfs/xfs_notify_failure.h
+++ b/fs/xfs/xfs_notify_failure.h
@@ -8,4 +8,42 @@
 
 extern const struct dax_holder_operations xfs_dax_holder_operations;
 
+enum xfs_failed_device {
+	XFS_FAILED_DATADEV,
+	XFS_FAILED_LOGDEV,
+	XFS_FAILED_RTDEV,
+};
+
+#if defined(CONFIG_XFS_LIVE_HOOKS) && defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_FS_DAX)
+struct xfs_media_error_params {
+	struct xfs_mount		*mp;
+	enum xfs_failed_device		fdev;
+	xfs_daddr_t			daddr;
+	uint64_t			bbcount;
+	bool				pre_remove;
+};
+
+struct xfs_media_error_hook {
+	struct xfs_hook			error_hook;
+};
+
+void xfs_media_error_hook_disable(void);
+void xfs_media_error_hook_enable(void);
+
+int xfs_media_error_hook_add(struct xfs_mount *mp,
+		struct xfs_media_error_hook *hook);
+void xfs_media_error_hook_del(struct xfs_mount *mp,
+		struct xfs_media_error_hook *hook);
+void xfs_media_error_hook_setup(struct xfs_media_error_hook *hook,
+		notifier_fn_t mod_fn);
+#else
+struct xfs_media_error_params { };
+struct xfs_media_error_hook { };
+# define xfs_media_error_hook_disable()		((void)0)
+# define xfs_media_error_hook_enable()		((void)0)
+# define xfs_media_error_hook_add(...)		(0)
+# define xfs_media_error_hook_del(...)		((void)0)
+# define xfs_media_error_hook_setup(...)	((void)0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 #endif /* __XFS_NOTIFY_FAILURE_H__ */
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 71aa97a5d1dcaa..a49082159faae8 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2184,6 +2184,7 @@ xfs_init_fs_context(
 	xfs_hooks_init(&mp->m_dir_update_hooks);
 	xfs_hooks_init(&mp->m_shutdown_hooks);
 	xfs_hooks_init(&mp->m_health_update_hooks);
+	xfs_hooks_init(&mp->m_media_error_hooks);
 
 	fc->s_fs_info = mp;
 	fc->ops = &xfs_context_ops;

