Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o4JDa7Wg131928 for <xfs@oss.sgi.com>; Wed, 19 May 2010 08:36:07 -0500
Received: from mx2.suse.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B76C5156C51A
	for <xfs@oss.sgi.com>; Wed, 19 May 2010 06:39:33 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id FDBHtMJoh5PJGnfH for <xfs@oss.sgi.com>;
	Wed, 19 May 2010 06:39:33 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 1/7] xfstests: test extent size hints
Date: Wed, 19 May 2010 15:38:03 +0200
Message-Id: <1274276289-8839-2-git-send-email-jack@suse.cz>
In-Reply-To: <1274276289-8839-1-git-send-email-jack@suse.cz>
References: <1274276289-8839-1-git-send-email-jack@suse.cz>
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
Cc: hch@infradead.org, Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

This is an adapted version of the reproduced in OSS BZ #874, which
shows file corruption when using the extent size hint.

Signed-off-by: Geoffrey Wehrman <gwehrman@sgi.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 229           |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 229.out       |    4 ++
 group         |    1 +
 src/Makefile  |    2 +-
 src/t_holes.c |   41 ++++++++++++++++++++++++++
 5 files changed, 135 insertions(+), 1 deletions(-)
 create mode 100644 229
 create mode 100644 229.out
 create mode 100644 src/t_holes.c

diff --git a/229 b/229
new file mode 100644
index 0000000..418a5af
--- /dev/null
+++ b/229
@@ -0,0 +1,88 @@
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
+# Copyright (c) 2010 Silicon Graphics, Inc.  All Rights Reserved.
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
diff --git a/229.out b/229.out
new file mode 100644
index 0000000..233920f
--- /dev/null
+++ b/229.out
@@ -0,0 +1,4 @@
+QA output created by 229
+generating 10 files
+comparing files
+got 0 errors
diff --git a/group b/group
index 69ba24d..2c1ac50 100644
--- a/group
+++ b/group
@@ -342,3 +342,4 @@ deprecated
 226 auto enospc
 227 auto fsr
 228 rw auto prealloc quick
+229 auto rw
diff --git a/src/Makefile b/src/Makefile
index 2f95fe2..976133d 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -10,7 +10,7 @@ TARGETS = dirstress fill fill2 getpagesize holes lstat64 \
 	mmapcat append_reader append_writer dirperf metaperf \
 	devzero feature alloc fault fstest t_access_root \
 	godown resvtest writemod makeextents itrash rename \
-	multi_open_unlink dmiperf unwritten_sync genhashnames
+	multi_open_unlink dmiperf unwritten_sync genhashnames t_holes
 
 LINUX_TARGETS = xfsctl bstat t_mtab getdevicesize preallo_rw_pattern_reader \
 	preallo_rw_pattern_writer ftrunc trunc fs_perms testx looptest \
diff --git a/src/t_holes.c b/src/t_holes.c
new file mode 100644
index 0000000..eba310a
--- /dev/null
+++ b/src/t_holes.c
@@ -0,0 +1,41 @@
+/*
+ * Copyright (c) 2010 Silicon Graphics, Inc.  All Rights Reserved.
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
+#include <unistd.h>
+#include <fcntl.h>
+#include <sys/types.h>
+#include <stdio.h>
+
+int main(int argc, char **argv)
+{
+	int buf[1024];
+	int fd, i, j;
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
+	return 0;
+}
-- 
1.6.4.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
