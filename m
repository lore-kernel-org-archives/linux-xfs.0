Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 657097F84
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 22:26:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 522FB304043
	for <xfs@oss.sgi.com>; Mon, 29 Jun 2015 20:25:59 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 2s44gmTcWeSIjugy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 29 Jun 2015 20:25:55 -0700 (PDT)
Subject: [PATCH 01/15] xfs_io: support reflinking and deduping file ranges
From: "Darrick J. Wong" <djwong@alder.djwong.org>
Date: Mon, 29 Jun 2015 20:25:45 -0700
Message-ID: <20150630032545.572.17097.stgit@birch.djwong.org>
In-Reply-To: <20150630032538.572.20293.stgit@birch.djwong.org>
References: <20150630032538.572.20293.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Wire up xfs_io to use the XFS range clone and dedupe ioctls to make
files share data blocks.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 io/Makefile       |    2 -
 io/dedupe.c       |  190 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 io/init.c         |    2 +
 io/io.h           |    3 +
 io/reflink.c      |  180 ++++++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/xfs_fs.h   |   36 ++++++++++
 man/man8/xfs_io.8 |   67 +++++++++++++++++++
 7 files changed, 479 insertions(+), 1 deletion(-)
 create mode 100644 io/dedupe.c
 create mode 100644 io/reflink.c


diff --git a/io/Makefile b/io/Makefile
index a08a782..6c4810e 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -11,7 +11,7 @@ HFILES = init.h io.h
 CFILES = init.c \
 	attr.c bmap.c file.c freeze.c fsync.c getrusage.c imap.c link.c \
 	mmap.c open.c parent.c pread.c prealloc.c pwrite.c seek.c shutdown.c \
-	sync.c truncate.c
+	sync.c truncate.c reflink.c dedupe.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE)
diff --git a/io/dedupe.c b/io/dedupe.c
new file mode 100644
index 0000000..8e69545
--- /dev/null
+++ b/io/dedupe.c
@@ -0,0 +1,190 @@
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
+#include <xfs/command.h>
+#include <xfs/input.h>
+#include "init.h"
+#include "io.h"
+
+static cmdinfo_t dedupe_cmd;
+
+static void
+dedupe_help(void)
+{
+	printf(_(
+"\n"
+" Links a range of bytes (in block size increments) from a file into a range \n"
+" of bytes in the open file.  The contents of both file ranges must match.\n"
+"\n"
+" Example:\n"
+" 'dedupe some_file 0 4096 32768' - links 32768 bytes from some_file at \n"
+"                                    offset 0 to into the open file at \n"
+"                                    position 4096\n"
+"\n"
+" Reflink a range of blocks from a given input file to the open file.  Both\n"
+" files share the same range of physical disk blocks; a write to the shared\n"
+" range of either file should result in the write landing in a new block and\n"
+" that range of the file being remapped (i.e. copy-on-write).  Both files\n"
+" must reside on the same filesystem, and the contents of both ranges must\n"
+" match.\n"
+" -w   -- call fdatasync(2) at the end (included in timing results)\n"
+" -W   -- call fsync(2) at the end (included in timing results)\n"
+"\n"));
+}
+
+static int
+dedupe_f(
+	int		argc,
+	char		**argv)
+{
+	off64_t		soffset, doffset;
+	long long	count, total;
+	char		s1[64], s2[64], ts[64];
+	char		*infile;
+	int		Cflag, qflag, wflag, Wflag;
+	struct xfs_ioctl_file_extent_same_args	*args = NULL;
+	struct xfs_ioctl_file_extent_same_info	*info;
+	size_t		fsblocksize, fssectsize;
+	struct timeval	t1, t2;
+	int		c, fd = -1;
+
+	Cflag = qflag = wflag = Wflag = 0;
+	init_cvtnum(&fsblocksize, &fssectsize);
+
+	while ((c = getopt(argc, argv, "CqwW")) != EOF) {
+		switch (c) {
+		case 'C':
+			Cflag = 1;
+			break;
+		case 'q':
+			qflag = 1;
+			break;
+		case 'w':
+			wflag = 1;
+			break;
+		case 'W':
+			Wflag = 1;
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
+	c = IO_READONLY;
+	fd = openfile(infile, NULL, c, 0);
+	if (fd < 0)
+		return 0;
+
+	gettimeofday(&t1, NULL);
+	args = calloc(1, sizeof(struct xfs_ioctl_file_extent_same_args) +
+			 sizeof(struct xfs_ioctl_file_extent_same_info));
+	if (!args)
+		goto done;
+	info = (struct xfs_ioctl_file_extent_same_info *)(args + 1);
+	args->logical_offset = soffset;
+	args->length = count;
+	args->dest_count = 1;
+	info->fd = file->fd;
+	info->logical_offset = doffset;
+	do {
+		c = ioctl(fd, XFS_IOC_FILE_EXTENT_SAME, args);
+		if (c)
+			break;
+		args->logical_offset += info->bytes_deduped;
+		info->logical_offset += info->bytes_deduped;
+		args->length -= info->bytes_deduped;
+	} while (c == 0 && info->status == 0 && info->bytes_deduped > 0);
+	if (c)
+		perror(_("dedupe ioctl"));
+	if (info->status < 0)
+		printf("dedupe: %s\n", _(strerror(-info->status)));
+	if (info->status == XFS_SAME_DATA_DIFFERS)
+		printf(_("Extents did not match.\n"));
+	if (c != 0 || info->status != 0)
+		goto done;
+	total = info->bytes_deduped;
+	c = 1;
+	if (Wflag)
+		fsync(file->fd);
+	if (wflag)
+		fdatasync(file->fd);
+	if (qflag)
+		goto done;
+	gettimeofday(&t2, NULL);
+	t2 = tsub(t2, t1);
+
+	/* Finally, report back -- -C gives a parsable format */
+	timestr(&t2, ts, sizeof(ts), Cflag ? VERBOSE_FIXED_TIME : 0);
+	if (!Cflag) {
+		cvtstr((double)total, s1, sizeof(s1));
+		cvtstr(tdiv((double)total, t2), s2, sizeof(s2));
+		printf(_("linked %lld/%lld bytes at offset %lld\n"),
+			total, count, (long long)doffset);
+		printf(_("%s, %d ops; %s (%s/sec and %.4f ops/sec)\n"),
+			s1, c, ts, s2, tdiv((double)c, t2));
+	} else {/* bytes,ops,time,bytes/sec,ops/sec */
+		printf("%lld,%d,%s,%.3f,%.3f\n",
+			total, c, ts,
+			tdiv((double)total, t2), tdiv((double)c, t2));
+	}
+done:
+	free(args);
+	close(fd);
+	return 0;
+}
+
+void
+dedupe_init(void)
+{
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
diff --git a/io/init.c b/io/init.c
index 1b07518..b6e0bc5 100644
--- a/io/init.c
+++ b/io/init.c
@@ -83,6 +83,8 @@ init_commands(void)
 	sync_init();
 	sync_range_init();
 	truncate_init();
+	reflink_init();
+	dedupe_init();
 }
 
 static int
diff --git a/io/io.h b/io/io.h
index db8b513..3bb7abf 100644
--- a/io/io.h
+++ b/io/io.h
@@ -159,3 +159,6 @@ extern void		readdir_init(void);
 #else
 #define readdir_init()		do { } while (0)
 #endif
+
+extern void		reflink_init(void);
+extern void		dedupe_init(void);
diff --git a/io/reflink.c b/io/reflink.c
new file mode 100644
index 0000000..cd1e310
--- /dev/null
+++ b/io/reflink.c
@@ -0,0 +1,180 @@
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
+#include <xfs/command.h>
+#include <xfs/input.h>
+#include "init.h"
+#include "io.h"
+
+static cmdinfo_t reflink_cmd;
+
+static void
+reflink_help(void)
+{
+	printf(_(
+"\n"
+" Links a range of bytes (in block size increments) from a file into a range \n"
+" of bytes in the open file.  The two extent ranges need not contain identical\n"
+" data. \n"
+"\n"
+" Example:\n"
+" 'reflink some_file 0 4096 32768' - links 32768 bytes from some_file at \n"
+"                                    offset 0 to into the open file at \n"
+"                                    position 4096\n"
+" 'reflink some_file' - links all bytes from some_file into the open file\n"
+"                       at position 0\n"
+"\n"
+" Reflink a range of blocks from a given input file to the open file.  Both\n"
+" files share the same range of physical disk blocks; a write to the shared\n"
+" range of either file should result in the write landing in a new block and\n"
+" that range of the file being remapped (i.e. copy-on-write).  Both files\n"
+" must reside on the same filesystem.\n"
+" -w   -- call fdatasync(2) at the end (included in timing results)\n"
+" -W   -- call fsync(2) at the end (included in timing results)\n"
+"\n"));
+}
+
+static int
+reflink_f(
+	int		argc,
+	char		**argv)
+{
+	off64_t		soffset, doffset;
+	long long	count = 0, total;
+	char		s1[64], s2[64], ts[64];
+	char		*infile = NULL;
+	int		Cflag, qflag, wflag, Wflag;
+	struct xfs_ioctl_clone_range_args	args;
+	size_t		fsblocksize, fssectsize;
+	struct timeval	t1, t2;
+	int		c, fd = -1;
+
+	Cflag = qflag = wflag = Wflag = 0;
+	init_cvtnum(&fsblocksize, &fssectsize);
+
+	while ((c = getopt(argc, argv, "CqwW")) != EOF) {
+		switch (c) {
+		case 'C':
+			Cflag = 1;
+			break;
+		case 'q':
+			qflag = 1;
+			break;
+		case 'w':
+			wflag = 1;
+			break;
+		case 'W':
+			Wflag = 1;
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
+	c = IO_READONLY;
+	fd = openfile(infile, NULL, c, 0);
+	if (fd < 0)
+		return 0;
+
+	gettimeofday(&t1, NULL);
+	if (count) {
+		args.src_fd = fd;
+		args.src_offset = soffset;
+		args.src_length = count;
+		args.dest_offset = doffset;
+		c = ioctl(file->fd, XFS_IOC_CLONE_RANGE, &args);
+	} else {
+		c = ioctl(file->fd, XFS_IOC_CLONE, fd);
+	}
+	if (c < 0) {
+		perror(_("reflink"));
+		goto done;
+	}
+	total = count;
+	c = 1;
+	if (Wflag)
+		fsync(file->fd);
+	if (wflag)
+		fdatasync(file->fd);
+	if (qflag)
+		goto done;
+	gettimeofday(&t2, NULL);
+	t2 = tsub(t2, t1);
+
+	/* Finally, report back -- -C gives a parsable format */
+	timestr(&t2, ts, sizeof(ts), Cflag ? VERBOSE_FIXED_TIME : 0);
+	if (!Cflag) {
+		cvtstr((double)total, s1, sizeof(s1));
+		cvtstr(tdiv((double)total, t2), s2, sizeof(s2));
+		printf(_("linked %lld/%lld bytes at offset %lld\n"),
+			total, count, (long long)doffset);
+		printf(_("%s, %d ops; %s (%s/sec and %.4f ops/sec)\n"),
+			s1, c, ts, s2, tdiv((double)c, t2));
+	} else {/* bytes,ops,time,bytes/sec,ops/sec */
+		printf("%lld,%d,%s,%.3f,%.3f\n",
+			total, c, ts,
+			tdiv((double)total, t2), tdiv((double)c, t2));
+	}
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
+}
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 89689c6..0c922ad 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
@@ -559,6 +559,42 @@ typedef struct xfs_swapext
 #define XFS_IOC_GOINGDOWN	     _IOR ('X', 125, __uint32_t)
 /*	XFS_IOC_GETFSUUID ---------- deprecated 140	 */
 
+/* reflink ioctls; these MUST match the btrfs ioctl definitions */
+struct xfs_ioctl_clone_range_args {
+	__s64 src_fd;
+	__u64 src_offset;
+	__u64 src_length;
+	__u64 dest_offset;
+};
+
+#define XFS_SAME_DATA_DIFFERS	1
+/* For extent-same ioctl */
+struct xfs_ioctl_file_extent_same_info {
+	__s64 fd;		/* in - destination file */
+	__u64 logical_offset;	/* in - start of extent in destination */
+	__u64 bytes_deduped;	/* out - total # of bytes we were able
+				 * to dedupe from this file */
+	/* status of this dedupe operation:
+	 * 0 if dedup succeeds
+	 * < 0 for error
+	 * == XFS_SAME_DATA_DIFFERS if data differs
+	 */
+	__s32 status;		/* out - see above description */
+	__u32 reserved;
+};
+
+struct xfs_ioctl_file_extent_same_args {
+	__u64 logical_offset;	/* in - start of extent in source */
+	__u64 length;		/* in - length of extent */
+	__u16 dest_count;	/* in - total elements in info array */
+	__u16 reserved1;
+	__u32 reserved2;
+	struct xfs_ioctl_file_extent_same_info info[0];
+};
+
+#define XFS_IOC_CLONE		 _IOW (0x94, 9, int)
+#define XFS_IOC_CLONE_RANGE	 _IOW (0x94, 13, struct xfs_ioctl_clone_range_args)
+#define XFS_IOC_FILE_EXTENT_SAME _IOWR(0x94, 54, struct xfs_ioctl_file_extent_same_args)
 
 #ifndef HAVE_BBMACROS
 /*
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 416206f..305335c 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -490,6 +490,73 @@ Recursively display all the specified segments starting at the specified
 .B \-s
 Display the starting lseek(2) offset. This offset will be a calculated value when
 both data and holes are displayed together or performing a recusively display.
+.RE
+.PD
+.TP
+.TP
+.BI "reflink  [ \-w ] [ \-W ] src_file [src_offset dst_offset length]"
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
+.B \-w
+Call
+.BR fdatasync (2)
+after executing the ioctl.
+.TP
+.B \-W
+Call
+.BR fsync (2)
+after executing the command.
+.RE
+.PD
+.TP
+.TP
+.BI "dedupe  [ \-w ] [ \-W ] src_file src_offset dst_offset length"
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
+.B \-w
+Call
+.BR fdatasync (2)
+after executing the ioctl.
+.TP
+.B \-W
+Call
+.BR fsync (2)
+after executing the command.
 .TP
 
 .SH MEMORY MAPPED I/O COMMANDS

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
