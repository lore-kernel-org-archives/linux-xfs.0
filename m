Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A9D907F82
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 20:52:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7C3578F8039
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 18:52:49 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id Xxzc8tDz9IlroNMt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Aug 2015 18:52:46 -0700 (PDT)
Subject: [PATCH 6/7] xfs: test directory metadata corruption checking and
	repair
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 14 Aug 2015 18:52:42 -0700
Message-ID: <20150815015242.4333.10512.stgit@birch.djwong.org>
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

Targeted fuzzing tests which destroy various pieces of directory
metadata; the tests look for (a) kernel detection of corruption, (b)
xfs_repair repair of said corruption, and (c) post-repair fs
usability.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/710     |  111 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/710.out |   14 ++++++
 tests/xfs/711     |  116 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/711.out |   14 ++++++
 tests/xfs/712     |  111 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/712.out |   14 ++++++
 tests/xfs/713     |  116 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/713.out |   14 ++++++
 tests/xfs/714     |  116 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/714.out |   14 ++++++
 tests/xfs/715     |  120 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/715.out |   14 ++++++
 tests/xfs/716     |  116 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/716.out |   14 ++++++
 tests/xfs/group   |    7 +++
 15 files changed, 911 insertions(+)
 create mode 100755 tests/xfs/710
 create mode 100644 tests/xfs/710.out
 create mode 100755 tests/xfs/711
 create mode 100644 tests/xfs/711.out
 create mode 100755 tests/xfs/712
 create mode 100644 tests/xfs/712.out
 create mode 100755 tests/xfs/713
 create mode 100644 tests/xfs/713.out
 create mode 100755 tests/xfs/714
 create mode 100644 tests/xfs/714.out
 create mode 100755 tests/xfs/715
 create mode 100644 tests/xfs/715.out
 create mode 100755 tests/xfs/716
 create mode 100644 tests/xfs/716.out


diff --git a/tests/xfs/710 b/tests/xfs/710
new file mode 100755
index 0000000..11c91fe
--- /dev/null
+++ b/tests/xfs/710
@@ -0,0 +1,111 @@
+#! /bin/bash
+# FS QA Test No. 710
+#
+# Create and populate an XFS filesystem, corrupt a block directory, then see
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
+dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+nr="$((dblksz / 40))"
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+leaf_lblk="$((32 * 1073741824 / blksz))"
+node_lblk="$((64 * 1073741824 / blksz))"
+
+echo "+ make some files"
+__populate_create_dir "${SCRATCH_MNT}/blockdir" "${nr}"
+inode="$(stat -c '%i' "${SCRATCH_MNT}/blockdir")"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ check dir"
+__populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" block
+
+echo "+ corrupt dir"
+$XFS_DB_PROG -x -c "inode ${inode}" -c 'dblock 0' -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify dir"
+rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
+mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
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
+echo "+ modify dir (2)"
+mkdir -p "${SCRATCH_MNT}/blockdir"
+rm -rf "${SCRATCH_MNT}/blockdir/00000000" || _fail "couldn't modify repaired directory"
+mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" || _fail "add to repaired directory"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/710.out b/tests/xfs/710.out
new file mode 100644
index 0000000..d8b5681
--- /dev/null
+++ b/tests/xfs/710.out
@@ -0,0 +1,14 @@
+QA output created by 710
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ check dir
++ corrupt dir
++ mount image
++ modify dir
++ repair fs
++ mount image (2)
++ chattr -R -i
++ modify dir (2)
++ check fs (2)
diff --git a/tests/xfs/711 b/tests/xfs/711
new file mode 100755
index 0000000..7efcccf
--- /dev/null
+++ b/tests/xfs/711
@@ -0,0 +1,116 @@
+#! /bin/bash
+# FS QA Test No. 711
+#
+# Create and populate an XFS filesystem, corrupt a leaf directory's data
+# extent, then see how the kernel and xfs_repair deal with it.
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
+dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+nr="$((dblksz / 12))"
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+leaf_lblk="$((32 * 1073741824 / blksz))"
+node_lblk="$((64 * 1073741824 / blksz))"
+
+echo "+ make some files"
+__populate_create_dir "${SCRATCH_MNT}/blockdir" "${nr}"
+inode="$(stat -c '%i' "${SCRATCH_MNT}/blockdir")"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ check dir"
+__populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" leaf
+
+echo "+ corrupt dir"
+loff=0
+while true; do
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file data block is unmapped' && break
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+	loff="$((loff + 1))"
+done
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify dir"
+rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
+mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
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
+echo "+ modify dir (2)"
+mkdir -p "${SCRATCH_MNT}/blockdir"
+rm -rf "${SCRATCH_MNT}/blockdir/00000000" || _fail "couldn't modify repaired directory"
+mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" || _fail "add to repaired directory"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/711.out b/tests/xfs/711.out
new file mode 100644
index 0000000..d8edca0
--- /dev/null
+++ b/tests/xfs/711.out
@@ -0,0 +1,14 @@
+QA output created by 711
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ check dir
++ corrupt dir
++ mount image
++ modify dir
++ repair fs
++ mount image (2)
++ chattr -R -i
++ modify dir (2)
++ check fs (2)
diff --git a/tests/xfs/712 b/tests/xfs/712
new file mode 100755
index 0000000..61b22d2
--- /dev/null
+++ b/tests/xfs/712
@@ -0,0 +1,111 @@
+#! /bin/bash
+# FS QA Test No. 712
+#
+# Create and populate an XFS filesystem, corrupt a leaf directory's leaf
+# extent, then see how the kernel and xfs_repair deal with it.
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
+dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+nr="$((dblksz / 12))"
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+leaf_lblk="$((32 * 1073741824 / blksz))"
+node_lblk="$((64 * 1073741824 / blksz))"
+
+echo "+ make some files"
+__populate_create_dir "${SCRATCH_MNT}/blockdir" "${nr}"
+inode="$(stat -c '%i' "${SCRATCH_MNT}/blockdir")"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ check dir"
+__populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" leaf
+
+echo "+ corrupt dir"
+$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${leaf_lblk}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify dir"
+rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
+mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
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
+echo "+ modify dir (2)"
+mkdir -p "${SCRATCH_MNT}/blockdir"
+rm -rf "${SCRATCH_MNT}/blockdir/00000000" || _fail "couldn't modify repaired directory"
+mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" || _fail "add to repaired directory"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/712.out b/tests/xfs/712.out
new file mode 100644
index 0000000..c1df4c8
--- /dev/null
+++ b/tests/xfs/712.out
@@ -0,0 +1,14 @@
+QA output created by 712
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ check dir
++ corrupt dir
++ mount image
++ modify dir
++ repair fs
++ mount image (2)
++ chattr -R -i
++ modify dir (2)
++ check fs (2)
diff --git a/tests/xfs/713 b/tests/xfs/713
new file mode 100755
index 0000000..4afeeac
--- /dev/null
+++ b/tests/xfs/713
@@ -0,0 +1,116 @@
+#! /bin/bash
+# FS QA Test No. 713
+#
+# Create and populate an XFS filesystem, corrupt a node directory's data
+# extent, then see how the kernel and xfs_repair deal with it.
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
+dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+nr="$((16 * dblksz / 40))"
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+leaf_lblk="$((32 * 1073741824 / blksz))"
+node_lblk="$((64 * 1073741824 / blksz))"
+
+echo "+ make some files"
+__populate_create_dir "${SCRATCH_MNT}/blockdir" "${nr}" true
+inode="$(stat -c '%i' "${SCRATCH_MNT}/blockdir")"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ check dir"
+__populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" node
+
+echo "+ corrupt dir"
+loff=0
+while true; do
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file data block is unmapped' && break
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+	loff="$((loff + 1))"
+done
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify dir"
+rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
+mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
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
+echo "+ modify dir (2)"
+mkdir -p "${SCRATCH_MNT}/blockdir"
+rm -rf "${SCRATCH_MNT}/blockdir/00000000" || _fail "couldn't modify repaired directory"
+mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" || _fail "add to repaired directory"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/713.out b/tests/xfs/713.out
new file mode 100644
index 0000000..22f1de1
--- /dev/null
+++ b/tests/xfs/713.out
@@ -0,0 +1,14 @@
+QA output created by 713
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ check dir
++ corrupt dir
++ mount image
++ modify dir
++ repair fs
++ mount image (2)
++ chattr -R -i
++ modify dir (2)
++ check fs (2)
diff --git a/tests/xfs/714 b/tests/xfs/714
new file mode 100755
index 0000000..488bb7c
--- /dev/null
+++ b/tests/xfs/714
@@ -0,0 +1,116 @@
+#! /bin/bash
+# FS QA Test No. 714
+#
+# Create and populate an XFS filesystem, corrupt a node directory's leaf
+# extent, then see how the kernel and xfs_repair deal with it.
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
+dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+nr="$((16 * dblksz / 40))"
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+leaf_lblk="$((32 * 1073741824 / blksz))"
+node_lblk="$((64 * 1073741824 / blksz))"
+
+echo "+ make some files"
+__populate_create_dir "${SCRATCH_MNT}/blockdir" "${nr}" true
+inode="$(stat -c '%i' "${SCRATCH_MNT}/blockdir")"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ check dir"
+__populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" node
+
+echo "+ corrupt dir"
+loff="${leaf_lblk}"
+while true; do
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file data block is unmapped' && break
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+	loff="$((loff + 1))"
+done
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify dir"
+rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
+mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
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
+echo "+ modify dir (2)"
+mkdir -p "${SCRATCH_MNT}/blockdir"
+rm -rf "${SCRATCH_MNT}/blockdir/00000000" || _fail "couldn't modify repaired directory"
+mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" || _fail "add to repaired directory"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/714.out b/tests/xfs/714.out
new file mode 100644
index 0000000..c280b7b
--- /dev/null
+++ b/tests/xfs/714.out
@@ -0,0 +1,14 @@
+QA output created by 714
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ check dir
++ corrupt dir
++ mount image
++ modify dir
++ repair fs
++ mount image (2)
++ chattr -R -i
++ modify dir (2)
++ check fs (2)
diff --git a/tests/xfs/715 b/tests/xfs/715
new file mode 100755
index 0000000..7121ca9
--- /dev/null
+++ b/tests/xfs/715
@@ -0,0 +1,120 @@
+#! /bin/bash
+# FS QA Test No. 715
+#
+# Create and populate an XFS filesystem, corrupt a node directory's freeindex
+# extent, then see how the kernel and xfs_repair deal with it.
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
+dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+nr="$((16 * dblksz / 40))"
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+leaf_lblk="$((32 * 1073741824 / blksz))"
+node_lblk="$((64 * 1073741824 / blksz))"
+
+echo "+ make some files"
+__populate_create_dir "${SCRATCH_MNT}/blockdir" "${nr}" true
+inode="$(stat -c '%i' "${SCRATCH_MNT}/blockdir")"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ check dir"
+__populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" node
+
+echo "+ corrupt dir"
+loff="${node_lblk}"
+while true; do
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file data block is unmapped' && break
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+	loff="$((loff + 1))"
+done
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify dir"
+rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
+mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
+umount "${SCRATCH_MNT}"
+
+echo "+ repair fs"
+_scratch_xfs_repair >> $seqres.full 2>&1
+if [ $? -eq 2 ]; then
+	_scratch_mount
+	umount "${SCRATCH_MNT}"
+	_scratch_xfs_repair >> $seqres.full 2>&1
+fi
+
+echo "+ mount image (2)"
+_scratch_mount
+
+echo "+ chattr -R -i"
+chattr -R -f -i "${SCRATCH_MNT}/"
+
+echo "+ modify dir (2)"
+mkdir -p "${SCRATCH_MNT}/blockdir"
+rm -rf "${SCRATCH_MNT}/blockdir/00000000" || _fail "couldn't modify repaired directory"
+mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" || _fail "add to repaired directory"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/715.out b/tests/xfs/715.out
new file mode 100644
index 0000000..c5b733a
--- /dev/null
+++ b/tests/xfs/715.out
@@ -0,0 +1,14 @@
+QA output created by 715
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ check dir
++ corrupt dir
++ mount image
++ modify dir
++ repair fs
++ mount image (2)
++ chattr -R -i
++ modify dir (2)
++ check fs (2)
diff --git a/tests/xfs/716 b/tests/xfs/716
new file mode 100755
index 0000000..7a309c5
--- /dev/null
+++ b/tests/xfs/716
@@ -0,0 +1,116 @@
+#! /bin/bash
+# FS QA Test No. 716
+#
+# Create and populate an XFS filesystem, corrupt a btree directory's data
+# extent, then see how the kernel and xfs_repair deal with it.
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
+dblksz="$(xfs_info "${SCRATCH_MNT}" | grep naming.*bsize | sed -e 's/^.*bsize=//g' -e 's/\([0-9]*\).*$/\1/g')"
+nr="$((128 * dblksz / 40))"
+blksz="$(stat -f -c '%s' "${SCRATCH_MNT}")"
+leaf_lblk="$((32 * 1073741824 / blksz))"
+node_lblk="$((64 * 1073741824 / blksz))"
+
+echo "+ make some files"
+__populate_create_dir "${SCRATCH_MNT}/blockdir" "${nr}" true
+inode="$(stat -c '%i' "${SCRATCH_MNT}/blockdir")"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+echo "+ check dir"
+__populate_check_xfs_dir "${SCRATCH_DEV}" "${inode}" btree
+
+echo "+ corrupt dir"
+loff=0
+while true; do
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" "${SCRATCH_DEV}" | grep -q 'file data block is unmapped' && break
+	$XFS_DB_PROG -x -c "inode ${inode}" -c "dblock ${loff}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full
+	loff="$((loff + 1))"
+done
+
+echo "+ mount image"
+_scratch_mount
+
+echo "+ modify dir"
+rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
+mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
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
+echo "+ modify dir (2)"
+mkdir -p "${SCRATCH_MNT}/blockdir"
+rm -rf "${SCRATCH_MNT}/blockdir/00000000" || _fail "couldn't modify repaired directory"
+mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" || _fail "add to repaired directory"
+umount "${SCRATCH_MNT}"
+
+echo "+ check fs (2)"
+_scratch_xfs_repair -n >> $seqres.full 2>&1 || _fail "xfs_repair should not fail"
+
+status=0
+exit
diff --git a/tests/xfs/716.out b/tests/xfs/716.out
new file mode 100644
index 0000000..36e3fca
--- /dev/null
+++ b/tests/xfs/716.out
@@ -0,0 +1,14 @@
+QA output created by 716
++ create scratch fs
++ mount fs image
++ make some files
++ check fs
++ check dir
++ corrupt dir
++ mount image
++ modify dir
++ repair fs
++ mount image (2)
++ chattr -R -i
++ modify dir (2)
++ check fs (2)
diff --git a/tests/xfs/group b/tests/xfs/group
index bdd0bb0..8e4f8b7 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -207,3 +207,10 @@
 707 fuzzers
 708 fuzzers
 709 fuzzers
+710 fuzzers
+711 fuzzers
+712 fuzzers
+713 fuzzers
+714 fuzzers
+715 fuzzers
+716 fuzzers

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
