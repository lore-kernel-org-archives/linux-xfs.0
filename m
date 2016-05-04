Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8E3D17CA4
	for <xfs@oss.sgi.com>; Wed,  4 May 2016 10:43:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5D4CA8F8039
	for <xfs@oss.sgi.com>; Wed,  4 May 2016 08:43:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id NXukjNvWnCTeOwVt (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 04 May 2016 08:43:29 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id DFF8E218F
	for <xfs@oss.sgi.com>; Wed,  4 May 2016 15:43:28 +0000 (UTC)
Received: from zion.usersys.redhat.com (unused [10.10.50.11] (may be forged))
	by int-mx10.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with
	ESMTP id u44FhPoG012561
	for <xfs@oss.sgi.com>; Wed, 4 May 2016 11:43:28 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 2/7] xfs: introduce metadata IO error class
Date: Wed,  4 May 2016 17:43:15 +0200
Message-Id: <1462376600-8617-3-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1462376600-8617-1-git-send-email-cmaiolino@redhat.com>
References: <1462376600-8617-1-git-send-email-cmaiolino@redhat.com>
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

Now we have the basic infrastructure, add the first error class so
we can build up the infrastructure in a meaningful way. Add the
metadata async write IO error class and sysfs entry, and introduce a
default configuration that matches the existing "retry forever" behavior
for async write metadata buffers.

Changelog:

V3:
	- Use 'cfg->max_retries = -1' as the default configuration for the
	  "retry forever" behavior, instead of
	  cfg->fail_speed = XFS_ERR_FAIL_NEVER

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_mount.h |  3 +++
 fs/xfs/xfs_sysfs.c | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index d639795..352a5c8 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -44,9 +44,11 @@ enum {
  * Error numbers define the errors that are configurable.
  */
 enum {
+	XFS_ERR_METADATA,
 	XFS_ERR_CLASS_MAX,
 };
 enum {
+	XFS_ERR_DEFAULT,
 	XFS_ERR_ERRNO_MAX,
 };
 
@@ -146,6 +148,7 @@ typedef struct xfs_mount {
 						/* low free space thresholds */
 	struct xfs_kobj		m_kobj;
 	struct xfs_kobj		m_error_kobj;
+	struct xfs_kobj		m_error_meta_kobj;
 	struct xfs_error_cfg	m_error_cfg[XFS_ERR_CLASS_MAX][XFS_ERR_ERRNO_MAX];
 	struct xstats		m_stats;	/* per-fs stats */
 
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index b971113..7180cff 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -399,11 +399,34 @@ int
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
+				&mp->m_error_meta_kobj, "default");
+	if (error)
+		goto out_error_meta;
+	cfg->max_retries = -1;
+
+	return 0;
+
+out_error_meta:
+	xfs_sysfs_del(&mp->m_error_meta_kobj);
+out_error:
+	xfs_sysfs_del(&mp->m_error_kobj);
 	return error;
 }
 
@@ -411,5 +434,16 @@ void
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
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
