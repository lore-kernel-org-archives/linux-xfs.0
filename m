Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4522 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751814AbdHULtd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Aug 2017 07:49:33 -0400
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH RFC 1/3] xfs: prepare for the customizable default values of error configuration
Date: Mon, 21 Aug 2017 19:54:20 +0800
Message-ID: <1503316462-16553-2-git-send-email-houtao1@huawei.com>
In-Reply-To: <1503316462-16553-1-git-send-email-houtao1@huawei.com>
References: <1503316462-16553-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, cmaiolino@redhat.com

The refactoring includes the following changes:
* move error configuration related fields into a single struct
  xfs_mp_error_obj for convenience.
* move kobj out of xfs_error_cfg, so the sysfs store and show functions
  can be used on both mp-specific error obj and default error obj.
* split the initialization of error cfg and the creation of the sysfs
  files of error cfg. The initial values will come from the default
  error obj instead of a const struct array.
* add struct xfs_error_sysfs_arg to entail the differences between
  mp-specific error obj and default error obj during the initialization
  and the destroy of the sysfs tree

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/xfs/xfs_buf_item.c |   6 +-
 fs/xfs/xfs_mount.c    |   8 +-
 fs/xfs/xfs_mount.h    |  20 ++--
 fs/xfs/xfs_sysfs.c    | 270 ++++++++++++++++++++++++++++++++++++--------------
 fs/xfs/xfs_sysfs.h    |   7 +-
 5 files changed, 224 insertions(+), 87 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 573fc72..fec1376 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1088,7 +1088,7 @@ xfs_buf_iodone_callback_error(
 	struct xfs_mount	*mp = lip->li_mountp;
 	static ulong		lasttime;
 	static xfs_buftarg_t	*lasttarg;
-	struct xfs_error_cfg	*cfg;
+	const struct xfs_error_cfg	*cfg;
 
 	/*
 	 * If we've already decided to shutdown the filesystem because of
@@ -1111,7 +1111,7 @@ xfs_buf_iodone_callback_error(
 	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
 	ASSERT(bp->b_iodone != NULL);
 
-	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
+	cfg = xfs_error_get_cfg(&mp->m_eobj, XFS_ERR_METADATA, bp->b_error);
 
 	/*
 	 * If the write was asynchronous then no one will be looking for the
@@ -1146,7 +1146,7 @@ xfs_buf_iodone_callback_error(
 			goto permanent_error;
 
 	/* At unmount we may treat errors differently */
-	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
+	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_eobj.fail_unmount)
 		goto permanent_error;
 
 	/*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ea7d4b4..d67b5b6 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -704,7 +704,7 @@ xfs_mountfs(
 	xfs_set_maxicount(mp);
 
 	/* enable fail_at_unmount as default */
-	mp->m_fail_unmount = 1;
+	mp->m_eobj.fail_unmount = 1;
 
 	error = xfs_sysfs_init(&mp->m_kobj, &xfs_mp_ktype, NULL, mp->m_fsname);
 	if (error)
@@ -715,7 +715,7 @@ xfs_mountfs(
 	if (error)
 		goto out_remove_sysfs;
 
-	error = xfs_error_sysfs_init(mp);
+	error = xfs_error_sysfs_init(&mp->m_eobj, &mp->m_kobj);
 	if (error)
 		goto out_del_stats;
 
@@ -1042,7 +1042,7 @@ xfs_mountfs(
  out_remove_errortag:
 	xfs_errortag_del(mp);
  out_remove_error_sysfs:
-	xfs_error_sysfs_del(mp);
+	xfs_error_sysfs_del(&mp->m_eobj);
  out_del_stats:
 	xfs_sysfs_del(&mp->m_stats.xs_kobj);
  out_remove_sysfs:
@@ -1149,7 +1149,7 @@ xfs_unmountfs(
 	xfs_free_perag(mp);
 
 	xfs_errortag_del(mp);
-	xfs_error_sysfs_del(mp);
+	xfs_error_sysfs_del(&mp->m_eobj);
 	xfs_sysfs_del(&mp->m_stats.xs_kobj);
 	xfs_sysfs_del(&mp->m_kobj);
 }
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index e0792d0..3e80aff 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -64,11 +64,22 @@ enum {
  * signed lets us store the special "-1" value, meaning retry forever.
  */
 struct xfs_error_cfg {
-	struct xfs_kobj	kobj;
 	int		max_retries;
 	long		retry_timeout;	/* in jiffies, -1 = infinite */
 };
 
+struct xfs_mp_error_cfg_kobj {
+	struct xfs_kobj kobj;
+	struct xfs_error_cfg cfg;
+};
+
+struct xfs_mp_error_obj {
+	struct xfs_kobj kobj;
+	struct xfs_kobj meta_kobj;
+	struct xfs_mp_error_cfg_kobj cfg_kobj[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
+	bool fail_unmount;
+};
+
 typedef struct xfs_mount {
 	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
@@ -171,9 +182,7 @@ typedef struct xfs_mount {
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
 	struct xfs_kobj		m_kobj;
-	struct xfs_kobj		m_error_kobj;
-	struct xfs_kobj		m_error_meta_kobj;
-	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
+	struct xfs_mp_error_obj	m_eobj;
 	struct xstats		m_stats;	/* per-fs stats */
 
 	struct workqueue_struct *m_buf_workqueue;
@@ -196,7 +205,6 @@ typedef struct xfs_mount {
 	 */
 	uint32_t		m_generation;
 
-	bool			m_fail_unmount;
 #ifdef DEBUG
 	/*
 	 * Frequency with which errors are injected.  Replaces xfs_etest; the
@@ -443,7 +451,7 @@ extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
 int	xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 			xfs_off_t count_fsb);
 
-struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
+const struct xfs_error_cfg *xfs_error_get_cfg(struct xfs_mp_error_obj *eobj,
 		int error_class, int error);
 
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 8b2ccc2..7c15cba 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -27,6 +27,17 @@
 #include "xfs_stats.h"
 #include "xfs_mount.h"
 
+typedef struct xfs_kobj * (*xfs_get_error_cfg_kobj_t)(void *priv,
+		int class, int nr);
+struct xfs_error_sysfs_arg {
+	struct xfs_kobj *kobj;
+	struct xfs_kobj *meta_kobj;
+	struct attribute *fail_unmount_attr;
+	struct kobj_type *cfg_ktype;
+	xfs_get_error_cfg_kobj_t get_cfg_kobj;
+	void *priv;
+};
+
 struct xfs_sysfs_attr {
 	struct attribute attr;
 	ssize_t (*show)(struct kobject *kobject, char *buf);
@@ -329,27 +340,26 @@ struct kobj_type xfs_log_ktype = {
  * and any other future type of IO (e.g. special inode or directory error
  * handling) we care to support.
  */
-static inline struct xfs_error_cfg *
-to_error_cfg(struct kobject *kobject)
+static inline struct xfs_mp_error_cfg_kobj *
+to_mp_error_cfg_kobj(struct kobject *kobject)
 {
 	struct xfs_kobj *kobj = to_kobj(kobject);
-	return container_of(kobj, struct xfs_error_cfg, kobj);
+	return container_of(kobj, struct xfs_mp_error_cfg_kobj, kobj);
 }
 
-static inline struct xfs_mount *
-err_to_mp(struct kobject *kobject)
+static inline struct xfs_mp_error_obj *
+to_mp_error_obj(struct kobject *kobject)
 {
 	struct xfs_kobj *kobj = to_kobj(kobject);
-	return container_of(kobj, struct xfs_mount, m_error_kobj);
+	return container_of(kobj, struct xfs_mp_error_obj, kobj);
 }
 
 static ssize_t
-max_retries_show(
-	struct kobject	*kobject,
+__max_retries_show(
+	struct xfs_error_cfg *cfg,
 	char		*buf)
 {
 	int		retries;
-	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
 
 	if (cfg->max_retries == XFS_ERR_RETRY_FOREVER)
 		retries = -1;
@@ -360,12 +370,11 @@ max_retries_show(
 }
 
 static ssize_t
-max_retries_store(
-	struct kobject	*kobject,
+__max_retries_store(
+	struct xfs_error_cfg *cfg,
 	const char	*buf,
 	size_t		count)
 {
-	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
 	int		ret;
 	int		val;
 
@@ -382,15 +391,35 @@ max_retries_store(
 		cfg->max_retries = val;
 	return count;
 }
-XFS_SYSFS_ATTR_RW(max_retries);
 
 static ssize_t
-retry_timeout_seconds_show(
+max_retries_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	struct xfs_mp_error_cfg_kobj *cfg_kobj = to_mp_error_cfg_kobj(kobject);
+
+	return __max_retries_show(&cfg_kobj->cfg, buf);
+}
+
+static ssize_t
+max_retries_store(
 	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
+	struct xfs_mp_error_cfg_kobj *cfg_kobj = to_mp_error_cfg_kobj(kobject);
+
+	return __max_retries_store(&cfg_kobj->cfg, buf, count);
+}
+XFS_SYSFS_ATTR_RW(max_retries);
+
+static ssize_t
+__retry_timeout_seconds_show(
+	struct xfs_error_cfg *cfg,
 	char		*buf)
 {
 	int		timeout;
-	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
 
 	if (cfg->retry_timeout == XFS_ERR_RETRY_FOREVER)
 		timeout = -1;
@@ -401,12 +430,11 @@ retry_timeout_seconds_show(
 }
 
 static ssize_t
-retry_timeout_seconds_store(
-	struct kobject	*kobject,
+__retry_timeout_seconds_store(
+	struct xfs_error_cfg *cfg,
 	const char	*buf,
 	size_t		count)
 {
-	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
 	int		ret;
 	int		val;
 
@@ -426,25 +454,43 @@ retry_timeout_seconds_store(
 	}
 	return count;
 }
-XFS_SYSFS_ATTR_RW(retry_timeout_seconds);
 
 static ssize_t
-fail_at_unmount_show(
+retry_timeout_seconds_show(
 	struct kobject	*kobject,
 	char		*buf)
 {
-	struct xfs_mount	*mp = err_to_mp(kobject);
+	struct xfs_mp_error_cfg_kobj *cfg_kobj = to_mp_error_cfg_kobj(kobject);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", mp->m_fail_unmount);
+	return __retry_timeout_seconds_show(&cfg_kobj->cfg, buf);
 }
 
 static ssize_t
-fail_at_unmount_store(
+retry_timeout_seconds_store(
 	struct kobject	*kobject,
 	const char	*buf,
 	size_t		count)
 {
-	struct xfs_mount	*mp = err_to_mp(kobject);
+	struct xfs_mp_error_cfg_kobj *cfg_kobj = to_mp_error_cfg_kobj(kobject);
+
+	return __retry_timeout_seconds_store(&cfg_kobj->cfg, buf, count);
+}
+XFS_SYSFS_ATTR_RW(retry_timeout_seconds);
+
+static inline ssize_t
+__fail_at_unmount_show(
+	bool fail_unmount,
+	char		*buf)
+{
+	return snprintf(buf, PAGE_SIZE, "%d\n", fail_unmount);
+}
+
+static ssize_t
+__fail_at_unmount_store(
+	bool *fail_unmount,
+	const char	*buf,
+	size_t		count)
+{
 	int		ret;
 	int		val;
 
@@ -455,9 +501,30 @@ fail_at_unmount_store(
 	if (val < 0 || val > 1)
 		return -EINVAL;
 
-	mp->m_fail_unmount = val;
+	*fail_unmount = val;
 	return count;
 }
+
+static ssize_t
+fail_at_unmount_show(
+	struct kobject	*kobject,
+	char		*buf)
+{
+	struct xfs_mp_error_obj *eobj = to_mp_error_obj(kobject);
+
+	return __fail_at_unmount_show(eobj->fail_unmount, buf);
+}
+
+static ssize_t
+fail_at_unmount_store(
+	struct kobject	*kobject,
+	const char	*buf,
+	size_t		count)
+{
+	struct xfs_mp_error_obj *eobj = to_mp_error_obj(kobject);
+
+	return __fail_at_unmount_store(&eobj->fail_unmount, buf, count);
+}
 XFS_SYSFS_ATTR_RW(fail_at_unmount);
 
 static struct attribute *xfs_error_attrs[] = {
@@ -511,124 +578,183 @@ static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
 
 static int
 xfs_error_sysfs_init_class(
-	struct xfs_mount	*mp,
+	struct xfs_error_sysfs_arg *arg,
 	int			class,
 	const char		*parent_name,
-	struct xfs_kobj		*parent_kobj,
 	const struct xfs_error_init init[])
 {
-	struct xfs_error_cfg	*cfg;
 	int			error;
 	int			i;
 
 	ASSERT(class < XFS_ERR_CLASS_MAX);
 
-	error = xfs_sysfs_init(parent_kobj, &xfs_error_ktype,
-				&mp->m_error_kobj, parent_name);
+	error = xfs_sysfs_init(arg->meta_kobj, &xfs_error_ktype,
+				arg->kobj, parent_name);
 	if (error)
 		return error;
 
 	for (i = 0; i < XFS_ERR_ERRNO_MAX; i++) {
-		cfg = &mp->m_error_cfg[class][i];
-		error = xfs_sysfs_init(&cfg->kobj, &xfs_error_cfg_ktype,
-					parent_kobj, init[i].name);
+		struct xfs_kobj *kobj = arg->get_cfg_kobj(arg->priv, class, i);
+
+		error = xfs_sysfs_init(kobj, arg->cfg_ktype,
+					arg->meta_kobj, init[i].name);
 		if (error)
 			goto out_error;
-
-		cfg->max_retries = init[i].max_retries;
-		if (init[i].retry_timeout == XFS_ERR_RETRY_FOREVER)
-			cfg->retry_timeout = XFS_ERR_RETRY_FOREVER;
-		else
-			cfg->retry_timeout = msecs_to_jiffies(
-					init[i].retry_timeout * MSEC_PER_SEC);
 	}
+
 	return 0;
 
 out_error:
 	/* unwind the entries that succeeded */
 	for (i--; i >= 0; i--) {
-		cfg = &mp->m_error_cfg[class][i];
-		xfs_sysfs_del(&cfg->kobj);
+		xfs_sysfs_del(arg->get_cfg_kobj(arg->priv, class, i));
 	}
-	xfs_sysfs_del(parent_kobj);
+	xfs_sysfs_del(arg->meta_kobj);
 	return error;
 }
 
-int
-xfs_error_sysfs_init(
-	struct xfs_mount	*mp)
+static int
+__xfs_error_sysfs_init(
+	struct xfs_error_sysfs_arg *arg,
+	const char *name,
+	struct xfs_kobj *parent)
 {
 	int			error;
 
 	/* .../xfs/<dev>/error/ */
-	error = xfs_sysfs_init(&mp->m_error_kobj, &xfs_error_ktype,
-				&mp->m_kobj, "error");
+	error = xfs_sysfs_init(arg->kobj, &xfs_error_ktype, parent, name);
 	if (error)
 		return error;
 
-	error = sysfs_create_file(&mp->m_error_kobj.kobject,
-				  ATTR_LIST(fail_at_unmount));
-
+	error = sysfs_create_file(&arg->kobj->kobject, arg->fail_unmount_attr);
 	if (error)
 		goto out_error;
 
 	/* .../xfs/<dev>/error/metadata/ */
-	error = xfs_error_sysfs_init_class(mp, XFS_ERR_METADATA,
-				"metadata", &mp->m_error_meta_kobj,
-				xfs_error_meta_init);
+	error = xfs_error_sysfs_init_class(arg, XFS_ERR_METADATA,
+				"metadata", xfs_error_meta_init);
 	if (error)
 		goto out_error;
 
 	return 0;
 
 out_error:
-	xfs_sysfs_del(&mp->m_error_kobj);
+	xfs_sysfs_del(arg->kobj);
 	return error;
 }
 
-void
-xfs_error_sysfs_del(
-	struct xfs_mount	*mp)
+static void
+__xfs_error_sysfs_del(
+	struct xfs_error_sysfs_arg *arg)
 {
-	struct xfs_error_cfg	*cfg;
 	int			i, j;
 
 	for (i = 0; i < XFS_ERR_CLASS_MAX; i++) {
 		for (j = 0; j < XFS_ERR_ERRNO_MAX; j++) {
-			cfg = &mp->m_error_cfg[i][j];
-
-			xfs_sysfs_del(&cfg->kobj);
+			xfs_sysfs_del(arg->get_cfg_kobj(arg->priv, i, j));
 		}
 	}
-	xfs_sysfs_del(&mp->m_error_meta_kobj);
-	xfs_sysfs_del(&mp->m_error_kobj);
+
+	xfs_sysfs_del(arg->meta_kobj);
+	xfs_sysfs_del(arg->kobj);
+}
+
+static struct xfs_kobj *
+xfs_get_mp_error_cfg_kobj(
+	void *priv,
+	int class,
+	int nr)
+{
+	struct xfs_mp_error_obj *eobj = priv;
+
+	return &eobj->cfg_kobj[class][nr].kobj;
+}
+
+static void
+xfs_error_mp_cfg_init(
+	struct xfs_mp_error_obj *eobj,
+	int class,
+	const struct xfs_error_init *init)
+{
+	int i;
+	struct xfs_error_cfg *cfg;
+
+	for (i = 0; i < XFS_ERR_ERRNO_MAX; i++) {
+		cfg = &eobj->cfg_kobj[class][i].cfg;
+
+		cfg->max_retries = init[i].max_retries;
+		if (init[i].retry_timeout == XFS_ERR_RETRY_FOREVER)
+			cfg->retry_timeout = XFS_ERR_RETRY_FOREVER;
+		else
+			cfg->retry_timeout = msecs_to_jiffies(
+					init[i].retry_timeout * MSEC_PER_SEC);
+	}
+}
+
+int
+xfs_error_sysfs_init(
+	struct xfs_mp_error_obj *eobj,
+	struct xfs_kobj *parent)
+{
+	int error;
+	struct xfs_error_sysfs_arg arg;
+
+	xfs_error_mp_cfg_init(eobj, XFS_ERR_METADATA, xfs_error_meta_init);
+
+	arg.kobj = &eobj->kobj;
+	arg.meta_kobj = &eobj->meta_kobj;
+	arg.fail_unmount_attr = ATTR_LIST(fail_at_unmount);
+	arg.cfg_ktype = &xfs_error_cfg_ktype;
+	arg.get_cfg_kobj = xfs_get_mp_error_cfg_kobj;
+	arg.priv = eobj;
+	error = __xfs_error_sysfs_init(&arg, "error", parent);
+	if (error)
+		return error;
+
+	return 0;
+}
+
+void
+xfs_error_sysfs_del(
+	struct xfs_mp_error_obj *eobj)
+{
+	struct xfs_error_sysfs_arg arg;
+
+	arg.kobj = &eobj->kobj;
+	arg.meta_kobj = &eobj->meta_kobj;
+	arg.fail_unmount_attr = NULL;
+	arg.cfg_ktype = NULL;
+	arg.get_cfg_kobj = xfs_get_mp_error_cfg_kobj;
+	arg.priv = eobj;
+
+	__xfs_error_sysfs_del(&arg);
 }
 
-struct xfs_error_cfg *
+const struct xfs_error_cfg *
 xfs_error_get_cfg(
-	struct xfs_mount	*mp,
+	struct xfs_mp_error_obj *eobj,
 	int			error_class,
 	int			error)
 {
-	struct xfs_error_cfg	*cfg;
+	int idx;
 
 	if (error < 0)
 		error = -error;
 
 	switch (error) {
 	case EIO:
-		cfg = &mp->m_error_cfg[error_class][XFS_ERR_EIO];
+		idx = XFS_ERR_EIO;
 		break;
 	case ENOSPC:
-		cfg = &mp->m_error_cfg[error_class][XFS_ERR_ENOSPC];
+		idx = XFS_ERR_ENOSPC;
 		break;
 	case ENODEV:
-		cfg = &mp->m_error_cfg[error_class][XFS_ERR_ENODEV];
+		idx = XFS_ERR_ENODEV;
 		break;
 	default:
-		cfg = &mp->m_error_cfg[error_class][XFS_ERR_DEFAULT];
+		idx = XFS_ERR_DEFAULT;
 		break;
 	}
 
-	return cfg;
+	return &eobj->cfg_kobj[error_class][idx].cfg;
 }
diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
index d046371..4c8b62c 100644
--- a/fs/xfs/xfs_sysfs.h
+++ b/fs/xfs/xfs_sysfs.h
@@ -24,6 +24,8 @@ extern struct kobj_type xfs_dbg_ktype;	/* debug */
 extern struct kobj_type xfs_log_ktype;	/* xlog */
 extern struct kobj_type xfs_stats_ktype;	/* stats */
 
+struct xfs_mp_error_obj;
+
 static inline struct xfs_kobj *
 to_kobj(struct kobject *kobject)
 {
@@ -58,7 +60,8 @@ xfs_sysfs_del(
 	wait_for_completion(&kobj->complete);
 }
 
-int	xfs_error_sysfs_init(struct xfs_mount *mp);
-void	xfs_error_sysfs_del(struct xfs_mount *mp);
+int	xfs_error_sysfs_init(struct xfs_mp_error_obj *eobj,
+		struct xfs_kobj *parent);
+void	xfs_error_sysfs_del(struct xfs_mp_error_obj *eobj);
 
 #endif	/* __XFS_SYSFS_H__ */
-- 
2.5.0

