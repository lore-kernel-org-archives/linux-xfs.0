Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3C6877FDB
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 06:09:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 099E4304051
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 04:09:05 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	7Zwjt3XySEtEyqWB for <xfs@oss.sgi.com>;
	Wed, 05 Aug 2015 04:09:04 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZMwYt-0006H8-QZ
	for xfs@oss.sgi.com; Wed, 05 Aug 2015 21:08:43 +1000
Received: from dave by disappointment with local (Exim 4.86_RC4)
	(envelope-from <dave@disappointment.disaster>) id 1ZMwYt-0007o4-Pt
	for xfs@oss.sgi.com; Wed, 05 Aug 2015 21:08:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 10/10] xfs: add kmem error configuration class
Date: Wed,  5 Aug 2015 21:08:41 +1000
Message-Id: <1438772921-28715-11-git-send-email-david@fromorbit.com>
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

For configuring how to handle memory allocation failures. I'm not
yet sure how to hook it into the memory allocation calls - that will
be done in a later patch; this just demonstrates how multiple
classes are configured and initialised.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.h |  3 ++-
 fs/xfs/xfs_sysfs.c | 77 +++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 61 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 876b86b..03162cd 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -46,6 +46,7 @@ enum {
  */
 enum {
 	XFS_ERR_METADATA,
+	XFS_ERR_KMEM,
 	XFS_ERR_CLASS_MAX,
 };
 enum {
@@ -162,7 +163,7 @@ typedef struct xfs_mount {
 						/* low free space thresholds */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
-	struct xfs_kobj		m_error_meta_kobj;
+	struct xfs_kobj		m_error_class_kobj[XFS_ERR_CLASS_MAX];
 	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
 
 	struct workqueue_struct *m_buf_workqueue;
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index fa46ca4..cbbc36a 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -484,26 +484,50 @@ static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
 	{ .name = "ENODEV",
 	  .fail_speed = XFS_ERR_FAIL_FAST,
 	},
-	{ .name = "ENOMEM",
+	{ /* ENOMEM */
 	  .fail_speed = XFS_ERR_FAIL_DEFAULT,
 	},
 };
 
+static const struct xfs_error_init xfs_error_kmem_init[XFS_ERR_ERRNO_MAX] = {
+	{ .name = "Default",
+	  .fail_speed = XFS_ERR_FAIL_NEVER,
+	  .max_retries = INT_MAX,
+	  .retry_timeout = 0,
+	  .fail_at_unmount = false,
+	},
+	{ /* EIO */
+	  .fail_speed = XFS_ERR_FAIL_DEFAULT,
+	},
+	{ /* ENOSPC */
+	  .fail_speed = XFS_ERR_FAIL_DEFAULT,
+	},
+	{ /* ENODEV */
+	  .fail_speed = XFS_ERR_FAIL_DEFAULT,
+	},
+	{ .name = "ENOMEM",
+	  .fail_speed = XFS_ERR_FAIL_NEVER,
+	  .max_retries = INT_MAX,
+	  .retry_timeout = 0,
+	  .fail_at_unmount = false,
+	},
+};
+
 static int
 xfs_error_sysfs_init_class(
 	struct xfs_mount	*mp,
 	int			class,
 	const char		*parent_name,
-	struct xfs_kobj		*parent_kobj,
 	const struct xfs_error_init init[])
 {
+	struct xfs_kobj		*class_kobj = &mp->m_error_class_kobj[class];
 	struct xfs_error_cfg	*cfg;
 	int			error;
 	int			i;
 
 	ASSERT(class < XFS_ERR_CLASS_MAX);
 
-	error = xfs_sysfs_init(parent_kobj, &xfs_error_ktype,
+	error = xfs_sysfs_init(class_kobj, &xfs_error_ktype,
 				&mp->m_error_kobj, parent_name);
 	if (error)
 		return error;
@@ -516,8 +540,9 @@ xfs_error_sysfs_init_class(
 		if (cfg->fail_speed == XFS_ERR_FAIL_DEFAULT)
 			continue;
 
+		ASSERT(init[i].name);
 		error = xfs_sysfs_init(&cfg->kobj, &xfs_error_cfg_ktype,
-					parent_kobj, init[i].name);
+					class_kobj, init[i].name);
 		if (error)
 			goto out_error;
 
@@ -534,10 +559,28 @@ out_error:
 		cfg = &mp->m_error_cfg[class][i];
 		xfs_sysfs_del(&cfg->kobj);
 	}
-	xfs_sysfs_del(parent_kobj);
+	xfs_sysfs_del(class_kobj);
 	return error;
 }
 
+static void
+xfs_error_sysfs_del_class(
+	struct xfs_mount	*mp,
+	int			class)
+{
+	struct xfs_error_cfg	*cfg;
+	int			i;
+
+	for (i = 0; i < XFS_ERR_ERRNO_MAX; i++) {
+		cfg = &mp->m_error_cfg[class][i];
+
+		if (cfg->fail_speed != XFS_ERR_FAIL_DEFAULT)
+			xfs_sysfs_del(&cfg->kobj);
+	}
+
+	xfs_sysfs_del(&mp->m_error_class_kobj[class]);
+}
+
 int
 xfs_error_sysfs_init(
 	struct xfs_mount	*mp)
@@ -551,14 +594,19 @@ xfs_error_sysfs_init(
 		return error;
 
 	/* .../xfs/<dev>/error/metadata/ */
-	error = xfs_error_sysfs_init_class(mp, XFS_ERR_METADATA,
-				"metadata", &mp->m_error_meta_kobj,
-				xfs_error_meta_init);
+	error = xfs_error_sysfs_init_class(mp, XFS_ERR_METADATA, "metadata",
+					   xfs_error_meta_init);
 	if (error)
 		goto out_error;
 
+	error = xfs_error_sysfs_init_class(mp, XFS_ERR_KMEM, "kmem",
+					   xfs_error_kmem_init);
+	if (error)
+		goto out_error_meta;
 	return 0;
 
+out_error_meta:
+	xfs_error_sysfs_del_class(mp, XFS_ERR_METADATA);
 out_error:
 	xfs_sysfs_del(&mp->m_error_kobj);
 	return error;
@@ -568,18 +616,11 @@ void
 xfs_error_sysfs_del(
 	struct xfs_mount	*mp)
 {
-	struct xfs_error_cfg	*cfg;
-	int			i, j;
+	int			i;
 
-	for (i = 0; i < XFS_ERR_CLASS_MAX; i++) {
-		for (j = 0; j < XFS_ERR_ERRNO_MAX; j++) {
-			cfg = &mp->m_error_cfg[i][j];
+	for (i = 0; i < XFS_ERR_CLASS_MAX; i++)
+		xfs_error_sysfs_del_class(mp, i);
 
-			if (cfg->fail_speed != XFS_ERR_FAIL_DEFAULT)
-				xfs_sysfs_del(&cfg->kobj);
-		}
-	}
-	xfs_sysfs_del(&mp->m_error_meta_kobj);
 	xfs_sysfs_del(&mp->m_error_kobj);
 }
 
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
