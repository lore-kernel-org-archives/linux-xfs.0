Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000A513FD72
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735688457; cv=none; b=U/LDqlAmFSk006kbnYGgCrJ3XPPs0+jIAtU/rUR2OYCMuhGDjjp0er4GHqsS3DddxkinE6SBu6LROZpWtOejHI/SFjmXZ9NmTQHKKIdXPF7XBj08VAV6yhp0+h2us4UdBDdI2mwyaMAIYOhlcBUogcSJMW7Yr6mgjdLWGTvovvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735688457; c=relaxed/simple;
	bh=JC2+lU0G7LDrwOo73vXseUN4rrBHZhrZHeqRdT5a8do=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eWmY/iiH9kdlBahHzlnmwRhSkK8RnKb9BNuVZQFiwEQmp1kn+4x6vHfhf3Ju58bQnktat4DSxuF4ctlm7ma3MwJWCBgOaMU+Ze1yvemSgwDy28ZtWsmJaFi6tgLnEgKHihXKwHTF4XlTU5VIvWq/jQRNSnvsremNcI9G6gJjc4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WLxAfV15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WLxAfV15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC445C4CED2;
	Tue, 31 Dec 2024 23:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735688456;
	bh=JC2+lU0G7LDrwOo73vXseUN4rrBHZhrZHeqRdT5a8do=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=WLxAfV15KBaiJDXLusWBkBuYizKZRMtIiTm2ZDVhuC0cVukoEx+jJjHlgClxN9vEn
	 rDut2BOZ9xbbAEv2Ygo4oRlSxdiiMKF5yeHO5y89w0bBdRju2t1HdmY1RHY676S5Gb
	 wfzSf8OF00ZC0my7bdSq51INDqmHNTx7rgXHqrMDWJPuyOXk7ZpJwXemXwblBC6meI
	 lwGVzTGMkUdXnvan5UVXHLtV8d70iHe8muTnjsrll7QEgYzuDtqiLGdV4fAGSGvQ0A
	 vujVHyE5ib2MbMUWU4Si1zWcEWR0l2JCimiSQe4KWJypcMsVE3nzzUOsoSzcW/mrrJ
	 ZMpGYfnjaQR8w==
Date: Tue, 31 Dec 2024 15:40:56 -0800
Subject: [PATCH 08/16] xfs: create a special file to pass filesystem health to
 userspace
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568754880.2704911.15158852399328244529.stgit@frogsfrogsfrogs>
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

Create an ioctl that installs a file descriptor backed by an anon_inode
file that will convey filesystem health events to userspace.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/Kconfig         |    8 +++
 fs/xfs/Makefile        |    1 
 fs/xfs/libxfs/xfs_fs.h |    8 +++
 fs/xfs/xfs_healthmon.c |  145 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_healthmon.h |   16 +++++
 fs/xfs/xfs_ioctl.c     |    4 +
 6 files changed, 182 insertions(+)
 create mode 100644 fs/xfs/xfs_healthmon.c
 create mode 100644 fs/xfs/xfs_healthmon.h


diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 5700bc671a0e92..9d061a8c2786fe 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -120,6 +120,14 @@ config XFS_RT
 
 	  If unsure, say N.
 
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
index 4c59d43c77089e..94a9dc7aa7a1d5 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -158,6 +158,7 @@ xfs-$(CONFIG_XFS_DRAIN_INTENTS)	+= xfs_drain.o
 xfs-$(CONFIG_XFS_LIVE_HOOKS)	+= xfs_hooks.o
 xfs-$(CONFIG_XFS_MEMORY_BUFS)	+= xfs_buf_mem.o
 xfs-$(CONFIG_XFS_BTREE_IN_MEM)	+= libxfs/xfs_btree_mem.o
+xfs-$(CONFIG_XFS_HEALTH_MONITOR) += xfs_healthmon.o
 
 # online scrub/repair
 ifeq ($(CONFIG_XFS_ONLINE_SCRUB),y)
diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index f4128dbdf3b9a2..d1a81b02a1a3f3 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -1100,6 +1100,13 @@ struct xfs_map_freesp {
 	__u64	pad;		/* must be zero */
 };
 
+struct xfs_health_monitor {
+	__u64	flags;		/* flags */
+	__u8	format;		/* output format */
+	__u8	pad1[7];	/* zeroes */
+	__u64	pad2[2];	/* zeroes */
+};
+
 /*
  * ioctl commands that are used by Linux filesystems
  */
@@ -1141,6 +1148,7 @@ struct xfs_map_freesp {
 #define XFS_IOC_RTGROUP_GEOMETRY _IOWR('X', 65, struct xfs_rtgroup_geometry)
 #define XFS_IOC_GETFSREFCOUNTS	_IOWR('X', 66, struct xfs_getfsrefs_head)
 #define XFS_IOC_MAP_FREESP	_IOW ('X', 67, struct xfs_map_freesp)
+#define XFS_IOC_HEALTH_MONITOR	_IOW ('X', 68, struct xfs_health_monitor)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/xfs_healthmon.c b/fs/xfs/xfs_healthmon.c
new file mode 100644
index 00000000000000..c5ce5699373c63
--- /dev/null
+++ b/fs/xfs/xfs_healthmon.c
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/*
+ * Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
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
+#include "xfs_ag.h"
+#include "xfs_btree.h"
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+#include "xfs_quota_defs.h"
+#include "xfs_rtgroup.h"
+#include "xfs_healthmon.h"
+
+#include <linux/anon_inodes.h>
+#include <linux/eventpoll.h>
+#include <linux/poll.h>
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
+	struct xfs_mount		*mp;
+};
+
+/*
+ * Convey queued event data to userspace.  First copy any remaining bytes in
+ * the outbuf, then format the oldest event into the outbuf and copy that too.
+ */
+STATIC ssize_t
+xfs_healthmon_read_iter(
+	struct kiocb		*iocb,
+	struct iov_iter		*to)
+{
+	return -EIO;
+}
+
+/* Free the health monitoring information. */
+STATIC int
+xfs_healthmon_release(
+	struct inode		*inode,
+	struct file		*file)
+{
+	struct xfs_healthmon	*hm = file->private_data;
+
+	kfree(hm);
+
+	return 0;
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
+static const struct file_operations xfs_healthmon_fops = {
+	.owner		= THIS_MODULE,
+	.read_iter	= xfs_healthmon_read_iter,
+	.release	= xfs_healthmon_release,
+};
+
+/*
+ * Create a health monitoring file.  Returns an index to the fd table or a
+ * negative errno.
+ */
+long
+xfs_ioc_health_monitor(
+	struct xfs_mount		*mp,
+	struct xfs_health_monitor __user *arg)
+{
+	struct xfs_health_monitor	hmo;
+	struct xfs_healthmon		*hm;
+	char				*name;
+	int				fd;
+	int				ret;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (copy_from_user(&hmo, arg, sizeof(hmo)))
+		return -EFAULT;
+
+	if (!xfs_healthmon_validate(&hmo))
+		return -EINVAL;
+
+	hm = kzalloc(sizeof(*hm), GFP_KERNEL);
+	if (!hm)
+		return -ENOMEM;
+	hm->mp = mp;
+
+	/* Set up VFS file and file descriptor. */
+	name = kasprintf(GFP_KERNEL, "XFS (%s): healthmon", mp->m_super->s_id);
+	if (!name) {
+		ret = -ENOMEM;
+		goto out_hm;
+	}
+
+	fd = anon_inode_getfd(name, &xfs_healthmon_fops, hm,
+			O_CLOEXEC | O_RDONLY);
+	kvfree(name);
+	if (fd < 0) {
+		ret = fd;
+		goto out_hm;
+	}
+
+	return fd;
+
+out_hm:
+	kfree(hm);
+	return ret;
+}
diff --git a/fs/xfs/xfs_healthmon.h b/fs/xfs/xfs_healthmon.h
new file mode 100644
index 00000000000000..07126e39281a0c
--- /dev/null
+++ b/fs/xfs/xfs_healthmon.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+/*
+ * Copyright (c) 2024-2025 Oracle.  All Rights Reserved.
+ * Author: Darrick J. Wong <djwong@kernel.org>
+ */
+#ifndef __XFS_HEALTHMON_H__
+#define __XFS_HEALTHMON_H__
+
+#ifdef CONFIG_XFS_HEALTH_MONITOR
+long xfs_ioc_health_monitor(struct xfs_mount *mp,
+		struct xfs_health_monitor __user *arg);
+#else
+# define xfs_ioc_health_monitor(mp, hmo)	(-ENOTTY)
+#endif /* CONFIG_XFS_HEALTH_MONITOR */
+
+#endif /* __XFS_HEALTHMON_H__ */
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 092a3699ff9e75..6c7a30128c7bf6 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -42,6 +42,7 @@
 #include "xfs_exchrange.h"
 #include "xfs_handle.h"
 #include "xfs_rtgroup.h"
+#include "xfs_healthmon.h"
 
 #include <linux/mount.h>
 #include <linux/fileattr.h>
@@ -1434,6 +1435,9 @@ xfs_file_ioctl(
 	case XFS_IOC_MAP_FREESP:
 		return xfs_ioc_map_freesp(filp, arg);
 
+	case XFS_IOC_HEALTH_MONITOR:
+		return xfs_ioc_health_monitor(mp, arg);
+
 	default:
 		return -ENOTTY;
 	}

