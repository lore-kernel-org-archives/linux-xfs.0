Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47350 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753169AbdEENb2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 May 2017 09:31:28 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 487F480C04
        for <linux-xfs@vger.kernel.org>; Fri,  5 May 2017 13:31:28 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 269CE82791
        for <linux-xfs@vger.kernel.org>; Fri,  5 May 2017 13:31:28 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2] xfs: make fatal assert failures conditional in debug mode
Date: Fri,  5 May 2017 09:31:26 -0400
Message-Id: <1493991086-18817-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

XFS currently supports two debug modes: XFS_WARN enables assert
failure warnings and XFS_DEBUG converts assert failures to fatal
errors (via BUG()) and enables additional runtime debug code.

While the behavior to BUG the kernel on assert failure is useful in
certain test scenarios, it is also useful for development/debug to
enable debug mode code without having to crash the kernel on an
assert failure.

To provide this additional flexibility, update XFS debug mode to not
BUG() the kernel by default and create a new XFS kernel
configuration option to enable fatal assert failures when debug mode
is enabled. To provide backwards compatibility with current
behavior, enable the fatal asserts option by default when debug mode
is enabled.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/Kconfig     |  9 +++++++++
 fs/xfs/xfs.h       |  4 ++++
 fs/xfs/xfs_linux.h | 32 +++++++++++++++++++-------------
 3 files changed, 32 insertions(+), 13 deletions(-)

v2:
- Clean up the Kconfig option help text.
v1: http://www.spinics.net/lists/linux-xfs/msg06498.html
- Use a new config option rather than reuse XFS_WARN.
- Disable BUG() in DEBUG mode by default and flip the logic of the new
  config option.
rfc: http://www.spinics.net/lists/linux-xfs/msg06390.html

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 35faf12..64da728 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -96,3 +96,12 @@ config XFS_DEBUG
 	  not useful unless you are debugging a particular problem.
 
 	  Say N unless you are an XFS developer, or you play one on TV.
+
+config XFS_ASSERT_FATAL
+	bool "XFS fatal asserts"
+	default y
+	depends on XFS_FS && XFS_DEBUG
+	help
+	  Say Y here to cause DEBUG mode ASSERT failures to result in fatal
+	  errors that BUG() the kernel. If you say N, assert failures result in
+	  warnings.
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
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 044fb0e..36c3eab 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -245,37 +245,43 @@ static inline __uint64_t howmany_64(__uint64_t x, __uint32_t y)
 	return x;
 }
 
+/*
+ * ASSERT() definitions
+ */
 #define ASSERT_ALWAYS(expr)	\
 	(likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
 
-#ifdef DEBUG
+#if defined(DEBUG) && defined(XFS_ASSERT_FATAL)
+
 #define ASSERT(expr)	\
 	(likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
 
-#ifndef STATIC
-# define STATIC noinline
-#endif
-
-#else	/* !DEBUG */
-
-#ifdef XFS_WARN
+#elif defined(DEBUG) || defined(XFS_WARN)
 
 #define ASSERT(expr)	\
 	(likely(expr) ? (void)0 : asswarn(#expr, __FILE__, __LINE__))
 
-#ifndef STATIC
-# define STATIC static noinline
+#else
+
+#define ASSERT(expr)	((void)0)
+
 #endif
 
-#else	/* !DEBUG && !XFS_WARN */
+/*
+ * STATIC definitions
+ */
+#ifdef DEBUG
+
+#ifndef STATIC
+# define STATIC noinline
+#endif
 
-#define ASSERT(expr)	((void)0)
+#else	/* !DEBUG */
 
 #ifndef STATIC
 # define STATIC static noinline
 #endif
 
-#endif /* XFS_WARN */
 #endif /* DEBUG */
 
 #ifdef CONFIG_XFS_RT
-- 
2.7.4

