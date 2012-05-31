Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q4VI7oTj058355 for <xfs@oss.sgi.com>; Thu, 31 May 2012 13:07:50 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id Pcblox640SdGNtu9
	(version=TLSv1 cipher=RC4-MD5 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 31 May 2012 11:07:49 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so2179348pbb.26
	for <xfs@oss.sgi.com>; Thu, 31 May 2012 11:07:49 -0700 (PDT)
From: raghu.prabhu13@gmail.com
Subject: [PATCH v4] Stop periodic syncing if filesystem is already shutdown.
Date: Thu, 31 May 2012 23:37:34 +0530
Message-Id: <d585aa328fc296e20bd3a180c2c3dbc4c77c45df.1338487073.git.rprabhu@wnohang.net>
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
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, raghu.prabhu13@gmail.com

From: Raghavendra D Prabhu <rprabhu@wnohang.net>

This is to prevent xfs_log_force from running ad-infinitum (due to xfs_sync)
till umount if the disk has been forcefully unplugged.

This is also to prevent messages like these from being displayed repeatedly.

[ 3873.009329] XFS (sdb3): xfs_log_force: error 5 returned.

Note, that even after xfs_do_force_shutdown has been called, xfs_log_force
doesn't stop till the filesystem has been unmounted (and it keeps printing
"error 5 returned" to kernel log).

To fix it, added return statements to xfs_log_force and xfs_fs_sync_fs if the
filesystem is already shutdown -- based on XFS_FORCED_SHUTDOWN.

To simulate it, mount an xfs filesystem located on external disk, and then pull
the power to the disk.

Tested it on latest linus tree.

Now, the dmesg looks,

[  268.307303] XFS (sdb2): xfs_do_force_shutdown(0x1) called from line 1031 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffff8127c13a
[  268.307318] XFS (sdb2): I/O Error Detected. Shutting down filesystem
[  268.307323] XFS (sdb2): Please umount the filesystem and rectify the problem(s)

---

Version 1: Removed calling xfs_syncd_stop from xfs_sync_worker.
Version 2: Removed calling xfs_fs_writable in xfs_sync_worker and xfs_flush_worker.
Version 3: Removed calling xfs_syncd_stop in xfs_bwrite.
Version 4: Added return statements to xfs_log_force and xfs_fs_sync_fs.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
Tested-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
  ---
---
 fs/xfs/xfs_log.c   |    7 +++++++
 fs/xfs/xfs_super.c |    7 +++++++
 2 files changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 6db1fef..e4192b2 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -2932,6 +2932,13 @@ xfs_log_force(
 {
 	int	error;
 
+	/*
+	 * No need to printk here since xfs_bwrite already printks about xfs
+	 * shutdown if it has shutdown already.
+	 */
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return;
+
 	error = _xfs_log_force(mp, flags, NULL);
 	if (error)
 		xfs_warn(mp, "%s: error %d returned.", __func__, error);
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index dab9a5f..b0f6041 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1010,6 +1010,13 @@ xfs_fs_sync_fs(
 	int			error;
 
 	/*
+	 * No need to printk here since xfs_bwrite already printks about xfs
+	 * shutdown if it has shutdown already.
+	 */
+	if (XFS_FORCED_SHUTDOWN(mp))
+		return XFS_ERROR(EIO);
+
+	/*
 	 * Doing anything during the async pass would be counterproductive.
 	 */
 	if (!wait)
-- 
1.7.10.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
