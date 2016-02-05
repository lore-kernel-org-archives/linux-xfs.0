Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8C1487CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 19:23:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2BEE6AC001
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 17:23:41 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Qn30dHkT66CvvwNT for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 17:23:38 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRV7T-0000Wp-1k
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 12:23:31 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRV7T-0005tF-0i
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 12:23:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/9] xfs: configurable error behaviour via sysfs
Date: Fri,  5 Feb 2016 12:23:19 +1100
Message-Id: <1454635407-22276-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1454635407-22276-1-git-send-email-david@fromorbit.com>
References: <1454635407-22276-1-git-send-email-david@fromorbit.com>
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
 fs/xfs/xfs_mount.c | 10 +++++++++-
 fs/xfs/xfs_mount.h | 27 ++++++++++++++++++++++++++
 fs/xfs/xfs_sysfs.c | 56 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_sysfs.h |  3 +++
 4 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 986290c..f6fb5e1 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -708,10 +708,15 @@ xfs_mountfs(
 	if (error)
 		goto out_remove_sysfs;
 
-	error = xfs_uuid_mount(mp);
+	error = xfs_error_sysfs_init(mp);
 	if (error)
 		goto out_del_stats;
 
+
+	error = xfs_uuid_mount(mp);
+	if (error)
+		goto out_remove_error_sysfs;
+
 	/*
 	 * Set the minimum read and write sizes
 	 */
@@ -986,6 +991,8 @@ xfs_mountfs(
 	xfs_da_unmount(mp);
  out_remove_uuid:
 	xfs_uuid_unmount(mp);
+ out_remove_error_sysfs:
+	xfs_error_sysfs_del(mp);
  out_del_stats:
 	xfs_sysfs_del(&mp->m_stats.xs_kobj);
  out_remove_sysfs:
@@ -1074,6 +1081,7 @@ xfs_unmountfs(
 #endif
 	xfs_free_perag(mp);
 
+	xfs_error_sysfs_del(mp);
 	xfs_sysfs_del(&mp->m_stats.xs_kobj);
 	xfs_sysfs_del(&mp->m_kobj);
 }
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index b570984..96c9658 100644
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
 	struct xstats		m_stats;	/* per-fs stats */
 
 	struct workqueue_struct *m_buf_workqueue;
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 641d625..7d81c1b 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -17,11 +17,15 @@
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
 #include "xfs_stats.h"
+#include "xfs_mount.h"
 
 struct xfs_sysfs_attr {
 	struct attribute attr;
@@ -304,3 +308,53 @@ struct kobj_type xfs_log_ktype = {
 	.sysfs_ops = &xfs_sysfs_ops,
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
+struct kobj_type xfs_error_cfg_ktype = {
+	.release = xfs_sysfs_release,
+	.sysfs_ops = &xfs_sysfs_ops,
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
index be692e5..d046371 100644
--- a/fs/xfs/xfs_sysfs.h
+++ b/fs/xfs/xfs_sysfs.h
@@ -58,4 +58,7 @@ xfs_sysfs_del(
 	wait_for_completion(&kobj->complete);
 }
 
+int	xfs_error_sysfs_init(struct xfs_mount *mp);
+void	xfs_error_sysfs_del(struct xfs_mount *mp);
+
 #endif	/* __XFS_SYSFS_H__ */
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
