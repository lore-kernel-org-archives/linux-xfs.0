Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3B5EB7CA4
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 12:55:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E8C9D8F8037
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 10:55:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id BCuNxSFXLRAFw9zC (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 May 2016 10:55:47 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 4101F497
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 17:55:47 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u43HtiDR016424
	for <xfs@oss.sgi.com>; Tue, 3 May 2016 13:55:46 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 2/7] xfs: introduce metadata IO error class
Date: Tue,  3 May 2016 19:55:35 +0200
Message-Id: <1462298140-12411-3-git-send-email-cmaiolino@redhat.com>
In-Reply-To: <1462298140-12411-1-git-send-email-cmaiolino@redhat.com>
References: <1462298140-12411-1-git-send-email-cmaiolino@redhat.com>
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
default configuration that matches the existing "retry forever" behavior
for async write metadata buffers.

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
