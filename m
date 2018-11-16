Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx7.valuehost.ru ([217.112.42.214]:32154 "EHLO mx7.valuehost.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728175AbeKQCqM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Nov 2018 21:46:12 -0500
Received: from mx7.valuehost.ru (unknown [127.0.0.255])
        by mx7.valuehost.ru (Postfix) with ESMTP id 456255382F
        for <linux-xfs@vger.kernel.org>; Fri, 16 Nov 2018 19:23:46 +0300 (MSK)
From: <info@mobile-stream.com>
Date: Fri, 16 Nov 2018 19:10:00 +0000
Subject: xfsprogs: MAP_SYNC detection/usage problems with musl
Message-Id: <20181116162346.456255382F@mx7.valuehost.ru>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

xfsprogs configure script tries to detect the MAP_SYNC mmap() flag support in kernel
by looking for the symbol in <asm-generic/mman{-common}.h> files. But some architectures
(e.g. mips) do not use the generic files and define all the mman bits in <asm/mman.h>.
Thus xfs_io ends up with the incorrectly detected MAP_SYNC support. Not a big deal, just
no graceful exit on 'xfs_io mmap -S'.

Worse problem is related to the MAP_SYNC handling in the musl library. They first define
MAP_SYNC unconditionally in <sys/mman.h> then undefine it in mips-specific <bits/mman.h>.
So io/mmap.c compilation fails since <sys/mman.h> (which undefines MAP_SYNC) is included
after "linux.h" (which either defines fallback values or pulls <asm-generic/mman{-common.h}>).

The diff below is not really a suggested patch (though it works for me in alpine/mipsel) but
merely an additional illustration of the above.

--- a/include/linux.h
+++ b/include/linux.h
@@ -327,12 +327,4 @@
 #define HAVE_GETFSMAP
 #endif /* HAVE_GETFSMAP */
 
-#ifndef HAVE_MAP_SYNC
-#define MAP_SYNC 0
-#define MAP_SHARED_VALIDATE 0
-#else
-#include <asm-generic/mman.h>
-#include <asm-generic/mman-common.h>
-#endif /* HAVE_MAP_SYNC */
-
 #endif	/* __XFS_LINUX_H__ */
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -23,6 +23,11 @@
 #include "init.h"
 #include "io.h"
 
+#ifndef HAVE_MAP_SYNC
+#define MAP_SYNC 0
+#define MAP_SHARED_VALIDATE 0
+#endif
+
 static cmdinfo_t mmap_cmd;
 static cmdinfo_t mread_cmd;
 static cmdinfo_t msync_cmd;
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -335,8 +335,7 @@
 AC_DEFUN([AC_HAVE_MAP_SYNC],
   [ AC_MSG_CHECKING([for MAP_SYNC])
     AC_TRY_COMPILE([
-#include <asm-generic/mman.h>
-#include <asm-generic/mman-common.h>
+#include <asm/mman.h>
     ], [
         int flags = MAP_SYNC | MAP_SHARED_VALIDATE;
     ], have_map_sync=yes
