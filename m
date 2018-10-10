Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:56198 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727714AbeJKDZU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 Oct 2018 23:25:20 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 04/18] xfsprogs: avoid redefinition of NBBY
Date: Wed, 10 Oct 2018 15:01:08 -0500
Message-Id: <1539201682-22198-5-git-send-email-sandeen@redhat.com>
In-Reply-To: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
References: <1539201682-22198-1-git-send-email-sandeen@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Include sys/param.h for NBBY definition.  Do this before our local
guarded definition which is for platforms like android that don't have it,
see commit:

c9a90185 xfsprogs: define NBBY if not defined by the system header files

Fixes sparse warnings about this redefinition.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 include/platform_defs.h.in | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/platform_defs.h.in b/include/platform_defs.h.in
index c4f0e8b..d111ec6 100644
--- a/include/platform_defs.h.in
+++ b/include/platform_defs.h.in
@@ -19,6 +19,7 @@
 #include <pthread.h>
 #include <ctype.h>
 #include <sys/types.h>
+#include <sys/param.h>
 #include <limits.h>
 #include <stdbool.h>
 #include <libgen.h>
@@ -65,6 +66,7 @@ typedef unsigned short umode_t;
 #define max(a,b)	(((a)>(b))?(a):(b))
 #endif
 
+/* If param.h doesn't provide it, i.e. for Android */
 #ifndef NBBY
 #define NBBY 8
 #endif
-- 
1.8.3.1
