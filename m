Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:44664 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751936AbcLFJQy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 6 Dec 2016 04:16:54 -0500
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH] xfs: during log recovery, destroy the unlinked inodes even for read-only mount
Date: Tue, 6 Dec 2016 17:00:47 +0800
Message-ID: <1481014847-22242-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: david@fromorbit.com, stable@vger.kernel.org

During the 2nd stage of log recovery, if the filesystem is firstly mounted
as read-only, the unlink inodes will not be destroyed and the unlinked list
in AGI will not be cleared. Even after a read-write remount or umount,
the unlinked inodes will still be valid and be kept on disk, and the
available freespace will be incorrect.

To fix the problem, we need to force xfs_inactive() to destroy the
unlinked inode when the filesystem is mounted as read-only.
So clear the XFS_MOUNT_RDONLY flag temporarily before the recovery
of unlinked inodes and restore the flag after the recovery has done.

The problem can be reproduced by the following steps:
1. mount a xfs fs on a KVM VM
2. on the VM launch an application which does the following things:
   open(xfs_file); unlink(xfs_file);
   while(1) { write(xfs_file, 2MB); sleep(1); }
3. wait 5 seconds, sync the xfs fs, and wait 5 seconds
4. terminate the VM
5. start the VM and mount the xfs as read-only
6. remount the xfs as read-write or umount
7. check the unlinked list and the available freespace

Cc: <stable@vger.kernel.org>        [3.10+]
Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/xfs/xfs_log_recover.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 9b3d7c7..fcc83e0 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -5025,6 +5025,7 @@ xlog_recover_process_iunlinks(
 	int		bucket;
 	int		error;
 	uint		mp_dmevmask;
+	int ro_mount;
 
 	mp = log->l_mp;
 
@@ -5034,6 +5035,11 @@ xlog_recover_process_iunlinks(
 	mp_dmevmask = mp->m_dmevmask;
 	mp->m_dmevmask = 0;
 
+	/* Destroy the unlinked inodes even for read-only mount */
+	ro_mount = mp->m_flags & XFS_MOUNT_RDONLY;
+	if (ro_mount)
+		mp->m_flags &= ~XFS_MOUNT_RDONLY;
+
 	for (agno = 0; agno < mp->m_sb.sb_agcount; agno++) {
 		/*
 		 * Find the agi for this ag.
@@ -5070,6 +5076,9 @@ xlog_recover_process_iunlinks(
 		xfs_buf_rele(agibp);
 	}
 
+	if (ro_mount)
+		mp->m_flags |= XFS_MOUNT_RDONLY;
+
 	mp->m_dmevmask = mp_dmevmask;
 }
 
-- 
2.5.0

