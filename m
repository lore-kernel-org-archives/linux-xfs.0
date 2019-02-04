Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35937 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729486AbfBDVUq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 Feb 2019 16:20:46 -0500
Received: by mail-ed1-f65.google.com with SMTP id d12so169836edy.3
        for <linux-xfs@vger.kernel.org>; Mon, 04 Feb 2019 13:20:45 -0800 (PST)
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] xfs: allow disabling xfs tracepoints via Kconfig
Date: Mon,  4 Feb 2019 22:20:35 +0100
Message-Id: <20190204212035.9919-1-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org

linux/tracepoints.h allows individual subsystems to disable their
tracepoints. Add such a knob for xfs. Disabling XFS_TRACEPOINTS
reduces the resident size of xfs.ko by about a third, or ~350 KiB.

$ size /tmp/xfs/{a,b}/xfs.ko
   text    data     bss     dec     hex filename
 671726    4129     632  676487   a5287 /tmp/xfs/a/xfs.ko
 893192  166737     632 1060561  102ed1 /tmp/xfs/b/xfs.ko

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 fs/xfs/Kconfig     | 9 +++++++++
 fs/xfs/xfs_trace.h | 4 ++++
 2 files changed, 13 insertions(+)

diff --git a/fs/xfs/Kconfig b/fs/xfs/Kconfig
index 457ac9f97377..d099e6d9f6c5 100644
--- a/fs/xfs/Kconfig
+++ b/fs/xfs/Kconfig
@@ -141,3 +141,12 @@ config XFS_ASSERT_FATAL
 	  result in warnings.
 
 	  This behavior can be modified at runtime via sysfs.
+
+config XFS_TRACEPOINTS
+	bool "XFS tracepoints"
+	default y
+	depends on XFS_FS && TRACEPOINTS
+	help
+	  Say Y here to build XFS with tracepoints.
+
+	  You can say N here to reduce the size of the kernel image.
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 6fcc893dfc91..5fb3d5c0483e 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -6,6 +6,10 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM xfs
 
+#ifndef CONFIG_XFS_TRACEPOINTS
+#define NOTRACE
+#endif
+
 #if !defined(_TRACE_XFS_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_XFS_H
 
-- 
2.20.1
