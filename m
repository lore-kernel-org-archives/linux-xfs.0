Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24867 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752478AbdGMTGq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 13 Jul 2017 15:06:46 -0400
Date: Thu, 13 Jul 2017 12:06:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] generic: test negative SEEK_HOLE/SEEK_DATA offsets
Message-ID: <20170713190641.GA4150@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, xfs <linux-xfs@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, fstests <fstests@vger.kernel.org>

Check that we get -ENXIO if the user calls SEEK_HOLE/SEEK_DATA with
a negative file offset.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
v2: use helpers as suggested by Eryu.
---
 src/seek_sanity_test.c |   13 +++++++++
 tests/generic/702      |   70 ++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/702.out  |    2 +
 tests/generic/group    |    1 +
 4 files changed, 86 insertions(+)
 create mode 100755 tests/generic/702
 create mode 100644 tests/generic/702.out

diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index a58ec36..e82cb1f 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -274,6 +274,18 @@ static int huge_file_test(int fd, int testnum, off_t filsz)
 	return ret;
 }
 
+/* Make sure we get ENXIO if we pass in a negative offset. */
+static int test18(int fd, int testnum)
+{
+	int ret = 0;
+
+	/* file size doesn't matter in this test, set to 0 */
+	ret += do_lseek(testnum, 1, fd, 0, SEEK_HOLE, -1, -1);
+	ret += do_lseek(testnum, 2, fd, 0, SEEK_DATA, -1, -1);
+
+	return ret;
+}
+
 static int test17(int fd, int testnum)
 {
 	char *buf = NULL;
@@ -969,6 +981,7 @@ struct testrec seek_tests[] = {
        { 15, test15, "Test file with unwritten extents, page after unwritten extent" },
        { 16, test16, "Test file with unwritten extents, non-contiguous dirty pages" },
        { 17, test17, "Test file with unwritten extents, data-hole-data inside page" },
+       { 18, test18, "Test file with negative SEEK_{HOLE,DATA} offsets" },
 };
 
 static int run_test(struct testrec *tr)
diff --git a/tests/generic/702 b/tests/generic/702
new file mode 100755
index 0000000..d251c39
--- /dev/null
+++ b/tests/generic/702
@@ -0,0 +1,70 @@
+#! /bin/bash
+# FS QA Test No. 702
+#
+# Check what happens when SEEK_HOLE/SEEK_DATA are fed negative offsets.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2017, Oracle and/or its affiliates.  All Rights Reserved.
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
+
+seq=`basename "$0"`
+seqres="$RESULT_DIR/$seq"
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1    # failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+    cd /
+    rm -rf "$tmp".* $testdir/file1
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+
+_supported_fs generic
+_supported_os Linux
+
+_require_test
+_require_seek_data_hole
+
+BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
+
+_require_test_program "seek_sanity_test"
+
+# Disable extent zeroing for ext4 as that change where holes are created
+if [ "$FSTYP" = "ext4" ]; then
+	DEV=`_short_dev $TEST_DEV`
+	echo 0 >/sys/fs/ext4/$DEV/extent_max_zeroout_kb
+fi
+
+_cleanup()
+{
+	rm -f $tmp.* $BASE_TEST_FILE.*
+}
+
+$here/src/seek_sanity_test -s 18 -e 18 $BASE_TEST_FILE > $seqres.full 2>&1 ||
+	_fail "seek sanity check failed!"
+
+_check_dmesg
+# success, all done
+echo "Silence is golden"
+status=0
+exit
diff --git a/tests/generic/702.out b/tests/generic/702.out
new file mode 100644
index 0000000..608d593
--- /dev/null
+++ b/tests/generic/702.out
@@ -0,0 +1,2 @@
+QA output created by 702
+Silence is golden
diff --git a/tests/generic/group b/tests/generic/group
index 3c5a19c..6afd402 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -449,4 +449,5 @@
 444 auto quick acl
 445 auto quick rw
 446 auto quick rw dangerous
+702 auto quick rw
 931 auto quick clone
