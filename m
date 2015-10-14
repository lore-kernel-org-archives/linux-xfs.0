Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6C3647F37
	for <xfs@oss.sgi.com>; Wed, 14 Oct 2015 00:37:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4C3FC8F8035
	for <xfs@oss.sgi.com>; Tue, 13 Oct 2015 22:37:11 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id ff9J8fe3nuH8uhCz (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 13 Oct 2015 22:37:07 -0700 (PDT)
Date: Tue, 13 Oct 2015 22:36:56 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 03/51] xfs_io: support reflink and dedupe of file ranges
Message-ID: <20151014053656.GJ10397@birch.djwong.org>
References: <20151007050513.1504.28089.stgit@birch.djwong.org>
	<20151007050533.1504.66249.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20151007050533.1504.66249.stgit@birch.djwong.org>
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
To: david@fromorbit.com
Cc: xfs@oss.sgi.com

Wire up xfs_io to use the XFS clone-range ioctl to make files share
data blocks; or the XFS extent-same ioctl to deduplicate file blocks.

v2: Send along the operation description to the io time reporting function

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/Makefile       |    2 
 io/init.c         |    1 
 io/io.h           |    2 
 io/reflink.c      |  325 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |   59 ++++++++++
 5 files changed, 388 insertions(+), 1 deletion(-)
 create mode 100644 io/reflink.c

diff --git a/io/Makefile b/io/Makefile
index a08a782..513f8c9 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -11,7 +11,7 @@ HFILES = init.h io.h
 CFILES = init.c \
 	attr.c bmap.c file.c freeze.c fsync.c getrusage.c imap.c link.c \
 	mmap.c open.c parent.c pread.c prealloc.c pwrite.c seek.c shutdown.c \
-	sync.c truncate.c
+	sync.c truncate.c reflink.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
diff --git a/io/init.c b/io/init.c
index 13f35c4..51f1f5c 100644
--- a/io/init.c
+++ b/io/init.c
@@ -83,6 +83,7 @@ init_commands(void)
 	sync_init();
 	sync_range_init();
 	truncate_init();
+	reflink_init();
 }
 
 static int
diff --git a/io/io.h b/io/io.h
index b115e4a..172b1f8 100644
--- a/io/io.h
+++ b/io/io.h
@@ -161,3 +161,5 @@ extern void		readdir_init(void);
 #else
 #define readdir_init()		do { } while (0)
 #endif
+
+extern void		reflink_init(void);
diff --git a/io/reflink.c b/io/reflink.c
new file mode 100644
index 0000000..5ba1c93
--- /dev/null
+++ b/io/reflink.c
@@ -0,0 +1,325 @@
+/*
+ * Copyright (c) 2015 Oracle, Inc.
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
+#include <sys/uio.h>
+#include <xfs/xfs.h>
+#include "command.h"
+#include "input.h"
+#include "init.h"
+#include "io.h"
+
+static cmdinfo_t dedupe_cmd;
+static cmdinfo_t reflink_cmd;
+
+static void
+dedupe_help(void)
+{
+	printf(_("\n\
+ Links a range of bytes (in block size increments) from a file into a range\n\
+ of bytes in the open file.  The contents of both file ranges must match.\n\
+\n\
+ Example:\n\
+ 'dedupe some_file 0 4096 32768' - links 32768 bytes from some_file at\n\
+                                    offset 0 to into the open file at\n\
+                                    position 4096\n\
+\n\
+ Reflink a range of blocks from a given input file to the open file.  Both\n\
+ files share the same range of physical disk blocks; a write to the shared\n\
+ range of either file should result in the write landing in a new block and\n\
+ that range of the file being remapped (i.e. copy-on-write).  Both files\n\
+ must reside on the same filesystem, and the contents of both ranges must\n\
+ match.\n\
+"));
+}
+
+static uint64_t
+dedupe_ioctl(
+	int		fd,
+	uint64_t	soffset,
+	uint64_t	doffset,
+	uint64_t	len,
+	int		*ops)
+{
+	struct xfs_extent_data		*args;
+	struct xfs_extent_data_info	*info;
+	int				error;
+	uint64_t			deduped = 0;
+
+	args = calloc(1, sizeof(struct xfs_extent_data) +
+			 sizeof(struct xfs_extent_data_info));
+	if (!args)
+		goto done;
+	info = (struct xfs_extent_data_info *)(args + 1);
+	args->logical_offset = soffset;
+	args->length = len;
+	args->dest_count = 1;
+	info->fd = file->fd;
+	info->logical_offset = doffset;
+
+	while (args->length > 0) {
+		error = ioctl(fd, XFS_IOC_FILE_EXTENT_SAME, args);
+		if (error) {
+			perror("XFS_IOC_FILE_EXTENT_SAME");
+			goto done;
+		}
+		if (info->status < 0) {
+			printf("dedupe: %s\n", _(strerror(-info->status)));
+			goto done;
+		}
+		if (info->status == XFS_EXTENT_DATA_DIFFERS) {
+			printf(_("Extents did not match.\n"));
+			goto done;
+		}
+		if (info->bytes_deduped == 0 ||
+		    info->bytes_deduped > args->length)
+			break;
+
+		(*ops)++;
+		args->logical_offset += info->bytes_deduped;
+		info->logical_offset += info->bytes_deduped;
+		args->length -= info->bytes_deduped;
+		deduped += info->bytes_deduped;
+	}
+done:
+	free(args);
+	return deduped;
+}
+
+static int
+dedupe_f(
+	int		argc,
+	char		**argv)
+{
+	off64_t		soffset, doffset;
+	long long	count, total;
+	char		*infile;
+	int		condensed, quiet_flag;
+	size_t		fsblocksize, fssectsize;
+	struct timeval	t1, t2;
+	int		c, ops = 0, fd = -1;
+
+	condensed = quiet_flag = 0;
+	init_cvtnum(&fsblocksize, &fssectsize);
+
+	while ((c = getopt(argc, argv, "Cq")) != EOF) {
+		switch (c) {
+		case 'C':
+			condensed = 1;
+			break;
+		case 'q':
+			quiet_flag = 1;
+			break;
+		default:
+			return command_usage(&dedupe_cmd);
+		}
+	}
+	if (optind != argc - 4)
+		return command_usage(&dedupe_cmd);
+	infile = argv[optind];
+	optind++;
+	soffset = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	if (soffset < 0) {
+		printf(_("non-numeric src offset argument -- %s\n"), argv[optind]);
+		return 0;
+	}
+	optind++;
+	doffset = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	if (doffset < 0) {
+		printf(_("non-numeric dest offset argument -- %s\n"), argv[optind]);
+		return 0;
+	}
+	optind++;
+	count = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	if (count < 1) {
+		printf(_("non-positive length argument -- %s\n"), argv[optind]);
+		return 0;
+	}
+
+	fd = openfile(infile, NULL, IO_READONLY, 0);
+	if (fd < 0)
+		return 0;
+
+	gettimeofday(&t1, NULL);
+	total = dedupe_ioctl(fd, soffset, doffset, count, &ops);
+	if (ops == 0 || quiet_flag)
+		goto done;
+	gettimeofday(&t2, NULL);
+	t2 = tsub(t2, t1);
+
+	report_io_times("deduped", &t2, (long long)doffset, count, total, ops,
+			condensed);
+done:
+	close(fd);
+	return 0;
+}
+
+static void
+reflink_help(void)
+{
+	printf(_("\n\
+ Links a range of bytes (in block size increments) from a file into a range\n\
+ of bytes in the open file.  The two extent ranges need not contain identical\n\
+ data.\n\
+\n\
+ Example:\n\
+ 'reflink some_file 0 4096 32768' - links 32768 bytes from some_file at\n\
+                                    offset 0 to into the open file at\n\
+                                    position 4096\n\
+ 'reflink some_file' - links all bytes from some_file into the open file\n\
+                       at position 0\n\
+\n\
+ Reflink a range of blocks from a given input file to the open file.  Both\n\
+ files share the same range of physical disk blocks; a write to the shared\n\
+ range of either file should result in the write landing in a new block and\n\
+ that range of the file being remapped (i.e. copy-on-write).  Both files\n\
+ must reside on the same filesystem.\n\
+"));
+}
+
+static uint64_t
+reflink_ioctl(
+	int			fd,
+	uint64_t		soffset,
+	uint64_t		doffset,
+	uint64_t		len,
+	int			*ops)
+{
+	struct xfs_clone_args	args;
+	int			error;
+
+	if (len) {
+		args.src_fd = fd;
+		args.src_offset = soffset;
+		args.src_length = len;
+		args.dest_offset = doffset;
+		error = ioctl(file->fd, XFS_IOC_CLONE_RANGE, &args);
+		if (error)
+			perror("XFS_IOC_CLONE_RANGE");
+	} else {
+		error = ioctl(file->fd, XFS_IOC_CLONE, fd);
+		if (error)
+			perror("XFS_IOC_CLONE");
+	}
+	if (!error)
+		(*ops)++;
+	return error ? 0 : len;
+}
+
+static int
+reflink_f(
+	int		argc,
+	char		**argv)
+{
+	off64_t		soffset, doffset;
+	long long	count = 0, total;
+	char		*infile = NULL;
+	int		condensed, quiet_flag;
+	size_t		fsblocksize, fssectsize;
+	struct timeval	t1, t2;
+	int		c, ops = 0, fd = -1;
+
+	condensed = quiet_flag = 0;
+	doffset = soffset = 0;
+	init_cvtnum(&fsblocksize, &fssectsize);
+
+	while ((c = getopt(argc, argv, "Cq")) != EOF) {
+		switch (c) {
+		case 'C':
+			condensed = 1;
+			break;
+		case 'q':
+			quiet_flag = 1;
+			break;
+		default:
+			return command_usage(&reflink_cmd);
+		}
+	}
+	if (optind != argc - 4 && optind != argc - 1)
+		return command_usage(&reflink_cmd);
+	infile = argv[optind];
+	optind++;
+	if (optind == argc)
+		goto clone_all;
+	soffset = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	if (soffset < 0) {
+		printf(_("non-numeric src offset argument -- %s\n"), argv[optind]);
+		return 0;
+	}
+	optind++;
+	doffset = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	if (doffset < 0) {
+		printf(_("non-numeric dest offset argument -- %s\n"), argv[optind]);
+		return 0;
+	}
+	optind++;
+	count = cvtnum(fsblocksize, fssectsize, argv[optind]);
+	if (count < 1) {
+		printf(_("non-positive length argument -- %s\n"), argv[optind]);
+		return 0;
+	}
+
+clone_all:
+	fd = openfile(infile, NULL, IO_READONLY, 0);
+	if (fd < 0)
+		return 0;
+
+	gettimeofday(&t1, NULL);
+	total = reflink_ioctl(fd, soffset, doffset, count, &ops);
+	if (ops == 0 || quiet_flag)
+		goto done;
+	gettimeofday(&t2, NULL);
+	t2 = tsub(t2, t1);
+
+	report_io_times("linked", &t2, (long long)doffset, count, total, ops,
+			condensed);
+done:
+	close(fd);
+	return 0;
+}
+
+void
+reflink_init(void)
+{
+	reflink_cmd.name = "reflink";
+	reflink_cmd.altname = "rl";
+	reflink_cmd.cfunc = reflink_f;
+	reflink_cmd.argmin = 4;
+	reflink_cmd.argmax = -1;
+	reflink_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	reflink_cmd.args =
+_("infile src_off dst_off len");
+	reflink_cmd.oneline =
+		_("reflinks a number of bytes at a specified offset");
+	reflink_cmd.help = reflink_help;
+
+	add_command(&reflink_cmd);
+
+	dedupe_cmd.name = "dedupe";
+	dedupe_cmd.altname = "dd";
+	dedupe_cmd.cfunc = dedupe_f;
+	dedupe_cmd.argmin = 4;
+	dedupe_cmd.argmax = -1;
+	dedupe_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	dedupe_cmd.args =
+_("infile src_off dst_off len");
+	dedupe_cmd.oneline =
+		_("dedupes a number of bytes at a specified offset");
+	dedupe_cmd.help = dedupe_help;
+
+	add_command(&dedupe_cmd);
+}
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 416206f..e0a901f 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -490,6 +490,65 @@ Recursively display all the specified segments starting at the specified
 .B \-s
 Display the starting lseek(2) offset. This offset will be a calculated value when
 both data and holes are displayed together or performing a recusively display.
+.RE
+.PD
+.TP
+.TP
+.BI "reflink  [ \-C ] [ \-q ] src_file [src_offset dst_offset length]"
+On filesystems that support the
+.B XFS_IOC_CLONE_RANGE
+or
+.B BTRFS_IOC_CLONE_RANGE
+ioctls, map
+.I length
+bytes at offset
+.I dst_offset
+in the open file to the same physical blocks that are mapped at offset
+.I src_offset
+in the file
+.I src_file
+, replacing any contents that may already have been there.  If a program
+writes into a reflinked block range of either file, the dirty blocks will be
+cloned, written to, and remapped ("copy on write") in the affected file,
+leaving the other file(s) unchanged.  If src_offset, dst_offset, and length
+are omitted, all contents of src_file will be reflinked into the open file.
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-C
+Print timing statistics in a condensed format.
+.TP
+.B \-q
+Do not print timing statistics at all.
+.RE
+.PD
+.TP
+.TP
+.BI "dedupe  [ \-C ] [ \-q ] src_file src_offset dst_offset length"
+On filesystems that support the
+.B XFS_IOC_FILE_EXTENT_SAME
+or
+.B BTRFS_IOC_FILE_EXTENT_SAME
+ioctls, map
+.I length
+bytes at offset
+.I dst_offset
+in the open file to the same physical blocks that are mapped at offset
+.I src_offset
+in the file
+.I src_file
+, but only if the contents of both ranges are identical.  This is known as
+block-based deduplication.  If a program writes into a reflinked block range of
+either file, the dirty blocks will be cloned, written to, and remapped ("copy
+on write") in the affected file, leaving the other file(s) unchanged.
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-C
+Print timing statistics in a condensed format.
+.TP
+.B \-q
+Do not print timing statistics at all.
 .TP
 
 .SH MEMORY MAPPED I/O COMMANDS

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
