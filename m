Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 72A217F60
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 20:52:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 41B87304039
	for <xfs@oss.sgi.com>; Fri, 14 Aug 2015 18:52:22 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id R1bb3VeW0q3B7D43 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 14 Aug 2015 18:52:20 -0700 (PDT)
Subject: [PATCH 2/7] randomly fuzz XFS and ext4 filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 14 Aug 2015 18:52:14 -0700
Message-ID: <20150815015214.4333.91129.stgit@birch.djwong.org>
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

Introduce tests for XFS and ext4 which format a filesystem, populate
it, then uses blocktrash and e2fuzz to corrupt the metadata.  The FS
is remounted, modified, and unmounted.  Following that, xfs_repair or
e2fsck are run until it no longer finds errors to correct, after which
the FS is mounted yet again and exercised to see if there are any
errors remaining.

The XFS test requires an xfs_db that can handle blocktrash and v5
filesystems.

The ext4 test requires metadata_csum support in e2fsprogs.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/ext4/700     |  161 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/700.out |    3 +
 tests/ext4/group   |    1 
 tests/xfs/700      |  174 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/700.out  |    3 +
 tests/xfs/group    |    1 
 6 files changed, 343 insertions(+)
 create mode 100755 tests/ext4/700
 create mode 100644 tests/ext4/700.out
 create mode 100755 tests/xfs/700
 create mode 100644 tests/xfs/700.out


diff --git a/tests/ext4/700 b/tests/ext4/700
new file mode 100755
index 0000000..ef68d75
--- /dev/null
+++ b/tests/ext4/700
@@ -0,0 +1,161 @@
+#! /bin/bash
+# FS QA Test No. 700
+#
+# Create and populate an ext4 filesystem, fuzz the metadata, then see how
+# the kernel reacts, how e2fsck fares in fixing the mess, and then
+# try more kernel accesses to see if it really fixed things.
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
+if [ ! -x "$(which e2fuzz)" ]; then
+	_notrun "Couldn't find e2fuzz"
+fi
+
+# real QA test starts here
+_supported_fs ext4
+_supported_os Linux
+
+_require_scratch
+_require_attrs
+
+repair_scratch() {
+	fsck_pass="$1"
+
+	FSCK_LOG="${tmp}-fuzz-${fsck_pass}.log"
+	echo "++ fsck pass ${fsck_pass}" > "${FSCK_LOG}"
+	e2fsck -f -y "${SCRATCH_DEV}"
+	res=$?
+	if [ "${res}" -eq 0 ]; then
+		echo "++ allegedly fixed, reverify" >> "${FSCK_LOG}"
+		_check_scratch_fs -n >> "${FSCK_LOG}" 2>&1
+		res=$?
+	fi
+	echo "++ fsck returns ${res}" >> "${FSCK_LOG}"
+	if [ "${res}" -eq 0 ]; then
+		echo "++ fsck thinks we are done" >> "${FSCK_LOG}"
+		cat "${FSCK_LOG}"
+		return 0
+	elif [ "${fsck_pass}" -eq "${FSCK_PASSES}" ]; then
+		echo "++ fsck did not fix in ${FSCK_PASSES} passes." >> "${FSCK_LOG}"
+		cat "${FSCK_LOG}"
+		return 0
+	fi
+	cat "${FSCK_LOG}"
+	if [ "${fsck_pass}" -gt 1 ]; then
+		cmp -s "${tmp}-fuzz-$((fsck_pass - 1)).log" "${FSCK_LOG}"
+		if [ $? -eq 0 ]; then
+			echo "++ fsck makes no progress"
+			return 2
+		fi
+	fi
+	return 1
+}
+
+rm -f $seqres.full
+echo "See interesting results in $seqres.full" | sed -e "s,$RESULT_DIR,RESULT_DIR,g"
+SRCDIR=`pwd`
+test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-b 32 -v"
+test -z "${FSCK_PASSES}" && FSCK_PASSES=10
+BLK_SZ=4096
+
+echo "fuzzing ext4 with FUZZ_ARGS=$FUZZ_ARGS and FSCK_PASSES=$FSCK_PASSES" > $seqres.full
+
+echo "+ create scratch fs" >> $seqres.full
+_scratch_mkfs_ext4 >> $seqres.full 2>&1
+
+echo "+ populate fs image" >> $seqres.full
+_scratch_populate >> $seqres.full
+
+echo "+ check fs" >> $seqres.full
+_check_scratch_fs >> $seqres.full 2>&1 || _fail "should pass initial fsck"
+
+echo "++ corrupt image" >> $seqres.full
+e2fuzz ${FUZZ_ARGS} ${SCRATCH_DEV} >> $seqres.full 2>&1
+
+echo "++ mount image" >> $seqres.full
+_scratch_mount >> $seqres.full 2>&1
+
+echo "++ test scratch" >> $seqres.full
+_scratch_fuzz_test >> $seqres.full 2>&1
+
+echo "++ modify scratch" >> $seqres.full
+_scratch_fuzz_modify >> $seqres.full 2>&1
+
+echo "++ unmount" >> $seqres.full
+umount "${SCRATCH_MNT}"
+
+# repair in a loop...
+for p in $(seq 1 "${FSCK_PASSES}"); do
+	repair_scratch "$p" >> $seqres.full 2>&1 && break
+done
+echo "+ fsck loop returns ${fsck_loop_ret}" >> $seqres.full
+
+echo "++ check fs for round 2" >> $seqres.full
+_check_scratch_fs >> $seqres.full 2>&1
+
+ROUND2_LOG="${tmp}-round2-${fsck_pass}.log"
+echo "++ mount image (2)" >> $ROUND2_LOG
+_scratch_mount >> $ROUND2_LOG 2>&1
+
+echo "++ chattr -R -i" >> $ROUND2_LOG
+chattr -R -f -i "${SCRATCH_MNT}/" > /dev/null 2>> $ROUND2_LOG
+
+echo "++ test scratch" >> $ROUND2_LOG
+_scratch_fuzz_test >> $ROUND2_LOG 2>&1
+
+echo "++ modify scratch" >> $ROUND2_LOG
+_scratch_fuzz_modify >> $ROUND2_LOG 2>&1
+
+echo "++ unmount" >> $ROUND2_LOG
+umount "${SCRATCH_MNT}" >> $ROUND2_LOG 2>&1
+
+cat "$ROUND2_LOG" >> $seqres.full
+
+echo "++ check fs (2)" >> $seqres.full
+_check_scratch_fs >> $seqres.full 2>&1
+
+egrep -q '(did not fix|makes no progress)' $seqres.full && echo "e2fsck failed" | tee -a $seqres.full
+if [ "$(wc -l < "$ROUND2_LOG")" -ne 8 ]; then
+	echo "e2fsck did not fix everything" | tee -a $seqres.full
+fi
+echo "finished fuzzing" | tee -a "$seqres.full"
+
+status=0
+exit
diff --git a/tests/ext4/700.out b/tests/ext4/700.out
new file mode 100644
index 0000000..c0a16f6
--- /dev/null
+++ b/tests/ext4/700.out
@@ -0,0 +1,3 @@
+QA output created by 700
+See interesting results in RESULT_DIR/700.full
+finished fuzzing
diff --git a/tests/ext4/group b/tests/ext4/group
index 96218b7..dfadd91 100644
--- a/tests/ext4/group
+++ b/tests/ext4/group
@@ -17,3 +17,4 @@
 306 auto rw resize quick
 307 auto ioctl rw
 308 auto ioctl rw prealloc quick
+700 dangerous_fuzzers
diff --git a/tests/xfs/700 b/tests/xfs/700
new file mode 100755
index 0000000..bc3f176
--- /dev/null
+++ b/tests/xfs/700
@@ -0,0 +1,174 @@
+#! /bin/bash
+# FS QA Test No. 700
+#
+# Create and populate an XFS filesystem, fuzz the metadata, then see how
+# the kernel reacts, how xfs_repair fares in fixing the mess, and then
+# try more kernel accesses to see if it really fixed things.
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
+_require_xfs_io_command "falloc"
+_require_xfs_io_command "fpunch"
+_require_scratch
+#_require_xfs_crc	# checksum not required, but you probably want it anyway...
+#_require_xfs_mkfs_crc
+_require_attrs
+
+scratch_repair() {
+	fsck_pass="$1"
+
+	FSCK_LOG="${tmp}-fuzz-${fsck_pass}.log"
+	echo "++ fsck pass ${fsck_pass}" > "${FSCK_LOG}"
+	_scratch_xfs_repair >> "${FSCK_LOG}" 2>&1
+	res=$?
+	if [ "${res}" -eq 0 ]; then
+		echo "++ allegedly fixed, reverify" >> "${FSCK_LOG}"
+		_scratch_xfs_repair -n >> "${FSCK_LOG}" 2>&1
+		res=$?
+	fi
+	echo "++ fsck returns ${res}" >> "${FSCK_LOG}"
+	if [ "${res}" -eq 0 ]; then
+		echo "++ fsck thinks we are done" >> "${FSCK_LOG}"
+		cat "${FSCK_LOG}"
+		return 0
+	elif [ "${res}" -eq 2 ]; then
+		# replay log?
+		echo "+++ replaying log" >> "${FSCK_LOG}"
+		_scratch_mount >> "${FSCK_LOG}" 2>&1
+		res=$?
+		echo "+++ mount returns ${res}" >> "${FSCK_LOG}"
+		if [ "${res}" -gt 0 ]; then
+			echo "+++ zeroing log" >> "${FSCK_LOG}"
+			_scratch_xfs_repair -L >> "${FSCK_LOG}" 2>&1
+			echo "+++ returns $?" >> "${FSCK_LOG}"
+		else
+			umount "${SCRATCH_MNT}" >> "${FSCK_LOG}" 2>&1
+		fi
+	elif [ "${fsck_pass}" -eq "${FSCK_PASSES}" ]; then
+		echo "++ fsck did not fix in ${FSCK_PASSES} passes." >> "${FSCK_LOG}"
+		cat "${FSCK_LOG}"
+		return 0
+	fi
+	cat "${FSCK_LOG}"
+	if [ "${fsck_pass}" -gt 1 ]; then
+		cmp -s "${tmp}-fuzz-$((fsck_pass - 1)).log" "${FSCK_LOG}"
+		if [ $? -eq 0 ]; then
+			echo "++ fsck makes no progress"
+			return 2
+		fi
+	fi
+	return 1
+}
+
+rm -f $seqres.full
+echo "See interesting results in $seqres.full" | sed -e "s,$RESULT_DIR,RESULT_DIR,g"
+SRCDIR=`pwd`
+test -z "${FUZZ_ARGS}" && FUZZ_ARGS="-3 -n 32"
+test -z "${FSCK_PASSES}" && FSCK_PASSES=10
+BLK_SZ=4096
+
+echo "fuzzing xfs with FUZZ_ARGS=$FUZZ_ARGS and FSCK_PASSES=$FSCK_PASSES" > $seqres.full
+
+echo "+ create scratch fs" >> $seqres.full
+_scratch_mkfs_xfs >> $seqres.full 2>&1
+
+echo "+ populate fs image" >> $seqres.full
+_scratch_populate >> $seqres.full
+
+echo "+ check fs" >> $seqres.full
+_scratch_xfs_repair >> $seqres.full 2>&1 || _fail "should pass initial fsck"
+
+echo "++ corrupt image" >> $seqres.full
+xfs_db -x -c blockget -c "blocktrash ${FUZZ_ARGS}" "${SCRATCH_DEV}" >> $seqres.full 2>&1
+
+echo "++ mount image" >> $seqres.full
+_scratch_mount >> $seqres.full 2>&1
+
+echo "+++ test scratch" >> $seqres.full
+_scratch_fuzz_test >> $seqres.full 2>&1
+
+echo "+++ modify scratch" >> $seqres.full
+_scratch_fuzz_modify >> $seqres.full 2>&1
+
+echo "++ umount" >> $seqres.full
+umount "${SCRATCH_MNT}"
+
+# repair in a loop...
+for p in $(seq 1 "${FSCK_PASSES}"); do
+	scratch_repair "$p" >> $seqres.full 2>&1 && break
+done
+echo "+ fsck loop returns ${fsck_loop_ret}" >> $seqres.full
+
+echo "++ check fs for round 2" >> $seqres.full
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+ROUND2_LOG="${tmp}-round2-${fsck_pass}.log"
+echo "++ mount image (2)" >> $ROUND2_LOG
+_scratch_mount >> $ROUND2_LOG 2>&1
+
+echo "++ chattr -R -i" >> $ROUND2_LOG
+chattr -R -f -i "${SCRATCH_MNT}/" > /dev/null 2>> $ROUND2_LOG
+
+echo "+++ test scratch" >> $ROUND2_LOG
+_scratch_fuzz_test >> $ROUND2_LOG 2>&1
+
+echo "+++ modify scratch" >> $ROUND2_LOG
+_scratch_fuzz_modify >> $ROUND2_LOG 2>&1
+
+echo "++ umount" >> $ROUND2_LOG
+umount "${SCRATCH_MNT}" >> $ROUND2_LOG 2>&1
+
+cat "$ROUND2_LOG" >> $seqres.full
+
+echo "++ check fs (2)" >> $seqres.full
+_scratch_xfs_repair >> $seqres.full 2>&1
+
+egrep -q '(did not fix|makes no progress)' $seqres.full && echo "xfs_repair failed" | tee -a $seqres.full
+if [ "$(wc -l < "$ROUND2_LOG")" -ne 8 ]; then
+	echo "xfs_repair did not fix everything" | tee -a $seqres.full
+fi
+echo "finished fuzzing" | tee -a "$seqres.full"
+
+status=0
+exit
diff --git a/tests/xfs/700.out b/tests/xfs/700.out
new file mode 100644
index 0000000..c0a16f6
--- /dev/null
+++ b/tests/xfs/700.out
@@ -0,0 +1,3 @@
+QA output created by 700
+See interesting results in RESULT_DIR/700.full
+finished fuzzing
diff --git a/tests/xfs/group b/tests/xfs/group
index ebe8e7e..140df27 100644
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -197,3 +197,4 @@
 303 auto quick quota
 304 auto quick quota
 305 auto quota
+700 dangerous_fuzzers

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
