Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50126 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754408AbdDFSsv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 14:48:51 -0400
Subject: [PATCH 2/3] xfs_io: refactor stat functions, add raw dump
References: <4bb89f72-962d-a9a2-c224-daa828558444@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <c93e8f2d-8164-c56c-e3a3-6f3b8fa43f99@sandeen.net>
Date: Thu, 6 Apr 2017 13:48:50 -0500
MIME-Version: 1.0
In-Reply-To: <4bb89f72-962d-a9a2-c224-daa828558444@sandeen.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>, fsdevel <linux-fsdevel@vger.kernel.org>, David Howells <dhowells@redhat.com>

This adds a "-r" raw structure dump to stat options, and
factors the code a bit; statx will also use print_file_info
and print_xfs_info.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/io/stat.c b/io/stat.c
index 3ae9903..770f3c7 100644
--- a/io/stat.c
+++ b/io/stat.c
@@ -59,16 +59,32 @@ filetype(mode_t mode)
 	return NULL;
 }
 
-int
-stat_f(
-	int		argc,
-	char		**argv)
+static int
+dump_raw_stat(struct stat *st)
 {
-	struct dioattr	dio;
-	struct fsxattr	fsx, fsxa;
-	struct stat	st;
-	int		verbose = (argc == 2 && !strcmp(argv[1], "-v"));
+	printf("stat.blksize = %lu\n", st->st_blksize);
+	printf("stat.nlink = %lu\n", st->st_nlink);
+	printf("stat.uid = %u\n", st->st_uid);
+	printf("stat.gid = %u\n", st->st_gid);
+	printf("stat.mode: 0%o\n", st->st_mode);
+	printf("stat.ino = %lu\n", st->st_ino);
+	printf("stat.size = %lu\n", st->st_size);
+	printf("stat.blocks = %lu\n", st->st_blocks);
+	printf("stat.atime.tv_sec = %ld\n", st->st_atim.tv_sec);
+	printf("stat.atime.tv_nsec = %ld\n", st->st_atim.tv_nsec);
+	printf("stat.ctime.tv_sec = %ld\n", st->st_ctim.tv_sec);
+	printf("stat.ctime.tv_nsec = %ld\n", st->st_ctim.tv_nsec);
+	printf("stat.mtime.tv_sec = %ld\n", st->st_mtim.tv_sec);
+	printf("stat.mtime.tv_nsec = %ld\n", st->st_mtim.tv_nsec);
+	printf("stat.rdev_major = %u\n", major(st->st_rdev));
+	printf("stat.rdev_minor = %u\n", minor(st->st_rdev));
+	printf("stat.dev_major = %u\n", major(st->st_dev));
+	printf("stat.dev_minor = %u\n", minor(st->st_dev));
+	return 0;
+}
 
+void print_file_info(void)
+{
 	printf(_("fd.path = \"%s\"\n"), file->name);
 	printf(_("fd.flags = %s,%s,%s%s%s%s%s\n"),
 		file->flags & IO_OSYNC ? _("sync") : _("non-sync"),
@@ -78,21 +94,13 @@ stat_f(
 		file->flags & IO_APPEND ? _(",append-only") : "",
 		file->flags & IO_NONBLOCK ? _(",non-block") : "",
 		file->flags & IO_TMPFILE ? _(",tmpfile") : "");
-	if (fstat(file->fd, &st) < 0) {
-		perror("fstat");
-	} else {
-		printf(_("stat.ino = %lld\n"), (long long)st.st_ino);
-		printf(_("stat.type = %s\n"), filetype(st.st_mode));
-		printf(_("stat.size = %lld\n"), (long long)st.st_size);
-		printf(_("stat.blocks = %lld\n"), (long long)st.st_blocks);
-		if (verbose) {
-			printf(_("stat.atime = %s"), ctime(&st.st_atime));
-			printf(_("stat.mtime = %s"), ctime(&st.st_mtime));
-			printf(_("stat.ctime = %s"), ctime(&st.st_ctime));
-		}
-	}
-	if (file->flags & IO_FOREIGN)
-		return 0;
+}
+
+void print_xfs_info(int verbose)
+{
+	struct dioattr	dio;
+	struct fsxattr	fsx, fsxa;
+
 	if ((xfsctl(file->name, file->fd, FS_IOC_FSGETXATTR, &fsx)) < 0 ||
 	    (xfsctl(file->name, file->fd, XFS_IOC_FSGETXATTRA, &fsxa)) < 0) {
 		perror("FS_IOC_FSGETXATTR");
@@ -112,6 +120,57 @@ stat_f(
 		printf(_("dioattr.miniosz = %u\n"), dio.d_miniosz);
 		printf(_("dioattr.maxiosz = %u\n"), dio.d_maxiosz);
 	}
+}
+
+int
+stat_f(
+	int		argc,
+	char		**argv)
+{
+	struct stat	st;
+	int		c, verbose = 0, raw = 0;
+
+	while ((c = getopt(argc, argv, "rv")) != EOF) {
+		switch (c) {
+		case 'r':
+			raw = 1;
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		default:
+			return command_usage(&stat_cmd);
+		}
+	}
+
+	if (raw && verbose)
+		return command_usage(&stat_cmd);
+
+	if (fstat(file->fd, &st) < 0) {
+		perror("fstat");
+		return 0;
+	}
+
+	if (raw)
+		return dump_raw_stat(&st);
+
+	print_file_info();
+
+	printf(_("stat.ino = %lld\n"), (long long)st.st_ino);
+	printf(_("stat.type = %s\n"), filetype(st.st_mode));
+	printf(_("stat.size = %lld\n"), (long long)st.st_size);
+	printf(_("stat.blocks = %lld\n"), (long long)st.st_blocks);
+	if (verbose) {
+		printf(_("stat.atime = %s"), ctime(&st.st_atime));
+		printf(_("stat.mtime = %s"), ctime(&st.st_mtime));
+		printf(_("stat.ctime = %s"), ctime(&st.st_ctime));
+	}
+
+	if (file->flags & IO_FOREIGN)
+		return 0;
+
+	print_xfs_info(verbose);
+
 	return 0;
 }
 
@@ -175,7 +234,7 @@ stat_init(void)
 	stat_cmd.argmin = 0;
 	stat_cmd.argmax = 1;
 	stat_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
-	stat_cmd.args = _("[-v]");
+	stat_cmd.args = _("[-v|-r]");
 	stat_cmd.oneline = _("statistics on the currently open file");
 
 	statfs_cmd.name = "statfs";
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 19e1ae4..e384327 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -872,13 +872,15 @@ Only available in expert mode and requires privileges.
 Force the filesystem to shutdown (with or without flushing the log).
 Only available in expert mode and requires privileges.
 .TP
-.BR stat " [ " \-v " ]"
+.BR stat " [ " \-v "|" \-r " ]"
 Selected statistics from
 .BR stat (2)
 and the XFS_IOC_GETXATTR system call on the current file. If the
 .B \-v
 option is specified, the atime (last access), mtime
-(last modify), and ctime (last change) timestamps are also displayed.
+(last modify), and ctime (last change) timestamps are also displayed.  The
+.B \-r
+option dumps raw fields from the stat structure.
 .TP
 .B statfs
 Selected statistics from


