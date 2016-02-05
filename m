Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3F3447CA3
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 19:23:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0BADD8F8040
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 17:23:40 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	tiQjRoHeOeTuc1lE for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 17:23:37 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRV7T-0000Wx-5M
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 12:23:31 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRV7T-0005tt-4X
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 12:23:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 9/9] xfs: add kmem error configuration class
Date: Fri,  5 Feb 2016 12:23:27 +1100
Message-Id: <1454635407-22276-10-git-send-email-david@fromorbit.com>
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

Add a new error configuration class for defining how memory
allocation failures are supposed to be handled, This requires
factoring the initialisation/teardown code to be able to handle
a generic error class object.

I'm not yet sure how to hook it into the memory allocation calls -
that will be done in a later patch; this just demonstrates how
multiple classes are configured and initialised. It may be that we
don't configure specific errors here - instead configure how we
handle specific types of allocation failure e.g. GFP_KERNEL vs
GFP_NOFS vs allocations inside transactions. Either way, we are
going to need to plumb the error config handler into the
memory allocation code in some manner.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.h |  3 ++-
 fs/xfs/xfs_sysfs.c | 77 +++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 61 insertions(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 0ff14a90..62bcdcb 100644
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
 	struct xstats		m_stats;	/* per-fs stats */
 
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index c984c3e..c3dff95 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -522,26 +522,50 @@ static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
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
@@ -554,8 +578,9 @@ xfs_error_sysfs_init_class(
 		if (cfg->fail_speed == XFS_ERR_FAIL_DEFAULT)
 			continue;
 
+		ASSERT(init[i].name);
 		error = xfs_sysfs_init(&cfg->kobj, &xfs_error_cfg_ktype,
-					parent_kobj, init[i].name);
+					class_kobj, init[i].name);
 		if (error)
 			goto out_error;
 
@@ -572,10 +597,28 @@ out_error:
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
@@ -589,14 +632,19 @@ xfs_error_sysfs_init(
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
@@ -606,18 +654,11 @@ void
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
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
