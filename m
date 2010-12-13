Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	oBD7MISN171611 for <xfs@oss.sgi.com>; Mon, 13 Dec 2010 01:22:18 -0600
Received: from mga09.intel.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 184F4144029F
	for <xfs@oss.sgi.com>; Sun, 12 Dec 2010 23:24:08 -0800 (PST)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24]) by
	cuda.sgi.com with ESMTP id SJP95Bl3sFiusX92 for
	<xfs@oss.sgi.com>; Sun, 12 Dec 2010 23:24:08 -0800 (PST)
From: "Zhong, Xin" <xin.zhong@intel.com>
Subject: [PATCH] xfstests: pwrite hang when writing from mmaped buffer of the
	same page
Date: Mon, 13 Dec 2010 15:24:43 +0800
Message-Id: <1292225083-17713-1-git-send-email-xin.zhong@intel.com>
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
Cc: xin.zhong@intel.com

The problem is found in meego testing:
http://bugs.meego.com/show_bug.cgi?id=6672
Only btrfs has this problem so far. Other linux fs works well.

Signed-off-by: Zhong, Xin <xin.zhong@intel.com>
---
 248                       |   57 ++++++++++++++++++++++++++++++++++++++++
 248.out                   |    2 +
 group                     |    1 +
 src/Makefile              |    2 +-
 src/pwrite_mmap_blocked.c |   63 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 124 insertions(+), 1 deletions(-)
 create mode 100644 248
 create mode 100644 248.out
 create mode 100644 src/pwrite_mmap_blocked.c

diff --git a/248 b/248
new file mode 100644
index 0000000..3e996d3
--- /dev/null
+++ b/248
@@ -0,0 +1,57 @@
+#! /bin/bash
+# FS QA Test No. 248
+#
+# Test for pwrite hang problem when writing from mmaped buffer of the same page 
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 YOUR NAME HERE.  All Rights Reserved.
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
+owner=xin.zhong@intel.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
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
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs generic
+_supported_os Linux
+
+TESTFILE=$TEST_DIR/test_file
+TEST_PROG=$here/src/pwrite_mmap_blocked
+
+$TEST_PROG $TESTFILE
+
+# success, all done
+status=0
+exit
diff --git a/248.out b/248.out
new file mode 100644
index 0000000..d02c1ac
--- /dev/null
+++ b/248.out
@@ -0,0 +1,2 @@
+QA output created by 248
+pwrite 1 bytes from 2 to 3
diff --git a/group b/group
index 0f94dd9..0b4f514 100644
--- a/group
+++ b/group
@@ -361,3 +361,4 @@ deprecated
 245 auto quick dir
 246 auto quick rw
 247 auto quick rw
+248 other
diff --git a/src/Makefile b/src/Makefile
index b827bd0..47d7334 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -17,7 +17,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
-	stale_handle
+	stale_handle pwrite_mmap_blocked
 
 SUBDIRS =
 
diff --git a/src/pwrite_mmap_blocked.c b/src/pwrite_mmap_blocked.c
new file mode 100644
index 0000000..40d7f7b
--- /dev/null
+++ b/src/pwrite_mmap_blocked.c
@@ -0,0 +1,63 @@
+#include <stdio.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <stdlib.h>
+#include <string.h>
+#include <errno.h>
+#include <time.h>
+#include <sys/mman.h>
+#include <sys/signal.h>
+#include <sys/stat.h>
+
+char *progname;
+loff_t size;
+int fd;
+char *filename="./test_file";
+void *mapped_mem;
+
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	progname = argv[0];
+	size = 5;
+	fd = open(argv[1], O_RDWR|O_TRUNC|O_CREAT, 0666);
+	if (fd < 0) {
+		fprintf(stderr, "%s: Cannot open `%s': %s\n",
+			progname, filename, strerror(errno));
+		exit(1);
+	}
+
+	char *cc = "01234";
+	if ((ret = pwrite(fd, (const char *)cc,
+				size, 0)) != size) {
+		fprintf(stderr, "%s: pwrite returned %d\n",
+			__FUNCTION__, ret);
+		perror("pwrite");
+		exit(1);
+	}
+
+	mapped_mem = mmap(0, size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
+	if (mapped_mem == MAP_FAILED) {
+		perror("mmap");
+		exit(1);
+	}
+	loff_t amount = 1;
+	loff_t from = 2;
+	loff_t to = 3;
+	printf("pwrite %Ld bytes from %Ld to %Ld\n", amount, from, to);
+	if ((ret = pwrite(fd, (char *)mapped_mem + from, amount, to)) != amount) {
+		printf("%s: pwrite returned %d, not %Ld\n",
+					__FUNCTION__, ret, amount);
+		if (errno == EFAULT) {
+			printf("pwrite: EFAULT\n");
+		} else if (ret < 0) {
+			perror("pwrite");
+			exit(1);
+		}
+	}
+	munmap(mapped_mem,0);
+	close(fd);
+	exit(0);
+}
-- 
1.6.2.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
