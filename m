Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q9GKfWM1219998 for <xfs@oss.sgi.com>; Tue, 16 Oct 2012 15:41:32 -0500
Received: from eagdhcp-232-125.americas.sgi.com
	(eagdhcp-232-125.americas.sgi.com [128.162.232.125])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5D78E8F8087
	for <xfs@oss.sgi.com>; Tue, 16 Oct 2012 13:43:10 -0700 (PDT)
Received: from eagdhcp-232-125.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-125.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	q9GKh8D8003991
	for <xfs@oss.sgi.com>; Tue, 16 Oct 2012 15:43:08 -0500 (CDT)
	(envelope-from tinguely@sgi.com)
Message-Id: <20121016204244.997819918@sgi.com>
Date: Tue, 16 Oct 2012 15:42:41 -0500
From: Mark Tinguely <tinguely@sgi.com>
Subject: xfstests: SEEK_HOLE/SEEK_DATA advanced tests
References: <20121016204240.142425319@sgi.com>
Content-Disposition: inline;
	filename=xfstests-advanced-seek_hole-seek_data.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is the test of the advanced SEEK_HOLE and SEEK_DATA features
of the lseek() function call.

Jie Liu <jeff.liu@oracle.com> wrote the C code, I converted it to
a test with his permission.

Signed-off-by: Mark Tinguely <tinguely@sgi.com
---
 288                     |   70 +++++++++++++++++
 288.out                 |    2 
 group                   |    1 
 src/Makefile            |    2 
 src/seek_advance_test.c |  189 ++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 263 insertions(+), 1 deletion(-)

Index: b/288
===================================================================
--- /dev/null
+++ b/288
@@ -0,0 +1,70 @@
+#! /bin/bash
+# FS QA Test No. 288
+#
+# SEEK_DATA/SEEK_HOLE advanced feature tests.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2012 SGI.  All Rights Reserved.
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
+owner=tinguely@sgi.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+status=1        # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+dir=$TEST_DIR
+src1=$dir/advseektst1
+src2=$dir/advseektst2
+
+[ -x $here/src/seek_advance_test ] || _notrun "seek_advance_test not built"
+
+_cleanup()
+{
+	rm -f $src1 $src2
+}
+
+	echo "Silence is golden..."
+	rm -f $src1 $src2
+        write_cmd1="-c \"falloc 512k 256k\" -c \"pwrite 516k 4k\" -c \
+		    \"pwrite 800k 4k\""
+        write_cmd2="-c \"falloc 512k 256k\" -c \"pwrite 600k 16k\""
+
+        eval ${XFS_IO_PROG} -F -f "${write_cmd1}" $src1 > $seq.full 2>&1 ||
+                _fail "create test1 file failed!"
+        echo "*** create test1 file done ***" >>$seq.full
+        eval ${XFS_IO_PROG} -F -f "${write_cmd2}" $src2 >>$seq.full 2>&1 ||
+                _fail "create test2 file failed!"
+        echo "*** create test2 file done ***" >>$seq.full
+        echo >>$seq.full
+        $here/src/seek_advance_test $dir >> $seq.full || _fail "test failed"
+
+status=0
+exit
+
Index: b/288.out
===================================================================
--- /dev/null
+++ b/288.out
@@ -0,0 +1,2 @@
+QA output created by 288
+Silence is golden...
Index: b/group
===================================================================
--- a/group
+++ b/group
@@ -406,3 +406,4 @@ deprecated
 285 auto rw
 286 other
 287 auto dump quota quick
+288 other
Index: b/src/Makefile
===================================================================
--- a/src/Makefile
+++ b/src/Makefile
@@ -18,7 +18,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getd
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked fstrim t_dir_offset2 seek_sanity_test \
-	seek_copy_test
+	seek_copy_test seek_advance_test
 
 SUBDIRS =
 
Index: b/src/seek_advance_test.c
===================================================================
--- /dev/null
+++ b/src/seek_advance_test.c
@@ -0,0 +1,189 @@
+/*
+ * Copyright (C) 2011-2012 Oracle. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public
+ * License v2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public
+ * License along with this program; if not, write to the
+ * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
+ * Boston, MA 021110-1307, USA.
+ */
+
+ /* Test the lseek() SEEK_DATA/SEEK_HOLE unwritten extent support
+  * found in XFS starting in Linux 3.7.
+  */
+
+#define _XOPEN_SOURCE 500
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/vfs.h>
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <string.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <assert.h>
+
+#ifndef SEEK_DATA
+#define SEEK_DATA	3
+#define SEEK_HOLE	4
+#endif
+
+char *base_file_path;
+
+int
+verify(
+	off_t offset,
+	off_t exp_hoff,
+	off_t exp_doff,
+	off_t hoff,
+	off_t doff)
+{
+	fprintf(stdout, "SEEK start %lu expect %ld/%ld got %ld/%ld [%s]\n",
+	offset, exp_hoff, exp_doff, hoff, doff,
+	(hoff == exp_hoff && doff == exp_doff) ? "PASS" : "FAIL");
+
+	return(hoff != exp_hoff || doff != exp_doff);
+}
+
+int
+test01(void)
+{
+	int fd, ret=0;
+	char filename[32];
+	off_t hpos, dpos;
+
+	snprintf(filename, sizeof(filename), "%s/advseektst1", base_file_path);
+	fd = open(filename, O_RDWR, 0644);
+	if (fd < 0) {
+		fprintf(stderr, " ERROR %d: Failed to open file '%s'\n",
+			errno, filename);
+		return(1);
+	}
+
+	hpos = lseek(fd, 512*1024, SEEK_HOLE);
+	dpos = lseek(fd, 512*1024, SEEK_DATA);
+	ret += verify(512*1024, 512*1024, 516*1024, hpos, dpos);
+
+	/* Wrote 4k past 516k, the hole located at 520k */
+	hpos = lseek(fd, 516*1024, SEEK_HOLE);
+	dpos = lseek(fd, 516*1024, SEEK_DATA);
+	ret += verify(516*1024, 520*1024, 516*1024, hpos, dpos);
+
+	hpos = lseek(fd, 520*1024, SEEK_HOLE);
+	dpos = lseek(fd, 520*1024, SEEK_DATA);
+	ret += verify(520*1024, 520*1024, 800*1024, hpos, dpos);
+
+	hpos = lseek(fd, 800*1024, SEEK_HOLE);
+	dpos = lseek(fd, 800*1024, SEEK_DATA);
+	/* Wrote 4k past 800k, the hole located at 804k */
+	ret += verify(800*1024, 804*1024, 800*1024, hpos, dpos);
+
+	/* A few cases for byte precious verfication */
+	hpos = lseek(fd, 512*1024 - 1, SEEK_HOLE);
+	dpos = lseek(fd, 512*1024 - 1, SEEK_DATA);
+	ret += verify(512*1024-1, 512*1024-1, 516*1024, hpos, dpos);
+
+	/* 516k landed in hole, wrote 4k past 516k */
+	hpos = lseek(fd, 516*1024 - 1, SEEK_HOLE);
+	dpos = lseek(fd, 516*1024 - 1, SEEK_DATA);
+	ret += verify(516*1024-1, 516*1024-1, 516*1024, hpos, dpos);
+
+	hpos = lseek(fd, 520*1024 - 1, SEEK_HOLE);
+	dpos = lseek(fd, 520*1024 - 1, SEEK_DATA);
+	ret += verify(520*1024-1, 520*1024, 520*1024-1, hpos, dpos);
+
+	/* Wrote 4k past 800k, 800k-1 is hole */
+	hpos = lseek(fd, 800*1024-1, SEEK_HOLE);
+	dpos = lseek(fd, 800*1024-1, SEEK_DATA);
+	ret += verify(800*1024-1, 800*1024-1, 800*1024, hpos, dpos);
+	close(fd);
+	return(ret);
+}
+
+int
+test02(void)
+{
+	int fd, ret=0;
+	char filename[32];
+	off_t hpos, dpos;
+
+	snprintf(filename, sizeof(filename), "%s/advseektst2", base_file_path);
+	fd = open(filename, O_RDWR, 0644);
+	if (fd < 0) {
+		fprintf(stderr, " ERROR %d: Failed to open file '%s'\n",
+			errno, filename);
+		return(1);
+	}
+
+	hpos = lseek(fd, 511*1024, SEEK_HOLE);
+	dpos = lseek(fd, 511*1024, SEEK_DATA);
+	ret += verify(511*1014, 511*1024, 600*1024, hpos, dpos);
+
+	/* Wrote 16k past 600, the hole locate at 616k */
+	hpos = lseek(fd, 600*1024, SEEK_HOLE);
+	dpos = lseek(fd, 600*1024, SEEK_DATA);
+	ret += verify(600*1024, 616*1024, 600*1024, hpos, dpos);
+
+	hpos = lseek(fd, 604*1024, SEEK_HOLE);
+	dpos = lseek(fd, 604*1024, SEEK_DATA);
+	ret += verify(604*1024, 616*1024, 604*1024, hpos, dpos);
+
+	hpos = lseek(fd, 608*1024, SEEK_HOLE);
+	dpos = lseek(fd, 608*1024, SEEK_DATA);
+	ret += verify(608*1024, 616*1024, 608*1024, hpos, dpos);
+
+	hpos = lseek(fd, 609*1024, SEEK_HOLE);
+	dpos = lseek(fd, 609*1024, SEEK_DATA);
+	ret += verify(609*1024, 616*1024, 609*1024, hpos, dpos);
+
+	hpos = lseek(fd, 612*1024, SEEK_HOLE);
+	dpos = lseek(fd, 612*1024, SEEK_DATA);
+	ret += verify(612*1024, 616*1024, 612*1024, hpos, dpos);
+
+	hpos = lseek(fd, 616*1024, SEEK_HOLE);
+	dpos = lseek(fd, 616*1024, SEEK_DATA);
+	ret += verify(616*1024, 616*1024, -1, hpos, dpos);
+
+	hpos = lseek(fd, 616*1024 - 1, SEEK_HOLE);
+	dpos = lseek(fd, 616*1024 - 1, SEEK_DATA);
+	ret += verify(616*1024-1, 616*1024, 616*1024-1, hpos, dpos);
+
+	hpos = lseek(fd, 616*1024 + 1, SEEK_HOLE);
+	dpos = lseek(fd, 616*1024 + 1, SEEK_DATA);
+	ret += verify(616*1024+1, 616*1024+1, -1, hpos, dpos);
+	close(fd);
+	return(ret);
+}
+
+int
+main(
+	int argc,
+	char **argv)
+{
+	int ret = 0;
+
+	if (argc != 2) {
+	fprintf(stdout, "Usage: %s base_file_path\n", argv[0]);
+	exit(1);
+	}
+
+	base_file_path = (char *)strdup(argv[1]);
+	if (!base_file_path)
+	return ret;
+
+	ret = test01();
+	printf("\n");
+	ret += test02();
+
+	free(base_file_path);
+	exit(ret);
+}


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
