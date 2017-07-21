Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39496 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754608AbdGUPY3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Jul 2017 11:24:29 -0400
Subject: [PATCH 1/2] xfs: write unmount record for ro mounts
References: <e98c7179-fdb0-1cc7-544b-c55489451db5@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <94b5e8b2-64cf-8945-83ff-15336f64e1b6@sandeen.net>
Date: Fri, 21 Jul 2017 10:24:28 -0500
MIME-Version: 1.0
In-Reply-To: <e98c7179-fdb0-1cc7-544b-c55489451db5@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>, linux-xfs <linux-xfs@vger.kernel.org>

There are dueling comments in the xfs code about intent
for log writes when unmounting a readonly filesystem.

In xfs_mountfs, we see the intent:

/*
 * Now the log is fully replayed, we can transition to full read-only
 * mode for read-only mounts. This will sync all the metadata and clean
 * the log so that the recovery we just performed does not have to be
 * replayed again on the next mount.
 */

and it calls xfs_quiesce_attr(), but by the time we get to 
xfs_log_unmount_write(), it returns early for a RDONLY mount:

 * Don't write out unmount record on read-only mounts.

Because of this, sequential ro mounts of a filesystem with
a dirty log will replay the log each time, which seems odd.

Fix this by writing an unmount record even for RO mounts, as long
as norecovery wasn't specified (don't write a clean log record
if a dirty log may still be there!) and the log device is
writable.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---


diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index 0053bcf..0bd1341 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -801,11 +801,14 @@
 	int		 error;
 
 	/*
-	 * Don't write out unmount record on read-only mounts.
+	 * Don't write out unmount record on norecovery mounts or ro devices.
 	 * Or, if we cd are doing a forced umount (typically because of IO errors).
 	 */
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
+	    xfs_readonly_buftarg(log->l_mp->m_logdev_targp)) {
+		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
 		return 0;
+	}
 
 	error = _xfs_log_force(mp, XFS_LOG_SYNC, NULL);
 	ASSERT(error || !(XLOG_FORCED_SHUTDOWN(log)));


