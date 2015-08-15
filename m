Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C31A37F51
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 20:52:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5EF40304039
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 18:52:57 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Zs22QMRL4MsMfyiE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Aug 2015 18:52:54 -0700 (PDT)
Subject: [PATCH 7/7] xfs: test file/symlink metadata corruption checking and
	repair
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 14 Aug 2015 18:52:49 -0700
Message-ID: <20150815015249.4333.56792.stgit@birch.djwong.org>
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

Targeted fuzzing tests which destroy various pieces of file and
symlink metadata; the tests look for (a) kernel detection of
corruption, (b) xfs_repair repair of said corruption, and (c)
post-repair fs usability.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/717     |  132 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/717.out |   15 ++++++
 tests/xfs/718     |  111 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/718.out |   13 +++++
 tests/xfs/719     |   96 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/719.out |   11 ++++
 tests/xfs/720     |  114 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/720.out |   14 ++++++
 tests/xfs/721     |  114 ++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/721.out |   14 ++++++
 tests/xfs/722     |  118 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/722.out |   14 ++++++
 tests/xfs/group   |    6 ++
 13 files changed, 772 insertions(+)
 create mode 100755 tests/xfs/717
 create mode 100644 tests/xfs/717.out
 create mode 100755 tests/xfs/718
 create mode 100644 tests/xfs/718.out
 create mode 100755 tests/xfs/719
 create mode 100644 tests/xfs/719.out
 create mode 100755 tests/xfs/720
 create mode 100644 tests/xfs/720.out
 create mode 100755 tests/xfs/721
 create mode 100644 tests/xfs/721.out
 create mode 100755 tests/xfs/722
 create mode 100644 tests/xfs/722.out


diff --git a/tests/xfs/717 b/tests/xfs/717
new file mode 100755
index 0000000..ffc0c4e
--- /dev/null
+++ b/tests/xfs/717
@@ -0,0 +1,132 @@
+#! /bin/bash
+# FS QA Test No. 717
+#
+# Create and populate an XFS filesystem, corrupt an inode, then see how
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
+seq "${inode}" "$((inode + 64))" | while read ino; do
+	$XFS_DB_PROG -x -c "inode ${ino}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+done
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify files"
+broken=0
+for x in `seq 1 64`; do
+	stat "${TESTFILE}.${x}" >> $seqres.full 2>&1
+	test $? -ne 0 && broken=1
+	touch "${TESTFILE}.${x}" >> $seqres.full 2>&1
+	test $? -ne 0 && broken=1
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
+for x in `seq 1 64`; do
+	test -e "${TESTFILE}.${x}" || continue
+	echo "test ${x}" >> $seqres.full
+	stat "${TESTFILE}.${x}" >> $seqres.full 2>&1
+	test $? -ne 0 && broken=1
+	touch "${TESTFILE}.${x}" >> $seqres.full 2>&1
+	test $? -ne 0 && broken=1
+	echo "${x}: broken=${broken}" >> $seqres.full
+done
+echo "broken: ${broken}"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/717.out b/tests/xfs/717.out
new file mode 100644
index 0000000..6446bb7
--- /dev/null
+++ b/tests/xfs/717.out
@@ -0,0 +1,15 @@
+QA output created by 717
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
diff --git a/tests/xfs/718 b/tests/xfs/718
new file mode 100755
index 0000000..99519d2
--- /dev/null
+++ b/tests/xfs/718
@@ -0,0 +1,111 @@
+#! /bin/bash
+# FS QA Test No. 718
+#
+# Create and populate an XFS filesystem, corrupt the bmbt, then see how
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
+
+echo "+ create scratch fs"
+_scratch_mkfs_xfs > /dev/null
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+nr="$((blksz * 2 / 16))"
+
+echo "+ make some files"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 0 $((blksz * nr))" -c 'fsync' "${SCRATCH_MNT}/bigfile" >> $seqres.full
+for i in $(seq 1 2 ${nr}); do
+	$XFS_IO_PROG -f -c "fpunch $((i * blksz)) ${blksz}" "${SCRATCH_MNT}/bigfile" >> $seqres.full
+done
+inode="$(stat -c '%i' "${SCRATCH_MNT}/bigfile")"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ corrupt image"
+$XFS_DB_PROG -x -c "inode ${inode}" -c "addr u.bmbt.ptrs[1]" -c "addr u3.bmbt.ptrs[1]" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify files"
+before="$(stat -c '%b' "${SCRATCH_MNT}/bigfile")"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 ${blksz} ${blksz}" -c 'fsync' "${SCRATCH_MNT}/bigfile" >> $seqres.full 2> /dev/null
+after="$(stat -c '%b' "${SCRATCH_MNT}/bigfile")"
+test "${before}" -eq "${after}" || _fail "pwrite should fail on corrupt bmbt"
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
+touch "${SCRATCH_MNT}/bigfile"
+before="$(stat -c '%b' "${SCRATCH_MNT}/bigfile")"
+$XFS_IO_PROG -f -c "pwrite -S 0x62 ${blksz} ${blksz}" -c 'fsync' "${SCRATCH_MNT}/bigfile" >> $seqres.full 2> /dev/null
+after="$(stat -c '%b' "${SCRATCH_MNT}/bigfile")"
+test "${before}" -ne "${after}" || _fail "pwrite failed after fixing corrupt bmbt"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/718.out b/tests/xfs/718.out
new file mode 100644
index 0000000..0b53f4d
--- /dev/null
+++ b/tests/xfs/718.out
@@ -0,0 +1,13 @@
+QA output created by 718
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ corrupt image
++ mount image
++ modify files
++ repair fs
++ mount image (2)
++ chattr -R -i
++ modify files (2)
++ check fs (2)
diff --git a/tests/xfs/719 b/tests/xfs/719
new file mode 100755
index 0000000..459889e
--- /dev/null
+++ b/tests/xfs/719
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. 719
+#
+# Create and populate an XFS filesystem, corrupt a long symlink, then see how
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
+
+echo "+ create scratch fs"
+_scratch_mkfs_xfs > /dev/null
+
+echo "+ mount fs image"
+_scratch_mount
+blksz=1000
+
+echo "+ make some files"
+echo "file contents: moo" > "${SCRATCH_MNT}/x"
+str="$(perl -e "print './' x $(( (blksz / 2) - 16));")x"
+(cd $SCRATCH_MNT; ln -s "${str}" "long_symlink")
+cat "${SCRATCH_MNT}/long_symlink"
+inode="$(stat -c '%i' "${SCRATCH_MNT}/long_symlink")"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ corrupt image"
+$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock 0" -c "stack" -c "blocktrash -x 32 -o 256 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+
+echo "+ mount image"
+_scratch_mount
+cat "${SCRATCH_MNT}/long_symlink" 2>/dev/null && _fail "symlink should be broken"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+cat "${SCRATCH_MNT}/long_symlink" 2>/dev/null && _fail "symlink should be broken"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/719.out b/tests/xfs/719.out
new file mode 100644
index 0000000..bb64ddd
--- /dev/null
+++ b/tests/xfs/719.out
@@ -0,0 +1,11 @@
+QA output created by 719
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
diff --git a/tests/xfs/720 b/tests/xfs/720
new file mode 100755
index 0000000..ad4cad3
--- /dev/null
+++ b/tests/xfs/720
@@ -0,0 +1,114 @@
+#! /bin/bash
+# FS QA Test No. 720
+#
+# Create and populate an XFS filesystem, corrupt a block xattr, then see
+# how the kernel and xfs_repair deal with it.
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
+
+echo "+ create scratch fs"
+_scratch_mkfs_xfs > /dev/null
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+nr="$((blksz / 40))"
+leaf_lblk="$((32 * 1073741824 / blksz))"
+node_lblk="$((64 * 1073741824 / blksz))"
+
+echo "+ make some files"
+touch "${SCRATCH_MNT}/attrfile"
+seq 0 "${nr}" | while read d; do
+	setfattr -n "user.x$(printf "%.08d" "$d")" -v "0000000000000000" "${SCRATCH_MNT}/attrfile"
+done
+inode="$(stat -c '%i' "${SCRATCH_MNT}/attrfile")"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ check xattr"
+$XFS_DB_PROG -x -c "inode ${inode}" -c "bmap" "${SCRATCH_DEV}" >> $seqres.full
+$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 0" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' && _fail "failed to create a block xattr (data)"
+$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock ${leaf_lblk}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' || _fail "failed to create a block xattr (leaf)"
+$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock ${node_lblk}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' || _fail "failed to create a block xattr (free)"
+
+echo "+ corrupt xattr"
+$XFS_DB_PROG -x -c "inode ${inode}" -c 'ablock 0' -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify xattr"
+setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" 2> /dev/null && _fail "modified corrupt xattr"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ modify xattr (2)"
+getfattr "${SCRATCH_MNT}/attrfile" -n "user.x00000000" > /dev/null 2>&1 && (setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" || _fail "remove corrupt xattr")
+setfattr -n "user.x00000000" -v 'x0x0x0x0' "${SCRATCH_MNT}/attrfile" || _fail "add corrupt xattr"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/720.out b/tests/xfs/720.out
new file mode 100644
index 0000000..4110f66
--- /dev/null
+++ b/tests/xfs/720.out
@@ -0,0 +1,14 @@
+QA output created by 720
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ check xattr
++ corrupt xattr
++ mount image
++ modify xattr
++ repair fs
++ mount image (2)
++ chattr -R -i
++ modify xattr (2)
++ check fs (2)
diff --git a/tests/xfs/721 b/tests/xfs/721
new file mode 100755
index 0000000..ec87139
--- /dev/null
+++ b/tests/xfs/721
@@ -0,0 +1,114 @@
+#! /bin/bash
+# FS QA Test No. 721
+#
+# Create and populate an XFS filesystem, corrupt a leaf xattr's index extent,
+# then see how the kernel and xfs_repair deal with it.
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
+
+echo "+ create scratch fs"
+_scratch_mkfs_xfs > /dev/null
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+nr="$((8 * blksz / 40))"
+
+echo "+ make some files"
+touch "${SCRATCH_MNT}/attrfile"
+seq 0 "${nr}" | while read d; do
+	setfattr -n "user.x$(printf "%.08d" "$d")" -v "0000000000000000" "${SCRATCH_MNT}/attrfile"
+done
+seq 1 2 "${nr}" | while read d; do
+	setfattr -x "user.x$(printf "%.08d" "$d")" "${SCRATCH_MNT}/attrfile"
+done
+inode="$(stat -c '%i' "${SCRATCH_MNT}/attrfile")"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ check xattr"
+$XFS_DB_PROG -x -c "inode ${inode}" -c "bmap" "${SCRATCH_DEV}" >> $seqres.full
+$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 0" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (index)"
+$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 1" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (data)"
+
+echo "+ corrupt xattr"
+$XFS_DB_PROG -x -c "inode ${inode}" -c 'ablock 0' -c "stack" -c "blocktrash -x 32 -o +32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify xattr"
+setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" 2> /dev/null && _fail "modified corrupt xattr"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ modify xattr (2)"
+setfattr -n "user.x00000000" -v "1111111111111111" "${SCRATCH_MNT}/attrfile" || _fail "modified corrupt xattr"
+setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" || _fail "delete corrupt xattr"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/721.out b/tests/xfs/721.out
new file mode 100644
index 0000000..2098e75
--- /dev/null
+++ b/tests/xfs/721.out
@@ -0,0 +1,14 @@
+QA output created by 721
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ check xattr
++ corrupt xattr
++ mount image
++ modify xattr
++ repair fs
++ mount image (2)
++ chattr -R -i
++ modify xattr (2)
++ check fs (2)
diff --git a/tests/xfs/722 b/tests/xfs/722
new file mode 100755
index 0000000..f2d7192
--- /dev/null
+++ b/tests/xfs/722
@@ -0,0 +1,118 @@
+#! /bin/bash
+# FS QA Test No. 722
+#
+# Create and populate an XFS filesystem, corrupt a leaf xattr's data extent,
+# then see how the kernel and xfs_repair deal with it.
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
+
+echo "+ create scratch fs"
+_scratch_mkfs_xfs > /dev/null
+
+echo "+ mount fs image"
+_scratch_mount
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+nr="$((8 * blksz / 40))"
+
+echo "+ make some files"
+touch "${SCRATCH_MNT}/attrfile"
+seq 0 "${nr}" | while read d; do
+	setfattr -n "user.x$(printf "%.08d" "$d")" -v "0000000000000000" "${SCRATCH_MNT}/attrfile"
+done
+seq 1 2 "${nr}" | while read d; do
+	setfattr -x "user.x$(printf "%.08d" "$d")" "${SCRATCH_MNT}/attrfile"
+done
+inode="$(stat -c '%i' "${SCRATCH_MNT}/attrfile")"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ check xattr"
+$XFS_DB_PROG -x -c "inode ${inode}" -c "bmap" "${SCRATCH_DEV}" >> $seqres.full
+$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 0" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (index)"
+$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock 1" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' && _fail "failed to create a leaf xattr (data)"
+
+echo "+ corrupt xattr"
+loff=1
+while true; do
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file attr block is unmapped' && break
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "ablock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+	loff="$((loff + 1))"
+done
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify xattr"
+setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" 2> /dev/null && _fail "modified corrupt xattr"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ modify xattr (2)"
+getfattr "${SCRATCH_MNT}/attrfile" -n "user.x00000000" 2> /dev/null && (setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" || _fail "modified corrupt xattr")
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/722.out b/tests/xfs/722.out
new file mode 100644
index 0000000..d482a60
--- /dev/null
+++ b/tests/xfs/722.out
@@ -0,0 +1,14 @@
+QA output created by 722
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ check xattr
++ corrupt xattr
++ mount image
++ modify xattr
++ repair fs
++ mount image (2)
++ chattr -R -i
++ modify xattr (2)
++ check fs (2)
diff --git a/tests/xfs/group b/tests/xfs/group
index 8e4f8b7..1510251 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -214,3 +214,9 @@
 714 fuzzers
 715 fuzzers
 716 fuzzers
+717 fuzzers
+718 fuzzers
+719 fuzzers
+720 fuzzers
+721 fuzzers
+722 fuzzers

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
