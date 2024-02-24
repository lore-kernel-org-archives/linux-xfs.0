Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B077F1864;
	Sat, 24 Feb 2024 01:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708737178; cv=none; b=T4F62Le5Wlb8TAFt2SPm8SI+1Atd3WY5EdARQOiTnnTL4tVMhKtD2UIvQLL3swUPBoBqQQm/+C29sWb/20DhZvIY6mk9+AU1VL5Y4XN2biU1RZS1vhLQwy/ykOWkcroCt/q7rhwpTV05vFLzI6r4EJaJGxGIc+F33e/721krtQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708737178; c=relaxed/simple;
	bh=WCaATn8+bSWEvtAKAMZilX9KcqT5ML8jRC19G1VrbVo=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Uu0QGhF59OPh8iBfGOVJAcIpWhgZdNkZHy2uYJAPXiq5KRSrXAJ7QubxmpzZWALnNP+oqyJ/1j6t1j1udHochYjM/oCs/da46cCDau/i9Xk+X1O9YOVd0QWQNwVzJVjN8jDzkXHuujn1debMjJN93W4PXm2sV6HXgB30jf9okAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h/V15Lgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h/V15Lgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F83EC433C7;
	Sat, 24 Feb 2024 01:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708737178;
	bh=WCaATn8+bSWEvtAKAMZilX9KcqT5ML8jRC19G1VrbVo=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=h/V15Lgz7NzZoZgEcjaRe/Qp9bADe8Va/AY9uVMSdmY73vm203AGqBufCFvuojo0m
	 HCE0IV+v0kTc0UxYwgqnJHkyFEXTlxmzsSJqgnYN0GD/nC1eICixrCDrZdWRKCz8pm
	 AXsCh256WTxqyrtoYFRSL1tJVj/5X4/eSwPmXWFBnX8mx2VPxNmE4ePzaeFOZjismm
	 5KkbdajOQT42reyvhnBiI4bPPvC6ZuRkSRQfx9ArryPoPMjtGieVC+2LG/NvO0SjEB
	 HqJUoVYAq5KVPsRHvwz1JNbu7OLGuJYdwT3D/tgtZUg1Qqggn/F1koPAQn9EL3hO18
	 nZg/pCP322tqA==
Date: Fri, 23 Feb 2024 17:12:57 -0800
Subject: [PATCH 1/4] xfs: present wait time statistics
From: "Darrick J. Wong" <djwong@kernel.org>
To: kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org
Message-ID: <170873668463.1861246.2262291401585063104.stgit@frogsfrogsfrogs>
In-Reply-To: <170873668436.1861246.6578314737824782019.stgit@frogsfrogsfrogs>
References: <170873668436.1861246.6578314737824782019.stgit@frogsfrogsfrogs>
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

Plumb in Kent's timestats code so we can observe wait times for log
grant heads, buffer, inode, and dquot locks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Kconfig         |    8 +++
 fs/xfs/Makefile        |    1 
 fs/xfs/xfs_buf.c       |    4 ++
 fs/xfs/xfs_dquot.c     |   11 +++++
 fs/xfs/xfs_dquot.h     |    4 ++
 fs/xfs/xfs_inode.c     |   12 ++++-
 fs/xfs/xfs_linux.h     |    4 ++
 fs/xfs/xfs_log.c       |    9 ++++
 fs/xfs/xfs_mount.h     |   13 +++++
 fs/xfs/xfs_super.c     |    6 +++
 fs/xfs/xfs_timestats.c |  115 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_timestats.h |   34 ++++++++++++++
 12 files changed, 219 insertions(+), 2 deletions(-)
 create mode 100644 fs/xfs/xfs_timestats.c
 create mode 100644 fs/xfs/xfs_timestats.h


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index b0cac77c90572..e0fa9b382fbeb 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -5,6 +5,7 @@ config XFS_FS
 	select EXPORTFS
 	select LIBCRC32C
 	select FS_IOMAP
+	select TIME_STATS if XFS_TIME_STATS
 	help
 	  XFS is a high performance journaling filesystem which originated
 	  on the SGI IRIX platform.  It is completely multi-threaded, can
@@ -120,6 +121,13 @@ config XFS_RT
 
 	  If unsure, say N.
 
+config XFS_TIME_STATS
+	bool "Collect time statistics for XFS filesystems"
+	depends on XFS_FS
+	default y
+	help
+	  Collects time statistics on various operations in the filesystem.
+
 config XFS_DRAIN_INTENTS
 	bool
 	select JUMP_LABEL if HAVE_ARCH_JUMP_LABEL
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 0c3b4cd4f9c84..bf3bacfb7afff 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -153,6 +153,7 @@ xfs-$(CONFIG_XFS_DRAIN_INTENTS)	+= xfs_drain.o
 xfs-$(CONFIG_XFS_LIVE_HOOKS)	+= xfs_hooks.o
 xfs-$(CONFIG_XFS_MEMORY_BUFS)	+= xfs_buf_mem.o
 xfs-$(CONFIG_XFS_BTREE_IN_MEM)	+= libxfs/xfs_btree_mem.o
+xfs-$(CONFIG_XFS_TIME_STATS)	+= xfs_timestats.o
 
 # online scrub/repair
 ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index 503ce7aff0c30..b11515f7f270f 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -22,6 +22,7 @@
 #include "xfs_error.h"
 #include "xfs_ag.h"
 #include "xfs_buf_mem.h"
+#include "xfs_timestats.h"
 
 struct kmem_cache *xfs_buf_cache;
 
@@ -1183,11 +1184,14 @@ void
 xfs_buf_lock(
 	struct xfs_buf		*bp)
 {
+	DEFINE_XFS_TIMESTAT(start_time);
+
 	trace_xfs_buf_lock(bp, _RET_IP_);
 
 	if (atomic_read(&bp->b_pin_count) && (bp->b_flags & XBF_STALE))
 		xfs_log_force(bp->b_mount, 0);
 	down(&bp->b_sema);
+	xfs_timestats_end(&bp->b_mount->m_timestats.ts_buflock, start_time);
 
 	trace_xfs_buf_lock_done(bp, _RET_IP_);
 }
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 2919b9bdf0cb0..515ffe0fcfe29 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -25,6 +25,7 @@
 #include "xfs_bmap_btree.h"
 #include "xfs_error.h"
 #include "xfs_health.h"
+#include "xfs_timestats.h"
 
 /*
  * Lock order:
@@ -45,6 +46,16 @@ static struct kmem_cache	*xfs_dquot_cache;
 static struct lock_class_key xfs_dquot_group_class;
 static struct lock_class_key xfs_dquot_project_class;
 
+#ifdef CONFIG_XFS_TIME_STATS
+void xfs_dqlock(struct xfs_dquot *dqp)
+{
+	DEFINE_XFS_TIMESTAT(start_time);
+
+	mutex_lock(&dqp->q_qlock);
+	xfs_timestats_end(&dqp->q_mount->m_timestats.ts_dqlock, start_time);
+}
+#endif
+
 /* Record observations of quota corruption with the health tracking system. */
 static void
 xfs_dquot_mark_sick(
diff --git a/fs/xfs/xfs_dquot.h b/fs/xfs/xfs_dquot.h
index 677bb2dc9ac91..6523a1f713139 100644
--- a/fs/xfs/xfs_dquot.h
+++ b/fs/xfs/xfs_dquot.h
@@ -120,10 +120,14 @@ static inline int xfs_dqlock_nowait(struct xfs_dquot *dqp)
 	return mutex_trylock(&dqp->q_qlock);
 }
 
+#ifdef CONFIG_XFS_TIME_STATS
+void xfs_dqlock(struct xfs_dquot *dqp);
+#else
 static inline void xfs_dqlock(struct xfs_dquot *dqp)
 {
 	mutex_lock(&dqp->q_qlock);
 }
+#endif
 
 static inline void xfs_dqunlock(struct xfs_dquot *dqp)
 {
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index d5ce9bd85a111..8d81e6ac77397 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -44,6 +44,7 @@
 #include "xfs_xattr.h"
 #include "xfs_inode_util.h"
 #include "xfs_imeta.h"
+#include "xfs_timestats.h"
 
 struct kmem_cache *xfs_inode_cache;
 
@@ -161,10 +162,17 @@ xfs_ilock(
 				 XFS_MMAPLOCK_DEP(lock_flags));
 	}
 
-	if (lock_flags & XFS_ILOCK_EXCL)
+	if (lock_flags & XFS_ILOCK_EXCL) {
+		DEFINE_XFS_TIMESTAT(start_time);
+
 		mrupdate_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
-	else if (lock_flags & XFS_ILOCK_SHARED)
+		xfs_timestats_end(&ip->i_mount->m_timestats.ts_ilock, start_time);
+	} else if (lock_flags & XFS_ILOCK_SHARED) {
+		DEFINE_XFS_TIMESTAT(start_time);
+
 		mraccess_nested(&ip->i_lock, XFS_ILOCK_DEP(lock_flags));
+		xfs_timestats_end(&ip->i_mount->m_timestats.ts_ilock, start_time);
+	}
 }
 
 /*
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 953466922ddf7..27f9ec7721a93 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -64,6 +64,10 @@ typedef __u32			xfs_nlink_t;
 #include <linux/xattr.h>
 #include <linux/mnt_idmapping.h>
 #include <linux/debugfs.h>
+#ifdef CONFIG_XFS_TIME_STATS
+# include <linux/seq_buf.h>
+# include <linux/time_stats.h>
+#endif
 
 #include <asm/page.h>
 #include <asm/div64.h>
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index a604eac68ea9e..a30be4ab780bb 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -20,6 +20,7 @@
 #include "xfs_sysfs.h"
 #include "xfs_sb.h"
 #include "xfs_health.h"
+#include "xfs_timestats.h"
 
 struct kmem_cache	*xfs_log_ticket_cache;
 
@@ -403,6 +404,7 @@ xfs_log_regrant(
 	struct xlog_ticket	*tic)
 {
 	struct xlog		*log = mp->m_log;
+	DECLARE_XFS_TIMESTAT(start_time);
 	int			need_bytes;
 	int			error = 0;
 
@@ -427,12 +429,15 @@ xfs_log_regrant(
 
 	trace_xfs_log_regrant(log, tic);
 
+	xfs_timestats_start(&start_time);
 	error = xlog_grant_head_check(log, &log->l_write_head, tic,
 				      &need_bytes);
 	if (error)
 		goto out_error;
 
 	xlog_grant_add_space(log, &log->l_write_head.grant, need_bytes);
+	xfs_timestats_end(&mp->m_timestats.ts_log_regrant, start_time);
+
 	trace_xfs_log_regrant_exit(log, tic);
 	xlog_verify_grant_tail(log);
 	return 0;
@@ -466,6 +471,7 @@ xfs_log_reserve(
 {
 	struct xlog		*log = mp->m_log;
 	struct xlog_ticket	*tic;
+	DECLARE_XFS_TIMESTAT(start_time);
 	int			need_bytes;
 	int			error = 0;
 
@@ -483,6 +489,7 @@ xfs_log_reserve(
 
 	trace_xfs_log_reserve(log, tic);
 
+	xfs_timestats_start(&start_time);
 	error = xlog_grant_head_check(log, &log->l_reserve_head, tic,
 				      &need_bytes);
 	if (error)
@@ -490,6 +497,8 @@ xfs_log_reserve(
 
 	xlog_grant_add_space(log, &log->l_reserve_head.grant, need_bytes);
 	xlog_grant_add_space(log, &log->l_write_head.grant, need_bytes);
+	xfs_timestats_end(&mp->m_timestats.ts_log_reserve, start_time);
+
 	trace_xfs_log_reserve_exit(log, tic);
 	xlog_verify_grant_tail(log);
 	return 0;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 01934c567f760..7cfd209404365 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -72,6 +72,17 @@ struct xfs_inodegc {
 	unsigned int		cpu;
 };
 
+struct xfs_timestats {
+#ifdef CONFIG_XFS_TIME_STATS
+	struct time_stats	ts_log_reserve;
+	struct time_stats	ts_log_regrant;
+	struct time_stats	ts_ilock;
+	struct time_stats	ts_buflock;
+	struct time_stats	ts_dqlock;
+	struct dentry		*ts_debugfs;
+#endif
+};
+
 /*
  * The struct xfsmount layout is optimised to separate read-mostly variables
  * from variables that are frequently modified. We put the read-mostly variables
@@ -271,6 +282,8 @@ typedef struct xfs_mount {
 
 	/* Hook to feed dirent updates to an active online repair. */
 	struct xfs_hooks	m_dir_update_hooks;
+
+	struct xfs_timestats	m_timestats;
 } xfs_mount_t;
 
 #define M_IGEO(mp)		(&(mp)->m_ino_geo)
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index fa4db490b74a0..69f1c1d85edf6 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -46,6 +46,7 @@
 #include "xfs_exchmaps_item.h"
 #include "xfs_parent.h"
 #include "xfs_rtalloc.h"
+#include "xfs_timestats.h"
 #include "scrub/stats.h"
 #include "scrub/rcbag_btree.h"
 
@@ -768,6 +769,7 @@ xfs_mount_free(
 		xfs_free_buftarg(mp->m_ddev_targp);
 
 	debugfs_remove(mp->m_debugfs);
+	xfs_timestats_destroy(mp);
 	kfree(mp->m_rtname);
 	kfree(mp->m_logname);
 	kmem_free(mp);
@@ -1146,6 +1148,7 @@ xfs_fs_put_super(
 	xfs_rtmount_freesb(mp);
 	xfs_freesb(mp);
 	xchk_mount_stats_free(mp);
+	xfs_timestats_unexport(mp);
 	free_percpu(mp->m_stats.xs_stats);
 	xfs_inodegc_free_percpu(mp);
 	xfs_destroy_percpu_counters(mp);
@@ -1580,6 +1583,7 @@ xfs_fs_fill_super(
 		goto out_destroy_inodegc;
 	}
 
+	xfs_timestats_export(mp);
 	error = xchk_mount_stats_alloc(mp);
 	if (error)
 		goto out_free_stats;
@@ -1805,6 +1809,7 @@ xfs_fs_fill_super(
 	xfs_freesb(mp);
  out_free_scrub_stats:
 	xchk_mount_stats_free(mp);
+	xfs_timestats_unexport(mp);
  out_free_stats:
 	free_percpu(mp->m_stats.xs_stats);
  out_destroy_inodegc:
@@ -2065,6 +2070,7 @@ static int xfs_init_fs_context(
 	mp->m_allocsize_log = 16; /* 64k */
 
 	xfs_hooks_init(&mp->m_dir_update_hooks);
+	xfs_timestats_init(mp);
 
 	fc->s_fs_info = mp;
 	fc->ops = &xfs_context_ops;
diff --git a/fs/xfs/xfs_timestats.c b/fs/xfs/xfs_timestats.c
new file mode 100644
index 0000000000000..163a37e6717f7
--- /dev/null
+++ b/fs/xfs/xfs_timestats.c
@@ -0,0 +1,115 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sb.h"
+#include "xfs_mount.h"
+#include "xfs_timestats.h"
+
+/* Format a timestats report into a buffer. */
+static ssize_t
+xfs_timestats_read(
+	struct file		*file,
+	char __user		*ubuf,
+	size_t			count,
+	loff_t			*ppos)
+{
+	struct seq_buf		s;
+	struct time_stats	*ts = file->private_data;
+	char			*buf;
+	ssize_t			ret;
+
+	/*
+	 * This generates a stringly snapshot of a timestats report, so we
+	 * do not want userspace to receive garbled text from multiple calls.
+	 * If the file position is greater than 0, return a short read.
+	 */
+	if (*ppos > 0)
+		return 0;
+
+	buf = kzalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	seq_buf_init(&s, buf, PAGE_SIZE);
+	time_stats_to_seq_buf(&s, ts, "mount", TIME_STATS_PRINT_NO_ZEROES);
+	ret = simple_read_from_buffer(ubuf, count, ppos, buf, seq_buf_used(&s));
+	kfree(buf);
+	return ret;
+}
+
+const struct file_operations xfs_timestats_fops = {
+	.open			= simple_open,
+	.read			= xfs_timestats_read,
+};
+
+/* Set up timestats collection. */
+void
+xfs_timestats_init(
+	struct xfs_mount	*mp)
+{
+	struct xfs_timestats	*ts = &mp->m_timestats;
+
+	time_stats_init(&ts->ts_log_reserve);
+	time_stats_init(&ts->ts_log_regrant);
+	time_stats_init(&ts->ts_ilock);
+	time_stats_init(&ts->ts_buflock);
+	time_stats_init(&ts->ts_dqlock);
+}
+
+/* Free all resources used by timestats collection. */
+void
+xfs_timestats_destroy(
+	struct xfs_mount	*mp)
+{
+	struct xfs_timestats	*ts = &mp->m_timestats;
+
+	time_stats_exit(&ts->ts_log_reserve);
+	time_stats_exit(&ts->ts_log_regrant);
+	time_stats_exit(&ts->ts_ilock);
+	time_stats_exit(&ts->ts_buflock);
+	time_stats_exit(&ts->ts_dqlock);
+}
+
+/* Export timestats via debugfs */
+#define X(p, ts, name) \
+	debugfs_create_file("blocked::" #name, 0444, (p), &(ts)->ts_##name, \
+			&xfs_timestats_fops)
+void
+xfs_timestats_export(
+	struct xfs_mount	*mp)
+{
+	struct dentry		*parent;
+	struct xfs_timestats	*ts = &mp->m_timestats;
+
+	if (!mp->m_debugfs)
+		return;
+
+	parent = xfs_debugfs_mkdir("time_stats", mp->m_debugfs);
+	if (!parent)
+		return;
+	ts->ts_debugfs = parent;
+
+	X(parent, ts, log_reserve);
+	X(parent, ts, log_regrant);
+	X(parent, ts, ilock);
+	X(parent, ts, buflock);
+	X(parent, ts, dqlock);
+}
+#undef X
+
+/* Delete debugfs entries for timestats */
+void
+xfs_timestats_unexport(
+	struct xfs_mount	*mp)
+{
+	struct xfs_timestats	*ts = &mp->m_timestats;
+
+	debugfs_remove(ts->ts_debugfs);
+}
diff --git a/fs/xfs/xfs_timestats.h b/fs/xfs/xfs_timestats.h
new file mode 100644
index 0000000000000..e53dbb40c8fff
--- /dev/null
+++ b/fs/xfs/xfs_timestats.h
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_TIMESTATS_H__
+#define __XFS_TIMESTATS_H__
+
+#ifdef CONFIG_XFS_TIME_STATS
+extern const struct file_operations xfs_timestats_fops;
+
+void xfs_timestats_init(struct xfs_mount *mp);
+void xfs_timestats_export(struct xfs_mount *mp);
+void xfs_timestats_unexport(struct xfs_mount *mp);
+void xfs_timestats_destroy(struct xfs_mount *mp);
+
+# define DECLARE_XFS_TIMESTAT(name)	u64 name
+# define DEFINE_XFS_TIMESTAT(name)	u64 name = local_clock()
+# define xfs_timestats_start(b)		do { *(b) = local_clock(); } while (0)
+# define xfs_timestats_end(a, b)	time_stats_update((a), (b))
+#else
+# define xfs_timestats_init(mp)		((void)0)
+# define xfs_timestats_export(mp)	((void)0)
+# define xfs_timestats_unexport(mp)	((void)0)
+# define xfs_timestats_destroy(mp)	((void)0)
+
+# define DECLARE_XFS_TIMESTAT(name)
+# define DEFINE_XFS_TIMESTAT(name)
+# define xfs_timestats_start(t)		((void)0)
+# define xfs_timestats_end(s, t)	((void)0)
+#endif /* CONFIG_XFS_TIME_STATS */
+
+#endif /* __XFS_TIMESTATS_H__ */
+

