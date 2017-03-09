Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:52202 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751037AbdCIUP1 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Mar 2017 15:15:27 -0500
Subject: [PATCH 1/2] xfs: write unmount record for ro mounts
References: <bbb0243d-e491-02e0-1802-e95cba4e8486@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <9a573fb1-0d4c-e393-b0b7-a0688b3849e5@sandeen.net>
Date: Thu, 9 Mar 2017 14:15:01 -0600
MIME-Version: 1.0
In-Reply-To: <bbb0243d-e491-02e0-1802-e95cba4e8486@redhat.com>
Content-Type: text/plain; charset=utf-8
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
---

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index b1469f0..62176b8 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -801,11 +801,14 @@
 	int		 error;
 
 	/*
-	 * Don't write out unmount record on read-only mounts.
+	 * Don't write out unmount record on norecovery mounts or ro devices.
 	 * Or, if we are doing a forced umount (typically because of IO errors).
 	 */
-	if (mp->m_flags & XFS_MOUNT_RDONLY)
+	if (mp->m_flags & XFS_MOUNT_NORECOVERY ||
+	    xfs_readonly_buftarg(log->l_mp->m_logdev_targp)) {
+		ASSERT(mp->m_flags & XFS_MOUNT_RDONLY);
 		return 0;
+	}
 
 	error = _xfs_log_force(mp, XFS_LOG_SYNC, NULL);
 	ASSERT(error || !(XLOG_FORCED_SHUTDOWN(log)));

