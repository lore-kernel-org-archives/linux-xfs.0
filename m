Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 238027F6F
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 05:35:15 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 02542304051
	for <xfs@oss.sgi.com>; Thu,  3 Sep 2015 03:35:14 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PUkg9WqWNzmmq2BL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 03 Sep 2015 03:35:14 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v2] xfsprogs: Make mremap conditional
Date: Thu,  3 Sep 2015 12:35:10 +0200
Message-Id: <1441276510-23637-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <1440590555-20463-11-git-send-email-jtulak@redhat.com>
References: <1440590555-20463-11-git-send-email-jtulak@redhat.com>
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
Cc: hch@infradead.org, Jan Tulak <jtulak@redhat.com>

Don't build mremap (in xfs_io) on platforms where it has no support.

CHANGELOG:
 - subject was xfsprogs: add dummy mremap for OS X

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 configure.ac          |  1 +
 include/builddefs.in  |  1 +
 include/darwin.h      |  1 +
 io/mmap.c             |  8 ++++++++
 m4/package_libcdev.m4 | 13 +++++++++++++
 5 files changed, 24 insertions(+)

diff --git a/configure.ac b/configure.ac
index 13aa308..01dd1a3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -124,6 +124,7 @@ AC_HAVE_MNTENT
 AC_HAVE_FLS
 AC_HAVE_READDIR
 AC_HAVE_FSETXATTR
+AC_HAVE_MREMAP
 
 if test "$enable_blkid" = yes; then
 AC_HAVE_BLKID_TOPO
diff --git a/include/builddefs.in b/include/builddefs.in
index 31e21ba..c1797fd 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -107,6 +107,7 @@ HAVE_READDIR = @have_readdir@
 HAVE_MNTENT = @have_mntent@
 HAVE_FLS = @have_fls@
 HAVE_FSETXATTR = @have_fsetxattr@
+HAVE_MREMAP = @have_mremap@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/include/darwin.h b/include/darwin.h
index af76f31..9f7a00b 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -33,6 +33,7 @@
 #include <mach/mach_time.h>
 #include <inttypes.h>
 #include <stdio.h>
+#include <sys/mman.h>
 
 #include <machine/endian.h>
 #define __BYTE_ORDER	BYTE_ORDER
diff --git a/io/mmap.c b/io/mmap.c
index f26276e..7093650 100644
--- a/io/mmap.c
+++ b/io/mmap.c
@@ -28,7 +28,9 @@ static cmdinfo_t mread_cmd;
 static cmdinfo_t msync_cmd;
 static cmdinfo_t munmap_cmd;
 static cmdinfo_t mwrite_cmd;
+#ifdef HAVE_MREMAP
 static cmdinfo_t mremap_cmd;
+#endif /* HAVE_MREMAP */
 
 mmap_region_t	*maptable;
 int		mapcount;
@@ -574,6 +576,7 @@ mwrite_f(
 	return 0;
 }
 
+#ifdef HAVE_MREMAP
 static void
 mremap_help(void)
 {
@@ -633,6 +636,7 @@ mremap_f(
 
 	return 0;
 }
+#endif /* HAVE_MREMAP */
 
 void
 mmap_init(void)
@@ -688,6 +692,7 @@ mmap_init(void)
 		_("writes data into a region in the current memory mapping");
 	mwrite_cmd.help = mwrite_help;
 
+#ifdef HAVE_MREMAP
 	mremap_cmd.name = "mremap";
 	mremap_cmd.altname = "mrm";
 	mremap_cmd.cfunc = mremap_f;
@@ -698,11 +703,14 @@ mmap_init(void)
 	mremap_cmd.oneline =
 		_("alters the size of the current memory mapping");
 	mremap_cmd.help = mremap_help;
+#endif /* HAVE_MREMAP */
 
 	add_command(&mmap_cmd);
 	add_command(&mread_cmd);
 	add_command(&msync_cmd);
 	add_command(&munmap_cmd);
 	add_command(&mwrite_cmd);
+#ifdef HAVE_MREMAP
 	add_command(&mremap_cmd);
+#endif /* HAVE_MREMAP */
 }
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 5e900ab..b6a7a54 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -235,3 +235,16 @@ AC_DEFUN([AC_HAVE_MNTENT],
     have_mntent=yes)
     AC_SUBST(have_mntent)
   ])
+
+#
+# Check if we have a mremap call (not on Mac OS X)
+#
+AC_DEFUN([AC_HAVE_MREMAP],
+  [ AC_CHECK_DECL([mremap],
+       have_mremap=yes,
+       [],
+       [#define _GNU_SOURCE
+        #include <sys/mman.h>]
+       )
+    AC_SUBST(have_mremap)
+  ])
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
