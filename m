Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:5075 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751336AbdHaOLO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 10:11:14 -0400
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH 5/7] xfs: construct the values of error configuration for XFS error handler
Date: Thu, 31 Aug 2017 22:15:56 +0800
Message-ID: <1504188958-18374-6-git-send-email-houtao1@huawei.com>
In-Reply-To: <1504188958-18374-1-git-send-email-houtao1@huawei.com>
References: <1504188958-18374-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, david@fromorbit.com, cmaiolino@redhat.com

When a corresponding XFS_ERR_CFG_BIT_* bit had been set on the error
configuration, the value of the fs-specific error configuration will
be returned, else the value of the default error configuration will
be used.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/xfs/xfs_buf_item.c |  3 ++-
 fs/xfs/xfs_mount.h    |  1 +
 fs/xfs/xfs_sysfs.c    | 19 ++++++++++++++++++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 186c5f5..4f9fd50 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1146,7 +1146,8 @@ xfs_buf_iodone_callback_error(
 		goto permanent_error;
 
 	/* At unmount we may treat errors differently */
-	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_eobj.fail_unmount)
+	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) &&
+			xfs_fail_at_unmount(&mp->m_eobj))
 		goto permanent_error;
 
 	/*
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 906c3a4..ceed665 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -475,5 +475,6 @@ int	xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 
 void xfs_error_get_cfg(struct xfs_error_obj *eobj,
 		int error_class, int error, struct xfs_error_cfg *cfg);
+bool xfs_fail_at_unmount(struct xfs_error_obj *eobj);
 
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index c623d92..cd7dfca 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -713,6 +713,7 @@ xfs_error_get_cfg(
 	struct xfs_error_cfg	*cfg)
 {
 	int idx;
+	struct xfs_error_cfg_kobj *kobj;
 
 	if (error < 0)
 		error = -error;
@@ -732,5 +733,21 @@ xfs_error_get_cfg(
 		break;
 	}
 
-	*cfg = eobj->cfg_kobj[error_class][idx].cfg;
+	*cfg = xfs_dft_eobj.cfg_kobj[error_class][idx].cfg;
+
+	kobj = &eobj->cfg_kobj[error_class][idx];
+	if (test_bit(XFS_ERR_CFG_BIT_PRIV_MAX_RETRIES, &kobj->flags))
+		cfg->max_retries = kobj->cfg.max_retries;
+	if (test_bit(XFS_ERR_CFG_BIT_PRIV_RETRY_TIMEOUT, &kobj->flags))
+		cfg->retry_timeout = kobj->cfg.retry_timeout;
+}
+
+bool
+xfs_fail_at_unmount(
+	struct xfs_error_obj	*eobj)
+{
+	if (!test_bit(XFS_ERR_CFG_BIT_PRIV_FAIL_UNMOUNT, &eobj->flags))
+		return xfs_dft_eobj.fail_unmount;
+	else
+		return eobj->fail_unmount;
 }
-- 
2.5.0

