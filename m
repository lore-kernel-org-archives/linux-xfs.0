Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA7L40Ji076282 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 15:04:00 -0600
From: Bill Kendall <wkendall@sgi.com>
Subject: [PATCH] xfstests: ignore fsstress file count for 022
Date: Mon,  7 Nov 2011 15:03:52 -0600
Message-Id: <1320699832-12693-1-git-send-email-wkendall@sgi.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

The recently added fsstress operations result in a different
number of directories and files being created for xfsdump test
022, which causes the test to fail since the expected xfsrestore
output records these numbers. Filter out the numbers to prevent
this from breaking in the future.

Also increase the number of fsstress operations used to populate
the filesystem so that we get roughly the same number of
directories and files as we used to for this test.

Signed-off-by: Bill Kendall <wkendall@sgi.com>
---
 022           |    3 ++-
 022.out.irix  |    2 +-
 022.out.linux |    2 +-
 common.dump   |    2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/022 b/022
index 76d18e6..b83b063 100755
--- a/022
+++ b/022
@@ -53,7 +53,8 @@ _require_tape $TAPE_DEV
 _create_dumpdir_stress
 _erase_hard
 _do_dump_sub
-_do_restore
+# filter out the file count, it changes as fsstress adds new operations
+_do_restore | sed -e "/entries processed$/s/[0-9][0-9]*/NUM/g"
 _ls_compare_sub
 
 # success, all done
diff --git a/022.out.irix b/022.out.irix
index 725d6cd..f72876a 100644
--- a/022.out.irix
+++ b/022.out.irix
@@ -46,7 +46,7 @@ xfsrestore: searching media for directory dump
 xfsrestore: preparing drive
 xfsrestore: examining media file 0
 xfsrestore: reading directories
-xfsrestore: 30 directories and 89 entries processed
+xfsrestore: NUM directories and NUM entries processed
 xfsrestore: directory post-processing
 xfsrestore: restoring non-directory files
 xfsrestore: restore complete: SECS seconds elapsed
diff --git a/022.out.linux b/022.out.linux
index 9466747..a843b0c 100644
--- a/022.out.linux
+++ b/022.out.linux
@@ -46,7 +46,7 @@ xfsrestore: searching media for directory dump
 xfsrestore: preparing drive
 xfsrestore: examining media file 0
 xfsrestore: reading directories
-xfsrestore: 30 directories and 89 entries processed
+xfsrestore: NUM directories and NUM entries processed
 xfsrestore: directory post-processing
 xfsrestore: restoring non-directory files
 xfsrestore: restore complete: SECS seconds elapsed
diff --git a/common.dump b/common.dump
index 31a75c5..493a5f7 100644
--- a/common.dump
+++ b/common.dump
@@ -301,7 +301,7 @@ _create_dumpdir_stress()
     _wipe_fs
 
     _param="-f link=10 -f creat=10 -f mkdir=10 -f truncate=5 -f symlink=10"
-    _count=200
+    _count=240
     rm -rf $dump_dir
     if ! mkdir $dump_dir; then
         echo "    failed to mkdir $dump_dir"
-- 
1.7.0.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
