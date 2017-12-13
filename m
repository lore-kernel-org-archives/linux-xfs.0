Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:48618 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750751AbdLMG1Y (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 13 Dec 2017 01:27:24 -0500
Date: Tue, 12 Dec 2017 22:21:46 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 1/2] xfs: eBPF user hacks insanity
Message-ID: <20171213062146.GP19219@magnolia>
References: <20171213061825.GO19219@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171213061825.GO19219@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Richard Wareing <rwareing@fb.com>, david@fromorbit.com, hch@infradead.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Create some special filter functions to which userspace can attach eBPF
programs which override the return value and thereby allow userspace to
assist XFS in making contextualized decisions about where to put
files.

In other words, users can upload their own custom algorithms into XFS to
override the default rtdev/datadev placement code.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/Kconfig              |    9 ++
 fs/xfs/Makefile             |    2 +
 fs/xfs/xfs_bmap_util.c      |    5 +
 fs/xfs/xfs_hacks.c          |  159 +++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_hacks.h          |   29 ++++++++
 fs/xfs/xfs_iomap.c          |    7 ++
 kernel/trace/trace_kprobe.c |    2 +
 7 files changed, 213 insertions(+)
 create mode 100644 fs/xfs/xfs_hacks.c
 create mode 100644 fs/xfs/xfs_hacks.h

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 06be67d..1594822 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -143,3 +143,12 @@ config XFS_ASSERT_FATAL
 	  result in warnings.
 
 	  This behavior can be modified at runtime via sysfs.
+
+config XFS_HACKS
+	bool "XFS Userspace eBPF Hacks"
+	default n
+	depends on XFS_FS && BPF_KPROBE_OVERRIDE
+	help
+	  Allow userspace to attach eBPF programs to various parts of XFS
+	  in order to customize its decisions.  This is insane; you get
+	  to keep the pieces!
diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 9f4de14..03e2a37 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -176,3 +176,5 @@ xfs-$(CONFIG_XFS_RT)		+= $(addprefix scrub/, \
 				   )
 xfs-$(CONFIG_XFS_QUOTA)		+= scrub/quota.o
 endif
+
+xfs-$(CONFIG_XFS_HACKS)		+= xfs_hacks.o
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 6d37ab4..39ce418 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -45,6 +45,7 @@
 #include "xfs_iomap.h"
 #include "xfs_reflink.h"
 #include "xfs_refcount.h"
+#include "xfs_hacks.h"
 
 /* Kernel only BMAP related definitions and functions */
 
@@ -918,6 +919,10 @@ xfs_alloc_file_space(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
+	error = xfs_hacks_retarget_iflags(ip, offset, len);
+	if (error)
+		return error;
+
 	error = xfs_qm_dqattach(ip, 0);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_hacks.c b/fs/xfs/xfs_hacks.c
new file mode 100644
index 0000000..28d2852
--- /dev/null
+++ b/fs/xfs/xfs_hacks.c
@@ -0,0 +1,159 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_mount.h"
+#include "xfs_defer.h"
+#include "xfs_btree.h"
+#include "xfs_bit.h"
+#include "xfs_log_format.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_inode.h"
+#include "xfs_icache.h"
+#include "xfs_itable.h"
+#include "xfs_fsops.h"
+#include <linux/bpf.h>
+
+static void
+xfs_hacks_warn(
+	struct xfs_mount	*mp)
+{
+	static struct ratelimit_state hack_warning = RATELIMIT_STATE_INIT(
+			__func__, 86400 * HZ, 1);
+
+	ratelimit_set_flags(&hack_warning, RATELIMIT_MSG_ON_RELEASE);
+	if (__ratelimit(&hack_warning))
+		xfs_alert(mp,
+"WARNING userspace eBPF hack feature in use. Use at your own risk!");
+}
+
+/*
+ * Return current xflags unless someone attaches an eBPF program to
+ * override the default return value to feed the inode different xflags.
+ * This is the mechanism through which userspace can make more
+ * contextual decisions about where to put a file.
+ *
+ * ftrace cannot attach to this function if it is too short, so we have
+ * three throwaway calls to trace_printk to ensure that we have enough
+ * bytes... or something.
+ */
+uint
+xfs_hack_filter_iflags(
+	struct xfs_fsop_geom	*geo,
+	struct xfs_fsop_counts	*stats,
+	xfs_ino_t		ino,
+	loff_t			offset,
+	loff_t			length,
+	uint			xflags)
+{
+	trace_printk("C: off=%llu len=%llu xflags=0x%x\\n",
+			offset, length, xflags);
+	trace_printk("C: dblocks=%llu rblocks=%llu\\n",
+			geo->datablocks, geo->rtblocks);
+	trace_printk("C: dfree=%llu rfree=%llu\\n",
+			stats->freedata, stats->freertx);
+
+	return xflags;
+}
+BPF_ALLOW_ERROR_INJECTION(xfs_hack_filter_iflags);
+
+/*
+ * Change flags on empty files, if so desired.
+ */
+#define XFS_XFLAGS_CAN_RETARGET	(FS_XFLAG_REALTIME)
+int
+xfs_hacks_retarget_iflags(
+	struct xfs_inode	*ip,
+	loff_t			offset,
+	loff_t			length)
+{
+	struct xfs_fsop_geom	fsgeo;
+	struct xfs_fsop_counts	stats;
+	struct xfs_trans	*tp;
+	struct xfs_mount	*mp = ip->i_mount;
+	uint16_t		flags;
+	uint64_t		flags2;
+	uint			curr_xflags;
+	uint			new_xflags;
+	int			error = 0;
+
+	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
+	if (error)
+		return error;
+
+	xfs_ilock(ip, XFS_ILOCK_EXCL);
+
+	flags = ip->i_d.di_flags;
+	flags2 = ip->i_d.di_flags2;
+
+	/* Only allow retargeting of empty files. */
+	if (i_size_read(VFS_I(ip)) || ip->i_d.di_nextents || ip->i_d.di_size)
+		goto out_unlock;
+
+	error = xfs_fs_geometry(mp, &fsgeo, 4);
+	if (error)
+		goto out_unlock;
+	error = xfs_fs_counts(mp, &stats);
+	if (error)
+		goto out_unlock;
+
+	curr_xflags = xfs_ip2xflags(ip);
+	new_xflags = xfs_hack_filter_iflags(&fsgeo, &stats, ip->i_ino, offset,
+			length, curr_xflags);
+
+	if (new_xflags == curr_xflags)
+		goto out_unlock;
+
+	xfs_hacks_warn(mp);
+
+	error = -EINVAL;
+	if ((new_xflags ^ curr_xflags) & ~XFS_XFLAGS_CAN_RETARGET)
+		goto out_unlock;
+
+	/* Change the rt flag. */
+	if (new_xflags & FS_XFLAG_REALTIME) {
+		if (!mp->m_rtdev_targp)
+			goto out_unlock;
+
+		if (xfs_is_reflink_inode(ip))
+			flags2 &= ~XFS_DIFLAG2_REFLINK;
+
+		flags |= XFS_DIFLAG_REALTIME;
+	} else {
+		flags &= ~XFS_DIFLAG_REALTIME;
+	}
+
+	/* Log inode and get out. */
+	ip->i_d.di_flags = flags;
+	ip->i_d.di_flags2 = flags2;
+	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
+	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
+	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
+	return xfs_trans_commit(tp);
+
+out_unlock:
+	xfs_iunlock(ip, XFS_ILOCK_EXCL);
+	xfs_trans_cancel(tp);
+	return error;
+}
diff --git a/fs/xfs/xfs_hacks.h b/fs/xfs/xfs_hacks.h
new file mode 100644
index 0000000..2c556f1
--- /dev/null
+++ b/fs/xfs/xfs_hacks.h
@@ -0,0 +1,29 @@
+/*
+ * Copyright (C) 2017 Oracle.  All Rights Reserved.
+ *
+ * Author: Darrick J. Wong <darrick.wong@oracle.com>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301, USA.
+ */
+#ifndef __XFS_HACKS_H__
+#define __XFS_HACKS_H__
+
+#ifdef CONFIG_XFS_HACKS
+int xfs_hacks_retarget_iflags(struct xfs_inode *ip, loff_t offset, loff_t length);
+#else
+# define xfs_hacks_retarget_iflags(ip, off, len)	(0)
+#endif
+
+#endif /* __XFS_HACKS_H__ */
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index 7ab52a8..f69d274 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -42,6 +42,7 @@
 #include "xfs_dquot_item.h"
 #include "xfs_dquot.h"
 #include "xfs_reflink.h"
+#include "xfs_hacks.h"
 
 
 #define XFS_WRITEIO_ALIGN(mp,off)	(((off) >> mp->m_writeio_log) \
@@ -987,6 +988,12 @@ xfs_file_iomap_begin(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
+	if (flags & IOMAP_WRITE) {
+		error = xfs_hacks_retarget_iflags(ip, offset, length);
+		if (error)
+			return error;
+	}
+
 	if (((flags & (IOMAP_WRITE | IOMAP_DIRECT)) == IOMAP_WRITE) &&
 			!IS_DAX(inode) && !xfs_get_extsz_hint(ip)) {
 		/* Reserve delalloc blocks for regular writeback. */
diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 5db8498..fd948e3 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -1215,8 +1215,10 @@ kprobe_perf_func(struct trace_kprobe *tk, struct pt_regs *regs)
 		if (__this_cpu_read(bpf_kprobe_override)) {
 			__this_cpu_write(bpf_kprobe_override, 0);
 			reset_current_kprobe();
+			preempt_enable();
 			return 1;
 		}
+		preempt_enable();
 		if (!ret)
 			return 0;
 	}
