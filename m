Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DF71029DF8
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 15:59:13 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5B93BAC002
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 13:59:13 -0700 (PDT)
Received: from dkim2.fusionio.com (dkim2.fusionio.com [66.114.96.54]) by
	cuda.sgi.com with ESMTP id dbEPZFDwS2DMHlVy (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 21 May 2013 13:59:11 -0700 (PDT)
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id F29609A040D
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 14:59:10 -0600 (MDT)
From: Josef Bacik <jbacik@fusionio.com>
Subject: [PATCH] xfstests: btrfs 308: regression test for btrfs send V2
Date: Tue, 21 May 2013 16:59:07 -0400
Message-ID: <1369169947-13748-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com, david@fromorbit.com

I'm not sure how the numbering is supposed to work now that we've split
everything out so I'm just going with the next number in the directory.  This is
a regression test for btrfs send, we had a problem where we'd try to send a file
that had been deleted in the source snapshot.  This is just to make sure we
don't have the same problem in the future.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fusionio.com>
---
V1->V2: 
-added a -x optoin to multi_open_unlink to make it not check for existing
 files
-made all the normal output go to $seqres.full

 src/multi_open_unlink.c |   12 +++++--
 tests/btrfs/308         |   75 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/308.out     |    2 +
 tests/btrfs/group       |    1 +
 4 files changed, 86 insertions(+), 4 deletions(-)
 create mode 100644 tests/btrfs/308
 create mode 100644 tests/btrfs/308.out

diff --git a/src/multi_open_unlink.c b/src/multi_open_unlink.c
index 51a405e..dfce974 100644
--- a/src/multi_open_unlink.c
+++ b/src/multi_open_unlink.c
@@ -39,7 +39,7 @@
 void
 usage(char *prog)
 {
-	fprintf(stderr, "Usage: %s [-e num-eas] [-f path_prefix] [-n num_files] [-s sleep_time] [-v ea-valuesize] \n", prog);
+	fprintf(stderr, "Usage: %s [-e num-eas] [-f path_prefix] [-n num_files] [-s sleep_time] [-v ea-valuesize] [-x] \n", prog);
 	exit(1);
 }
 
@@ -54,9 +54,10 @@ main(int argc, char *argv[])
 	int num_eas = 0;
 	int value_size = ATTR_MAX_VALUELEN;
 	int fd = -1;
+	int open_flags = O_RDWR|O_CREAT|O_EXCL;
 	int i,j,c;
 
-	while ((c = getopt(argc, argv, "e:f:n:s:v:")) != EOF) {
+	while ((c = getopt(argc, argv, "e:f:n:s:v:x")) != EOF) {
 		switch (c) {
 			case 'e':   /* create eas */
 				num_eas = atoi(optarg);
@@ -73,6 +74,9 @@ main(int argc, char *argv[])
 			case 'v':  /* value size on eas */
 				value_size = atoi(optarg);
 				break;
+			case 'x': /* don't use O_EXCL, for use with exsint files */
+				open_flags &= ~O_EXCL;
+				break;
 			case '?':
 				usage(prog);
 		}
@@ -83,12 +87,12 @@ main(int argc, char *argv[])
 		sprintf(path, "%s.%d", given_path, i+1);
 
 		/* if file already exists then error out */
-		if (access(path, F_OK) == 0) {
+		if ((open_flags & O_EXCL) && access(path, F_OK) == 0) {
 			fprintf(stderr, "%s: file \"%s\" already exists\n", prog, path);
 			return 1;
 		}
 
-		fd = open(path, O_RDWR|O_CREAT|O_EXCL, 0666);
+		fd = open(path, open_flags, 0666);
 		if (fd == -1) {
 			fprintf(stderr, "%s: failed to create \"%s\": %s\n", prog, path, strerror(errno));
 			return 1;
diff --git a/tests/btrfs/308 b/tests/btrfs/308
new file mode 100644
index 0000000..52bf1e2
--- /dev/null
+++ b/tests/btrfs/308
@@ -0,0 +1,75 @@
+#! /bin/bash
+# FS QA Test No. btrfs/308
+#
+# btrfs send ESTALE regression test, kernel.org bugzilla 57491
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Fusion IO.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+
+_cleanup()
+{
+    rm -f $tmp.*
+}
+
+trap "_cleanup ; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+_require_scratch
+
+_scratch_mkfs > /dev/null 2>&1
+_scratch_mount
+
+dd if=/dev/zero of=$SCRATCH_MNT/foo.1 bs=1M count=10 > $seqres.full 2>&1
+sync
+$BTRFS_UTIL_PROG subvol snap -r $SCRATCH_MNT $SCRATCH_MNT/snap > $seqres.full 2>&1
+dd if=/dev/zero of=$SCRATCH_MNT/foo.1 bs=1M count=10 oflag=append > $seqres.full 2>&1
+sync
+
+# We need to hold the file open, tail -f makes the output file look weird so
+# here is this awful hack to get around that
+$here/src/multi_open_unlink -x -n 1 -f $SCRATCH_MNT/foo -s 90 &
+
+# need this to give multi_open_unlink enough time to unlink the file before we
+# snapshot
+sleep 5
+
+$BTRFS_UTIL_PROG subvol snap -r $SCRATCH_MNT $SCRATCH_MNT/snap1 > $seqres.full 2>&1
+$BTRFS_UTIL_PROG send -f /dev/null -p $SCRATCH_MNT/snap $SCRATCH_MNT/snap1 > $seqres.full 2>&1
+if [ $? -ne 0 ]
+then
+	echo "send failed"
+fi
+kill $!
+
+echo "Silence is golden"
+status=0 ; exit
diff --git a/tests/btrfs/308.out b/tests/btrfs/308.out
new file mode 100644
index 0000000..a731eaa
--- /dev/null
+++ b/tests/btrfs/308.out
@@ -0,0 +1,2 @@
+QA output created by 308
+Silence is golden
diff --git a/tests/btrfs/group b/tests/btrfs/group
index bc6c256..666054b 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -9,3 +9,4 @@
 276 auto rw metadata
 284 auto
 307 auto quick
+308 auto quick
-- 
1.7.7.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
