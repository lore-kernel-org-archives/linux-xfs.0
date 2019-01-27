Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45520 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726419AbfA0HvI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Jan 2019 02:51:08 -0500
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 1/2] common/dump: do not override test cleanup trap
Date: Sun, 27 Jan 2019 09:50:56 +0200
Message-Id: <20190127075057.25254-1-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <guaneryu@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>, Zorro Lang <zlang@redhat.com>, Eric Sandeen <sandeen@redhat.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, fstests@vger.kernel.org, linux-xfs@vger.kernel.org

Instead, call _cleanup_dump explicitly from a private _cleanup.
Remove the generic cleanup bits (rm $tmp.*) from _cleanup_dump.

The only xfs/dump test that had anything other than rm $tmp.* in
_cleanup in xfs/287, but that was _scratch_unmount, which is not
needed anyway.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 common/dump   | 6 +-----
 tests/xfs/022 | 9 ++++++++-
 tests/xfs/023 | 9 ++++++++-
 tests/xfs/024 | 9 ++++++++-
 tests/xfs/025 | 9 ++++++++-
 tests/xfs/026 | 9 ++++++++-
 tests/xfs/027 | 9 ++++++++-
 tests/xfs/028 | 9 ++++++++-
 tests/xfs/035 | 9 ++++++++-
 tests/xfs/036 | 9 ++++++++-
 tests/xfs/037 | 9 ++++++++-
 tests/xfs/038 | 9 ++++++++-
 tests/xfs/039 | 9 ++++++++-
 tests/xfs/043 | 9 ++++++++-
 tests/xfs/046 | 9 ++++++++-
 tests/xfs/047 | 9 ++++++++-
 tests/xfs/055 | 9 ++++++++-
 tests/xfs/056 | 9 ++++++++-
 tests/xfs/059 | 9 ++++++++-
 tests/xfs/060 | 9 ++++++++-
 tests/xfs/061 | 9 ++++++++-
 tests/xfs/063 | 9 ++++++++-
 tests/xfs/064 | 9 ++++++++-
 tests/xfs/065 | 9 ++++++++-
 tests/xfs/066 | 1 +
 tests/xfs/068 | 9 ++++++++-
 tests/xfs/266 | 9 ++++++++-
 tests/xfs/267 | 9 ++++++++-
 tests/xfs/268 | 9 ++++++++-
 tests/xfs/281 | 9 ++++++++-
 tests/xfs/282 | 9 ++++++++-
 tests/xfs/283 | 9 ++++++++-
 tests/xfs/287 | 2 +-
 tests/xfs/296 | 1 +
 tests/xfs/301 | 1 +
 tests/xfs/302 | 1 +
 36 files changed, 246 insertions(+), 36 deletions(-)

diff --git a/common/dump b/common/dump
index 4d1a1607..89fa0391 100644
--- a/common/dump
+++ b/common/dump
@@ -45,9 +45,6 @@ session_label="stress_$seq"
 nobody=4 # define this uid/gid as a number
 do_quota_check=true # do quota check if quotas enabled
 
-# install our cleaner
-trap "_cleanup; exit \$status" 0 1 2 3 15
-
 # start inventory from a known base - move it aside for test
 for dir in /var/xfsdump/inventory /var/lib/xfsdump/inventory; do
     if [ -d $dir ]; then
@@ -227,7 +224,7 @@ _wipe_fs()
 # Cleanup created dirs and files
 # Called by trap
 #
-_cleanup()
+_cleanup_dump()
 {
     # Some tests include this before checking _supported_fs xfs
     # and the sleeps & checks here get annoying
@@ -236,7 +233,6 @@ _cleanup()
     fi
 
     cd $here
-    rm -f $tmp.*
 
     if [ -n "$DEBUGDUMP" ]; then
 	# save it for inspection
diff --git a/tests/xfs/022 b/tests/xfs/022
index e1162798..e668a6fc 100755
--- a/tests/xfs/022
+++ b/tests/xfs/022
@@ -17,7 +17,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 . ./common/rc
 . ./common/dump
diff --git a/tests/xfs/023 b/tests/xfs/023
index b0763402..f7805b85 100755
--- a/tests/xfs/023
+++ b/tests/xfs/023
@@ -15,7 +15,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/024 b/tests/xfs/024
index bf222150..b4ecd790 100755
--- a/tests/xfs/024
+++ b/tests/xfs/024
@@ -13,7 +13,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/025 b/tests/xfs/025
index 5ce844e6..74039062 100755
--- a/tests/xfs/025
+++ b/tests/xfs/025
@@ -13,7 +13,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/026 b/tests/xfs/026
index d4fd636c..96f71293 100755
--- a/tests/xfs/026
+++ b/tests/xfs/026
@@ -13,7 +13,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/027 b/tests/xfs/027
index 8459c5ad..7a501f03 100755
--- a/tests/xfs/027
+++ b/tests/xfs/027
@@ -13,7 +13,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/028 b/tests/xfs/028
index b71039b9..bedfa3d3 100755
--- a/tests/xfs/028
+++ b/tests/xfs/028
@@ -13,7 +13,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/035 b/tests/xfs/035
index 1874173f..2e09c35c 100755
--- a/tests/xfs/035
+++ b/tests/xfs/035
@@ -14,7 +14,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/036 b/tests/xfs/036
index 8d61a719..a7e7d572 100755
--- a/tests/xfs/036
+++ b/tests/xfs/036
@@ -14,7 +14,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/037 b/tests/xfs/037
index 478157e4..aea557fc 100755
--- a/tests/xfs/037
+++ b/tests/xfs/037
@@ -13,7 +13,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/038 b/tests/xfs/038
index 43fdc2c3..8ae93dad 100755
--- a/tests/xfs/038
+++ b/tests/xfs/038
@@ -13,7 +13,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/039 b/tests/xfs/039
index 79284afd..7b213e33 100755
--- a/tests/xfs/039
+++ b/tests/xfs/039
@@ -14,7 +14,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/043 b/tests/xfs/043
index b60c2870..5db2d6f9 100755
--- a/tests/xfs/043
+++ b/tests/xfs/043
@@ -16,7 +16,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/046 b/tests/xfs/046
index c5358c29..0955e453 100755
--- a/tests/xfs/046
+++ b/tests/xfs/046
@@ -13,7 +13,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/047 b/tests/xfs/047
index ddf871f8..2fdfef14 100755
--- a/tests/xfs/047
+++ b/tests/xfs/047
@@ -13,7 +13,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/055 b/tests/xfs/055
index 8a30d4b3..58144e98 100755
--- a/tests/xfs/055
+++ b/tests/xfs/055
@@ -14,7 +14,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/056 b/tests/xfs/056
index 533fef2e..b0f70e90 100755
--- a/tests/xfs/056
+++ b/tests/xfs/056
@@ -14,7 +14,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/059 b/tests/xfs/059
index 949dbe81..0121872a 100755
--- a/tests/xfs/059
+++ b/tests/xfs/059
@@ -13,7 +13,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/060 b/tests/xfs/060
index ca709983..a7048a66 100755
--- a/tests/xfs/060
+++ b/tests/xfs/060
@@ -13,7 +13,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/061 b/tests/xfs/061
index fcea0ee8..f8a639fc 100755
--- a/tests/xfs/061
+++ b/tests/xfs/061
@@ -13,7 +13,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/063 b/tests/xfs/063
index f4c65807..b6d4c03a 100755
--- a/tests/xfs/063
+++ b/tests/xfs/063
@@ -13,7 +13,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/064 b/tests/xfs/064
index f8fc382a..8adb406a 100755
--- a/tests/xfs/064
+++ b/tests/xfs/064
@@ -13,7 +13,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/065 b/tests/xfs/065
index 3fcdb604..c3472486 100755
--- a/tests/xfs/065
+++ b/tests/xfs/065
@@ -16,7 +16,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/066 b/tests/xfs/066
index b7da7966..90e1251c 100755
--- a/tests/xfs/066
+++ b/tests/xfs/066
@@ -22,6 +22,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
+    _cleanup_dump
     cd /
     rm -f $tmp.*
 }
diff --git a/tests/xfs/068 b/tests/xfs/068
index c755bc3e..7f5900fc 100755
--- a/tests/xfs/068
+++ b/tests/xfs/068
@@ -18,7 +18,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 . ./common/rc
 . ./common/dump
diff --git a/tests/xfs/266 b/tests/xfs/266
index 9084f5b9..73c1096d 100755
--- a/tests/xfs/266
+++ b/tests/xfs/266
@@ -13,7 +13,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 #
 # Add a new file and append a subset of the fill'ed files
diff --git a/tests/xfs/267 b/tests/xfs/267
index 8887f4c1..d13ec19a 100755
--- a/tests/xfs/267
+++ b/tests/xfs/267
@@ -13,7 +13,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 #
 # create a 40 MiB file with an extended attr.
diff --git a/tests/xfs/268 b/tests/xfs/268
index c2686302..fa5b9283 100755
--- a/tests/xfs/268
+++ b/tests/xfs/268
@@ -15,7 +15,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=0	# success is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 #
 # create two 12 MiB files with extended attrs.
diff --git a/tests/xfs/281 b/tests/xfs/281
index 9df6154c..43534f10 100755
--- a/tests/xfs/281
+++ b/tests/xfs/281
@@ -13,7 +13,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/282 b/tests/xfs/282
index bb4975c4..3f0d8e59 100755
--- a/tests/xfs/282
+++ b/tests/xfs/282
@@ -15,7 +15,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/283 b/tests/xfs/283
index e647cef9..eab9f96b 100755
--- a/tests/xfs/283
+++ b/tests/xfs/283
@@ -15,7 +15,14 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
-trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	_cleanup_dump
+	cd /
+	rm -f $tmp.*
+}
 
 # get standard environment, filters and checks
 . ./common/rc
diff --git a/tests/xfs/287 b/tests/xfs/287
index bde15e94..8dc754a5 100755
--- a/tests/xfs/287
+++ b/tests/xfs/287
@@ -23,8 +23,8 @@ rm -f $seqres.full
 
 _cleanup()
 {
+	_cleanup_dump
 	cd /
-	_scratch_unmount 2>/dev/null
 	rm -rf $tmp.*
 }
 
diff --git a/tests/xfs/296 b/tests/xfs/296
index bc190faf..e17adaa1 100755
--- a/tests/xfs/296
+++ b/tests/xfs/296
@@ -17,6 +17,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
+    _cleanup_dump
     cd /
     rm -f $tmp.*
 }
diff --git a/tests/xfs/301 b/tests/xfs/301
index 440d314b..231e4a18 100755
--- a/tests/xfs/301
+++ b/tests/xfs/301
@@ -17,6 +17,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
+    _cleanup_dump
     cd /
     rm -f $tmp.*
 }
diff --git a/tests/xfs/302 b/tests/xfs/302
index de619874..92806a23 100755
--- a/tests/xfs/302
+++ b/tests/xfs/302
@@ -17,6 +17,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 
 _cleanup()
 {
+    _cleanup_dump
     cd /
     rm -f $tmp.*
 }
-- 
2.17.1
