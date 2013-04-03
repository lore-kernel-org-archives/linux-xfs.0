Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 45C627FCA
	for <xfs@oss.sgi.com>; Wed,  3 Apr 2013 01:09:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 30ECE304081
	for <xfs@oss.sgi.com>; Tue,  2 Apr 2013 23:09:39 -0700 (PDT)
Received: from mail-pa0-f44.google.com (mail-pa0-f44.google.com
	[209.85.220.44]) by cuda.sgi.com with ESMTP id 4nSPTF2dBLqFDgbh
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 02 Apr 2013 23:09:37 -0700 (PDT)
Received: by mail-pa0-f44.google.com with SMTP id bi5so719957pad.3
	for <xfs@oss.sgi.com>; Tue, 02 Apr 2013 23:09:37 -0700 (PDT)
Message-ID: <515BC786.3070102@gmail.com>
Date: Wed, 03 Apr 2013 14:09:10 +0800
From: Zhao Hongjiang <zhaohongjiang37@gmail.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: Check concurrently of readdir and read on the same
	directory fd
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
Cc: linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com

From: Zhao Hongjiang <zhaohongjiang@huawei.com>

Check if there are two threads,one keeps calling read() or lseek(), and
the other calling readdir(), both on the same directory fd.

Based on a testcase from Li Zefan <lizefan@huawei.com>.
http://marc.info/?l=linux-kernel&m=136123703211869&w=2

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
---
 src/Makefile          |    2 +-
 src/t_readdir_1.c     |   46 +++++++++++++++++++++++++++++
 src/t_readdir_2.c     |   57 ++++++++++++++++++++++++++++++++++++
 tests/generic/308     |   76 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/308.out |    2 +
 tests/generic/group   |    1 +
 6 files changed, 183 insertions(+), 1 deletions(-)
 create mode 100644 src/t_readdir_1.c
 create mode 100644 src/t_readdir_2.c
 create mode 100755 tests/generic/308
 create mode 100644 tests/generic/308.out

diff --git a/src/Makefile b/src/Makefile
index f7362a2..8d8e97f 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -18,7 +18,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked t_dir_offset2 seek_sanity_test \
-	seek_copy_test
+	seek_copy_test t_readdir_1 t_readdir_2

 SUBDIRS =

diff --git a/src/t_readdir_1.c b/src/t_readdir_1.c
new file mode 100644
index 0000000..2d46b29
--- /dev/null
+++ b/src/t_readdir_1.c
@@ -0,0 +1,46 @@
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <dirent.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+
+int main(int argc, char *argv[])
+{
+	int fd;
+	int ret;
+	DIR *dir;
+	struct dirent *ptr;
+
+	dir = opendir(argv[1]);
+	
+	fd = dirfd(dir);
+	if (fd < 0) {
+		perror("Failed to get dirfd!");
+		exit(EXIT_FAILURE);
+	}
+	ret = fork();
+
+	if (ret == 0) {
+		char buf[100];
+		
+		while(1)
+                        read(fd, buf, 100);
+
+	} else {
+		while (1) {
+			int ret2 = lseek(fd, 0, SEEK_SET);
+			if (ret2 == -1) {
+				perror("Seek failed!");
+				exit(EXIT_FAILURE);
+			}
+			while ((ptr = readdir(dir)))
+					;
+		}
+	}
+
+	closedir(dir);
+	exit(EXIT_SUCCESS);
+}
diff --git a/src/t_readdir_2.c b/src/t_readdir_2.c
new file mode 100644
index 0000000..7ec3a50
--- /dev/null
+++ b/src/t_readdir_2.c
@@ -0,0 +1,57 @@
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <dirent.h>
+#include <fcntl.h>
+#include <sys/stat.h>
+#include <sys/types.h>
+
+int main(int argc, char *argv[])
+{
+	int fd;
+	int ret;
+	DIR *dir;
+	struct dirent *ptr;
+
+	dir = opendir(argv[1]);
+	
+	fd = dirfd(dir);
+	if (fd < 0) {
+		perror("Failed to get dirfd!");
+		exit(EXIT_FAILURE);
+	}
+	ret = fork();
+
+	if (ret == 0) {
+		int ret1, i;
+		static int array[11] = {0, 1, 2, 3, 1023, 1024, 1025, 4095,
+					4096, 4097, 0x7fffffff};
+
+		while(1) {
+			for(i = 0; i < 11; i++) {
+				ret1 = lseek(fd, array[i++], SEEK_SET);
+				if (ret1 == -1) {
+                                	perror("Seek failed!");
+					exit(EXIT_FAILURE);
+				}
+			}
+
+			off_t pos = lseek(fd, 0, SEEK_CUR);
+			lseek(fd, pos, SEEK_SET);
+		}
+	} else {
+		while (1) {
+			int ret2 = lseek(fd, 0, SEEK_SET);
+			if (ret2 == -1) {
+				perror("Seek failed!");
+				exit(EXIT_FAILURE);
+			}
+			while ((ptr = readdir(dir)))
+					;
+		}
+	}
+
+	closedir(dir);
+	exit(EXIT_SUCCESS);
+}
diff --git a/tests/generic/308 b/tests/generic/308
new file mode 100755
index 0000000..38d4903
--- /dev/null
+++ b/tests/generic/308
@@ -0,0 +1,76 @@
+#! /bin/bash
+# FS QA Test No. 308
+#
+#Check if there are two threads,one keeps calling read() or lseek(), and
+#the other calling readdir(), both on the same directory fd.
+#
+# Based on a testcase from Li Zefan <lizefan@huawei.com>.
+#
+# http://marc.info/?l=linux-kernel&m=136123703211869&w=2
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 HuaWei. All Rights Reserved.
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
+# creator
+owner=zhaohongjiang@huawei.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+status=1	# failure is the default!
+
+_cleanup()
+{
+	rm -rf $TEST_DIR/tmp
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+mkdir $TEST_DIR/tmp
+for n in {1..4096}; do
+	touch $TEST_DIR/tmp/$n
+done
+
+_test_read()
+{
+	src/t_readdir_1 $TEST_DIR/tmp &
+	sleep 100
+	killall src/t_readdir_1
+}
+
+_test_lseek()
+{
+	src/t_readdir_2 $TEST_DIR/tmp &
+	sleep 100
+	killall src/t_readdir_2
+}
+
+_test_read
+_test_lseek
+
+# success, all done
+echo "*** done"
+rm -f $seq.full
+status=0
+exit
diff --git a/tests/generic/308.out b/tests/generic/308.out
new file mode 100644
index 0000000..904ad4d
--- /dev/null
+++ b/tests/generic/308.out
@@ -0,0 +1,2 @@
+QA output created by 308
+*** done
diff --git a/tests/generic/group b/tests/generic/group
index 450e942..a924086 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -109,3 +109,4 @@
 299 auto aio enospc rw stress
 300 auto aio enospc preallocrw stress
 306 auto quick rw
+308 auto
-- 1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
