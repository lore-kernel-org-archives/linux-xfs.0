Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9A3chmr181124 for <xfs@oss.sgi.com>; Tue, 9 Oct 2012 22:38:43 -0500
Received: from mail.sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com
	with ESMTP id qG42eUErwHjbHeQf for <xfs@oss.sgi.com>;
	Tue, 09 Oct 2012 20:40:10 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested) (Authenticated sender: sandeen)
	by mail.sandeen.net (Postfix) with ESMTP id 48C324964603
	for <xfs@oss.sgi.com>; Tue,  9 Oct 2012 22:40:10 -0500 (CDT)
Message-ID: <5074EE1B.3090600@sandeen.net>
Date: Tue, 09 Oct 2012 22:40:11 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 2/2 V2] xfs_io: configure tests for preadv/pwritev &
	sync_file_range
References: <50749EE2.6070408@redhat.com> <5074A05A.6000709@sandeen.net>
In-Reply-To: <5074A05A.6000709@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

On older systems we may not have preadv/pwritev and/or
sync_file_range.

Add the configure magic, and stub out the code
where needed.

(sync_file_range just needed a better test; preadv/pwritev
took a little more rearranging)

And fix a couple typos ("numberic") while we're at it.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

V2: add -DHAVE_PWRITEV and use that test in io/pwrite.c
rather than HAVE_PREADV

diff --git a/configure.in b/configure.in
index 664c0e9..b927c32 100644
--- a/configure.in
+++ b/configure.in
@@ -108,6 +108,8 @@ AC_HAVE_GETMNTENT
 AC_HAVE_GETMNTINFO
 AC_HAVE_FALLOCATE
 AC_HAVE_FIEMAP
+AC_HAVE_PREADV
+AC_HAVE_SYNC_FILE_RANGE
 AC_HAVE_BLKID_TOPO($enable_blkid)
 
 AC_TYPE_PSINT
diff --git a/include/builddefs.in b/include/builddefs.in
index 04590d2..0a3fa1a 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -101,6 +101,8 @@ HAVE_GETMNTENT = @have_getmntent@
 HAVE_GETMNTINFO = @have_getmntinfo@
 HAVE_FALLOCATE = @have_fallocate@
 HAVE_FIEMAP = @have_fiemap@
+HAVE_PREADV = @have_preadv@
+HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/io/Makefile b/io/Makefile
index bf46d56..50edf91 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -58,7 +58,7 @@ CFILES += inject.c resblks.c
 LCFLAGS += -DHAVE_INJECT -DHAVE_RESBLKS
 endif
 
-ifeq ($(PKG_PLATFORM),linux)
+ifeq ($(HAVE_SYNC_FILE_RANGE),yes)
 CFILES += sync_file_range.c
 LCFLAGS += -DHAVE_SYNC_FILE_RANGE
 endif
@@ -75,6 +75,11 @@ ifeq ($(HAVE_FALLOCATE),yes)
 LCFLAGS += -DHAVE_FALLOCATE
 endif
 
+# Also implies PWRITEV
+ifeq ($(HAVE_PREADV),yes)
+LCFLAGS += -DHAVE_PREADV -DHAVE_PWRITEV
+endif
+
 default: depend $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/io/pread.c b/io/pread.c
index 7e2ed7d..a42baed 100644
--- a/io/pread.c
+++ b/io/pread.c
@@ -47,7 +47,9 @@ pread_help(void)
 " -R   -- read at random offsets in the range of bytes\n"
 " -Z N -- zeed the random number generator (used when reading randomly)\n"
 "         (heh, zorry, the -s/-S arguments were already in use in pwrite)\n"
+#ifdef HAVE_PREADV
 " -V N -- use vectored IO with N iovecs of blocksize each (preadv)\n"
+#endif
 "\n"
 " When in \"random\" mode, the number of read operations will equal the\n"
 " number required to do a complete forward/backward scan of the range.\n"
@@ -168,8 +170,9 @@ dump_buffer(
 	}
 }
 
+#ifdef HAVE_PREADV
 static int
-do_pread(
+do_preadv(
 	int		fd,
 	off64_t		offset,
 	ssize_t		count,
@@ -179,10 +182,6 @@ do_pread(
 	ssize_t		oldlen = 0;
 	ssize_t		bytes = 0;
 
-
-	if (!vectors)
-		return pread64(fd, buffer, min(count, buffer_size), offset);
-
 	/* trim the iovec if necessary */
 	if (count < buffersize) {
 		size_t	len = 0;
@@ -204,6 +203,22 @@ do_pread(
 
 	return bytes;
 }
+#else
+#define do_preadv(fd, offset, count, buffer_size) (0)
+#endif
+
+static int
+do_pread(
+	int		fd,
+	off64_t		offset,
+	ssize_t		count,
+	ssize_t		buffer_size)
+{
+	if (!vectors)
+		return pread64(fd, buffer, min(count, buffer_size), offset);
+
+	return do_preadv(fd, offset, count, buffer_size);
+}
 
 static int
 read_random(
@@ -406,14 +421,16 @@ pread_f(
 		case 'v':
 			vflag = 1;
 			break;
+#ifdef HAVE_PREADV
 		case 'V':
 			vectors = strtoul(optarg, &sp, 0);
 			if (!sp || sp == optarg) {
-				printf(_("non-numberic vector count == %s\n"),
+				printf(_("non-numeric vector count == %s\n"),
 					optarg);
 				return 0;
 			}
 			break;
+#endif
 		case 'Z':
 			zeed = strtoul(optarg, &sp, 0);
 			if (!sp || sp == optarg) {
diff --git a/io/pwrite.c b/io/pwrite.c
index 73acbac..a2f0a81 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -51,24 +51,23 @@ pwrite_help(void)
 " -R   -- write at random offsets in the specified range of bytes\n"
 " -Z N -- zeed the random number generator (used when writing randomly)\n"
 "         (heh, zorry, the -s/-S arguments were already in use in pwrite)\n"
+#ifdef HAVE_PWRITEV
 " -V N -- use vectored IO with N iovecs of blocksize each (pwritev)\n"
+#endif
 "\n"));
 }
 
+#ifdef HAVE_PWRITEV
 static int
-do_pwrite(
+do_pwritev(
 	int		fd,
 	off64_t		offset,
 	ssize_t		count,
 	ssize_t		buffer_size)
 {
-	int		vecs = 0;
-	ssize_t		oldlen = 0;
-	ssize_t		bytes = 0;
-
-
-	if (!vectors)
-		return pwrite64(fd, buffer, min(count, buffer_size), offset);
+	int vecs = 0;
+	ssize_t oldlen = 0;
+	ssize_t bytes = 0;
 
 	/* trim the iovec if necessary */
 	if (count < buffersize) {
@@ -91,6 +90,23 @@ do_pwrite(
 
 	return bytes;
 }
+#else
+#define do_pwritev(fd, offset, count, buffer_size) (0)
+#endif
+
+static int
+do_pwrite(
+	int		fd,
+	off64_t		offset,
+	ssize_t		count,
+	ssize_t		buffer_size)
+{
+	if (!vectors)
+		return pwrite64(fd, buffer, min(count, buffer_size), offset);
+
+	return do_pwritev(fd, offset, count, buffer_size);
+}
+
 static int
 write_random(
 	off64_t		offset,
@@ -297,7 +313,7 @@ pwrite_f(
 		case 'V':
 			vectors = strtoul(optarg, &sp, 0);
 			if (!sp || sp == optarg) {
-				printf(_("non-numberic vector count == %s\n"),
+				printf(_("non-numeric vector count == %s\n"),
 					optarg);
 				return 0;
 			}
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 1e2c256..f489f52 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -135,3 +135,38 @@ AC_DEFUN([AC_HAVE_FIEMAP],
        AC_MSG_RESULT(no))
     AC_SUBST(have_fiemap)
   ])
+
+#
+# Check if we have a preadv libc call (Linux)
+#
+AC_DEFUN([AC_HAVE_PREADV],
+  [ AC_MSG_CHECKING([for preadv])
+    AC_TRY_LINK([
+#define _FILE_OFFSET_BITS 64
+#define _BSD_SOURCE
+#include <sys/uio.h>
+    ], [
+         preadv(0, 0, 0, 0);
+    ], have_preadv=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_preadv)
+  ])
+
+#
+# Check if we have a sync_file_range libc call (Linux)
+#
+AC_DEFUN([AC_HAVE_SYNC_FILE_RANGE],
+  [ AC_MSG_CHECKING([for sync_file_range])
+    AC_TRY_LINK([
+#define _GNU_SOURCE
+#define _FILE_OFFSET_BITS 64
+#include <fcntl.h>
+    ], [
+         sync_file_range(0, 0, 0, 0);
+    ], have_sync_file_range=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_sync_file_range)
+  ])
+


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
