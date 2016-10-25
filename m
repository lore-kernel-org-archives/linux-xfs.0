Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:46546 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932449AbcJYXFW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Oct 2016 19:05:22 -0400
Subject: [PATCH 16/39] libxfs: add configure option to override system
 header fsxattr
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Oct 2016 16:05:17 -0700
Message-ID: <147743671705.11035.1549555844450499931.stgit@birch.djwong.org>
In-Reply-To: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
References: <147743661772.11035.560864407573832590.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

By default, libxfs will use the kernel/system headers to define struct
fsxattr.  Unfortunately, this creates a problem for developers who are
writing new features but building xfsprogs on a stable system, because
the stable kernel's headers don't reflect the new feature.  In this
case, we want to be able to use the internal fsxattr definition while
the kernel headers catch up, so provide some configure magic to allow
developers to force the use of the internal definition.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 configure.ac         |    5 +++++
 include/builddefs.in |    4 ++++
 include/linux.h      |   10 +++++++++-
 io/fiemap.c          |    1 -
 4 files changed, 18 insertions(+), 2 deletions(-)


diff --git a/configure.ac b/configure.ac
index 50e04df..8a39e75 100644
--- a/configure.ac
+++ b/configure.ac
@@ -61,6 +61,11 @@ AC_ARG_ENABLE(librt,
 	enable_librt=yes)
 AC_SUBST(enable_librt)
 
+AC_ARG_ENABLE(internal-fsxattr,
+[ --enable-internal-fsxattr=[yes/no] Override system definition of struct fsxattr [default=no]],,
+	enable_internal_fsxattr=no)
+AC_SUBST(enable_internal_fsxattr)
+
 #
 # If the user specified a libdir ending in lib64 do not append another
 # 64 to the library names.
diff --git a/include/builddefs.in b/include/builddefs.in
index 7153d7a..fd7eb74 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -109,6 +109,7 @@ HAVE_MNTENT = @have_mntent@
 HAVE_FLS = @have_fls@
 HAVE_FSETXATTR = @have_fsetxattr@
 HAVE_MREMAP = @have_mremap@
+ENABLE_INTERNAL_FSXATTR = @enable_internal_fsxattr@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
@@ -148,6 +149,9 @@ endif
 ifeq ($(ENABLE_BLKID),yes)
 PCFLAGS+= -DENABLE_BLKID
 endif
+ifeq ($(ENABLE_INTERNAL_FSXATTR),yes)
+PCFLAGS+= -DOVERRIDE_SYSTEM_FSXATTR
+endif
 
 
 GCFLAGS = $(OPTIMIZER) $(DEBUG) \
diff --git a/include/linux.h b/include/linux.h
index ddc053e..e26388b 100644
--- a/include/linux.h
+++ b/include/linux.h
@@ -32,7 +32,13 @@
 #include <stdio.h>
 #include <asm/types.h>
 #include <mntent.h>
+#ifdef OVERRIDE_SYSTEM_FSXATTR
+# define fsxattr sys_fsxattr
+#endif
 #include <linux/fs.h> /* fsxattr defintion for new kernels */
+#ifdef OVERRIDE_SYSTEM_FSXATTR
+# undef fsxattr
+#endif
 
 static __inline__ int xfsctl(const char *path, int fd, int cmd, void *p)
 {
@@ -175,7 +181,7 @@ static inline void platform_mntent_close(struct mntent_cursor * cursor)
  * are a copy of the definitions moved to linux/uapi/fs.h in the 4.5 kernel,
  * so this is purely for supporting builds against old kernel headers.
  */
-#ifndef FS_IOC_FSGETXATTR
+#if !defined FS_IOC_FSGETXATTR || defined OVERRIDE_SYSTEM_FSXATTR
 struct fsxattr {
 	__u32		fsx_xflags;	/* xflags field value (get/set) */
 	__u32		fsx_extsize;	/* extsize field value (get/set)*/
@@ -184,7 +190,9 @@ struct fsxattr {
 	__u32		fsx_cowextsize;	/* cow extsize field value (get/set) */
 	unsigned char	fsx_pad[8];
 };
+#endif
 
+#ifndef FS_IOC_FSGETXATTR
 /*
  * Flags for the fsx_xflags field
  */
diff --git a/io/fiemap.c b/io/fiemap.c
index f89da06..bcbae49 100644
--- a/io/fiemap.c
+++ b/io/fiemap.c
@@ -19,7 +19,6 @@
 #include "platform_defs.h"
 #include "command.h"
 #include <linux/fiemap.h>
-#include <linux/fs.h>
 #include "init.h"
 #include "io.h"
 

