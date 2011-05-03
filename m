Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p43KBS8x027829 for <xfs@oss.sgi.com>; Tue, 3 May 2011 15:11:28 -0500
From: Alex Elder <aelder@sgi.com>
Subject: [PATCH] xfs: kill off xfs_printk()
Date: Tue,  3 May 2011 15:14:44 -0500
Message-Id: <a7077b2b2f6f46ac48d03cff4ccede2feba18f07.1304453673.git.aelder@sgi.com>
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
Cc: Joe Perches <joe@perches.com>, Alex Elder <aelder@sgi.com>

From: Joe Perches <joe@perches.com>

xfs_alert_tag() can be defined using xfs_alert(), and thereby avoid
using xfs_printk() altogether.  This is the only remaining use of
xfs_printk(), so changing it this way means xfs_printk() can simply
be eliminated.can simply be eliminated.can simply be eliminated.can
simply be eliminated.can simply be eliminated.can simply be
eliminated.can simply be eliminated.can simply be eliminated.can
simply be eliminated.

Also add format checking to the non-debug inline function xfs_debug.
Miscellaneous function prototype argument alignment.

(Updated to delete the definition of xfs_printk(), which is
no longer used or needed.)

Signed-off-by: Alex Elder <aelder@sgi.com>
---
 fs/xfs/linux-2.6/xfs_message.c |   20 +-------------------
 fs/xfs/linux-2.6/xfs_message.h |    7 +++----
 2 files changed, 4 insertions(+), 23 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_message.c b/fs/xfs/linux-2.6/xfs_message.c
index 9f76cce..bd672de 100644
--- a/fs/xfs/linux-2.6/xfs_message.c
+++ b/fs/xfs/linux-2.6/xfs_message.c
@@ -41,23 +41,6 @@ __xfs_printk(
 	printk("%sXFS: %pV\n", level, vaf);
 }
 
-void xfs_printk(
-	const char		*level,
-	const struct xfs_mount	*mp,
-	const char		*fmt, ...)
-{
-	struct va_format	vaf;
-	va_list			args;
-
-	va_start(args, fmt);
-
-	vaf.fmt = fmt;
-	vaf.va = &args;
-
-	__xfs_printk(level, mp, &vaf);
-	va_end(args);
-}
-
 #define define_xfs_printk_level(func, kern_level)		\
 void func(const struct xfs_mount *mp, const char *fmt, ...)	\
 {								\
@@ -95,8 +78,7 @@ xfs_alert_tag(
 	int			do_panic = 0;
 
 	if (xfs_panic_mask && (xfs_panic_mask & panic_tag)) {
-		xfs_printk(KERN_ALERT, mp,
-			"XFS: Transforming an alert into a BUG.");
+		xfs_alert(mp, "Transforming an alert into a BUG.");
 		do_panic = 1;
 	}
 
diff --git a/fs/xfs/linux-2.6/xfs_message.h b/fs/xfs/linux-2.6/xfs_message.h
index f1b3fc1..7fb7ea0 100644
--- a/fs/xfs/linux-2.6/xfs_message.h
+++ b/fs/xfs/linux-2.6/xfs_message.h
@@ -3,9 +3,6 @@
 
 struct xfs_mount;
 
-extern void xfs_printk(const char *level, const struct xfs_mount *mp,
-                      const char *fmt, ...)
-        __attribute__ ((format (printf, 3, 4)));
 extern void xfs_emerg(const struct xfs_mount *mp, const char *fmt, ...)
         __attribute__ ((format (printf, 2, 3)));
 extern void xfs_alert(const struct xfs_mount *mp, const char *fmt, ...)
@@ -28,7 +25,9 @@ extern void xfs_info(const struct xfs_mount *mp, const char *fmt, ...)
 extern void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
         __attribute__ ((format (printf, 2, 3)));
 #else
-static inline void xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
+static inline void
+__attribute__ ((format (printf, 2, 3)))
+xfs_debug(const struct xfs_mount *mp, const char *fmt, ...)
 {
 }
 #endif
-- 
1.7.4.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
