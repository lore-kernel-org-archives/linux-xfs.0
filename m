Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2334B7CB3
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 07:16:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BD040304066
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 05:16:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id h3do01tKYl8tZotf (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 May 2016 05:16:30 -0700 (PDT)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 6F7F2627DA
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 12:16:30 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u4ACGOum016940
	for <xfs@oss.sgi.com>; Tue, 10 May 2016 08:16:29 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 6/7] xfs: add configuration handlers for specific errors
Date: Tue, 10 May 2016 14:16:20 +0200
Message-Id: <1462882581-30859-7-git-send-email-cmaiolino@redhat.com>
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

now most of the infrastructure is in place, we can start adding
support for configuring specific errors such as ENODEV, ENOSPC, EIO,
etc. Add these error configurations and configure them all to have
appropriate behaviours. That is, all will be configured to retry forever by
default, except for ENODEV, which is an unrecoverable error, so it will be
configured to not retry on error

Changelog:

V3:
	- Do not implement .fail_speed and .fail_at_unmount
	- .fail_at_unmount will be implemented in a different patch

V4:
	- ENODEV should fail immediately by default
	- Use XFS_ERR_RETRY_FOREVER flag, instead of -1 directly

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_mount.h |  3 +++
 fs/xfs/xfs_sysfs.c | 22 +++++++++++++++++++++-
 2 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 2fafa94..72ec3e3 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -49,6 +49,9 @@ enum {
 };
 enum {
 	XFS_ERR_DEFAULT,
+	XFS_ERR_EIO,
+	XFS_ERR_ENOSPC,
+	XFS_ERR_ENODEV,
 	XFS_ERR_ERRNO_MAX,
 };
 
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index 918d144..084a606 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -478,9 +478,20 @@ struct xfs_error_init {
 
 static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
 	{ .name = "default",
-	  .max_retries = -1,
+	  .max_retries = XFS_ERR_RETRY_FOREVER,
 	  .retry_timeout = 0,
 	},
+	{ .name = "EIO",
+	  .max_retries = XFS_ERR_RETRY_FOREVER,
+	  .retry_timeout = 0,
+	},
+	{ .name = "ENOSPC",
+	  .max_retries = XFS_ERR_RETRY_FOREVER,
+	  .retry_timeout = 0,
+	},
+	{ .name = "ENODEV",
+	  .max_retries = 0,
+	},
 };
 
 static int
@@ -578,6 +589,15 @@ xfs_error_get_cfg(
 	struct xfs_error_cfg	*cfg;
 
 	switch (error) {
+	case EIO:
+		cfg = &mp->m_error_cfg[error_class][XFS_ERR_EIO];
+		break;
+	case ENOSPC:
+		cfg = &mp->m_error_cfg[error_class][XFS_ERR_ENOSPC];
+		break;
+	case ENODEV:
+		cfg = &mp->m_error_cfg[error_class][XFS_ERR_ENODEV];
+		break;
 	default:
 		cfg = &mp->m_error_cfg[error_class][XFS_ERR_DEFAULT];
 		break;
-- 
2.4.11

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
