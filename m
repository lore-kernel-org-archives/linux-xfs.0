Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 32A8F7F66
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 20:52:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 059DC304039
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 18:52:28 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id igmpg5cVoOGBjh8J (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Aug 2015 18:52:26 -0700 (PDT)
Subject: [PATCH 3/7] ext4: test block group metadata corruption checking and
	repair
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 14 Aug 2015 18:52:20 -0700
Message-ID: <20150815015220.4333.14758.stgit@birch.djwong.org>
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

Targeted fuzzing tests which destroy various pieces of filesystem or
block group metadata; the tests look for (a) kernel detection of
corruption, (b) e2fsck repair of said corruption, and (c) post-repair
fs usability.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc          |   11 +++++
 tests/ext4/701     |  122 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/701.out |   13 ++++++
 tests/ext4/702     |  103 ++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/702.out |   10 ++++
 tests/ext4/703     |  113 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/703.out |   12 +++++
 tests/ext4/704     |  102 +++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/704.out |   12 +++++
 tests/ext4/705     |   88 ++++++++++++++++++++++++++++++++++++++
 tests/ext4/705.out |   10 ++++
 tests/ext4/706     |   87 +++++++++++++++++++++++++++++++++++++
 tests/ext4/706.out |   10 ++++
 tests/ext4/group   |    6 +++
 14 files changed, 699 insertions(+)
 create mode 100755 tests/ext4/701
 create mode 100644 tests/ext4/701.out
 create mode 100755 tests/ext4/702
 create mode 100644 tests/ext4/702.out
 create mode 100755 tests/ext4/703
 create mode 100644 tests/ext4/703.out
 create mode 100755 tests/ext4/704
 create mode 100644 tests/ext4/704.out
 create mode 100755 tests/ext4/705
 create mode 100644 tests/ext4/705.out
 create mode 100755 tests/ext4/706
 create mode 100644 tests/ext4/706.out


diff --git a/common/rc b/common/rc
index 70d2fa8..f889103 100644
--- a/common/rc
+++ b/common/rc
@@ -1398,6 +1398,17 @@ _require_xfs_crc()
 	umount $SCRATCH_MNT
 }
 
+# this test requires the ext4 kernel support crc feature on scratch device
+#
+_require_scratch_ext4_crc()
+{
+	_scratch_mkfs_ext4 >/dev/null 2>&1
+	dumpe2fs -h $SCRATCH_DEV 2> /dev/null | grep -q metadata_csum || _notrun "metadata_csum not supported by this filesystem"
+	_scratch_mount >/dev/null 2>&1 \
+	   || _notrun "Kernel doesn't support metadata_csum feature"
+	umount $SCRATCH_MNT
+}
+
 # this test requires the bigalloc feature to be available in mkfs.ext4
 #
 _require_ext4_mkfs_bigalloc()
diff --git a/tests/ext4/701 b/tests/ext4/701
new file mode 100755
index 0000000..6833954
--- /dev/null
+++ b/tests/ext4/701
@@ -0,0 +1,122 @@
+#! /bin/bash
+# FS QA Test No. 701
+#
+# Create and populate an ext4 filesystem, corrupt the primary superblock, then
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
+dumpe2fs -g "${SCRATCH_DEV}" > /dev/null 2>&1 || _notrun "dumpe2fs -g not supported"
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+nr_groups="$(dumpe2fs -g "${SCRATCH_DEV}" 2> /dev/null | tail -n 1 | cut -d : -f 1)"
+test "${nr_groups}" -gt 0 || _notrun "scratch device not big enough for backup superblocks"
+backup_sb="$(dumpe2fs -g "${SCRATCH_DEV}" 2> /dev/null | awk -F ':' 'BEGIN {x = 0;} {if (x == 0 && int($3) > 1) {print $3; x++;}}')"
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
+dumpe2fs -g "${SCRATCH_DEV}" 2>/dev/null | awk -F ':' '{if ($1 == 0) {print $3}}' | while read blk; do
+	debugfs -w -R "zap_block ${blk}" "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "primary sb fuzz failed"
+done
+
+echo "+ mount image"
+_scratch_mount 2> /dev/null && _fail "mount should not succeed"
+
+echo "+ repair fs"
+# Have to specify backup sb and blocksize here so we don't pick up superblocks
+# scattered elsewhere on the scratch device.
+echo e2fsck -f -y -B "${blksz}" -b "${backup_sb}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+e2fsck -f -y -B "${blksz}" -b "${backup_sb}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
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
+	stat "${TESTFILE}.${x}" >> /dev/null 2>&1
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
diff --git a/tests/ext4/701.out b/tests/ext4/701.out
new file mode 100644
index 0000000..a44edb2
--- /dev/null
+++ b/tests/ext4/701.out
@@ -0,0 +1,13 @@
+QA output created by 701
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ corrupt image
++ mount image
++ repair fs
++ mount image (2)
++ chattr -R -i
++ modify files (2)
+broken: 0
++ check fs (2)
diff --git a/tests/ext4/702 b/tests/ext4/702
new file mode 100755
index 0000000..60c52f6
--- /dev/null
+++ b/tests/ext4/702
@@ -0,0 +1,103 @@
+#! /bin/bash
+# FS QA Test No. 702
+#
+# Create and populate an ext4 filesystem, corrupt a group descriptor, then
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
+dumpe2fs -g "${SCRATCH_DEV}" > /dev/null 2>&1 || _notrun "dumpe2fs -g not supported"
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
+	echo moo >> "${TESTFILE}.${x}"
+done
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+echo "+ corrupt image"
+dumpe2fs -g "${SCRATCH_DEV}" 2>/dev/null | awk -F ':' '{if (int($4) != -1) {print $4}}' | sed -e 's/-.*$//g' | awk '{if (int($1) > 0) {print $1}}' | while read blk; do
+	debugfs -w -R "zap_block ${blk}" "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "group descriptor fuzz failed"
+done
+
+echo "+ mount image"
+_scratch_mount 2> /dev/null && _fail "mount should not succeed"
+
+echo "+ repair fs"
+e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
+e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+status=0
+exit
diff --git a/tests/ext4/702.out b/tests/ext4/702.out
new file mode 100644
index 0000000..66f3b3b
--- /dev/null
+++ b/tests/ext4/702.out
@@ -0,0 +1,10 @@
+QA output created by 702
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ corrupt image
++ mount image
++ repair fs
++ mount image (2)
++ check fs (2)
diff --git a/tests/ext4/703 b/tests/ext4/703
new file mode 100755
index 0000000..61fb55b
--- /dev/null
+++ b/tests/ext4/703
@@ -0,0 +1,113 @@
+#! /bin/bash
+# FS QA Test No. 703
+#
+# Create and populate an ext4 filesystem, corrupt a block bitmap, then
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
+dumpe2fs -g "${SCRATCH_DEV}" > /dev/null 2>&1 || _notrun "dumpe2fs -g not supported"
+nr_groups="$(dumpe2fs -g "${SCRATCH_DEV}" 2> /dev/null | tail -n 1 | cut -d : -f 1)"
+
+echo "+ mount fs image"
+_scratch_mount
+# abuse orlov allocator in the hopes that each bg ends up with some inodes
+for i in `seq 1 $((nr_groups * 8))`; do
+	mkdir -p "${SCRATCH_MNT}/d_${i}"
+done
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+freeblks="$(stat -f -c '%a' "${SCRATCH_MNT}")"
+$XFS_IO_PROG -f -c "falloc 0 $((blksz * freeblks))" "${SCRATCH_MNT}/bigfile2" >> $seqres.full
+umount "${SCRATCH_MNT}"
+
+echo "+ make some files"
+_scratch_mount
+rm -rf "${SCRATCH_MNT}/bigfile2"
+touch "${SCRATCH_MNT}/bigfile"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+echo "+ corrupt image"
+dumpe2fs -g "${SCRATCH_DEV}" 2>/dev/null | awk -F ':' '{if (int($5) > 0) {print $5}}' | while read blk; do
+	debugfs -w -n -R "zap_block -p 0xff ${blk}" "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "block bitmap fuzz failed"
+done
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify files"
+b_bytes="$(stat -c '%B' "${SCRATCH_MNT}/bigfile")"
+$XFS_IO_PROG -f -c "falloc 0 $((blksz * freeblks))" "${SCRATCH_MNT}/bigfile" >> $seqres.full 2> /dev/null
+after="$(stat -c '%b' "${SCRATCH_MNT}/bigfile")"
+echo "$((after * b_bytes))" lt "$((blksz * freeblks / 4))" >> $seqres.full
+test "$((after * b_bytes))" -lt "$((blksz * freeblks / 4))" || _fail "falloc should fail"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ modify files (2)"
+$XFS_IO_PROG -f -c "falloc 0 $((blksz * freeblks))" "${SCRATCH_MNT}/bigfile" >> $seqres.full
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+status=0
+exit
diff --git a/tests/ext4/703.out b/tests/ext4/703.out
new file mode 100644
index 0000000..42ecc84
--- /dev/null
+++ b/tests/ext4/703.out
@@ -0,0 +1,12 @@
+QA output created by 703
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
diff --git a/tests/ext4/704 b/tests/ext4/704
new file mode 100755
index 0000000..da94317
--- /dev/null
+++ b/tests/ext4/704
@@ -0,0 +1,102 @@
+#! /bin/bash
+# FS QA Test No. 704
+#
+# Create and populate an ext4 filesystem, corrupt an inode bitmap, then
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
+dumpe2fs -g "${SCRATCH_DEV}" > /dev/null 2>&1 || _notrun "dumpe2fs -g not supported"
+resize2fs -M "${SCRATCH_DEV}" >> $seqres.full 2>&1
+nr_groups="$(dumpe2fs -g "${SCRATCH_DEV}" 2> /dev/null | tail -n 1 | cut -d : -f 1)"
+
+echo "+ mount fs image"
+_scratch_mount
+
+echo "+ make some files"
+# abuse orlov allocator in the hopes that each bg ends up with some inodes
+for i in `seq 1 $((nr_groups * 8))`; do
+	mkdir -p "${SCRATCH_MNT}/d_${i}"
+done
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+echo "+ corrupt image"
+dumpe2fs -g "${SCRATCH_DEV}" 2>/dev/null | awk -F ':' '{if (int($6) > 0) {print $6}}' | while read blk; do
+	debugfs -w -n -R "zap_block ${blk}" "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "inode bitmap fuzz failed"
+done
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify files"
+touch "${SCRATCH_MNT}/file0" > /dev/null 2>&1 && _fail "touch should fail"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ modify files (2)"
+touch "${SCRATCH_MNT}/file1"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+status=0
+exit
diff --git a/tests/ext4/704.out b/tests/ext4/704.out
new file mode 100644
index 0000000..e1b0dbd
--- /dev/null
+++ b/tests/ext4/704.out
@@ -0,0 +1,12 @@
+QA output created by 704
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
diff --git a/tests/ext4/705 b/tests/ext4/705
new file mode 100755
index 0000000..11ff98f
--- /dev/null
+++ b/tests/ext4/705
@@ -0,0 +1,88 @@
+#! /bin/bash
+# FS QA Test No. 705
+#
+# Create and populate an ext4 filesystem, corrupt the MMP block, then
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
+_scratch_mkfs_ext4 -O mmp -E mmp_update_interval=2 > /dev/null 2>&1
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+
+echo "+ make some files"
+echo moo > "${SCRATCH_MNT}/file0"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+echo "+ corrupt image"
+blk="$(dumpe2fs "${SCRATCH_DEV}" 2> /dev/null | grep 'MMP block number' | sed -e 's/^MMP block number: *\([0-9]*\)$/\1/g')"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 $((blk * blksz + 16)) 8" "${SCRATCH_DEV}" >> $seqres.full
+
+echo "+ mount image"
+_scratch_mount 2> /dev/null && _fail "mount should fail due to bad MMP"
+
+echo "+ repair fs"
+e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount || _fail "mount should not fail; MMP has been fixed"
+
+echo "+ check fs (2)"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+status=0
+exit
diff --git a/tests/ext4/705.out b/tests/ext4/705.out
new file mode 100644
index 0000000..60c43ef
--- /dev/null
+++ b/tests/ext4/705.out
@@ -0,0 +1,10 @@
+QA output created by 705
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ corrupt image
++ mount image
++ repair fs
++ mount image (2)
++ check fs (2)
diff --git a/tests/ext4/706 b/tests/ext4/706
new file mode 100755
index 0000000..505be41
--- /dev/null
+++ b/tests/ext4/706
@@ -0,0 +1,87 @@
+#! /bin/bash
+# FS QA Test No. 706
+#
+# Create and populate an ext4 filesystem, corrupt the journal, then
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
+_scratch_mkfs_ext4 -O journal > /dev/null 2>&1
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+
+echo "+ make some files"
+echo moo > "${SCRATCH_MNT}/file0"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+echo "+ corrupt image"
+debugfs -w -R 'zap -f <8> 0' "${SCRATCH_DEV}" 2> /dev/null
+
+echo "+ mount image"
+_scratch_mount 2> /dev/null && _fail "mount should fail due to bad journal"
+
+echo "+ repair fs"
+e2fsck -fy "${SCRATCH_DEV}" >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount || _fail "mount should not fail; journal has been fixed"
+
+echo "+ check fs (2)"
+e2fsck -fn "${SCRATCH_DEV}" >> $seqres.full 2>&1 || _fail "fsck should not fail"
+
+status=0
+exit
diff --git a/tests/ext4/706.out b/tests/ext4/706.out
new file mode 100644
index 0000000..f919d45
--- /dev/null
+++ b/tests/ext4/706.out
@@ -0,0 +1,10 @@
+QA output created by 706
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ corrupt image
++ mount image
++ repair fs
++ mount image (2)
++ check fs (2)
diff --git a/tests/ext4/group b/tests/ext4/group
index dfadd91..d685076 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -18,3 +18,9 @@
 307 auto ioctl rw
 308 auto ioctl rw prealloc quick
 700 dangerous_fuzzers
+701 fuzzers
+702 fuzzers
+703 fuzzers
+704 fuzzers
+705 fuzzers
+706 fuzzers

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
