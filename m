Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 23:09:55 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4M69jL3018053
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 23:09:47 -0700
Date: Thu, 22 May 2008 16:10:29 +1000
From: David Chinner <dgc@sgi.com>
Subject: [patch] rudimetary fallocate support for xfs_io
Message-ID: <20080522061029.GO173056135@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Rudimentary fallocate support for xfs_io. Supports the two
known methods that fallocate currently implements. When glibc
support for the syscall comes around this should be changed
to use that interface.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 xfsprogs/io/prealloc.c |   82 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

Index: xfs-cmds/xfsprogs/io/prealloc.c
===================================================================
--- xfs-cmds.orig/xfsprogs/io/prealloc.c	2007-10-30 15:00:49.338718381 +1100
+++ xfs-cmds/xfsprogs/io/prealloc.c	2007-11-08 11:45:56.538926493 +1100
@@ -26,6 +26,8 @@ static cmdinfo_t allocsp_cmd;
 static cmdinfo_t freesp_cmd;
 static cmdinfo_t resvsp_cmd;
 static cmdinfo_t unresvsp_cmd;
+static cmdinfo_t falloc_allocsp_cmd;
+static cmdinfo_t falloc_resvsp_cmd;
 
 static int
 offset_length(
@@ -119,6 +121,66 @@ unresvsp_f(
 	return 0;
 }
 
+/*
+ * someday there'll be a real header file in user space.
+ * (kernel is include/linux/falloc.h). In the mean time....
+ */
+#define FALLOC_FL_KEEP_SIZE     0x01
+#define FALLOC_ALLOCATE         0x0
+#define FALLOC_RESV_SPACE       FALLOC_FL_KEEP_SIZE
+
+#if defined(__i386__)
+#define __NR_fallocate	324
+#elif defined(__x86_64__)
+#define __NR_fallocate	285
+#elif defined(__ia64__)
+#define __NR_fallocate	1303
+#endif
+
+static int
+fallocate(int fd, int cmd, off64_t start, off64_t len)
+{
+	return syscall(__NR_fallocate, fd, cmd, start, len);
+}
+
+static int
+fallocate_allocsp_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_flock64_t	segment;
+
+	if (!offset_length(argv[1], argv[2], &segment))
+		return 0;
+
+	/* syscall(__NR_fallocate, ...) */
+	if (fallocate(file->fd, FALLOC_ALLOCATE,
+			segment.l_start, segment.l_len)) {
+		perror("FALLOC_ALLOCATE");
+		return 0;
+	}
+	return 0;
+}
+
+static int
+fallocate_resvsp_f(
+	int		argc,
+	char		**argv)
+{
+	xfs_flock64_t	segment;
+
+	if (!offset_length(argv[1], argv[2], &segment))
+		return 0;
+
+	/* syscall(__NR_fallocate, ...) */
+	if (fallocate(file->fd, FALLOC_RESV_SPACE,
+			segment.l_start, segment.l_len)) {
+		perror("FALLOC_RESVSP");
+		return 0;
+	}
+	return 0;
+}
+
 void
 prealloc_init(void)
 {
@@ -156,8 +218,28 @@ prealloc_init(void)
 	unresvsp_cmd.oneline =
 		_("frees reserved space associated with part of a file");
 
+	falloc_allocsp_cmd.name = _("falloc_allocsp");
+	falloc_allocsp_cmd.cfunc = fallocate_allocsp_f;
+	falloc_allocsp_cmd.argmin = 2;
+	falloc_allocsp_cmd.argmax = 2;
+	falloc_allocsp_cmd.flags = CMD_NOMAP_OK;
+	falloc_allocsp_cmd.args = _("off len");
+	falloc_allocsp_cmd.oneline =
+		_("allocates space associated with part of a file via fallocate");
+
+	falloc_resvsp_cmd.name = _("falloc_resvsp");
+	falloc_resvsp_cmd.cfunc = fallocate_resvsp_f;
+	falloc_resvsp_cmd.argmin = 2;
+	falloc_resvsp_cmd.argmax = 2;
+	falloc_resvsp_cmd.flags = CMD_NOMAP_OK;
+	falloc_resvsp_cmd.args = _("off len");
+	falloc_resvsp_cmd.oneline =
+		_("reserves space associated with part of a file via fallocate");
+
 	add_command(&allocsp_cmd);
 	add_command(&freesp_cmd);
 	add_command(&resvsp_cmd);
 	add_command(&unresvsp_cmd);
+	add_command(&falloc_allocsp_cmd);
+	add_command(&falloc_resvsp_cmd);
 }
