Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AA6FD7F47
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 11:23:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8D948304075
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 09:23:55 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 3dHa1LQqhiBSbs5I (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 09:23:54 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 06/11] xfsprogs: Add mntent.h check into autoconf
Date: Mon, 17 Aug 2015 18:23:21 +0200
Message-Id: <1439828606-7886-7-git-send-email-jtulak@redhat.com>
In-Reply-To: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
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

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 configure.ac          | 1 +
 fsr/xfs_fsr.c         | 6 +++---
 include/builddefs.in  | 4 ++++
 m4/package_libcdev.m4 | 8 ++++++++
 4 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index 530650b..0aba90c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -115,6 +115,7 @@ AC_HAVE_FALLOCATE
 AC_HAVE_FIEMAP
 AC_HAVE_PREADV
 AC_HAVE_SYNC_FILE_RANGE
+AC_HAVE_MNTENT
 AC_HAVE_BLKID_TOPO
 AC_HAVE_READDIR
 
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index b4ff136..4912b73 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -25,16 +25,16 @@
 
 #include <fcntl.h>
 #include <errno.h>
-#include <malloc.h>
-#include <mntent.h>
 #include <syslog.h>
 #include <signal.h>
 #include <sys/ioctl.h>
 #include <sys/wait.h>
-#include <sys/vfs.h>
 #include <sys/statvfs.h>
 #include <sys/xattr.h>
 
+#ifdef HAVE_MNTENT
+#  include <mntent.h>
+#endif
 
 #ifndef XFS_XFLAG_NODEFRAG
 #define XFS_XFLAG_NODEFRAG 0x00002000 /* src dependancy, remove later */
diff --git a/include/builddefs.in b/include/builddefs.in
index c644a17..e522243 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -103,6 +103,7 @@ HAVE_FIEMAP = @have_fiemap@
 HAVE_PREADV = @have_preadv@
 HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
 HAVE_READDIR = @have_readdir@
+HAVE_MNTENT = @have_mntent@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
@@ -130,6 +131,9 @@ PLDLIBS = -L/usr/local/lib -lintl
 PCFLAGS = -I/usr/local/include $(GCCFLAGS)
 DEPENDFLAGS = -D__FreeBSD__
 endif
+ifeq ($(HAVE_MNTENT),yes)
+PCFLAGS+= -DHAVE_MNTENT
+endif
 
 GCFLAGS = $(OPTIMIZER) $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 919ae0a..75aa61e 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -202,3 +202,11 @@ AC_DEFUN([AC_HAVE_READDIR],
     AC_SUBST(have_readdir)
   ])
 
+#
+# Check if there is mntent.h
+#
+AC_DEFUN([AC_HAVE_MNTENT],
+  [ AC_CHECK_HEADERS(mntent.h,
+    have_mntent=yes)
+    AC_SUBST(have_mntent)
+  ])
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
