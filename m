Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id C97127F50
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 09:14:19 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 8D3AF304032
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 07:14:19 -0800 (PST)
Received: from mail-pd0-f175.google.com (mail-pd0-f175.google.com
	[209.85.192.175]) by cuda.sgi.com with ESMTP id
	bBEABz6yMBjTOJ7q (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Wed, 21 Jan 2015 07:14:18 -0800 (PST)
Received: by mail-pd0-f175.google.com with SMTP id fl12so17352739pdb.6
	for <xfs@oss.sgi.com>; Wed, 21 Jan 2015 07:14:18 -0800 (PST)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v9 9/11] xfstests: generic/043: Test multiple fallocate
	insert/collapse range calls
Date: Thu, 22 Jan 2015 00:12:04 +0900
Message-Id: <1421853126-4505-10-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1421853126-4505-1-git-send-email-linkinjeon@gmail.com>
References: <1421853126-4505-1-git-send-email-linkinjeon@gmail.com>
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
To: david@fromorbit.com, tytso@mit.edu
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, bfoster@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This testcase(043) tries to test finsert range a single alternate block
multiple times and test merge code of collase range.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
Changelog
v9:
 - check that mkfs and mount succeed.
 - check extent_before and extent_after instead of hardcode 1.
 - remove umount.

v8:
 - use MKFS_OPTION to use blocksize in configuration and remove loop.
 - remove trailing space.
 - compare original file and test file to check data integrity.

 tests/generic/043     |   96 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/043.out |    2 ++
 tests/generic/group   |    1 +
 3 files changed, 99 insertions(+)
 create mode 100644 tests/generic/043
 create mode 100644 tests/generic/043.out

diff --git a/tests/generic/043 b/tests/generic/043
new file mode 100644
index 0000000..a6f91ce
--- /dev/null
+++ b/tests/generic/043
@@ -0,0 +1,96 @@
+#! /bin/bash
+# FS QA Test No. generic/043
+#
+# Test multiple fallocate insert/collapse range calls on same file.
+# Call insert range a single alternate block multiple times until the file
+# is left with 100 extents and as much number of extents. And Call collapse
+# range about the previously inserted ranges to test merge code of collapse
+# range. Also check for data integrity and file system consistency.
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
+_do_die_on_error=always
+src=$SCRATCH_MNT/testfile
+dest=$SCRATCH_MNT/testfile.dest
+BLOCKS=100
+BSIZE=`get_block_size $SCRATCH_MNT`
+rm -f $seqres.full
+
+_scratch_mkfs >> $seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount || _fail "mount failed"
+length=$(($BLOCKS * $BSIZE))
+
+# Write file
+_do "$XFS_IO_PROG -f -c \"pwrite 0 $length\" -c fsync $src"
+cp $src $dest
+extent_before=`$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l`
+
+# Insert alternate blocks
+for (( j=0; j < $(($BLOCKS/2)); j++ )); do
+	offset=$((($j*$BSIZE)*2))
+	_do "$XFS_IO_PROG -c \"finsert $offset $BSIZE\" $dest"
+done
+
+# Check if 100 extents are present
+$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l
+
+_check_scratch_fs
+if [ $? -ne 0 ]; then
+	status=1
+	exit
+fi
+
+# Collapse alternate blocks
+for (( j=0; j < $(($BLOCKS/2)); j++ )); do
+	offset=$((($j*$BSIZE)))
+	_do "$XFS_IO_PROG -c \"fcollapse $offset $BSIZE\" $dest"
+done
+
+extent_after=`$XFS_IO_PROG -c "fiemap -v" $dest | grep "^ *[0-9]*:" |wc -l`
+if [ $extent_before -ne $extent_after ]; then
+	echo "extents mismatched before = $extent_before after = $extent_after"
+fi
+
+# compare original file and test file.
+cmp $src $dest || _fail "file bytes check failed"
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/043.out b/tests/generic/043.out
new file mode 100644
index 0000000..28427c5
--- /dev/null
+++ b/tests/generic/043.out
@@ -0,0 +1,2 @@
+QA output created by 043
+100
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
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
