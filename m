Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id D764D7FC6
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 06:09:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A6E99304051
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 04:09:02 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	ZLFHgQghCwjOQkIQ for <xfs@oss.sgi.com>;
	Wed, 05 Aug 2015 04:09:00 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZMwYt-0006H0-Mx
	for xfs@oss.sgi.com; Wed, 05 Aug 2015 21:08:43 +1000
Received: from dave by disappointment with local (Exim 4.86_RC4)
	(envelope-from <dave@disappointment.disaster>) id 1ZMwYt-0007nQ-MH
	for xfs@oss.sgi.com; Wed, 05 Aug 2015 21:08:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/10] xfs: configurable error behaviour via sysfs
Date: Wed,  5 Aug 2015 21:08:33 +1000
Message-Id: <1438772921-28715-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1438772921-28715-1-git-send-email-david@fromorbit.com>
References: <1438772921-28715-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

We need to be able to change the way XFS behaviours in error
conditions depending on the type of underlying storage. This is
necessary for handling non-traditional block devices with extended
error cases, such as thin provisioned devices that can return ENOSPC
as an IO error.

Introduce the basic sysfs infrastructure needed to define and
configure error behaviours. This is done to be generic enough to
extend to configuring behaviour in other error conditions, such as
ENOMEM, which also has different desired behaviours according to
machine configuration.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.c |  9 +++++-
 fs/xfs/xfs_mount.h | 27 +++++++++++++++++
 fs/xfs/xfs_sysfs.c | 86 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_sysfs.h |  3 ++
 4 files changed, 123 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index a094e47..4245b7f3 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -693,10 +693,14 @@ xfs_mountfs(
 	if (error)
 		goto out;
 
-	error = xfs_uuid_mount(mp);
+	error = xfs_error_sysfs_init(mp);
 	if (error)
 		goto out_remove_sysfs;
 
+	error = xfs_uuid_mount(mp);
+	if (error)
+		goto out_remove_error_sysfs;
+
 	/*
 	 * Set the minimum read and write sizes
 	 */
@@ -967,6 +971,8 @@ xfs_mountfs(
 	xfs_da_unmount(mp);
  out_remove_uuid:
 	xfs_uuid_unmount(mp);
+ out_remove_error_sysfs:
+	xfs_error_sysfs_del(mp);
  out_remove_sysfs:
 	xfs_sysfs_del(&mp->m_kobj);
  out:
@@ -1052,6 +1058,7 @@ xfs_unmountfs(
 #endif
 	xfs_free_perag(mp);
 
+	xfs_error_sysfs_del(mp);
 	xfs_sysfs_del(&mp->m_kobj);
 }
 
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7999e91..e51c63c 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -37,6 +37,31 @@ enum {
 	XFS_LOWSP_MAX,
 };
 
+/*
+ * Error Configuration
+ *
+ * Error classes define the subsystem the configuration belongs to.
+ * Error numbers define the errors that are configurable.
+ * Failure types describe when an error is considered fatal.
+ */
+enum {
+	XFS_ERR_CLASS_MAX,
+};
+enum {
+	XFS_ERR_ERRNO_MAX,
+};
+enum {
+	XFS_ERR_FAIL_DEFAULT,
+	XFS_ERR_FAIL_NEVER,
+	XFS_ERR_FAIL_SLOW,
+	XFS_ERR_FAIL_FAST,
+};
+
+struct xfs_error_cfg {
+	struct xfs_kobj	kobj;
+	int		fail_speed;
+};
+
 typedef struct xfs_mount {
 	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
@@ -127,6 +152,8 @@ typedef struct xfs_mount {
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
 	struct xfs_kobj		m_kobj;
+	struct xfs_kobj		m_error_kobj;
+	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
 
 	struct workqueue_struct *m_buf_workqueue;
 	struct workqueue_struct	*m_data_workqueue;
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index aa03670..017dcfb 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -17,10 +17,14 @@
  */
 
 #include "xfs.h"
-#include "xfs_sysfs.h"
+#include "xfs_shared.h"
+#include "xfs_format.h"
 #include "xfs_log_format.h"
+#include "xfs_trans_resv.h"
+#include "xfs_sysfs.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
+#include "xfs_mount.h"
 
 struct xfs_sysfs_attr {
 	struct attribute attr;
@@ -237,3 +241,83 @@ struct kobj_type xfs_log_ktype = {
 	.sysfs_ops = &xfs_log_ops,
 	.default_attrs = xfs_log_attrs,
 };
+
+/*
+ * Metadata IO error configuration
+ *
+ * The sysfs structure here is:
+ *	...xfs/<dev>/error/<class>/<errno>/<error_attrs>
+ *
+ * where <class> allows use to discriminate between data IO and metadata IO,
+ * and any other future type of IO (e.g. special inode or directory error
+ * handling) we care to support.
+ */
+static struct attribute *xfs_error_attrs[] = {
+	NULL,
+};
+
+static inline struct xfs_error_cfg *
+to_error_cfg(struct kobject *kobject)
+{
+	struct xfs_kobj *kobj = to_kobj(kobject);
+	return container_of(kobj, struct xfs_error_cfg, kobj);
+}
+
+static ssize_t
+xfs_error_show(
+	struct kobject		*kobject,
+	struct attribute	*attr,
+	char			*buf)
+{
+	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
+	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
+
+	return xfs_attr->show ? xfs_attr->show(buf, cfg) : 0;
+}
+
+static ssize_t
+xfs_error_store(
+	struct kobject		*kobject,
+	struct attribute	*attr,
+	const char		*buf,
+	size_t			count)
+{
+	struct xfs_error_cfg *cfg = to_error_cfg(kobject);
+	struct xfs_sysfs_attr *xfs_attr = to_attr(attr);
+
+	return xfs_attr->store ? xfs_attr->store(buf, count, cfg) : 0;
+}
+
+static struct sysfs_ops xfs_error_ops = {
+	.show = xfs_error_show,
+	.store = xfs_error_store,
+};
+
+struct kobj_type xfs_error_cfg_ktype = {
+	.release = xfs_sysfs_release,
+	.sysfs_ops = &xfs_error_ops,
+	.default_attrs = xfs_error_attrs,
+};
+
+struct kobj_type xfs_error_ktype = {
+	.release = xfs_sysfs_release,
+};
+
+int
+xfs_error_sysfs_init(
+	struct xfs_mount	*mp)
+{
+	int			error;
+
+	/* .../xfs/<dev>/error/ */
+	error = xfs_sysfs_init(&mp->m_error_kobj, &xfs_error_ktype,
+				&mp->m_kobj, "error");
+	return error;
+}
+
+void
+xfs_error_sysfs_del(
+	struct xfs_mount	*mp)
+{
+	xfs_sysfs_del(&mp->m_error_kobj);
+}
diff --git a/fs/xfs/xfs_sysfs.h b/fs/xfs/xfs_sysfs.h
index 240eee3..1f662d8 100644
--- a/fs/xfs/xfs_sysfs.h
+++ b/fs/xfs/xfs_sysfs.h
@@ -57,4 +57,7 @@ xfs_sysfs_del(
 	wait_for_completion(&kobj->complete);
 }
 
+int	xfs_error_sysfs_init(struct xfs_mount *mp);
+void	xfs_error_sysfs_del(struct xfs_mount *mp);
+
 #endif	/* __XFS_SYSFS_H__ */
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
