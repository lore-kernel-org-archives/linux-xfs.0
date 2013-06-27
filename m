Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5D9FD7F52
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 11:03:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4B2548F8035
	for <xfs@oss.sgi.com>; Thu, 27 Jun 2013 09:03:43 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id EH8WvFFcHPJuk0d6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 27 Jun 2013 09:03:42 -0700 (PDT)
Date: Thu, 27 Jun 2013 12:03:34 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH 2/3] xfstests 313: user namespace uid/gids in an inode
Message-ID: <20130627120334.0c4de386@oracle.com>
In-Reply-To: <20130626010931.GA29376@dastard>
References: <20130625153443.08142635@oracle.com>
	<20130626010931.GA29376@dastard>
Mime-Version: 1.0
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 tests/generic/313     | 107 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/313.out |  20 ++++++++++
 tests/generic/group   |   1 +
 3 files changed, 128 insertions(+)
 create mode 100644 tests/generic/313
 create mode 100644 tests/generic/313.out

diff --git a/tests/generic/313 b/tests/generic/313
new file mode 100644
index 0000000..0dd6213
--- /dev/null
+++ b/tests/generic/313
@@ -0,0 +1,107 @@
+#! /bin/bash
+# FS QA Test No. 313
+#
+# Check uid/gid to/from disk with a user namespace. A new file
+# will be created from inside a userns. We check that the uid/gid
+# is correct from both inside the userns and also from init_user_ns.
+# We will then unmount and remount the file system and check the
+# uid/gid from both inside the userns and from init_user_ns to show
+# that the correct uid was flushed and brought back from disk.
+#
+#-----------------------------------------------------------------------
+# Copyright (C) 2013 Oracle, Inc.  All Rights Reserved.
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
+
+_cleanup()
+{
+    cd /
+    umount $SCRATCH_DEV >/dev/null 2>&1
+}
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/attr
+
+nsexec=$here/src/nsexec
+lstat64=$here/src/lstat64
+file=$SCRATCH_MNT/file1
+
+# real QA test starts here
+_supported_fs generic
+# only Linux supports user namespace
+_supported_os Linux
+
+[ -x $nsexec  ] || _notrun "$nsexec executable not found"
+[ -x $lstat64 ] || _notrun "$lstat64 executable not found"
+
+rm -f $seqres.full
+
+_require_scratch
+_need_to_be_root
+_require_user
+qa_user_id=`grep $qa_user /etc/passwd |awk -F: '{print $3}'`
+
+_filter_output()
+{
+    sed \
+      -e "s/$qa_user_id/qa_user/g" \
+      -e "s!$SCRATCH_MNT!\$SCRATCH_MNT!"
+}
+
+_print_numeric_uid()
+{
+    echo "From init_user_ns"
+    $here/src/lstat64 $file |head -3 |_filter_output
+
+    echo "From user_ns"
+    $nsexec -s -U -M "0 $qa_user_id 1000" -G "0 $qa_user_id 1000" $here/src/lstat64 $file |head -3 |_filter_output
+}
+
+umount $SCRATCH_DEV >/dev/null 2>&1
+echo "*** MKFS ***" >>$seqres.full
+echo ""             >>$seqres.full
+_scratch_mkfs       >>$seqres.full 2>&1 || _fail "mkfs failed"
+_scratch_mount      >>$seqres.full 2>&1 || _fail "mount failed"
+chmod 777 $SCRATCH_MNT
+
+# create $file as "root" in userns, which is $qa_user in parent namespace
+$nsexec -s -U -M "0 $qa_user_id 1000" -G "0 $qa_user_id 1000" touch $file
+
+_print_numeric_uid
+
+echo ""
+echo "*** Remounting ***"
+echo ""
+sync
+umount $SCRATCH_MNT >>$seqres.full 2>&1
+_scratch_mount      >>$seqres.full 2>&1 || _fail "mount failed"
+
+_print_numeric_uid
+
+umount $SCRATCH_DEV >/dev/null 2>&1
+status=0
+exit
diff --git a/tests/generic/313.out b/tests/generic/313.out
new file mode 100644
index 0000000..eab14c4
--- /dev/null
+++ b/tests/generic/313.out
@@ -0,0 +1,20 @@
+QA output created by 313
+From init_user_ns
+  File: "$SCRATCH_MNT/file1"
+  Size: 0            Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (qa_user)  Gid: (qa_user)
+From user_ns
+  File: "$SCRATCH_MNT/file1"
+  Size: 0            Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (0)  Gid: (0)
+
+*** Remounting ***
+
+From init_user_ns
+  File: "$SCRATCH_MNT/file1"
+  Size: 0            Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (qa_user)  Gid: (qa_user)
+From user_ns
+  File: "$SCRATCH_MNT/file1"
+  Size: 0            Filetype: Regular File
+  Mode: (0644/-rw-r--r--)         Uid: (0)  Gid: (0)
diff --git a/tests/generic/group b/tests/generic/group
index bd443c1..5c2b4d7 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -115,3 +115,4 @@
 310 auto
 311 auto metadata log
 312 auto quick prealloc enospc
+313 auto metadata quick
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
