Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2695F4A05;
	Sat, 24 Feb 2024 01:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708737491; cv=none; b=TKm23zhe56WJm6mw8OCzq8RlYfYji5k1ICmZMMScY2p47kJ5dpLSK+n8VPPCm+C4x17gRaAUYgsmrCPFio1W1eBSuesXC6/8dNqfIW+SMpNilb1BDfm1J9THdtn7DECVrK52CNU1QQv+NEXKohajospTH6Yx5d7AQPdSwf4EX3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708737491; c=relaxed/simple;
	bh=E9mZ80ay58OSRzb4AAg68GKJTS2YXrGAKiOODN3sdcY=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BdXOJsMXev6WwsrG6EIY5KvGNG7YJdpKiDf7pG90Rle3QmS8BRgwS8ykTVlhte2TqLPSTPK1KmGL01NeGUwg2ebzb1giJb7TZDIz+0x8bOcSpioADyrGW3JraXeLMuo/iQVQ/7Q6bYC/DaiHKnYmCH60WeYHhfRLOS4SXD/i6iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NlB6k/Xj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NlB6k/Xj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC83CC433F1;
	Sat, 24 Feb 2024 01:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708737490;
	bh=E9mZ80ay58OSRzb4AAg68GKJTS2YXrGAKiOODN3sdcY=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=NlB6k/Xj3uT7mkn1bMj6CucejidtdN6d3G5Mwq3U9g6jjffaUceMiQICpAiuo6L9x
	 wgOGsUIxW9adU59MExJOOuMYDTJUtnf0XZrZi24tEHrsSZgaoss9aQFCZh9VU+j9WF
	 4nh4kPN1smvwRqNaj7As9C2s6CZXUZNhEVzYDantXE3zouvFioxdHfUcKa2fzqQyPV
	 kVnHiNGZ8JGQFLKGHQ6MO0lifXsrTqy4Y3dlqy2z5WP1k0JDIk3JN+EJOJfytzyqCE
	 SHITmoSL1nVbqkKilZ8kUlYtWozMVL1QFkhM1l8IN3pMDTr/WUv5U+CGotkHAS4uDd
	 m26sUhRIazSjw==
Date: Fri, 23 Feb 2024 17:18:10 -0800
Subject: [PATCH 2/8] xfs: create hooks for monitoring health updates
From: "Darrick J. Wong" <djwong@kernel.org>
To: kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org
Message-ID: <170873669896.1861872.13165225160395901473.stgit@frogsfrogsfrogs>
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

Create hooks for monitoring health events.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_health.h |   48 ++++++++
 fs/xfs/xfs_health.c        |  266 ++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_mount.h         |    3 
 fs/xfs/xfs_super.c         |    1 
 4 files changed, 317 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/libxfs/xfs_health.h b/fs/xfs/libxfs/xfs_health.h
index 89b80e957917e..3c508a71ec91e 100644
--- a/fs/xfs/libxfs/xfs_health.h
+++ b/fs/xfs/libxfs/xfs_health.h
@@ -331,4 +331,52 @@ void xfs_bulkstat_health(struct xfs_inode *ip, struct xfs_bulkstat *bs);
 #define xfs_metadata_is_sick(error) \
 	(unlikely((error) == -EFSCORRUPTED || (error) == -EFSBADCRC))
 
+/*
+ * Parameters for tracking health updates.  The enum below is passed as the
+ * hook function argument.
+ */
+enum xfs_health_update_type {
+	XFS_HEALTHUP_SICK = 1,	/* runtime corruption observed */
+	XFS_HEALTHUP_CORRUPT,	/* fsck reported corruption */
+	XFS_HEALTHUP_HEALTHY,	/* fsck reported healthy structure */
+	XFS_HEALTHUP_UNMOUNT,	/* filesystem is unmounting */
+};
+
+/* Where in the filesystem was the event observed? */
+enum xfs_health_update_domain {
+	XFS_HEALTHUP_FS = 1,	/* main filesystem */
+	XFS_HEALTHUP_RT,	/* realtime */
+	XFS_HEALTHUP_AG,	/* allocation group */
+	XFS_HEALTHUP_INODE,	/* inode */
+	XFS_HEALTHUP_RTGROUP,	/* realtime group */
+};
+
+struct xfs_health_update_params {
+	/* XFS_HEALTHUP_INODE */
+	xfs_ino_t			ino;
+	uint32_t			gen;
+
+	/* XFS_HEALTHUP_AG/RTGROUP */
+	uint32_t			group;
+
+	/* XFS_SICK_* flags */
+	unsigned int			old_mask;
+	unsigned int			new_mask;
+
+	enum xfs_health_update_domain	domain;
+};
+
+#ifdef CONFIG_XFS_LIVE_HOOKS
+struct xfs_health_hook {
+	struct xfs_hook			health_hook;
+};
+
+void xfs_health_hook_disable(void);
+void xfs_health_hook_enable(void);
+
+int xfs_health_hook_add(struct xfs_mount *mp, struct xfs_health_hook *hook);
+void xfs_health_hook_del(struct xfs_mount *mp, struct xfs_health_hook *hook);
+void xfs_health_hook_setup(struct xfs_health_hook *hook, notifier_fn_t mod_fn);
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 #endif	/* __XFS_HEALTH_H__ */
diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 33059d979857a..7e6cde66ef23a 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -20,6 +20,189 @@
 #include "xfs_quota_defs.h"
 #include "xfs_rtgroup.h"
 
+#ifdef CONFIG_XFS_LIVE_HOOKS
+/*
+ * Use a static key here to reduce the overhead of health updates.  If
+ * the compiler supports jump labels, the static branch will be replaced by a
+ * nop sled when there are no hook users.  Online fsck is currently the only
+ * caller, so this is a reasonable tradeoff.
+ *
+ * Note: Patching the kernel code requires taking the cpu hotplug lock.  Other
+ * parts of the kernel allocate memory with that lock held, which means that
+ * XFS callers cannot hold any locks that might be used by memory reclaim or
+ * writeback when calling the static_branch_{inc,dec} functions.
+ */
+DEFINE_STATIC_XFS_HOOK_SWITCH(xfs_health_hooks_switch);
+
+void
+xfs_health_hook_disable(void)
+{
+	xfs_hooks_switch_off(&xfs_health_hooks_switch);
+}
+
+void
+xfs_health_hook_enable(void)
+{
+	xfs_hooks_switch_on(&xfs_health_hooks_switch);
+}
+
+/* Call downstream hooks for a filesystem unmount health update. */
+static inline void
+xfs_health_unmount_hook(
+	struct xfs_mount		*mp)
+{
+	if (xfs_hooks_switched_on(&xfs_health_hooks_switch)) {
+		struct xfs_health_update_params	p = {
+			.domain		= XFS_HEALTHUP_FS,
+		};
+
+		xfs_hooks_call(&mp->m_health_update_hooks,
+				XFS_HEALTHUP_UNMOUNT, &p);
+	}
+}
+
+/* Call downstream hooks for a filesystem health update. */
+static inline void
+xfs_fs_health_update_hook(
+	struct xfs_mount		*mp,
+	enum xfs_health_update_type	op,
+	unsigned int			old_mask,
+	unsigned int			new_mask)
+{
+	if (xfs_hooks_switched_on(&xfs_health_hooks_switch)) {
+		struct xfs_health_update_params	p = {
+			.domain		= XFS_HEALTHUP_FS,
+			.old_mask	= old_mask,
+			.new_mask	= new_mask,
+		};
+
+		if (new_mask)
+			xfs_hooks_call(&mp->m_health_update_hooks, op, &p);
+	}
+}
+
+/* Call downstream hooks for a realtime health update. */
+static inline void
+xfs_rt_health_update_hook(
+	struct xfs_mount		*mp,
+	enum xfs_health_update_type	op,
+	unsigned int			old_mask,
+	unsigned int			new_mask)
+{
+	if (xfs_hooks_switched_on(&xfs_health_hooks_switch)) {
+		struct xfs_health_update_params	p = {
+			.domain		= XFS_HEALTHUP_RT,
+			.old_mask	= old_mask,
+			.new_mask	= new_mask,
+		};
+
+		if (new_mask)
+			xfs_hooks_call(&mp->m_health_update_hooks, op, &p);
+	}
+}
+
+/* Call downstream hooks for a perag health update. */
+static inline void
+xfs_ag_health_update_hook(
+	struct xfs_perag		*pag,
+	enum xfs_health_update_type	op,
+	unsigned int			old_mask,
+	unsigned int			new_mask)
+{
+	if (xfs_hooks_switched_on(&xfs_health_hooks_switch)) {
+		struct xfs_health_update_params	p = {
+			.domain		= XFS_HEALTHUP_AG,
+			.old_mask	= old_mask,
+			.new_mask	= new_mask,
+			.group		= pag->pag_agno,
+		};
+		struct xfs_mount	*mp = pag->pag_mount;
+
+		if (new_mask)
+			xfs_hooks_call(&mp->m_health_update_hooks, op, &p);
+	}
+}
+
+/* Call downstream hooks for an inode health update. */
+static inline void
+xfs_inode_health_update_hook(
+	struct xfs_inode		*ip,
+	enum xfs_health_update_type	op,
+	unsigned int			old_mask,
+	unsigned int			new_mask)
+{
+	if (xfs_hooks_switched_on(&xfs_health_hooks_switch)) {
+		struct xfs_health_update_params	p = {
+			.domain		= XFS_HEALTHUP_INODE,
+			.old_mask	= old_mask,
+			.new_mask	= new_mask,
+			.ino		= ip->i_ino,
+			.gen		= VFS_I(ip)->i_generation,
+		};
+		struct xfs_mount	*mp = ip->i_mount;
+
+		if (new_mask)
+			xfs_hooks_call(&mp->m_health_update_hooks, op, &p);
+	}
+}
+
+/* Call downstream hooks for a realtime group health update. */
+static inline void
+xfs_rtgroup_health_update_hook(
+	struct xfs_rtgroup		*rtg,
+	enum xfs_health_update_type	op,
+	unsigned int			old_mask,
+	unsigned int			new_mask)
+{
+	if (xfs_hooks_switched_on(&xfs_health_hooks_switch)) {
+		struct xfs_health_update_params	p = {
+			.domain		= XFS_HEALTHUP_RTGROUP,
+			.old_mask	= old_mask,
+			.new_mask	= new_mask,
+			.group		= rtg->rtg_rgno,
+		};
+		struct xfs_mount	*mp = rtg->rtg_mount;
+
+		if (new_mask)
+			xfs_hooks_call(&mp->m_health_update_hooks, op, &p);
+	}
+}
+
+/* Call the specified function during a health update. */
+int
+xfs_health_hook_add(
+	struct xfs_mount	*mp,
+	struct xfs_health_hook	*hook)
+{
+	return xfs_hooks_add(&mp->m_health_update_hooks, &hook->health_hook);
+}
+
+/* Stop calling the specified function during a health update. */
+void
+xfs_health_hook_del(
+	struct xfs_mount	*mp,
+	struct xfs_health_hook	*hook)
+{
+	xfs_hooks_del(&mp->m_health_update_hooks, &hook->health_hook);
+}
+
+/* Configure health update hook functions. */
+void
+xfs_health_hook_setup(
+	struct xfs_health_hook	*hook,
+	notifier_fn_t		mod_fn)
+{
+	xfs_hook_setup(&hook->health_hook, mod_fn);
+}
+#else
+# define xfs_health_unmount_hook(...)		((void)0)
+# define xfs_fs_health_update_hook(...)		((void)0)
+# define xfs_rt_health_update_hook(...)		((void)0)
+# define xfs_ag_health_update_hook(...)		((void)0)
+# define xfs_inode_health_update_hook(...)	((void)0)
+# define xfs_rtgroup_health_update_hook(...)	((void)0)
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 /*
  * Warn about metadata corruption that we detected but haven't fixed, and
  * make sure we're not sitting on anything that would get in the way of
@@ -37,8 +220,10 @@ xfs_health_unmount(
 	unsigned int		checked = 0;
 	bool			warn = false;
 
-	if (xfs_is_shutdown(mp))
+	if (xfs_is_shutdown(mp)) {
+		xfs_health_unmount_hook(mp);
 		return;
+	}
 
 	/* Measure AG corruption levels. */
 	for_each_perag(mp, agno, pag) {
@@ -101,6 +286,8 @@ xfs_health_unmount(
 		if (sick & XFS_SICK_FS_COUNTERS)
 			xfs_fs_mark_healthy(mp, XFS_SICK_FS_COUNTERS);
 	}
+
+	xfs_health_unmount_hook(mp);
 }
 
 /* Mark unhealthy per-fs metadata. */
@@ -109,12 +296,17 @@ xfs_fs_mark_sick(
 	struct xfs_mount	*mp,
 	unsigned int		mask)
 {
+	unsigned int		old_mask;
+
 	ASSERT(!(mask & ~XFS_SICK_FS_ALL));
 	trace_xfs_fs_mark_sick(mp, mask);
 
 	spin_lock(&mp->m_sb_lock);
+	old_mask = mp->m_fs_sick;
 	mp->m_fs_sick |= mask;
 	spin_unlock(&mp->m_sb_lock);
+
+	xfs_fs_health_update_hook(mp, XFS_HEALTHUP_SICK, old_mask, mask);
 }
 
 /* Mark per-fs metadata as having been checked and found unhealthy by fsck. */
@@ -123,13 +315,18 @@ xfs_fs_mark_corrupt(
 	struct xfs_mount	*mp,
 	unsigned int		mask)
 {
+	unsigned int		old_mask;
+
 	ASSERT(!(mask & ~XFS_SICK_FS_ALL));
 	trace_xfs_fs_mark_corrupt(mp, mask);
 
 	spin_lock(&mp->m_sb_lock);
+	old_mask = mp->m_fs_sick;
 	mp->m_fs_sick |= mask;
 	mp->m_fs_checked |= mask;
 	spin_unlock(&mp->m_sb_lock);
+
+	xfs_fs_health_update_hook(mp, XFS_HEALTHUP_CORRUPT, old_mask, mask);
 }
 
 /* Mark a per-fs metadata healed. */
@@ -138,15 +335,20 @@ xfs_fs_mark_healthy(
 	struct xfs_mount	*mp,
 	unsigned int		mask)
 {
+	unsigned int		old_mask;
+
 	ASSERT(!(mask & ~XFS_SICK_FS_ALL));
 	trace_xfs_fs_mark_healthy(mp, mask);
 
 	spin_lock(&mp->m_sb_lock);
+	old_mask = mp->m_fs_sick;
 	mp->m_fs_sick &= ~mask;
 	if (!(mp->m_fs_sick & XFS_SICK_FS_PRIMARY))
 		mp->m_fs_sick &= ~XFS_SICK_FS_SECONDARY;
 	mp->m_fs_checked |= mask;
 	spin_unlock(&mp->m_sb_lock);
+
+	xfs_fs_health_update_hook(mp, XFS_HEALTHUP_HEALTHY, old_mask, mask);
 }
 
 /* Sample which per-fs metadata are unhealthy. */
@@ -168,12 +370,17 @@ xfs_rt_mark_sick(
 	struct xfs_mount	*mp,
 	unsigned int		mask)
 {
+	unsigned int		old_mask;
+
 	ASSERT(!(mask & ~XFS_SICK_RT_ALL));
 	trace_xfs_rt_mark_sick(mp, mask);
 
 	spin_lock(&mp->m_sb_lock);
+	old_mask = mp->m_rt_sick;
 	mp->m_rt_sick |= mask;
 	spin_unlock(&mp->m_sb_lock);
+
+	xfs_rt_health_update_hook(mp, XFS_HEALTHUP_SICK, old_mask, mask);
 }
 
 /* Mark realtime metadata as having been checked and found unhealthy by fsck. */
@@ -182,13 +389,18 @@ xfs_rt_mark_corrupt(
 	struct xfs_mount	*mp,
 	unsigned int		mask)
 {
+	unsigned int		old_mask;
+
 	ASSERT(!(mask & ~XFS_SICK_RT_ALL));
 	trace_xfs_rt_mark_corrupt(mp, mask);
 
 	spin_lock(&mp->m_sb_lock);
+	old_mask = mp->m_rt_sick;
 	mp->m_rt_sick |= mask;
 	mp->m_rt_checked |= mask;
 	spin_unlock(&mp->m_sb_lock);
+
+	xfs_rt_health_update_hook(mp, XFS_HEALTHUP_CORRUPT, old_mask, mask);
 }
 
 /* Mark a realtime metadata healed. */
@@ -197,15 +409,20 @@ xfs_rt_mark_healthy(
 	struct xfs_mount	*mp,
 	unsigned int		mask)
 {
+	unsigned int		old_mask;
+
 	ASSERT(!(mask & ~XFS_SICK_RT_ALL));
 	trace_xfs_rt_mark_healthy(mp, mask);
 
 	spin_lock(&mp->m_sb_lock);
+	old_mask = mp->m_rt_sick;
 	mp->m_rt_sick &= ~mask;
 	if (!(mp->m_rt_sick & XFS_SICK_RT_PRIMARY))
 		mp->m_rt_sick &= ~XFS_SICK_RT_SECONDARY;
 	mp->m_rt_checked |= mask;
 	spin_unlock(&mp->m_sb_lock);
+
+	xfs_rt_health_update_hook(mp, XFS_HEALTHUP_HEALTHY, old_mask, mask);
 }
 
 /* Sample which realtime metadata are unhealthy. */
@@ -244,12 +461,17 @@ xfs_ag_mark_sick(
 	struct xfs_perag	*pag,
 	unsigned int		mask)
 {
+	unsigned int		old_mask;
+
 	ASSERT(!(mask & ~XFS_SICK_AG_ALL));
 	trace_xfs_ag_mark_sick(pag->pag_mount, pag->pag_agno, mask);
 
 	spin_lock(&pag->pag_state_lock);
+	old_mask = pag->pag_sick;
 	pag->pag_sick |= mask;
 	spin_unlock(&pag->pag_state_lock);
+
+	xfs_ag_health_update_hook(pag, XFS_HEALTHUP_SICK, old_mask, mask);
 }
 
 /* Mark per-ag metadata as having been checked and found unhealthy by fsck. */
@@ -258,13 +480,18 @@ xfs_ag_mark_corrupt(
 	struct xfs_perag	*pag,
 	unsigned int		mask)
 {
+	unsigned int		old_mask;
+
 	ASSERT(!(mask & ~XFS_SICK_AG_ALL));
 	trace_xfs_ag_mark_corrupt(pag->pag_mount, pag->pag_agno, mask);
 
 	spin_lock(&pag->pag_state_lock);
+	old_mask = pag->pag_sick;
 	pag->pag_sick |= mask;
 	pag->pag_checked |= mask;
 	spin_unlock(&pag->pag_state_lock);
+
+	xfs_ag_health_update_hook(pag, XFS_HEALTHUP_CORRUPT, old_mask, mask);
 }
 
 /* Mark per-ag metadata ok. */
@@ -273,15 +500,20 @@ xfs_ag_mark_healthy(
 	struct xfs_perag	*pag,
 	unsigned int		mask)
 {
+	unsigned int		old_mask;
+
 	ASSERT(!(mask & ~XFS_SICK_AG_ALL));
 	trace_xfs_ag_mark_healthy(pag->pag_mount, pag->pag_agno, mask);
 
 	spin_lock(&pag->pag_state_lock);
+	old_mask = pag->pag_sick;
 	pag->pag_sick &= ~mask;
 	if (!(pag->pag_sick & XFS_SICK_AG_PRIMARY))
 		pag->pag_sick &= ~XFS_SICK_AG_SECONDARY;
 	pag->pag_checked |= mask;
 	spin_unlock(&pag->pag_state_lock);
+
+	xfs_ag_health_update_hook(pag, XFS_HEALTHUP_HEALTHY, old_mask, mask);
 }
 
 /* Sample which per-ag metadata are unhealthy. */
@@ -320,12 +552,17 @@ xfs_rtgroup_mark_sick(
 	struct xfs_rtgroup	*rtg,
 	unsigned int		mask)
 {
+	unsigned int		old_mask;
+
 	ASSERT(!(mask & ~XFS_SICK_RG_ALL));
 	trace_xfs_rtgroup_mark_sick(rtg, mask);
 
 	spin_lock(&rtg->rtg_state_lock);
+	old_mask = rtg->rtg_sick;
 	rtg->rtg_sick |= mask;
 	spin_unlock(&rtg->rtg_state_lock);
+
+	xfs_rtgroup_health_update_hook(rtg, XFS_HEALTHUP_SICK, old_mask, mask);
 }
 
 /* Mark rtgroup metadata as having been checked and found unhealthy by fsck. */
@@ -334,13 +571,19 @@ xfs_rtgroup_mark_corrupt(
 	struct xfs_rtgroup	*rtg,
 	unsigned int		mask)
 {
+	unsigned int		old_mask;
+
 	ASSERT(!(mask & ~XFS_SICK_RG_ALL));
 	trace_xfs_rtgroup_mark_corrupt(rtg, mask);
 
 	spin_lock(&rtg->rtg_state_lock);
+	old_mask = rtg->rtg_sick;
 	rtg->rtg_sick |= mask;
 	rtg->rtg_checked |= mask;
 	spin_unlock(&rtg->rtg_state_lock);
+
+	xfs_rtgroup_health_update_hook(rtg, XFS_HEALTHUP_CORRUPT, old_mask,
+			mask);
 }
 
 /* Mark per-rtgroup metadata ok. */
@@ -349,15 +592,21 @@ xfs_rtgroup_mark_healthy(
 	struct xfs_rtgroup	*rtg,
 	unsigned int		mask)
 {
+	unsigned int		old_mask;
+
 	ASSERT(!(mask & ~XFS_SICK_RG_ALL));
 	trace_xfs_rtgroup_mark_healthy(rtg, mask);
 
 	spin_lock(&rtg->rtg_state_lock);
+	old_mask = rtg->rtg_sick;
 	rtg->rtg_sick &= ~mask;
 	if (!(rtg->rtg_sick & XFS_SICK_RT_PRIMARY))
 		rtg->rtg_sick &= ~XFS_SICK_RT_SECONDARY;
 	rtg->rtg_checked |= mask;
 	spin_unlock(&rtg->rtg_state_lock);
+
+	xfs_rtgroup_health_update_hook(rtg, XFS_HEALTHUP_HEALTHY, old_mask,
+			mask);
 }
 
 /* Sample which per-rtgroup metadata are unhealthy. */
@@ -379,10 +628,13 @@ xfs_inode_mark_sick(
 	struct xfs_inode	*ip,
 	unsigned int		mask)
 {
+	unsigned int		old_mask;
+
 	ASSERT(!(mask & ~XFS_SICK_INO_ALL));
 	trace_xfs_inode_mark_sick(ip, mask);
 
 	spin_lock(&ip->i_flags_lock);
+	old_mask = ip->i_sick;
 	ip->i_sick |= mask;
 	spin_unlock(&ip->i_flags_lock);
 
@@ -394,6 +646,8 @@ xfs_inode_mark_sick(
 	spin_lock(&VFS_I(ip)->i_lock);
 	VFS_I(ip)->i_state &= ~I_DONTCACHE;
 	spin_unlock(&VFS_I(ip)->i_lock);
+
+	xfs_inode_health_update_hook(ip, XFS_HEALTHUP_SICK, old_mask, mask);
 }
 
 /* Mark inode metadata as having been checked and found unhealthy by fsck. */
@@ -402,10 +656,13 @@ xfs_inode_mark_corrupt(
 	struct xfs_inode	*ip,
 	unsigned int		mask)
 {
+	unsigned int		old_mask;
+
 	ASSERT(!(mask & ~XFS_SICK_INO_ALL));
 	trace_xfs_inode_mark_corrupt(ip, mask);
 
 	spin_lock(&ip->i_flags_lock);
+	old_mask = ip->i_sick;
 	ip->i_sick |= mask;
 	ip->i_checked |= mask;
 	spin_unlock(&ip->i_flags_lock);
@@ -418,6 +675,8 @@ xfs_inode_mark_corrupt(
 	spin_lock(&VFS_I(ip)->i_lock);
 	VFS_I(ip)->i_state &= ~I_DONTCACHE;
 	spin_unlock(&VFS_I(ip)->i_lock);
+
+	xfs_inode_health_update_hook(ip, XFS_HEALTHUP_CORRUPT, old_mask, mask);
 }
 
 /* Mark parts of an inode healed. */
@@ -426,15 +685,20 @@ xfs_inode_mark_healthy(
 	struct xfs_inode	*ip,
 	unsigned int		mask)
 {
+	unsigned int		old_mask;
+
 	ASSERT(!(mask & ~XFS_SICK_INO_ALL));
 	trace_xfs_inode_mark_healthy(ip, mask);
 
 	spin_lock(&ip->i_flags_lock);
+	old_mask = ip->i_sick;
 	ip->i_sick &= ~mask;
 	if (!(ip->i_sick & XFS_SICK_INO_PRIMARY))
 		ip->i_sick &= ~XFS_SICK_INO_SECONDARY;
 	ip->i_checked |= mask;
 	spin_unlock(&ip->i_flags_lock);
+
+	xfs_inode_health_update_hook(ip, XFS_HEALTHUP_HEALTHY, old_mask, mask);
 }
 
 /* Sample which parts of an inode are unhealthy. */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 63649c259b9c5..316240b79a1e9 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -284,6 +284,9 @@ typedef struct xfs_mount {
 	/* Hook to feed dirent updates to an active online repair. */
 	struct xfs_hooks	m_dir_update_hooks;
 
+	/* Hook to feed health events to a daemon. */
+	struct xfs_hooks	m_health_update_hooks;
+
 	struct xfs_timestats	m_timestats;
 } xfs_mount_t;
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 29a53874490cc..23dbb67a1344d 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2081,6 +2081,7 @@ static int xfs_init_fs_context(
 	mp->m_allocsize_log = 16; /* 64k */
 
 	xfs_hooks_init(&mp->m_dir_update_hooks);
+	xfs_hooks_init(&mp->m_health_update_hooks);
 	xfs_timestats_init(mp);
 
 	fc->s_fs_info = mp;

