Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36713 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933960AbdAEBRh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jan 2017 20:17:37 -0500
Subject: [PATCH 5/9] common/fuzzy: move fuzzing helper functions here
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Wed, 04 Jan 2017 17:17:32 -0800
Message-ID: <148357905253.10436.560781214557366417.stgit@birch.djwong.org>
In-Reply-To: <148357902056.10436.12795484251467155460.stgit@birch.djwong.org>
References: <148357902056.10436.12795484251467155460.stgit@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@redhat.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

Move some fuzzing helper functions into a new common/fuzzy file.
We'll add a lot more fuzzing helpers in subsequent patches.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/fuzzy    |   83 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common/populate |   35 -----------------------
 tests/ext4/006  |    1 +
 tests/xfs/083   |    1 +
 4 files changed, 85 insertions(+), 35 deletions(-)
 create mode 100644 common/fuzzy


diff --git a/common/fuzzy b/common/fuzzy
new file mode 100644
index 0000000..1cc1d5e
--- /dev/null
+++ b/common/fuzzy
@@ -0,0 +1,83 @@
+##/bin/bash
+
+# Routines for fuzzing and scrubbing a filesystem.
+#
+#-----------------------------------------------------------------------
+#  Copyright (c) 2017 Oracle.  All Rights Reserved.
+#  This program is free software; you can redistribute it and/or modify
+#  it under the terms of the GNU General Public License as published by
+#  the Free Software Foundation; either version 2 of the License, or
+#  (at your option) any later version.
+#
+#  This program is distributed in the hope that it will be useful,
+#  but WITHOUT ANY WARRANTY; without even the implied warranty of
+#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+#  GNU General Public License for more details.
+#
+#  You should have received a copy of the GNU General Public License
+#  along with this program; if not, write to the Free Software
+#  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307
+#  USA
+#
+#  Contact information: Silicon Graphics, Inc., 1500 Crittenden Lane,
+#  Mountain View, CA 94043, USA, or: http://www.sgi.com
+#-----------------------------------------------------------------------
+
+# Modify various files after a fuzzing operation
+_scratch_fuzz_modify() {
+	nr="$1"
+
+	test -z "${nr}" && nr=50000
+	echo "+++ touch ${nr} files"
+	blk_sz=$(stat -f -c '%s' ${SCRATCH_MNT})
+	$XFS_IO_PROG -f -c "pwrite -S 0x63 0 ${blk_sz}" "/tmp/afile" > /dev/null
+	date="$(date)"
+	find "${SCRATCH_MNT}/" -type f 2> /dev/null | head -n "${nr}" | while read f; do
+		setfattr -n "user.date" -v "${date}" "$f"
+		cat "/tmp/afile" >> "$f"
+		mv "$f" "$f.longer"
+	done
+	sync
+	rm -rf "/tmp/afile"
+
+	echo "+++ create files"
+	mkdir -p "${SCRATCH_MNT}/test.moo"
+	$XFS_IO_PROG -f -c 'pwrite -S 0x80 0 65536' "${SCRATCH_MNT}/test.moo/urk"
+	sync
+
+	echo "+++ remove files"
+	rm -rf "${SCRATCH_MNT}/test.moo"
+}
+
+# Try to access files after fuzzing
+_scratch_fuzz_test() {
+	echo "+++ ls -laR" >> $seqres.full
+	ls -laR "${SCRATCH_MNT}/test.1/" >/dev/null 2>&1
+
+	echo "+++ cat files" >> $seqres.full
+	(find "${SCRATCH_MNT}/test.1/" -type f -size -1048576k -print0 | xargs -0 cat) >/dev/null 2>&1
+}
+
+# Do we have an online scrub program?
+_require_scrub() {
+	case "${FSTYP}" in
+	"xfs"|"ext4")
+		test -x $XFS_SCRUB_PROG || _notrun "xfs_scrub not found"
+		;;
+	*)
+		_notrun "No online scrub program for ${FSTYP}."
+		;;
+	esac
+}
+
+# Scrub the scratch filesystem metadata (online)
+_scratch_scrub() {
+	case "${FSTYP}" in
+	"xfs"|"ext4"|"ext3"|"ext2")
+		$XFS_SCRUB_PROG -d -T -v "$@" $SCRATCH_MNT
+		;;
+	*)
+		_fail "No online scrub program for ${FSTYP}."
+		;;
+	esac
+}
diff --git a/common/populate b/common/populate
index 5808bc9..f012173 100644
--- a/common/populate
+++ b/common/populate
@@ -606,41 +606,6 @@ _scratch_populate() {
 	esac
 }
 
-# Modify various files after a fuzzing operation
-_scratch_fuzz_modify() {
-	nr="$1"
-
-	test -z "${nr}" && nr=50000
-	echo "+++ touch ${nr} files"
-	blk_sz=$(stat -f -c '%s' ${SCRATCH_MNT})
-	$XFS_IO_PROG -f -c "pwrite -S 0x63 0 ${blk_sz}" "/tmp/afile" > /dev/null
-	date="$(date)"
-	find "${SCRATCH_MNT}/" -type f 2> /dev/null | head -n "${nr}" | while read f; do
-		setfattr -n "user.date" -v "${date}" "$f"
-		cat "/tmp/afile" >> "$f"
-		mv "$f" "$f.longer"
-	done
-	sync
-	rm -rf "/tmp/afile"
-
-	echo "+++ create files"
-	mkdir -p "${SCRATCH_MNT}/test.moo"
-	$XFS_IO_PROG -f -c 'pwrite -S 0x80 0 65536' "${SCRATCH_MNT}/test.moo/urk"
-	sync
-
-	echo "+++ remove files"
-	rm -rf "${SCRATCH_MNT}/test.moo"
-}
-
-# Try to access files after fuzzing
-_scratch_fuzz_test() {
-	echo "+++ ls -laR" >> $seqres.full
-	ls -laR "${SCRATCH_MNT}/test.1/" >/dev/null 2>&1
-
-	echo "+++ cat files" >> $seqres.full
-	(find "${SCRATCH_MNT}/test.1/" -type f -size -1048576k -print0 | xargs -0 cat) >/dev/null 2>&1
-}
-
 # Fill a file system by repeatedly creating files in the given folder
 # starting with the given file size.  Files are reduced in size when
 # they can no longer fit until no more files can be created.
diff --git a/tests/ext4/006 b/tests/ext4/006
index 9662f50..bb9b7e5 100755
--- a/tests/ext4/006
+++ b/tests/ext4/006
@@ -43,6 +43,7 @@ _cleanup()
 . ./common/filter
 . ./common/attr
 . ./common/populate
+. ./common/fuzzy
 
 if [ ! -x "$(which e2fuzz)" ]; then
 	_notrun "Couldn't find e2fuzz"
diff --git a/tests/xfs/083 b/tests/xfs/083
index 39bd75f..e2b5f82 100755
--- a/tests/xfs/083
+++ b/tests/xfs/083
@@ -43,6 +43,7 @@ _cleanup()
 . ./common/filter
 . ./common/attr
 . ./common/populate
+. ./common/fuzzy
 
 # real QA test starts here
 _supported_fs xfs

