Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:5077 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751351AbdHaOLP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 10:11:15 -0400
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH 6/7] xfs: show the summary of error configurations for debugging purpose
Date: Thu, 31 Aug 2017 22:15:57 +0800
Message-ID: <1504188958-18374-7-git-send-email-houtao1@huawei.com>
In-Reply-To: <1504188958-18374-1-git-send-email-houtao1@huawei.com>
References: <1504188958-18374-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, david@fromorbit.com, cmaiolino@redhat.com

When the value of an error configuration is "default", the actual
value used by XFS error handler is decided by the corresponding
default error configuration. To ensure they are the same, add
a sysfs file named "summary" to display the actual used values.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/xfs/xfs_sysfs.c | 115 +++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 89 insertions(+), 26 deletions(-)

diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index cd7dfca..0af5e56 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -30,6 +30,9 @@
 #define XFS_ERR_CFG_DEFAULT_VALUE "default"
 #define XFS_ERR_CFG_DEFAULT_VALUE_LEN 7
 
+static void _xfs_error_get_cfg(struct xfs_error_obj *eobj, int error_class,
+		int error_idx, struct xfs_error_cfg *cfg);
+
 struct xfs_sysfs_attr {
 	struct attribute attr;
 	ssize_t (*show)(struct kobject *kobject, char *buf);
@@ -381,26 +384,33 @@ is_value_of_dft_error_cfg(
 			  buf[XFS_ERR_CFG_DEFAULT_VALUE_LEN + 1] == '\0')));
 }
 
+static int
+to_max_retries_show_fmt(
+	int max_retries)
+{
+	int		retries;
+
+	if (max_retries == XFS_ERR_RETRY_FOREVER)
+		retries = -1;
+	else
+		retries = max_retries;
+
+	return retries;
+}
+
 static ssize_t
 max_retries_show(
 	struct kobject	*kobject,
 	char		*buf)
 {
-	int		retries;
 	struct xfs_error_cfg_kobj *cfg_kobj = to_error_cfg_kobj(kobject);
-	struct xfs_error_cfg *cfg;
 
 	if (is_dft_error_cfg(&cfg_kobj->flags,
 				XFS_ERR_CFG_BIT_PRIV_MAX_RETRIES))
 		return dft_error_cfg_show(buf);
 
-	cfg = &cfg_kobj->cfg;
-	if (cfg->max_retries == XFS_ERR_RETRY_FOREVER)
-		retries = -1;
-	else
-		retries = cfg->max_retries;
-
-	return snprintf(buf, PAGE_SIZE, "%d\n", retries);
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			to_max_retries_show_fmt(cfg_kobj->cfg.max_retries));
 }
 
 static ssize_t
@@ -441,26 +451,33 @@ max_retries_store(
 }
 XFS_SYSFS_ATTR_RW(max_retries);
 
+static int
+to_retry_timeout_show_fmt(
+	long retry_timeout)
+{
+	int		timeout;
+
+	if (retry_timeout == XFS_ERR_RETRY_FOREVER)
+		timeout = -1;
+	else
+		timeout = jiffies_to_msecs(retry_timeout) / MSEC_PER_SEC;
+
+	return timeout;
+}
+
 static ssize_t
 retry_timeout_seconds_show(
 	struct kobject	*kobject,
 	char		*buf)
 {
-	int		timeout;
 	struct xfs_error_cfg_kobj *cfg_kobj = to_error_cfg_kobj(kobject);
-	struct xfs_error_cfg *cfg;
 
 	if (is_dft_error_cfg(&cfg_kobj->flags,
 				XFS_ERR_CFG_BIT_PRIV_RETRY_TIMEOUT))
 		return dft_error_cfg_show(buf);
 
-	cfg = &cfg_kobj->cfg;
-	if (cfg->retry_timeout == XFS_ERR_RETRY_FOREVER)
-		timeout = -1;
-	else
-		timeout = jiffies_to_msecs(cfg->retry_timeout) / MSEC_PER_SEC;
-
-	return snprintf(buf, PAGE_SIZE, "%d\n", timeout);
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			to_retry_timeout_show_fmt(cfg_kobj->cfg.retry_timeout));
 }
 
 static ssize_t
@@ -550,6 +567,35 @@ fail_at_unmount_store(
 }
 XFS_SYSFS_ATTR_RW(fail_at_unmount);
 
+#ifdef DEBUG
+static ssize_t
+summary_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	struct xfs_error_obj *eobj = err_to_mp(kobject);
+	int len = PAGE_SIZE;
+	int used = 0;
+	int i;
+	struct xfs_error_cfg cfg;
+
+	used += snprintf(buf + used, len - used, "fail_at_unmount: %d\n",
+			xfs_fail_at_unmount(eobj));
+	for (i = 0; used < len && i < XFS_ERR_ERRNO_MAX; i++) {
+		_xfs_error_get_cfg(eobj, XFS_ERR_METADATA, i, &cfg);
+
+		used += snprintf(buf + used, len - used,
+				"metadata %s: retries %d timeout %d\n",
+				xfs_error_meta_name[i],
+				to_max_retries_show_fmt(cfg.max_retries),
+				to_retry_timeout_show_fmt(cfg.retry_timeout));
+	}
+
+	return used;
+}
+XFS_SYSFS_ATTR_RO(summary);
+#endif /* DEBUG */
+
 static struct attribute *xfs_error_attrs[] = {
 	ATTR_LIST(max_retries),
 	ATTR_LIST(retry_timeout_seconds),
@@ -631,6 +677,12 @@ xfs_error_sysfs_init(
 	if (error)
 		goto out_error;
 
+#ifdef DEBUG
+	error = sysfs_create_file(&eobj->kobj.kobject, ATTR_LIST(summary));
+	if (error)
+		goto out_error;
+#endif
+
 	/* .../xfs/error/metadata/ or .../xfs/<dev>/error/metadata/ */
 	error = xfs_error_sysfs_init_class(eobj, XFS_ERR_METADATA,
 				"metadata", &eobj->meta_kobj,
@@ -706,6 +758,24 @@ xfs_dft_error_sysfs_del(void)
 }
 
 void
+_xfs_error_get_cfg(
+	struct xfs_error_obj	*eobj,
+	int	error_class,
+	int	error_idx,
+	struct xfs_error_cfg *cfg)
+{
+	struct xfs_error_cfg_kobj *kobj;
+
+	*cfg = xfs_dft_eobj.cfg_kobj[error_class][error_idx].cfg;
+
+	kobj = &eobj->cfg_kobj[error_class][error_idx];
+	if (test_bit(XFS_ERR_CFG_BIT_PRIV_MAX_RETRIES, &kobj->flags))
+		cfg->max_retries = kobj->cfg.max_retries;
+	if (test_bit(XFS_ERR_CFG_BIT_PRIV_RETRY_TIMEOUT, &kobj->flags))
+		cfg->retry_timeout = kobj->cfg.retry_timeout;
+}
+
+void
 xfs_error_get_cfg(
 	struct xfs_error_obj	*eobj,
 	int			error_class,
@@ -713,7 +783,6 @@ xfs_error_get_cfg(
 	struct xfs_error_cfg	*cfg)
 {
 	int idx;
-	struct xfs_error_cfg_kobj *kobj;
 
 	if (error < 0)
 		error = -error;
@@ -733,13 +802,7 @@ xfs_error_get_cfg(
 		break;
 	}
 
-	*cfg = xfs_dft_eobj.cfg_kobj[error_class][idx].cfg;
-
-	kobj = &eobj->cfg_kobj[error_class][idx];
-	if (test_bit(XFS_ERR_CFG_BIT_PRIV_MAX_RETRIES, &kobj->flags))
-		cfg->max_retries = kobj->cfg.max_retries;
-	if (test_bit(XFS_ERR_CFG_BIT_PRIV_RETRY_TIMEOUT, &kobj->flags))
-		cfg->retry_timeout = kobj->cfg.retry_timeout;
+	_xfs_error_get_cfg(eobj, error_class, idx, cfg);
 }
 
 bool
-- 
2.5.0

