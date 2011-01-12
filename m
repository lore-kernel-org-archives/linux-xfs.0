Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0C0YGYq124032 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 18:34:16 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A72AFD432C
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 16:36:28 -0800 (PST)
Received: from mail.internode.on.net (bld-mail15.adl6.internode.on.net
	[150.101.137.100]) by cuda.sgi.com with ESMTP id
	oUWOyXFgsdvTCNwy for <xfs@oss.sgi.com>;
	Tue, 11 Jan 2011 16:36:28 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	41062648-1927428
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 11:06:27 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PcohC-0000Uo-L1
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:36:14 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pcogv-0002GW-5z
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:35:57 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 12/12] xfs: kill support/debug.[ch]
Date: Wed, 12 Jan 2011 11:35:53 +1100
Message-Id: <1294792553-8378-13-git-send-email-david@fromorbit.com>
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

The remaining functionality in debug.[ch] is effectively just assert
handling, conditional debug definitions and hex dumping. The hex
dumping and assert function can be moved into the new printk module,
while the rest can be moved into top-level header files. This allows
fs/xfs/support/debug.[ch] to be completely removed from the
codebase.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile               |    1 -
 fs/xfs/linux-2.6/xfs_linux.h  |   21 +++++++++++++++++++
 fs/xfs/linux-2.6/xfs_printk.c |   14 ++++++++++++
 fs/xfs/linux-2.6/xfs_printk.h |    4 +++
 fs/xfs/support/debug.c        |   32 -----------------------------
 fs/xfs/support/debug.h        |   45 -----------------------------------------
 fs/xfs/xfs_error.h            |    4 ---
 7 files changed, 39 insertions(+), 82 deletions(-)
 delete mode 100644 fs/xfs/support/debug.c
 delete mode 100644 fs/xfs/support/debug.h

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index 3060407..be12325 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -111,5 +111,4 @@ xfs-y				+= $(addprefix $(XFS_LINUX)/, \
 
 # Objects in support/
 xfs-y				+= $(addprefix support/, \
-				   debug.o \
 				   uuid.o)
diff --git a/fs/xfs/linux-2.6/xfs_linux.h b/fs/xfs/linux-2.6/xfs_linux.h
index 9549023..26c0d29 100644
--- a/fs/xfs/linux-2.6/xfs_linux.h
+++ b/fs/xfs/linux-2.6/xfs_linux.h
@@ -281,4 +281,25 @@ static inline __uint64_t howmany_64(__uint64_t x, __uint32_t y)
 #define __arch_pack
 #endif
 
+#define ASSERT_ALWAYS(expr)	\
+	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
+
+#ifndef DEBUG
+#define ASSERT(expr)	((void)0)
+
+#ifndef STATIC
+# define STATIC static noinline
+#endif
+
+#else /* DEBUG */
+
+#define ASSERT(expr)	\
+	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
+
+#ifndef STATIC
+# define STATIC noinline
+#endif
+
+#endif /* DEBUG */
+
 #endif /* __XFS_LINUX__ */
diff --git a/fs/xfs/linux-2.6/xfs_printk.c b/fs/xfs/linux-2.6/xfs_printk.c
index 6f3368e..8fe8cf6 100644
--- a/fs/xfs/linux-2.6/xfs_printk.c
+++ b/fs/xfs/linux-2.6/xfs_printk.c
@@ -117,3 +117,17 @@ xfs_alert_tag(
 
 	return r;
 }
+
+void
+assfail(char *expr, char *file, int line)
+{
+	xfs_emerg(NULL, "Assertion failed: %s, file: %s, line: %d",
+		expr, file, line);
+	BUG();
+}
+
+void
+xfs_hex_dump(void *p, int length)
+{
+	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_ADDRESS, 16, 1, p, length, 1);
+}
diff --git a/fs/xfs/linux-2.6/xfs_printk.h b/fs/xfs/linux-2.6/xfs_printk.h
index 579367f..d39ad30 100644
--- a/fs/xfs/linux-2.6/xfs_printk.h
+++ b/fs/xfs/linux-2.6/xfs_printk.h
@@ -31,4 +31,8 @@ extern int xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
 #define xfs_debug(mp, fmt, ...)	(0)
 #endif
 
+extern void assfail(char *expr, char *f, int l);
+
+extern void xfs_hex_dump(void *p, int length);
+
 #endif	/* __XFS_PRINTK_H */
diff --git a/fs/xfs/support/debug.c b/fs/xfs/support/debug.c
deleted file mode 100644
index c9020ae..0000000
--- a/fs/xfs/support/debug.c
+++ /dev/null
@@ -1,32 +0,0 @@
-/*
- * Copyright (c) 2000-2003,2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#include <xfs.h>
-#include "debug.h"
-
-void
-assfail(char *expr, char *file, int line)
-{
-	printk("Assertion failed: %s, file: %s, line: %d\n", expr, file, line);
-	BUG();
-}
-
-void
-xfs_hex_dump(void *p, int length)
-{
-	print_hex_dump(KERN_ALERT, "", DUMP_PREFIX_ADDRESS, 16, 1, p, length, 1);
-}
diff --git a/fs/xfs/support/debug.h b/fs/xfs/support/debug.h
deleted file mode 100644
index db36be4..0000000
--- a/fs/xfs/support/debug.h
+++ /dev/null
@@ -1,45 +0,0 @@
-/*
- * Copyright (c) 2000-2005 Silicon Graphics, Inc.
- * All Rights Reserved.
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it would be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write the Free Software Foundation,
- * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
- */
-#ifndef	__XFS_SUPPORT_DEBUG_H__
-#define	__XFS_SUPPORT_DEBUG_H__
-
-#include <stdarg.h>
-
-extern void assfail(char *expr, char *f, int l);
-
-#define ASSERT_ALWAYS(expr)	\
-	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
-
-#ifndef DEBUG
-#define ASSERT(expr)	((void)0)
-
-#ifndef STATIC
-# define STATIC static noinline
-#endif
-
-#else /* DEBUG */
-
-#define ASSERT(expr)	\
-	(unlikely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
-
-#ifndef STATIC
-# define STATIC noinline
-#endif
-
-#endif /* DEBUG */
-#endif  /* __XFS_SUPPORT_DEBUG_H__ */
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index e836051..079a367 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -158,8 +158,4 @@ extern int xfs_errortag_clearall(struct xfs_mount *mp, int loud);
 #define		XFS_PTAG_SHUTDOWN_LOGERROR	0x00000040
 #define		XFS_PTAG_FSBLOCK_ZERO		0x00000080
 
-struct xfs_mount;
-
-extern void xfs_hex_dump(void *p, int length);
-
 #endif	/* __XFS_ERROR_H__ */
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
