Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B6D207F8B
	for <xfs@oss.sgi.com>; Fri,  2 Jan 2015 03:42:45 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A57C8304039
	for <xfs@oss.sgi.com>; Fri,  2 Jan 2015 01:42:45 -0800 (PST)
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24]) by
	cuda.sgi.com with ESMTP id YhpOhci8JLguyCBQ (version=TLSv1
	cipher=RC4-MD5 bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 02 Jan 2015 01:42:44 -0800 (PST)
Received: from epcpsbgr5.samsung.com
	(u145.gpu120.samsung.co.kr [203.254.230.145])
	by mailout1.samsung.com (Oracle Communications Messaging Server
	7u4-24.01 (7.0.4.24.0) 64bit (built Nov 17 2011))
	with ESMTP id <0NHJ00JBAMZ6MP00@mailout1.samsung.com> for
	xfs@oss.sgi.com; Fri, 02 Jan 2015 18:42:42 +0900 (KST)
From: Namjae Jeon <namjae.jeon@samsung.com>
Subject: [PATCH v7 9/11] xfstests: generic/043: Test multiple fallocate
	insert/collapse range calls
Date: Fri, 02 Jan 2015 18:42:41 +0900
Message-id: <004701d02670$73dcb0a0$5b9611e0$@samsung.com>
MIME-version: 1.0
Content-language: ko
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
To: Dave Chinner <david@fromorbit.com>, Theodore Ts'o <tytso@mit.edu>
Cc: Brian Foster <bfoster@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>

This testcase(043) tries to test finsert range a single alternate block
mulitiple times and test merge code of collase range.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Cc: Brian Foster <bfoster@redhat.com>
---
 tests/generic/043     | 107 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/043.out |   7 ++++
 tests/generic/group   |   1 +
 3 files changed, 115 insertions(+)
 create mode 100644 tests/generic/043
 create mode 100644 tests/generic/043.out

diff --git a/tests/generic/043 b/tests/generic/043
new file mode 100644
index 0000000..6aebc1e
--- /dev/null
+++ b/tests/generic/043
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. generic/043
+#
+# Test multiple fallocate insert/collapse range calls on same file.
+# For different blocksizes, Call insert range a single alternate block
+# multiple times until the file is left with 100 extents and as much
+# number of extents. And Call collapse range about the previously inserted
+# ranges to test merge code of collapse range.
+# Also check for file system consistency after completing this operation
+# for each blocksize.
+#-----------------------------------------------------------------------
+# Copyright (c) 2014 Samsung Electronics.  All Rights Reserved.
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
+#
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
+trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+
+_require_scratch
+_require_xfs_io_command "fiemap"
+_require_xfs_io_command "finsert"
+_require_xfs_io_command "fcollapse"
+_do_die_on_error=y
+testfile=$SCRATCH_MNT/$seq.$$
+BLOCKS=100
+
+for (( BSIZE = 1024; BSIZE <= 4096; BSIZE *= 2 )); do
+
+	length=$(($BLOCKS * $BSIZE))
+	case $FSTYP in
+	xfs)
+	_scratch_mkfs -b size=$BSIZE >> $seqres.full 2>&1
+	;;
+	ext4)
+	_scratch_mkfs -b $BSIZE >> $seqres.full 2>&1
+	;;
+	esac
+	_scratch_mount >> $seqres.full 2>&1
+
+	# Write file
+	$XFS_IO_PROG -f -c "pwrite 0 $length" -c fsync $testfile > /dev/null
+
+
+	# Insert alternate blocks 
+	for (( j=0; j < $(($BLOCKS/2)); j++ )); do
+		offset=$((($j*$BSIZE)*2))
+		$XFS_IO_PROG -c "finsert $offset $BSIZE" $testfile > /dev/null
+	done
+
+	# Check if 100 extents are present
+	$XFS_IO_PROG -c "fiemap -v" $testfile | grep "^ *[0-9]*:" |wc -l
+
+	_check_scratch_fs
+	if [ $? -ne 0 ]; then
+		status=1
+		exit
+	fi
+
+	# Collapse alternate blocks 
+	for (( j=0; j < $(($BLOCKS/2)); j++ )); do
+		offset=$((($j*$BSIZE)))
+		$XFS_IO_PROG -c "fcollapse $offset $BSIZE" $testfile > /dev/null
+	done
+
+	# Check if 1 extents are present
+	$XFS_IO_PROG -c "fiemap -v" $testfile | grep "^ *[0-9]*:" |wc -l
+
+	_check_scratch_fs
+	if [ $? -ne 0 ]; then
+		status=1
+		exit
+	fi
+
+	umount $SCRATCH_MNT
+done
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/043.out b/tests/generic/043.out
new file mode 100644
index 0000000..fd4b804
--- /dev/null
+++ b/tests/generic/043.out
@@ -0,0 +1,7 @@
+QA output created by 043
+100
+1
+100
+1
+100
+1
diff --git a/tests/generic/group b/tests/generic/group
index c0944b3..0a10bdd 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -45,6 +45,7 @@
 040 auto quick prealloc
 041 auto quick prealloc
 042 auto quick prealloc
+043 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.8.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
