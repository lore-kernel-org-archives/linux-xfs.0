Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:49432 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932270AbeGDEvK (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Jul 2018 00:51:10 -0400
Subject: [PATCH 3/7] xfs/001: update to handle v5 filesystems
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 03 Jul 2018 21:51:06 -0700
Message-ID: <153067986635.28393.2430588973298698151.stgit@magnolia>
In-Reply-To: <153067984748.28393.1595618163831671652.stgit@magnolia>
References: <153067984748.28393.1595618163831671652.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: guaneryu@gmail.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

xfs/001 fuzzes various extent fields using xfs_db.  There's nothing in
it that's specific to v4 filesystems, so upgrade the test to be able to
handle v5 filesystems.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 common/xfs    |   15 +++++++++++++++
 tests/xfs/001 |   18 ++++++++++++------
 2 files changed, 27 insertions(+), 6 deletions(-)


diff --git a/common/xfs b/common/xfs
index 9a785b88..5b632df1 100644
--- a/common/xfs
+++ b/common/xfs
@@ -765,3 +765,18 @@ _scratch_get_sfdir_prefix() {
 	_scratch_xfs_db -c "inode ${dir_ino}" -c 'p' >> $seqres.full
 	return 1
 }
+
+_scratch_get_bmx_prefix() {
+	local ino="$1"
+
+	for prefix in "u3.bmx" "u.bmx"; do
+		if [ -n "$(_scratch_xfs_get_metadata_field \
+				"${prefix}[0].startblock" \
+				"inode ${ino}")" ]; then
+			echo "${prefix}"
+			return 0
+		fi
+	done
+	_scratch_xfs_db -c "inode ${ino}" -c 'p' >> $seqres.full
+	return 1
+}
diff --git a/tests/xfs/001 b/tests/xfs/001
index ac86c3b1..6ad3aba8 100755
--- a/tests/xfs/001
+++ b/tests/xfs/001
@@ -49,9 +49,8 @@ _do_bit_test()
 _supported_fs xfs
 _supported_os Linux
 _require_scratch_nocheck
-_require_xfs_mkfs_crc
 
-_scratch_mkfs -m crc=0 >/dev/null 2>&1
+_scratch_mkfs >/dev/null 2>&1
 _scratch_mount
 
 # create the test file
@@ -68,11 +67,18 @@ BMBT_STARTOFF_BITLEN=54
 BMBT_STARTBLOCK_BITLEN=52
 BMBT_BLOCKCOUNT_BITLEN=21
 
+prefix=$(_scratch_get_bmx_prefix $FILE_INO)
+test -n "$prefix" || _fail "could not find bmx prefix from inode $FILE_INO"
+
+filter_output() {
+	sed -e "s/${prefix}/u.bmx/g"
+}
+
 # test setting the BMBT entries from 0 to past the valid number.
-_do_bit_test "u.bmx[0].extentflag" $BMBT_EXNTFLAG_BITLEN
-_do_bit_test "u.bmx[0].startoff" $BMBT_STARTOFF_BITLEN
-_do_bit_test "u.bmx[0].startblock" $BMBT_STARTBLOCK_BITLEN
-_do_bit_test "u.bmx[0].blockcount" $BMBT_BLOCKCOUNT_BITLEN
+_do_bit_test "${prefix}[0].extentflag" $BMBT_EXNTFLAG_BITLEN | filter_output
+_do_bit_test "${prefix}[0].startoff" $BMBT_STARTOFF_BITLEN | filter_output
+_do_bit_test "${prefix}[0].startblock" $BMBT_STARTBLOCK_BITLEN | filter_output
+_do_bit_test "${prefix}[0].blockcount" $BMBT_BLOCKCOUNT_BITLEN | filter_output
 # test setting the 32 bit generation number
 _scratch_xfs_db -x -c "inode $FILE_INO" -c "write core.gen 0x5a"
 _scratch_xfs_db -x -c "inode $FILE_INO" -c "write core.gen 0xa5"

