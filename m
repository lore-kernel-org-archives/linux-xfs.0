Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o6MJ2UEW155814 for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 14:02:30 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BF760C0D428
	for <xfs@oss.sgi.com>; Thu, 22 Jul 2010 12:12:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zDxD2Yf3xGpV1HTK for
	<xfs@oss.sgi.com>; Thu, 22 Jul 2010 12:12:25 -0700 (PDT)
Message-ID: <4C489676.2000605@redhat.com>
Date: Thu, 22 Jul 2010 14:05:26 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests 240: test non-aligned AIO hole-filling
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
To: xfs-oss <xfs@oss.sgi.com>, ext4 development <linux-ext4@vger.kernel.org>

This replicates file corruption we've seen with qemu-kvm when
we use if=virtio,cache=none,aio=native for IO to a sparse
ext4- or xfs-hosted file, and the partitions/filesystems
within that file image are not block-aligned.  (think sector
63 here...)  This results in AIO IOs not aligned to the
filesystem blocks.

This test modifies aiodio_sparse2.c to add an option to start
the file IO at an offset.

When we do 4k writes to a 16k file in 2 threads, starting
at offset 512, we get 0s interspersed in the file where they
should not be:

00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000200  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01  |................|
*
00001000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00001200  01 01 01 01 01 01 01 01  01 01 01 01 01 01 01 01  |................|
....

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---

diff --git a/240 b/240
new file mode 100644
index 0000000..b8a1024
--- /dev/null
+++ b/240
@@ -0,0 +1,62 @@
+#! /bin/bash
+# FS QA Test No. 240
+#
+# Test that non-block-aligned aio+dio into holes does not leave
+# zero'd out portions of the file
+#
+# QEMU IO to a file-backed device with misaligned partitions
+# can send this sort of IO
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2010 Red Hat, Inc.  All Rights Reserved.
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
+owner=sandeen@sandeen.net
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1        # failure is the default!
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
+_supported_fs generic
+_supported_os Linux
+
+echo "Silence is golden."
+
+# real QA test starts here
+rm -f $seq.full
+
+rm -f "$TEST_DIR/aiodio_sparse*"
+
+# 2 threads, 4k writes, 16k filesize, stride throug file by 4k, start at 512 offset
+$here/src/aio-dio-regress/aiodio_sparse2 -i 2 -w 4k -s 16k -n 4k -o 512 "$TEST_DIR/aiodio_sparse"
+
+status=$?
+exit
diff --git a/240.out b/240.out
new file mode 100644
index 0000000..b6bdbce
--- /dev/null
+++ b/240.out
@@ -0,0 +1,2 @@
+QA output created by 240
+Silence is golden.
diff --git a/group b/group
index 87b1230..afe7614 100644
--- a/group
+++ b/group
@@ -353,3 +353,4 @@ deprecated
 237 auto quick acl
 238 auto quick metadata ioctl
 239 auto aio rw
+240 auto aio quick rw
diff --git a/src/aio-dio-regress/aiodio_sparse2.c b/src/aio-dio-regress/aiodio_sparse2.c
index b56f91a..f1225dd 100644
--- a/src/aio-dio-regress/aiodio_sparse2.c
+++ b/src/aio-dio-regress/aiodio_sparse2.c
@@ -66,7 +66,8 @@ sig_term_func(int i, siginfo_t *si, void *p)
 /*
  * do async DIO writes to a sparse file
  */
-void aiodio_sparse(char *filename, int align, int writesize, int filesize, int num_aio, int step, int sparse, int direct, int keep)
+void aiodio_sparse(char *filename, int align, int writesize, int startoffset, int filesize,
+			int num_aio, int step, int sparse, int direct, int keep)
 {
 	int fd;
 	void *bufptr;
@@ -110,7 +111,7 @@ void aiodio_sparse(char *filename, int align, int writesize, int filesize, int n
 	/*
 	 * allocate the iocbs array and iocbs with buffers
 	 */
-	offset = 0;
+	offset = startoffset;
 	for (i = 0; i < num_aio; i++) {
 		void *bufptr;
 
@@ -220,9 +221,11 @@ void aiodio_sparse(char *filename, int align, int writesize, int filesize, int n
 		exit(1);
 
 	bufptr = malloc(writesize);
-	for (offset = 0; offset < filesize; offset += step)  {
+	for (offset = startoffset; offset < filesize; offset += step)  {
 		unsigned char *badbuf;
 
+		if (debug)
+			fprintf(stderr, "seek to %ld and read %d\n", offset, writesize);
 		lseek(fd, offset, SEEK_SET);
 		if (read(fd, bufptr, writesize) < writesize) {
 			fprintf(stderr, "short read() at offset %lld\n",
@@ -274,7 +277,7 @@ void dirty_freeblocks(char *filename, int size)
 void usage()
 {
 	fprintf(stderr, "usage: dio_sparse [-n step] [-s filesize]"
-		" [-w writesize] [-r readsize] filename\n");
+		" [-w writesize] [-o startoffset] [-r readsize] filename\n");
 	exit(1);
 }
 
@@ -305,7 +308,7 @@ long long scale_by_kmg(long long value, char scale)
 
 /*
  *	usage:
- * aiodio_sparse [-r readsize] [-w writesize] [-n step] [-a align] [-i num_aio] filename
+ * aiodio_sparse [-r readsize] [-w writesize] [-o startoffset] [-n step] [-a align] [-i num_aio] filename
  */
 
 int main(int argc, char **argv)
@@ -314,6 +317,7 @@ int main(int argc, char **argv)
 	long alignment = 512;
 	int readsize = 65536;
 	int writesize = 65536;
+	int startoffset = 0;
 	int filesize = 100*1024*1024;
 	int num_aio = 16;
 	int step = 5*1024*1024;
@@ -321,7 +325,7 @@ int main(int argc, char **argv)
 	extern char *optarg;
 	extern int optind, optopt, opterr;
 
-	while ((c = getopt(argc, argv, "dr:w:n:a:s:i:DkS")) != -1) {
+	while ((c = getopt(argc, argv, "dr:w:n:o:a:s:i:DkS")) != -1) {
 		char *endp;
 		switch (c) {
 		case 'D':
@@ -360,6 +364,10 @@ int main(int argc, char **argv)
 			step = strtol(optarg, &endp, 0);
 			step = (int)scale_by_kmg((long long)step, *endp);
 			break;
+		case 'o':
+			startoffset = strtol(optarg, &endp, 0);
+			startoffset = (int)scale_by_kmg((long long)startoffset, *endp);
+			break;
 		case '?':
 			usage();
 			break;
@@ -378,7 +386,7 @@ int main(int argc, char **argv)
 	 * Parent write to a hole in a file using async direct i/o
 	 */
 
-	aiodio_sparse(filename, alignment, writesize, filesize, num_aio, step, sparse, direct, keep);
+	aiodio_sparse(filename, alignment, writesize, startoffset, filesize, num_aio, step, sparse, direct, keep);
 
 	return 0;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
