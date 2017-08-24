Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:4567 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbdHXNVd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2017 09:21:33 -0400
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH] xfs: add online uevent for mount operation
Date: Thu, 24 Aug 2017 21:26:26 +0800
Message-ID: <1503581186-33500-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, david@fromorbit.com

It will be useful if there is a correponding online uevent after
a XFS filesystem has been mounted. A typical usage of the uevent
is setting the error configuration for a specific XFS filesystem
or all XFS filesystems by using udevd.

The following is an example of udevd rule which will shutdown
any XFS filesystem after the filesystem gets any IO error:

    ACTION=="online", SUBSYSTEM=="xfs", DEVPATH=="/fs/xfs/*", \
    RUN+="/bin/sh -c 'echo 0 > /sys%p/error/metadata/default/max_retries; \
	    echo 0 > /sys%p/error/metadata/EIO/max_retries; \
	    echo 0 > /sys%p/error/metadata/ENOSPC/max_retries; \
	    echo 0 > /sys%p/error/metadata/ENODEV/max_retries'"

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/xfs/xfs_super.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 38aaacd..da041bc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1530,6 +1530,18 @@ xfs_destroy_percpu_counters(
 	percpu_counter_destroy(&mp->m_fdblocks);
 }
 
+static void
+xfs_fs_uevent(
+	struct xfs_mount	*mp,
+	enum kobject_action	action)
+{
+	int err;
+
+	err = kobject_uevent(&mp->m_kobj.kobject, action);
+	if (err)
+		xfs_notice(mp, "Sending XFS uevent %d got error %d", action, err);
+}
+
 STATIC int
 xfs_fs_fill_super(
 	struct super_block	*sb,
@@ -1667,6 +1679,8 @@ xfs_fs_fill_super(
 		goto out_unmount;
 	}
 
+	xfs_fs_uevent(mp, KOBJ_ONLINE);
+
 	return 0;
 
  out_filestream_unmount:
-- 
2.5.0

