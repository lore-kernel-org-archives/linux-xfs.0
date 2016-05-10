Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 728AC7CA4
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 07:16:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25B1C304048
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 05:16:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id TOGdIh6oh85qofLo (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 May 2016 05:16:26 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 5BC23C01FBB1
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 12:16:26 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4ACGOuh016940
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 08:16:25 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 1/7] xfs: configurable error behavior via sysfs
Date: Tue, 10 May 2016 14:16:15 +0200
Message-Id: <1462882581-30859-2-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1462882581-30859-1-git-send-email-cmaiolino@redhat.com>
References: <1462882581-30859-1-git-send-email-cmaiolino@redhat.com>
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

Changelog:

V3:
	- Rebase patch on top of linux-xfs tree
	- Remove XFS_ERR_FAIL enums, once we are not using them
	  to control the fail speed, but base it on max_retries value
	- Get rid of xfs_error_cfg.fail_speed field. We will use only
	  .max_retries to control the failure speed for each error

V4:
	- Fix typo error in xfs_sysfs.c

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_mount.c | 10 +++++++++-
 fs/xfs/xfs_mount.h | 20 ++++++++++++++++++++
 fs/xfs/xfs_sysfs.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/xfs/xfs_sysfs.h |  3 +++
 4 files changed, 84 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 654799f..eda3906 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -689,10 +689,15 @@ xfs_mountfs(
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
@@ -967,6 +972,8 @@ xfs_mountfs(
 	xfs_da_unmount(mp);
  out_remove_uuid:
 	xfs_uuid_unmount(mp);
+ out_remove_error_sysfs:
+	xfs_error_sysfs_del(mp);
  out_del_stats:
 	xfs_sysfs_del(&mp->m_stats.xs_kobj);
  out_remove_sysfs:
@@ -1055,6 +1062,7 @@ xfs_unmountfs(
 #endif
 	xfs_free_perag(mp);
 
+	xfs_error_sysfs_del(mp);
 	xfs_sysfs_del(&mp->m_stats.xs_kobj);
 	xfs_sysfs_del(&mp->m_kobj);
 }
diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index bac6b34..d639795 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -37,6 +37,24 @@ enum {
 	XFS_LOWSP_MAX,
 };
 
+/*
+ * Error Configuration
+ *
+ * Error classes define the subsystem the configuration belongs to.
+ * Error numbers define the errors that are configurable.
+ */
+enum {
+	XFS_ERR_CLASS_MAX,
+};
+enum {
+	XFS_ERR_ERRNO_MAX,
+};
+
+struct xfs_error_cfg {
+	struct xfs_kobj	kobj;
+	int		max_retries;
+};
+
 typedef struct xfs_mount {
 	struct super_block	*m_super;
 	xfs_tid_t		m_tid;		/* next unused tid for fs */
@@ -127,6 +145,8 @@ typedef struct xfs_mount {
 	int64_t			m_low_space[XFS_LOWSP_MAX];
 						/* low free space thresholds */
 	struct xfs_kobj		m_kobj;
+	struct xfs_kobj		m_error_kobj;
+	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
 	struct xstats		m_stats;	/* per-fs stats */
 
 	struct workqueue_struct *m_buf_workqueue;
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 6ced4f1..74e3940 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -17,10 +17,11 @@
  */
 
 #include "xfs.h"
-#include "xfs_sysfs.h"
+#include "xfs_shared.h"
 #include "xfs_format.h"
 #include "xfs_log_format.h"
 #include "xfs_trans_resv.h"
+#include "xfs_sysfs.h"
 #include "xfs_log.h"
 #include "xfs_log_priv.h"
 #include "xfs_stats.h"
@@ -362,3 +363,53 @@ struct kobj_type xfs_log_ktype = {
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
+ * where <class> allows us to discriminate between data IO and metadata IO,
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
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
