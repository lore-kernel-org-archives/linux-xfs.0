Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5961 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752825AbdEJObx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 10:31:53 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C738C7AE84
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2017 14:31:52 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6A3417962
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2017 14:31:52 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 2/2] xfs: define fatal assert build time tunable
Date: Wed, 10 May 2017 10:31:51 -0400
Message-Id: <1494426711-6934-3-git-send-email-bfoster@redhat.com>
In-Reply-To: <1494426711-6934-1-git-send-email-bfoster@redhat.com>
References: <1494426711-6934-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

While configurable at runtime, the DEBUG mode assert failure
behavior is usually either desired or not for a particular
situation. For example, developers using kernel modules may prefer
for fatal asserts to remain disabled across module reloads while QE
engineers doing broad regression testing may prefer to have fatal
asserts enabled on boot to facilitate data collection for bug
reports.

To provide a compromise/convenience for developers, create a Kconfig
option that sets the default value of the DEBUG mode 'bug_on_assert'
sysfs tunable. The default behavior remains to trigger kernel BUGs
on assert failures to preserve existing behavior across kernel
configuration updates with DEBUG mode enabled.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/Kconfig       | 13 +++++++++++++
 fs/xfs/xfs.h         |  4 ++++
 fs/xfs/xfs_globals.c |  7 +++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 35faf12..1b98cfa 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -96,3 +96,16 @@ config XFS_DEBUG
 	  not useful unless you are debugging a particular problem.
 
 	  Say N unless you are an XFS developer, or you play one on TV.
+
+config XFS_ASSERT_FATAL
+	bool "XFS fatal asserts"
+	default y
+	depends on XFS_FS && XFS_DEBUG
+	help
+	  Set the default DEBUG mode ASSERT failure behavior.
+
+	  Say Y here to cause DEBUG mode ASSERT failures to result in fatal
+	  errors that BUG() the kernel by default. If you say N, ASSERT failures
+	  result in warnings.
+
+	  This behavior can be modified at runtime via sysfs.
diff --git a/fs/xfs/xfs.h b/fs/xfs/xfs.h
index a742c47..80cd0fd 100644
--- a/fs/xfs/xfs.h
+++ b/fs/xfs/xfs.h
@@ -24,6 +24,10 @@
 #define XFS_BUF_LOCK_TRACKING 1
 #endif
 
+#ifdef CONFIG_XFS_ASSERT_FATAL
+#define XFS_ASSERT_FATAL 1
+#endif
+
 #ifdef CONFIG_XFS_WARN
 #define XFS_WARN 1
 #endif
diff --git a/fs/xfs/xfs_globals.c b/fs/xfs/xfs_globals.c
index 673adf0..3e1cc30 100644
--- a/fs/xfs/xfs_globals.c
+++ b/fs/xfs/xfs_globals.c
@@ -47,6 +47,9 @@ xfs_param_t xfs_params = {
 
 struct xfs_globals xfs_globals = {
 	.log_recovery_delay	=	0,	/* no delay by default */
-	.bug_on_assert		=	true,	/* historical default in DEBUG
-						 * mode */
+#ifdef XFS_ASSERT_FATAL
+	.bug_on_assert		=	true,	/* assert failures BUG() */
+#else
+	.bug_on_assert		=	false,	/* assert failures WARN() */
+#endif
 };
-- 
2.7.4

