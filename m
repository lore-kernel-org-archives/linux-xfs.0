Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id F24E87F8D
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 09:40:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 80B83AC003
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 07:40:33 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wsB7zE8ACLtOa0Vh (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 07:40:32 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v3 09/11] xfsprogs: Add mntent.h check into autoconf
Date: Mon,  3 Aug 2015 16:39:47 +0200
Message-Id: <1438612789-17486-10-git-send-email-jtulak@redhat.com>
In-Reply-To: <1438612789-17486-1-git-send-email-jtulak@redhat.com>
References: <1438612789-17486-1-git-send-email-jtulak@redhat.com>
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
 configure.ac          |  1 +
 fsr/xfs_fsr.c         |  6 +++---
 include/builddefs.in  |  4 ++++
 m4/package_libcdev.m4 | 12 ++++++++++++
 4 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index 8f966a6..e2d395b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -113,6 +113,7 @@ AC_HAVE_PREADV
 AC_HAVE_SYNC_FILE_RANGE
 AC_HAVE_BLKID_TOPO($enable_blkid)
 AC_HAVE_READDIR
+AC_HAVE_MNTENT
 AC_HAVE_FLS
 
 AC_CHECK_SIZEOF([long])
diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index d8a4ece..12eb172 100644
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
index 9feb096..1132f26 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -104,6 +104,7 @@ HAVE_FIEMAP = @have_fiemap@
 HAVE_PREADV = @have_preadv@
 HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
 HAVE_READDIR = @have_readdir@
+HAVE_MNTENT = @have_mntent@
 HAVE_FLS = @have_fls@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
@@ -135,6 +136,9 @@ endif
 ifeq ($(HAVE_FLS),yes)
 LCFLAGS+= -DHAVE_FLS
 endif
+ifeq ($(HAVE_MNTENT),yes)
+PCFLAGS+= -DHAVE_MNTENT
+endif
 
 GCFLAGS = $(OPTIMIZER) $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index d7f37ca..bb7bcdb 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -216,3 +216,15 @@ AC_DEFUN([AC_HAVE_FLS],
        AC_MSG_RESULT(no))
     AC_SUBST(have_fls)
   ])
+
+#
+# Check if there is mntent.h
+#
+AC_DEFUN([AC_HAVE_MNTENT],
+  [ AC_MSG_CHECKING([for mntent])
+    AC_CHECK_HEADERS(mntent.h,
+    have_mntent=yes
+    AC_MSG_RESULT(yes),
+    AC_MSG_RESULT(no))
+    AC_SUBST(have_mntent)
+  ])
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
