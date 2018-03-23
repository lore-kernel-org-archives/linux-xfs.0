Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:50440 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751632AbeCWQyw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Mar 2018 12:54:52 -0400
Subject: [PATCH 4/4] xfs/278: find sfdir inode field prefix
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Fri, 23 Mar 2018 09:54:47 -0700
Message-ID: <152182408764.14523.16193613645363841396.stgit@magnolia>
In-Reply-To: <152182406249.14523.2186010254497227366.stgit@magnolia>
References: <152182406249.14523.2186010254497227366.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: eguan@linux.alibaba.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Use the xfs set/get metadata field helpers to detect the correct sfdir
field name prefix on v4-v5 filesystems.  This enables us to test inode
link count corrections on a (deliberately) disconnected directory.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 tests/xfs/278 |   38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)


diff --git a/tests/xfs/278 b/tests/xfs/278
index b94ee9c..47012a3 100755
--- a/tests/xfs/278
+++ b/tests/xfs/278
@@ -61,17 +61,39 @@ _scratch_unmount
 
 echo "Silence is goodness..."
 
+get_sfdir_prefix() {
+	local dir_ino="$1"
+
+	for prefix in "u.sfdir3" "u.sfdir2" "u3.sfdir3"; do
+		if [ -n "$(_scratch_xfs_get_metadata_field \
+				"${prefix}.hdr.parent.i4" \
+				"inode ${dir_ino}")" ]; then
+			echo "${prefix}"
+			return 0
+		fi
+	done
+	_scratch_xfs_db -c "inode ${dir_ino}" -c 'p' >> $seqres.full
+	return 1
+}
+set_ifield() {
+	_scratch_xfs_set_metadata_field "$1" 0 "inode $2" >> $seqres.full
+}
+
+sfdir_prefix="$(get_sfdir_prefix "$DIR_INO" || \
+	_fail "Cannot determine sfdir prefix")"
+
 # Corrupt DIR
-_scratch_xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].inumber.i4 0"  >> $seqres.full
-_scratch_xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].name 0"  >> $seqres.full
-_scratch_xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].offset 0"  >> $seqres.full
-_scratch_xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.list[0].namelen 0"  >> $seqres.full
-_scratch_xfs_db -x -c "inode $DIR_INO" -c "write u.sfdir2.hdr.parent.i4 0"  >> $seqres.full
-_scratch_xfs_db -x -c "inode $DIR_INO" -c "write core.nlinkv2 0"  >> $seqres.full
+
+set_ifield "${sfdir_prefix}.list[0].inumber.i4" "$DIR_INO"
+set_ifield "${sfdir_prefix}.list[0].name" "$DIR_INO"
+set_ifield "${sfdir_prefix}.list[0].offset" "$DIR_INO"
+set_ifield "${sfdir_prefix}.list[0].namelen" "$DIR_INO"
+set_ifield "${sfdir_prefix}.hdr.parent.i4" "$DIR_INO"
+set_ifield "core.nlinkv2" "$DIR_INO"
 
 # Corrupt SUBDIR
-_scratch_xfs_db -x -c "inode $SUBDIR_INO" -c "write u.sfdir2.hdr.parent.i4 0"  >> $seqres.full
-_scratch_xfs_db -x -c "inode $SUBDIR_INO" -c "write core.nlinkv2 0"  >> $seqres.full
+set_ifield "${sfdir_prefix}.hdr.parent.i4" "$SUBDIR_INO"
+set_ifield "core.nlinkv2" "$SUBDIR_INO"
 
 echo "===== BEGIN of xfs_repair =====" >> $seqres.full
 echo "" >>$seqres.full

