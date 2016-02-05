Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 38CED7CA2
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 19:23:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CDB0DAC004
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2016 17:23:35 -0800 (PST)
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
	[150.101.137.129]) by cuda.sgi.com with ESMTP id
	Hnb7WujZuvwlft9D for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2016 17:23:33 -0800 (PST)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1aRV7T-0000Wv-4b
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 12:23:31 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1aRV7T-0005tj-3l
	for xfs@oss.sgi.com; Fri, 05 Feb 2016 12:23:31 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 7/9] xfs: add configuration handles for specific errors
Date: Fri,  5 Feb 2016 12:23:25 +1100
Message-Id: <1454635407-22276-8-git-send-email-david@fromorbit.com>
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

now most of the infrastructure is in place, we can start adding
support for configuring specific errors such as ENODEV, ENOSPC, EIO,
etc. Add these error configurations and configure them all to have
appropriate behaviours. That is, all will use the "fail never, fail
at unmount" default except for ENODEV, which is an unrecoverable
error so it will be configured as a "fail fast" error.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_mount.h |  3 +++
 fs/xfs/xfs_sysfs.c | 24 ++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index edeb0b6..c05b500 100644
--- a/fs/xfs/xfs_mount.h
+++ b/fs/xfs/xfs_mount.h
@@ -50,6 +50,9 @@ enum {
 };
 enum {
 	XFS_ERR_DEFAULT,
+	XFS_ERR_EIO,
+	XFS_ERR_ENOSPC,
+	XFS_ERR_ENODEV,
 	XFS_ERR_ERRNO_MAX,
 };
 enum {
diff --git a/fs/xfs/xfs_sysfs.c b/fs/xfs/xfs_sysfs.c
index a5b040a..d48dc46 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -507,6 +507,21 @@ static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
 	  .retry_timeout = 0,
 	  .fail_at_unmount = true,
 	},
+	{ .name = "EIO",
+	  .fail_speed = XFS_ERR_FAIL_NEVER,
+	  .max_retries = INT_MAX,
+	  .retry_timeout = 0,
+	  .fail_at_unmount = true,
+	},
+	{ .name = "ENOSPC",
+	  .fail_speed = XFS_ERR_FAIL_NEVER,
+	  .max_retries = INT_MAX,
+	  .retry_timeout = 0,
+	  .fail_at_unmount = true,
+	},
+	{ .name = "ENODEV",
+	  .fail_speed = XFS_ERR_FAIL_FAST,
+	},
 };
 
 static int
@@ -606,6 +621,15 @@ xfs_error_get_cfg(
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
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
