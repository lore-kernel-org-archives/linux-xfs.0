Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:5078 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751386AbdHaOLO (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 10:11:14 -0400
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH 2/7] xfs: add sysfs files for default values of error configuration
Date: Thu, 31 Aug 2017 22:15:53 +0800
Message-ID: <1504188958-18374-3-git-send-email-houtao1@huawei.com>
In-Reply-To: <1504188958-18374-1-git-send-email-houtao1@huawei.com>
References: <1504188958-18374-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, david@fromorbit.com, cmaiolino@redhat.com

Both the hierarchies and the names are the same with the sysfs tree
of the filesystem-specific error configuration. The only difference
is the root of error configuration sysfs tree: for the default error
configuration it is ".../xfs/default_error/" instead of
".../xfs/<dev_name>/error/".

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/xfs/xfs_super.c | 11 +++++++++--
 fs/xfs/xfs_sysfs.c | 22 ++++++++++++++++++++--
 fs/xfs/xfs_sysfs.h |  3 +++
 3 files changed, 32 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 38aaacd..3a3812b4 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -2043,11 +2043,15 @@ init_xfs_fs(void)
 	if (error)
 		goto out_free_stats;
 
+	error = xfs_dft_error_sysfs_init(xfs_kset);
+	if (error)
+		goto out_remove_stats_kobj;
+
 #ifdef DEBUG
 	xfs_dbg_kobj.kobject.kset = xfs_kset;
 	error = xfs_sysfs_init(&xfs_dbg_kobj, &xfs_dbg_ktype, NULL, "debug");
 	if (error)
-		goto out_remove_stats_kobj;
+		goto out_remove_dft_error_sysfs;
 #endif
 
 	error = xfs_qm_init();
@@ -2064,8 +2068,10 @@ init_xfs_fs(void)
  out_remove_dbg_kobj:
 #ifdef DEBUG
 	xfs_sysfs_del(&xfs_dbg_kobj);
- out_remove_stats_kobj:
+ out_remove_dft_error_sysfs:
 #endif
+	xfs_dft_error_sysfs_del();
+ out_remove_stats_kobj:
 	xfs_sysfs_del(&xfsstats.xs_kobj);
  out_free_stats:
 	free_percpu(xfsstats.xs_stats);
@@ -2095,6 +2101,7 @@ exit_xfs_fs(void)
 #ifdef DEBUG
 	xfs_sysfs_del(&xfs_dbg_kobj);
 #endif
+	xfs_dft_error_sysfs_del();
 	xfs_sysfs_del(&xfsstats.xs_kobj);
 	free_percpu(xfsstats.xs_stats);
 	kset_unregister(xfs_kset);
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 966cf3f..4a19fad 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -49,6 +49,8 @@ to_attr(struct attribute *attr)
 
 #define ATTR_LIST(name) (&xfs_sysfs_attr_##name.attr)
 
+static struct xfs_error_obj xfs_dft_eobj;
+
 STATIC ssize_t
 xfs_sysfs_object_show(
 	struct kobject		*kobject,
@@ -569,7 +571,7 @@ xfs_error_sysfs_init(
 {
 	int			error;
 
-	/* .../xfs/<dev>/error/ */
+	/* .../xfs/default_error/ or .../xfs/<dev>/error/ */
 	error = xfs_sysfs_init(&eobj->kobj, &xfs_error_ktype,
 				parent, name);
 	if (error)
@@ -580,7 +582,7 @@ xfs_error_sysfs_init(
 	if (error)
 		goto out_error;
 
-	/* .../xfs/<dev>/error/metadata/ */
+	/* .../xfs/error/metadata/ or .../xfs/<dev>/error/metadata/ */
 	error = xfs_error_sysfs_init_class(eobj, XFS_ERR_METADATA,
 				"metadata", &eobj->meta_kobj,
 				xfs_error_meta_init);
@@ -612,6 +614,22 @@ xfs_error_sysfs_del(
 	xfs_sysfs_del(&eobj->kobj);
 }
 
+int
+xfs_dft_error_sysfs_init(
+	struct kset *xfs_kset)
+{
+	xfs_dft_eobj.kobj.kobject.kset = xfs_kset;
+	xfs_dft_eobj.fail_unmount = true;
+
+	return xfs_error_sysfs_init(&xfs_dft_eobj, NULL, "default_error");
+}
+
+void
+xfs_dft_error_sysfs_del(void)
+{
+	xfs_error_sysfs_del(&xfs_dft_eobj);
+}
+
 void
 xfs_error_get_cfg(
 	struct xfs_error_obj	*eobj,
diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
index a0e4c17..90970c6 100644
--- a/fs/xfs/xfs_sysfs.h
+++ b/fs/xfs/xfs_sysfs.h
@@ -61,6 +61,9 @@ xfs_sysfs_del(
 	wait_for_completion(&kobj->complete);
 }
 
+int xfs_dft_error_sysfs_init(struct kset *xfs_kset);
+void xfs_dft_error_sysfs_del(void);
+
 int xfs_error_sysfs_init(struct xfs_error_obj *eobj,
 		struct xfs_kobj *parent, const char *name);
 void xfs_error_sysfs_del(struct xfs_error_obj *eobj);
-- 
2.5.0

