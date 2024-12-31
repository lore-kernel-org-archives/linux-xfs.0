Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DE113FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688441; cv=none; b=k7Qf0gu8tNbD7wN+Pwax2EF6oO4p15ayjh6PBB3DiDuEtUJz16mOfDU56w7EY+7IWDxFPGHPAamlqgCI3lFQi17o7SEfuH8ws6qPG8q1kEp2nhCOv5jLZvUzFo7MxfYfbmOYzcNxgQvmTTkaTSTQd4ZShqS7SLxfv58G1jFOMuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688441; c=relaxed/simple;
	bh=QoZyaTJB/V8pCUTDOox5BiFb5xSzVG4VKgm7A6gQYoo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CrVWP3q0/u8d1KMmN9aw7u94tp9hH7sdk1fXCDch6Eq95k4HeWGo1BPR4cY/6fki96krlb7VUpCyb0S89izTh4NKkbFvYj/+2vS06WWGPCDT9OkOIH4BSLwO9jyPfKNAooEkqGQZfRYQx86AaxpKMG0iB7cAc5tOofMjVmPXM8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RRrStCIp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RRrStCIp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447B7C4CED2;
	Tue, 31 Dec 2024 23:40:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688441;
	bh=QoZyaTJB/V8pCUTDOox5BiFb5xSzVG4VKgm7A6gQYoo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=RRrStCIpeM/kgXRoML6tlCvuBcA/QJBhY0P3ySBBuurlCrGAHwkevlB0Vx3nGSFRC
	 XQMs/z/Yly5jngnXxb51HgqweE0sIEaHEkYDiPWavG7yxdOqJnvW+VWrWVjIOv4vsM
	 73RvVMMOadJKHCA9E/j5M/2TZGT4aseE7W6aPz6wHkHoZBxgYSFoOkuGFAITt/910+
	 c3323pYcDpXVKSvr/niSc6D8nNNbhife3LPfOpyP6TC2vomiRNBOz2SaLs9iG51OUO
	 dgvyJUwby/IJu4kWQF4NvQBtbUKCw9uIBG9eOQveZC8cOzsHEFwICSp4I143c6uzH3
	 /hiTugXyP8qsQ==
Date: Tue, 31 Dec 2024 15:40:40 -0800
Subject: [PATCH 07/16] xfs: create file io error hooks
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754863.2704911.11267943332732791949.stgit@frogsfrogsfrogs>
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

Create hooks within XFS to deliver IO errors to callers.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/xfs_aops.c  |    2 +
 fs/xfs/xfs_file.c  |  167 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_file.h  |   36 +++++++++++
 fs/xfs/xfs_mount.h |    3 +
 fs/xfs/xfs_super.c |    1 
 5 files changed, 208 insertions(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 4319d0488f2146..7892b794085251 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -21,6 +21,7 @@
 #include "xfs_error.h"
 #include "xfs_zone_alloc.h"
 #include "xfs_rtgroup.h"
+#include "xfs_file.h"
 
 struct xfs_writepage_ctx {
 	struct iomap_writepage_ctx ctx;
@@ -722,6 +723,7 @@ const struct address_space_operations xfs_address_space_operations = {
 	.is_partially_uptodate  = iomap_is_partially_uptodate,
 	.error_remove_folio	= generic_error_remove_folio,
 	.swap_activate		= xfs_iomap_swapfile_activate,
+	.ioerror		= xfs_vm_ioerror,
 };
 
 const struct address_space_operations xfs_dax_aops = {
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index ceb7936e5fd9a3..cbeb60582cb15f 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -230,6 +230,169 @@ xfs_ilock_iocb_for_write(
 	return 0;
 }
 
+#ifdef CONFIG_XFS_LIVE_HOOKS
+DEFINE_STATIC_XFS_HOOK_SWITCH(xfs_file_ioerror_hooks_switch);
+
+void
+xfs_file_ioerror_hook_disable(void)
+{
+	xfs_hooks_switch_off(&xfs_file_ioerror_hooks_switch);
+}
+
+void
+xfs_file_ioerror_hook_enable(void)
+{
+	xfs_hooks_switch_on(&xfs_file_ioerror_hooks_switch);
+}
+
+struct xfs_file_ioerror {
+	struct work_struct		work;
+	struct xfs_mount		*mp;
+	xfs_ino_t			ino;
+	loff_t				pos;
+	u64				len;
+	u32				gen;
+	int				error;
+	enum xfs_file_ioerror_type	type;
+};
+
+/* Call downstream hooks for a file io error update. */
+STATIC void
+xfs_file_report_ioerror(
+	struct work_struct	*work)
+{
+	struct xfs_file_ioerror	*ioerr;
+
+	ioerr = container_of(work, struct xfs_file_ioerror, work);
+
+	if (xfs_hooks_switched_on(&xfs_file_ioerror_hooks_switch)) {
+		struct xfs_file_ioerror_params	p = {
+			.ino		= ioerr->ino,
+			.gen		= ioerr->gen,
+			.pos		= ioerr->pos,
+			.len		= ioerr->len,
+		};
+		struct xfs_mount	*mp = ioerr->mp;
+
+		xfs_hooks_call(&mp->m_file_ioerror_hooks, ioerr->type, &p);
+	}
+
+	kfree(ioerr);
+}
+
+/* Queue a directio io error notification. */
+STATIC void
+xfs_dio_ioerror(
+	struct inode		*inode,
+	int			direction,
+	loff_t			pos,
+	u64			len,
+	int			error)
+{
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_file_ioerror	*ioerr;
+
+	if (xfs_hooks_switched_on(&xfs_file_ioerror_hooks_switch)) {
+		ioerr = kzalloc(sizeof(*ioerr), GFP_ATOMIC);
+		if (!ioerr) {
+			xfs_err(mp,
+ "lost ioerror report for ino 0x%llx %s pos 0x%llx len 0x%llx error %d",
+					ip->i_ino,
+					direction == WRITE ? "WRITE" : "READ",
+					pos, len, error);
+			return;
+		}
+
+		INIT_WORK(&ioerr->work, xfs_file_report_ioerror);
+		ioerr->mp = mp;
+		ioerr->ino = ip->i_ino;
+		ioerr->gen = VFS_I(ip)->i_generation;
+		ioerr->pos = pos;
+		ioerr->len = len;
+		if (direction == WRITE)
+			ioerr->type = XFS_FILE_IOERROR_DIRECT_WRITE;
+		else
+			ioerr->type = XFS_FILE_IOERROR_DIRECT_READ;
+		ioerr->error = error;
+		queue_work(mp->m_unwritten_workqueue, &ioerr->work);
+	}
+}
+
+/* Queue a buffered io error notification. */
+void
+xfs_vm_ioerror(
+	struct address_space	*mapping,
+	int			direction,
+	loff_t			pos,
+	u64			len,
+	int			error)
+{
+	struct inode		*inode = mapping->host;
+	struct xfs_inode	*ip = XFS_I(inode);
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_file_ioerror	*ioerr;
+
+	if (xfs_hooks_switched_on(&xfs_file_ioerror_hooks_switch)) {
+		ioerr = kzalloc(sizeof(*ioerr), GFP_ATOMIC);
+		if (!ioerr) {
+			xfs_err(mp,
+ "lost ioerror report for ino 0x%llx %s pos 0x%llx len 0x%llx error %d",
+					ip->i_ino,
+					direction == WRITE ? "WRITE" : "READ",
+					pos, len, error);
+			return;
+		}
+
+		INIT_WORK(&ioerr->work, xfs_file_report_ioerror);
+		ioerr->mp = mp;
+		ioerr->ino = ip->i_ino;
+		ioerr->gen = VFS_I(ip)->i_generation;
+		ioerr->pos = pos;
+		ioerr->len = len;
+		if (direction == WRITE)
+			ioerr->type = XFS_FILE_IOERROR_BUFFERED_WRITE;
+		else
+			ioerr->type = XFS_FILE_IOERROR_BUFFERED_READ;
+		ioerr->error = error;
+		queue_work(mp->m_unwritten_workqueue, &ioerr->work);
+	}
+}
+
+/* Call the specified function after a file io error. */
+int
+xfs_file_ioerror_hook_add(
+	struct xfs_mount		*mp,
+	struct xfs_file_ioerror_hook	*hook)
+{
+	return xfs_hooks_add(&mp->m_file_ioerror_hooks, &hook->ioerror_hook);
+}
+
+/* Stop calling the specified function after a file io error. */
+void
+xfs_file_ioerror_hook_del(
+	struct xfs_mount		*mp,
+	struct xfs_file_ioerror_hook	*hook)
+{
+	xfs_hooks_del(&mp->m_file_ioerror_hooks, &hook->ioerror_hook);
+}
+
+/* Configure file io error update hook functions. */
+void
+xfs_file_ioerror_hook_setup(
+	struct xfs_file_ioerror_hook	*hook,
+	notifier_fn_t			mod_fn)
+{
+	xfs_hook_setup(&hook->ioerror_hook, mod_fn);
+}
+#else
+# define xfs_dio_ioerror		NULL
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
+static const struct iomap_dio_ops xfs_dio_read_ops = {
+	.ioerror	= xfs_dio_ioerror,
+};
+
 STATIC ssize_t
 xfs_file_dio_read(
 	struct kiocb		*iocb,
@@ -248,7 +411,8 @@ xfs_file_dio_read(
 	ret = xfs_ilock_iocb(iocb, XFS_IOLOCK_SHARED);
 	if (ret)
 		return ret;
-	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, NULL, 0, NULL, 0);
+	ret = iomap_dio_rw(iocb, to, &xfs_read_iomap_ops, &xfs_dio_read_ops,
+			0, NULL, 0);
 	xfs_iunlock(ip, XFS_IOLOCK_SHARED);
 
 	return ret;
@@ -769,6 +933,7 @@ xfs_dio_write_end_io(
 
 static const struct iomap_dio_ops xfs_dio_write_ops = {
 	.end_io		= xfs_dio_write_end_io,
+	.ioerror	= xfs_dio_ioerror,
 };
 
 static void
diff --git a/fs/xfs/xfs_file.h b/fs/xfs/xfs_file.h
index c9d50699baba85..38c546cd498a52 100644
--- a/fs/xfs/xfs_file.h
+++ b/fs/xfs/xfs_file.h
@@ -17,4 +17,40 @@ int xfs_file_unshare_at(struct xfs_inode *ip, loff_t pos);
 
 long xfs_ioc_map_freesp(struct file *file, struct xfs_map_freesp __user	*argp);
 
+enum xfs_file_ioerror_type {
+	XFS_FILE_IOERROR_BUFFERED_READ,
+	XFS_FILE_IOERROR_BUFFERED_WRITE,
+	XFS_FILE_IOERROR_DIRECT_READ,
+	XFS_FILE_IOERROR_DIRECT_WRITE,
+};
+
+struct xfs_file_ioerror_params {
+	xfs_ino_t		ino;
+	loff_t			pos;
+	u64			len;
+	u32			gen;
+	int			error;
+};
+
+#ifdef CONFIG_XFS_LIVE_HOOKS
+struct xfs_file_ioerror_hook {
+	struct xfs_hook			ioerror_hook;
+};
+
+void xfs_file_ioerror_hook_disable(void);
+void xfs_file_ioerror_hook_enable(void);
+
+int xfs_file_ioerror_hook_add(struct xfs_mount *mp,
+		struct xfs_file_ioerror_hook *hook);
+void xfs_file_ioerror_hook_del(struct xfs_mount *mp,
+		struct xfs_file_ioerror_hook *hook);
+void xfs_file_ioerror_hook_setup(struct xfs_file_ioerror_hook *hook,
+		notifier_fn_t mod_fn);
+
+void xfs_vm_ioerror(struct address_space *mapping, int direction, loff_t pos,
+		u64 len, int error);
+#else
+# define xfs_vm_ioerror			NULL
+#endif /* CONFIG_XFS_LIVE_HOOKS */
+
 #endif /* __XFS_FILE_H__ */
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 3fcfdaaf199315..10b4ff3548601e 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -349,6 +349,9 @@ typedef struct xfs_mount {
 
 	/* Hook to feed media error events to a daemon. */
 	struct xfs_hooks	m_media_error_hooks;
+
+	/* Hook to feed file io error events to a daemon. */
+	struct xfs_hooks	m_file_ioerror_hooks;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index a49082159faae8..df6afcf8840948 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2185,6 +2185,7 @@ xfs_init_fs_context(
 	xfs_hooks_init(&mp->m_shutdown_hooks);
 	xfs_hooks_init(&mp->m_health_update_hooks);
 	xfs_hooks_init(&mp->m_media_error_hooks);
+	xfs_hooks_init(&mp->m_file_ioerror_hooks);
 
 	fc->s_fs_info = mp;
 	fc->ops = &xfs_context_ops;

