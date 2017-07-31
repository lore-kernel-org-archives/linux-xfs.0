Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58206 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751784AbdGaNKD (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 31 Jul 2017 09:10:03 -0400
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH v3] generic: test read around EOF
Date: Mon, 31 Jul 2017 21:09:56 +0800
Message-Id: <20170731130956.30494-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: linux-xfs@vger.kernel.org

As posix standard, if the file offset is at or past the end of file,
no bytes are read, and read() returns zero.

This case reads from range within EOF, past EOF and at EOF, to make
sure the return value as expected, especially read from past/at EOF
returns 0.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

V3 did below changes:
1) Remove truncate/fallocate/resvsp/alloc operations, only leave pwrite.
2) Only test on sector size <= (block size / 4), generally that means
   512b sector size and 4k block size.
3) remove all unaligned test, due to ext4 and xfs got different results
   when read past EOF with unaligned offset/length. And I can get a pretty
   sure expected result for this situation.

For the 3rd situation (*unaligned* read from past EOF):
 - RHEL-7.3 ext4 return 0, xfs return error (known bug).
 - Upstream 4.13-rc1 ext4 return EINVAL, xfs return 0.

I can't find any standard explain how a unaligned read from past EOF should
be. So I decide to skip this gray area for now.

Thanks,
Zorro

 tests/generic/450     | 149 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/450.out |  11 ++++
 tests/generic/group   |   1 +
 3 files changed, 161 insertions(+)
 create mode 100755 tests/generic/450
 create mode 100644 tests/generic/450.out

diff --git a/tests/generic/450 b/tests/generic/450
new file mode 100755
index 00000000..0aa2e81c
--- /dev/null
+++ b/tests/generic/450
@@ -0,0 +1,149 @@
+#! /bin/bash
+# FS QA Test 450
+#
+# Test read around EOF. If the file offset is at or past the end of file,
+# no bytes are read, and read() returns zero.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017 Red Hat, Inc.  All Rights Reserved.
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
+	cd /
+	rm -f $tmp.*
+	rm -f $tfile
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_test
+
+tfile=$TEST_DIR/testfile_${seq}
+ssize=`_min_dio_alignment $TEST_DEV`
+bsize=`_get_block_size $TEST_DIR`
+
+if [ $ssize -gt $((bsize/4)) ]; then
+	_notrun "Only test on sector size < half of block size"
+fi
+
+rm -f $tfile 2>/dev/null
+
+# check xfs_io pread result, especially for
+# Param1: expected pread return
+# Param2: expected pread count
+# Param3: expected pread offset
+#
+# If any of above values are not as expected, the output keeps
+# using the real value
+check_xfs_io_read()
+{
+	RETURN=$1
+	COUNT=$2
+	OFFSET=$3
+
+	$AWK_PROG -v ret="$RETURN" -v cnt="$COUNT" -v off="$OFFSET" '
+		/read/{
+			split($2, bytes, "/")
+
+			retval=bytes[1]
+			count=bytes[2]
+			offset=$NF
+
+			if(retval != ret || count != cnt || offset != off)
+				printf("expect [%s, %s, %s], but get [%s, %s, %s]\n", ret, cnt, off, retval, count, offset)
+
+			next
+		}
+	'
+}
+
+# +-------------------------------------------------------+
+# |           block           |           block           |
+# +-------------------------------------------------------+
+# | sect | sect | sect | sect | sect | sect | sect | sect |
+#                                           |
+#                                          EOF
+# |<--------------- move EOF -------------->| xxxxxxxxxxx |
+# [pread1]
+#                             [           pread2          ]
+#                                           [pread3]
+#                                                  [pread4]  ...  [pread5]
+#
+# Run below steps with differnt $operation and $openflag
+#
+# 1) write 2 blocks (6 sectors) data to move EOF to the penultimate sector
+# 2) read (pread1) the first sector within EOF
+# 3) read (pread2) the second block contain EOF
+# 4) read (pread3) a sector at (after) EOF
+# 6) read (pread4) the last sector past EOF
+# 7) read (pread5) at far away from EOF
+#
+# NOTE: This case generally test on sector size < block size, but equal is fine
+#
+asize=$((bsize * 2))
+tsize=$((asize - ssize * 2))
+
+read_test()
+{
+	echo "## pread1 $oflag ##"
+	$XFS_IO_PROG $oflag -c "pread 0 $ssize" $tfile | \
+		check_xfs_io_read "$ssize" "$ssize" "0"
+
+	echo "## pread2 $oflag ##"
+	$XFS_IO_PROG $oflag -c "pread $bsize $bsize" $tfile | \
+		check_xfs_io_read "$((bsize - ssize * 2))" "$bsize" "$bsize"
+
+	echo "## pread3 $oflag ##"
+	$XFS_IO_PROG $oflag -c "pread $tsize $ssize" $tfile | \
+		check_xfs_io_read "0" "$ssize" "$tsize"
+
+	echo "## pread4 $oflag ##"
+	$XFS_IO_PROG $oflag -c "pread $((asize - ssize)) $ssize" $tfile | \
+		check_xfs_io_read "0" "$ssize" "$((asize - ssize))"
+
+	echo "## pread5 $oflag ##"
+	$XFS_IO_PROG $oflag -c "pread $((bsize * 100)) $ssize" $tfile | \
+		check_xfs_io_read "0" "$ssize" "$((bsize * 100))"
+}
+
+# Test buffer/direct I/O read
+for oflag in "" "-d"; do
+	$XFS_IO_PROG -ft -c "pwrite 0 ${tsize}" $tfile >>$seqres.full
+	read_test
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/450.out b/tests/generic/450.out
new file mode 100644
index 00000000..ce3571bc
--- /dev/null
+++ b/tests/generic/450.out
@@ -0,0 +1,11 @@
+QA output created by 450
+## pread1  ##
+## pread2  ##
+## pread3  ##
+## pread4  ##
+## pread5  ##
+## pread1 -d ##
+## pread2 -d ##
+## pread3 -d ##
+## pread4 -d ##
+## pread5 -d ##
diff --git a/tests/generic/group b/tests/generic/group
index a04cc900..0b29be0a 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -452,3 +452,4 @@
 447 auto quick clone
 448 auto quick rw
 449 auto quick acl enospc
+450 auto quick rw
-- 
2.13.3

