Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7CECF7F37
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 12:51:53 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 06013AC002
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 10:51:52 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gkymFh2JKK6BXEXW for
	<xfs@oss.sgi.com>; Mon, 20 May 2013 10:51:48 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r4KHpmlq022041
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 20 May 2013 13:51:48 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfstests generic/313: test ctime and mtime are updated on
	truncate and ftruncate
Date: Tue, 21 May 2013 01:51:41 +0800
Message-Id: <1369072301-13690-1-git-send-email-eguan@redhat.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Eryu Guan <eguan@redhat.com>

Regression test for commit:
3972f26 btrfs: update timestamps on truncate()

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 src/Makefile            |   2 +-
 src/t_truncate_cmtime.c | 110 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/313       |  55 ++++++++++++++++++++++++
 tests/generic/313.out   |   2 +
 tests/generic/group     |   1 +
 5 files changed, 169 insertions(+), 1 deletion(-)
 create mode 100644 src/t_truncate_cmtime.c
 create mode 100755 tests/generic/313
 create mode 100644 tests/generic/313.out

diff --git a/src/Makefile b/src/Makefile
index c18ffc9..cc679e8 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -11,7 +11,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	devzero feature alloc fault fstest t_access_root \
 	godown resvtest writemod makeextents itrash rename \
 	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes \
-	t_mmap_writev
+	t_mmap_writev t_truncate_cmtime
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
diff --git a/src/t_truncate_cmtime.c b/src/t_truncate_cmtime.c
new file mode 100644
index 0000000..b08ca44
--- /dev/null
+++ b/src/t_truncate_cmtime.c
@@ -0,0 +1,110 @@
+/*
+ * Test ctime and mtime are updated on truncate(2) and ftruncate(2)
+ *
+ * Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
+#include <sys/stat.h>
+#include <sys/types.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+
+#define TEST_MSG "this is a test string"
+
+int do_test(const char *file, int is_ftrunc)
+{
+	int ret;
+	int fd;
+	struct stat statbuf1;
+	struct stat statbuf2;
+
+	ret = 0;
+	fd = open(file, O_RDWR | O_CREAT | O_TRUNC, 0644);
+	if (fd == -1) {
+		perror("open(2) failed");
+		exit(EXIT_FAILURE);
+	}
+
+	ret = write(fd, TEST_MSG, sizeof(TEST_MSG));
+	if (ret == -1) {
+		perror("write(2) failed");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Get timestamps before [f]truncate(2) */
+	ret = fstat(fd, &statbuf1);
+	if (ret == -1) {
+		perror("fstat(2) failed");
+		exit(EXIT_FAILURE);
+	}
+
+	sleep(1);
+	if (is_ftrunc) {
+		ret = ftruncate(fd, 0);
+		if (ret == -1) {
+			perror("ftruncate(2) failed");
+			exit(EXIT_FAILURE);
+		}
+	} else {
+		ret = truncate(file, 0);
+		if (ret == -1) {
+			perror("truncate(2) failed");
+			exit(EXIT_FAILURE);
+		}
+	}
+
+	/* Get timestamps after [f]truncate(2) */
+	ret = fstat(fd, &statbuf2);
+	if (ret == -1) {
+		perror("fstat(2) failed");
+		exit(EXIT_FAILURE);
+	}
+
+	/* Check whether timestamps got updated */
+	if (statbuf1.st_ctime == statbuf2.st_ctime) {
+		fprintf(stderr, "ctime not updated after %s\n",
+			is_ftrunc ? "ftruncate" : "truncate");
+		ret++;
+	}
+	if (statbuf1.st_mtime == statbuf2.st_mtime) {
+		fprintf(stderr, "mtime not updated after %s\n",
+			is_ftrunc ? "ftruncate" : "truncate");
+		ret++;
+	}
+
+	close(fd);
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+	char *testfile;
+
+	ret = 0;
+	if (argc != 2) {
+		fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
+		exit(EXIT_FAILURE);
+	}
+	testfile = argv[1];
+
+	ret = do_test(testfile, 0);
+	ret += do_test(testfile, 1);
+
+	exit(ret);
+}
diff --git a/tests/generic/313 b/tests/generic/313
new file mode 100755
index 0000000..1237ded
--- /dev/null
+++ b/tests/generic/313
@@ -0,0 +1,55 @@
+#! /bin/bash
+# FS QA Test No. 313
+#
+# Check ctime and mtime are updated on truncate(2) and ftruncate(2)
+#
+# Regression test for commit:
+# 3972f26 btrfs: update timestamps on truncate()
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Red Hat, Inc.  All Rights Reserved.
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
+#-----------------------------------------------------------------------
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+testfile=$TEST_DIR/testfile.$seq
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -f $testfile
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os IRIX Linux
+
+echo "Silence is golden"
+
+$here/src/t_truncate_cmtime $testfile 2>&1
+
+status=0
+exit
diff --git a/tests/generic/313.out b/tests/generic/313.out
new file mode 100644
index 0000000..2684669
--- /dev/null
+++ b/tests/generic/313.out
@@ -0,0 +1,2 @@
+QA output created by 313
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index e2ef70e..7965bfa 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -115,3 +115,4 @@
 310 auto
 311 auto metadata log
 312 auto quick prealloc enospc
+313 auto quick
-- 
1.8.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
