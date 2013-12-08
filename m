Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 2BB517F94
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 08:01:56 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F3B0C304062
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 06:01:55 -0800 (PST)
Received: from mail-pd0-f175.google.com (mail-pd0-f175.google.com
	[209.85.192.175]) by cuda.sgi.com with ESMTP id
	HAUEl6qy8uhGepGl (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 08 Dec 2013 06:01:51 -0800 (PST)
Received: by mail-pd0-f175.google.com with SMTP id w10so3637161pde.20
	for <xfs@oss.sgi.com>; Sun, 08 Dec 2013 06:01:51 -0800 (PST)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v4 9/10] xfstest: shared/005: Test multiple fallocate collapse
Date: Sun,  8 Dec 2013 23:01:44 +0900
Message-Id: <1386511304-3557-1-git-send-email-linkinjeon@gmail.com>
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
To: viro@zeniv.linux.org.uk, dchinner@fromorbit.com, bpm@sgi.com, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

We execute collapse range multiple times on same file.
Each collapse range call collapses a single alternate block.
After the test execution, file will be left with 80 blocks and
as much number of extents.
We also check for file system consistency after the completion.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 tests/shared/005     |   90 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/shared/005.out |    4 +++
 tests/shared/group   |    1 +
 3 files changed, 95 insertions(+)
 create mode 100644 tests/shared/005
 create mode 100644 tests/shared/005.out

diff --git a/tests/shared/005 b/tests/shared/005
new file mode 100644
index 0000000..1347e7f
--- /dev/null
+++ b/tests/shared/005
@@ -0,0 +1,90 @@
+#! /bin/bash
+# FS QA Test No. 5
+#
+# Test multiple fallocate collapse range calls on same file.
+# For different blocksizes, collapse a single alternate block multiple times
+# until the file is left with 80 blocks and as much number of extents.
+# Also check for file system consistency after completing this operation
+# for each blocksize.
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Samsung Electronics.  All Rights Reserved.
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
+_supported_fs xfs ext4
+_supported_os Linux
+
+_require_scratch
+_require_xfs_io_fiemap
+_require_xfs_io_falloc_collapse
+_do_die_on_error=y
+testfile=$SCRATCH_MNT/$seq.$$
+BLOCKS=10240
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
+	# Collapse alternate blocks 
+	for (( i = 1; i <= 7; i++ )); do
+		for (( j=0; j < $(($BLOCKS/(2**$i))); j++ )); do
+			offset=$(($j*$BSIZE))
+			$XFS_IO_PROG -c "fcollapse $offset $BSIZE" $testfile > /dev/null
+		done
+	done
+
+	# Check if 80 extents are present
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
diff --git a/tests/shared/005.out b/tests/shared/005.out
new file mode 100644
index 0000000..8d30b9d
--- /dev/null
+++ b/tests/shared/005.out
@@ -0,0 +1,4 @@
+QA output created by 005
+80
+80
+80
diff --git a/tests/shared/group b/tests/shared/group
index fb1d6d0..22f1d3a 100644
--- a/tests/shared/group
+++ b/tests/shared/group
@@ -7,6 +7,7 @@
 002 auto prealloc
 003 auto prealloc
 004 auto prealloc
+005 auto prealloc
 032 mkfs auto quick
 051 acl udf auto quick
 218 auto fsr quick
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
