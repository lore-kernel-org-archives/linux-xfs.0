Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8E4407F6F
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 20:52:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6F9198F8033
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 18:52:43 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id 4CRtwkEJhiAm1IDN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Aug 2015 18:52:39 -0700 (PDT)
Subject: [PATCH 5/7] xfs: test allocation group metadata corruption checking
	and repair
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 14 Aug 2015 18:52:35 -0700
Message-ID: <20150815015235.4333.4974.stgit@birch.djwong.org>
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
allocation group metadata; the tests look for (a) kernel detection of
corruption, (b) xfs_repair repair of said corruption, and (c)
post-repair fs usability.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/rc         |   11 ++++
 tests/xfs/701     |  115 +++++++++++++++++++++++++++++++++++++++++
 tests/xfs/701.out |   13 +++++
 tests/xfs/702     |  147 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/702.out |   20 +++++++
 tests/xfs/703     |  124 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/703.out |   15 +++++
 tests/xfs/704     |  146 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/704.out |   20 +++++++
 tests/xfs/705     |  147 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/705.out |   20 +++++++
 tests/xfs/706     |  147 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/706.out |   20 +++++++
 tests/xfs/707     |  124 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/707.out |   15 +++++
 tests/xfs/708     |  127 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/708.out |   15 +++++
 tests/xfs/709     |  118 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/709.out |   13 +++++
 tests/xfs/group   |    9 +++
 20 files changed, 1366 insertions(+)
 create mode 100755 tests/xfs/701
 create mode 100644 tests/xfs/701.out
 create mode 100755 tests/xfs/702
 create mode 100644 tests/xfs/702.out
 create mode 100755 tests/xfs/703
 create mode 100644 tests/xfs/703.out
 create mode 100755 tests/xfs/704
 create mode 100644 tests/xfs/704.out
 create mode 100755 tests/xfs/705
 create mode 100644 tests/xfs/705.out
 create mode 100755 tests/xfs/706
 create mode 100644 tests/xfs/706.out
 create mode 100755 tests/xfs/707
 create mode 100644 tests/xfs/707.out
 create mode 100755 tests/xfs/708
 create mode 100644 tests/xfs/708.out
 create mode 100755 tests/xfs/709
 create mode 100644 tests/xfs/709.out


diff --git a/common/rc b/common/rc
index f889103..1e7e47b 100644
--- a/common/rc
+++ b/common/rc
@@ -1409,6 +1409,17 @@ _require_scratch_ext4_crc()
 	umount $SCRATCH_MNT
 }
 
+# this test requires the xfs kernel support crc feature on scratch device
+#
+_require_scratch_xfs_crc()
+{
+	_scratch_mkfs_xfs >/dev/null 2>&1
+	_scratch_mount >/dev/null 2>&1 \
+	   || _notrun "Kernel doesn't support crc feature"
+	xfs_info $SCRATCH_MNT | grep -q 'crc=1' || _notrun "crc feature not supported by this filesystem"
+	umount $SCRATCH_MNT
+}
+
 # this test requires the bigalloc feature to be available in mkfs.ext4
 #
 _require_ext4_mkfs_bigalloc()
diff --git a/tests/xfs/701 b/tests/xfs/701
new file mode 100755
index 0000000..00f2a46
--- /dev/null
+++ b/tests/xfs/701
@@ -0,0 +1,115 @@
+#! /bin/bash
+# FS QA Test No. 701
+#
+# Create and populate an XFS filesystem, corrupt a superblock, then see how
+# the kernel and xfs_repair deal with it.
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
+. ./common/populate
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
+_require_attrs
+_require_xfs_db_blocktrash_z_command
+
+rm -f $seqres.full
+TESTDIR="${SCRATCH_MNT}/scratchdir"
+TESTFILE="${TESTDIR}/testfile"
+
+echo "+ create scratch fs"
+_scratch_mkfs_xfs > /dev/null
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
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
+agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ corrupt image"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 32 4" "${SCRATCH_DEV}" >> $seqres.full
+
+echo "+ mount image"
+_scratch_mount 2>/dev/null && _fail "mount should not succeed"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
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
+	echo moo | dd oflag=append conv=notrunc of="${TESTFILE}.${x}" 2>/dev/null
+	test $? -ne 0 && broken=1
+done
+echo "broken: ${broken}"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/701.out b/tests/xfs/701.out
new file mode 100644
index 0000000..a44edb2
--- /dev/null
+++ b/tests/xfs/701.out
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
diff --git a/tests/xfs/702 b/tests/xfs/702
new file mode 100755
index 0000000..1cbc3e9
--- /dev/null
+++ b/tests/xfs/702
@@ -0,0 +1,147 @@
+#! /bin/bash
+# FS QA Test No. 702
+#
+# Create and populate an XFS filesystem, corrupt an AGF, then see how
+# the kernel and xfs_repair deal with it.
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
+. ./common/populate
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
+_require_attrs
+_require_xfs_db_blocktrash_z_command
+test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
+
+rm -f $seqres.full
+TESTDIR="${SCRATCH_MNT}/scratchdir"
+TESTFILE="${TESTDIR}/testfile"
+
+echo "+ create scratch fs"
+_scratch_mkfs_xfs > /dev/null
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
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
+agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+test "${agcount}" -gt 1 || _notrun "Single-AG XFS not supported"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ corrupt image"
+for ag in $(seq 1 $((agcount - 1))) 0; do
+	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "stack" -c "blocktrash -x 32 -o +64 -y 4096 -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+done
+
+# Try to append to files; this should fail
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify files"
+for x in `seq 1 64`; do
+	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
+done
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ check files"
+broken=0
+for x in `seq 1 64`; do
+	test -s "${TESTFILE}.${x}" || broken=1
+done
+echo "broken: ${broken}"
+
+# Try appending again, now that we've fixed the fs
+echo "+ modify files (2)"
+for x in `seq 1 64`; do
+	$XFS_IO_PROG -f -c "pwrite -S 0x62 ${blksz} ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
+done
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ check files (2)"
+broken=0
+for x in `seq 1 64`; do
+	test -s "${TESTFILE}.${x}" || broken=1
+done
+echo "broken: ${broken}"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/702.out b/tests/xfs/702.out
new file mode 100644
index 0000000..e44c454
--- /dev/null
+++ b/tests/xfs/702.out
@@ -0,0 +1,20 @@
+QA output created by 702
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ corrupt image
++ mount image
++ modify files
++ repair fs
++ mount image
++ chattr -R -i
++ check files
+broken: 1
++ modify files (2)
++ repair fs
++ mount image
++ chattr -R -i
++ check files (2)
+broken: 0
++ check fs (2)
diff --git a/tests/xfs/703 b/tests/xfs/703
new file mode 100755
index 0000000..459d80b
--- /dev/null
+++ b/tests/xfs/703
@@ -0,0 +1,124 @@
+#! /bin/bash
+# FS QA Test No. 703
+#
+# Create and populate an XFS filesystem, corrupt the AGI, then see how
+# the kernel and xfs_repair deal with it.
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
+. ./common/populate
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
+_require_attrs
+_require_xfs_db_blocktrash_z_command
+test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
+
+rm -f $seqres.full
+TESTDIR="${SCRATCH_MNT}/scratchdir"
+TESTFILE="${TESTDIR}/testfile"
+
+echo "+ create scratch fs"
+_scratch_mkfs_xfs > /dev/null
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
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
+agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ corrupt image"
+for ag in $(seq 1 $((agcount - 1))) 0; do
+	$XFS_DB_PROG -x -c "agi ${ag}" -c "agi ${ag}" -c "stack" -c "blocktrash -x 32 -o +64 -y 4096 -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+done
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify files"
+broken=0
+for x in `seq 65 70`; do
+	touch "${TESTFILE}.${x}" 2> /dev/null || broken=1
+done
+echo "broken: ${broken}"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ modify files (2)"
+broken=0
+for x in `seq 65 70`; do
+	touch "${TESTFILE}.${x}" || broken=1
+done
+echo "broken: ${broken}"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/703.out b/tests/xfs/703.out
new file mode 100644
index 0000000..76ba47c
--- /dev/null
+++ b/tests/xfs/703.out
@@ -0,0 +1,15 @@
+QA output created by 703
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
diff --git a/tests/xfs/704 b/tests/xfs/704
new file mode 100755
index 0000000..9370463
--- /dev/null
+++ b/tests/xfs/704
@@ -0,0 +1,146 @@
+#! /bin/bash
+# FS QA Test No. 704
+#
+# Create and populate an XFS filesystem, corrupt the AGFL, then see how
+# the kernel and xfs_repair deal with it.
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
+. ./common/populate
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
+_require_attrs
+_require_xfs_db_blocktrash_z_command
+test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
+
+rm -f $seqres.full
+TESTDIR="${SCRATCH_MNT}/scratchdir"
+TESTFILE="${TESTDIR}/testfile"
+
+echo "+ create scratch fs"
+_scratch_mkfs_xfs > /dev/null
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
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
+agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ corrupt image"
+for ag in $(seq 1 $((agcount - 1))) 0; do
+	$XFS_DB_PROG -x -c "agfl ${ag}" -c "agfl ${ag}" -c "stack" -c "blocktrash -x 32 -o +64 -y 4096 -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+done
+
+# Try to append to files; this should fail
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify files"
+for x in `seq 1 64`; do
+	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
+done
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ check files"
+broken=0
+for x in `seq 1 64`; do
+	test -s "${TESTFILE}.${x}" || broken=1
+done
+echo "broken: ${broken}"
+
+# Try appending again, now that we've fixed the fs
+echo "+ modify files (2)"
+for x in `seq 1 64`; do
+	$XFS_IO_PROG -f -c "pwrite -S 0x62 ${blksz} ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
+done
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ check files (2)"
+broken=0
+for x in `seq 1 64`; do
+	test -s "${TESTFILE}.${x}" || broken=1
+done
+echo "broken: ${broken}"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/704.out b/tests/xfs/704.out
new file mode 100644
index 0000000..14871e5
--- /dev/null
+++ b/tests/xfs/704.out
@@ -0,0 +1,20 @@
+QA output created by 704
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ corrupt image
++ mount image
++ modify files
++ repair fs
++ mount image
++ chattr -R -i
++ check files
+broken: 1
++ modify files (2)
++ repair fs
++ mount image
++ chattr -R -i
++ check files (2)
+broken: 0
++ check fs (2)
diff --git a/tests/xfs/705 b/tests/xfs/705
new file mode 100755
index 0000000..b5c3eb0
--- /dev/null
+++ b/tests/xfs/705
@@ -0,0 +1,147 @@
+#! /bin/bash
+# FS QA Test No. 705
+#
+# Create and populate an XFS filesystem, corrupt the bnobt, then see how
+# the kernel and xfs_repair deal with it.
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
+. ./common/populate
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
+_require_attrs
+_require_xfs_db_blocktrash_z_command
+test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
+
+rm -f $seqres.full
+TESTDIR="${SCRATCH_MNT}/scratchdir"
+TESTFILE="${TESTDIR}/testfile"
+
+echo "+ create scratch fs"
+_scratch_mkfs_xfs > /dev/null
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
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
+agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ corrupt image"
+for ag in $(seq 1 $((agcount - 1))) 0; do
+	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "addr bnoroot" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+done
+
+# Try to append to files; this should fail
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify files"
+for x in `seq 1 64`; do
+	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
+done
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ check files"
+ls -la "${TESTDIR}" >> $seqres.full
+broken=0
+for x in `seq 1 64`; do
+	test -s "${TESTFILE}.${x}" || broken=1
+done
+echo "broken: ${broken}"
+
+# Try appending again, now that we've fixed the fs
+echo "+ modify files (2)"
+for x in `seq 1 64`; do
+	$XFS_IO_PROG -f -c "pwrite -S 0x62 ${blksz} ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
+done
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ check files (2)"
+broken=0
+for x in `seq 1 64`; do
+	test -s "${TESTFILE}.${x}" || broken=1
+done
+echo "broken: ${broken}"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/705.out b/tests/xfs/705.out
new file mode 100644
index 0000000..4288234
--- /dev/null
+++ b/tests/xfs/705.out
@@ -0,0 +1,20 @@
+QA output created by 705
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ corrupt image
++ mount image
++ modify files
++ repair fs
++ mount image
++ chattr -R -i
++ check files
+broken: 1
++ modify files (2)
++ repair fs
++ mount image
++ chattr -R -i
++ check files (2)
+broken: 0
++ check fs (2)
diff --git a/tests/xfs/706 b/tests/xfs/706
new file mode 100755
index 0000000..1aa2d57
--- /dev/null
+++ b/tests/xfs/706
@@ -0,0 +1,147 @@
+#! /bin/bash
+# FS QA Test No. 706
+#
+# Create and populate an XFS filesystem, corrupt the cntbt, then see how
+# the kernel and xfs_repair deal with it.
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
+. ./common/populate
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
+_require_attrs
+_require_xfs_db_blocktrash_z_command
+test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
+
+rm -f $seqres.full
+TESTDIR="${SCRATCH_MNT}/scratchdir"
+TESTFILE="${TESTDIR}/testfile"
+
+echo "+ create scratch fs"
+_scratch_mkfs_xfs > /dev/null
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
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
+agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ corrupt image"
+for ag in $(seq 1 $((agcount - 1))) 0; do
+	$XFS_DB_PROG -x -c "agf ${ag}" -c "agf ${ag}" -c "addr cntroot" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+done
+
+# Try to append to files; this should fail
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify files"
+for x in `seq 1 64`; do
+	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
+done
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ check files"
+ls -la "${TESTDIR}" >> $seqres.full
+broken=0
+for x in `seq 1 64`; do
+	test -s "${TESTFILE}.${x}" || broken=1
+done
+echo "broken: ${broken}"
+
+# Try appending again, now that we've fixed the fs
+echo "+ modify files (2)"
+for x in `seq 1 64`; do
+	$XFS_IO_PROG -f -c "pwrite -S 0x62 ${blksz} ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
+done
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ check files (2)"
+broken=0
+for x in `seq 1 64`; do
+	test -s "${TESTFILE}.${x}" || broken=1
+done
+echo "broken: ${broken}"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/706.out b/tests/xfs/706.out
new file mode 100644
index 0000000..0051a92
--- /dev/null
+++ b/tests/xfs/706.out
@@ -0,0 +1,20 @@
+QA output created by 706
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ corrupt image
++ mount image
++ modify files
++ repair fs
++ mount image
++ chattr -R -i
++ check files
+broken: 1
++ modify files (2)
++ repair fs
++ mount image
++ chattr -R -i
++ check files (2)
+broken: 0
++ check fs (2)
diff --git a/tests/xfs/707 b/tests/xfs/707
new file mode 100755
index 0000000..1107714
--- /dev/null
+++ b/tests/xfs/707
@@ -0,0 +1,124 @@
+#! /bin/bash
+# FS QA Test No. 707
+#
+# Create and populate an XFS filesystem, corrupt the inobt, then see how
+# the kernel and xfs_repair deal with it.
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
+. ./common/populate
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
+_require_attrs
+_require_xfs_db_blocktrash_z_command
+test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
+
+rm -f $seqres.full
+TESTDIR="${SCRATCH_MNT}/scratchdir"
+TESTFILE="${TESTDIR}/testfile"
+
+echo "+ create scratch fs"
+_scratch_mkfs_xfs > /dev/null
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
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
+agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ corrupt image"
+for ag in $(seq 1 $((agcount - 1))) 0; do
+	$XFS_DB_PROG -x -c "agi ${ag}" -c "agi ${ag}" -c "addr root" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+done
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify files"
+broken=0
+for x in `seq 65 70`; do
+	touch "${TESTFILE}.${x}" 2> /dev/null || broken=1
+done
+echo "broken: ${broken}"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ modify files (2)"
+broken=0
+for x in `seq 65 70`; do
+	touch "${TESTFILE}.${x}" || broken=1
+done
+echo "broken: ${broken}"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/707.out b/tests/xfs/707.out
new file mode 100644
index 0000000..4cbeaf9
--- /dev/null
+++ b/tests/xfs/707.out
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
diff --git a/tests/xfs/708 b/tests/xfs/708
new file mode 100755
index 0000000..a9a3710
--- /dev/null
+++ b/tests/xfs/708
@@ -0,0 +1,127 @@
+#! /bin/bash
+# FS QA Test No. 708
+#
+# Create and populate an XFS filesystem, corrupt the finobt, then see how
+# the kernel and xfs_repair deal with it.
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
+. ./common/populate
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+_require_xfs_mkfs_finobt
+_require_xfs_finobt
+test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
+_require_attrs
+_require_xfs_db_blocktrash_z_command
+test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
+
+rm -f $seqres.full
+TESTDIR="${SCRATCH_MNT}/scratchdir"
+TESTFILE="${TESTDIR}/testfile"
+
+echo "+ create scratch fs"
+_scratch_mkfs_xfs > /dev/null
+
+echo "+ mount fs image"
+_scratch_mount
+xfs_info "${SCRATCH_MNT}" | grep -q "finobt=1" || _notrun "finobt not enabled"
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
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
+agcount="$(xfs_info "${SCRATCH_MNT}" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g')"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ corrupt image"
+for ag in $(seq 1 $((agcount - 1))) 0; do
+	$XFS_DB_PROG -x -c "agi ${ag}" -c "agi ${ag}" -c "addr free_root" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+done
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify files"
+broken=0
+for x in `seq 65 70`; do
+	touch "${TESTFILE}.${x}" 2> /dev/null || broken=1
+done
+echo "broken: ${broken}"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ modify files (2)"
+broken=0
+for x in `seq 65 70`; do
+	touch "${TESTFILE}.${x}" || broken=1
+done
+echo "broken: ${broken}"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/708.out b/tests/xfs/708.out
new file mode 100644
index 0000000..0eb44c0
--- /dev/null
+++ b/tests/xfs/708.out
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
diff --git a/tests/xfs/709 b/tests/xfs/709
new file mode 100755
index 0000000..33192f8
--- /dev/null
+++ b/tests/xfs/709
@@ -0,0 +1,118 @@
+#! /bin/bash
+# FS QA Test No. 709
+#
+# Create and populate an XFS filesystem, corrupt the journal, then see how
+# the kernel and xfs_repair deal with it.
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
+. ./common/populate
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_require_scratch
+test -n "${FORCE_FUZZ}" || _require_scratch_xfs_crc
+_require_attrs
+_require_xfs_db_blocktrash_z_command
+test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-n 8 -3"
+
+rm -f $seqres.full
+TESTDIR="${SCRATCH_MNT}/scratchdir"
+TESTFILE="${TESTDIR}/testfile"
+
+echo "+ create scratch fs"
+_scratch_mkfs_xfs > /dev/null
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
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
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ corrupt image"
+logstart="$($XFS_DB_PROG -c 'sb 0' -c 'p' "${SCRATCH_DEV}" | grep '^logstart =' | cut -d ' ' -f 3)"
+logstart="$($XFS_DB_PROG -c "convert fsblock ${logstart} byte" "${SCRATCH_DEV}" | sed -e 's/^.*(\([0-9]*\).*$/\1/g')"
+logblocks="$(xfs_db -c 'sb 0' -c 'p' "${SCRATCH_DEV}" | grep '^logblocks =' | cut -d ' ' -f 3)"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 ${logstart} $((logblocks * blksz))" "${SCRATCH_DEV}" >> $seqres.full
+
+echo "+ mount image"
+_scratch_mount 2>/dev/null && _fail "mount should not succeed"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
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
+	echo moo | dd oflag=append conv=notrunc of="${TESTFILE}.${x}" 2>/dev/null
+	test $? -ne 0 && broken=1
+done
+echo "broken: ${broken}"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/709.out b/tests/xfs/709.out
new file mode 100644
index 0000000..6badb94
--- /dev/null
+++ b/tests/xfs/709.out
@@ -0,0 +1,13 @@
+QA output created by 709
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
diff --git a/tests/xfs/group b/tests/xfs/group
index 140df27..bdd0bb0 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -198,3 +198,12 @@
 304 auto quick quota
 305 auto quota
 700 dangerous_fuzzers
+701 fuzzers
+702 fuzzers
+703 fuzzers
+704 fuzzers
+705 fuzzers
+706 fuzzers
+707 fuzzers
+708 fuzzers
+709 fuzzers

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
