Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3TAWd8J063311 for <xfs@oss.sgi.com>; Thu, 29 Apr 2010 05:32:40 -0500
Date: Thu, 29 Apr 2010 06:34:44 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfstests: test extent size hints
Message-ID: <20100429103444.GA8019@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is an adapted version of the reproduced in OSS BZ #874, which
shows file corruption when using the extent size hint.

Geoffrey, can you say if licensing the small test program as GPLv2+
is fine so that we can add it to xfstests?


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests-dev/228
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests-dev/228	2010-04-29 10:28:56.000000000 +0000
@@ -0,0 +1,87 @@
+#! /bin/bash
+# FS QA Test No. 221
+#
+# Check for file corruption when using the extent size hint on
+# the normal data subvolume.
+#
+# http://oss.sgi.com/bugzilla/show_bug.cgi?id=874
+#
+# Based on a bug report and testcase from Geoffrey Wehrman <gwehrman@sgi.com>.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 Christoph Hellwig.  All Rights Reserved.
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
+# creator
+owner=hch@lst.de
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -rf ${TDIR}
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+TDIR="${TEST_DIR}/t_holes"
+NFILES="10"
+EXTSIZE="256k"
+
+# Create the test directory
+mkdir ${TDIR}
+
+# Set the test directory extsize
+xfs_io -c "extsize ${EXTSIZE}" ${TDIR}
+
+# Create a set of holey files
+echo "generating ${NFILES} files"
+
+for i in $(seq 0 ${NFILES}); do
+  $here/src/t_holes ${TDIR}/${i}
+done
+
+# Compare the files
+echo "comparing files"
+errcnt=0
+j=0
+for i in $(seq 0 ${NFILES}); do
+    let j=$i+1
+    while [ ${j} -lt ${NFILES} ] ; do
+	if ! cmp ${TDIR}/${i} ${TDIR}/${j} ; then
+	    let errcnt=$errcnt+1
+	fi
+	let j=$j+1
+    done
+done
+
+echo "got ${errcnt} errors"
+
+status=$errcnt
+exit $status
Index: xfstests-dev/228.out
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests-dev/228.out	2010-04-29 10:27:09.000000000 +0000
@@ -0,0 +1,4 @@
+QA output created by 228
+generating 10 files
+comparing files
+got 0 errors
Index: xfstests-dev/group
===================================================================
--- xfstests-dev.orig/group	2010-04-29 10:26:54.000000000 +0000
+++ xfstests-dev/group	2010-04-29 10:27:09.000000000 +0000
@@ -341,3 +341,4 @@ deprecated
 225 auto quick
 226 auto enospc
 227 auto fsr
+228 auto rw
Index: xfstests-dev/src/Makefile
===================================================================
--- xfstests-dev.orig/src/Makefile	2010-04-29 10:26:54.000000000 +0000
+++ xfstests-dev/src/Makefile	2010-04-29 10:27:09.000000000 +0000
@@ -10,7 +10,7 @@ TARGETS = dirstress fill fill2 getpagesi
 	mmapcat append_reader append_writer dirperf metaperf \
 	devzero feature alloc fault fstest t_access_root \
 	godown resvtest writemod makeextents itrash rename \
-	multi_open_unlink dmiperf unwritten_sync genhashnames
+	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
Index: xfstests-dev/src/t_holes.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests-dev/src/t_holes.c	2010-04-29 10:27:09.000000000 +0000
@@ -0,0 +1,29 @@
+
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/types.h>
+#include <stdio.h>
+
+int main(int argc, char **argv)
+{
+	int fd;
+	int j;
+	int i;
+	int buf[1024];
+
+	fd = open(argv[1], O_RDWR|O_CREAT, 0666);
+        for (i = 1; i < 9100; i++) {
+		for (j = 0; j < 1024; j++)
+			buf[j]  = i | i << 5;
+
+		if (write(fd,buf,253*4*sizeof(int))!= 253*4*sizeof(int))
+			printf("Write did not return correct amount\n");
+
+		if ((i % 9) == 0 && i < 9001)
+			lseek(fd, 4096 * 110,SEEK_CUR);
+	}
+
+	close(fd);
+
+	return 0;
+}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
