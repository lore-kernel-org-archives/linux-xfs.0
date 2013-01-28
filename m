Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B89397F4C
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 01:20:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7B7BD30405F
	for <xfs@oss.sgi.com>; Sun, 27 Jan 2013 23:20:44 -0800 (PST)
Received: from mail-pa0-f46.google.com (mail-pa0-f46.google.com
	[209.85.220.46]) by cuda.sgi.com with ESMTP id 01x8cg10BEflFmAJ
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 27 Jan 2013 23:20:43 -0800 (PST)
Received: by mail-pa0-f46.google.com with SMTP id kp14so1341146pab.19
	for <xfs@oss.sgi.com>; Sun, 27 Jan 2013 23:20:42 -0800 (PST)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 4/4] xfstests: 296: add a seek data/hole test w/o unwritten
	extent
Date: Mon, 28 Jan 2013 15:32:51 +0800
Message-Id: <1359358371-21411-5-git-send-email-wenqing.lz@taobao.com>
In-Reply-To: <1359358371-21411-1-git-send-email-wenqing.lz@taobao.com>
References: <1359358371-21411-1-git-send-email-wenqing.lz@taobao.com>
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
To: xfs@oss.sgi.com, linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>

From: Zheng Liu <wenqing.lz@taobao.com>

Now ext4 has supported seek data/hole w/o unwritten extent.  This commit
creates a new test case to do seek data/hole sanity test w/o unwritten
extent.  All file systems that support seek_data/hole should survive
after running this test.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Dave Chinner <david@fromorbit.com>
---
 296                    | 57 ++++++++++++++++++++++++++++++++++++++++++++++++++
 296.out                |  1 +
 group                  |  1 +
 src/seek_sanity_test.c | 30 +++++++++++++++++++++-----
 4 files changed, 84 insertions(+), 5 deletions(-)
 create mode 100755 296
 create mode 100644 296.out

diff --git a/296 b/296
new file mode 100755
index 0000000..8a49a0f
--- /dev/null
+++ b/296
@@ -0,0 +1,57 @@
+#! /bin/bash
+# FS QA Test No. 296
+#
+# SEEK_DATA/SEEK_HOLE sanity test w/o unwritten extent.
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2013 Alibaba Group.  All Rights Reserved.
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
+# creator
+owner=wenqing.lz@taobao.com
+
+seq=`basename $0`
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	eval "rm -f $BASE_TEST_FILE.*"
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+_supported_fs generic
+_supported_os IRIX Linux
+
+_require_seek_data_hole
+
+BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
+
+[ -x $here/src/seek_sanity_test ] || _notrun "seek_sanity_tester not built"
+
+$here/src/seek_sanity_test -u $BASE_TEST_FILE > $seq.full 2>&1 ||
+	_fail "seek sanity check failed!"
+
+# success, all done
+status=0
+exit
diff --git a/296.out b/296.out
new file mode 100644
index 0000000..7921f57
--- /dev/null
+++ b/296.out
@@ -0,0 +1 @@
+QA output created by 296
diff --git a/group b/group
index a07d7f3..3019924 100644
--- a/group
+++ b/group
@@ -414,3 +414,4 @@ deprecated
 293 auto quick
 294 auto quick
 295 auto quick prealloc
+296 auto rw
diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index b1ef006..bfa5e52 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -567,7 +567,16 @@ struct testrec {
        char    *test_desc;
 };
 
-struct testrec seek_tests[] = {
+struct testrec no_unwritten_seek_tests[] = {
+       {  1, test01, "Test empty file" },
+       {  2, test02, "Test a tiny full file" },
+       {  3, test03, "Test a larger full file" },
+       {  4, test04, "Test file hole at beg, data at end" },
+       {  5, test05, "Test file data at beg, hole at end" },
+       {  6, test06, "Test file hole data hole data" },
+};
+
+struct testrec full_seek_tests[] = {
        {  1, test01, "Test empty file" },
        {  2, test02, "Test a tiny full file" },
        {  3, test03, "Test a larger full file" },
@@ -662,15 +671,20 @@ int main(int argc, char **argv)
 	int i = 0;
 	int opt;
 	int check_support = 0;
-	int numtests = sizeof(seek_tests) / sizeof(struct testrec);
+	int dont_unwritten = 0;
+	int numtests = sizeof(full_seek_tests) / sizeof(struct testrec);
+	struct testrec *tests = full_seek_tests;
 
-	while ((opt = getopt(argc, argv, "t")) != -1) {
+	while ((opt = getopt(argc, argv, "tu")) != -1) {
 		switch (opt) {
 		case 't':
 			check_support++;
 			break;
+		case 'u':
+			dont_unwritten++;
+			break;
 		default:
-			fprintf(stdout, "Usage: %s [-t] base_file_path\n", argv[0]);
+			fprintf(stdout, "Usage: %s [-tu] base_file_path\n", argv[0]);
 			return ret;
 		}
 	}
@@ -681,8 +695,14 @@ int main(int argc, char **argv)
 	if (ret || check_support)
 		goto out;
 
+	if (dont_unwritten) {
+		numtests = sizeof(no_unwritten_seek_tests) /
+				sizeof(struct testrec);
+		tests = no_unwritten_seek_tests;
+	}
+
 	for (i = 0; i < numtests; ++i) {
-		ret = run_test(&seek_tests[i]);
+		ret = run_test(&tests[i]);
 		if (ret)
 			break;
 	}
-- 
1.7.12.rc2.18.g61b472e

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
