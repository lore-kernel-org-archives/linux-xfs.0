Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id CE69B7F4E
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 07:06:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BD55330406B
	for <xfs@oss.sgi.com>; Wed,  3 Jul 2013 05:06:08 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id gVEI2OfPV8ZEh7jZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 03 Jul 2013 05:06:07 -0700 (PDT)
From: Koen De Wit <koen.de.wit@oracle.com>
Subject: [PATCH v4] xfstests: btrfs/316: cross-subvolume sparse copy
Date: Wed,  3 Jul 2013 14:04:09 +0200
Message-Id: <1372853049-5773-1-git-send-email-koen.de.wit@oracle.com>
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
To: xfs@oss.sgi.com, linux-btrfs@vger.kernel.org
Cc: Koen De Wit <koen.de.wit@oracle.com>

This testscript creates reflinks to files on different subvolumes,
overwrites the original files and reflinks, and moves reflinked files
between subvolumes.

Signed-off-by: Koen De Wit <koen.de.wit@oracle.com>
---
Two new common/rc functions used in this script (_require_cp_reflink and
_verify_reflink) have been submitted recently:
http://oss.sgi.com/archives/xfs/2013-05/msg00745.html

Changelog:
v3 -> v4: Cleaning up commit message, cutting out filenames from output
          when printing md5sums, adding to group "reflink"
v2 -> v3: Fixing wrapped patch
v1 -> v2: Renamed 302 -> 316, changes made based on comments from Eric
          Sandeen: http://oss.sgi.com/archives/xfs/2013-03/msg00231.html

 tests/btrfs/316     |  131 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/316.out |   48 +++++++++++++++++++
 tests/btrfs/group   |    1 +
 3 files changed, 180 insertions(+), 0 deletions(-)
 create mode 100755 tests/btrfs/316
 create mode 100644 tests/btrfs/316.out

diff --git a/tests/btrfs/316 b/tests/btrfs/316
new file mode 100755
index 0000000..321832a
--- /dev/null
+++ b/tests/btrfs/316
@@ -0,0 +1,131 @@
+#! /bin/bash
+# FS QA Test No. btrfs/316
+#
+# Testing cross-subvolume sparse copy on btrfs
+#    - Create two subvolumes, mount one of them
+#    - Create a file on each (sub/root)volume,
+#      reflink them on the other volumes
+#    - Change one original and two reflinked files
+#    - Move reflinked files between subvolumes
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013, Oracle and/or its affiliates.  All Rights Reserved.
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
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    umount $SCRATCH_MNT
+    rm -rf $TESTDIR1
+    rm -rf $TESTDIR2
+    btrfs subvolume delete $SUBVOL1 >> $seqres.full
+    btrfs subvolume delete $SUBVOL2 >> $seqres.full
+    cd /
+    rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs btrfs
+_supported_os Linux
+
+_require_scratch
+_require_cp_reflink
+
+_checksum_files() {
+    for F in file1 file2 file3
+    do
+        echo "$F:"
+        for D in $TESTDIR1 $SCRATCH_MNT $SUBVOL2
+        do
+            _md5_checksum $D/$F
+        done
+    done
+}
+
+TESTDIR1=$TEST_DIR/test-$seq-1
+TESTDIR2=$TEST_DIR/test-$seq-2
+SUBVOL1=$TEST_DIR/subvol-$seq-1
+SUBVOL2=$TEST_DIR/subvol-$seq-2
+
+_scratch_unmount 2>/dev/null
+rm -rf $seqres.full
+rm -rf $TESTDIR1 $TESTDIR2
+btrfs subvol delete $SUBVOL1 >/dev/null 2>&1
+btrfs subvol delete $SUBVOL2 >/dev/null 2>&1
+
+mkdir $TESTDIR1
+mkdir $TESTDIR2
+btrfs subvolume create $SUBVOL1 >> $seqres.full
+btrfs subvolume create $SUBVOL2 >> $seqres.full
+_mount -t btrfs -o subvol=subvol-$seq-1 $TEST_DEV $SCRATCH_MNT
+
+echo "Create initial files"
+# TESTDIR1/file1 is very small and will be inlined
+$XFS_IO_PROG -f -c 'pwrite -S 0x61 0 10' $TESTDIR1/file1 >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x62 0 13000' $SCRATCH_MNT/file2 >> $seqres.full
+$XFS_IO_PROG -f -c 'pwrite -S 0x63 0 17000' $SUBVOL2/file3 >> $seqres.full
+
+echo "Create reflinks to the initial files on other subvolumes"
+cp --reflink $TESTDIR1/file1 $SUBVOL1
+cp --reflink $TESTDIR1/file1 $SUBVOL2
+cp --reflink $SUBVOL1/file2 $TESTDIR1/
+cp --reflink $SUBVOL1/file2 $SUBVOL2
+cp --reflink $SUBVOL2/file3 $TESTDIR1/
+cp --reflink $SUBVOL2/file3 $SUBVOL1
+
+echo "Verify the reflinks"
+_verify_reflink $SCRATCH_MNT/file2 $TESTDIR1/file2
+_verify_reflink $SCRATCH_MNT/file2 $SUBVOL2/file2
+_verify_reflink $SUBVOL2/file3 $TESTDIR1/file3
+_verify_reflink $SUBVOL2/file3 $SCRATCH_MNT/file3
+echo "Verify the file contents:"
+_checksum_files
+
+echo -e "---\nOverwrite some files with new content"
+$XFS_IO_PROG -c 'pwrite -S 0x64 0 20' $TESTDIR1/file1 >> $seqres.full
+$XFS_IO_PROG -c 'pwrite -S 0x66 0 21000' $SUBVOL2/file2 >> $seqres.full
+$XFS_IO_PROG -c 'pwrite -S 0x65 5000 5000' $SCRATCH_MNT/file3 >> $seqres.full
+
+echo "Verify that non-overwritten reflinks still have the same data blocks"
+_verify_reflink $TESTDIR1/file2 $SCRATCH_MNT/file2
+_verify_reflink $TESTDIR1/file3 $SUBVOL2/file3
+echo "Verify the file contents:"
+_checksum_files
+
+echo -e "---\nShuffle files between directories"
+mv $TESTDIR1/file* $TESTDIR2
+mv $SCRATCH_MNT/file* $TESTDIR1/
+mv $SUBVOL2/file* $SCRATCH_MNT/
+mv $TESTDIR2/file* $SUBVOL2/
+
+# No _verify_reflink here as data is copied when moving files between subvols
+echo "Verify the file contents:"
+_checksum_files
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/316.out b/tests/btrfs/316.out
new file mode 100644
index 0000000..ad3d01f
--- /dev/null
+++ b/tests/btrfs/316.out
@@ -0,0 +1,48 @@
+QA output created by 316
+Create initial files
+Create reflinks to the initial files on other subvolumes
+Verify the reflinks
+Verify the file contents:
+file1:
+e09c80c42fda55f9d992e59ca6b3307d
+e09c80c42fda55f9d992e59ca6b3307d
+e09c80c42fda55f9d992e59ca6b3307d
+file2:
+d7402b46310fbbfbc5e466b1dccb043b
+d7402b46310fbbfbc5e466b1dccb043b
+d7402b46310fbbfbc5e466b1dccb043b
+file3:
+5a95800e4c04b11117aa4e4de057721f
+5a95800e4c04b11117aa4e4de057721f
+5a95800e4c04b11117aa4e4de057721f
+---
+Overwrite some files with new content
+Verify that non-overwritten reflinks still have the same data blocks
+Verify the file contents:
+file1:
+00d620f69f30327f0f8946b95c12de44
+e09c80c42fda55f9d992e59ca6b3307d
+e09c80c42fda55f9d992e59ca6b3307d
+file2:
+d7402b46310fbbfbc5e466b1dccb043b
+d7402b46310fbbfbc5e466b1dccb043b
+917619ae44b38bb9968af261c3c45440
+file3:
+5a95800e4c04b11117aa4e4de057721f
+b9f275cd638cb784c9e61def94c622a8
+5a95800e4c04b11117aa4e4de057721f
+---
+Shuffle files between directories
+Verify the file contents:
+file1:
+e09c80c42fda55f9d992e59ca6b3307d
+e09c80c42fda55f9d992e59ca6b3307d
+00d620f69f30327f0f8946b95c12de44
+file2:
+d7402b46310fbbfbc5e466b1dccb043b
+917619ae44b38bb9968af261c3c45440
+d7402b46310fbbfbc5e466b1dccb043b
+file3:
+b9f275cd638cb784c9e61def94c622a8
+5a95800e4c04b11117aa4e4de057721f
+5a95800e4c04b11117aa4e4de057721f
diff --git a/tests/btrfs/group b/tests/btrfs/group
index bc6c256..a6d8de1 100644
--- a/tests/btrfs/group
+++ b/tests/btrfs/group
@@ -9,3 +9,4 @@
 276 auto rw metadata
 284 auto
 307 auto quick
+316 auto quick reflink
-- 
1.7.2.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
