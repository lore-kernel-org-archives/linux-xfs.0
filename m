Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42234 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbfDFCf0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 5 Apr 2019 22:35:26 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id CAE67C05001A
        for <linux-xfs@vger.kernel.org>; Sat,  6 Apr 2019 02:35:25 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-20.pek2.redhat.com [10.72.12.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DE2175D70A
        for <linux-xfs@vger.kernel.org>; Sat,  6 Apr 2019 02:35:24 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfs_io: support splice data between two files
Date: Sat,  6 Apr 2019 10:35:19 +0800
Message-Id: <20190406023519.4429-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Add splice command into xfs_io, by calling splice(2) system call.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

I've add splice() test into fsstress.c, due to we find a XFS regression
by doing some splice test on overlayfs over XFS. Although copy_file_range
maybe through splice() code path, but it depends. So a specified splice
operation is helpful to use splice clearly.

Thanks,
Zorro

 io/Makefile       |   2 +-
 io/init.c         |   1 +
 io/io.h           |   1 +
 io/splice.c       | 194 ++++++++++++++++++++++++++++++++++++++++++++++
 man/man8/xfs_io.8 |  26 +++++++
 5 files changed, 223 insertions(+), 1 deletion(-)
 create mode 100644 io/splice.c

diff --git a/io/Makefile b/io/Makefile
index 484e2b5a..06d21dd5 100644
--- a/io/Makefile
+++ b/io/Makefile
@@ -12,7 +12,7 @@ CFILES = init.c \
 	attr.c bmap.c crc32cselftest.c cowextsize.c encrypt.c file.c freeze.c \
 	fsync.c getrusage.c imap.c inject.c label.c link.c mmap.c open.c \
 	parent.c pread.c prealloc.c pwrite.c reflink.c resblks.c scrub.c \
-	seek.c shutdown.c stat.c swapext.c sync.c truncate.c utimes.c
+	seek.c shutdown.c splice.c stat.c swapext.c sync.c truncate.c utimes.c
 
 LLDLIBS = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG) $(LIBPTHREAD)
 LTDEPENDENCIES = $(LIBXCMD) $(LIBHANDLE) $(LIBFROG)
diff --git a/io/init.c b/io/init.c
index 83f08f2d..fc191aa7 100644
--- a/io/init.c
+++ b/io/init.c
@@ -79,6 +79,7 @@ init_commands(void)
 	seek_init();
 	sendfile_init();
 	shutdown_init();
+	splice_init();
 	stat_init();
 	swapext_init();
 	sync_init();
diff --git a/io/io.h b/io/io.h
index 6469179e..9a0b71f0 100644
--- a/io/io.h
+++ b/io/io.h
@@ -110,6 +110,7 @@ extern void		quit_init(void);
 extern void		resblks_init(void);
 extern void		seek_init(void);
 extern void		shutdown_init(void);
+extern void		splice_init(void);
 extern void		stat_init(void);
 extern void		swapext_init(void);
 extern void		sync_init(void);
diff --git a/io/splice.c b/io/splice.c
new file mode 100644
index 00000000..7e2f1aa2
--- /dev/null
+++ b/io/splice.c
@@ -0,0 +1,194 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (c) 2019 Red Hat, Inc.
+ * All Rights Reserved.
+ */
+
+#include "command.h"
+#include "input.h"
+#include <fcntl.h>
+#include "init.h"
+#include "io.h"
+
+static cmdinfo_t splice_cmd;
+
+static void
+splice_help(void)
+{
+	printf(_(
+"\n"
+" Splice a range of bytes from the given offset between files through pipe\n"
+"\n"
+" Example:\n"
+" 'splice filename 0 4096 32768' - splice 32768 bytes from filename at offset\n"
+"                                  0 into the open file at position 4096\n"
+" 'splice filename' - splice all bytes from filename into the open file at\n"
+" '                   position 0\n"
+"\n"
+" Copies data between one file and another.  Because this copying is done\n"
+" within the kernel, sendfile does not need to transfer data to and from user\n"
+" space.\n"
+" -m -- SPLICE_F_MOVE flag, attempt to move pages instead of copying.\n"
+" Offset and length in the source/destination file can be optionally specified.\n"
+"\n"));
+}
+
+static uint64_t
+splice_file(
+	int		fd,
+	off64_t		soffset,
+	off64_t		doffset,
+	size_t		length,
+	unsigned int	flag,
+	int		*ops)
+{
+	off64_t		soff = soffset;
+	off64_t		doff = doffset;
+	ssize_t		rc = 0;
+	size_t		len = length;
+	uint64_t	total = 0;
+	int		filedes[2];
+
+	if (pipe(filedes) < 0) {
+		perror("pipe");
+		return -1;
+	}
+
+	*ops = 0;
+	while (len > 0 || !*ops) {
+		/* move to pipe buffer */
+		rc = splice(fd, &soff, filedes[1], NULL, len, flag);
+		if (rc < 0) {
+			perror("splice to pipe");
+			goto out_close;
+		}
+		/* move from pipe buffer to dst file */
+		rc = splice(filedes[0], NULL, file->fd, &doff, len, flag);
+		if (rc < 0) {
+			perror("splice from pipe");
+			goto out_close;
+		}
+		(*ops)++;
+		len -= rc;
+		total += rc;
+	}
+
+out_close:
+	close(filedes[0]);
+	close(filedes[1]);
+	return total;
+}
+
+static int
+splice_f(
+	int		argc,
+	char		**argv)
+{
+	off64_t		soffset, doffset;
+	long long	count, total;
+	size_t		blocksize, sectsize;
+	struct timeval	t1, t2;
+	char		*infile = NULL;
+	int		Cflag, qflag;
+	int		splice_flag = 0;
+	int		c, fd = -1;
+	int		ops = 0;
+
+	Cflag = qflag = 0;
+	soffset = doffset=0;
+	init_cvtnum(&blocksize, &sectsize);
+
+	while ((c = getopt(argc, argv, "Cqm")) != EOF) {
+		switch (c) {
+		case 'C':
+			Cflag = 1;
+			break;
+		case 'q':
+			qflag = 1;
+			break;
+		case 'm':
+			splice_flag |= SPLICE_F_MOVE;
+			break;
+		default:
+			return command_usage(&splice_cmd);
+		}
+	}
+
+	if (optind != argc - 4 && optind != argc - 1)
+		return command_usage(&splice_cmd);
+
+	infile = argv[optind];
+	if ((fd = openfile(infile, NULL, IO_READONLY, 0, NULL)) < 0)
+		return 0;
+	optind++;
+
+	if (optind == argc - 3) {
+		soffset = cvtnum(blocksize, sectsize, argv[optind]);
+		if (soffset < 0) {
+			printf(_("non-numeric src offset argument -- %s\n"), \
+			       argv[optind]);
+			return 0;
+		}
+		optind++;
+		doffset = cvtnum(blocksize, sectsize, argv[optind]);
+		if (doffset < 0) {
+			printf(_("non-numeric dest offset argument -- %s\n"), \
+			       argv[optind]);
+			return 0;
+		}
+		optind++;
+		count = cvtnum(blocksize, sectsize, argv[optind]);
+		if (count < 0) {
+			printf(_("non-positive length argument -- %s\n"), \
+			       argv[optind]);
+			return 0;
+		}
+	} else {
+		/*
+		 * splice whole file to another, if doesn't specify src and dst
+		 * offset and length
+		 */
+		struct stat	stat;
+
+		if (fstat(fd, &stat) < 0) {
+			perror("fstat");
+			goto done;
+		}
+		count = stat.st_size;
+		soffset = 0;
+		doffset = 0;
+	}
+
+	gettimeofday(&t1, NULL);
+	total = splice_file(fd, soffset, doffset, count, splice_flag, &ops);
+	if (ops == 0 || qflag)
+		goto done;
+	gettimeofday(&t2, NULL);
+	t2 = tsub(t2, t1);
+
+	report_io_times("spliced", &t2, (long long)doffset, count, total, ops, \
+	                Cflag);
+
+done:
+	if (infile)
+		close(fd);
+	return 0;
+}
+
+void
+splice_init(void)
+{
+	splice_cmd.name = "splice";
+	splice_cmd.altname = "spl";
+	splice_cmd.cfunc = splice_f;
+	splice_cmd.argmin = 1;
+	splice_cmd.argmax = -1;
+	splice_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK | CMD_FLAG_ONESHOT;;
+	splice_cmd.args =
+		_("[-m] infile [src_off dst_off len]");
+	splice_cmd.oneline =
+		_("Splice an entire file, or a number of bytes at a specified offset");
+	splice_cmd.help = splice_help;
+
+	add_command(&splice_cmd);
+}
diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index 980dcfd3..066a72e7 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -830,6 +830,32 @@ verbose output will be printed.
 .RE
 .PD
 .TP
+.BI "splice  [ \-C ] [ \-q ] [\-m] infile [src_offset dst_offset length]"
+On filesystems that support the
+.BR splice (2)
+system call, splice data from the
+.I infile
+into the open file. If
+.IR src_offset ,
+.IR dst_offset ,
+and
+.I length
+are omitted the contents of infile will be copied to the beginning of the
+open file, overwriting any data already there.
+.RS 1.0i
+.PD 0
+.TP 0.4i
+.B \-C
+Print timing statistics in a condensed format.
+.TP
+.B \-q
+Do not print timing statistics at all.
+.TP
+.B \-m
+Enable SPLICE_F_MOVE flag, attempt to move pages instead of copying.
+.RE
+.PD
+.TP
 .BI utimes " atime_sec atime_nsec mtime_sec mtime_nsec"
 The utimes command changes the atime and mtime of the current file.
 sec uses UNIX timestamp notation and is the seconds elapsed since
-- 
2.17.2
