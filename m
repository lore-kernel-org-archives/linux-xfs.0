Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0C0YFbx124021 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 18:34:16 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8A41EFD41CC
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 16:36:26 -0800 (PST)
Received: from mail.internode.on.net (bld-mail18.adl2.internode.on.net
	[150.101.137.103]) by cuda.sgi.com with ESMTP id
	imQcysQP9DWjnrIO for <xfs@oss.sgi.com>;
	Tue, 11 Jan 2011 16:36:26 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	52231989-1927428
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 11:06:25 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PcohM-0000UR-1e
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:36:24 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pcogu-0002G3-Ju
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:35:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/12] xfs: introduce new logging API.
Date: Wed, 12 Jan 2011 11:35:43 +1100
Message-Id: <1294792553-8378-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1294792553-8378-1-git-send-email-david@fromorbit.com>
References: <1294792553-8378-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

Most of the logging infrastructurein XFS is unneccessary and
designed around the infrastructure supplied  by Irix rather than
Linux. To start rationalising all the logging interfaces, start by
introducing simple printk wrappers similar to the dev_printk()
infrastructure. later patches will convert code to use this new
interface.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile               |    1 +
 fs/xfs/linux-2.6/xfs_linux.h  |    1 +
 fs/xfs/linux-2.6/xfs_printk.c |  119 +++++++++++++++++++++++++++++++++++++++++
 fs/xfs/linux-2.6/xfs_printk.h |   34 ++++++++++++
 4 files changed, 155 insertions(+), 0 deletions(-)
 create mode 100644 fs/xfs/linux-2.6/xfs_printk.c
 create mode 100644 fs/xfs/linux-2.6/xfs_printk.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 0dce969..3060407 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -104,6 +104,7 @@ xfs-y				+= $(addprefix $(XFS_LINUX)/, \
 				   xfs_globals.o \
 				   xfs_ioctl.o \
 				   xfs_iops.o \
+				   xfs_printk.o \
 				   xfs_super.o \
 				   xfs_sync.o \
 				   xfs_xattr.o)
diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index 0964949..9549023 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -86,6 +86,7 @@
 #include <xfs_aops.h>
 #include <xfs_super.h>
 #include <xfs_buf.h>
+#include <xfs_printk.h>
 
 /*
  * Feature macros (disable/enable)
diff --git a/fs/xfs/linux-2.6/xfs_printk.c b/fs/xfs/linux-2.6/xfs_printk.c
new file mode 100644
index 0000000..6f3368e
--- /dev/null
+++ b/fs/xfs/linux-2.6/xfs_printk.c
@@ -0,0 +1,119 @@
+/*
+ * Copyright (c) 2011 Red Hat, Inc.  All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include "xfs.h"
+#include "xfs_fs.h"
+#include "xfs_types.h"
+#include "xfs_log.h"
+#include "xfs_inum.h"
+#include "xfs_trans.h"
+#include "xfs_sb.h"
+#include "xfs_ag.h"
+#include "xfs_mount.h"
+
+/*
+ * XFS logging functions
+ */
+static int
+__xfs_printk(
+	const char		*level,
+	const struct xfs_mount	*mp,
+	struct va_format	*vaf)
+{
+	if (mp && mp->m_fsname)
+		return printk("%sXFS (%s): %pV\n", level, mp->m_fsname, vaf);
+	return printk("%sXFS: %pV\n", level, vaf);
+}
+
+int xfs_printk(
+	const char		*level,
+	const struct xfs_mount	*mp,
+	const char		*fmt, ...)
+{
+	struct va_format	vaf;
+	va_list			args;
+	int			 r;
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	r = __xfs_printk(level, mp, &vaf);
+	va_end(args);
+
+	return r;
+}
+
+#define define_xfs_printk_level(func, kern_level)		\
+int func(const struct xfs_mount *mp, const char *fmt, ...)	\
+{								\
+	struct va_format	vaf;				\
+	va_list			args;				\
+	int			r;				\
+								\
+	va_start(args, fmt);					\
+								\
+	vaf.fmt = fmt;						\
+	vaf.va = &args;						\
+								\
+	r = __xfs_printk(kern_level, mp, &vaf);			\
+	va_end(args);						\
+								\
+	return r;						\
+}								\
+
+define_xfs_printk_level(xfs_emerg, KERN_EMERG);
+define_xfs_printk_level(xfs_alert, KERN_ALERT);
+define_xfs_printk_level(xfs_crit, KERN_CRIT);
+define_xfs_printk_level(xfs_err, KERN_ERR);
+define_xfs_printk_level(xfs_warn, KERN_WARNING);
+define_xfs_printk_level(xfs_notice, KERN_NOTICE);
+define_xfs_printk_level(xfs_info, KERN_INFO);
+#ifdef DEBUG
+define_xfs_printk_level(xfs_debug, KERN_DEBUG);
+#endif
+
+int
+xfs_alert_tag(
+	const struct xfs_mount	*mp,
+	int			panic_tag,
+	const char		*fmt, ...)
+{
+	struct va_format	vaf;
+	va_list			args;
+	int			panic = 0;
+	int			 r;
+
+	if (xfs_panic_mask && (xfs_panic_mask & panic_tag)) {
+		xfs_printk(KERN_ALERT, mp,
+			"XFS: Transforming an alert into a BUG.");
+		panic = 1;
+	}
+
+	va_start(args, fmt);
+
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	r = __xfs_printk(KERN_ALERT, mp, &vaf);
+	va_end(args);
+
+	BUG_ON(panic);
+
+	return r;
+}
diff --git a/fs/xfs/linux-2.6/xfs_printk.h b/fs/xfs/linux-2.6/xfs_printk.h
new file mode 100644
index 0000000..579367f
--- /dev/null
+++ b/fs/xfs/linux-2.6/xfs_printk.h
@@ -0,0 +1,34 @@
+#ifndef __XFS_PRINTK_H
+#define __XFS_PRINTK_H 1
+
+struct xfs_mount;
+
+extern int xfs_printk(const char *level, const struct xfs_mount *mp,
+                      const char *fmt, ...)
+        __attribute__ ((format (printf, 3, 4)));
+extern int xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...)
+        __attribute__ ((format (printf, 2, 3)));
+extern int xfs_alert(const struct xfs_mount *mp, const char *fmt, ...)
+        __attribute__ ((format (printf, 2, 3)));
+extern int xfs_alert_tag(const struct xfs_mount *mp, int tag,
+			 const char *fmt, ...)
+        __attribute__ ((format (printf, 3, 4)));
+extern int xfs_crit(const struct xfs_mount *mp, const char *fmt, ...)
+        __attribute__ ((format (printf, 2, 3)));
+extern int xfs_err(const struct xfs_mount *mp, const char *fmt, ...)
+        __attribute__ ((format (printf, 2, 3)));
+extern int xfs_warn(const struct xfs_mount *mp, const char *fmt, ...)
+        __attribute__ ((format (printf, 2, 3)));
+extern int xfs_notice(const struct xfs_mount *mp, const char *fmt, ...)
+        __attribute__ ((format (printf, 2, 3)));
+extern int xfs_info(const struct xfs_mount *mp, const char *fmt, ...)
+        __attribute__ ((format (printf, 2, 3)));
+
+#ifdef DEBUG
+extern int xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
+        __attribute__ ((format (printf, 2, 3)));
+#else
+#define xfs_debug(mp, fmt, ...)	(0)
+#endif
+
+#endif	/* __XFS_PRINTK_H */
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
