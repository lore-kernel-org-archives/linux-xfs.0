Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 6D4497FC9
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 06:09:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2BA77304051
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 04:09:04 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	TC92udLk2DSkhz0i for <xfs@oss.sgi.com>;
	Wed, 05 Aug 2015 04:09:02 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZMwYt-0006H7-QC
	for xfs@oss.sgi.com; Wed, 05 Aug 2015 21:08:43 +1000
Received: from dave by disappointment with local (Exim 4.86_RC4)
	(envelope-from <dave@disappointment.disaster>) id 1ZMwYt-0007nz-Pb
	for xfs@oss.sgi.com; Wed, 05 Aug 2015 21:08:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 09/10] xfs: disable specific error configurations
Date: Wed,  5 Aug 2015 21:08:40 +1000
Message-Id: <1438772921-28715-10-git-send-email-david@fromorbit.com>
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

Different error classes are going to need different error to be
configured, so we don't want them all to be visible in sysfs. Add a
configuration check into the config initialisation an lookup
code to determine if the default should be used for a specific
error. If so, the sysfs entry is not created, and on lookup the
default config is returned.

Add ENOMEM at this point to exercise this code, as it will be used
later when adding a kmem error failure class.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.h |  1 +
 fs/xfs/xfs_sysfs.c | 22 ++++++++++++++++++----
 2 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 7d62450..876b86b 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -53,6 +53,7 @@ enum {
 	XFS_ERR_EIO,
 	XFS_ERR_ENOSPC,
 	XFS_ERR_ENODEV,
+	XFS_ERR_ENOMEM,
 	XFS_ERR_ERRNO_MAX,
 };
 enum {
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 019e859..fa46ca4 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -484,6 +484,9 @@ static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
 	{ .name = "ENODEV",
 	  .fail_speed = XFS_ERR_FAIL_FAST,
 	},
+	{ .name = "ENOMEM",
+	  .fail_speed = XFS_ERR_FAIL_DEFAULT,
+	},
 };
 
 static int
@@ -507,12 +510,17 @@ xfs_error_sysfs_init_class(
 
 	for (i = 0; i < XFS_ERR_ERRNO_MAX; i++) {
 		cfg = &mp->m_error_cfg[class][i];
+
+		/* skip errors that are not configurable for this class */
+		cfg->fail_speed = init[i].fail_speed;
+		if (cfg->fail_speed == XFS_ERR_FAIL_DEFAULT)
+			continue;
+
 		error = xfs_sysfs_init(&cfg->kobj, &xfs_error_cfg_ktype,
 					parent_kobj, init[i].name);
 		if (error)
 			goto out_error;
 
-		cfg->fail_speed = init[i].fail_speed;
 		cfg->max_retries = init[i].max_retries;
 		cfg->retry_timeout = msecs_to_jiffies(
 					init[i].retry_timeout * MSEC_PER_SEC);
@@ -567,7 +575,8 @@ xfs_error_sysfs_del(
 		for (j = 0; j < XFS_ERR_ERRNO_MAX; j++) {
 			cfg = &mp->m_error_cfg[i][j];
 
-			xfs_sysfs_del(&cfg->kobj);
+			if (cfg->fail_speed != XFS_ERR_FAIL_DEFAULT)
+				xfs_sysfs_del(&cfg->kobj);
 		}
 	}
 	xfs_sysfs_del(&mp->m_error_meta_kobj);
@@ -592,10 +601,15 @@ xfs_error_get_cfg(
 	case ENODEV:
 		cfg = &mp->m_error_cfg[error_class][XFS_ERR_ENODEV];
 		break;
-	default:
-		cfg = &mp->m_error_cfg[error_class][XFS_ERR_DEFAULT];
+	case ENOMEM:
+		cfg = &mp->m_error_cfg[error_class][XFS_ERR_ENOMEM];
 		break;
+	default:
+		return &mp->m_error_cfg[error_class][XFS_ERR_DEFAULT];
 	}
 
+	/* The error may not be not configurable, so uses default behaviour */
+	if (cfg->fail_speed == XFS_ERR_FAIL_DEFAULT)
+		return &mp->m_error_cfg[error_class][XFS_ERR_DEFAULT];
 	return cfg;
 }
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
