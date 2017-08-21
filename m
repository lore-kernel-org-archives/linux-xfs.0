Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4521 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750967AbdHULt2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Aug 2017 07:49:28 -0400
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH RFC 2/3] xfs: add sysfs files for default values of error configuration
Date: Mon, 21 Aug 2017 19:54:21 +0800
Message-ID: <1503316462-16553-3-git-send-email-houtao1@huawei.com>
In-Reply-To: <1503316462-16553-1-git-send-email-houtao1@huawei.com>
References: <1503316462-16553-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, cmaiolino@redhat.com

Both the hierarchies and the names are the same with the sysfs tree
of the mount-point specific error configuration. The only difference
is the root of error configuration sysfs tree: for the sysfs tree of
default values it is "xfs/default_error" instead of "xfs/<dev_name>/error".

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/xfs/xfs_mount.h |  14 +++++
 fs/xfs/xfs_super.c |  11 +++-
 fs/xfs/xfs_sysfs.c | 158 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_sysfs.h |   2 +
 4 files changed, 180 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 3e80aff..a655821 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -73,6 +73,13 @@ struct xfs_mp_error_cfg_kobj {
 	struct xfs_error_cfg cfg;
 };
 
+struct xfs_dft_error_cfg_kobj {
+	struct xfs_kobj kobj;
+	struct xfs_error_cfg cfg;
+	int error_class;
+	int error_nr;
+};
+
 struct xfs_mp_error_obj {
 	struct xfs_kobj kobj;
 	struct xfs_kobj meta_kobj;
@@ -80,6 +87,13 @@ struct xfs_mp_error_obj {
 	bool fail_unmount;
 };
 
+struct xfs_dft_error_obj {
+	struct xfs_kobj kobj;
+	struct xfs_kobj meta_kobj;
+	struct xfs_dft_error_cfg_kobj cfg_kobj[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
+	bool fail_unmount;
+};
+
 typedef struct xfs_mount {
 	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
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
index 7c15cba..9270cb1 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -45,6 +45,8 @@ struct xfs_sysfs_attr {
 			 size_t count);
 };
 
+static struct xfs_dft_error_obj xfs_dft_eobj;
+
 static inline struct xfs_sysfs_attr *
 to_attr(struct attribute *attr)
 {
@@ -57,8 +59,12 @@ to_attr(struct attribute *attr)
 	static struct xfs_sysfs_attr xfs_sysfs_attr_##name = __ATTR_RO(name)
 #define XFS_SYSFS_ATTR_WO(name) \
 	static struct xfs_sysfs_attr xfs_sysfs_attr_##name = __ATTR_WO(name)
+#define XFS_SYSFS_DFT_ATTR_RW(name) \
+	static struct xfs_sysfs_attr xfs_sysfs_attr_dft_##name = \
+		__ATTR(name, 0644, dft_##name##_show, dft_##name##_store)
 
-#define ATTR_LIST(name) &xfs_sysfs_attr_##name.attr
+#define ATTR_LIST(name) (&xfs_sysfs_attr_##name.attr)
+#define DFT_ATTR_LIST(name) (&xfs_sysfs_attr_dft_##name.attr)
 
 STATIC ssize_t
 xfs_sysfs_object_show(
@@ -344,16 +350,34 @@ static inline struct xfs_mp_error_cfg_kobj *
 to_mp_error_cfg_kobj(struct kobject *kobject)
 {
 	struct xfs_kobj *kobj = to_kobj(kobject);
+
 	return container_of(kobj, struct xfs_mp_error_cfg_kobj, kobj);
 }
 
+static inline struct xfs_dft_error_cfg_kobj *
+to_dft_error_cfg_kobj(struct kobject *kobject)
+{
+	struct xfs_kobj *kobj = to_kobj(kobject);
+
+	return container_of(kobj, struct xfs_dft_error_cfg_kobj, kobj);
+}
+
 static inline struct xfs_mp_error_obj *
 to_mp_error_obj(struct kobject *kobject)
 {
 	struct xfs_kobj *kobj = to_kobj(kobject);
+
 	return container_of(kobj, struct xfs_mp_error_obj, kobj);
 }
 
+static inline struct xfs_dft_error_obj *
+to_dft_error_obj(struct kobject *kobject)
+{
+	struct xfs_kobj *kobj = to_kobj(kobject);
+
+	return container_of(kobj, struct xfs_dft_error_obj, kobj);
+}
+
 static ssize_t
 __max_retries_show(
 	struct xfs_error_cfg *cfg,
@@ -415,6 +439,30 @@ max_retries_store(
 XFS_SYSFS_ATTR_RW(max_retries);
 
 static ssize_t
+dft_max_retries_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	struct xfs_dft_error_cfg_kobj *cfg_kobj =
+	    to_dft_error_cfg_kobj(kobject);
+
+	return __max_retries_show(&cfg_kobj->cfg, buf);
+}
+
+static ssize_t
+dft_max_retries_store(
+	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
+	struct xfs_dft_error_cfg_kobj *cfg_kobj =
+	    to_dft_error_cfg_kobj(kobject);
+
+	return __max_retries_store(&cfg_kobj->cfg, buf, count);
+}
+XFS_SYSFS_DFT_ATTR_RW(max_retries);
+
+static ssize_t
 __retry_timeout_seconds_show(
 	struct xfs_error_cfg *cfg,
 	char		*buf)
@@ -477,6 +525,30 @@ retry_timeout_seconds_store(
 }
 XFS_SYSFS_ATTR_RW(retry_timeout_seconds);
 
+static ssize_t
+dft_retry_timeout_seconds_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	struct xfs_dft_error_cfg_kobj *cfg_kobj =
+	    to_dft_error_cfg_kobj(kobject);
+
+	return __retry_timeout_seconds_show(&cfg_kobj->cfg, buf);
+}
+
+static ssize_t
+dft_retry_timeout_seconds_store(
+	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
+	struct xfs_dft_error_cfg_kobj *cfg_kobj =
+	    to_dft_error_cfg_kobj(kobject);
+
+	return __retry_timeout_seconds_store(&cfg_kobj->cfg, buf, count);
+}
+XFS_SYSFS_DFT_ATTR_RW(retry_timeout_seconds);
+
 static inline ssize_t
 __fail_at_unmount_show(
 	bool fail_unmount,
@@ -527,12 +599,39 @@ fail_at_unmount_store(
 }
 XFS_SYSFS_ATTR_RW(fail_at_unmount);
 
+static ssize_t
+dft_fail_at_unmount_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	struct xfs_dft_error_obj *eobj = to_dft_error_obj(kobject);
+
+	return __fail_at_unmount_show(eobj->fail_unmount, buf);
+}
+
+static ssize_t
+dft_fail_at_unmount_store(
+	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
+	struct xfs_dft_error_obj *eobj = to_dft_error_obj(kobject);
+
+	return __fail_at_unmount_store(&eobj->fail_unmount, buf, count);
+}
+XFS_SYSFS_DFT_ATTR_RW(fail_at_unmount);
+
 static struct attribute *xfs_error_attrs[] = {
 	ATTR_LIST(max_retries),
 	ATTR_LIST(retry_timeout_seconds),
 	NULL,
 };
 
+static struct attribute *xfs_dft_error_attrs[] = {
+	DFT_ATTR_LIST(max_retries),
+	DFT_ATTR_LIST(retry_timeout_seconds),
+	NULL,
+};
 
 static struct kobj_type xfs_error_cfg_ktype = {
 	.release = xfs_sysfs_release,
@@ -540,6 +639,12 @@ static struct kobj_type xfs_error_cfg_ktype = {
 	.default_attrs = xfs_error_attrs,
 };
 
+static struct kobj_type xfs_dft_error_cfg_ktype = {
+	.release = xfs_sysfs_release,
+	.sysfs_ops = &xfs_sysfs_ops,
+	.default_attrs = xfs_dft_error_attrs,
+};
+
 static struct kobj_type xfs_error_ktype = {
 	.release = xfs_sysfs_release,
 	.sysfs_ops = &xfs_sysfs_ops,
@@ -621,7 +726,7 @@ __xfs_error_sysfs_init(
 {
 	int			error;
 
-	/* .../xfs/<dev>/error/ */
+	/* .../xfs/default_error/ or .../xfs/<dev>/error/ */
 	error = xfs_sysfs_init(arg->kobj, &xfs_error_ktype, parent, name);
 	if (error)
 		return error;
@@ -630,7 +735,7 @@ __xfs_error_sysfs_init(
 	if (error)
 		goto out_error;
 
-	/* .../xfs/<dev>/error/metadata/ */
+	/* .../xfs/error/metadata/ or .../xfs/<dev>/error/metadata/ */
 	error = xfs_error_sysfs_init_class(arg, XFS_ERR_METADATA,
 				"metadata", xfs_error_meta_init);
 	if (error)
@@ -758,3 +863,50 @@ xfs_error_get_cfg(
 
 	return &eobj->cfg_kobj[error_class][idx].cfg;
 }
+
+static struct xfs_kobj *
+xfs_get_dft_error_cfg_kobj(
+	void *priv,
+	int class,
+	int nr)
+{
+	struct xfs_dft_error_obj *eobj = priv;
+
+	return &eobj->cfg_kobj[class][nr].kobj;
+}
+
+int
+xfs_dft_error_sysfs_init(struct kset *kset)
+{
+	struct xfs_dft_error_obj *eobj = &xfs_dft_eobj;
+	struct xfs_error_sysfs_arg arg;
+
+	eobj->kobj.kobject.kset = kset;
+
+	eobj->fail_unmount = 1;
+
+	arg.kobj = &eobj->kobj;
+	arg.meta_kobj = &eobj->meta_kobj;
+	arg.fail_unmount_attr = DFT_ATTR_LIST(fail_at_unmount);
+	arg.cfg_ktype = &xfs_dft_error_cfg_ktype;
+	arg.get_cfg_kobj = xfs_get_dft_error_cfg_kobj;
+	arg.priv = eobj;
+
+	return __xfs_error_sysfs_init(&arg, "default_error", NULL);
+}
+
+void
+xfs_dft_error_sysfs_del(void)
+{
+	struct xfs_dft_error_obj *eobj = &xfs_dft_eobj;
+	struct xfs_error_sysfs_arg arg;
+
+	arg.kobj = &eobj->kobj;
+	arg.meta_kobj = &eobj->meta_kobj;
+	arg.fail_unmount_attr = NULL;
+	arg.cfg_ktype = NULL;
+	arg.get_cfg_kobj = xfs_get_dft_error_cfg_kobj;
+	arg.priv = eobj;
+
+	__xfs_error_sysfs_del(&arg);
+}
diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
index 4c8b62c..acfaa70 100644
--- a/fs/xfs/xfs_sysfs.h
+++ b/fs/xfs/xfs_sysfs.h
@@ -63,5 +63,7 @@ xfs_sysfs_del(
 int	xfs_error_sysfs_init(struct xfs_mp_error_obj *eobj,
 		struct xfs_kobj *parent);
 void	xfs_error_sysfs_del(struct xfs_mp_error_obj *eobj);
+int	xfs_dft_error_sysfs_init(struct kset *kset);
+void	xfs_dft_error_sysfs_del(void);
 
 #endif	/* __XFS_SYSFS_H__ */
-- 
2.5.0

