Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0C0i9HL124908 for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 18:44:09 -0600
Received: from mail.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 533A1256224
	for <xfs@oss.sgi.com>; Tue, 11 Jan 2011 16:36:28 -0800 (PST)
Received: from mail.internode.on.net (bld-mail13.adl6.internode.on.net
	[150.101.137.98]) by cuda.sgi.com with ESMTP id
	dwSTtyoJDc631Cek for <xfs@oss.sgi.com>;
	Tue, 11 Jan 2011 16:36:28 -0800 (PST)
Received: from dastard (unverified [121.44.222.102])
	by mail.internode.on.net (SurgeMail 3.8f2) with ESMTP id
	52672235-1927428
	for <xfs@oss.sgi.com>; Wed, 12 Jan 2011 11:06:25 +1030 (CDT)
Received: from chute ([192.168.1.1] helo=disappointment)
	by dastard with esmtp (Exim 4.72)
	(envelope-from <dave@fromorbit.com>) id 1PcohC-0000UQ-1F
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:36:14 +1100
Received: from dave by disappointment with local (Exim 4.72)
	(envelope-from <dave@disappointment.disaster>) id 1Pcogu-0002G1-Hf
	for xfs@oss.sgi.com; Wed, 12 Jan 2011 11:35:56 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 01/12] xfs: prevent NMI timeouts in cmn_err
Date: Wed, 12 Jan 2011 11:35:42 +1100
Message-Id: <1294792553-8378-2-git-send-email-david@fromorbit.com>
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

We currently have a global error message buffer in cmn_err that is
protected by a spin lock that disables interrupts.  Recently there
have been reports of NMI timeouts occurring when the console is
being flooded by SCSI error reports due to cmn_err() getting stuck
trying to print to the console while holding this lock (i.e. with
interrupts disabled). The NMI watchdog is seeing this CPU as
non-responding and so is triggering a panic.  While the trigger for
the reported case is SCSI errors, pretty much anything that spams
the kernel log could cause this to occur.

Realistically the only reason that we have the intemediate message
buffer is to prepend the correct kernel log level prefix to the log
message. The only reason we have the lock is to protect the global
message buffer and the only reason the message buffer is global is
to keep it off the stack. Hence if we can avoid needing a global
message buffer we avoid needing the lock, and we can do this with a
small amount of cleanup and some preprocessor tricks:

	1. clean up xfs_cmn_err() panic mask functionality to avoid
	   needing debug code in xfs_cmn_err()
	2. remove the couple of "!" message prefixes that still exist that
	   the existing cmn_err() code steps over.
	3. redefine CE_* levels directly to KERN_*
	4. redefine cmn_err() and friends to use printk() directly
	   via variable argument length macros.

By doing this, we can completely remove the cmn_err() code and the
lock that is causing the problems, and rely solely on printk()
serialisation to ensure that we don't get garbled messages.

A series of followup patches is really needed to clean up all the
cmn_err() calls and related messages properly, but that results in a
series that is not easily back portable to enterprise kernels. Hence
this initial fix is only to address the direct problem in the lowest
impact way possible.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/linux-2.6/xfs_sysctl.c |   23 ++++++++-
 fs/xfs/support/debug.c        |  109 +++++++++++++++++++----------------------
 fs/xfs/support/debug.h        |   25 ++++++---
 fs/xfs/xfs_error.c            |   31 ------------
 fs/xfs/xfs_error.h            |   18 ++-----
 fs/xfs/xfs_log.c              |    2 +-
 fs/xfs/xfs_log_recover.c      |    2 +-
 7 files changed, 96 insertions(+), 114 deletions(-)

diff --git a/fs/xfs/linux-2.6/xfs_sysctl.c b/fs/xfs/linux-2.6/xfs_sysctl.c
index 7bb5092..ee3cee0 100644
--- a/fs/xfs/linux-2.6/xfs_sysctl.c
+++ b/fs/xfs/linux-2.6/xfs_sysctl.c
@@ -18,6 +18,7 @@
 #include "xfs.h"
 #include <linux/sysctl.h>
 #include <linux/proc_fs.h>
+#include "xfs_error.h"
 
 static struct ctl_table_header *xfs_table_header;
 
@@ -51,6 +52,26 @@ xfs_stats_clear_proc_handler(
 
 	return ret;
 }
+
+STATIC int
+xfs_panic_mask_proc_handler(
+	ctl_table	*ctl,
+	int		write,
+	void		__user *buffer,
+	size_t		*lenp,
+	loff_t		*ppos)
+{
+	int		ret, *valp = ctl->data;
+
+	ret = proc_dointvec_minmax(ctl, write, buffer, lenp, ppos);
+	if (!ret && write) {
+		xfs_panic_mask = *valp;
+#ifdef DEBUG
+		xfs_panic_mask |= (XFS_PTAG_SHUTDOWN_CORRUPT | XFS_PTAG_LOGRES);
+#endif
+	}
+	return ret;
+}
 #endif /* CONFIG_PROC_FS */
 
 static ctl_table xfs_table[] = {
@@ -77,7 +98,7 @@ static ctl_table xfs_table[] = {
 		.data		= &xfs_params.panic_mask.val,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
+		.proc_handler	= xfs_panic_mask_proc_handler,
 		.extra1		= &xfs_params.panic_mask.min,
 		.extra2		= &xfs_params.panic_mask.max
 	},
diff --git a/fs/xfs/support/debug.c b/fs/xfs/support/debug.c
index 975aa10..262b099 100644
--- a/fs/xfs/support/debug.c
+++ b/fs/xfs/support/debug.c
@@ -25,80 +25,71 @@
 #include "xfs_mount.h"
 #include "xfs_error.h"
 
-static char		message[1024];	/* keep it off the stack */
-static DEFINE_SPINLOCK(xfs_err_lock);
-
-/* Translate from CE_FOO to KERN_FOO, err_level(CE_FOO) == KERN_FOO */
-#define XFS_MAX_ERR_LEVEL	7
-#define XFS_ERR_MASK		((1 << 3) - 1)
-static const char * const	err_level[XFS_MAX_ERR_LEVEL+1] =
-					{KERN_EMERG, KERN_ALERT, KERN_CRIT,
-					 KERN_ERR, KERN_WARNING, KERN_NOTICE,
-					 KERN_INFO, KERN_DEBUG};
-
 void
-cmn_err(register int level, char *fmt, ...)
+cmn_err(
+	const char	*lvl,
+	const char	*fmt,
+	...)
 {
-	char	*fp = fmt;
-	int	len;
-	ulong	flags;
-	va_list	ap;
-
-	level &= XFS_ERR_MASK;
-	if (level > XFS_MAX_ERR_LEVEL)
-		level = XFS_MAX_ERR_LEVEL;
-	spin_lock_irqsave(&xfs_err_lock,flags);
-	va_start(ap, fmt);
-	if (*fmt == '!') fp++;
-	len = vsnprintf(message, sizeof(message), fp, ap);
-	if (len >= sizeof(message))
-		len = sizeof(message) - 1;
-	if (message[len-1] == '\n')
-		message[len-1] = 0;
-	printk("%s%s\n", err_level[level], message);
-	va_end(ap);
-	spin_unlock_irqrestore(&xfs_err_lock,flags);
-	BUG_ON(level == CE_PANIC);
+	struct va_format vaf;
+	va_list		args;
+
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
+
+	printk("%s%pV", lvl, &vaf);
+	va_end(args);
+
+	BUG_ON(strncmp(lvl, KERN_EMERG, strlen(KERN_EMERG)) == 0);
 }
 
 void
-xfs_fs_vcmn_err(
-	int			level,
+xfs_fs_cmn_err(
+	const char		*lvl,
 	struct xfs_mount	*mp,
-	char			*fmt,
-	va_list			ap)
+	const char		*fmt,
+	...)
 {
-	unsigned long		flags;
-	int			len = 0;
+	struct va_format	vaf;
+	va_list			args;
 
-	level &= XFS_ERR_MASK;
-	if (level > XFS_MAX_ERR_LEVEL)
-		level = XFS_MAX_ERR_LEVEL;
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
 
-	spin_lock_irqsave(&xfs_err_lock,flags);
+	printk("%sFilesystem %s: %pV", lvl, mp->m_fsname, &vaf);
+	va_end(args);
 
-	if (mp) {
-		len = sprintf(message, "Filesystem \"%s\": ", mp->m_fsname);
+	BUG_ON(strncmp(lvl, KERN_EMERG, strlen(KERN_EMERG)) == 0);
+}
+
+/* All callers to xfs_cmn_err use CE_ALERT, so don't bother testing lvl */
+void
+xfs_cmn_err(
+	int			panic_tag,
+	const char		*lvl,
+	struct xfs_mount	*mp,
+	const char		*fmt,
+	...)
+{
+	struct va_format	vaf;
+	va_list			args;
+	int			panic = 0;
 
-		/*
-		 * Skip the printk if we can't print anything useful
-		 * due to an over-long device name.
-		 */
-		if (len >= sizeof(message))
-			goto out;
+	if (xfs_panic_mask && (xfs_panic_mask & panic_tag)) {
+		printk(KERN_ALERT "XFS: Transforming an alert into a BUG.");
+		panic = 1;
 	}
 
-	len = vsnprintf(message + len, sizeof(message) - len, fmt, ap);
-	if (len >= sizeof(message))
-		len = sizeof(message) - 1;
-	if (message[len-1] == '\n')
-		message[len-1] = 0;
+	va_start(args, fmt);
+	vaf.fmt = fmt;
+	vaf.va = &args;
 
-	printk("%s%s\n", err_level[level], message);
- out:
-	spin_unlock_irqrestore(&xfs_err_lock,flags);
+	printk(KERN_ALERT "Filesystem %s: %pV", mp->m_fsname, &vaf);
+	va_end(args);
 
-	BUG_ON(level == CE_PANIC);
+	BUG_ON(panic);
 }
 
 void
diff --git a/fs/xfs/support/debug.h b/fs/xfs/support/debug.h
index d2d2046..05699f6 100644
--- a/fs/xfs/support/debug.h
+++ b/fs/xfs/support/debug.h
@@ -20,15 +20,22 @@
 
 #include <stdarg.h>
 
-#define CE_DEBUG        7               /* debug        */
-#define CE_CONT         6               /* continuation */
-#define CE_NOTE         5               /* notice       */
-#define CE_WARN         4               /* warning      */
-#define CE_ALERT        1               /* alert        */
-#define CE_PANIC        0               /* panic        */
-
-extern void cmn_err(int, char *, ...)
-	__attribute__ ((format (printf, 2, 3)));
+struct xfs_mount;
+
+#define CE_DEBUG        KERN_DEBUG
+#define CE_CONT         KERN_INFO
+#define CE_NOTE         KERN_NOTICE
+#define CE_WARN         KERN_WARNING
+#define CE_ALERT        KERN_ALERT
+#define CE_PANIC        KERN_EMERG
+
+void cmn_err(const char *lvl, const char *fmt, ...)
+		__attribute__ ((format (printf, 2, 3)));
+void xfs_fs_cmn_err( const char *lvl, struct xfs_mount *mp,
+		const char *fmt, ...) __attribute__ ((format (printf, 3, 4)));
+void xfs_cmn_err( int panic_tag, const char *lvl, struct xfs_mount *mp,
+		const char *fmt, ...) __attribute__ ((format (printf, 4, 5)));
+
 extern void assfail(char *expr, char *f, int l);
 
 #define ASSERT_ALWAYS(expr)	\
diff --git a/fs/xfs/xfs_error.c b/fs/xfs/xfs_error.c
index c78cc6a..4c7db74 100644
--- a/fs/xfs/xfs_error.c
+++ b/fs/xfs/xfs_error.c
@@ -152,37 +152,6 @@ xfs_errortag_clearall(xfs_mount_t *mp, int loud)
 }
 #endif /* DEBUG */
 
-
-void
-xfs_fs_cmn_err(int level, xfs_mount_t *mp, char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	xfs_fs_vcmn_err(level, mp, fmt, ap);
-	va_end(ap);
-}
-
-void
-xfs_cmn_err(int panic_tag, int level, xfs_mount_t *mp, char *fmt, ...)
-{
-	va_list ap;
-
-#ifdef DEBUG
-	xfs_panic_mask |= (XFS_PTAG_SHUTDOWN_CORRUPT | XFS_PTAG_LOGRES);
-#endif
-
-	if (xfs_panic_mask && (xfs_panic_mask & panic_tag)
-	    && (level & CE_ALERT)) {
-		level &= ~CE_ALERT;
-		level |= CE_PANIC;
-		cmn_err(CE_ALERT, "XFS: Transforming an alert into a BUG.");
-	}
-	va_start(ap, fmt);
-	xfs_fs_vcmn_err(level, mp, fmt, ap);
-	va_end(ap);
-}
-
 void
 xfs_error_report(
 	const char		*tag,
diff --git a/fs/xfs/xfs_error.h b/fs/xfs/xfs_error.h
index f338847..10dce54 100644
--- a/fs/xfs/xfs_error.h
+++ b/fs/xfs/xfs_error.h
@@ -136,8 +136,8 @@ extern int xfs_error_test(int, int *, char *, int, char *, unsigned long);
 	 xfs_error_test((tag), (mp)->m_fixedfsid, "expr", __LINE__, __FILE__, \
 			(rf))))
 
-extern int xfs_errortag_add(int error_tag, xfs_mount_t *mp);
-extern int xfs_errortag_clearall(xfs_mount_t *mp, int loud);
+extern int xfs_errortag_add(int error_tag, struct xfs_mount *mp);
+extern int xfs_errortag_clearall(struct xfs_mount *mp, int loud);
 #else
 #define XFS_TEST_ERROR(expr, mp, tag, rf)	(expr)
 #define xfs_errortag_add(tag, mp)		(ENOSYS)
@@ -162,21 +162,15 @@ extern int xfs_errortag_clearall(xfs_mount_t *mp, int loud);
 
 struct xfs_mount;
 
-extern void xfs_fs_vcmn_err(int level, struct xfs_mount *mp,
-		char *fmt, va_list ap)
-	__attribute__ ((format (printf, 3, 0)));
-extern void xfs_cmn_err(int panic_tag, int level, struct xfs_mount *mp,
-			char *fmt, ...)
-	__attribute__ ((format (printf, 4, 5)));
-extern void xfs_fs_cmn_err(int level, struct xfs_mount *mp, char *fmt, ...)
-	__attribute__ ((format (printf, 3, 4)));
-
 extern void xfs_hex_dump(void *p, int length);
 
 #define xfs_fs_repair_cmn_err(level, mp, fmt, args...) \
 	xfs_fs_cmn_err(level, mp, fmt "  Unmount and run xfs_repair.", ## args)
 
 #define xfs_fs_mount_cmn_err(f, fmt, args...) \
-	((f & XFS_MFSI_QUIET)? (void)0 : cmn_err(CE_WARN, "XFS: " fmt, ## args))
+	do { \
+		if (!(f & XFS_MFSI_QUIET)) 	\
+			cmn_err(CE_WARN, "XFS: " fmt, ## args); \
+	} while (0)
 
 #endif	/* __XFS_ERROR_H__ */
diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0bf24b1..ae6fef1 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -377,7 +377,7 @@ xfs_log_mount(
 		cmn_err(CE_NOTE, "XFS mounting filesystem %s", mp->m_fsname);
 	else {
 		cmn_err(CE_NOTE,
-			"!Mounting filesystem \"%s\" in no-recovery mode.  Filesystem will be inconsistent.",
+			"Mounting filesystem \"%s\" in no-recovery mode.  Filesystem will be inconsistent.",
 			mp->m_fsname);
 		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
 	}
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 204d8e5..aa0ebb7 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -3800,7 +3800,7 @@ xlog_recover_finish(
 		log->l_flags &= ~XLOG_RECOVERY_NEEDED;
 	} else {
 		cmn_err(CE_DEBUG,
-			"!Ending clean XFS mount for filesystem: %s\n",
+			"Ending clean XFS mount for filesystem: %s\n",
 			log->l_mp->m_fsname);
 	}
 	return 0;
-- 
1.7.2.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
