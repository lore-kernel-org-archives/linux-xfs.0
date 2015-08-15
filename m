Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 417A87F50
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 20:52:36 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C5BBEAC006
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 18:52:35 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id aw4cjTDU9rkQQvG0 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Aug 2015 18:52:32 -0700 (PDT)
Subject: [PATCH 4/7] ext4: test file/dir/symlink metadata corruption
	checking and repair
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 14 Aug 2015 18:52:29 -0700
Message-ID: <20150815015229.4333.87123.stgit@birch.djwong.org>
In-Reply-To: <20150815015200.4333.9278.stgit@birch.djwong.org>
References: <20150815015200.4333.9278.stgit@birch.djwong.org>
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
Cc: linux-ext4@vger.kernel.org, fstests@vger.kernel.org, xfs@oss.sgi.com

Targeted fuzzing tests which destroy various pieces of file,
directory, and symlink metadata; the tests look for (a) kernel
detection of corruption, (b) e2fsck repair of said corruption, and (c)
post-repair fs usability.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/ext4/707     |  126 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/707.out |   15 ++++++
 tests/ext4/708     |  124 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/708.out |   15 ++++++
 tests/ext4/709     |  103 +++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/709.out |   12 +++++
 tests/ext4/710     |   96 ++++++++++++++++++++++++++++++++++++++++
 tests/ext4/710.out |   12 +++++
 tests/ext4/711     |   99 +++++++++++++++++++++++++++++++++++++++++
 tests/ext4/711.out |   12 +++++
 tests/ext4/712     |   97 ++++++++++++++++++++++++++++++++++++++++
 tests/ext4/712.out |   12 +++++
 tests/ext4/713     |   95 +++++++++++++++++++++++++++++++++++++++
 tests/ext4/713.out |   11 +++++
 tests/ext4/group   |    7 +++
 15 files changed, 836 insertions(+)
 create mode 100755 tests/ext4/707
 create mode 100644 tests/ext4/707.out
 create mode 100755 tests/ext4/708
 create mode 100644 tests/ext4/708.out
 create mode 100755 tests/ext4/709
 create mode 100644 tests/ext4/709.out
 create mode 100755 tests/ext4/710
 create mode 100644 tests/ext4/710.out
 create mode 100755 tests/ext4/711
 create mode 100644 tests/ext4/711.out
 create mode 100755 tests/ext4/712
 create mode 100644 tests/ext4/712.out
 create mode 100755 tests/ext4/713
 create mode 100644 tests/ext4/713.out


diff --git a/tests/ext4/707 b/tests/ext4/707
new file mode 100755
index 0000000..c62b107
--- /dev/null
+++ b/tests/ext4/707
@@ -0,0 +1,126 @@
+#! /bin/bash
+# FS QA Test No. 707
+#
+# Create and populate an ext4 filesystem, corrupt an inode, then see how
+# the kernel and e2fsck deal with it.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle, Inc.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
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
+    #rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_fs ext4
+_supported_os Linux
+
+_require_scratch
+test -n "${FORCE_FUZZ}" || _require_scratch_ext4_crc
+_require_attrs
+
+rm -f $seqres.full
+TESTDIR="${SCRATCH_MNT}/scratchdir"
+TESTFILE="${TESTDIR}/testfile"
+
+echo "+ create scratch fs"
+_scratch_mkfs_ext4 > /dev/null 2>&1
+
+echo "+ mount fs image"
+_scratch_mount
+
+echo "+ make some files"
+mkdir -p "${TESTDIR}"
+for x in `seq 1 1024`; do
+	touch "${SCRATCH_MNT}/junk.${x}"
+	inode="$(stat -c '%i' "${SCRATCH_MNT}/junk.${x}")"
+	if [ "$x" -gt 512 ] && [ "$((inode % 64))" -eq 0 ]; then
+		mv "${SCRATCH_MNT}/junk.${x}" "${TESTFILE}.1"
+		break
+	fi
+done
+for x in `seq 2 64`; do
+	touch "${TESTFILE}.${x}"
+done
+inode="$(stat -c '%i' "${TESTFILE}.1")"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+echo "+ corrupt image"
+blk="$(debugfs -R "imap <$inode>" "${SCRATCH_DEV}" 2> /dev/null | grep located | sed -e 's/^.*block \([0-9]*\),.*$/\1/g')"
+debugfs -w -R "zap_block ${blk}" "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "inode fuzz failed"
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify files"
+broken=0
+for x in `seq 1 64`; do
+	#test -e "${TESTFILE}.${x}" || continue
+	stat "${TESTFILE}.${x}" >> $seqres.full 2>&1
+	test $? -ne 0 && broken=1
+	echo moo | dd oflag=append of="${TESTFILE}.${x}" 2>/dev/null
+	test $? -ne 0 && broken=1
+done
+echo "broken: ${broken}"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ modify files (2)"
+broken=0
+for x in `seq 1 64`; do
+	test -e "${TESTFILE}.${x}" || continue
+	stat "${TESTFILE}.${x}" >> $seqres.full 2>&1
+	test $? -ne 0 && broken=1
+	echo moo | dd oflag=append of="${TESTFILE}.${x}" 2>/dev/null
+	test $? -ne 0 && broken=1
+done
+echo "broken: ${broken}"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+status=0
+exit
diff --git a/tests/ext4/707.out b/tests/ext4/707.out
new file mode 100644
index 0000000..4cbeaf9
--- /dev/null
+++ b/tests/ext4/707.out
@@ -0,0 +1,15 @@
+QA output created by 707
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ corrupt image
++ mount image
++ modify files
+broken: 1
++ repair fs
++ mount image (2)
++ chattr -R -i
++ modify files (2)
+broken: 0
++ check fs (2)
diff --git a/tests/ext4/708 b/tests/ext4/708
new file mode 100755
index 0000000..24e259b
--- /dev/null
+++ b/tests/ext4/708
@@ -0,0 +1,124 @@
+#! /bin/bash
+# FS QA Test No. 708
+#
+# Create and populate an ext4 filesystem, corrupt root directory, then
+# see how the kernel and e2fsck deal with it.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle, Inc.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
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
+    #rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_fs ext4
+_supported_os Linux
+
+_require_scratch
+test -n "${FORCE_FUZZ}" || _require_scratch_ext4_crc
+_require_attrs
+
+rm -f $seqres.full
+TESTDIR="${SCRATCH_MNT}/scratchdir"
+TESTFILE="${TESTDIR}/testfile"
+
+echo "+ create scratch fs"
+_scratch_mkfs_ext4 > /dev/null 2>&1
+
+echo "+ mount fs image"
+_scratch_mount
+
+echo "+ make some files"
+mkdir -p "${TESTDIR}"
+for x in `seq 1 128`; do
+	touch "${SCRATCH_MNT}/junk.${x}"
+	inode="$(stat -c '%i' "${SCRATCH_MNT}/junk.${x}")"
+	if [ "$x" -gt 64 ] && [ "$((inode % 64))" -eq 0 ]; then
+		mv "${SCRATCH_MNT}/junk.${x}" "${TESTFILE}.1"
+		break
+	fi
+done
+for x in `seq 2 64`; do
+	touch "${TESTFILE}.${x}"
+done
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+echo "+ corrupt image"
+debugfs -w -R "zap -f / 0" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify files"
+broken=0
+for x in `seq 1 64`; do
+	#test -e "${TESTFILE}.${x}" || continue
+	stat "${TESTFILE}.${x}" >> $seqres.full 2>&1
+	test $? -ne 0 && broken=1
+	echo moo | dd oflag=append of="${TESTFILE}.${x}" 2>/dev/null
+	test $? -ne 0 && broken=1
+done
+echo "broken: ${broken}"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1 && _fail "e2fsck should not succeed"
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ modify files (2)"
+broken=0
+for x in `seq 1 64`; do
+	test -e "${TESTFILE}.${x}" || continue
+	stat "${TESTFILE}.${x}" >> $seqres.full 2>&1
+	test $? -ne 0 && broken=1
+	echo moo | dd oflag=append of="${TESTFILE}.${x}" 2>/dev/null
+	test $? -ne 0 && broken=1
+done
+echo "broken: ${broken}"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+status=0
+exit
diff --git a/tests/ext4/708.out b/tests/ext4/708.out
new file mode 100644
index 0000000..0eb44c0
--- /dev/null
+++ b/tests/ext4/708.out
@@ -0,0 +1,15 @@
+QA output created by 708
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ corrupt image
++ mount image
++ modify files
+broken: 1
++ repair fs
++ mount image (2)
++ chattr -R -i
++ modify files (2)
+broken: 0
++ check fs (2)
diff --git a/tests/ext4/709 b/tests/ext4/709
new file mode 100755
index 0000000..9edfea9
--- /dev/null
+++ b/tests/ext4/709
@@ -0,0 +1,103 @@
+#! /bin/bash
+# FS QA Test No. 709
+#
+# Create and populate an ext4 filesystem, corrupt an extent tree block, then
+# see how the kernel and e2fsck deal with it.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle, Inc.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
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
+    #rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_fs ext4
+_supported_os Linux
+
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
+_require_scratch
+test -n "${FORCE_FUZZ}" || _require_scratch_ext4_crc
+_require_attrs
+
+rm -f $seqres.full
+TESTDIR="${SCRATCH_MNT}/scratchdir"
+TESTFILE="${TESTDIR}/testfile"
+
+echo "+ create scratch fs"
+_scratch_mkfs_ext4 > /dev/null 2>&1
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+freeblks="$((3 * blksz / 12))"
+
+echo "+ make some files"
+$XFS_IO_PROG -f -c "falloc 0 $((blksz * freeblks))" "${SCRATCH_MNT}/bigfile" >> $seqres.full
+seq 1 2 ${freeblks} | while read lblk; do
+	$XFS_IO_PROG -f -c "fpunch $((lblk * blksz)) ${blksz}" "${SCRATCH_MNT}/bigfile" >> $seqres.full
+done
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+echo "+ corrupt image"
+debugfs "${SCRATCH_DEV}" -R 'ex /bigfile' 2> /dev/null | grep '^ 0' | awk '{print $8}' | while read blk; do
+	$XFS_IO_PROG -f -c "pwrite -S 0x62 $((blk * blksz + 8)) 8" "${SCRATCH_DEV}" >> $seqres.full
+done
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify files"
+echo moo >> "${SCRATCH_MNT}/bigfile" 2> /dev/null && _fail "extent tree should be corrupt"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ modify files (2)"
+$XFS_IO_PROG -f -c "pwrite ${blksz} ${blksz}" "${SCRATCH_MNT}/bigfile" >> $seqres.full
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+status=0
+exit
diff --git a/tests/ext4/709.out b/tests/ext4/709.out
new file mode 100644
index 0000000..6d8a022
--- /dev/null
+++ b/tests/ext4/709.out
@@ -0,0 +1,12 @@
+QA output created by 709
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ corrupt image
++ mount image
++ modify files
++ repair fs
++ mount image (2)
++ modify files (2)
++ check fs (2)
diff --git a/tests/ext4/710 b/tests/ext4/710
new file mode 100755
index 0000000..e113254
--- /dev/null
+++ b/tests/ext4/710
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. 710
+#
+# Create and populate an ext4 filesystem, corrupt a dirent block, then
+# see how the kernel and e2fsck deal with it.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle, Inc.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
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
+    #rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_fs ext4
+_supported_os Linux
+
+_require_scratch
+test -n "${FORCE_FUZZ}" || _require_scratch_ext4_crc
+_require_attrs
+
+rm -f $seqres.full
+TESTDIR="${SCRATCH_MNT}/scratchdir"
+TESTFILE="${TESTDIR}/testfile"
+
+echo "+ create scratch fs"
+_scratch_mkfs_ext4 > /dev/null 2>&1
+
+echo "+ mount fs image"
+_scratch_mount
+
+echo "+ make some files"
+for x in `seq 1 15`; do
+	mkdir -p "${SCRATCH_MNT}/test/d_${x}"
+done
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+echo "+ corrupt image"
+debugfs -w -R "zap -f /test 0" "${SCRATCH_DEV}" 2> /dev/null
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify dirs"
+mkdir -p "${SCRATCH_MNT}/test/newdir" 2> /dev/null && _fail "directory should be corrupt"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ modify dirs (2)"
+mkdir -p "${SCRATCH_MNT}/test/newdir" || _fail "directory should be corrupt"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+status=0
+exit
diff --git a/tests/ext4/710.out b/tests/ext4/710.out
new file mode 100644
index 0000000..6d9b3aa
--- /dev/null
+++ b/tests/ext4/710.out
@@ -0,0 +1,12 @@
+QA output created by 710
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ corrupt image
++ mount image
++ modify dirs
++ repair fs
++ mount image (2)
++ modify dirs (2)
++ check fs (2)
diff --git a/tests/ext4/711 b/tests/ext4/711
new file mode 100755
index 0000000..06c6a39
--- /dev/null
+++ b/tests/ext4/711
@@ -0,0 +1,99 @@
+#! /bin/bash
+# FS QA Test No. 711
+#
+# Create and populate an ext4 filesystem, corrupt a htree block, then
+# see how the kernel and e2fsck deal with it.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle, Inc.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
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
+    #rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_fs ext4
+_supported_os Linux
+
+_require_scratch
+test -n "${FORCE_FUZZ}" || _require_scratch_ext4_crc
+_require_attrs
+
+rm -f $seqres.full
+TESTDIR="${SCRATCH_MNT}/scratchdir"
+TESTFILE="${TESTDIR}/testfile"
+
+echo "+ create scratch fs"
+_scratch_mkfs_ext4 > /dev/null 2>&1
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+
+echo "+ make some files"
+mkdir -p "${SCRATCH_MNT}/test/"
+for x in `seq 1 $((blksz * 4 / 256))`; do
+	fname="$(printf "%.255s\n" "$(perl -e "print \"${x}_\" x 500;")")"
+	touch "${SCRATCH_MNT}/test/${fname}"
+done
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+echo "+ corrupt image"
+debugfs -w -R "zap -f /test 0" "${SCRATCH_DEV}" 2> /dev/null
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify dirs"
+mkdir -p "${SCRATCH_MNT}/test/newdir" 2> /dev/null && _fail "htree should be corrupt"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ modify dirs (2)"
+mkdir -p "${SCRATCH_MNT}/test/newdir" || _fail "htree should not be corrupt"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+status=0
+exit
diff --git a/tests/ext4/711.out b/tests/ext4/711.out
new file mode 100644
index 0000000..ef1fc8b
--- /dev/null
+++ b/tests/ext4/711.out
@@ -0,0 +1,12 @@
+QA output created by 711
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ corrupt image
++ mount image
++ modify dirs
++ repair fs
++ mount image (2)
++ modify dirs (2)
++ check fs (2)
diff --git a/tests/ext4/712 b/tests/ext4/712
new file mode 100755
index 0000000..4bd341e
--- /dev/null
+++ b/tests/ext4/712
@@ -0,0 +1,97 @@
+#! /bin/bash
+# FS QA Test No. 712
+#
+# Create and populate an ext4 filesystem, corrupt a xattr block, then
+# see how the kernel and e2fsck deal with it.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle, Inc.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
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
+    #rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_fs ext4
+_supported_os Linux
+
+_require_scratch
+test -n "${FORCE_FUZZ}" || _require_scratch_ext4_crc
+_require_attrs
+
+rm -f $seqres.full
+TESTDIR="${SCRATCH_MNT}/scratchdir"
+TESTFILE="${TESTDIR}/testfile"
+
+echo "+ create scratch fs"
+_scratch_mkfs_ext4 > /dev/null 2>&1
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+
+echo "+ make some files"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${SCRATCH_MNT}/attrfile" >> $seqres.full
+setfattr -n user.key -v "$(perl -e 'print "v" x 300;')" "${SCRATCH_MNT}/attrfile"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+echo "+ corrupt image"
+blk="$(debugfs -R 'stat /attrfile' "${SCRATCH_DEV}" 2> /dev/null | grep 'File ACL:' | sed -e 's/^.*File ACL: \([0-9]*\).*Directory.*$/\1/g')"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $((blk * blksz + 20)) 8" "${SCRATCH_DEV}" >> $seqres.full
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify attrs"
+setfattr -n user.newkey -v "$(perl -e 'print "v" x 300;')" "${SCRATCH_MNT}/attrfile" 2> /dev/null && _fail "xattr should be corrupt"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ modify attrs (2)"
+setfattr -n user.newkey -v "$(perl -e 'print "v" x 300;')" "${SCRATCH_MNT}/attrfile" || _fail "xattr should not be corrupt"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+status=0
+exit
diff --git a/tests/ext4/712.out b/tests/ext4/712.out
new file mode 100644
index 0000000..3bafe93
--- /dev/null
+++ b/tests/ext4/712.out
@@ -0,0 +1,12 @@
+QA output created by 712
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ corrupt image
++ mount image
++ modify attrs
++ repair fs
++ mount image (2)
++ modify attrs (2)
++ check fs (2)
diff --git a/tests/ext4/713 b/tests/ext4/713
new file mode 100755
index 0000000..cf15425
--- /dev/null
+++ b/tests/ext4/713
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 713
+#
+# Create and populate an ext4 filesystem, corrupt a big symlink, then
+# see how the kernel and e2fsck deal with it.  (They won't)
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Oracle, Inc.  All Rights Reserved.
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
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
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
+    #rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+# real QA test starts here
+_supported_fs ext4
+_supported_os Linux
+
+_require_scratch
+test -n "${FORCE_FUZZ}" || _require_scratch_ext4_crc
+_require_attrs
+
+rm -f $seqres.full
+TESTDIR="${SCRATCH_MNT}/scratchdir"
+TESTFILE="${TESTDIR}/testfile"
+
+echo "+ create scratch fs"
+_scratch_mkfs_ext4 -O journal > /dev/null 2>&1
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+test "${blksz}" -gt 4096 && blksz=4096
+
+echo "+ make some files"
+echo "file contents: moo" > "${SCRATCH_MNT}/x"
+str="$(perl -e "print './' x $(( (blksz / 2) - 16));")x"
+(cd $SCRATCH_MNT; ln -s "${str}" "long_symlink")
+cat "${SCRATCH_MNT}/long_symlink"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+echo "+ corrupt image"
+debugfs -w -R 'zap -f /long_symlink -p 0x62 0' "${SCRATCH_DEV}" 2> /dev/null
+
+echo "+ mount image"
+_scratch_mount 2> /dev/null
+cat "${SCRATCH_MNT}/long_symlink" 2>/dev/null && _fail "symlink should be broken"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+cat "${SCRATCH_MNT}/long_symlink" 2>/dev/null && _fail "symlink should be broken"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+status=0
+exit
diff --git a/tests/ext4/713.out b/tests/ext4/713.out
new file mode 100644
index 0000000..10e7305
--- /dev/null
+++ b/tests/ext4/713.out
@@ -0,0 +1,11 @@
+QA output created by 713
++ create scratch fs
++ mount fs image
++ make some files
+file contents: moo
++ check fs
++ corrupt image
++ mount image
++ repair fs
++ mount image (2)
++ check fs (2)
diff --git a/tests/ext4/group b/tests/ext4/group
index d685076..13c8d90 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -24,3 +24,10 @@
 704 fuzzers
 705 fuzzers
 706 fuzzers
+707 fuzzers
+708 fuzzers
+709 fuzzers
+710 fuzzers
+711 fuzzers
+712 fuzzers
+713 fuzzers

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
