Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 07 May 2007 23:53:40 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l486rYfB030943
	for <xfs@oss.sgi.com>; Mon, 7 May 2007 23:53:35 -0700
Date: Tue, 8 May 2007 16:53:27 +1000
From: David Chinner <dgc@sgi.com>
Subject: Review: XFSQA: unwritten extent conversion vs synchronous direct I/O
Message-ID: <20070508065327.GL32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

Test to exercise synchronous direct I/O into unwritten extents.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group

---
 xfstests/167                  |   65 ++++++++++++++++
 xfstests/167.out              |    3 
 xfstests/group                |    1 
 xfstests/src/Makefile         |    5 +
 xfstests/src/unwritten_sync.c |  167 ++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 240 insertions(+), 1 deletion(-)

Index: xfs-cmds/xfstests/src/Makefile
===================================================================
--- xfs-cmds.orig/xfstests/src/Makefile	2007-05-03 17:10:54.000000000 +1000
+++ xfs-cmds/xfstests/src/Makefile	2007-05-07 10:54:08.296322074 +1000
@@ -10,7 +10,7 @@ TARGETS = dirstress fill fill2 getpagesi
 	mmapcat append_reader append_writer dirperf metaperf \
 	devzero feature alloc fault fstest t_access_root \
 	godown resvtest writemod makeextents itrash \
-	multi_open_unlink dmiperf
+	multi_open_unlink dmiperf unwritten_sync
 
 LINUX_TARGETS = loggen xfsctl bstat t_mtab getdevicesize \
 	preallo_rw_pattern_reader preallo_rw_pattern_writer ftrunc trunc \
@@ -111,6 +111,9 @@ looptest: looptest.o
 locktest: locktest.o
 	$(LINKTEST)
 
+unwritten_sync: unwritten_sync.o
+	$(LINKTEST)
+
 ifeq ($(PKG_PLATFORM),irix)
 fill2: fill2.o
 	$(LINKTEST)  -lgen
Index: xfs-cmds/xfstests/src/unwritten_sync.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs-cmds/xfstests/src/unwritten_sync.c	2007-05-07 11:44:38.668980258 +1000
@@ -0,0 +1,167 @@
+#include <sys/types.h>
+#include <fcntl.h>
+#include <errno.h>
+#include <malloc.h>
+#include <unistd.h>
+#include <xfs/xfs.h>
+
+/* test thanks to judith@sgi.com */
+
+#define IO_SIZE	1048576
+
+void
+print_getbmapx(
+	const char	*pathname,
+	int		fd,
+	int64_t		start,
+	int64_t		limit);
+
+int
+main(int argc, char *argv[])
+{
+	int i;
+	int fd;
+	char *buf;
+	struct dioattr dio;
+	xfs_flock64_t flock;
+	off_t offset;
+	char	*file;
+	int	loops;
+
+	if(argc != 3) {
+		fprintf(stderr, "%s <loops> <file>\n", argv[0]);
+		exit(1);
+	}
+
+	errno = 0;
+	loops = strtoull(argv[1], NULL, 0);
+	if (errno) {
+		perror("strtoull");
+		exit(errno);
+	}
+	file = argv[2];
+
+	while (loops-- > 0) {
+		sleep(1);
+		fd = open(file, O_RDWR|O_CREAT|O_DIRECT, 0666);
+		if (fd < 0) {
+			perror("open");
+			exit(1);
+		}
+		if (xfsctl(file, fd, XFS_IOC_DIOINFO, &dio) < 0) {
+			perror("dioinfo");
+			exit(1);
+		}
+
+		if ((dio.d_miniosz > IO_SIZE) || (dio.d_maxiosz < IO_SIZE)) {
+			fprintf(stderr,"Test won't work. Sorry\n");
+			exit(1);
+		}
+		buf = (char *)memalign(dio.d_mem , IO_SIZE);
+		if (buf == NULL) {
+			fprintf(stderr,"Can't get memory\n");
+			exit(1);
+		}
+		memset(buf,'Z',IO_SIZE);
+		offset = 0;
+
+		flock.l_whence = 0;
+		flock.l_start= 0;
+		flock.l_len = IO_SIZE*21;
+		if (xfsctl(file, fd, XFS_IOC_RESVSP64, &flock) < 0) {
+			perror("xfsctl ");
+			exit(1);
+		}
+		for (i = 0; i < 21; i++) {
+			if (pwrite(fd, buf, IO_SIZE, offset) != IO_SIZE) {
+				perror("pwrite");
+				exit(1);
+			}
+			offset += IO_SIZE;
+		}
+
+		print_getbmapx(file, fd, 0, 0);
+
+		flock.l_whence = 0;
+		flock.l_start= 0;
+		flock.l_len = 0;
+		xfsctl(file, fd, XFS_IOC_FREESP64, &flock);
+		print_getbmapx(file, fd, 0, 0);
+		close(fd);
+	}
+}
+
+
+
+int
+get_getbmapx(
+	const char	*pathname,
+	int		fd,
+	struct getbmapx	*bmapx)
+{
+	int     rc;
+
+	rc = ioctl(fd, XFS_IOC_GETBMAPX, bmapx);
+	if (rc < 0) {
+		perror("xfs_ioc_getbmapx");
+		exit(1);
+	}
+}
+
+void
+print_getbmapx(
+const   char	*pathname,
+	int	fd,
+	int64_t	start,
+	int64_t	limit)
+{
+	struct getbmapx bmapx[50];
+	int array_size = sizeof(bmapx) / sizeof(bmapx[0]);
+	int x;
+	int foundone = 0;
+	int foundany = 0;
+
+again:
+	foundone = 0;
+	memset(bmapx, '\0', sizeof(bmapx));
+
+	bmapx[0].bmv_offset = start;
+	bmapx[0].bmv_length = -1; /* limit - start; */
+	bmapx[0].bmv_count = array_size;
+	bmapx[0].bmv_entries = 0;       /* no entries filled in yet */
+
+	bmapx[0].bmv_iflags = BMV_IF_PREALLOC;
+
+	x = array_size;
+	for (;;) {
+		if (x > bmapx[0].bmv_entries) {
+			if (x != array_size) {
+				break;  /* end of file */
+			}
+			if (get_getbmapx(pathname, fd, bmapx) < 0) {
+				fprintf(stderr, "getbmapx failed\n");
+				exit(1);
+			}
+			if (bmapx[0].bmv_entries == 0) {
+				break;
+			}
+			x = 1;  /* back at first extent in buffer */
+		}
+		if (bmapx[x].bmv_oflags & 1) {
+			fprintf(stderr, "FOUND ONE %lld %lld %x\n",
+				bmapx[x].bmv_offset, bmapx[x].bmv_length,bmapx[x].bmv_oflags);
+			foundone = 1;
+			foundany = 1;
+		}
+		x++;
+	}
+	if (foundone) {
+		sleep(1);
+		fprintf(stderr,"Repeat\n");
+		goto again;
+	}
+	if (foundany) {
+		exit(1);
+	}
+}
+
Index: xfs-cmds/xfstests/167
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs-cmds/xfstests/167	2007-05-07 16:02:58.993892587 +1000
@@ -0,0 +1,65 @@
+#! /bin/sh
+# FSQA Test No. 167
+#
+# unwritten extent conversion test
+#
+#-----------------------------------------------------------------------
+#  Copyright (c) 2007 Silicon Graphics, Inc.  All Rights Reserved.
+#-----------------------------------------------------------------------
+#
+# creator
+owner=dgc@sgi.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+rm -f $seq.full
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	killall -q -TERM fsstress 2> /dev/null
+	_cleanup_testdir
+}
+
+workout()
+{
+	procs=100
+	nops=15000
+	$FSSTRESS_PROG -d $SCRATCH_MNT -p $procs -n $nops $FSSTRESS_AVOID \
+		>>$seq.full &
+	sleep 2
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_setup_testdir
+_require_scratch
+_scratch_mkfs_xfs >/dev/null 2>&1
+_scratch_mount
+
+TEST_FILE=$SCRATCH_MNT/test_file
+TEST_PROG=$here/src/unwritten_sync
+LOOPS=100
+
+echo "*** test unwritten extent conversion under heavy I/O"
+
+workout
+
+rm -f $TEST_FILE
+$TEST_PROG $LOOPS $TEST_FILE
+killall -q -TERM fsstress 2> /dev/null
+
+echo "     *** test done"
+
+status=0
+exit
Index: xfs-cmds/xfstests/167.out
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs-cmds/xfstests/167.out	2007-05-07 11:46:46.560202917 +1000
@@ -0,0 +1,3 @@
+QA output created by 167
+*** test unwritten extent conversion under heavy I/O
+     *** test done
Index: xfs-cmds/xfstests/group
===================================================================
--- xfs-cmds.orig/xfstests/group	2007-04-23 16:22:06.000000000 +1000
+++ xfs-cmds/xfstests/group	2007-05-07 10:57:00.721817454 +1000
@@ -246,3 +246,4 @@ pattern         ajones@sgi.com
 164 rw pattern auto
 165 rw pattern auto
 166 rw metadata auto
+167 rw metadata auto
