Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q51IxiKD170983 for <xfs@oss.sgi.com>; Fri, 1 Jun 2012 13:59:45 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 708F1AC004
	for <xfs@oss.sgi.com>; Fri,  1 Jun 2012 11:59:41 -0700 (PDT)
Received: from arenaud-laptop (cf-vpn-hw-arenaud-1.corp.sgi.com [134.15.95.98])
	by estes.americas.sgi.com (Postfix) with ESMTP id F1B2A7001A56
	for <xfs@oss.sgi.com>; Fri,  1 Jun 2012 13:59:40 -0500 (CDT)
Message-Id: <20120601185935.708235862@sgi.com>
Date: Fri, 01 Jun 2012 14:58:16 -0400
From: Alain Renaud <arenaud@sgi.com>
Subject: [PATCH 1/1] xfstest: using extsize cause corruption with multi buffer
	page
References: <20120601185815.883227033@sgi.com>
Content-Disposition: inline;
	filename=xfstest:mix-bettwen-unwritten-and-real-extent-in-one-page.patch
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

  Test using extsize to create a file with multiple extent in one 
PAGE. This show an error in the block conversion from unwritten
to real. As a result we tag raw disk block as valid(3-4) and 
valid data as unwritten(5-6)

On an x86_64 machine the page should look like this.

buffer  content
0       empty  b_state = 0
1       DATA   b_state = 0x1023
2       DATA   b_state = 0x1023
3       empty  b_state = 0
4       empty  b_state = 0
5       DATA   b_state = 0x1023
6       DATA   b_state = 0x1023
7       empty  b_state = 0

Signed-off-by: Alain Renaud <arenaud@sgi.com>

---
 .gitignore         |    1 	1 +	0 -	0 !
 287                |   74 	74 +	0 -	0 !
 287.out            |    1 	1 +	0 -	0 !
 group              |    1 	1 +	0 -	0 !
 src/Makefile       |    2 	1 +	1 -	0 !
 src/extsize_page.c |  113 	113 +	0 -	0 !
 6 files changed, 191 insertions(+), 1 deletion(-)
 create mode 100755 287
 create mode 100644 287.out
 create mode 100644 src/extsize_page.c

Index: b/.gitignore
===================================================================
--- a/.gitignore
+++ b/.gitignore
@@ -30,6 +30,7 @@
 src/dirperf
 src/dirstress
 src/dmiperf
+src/extsize_page
 src/fault
 src/feature
 src/fiemap-tester
Index: b/287
===================================================================
--- /dev/null
+++ b/287
@@ -0,0 +1,74 @@
+#! /bin/bash
+# FS QA Test No. 287
+#
+# File coruption with multi extent in one page.
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
+owner=arenaud@sgi.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.dump
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+
+_scratch_mkfs_xfs -b size=512 >> $seq.full 2>&1
+_scratch_mount
+
+TDIR=${SCRATCH_MNT}/testdir
+PAGE=$(getconf PAGE_SIZE)
+mkdir ${TDIR}
+
+# Create the template file to compare with.
+$here/src/extsize_page ${PAGE} 512 1 ${TDIR}/template
+
+# Create test file and compare to template.
+for i in $(seq -w 0 20)
+do
+    $here/src/extsize_page ${PAGE} 512 0 ${TDIR}/zfile-${i}
+    # clean FS cache
+    _scratch_unmount
+    _scratch_mount
+    if ! cmp ${TDIR}/template ${TDIR}/zfile-${i}
+    then
+	echo "ERROR: compare failed"
+	xfs_bmap -vp ${TDIR}/zfile-${i}
+	hexdump -c ${TDIR}/zfile-${i}
+	status=1
+	exit 1
+    fi
+done
+
+# success, all done
+status=0
+exit
Index: b/287.out
===================================================================
--- /dev/null
+++ b/287.out
@@ -0,0 +1 @@
+QA output created by 287
Index: b/group
===================================================================
--- a/group
+++ b/group
@@ -405,3 +405,4 @@
 284 auto
 285 auto rw
 286 other
+287 auto rw
Index: b/src/Makefile
===================================================================
--- a/src/Makefile
+++ b/src/Makefile
@@ -18,7 +18,7 @@
 	locktest unwritten_mmap bulkstat_unlink_test t_stripealign \
 	bulkstat_unlink_test_modified t_dir_offset t_futimens t_immutable \
 	stale_handle pwrite_mmap_blocked fstrim t_dir_offset2 seek_sanity_test \
-	seek_copy_test
+	seek_copy_test extsize_page
 
 SUBDIRS =
 
Index: b/src/extsize_page.c
===================================================================
--- /dev/null
+++ b/src/extsize_page.c
@@ -0,0 +1,113 @@
+/*
+ * Copyright (c) 2012 SGI.
+ * All rights reserved.
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
+ * Tested on a 86_64 node with filesystem blocksize of 512
+ *
+ *meta-data=/dev/sdb1              isize=256    agcount=4, agsize=58609664 blks
+ *         =                       sectsz=512   attr=2
+ *data     =                       bsize=512    blocks=234438656, imaxpct=25
+ *         =                       sunit=0      swidth=0 blks
+ *naming   =version 2              bsize=512    ascii-ci=0
+ *log      =internal               bsize=512    blocks=114472, version=2
+ *         =                       sectsz=512   sunit=0 blks, lazy-count=0
+ *realtime =none                   extsz=4096   blocks=0, rtextents=0
+ *
+ *
+ * PAGE 1 will look like this.
+ * block     content
+ * 0         empty
+ * 1         B
+ * 2         B
+ * 3         empty
+ * 4         empty
+ * 5         C
+ * 6         C
+ * 7         empty
+ */
+#include <sys/file.h>
+#include <sys/types.h>
+#include <xfs/xfs.h>
+#include <errno.h>
+#include <unistd.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+int
+main(int argc, char **argv)
+{
+        int fd;
+	int pagesz, blocksz, template;
+	char *pathname;
+	char buf[65536];
+
+	if ( argc != 5 ) {
+		printf("usage: %s <pagesz> <blocksz> <flag> <file>\n",argv[0]);
+		exit(1);
+	}
+	pagesz = atoi(argv[1]);
+	blocksz = atoi(argv[2]);
+	template = atoi(argv[3]);
+	pathname = argv[4];
+
+	if ( pagesz <= blocksz || ((pagesz % pagesz) != 0)) {
+		printf("Error invalid page/block size combination\n");
+		exit(1);
+	}
+
+        fd = open(pathname,O_RDWR|O_CREAT|O_TRUNC,0666);
+        if (fd < 0) {
+                perror("open");
+                exit(1);
+        }
+
+	if (!template) {
+		/* set the XFS_XFLAG_EXTSIZE on the file */
+		struct fsxattr fattr;
+		memset(&fattr,0,sizeof(fattr));
+		fattr.fsx_extsize = pagesz*10;
+		fattr.fsx_xflags = XFS_XFLAG_EXTSIZE;
+
+		if (ioctl( fd, XFS_IOC_FSSETXATTR, &fattr) < 0) {
+			perror("Ioctl");
+			exit(1);
+		}
+	}
+
+	/* goto page 1 block 1 */
+        lseek(fd, (pagesz * 1) + (blocksz * 1), SEEK_SET);
+
+	/* write 'B' in page 1 block 1 and 2 */
+        memset(buf,'B',65536);
+        write(fd, buf, blocksz * 2);
+
+	/* goto page 1 block 5 */
+        lseek(fd, (pagesz * 1) + (blocksz * 5), SEEK_SET);
+
+	/* write 'C' in page 1 block 5 and 6 */
+        memset(buf,'C',65536);
+        write(fd, buf, blocksz * 2);
+
+	/* move eof after end of page 1 */
+	ftruncate(fd, pagesz * 3);
+        close(fd);
+
+	exit(0);
+}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
