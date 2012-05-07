Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q479FKvY259509 for <xfs@oss.sgi.com>; Mon, 7 May 2012 04:15:21 -0500
Received: from mail-pb0-f53.google.com (mail-pb0-f53.google.com
	[209.85.160.53]) by cuda.sgi.com with ESMTP id EdWguP4I6ZjvzDoI
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 07 May 2012 02:15:19 -0700 (PDT)
Received: by pbbrr13 with SMTP id rr13so7396381pbb.26
	for <xfs@oss.sgi.com>; Mon, 07 May 2012 02:15:19 -0700 (PDT)
From: raghu.prabhu13@gmail.com
Subject: [PATCH] [PATCH] Stop periodic syncing if filesystem is already
	shutdown.
Date: Mon,  7 May 2012 14:44:07 +0530
Message-Id: <a27cbce4f4b35c2a8aee1b58d88c22381fe70ccf.1336378182.git.rprabhu@wnohang.net>
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

This is to prevent syncing from running ad-infinitum till umount if the disk has been forcefully unplugged.

This is to prevent messages like these from being displayed.

==========================================
[ 3816.416570] XFS (sdb3): xfs_do_force_shutdown(0x1) called from line 1031 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffff8127c13a
[ 3816.416586] XFS (sdb3): I/O Error Detected. Shutting down filesystem
[ 3816.416592] XFS (sdb3): Please umount the filesystem and rectify the problem(s)
[ 3842.941953] XFS (sdb3): xfs_log_force: error 5 returned.
[ 3873.009329] XFS (sdb3): xfs_log_force: error 5 returned.
[ 3878.913310] XFS (sdb3): xfs_log_force: error 5 returned.
[ 3878.913322] XFS (sdb3): xfs_do_force_shutdown(0x1) called from line 1031 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffff8127c13a
[ 3878.913350] XFS (sdb3): xfs_log_force: error 5 returned.
[ 3878.913362] XFS (sdb3): xfs_log_force: error 5 returned.
===========================================

Note, that even after xfs_do_force_shutdown has been called, xfs_log_force
doesn't stop till the filesystem has been unmounted (and it keeps printing
"error 5 returned" to kernel log).

To simulate it, mount an xfs filesystem located on external disk, and then pull
the power to the disk (non-usb powered disk).

Tested it on latest linus tree. 
Now, the kernel log looks,

[ 2477.305280] XFS (sdc3): xfs_do_force_shutdown(0x1) called from line 1031 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffff8127c13a
[ 2477.305295] XFS (sdc3): I/O Error Detected. Shutting down filesystem
[ 2477.305300] XFS (sdc3): Please umount the filesystem and rectify the problem(s)
[ 2477.305588] XFS (sdc2): xfs_do_force_shutdown(0x1) called from line 1031 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffff8127c13a
[ 2477.305600] XFS (sdc2): I/O Error Detected. Shutting down filesystem
[ 2477.305604] XFS (sdc2): Please umount the filesystem and rectify the problem(s)
[ 2487.810718] XFS (sdc3): xfs_log_force: error 5 returned.
[ 2487.810729] XFS (sdc3): xfs_do_force_shutdown(0x1) called from line 1031 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffff8127c13a
[ 2487.812981] XFS (sdc2): xfs_log_force: error 5 returned.
[ 2487.812991] XFS (sdc2): xfs_do_force_shutdown(0x1) called from line 1031 of file fs/xfs/xfs_buf.c.  Return address = 0xffffffff8127c13a
[ 2489.420042] XFS (sdc3): Filesystem not writable / already shutdown.
[ 2490.955438] XFS (sdc2): Filesystem not writable / already shutdown.

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
Tested-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
 fs/xfs/xfs_sync.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/xfs/xfs_sync.c b/fs/xfs/xfs_sync.c
index 205ebcb..7ec412c 100644
--- a/fs/xfs/xfs_sync.c
+++ b/fs/xfs/xfs_sync.c
@@ -460,6 +460,12 @@ xfs_sync_worker(
 					struct xfs_mount, m_sync_work);
 	int		error;
 
+	if (!xfs_fs_writable(mp)) {
+		xfs_err(mp, "Filesystem not writable / already shutdown.");
+		xfs_syncd_stop(mp);
+		return;
+	}
+
 	if (!(mp->m_flags & XFS_MOUNT_RDONLY)) {
 		/* dgc: errors ignored here */
 		if (mp->m_super->s_frozen == SB_UNFROZEN &&
@@ -551,6 +557,12 @@ xfs_flush_worker(
 	struct xfs_mount *mp = container_of(work,
 					struct xfs_mount, m_flush_work);
 
+	if (!xfs_fs_writable(mp)) {
+		xfs_err(mp, "Filesystem not writable / already shutdown.");
+		xfs_syncd_stop(mp);
+		return;
+	}
+
 	xfs_sync_data(mp, SYNC_TRYLOCK);
 	xfs_sync_data(mp, SYNC_TRYLOCK | SYNC_WAIT);
 }
-- 
1.7.10.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
