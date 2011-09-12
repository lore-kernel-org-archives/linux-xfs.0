Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p8C0JDUK220610 for <xfs@oss.sgi.com>; Sun, 11 Sep 2011 19:19:13 -0500
Received: from mail-fx0-f53.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id CAF951BC2D5B
	for <xfs@oss.sgi.com>; Sun, 11 Sep 2011 17:19:11 -0700 (PDT)
Received: from mail-fx0-f53.google.com (mail-fx0-f53.google.com
	[209.85.161.53]) by cuda.sgi.com with ESMTP id yKAjS2Hy4Q1KDmAP
	for <xfs@oss.sgi.com>; Sun, 11 Sep 2011 17:19:11 -0700 (PDT)
Received: by fxh2 with SMTP id 2so970144fxh.26
	for <xfs@oss.sgi.com>; Sun, 11 Sep 2011 17:19:10 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH] xfstests: add new getdents test
Date: Mon, 12 Sep 2011 03:19:07 +0300
Message-Id: <1315786747-12109-1-git-send-email-notasas@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0864990448562178800=="
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Grazvydas Ignotas <notasas@gmail.com>, linux-btrfs@vger.kernel.org

--===============0864990448562178800==
Content-Type: text/plain

The test checks if no duplicate d_off values are returned and that
those values are seekable to the right inodes.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 257                 |   56 +++++++++++++++++++++++
 257.out             |    2 +
 group               |    1 +
 src/Makefile        |    2 +-
 src/t_dir_offset2.c |  124 +++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 184 insertions(+), 1 deletions(-)
 create mode 100755 257
 create mode 100644 257.out
 create mode 100644 src/t_dir_offset2.c

diff --git a/257 b/257
new file mode 100755
index 0000000..fb81e07
--- /dev/null
+++ b/257
@@ -0,0 +1,56 @@
+#! /bin/bash
+#
+# Check that no duplicate d_off values are returned and that those
+# values are seekable. Most work is done by the C program here.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2011 Gražvydas Ignotas
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
+owner=notasas@gmail.com
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
+	rm -rf $TEST_DIR/ttt
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
+mkdir $TEST_DIR/ttt
+for n in {1..168}; do
+    touch $TEST_DIR/ttt/$n;
+done
+src/t_dir_offset2 $TEST_DIR/ttt
+
+# success, all done
+echo "*** done"
+rm -f $seq.full
+status=0
diff --git a/257.out b/257.out
new file mode 100644
index 0000000..ac232ec
--- /dev/null
+++ b/257.out
@@ -0,0 +1,2 @@
+QA output created by 257
+*** done
diff --git a/group b/group
index 0c746c8..a742495 100644
--- a/group
+++ b/group
@@ -370,3 +370,4 @@ deprecated
 254 auto quick
 255 auto quick prealloc
 256 auto quick
+257 dir auto quick
diff --git a/src/Makefile b/src/Makefile
index 91088bf..67250ee 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -17,7 +17,7 @@ LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
-	stale_handle pwrite_mmap_blocked fstrim
+	stale_handle pwrite_mmap_blocked fstrim t_dir_offset2
 
 SUBDIRS =
 
diff --git a/src/t_dir_offset2.c b/src/t_dir_offset2.c
new file mode 100644
index 0000000..1375c3b
--- /dev/null
+++ b/src/t_dir_offset2.c
@@ -0,0 +1,124 @@
+/*
+ * Copyright (c) 2011 Gražvydas Ignotas
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
+/*
+ * This test checks if no duplicate d_off values are returned and
+ * that these offsets are seekable to entry with the right inode.
+ */
+
+#include <fcntl.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <sys/stat.h>
+#include <sys/syscall.h>
+
+struct linux_dirent64 {
+	uint64_t	d_ino;
+	uint64_t	d_off;
+	unsigned short	d_reclen;
+	unsigned char	d_type;
+	char		d_name[0];
+};
+
+#define BUF_SIZE 4096
+#define HISTORY_LEN 1024
+
+static uint64_t d_off_histoty[HISTORY_LEN];
+static uint64_t d_ino_histoty[HISTORY_LEN];
+
+int
+main(int argc, char *argv[])
+{
+	int fd, nread;
+	char buf[BUF_SIZE];
+	struct linux_dirent64 *d;
+	int bpos, total, i;
+	off_t lret;
+	int retval = EXIT_SUCCESS;
+
+	fd = open(argv[1], O_RDONLY | O_DIRECTORY);
+	if (fd < 0) {
+		perror("open");
+		exit(EXIT_FAILURE);
+	}
+
+	total = 0;
+	for ( ; ; ) {
+		nread = syscall(SYS_getdents64, fd, buf, BUF_SIZE);
+		if (nread == -1) {
+			perror("getdents");
+			exit(EXIT_FAILURE);
+		}
+
+		if (nread == 0)
+			break;
+
+		for (bpos = 0; bpos < nread; total++) {
+			d = (struct linux_dirent64 *) (buf + bpos);
+
+			if (total >= HISTORY_LEN) {
+				fprintf(stderr, "too many files\n");
+				break;
+			}
+
+			for (i = 0; i < total; i++)
+			{
+				if (d_off_histoty[i] == d->d_off) {
+					fprintf(stderr, "entries %d and %d have duplicate d_off %lld\n",
+						i, total, (long long int)d->d_off);
+					retval = EXIT_FAILURE;
+				}
+			}
+			d_off_histoty[total] = d->d_off;
+			d_ino_histoty[total] = d->d_ino;
+			bpos += d->d_reclen;
+		}
+	}
+
+	/* check if seek works correctly */
+	d = (struct linux_dirent64 *)buf;
+	for (i = total - 1; i >= 0; i--)
+	{
+		lret = lseek(fd, i > 0 ? d_off_histoty[i - 1] : 0, SEEK_SET);
+		if (lret == -1) {
+			perror("lseek");
+			exit(EXIT_FAILURE);
+		}
+
+		nread = syscall(SYS_getdents64, fd, buf, BUF_SIZE);
+		if (nread == -1) {
+			perror("getdents");
+			exit(EXIT_FAILURE);
+		}
+
+		if (nread == 0) {
+			fprintf(stderr, "getdents returned 0 on entry %d\n", i);
+			retval = EXIT_FAILURE;
+		}
+
+		if (d->d_ino != d_ino_histoty[i]) {
+			fprintf(stderr, "entry %d has inode %lld, expected %lld\n",
+				i, (long long int)d->d_ino, (long long int)d_ino_histoty[i]);
+			retval = EXIT_FAILURE;
+		}
+	}
+
+	close(fd);
+	exit(retval);
+}
-- 
1.7.0.4


--===============0864990448562178800==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--===============0864990448562178800==--
