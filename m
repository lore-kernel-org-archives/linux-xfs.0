Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4B0UAhm208685 for <xfs@oss.sgi.com>; Sun, 10 May 2009 19:30:10 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7CE7A2769B7
	for <xfs@oss.sgi.com>; Sun, 10 May 2009 17:30:14 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id y3JKQFW7JJNMlgoc for
	<xfs@oss.sgi.com>; Sun, 10 May 2009 17:30:14 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id 1C870A9B0C8
	for <xfs@oss.sgi.com>; Sun, 10 May 2009 19:30:14 -0500 (CDT)
Message-ID: <4A077195.3070708@sandeen.net>
Date: Sun, 10 May 2009 19:30:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs:  add fallocate command to xfs_io
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

Based on Dave's earlier patch, but now we have an fallocate
glibc call... this also adds autoconf magic and a manpage 
update.

(hopefully not too #ifdef-heavy....)

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---


diff --git a/configure.in b/configure.in
index 3fbd44e..8f5782a 100644
--- a/configure.in
+++ b/configure.in
@@ -66,6 +66,7 @@ AC_HAVE_MINCORE
 AC_HAVE_SENDFILE
 AC_HAVE_GETMNTENT
 AC_HAVE_GETMNTINFO
+AC_HAVE_FALLOCATE
 
 AC_TYPE_PSINT
 AC_TYPE_PSUNSIGNED
diff --git a/include/builddefs.in b/include/builddefs.in
index c8f5c08..d6bf5c0 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -94,6 +94,7 @@ HAVE_MINCORE = @have_mincore@
 HAVE_SENDFILE = @have_sendfile@
 HAVE_GETMNTENT = @have_getmntent@
 HAVE_GETMNTINFO = @have_getmntinfo@
+HAVE_FALLOCATE = @have_fallocate@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
 #	   -Wbitwise -Wno-transparent-union -Wno-old-initializer -Wno-decl
diff --git a/io/Makefile b/io/Makefile
index 6f10e8d..1a51879 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -59,6 +59,10 @@ ifeq ($(ENABLE_EDITLINE),yes)
 LLDLIBS += $(LIBEDITLINE) $(LIBTERMCAP)
 endif
 
+ifeq ($(HAVE_FALLOCATE),yes)
+LCFLAGS += -DHAVE_FALLOCATE
+endif
+
 default: $(LTCOMMAND)
 
 include $(BUILDRULES)
diff --git a/io/prealloc.c b/io/prealloc.c
index 6a2563e..7d9bd2f 100644
--- a/io/prealloc.c
+++ b/io/prealloc.c
@@ -16,6 +16,9 @@
  * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
  */
 
+#if defined(HAVE_FALLOCATE)
+#include <linux/falloc.h>
+#endif
 #include <xfs/xfs.h>
 #include <xfs/command.h>
 #include <xfs/input.h>
@@ -26,6 +29,9 @@ static cmdinfo_t allocsp_cmd;
 static cmdinfo_t freesp_cmd;
 static cmdinfo_t resvsp_cmd;
 static cmdinfo_t unresvsp_cmd;
+#if defined(HAVE_FALLOCATE)
+static cmdinfo_t falloc_cmd;
+#endif
 
 static int
 offset_length(
@@ -119,6 +125,40 @@ unresvsp_f(
 	return 0;
 }
 
+#if defined (HAVE_FALLOCATE)
+static int
+fallocate_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_flock64_t	segment;
+	int		mode = 0;
+	int		c;
+
+	while ((c = getopt(argc, argv, "k")) != EOF) {
+		switch (c) {
+		case 'k':
+			mode = FALLOC_FL_KEEP_SIZE;
+			break;
+		default:
+			command_usage(&falloc_cmd);
+		}
+	}
+        if (optind != argc - 2)
+                return command_usage(&falloc_cmd);
+
+	if (!offset_length(argv[optind], argv[optind+1], &segment))
+		return 0;
+
+	if (fallocate(file->fd, mode,
+			segment.l_start, segment.l_len)) {
+		perror("fallocate");
+		return 0;
+	}
+	return 0;
+}
+#endif
+
 void
 prealloc_init(void)
 {
@@ -160,4 +200,17 @@ prealloc_init(void)
 	add_command(&freesp_cmd);
 	add_command(&resvsp_cmd);
 	add_command(&unresvsp_cmd);
+
+#if defined (HAVE_FALLOCATE)
+	falloc_cmd.name = _("falloc");
+	falloc_cmd.cfunc = fallocate_f;
+	falloc_cmd.argmin = 2;
+	falloc_cmd.argmax = -1;
+	falloc_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	falloc_cmd.args = _("[-k] off len");
+	falloc_cmd.oneline =
+		_("allocates space associated with part of a file via fallocate");
+
+	add_command(&falloc_cmd);
+#endif
 }
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 5156ced..856794a 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -98,3 +98,18 @@ AC_DEFUN([AC_HAVE_GETMNTINFO],
        AC_MSG_RESULT(no))
     AC_SUBST(have_getmntinfo)
   ])
+
+#
+# Check if we have a fallocate libc call (Linux)
+#
+AC_DEFUN([AC_HAVE_FALLOCATE],
+  [ AC_MSG_CHECKING([for fallocate])
+    AC_TRY_COMPILE([
+#include <linux/falloc.h>
+    ], [
+         fallocate(0, 0, 0, 0);
+    ], have_fallocate=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_fallocate)
+  ])
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 23bef94..6fc6bad 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -295,6 +295,20 @@ system call described in the
 .BR xfsctl (3)
 manual page.
 .TP
+.BI "falloc [ \-k ]" " offset length"
+Allocates reserved, unwritten space for part of a file using the
+fallocate routine as described in the
+.BR fallocate (3)
+manual page.
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-k
+will set the FALLOC_FL_KEEP_SIZE flag as described in
+.BR fallocate (3).
+.PD
+.RE
+.TP
 .BI truncate " offset"
 Truncates the current file at the given offset using
 .BR ftruncate (2).

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
