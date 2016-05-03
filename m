Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id DB7B37CB3
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 12:55:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9432030404E
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 10:55:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id G4bQtgR4LjAGEjQw (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 03 May 2016 10:55:50 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 53E566F672
	for <xfs@oss.sgi.com>; Tue,  3 May 2016 17:55:50 +0000 (UTC)
Received: from zion.usersys.redhat.com (dhcp-26-103.brq.redhat.com
	[10.34.26.103])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u43HtiDV016424
	for <xfs@oss.sgi.com>; Tue, 3 May 2016 13:55:49 -0400
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 6/7] xfs: add configuration handles for specific errors
Date: Tue,  3 May 2016 19:55:39 +0200
Message-Id: <1462298140-12411-7-git-send-email-cmaiolino@redhat.com>
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

now most of the infrastructure is in place, we can start adding
support for configuring specific errors such as ENODEV, ENOSPC, EIO,
etc. Add these error configurations and configure them all to have
appropriate behaviours. That is, all will use the "fail never, fail
at unmount" default except for ENODEV, which is an unrecoverable
error so it will be configured as a "fail fast" error.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 fs/xfs/xfs_mount.h |  3 +++
 fs/xfs/xfs_sysfs.c | 20 ++++++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
index 0382140..e3b3267 100644
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
index fa291c4..aad3320 100644
--- a/fs/xfs/xfs_sysfs.c
+++ b/fs/xfs/xfs_sysfs.c
@@ -481,6 +481,17 @@ static const struct xfs_error_init xfs_error_meta_init[XFS_ERR_ERRNO_MAX] = {
 	  .max_retries = -1,
 	  .retry_timeout = 0,
 	},
+	{ .name = "EIO",
+	  .max_retries = -1,
+	  .retry_timeout = 0,
+	},
+	{ .name = "ENOSPC",
+	  .max_retries = -1,
+	  .retry_timeout = 0,
+	},
+	{ .name = "ENODEV",
+	  .max_retries = -1,
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
