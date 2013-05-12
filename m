Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8A41E7F37
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 04:06:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 20716AC001
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 02:06:49 -0700 (PDT)
Received: from mail-pd0-f177.google.com (mail-pd0-f177.google.com
	[209.85.192.177]) by cuda.sgi.com with ESMTP id
	EWgqTcyqGGlJFwdk (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sun, 12 May 2013 02:06:48 -0700 (PDT)
Received: by mail-pd0-f177.google.com with SMTP id g10so3685910pdj.22
	for <xfs@oss.sgi.com>; Sun, 12 May 2013 02:06:47 -0700 (PDT)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH v2] xfstests: add _require_seek_data_hole to check seek
	data/hole
Date: Sun, 12 May 2013 17:24:30 +0800
Message-Id: <1368350670-9499-1-git-send-email-wenqing.lz@taobao.com>
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
Cc: Rich Johnston <rjohnston@sgi.com>, Zheng Liu <wenqing.lz@taobao.com>

From: Zheng Liu <wenqing.lz@taobao.com>

In xfstest 285/286 we don't check whether the target file system
supports seek data/hole operation or not.  Here _require_seek_data_hole
is defined to do this work.

Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: Rich Johnston <rjohnston@sgi.com>
---
changelog:
 * rebase against the latest master branch of xfstests tree

Hi Rich,

Sorry for the late.  Could you please look at this patch?

Thanks,
						- Zheng

 common/rc              | 12 ++++++++++++
 src/seek_sanity_test.c | 18 ++++++++++++++++--
 tests/generic/285      |  2 ++
 tests/generic/286      |  2 ++
 4 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/common/rc b/common/rc
index f97924a..f24a6aa 100644
--- a/common/rc
+++ b/common/rc
@@ -1283,6 +1283,18 @@ _require_fail_make_request()
  not found. Seems that CONFIG_FAIL_MAKE_REQUEST kernel config option not enabled"
 }
 
+#
+# Check if the file system supports seek_data/hole
+#
+_require_seek_data_hole()
+{
+    testfile=$TEST_DIR/$$.seek
+    testseek=`$here/src/seek_sanity_test -t $testfile 2>&1`
+    rm -f $testfile &>/dev/null
+    echo $testseek | grep -q "Kernel does not support" && \
+        _notrun "File system does not support llseek(2) SEEK_DATA/HOLE"
+}
+
 # check that a FS on a device is mounted
 # if so, return mount point
 #
diff --git a/src/seek_sanity_test.c b/src/seek_sanity_test.c
index 3897f02..4275a84 100644
--- a/src/seek_sanity_test.c
+++ b/src/seek_sanity_test.c
@@ -660,6 +660,8 @@ int main(int argc, char **argv)
 {
 	int ret = -1;
 	int i = 0;
+	int opt;
+	int check_support = 0;
 	int numtests = sizeof(seek_tests) / sizeof(struct testrec);
 
 	if (argc != 2) {
@@ -667,10 +669,22 @@ int main(int argc, char **argv)
 		return ret;
 	}
 
-	base_file_path = (char *)strdup(argv[1]);
+	while ((opt = getopt(argc, argv, "t")) != -1) {
+		switch (opt) {
+		case 't':
+			check_support++;
+			break;
+		default:
+			fprintf(stderr, "Usage: %s [-t] base_file_path\n",
+				argv[0]);
+			return ret;
+		}
+	}
+
+	base_file_path = (char *)strdup(argv[optind]);
 
 	ret = test_basic_support();
-	if (ret)
+	if (ret || check_support)
 		goto out;
 
 	for (i = 0; i < numtests; ++i) {
diff --git a/tests/generic/285 b/tests/generic/285
index 22b4a08..b700a15 100644
--- a/tests/generic/285
+++ b/tests/generic/285
@@ -40,6 +40,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
+_require_seek_data_hole
+
 BASE_TEST_FILE=$TEST_DIR/seek_sanity_testfile
 
 [ -x $here/src/seek_sanity_test ] || _notrun "seek_sanitfy_tester not built"
diff --git a/tests/generic/286 b/tests/generic/286
index a0d4df9..5ab174f 100644
--- a/tests/generic/286
+++ b/tests/generic/286
@@ -38,6 +38,8 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os Linux
 
+_require_seek_data_hole
+
 src=$TEST_DIR/seek_copy_testfile
 dest=$TEST_DIR/seek_copy_testfile.dest
 
-- 
1.7.12.rc2.18.g61b472e

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
