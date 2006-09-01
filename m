Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 31 Aug 2006 23:56:21 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k816tcDW022684
	for <xfs@oss.sgi.com>; Thu, 31 Aug 2006 23:55:50 -0700
Date: Fri, 1 Sep 2006 16:54:50 +1000
From: Nathan Scott <nathans@sgi.com>
Subject: review: add a splice command to xfs_io
Message-ID: <20060901165450.T3186664@wobbly.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="1LKvkjL3sHcu1TtY"
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: dgc@melbourne.sgi.com
Cc: xfs@oss.sgi.com

--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Yo Dave,

Here's some code which should help exercising the splice functionality
from a QA test.  Needs a /usr/include/sys/splice.h (attached also, but
glibc will get this at some point I guess).  No QA test yet though - I
will hack something up there on Monday (its beer o'clock).

cheers.

-- 
Nathan

Index: xfsprogs/io/init.c
===================================================================
--- xfsprogs.orig/io/init.c	2006-09-01 09:34:40.679409500 +1000
+++ xfsprogs/io/init.c	2006-09-01 09:36:18.193313250 +1000
@@ -74,6 +74,7 @@ init_commands(void)
 	resblks_init();
 	sendfile_init();
 	shutdown_init();
+	splice_init();
 	truncate_init();
 }
 
Index: xfsprogs/io/io.h
===================================================================
--- xfsprogs.orig/io/io.h	2006-09-01 09:34:40.595404250 +1000
+++ xfsprogs/io/io.h	2006-09-01 09:36:04.013341500 +1000
@@ -131,6 +131,12 @@ extern void		sendfile_init(void);
 #define sendfile_init()	do { } while (0)
 #endif
 
+#ifdef HAVE_SPLICE
+extern void		splice_init(void);
+#else
+#define splice_init()	do { } while (0)
+#endif
+
 #ifdef HAVE_MADVISE
 extern void		madvise_init(void);
 #else
Index: xfsprogs/io/splice.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfsprogs/io/splice.c	2006-09-01 16:46:41.929606500 +1000
@@ -0,0 +1,255 @@
+/*
+ * Copyright (c) 2006 Silicon Graphics, Inc.
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
+#include <xfs/input.h>
+#include <sys/splice.h>
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
+" splice part or all of the current open file to a second file\n"
+"\n"
+" Example:\n"
+" 'splice 100m 400m 4k out' - splices 4 kilobytes at 100 megabytes offset\n"
+"                             into the open file, to 200m offset in \"out\"\n"
+"\n"
+" Copies data between one file descriptor and another.  Because this copying\n"
+" is done within the kernel, splice does not need to transfer data to and\n"
+" from user space.\n"
+" -i <path> -- input file, instead of current file descriptor\n"
+" -m -- move pages instead of copying\n"
+" -n -- operate in non-blocking I/O mode\n"
+" Offsets in both the source and target files are optional, as is the size,\n"
+" as follows:  If one of these arguments is given it's the transfer size.  If\n"
+" two are given they are offsets.  If three are given - offset, offset, size.\n"
+" Finally, if none of these arguments are given the entire input file will be\n"
+" spliced to the output file.\n"
+"\n"));
+}
+
+static int
+splice_buffer(
+	int		in_fd,
+	off64_t		in_offset,
+	int		out_fd,
+	off64_t		out_offset,
+	size_t		bsize,
+	int		flags,
+	long long	*total)
+{
+	long long	bytes_remaining = *total;
+	ssize_t		bytes, ibytes, obytes;
+	int		pipefds[2];
+	int		ops = 0;
+
+	*total = 0;
+	if (pipe(pipefds) < 0) {
+		perror("pipe");
+		return -1;
+	}
+	while (bytes_remaining > 0) {
+		ibytes = min(bytes_remaining, bsize);
+		bytes = splice(in_fd, &in_offset,
+				pipefds[1], NULL, ibytes, flags);
+		if (bytes == 0)
+			break;
+		if (bytes < 0) {
+			perror("splice(in)");
+			return -1;
+		}
+		ops++;
+		ibytes = obytes = bytes;
+		while (obytes > 0) {
+			bytes = splice(pipefds[0], NULL,
+					out_fd, &out_offset, obytes, flags);
+			if (bytes < 0) {
+				perror("splice(out)");
+				return -1;
+			}
+			ops++;
+			obytes -= bytes;
+		}
+		*total += ibytes;
+		if (ibytes >= bytes_remaining)
+			break;
+		bytes_remaining -= ibytes;
+	}
+	return ops;
+}
+
+static int
+splice_f(
+	int		argc,
+	char		**argv)
+{
+	off64_t		inoff, outoff;
+	long long	count, total;
+	size_t		blocksize, sectsize;
+	struct stat64	instat;
+	struct timeval	t1, t2;
+	char		s1[64], s2[64], ts[64];
+	char		*infile = NULL;
+	int		Cflag, qflag, flags;
+	int		c, infd = -1, outfd = -1;
+
+	Cflag = qflag = flags = 0;
+	init_cvtnum(&blocksize, &sectsize);
+	while ((c = getopt(argc, argv, "i:mnqC")) != EOF) {
+		switch (c) {
+		case 'C':
+			Cflag = 1;
+			break;
+		case 'q':
+			qflag = 1;
+			break;
+		case 'm':
+			flags |= SPLICE_F_MOVE;
+			break;
+		case 'n':
+			flags |= SPLICE_F_NONBLOCK;
+			break;
+		case 'i':
+			infile = optarg;
+			break;
+		default:
+			return command_usage(&splice_cmd);
+		}
+	}
+
+	/*
+	 * If no more arguments are given, splice the whole input file
+	 * If one of these arguments is given it's the transfer size
+	 * If two are given they are file offsets
+	 * If three are given - offset, offset, size
+	 */
+
+	if (optind >= argc)
+		return command_usage(&splice_cmd);
+
+	if (optind == argc - 1) {
+		inoff = outoff = 0;
+		count = -1;
+	} else if (optind == argc - 2) {
+		inoff = outoff = 0;
+		count = cvtnum(blocksize, sectsize, argv[optind]);
+		if (count < 0) {
+			printf(_("non-numeric length argument -- %s\n"),
+				argv[optind]);
+			return 0;
+		}
+		optind++;
+	} else if (optind == argc - 3 || optind == argc - 4) {
+		inoff = cvtnum(blocksize, sectsize, argv[optind]);
+		if (inoff < 0) {
+			printf(_("non-numeric offset argument -- %s\n"),
+				argv[optind]);
+			return 0;
+		}
+		optind++;
+		outoff = cvtnum(blocksize, sectsize, argv[optind]);
+		if (outoff < 0) {
+			printf(_("non-numeric offset argument -- %s\n"),
+				argv[optind]);
+			return 0;
+		}
+		optind++;
+		if (optind == argc - 1) {
+			count = -1;
+		} else {
+			count = cvtnum(blocksize, sectsize, argv[optind]);
+			if (count < 0) {
+				printf(_("non-numeric length argument -- %s\n"),
+					argv[optind]);
+				return 0;
+			}
+			optind++;
+		}
+	} else
+		return command_usage(&splice_cmd);
+
+	if (((outfd = openfile(argv[optind], NULL, IO_CREAT, 0644)) < 0))
+		return 0;
+
+	if (!infile)
+		infd = file->fd;
+	else if ((infd = openfile(infile, NULL, IO_READONLY, 0)) < 0)
+		goto done;
+
+	if (fstat64(infd, &instat) < 0) {
+		perror("fstat64");
+		goto done;
+	}
+	if (count == -1)
+		count = instat.st_size;
+	total = count;
+	blocksize = instat.st_blksize;
+
+	gettimeofday(&t1, NULL);
+	c = splice_buffer(infd, inoff, outfd, outoff, blocksize, flags, &total);
+	if (c < 0)
+		goto done;
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
+		printf(_("spliced %lld/%lld bytes from offset %lld to offset %lld\n"),
+			total, count, (long long)inoff, (long long)outoff);
+		printf(_("%s, %d ops; %s (%s/sec and %.4f ops/sec)\n"),
+			s1, c, ts, s2, tdiv((double)c, t2));
+	} else {/* bytes,ops,time,bytes/sec,ops/sec */
+		printf("%lld,%d,%s,%.3f,%.3f\n",
+			total, c, ts,
+			tdiv((double)total, t2), tdiv((double)c, t2));
+	}
+done:
+	if (infile)
+		close(infd);
+	close(outfd);
+	return 0;
+}
+
+void
+splice_init(void)
+{
+	splice_cmd.name = _("splice");
+	splice_cmd.cfunc = splice_f;
+	splice_cmd.argmin = 1;
+	splice_cmd.argmax = -1;
+	splice_cmd.flags = CMD_NOMAP_OK | CMD_FOREIGN_OK;
+	splice_cmd.args =
+		_("[-i infile] [inoff [outoff [len]]] outfile");
+	splice_cmd.oneline =
+		_("Splice copy data between two file descriptors via a pipe");
+	splice_cmd.help = splice_help;
+
+	add_command(&splice_cmd);
+}
Index: xfsprogs/io/Makefile
===================================================================
--- xfsprogs.orig/io/Makefile	2006-09-01 09:32:31.319325000 +1000
+++ xfsprogs/io/Makefile	2006-09-01 12:03:24.598944250 +1000
@@ -44,6 +44,13 @@ else
 LSRCFILES += sendfile.c
 endif
 
+ifeq ($(HAVE_SPLICE),yes)
+CFILES += splice.c
+LCFLAGS += -DHAVE_SPLICE
+else
+LSRCFILES += splice.c
+endif
+
 ifeq ($(PKG_PLATFORM),irix)
 LSRCFILES += inject.c resblks.c
 else
Index: xfsprogs/aclocal.m4
===================================================================
--- xfsprogs.orig/aclocal.m4	2006-09-01 12:04:54.696575000 +1000
+++ xfsprogs/aclocal.m4	2006-09-01 12:06:48.043658750 +1000
@@ -157,9 +157,9 @@ AC_DEFUN([AC_PACKAGE_GLOBALS],
     AC_SUBST(pkg_platform)
   ])
 
-# 
+#
 # Check if we have a working fadvise system call
-# 
+#
 AC_DEFUN([AC_HAVE_FADVISE],
   [ AC_MSG_CHECKING([for fadvise ])
     AC_TRY_COMPILE([
@@ -174,9 +174,9 @@ AC_DEFUN([AC_HAVE_FADVISE],
     AC_SUBST(have_fadvise)
   ])
 
-# 
+#
 # Check if we have a working madvise system call
-# 
+#
 AC_DEFUN([AC_HAVE_MADVISE],
   [ AC_MSG_CHECKING([for madvise ])
     AC_TRY_COMPILE([
@@ -191,9 +191,9 @@ AC_DEFUN([AC_HAVE_MADVISE],
     AC_SUBST(have_madvise)
   ])
 
-# 
+#
 # Check if we have a working mincore system call
-# 
+#
 AC_DEFUN([AC_HAVE_MINCORE],
   [ AC_MSG_CHECKING([for mincore ])
     AC_TRY_COMPILE([
@@ -208,9 +208,9 @@ AC_DEFUN([AC_HAVE_MINCORE],
     AC_SUBST(have_mincore)
   ])
 
-# 
+#
 # Check if we have a working sendfile system call
-# 
+#
 AC_DEFUN([AC_HAVE_SENDFILE],
   [ AC_MSG_CHECKING([for sendfile ])
     AC_TRY_COMPILE([
@@ -226,6 +226,23 @@ AC_DEFUN([AC_HAVE_SENDFILE],
   ])
 
 #
+# Check if we have a working splice system call
+#
+AC_DEFUN([AC_HAVE_SPLICE],
+  [ AC_MSG_CHECKING([for splice ])
+    AC_TRY_COMPILE([
+#define _GNU_SOURCE
+#define _FILE_OFFSET_BITS 64
+#include <sys/splice.h>
+    ], [
+         splice(0, 0, 0, 0, 0, 0);
+    ],	have_splice=yes
+	AC_MSG_RESULT(yes),
+	AC_MSG_RESULT(no))
+    AC_SUBST(have_splice)
+  ])
+
+#
 # Check if we have a getmntent libc call (IRIX, Linux)
 #
 AC_DEFUN([AC_HAVE_GETMNTENT],
Index: xfsprogs/configure.in
===================================================================
--- xfsprogs.orig/configure.in	2006-09-01 12:04:54.612569750 +1000
+++ xfsprogs/configure.in	2006-09-01 12:06:39.123101250 +1000
@@ -52,6 +52,7 @@ AC_HAVE_FADVISE
 AC_HAVE_MADVISE
 AC_HAVE_MINCORE
 AC_HAVE_SENDFILE
+AC_HAVE_SPLICE
 AC_HAVE_GETMNTENT
 AC_HAVE_GETMNTINFO
 
Index: xfsprogs/m4/package_libcdev.m4
===================================================================
--- xfsprogs.orig/m4/package_libcdev.m4	2006-09-01 12:05:03.605131750 +1000
+++ xfsprogs/m4/package_libcdev.m4	2006-09-01 12:06:29.186480250 +1000
@@ -1,6 +1,6 @@
-# 
+#
 # Check if we have a working fadvise system call
-# 
+#
 AC_DEFUN([AC_HAVE_FADVISE],
   [ AC_MSG_CHECKING([for fadvise ])
     AC_TRY_COMPILE([
@@ -15,9 +15,9 @@ AC_DEFUN([AC_HAVE_FADVISE],
     AC_SUBST(have_fadvise)
   ])
 
-# 
+#
 # Check if we have a working madvise system call
-# 
+#
 AC_DEFUN([AC_HAVE_MADVISE],
   [ AC_MSG_CHECKING([for madvise ])
     AC_TRY_COMPILE([
@@ -32,9 +32,9 @@ AC_DEFUN([AC_HAVE_MADVISE],
     AC_SUBST(have_madvise)
   ])
 
-# 
+#
 # Check if we have a working mincore system call
-# 
+#
 AC_DEFUN([AC_HAVE_MINCORE],
   [ AC_MSG_CHECKING([for mincore ])
     AC_TRY_COMPILE([
@@ -49,9 +49,9 @@ AC_DEFUN([AC_HAVE_MINCORE],
     AC_SUBST(have_mincore)
   ])
 
-# 
+#
 # Check if we have a working sendfile system call
-# 
+#
 AC_DEFUN([AC_HAVE_SENDFILE],
   [ AC_MSG_CHECKING([for sendfile ])
     AC_TRY_COMPILE([
@@ -67,6 +67,23 @@ AC_DEFUN([AC_HAVE_SENDFILE],
   ])
 
 #
+# Check if we have a working splice system call
+#
+AC_DEFUN([AC_HAVE_SPLICE],
+  [ AC_MSG_CHECKING([for splice ])
+    AC_TRY_COMPILE([
+#define _GNU_SOURCE
+#define _FILE_OFFSET_BITS 64
+#include <sys/splice.h>
+    ], [
+         splice(0, 0, 0, 0, 0, 0);
+    ],	have_splice=yes
+	AC_MSG_RESULT(yes),
+	AC_MSG_RESULT(no))
+    AC_SUBST(have_splice)
+  ])
+
+#
 # Check if we have a getmntent libc call (IRIX, Linux)
 #
 AC_DEFUN([AC_HAVE_GETMNTENT],
Index: xfsprogs/include/builddefs.in
===================================================================
--- xfsprogs.orig/include/builddefs.in	2006-09-01 14:58:42.038205250 +1000
+++ xfsprogs/include/builddefs.in	2006-09-01 14:59:00.475357500 +1000
@@ -90,6 +90,7 @@ HAVE_FADVISE = @have_fadvise@
 HAVE_MADVISE = @have_madvise@
 HAVE_MINCORE = @have_mincore@
 HAVE_SENDFILE = @have_sendfile@
+HAVE_SPLICE = @have_splice@
 HAVE_GETMNTENT = @have_getmntent@
 HAVE_GETMNTINFO = @have_getmntinfo@
 

--1LKvkjL3sHcu1TtY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="splice.h"

#ifndef SPLICE_H
#define SPLICE_H

#include <errno.h>
#include <sys/uio.h>
#include <sys/stat.h>
#include <linux/unistd.h>

#if defined(__i386__)
#define __NR_sys_splice		313
#define __NR_sys_tee		315
#define __NR_sys_vmsplice	316
#elif defined(__x86_64__)
#define __NR_sys_splice		275
#define __NR_sys_tee		276
#define __NR_sys_vmsplice	278
#elif defined(__powerpc__) || defined(__powerpc64__)
#define __NR_sys_splice		283
#define __NR_sys_tee		284
#define __NR_sys_vmsplice	285
#elif defined(__ia64__)
#define __NR_sys_splice		1297
#define __NR_sys_tee		1301
#define __NR_sys_vmsplice	1302
#else
#error unsupported arch
#endif

#define SPLICE_F_MOVE	(0x01)	/* move pages instead of copying */
#define SPLICE_F_NONBLOCK (0x02) /* don't block on the pipe splicing (but */
				 /* we may still block on the fd we splice */
				 /* from/to, of course */
#define SPLICE_F_MORE	(0x04)	/* expect more data */
#define SPLICE_F_GIFT   (0x08)  /* pages passed in are a gift */

_syscall6(int, sys_splice, int, fdin, loff_t *, off_in, int, fdout, loff_t *, off_out, size_t, len, unsigned int, flags);
_syscall4(int, sys_vmsplice, int, fd, const struct iovec *, iov, unsigned long, nr_segs, unsigned int, flags);
_syscall4(int, sys_tee, int, fdin, int, fdout, size_t, len, unsigned int, flags);

static inline int splice(int fdin, loff_t *off_in, int fdout, loff_t *off_out,
			 size_t len, unsigned long flags)
{
	return sys_splice(fdin, off_in, fdout, off_out, len, flags);
}

static inline int tee(int fdin, int fdout, size_t len, unsigned int flags)
{
	return sys_tee(fdin, fdout, len, flags);
}

static inline int vmsplice(int fd, const struct iovec *iov,
			   unsigned long nr_segs, unsigned int flags)
{
	return sys_vmsplice(fd, iov, nr_segs, flags);
}

#endif

--1LKvkjL3sHcu1TtY--
