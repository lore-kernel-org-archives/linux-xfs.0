Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:5080 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751399AbdHaOLP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 10:11:15 -0400
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH 1/7] xfs: prepare for the customizable default values of error configuration
Date: Thu, 31 Aug 2017 22:15:52 +0800
Message-ID: <1504188958-18374-2-git-send-email-houtao1@huawei.com>
In-Reply-To: <1504188958-18374-1-git-send-email-houtao1@huawei.com>
References: <1504188958-18374-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, david@fromorbit.com, cmaiolino@redhat.com

The refactoring includes the following changes:
* move error configuration related fields into a single struct
  xfs_error_obj, so it can be used on both the default erorr
  configuration and the fs-specific one
* move kobj out of xfs_error_cfg to make it small, so we can
  define it on stack and get the values by mixing the values
  from the default error configuration and the fs-specific one

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/xfs/xfs_buf_item.c | 22 ++++++-------
 fs/xfs/xfs_mount.c    |  8 ++---
 fs/xfs/xfs_mount.h    | 23 +++++++++----
 fs/xfs/xfs_sysfs.c    | 91 ++++++++++++++++++++++++++++-----------------------
 fs/xfs/xfs_sysfs.h    |  8 +++--
 5 files changed, 87 insertions(+), 65 deletions(-)

diff --git a/fs/xfs/xfs_buf_item.c b/fs/xfs/xfs_buf_item.c
index 573fc72..186c5f5 100644
--- a/fs/xfs/xfs_buf_item.c
+++ b/fs/xfs/xfs_buf_item.c
@@ -1088,7 +1088,7 @@ xfs_buf_iodone_callback_error(
 	struct xfs_mount	*mp = lip->li_mountp;
 	static ulong		lasttime;
 	static xfs_buftarg_t	*lasttarg;
-	struct xfs_error_cfg	*cfg;
+	struct xfs_error_cfg	cfg;
 
 	/*
 	 * If we've already decided to shutdown the filesystem because of
@@ -1111,7 +1111,7 @@ xfs_buf_iodone_callback_error(
 	trace_xfs_buf_item_iodone_async(bp, _RET_IP_);
 	ASSERT(bp->b_iodone != NULL);
 
-	cfg = xfs_error_get_cfg(mp, XFS_ERR_METADATA, bp->b_error);
+	xfs_error_get_cfg(&mp->m_eobj, XFS_ERR_METADATA, bp->b_error, &cfg);
 
 	/*
 	 * If the write was asynchronous then no one will be looking for the
@@ -1124,7 +1124,7 @@ xfs_buf_iodone_callback_error(
 	     bp->b_last_error != bp->b_error) {
 		bp->b_flags |= (XBF_WRITE | XBF_DONE | XBF_WRITE_FAIL);
 		bp->b_last_error = bp->b_error;
-		if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
+		if (cfg.retry_timeout != XFS_ERR_RETRY_FOREVER &&
 		    !bp->b_first_retry_time)
 			bp->b_first_retry_time = jiffies;
 
@@ -1137,16 +1137,16 @@ xfs_buf_iodone_callback_error(
 	 * Repeated failure on an async write. Take action according to the
 	 * error configuration we have been set up to use.
 	 */
-
-	if (cfg->max_retries != XFS_ERR_RETRY_FOREVER &&
-	    ++bp->b_retries > cfg->max_retries)
-			goto permanent_error;
-	if (cfg->retry_timeout != XFS_ERR_RETRY_FOREVER &&
-	    time_after(jiffies, cfg->retry_timeout + bp->b_first_retry_time))
-			goto permanent_error;
+	if (cfg.max_retries != XFS_ERR_RETRY_FOREVER &&
+			++bp->b_retries > cfg.max_retries)
+		goto permanent_error;
+	if (cfg.retry_timeout != XFS_ERR_RETRY_FOREVER &&
+			time_after(jiffies,
+				cfg.retry_timeout + bp->b_first_retry_time))
+		goto permanent_error;
 
 	/* At unmount we may treat errors differently */
-	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_fail_unmount)
+	if ((mp->m_flags & XFS_MOUNT_UNMOUNTING) && mp->m_eobj.fail_unmount)
 		goto permanent_error;
 
 	/*
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index ea7d4b4..3970066 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -704,7 +704,7 @@ xfs_mountfs(
 	xfs_set_maxicount(mp);
 
 	/* enable fail_at_unmount as default */
-	mp->m_fail_unmount = 1;
+	mp->m_eobj.fail_unmount = true;
 
 	error = xfs_sysfs_init(&mp->m_kobj, &xfs_mp_ktype, NULL, mp->m_fsname);
 	if (error)
@@ -715,7 +715,7 @@ xfs_mountfs(
 	if (error)
 		goto out_remove_sysfs;
 
-	error = xfs_error_sysfs_init(mp);
+	error = xfs_error_sysfs_init(&mp->m_eobj, &mp->m_kobj, "error");
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
index e0792d0..15e35f7 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -64,11 +64,23 @@ enum {
  * signed lets us store the special "-1" value, meaning retry forever.
  */
 struct xfs_error_cfg {
-	struct xfs_kobj	kobj;
 	int		max_retries;
 	long		retry_timeout;	/* in jiffies, -1 = infinite */
 };
 
+struct xfs_error_cfg_kobj {
+	struct xfs_kobj kobj;
+	struct xfs_error_cfg cfg;
+};
+
+struct xfs_error_obj {
+	struct xfs_kobj kobj;
+	struct xfs_kobj meta_kobj;
+	struct xfs_error_cfg_kobj
+		cfg_kobj[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
+	bool fail_unmount;
+};
+
 typedef struct xfs_mount {
 	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
@@ -171,9 +183,7 @@ typedef struct xfs_mount {
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
 	struct xfs_kobj		m_kobj;
-	struct xfs_kobj		m_error_kobj;
-	struct xfs_kobj		m_error_meta_kobj;
-	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
+	struct xfs_error_obj	m_eobj;
 	struct xstats		m_stats;	/* per-fs stats */
 
 	struct workqueue_struct *m_buf_workqueue;
@@ -196,7 +206,6 @@ typedef struct xfs_mount {
 	 */
 	uint32_t		m_generation;
 
-	bool			m_fail_unmount;
 #ifdef DEBUG
 	/*
 	 * Frequency with which errors are injected.  Replaces xfs_etest; the
@@ -443,7 +452,7 @@ extern void	xfs_set_low_space_thresholds(struct xfs_mount *);
 int	xfs_zero_extent(struct xfs_inode *ip, xfs_fsblock_t start_fsb,
 			xfs_off_t count_fsb);
 
-struct xfs_error_cfg * xfs_error_get_cfg(struct xfs_mount *mp,
-		int error_class, int error);
+void xfs_error_get_cfg(struct xfs_error_obj *eobj,
+		int error_class, int error, struct xfs_error_cfg *cfg);
 
 #endif	/* __XFS_MOUNT_H__ */
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 8b2ccc2..966cf3f 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -47,7 +47,7 @@ to_attr(struct attribute *attr)
 #define XFS_SYSFS_ATTR_WO(name) \
 	static struct xfs_sysfs_attr xfs_sysfs_attr_##name = __ATTR_WO(name)
 
-#define ATTR_LIST(name) &xfs_sysfs_attr_##name.attr
+#define ATTR_LIST(name) (&xfs_sysfs_attr_##name.attr)
 
 STATIC ssize_t
 xfs_sysfs_object_show(
@@ -333,14 +333,17 @@ static inline struct xfs_error_cfg *
 to_error_cfg(struct kobject *kobject)
 {
 	struct xfs_kobj *kobj = to_kobj(kobject);
-	return container_of(kobj, struct xfs_error_cfg, kobj);
+	struct xfs_error_cfg_kobj *cfg_kobj =
+		container_of(kobj, struct xfs_error_cfg_kobj, kobj);
+
+	return &cfg_kobj->cfg;
 }
 
-static inline struct xfs_mount *
+static inline struct xfs_error_obj *
 err_to_mp(struct kobject *kobject)
 {
 	struct xfs_kobj *kobj = to_kobj(kobject);
-	return container_of(kobj, struct xfs_mount, m_error_kobj);
+	return container_of(kobj, struct xfs_error_obj, kobj);
 }
 
 static ssize_t
@@ -433,9 +436,9 @@ fail_at_unmount_show(
 	struct kobject	*kobject,
 	char		*buf)
 {
-	struct xfs_mount	*mp = err_to_mp(kobject);
+	struct xfs_error_obj *eobj = err_to_mp(kobject);
 
-	return snprintf(buf, PAGE_SIZE, "%d\n", mp->m_fail_unmount);
+	return snprintf(buf, PAGE_SIZE, "%d\n", eobj->fail_unmount);
 }
 
 static ssize_t
@@ -444,7 +447,7 @@ fail_at_unmount_store(
 	const char	*buf,
 	size_t		count)
 {
-	struct xfs_mount	*mp = err_to_mp(kobject);
+	struct xfs_error_obj *eobj = err_to_mp(kobject);
 	int		ret;
 	int		val;
 
@@ -455,7 +458,7 @@ fail_at_unmount_store(
 	if (val < 0 || val > 1)
 		return -EINVAL;
 
-	mp->m_fail_unmount = val;
+	eobj->fail_unmount = val;
 	return count;
 }
 XFS_SYSFS_ATTR_RW(fail_at_unmount);
@@ -511,30 +514,33 @@ static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
 
 static int
 xfs_error_sysfs_init_class(
-	struct xfs_mount	*mp,
+	struct xfs_error_obj	*eobj,
 	int			class,
 	const char		*parent_name,
-	struct xfs_kobj		*parent_kobj,
+	struct xfs_kobj	*parent_kobj,
 	const struct xfs_error_init init[])
 {
-	struct xfs_error_cfg	*cfg;
+	struct xfs_error_cfg_kobj *cfg_kobj;
 	int			error;
 	int			i;
 
 	ASSERT(class < XFS_ERR_CLASS_MAX);
 
 	error = xfs_sysfs_init(parent_kobj, &xfs_error_ktype,
-				&mp->m_error_kobj, parent_name);
+				&eobj->kobj, parent_name);
 	if (error)
 		return error;
 
 	for (i = 0; i < XFS_ERR_ERRNO_MAX; i++) {
-		cfg = &mp->m_error_cfg[class][i];
-		error = xfs_sysfs_init(&cfg->kobj, &xfs_error_cfg_ktype,
+		struct xfs_error_cfg *cfg;
+
+		cfg_kobj = &eobj->cfg_kobj[class][i];
+		error = xfs_sysfs_init(&cfg_kobj->kobj, &xfs_error_cfg_ktype,
 					parent_kobj, init[i].name);
 		if (error)
 			goto out_error;
 
+		cfg = &cfg_kobj->cfg;
 		cfg->max_retries = init[i].max_retries;
 		if (init[i].retry_timeout == XFS_ERR_RETRY_FOREVER)
 			cfg->retry_timeout = XFS_ERR_RETRY_FOREVER;
@@ -542,13 +548,14 @@ xfs_error_sysfs_init_class(
 			cfg->retry_timeout = msecs_to_jiffies(
 					init[i].retry_timeout * MSEC_PER_SEC);
 	}
+
 	return 0;
 
 out_error:
 	/* unwind the entries that succeeded */
 	for (i--; i >= 0; i--) {
-		cfg = &mp->m_error_cfg[class][i];
-		xfs_sysfs_del(&cfg->kobj);
+		cfg_kobj = &eobj->cfg_kobj[class][i];
+		xfs_sysfs_del(&cfg_kobj->kobj);
 	}
 	xfs_sysfs_del(parent_kobj);
 	return error;
@@ -556,25 +563,26 @@ xfs_error_sysfs_init_class(
 
 int
 xfs_error_sysfs_init(
-	struct xfs_mount	*mp)
+	struct xfs_error_obj	*eobj,
+	struct xfs_kobj	*parent,
+	const char	*name)
 {
 	int			error;
 
 	/* .../xfs/<dev>/error/ */
-	error = xfs_sysfs_init(&mp->m_error_kobj, &xfs_error_ktype,
-				&mp->m_kobj, "error");
+	error = xfs_sysfs_init(&eobj->kobj, &xfs_error_ktype,
+				parent, name);
 	if (error)
 		return error;
 
-	error = sysfs_create_file(&mp->m_error_kobj.kobject,
-				  ATTR_LIST(fail_at_unmount));
-
+	error = sysfs_create_file(&eobj->kobj.kobject,
+					ATTR_LIST(fail_at_unmount));
 	if (error)
 		goto out_error;
 
 	/* .../xfs/<dev>/error/metadata/ */
-	error = xfs_error_sysfs_init_class(mp, XFS_ERR_METADATA,
-				"metadata", &mp->m_error_meta_kobj,
+	error = xfs_error_sysfs_init_class(eobj, XFS_ERR_METADATA,
+				"metadata", &eobj->meta_kobj,
 				xfs_error_meta_init);
 	if (error)
 		goto out_error;
@@ -582,53 +590,54 @@ xfs_error_sysfs_init(
 	return 0;
 
 out_error:
-	xfs_sysfs_del(&mp->m_error_kobj);
+	xfs_sysfs_del(&eobj->kobj);
 	return error;
 }
 
 void
 xfs_error_sysfs_del(
-	struct xfs_mount	*mp)
+	struct xfs_error_obj	*eobj)
 {
-	struct xfs_error_cfg	*cfg;
+	struct xfs_kobj *kobj;
 	int			i, j;
 
 	for (i = 0; i < XFS_ERR_CLASS_MAX; i++) {
 		for (j = 0; j < XFS_ERR_ERRNO_MAX; j++) {
-			cfg = &mp->m_error_cfg[i][j];
-
-			xfs_sysfs_del(&cfg->kobj);
+			kobj = &eobj->cfg_kobj[i][j].kobj;
+			xfs_sysfs_del(kobj);
 		}
 	}
-	xfs_sysfs_del(&mp->m_error_meta_kobj);
-	xfs_sysfs_del(&mp->m_error_kobj);
+
+	xfs_sysfs_del(&eobj->meta_kobj);
+	xfs_sysfs_del(&eobj->kobj);
 }
 
-struct xfs_error_cfg *
+void
 xfs_error_get_cfg(
-	struct xfs_mount	*mp,
+	struct xfs_error_obj	*eobj,
 	int			error_class,
-	int			error)
+	int			error,
+	struct xfs_error_cfg	*cfg)
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
+	*cfg = eobj->cfg_kobj[error_class][idx].cfg;
 }
diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
index d046371..a0e4c17 100644
--- a/fs/xfs/xfs_sysfs.h
+++ b/fs/xfs/xfs_sysfs.h
@@ -24,6 +24,9 @@ extern struct kobj_type xfs_dbg_ktype;	/* debug */
 extern struct kobj_type xfs_log_ktype;	/* xlog */
 extern struct kobj_type xfs_stats_ktype;	/* stats */
 
+/* for the declarations of xfs_error_sysfs_init/del */
+struct xfs_error_obj;
+
 static inline struct xfs_kobj *
 to_kobj(struct kobject *kobject)
 {
@@ -58,7 +61,8 @@ xfs_sysfs_del(
 	wait_for_completion(&kobj->complete);
 }
 
-int	xfs_error_sysfs_init(struct xfs_mount *mp);
-void	xfs_error_sysfs_del(struct xfs_mount *mp);
+int xfs_error_sysfs_init(struct xfs_error_obj *eobj,
+		struct xfs_kobj *parent, const char *name);
+void xfs_error_sysfs_del(struct xfs_error_obj *eobj);
 
 #endif	/* __XFS_SYSFS_H__ */
-- 
2.5.0

