Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id EA5FF29DFD
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 14:25:11 -0600 (CST)
Received: from eagdhcp-232-183.americas.sgi.com
	(eagdhcp-232-183.americas.sgi.com [128.162.232.183])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 63321AC00B
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 12:25:11 -0800 (PST)
Received: from eagdhcp-232-183.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-183.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s1DKPCaF005450
	for <xfs@oss.sgi.com>; Thu, 13 Feb 2014 14:25:12 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-183.americas.sgi.com)
Message-Id: <20140213202608.627433955@sgi.com>
Date: Thu, 13 Feb 2014 14:26:56 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH v2] xfstests: test setting XFS BMBT fields
References: <20140210231046.910977175@sgi.com>
Content-Disposition: inline; filename=xfstests-setting-xfs-bmbt-fields.patch
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Test the setting of the XFS BMBT fields. Runs through the valid
bit values for each field and tests an illegal value.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
v2:
 Removed the test for CRC filesystems which also removes need for the nasty
  prefixes and filtering output.
 Remove the hex input as an integer test because it aint a number.
 Remove "__" from function variable names.
 Add to quick test group.

 tests/xfs/307     |   95 ++++++++++++++++++++++++++++++++++
 tests/xfs/307.out |  148 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/group   |    1 
 3 files changed, 244 insertions(+)

Index: b/tests/xfs/307
===================================================================
--- /dev/null
+++ b/tests/xfs/307
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. 307
+#
+# Test the xfs_db write of the XFS BMBT entries. For each XFS BMBT field,
+# write the value 0, each bit and finally the entry beyond the maximum legal
+# value. Also makes sure a core write and hex input still work.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 SGI.  All Rights Reserved.
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
+    rm -f $tmp.*
+}
+
+_do_bit_test()
+{
+	field="$1"
+	bits="$2"
+
+	echo "testing $field with $bits bits"
+	$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write $field 0" $SCRATCH_DEV
+	num=1
+	for n in `seq 0 1 $bits`; do
+		$XFS_DB_PROG -x -c "inode $FILE_INO" \
+			  -c "write $field $num" $SCRATCH_DEV
+		let num=$num*2
+	done
+	echo
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs xfs
+_supported_os Linux
+
+_scratch_unmount
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+
+# create the test file
+echo "make a file with data so it has an extent" > $SCRATCH_MNT/file
+
+# find the inode for the test file
+FILE_INO=`ls -i $SCRATCH_MNT |awk '{print $1}'`
+
+_scratch_unmount
+
+# test bit length constants
+BMBT_EXNTFLAG_BITLEN=1
+BMBT_STARTOFF_BITLEN=54
+BMBT_STARTBLOCK_BITLEN=52
+BMBT_BLOCKCOUNT_BITLEN=21
+
+# test setting the BMBT entries from 0 to past the valid number.
+_do_bit_test "u.bmx[0].extentflag" $BMBT_EXNTFLAG_BITLEN
+_do_bit_test "u.bmx[0].startoff" $BMBT_STARTOFF_BITLEN
+_do_bit_test "u.bmx[0].startblock" $BMBT_STARTBLOCK_BITLEN
+_do_bit_test "u.bmx[0].blockcount" $BMBT_BLOCKCOUNT_BITLEN
+# test setting the 32 bit generation number
+$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen 0x5a" $SCRATCH_DEV
+$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen 0xa5" $SCRATCH_DEV
+$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen 0" $SCRATCH_DEV
+status=0
+exit
Index: b/tests/xfs/307.out
===================================================================
--- /dev/null
+++ b/tests/xfs/307.out
@@ -0,0 +1,148 @@
+QA output created by 307
+testing u.bmx[0].extentflag with 1 bits
+u.bmx[0].extentflag = 0
+u.bmx[0].extentflag = 1
+unable to convert value '2'.
+
+testing u.bmx[0].startoff with 54 bits
+u.bmx[0].startoff = 0
+u.bmx[0].startoff = 1
+u.bmx[0].startoff = 2
+u.bmx[0].startoff = 4
+u.bmx[0].startoff = 8
+u.bmx[0].startoff = 16
+u.bmx[0].startoff = 32
+u.bmx[0].startoff = 64
+u.bmx[0].startoff = 128
+u.bmx[0].startoff = 256
+u.bmx[0].startoff = 512
+u.bmx[0].startoff = 1024
+u.bmx[0].startoff = 2048
+u.bmx[0].startoff = 4096
+u.bmx[0].startoff = 8192
+u.bmx[0].startoff = 16384
+u.bmx[0].startoff = 32768
+u.bmx[0].startoff = 65536
+u.bmx[0].startoff = 131072
+u.bmx[0].startoff = 262144
+u.bmx[0].startoff = 524288
+u.bmx[0].startoff = 1048576
+u.bmx[0].startoff = 2097152
+u.bmx[0].startoff = 4194304
+u.bmx[0].startoff = 8388608
+u.bmx[0].startoff = 16777216
+u.bmx[0].startoff = 33554432
+u.bmx[0].startoff = 67108864
+u.bmx[0].startoff = 134217728
+u.bmx[0].startoff = 268435456
+u.bmx[0].startoff = 536870912
+u.bmx[0].startoff = 1073741824
+u.bmx[0].startoff = 2147483648
+u.bmx[0].startoff = 4294967296
+u.bmx[0].startoff = 8589934592
+u.bmx[0].startoff = 17179869184
+u.bmx[0].startoff = 34359738368
+u.bmx[0].startoff = 68719476736
+u.bmx[0].startoff = 137438953472
+u.bmx[0].startoff = 274877906944
+u.bmx[0].startoff = 549755813888
+u.bmx[0].startoff = 1099511627776
+u.bmx[0].startoff = 2199023255552
+u.bmx[0].startoff = 4398046511104
+u.bmx[0].startoff = 8796093022208
+u.bmx[0].startoff = 17592186044416
+u.bmx[0].startoff = 35184372088832
+u.bmx[0].startoff = 70368744177664
+u.bmx[0].startoff = 140737488355328
+u.bmx[0].startoff = 281474976710656
+u.bmx[0].startoff = 562949953421312
+u.bmx[0].startoff = 1125899906842624
+u.bmx[0].startoff = 2251799813685248
+u.bmx[0].startoff = 4503599627370496
+u.bmx[0].startoff = 9007199254740992
+unable to convert value '18014398509481984'.
+
+testing u.bmx[0].startblock with 52 bits
+u.bmx[0].startblock = 0
+u.bmx[0].startblock = 1
+u.bmx[0].startblock = 2
+u.bmx[0].startblock = 4
+u.bmx[0].startblock = 8
+u.bmx[0].startblock = 16
+u.bmx[0].startblock = 32
+u.bmx[0].startblock = 64
+u.bmx[0].startblock = 128
+u.bmx[0].startblock = 256
+u.bmx[0].startblock = 512
+u.bmx[0].startblock = 1024
+u.bmx[0].startblock = 2048
+u.bmx[0].startblock = 4096
+u.bmx[0].startblock = 8192
+u.bmx[0].startblock = 16384
+u.bmx[0].startblock = 32768
+u.bmx[0].startblock = 65536
+u.bmx[0].startblock = 131072
+u.bmx[0].startblock = 262144
+u.bmx[0].startblock = 524288
+u.bmx[0].startblock = 1048576
+u.bmx[0].startblock = 2097152
+u.bmx[0].startblock = 4194304
+u.bmx[0].startblock = 8388608
+u.bmx[0].startblock = 16777216
+u.bmx[0].startblock = 33554432
+u.bmx[0].startblock = 67108864
+u.bmx[0].startblock = 134217728
+u.bmx[0].startblock = 268435456
+u.bmx[0].startblock = 536870912
+u.bmx[0].startblock = 1073741824
+u.bmx[0].startblock = 2147483648
+u.bmx[0].startblock = 4294967296
+u.bmx[0].startblock = 8589934592
+u.bmx[0].startblock = 17179869184
+u.bmx[0].startblock = 34359738368
+u.bmx[0].startblock = 68719476736
+u.bmx[0].startblock = 137438953472
+u.bmx[0].startblock = 274877906944
+u.bmx[0].startblock = 549755813888
+u.bmx[0].startblock = 1099511627776
+u.bmx[0].startblock = 2199023255552
+u.bmx[0].startblock = 4398046511104
+u.bmx[0].startblock = 8796093022208
+u.bmx[0].startblock = 17592186044416
+u.bmx[0].startblock = 35184372088832
+u.bmx[0].startblock = 70368744177664
+u.bmx[0].startblock = 140737488355328
+u.bmx[0].startblock = 281474976710656
+u.bmx[0].startblock = 562949953421312
+u.bmx[0].startblock = 1125899906842624
+u.bmx[0].startblock = 2251799813685248
+unable to convert value '4503599627370496'.
+
+testing u.bmx[0].blockcount with 21 bits
+u.bmx[0].blockcount = 0
+u.bmx[0].blockcount = 1
+u.bmx[0].blockcount = 2
+u.bmx[0].blockcount = 4
+u.bmx[0].blockcount = 8
+u.bmx[0].blockcount = 16
+u.bmx[0].blockcount = 32
+u.bmx[0].blockcount = 64
+u.bmx[0].blockcount = 128
+u.bmx[0].blockcount = 256
+u.bmx[0].blockcount = 512
+u.bmx[0].blockcount = 1024
+u.bmx[0].blockcount = 2048
+u.bmx[0].blockcount = 4096
+u.bmx[0].blockcount = 8192
+u.bmx[0].blockcount = 16384
+u.bmx[0].blockcount = 32768
+u.bmx[0].blockcount = 65536
+u.bmx[0].blockcount = 131072
+u.bmx[0].blockcount = 262144
+u.bmx[0].blockcount = 524288
+u.bmx[0].blockcount = 1048576
+unable to convert value '2097152'.
+
+core.gen = 90
+core.gen = 165
+core.gen = 0
Index: b/tests/xfs/group
===================================================================
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -186,3 +186,4 @@
 304 auto quick quota
 305 auto quota
 306 auto stress log metadata repair
+307 auto db quick


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
