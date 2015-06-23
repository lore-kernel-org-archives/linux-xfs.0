Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 053D47F54
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2015 11:47:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 687B58F8033
	for <xfs@oss.sgi.com>; Tue, 23 Jun 2015 09:47:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FmZKmaR103HEgzKY (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 23 Jun 2015 09:47:27 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfstests: generic xattr enospc cleanup test
Date: Tue, 23 Jun 2015 12:47:24 -0400
Message-Id: <1435078044-21679-1-git-send-email-bfoster@redhat.com>
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
To: fstests@vger.kernel.org
Cc: xfs@oss.sgi.com

XFS had a regression where inode reclaim in the unlink codepath would
not correctly tear down extended attribute forks where no xattr extents
are present. Add a generic test to create this condition.

The test sets extended attributes on a series of files under ENOSPC
conditions and then verifies that the files can be removed without
syslog warnings or errors.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 tests/generic/103     | 91 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/103.out |  2 ++
 tests/generic/group   |  1 +
 3 files changed, 94 insertions(+)
 create mode 100755 tests/generic/103
 create mode 100644 tests/generic/103.out

diff --git a/tests/generic/103 b/tests/generic/103
new file mode 100755
index 0000000..373cd9d
--- /dev/null
+++ b/tests/generic/103
@@ -0,0 +1,91 @@
+#! /bin/bash
+# FSQA Test No. 103
+#
+# Test attribute fork teardown. This test is inspired by a regression in XFS
+# that resulted in problematic removal of inodes with remote attribute forks
+# without attribute extents. The attribute fork condition is created by
+# attempting to set larger attribute values on a filesystem that is at or near
+# ENOSPC.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2015 Red Hat, Inc.  All Rights Reserved.
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
+_cleanup()
+{
+        cd /
+        rm -f $tmp.*
+}
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15 25
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/attr
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch
+_require_attrs
+
+rm -f $seqres.full
+
+_consume_freesp()
+{
+	file=$1
+
+	# consume nearly all available space (leave ~512kB)
+	avail=`_get_available_space $SCRATCH_MNT`
+	filesizekb=$((avail / 1024 - 512))
+	$XFS_IO_PROG -fc "falloc 0 ${filesizekb}k" $file
+}
+
+_scratch_mkfs >> $seqres.full 2>&1
+_scratch_mount
+
+for i in $(seq 0 63); do
+	touch $SCRATCH_MNT/$seq.$i
+done
+
+# Generate a large attribute value and consume the rest of the space in the
+# filesystem.
+$XFS_IO_PROG -fc "pwrite 0 64k" $SCRATCH_MNT/attrval > /dev/null 2>&1
+_consume_freesp $SCRATCH_MNT/spc
+
+# Set attributes on the test files. These should start to hit ENOSPC.
+for i in $(seq 0 63); do
+	$SETFATTR_PROG -n user.test -v "`cat $SCRATCH_MNT/attrval`" \
+		$SCRATCH_MNT/$seq.$i >> $seqres.full 2>&1
+done
+
+# Remove the files with attributes to test attribute fork teardown. Problems
+# result in dmesg output.
+rm -f $SCRATCH_MNT/$seq.*
+
+echo Silence is golden.
+
+status=0
+exit
diff --git a/tests/generic/103.out b/tests/generic/103.out
new file mode 100644
index 0000000..ce229bf
--- /dev/null
+++ b/tests/generic/103.out
@@ -0,0 +1,2 @@
+QA output created by 103
+Silence is golden.
diff --git a/tests/generic/group b/tests/generic/group
index 0c8964c..41f3039 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -98,6 +98,7 @@
 097 udf auto
 099 udf auto
 100 udf auto
+103 auto enospc quick
 105 acl auto quick
 112 rw aio auto quick
 113 rw aio auto quick
-- 
1.9.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
