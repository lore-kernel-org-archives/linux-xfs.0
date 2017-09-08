Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:36663 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753011AbdIHXg3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 Sep 2017 19:36:29 -0400
Received: by mail-pf0-f193.google.com with SMTP id f84so2080505pfj.3
        for <linux-xfs@vger.kernel.org>; Fri, 08 Sep 2017 16:36:29 -0700 (PDT)
From: Khem Raj <raj.khem@gmail.com>
Subject: [PATCH] define __ prefixed version of intXY_t types
Date: Fri,  8 Sep 2017 16:36:16 -0700
Message-Id: <20170908233616.26051-1-raj.khem@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Khem Raj <raj.khem@gmail.com>

This is required since musl does not define them
unlike glibc

Signed-off-by: Khem Raj <raj.khem@gmail.com>
---
 include/linux.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/include/linux.h b/include/linux.h
index 9611a37f..1f6319c6 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -40,6 +40,35 @@
 # undef fsxattr
 #endif
 
+#ifndef loff_t
+#define loff_t off_t
+#endif
+#ifndef __uint8_t
+#define __uint8_t uint8_t
+#endif
+#ifndef __uint16_t
+#define __uint16_t uint16_t
+#endif
+#ifndef __uint32_t
+#define __uint32_t uint32_t
+#endif
+#ifndef __uint64_t
+#define __uint64_t uint64_t
+#endif
+
+#ifndef __int8_t
+#define __int8_t int8_t
+#endif
+#ifndef __int16_t
+#define __int16_t int16_t
+#endif
+#ifndef __int32_t
+#define __int32_t int32_t
+#endif
+#ifndef __int64_t
+#define __int64_t int64_t
+#endif
+
 static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
 {
 	return ioctl(fd, cmd, p);
-- 
2.14.1

