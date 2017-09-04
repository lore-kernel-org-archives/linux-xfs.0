Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:5516 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751620AbdIDGwr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Sep 2017 02:52:47 -0400
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH v3] xfs: add online uevent for mount operation
Date: Mon, 4 Sep 2017 14:50:59 +0800
Message-ID: <1504507859-39323-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, david@fromorbit.com

It will be useful if there is a corresponding online uevent after
a XFS filesystem has been mounted. A typical usage of the uevent
is setting the error configuration for a specific XFS filesystem
or all XFS filesystems by using udevd.

The following is an example of udevd rule which will shutdown
any XFS filesystem (except the one with the matched UUID) after
the filesystem gets any IO error and the filesystem with the matched
UUID will retry 5 times before its shutdown:

    ACTION=="online", SUBSYSTEM=="xfs", \
    ENV{ID_FS_UUID}=="6c1eebfd-d1af-4b69-a0f1-c9b4663df44d", \
    RUN+="/bin/sh -c 'echo 5 > /sys%p/error/metadata/EIO/max_retries'", \
    GOTO="end"

    ACTION=="online", SUBSYSTEM=="xfs", DEVPATH=="/fs/xfs/*", \
    RUN+="/bin/sh -c 'echo 0 > /sys%p/error/metadata/default/max_retries; \
	echo 0 > /sys%p/error/metadata/EIO/max_retries; \
	echo 0 > /sys%p/error/metadata/ENOSPC/max_retries; \
	echo 0 > /sys%p/error/metadata/ENODEV/max_retries'"

    LABEL="end"

Suggested-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Hou Tao <houtao1@huawei.com>
---
v3:
    * code style fixes
    * use "ID_FS_UUID" instead of "UUID" as the name of uuid environment
v2:
    * add UUID property for mount uevent
    * add an udev example for UUID filtering
v1:
    * http://www.spinics.net/lists/linux-xfs/msg09484.html
---
 fs/xfs/xfs_super.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 3a3812b4..1f0d895 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1530,6 +1530,28 @@ xfs_destroy_percpu_counters(
 	percpu_counter_destroy(&mp->m_fdblocks);
 }
 
+static void
+xfs_fs_uevent(
+	struct xfs_mount	*mp,
+	enum kobject_action	action)
+{
+#define XFS_UEVENT_MAX_ENV_COUNT 1
+	/* "+ 1" for the trailing NULL pointer */
+	char			*envp[XFS_UEVENT_MAX_ENV_COUNT + 1];
+	const char		*prefix = "ID_FS_UUID=";
+	char			buf[strlen(prefix) + UUID_STRING_LEN + 1];
+	int			i = 0;
+	int			err;
+
+	snprintf(buf, sizeof(buf), "%s%pUb", prefix, &mp->m_super->s_uuid);
+	envp[i++] = buf;
+	envp[i] = NULL;
+	err = kobject_uevent_env(&mp->m_kobj.kobject, action, envp);
+	if (err)
+		xfs_notice(mp, "Sending XFS uevent %d got error %d",
+				action, err);
+}
+
 STATIC int
 xfs_fs_fill_super(
 	struct super_block	*sb,
@@ -1667,6 +1689,8 @@ xfs_fs_fill_super(
 		goto out_unmount;
 	}
 
+	xfs_fs_uevent(mp, KOBJ_ONLINE);
+
 	return 0;
 
  out_filestream_unmount:
-- 
2.5.0

