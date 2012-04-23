Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3N5xexP127632 for <xfs@oss.sgi.com>; Mon, 23 Apr 2012 00:59:41 -0500
Received: from ipmail04.adl6.internode.on.net (ipmail04.adl6.internode.on.net
	[150.101.137.141]) by cuda.sgi.com with ESMTP id
	4ojSM98CBbH5gD22 for <xfs@oss.sgi.com>;
	Sun, 22 Apr 2012 22:59:38 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SMCJF-0001bE-7H
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:37 +1000
Received: from dave by disappointment with local (Exim 4.77)
	(envelope-from <dave@disappointment.disaster>) id 1SMCJF-0004Yz-4T
	for xfs@oss.sgi.com; Mon, 23 Apr 2012 15:59:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 33/37] xfs: move xfs_do_force_shutdown() and kill xfs_rw.c
Date: Mon, 23 Apr 2012 15:59:03 +1000
Message-Id: <1335160747-17254-34-git-send-email-david@fromorbit.com>
In-Reply-To: <1335160747-17254-1-git-send-email-david@fromorbit.com>
References: <1335160747-17254-1-git-send-email-david@fromorbit.com>
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

xfs-do-force_shutdown now is the only thing in xfs_rw.c. There is no
need to keep it in it's own file anymore, so move it to xfs_fsops.c
next to xfs_fs_goingdown() and kill xfs_rw.c.

Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/Makefile    |    1 -
 fs/xfs/xfs_fsops.c |   60 +++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_rw.c    |   90 ----------------------------------------------------
 3 files changed, 60 insertions(+), 91 deletions(-)
 delete mode 100644 fs/xfs/xfs_rw.c

diff --git a/fs/xfs/Makefile b/fs/xfs/Makefile
index ca9229f..d2bf974 100644
--- a/fs/xfs/Makefile
+++ b/fs/xfs/Makefile
@@ -50,7 +50,6 @@ xfs-y				+= xfs_aops.o \
 				   xfs_sync.o \
 				   xfs_xattr.o \
 				   xfs_rename.o \
-				   xfs_rw.o \
 				   xfs_utils.o \
 				   xfs_vnodeops.o \
 				   kmem.o \
diff --git a/fs/xfs/xfs_fsops.c b/fs/xfs/xfs_fsops.c
index f6c7698..537c2ae 100644
--- a/fs/xfs/xfs_fsops.c
+++ b/fs/xfs/xfs_fsops.c
@@ -688,3 +688,63 @@ xfs_fs_goingdown(
 
 	return 0;
 }
+
+/*
+ * Force a shutdown of the filesystem instantly while keeping the filesystem
+ * consistent. We don't do an unmount here; just shutdown the shop, make sure
+ * that absolutely nothing persistent happens to this filesystem after this
+ * point.
+ */
+void
+xfs_do_force_shutdown(
+	xfs_mount_t	*mp,
+	int		flags,
+	char		*fname,
+	int		lnnum)
+{
+	int		logerror;
+
+	logerror = flags & SHUTDOWN_LOG_IO_ERROR;
+
+	if (!(flags & SHUTDOWN_FORCE_UMOUNT)) {
+		xfs_notice(mp,
+	"%s(0x%x) called from line %d of file %s.  Return address = 0x%p",
+			__func__, flags, lnnum, fname, __return_address);
+	}
+	/*
+	 * No need to duplicate efforts.
+	 */
+	if (XFS_FORCED_SHUTDOWN(mp) && !logerror)
+		return;
+
+	/*
+	 * This flags XFS_MOUNT_FS_SHUTDOWN, makes sure that we don't
+	 * queue up anybody new on the log reservations, and wakes up
+	 * everybody who's sleeping on log reservations to tell them
+	 * the bad news.
+	 */
+	if (xfs_log_force_umount(mp, logerror))
+		return;
+
+	if (flags & SHUTDOWN_CORRUPT_INCORE) {
+		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_CORRUPT,
+    "Corruption of in-memory data detected.  Shutting down filesystem");
+		if (XFS_ERRLEVEL_HIGH <= xfs_error_level)
+			xfs_stack_trace();
+	} else if (!(flags & SHUTDOWN_FORCE_UMOUNT)) {
+		if (logerror) {
+			xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_LOGERROR,
+		"Log I/O Error Detected.  Shutting down filesystem");
+		} else if (flags & SHUTDOWN_DEVICE_REQ) {
+			xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
+		"All device paths lost.  Shutting down filesystem");
+		} else if (!(flags & SHUTDOWN_REMOTE_REQ)) {
+			xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
+		"I/O Error Detected. Shutting down filesystem");
+		}
+	}
+	if (!(flags & SHUTDOWN_FORCE_UMOUNT)) {
+		xfs_alert(mp,
+	"Please umount the filesystem and rectify the problem(s)");
+	}
+}
diff --git a/fs/xfs/xfs_rw.c b/fs/xfs/xfs_rw.c
deleted file mode 100644
index c406cb6..0000000
--- a/fs/xfs/xfs_rw.c
+++ /dev/null
@@ -1,90 +0,0 @@
-/*
- * Copyright (c) 2000-2006 Silicon Graphics, Inc.
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
-#include "xfs.h"
-#include "xfs_fs.h"
-#include "xfs_types.h"
-#include "xfs_bit.h"
-#include "xfs_log.h"
-#include "xfs_trans.h"
-#include "xfs_sb.h"
-#include "xfs_ag.h"
-#include "xfs_mount.h"
-#include "xfs_bmap_btree.h"
-#include "xfs_dinode.h"
-#include "xfs_inode.h"
-#include "xfs_error.h"
-
-/*
- * Force a shutdown of the filesystem instantly while keeping
- * the filesystem consistent. We don't do an unmount here; just shutdown
- * the shop, make sure that absolutely nothing persistent happens to
- * this filesystem after this point.
- */
-void
-xfs_do_force_shutdown(
-	xfs_mount_t	*mp,
-	int		flags,
-	char		*fname,
-	int		lnnum)
-{
-	int		logerror;
-
-	logerror = flags & SHUTDOWN_LOG_IO_ERROR;
-
-	if (!(flags & SHUTDOWN_FORCE_UMOUNT)) {
-		xfs_notice(mp,
-	"%s(0x%x) called from line %d of file %s.  Return address = 0x%p",
-			__func__, flags, lnnum, fname, __return_address);
-	}
-	/*
-	 * No need to duplicate efforts.
-	 */
-	if (XFS_FORCED_SHUTDOWN(mp) && !logerror)
-		return;
-
-	/*
-	 * This flags XFS_MOUNT_FS_SHUTDOWN, makes sure that we don't
-	 * queue up anybody new on the log reservations, and wakes up
-	 * everybody who's sleeping on log reservations to tell them
-	 * the bad news.
-	 */
-	if (xfs_log_force_umount(mp, logerror))
-		return;
-
-	if (flags & SHUTDOWN_CORRUPT_INCORE) {
-		xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_CORRUPT,
-    "Corruption of in-memory data detected.  Shutting down filesystem");
-		if (XFS_ERRLEVEL_HIGH <= xfs_error_level)
-			xfs_stack_trace();
-	} else if (!(flags & SHUTDOWN_FORCE_UMOUNT)) {
-		if (logerror) {
-			xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_LOGERROR,
-		"Log I/O Error Detected.  Shutting down filesystem");
-		} else if (flags & SHUTDOWN_DEVICE_REQ) {
-			xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
-		"All device paths lost.  Shutting down filesystem");
-		} else if (!(flags & SHUTDOWN_REMOTE_REQ)) {
-			xfs_alert_tag(mp, XFS_PTAG_SHUTDOWN_IOERROR,
-		"I/O Error Detected. Shutting down filesystem");
-		}
-	}
-	if (!(flags & SHUTDOWN_FORCE_UMOUNT)) {
-		xfs_alert(mp,
-	"Please umount the filesystem and rectify the problem(s)");
-	}
-}
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
