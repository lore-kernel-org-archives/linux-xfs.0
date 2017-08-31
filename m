Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:5081 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751410AbdHaOLP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 10:11:15 -0400
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH 4/7] xfs: merge the initialization table into the default error configuration
Date: Thu, 31 Aug 2017 22:15:55 +0800
Message-ID: <1504188958-18374-5-git-send-email-houtao1@huawei.com>
In-Reply-To: <1504188958-18374-1-git-send-email-houtao1@huawei.com>
References: <1504188958-18374-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, david@fromorbit.com, cmaiolino@redhat.com

There is no need to save the initial default values in two difference
places: the initialization table and the default error configuration,
so merge them.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/xfs/xfs_mount.c |  3 ---
 fs/xfs/xfs_sysfs.c | 77 +++++++++++++++++++++++-------------------------------
 2 files changed, 32 insertions(+), 48 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 19f729e..bf56d97 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -703,9 +703,6 @@ xfs_mountfs(
 
 	xfs_set_maxicount(mp);
 
-	/* enable fail_at_unmount as default */
-	mp->m_eobj.fail_unmount = true;
-
 	error = xfs_sysfs_init(&mp->m_kobj, &xfs_mp_ktype, NULL, mp->m_fsname);
 	if (error)
 		goto out;
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 64f33b1..c623d92 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -52,6 +52,9 @@ to_attr(struct attribute *attr)
 
 #define ATTR_LIST(name) (&xfs_sysfs_attr_##name.attr)
 
+static const char *xfs_error_meta_name[XFS_ERR_ERRNO_MAX] = {
+	"default", "EIO", "ENOSPC", "ENODEV",
+};
 static struct xfs_error_obj xfs_dft_eobj;
 
 STATIC ssize_t
@@ -565,44 +568,13 @@ static struct kobj_type xfs_error_ktype = {
 	.sysfs_ops = &xfs_sysfs_ops,
 };
 
-/*
- * Error initialization tables. These need to be ordered in the same
- * order as the enums used to index the array. All class init tables need to
- * define a "default" behaviour as the first entry, all other entries can be
- * empty.
- */
-struct xfs_error_init {
-	char		*name;
-	int		max_retries;
-	int		retry_timeout;	/* in seconds */
-};
-
-static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
-	{ .name = "default",
-	  .max_retries = XFS_ERR_RETRY_FOREVER,
-	  .retry_timeout = XFS_ERR_RETRY_FOREVER,
-	},
-	{ .name = "EIO",
-	  .max_retries = XFS_ERR_RETRY_FOREVER,
-	  .retry_timeout = XFS_ERR_RETRY_FOREVER,
-	},
-	{ .name = "ENOSPC",
-	  .max_retries = XFS_ERR_RETRY_FOREVER,
-	  .retry_timeout = XFS_ERR_RETRY_FOREVER,
-	},
-	{ .name = "ENODEV",
-	  .max_retries = 0,	/* We can't recover from devices disappearing */
-	  .retry_timeout = 0,
-	},
-};
-
 static int
 xfs_error_sysfs_init_class(
 	struct xfs_error_obj	*eobj,
 	int			class,
 	const char		*parent_name,
 	struct xfs_kobj	*parent_kobj,
-	const struct xfs_error_init init[])
+	const char	*name[])
 {
 	struct xfs_error_cfg_kobj *cfg_kobj;
 	int			error;
@@ -616,23 +588,13 @@ xfs_error_sysfs_init_class(
 		return error;
 
 	for (i = 0; i < XFS_ERR_ERRNO_MAX; i++) {
-		struct xfs_error_cfg *cfg;
-
 		cfg_kobj = &eobj->cfg_kobj[class][i];
 		cfg_kobj->flags = eobj->flags &
 			BIT(XFS_ERR_CFG_BIT_ALWAYS_PRIV);
 		error = xfs_sysfs_init(&cfg_kobj->kobj, &xfs_error_cfg_ktype,
-					parent_kobj, init[i].name);
+					parent_kobj, name[i]);
 		if (error)
 			goto out_error;
-
-		cfg = &cfg_kobj->cfg;
-		cfg->max_retries = init[i].max_retries;
-		if (init[i].retry_timeout == XFS_ERR_RETRY_FOREVER)
-			cfg->retry_timeout = XFS_ERR_RETRY_FOREVER;
-		else
-			cfg->retry_timeout = msecs_to_jiffies(
-					init[i].retry_timeout * MSEC_PER_SEC);
 	}
 
 	return 0;
@@ -672,7 +634,7 @@ xfs_error_sysfs_init(
 	/* .../xfs/error/metadata/ or .../xfs/<dev>/error/metadata/ */
 	error = xfs_error_sysfs_init_class(eobj, XFS_ERR_METADATA,
 				"metadata", &eobj->meta_kobj,
-				xfs_error_meta_init);
+				xfs_error_meta_name);
 	if (error)
 		goto out_error;
 
@@ -701,12 +663,37 @@ xfs_error_sysfs_del(
 	xfs_sysfs_del(&eobj->kobj);
 }
 
+static void
+xfs_dft_error_cfg_init(
+	struct xfs_error_obj *eobj)
+{
+	int class = XFS_ERR_METADATA;
+	int i;
+	struct xfs_error_cfg *cfg;
+
+	/* enable fail_unmount as default */
+	eobj->fail_unmount = true;
+
+	for (i = 0; i < XFS_ERR_ERRNO_MAX; i++) {
+		cfg = &eobj->cfg_kobj[class][i].cfg;
+
+		cfg->max_retries = XFS_ERR_RETRY_FOREVER;
+		cfg->retry_timeout = XFS_ERR_RETRY_FOREVER;
+	}
+
+	/* We can't recover from devices disappearing */
+	cfg = &eobj->cfg_kobj[class][XFS_ERR_ENODEV].cfg;
+	cfg->max_retries = 0;
+	cfg->retry_timeout = 0;
+}
+
 int
 xfs_dft_error_sysfs_init(
 	struct kset *xfs_kset)
 {
 	xfs_dft_eobj.kobj.kobject.kset = xfs_kset;
-	xfs_dft_eobj.fail_unmount = true;
+
+	xfs_dft_error_cfg_init(&xfs_dft_eobj);
 
 	return xfs_error_sysfs_init(&xfs_dft_eobj, NULL, "default_error",
 			BIT(XFS_ERR_CFG_BIT_ALWAYS_PRIV));
-- 
2.5.0

