Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 77F777CB2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 19:23:41 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3C4BF304066
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 17:23:41 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	wGeq1t6boHko3rFk for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 17:23:38 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRV7T-0000Wq-26
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 12:23:31 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRV7T-0005tK-1J
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 12:23:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 2/9] xfs: introduce metadata IO error class
Date: Fri,  5 Feb 2016 12:23:20 +1100
Message-Id: <1454635407-22276-3-git-send-email-david@fromorbit.com>
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

Now we have the basic infrastructure, add the first error class so
we can build up the infrastructure in a meaningful way. Add the
metadata async write IO error class and sysfs entry, and introduce a
default configuration that matches the existing behaviour of
XFS_ERR_FAIL_NEVER for async write metadata buffers.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.h |  3 +++
 fs/xfs/xfs_sysfs.c | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 96c9658..36e7330 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -45,9 +45,11 @@ enum {
  * Failure types describe when an error is considered fatal.
  */
 enum {
+	XFS_ERR_METADATA,
 	XFS_ERR_CLASS_MAX,
 };
 enum {
+	XFS_ERR_DEFAULT,
 	XFS_ERR_ERRNO_MAX,
 };
 enum {
@@ -153,6 +155,7 @@ typedef struct xfs_mount {
 						/* low free space thresholds */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
+	struct xfs_kobj		m_error_meta_kobj;
 	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
 	struct xstats		m_stats;	/* per-fs stats */
 
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 7d81c1b..c5f0afa 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -344,11 +344,34 @@ int
 xfs_error_sysfs_init(
 	struct xfs_mount	*mp)
 {
+	struct xfs_error_cfg	*cfg;
 	int			error;
 
 	/* .../xfs/<dev>/error/ */
 	error = xfs_sysfs_init(&mp->m_error_kobj, &xfs_error_ktype,
 				&mp->m_kobj, "error");
+	if (error)
+		return error;
+
+	/* .../xfs/<dev>/error/metadata/ */
+	error = xfs_sysfs_init(&mp->m_error_meta_kobj, &xfs_error_ktype,
+				&mp->m_error_kobj, "metadata");
+	if (error)
+		goto out_error;
+
+	cfg = &mp->m_error_cfg[XFS_ERR_METADATA][XFS_ERR_DEFAULT];
+	error = xfs_sysfs_init(&cfg->kobj, &xfs_error_cfg_ktype,
+				&mp->m_error_meta_kobj, "Default");
+	if (error)
+		goto out_error_meta;
+	cfg->fail_speed = XFS_ERR_FAIL_NEVER;
+
+	return 0;
+
+out_error_meta:
+	xfs_sysfs_del(&mp->m_error_meta_kobj);
+out_error:
+	xfs_sysfs_del(&mp->m_error_kobj);
 	return error;
 }
 
@@ -356,5 +379,16 @@ void
 xfs_error_sysfs_del(
 	struct xfs_mount	*mp)
 {
+	struct xfs_error_cfg	*cfg;
+	int			i, j;
+
+	for (i = 0; i < XFS_ERR_CLASS_MAX; i++) {
+		for (j = 0; j < XFS_ERR_ERRNO_MAX; j++) {
+			cfg = &mp->m_error_cfg[i][j];
+
+			xfs_sysfs_del(&cfg->kobj);
+		}
+	}
+	xfs_sysfs_del(&mp->m_error_meta_kobj);
 	xfs_sysfs_del(&mp->m_error_kobj);
 }
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
