Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBTHTZgX031890 for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 11:29:36 -0600
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 362B54F746
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 09:29:33 -0800 (PST)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id YYbrXcR3cmKA9QoC for
	<xfs@oss.sgi.com>; Mon, 29 Dec 2008 09:29:33 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.sandeen.net (Postfix) with ESMTP id E3745AC358C
	for <xfs@oss.sgi.com>; Mon, 29 Dec 2008 11:29:01 -0600 (CST)
Message-ID: <495908DE.7040704@sandeen.net>
Date: Mon, 29 Dec 2008 11:29:02 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH xfstests] 198: test aio+dio writes into sparse files
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Older kernels were not doing completion properly, and converting
unwritten extents at the wrong offsets; this exposed stale data.

Xen w/ the blktap driver was hitting this.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

Index: xfstests/198
===================================================================
--- /dev/null
+++ xfstests/198
@@ -0,0 +1,45 @@
+#! /bin/sh
+# FS QA Test No. 198
+#
+# Test that aio+dio into holes does completion at the proper offsets
+# See also https://bugzilla.redhat.com/show_bug.cgi?id=217098
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2008 Eric Sandeen.  All Rights Reserved.
+#-----------------------------------------------------------------------
+#
+# creator
+owner=sandeen@sandeen.net
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1        # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# This should actually run on anything that supports O_DIRECT + AIO...
+_supported_fs xfs
+_supported_os Linux
+
+echo "Silence is golden."
+
+# real QA test starts here
+rm -f $seq.full
+
+rm -f "$TEST_DIR/aiodio_sparse*"
+$here/src/aiodio_sparse2 "$TEST_DIR/aiodio_sparse"
+
+status=$?
+exit
Index: xfstests/198.out
===================================================================
--- /dev/null
+++ xfstests/198.out
@@ -0,0 +1,2 @@
+QA output created by 198
+Silence is golden.
Index: xfstests/group
===================================================================
--- xfstests.orig/group
+++ xfstests/group
@@ -288,3 +288,4 @@ nfs4acl		tes@sgi.com donaldd@sgi.com
 189 mount auto
 190 rw auto
 191 nfs4acl auto
+198 aio auto
Index: xfstests/src/Makefile
===================================================================
--- xfstests.orig/src/Makefile
+++ xfstests/src/Makefile
@@ -17,6 +17,11 @@ LINUX_TARGETS = loggen xfsctl bstat t_mt
 	fs_perms testx looptest locktest unwritten_mmap \
 	bulkstat_unlink_test bulkstat_unlink_test_modified
 
+ifeq ($(HAVE_AIO), true)
+LINUX_TARGETS += aiodio_sparse2
+LIBAIO = -laio
+endif
+
 IRIX_TARGETS = open_unlink
 
 ifeq ($(PKG_PLATFORM),linux)
@@ -115,6 +120,9 @@ locktest: locktest.o
 unwritten_sync: unwritten_sync.o
 	$(LINKTEST)
 
+aiodio_sparse2: aiodio_sparse2.o
+	$(LINKTEST) $(LIBAIO)
+
 ifeq ($(PKG_PLATFORM),irix)
 fill2: fill2.o
 	$(LINKTEST)  -lgen
Index: xfstests/src/aiodio_sparse2.c
===================================================================
--- /dev/null
+++ xfstests/src/aiodio_sparse2.c
@@ -0,0 +1,385 @@
+/* gcc -g -Wall -O2 aiodio_sparse.c -o aiodio_sparse -laio */
+
+/*
+ * From http://developer.osdl.org/daniel/AIO/TESTS/aiodio_sparse.c
+ * With patch from https://bugzilla.redhat.com/attachment.cgi?id=142124
+ * (Bug https://bugzilla.redhat.com/show_bug.cgi?id=217098)
+ */
+
+#ifndef _GNU_SOURCE
+#define _GNU_SOURCE
+#endif
+#include <sys/types.h>
+#include <errno.h>
+#include <signal.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <limits.h>
+#include <sys/mman.h>
+#include <sys/wait.h>
+
+#include <libaio.h>
+
+int debug;
+
+/*
+ * aiodio_sparse - issue async O_DIRECT writes to holes is a file while
+ *	concurrently reading the file and checking that the read never reads
+ *	uninitailized data.
+ */
+
+unsigned char *check_zero(unsigned char *buf, int size)
+{
+	unsigned char *p;
+
+	p = buf;
+
+	while (size > 0) {
+		if (*buf != 1) {
+			fprintf(stderr, "non one buffer at buf[%ld] => 0x%02x,%02x,%02x,%02x\n",
+				buf - p, (unsigned int)buf[0],
+				size > 1 ? (unsigned int)buf[1] : 0,
+				size > 2 ? (unsigned int)buf[2] : 0,
+				size > 3 ? (unsigned int)buf[3] : 0);
+			if (debug)
+				fprintf(stderr, "buf %p, p %p\n", buf, p);
+			return buf;
+		}
+		buf++;
+		size--;
+	}
+	return 0;	/* all zeros */
+}
+
+volatile int got_signal;
+
+void
+sig_term_func(int i, siginfo_t *si, void *p)
+{
+	if (debug)
+		fprintf(stderr, "sig(%d, %p, %p)\n", i, si, p);
+	got_signal++;
+}
+
+/*
+ * do async DIO writes to a sparse file
+ */
+void aiodio_sparse(char *filename, int align, int writesize, int filesize, int num_aio, int step, int sparse, int direct, int keep)
+{
+	int fd;
+	void *bufptr;
+	int i;
+	int w;
+	static struct sigaction s;
+	struct iocb **iocbs;
+	off_t offset;
+	io_context_t myctx;
+	struct io_event event;
+	int aio_inflight;
+
+	s.sa_sigaction = sig_term_func;
+	s.sa_flags = SA_SIGINFO;
+	sigaction(SIGTERM, &s, 0);
+
+	if ((num_aio * step) > filesize) {
+		num_aio = filesize / step;
+	}
+	memset(&myctx, 0, sizeof(myctx));
+	io_queue_init(num_aio, &myctx);
+
+	iocbs = (struct iocb **)calloc(num_aio, sizeof(struct iocb *));
+	for (i = 0; i < num_aio; i++) {
+		if ((iocbs[i] = (struct iocb *)calloc(1, sizeof(struct iocb))) == 0) {
+			perror("cannot malloc iocb");
+			return;
+		}
+	}
+
+	fd = open(filename, direct|O_WRONLY|O_CREAT, 0666);
+
+	if (fd < 0) {
+		perror("cannot create file");
+		return;
+	}
+
+	if (sparse)
+		ftruncate(fd, filesize);
+
+	/*
+	 * allocate the iocbs array and iocbs with buffers
+	 */
+	offset = 0;
+	for (i = 0; i < num_aio; i++) {
+		void *bufptr;
+
+		if (posix_memalign(&bufptr, align, writesize)) {
+			perror("cannot malloc aligned memory");
+			close(fd);
+			unlink(filename);
+			return;
+		}
+		memset(bufptr, 1, writesize);
+		io_prep_pwrite(iocbs[i], fd, bufptr, writesize, offset);
+		offset += step;
+	}
+
+	/*
+	 * start the 1st num_aio write requests
+	 */
+	if ((w = io_submit(myctx, num_aio, iocbs)) < 0) {
+		perror("io_submit failed");
+		close(fd);
+		unlink(filename);
+		return;
+	}
+	if (debug) 
+		fprintf(stderr, "io_submit() return %d\n", w);
+
+	/*
+	 * As AIO requests finish, keep issuing more AIO until done.
+	 */
+	aio_inflight = num_aio;
+	if (debug)
+		fprintf(stderr, "aiodio_sparse: %d i/o in flight\n", aio_inflight);
+	while (offset < filesize)  {
+		int n;
+		struct iocb *iocbp;
+
+		if (debug)
+			fprintf(stderr, "aiodio_sparse: offset %ld filesize %d inflight %d\n",
+				offset, filesize, aio_inflight);
+
+		if ((n = io_getevents(myctx, 1, 1, &event, 0)) != 1) {
+			if (-n != EINTR)
+				fprintf(stderr, "io_getevents() returned %d\n", n);
+			break;
+		}
+		if (debug)
+			fprintf(stderr, "aiodio_sparse: io_getevent() returned %d\n", n);
+		aio_inflight--;
+		if (got_signal)
+			break;		/* told to stop */
+		/*
+		 * check if write succeeded.
+		 */
+		iocbp = event.obj;
+		if (event.res2 != 0 || event.res != iocbp->u.c.nbytes) {
+			fprintf(stderr,
+				"AIO write offset %lld expected %ld got %ld\n",
+				iocbp->u.c.offset, iocbp->u.c.nbytes,
+				event.res);
+			break;
+		}
+		if (debug)
+			fprintf(stderr, "aiodio_sparse: io_getevent() res %ld res2 %ld\n",
+				event.res, event.res2);
+		
+		/* start next write */
+		io_prep_pwrite(iocbp, fd, iocbp->u.c.buf, writesize, offset);
+		offset += step;
+		if ((w = io_submit(myctx, 1, &iocbp)) < 0) {
+			fprintf(stderr, "io_submit failed at offset %ld\n",
+				offset);
+			perror("");
+			break;
+		}
+		if (debug) 
+			fprintf(stderr, "io_submit() return %d\n", w);
+		aio_inflight++;
+	}
+
+	/*
+	 * wait for AIO requests in flight.
+	 */
+	while (aio_inflight > 0) {
+		int n;
+		struct iocb *iocbp;
+
+		if ((n = io_getevents(myctx, 1, 1, &event, 0)) != 1) {
+			perror("io_getevents failed");
+			break;
+		}
+		aio_inflight--;
+		/*
+		 * check if write succeeded.
+		 */
+		iocbp = event.obj;
+		if (event.res2 != 0 || event.res != iocbp->u.c.nbytes) {
+			fprintf(stderr,
+				"AIO write offset %lld expected %ld got %ld\n",
+				iocbp->u.c.offset, iocbp->u.c.nbytes,
+				event.res);
+		}
+	}
+	if (debug)
+		fprintf(stderr, "AIO DIO write done\n");
+	close(fd);
+	if ((fd = open(filename, O_RDONLY)) < 0)
+		exit(1);
+
+	bufptr = malloc(writesize);
+	for (offset = 0; offset < filesize; offset += step)  {
+		unsigned char *badbuf;
+
+		lseek(fd, offset, SEEK_SET);
+		if (read(fd, bufptr, writesize) < writesize) {
+			fprintf(stderr, "short read() at offset %ld\n", offset);
+			exit(11);
+		}
+		if ((badbuf = check_zero(bufptr, writesize))) {
+			fprintf(stderr, "non-one read at offset %ld\n",
+				offset + badbuf - (unsigned char*)bufptr);
+			fprintf(stderr, "*** WARNING *** %s has not been unlinked; if you don't rm it manually first, it may influence the next run\n", filename);
+			exit(10);
+		}
+	}
+	close(fd);
+	if (!keep)
+		unlink(filename);
+	else
+		fprintf(stderr, "*** WARNING *** You requested %s not to be unlinked; if you don't rm it manually first, it may influence the next run\n", filename);
+		
+}
+
+void dirty_freeblocks(char *filename, int size)
+{
+	int fd;
+	void *p;
+	int pg;
+	char filename2[PATH_MAX];
+	
+
+	pg = getpagesize();
+	size = ((size + pg - 1) / pg) * pg;
+	sprintf(filename2, "%s.xx.%d", filename, getpid());
+	fd = open(filename2, O_CREAT|O_RDWR, 0666);
+	if (fd < 0) {
+		perror("cannot open file");
+		exit(2);
+	}
+	ftruncate(fd, size);
+	p = mmap(0, size, PROT_WRITE|PROT_READ, MAP_SHARED|MAP_FILE, fd, 0);
+	if (p == MAP_FAILED) {
+		perror("cannot mmap");
+		exit(2);
+	}
+	memset(p, 0xaa, size);
+	msync(p, size, MS_SYNC);
+	munmap(p, size);
+	close(fd);
+	unlink(filename2);
+}
+
+void usage()
+{
+	fprintf(stderr, "usage: dio_sparse [-n step] [-s filesize]"
+		" [-w writesize] [-r readsize] filename\n");
+	exit(1);
+}
+
+/*
+ * Scale value by kilo, mega, or giga.
+ */
+long long scale_by_kmg(long long value, char scale)
+{
+	switch (scale) {
+	case 'g':
+	case 'G':
+		value *= 1024;
+	case 'm':
+	case 'M':
+		value *= 1024;
+	case 'k':
+	case 'K':
+		value *= 1024;
+		break;
+	case '\0':
+		break;
+	default:
+		usage();
+		break;
+	}
+	return value;
+}
+
+/*
+ *	usage:
+ * aiodio_sparse [-r readsize] [-w writesize] [-n step] [-a align] [-i num_aio] filename
+ */
+
+int main(int argc, char **argv)
+{
+	char filename[PATH_MAX];
+	long alignment = 512;
+	int readsize = 65536;
+	int writesize = 65536;
+	int filesize = 100*1024*1024;
+	int num_aio = 16;
+	int step = 5*1024*1024;
+	int c, direct = O_DIRECT, keep = 0, sparse = 1;
+	extern char *optarg;
+	extern int optind, optopt, opterr;
+
+	while ((c = getopt(argc, argv, "dr:w:n:a:s:i:DkS")) != -1) {
+		char *endp;
+		switch (c) {
+		case 'D':
+			direct = 0;
+			break;
+		case 'k':
+			keep = 1;
+			break;
+		case 'S':
+			sparse = 0;
+			break;
+		case 'd':
+			debug++;
+			break;
+		case 'i':
+			num_aio = atoi(optarg);
+			break;
+		case 'a':
+			alignment = strtol(optarg, &endp, 0);
+			alignment = (int)scale_by_kmg((long long)alignment,
+                                                        *endp);
+			break;
+		case 'r':
+			readsize = strtol(optarg, &endp, 0);
+			readsize = (int)scale_by_kmg((long long)readsize, *endp);
+			break;
+		case 'w':
+			writesize = strtol(optarg, &endp, 0);
+			writesize = (int)scale_by_kmg((long long)writesize, *endp);
+			break;
+		case 's':
+			filesize = strtol(optarg, &endp, 0);
+			filesize = (int)scale_by_kmg((long long)filesize, *endp);
+			break;
+		case 'n':
+			step = strtol(optarg, &endp, 0);
+			step = (int)scale_by_kmg((long long)step, *endp);
+			break;
+		case '?':
+			usage();
+			break;
+		}
+	}
+
+	strncpy(filename, argv[argc-1], PATH_MAX);
+
+	/*
+	 * Create some dirty free blocks by allocating, writing, syncing,
+	 * and then unlinking and freeing.
+	 */
+	dirty_freeblocks(filename, filesize);
+
+	/*
+	 * Parent write to a hole in a file using async direct i/o
+	 */
+
+	aiodio_sparse(filename, alignment, writesize, filesize, num_aio, step, sparse, direct, keep);
+
+	return 0;
+}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
