Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 1FE2C7F52
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 17:10:11 -0600 (CST)
Received: from eagdhcp-232-208.americas.sgi.com
	(eagdhcp-232-208.americas.sgi.com [128.162.232.208])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 948A0AC00B
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 15:10:07 -0800 (PST)
Received: from eagdhcp-232-208.americas.sgi.com (localhost [127.0.0.1])
	by eagdhcp-232-208.americas.sgi.com (8.14.5/8.14.5) with ESMTP id
	s1ANA9KY003109
	for <xfs@oss.sgi.com>; Mon, 10 Feb 2014 17:10:09 -0600 (CST)
	(envelope-from tinguely@eagdhcp-232-208.americas.sgi.com)
Message-Id: <20140210231046.910977175@sgi.com>
Date: Mon, 10 Feb 2014 17:10:43 -0600
From: Mark Tinguely <tinguely@sgi.com>
Subject: [PATCH] xfstests: test setting XFS BMBT fields
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
bit values for each field. Also test the value past the last legal
value.

Additionally, ensures setting a core entry (core.gen is used) is
still correct. Test that the hex (#HH) input on a BMBT field and a
core entry are also correct.

Signed-off-by: Mark Tinguely <tinguely@sgi.com>
---
 tests/xfs/307     |  112 +++++++++++++++++++++++++++++++++++++++
 tests/xfs/307.out |  152 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/group   |    1 
 3 files changed, 265 insertions(+)

Index: b/tests/xfs/307
===================================================================
--- /dev/null
+++ b/tests/xfs/307
@@ -0,0 +1,112 @@
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
+	_field="$1"
+	_bits="$2"
+
+	echo "testing ${_field} ${_bits} bits" | sed 's/u3/u/'
+	$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write ${_field} 0" \
+			  $SCRATCH_DEV | sed 's/u3/u/'
+	num=1
+	for n in `seq 0 1 ${_bits}`; do
+		$XFS_DB_PROG -x -c "inode $FILE_INO"  \
+			  -c "write ${_field} ${num}" \
+			  $SCRATCH_DEV | sed 's/u3/u/'
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
+echo "test file" > $SCRATCH_MNT/testfile
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
+# Which version of the filesystem?
+echo $XFS_MKFS_OPTIONS | grep "crc=1" > /dev/null
+if [ $? == 1 ]; then
+ prefix="u"
+else
+ prefix="u3"
+fi
+
+# test setting the BMBT entries from 0 to past the valid number.
+_do_bit_test "$prefix.bmx[0].extentflag" $BMBT_EXNTFLAG_BITLEN
+_do_bit_test "$prefix.bmx[0].startoff" $BMBT_STARTOFF_BITLEN
+_do_bit_test "$prefix.bmx[0].startblock" $BMBT_STARTBLOCK_BITLEN
+_do_bit_test "$prefix.bmx[0].blockcount" $BMBT_BLOCKCOUNT_BITLEN
+# test setting the 32 bit generation number
+$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen 0x5a" $SCRATCH_DEV
+$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen 0xa5" $SCRATCH_DEV
+$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen 0" $SCRATCH_DEV
+# test setting the entry using #HH hex
+$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write $prefix.bmx[0].startoff #573a" \
+		$SCRATCH_DEV | sed 's/u3/u/'
+$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write $prefix.bmx[0].startoff #a573" \
+		$SCRATCH_DEV | sed 's/u3/u/'
+$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen #185a" $SCRATCH_DEV
+$XFS_DB_PROG -x -c "inode $FILE_INO" -c "write core.gen #a518" $SCRATCH_DEV
+status=0
+exit
Index: b/tests/xfs/307.out
===================================================================
--- /dev/null
+++ b/tests/xfs/307.out
@@ -0,0 +1,152 @@
+QA output created by 307
+testing u.bmx[0].extentflag 1 bits
+u.bmx[0].extentflag = 0
+u.bmx[0].extentflag = 1
+unable to convert value '2'.
+
+testing u.bmx[0].startoff 54 bits
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
+testing u.bmx[0].startblock 52 bits
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
+testing u.bmx[0].blockcount 21 bits
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
+u.bmx[0].startoff = 22330
+u.bmx[0].startoff = 42355
+core.gen = 6234
+core.gen = 42264
Index: b/tests/xfs/group
===================================================================
--- a/tests/xfs/group
+++ b/tests/xfs/group
@@ -186,3 +186,4 @@
 304 auto quick quota
 305 auto quota
 306 auto stress log metadata repair
+307 auto db


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
