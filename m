Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AB017FE;
	Sat, 24 Feb 2024 01:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708737475; cv=none; b=cDDRtUMpZrfbkBtLkLuJJU0JI0oxFn/jHcCt2ZoGn1ZjlPVou/ihiHEkBbzpj2psfVHFx6sLtVu7LbZKesCzPwkmFySqrxsbU1qPCx05jxsI27OcYlGCUMmXHOUNEP8HWhK9PZOJFv4mkll5vg2UFihTTTRJcZyXikLI27dtC6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708737475; c=relaxed/simple;
	bh=sLNmKadMIQl09sx1cOGgPU9gMZWcSaisZuSKHdF5jm0=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iCz1k0qn5yN2MmY7UnpxfX+949i6S65rbQ2mpZgGhXHi/k9AJXIsSdu+pD8RDkCU2axpi2e4F8h9dD/ZolmXEPETG62uHM0nSdQPIFiHREWYCxDTKnW3zrqlYYGNgWQp0pu/j6x+DtcLM/CD+hkHHdg4dLfd1aRqbq/tCVaOWbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a+0VNxUQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a+0VNxUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C1FC433C7;
	Sat, 24 Feb 2024 01:17:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1708737475;
	bh=sLNmKadMIQl09sx1cOGgPU9gMZWcSaisZuSKHdF5jm0=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=a+0VNxUQ/E6OyPPKQLHvIm9WjIA9VyBUM6ppFH12+TEickyBcLO70+y4VtxAJE4Z8
	 lsGceQ/mVY3EnjAcmD1MQnUIhb4X80KBt3HsRa/7nvy8l+gq799z7iX2fpb8FJx4Hg
	 NWxa6TAE6SkPgISU4pZYe778BXFI9wLZ74aWkcaejhBzs972b3c6tDD2FevUGgYf6n
	 N/7RwMCu7wAnxNh8MNYK+fku6T6KQmT8CBwrmeQFJlarmuBajxNT+xSenF6NLpDZZq
	 ESG7sd2eXYywE6UKQqi+kLOLuryFZ8EJLJEytl7bsHfGAlXHgJco1ovAg/ceSP2ah3
	 fPmtafviVCS5A==
Date: Fri, 23 Feb 2024 17:17:54 -0800
Subject: [PATCH 1/8] xfs: use thread_with_file to create a monitoring file
From: "Darrick J. Wong" <djwong@kernel.org>
To: kent.overstreet@linux.dev, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org
Message-ID: <170873669879.1861872.15936945776135670310.stgit@frogsfrogsfrogs>
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

Use Kent Overstreet's thread_with_file abstraction to provide a magic
file from which we can read filesystem health events.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/Kconfig                 |    9 +++
 fs/xfs/Makefile                |    1 
 fs/xfs/libxfs/xfs_fs.h         |    1 
 fs/xfs/libxfs/xfs_fs_staging.h |   10 +++
 fs/xfs/xfs_healthmon.c         |  129 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_healthmon.h         |   15 +++++
 fs/xfs/xfs_ioctl.c             |   21 +++++++
 fs/xfs/xfs_linux.h             |    3 +
 8 files changed, 189 insertions(+)
 create mode 100644 fs/xfs/xfs_healthmon.c
 create mode 100644 fs/xfs/xfs_healthmon.h


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index e0fa9b382fbeb..dd22cf799328a 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -6,6 +6,7 @@ config XFS_FS
 	select LIBCRC32C
 	select FS_IOMAP
 	select TIME_STATS if XFS_TIME_STATS
+	select THREAD_WITH_FILE if XFS_HEALTH_MONITOR
 	help
 	  XFS is a high performance journaling filesystem which originated
 	  on the SGI IRIX platform.  It is completely multi-threaded, can
@@ -128,6 +129,14 @@ config XFS_TIME_STATS
 	help
 	  Collects time statistics on various operations in the filesystem.
 
+config XFS_HEALTH_MONITOR
+	bool "Report filesystem health events to userspace"
+	depends on XFS_FS
+	select XFS_LIVE_HOOKS
+	default y
+	help
+	  Report health events to userspace programs.
+
 config XFS_DRAIN_INTENTS
 	bool
 	select JUMP_LABEL if HAVE_ARCH_JUMP_LABEL
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index bf3bacfb7afff..563936e48ab39 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -154,6 +154,7 @@ xfs-$(CONFIG_XFS_LIVE_HOOKS)	+= xfs_hooks.o
 xfs-$(CONFIG_XFS_MEMORY_BUFS)	+= xfs_buf_mem.o
 xfs-$(CONFIG_XFS_BTREE_IN_MEM)	+= libxfs/xfs_btree_mem.o
 xfs-$(CONFIG_XFS_TIME_STATS)	+= xfs_timestats.o
+xfs-$(CONFIG_XFS_HEALTH_MONITOR) += xfs_healthmon.o
 
 # online scrub/repair
 ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 246c2582abbe5..b9d9bc511475d 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -855,6 +855,7 @@ struct xfs_scrub_metadata {
 #define XFS_IOC_FSGETXATTRA	_IOR ('X', 45, struct fsxattr)
 /*	XFS_IOC_SETBIOSIZE ---- deprecated 46	   */
 /*	XFS_IOC_GETBIOSIZE ---- deprecated 47	   */
+/*	XFS_IOC_HEALTHMON -------- staging 48	   */
 #define XFS_IOC_GETBMAPX	_IOWR('X', 56, struct getbmap)
 #define XFS_IOC_ZERO_RANGE	_IOW ('X', 57, struct xfs_flock64)
 #define XFS_IOC_FREE_EOFBLOCKS	_IOR ('X', 58, struct xfs_fs_eofblocks)
diff --git a/fs/xfs/libxfs/xfs_fs_staging.h b/fs/xfs/libxfs/xfs_fs_staging.h
index 1da182c77934d..84b99816eec2e 100644
--- a/fs/xfs/libxfs/xfs_fs_staging.h
+++ b/fs/xfs/libxfs/xfs_fs_staging.h
@@ -303,4 +303,14 @@ struct xfs_map_freesp {
  */
 #define XFS_IOC_MAP_FREESP	_IOWR('X', 64, struct xfs_map_freesp)
 
+struct xfs_health_monitor {
+	__u64	flags;		/* flags */
+	__u8	format;		/* output format */
+	__u8	pad1[7];	/* zeroes */
+	__u64	pad2[2];	/* zeroes */
+};
+
+/* Monitor for health events. */
+#define XFS_IOC_HEALTH_MONITOR		_IOR ('X', 48, struct xfs_health_monitor)
+
 #endif /* __XFS_FS_STAGING_H__ */
diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
new file mode 100644
index 0000000000000..9b4da8d1e5173
--- /dev/null
+++ b/fs/xfs/xfs_healthmon.c
@@ -0,0 +1,129 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (C) 2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_inode.h"
+#include "xfs_trace.h"
+#include "xfs_health.h"
+#include "xfs_ag.h"
+#include "xfs_btree.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_quota_defs.h"
+#include "xfs_rtgroup.h"
+#include "xfs_healthmon.h"
+
+/*
+ * Live Health Monitoring
+ * ======================
+ *
+ * Autonomous self-healing of XFS filesystems requires a means for the kernel
+ * to send filesystem health events to a monitoring daemon in userspace.  To
+ * accomplish this, we establish a thread_with_file kthread object to handle
+ * translating internal events about filesystem health into a format that can
+ * be parsed easily by userspace.  Then we hook various parts of the filesystem
+ * to supply those internal events to the kthread.  Userspace reads events
+ * from the file descriptor returned by the ioctl.
+ *
+ * The healthmon abstraction has a weak reference to the host filesystem mount
+ * so that the queueing and processing of the events do not pin the mount and
+ * cannot slow down the main filesystem.  The healthmon object can exist past
+ * the end of the filesystem mount.
+ */
+
+struct xfs_healthmon {
+	/* thread with stdio redirection */
+	struct thread_with_stdio	thread;
+};
+
+static inline struct xfs_healthmon *
+to_healthmon(struct thread_with_stdio	*thr)
+{
+	return container_of(thr, struct xfs_healthmon, thread);
+}
+
+/* Free the health monitoring information. */
+STATIC void
+xfs_healthmon_exit(
+	struct thread_with_stdio	*thr)
+{
+	struct xfs_healthmon		*hm = to_healthmon(thr);
+
+	kfree(hm);
+	module_put(THIS_MODULE);
+}
+
+/* Pipe health monitoring information to userspace. */
+STATIC void
+xfs_healthmon_run(
+	struct thread_with_stdio	*thr)
+{
+}
+
+/* Validate ioctl parameters. */
+static inline bool
+xfs_healthmon_validate(
+	const struct xfs_health_monitor	*hmo)
+{
+	if (hmo->flags)
+		return false;
+	if (hmo->format)
+		return false;
+	if (memchr_inv(&hmo->pad1, 0, sizeof(hmo->pad1)))
+		return false;
+	if (memchr_inv(&hmo->pad2, 0, sizeof(hmo->pad2)))
+		return false;
+	return true;
+}
+
+static const struct thread_with_stdio_ops xfs_healthmon_ops = {
+	.exit		= xfs_healthmon_exit,
+	.fn		= xfs_healthmon_run,
+};
+
+/*
+ * Create a health monitoring file.  Returns an index to the fd table or a
+ * negative errno.
+ */
+int
+xfs_healthmon_create(
+	struct xfs_mount		*mp,
+	struct xfs_health_monitor	*hmo)
+{
+	struct xfs_healthmon		*hm;
+	int				ret;
+
+	if (!xfs_healthmon_validate(hmo))
+		return -EINVAL;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (!try_module_get(THIS_MODULE))
+		return -ENOMEM;
+
+	hm = kzalloc(sizeof(*hm), GFP_KERNEL);
+	if (!hm) {
+		ret = -ENOMEM;
+		goto out_mod;
+	}
+
+	ret = run_thread_with_stdout(&hm->thread, &xfs_healthmon_ops);
+	if (ret < 0)
+		goto out_hm;
+
+	return ret;
+out_hm:
+	kfree(hm);
+out_mod:
+	module_put(THIS_MODULE);
+	return ret;
+}
diff --git a/fs/xfs/xfs_healthmon.h b/fs/xfs/xfs_healthmon.h
new file mode 100644
index 0000000000000..a9a8115ec770b
--- /dev/null
+++ b/fs/xfs/xfs_healthmon.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (C) 2024 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_HEALTHMON_H__
+#define __XFS_HEALTHMON_H__
+
+#ifdef CONFIG_XFS_HEALTH_MONITOR
+int xfs_healthmon_create(struct xfs_mount *mp, struct xfs_health_monitor *hmo);
+#else
+# define xfs_healthmon_create(mp, hmo)		(-EOPNOTSUPP)
+#endif /* CONFIG_XFS_HEALTH_MONITOR */
+
+#endif /* __XFS_HEALTHMON_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d592ceb26c3e5..270127300ba02 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -44,6 +44,7 @@
 #include "xfs_file.h"
 #include "xfs_exchrange.h"
 #include "xfs_rtgroup.h"
+#include "xfs_healthmon.h"
 
 #include <linux/mount.h>
 #include <linux/namei.h>
@@ -2429,6 +2430,23 @@ xfs_ioc_map_freesp(
 # define xfs_ioc_map_freesp(...)		(-ENOTTY)
 #endif
 
+#ifdef CONFIG_XFS_EXPERIMENTAL_IOCTLS
+STATIC int
+xfs_ioc_health_monitor(
+	struct xfs_mount		*mp,
+	struct xfs_health_monitor __user *arg)
+{
+	struct xfs_health_monitor	hmo;
+
+	if (copy_from_user(&hmo, arg, sizeof(hmo)))
+		return -EFAULT;
+
+	return xfs_healthmon_create(mp, &hmo);
+}
+#else
+# define xfs_ioc_health_monitor(...)		(-ENOTTY)
+#endif
+
 /*
  * These long-unused ioctls were removed from the official ioctl API in 5.17,
  * but retain these definitions so that we can log warnings about them.
@@ -2685,6 +2703,9 @@ xfs_file_ioctl(
 	case XFS_IOC_MAP_FREESP:
 		return xfs_ioc_map_freesp(filp, arg);
 
+	case XFS_IOC_HEALTH_MONITOR:
+		return xfs_ioc_health_monitor(mp, arg);
+
 	default:
 		return -ENOTTY;
 	}
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 8598294514aa3..02dc0aba4e728 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -69,6 +69,9 @@ typedef __u32			xfs_nlink_t;
 # include <linux/time_stats.h>
 #endif
 #include <linux/sched/clock.h>
+#ifdef CONFIG_XFS_HEALTH_MONITOR
+# include <linux/thread_with_file.h>
+#endif
 
 #include <asm/page.h>
 #include <asm/div64.h>

