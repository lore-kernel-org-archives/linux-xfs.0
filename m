Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ABF4D7F7C
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 09:40:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 478A7AC002
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 07:40:32 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id T6IZOXR1t4GGoZEc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 07:40:31 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v3 08/11] xfsprogs: Add fls check into autoconf
Date: Mon,  3 Aug 2015 16:39:46 +0200
Message-Id: <1438612789-17486-9-git-send-email-jtulak@redhat.com>
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

Add a check for fls call, and a replacement call
for platforms without fls.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 configure.ac          |  1 +
 include/bitops.h      |  2 ++
 include/builddefs.in  |  4 ++++
 m4/package_libcdev.m4 | 14 ++++++++++++++
 4 files changed, 21 insertions(+)

diff --git a/configure.ac b/configure.ac
index fe991cc..8f966a6 100644
--- a/configure.ac
+++ b/configure.ac
@@ -113,6 +113,7 @@ AC_HAVE_PREADV
 AC_HAVE_SYNC_FILE_RANGE
 AC_HAVE_BLKID_TOPO($enable_blkid)
 AC_HAVE_READDIR
+AC_HAVE_FLS
 
 AC_CHECK_SIZEOF([long])
 AC_CHECK_SIZEOF([char *])
diff --git a/include/bitops.h b/include/bitops.h
index 930f64a..44599a7 100644
--- a/include/bitops.h
+++ b/include/bitops.h
@@ -5,6 +5,7 @@
  * fls: find last bit set.
  */
 
+#ifndef HAVE_FLS
 static inline int fls(int x)
 {
 	int r = 32;
@@ -32,6 +33,7 @@ static inline int fls(int x)
 	}
 	return r;
 }
+#endif /* HAVE_FLS */
 
 static inline int fls64(__u64 x)
 {
diff --git a/include/builddefs.in b/include/builddefs.in
index 7f939f6..9feb096 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -104,6 +104,7 @@ HAVE_FIEMAP = @have_fiemap@
 HAVE_PREADV = @have_preadv@
 HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
 HAVE_READDIR = @have_readdir@
+HAVE_FLS = @have_fls@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
@@ -131,6 +132,9 @@ PLDLIBS = -L/usr/local/lib -lintl
 PCFLAGS = -I/usr/local/include $(GCCFLAGS)
 DEPENDFLAGS = -D__FreeBSD__
 endif
+ifeq ($(HAVE_FLS),yes)
+LCFLAGS+= -DHAVE_FLS
+endif
 
 GCFLAGS = $(OPTIMIZER) $(DEBUG) \
 	  -DVERSION=\"$(PKG_VERSION)\" -DLOCALEDIR=\"$(PKG_LOCALE_DIR)\"  \
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 919ae0a..d7f37ca 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -202,3 +202,17 @@ AC_DEFUN([AC_HAVE_READDIR],
     AC_SUBST(have_readdir)
   ])
 
+#
+# Check if we have a flc call (Mac OS X)
+#
+AC_DEFUN([AC_HAVE_FLS],
+  [ AC_MSG_CHECKING([for fls])
+    AC_TRY_LINK([
+#include <string.h>
+    ], [
+         fls(0);
+    ], have_fls=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_fls)
+  ])
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
