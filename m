Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9EA2429F10
	for <xfs@oss.sgi.com>; Wed,  7 Oct 2015 00:13:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E54E9AC005
	for <xfs@oss.sgi.com>; Tue,  6 Oct 2015 22:13:45 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id KX9SyYF0nzQFgxae (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 06 Oct 2015 22:13:40 -0700 (PDT)
Subject: [PATCH 04/12] reflink: basic tests of the reflink and dedupe ioctls
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 06 Oct 2015 22:13:30 -0700
Message-ID: <20151007051330.3260.7654.stgit@birch.djwong.org>
In-Reply-To: <20151007051257.3260.73072.stgit@birch.djwong.org>
References: <20151007051257.3260.73072.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: fstests@vger.kernel.org, linux-ext4@vger.kernel.org, Anna.Schumaker@netapp.com, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Test the operation of the btrfs (and now xfs) reflink and dedupe
ioctls at various file offsets and with matching and nonmatching
files.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc             |    9 +++
 tests/generic/803     |   89 ++++++++++++++++++++++++++
 tests/generic/803.out |    4 +
 tests/generic/804     |   90 ++++++++++++++++++++++++++
 tests/generic/804.out |    7 ++
 tests/generic/805     |  171 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/805.out |   18 +++++
 tests/generic/806     |   89 ++++++++++++++++++++++++++
 tests/generic/806.out |    4 +
 tests/generic/807     |   89 ++++++++++++++++++++++++++
 tests/generic/807.out |    8 ++
 tests/generic/817     |  125 ++++++++++++++++++++++++++++++++++++
 tests/generic/817.out |    8 ++
 tests/generic/818     |  125 ++++++++++++++++++++++++++++++++++++
 tests/generic/818.out |    9 +++
 tests/generic/819     |  128 +++++++++++++++++++++++++++++++++++++
 tests/generic/819.out |    7 ++
 tests/generic/group   |    8 ++
 18 files changed, 988 insertions(+)
 create mode 100755 tests/generic/803
 create mode 100644 tests/generic/803.out
 create mode 100755 tests/generic/804
 create mode 100644 tests/generic/804.out
 create mode 100755 tests/generic/805
 create mode 100644 tests/generic/805.out
 create mode 100755 tests/generic/806
 create mode 100644 tests/generic/806.out
 create mode 100755 tests/generic/807
 create mode 100644 tests/generic/807.out
 create mode 100755 tests/generic/817
 create mode 100644 tests/generic/817.out
 create mode 100755 tests/generic/818
 create mode 100644 tests/generic/818.out
 create mode 100755 tests/generic/819
 create mode 100644 tests/generic/819.out


diff --git a/common/rc b/common/rc
index 7e2f140..639f355 100644
--- a/common/rc
+++ b/common/rc
@@ -82,6 +82,15 @@ _md5_checksum()
 	md5sum $1 | cut -d ' ' -f1
 }
 
+# Prints the md5 checksum of a part of a given file
+_md5_range_checksum() {
+	file="$1"
+	offset="$2"
+	len="$3"
+
+	md5sum <($XFS_IO_PROG -f -c "pread -q -v $offset $len" "$file" | sed -e 's/^.*:  //g') | cut -d ' ' -f 1
+}
+
 
 # ls -l w/ selinux sometimes puts a dot at the end:
 # -rwxrw-r--. id1 id2 file1
diff --git a/tests/generic/803 b/tests/generic/803
new file mode 100755
index 0000000..d5595ed
--- /dev/null
+++ b/tests/generic/803
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test No. 803
+#
+# Ensure that we can reflink parts of two identical files:
+#   - Reflink identical parts of two identical files
+#   - Check that we still have identical contents
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "reflink"
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ="$(( $(stat -f $TESTDIR -c '%S') * 64))"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 $((BLKSZ * 2)) $((BLKSZ * 6))" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 $((BLKSZ * 2)) $((BLKSZ * 6))" $TESTDIR/file2 >> $seqres.full
+sync
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 8))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 8))" $TESTDIR/file2) \
+       || echo "Files do not match"
+
+echo "Reflink the middle blocks together"
+free_before="$(stat -f -c '%a' $TESTDIR)"
+$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 $((BLKSZ * 4)) $((BLKSZ * 4)) $((BLKSZ * 2))" $TESTDIR/file2 >> $seqres.full
+_test_remount
+free_after="$(stat -f -c '%a' $TESTDIR)"
+echo "freesp changed by $free_before -> $free_after" >> $seqres.full
+
+echo "Compare sections"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 0)) $((BLKSZ * 4))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 0)) $((BLKSZ * 4))" $TESTDIR/file2) \
+       || echo "Start sections do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 4)) $((BLKSZ * 2))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 4)) $((BLKSZ * 2))" $TESTDIR/file2) \
+       || echo "Middle sections do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 6)) $((BLKSZ * 2))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 6)) $((BLKSZ * 2))" $TESTDIR/file2) \
+       || echo "End sections do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/803.out b/tests/generic/803.out
new file mode 100644
index 0000000..1108990
--- /dev/null
+++ b/tests/generic/803.out
@@ -0,0 +1,4 @@
+QA output created by 803
+Create the original files
+Reflink the middle blocks together
+Compare sections
diff --git a/tests/generic/804 b/tests/generic/804
new file mode 100755
index 0000000..cc39e4d
--- /dev/null
+++ b/tests/generic/804
@@ -0,0 +1,90 @@
+#! /bin/bash
+# FS QA Test No. 804
+#
+# Ensuring that we can reflink non-matching parts of files:
+#   - Reflink identical ranges of two different files
+#   - Check that the non-linked ranges still do not match
+#   - Check that we end up with identical contents in the linked ranges
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "reflink"
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ="$(( $(stat -f $TESTDIR -c '%S') * 64))"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 $((BLKSZ * 2)) $((BLKSZ * 6))" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $((BLKSZ * 2)) $((BLKSZ * 6))" $TESTDIR/file2 >> $seqres.full
+sync
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 8))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 8))" $TESTDIR/file2) \
+       || echo "Files do not match (intentional)"
+
+echo "Reflink the middle blocks together"
+free_before="$(stat -f -c '%a' $TESTDIR)"
+$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 $((BLKSZ * 4)) $((BLKSZ * 4)) $((BLKSZ * 2))" $TESTDIR/file2 >> $seqres.full
+_test_remount
+free_after="$(stat -f -c '%a' $TESTDIR)"
+echo "freesp changed by $free_before -> $free_after" >> $seqres.full
+
+echo "Compare sections"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 0)) $((BLKSZ * 4))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 0)) $((BLKSZ * 4))" $TESTDIR/file2) \
+       || echo "Start sections do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 4)) $((BLKSZ * 2))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 4)) $((BLKSZ * 2))" $TESTDIR/file2) \
+       || echo "Middle sections do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 6)) $((BLKSZ * 2))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 6)) $((BLKSZ * 2))" $TESTDIR/file2) \
+       || echo "End sections do not match (intentional)"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/804.out b/tests/generic/804.out
new file mode 100644
index 0000000..df0a551
--- /dev/null
+++ b/tests/generic/804.out
@@ -0,0 +1,7 @@
+QA output created by 804
+Create the original files
+Files do not match (intentional)
+Reflink the middle blocks together
+Compare sections
+Start sections do not match (intentional)
+End sections do not match (intentional)
diff --git a/tests/generic/805 b/tests/generic/805
new file mode 100755
index 0000000..f926fb7
--- /dev/null
+++ b/tests/generic/805
@@ -0,0 +1,171 @@
+#! /bin/bash
+# FS QA Test No. 805
+#
+# Reflinking two sets of files together:
+#   - Reflink identical parts of two identical files
+#   - Reflink identical parts of two other identical files
+#   - Reflink identical parts of all four files
+#   - Check that we end up with identical contents
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "reflink"
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ="$(( $(stat -f $TESTDIR -c '%S') * 64))"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ * 8))" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((BLKSZ * 8))" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x63 0 $((BLKSZ * 8))" $TESTDIR/file3 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x64 0 $((BLKSZ * 8))" $TESTDIR/file4 >> $seqres.full
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 8))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 8))" $TESTDIR/file2) \
+       || echo "Files 1-2 do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 8))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 8))" $TESTDIR/file3) \
+       || echo "Files 1-3 do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 8))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 8))" $TESTDIR/file4) \
+       || echo "Files 1-4 do not match (intentional)"
+
+echo "Reflink the first blocks together"
+free_before="$(stat -f -c '%a' $TESTDIR)"
+$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 0 0 $((BLKSZ * 4))" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "reflink $TESTDIR/file3 0 0 $((BLKSZ * 4))" $TESTDIR/file4 >> $seqres.full
+_test_remount
+free_after="$(stat -f -c '%a' $TESTDIR)"
+echo "freesp changed by $free_before -> $free_after" >> $seqres.full
+
+echo "Compare sections"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 4))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 4))" $TESTDIR/file2) \
+       || echo "Sections of file 1-2 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 4))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 4))" $TESTDIR/file3) \
+       || echo "Sections of file 1-3 do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 4))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 4))" $TESTDIR/file3) \
+       || echo "Sections of file 1-4 do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 4))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 4))" $TESTDIR/file3) \
+       || echo "Sections of file 2-3 do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 4))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 4))" $TESTDIR/file3) \
+       || echo "Sections of file 2-4 do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 4))" $TESTDIR/file3) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 4))" $TESTDIR/file4) \
+       || echo "Sections of file 3-4 do not match"
+
+echo "Reflink the middle blocks together"
+free_before="$(stat -f -c '%a' $TESTDIR)"
+$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 0 0 $((BLKSZ * 2))" $TESTDIR/file3 >> $seqres.full
+$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 0 0 $((BLKSZ * 2))" $TESTDIR/file4 >> $seqres.full
+_test_remount
+free_after="$(stat -f -c '%a' $TESTDIR)"
+echo "freesp changed by $free_before -> $free_after" >> $seqres.full
+
+echo "Compare sections"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 2))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 2))" $TESTDIR/file2) \
+       || echo "Sections of files 1-2 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 2))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 2))" $TESTDIR/file3) \
+       || echo "Sections of files 1-3 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 2))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 2))" $TESTDIR/file4) \
+       || echo "Sections of files 1-4 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 2))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 2))" $TESTDIR/file2) \
+       || echo "Sections of files 2-3 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 2))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 2))" $TESTDIR/file3) \
+       || echo "Sections of files 2-4 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 2))" $TESTDIR/file3) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 2))" $TESTDIR/file4) \
+       || echo "Sections of files 3-4 do not match"
+
+echo "Compare previously reflinked sections"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 2)) $((BLKSZ * 2))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 2)) $((BLKSZ * 2))" $TESTDIR/file2) \
+       || echo "Sections of file 1-2 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 2)) $((BLKSZ * 2))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 2)) $((BLKSZ * 2))" $TESTDIR/file3) \
+       || echo "Sections of file 1-3 do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 2)) $((BLKSZ * 2))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 2)) $((BLKSZ * 2))" $TESTDIR/file3) \
+       || echo "Sections of file 1-4 do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 2)) $((BLKSZ * 2))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 2)) $((BLKSZ * 2))" $TESTDIR/file3) \
+       || echo "Sections of file 2-3 do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 2)) $((BLKSZ * 2))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 2)) $((BLKSZ * 2))" $TESTDIR/file3) \
+       || echo "Sections of file 2-4 do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 2)) $((BLKSZ * 2))" $TESTDIR/file3) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 2)) $((BLKSZ * 2))" $TESTDIR/file4) \
+       || echo "Sections of file 3-4 do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/805.out b/tests/generic/805.out
new file mode 100644
index 0000000..5c9629e
--- /dev/null
+++ b/tests/generic/805.out
@@ -0,0 +1,18 @@
+QA output created by 805
+Create the original files
+Files 1-2 do not match (intentional)
+Files 1-3 do not match (intentional)
+Files 1-4 do not match (intentional)
+Reflink the first blocks together
+Compare sections
+Sections of file 1-3 do not match (intentional)
+Sections of file 1-4 do not match (intentional)
+Sections of file 2-3 do not match (intentional)
+Sections of file 2-4 do not match (intentional)
+Reflink the middle blocks together
+Compare sections
+Compare previously reflinked sections
+Sections of file 1-3 do not match (intentional)
+Sections of file 1-4 do not match (intentional)
+Sections of file 2-3 do not match (intentional)
+Sections of file 2-4 do not match (intentional)
diff --git a/tests/generic/806 b/tests/generic/806
new file mode 100755
index 0000000..defcc20
--- /dev/null
+++ b/tests/generic/806
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test No. 806
+#
+# Ensure that we can dedupe parts of two files:
+#   - Dedupe identical parts of two identical files
+#   - Check that still have identical contents
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "dedupe"
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 $((BLKSZ * 2)) $((BLKSZ * 6))" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 $((BLKSZ * 2)) $((BLKSZ * 6))" $TESTDIR/file2 >> $seqres.full
+sync
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 8))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 8))" $TESTDIR/file2) \
+       || echo "Files do not match"
+
+echo "Dedupe the middle blocks together"
+free_before="$(stat -f -c '%a' $TESTDIR)"
+$XFS_IO_PROG -f -c "dedupe $TESTDIR/file1 $((BLKSZ * 4)) $((BLKSZ * 4)) $((BLKSZ * 2))" $TESTDIR/file2 >> $seqres.full
+_test_remount
+free_after="$(stat -f -c '%a' $TESTDIR)"
+echo "freesp changed by $free_before -> $free_after" >> $seqres.full
+
+echo "Compare sections"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 0)) $((BLKSZ * 4))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 0)) $((BLKSZ * 4))" $TESTDIR/file2) \
+       || echo "Start sections do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 4)) $((BLKSZ * 2))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 4)) $((BLKSZ * 2))" $TESTDIR/file2) \
+       || echo "Middle sections do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 6)) $((BLKSZ * 2))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 6)) $((BLKSZ * 2))" $TESTDIR/file2) \
+       || echo "End sections do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/806.out b/tests/generic/806.out
new file mode 100644
index 0000000..7c0fbf2
--- /dev/null
+++ b/tests/generic/806.out
@@ -0,0 +1,4 @@
+QA output created by 806
+Create the original files
+Dedupe the middle blocks together
+Compare sections
diff --git a/tests/generic/807 b/tests/generic/807
new file mode 100755
index 0000000..e86339d
--- /dev/null
+++ b/tests/generic/807
@@ -0,0 +1,89 @@
+#! /bin/bash
+# FS QA Test No. 807
+#
+# Ensuring that we cannot dedupe non-matching parts of files:
+#   - Fail to dedupe non-identical parts of two different files
+#   - Check that nothing changes in either file
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "dedupe"
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 $((BLKSZ * 2)) $((BLKSZ * 6))" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $((BLKSZ * 2)) $((BLKSZ * 6))" $TESTDIR/file2 >> $seqres.full
+sync
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 8))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v 0 $((BLKSZ * 8))" $TESTDIR/file2) \
+       || echo "Files do not match (intentional)"
+
+echo "(Fail to) dedupe the middle blocks together"
+free_before="$(stat -f -c '%a' $TESTDIR)"
+$XFS_IO_PROG -f -c "dedupe $TESTDIR/file1 $((BLKSZ * 4)) $((BLKSZ * 4)) $((BLKSZ * 2))" $TESTDIR/file2 >> $seqres.full
+_test_remount
+free_after="$(stat -f -c '%a' $TESTDIR)"
+echo "freesp changed by $free_before -> $free_after" >> $seqres.full
+
+echo "Compare sections"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 0)) $((BLKSZ * 4))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 0)) $((BLKSZ * 4))" $TESTDIR/file2) \
+       || echo "Start sections do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 4)) $((BLKSZ * 2))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 4)) $((BLKSZ * 2))" $TESTDIR/file2) \
+       || echo "Middle sections do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 6)) $((BLKSZ * 2))" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $((BLKSZ * 6)) $((BLKSZ * 2))" $TESTDIR/file2) \
+       || echo "End sections do not match (intentional)"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/807.out b/tests/generic/807.out
new file mode 100644
index 0000000..9422bc1
--- /dev/null
+++ b/tests/generic/807.out
@@ -0,0 +1,8 @@
+QA output created by 807
+Create the original files
+Files do not match (intentional)
+(Fail to) dedupe the middle blocks together
+Compare sections
+Start sections do not match (intentional)
+Middle sections do not match (intentional)
+End sections do not match (intentional)
diff --git a/tests/generic/817 b/tests/generic/817
new file mode 100755
index 0000000..109a9d8
--- /dev/null
+++ b/tests/generic/817
@@ -0,0 +1,125 @@
+#! /bin/bash
+# FS QA Test No. 817
+#
+# Ensure that we can reflink the last block of a file whose size isn't
+# block-aligned.
+#   - Create two 'a' files file whose size isn't block-aligned.
+#   - Create two 'b' files file whose size isn't block-aligned.
+#   - Reflink the last block of file1 to the last block in file2 and file3.
+#   - Check that files 1-2 match, 3-4 don't match, and that nothing matches 3.
+#   - Check that the ends of 1-3 match, and 1-3 do not match the end of file4.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "reflink"
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ + 37))" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ + 37))" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((BLKSZ + 37))" $TESTDIR/file3 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((BLKSZ + 37))" $TESTDIR/file4 >> $seqres.full
+
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+C4="$(_md5_checksum $TESTDIR/file4)"
+
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
+test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+
+echo "Reflink the last blocks together"
+$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 $BLKSZ $BLKSZ 37" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 $BLKSZ $BLKSZ 37" $TESTDIR/file3 >> $seqres.full
+_test_remount
+
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+C4="$(_md5_checksum $TESTDIR/file4)"
+
+echo "Compare files"
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
+test "${C3}" != "${C4}" || echo "file3 and file4 should match"
+
+echo "Compare sections"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file2) \
+       || echo "End sections of files 1-2 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file3) \
+       || echo "End sections of files 1-3 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file4) \
+       || echo "End sections of files 1-4 do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file3) \
+       || echo "End sections of files 2-3 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file4) \
+       || echo "End sections of files 2-4 do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file3) \
+       <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file4) \
+       || echo "End sections of files 3-4 do not match (intentional)"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/817.out b/tests/generic/817.out
new file mode 100644
index 0000000..3574727
--- /dev/null
+++ b/tests/generic/817.out
@@ -0,0 +1,8 @@
+QA output created by 817
+Create the original files
+Reflink the last blocks together
+Compare files
+Compare sections
+End sections of files 1-4 do not match (intentional)
+End sections of files 2-4 do not match (intentional)
+End sections of files 3-4 do not match (intentional)
diff --git a/tests/generic/818 b/tests/generic/818
new file mode 100755
index 0000000..0a99768
--- /dev/null
+++ b/tests/generic/818
@@ -0,0 +1,125 @@
+#! /bin/bash
+# FS QA Test No. 818
+#
+# Ensure that we can dedupe the last block of a file whose size isn't
+# block-aligned.
+#   - Create two 'a' files file whose size isn't block-aligned.
+#   - Create two 'b' files file whose size isn't block-aligned.
+#   - Dedupe the last block of file1 to the last block in file2 and file3.
+#   - Check that files 1-2 match, and that 3-4 match.
+#   - Check that the ends of 1-2 and 3-4 match, and that 1-3 don't match.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "dedupe"
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original files"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ + 37))" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $((BLKSZ + 37))" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((BLKSZ + 37))" $TESTDIR/file3 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((BLKSZ + 37))" $TESTDIR/file4 >> $seqres.full
+
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+C4="$(_md5_checksum $TESTDIR/file4)"
+
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
+test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+
+echo "Dedupe the last blocks together"
+$XFS_IO_PROG -f -c "dedupe $TESTDIR/file1 $BLKSZ $BLKSZ 37" $TESTDIR/file2 >> $seqres.full
+$XFS_IO_PROG -f -c "dedupe $TESTDIR/file1 $BLKSZ $BLKSZ 37" $TESTDIR/file3 >> $seqres.full
+_test_remount
+
+C1="$(_md5_checksum $TESTDIR/file1)"
+C2="$(_md5_checksum $TESTDIR/file2)"
+C3="$(_md5_checksum $TESTDIR/file3)"
+C4="$(_md5_checksum $TESTDIR/file4)"
+
+echo "Compare files"
+test "${C1}" = "${C2}" || echo "file1 and file2 should match"
+test "${C1}" != "${C3}" || echo "file1 and file3 should not match"
+test "${C1}" != "${C4}" || echo "file1 and file4 should not match"
+test "${C2}" != "${C3}" || echo "file2 and file3 should not match"
+test "${C2}" != "${C4}" || echo "file2 and file4 should not match"
+test "${C3}" = "${C4}" || echo "file3 and file4 should match"
+
+echo "Compare sections"
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file2) \
+       || echo "End sections of files 1-2 do not match"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file3) \
+       || echo "End sections of files 1-3 do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file1) \
+       <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file4) \
+       || echo "End sections of files 1-4 do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file3) \
+       || echo "End sections of files 2-3 do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file2) \
+       <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file4) \
+       || echo "End sections of files 2-4 do not match (intentional)"
+
+cmp -s <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file3) \
+       <($XFS_IO_PROG -f -c "pread -q -v $BLKSZ 37" $TESTDIR/file4) \
+       || echo "End sections of files 3-4 do not match"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/818.out b/tests/generic/818.out
new file mode 100644
index 0000000..242dc8c
--- /dev/null
+++ b/tests/generic/818.out
@@ -0,0 +1,9 @@
+QA output created by 818
+Create the original files
+Dedupe the last blocks together
+Compare files
+Compare sections
+End sections of files 1-3 do not match (intentional)
+End sections of files 1-4 do not match (intentional)
+End sections of files 2-3 do not match (intentional)
+End sections of files 2-4 do not match (intentional)
diff --git a/tests/generic/819 b/tests/generic/819
new file mode 100755
index 0000000..08bc374
--- /dev/null
+++ b/tests/generic/819
@@ -0,0 +1,128 @@
+#! /bin/bash
+# FS QA Test No. 819
+#
+# Ensure that we can reflink and dedupe blocks within the same file...
+#   - Create a file with three distinct blocks ABB
+#   - Reflink block zero to the multiple-of-three blocks
+#   - Reflink block one to the multiple-of-five blocks
+#   - Dedupe block two to the multiple-of-seven blocks
+#   - Check that we successfully avoid deduping with holes, unwritten
+#     extents, and non-matches; but actually dedupe real matches.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015, Oracle and/or its affiliates.  All Rights Reserved.
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
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf $tmp.* $TESTDIR
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_require_test_reflink
+_supported_os Linux
+
+_require_xfs_io_command "reflink"
+_require_xfs_io_command "dedupe"
+_require_xfs_io_command "falloc"
+_require_test
+
+rm -f $seqres.full
+
+TESTDIR=$TEST_DIR/test-$seq
+rm -rf $TESTDIR
+mkdir $TESTDIR
+
+echo "Create the original file blocks"
+BLKSZ="$(stat -f $TESTDIR -c '%S')"
+$XFS_IO_PROG -f -c "pwrite -S 0x61 0 $BLKSZ" $TESTDIR/file1 >> $seqres.full
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $BLKSZ $((BLKSZ * 2))" $TESTDIR/file1 >> $seqres.full
+
+NR_BLKS=1024
+
+echo "fallocate half the file"
+$XFS_IO_PROG -f -c "falloc $((NR_BLKS * BLKSZ / 2)) $((NR_BLKS * BLKSZ / 2))" $TESTDIR/file1 >> $seqres.full
+
+echo "Reflink block zero to the threes"
+seq 1 $((NR_BLKS / 3)) | while read nr; do
+	$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 0 $((nr * 3 * BLKSZ)) $BLKSZ" $TESTDIR/file1 >> $seqres.full
+done
+
+echo "Reflink block one to the fives"
+seq 1 $((NR_BLKS / 5)) | while read nr; do
+	$XFS_IO_PROG -f -c "reflink $TESTDIR/file1 $BLKSZ $((nr * 5 * BLKSZ)) $BLKSZ" $TESTDIR/file1 >> $seqres.full
+done
+
+echo "Dedupe block two to the sevens"
+seq 1 $((NR_BLKS / 7)) | while read nr; do
+	$XFS_IO_PROG -f -c "dedupe $TESTDIR/file1 $((BLKSZ * 2)) $((nr * 7 * BLKSZ)) $BLKSZ" $TESTDIR/file1 >> $seqres.full
+done
+
+_test_remount
+
+echo "Check block mappings"
+crcZ=$(_md5_range_checksum /dev/zero 0 $BLKSZ)
+crc0=$(_md5_range_checksum $TESTDIR/file1 0 $BLKSZ)
+crc1=$(_md5_range_checksum $TESTDIR/file1 $BLKSZ $BLKSZ)
+crc2=$(_md5_range_checksum $TESTDIR/file1 $((BLKSZ * 2)) $BLKSZ)
+
+check_block() {
+	lblk="$1"
+	rem7=$((lblk % 7))
+	rem5=$((lblk % 5))
+	rem3=$((lblk % 3))
+
+	crc=$(_md5_range_checksum $TESTDIR/file1 $((lblk * BLKSZ)) $BLKSZ)
+
+	if [ $rem7 -eq 0 ]; then
+		if [ $rem5 -eq 0 ]; then
+			test $crc2 = $crc || echo "lblk $lblk doesn't match block 2"
+		elif [ $rem3 -eq 0 ]; then
+			test $crc0 = $crc || echo "lblk $lblk doesn't match block 0"
+		elif [ $lblk -lt $((NR_BLKS / 2)) ]; then
+			test $crcZ = $crc || echo "lblk $lblk isn't zeroed"
+		fi
+	elif [ $rem5 -eq 0 ]; then
+		test $crc1 = $crc || echo "lblk $lblk doesn't match block 1"
+	elif [ $rem3 -eq 0 ]; then
+		test $crc0 = $crc || echo "lblk $lblk doesn't match block 0"
+	elif [ $lblk -lt $((NR_BLKS / 2)) ]; then
+		test $crcZ = $crc || echo "lblk $lblk isn't zeroed"
+	fi
+}
+
+seq 3 $((NR_BLKS - 1)) | while read lblk; do
+	err="$(check_block $lblk)"
+	test -n "$err" && echo "$lblk: $err"
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/819.out b/tests/generic/819.out
new file mode 100644
index 0000000..0ee5b14
--- /dev/null
+++ b/tests/generic/819.out
@@ -0,0 +1,7 @@
+QA output created by 819
+Create the original file blocks
+fallocate half the file
+Reflink block zero to the threes
+Reflink block one to the fives
+Dedupe block two to the sevens
+Check block mappings
diff --git a/tests/generic/group b/tests/generic/group
index d8b21ce..25cffa7 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -210,3 +210,11 @@
 800 auto quick clone
 801 auto quick clone
 802 auto quick clone
+803 auto quick clone
+804 auto quick clone
+805 auto quick clone
+806 auto quick clone
+807 auto quick clone
+817 auto quick clone
+818 auto quick clone
+819 auto quick clone

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
