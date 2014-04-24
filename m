Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8FD677F52
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 14:13:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 415D18F8040
	for <xfs@oss.sgi.com>; Thu, 24 Apr 2014 12:13:35 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6xISJferKAGAx7Bb for
	<xfs@oss.sgi.com>; Thu, 24 Apr 2014 12:13:34 -0700 (PDT)
Message-ID: <5359625B.3090001@redhat.com>
Date: Thu, 24 Apr 2014 14:13:31 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: test pipe resizing
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
Cc: Miklos Szeredi <miklos@szeredi.hu>

Add a simple test to exercise the pipe resize fcntls,
F_SETPIPE_SZ and F_GETPIPE_SZ.

This doesn't do a whole lot, but does some pipe reading
and writing, some pipe resizing and checking, validates
that we get EBUSY if we try to resize below the current
size of buffers in the pipe, that the minimum is limited
to PAGE_SIZE, etc.

The piperesize.c is based on an old test written
by Miklos which used to be at

http://www.kernel.org/pub/linux/kernel/people/mszeredi/piperesize/piperesize.c

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
---


diff --git a/src/Makefile b/src/Makefile
index d754048..7f403d8 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -19,7 +19,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
 	seek_copy_test t_readdir_1 t_readdir_2 fsync-tester nsexec cloner \
-	renameat2
+	renameat2 piperesize
 
 SUBDIRS =
 
diff --git a/src/piperesize.c b/src/piperesize.c
new file mode 100644
index 0000000..f292db1
--- /dev/null
+++ b/src/piperesize.c
@@ -0,0 +1,133 @@
+#include <stdio.h>
+#include <fcntl.h>
+#include <unistd.h>
+#include <err.h>
+#include <errno.h>
+#include <string.h>
+
+#ifndef F_LINUX_SPECIFIC_BASE
+#define F_LINUX_SPECIFIC_BASE       1024
+#endif
+#ifndef F_SETPIPE_SZ
+#define F_SETPIPE_SZ	(F_LINUX_SPECIFIC_BASE + 7)
+#endif
+#ifndef F_GETPIPE_SZ
+#define F_GETPIPE_SZ	(F_LINUX_SPECIFIC_BASE + 8)
+#endif
+
+#define WRITE_PIPE	1
+#define READ_PIPE	2
+
+#define NONFATAL	0
+#define FATAL		1
+
+int i;
+int outstanding;
+int pip[2];
+
+void writeread_pipe(int count, int flags)
+{
+	int res = 0;
+	char buf[4096];
+
+	if (!flags)
+		return;
+
+	for (; i < count; i++) {
+		printf("Iter %d - ", i);
+		if (flags & WRITE_PIPE) {
+			sprintf(buf, "buffer #%i", i);
+			res = write(pip[1], buf, sizeof(buf));
+			if (res == -1)
+				err(1, "write");
+			printf("Wrote: %s ", buf);
+			outstanding++;
+		}
+	
+		if (flags & READ_PIPE) {
+			res = read(pip[0], buf, sizeof(buf));
+			if (res == -1)
+				err(1, "read");
+			printf("Read: %s ", buf);
+			outstanding--;
+		}
+		printf("\n");
+	}
+	printf("%d buffers left in pipe\n", outstanding);
+
+}
+
+void resize_pipe(int size, int fatal)
+{
+	int res;
+	long page_size = sysconf(_SC_PAGESIZE);
+
+	printf("Attempting to resize pipe to %d\n", size);
+	res = fcntl(pip[0], F_SETPIPE_SZ, size);
+	if (res == -1) {
+		if (fatal || (errno != EBUSY))
+			err(1, "F_SETPIPE_SZ");
+		else if (errno)
+			printf("F_SETPIPE_SZ: %s\n", strerror(errno));
+	}
+
+	res = fcntl(pip[1], F_GETPIPE_SZ);
+	if (res == -1)
+		err(1, "F_GETPIPE_SZ");
+
+	/* if we try to go below system page size, it's limited to that */
+	if (size < page_size && res == page_size)
+		printf("now pipe size is: PAGE_SIZE\n");
+	else
+		printf("now pipe size is: %i\n", res);
+
+	if (fatal) {
+		if (res != (size < page_size ? page_size : size))
+			err(1, "Resize failed");
+	}
+}
+
+int main(void)
+{
+	int res;
+
+	res = pipe(pip);
+	if (res == -1)
+		err(1, "pipe");
+
+	/*
+	 * Write 7 x 4k buffers to the pipe; these linger
+	 */ 
+	writeread_pipe(7, WRITE_PIPE);
+
+	/*
+	 * Do a handful of new writes followed by reads
+	 */ 
+	writeread_pipe(21, WRITE_PIPE|READ_PIPE);
+
+	/* Resize pipe to 8k; should fail EBUSY & print that */
+	resize_pipe(8192, NONFATAL);
+
+	/* Resize pipe to 128k */
+	resize_pipe(131072, FATAL);
+
+	/* A bunch more writes & reads */
+	writeread_pipe(70, WRITE_PIPE|READ_PIPE);
+
+	/* resize pipe back down to 32k */
+	resize_pipe(32768, FATAL);
+
+	/* even more writes & reads */
+	writeread_pipe(100, WRITE_PIPE|READ_PIPE);
+
+	/* empty the pipe */
+	writeread_pipe(107, READ_PIPE);
+
+	/* resizing pipe to 0 should be limited to 4k (?) */
+	resize_pipe(0, FATAL);
+
+	close(pip[0]);
+	close(pip[1]);
+	return 0;
+}
+
diff --git a/tests/generic/026 b/tests/generic/026
new file mode 100755
index 0000000..4f462a8
--- /dev/null
+++ b/tests/generic/026
@@ -0,0 +1,55 @@
+#! /bin/bash
+# FS QA Test No. 026
+#
+# Test pipe resizing
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Red Hat, Inc.  All Rights Reserved.
+#
+# This program is free software; you can redistribute it and/or
+# modify it under the terms of the GNU General Public License as
+# published by the Free Software Foundation.
+#
+# This program is distributed in the hope that it would be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write the Free Software Foundation,
+# Inc.,  51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
+#
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+tmp=/tmp/$$
+here=`pwd`
+status=1
+done_cleanup=false
+trap "_cleanup; rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $tmp.*
+}
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+test -f /proc/sys/fs/pipe-max-size || _notrun "Dynamic pipe resizing unsupported"
+
+[ -x $here/src/piperesize ] || _notrun "piperesize not built"
+$here/src/piperesize
+
+status=0
+exit
diff --git a/tests/generic/026.out b/tests/generic/026.out
new file mode 100755
index 0000000..e2a9a33
--- /dev/null
+++ b/tests/generic/026.out
@@ -0,0 +1,122 @@
+QA output created by 026
+Iter 0 - Wrote: buffer #0 
+Iter 1 - Wrote: buffer #1 
+Iter 2 - Wrote: buffer #2 
+Iter 3 - Wrote: buffer #3 
+Iter 4 - Wrote: buffer #4 
+Iter 5 - Wrote: buffer #5 
+Iter 6 - Wrote: buffer #6 
+7 buffers left in pipe
+Iter 7 - Wrote: buffer #7 Read: buffer #0 
+Iter 8 - Wrote: buffer #8 Read: buffer #1 
+Iter 9 - Wrote: buffer #9 Read: buffer #2 
+Iter 10 - Wrote: buffer #10 Read: buffer #3 
+Iter 11 - Wrote: buffer #11 Read: buffer #4 
+Iter 12 - Wrote: buffer #12 Read: buffer #5 
+Iter 13 - Wrote: buffer #13 Read: buffer #6 
+Iter 14 - Wrote: buffer #14 Read: buffer #7 
+Iter 15 - Wrote: buffer #15 Read: buffer #8 
+Iter 16 - Wrote: buffer #16 Read: buffer #9 
+Iter 17 - Wrote: buffer #17 Read: buffer #10 
+Iter 18 - Wrote: buffer #18 Read: buffer #11 
+Iter 19 - Wrote: buffer #19 Read: buffer #12 
+Iter 20 - Wrote: buffer #20 Read: buffer #13 
+7 buffers left in pipe
+Attempting to resize pipe to 8192
+F_SETPIPE_SZ: Device or resource busy
+now pipe size is: 65536
+Attempting to resize pipe to 131072
+now pipe size is: 131072
+Iter 21 - Wrote: buffer #21 Read: buffer #14 
+Iter 22 - Wrote: buffer #22 Read: buffer #15 
+Iter 23 - Wrote: buffer #23 Read: buffer #16 
+Iter 24 - Wrote: buffer #24 Read: buffer #17 
+Iter 25 - Wrote: buffer #25 Read: buffer #18 
+Iter 26 - Wrote: buffer #26 Read: buffer #19 
+Iter 27 - Wrote: buffer #27 Read: buffer #20 
+Iter 28 - Wrote: buffer #28 Read: buffer #21 
+Iter 29 - Wrote: buffer #29 Read: buffer #22 
+Iter 30 - Wrote: buffer #30 Read: buffer #23 
+Iter 31 - Wrote: buffer #31 Read: buffer #24 
+Iter 32 - Wrote: buffer #32 Read: buffer #25 
+Iter 33 - Wrote: buffer #33 Read: buffer #26 
+Iter 34 - Wrote: buffer #34 Read: buffer #27 
+Iter 35 - Wrote: buffer #35 Read: buffer #28 
+Iter 36 - Wrote: buffer #36 Read: buffer #29 
+Iter 37 - Wrote: buffer #37 Read: buffer #30 
+Iter 38 - Wrote: buffer #38 Read: buffer #31 
+Iter 39 - Wrote: buffer #39 Read: buffer #32 
+Iter 40 - Wrote: buffer #40 Read: buffer #33 
+Iter 41 - Wrote: buffer #41 Read: buffer #34 
+Iter 42 - Wrote: buffer #42 Read: buffer #35 
+Iter 43 - Wrote: buffer #43 Read: buffer #36 
+Iter 44 - Wrote: buffer #44 Read: buffer #37 
+Iter 45 - Wrote: buffer #45 Read: buffer #38 
+Iter 46 - Wrote: buffer #46 Read: buffer #39 
+Iter 47 - Wrote: buffer #47 Read: buffer #40 
+Iter 48 - Wrote: buffer #48 Read: buffer #41 
+Iter 49 - Wrote: buffer #49 Read: buffer #42 
+Iter 50 - Wrote: buffer #50 Read: buffer #43 
+Iter 51 - Wrote: buffer #51 Read: buffer #44 
+Iter 52 - Wrote: buffer #52 Read: buffer #45 
+Iter 53 - Wrote: buffer #53 Read: buffer #46 
+Iter 54 - Wrote: buffer #54 Read: buffer #47 
+Iter 55 - Wrote: buffer #55 Read: buffer #48 
+Iter 56 - Wrote: buffer #56 Read: buffer #49 
+Iter 57 - Wrote: buffer #57 Read: buffer #50 
+Iter 58 - Wrote: buffer #58 Read: buffer #51 
+Iter 59 - Wrote: buffer #59 Read: buffer #52 
+Iter 60 - Wrote: buffer #60 Read: buffer #53 
+Iter 61 - Wrote: buffer #61 Read: buffer #54 
+Iter 62 - Wrote: buffer #62 Read: buffer #55 
+Iter 63 - Wrote: buffer #63 Read: buffer #56 
+Iter 64 - Wrote: buffer #64 Read: buffer #57 
+Iter 65 - Wrote: buffer #65 Read: buffer #58 
+Iter 66 - Wrote: buffer #66 Read: buffer #59 
+Iter 67 - Wrote: buffer #67 Read: buffer #60 
+Iter 68 - Wrote: buffer #68 Read: buffer #61 
+Iter 69 - Wrote: buffer #69 Read: buffer #62 
+7 buffers left in pipe
+Attempting to resize pipe to 32768
+now pipe size is: 32768
+Iter 70 - Wrote: buffer #70 Read: buffer #63 
+Iter 71 - Wrote: buffer #71 Read: buffer #64 
+Iter 72 - Wrote: buffer #72 Read: buffer #65 
+Iter 73 - Wrote: buffer #73 Read: buffer #66 
+Iter 74 - Wrote: buffer #74 Read: buffer #67 
+Iter 75 - Wrote: buffer #75 Read: buffer #68 
+Iter 76 - Wrote: buffer #76 Read: buffer #69 
+Iter 77 - Wrote: buffer #77 Read: buffer #70 
+Iter 78 - Wrote: buffer #78 Read: buffer #71 
+Iter 79 - Wrote: buffer #79 Read: buffer #72 
+Iter 80 - Wrote: buffer #80 Read: buffer #73 
+Iter 81 - Wrote: buffer #81 Read: buffer #74 
+Iter 82 - Wrote: buffer #82 Read: buffer #75 
+Iter 83 - Wrote: buffer #83 Read: buffer #76 
+Iter 84 - Wrote: buffer #84 Read: buffer #77 
+Iter 85 - Wrote: buffer #85 Read: buffer #78 
+Iter 86 - Wrote: buffer #86 Read: buffer #79 
+Iter 87 - Wrote: buffer #87 Read: buffer #80 
+Iter 88 - Wrote: buffer #88 Read: buffer #81 
+Iter 89 - Wrote: buffer #89 Read: buffer #82 
+Iter 90 - Wrote: buffer #90 Read: buffer #83 
+Iter 91 - Wrote: buffer #91 Read: buffer #84 
+Iter 92 - Wrote: buffer #92 Read: buffer #85 
+Iter 93 - Wrote: buffer #93 Read: buffer #86 
+Iter 94 - Wrote: buffer #94 Read: buffer #87 
+Iter 95 - Wrote: buffer #95 Read: buffer #88 
+Iter 96 - Wrote: buffer #96 Read: buffer #89 
+Iter 97 - Wrote: buffer #97 Read: buffer #90 
+Iter 98 - Wrote: buffer #98 Read: buffer #91 
+Iter 99 - Wrote: buffer #99 Read: buffer #92 
+7 buffers left in pipe
+Iter 100 - Read: buffer #93 
+Iter 101 - Read: buffer #94 
+Iter 102 - Read: buffer #95 
+Iter 103 - Read: buffer #96 
+Iter 104 - Read: buffer #97 
+Iter 105 - Read: buffer #98 
+Iter 106 - Read: buffer #99 
+0 buffers left in pipe
+Attempting to resize pipe to 0
+now pipe size is: PAGE_SIZE
diff --git a/tests/generic/group b/tests/generic/group
index 60d6066..a6eabbf 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -28,6 +28,7 @@
 023 auto quick
 024 auto quick
 025 auto quick
+026 auto quick
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
