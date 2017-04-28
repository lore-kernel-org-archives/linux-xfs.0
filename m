Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59866 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754628AbdD1R3D (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 28 Apr 2017 13:29:03 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 517C446D080
        for <linux-xfs@vger.kernel.org>; Fri, 28 Apr 2017 17:29:03 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3293D96511
        for <linux-xfs@vger.kernel.org>; Fri, 28 Apr 2017 17:29:03 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC] xfs: support debug mode with assert warnings
Date: Fri, 28 Apr 2017 13:29:01 -0400
Message-Id: <1493400541-56113-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

Hi all,

Every now and then I find myself wanting to enable DEBUG mode code
without having to BUG the kernel every time an assert fails. Currently,
I end up just commenting out the BUG() call from assfail(). Any thoughts
on something like the below to update our configuration to support the
ability to enable debug mode with assert warnings?

While this appears as a new option in Kconfig, it just reuses the
existing XFS_WARN definition to convert asserts into warnings regardless
of whether debug mode is enabled or not. There are probably multiple
other ways to do something like this (e.g., a Kconfig 'choice' selection
for various XFS debug modes, dropping the BUG() entirely, etc.).
Thoughts?

Brian

 fs/xfs/Kconfig     |  9 +++++++++
 fs/xfs/xfs_linux.h | 32 +++++++++++++++++++-------------
 2 files changed, 28 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 35faf12..db6d830 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -96,3 +96,12 @@ config XFS_DEBUG
 	  not useful unless you are debugging a particular problem.
 
 	  Say N unless you are an XFS developer, or you play one on TV.
+
+config XFS_WARN
+	bool "Non-fatal Asserts"
+	default n
+	depends on XFS_FS && XFS_DEBUG
+	help
+	  Say Y here to convert DEBUG mode ASSERT failures into warnings.
+	  Otherwise, ASSERT failures are considered fatal errors and BUG the
+	  kernel.
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index 044fb0e..3432863 100644
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
+#if defined(DEBUG) && !defined(XFS_WARN)
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
+#elif defined(XFS_WARN)
 
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

