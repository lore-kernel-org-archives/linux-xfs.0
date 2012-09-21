Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8L4r0ur173209 for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 23:53:00 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id nTnDKFqdNcVQUAtf
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 20 Sep 2012 21:54:13 -0700 (PDT)
Received: by pbbrp16 with SMTP id rp16so7563526pbb.26
	for <xfs@oss.sgi.com>; Thu, 20 Sep 2012 21:54:12 -0700 (PDT)
From: raghu.prabhu13@gmail.com
Subject: [PATCH v6] Stop periodic syncing if filesystem is already shutdown.
Date: Fri, 21 Sep 2012 10:24:04 +0530
Message-Id: <143becf0f8266fbc8025ec97c8f44476d8fcafc5.1348203015.git.rprabhu@wnohang.net>
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
To: david@fromorbit.com
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, xfs@oss.sgi.com

From: Raghavendra D Prabhu <rprabhu@wnohang.net>

This is to prevent xfs_log_force from printing error message continuously (due
to xfs_sync and others) till umount if the disk has been forcefully unplugged.

This is to prevent messages like these from being displayed repeatedly.

[ 3873.009329] XFS (sdb3): xfs_log_force: error 5 returned.

Note, that even after xfs_do_force_shutdown has been called, xfs_log_force
doesn't stop till the filesystem has been unmounted (and it keeps printing
"error 5 returned" to kernel log).

To fix this, added condition over XFS_FORCED_SHUTDOWN to xfs_log_force and
xfs_fs_sync_fs.

To simulate it, mount an xfs filesystem located on external disk, and then pull
the power to the disk.

Now, the dmesg looks,

[  268.307303] XFS (sdb2): xfs_do_force_shutdown(0x1) called from line 1031 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffff8127c13a
[  268.307318] XFS (sdb2): I/O Error Detected. Shutting down filesystem
[  268.307323] XFS (sdb2): Please umount the filesystem and rectify the problem(s)

Version 1: Removed calling xfs_syncd_stop from xfs_sync_worker.
Version 2: Removed calling xfs_fs_writable in xfs_sync_worker and xfs_flush_worker.
Version 3: Removed calling xfs_syncd_stop in xfs_bwrite.
Version 4: Added return statements to xfs_log_force and xfs_fs_sync_fs.
Version 5: As per suggestion, removed EIO return in xfs_log_force.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 fs/xfs/xfs_log.c   | 5 ++++-
 fs/xfs/xfs_super.c | 4 ++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 7f4f937..161c925 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -3002,7 +3002,10 @@ xfs_log_force(
 
 	trace_xfs_log_force(mp, 0);
 	error = _xfs_log_force(mp, flags, NULL);
-	if (error)
+	/*
+	 * Avoid warning when the filesystem has already shutdown.
+	 */
+	if (error && !XFS_FORCED_SHUTDOWN(mp))
 		xfs_warn(mp, "%s: error %d returned.", __func__, error);
 }
 
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 19e2380..8df3387 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -944,6 +944,10 @@ xfs_fs_sync_fs(
 	if (!wait)
 		return 0;
 
+	if (XFS_FORCED_SHUTDOWN(mp)) {
+		return XFS_ERROR(EIO);
+	}
+
 	error = xfs_quiesce_data(mp);
 	if (error)
 		return -error;
-- 
1.7.12.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
