Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45602 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753851AbeEAPkV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 May 2018 11:40:21 -0400
Subject: [PATCH 9/9] xfs: fix blocktrash fuzzers
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 01 May 2018 08:40:17 -0700
Message-ID: <152518921725.23023.4587669785997103827.stgit@magnolia>
In-Reply-To: <152518916007.23023.4793255395982876953.stgit@magnolia>
References: <152518916007.23023.4793255395982876953.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

The blocktrash fuzz tests for xfs will try to mount and write to the
filesystem after corrupting it.  However, the mount may not necessarily
succeed, in which case we must not write junk to the root filesystem.
Use the new _test_scratch_mount to guard against that.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/086 |   15 ++++++++-------
 tests/xfs/087 |   19 ++++++++++---------
 tests/xfs/088 |   15 ++++++++-------
 tests/xfs/089 |   15 ++++++++-------
 tests/xfs/091 |   15 ++++++++-------
 tests/xfs/093 |   19 ++++++++++---------
 tests/xfs/097 |   19 ++++++++++---------
 tests/xfs/099 |   11 ++++++-----
 tests/xfs/100 |   11 ++++++-----
 tests/xfs/101 |   11 ++++++-----
 tests/xfs/102 |   11 ++++++-----
 tests/xfs/105 |   11 ++++++-----
 tests/xfs/112 |   11 ++++++-----
 tests/xfs/113 |   11 ++++++-----
 tests/xfs/117 |   25 +++++++++++++------------
 tests/xfs/120 |   17 +++++++++--------
 tests/xfs/123 |    7 ++++---
 tests/xfs/124 |    9 +++++----
 tests/xfs/125 |    9 +++++----
 tests/xfs/126 |    9 +++++----
 tests/xfs/235 |   11 ++++++-----
 tests/xfs/337 |   11 ++++++-----
 22 files changed, 157 insertions(+), 135 deletions(-)


diff --git a/tests/xfs/086 b/tests/xfs/086
index 787f8865..98b45dde 100755
--- a/tests/xfs/086
+++ b/tests/xfs/086
@@ -93,13 +93,14 @@ done
 
 # Try to append to files; this should fail
 echo "+ mount image"
-_scratch_mount
-
-echo "+ modify files"
-for x in `seq 1 64`; do
-	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
-done
-umount "${SCRATCH_MNT}"
+if _try_scratch_mount >> $seqres.full 2>&1; then
+
+	echo "+ modify files"
+	for x in `seq 1 64`; do
+		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
+	done
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/087 b/tests/xfs/087
index 58ba9586..65877c7c 100755
--- a/tests/xfs/087
+++ b/tests/xfs/087
@@ -91,15 +91,16 @@ for ag in $(seq 1 $((agcount - 1))) 0; do
 done
 
 echo "+ mount image"
-_scratch_mount
-
-echo "+ modify files"
-broken=0
-for x in `seq 65 70`; do
-	touch "${TESTFILE}.${x}" 2> /dev/null || broken=1
-done
-echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+if _try_scratch_mount >> $seqres.full 2>&1; then
+
+	echo "+ modify files"
+	broken=0
+	for x in `seq 65 70`; do
+		touch "${TESTFILE}.${x}" 2> /dev/null || broken=1
+	done
+	echo "broken: ${broken}"
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/088 b/tests/xfs/088
index 36745b2f..14b1f115 100755
--- a/tests/xfs/088
+++ b/tests/xfs/088
@@ -92,13 +92,14 @@ done
 
 # Try to append to files; this should fail
 echo "+ mount image"
-_scratch_mount
-
-echo "+ modify files"
-for x in `seq 1 64`; do
-	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
-done
-umount "${SCRATCH_MNT}"
+if _try_scratch_mount >> $seqres.full 2>&1; then
+
+	echo "+ modify files"
+	for x in `seq 1 64`; do
+		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
+	done
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/089 b/tests/xfs/089
index 52bdd542..e47f7fef 100755
--- a/tests/xfs/089
+++ b/tests/xfs/089
@@ -92,13 +92,14 @@ done
 
 # Try to append to files; this should fail
 echo "+ mount image"
-_scratch_mount
-
-echo "+ modify files"
-for x in `seq 1 64`; do
-	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
-done
-umount "${SCRATCH_MNT}"
+if _try_scratch_mount >> $seqres.full 2>&1; then
+
+	echo "+ modify files"
+	for x in `seq 1 64`; do
+		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
+	done
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/091 b/tests/xfs/091
index ae623370..7adbdc9e 100755
--- a/tests/xfs/091
+++ b/tests/xfs/091
@@ -92,13 +92,14 @@ done
 
 # Try to append to files; this should fail
 echo "+ mount image"
-_scratch_mount
-
-echo "+ modify files"
-for x in `seq 1 64`; do
-	$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
-done
-umount "${SCRATCH_MNT}"
+if _try_scratch_mount >> $seqres.full 2>&1; then
+
+	echo "+ modify files"
+	for x in `seq 1 64`; do
+		$XFS_IO_PROG -f -c "pwrite -S 0x62 0 ${blksz}" "${TESTFILE}.${x}" >> $seqres.full
+	done
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/093 b/tests/xfs/093
index 0f9311e9..440cdb66 100755
--- a/tests/xfs/093
+++ b/tests/xfs/093
@@ -91,15 +91,16 @@ for ag in $(seq 1 $((agcount - 1))) 0; do
 done
 
 echo "+ mount image"
-_scratch_mount
-
-echo "+ modify files"
-broken=0
-for x in `seq 65 70`; do
-	touch "${TESTFILE}.${x}" 2> /dev/null || broken=1
-done
-echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+if _try_scratch_mount >> $seqres.full 2>&1; then
+
+	echo "+ modify files"
+	broken=0
+	for x in `seq 65 70`; do
+		touch "${TESTFILE}.${x}" 2> /dev/null || broken=1
+	done
+	echo "broken: ${broken}"
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/097 b/tests/xfs/097
index 303ad04f..703bd9b4 100755
--- a/tests/xfs/097
+++ b/tests/xfs/097
@@ -94,15 +94,16 @@ for ag in $(seq 1 $((agcount - 1))) 0; do
 done
 
 echo "+ mount image"
-_scratch_mount
-
-echo "+ modify files"
-broken=0
-for x in `seq 65 70`; do
-	touch "${TESTFILE}.${x}" 2> /dev/null || broken=1
-done
-echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+if _try_scratch_mount >> $seqres.full 2>&1; then
+
+	echo "+ modify files"
+	broken=0
+	for x in `seq 65 70`; do
+		touch "${TESTFILE}.${x}" 2> /dev/null || broken=1
+	done
+	echo "broken: ${broken}"
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/099 b/tests/xfs/099
index 7835df9f..2d63536c 100755
--- a/tests/xfs/099
+++ b/tests/xfs/099
@@ -82,12 +82,13 @@ echo "+ corrupt dir"
 _scratch_xfs_db -x -c "inode ${inode}" -c 'dblock 0' -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 
 echo "+ mount image"
-_scratch_mount
+if _try_scratch_mount >> $seqres.full 2>&1; then
 
-echo "+ modify dir"
-rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
-mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
-umount "${SCRATCH_MNT}"
+	echo "+ modify dir"
+	rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
+	mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/100 b/tests/xfs/100
index ebb656d3..83146ee0 100755
--- a/tests/xfs/100
+++ b/tests/xfs/100
@@ -87,12 +87,13 @@ while true; do
 done
 
 echo "+ mount image"
-_scratch_mount
+if _try_scratch_mount >> $seqres.full 2>&1; then
 
-echo "+ modify dir"
-rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
-mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
-umount "${SCRATCH_MNT}"
+	echo "+ modify dir"
+	rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
+	mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/101 b/tests/xfs/101
index 709fc9d3..426c3e9c 100755
--- a/tests/xfs/101
+++ b/tests/xfs/101
@@ -82,12 +82,13 @@ echo "+ corrupt dir"
 _scratch_xfs_db -x -c "inode ${inode}" -c "dblock ${leaf_lblk}" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 
 echo "+ mount image"
-_scratch_mount
+if _try_scratch_mount >> $seqres.full 2>&1; then
 
-echo "+ modify dir"
-rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
-mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
-umount "${SCRATCH_MNT}"
+	echo "+ modify dir"
+	rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
+	mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/102 b/tests/xfs/102
index 3d51c6a2..02bc35ca 100755
--- a/tests/xfs/102
+++ b/tests/xfs/102
@@ -87,12 +87,13 @@ while true; do
 done
 
 echo "+ mount image"
-_scratch_mount
+if _try_scratch_mount >> $seqres.full 2>&1; then
 
-echo "+ modify dir"
-rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
-mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
-umount "${SCRATCH_MNT}"
+	echo "+ modify dir"
+	rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
+	mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/105 b/tests/xfs/105
index fc91a4f5..c3a853b0 100755
--- a/tests/xfs/105
+++ b/tests/xfs/105
@@ -87,12 +87,13 @@ while true; do
 done
 
 echo "+ mount image"
-_scratch_mount
+if _try_scratch_mount >> $seqres.full 2>&1; then
 
-echo "+ modify dir"
-rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
-mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
-umount "${SCRATCH_MNT}"
+	echo "+ modify dir"
+	rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
+	mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/112 b/tests/xfs/112
index ae756845..cec3a168 100755
--- a/tests/xfs/112
+++ b/tests/xfs/112
@@ -87,12 +87,13 @@ while true; do
 done
 
 echo "+ mount image"
-_scratch_mount
+if _try_scratch_mount >> $seqres.full 2>&1; then
 
-echo "+ modify dir"
-rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
-mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
-umount "${SCRATCH_MNT}"
+	echo "+ modify dir"
+	rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
+	mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/113 b/tests/xfs/113
index c347db78..17af3b66 100755
--- a/tests/xfs/113
+++ b/tests/xfs/113
@@ -87,12 +87,13 @@ while true; do
 done
 
 echo "+ mount image"
-_scratch_mount
+if _try_scratch_mount >> $seqres.full 2>&1; then
 
-echo "+ modify dir"
-rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
-mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
-umount "${SCRATCH_MNT}"
+	echo "+ modify dir"
+	rm -rf "${SCRATCH_MNT}/blockdir/00000000" 2> /dev/null && _fail "modified corrupt directory"
+	mkdir "${SCRATCH_MNT}/blockdir/xxxxxxxx" 2> /dev/null && _fail "add to corrupt directory"
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/117 b/tests/xfs/117
index f0b95aa1..31eac295 100755
--- a/tests/xfs/117
+++ b/tests/xfs/117
@@ -90,18 +90,19 @@ seq "${inode}" "$((inode + 64))" | while read ino; do
 done
 
 echo "+ mount image"
-_scratch_mount
-
-echo "+ modify files"
-broken=0
-for x in `seq 1 64`; do
-	stat "${TESTFILE}.${x}" >> $seqres.full 2>&1
-	test $? -ne 0 && broken=1
-	touch "${TESTFILE}.${x}" >> $seqres.full 2>&1
-	test $? -ne 0 && broken=1
-done
-echo "broken: ${broken}"
-umount "${SCRATCH_MNT}"
+if _try_scratch_mount >> $seqres.full 2>&1; then
+
+	echo "+ modify files"
+	broken=0
+	for x in `seq 1 64`; do
+		stat "${TESTFILE}.${x}" >> $seqres.full 2>&1
+		test $? -ne 0 && broken=1
+		touch "${TESTFILE}.${x}" >> $seqres.full 2>&1
+		test $? -ne 0 && broken=1
+	done
+	echo "broken: ${broken}"
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/120 b/tests/xfs/120
index 5a38000c..39c41d98 100755
--- a/tests/xfs/120
+++ b/tests/xfs/120
@@ -79,14 +79,15 @@ echo "+ corrupt image"
 _scratch_xfs_db -x -c "inode ${inode}" -c "addr u.bmbt.ptrs[1]" -c "addr u3.bmbt.ptrs[1]" -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 
 echo "+ mount image"
-_scratch_mount
-
-echo "+ modify files"
-before="$(stat -c '%b' "${SCRATCH_MNT}/bigfile")"
-$XFS_IO_PROG -f -c "pwrite -S 0x62 ${blksz} ${blksz}" -c 'fsync' "${SCRATCH_MNT}/bigfile" >> $seqres.full 2> /dev/null
-after="$(stat -c '%b' "${SCRATCH_MNT}/bigfile")"
-test "${before}" -eq "${after}" || _fail "pwrite should fail on corrupt bmbt"
-umount "${SCRATCH_MNT}"
+if _try_scratch_mount >> $seqres.full 2>&1; then
+
+	echo "+ modify files"
+	before="$(stat -c '%b' "${SCRATCH_MNT}/bigfile")"
+	$XFS_IO_PROG -f -c "pwrite -S 0x62 ${blksz} ${blksz}" -c 'fsync' "${SCRATCH_MNT}/bigfile" >> $seqres.full 2> /dev/null
+	after="$(stat -c '%b' "${SCRATCH_MNT}/bigfile")"
+	test "${before}" -eq "${after}" || _fail "pwrite should fail on corrupt bmbt"
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/123 b/tests/xfs/123
index 7355e86a..2640d675 100755
--- a/tests/xfs/123
+++ b/tests/xfs/123
@@ -78,9 +78,10 @@ echo "+ corrupt image"
 _scratch_xfs_db -x -c "inode ${inode}" -c "dblock 0" -c "stack" -c "blocktrash -x 32 -o 256 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 
 echo "+ mount image"
-_scratch_mount
-cat "${SCRATCH_MNT}/long_symlink" 2>/dev/null && _fail "symlink should be broken"
-umount "${SCRATCH_MNT}"
+if _try_scratch_mount >> $seqres.full 2>&1; then
+	cat "${SCRATCH_MNT}/long_symlink" 2>/dev/null && _fail "symlink should be broken"
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/124 b/tests/xfs/124
index a828dd6b..742ef75a 100755
--- a/tests/xfs/124
+++ b/tests/xfs/124
@@ -87,11 +87,12 @@ echo "+ corrupt xattr"
 _scratch_xfs_db -x -c "inode ${inode}" -c 'ablock 0' -c "stack" -c "blocktrash -x 32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 
 echo "+ mount image"
-_scratch_mount
+if _try_scratch_mount >> $seqres.full 2>&1; then
 
-echo "+ modify xattr"
-setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" 2> /dev/null && _fail "modified corrupt xattr"
-umount "${SCRATCH_MNT}"
+	echo "+ modify xattr"
+	setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" 2> /dev/null && _fail "modified corrupt xattr"
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/125 b/tests/xfs/125
index 3afb4cc1..4ab0177d 100755
--- a/tests/xfs/125
+++ b/tests/xfs/125
@@ -87,11 +87,12 @@ echo "+ corrupt xattr"
 _scratch_xfs_db -x -c "inode ${inode}" -c 'ablock 0' -c "stack" -c "blocktrash -x 32 -o +32 -y $((blksz * 8)) -z ${FUZZ_ARGS}" >> $seqres.full
 
 echo "+ mount image"
-_scratch_mount
+if _try_scratch_mount >> $seqres.full 2>&1; then
 
-echo "+ modify xattr"
-setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" 2> /dev/null && _fail "modified corrupt xattr"
-umount "${SCRATCH_MNT}"
+	echo "+ modify xattr"
+	setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" 2> /dev/null && _fail "modified corrupt xattr"
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/126 b/tests/xfs/126
index d696ff1f..de6e2fdb 100755
--- a/tests/xfs/126
+++ b/tests/xfs/126
@@ -92,11 +92,12 @@ while true; do
 done
 
 echo "+ mount image"
-_scratch_mount
+if _try_scratch_mount >> $seqres.full 2>&1; then
 
-echo "+ modify xattr"
-setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" 2> /dev/null && _fail "modified corrupt xattr"
-umount "${SCRATCH_MNT}"
+	echo "+ modify xattr"
+	setfattr -x "user.x00000000" "${SCRATCH_MNT}/attrfile" 2> /dev/null && _fail "modified corrupt xattr"
+	umount "${SCRATCH_MNT}"
+fi
 
 echo "+ repair fs"
 _scratch_xfs_repair >> $seqres.full 2>&1
diff --git a/tests/xfs/235 b/tests/xfs/235
index 88101f2d..84725b0a 100755
--- a/tests/xfs/235
+++ b/tests/xfs/235
@@ -77,12 +77,13 @@ seq 0 $((agcount - 1)) | while read ag; do
 done
 
 echo "+ mount image"
-_scratch_mount
+if _try_scratch_mount >> $seqres.full 2>&1; then
 
-echo "+ copy more"
-$XFS_IO_PROG -f -c "pwrite -S 0x63 0 $((blksz * 64))" -c "fsync" ${SCRATCH_MNT}/file4 >> $seqres.full 2>&1
-test -s ${SCRATCH_MNT}/file4 && _fail "should not be able to copy with busted rmap btree"
-umount ${SCRATCH_MNT}
+	echo "+ copy more"
+	$XFS_IO_PROG -f -c "pwrite -S 0x63 0 $((blksz * 64))" -c "fsync" ${SCRATCH_MNT}/file4 >> $seqres.full 2>&1
+	test -s ${SCRATCH_MNT}/file4 && _fail "should not be able to copy with busted rmap btree"
+	umount ${SCRATCH_MNT}
+fi
 
 echo "+ repair fs"
 _disable_dmesg_check
diff --git a/tests/xfs/337 b/tests/xfs/337
index b61e7226..851b6439 100755
--- a/tests/xfs/337
+++ b/tests/xfs/337
@@ -85,12 +85,13 @@ _scratch_xfs_db -x -c "sb" -c "addr rrmapino" -c "addr u3.rtrmapbt.ptrs[1]" \
 	>> $seqres.full 2>&1
 
 echo "+ mount image"
-_scratch_mount
+if _try_scratch_mount >> $seqres.full 2>&1; then
 
-echo "+ copy more"
-$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 1" $SCRATCH_MNT/e3 >> $seqres.full 2>&1
-test -s ${SCRATCH_MNT}/f3 && echo "should not be able to copy with busted rtrmap btree"
-_scratch_unmount
+	echo "+ copy more"
+	$XFS_IO_PROG -f -R -c "pwrite -S 0x68 0 1" $SCRATCH_MNT/e3 >> $seqres.full 2>&1
+	test -s ${SCRATCH_MNT}/f3 && echo "should not be able to copy with busted rtrmap btree"
+	_scratch_unmount
+fi
 
 echo "+ repair fs"
 _repair_scratch_fs >> $seqres.full 2>&1

