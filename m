Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7KxiJG076057 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 14:59:44 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH v2 1/8] xfsdump: link with libpthread
Date: Mon,  7 Nov 2011 14:58:24 -0600
Message-Id: <1320699511-12281-2-git-send-email-wkendall@sgi.com>
In-Reply-To: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
References: <1320699511-12281-1-git-send-email-wkendall@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This patch changes xfsdump/xfsrestore to link with libpthread in
preparation for enabling multi-stream support. The libpthread checks
are the same as those used in xfsprogs.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 configure.in          |    3 +++
 dump/Makefile         |    2 +-
 include/builddefs.in  |    1 +
 m4/Makefile           |    1 +
 m4/package_pthread.m4 |   19 +++++++++++++++++++
 restore/Makefile      |    2 +-
 6 files changed, 26 insertions(+), 2 deletions(-)
 create mode 100644 m4/package_pthread.m4

diff --git a/configure.in b/configure.in
index b7ea1eb..8d4a256 100644
--- a/configure.in
+++ b/configure.in
@@ -67,6 +67,9 @@ AC_MULTILIB($enable_lib64)
 AC_PACKAGE_NEED_UUID_H
 AC_PACKAGE_NEED_UUIDCOMPARE
 
+AC_PACKAGE_NEED_PTHREAD_H
+AC_PACKAGE_NEED_PTHREADMUTEXINIT
+
 AC_PACKAGE_NEED_NCURSES_H
 AC_PACKAGE_WANT_WORKING_LIBNCURSES
 
diff --git a/dump/Makefile b/dump/Makefile
index ce964a0..d193f68 100644
--- a/dump/Makefile
+++ b/dump/Makefile
@@ -89,7 +89,7 @@ HFILES = $(LOCALINCL)
 LHFILES = $(COMMINCL) $(INVINCL)
 LINKS = $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
 LDIRT = $(LINKS)
-LLDLIBS = $(LIBUUID) $(LIBHANDLE) $(LIBATTR) $(LIBRMT)
+LLDLIBS = $(LIBUUID) $(LIBHANDLE) $(LIBATTR) $(LIBRMT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBRMT)
 
 LCFLAGS = -DDUMP
diff --git a/include/builddefs.in b/include/builddefs.in
index f69c038..d5cc8d3 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -16,6 +16,7 @@ CFLAGS = @CFLAGS@
 LIBRMT = $(TOPDIR)/librmt/librmt.la
 LIBXFS = @libxfs@
 LIBATTR = @libattr@
+LIBPTHREAD = @libpthread@
 LIBUUID = @libuuid@
 LIBCURSES = @libcurses@
 LIBHANDLE = @libhdl@
diff --git a/m4/Makefile b/m4/Makefile
index 8ce63f8..9a35056 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -17,6 +17,7 @@ LSRCFILES = \
 	package_attrdev.m4 \
 	package_globals.m4 \
 	package_ncurses.m4 \
+	package_pthread.m4 \
 	package_utilies.m4 \
 	package_uuiddev.m4 \
 	package_xfslibs.m4 \
diff --git a/m4/package_pthread.m4 b/m4/package_pthread.m4
new file mode 100644
index 0000000..be21d29
--- /dev/null
+++ b/m4/package_pthread.m4
@@ -0,0 +1,19 @@
+AC_DEFUN([AC_PACKAGE_NEED_PTHREAD_H],
+  [ AC_CHECK_HEADERS(pthread.h)
+    if test $ac_cv_header_pthread_h = no; then
+	AC_CHECK_HEADERS(pthread.h,, [
+	echo
+	echo 'FATAL ERROR: could not find a valid pthread header.'
+	exit 1])
+    fi
+  ])
+
+AC_DEFUN([AC_PACKAGE_NEED_PTHREADMUTEXINIT],
+  [ AC_CHECK_LIB(pthread, pthread_mutex_init,, [
+	echo
+	echo 'FATAL ERROR: could not find a valid pthread library.'
+	exit 1
+    ])
+    libpthread=-lpthread
+    AC_SUBST(libpthread)
+  ])
diff --git a/restore/Makefile b/restore/Makefile
index 003ea16..ce3d6b4 100644
--- a/restore/Makefile
+++ b/restore/Makefile
@@ -99,7 +99,7 @@ HFILES = $(LOCALINCL)
 LHFILES = $(COMMINCL) $(INVINCL)
 LINKS = $(COMMINCL) $(COMMON) $(INVINCL) $(INVCOMMON)
 LDIRT = $(LINKS)
-LLDLIBS = $(LIBUUID) $(LIBHANDLE) $(LIBATTR) $(LIBRMT)
+LLDLIBS = $(LIBUUID) $(LIBHANDLE) $(LIBATTR) $(LIBRMT) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBRMT)
 
 LCFLAGS = -DRESTORE
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
