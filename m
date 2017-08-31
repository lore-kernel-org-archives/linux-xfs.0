Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:5082 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751417AbdHaOLQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 10:11:16 -0400
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH 3/7] xfs: make the default values of error configuration customizable and workable
Date: Thu, 31 Aug 2017 22:15:54 +0800
Message-ID: <1504188958-18374-4-git-send-email-houtao1@huawei.com>
In-Reply-To: <1504188958-18374-1-git-send-email-houtao1@huawei.com>
References: <1504188958-18374-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, david@fromorbit.com, cmaiolino@redhat.com

Because there is no "default" option for the values of the default error
configuration sysfs, we use bit XFS_ERR_CFG_BIT_ALWAYS_PRIV to distinguish
the default error configurations from the fs-specific ones in store() and
show() functions of these error configuration sysfs.

For each error configuration, a corresponding bit is defined to denote
whether or not an explicit value has been set on the error configuration,
and the bit can be cleared by writing "default" to the sysfs file.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/xfs/xfs_mount.c |   2 +-
 fs/xfs/xfs_mount.h |  21 ++++++++++
 fs/xfs/xfs_sysfs.c | 110 +++++++++++++++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_sysfs.h |   2 +-
 4 files changed, 122 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 3970066..19f729e 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -715,7 +715,7 @@ xfs_mountfs(
 	if (error)
 		goto out_remove_sysfs;
 
-	error = xfs_error_sysfs_init(&mp->m_eobj, &mp->m_kobj, "error");
+	error = xfs_error_sysfs_init(&mp->m_eobj, &mp->m_kobj, "error", 0);
 	if (error)
 		goto out_del_stats;
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 15e35f7..906c3a4 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -57,6 +57,23 @@ enum {
 
 #define XFS_ERR_RETRY_FOREVER	-1
 
+enum {
+	/*
+	 * Used by the default error configuration, because it doesn't
+	 * have a "default" value.
+	 */
+	XFS_ERR_CFG_BIT_ALWAYS_PRIV = 0,
+
+	/*
+	 * Use to denote whether or not the error cfg has a private
+	 * value. The private value will not be influenced by the value
+	 * of the corresponding default error configuration.
+	 */
+	XFS_ERR_CFG_BIT_PRIV_FAIL_UNMOUNT = 1,
+	XFS_ERR_CFG_BIT_PRIV_MAX_RETRIES = 2,
+	XFS_ERR_CFG_BIT_PRIV_RETRY_TIMEOUT = 3,
+};
+
 /*
  * Although retry_timeout is in jiffies which is normally an unsigned long,
  * we limit the retry timeout to 86400 seconds, or one day.  So even a
@@ -70,6 +87,8 @@ struct xfs_error_cfg {
 
 struct xfs_error_cfg_kobj {
 	struct xfs_kobj kobj;
+	/* Refer to XFS_ERR_CFG_BIT_* */
+	unsigned long flags;
 	struct xfs_error_cfg cfg;
 };
 
@@ -78,6 +97,8 @@ struct xfs_error_obj {
 	struct xfs_kobj meta_kobj;
 	struct xfs_error_cfg_kobj
 		cfg_kobj[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
+	/* Refer to XFS_ERR_CFG_BIT_* */
+	unsigned long flags;
 	bool fail_unmount;
 };
 
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 4a19fad..64f33b1 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -27,6 +27,9 @@
 #include "xfs_stats.h"
 #include "xfs_mount.h"
 
+#define XFS_ERR_CFG_DEFAULT_VALUE "default"
+#define XFS_ERR_CFG_DEFAULT_VALUE_LEN 7
+
 struct xfs_sysfs_attr {
 	struct attribute attr;
 	ssize_t (*show)(struct kobject *kobject, char *buf);
@@ -326,19 +329,19 @@ struct kobj_type xfs_log_ktype = {
  *
  * The sysfs structure here is:
  *	...xfs/<dev>/error/<class>/<errno>/<error_attrs>
+ *	or
+ *	...xfs/default_error/<class>/<errno>/<error_attrs>
  *
  * where <class> allows us to discriminate between data IO and metadata IO,
  * and any other future type of IO (e.g. special inode or directory error
  * handling) we care to support.
  */
-static inline struct xfs_error_cfg *
-to_error_cfg(struct kobject *kobject)
+static inline struct xfs_error_cfg_kobj *
+to_error_cfg_kobj(struct kobject *kobject)
 {
 	struct xfs_kobj *kobj = to_kobj(kobject);
-	struct xfs_error_cfg_kobj *cfg_kobj =
-		container_of(kobj, struct xfs_error_cfg_kobj, kobj);
 
-	return &cfg_kobj->cfg;
+	return container_of(kobj, struct xfs_error_cfg_kobj, kobj);
 }
 
 static inline struct xfs_error_obj *
@@ -348,14 +351,47 @@ err_to_mp(struct kobject *kobject)
 	return container_of(kobj, struct xfs_error_obj, kobj);
 }
 
+static inline ssize_t
+dft_error_cfg_show(
+	char	*buf)
+{
+	return snprintf(buf, PAGE_SIZE, XFS_ERR_CFG_DEFAULT_VALUE "\n");
+}
+
+static inline bool
+is_dft_error_cfg(
+	unsigned long *flags,
+	unsigned int cfg)
+{
+	return (!test_bit(XFS_ERR_CFG_BIT_ALWAYS_PRIV, flags) &&
+			!test_bit(cfg, flags));
+}
+
+static inline bool
+is_value_of_dft_error_cfg(
+	const char	*buf)
+{
+	return (!strncmp(buf, XFS_ERR_CFG_DEFAULT_VALUE,
+				XFS_ERR_CFG_DEFAULT_VALUE_LEN) &&
+			(buf[XFS_ERR_CFG_DEFAULT_VALUE_LEN] == '\0' ||
+			 (buf[XFS_ERR_CFG_DEFAULT_VALUE_LEN] == '\n' &&
+			  buf[XFS_ERR_CFG_DEFAULT_VALUE_LEN + 1] == '\0')));
+}
+
 static ssize_t
 max_retries_show(
 	struct kobject	*kobject,
 	char		*buf)
 {
 	int		retries;
-	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
+	struct xfs_error_cfg_kobj *cfg_kobj = to_error_cfg_kobj(kobject);
+	struct xfs_error_cfg *cfg;
 
+	if (is_dft_error_cfg(&cfg_kobj->flags,
+				XFS_ERR_CFG_BIT_PRIV_MAX_RETRIES))
+		return dft_error_cfg_show(buf);
+
+	cfg = &cfg_kobj->cfg;
 	if (cfg->max_retries == XFS_ERR_RETRY_FOREVER)
 		retries = -1;
 	else
@@ -370,10 +406,18 @@ max_retries_store(
 	const char	*buf,
 	size_t		count)
 {
-	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
+	struct xfs_error_cfg_kobj *cfg_kobj = to_error_cfg_kobj(kobject);
+	struct xfs_error_cfg *cfg;
+	bool	fs_cfg;
 	int		ret;
 	int		val;
 
+	fs_cfg = !test_bit(XFS_ERR_CFG_BIT_ALWAYS_PRIV, &cfg_kobj->flags);
+	if (fs_cfg && is_value_of_dft_error_cfg(buf)) {
+		clear_bit(XFS_ERR_CFG_BIT_PRIV_MAX_RETRIES, &cfg_kobj->flags);
+		return count;
+	}
+
 	ret = kstrtoint(buf, 0, &val);
 	if (ret)
 		return ret;
@@ -381,10 +425,15 @@ max_retries_store(
 	if (val < -1)
 		return -EINVAL;
 
+	cfg = &cfg_kobj->cfg;
 	if (val == -1)
 		cfg->max_retries = XFS_ERR_RETRY_FOREVER;
 	else
 		cfg->max_retries = val;
+
+	if (fs_cfg)
+		set_bit(XFS_ERR_CFG_BIT_PRIV_MAX_RETRIES, &cfg_kobj->flags);
+
 	return count;
 }
 XFS_SYSFS_ATTR_RW(max_retries);
@@ -395,8 +444,14 @@ retry_timeout_seconds_show(
 	char		*buf)
 {
 	int		timeout;
-	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
+	struct xfs_error_cfg_kobj *cfg_kobj = to_error_cfg_kobj(kobject);
+	struct xfs_error_cfg *cfg;
 
+	if (is_dft_error_cfg(&cfg_kobj->flags,
+				XFS_ERR_CFG_BIT_PRIV_RETRY_TIMEOUT))
+		return dft_error_cfg_show(buf);
+
+	cfg = &cfg_kobj->cfg;
 	if (cfg->retry_timeout == XFS_ERR_RETRY_FOREVER)
 		timeout = -1;
 	else
@@ -411,10 +466,18 @@ retry_timeout_seconds_store(
 	const char	*buf,
 	size_t		count)
 {
-	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
+	struct xfs_error_cfg_kobj *cfg_kobj = to_error_cfg_kobj(kobject);
+	struct xfs_error_cfg *cfg;
+	bool	fs_cfg;
 	int		ret;
 	int		val;
 
+	fs_cfg = !test_bit(XFS_ERR_CFG_BIT_ALWAYS_PRIV, &cfg_kobj->flags);
+	if (fs_cfg && is_value_of_dft_error_cfg(buf)) {
+		clear_bit(XFS_ERR_CFG_BIT_PRIV_RETRY_TIMEOUT, &cfg_kobj->flags);
+		return count;
+	}
+
 	ret = kstrtoint(buf, 0, &val);
 	if (ret)
 		return ret;
@@ -423,12 +486,17 @@ retry_timeout_seconds_store(
 	if (val < -1 || val > 86400)
 		return -EINVAL;
 
+	cfg = &cfg_kobj->cfg;
 	if (val == -1)
 		cfg->retry_timeout = XFS_ERR_RETRY_FOREVER;
 	else {
 		cfg->retry_timeout = msecs_to_jiffies(val * MSEC_PER_SEC);
 		ASSERT(msecs_to_jiffies(val * MSEC_PER_SEC) < LONG_MAX);
 	}
+
+	if (fs_cfg)
+		set_bit(XFS_ERR_CFG_BIT_PRIV_RETRY_TIMEOUT, &cfg_kobj->flags);
+
 	return count;
 }
 XFS_SYSFS_ATTR_RW(retry_timeout_seconds);
@@ -440,6 +508,9 @@ fail_at_unmount_show(
 {
 	struct xfs_error_obj *eobj = err_to_mp(kobject);
 
+	if (is_dft_error_cfg(&eobj->flags, XFS_ERR_CFG_BIT_PRIV_FAIL_UNMOUNT))
+		return dft_error_cfg_show(buf);
+
 	return snprintf(buf, PAGE_SIZE, "%d\n", eobj->fail_unmount);
 }
 
@@ -450,9 +521,16 @@ fail_at_unmount_store(
 	size_t		count)
 {
 	struct xfs_error_obj *eobj = err_to_mp(kobject);
+	bool	fs_cfg;
 	int		ret;
 	int		val;
 
+	fs_cfg = !test_bit(XFS_ERR_CFG_BIT_ALWAYS_PRIV, &eobj->flags);
+	if (fs_cfg && is_value_of_dft_error_cfg(buf)) {
+		clear_bit(XFS_ERR_CFG_BIT_PRIV_FAIL_UNMOUNT, &eobj->flags);
+		return count;
+	}
+
 	ret = kstrtoint(buf, 0, &val);
 	if (ret)
 		return ret;
@@ -461,6 +539,10 @@ fail_at_unmount_store(
 		return -EINVAL;
 
 	eobj->fail_unmount = val;
+
+	if (fs_cfg)
+		set_bit(XFS_ERR_CFG_BIT_PRIV_FAIL_UNMOUNT, &eobj->flags);
+
 	return count;
 }
 XFS_SYSFS_ATTR_RW(fail_at_unmount);
@@ -537,6 +619,8 @@ xfs_error_sysfs_init_class(
 		struct xfs_error_cfg *cfg;
 
 		cfg_kobj = &eobj->cfg_kobj[class][i];
+		cfg_kobj->flags = eobj->flags &
+			BIT(XFS_ERR_CFG_BIT_ALWAYS_PRIV);
 		error = xfs_sysfs_init(&cfg_kobj->kobj, &xfs_error_cfg_ktype,
 					parent_kobj, init[i].name);
 		if (error)
@@ -567,10 +651,13 @@ int
 xfs_error_sysfs_init(
 	struct xfs_error_obj	*eobj,
 	struct xfs_kobj	*parent,
-	const char	*name)
+	const char	*name,
+	unsigned long	flags)
 {
 	int			error;
 
+	eobj->flags = flags & BIT(XFS_ERR_CFG_BIT_ALWAYS_PRIV);
+
 	/* .../xfs/default_error/ or .../xfs/<dev>/error/ */
 	error = xfs_sysfs_init(&eobj->kobj, &xfs_error_ktype,
 				parent, name);
@@ -621,7 +708,8 @@ xfs_dft_error_sysfs_init(
 	xfs_dft_eobj.kobj.kobject.kset = xfs_kset;
 	xfs_dft_eobj.fail_unmount = true;
 
-	return xfs_error_sysfs_init(&xfs_dft_eobj, NULL, "default_error");
+	return xfs_error_sysfs_init(&xfs_dft_eobj, NULL, "default_error",
+			BIT(XFS_ERR_CFG_BIT_ALWAYS_PRIV));
 }
 
 void
diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
index 90970c6..77773e5 100644
--- a/fs/xfs/xfs_sysfs.h
+++ b/fs/xfs/xfs_sysfs.h
@@ -65,7 +65,7 @@ int xfs_dft_error_sysfs_init(struct kset *xfs_kset);
 void xfs_dft_error_sysfs_del(void);
 
 int xfs_error_sysfs_init(struct xfs_error_obj *eobj,
-		struct xfs_kobj *parent, const char *name);
+		struct xfs_kobj *parent, const char *name, unsigned long flags);
 void xfs_error_sysfs_del(struct xfs_error_obj *eobj);
 
 #endif	/* __XFS_SYSFS_H__ */
-- 
2.5.0

