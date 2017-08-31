Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:35689 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751571AbdHaOry (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 31 Aug 2017 10:47:54 -0400
Date: Thu, 31 Aug 2017 07:47:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2 3/4] xfs: test rmapbt updates are correct with
 insert/collapse range
Message-ID: <20170831144741.GG3775@magnolia>
References: <150406805060.31349.16766271336969357123.stgit@magnolia>
 <150406806291.31349.16354828502139354709.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150406806291.31349.16354828502139354709.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Make sure that we update the rmapbt correctly when we collapse-range a
file and the extents on both sides of the hole can be merged.  We can
construct this pretty trivially with insert-range and write, so test
that too.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: update usage info and expand the test description
---
 src/punch-alternating.c |   20 ++++++-
 tests/xfs/706           |  128 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/706.out       |    9 +++
 tests/xfs/group         |    1 
 4 files changed, 154 insertions(+), 4 deletions(-)
 create mode 100755 tests/xfs/706
 create mode 100644 tests/xfs/706.out

diff --git a/src/punch-alternating.c b/src/punch-alternating.c
index 25228cd..18dd215 100644
--- a/src/punch-alternating.c
+++ b/src/punch-alternating.c
@@ -13,9 +13,10 @@
 
 void usage(char *cmd)
 {
-	printf("Usage: %s [-i interval] [-s size] file\n", cmd);
+	printf("Usage: %s [-o offset] [-i interval] [-s size] file\n", cmd);
 	printf("Punches every other block in the file by default,\n");
-	printf("or 'size' blocks every 'interval' blocks with options.\n");
+	printf("or 'size' blocks every 'interval' blocks starting at\n");
+	printf("'offset'.  Units are in fstatfs blocks.\n");
 	exit(1);
 }
 
@@ -24,6 +25,7 @@ int main(int argc, char *argv[])
 	struct stat	s;
 	struct statfs	sf;
 	off_t		offset;
+	off_t		start_offset = 0;
 	int		fd;
 	blksize_t	blksz;
 	off_t		sz;
@@ -33,11 +35,19 @@ int main(int argc, char *argv[])
 	int		size = 1;	/* punch $SIZE blocks ... */
 	int		interval = 2;	/* every $INTERVAL blocks */
 
-	while ((c = getopt(argc, argv, "i:s:")) != EOF) {
+	while ((c = getopt(argc, argv, "i:o:s:")) != EOF) {
 		switch (c) {
 		case 'i':
 			interval = atoi(optarg);
 			break;
+		case 'o':
+			errno = 0;
+			start_offset = strtoull(optarg, NULL, 0);
+			if (errno) {
+				fprintf(stderr, "invalid offset '%s'\n", optarg);
+				return 1;
+			}
+			break;
 		case 's':
 			size = atoi(optarg);
 			break;
@@ -75,7 +85,9 @@ int main(int argc, char *argv[])
 	blksz = sf.f_bsize;
 
 	mode = FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE;
-	for (offset = 0; offset < sz; offset += blksz * interval) {
+	for (offset = start_offset * blksz;
+	     offset < sz;
+	     offset += blksz * interval) {
 		error = fallocate(fd, mode, offset, blksz * size);
 		if (error)
 			goto err;
diff --git a/tests/xfs/706 b/tests/xfs/706
new file mode 100755
index 0000000..c2aefa2
--- /dev/null
+++ b/tests/xfs/706
@@ -0,0 +1,128 @@
+#! /bin/bash
+# FS QA Test No. 706
+#
+# Make sure that we can handle insert-range followed by collapse-range.
+# In particular, make sure that fcollapse works for rmap when the
+# extents on either side of the collapse area are mergeable.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -rf "$tmp".*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+_supported_os Linux
+_supported_fs xfs
+_require_test_program "punch-alternating"
+_require_xfs_scratch_rmapbt
+_require_xfs_io_command "fcollapse"
+_require_xfs_io_command "finsert"
+
+rm -f "$seqres.full"
+
+echo "Format and mount"
+_scratch_mkfs > "$seqres.full" 2>&1
+_scratch_mount
+blksz=65536
+blocks1=150	# enough extents to force btree format
+blocks2=16	# local format
+len1=$((blocks1 * blksz))
+len2=$((blocks2 * blksz))
+file_blksz=$(_get_file_block_size $SCRATCH_MNT)
+
+echo "Create some files"
+$XFS_IO_PROG -f \
+	-c "falloc 0 $len1" \
+	-c "pwrite -S 0x68 -b 1048576 0 $len1" \
+	$SCRATCH_MNT/f1 >> $seqres.full
+$XFS_IO_PROG -f \
+	-c "falloc 0 $len2" \
+	-c "pwrite -S 0x68 -b 1048576 0 $len2" \
+	$SCRATCH_MNT/f2 >> $seqres.full
+
+./src/punch-alternating -o $((16 * blksz / file_blksz)) \
+	-s $((blksz / file_blksz)) \
+	-i $((blksz * 2 / file_blksz)) \
+	$SCRATCH_MNT/f1 >> "$seqres.full"
+
+echo "Insert and write file range"
+$XFS_IO_PROG \
+	-c "finsert $((8 * blksz)) $blksz" \
+	-c "pwrite -S 0x69 $((8 * blksz)) $blksz" \
+	-c "fsync" \
+	$SCRATCH_MNT/f1 >> $seqres.full
+$XFS_IO_PROG \
+	-c "finsert $((8 * blksz)) $blksz" \
+	-c "pwrite -S 0x69 $((8 * blksz)) $blksz" \
+	-c "fsync" \
+	$SCRATCH_MNT/f2 >> $seqres.full
+
+# Make reflink copies to force it to use the fancy rmap operations.
+# The test's functionality doesn't depend on the fs supporting reflink.
+_cp_reflink $SCRATCH_MNT/f1 $SCRATCH_MNT/e1 >> $seqres.full 2>&1
+_cp_reflink $SCRATCH_MNT/f2 $SCRATCH_MNT/e2 >> $seqres.full 2>&1
+
+echo "f1 bmap" >> $seqres.full
+$XFS_IO_PROG -c 'bmap -elpv' $SCRATCH_MNT/f1 >> $seqres.full
+echo "f2 bmap" >> $seqres.full
+$XFS_IO_PROG -c 'bmap -elpv' $SCRATCH_MNT/f2 >> $seqres.full
+echo "fsmap" >> $seqres.full
+$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT >> $seqres.full
+
+echo "Remount"
+_scratch_unmount
+_scratch_xfs_check
+_scratch_mount
+
+echo "Collapse file"
+$XFS_IO_PROG -c "fcollapse $((8 * blksz)) $blksz" $SCRATCH_MNT/f1 >> $seqres.full
+$XFS_IO_PROG -c "fcollapse $((8 * blksz)) $blksz" $SCRATCH_MNT/f2 >> $seqres.full
+
+echo "f1 bmap" >> $seqres.full
+$XFS_IO_PROG -c 'bmap -elpv' $SCRATCH_MNT/f1 >> $seqres.full
+echo "f2 bmap" >> $seqres.full
+$XFS_IO_PROG -c 'bmap -elpv' $SCRATCH_MNT/f2 >> $seqres.full
+echo "fsmap" >> $seqres.full
+$XFS_IO_PROG -c 'fsmap -v' $SCRATCH_MNT >> $seqres.full
+
+echo "Check file"
+md5sum $SCRATCH_MNT/f1 | _filter_scratch
+md5sum $SCRATCH_MNT/f2 | _filter_scratch
+od -tx1 -Ad -c $SCRATCH_MNT/f1 >> $seqres.full
+od -tx1 -Ad -c $SCRATCH_MNT/f2 >> $seqres.full
+
+# success, all done
+status=0
+exit
diff --git a/tests/xfs/706.out b/tests/xfs/706.out
new file mode 100644
index 0000000..064d33c
--- /dev/null
+++ b/tests/xfs/706.out
@@ -0,0 +1,9 @@
+QA output created by 706
+Format and mount
+Create some files
+Insert and write file range
+Remount
+Collapse file
+Check file
+f45e899d0ed7c055f7baa4e2039eb152  SCRATCH_MNT/f1
+e57a7dd63e41d5ba02a754dd72386c3d  SCRATCH_MNT/f2
diff --git a/tests/xfs/group b/tests/xfs/group
index 5977330..bfed828 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -426,3 +426,4 @@
 428 dangerous_fuzzers dangerous_scrub dangerous_online_repair
 429 dangerous_fuzzers dangerous_scrub dangerous_repair
 430 dangerous_fuzzers dangerous_scrub dangerous_online_repair
+706 auto quick clone rmap
