Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 557647CA4
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 19:23:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E7FC8AC004
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 17:23:37 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Umq6mFAGVuCqikVx for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 17:23:35 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRV7T-0000Ws-3K
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 12:23:31 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRV7T-0005tU-28
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 12:23:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/9] xfs: introduce table-based init for error behaviours
Date: Fri,  5 Feb 2016 12:23:22 +1100
Message-Id: <1454635407-22276-5-git-send-email-david@fromorbit.com>
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

Before we start expanding the number of error classes and errors we
can configure behaviour for, we need a simple and clear way to
define the default behaviour that we initialised each mount with.
Introduce a table based method for keeping the initial configuration
in, and apply that to the existing initialisation code.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_sysfs.c | 72 +++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 60 insertions(+), 12 deletions(-)

diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index b8a6804..27487ce 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -340,11 +340,67 @@ struct kobj_type xfs_error_ktype = {
 	.release = xfs_sysfs_release,
 };
 
+/*
+ * Error initialisation tables. These need to be ordered in the same
+ * order as the enums used to index the array. All class init tables need to
+ * define a "default" behaviour as the first entry, all other entries can be
+ * empty.
+ */
+struct xfs_error_init {
+	char		*name;
+	int		fail_speed;
+};
+
+static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
+	{ .name = "Default",
+	  .fail_speed = XFS_ERR_FAIL_NEVER,
+	},
+};
+
+static int
+xfs_error_sysfs_init_class(
+	struct xfs_mount	*mp,
+	int			class,
+	const char		*parent_name,
+	struct xfs_kobj		*parent_kobj,
+	const struct xfs_error_init init[])
+{
+	struct xfs_error_cfg	*cfg;
+	int			error;
+	int			i;
+
+	ASSERT(class < XFS_ERR_CLASS_MAX);
+
+	error = xfs_sysfs_init(parent_kobj, &xfs_error_ktype,
+				&mp->m_error_kobj, parent_name);
+	if (error)
+		return error;
+
+	for (i = 0; i < XFS_ERR_ERRNO_MAX; i++) {
+		cfg = &mp->m_error_cfg[class][i];
+		error = xfs_sysfs_init(&cfg->kobj, &xfs_error_cfg_ktype,
+					parent_kobj, init[i].name);
+		if (error)
+			goto out_error;
+
+		cfg->fail_speed = init[i].fail_speed;
+	}
+	return 0;
+
+out_error:
+	/* unwind the entries that succeeded */
+	for (i--; i >= 0; i--) {
+		cfg = &mp->m_error_cfg[class][i];
+		xfs_sysfs_del(&cfg->kobj);
+	}
+	xfs_sysfs_del(parent_kobj);
+	return error;
+}
+
 int
 xfs_error_sysfs_init(
 	struct xfs_mount	*mp)
 {
-	struct xfs_error_cfg	*cfg;
 	int			error;
 
 	/* .../xfs/<dev>/error/ */
@@ -354,22 +410,14 @@ xfs_error_sysfs_init(
 		return error;
 
 	/* .../xfs/<dev>/error/metadata/ */
-	error = xfs_sysfs_init(&mp->m_error_meta_kobj, &xfs_error_ktype,
-				&mp->m_error_kobj, "metadata");
+	error = xfs_error_sysfs_init_class(mp, XFS_ERR_METADATA,
+				"metadata", &mp->m_error_meta_kobj,
+				xfs_error_meta_init);
 	if (error)
 		goto out_error;
 
-	cfg = &mp->m_error_cfg[XFS_ERR_METADATA][XFS_ERR_DEFAULT];
-	error = xfs_sysfs_init(&cfg->kobj, &xfs_error_cfg_ktype,
-				&mp->m_error_meta_kobj, "Default");
-	if (error)
-		goto out_error_meta;
-	cfg->fail_speed = XFS_ERR_FAIL_NEVER;
-
 	return 0;
 
-out_error_meta:
-	xfs_sysfs_del(&mp->m_error_meta_kobj);
 out_error:
 	xfs_sysfs_del(&mp->m_error_kobj);
 	return error;
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
