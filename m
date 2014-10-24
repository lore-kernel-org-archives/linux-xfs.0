Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2865E7F5A
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 13:06:16 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 16BC68F8052
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 11:06:13 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id S1M08Pw4EDXEe65o (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 24 Oct 2014 11:06:12 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9OI6B8q024688
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 14:06:11 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.rdu2.redhat.com
	[10.11.146.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s9OI69rn012707
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 24 Oct 2014 14:06:10 -0400
Message-ID: <544A9511.70500@redhat.com>
Date: Fri, 24 Oct 2014 13:06:09 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs_io: add sync and syncfs commands
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>

There's no easy way to invoke syncfs from the commandline,
as far as I know, so add it to xfs_io to be handy.

Add sync while we're at it, just for completeness.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/configure.ac b/configure.ac
index ae17c68..bf0c205 100644
--- a/configure.ac
+++ b/configure.ac
@@ -111,6 +111,7 @@ AC_HAVE_FALLOCATE
 AC_HAVE_FIEMAP
 AC_HAVE_PREADV
 AC_HAVE_SYNC_FILE_RANGE
+AC_HAVE_SYNCFS
 AC_HAVE_BLKID_TOPO($enable_blkid)
 AC_HAVE_READDIR
 
diff --git a/include/builddefs.in b/include/builddefs.in
index 944bcf6..b8bde5f 100644
--- a/include/builddefs.in
+++ b/include/builddefs.in
@@ -103,6 +103,7 @@ HAVE_FALLOCATE = @have_fallocate@
 HAVE_FIEMAP = @have_fiemap@
 HAVE_PREADV = @have_preadv@
 HAVE_SYNC_FILE_RANGE = @have_sync_file_range@
+HAVE_SYNCFS = @have_syncfs@
 HAVE_READDIR = @have_readdir@
 
 GCCFLAGS = -funsigned-char -fno-strict-aliasing -Wall 
diff --git a/io/Makefile b/io/Makefile
index c16af87..82593a6 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -11,7 +11,7 @@ HFILES = init.h io.h
 CFILES = init.c \
 	attr.c bmap.c file.c freeze.c fsync.c getrusage.c imap.c link.c \
 	mmap.c open.c parent.c pread.c prealloc.c pwrite.c seek.c shutdown.c \
-	truncate.c
+	sync.c truncate.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
@@ -64,6 +64,10 @@ CFILES += sync_file_range.c
 LCFLAGS += -DHAVE_SYNC_FILE_RANGE
 endif
 
+ifeq ($(HAVE_SYNCFS),yes)
+LCFLAGS += -DHAVE_SYNCFS
+endif
+
 ifeq ($(ENABLE_READLINE),yes)
 LLDLIBS += $(LIBREADLINE) $(LIBTERMCAP)
 endif
diff --git a/io/init.c b/io/init.c
index bfc35bf..1b07518 100644
--- a/io/init.c
+++ b/io/init.c
@@ -80,8 +80,9 @@ init_commands(void)
 	resblks_init();
 	sendfile_init();
 	shutdown_init();
-	truncate_init();
+	sync_init();
 	sync_range_init();
+	truncate_init();
 }
 
 static int
diff --git a/io/io.h b/io/io.h
index 1b3bca1..db8b513 100644
--- a/io/io.h
+++ b/io/io.h
@@ -109,6 +109,7 @@ extern void		pwrite_init(void);
 extern void		quit_init(void);
 extern void		seek_init(void);
 extern void		shutdown_init(void);
+extern void		sync_init(void);
 extern void		truncate_init(void);
 
 #ifdef HAVE_FADVISE
diff --git a/io/sync.c b/io/sync.c
new file mode 100644
index 0000000..a6c6215
--- /dev/null
+++ b/io/sync.c
@@ -0,0 +1,70 @@
+/*
+ * Copyright (c) 2014 Red Hat, Inc.
+ * All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it would be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write the Free Software Foundation,
+ * Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+ */
+
+#include <xfs/xfs.h>
+#include <xfs/command.h>
+#include "init.h"
+#include "io.h"
+
+static cmdinfo_t sync_cmd;
+
+static int
+sync_f(
+	int			argc,
+	char			**argv)
+{
+	/* sync can't fail */
+	sync();
+	return 0;
+}
+
+#ifdef HAVE_SYNCFS
+static cmdinfo_t syncfs_cmd;
+
+static int
+syncfs_f(
+	int			argc,
+	char			**argv)
+{
+	/* syncfs can't fail */
+	syncfs(file->fd);
+	return 0;
+}
+#endif
+
+void
+sync_init(void)
+{
+	sync_cmd.name = "sync";
+	sync_cmd.cfunc = sync_f;
+	sync_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	sync_cmd.oneline =
+		_("calls sync(2) to flush all in-core filesystem state to disk");
+
+	add_command(&sync_cmd);
+
+#ifdef HAVE_SYNCFS
+	syncfs_cmd.name = "syncfs";
+	syncfs_cmd.cfunc = syncfs_f;
+	syncfs_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	syncfs_cmd.oneline =
+		_("calls syncfs(2) to flush all in-core filesystem state to disk");
+
+	add_command(&syncfs_cmd);
+#endif
+}
diff --git a/m4/package_libcdev.m4 b/m4/package_libcdev.m4
index 8267ba0..51182e4 100644
--- a/m4/package_libcdev.m4
+++ b/m4/package_libcdev.m4
@@ -171,6 +171,23 @@ AC_DEFUN([AC_HAVE_SYNC_FILE_RANGE],
   ])
 
 #
+# Check if we have a syncfs libc call (Linux)
+#
+AC_DEFUN([AC_HAVE_SYNCFS],
+  [ AC_MSG_CHECKING([for syncfs])
+    AC_TRY_LINK([
+#define _GNU_SOURCE
+#define _FILE_OFFSET_BITS 64
+#include <unistd.h>
+    ], [
+         syncfs(0);
+    ], have_syncfs=yes
+       AC_MSG_RESULT(yes),
+       AC_MSG_RESULT(no))
+    AC_SUBST(have_syncfs)
+  ])
+
+#
 # Check if we have a readdir libc call
 #
 AC_DEFUN([AC_HAVE_READDIR],
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index e40fbf9..cf27b99 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -362,6 +362,16 @@ start writeback of dirty data in the given range (SYNC_FILE_RANGE_WRITE).
 .RE
 .PD
 .TP
+.B sync
+Calls
+.BR sync (2)
+to flush all filesystems' in-core data to disk.
+.TP
+.B syncfs
+Calls
+.BR syncfs (2)
+to flush this filesystem's in-core data to disk.
+.TP
 .BI resvsp " offset length"
 Allocates reserved, unwritten space for part of a file using the
 XFS_IOC_RESVSP system call described in the

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
