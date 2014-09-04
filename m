Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 304B67F37
	for <xfs@oss.sgi.com>; Thu,  4 Sep 2014 11:38:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1090B304059
	for <xfs@oss.sgi.com>; Thu,  4 Sep 2014 09:38:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 0xlNVTymWtqfDNyW (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 04 Sep 2014 09:38:30 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s84GcUS5018753
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 4 Sep 2014 12:38:30 -0400
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s84GcTFO032524
	for <xfs@oss.sgi.com>; Thu, 4 Sep 2014 12:38:29 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfsrestore: use utimensat() to provide atime/mtime with ns
	resolution
Date: Thu,  4 Sep 2014 12:38:28 -0400
Message-Id: <1409848708-42666-1-git-send-email-bfoster@redhat.com>
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

xfsdump encodes and stores the full atime and mtime for each file with
nanosecond resolution. xfsrestore uses utime() to set the times of each
file that is restored. The latter supports resolution of 1 second, thus
sub-second timestamp data is lost on restore.

Add the associated configure checks for and use utimensat() when
available to restore timestamps with nanosecond resolution. Create a new
helper to facilitate conditional support for utimensat().

Signed-off-by: Brian Foster <bfoster@redhat.com>
---

I'm not totally sure on the configure bits here... it's mostly copied
from xfsprogs and tweaked appropriately. It seems to work, at least. ;)

Brian

 configure.ac          |  2 ++
 include/builddefs.in  |  1 +
 m4/Makefile           |  1 +
 m4/package_libcdev.m4 | 16 ++++++++++++++++
 restore/Makefile      |  4 ++++
 restore/content.c     | 38 ++++++++++++++++++++++++++++++--------
 6 files changed, 54 insertions(+), 8 deletions(-)
 create mode 100644 m4/package_libcdev.m4

diff --git a/configure.ac b/configure.ac
index 59f9564..28e604e 100644
--- a/configure.ac
+++ b/configure.ac
@@ -82,6 +82,8 @@ AC_PACKAGE_NEED_ATTRIBUTES_H
 AC_PACKAGE_NEED_ATTRIBUTES_MACROS
 AC_PACKAGE_NEED_ATTRGET_LIBATTR
 
+AC_HAVE_UTIMENSAT
+
 AC_MANUAL_FORMAT
 
 AC_CONFIG_FILES([include/builddefs])
diff --git a/include/builddefs.in b/include/builddefs.in
index 269c928..bdf0ede 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -69,6 +69,7 @@ ENABLE_SHARED	= @enable_shared@
 ENABLE_GETTEXT	= @enable_gettext@
 
 HAVE_ZIPPED_MANPAGES = @have_zipped_manpages@
+HAVE_UTIMENSAT = @have_utimensat@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/m4/Makefile b/m4/Makefile
index 9a35056..ae452f7 100644
--- a/m4/Makefile
+++ b/m4/Makefile
@@ -16,6 +16,7 @@ LSRCFILES = \
 	manual_format.m4 \
 	package_attrdev.m4 \
 	package_globals.m4 \
+	package_libcdev.m4 \
 	package_ncurses.m4 \
 	package_pthread.m4 \
 	package_utilies.m4 \
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
new file mode 100644
index 0000000..6fcbdba
--- /dev/null
+++ b/m4/package_libcdev.m4
@@ -0,0 +1,16 @@
+#
+# Check if we have a utimensat libc call
+#
+AC_DEFUN([AC_HAVE_UTIMENSAT],
+  [ AC_MSG_CHECKING([for utimensat])
+    AC_TRY_COMPILE([
+#define _ATFILE_SOURCE
+#include <fcntl.h>
+#include <sys/stat.h>
+    ], [
+         utimensat(AT_FDCWD, 0, 0, AT_SYMLINK_NOFOLLOW);
+    ], have_utimensat=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_utimensat)
+  ])
diff --git a/restore/Makefile b/restore/Makefile
index c6f3f25..c5cf925 100644
--- a/restore/Makefile
+++ b/restore/Makefile
@@ -102,6 +102,10 @@ LTDEPENDENCIES = $(LIBRMT)
 
 LCFLAGS = -DRESTORE
 
+ifeq ($(HAVE_UTIMENSAT),yes)
+LCFLAGS += -DHAVE_UTIMENSAT
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/restore/content.c b/restore/content.c
index cfcf94d..65dc2f5 100644
--- a/restore/content.c
+++ b/restore/content.c
@@ -7418,6 +7418,34 @@ done:
 	return 0;
 }
 
+/*
+ * Set the access and modification times for a file.
+ */
+static int
+restore_file_amtime(
+	const char	*path,
+	struct bstat	*bstatp)
+{
+	int rval;
+
+#ifdef HAVE_UTIMENSAT
+	struct timespec times[2];
+
+	times[0].tv_sec = bstatp->bs_atime.tv_sec;
+	times[0].tv_nsec = bstatp->bs_atime.tv_nsec;
+	times[1].tv_sec = bstatp->bs_mtime.tv_sec;
+	times[1].tv_nsec = bstatp->bs_mtime.tv_nsec;
+	rval = utimensat(AT_FDCWD, path, times, 0);
+#else
+	struct utimbuf utimbuf;
+
+	utimbuf.actime = ( time32_t )bstatp->bs_atime.tv_sec;
+	utimbuf.modtime = ( time32_t )bstatp->bs_mtime.tv_sec;
+	rval = utime(path, &utimbuf);
+#endif
+	return rval;
+}
+
 /* called to begin a regular file. if no path given, or if just toc,
  * don't actually write, just read. also get into that situation if
  * cannot prepare destination. fd == -1 signifies no write. *statp
@@ -7671,7 +7699,6 @@ restore_complete_reg(stream_context_t *strcxtp)
 	bstat_t *bstatp = &strcxtp->sc_bstat;
 	char *path = strcxtp->sc_path;
 	intgen_t fd = strcxtp->sc_fd;
-	struct utimbuf utimbuf;
 	intgen_t rval;
 
 	// only applies to regular files
@@ -7688,9 +7715,7 @@ restore_complete_reg(stream_context_t *strcxtp)
 
 	/* set the access and modification times
 	 */
-	utimbuf.actime = ( time32_t )bstatp->bs_atime.tv_sec;
-	utimbuf.modtime = ( time32_t )bstatp->bs_mtime.tv_sec;
-	rval = utime( path, &utimbuf );
+	rval = restore_file_amtime(path, bstatp);
 	if ( rval ) {
 		mlog( MLOG_VERBOSE | MLOG_WARNING, _(
 		      "unable to set access and modification "
@@ -7770,7 +7795,6 @@ static bool_t
 restore_spec( filehdr_t *fhdrp, rv_t *rvp, char *path )
 {
 	bstat_t *bstatp = &fhdrp->fh_stat;
-	struct utimbuf utimbuf;
 	char *printstr;
 	intgen_t rval;
 
@@ -7913,9 +7937,7 @@ restore_spec( filehdr_t *fhdrp, rv_t *rvp, char *path )
 
 		/* set the access and modification times
 		 */
-		utimbuf.actime = ( time32_t )bstatp->bs_atime.tv_sec;
-		utimbuf.modtime = ( time32_t )bstatp->bs_mtime.tv_sec;
-		rval = utime( path, &utimbuf );
+		rval = restore_file_amtime(path, bstatp);
 		if ( rval ) {
 			mlog( MLOG_VERBOSE | MLOG_WARNING, _(
 			      "unable to set access and modification "
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
