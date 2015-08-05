Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 024787FC8
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 06:09:05 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id BC6738F804B
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2015 04:09:04 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	lPlTI9Y7hr3dX8Xh for <xfs@oss.sgi.com>;
	Wed, 05 Aug 2015 04:09:03 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1ZMwYt-0006H6-Pu
	for xfs@oss.sgi.com; Wed, 05 Aug 2015 21:08:43 +1000
Received: from dave by disappointment with local (Exim 4.86_RC4)
	(envelope-from <dave@disappointment.disaster>) id 1ZMwYt-0007nu-PI
	for xfs@oss.sgi.com; Wed, 05 Aug 2015 21:08:43 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 08/10] xfs: add configuration handles for specific errors
Date: Wed,  5 Aug 2015 21:08:39 +1000
Message-Id: <1438772921-28715-9-git-send-email-david@fromorbit.com>
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
index c86fe43..7d62450 100644
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
index 921b079..019e859 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -469,6 +469,21 @@ static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
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
@@ -568,6 +583,15 @@ xfs_error_get_cfg(
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
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
