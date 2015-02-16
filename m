Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 81A757F62
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 09:49:36 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 44ADF304062
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 07:49:36 -0800 (PST)
Received: from mail-pd0-f173.google.com (mail-pd0-f173.google.com
	[209.85.192.173]) by cuda.sgi.com with ESMTP id
	hpUbYWYinfFKGPD0 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Feb 2015 07:49:30 -0800 (PST)
Received: by pdjg10 with SMTP id g10so36816470pdj.1
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 07:49:30 -0800 (PST)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH RESEND 9/12] xfstests: generic/046: Test multiple fallocate
	insert/collapse range calls
Date: Tue, 17 Feb 2015 00:47:56 +0900
Message-Id: <1424101680-3301-10-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1424101680-3301-1-git-send-email-linkinjeon@gmail.com>
References: <1424101680-3301-1-git-send-email-linkinjeon@gmail.com>
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
Cc: linux-man@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-api@vger.kernel.org, bfoster@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, mtk.manpages@gmail.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

This testcase(043) tries to test finsert range a single alternate block
multiple times and test merge code of collase range.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 tests/generic/046     |   95 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/046.out |    2 ++
 tests/generic/group   |    1 +
 3 files changed, 98 insertions(+)
 create mode 100644 tests/generic/046
 create mode 100644 tests/generic/046.out

diff --git a/tests/generic/046 b/tests/generic/046
new file mode 100644
index 0000000..5d036e0
--- /dev/null
+++ b/tests/generic/046
@@ -0,0 +1,95 @@
+#! /bin/bash
+# FS QA Test No. generic/046
+#
+# Test multiple fallocate insert/collapse range calls on same file.
+# Call insert range a single alternate block multiple times until the file
+# is left with 100 extents and as much number of extents. And Call collapse
+# range about the previously inserted ranges to test merge code of collapse
+# range. Also check for data integrity and file system consistency.
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Samsung Electronics.  All Rights Reserved.
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
diff --git a/tests/generic/046.out b/tests/generic/046.out
new file mode 100644
index 0000000..2a6a862
--- /dev/null
+++ b/tests/generic/046.out
@@ -0,0 +1,2 @@
+QA output created by 046
+100
diff --git a/tests/generic/group b/tests/generic/group
index 772f910..75e567e 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -48,6 +48,7 @@
 043 auto quick prealloc
 044 auto quick prealloc
 045 auto quick prealloc
+046 auto quick prealloc
 053 acl repair auto quick
 062 attr udf auto quick
 068 other auto freeze dangerous stress
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
