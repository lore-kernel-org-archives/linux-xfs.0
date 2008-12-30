Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBUN9FAo007375 for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 17:09:15 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D900D17996E2
	for <xfs@oss.sgi.com>; Tue, 30 Dec 2008 15:09:13 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id SXNytXAgsKDRVyPw for
	<xfs@oss.sgi.com>; Tue, 30 Dec 2008 15:09:13 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat
	Linux)) id 1LHni5-0000IS-Mz
	for xfs@oss.sgi.com; Tue, 30 Dec 2008 23:09:13 +0000
Message-Id: <20081230230913.619447000@bombadil.infradead.org>
References: <20081230230810.986105000@bombadil.infradead.org>
Date: Tue, 30 Dec 2008 18:08:15 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 5/5] xfstests: test 197, add a testcase for d_off truncation
Content-Disposition: inline; filename=xfstests-add-d_off-truncation-test
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
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

Make sure our directory offsets fit into a 32 bit value.
Based on a report by John Stanley.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: xfstests/src/Makefile
===================================================================
--- xfstests/src/Makefile	2008-12-30 14:35:02.000000000 +0000
+++ xfstests/src/Makefile	2008-12-30 14:36:01.000000000 +0000
@@ -15,7 +15,7 @@
 LINUX_TARGETS = loggen xfsctl bstat t_mtab getdevicesize \
 	preallo_rw_pattern_reader preallo_rw_pattern_writer ftrunc trunc \
 	fs_perms testx looptest locktest unwritten_mmap \
-	bulkstat_unlink_test bulkstat_unlink_test_modified
+	bulkstat_unlink_test bulkstat_unlink_test_modified t_dir_offset
 
 IRIX_TARGETS = open_unlink
 
Index: xfstests/src/t_dir_offset.c
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests/src/t_dir_offset.c	2008-12-30 14:35:05.000000000 +0000
@@ -0,0 +1,62 @@
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
+	int64_t		d_off;
+	unsigned short	d_reclen;
+	unsigned char	d_type;
+        char		d_name[0];
+};
+
+
+#define BUF_SIZE 4096
+
+int
+main(int argc, char *argv[])
+{
+	int fd, nread;
+	char buf[BUF_SIZE];
+	struct linux_dirent64 *d;
+	int bpos;
+
+	fd = open(argv[1], O_RDONLY | O_DIRECTORY);
+	if (fd < 0) {
+		perror("open");
+		exit(EXIT_FAILURE);
+	}
+
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
+		for (bpos = 0; bpos < nread;) {
+			d = (struct linux_dirent64 *) (buf + bpos);
+			/*
+			 * Can't use off_t here xfsqa is compiled with
+			 * -D_FILE_OFFSET_BITS=64
+			 */
+			if (d->d_off != (long)d->d_off) {
+	                        fprintf(stderr, "detected d_off truncation "
+						"d_name = %s, d_off = %lld\n",
+						d->d_name, (long long)d->d_off);
+        	                exit(EXIT_FAILURE);
+                	}
+			bpos += d->d_reclen;
+		}
+	}
+
+	exit(EXIT_SUCCESS);
+}
Index: xfstests/group
===================================================================
--- xfstests/group	2008-12-30 14:35:02.000000000 +0000
+++ xfstests/group	2008-12-30 14:35:05.000000000 +0000
@@ -299,3 +299,4 @@
 194 rw auto
 195 ioctl dump auto
 196 quota auto
+197 dir auto
Index: xfstests/197
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests/197	2008-12-30 14:35:05.000000000 +0000
@@ -0,0 +1,49 @@
+#! /bin/sh
+# FS QA Test No. 197
+#
+# Check that d_off can be represented in a 32 bit long type without
+# truncation.
+#
+# Based on a testcase from John Stanley <jpsinthemix@verizon.net>.
+#
+# http://oss.sgi.com/bugzilla/show_bug.cgi?id=808
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2008 Christoph Hellwig.
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
+	rm -rf $TEST_DIR/ttt
+}
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
+
+mkdir $TEST_DIR/ttt
+for n in {1..168}; do
+    touch $TEST_DIR/ttt/$n;
+done
+src/t_dir_offset $TEST_DIR/ttt
+
+# success, all done
+echo "*** done"
+rm -f $seq.full
+status=0
Index: xfstests/197.out
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfstests/197.out	2008-12-30 14:35:05.000000000 +0000
@@ -0,0 +1,2 @@
+QA output created by 197
+*** done

-- 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
