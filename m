Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4524 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752234AbdHULth (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Aug 2017 07:49:37 -0400
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH RFC 3/3] xfs: make the default values of error configuration customizable and workable
Date: Mon, 21 Aug 2017 19:54:22 +0800
Message-ID: <1503316462-16553-4-git-send-email-houtao1@huawei.com>
In-Reply-To: <1503316462-16553-1-git-send-email-houtao1@huawei.com>
References: <1503316462-16553-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: darrick.wong@oracle.com, cmaiolino@redhat.com

Merge the error initialization table into the error configurations of the
default error object, and assign the error configurations to mount point
specific error object when initializing the sysfs tree of mount point.

When any default value is being modified and the value of mount point
specific configuration is same with the old default value, the value of
mount point specific configuration will be updated and synced with
the new default value.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 fs/xfs/xfs_mount.c |   3 -
 fs/xfs/xfs_mount.h |   3 +
 fs/xfs/xfs_sysfs.c | 185 ++++++++++++++++++++++++++++++++++++++---------------
 3 files changed, 137 insertions(+), 54 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index d67b5b6..3a6d2e0 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -703,9 +703,6 @@ xfs_mountfs(
 
 	xfs_set_maxicount(mp);
 
-	/* enable fail_at_unmount as default */
-	mp->m_eobj.fail_unmount = 1;
-
 	error = xfs_sysfs_init(&mp->m_kobj, &xfs_mp_ktype, NULL, mp->m_fsname);
 	if (error)
 		goto out;
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index a655821..bd22064 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -81,6 +81,7 @@ struct xfs_dft_error_cfg_kobj {
 };
 
 struct xfs_mp_error_obj {
+	struct list_head node;
 	struct xfs_kobj kobj;
 	struct xfs_kobj meta_kobj;
 	struct xfs_mp_error_cfg_kobj cfg_kobj[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
@@ -88,6 +89,8 @@ struct xfs_mp_error_obj {
 };
 
 struct xfs_dft_error_obj {
+	struct mutex lock;
+	struct list_head head;
 	struct xfs_kobj kobj;
 	struct xfs_kobj meta_kobj;
 	struct xfs_dft_error_cfg_kobj cfg_kobj[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 9270cb1..51b6a48 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -45,6 +45,10 @@ struct xfs_sysfs_attr {
 			 size_t count);
 };
 
+static const char *xfs_error_meta_name[XFS_ERR_ERRNO_MAX] = {
+	"default", "EIO", "ENOSPC", "ENODEV",
+};
+
 static struct xfs_dft_error_obj xfs_dft_eobj;
 
 static inline struct xfs_sysfs_attr *
@@ -457,8 +461,35 @@ dft_max_retries_store(
 {
 	struct xfs_dft_error_cfg_kobj *cfg_kobj =
 	    to_dft_error_cfg_kobj(kobject);
+	struct xfs_error_cfg *cfg = &cfg_kobj->cfg;
+	int old_val;
+	int ret;
+	struct xfs_dft_error_obj *eobj;
+	struct xfs_mp_error_obj *mp_eobj;
+	int cls;
+	int nr;
+
+	old_val = cfg->max_retries;
+	ret = __max_retries_store(cfg, buf, count);
+	if (ret < 0)
+		return ret;
 
-	return __max_retries_store(&cfg_kobj->cfg, buf, count);
+	eobj = &xfs_dft_eobj;
+	cls = cfg_kobj->error_class;
+	nr = cfg_kobj->error_nr;
+	ASSERT(cls >= 0 && cls < XFS_ERR_CLASS_MAX);
+	ASSERT(nr >= 0 && nr < XFS_ERR_ERRNO_MAX);
+
+	mutex_lock(&eobj->lock);
+	list_for_each_entry(mp_eobj, &eobj->head, node) {
+		struct xfs_error_cfg *mp_cfg = &mp_eobj->cfg_kobj[cls][nr].cfg;
+
+		if (mp_cfg->max_retries == old_val)
+			mp_cfg->max_retries = cfg->max_retries;
+	}
+	mutex_unlock(&eobj->lock);
+
+	return ret;
 }
 XFS_SYSFS_DFT_ATTR_RW(max_retries);
 
@@ -544,8 +575,35 @@ dft_retry_timeout_seconds_store(
 {
 	struct xfs_dft_error_cfg_kobj *cfg_kobj =
 	    to_dft_error_cfg_kobj(kobject);
+	struct xfs_error_cfg *cfg = &cfg_kobj->cfg;
+	int old_val;
+	int ret;
+	struct xfs_dft_error_obj *eobj;
+	struct xfs_mp_error_obj *mp_eobj;
+	int cls;
+	int nr;
+
+	old_val = cfg->retry_timeout;
+	ret = __retry_timeout_seconds_store(cfg, buf, count);
+	if (ret < 0)
+		return ret;
 
-	return __retry_timeout_seconds_store(&cfg_kobj->cfg, buf, count);
+	eobj = &xfs_dft_eobj;
+	cls = cfg_kobj->error_class;
+	nr = cfg_kobj->error_nr;
+	ASSERT(cls >= 0 && cls < XFS_ERR_CLASS_MAX);
+	ASSERT(nr >= 0 && nr < XFS_ERR_ERRNO_MAX);
+
+	mutex_lock(&eobj->lock);
+	list_for_each_entry(mp_eobj, &eobj->head, node) {
+		struct xfs_error_cfg *mp_cfg = &mp_eobj->cfg_kobj[cls][nr].cfg;
+
+		if (mp_cfg->retry_timeout == old_val)
+			mp_cfg->retry_timeout = cfg->retry_timeout;
+	}
+	mutex_unlock(&eobj->lock);
+
+	return ret;
 }
 XFS_SYSFS_DFT_ATTR_RW(retry_timeout_seconds);
 
@@ -616,8 +674,23 @@ dft_fail_at_unmount_store(
 	size_t		count)
 {
 	struct xfs_dft_error_obj *eobj = to_dft_error_obj(kobject);
+	struct xfs_mp_error_obj *mp_eobj;
+	bool old_val;
+	int ret;
 
-	return __fail_at_unmount_store(&eobj->fail_unmount, buf, count);
+	old_val = eobj->fail_unmount;
+	ret = __fail_at_unmount_store(&eobj->fail_unmount, buf, count);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&eobj->lock);
+	list_for_each_entry(mp_eobj, &eobj->head, node) {
+		if (mp_eobj->fail_unmount == old_val)
+			mp_eobj->fail_unmount = eobj->fail_unmount;
+	}
+	mutex_unlock(&eobj->lock);
+
+	return ret;
 }
 XFS_SYSFS_DFT_ATTR_RW(fail_at_unmount);
 
@@ -650,43 +723,12 @@ static struct kobj_type xfs_error_ktype = {
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
 	struct xfs_error_sysfs_arg *arg,
 	int			class,
 	const char		*parent_name,
-	const struct xfs_error_init init[])
+	const char		**names)
 {
 	int			error;
 	int			i;
@@ -702,7 +744,7 @@ xfs_error_sysfs_init_class(
 		struct xfs_kobj *kobj = arg->get_cfg_kobj(arg->priv, class, i);
 
 		error = xfs_sysfs_init(kobj, arg->cfg_ktype,
-					arg->meta_kobj, init[i].name);
+					arg->meta_kobj, names[i]);
 		if (error)
 			goto out_error;
 	}
@@ -737,7 +779,7 @@ __xfs_error_sysfs_init(
 
 	/* .../xfs/error/metadata/ or .../xfs/<dev>/error/metadata/ */
 	error = xfs_error_sysfs_init_class(arg, XFS_ERR_METADATA,
-				"metadata", xfs_error_meta_init);
+				"metadata", xfs_error_meta_name);
 	if (error)
 		goto out_error;
 
@@ -776,24 +818,36 @@ xfs_get_mp_error_cfg_kobj(
 }
 
 static void
-xfs_error_mp_cfg_init(
+xfs_error_dft_cfg_detach(
 	struct xfs_mp_error_obj *eobj,
-	int class,
-	const struct xfs_error_init *init)
+	struct xfs_dft_error_obj *dft_eobj)
+{
+	mutex_lock(&dft_eobj->lock);
+	list_del_init(&eobj->node);
+	mutex_unlock(&dft_eobj->lock);
+}
+
+static void
+xfs_error_dft_cfg_attach(
+	struct xfs_mp_error_obj *eobj,
+	struct xfs_dft_error_obj *dft_eobj)
 {
 	int i;
-	struct xfs_error_cfg *cfg;
 
+	/*
+	 * When the default error cfg is being modified, to ensure
+	 * the final default error cfg will be propagated to the
+	 * mount point specific error cfg, the lock needs to protect
+	 * the initialization of mount point specific error cfg as well.
+	 */
+	mutex_lock(&dft_eobj->lock);
+	eobj->fail_unmount = dft_eobj->fail_unmount;
 	for (i = 0; i < XFS_ERR_ERRNO_MAX; i++) {
-		cfg = &eobj->cfg_kobj[class][i].cfg;
-
-		cfg->max_retries = init[i].max_retries;
-		if (init[i].retry_timeout == XFS_ERR_RETRY_FOREVER)
-			cfg->retry_timeout = XFS_ERR_RETRY_FOREVER;
-		else
-			cfg->retry_timeout = msecs_to_jiffies(
-					init[i].retry_timeout * MSEC_PER_SEC);
+		eobj->cfg_kobj[XFS_ERR_METADATA][i].cfg =
+			dft_eobj->cfg_kobj[XFS_ERR_METADATA][i].cfg;
 	}
+	list_add_tail(&eobj->node, &dft_eobj->head);
+	mutex_unlock(&dft_eobj->lock);
 }
 
 int
@@ -804,7 +858,7 @@ xfs_error_sysfs_init(
 	int error;
 	struct xfs_error_sysfs_arg arg;
 
-	xfs_error_mp_cfg_init(eobj, XFS_ERR_METADATA, xfs_error_meta_init);
+	xfs_error_dft_cfg_attach(eobj, &xfs_dft_eobj);
 
 	arg.kobj = &eobj->kobj;
 	arg.meta_kobj = &eobj->meta_kobj;
@@ -813,8 +867,10 @@ xfs_error_sysfs_init(
 	arg.get_cfg_kobj = xfs_get_mp_error_cfg_kobj;
 	arg.priv = eobj;
 	error = __xfs_error_sysfs_init(&arg, "error", parent);
-	if (error)
+	if (error) {
+		xfs_error_dft_cfg_detach(eobj, &xfs_dft_eobj);
 		return error;
+	}
 
 	return 0;
 }
@@ -825,6 +881,8 @@ xfs_error_sysfs_del(
 {
 	struct xfs_error_sysfs_arg arg;
 
+	xfs_error_dft_cfg_detach(eobj, &xfs_dft_eobj);
+
 	arg.kobj = &eobj->kobj;
 	arg.meta_kobj = &eobj->meta_kobj;
 	arg.fail_unmount_attr = NULL;
@@ -875,15 +933,40 @@ xfs_get_dft_error_cfg_kobj(
 	return &eobj->cfg_kobj[class][nr].kobj;
 }
 
+static void
+xfs_dft_error_cfg_init(
+	int class,
+	struct xfs_dft_error_cfg_kobj *tbl)
+{
+	int i;
+
+	for (i = 0; i < XFS_ERR_ERRNO_MAX; i++) {
+		tbl[i].cfg.max_retries = XFS_ERR_RETRY_FOREVER;
+		tbl[i].cfg.retry_timeout = XFS_ERR_RETRY_FOREVER;
+		tbl[i].error_class = class;
+		tbl[i].error_nr = i;
+	}
+
+	/* We can't recover from devices disappearing */
+	tbl[XFS_ERR_ENODEV].cfg.max_retries = 0;
+	tbl[XFS_ERR_ENODEV].cfg.retry_timeout = 0;
+}
+
 int
 xfs_dft_error_sysfs_init(struct kset *kset)
 {
 	struct xfs_dft_error_obj *eobj = &xfs_dft_eobj;
 	struct xfs_error_sysfs_arg arg;
 
+	mutex_init(&eobj->lock);
+	INIT_LIST_HEAD(&eobj->head);
+
 	eobj->kobj.kobject.kset = kset;
 
+	/* enable fail_at_unmount as default */
 	eobj->fail_unmount = 1;
+	xfs_dft_error_cfg_init(XFS_ERR_METADATA,
+			eobj->cfg_kobj[XFS_ERR_METADATA]);
 
 	arg.kobj = &eobj->kobj;
 	arg.meta_kobj = &eobj->meta_kobj;
-- 
2.5.0

