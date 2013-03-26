Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 81B4F7F5D
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 03:58:35 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id EB5A0AC001
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 01:58:34 -0700 (PDT)
Received: from mail-pb0-f49.google.com (mail-pb0-f49.google.com
	[209.85.160.49]) by cuda.sgi.com with ESMTP id xEyvsBhuL3YoRs1a
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 26 Mar 2013 01:58:33 -0700 (PDT)
Received: by mail-pb0-f49.google.com with SMTP id um15so876581pbc.8
	for <xfs@oss.sgi.com>; Tue, 26 Mar 2013 01:58:33 -0700 (PDT)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH] xfstests: add _require_seek_data_hole to check seek data/hole
Date: Tue, 26 Mar 2013 17:14:12 +0800
Message-Id: <1364289252-7012-1-git-send-email-wenqing.lz@taobao.com>
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
Cc: Zheng Liu <wenqing.lz@taobao.com>

From: Zheng Liu <wenqing.lz@taobao.com>

In xfstests 285 and 286 we don't check whether the target file system
supports seek data/hole operation or not.  Here _require_seek_data_hole
is defined to do this work.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 285                    |  1 +
 286                    |  2 ++
 common.rc              | 12 ++++++++++++
 src/seek_sanity_test.c | 19 ++++++++++++++-----
 4 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/285 b/285
index 8726b9e..4cad633 100644
--- a/285
+++ b/285
@@ -42,6 +42,7 @@ _supported_fs generic
 _supported_os Linux
 
 _require_xfs_io_falloc
+_require_seek_data_hole
 
 BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
 
diff --git a/286 b/286
index 9567244..6f34724 100644
--- a/286
+++ b/286
@@ -39,6 +39,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
+_require_seek_data_hole
+
 src=$TEST_DIR/seek_copy_testfile
 dest=$TEST_DIR/seek_copy_testfile.dest
 
diff --git a/common.rc b/common.rc
index 319680d..3c01211 100644
--- a/common.rc
+++ b/common.rc
@@ -1205,6 +1205,18 @@ _require_fail_make_request()
  not found. Seems that CONFIG_FAIL_MAKE_REQUEST kernel config option not enabled"
 }
 
+#
+# Check if the file system supports seek_data/hole.
+#
+_require_seek_data_hole()
+{
+	testfile=$TEST_DIR/$$.seek
+	testseek=`$here/src/seek_sanity_test -t $testfile 2>&1`
+	rm -f $testfile &>/dev/null
+	echo $testseek | grep -q "Kernel does not support" && \
+		_notrun "File system does not support llseek(2) SEEK_DATA/HOLE"
+}
+
 # check that a FS on a device is mounted
 # if so, return mount point
 #
diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index 3897f02..3b5217b 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -660,17 +660,26 @@ int main(int argc, char **argv)
 {
 	int ret = -1;
 	int i = 0;
+	int opt;
+	int check_support = 0;
 	int numtests = sizeof(seek_tests) / sizeof(struct testrec);
 
-	if (argc != 2) {
-		fprintf(stdout, "Usage: %s base_file_path\n", argv[0]);
-		return ret;
+	while ((opt = getopt(argc, argv, "t")) != -1) {
+		switch (opt) {
+		case 't':
+			check_support++;
+			break;
+		default:
+			fprintf(stdout, "Usage: %s [-t] base_file_path\n",
+				argv[0]);
+			return ret;
+		}
 	}
 
-	base_file_path = (char *)strdup(argv[1]);
+	base_file_path = (char *)strdup(argv[optind]);
 
 	ret = test_basic_support();
-	if (ret)
+	if (ret || check_support)
 		goto out;
 
 	for (i = 0; i < numtests; ++i) {
-- 
1.7.12.rc2.18.g61b472e

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
