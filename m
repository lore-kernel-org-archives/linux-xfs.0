Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q8e5j1001396 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:40:06 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	AJXahTdyMrlUkQea for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 01:40:03 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuJbr-00013b-RI
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:39:51 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuJbr-0003uX-Np
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:39:51 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 02/10] xfstests: rename USE_BIG_LOOPFS to be more generic
Date: Thu, 26 Jul 2012 18:39:41 +1000
Message-Id: <1343291989-14987-3-git-send-email-david@fromorbit.com>
In-Reply-To: <1343291989-14987-1-git-send-email-david@fromorbit.com>
References: <1343291989-14987-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

USE_BIG_LOOPFS is really misnamed - it can be used on real devices just as
easily as loop devices. It really means we are testing a large scratch device
and that we should enable the special filesystem filling and checking options
that enable xfstests to be run sanely on large XFS filesystems.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 004       |    2 +-
 015       |    2 +-
 030       |    2 +-
 031       |    2 +-
 032       |    2 +-
 033       |    4 ++--
 041       |    2 +-
 049       |    2 +-
 083       |    2 +-
 092       |    2 +-
 148       |    2 +-
 149       |    2 +-
 common    |    2 +-
 common.rc |   12 ++++++------
 setup     |    5 +++--
 15 files changed, 23 insertions(+), 22 deletions(-)

diff --git a/004 b/004
index 9f28e17..23729da 100755
--- a/004
+++ b/004
@@ -64,7 +64,7 @@ _supported_os IRIX Linux
 
 _need_to_be_root
 _require_scratch
-_require_nobigloopfs
+_require_no_large_scratch_dev
 
 rm -f $seq.full
 
diff --git a/015 b/015
index 4206b93..a99f1ed 100755
--- a/015
+++ b/015
@@ -52,7 +52,7 @@ _supported_fs generic
 _supported_os IRIX Linux
 
 _require_scratch
-_require_nobigloopfs
+_require_no_large_scratch_dev
 
 _scratch_mkfs_sized `expr 50 \* 1024 \* 1024` >/dev/null 2>&1 \
     || _fail "mkfs failed"
diff --git a/030 b/030
index fe57372..a8fb92c 100755
--- a/030
+++ b/030
@@ -64,8 +64,8 @@ _check_ag()
 _supported_fs xfs
 _supported_os IRIX Linux
 
-_require_nobigloopfs
 _require_scratch
+_require_no_large_scratch_dev
 
 DSIZE="-dsize=100m,agcount=6"
 
diff --git a/031 b/031
index b062277..fb6f15b 100755
--- a/031
+++ b/031
@@ -97,8 +97,8 @@ EOF
 _supported_fs xfs
 _supported_os IRIX Linux
 
-_require_nobigloopfs
 _require_scratch
+_require_no_large_scratch_dev
 
 # sanity test - default + one root directory entry
 # Note: must do this proto/mkfs now for later inode size calcs
diff --git a/032 b/032
index 4261ca2..d093b45 100755
--- a/032
+++ b/032
@@ -41,8 +41,8 @@ rm -f $seq.full
 _supported_fs xfs
 _supported_os Linux
 
-_require_nobigloopfs
 _require_scratch
+_require_no_large_scratch_dev
 
 echo "Silence is golden."
 for fs in `echo /sbin/mkfs.* | sed -e 's/.sbin.mkfs.//g'`
diff --git a/033 b/033
index 9651f26..68a688e 100755
--- a/033
+++ b/033
@@ -76,9 +76,9 @@ _filter_bad_ids()
 # real QA test starts here
 _supported_fs xfs
 _supported_os IRIX Linux
- 
-_require_nobigloopfs
+
 _require_scratch
+_require_no_large_scratch_dev
 
 # devzero blows away 512byte blocks, so make 512byte inodes (at least)
 _scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
diff --git a/041 b/041
index 2800811..28dcb33 100755
--- a/041
+++ b/041
@@ -50,7 +50,7 @@ _supported_fs xfs
 _supported_os IRIX Linux
 
 _require_scratch
-_require_nobigloopfs
+_require_no_large_scratch_dev
 umount $SCRATCH_DEV 2>/dev/null
 
 _fill()
diff --git a/049 b/049
index c3065ad..149c4b5 100755
--- a/049
+++ b/049
@@ -60,9 +60,9 @@ _log()
     echo "--- $*" >> $seq.full
 }
 
-_require_nobigloopfs
 _require_nonexternal
 _require_scratch
+_require_no_large_scratch_dev
 _require_loop
 _require_ext2
 
diff --git a/083 b/083
index e0670b9..7a73f30 100755
--- a/083
+++ b/083
@@ -58,7 +58,7 @@ _supported_fs generic
 _supported_os IRIX Linux
 
 _require_scratch
-_require_nobigloopfs
+_require_no_large_scratch_dev
 
 rm -f $seq.full
 
diff --git a/092 b/092
index 429fa80..02ccc71 100755
--- a/092
+++ b/092
@@ -48,7 +48,7 @@ _cleanup()
 _supported_fs xfs
 _supported_os IRIX Linux
 _require_scratch
-_require_nobigloopfs
+_require_no_large_scratch_dev
 
 MOUNT_OPTIONS="$MOUNT_OPTIONS -o inode64"
 _scratch_mkfs_xfs | _filter_mkfs 2>/dev/null
diff --git a/148 b/148
index 76cbf37..7bb1722 100755
--- a/148
+++ b/148
@@ -66,8 +66,8 @@ _check_ag()
 _supported_fs xfs
 _supported_os IRIX Linux
 
-_require_nobigloopfs
 _require_scratch
+_require_no_large_scratch_dev
 
 DSIZE="-dsize=100m"
 
diff --git a/149 b/149
index 5131a45..193e6d7 100755
--- a/149
+++ b/149
@@ -100,8 +100,8 @@ EOF
 _supported_fs xfs
 _supported_os IRIX Linux
 
-_require_nobigloopfs
 _require_scratch
+_require_no_large_scratch_dev
 
 # sanity test - default + one root directory entry
 # Note: must do this proto/mkfs now for later inode size calcs
diff --git a/common b/common
index 7d13078..da86cd9 100644
--- a/common
+++ b/common
@@ -239,7 +239,7 @@ s/ .*//p
 	    ;;
 
 	--large-fs)
-	    export USE_BIG_LOOPFS=yes
+	    export LARGE_SCRATCH_DEV=yes
 	    xpand=false
 	    ;;
 
diff --git a/common.rc b/common.rc
index 602513a..9517904 100644
--- a/common.rc
+++ b/common.rc
@@ -310,7 +310,7 @@ _scratch_mkfs_xfs()
     cat $tmp_dir.mkfsstd
     rm -f $tmp_dir.mkfserr $tmp_dir.mkfsstd
 
-    if [ "$USE_BIG_LOOPFS" = yes ]; then
+    if [ "$LARGE_SCRATCH_DEV" = yes ]; then
         [ -z "$RETAIN_AG_BYTES" ] && RETAIN_AG_BYTES=0
         ./tools/ag-wipe -q -r $RETAIN_AG_BYTES $SCRATCH_DEV
     fi
@@ -432,7 +432,7 @@ _scratch_xfs_repair()
         SCRATCH_OPTIONS="-l$SCRATCH_LOGDEV"
     [ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_RTDEV" ] && \
         SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -r$SCRATCH_RTDEV"
-    [ "$USE_BIG_LOOPFS" = yes ] && SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -t"
+    [ "$LARGE_SCRATCH_DEV" = yes ] && SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -t"
     $XFS_REPAIR_PROG $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 
@@ -821,9 +821,9 @@ _require_ext2()
 
 # this test requires that (large) loopback device files are not in use
 #
-_require_nobigloopfs()
+_require_no_large_scratch_dev()
 {
-    [ "$USE_BIG_LOOPFS" = yes ] && \
+    [ "$LARGE_SCRATCH_DEV" = yes ] && \
 	_notrun "Large filesystem testing in progress, skipped this test"
 }
 
@@ -1202,7 +1202,7 @@ _check_xfs_filesystem()
 
     [ "$FSTYP" != xfs ] && return 0
     testoption=""
-    [ "$USE_BIG_LOOPFS" = yes ] && testoption=-t
+    [ "$LARGE_SCRATCH_DEV" = yes ] && testoption=-t
 
     type=`_fs_type $device`
     ok=1
@@ -1241,7 +1241,7 @@ _check_xfs_filesystem()
         ok=0
     fi
     # repair doesn't scale massively at this stage, optionally skip it for now
-    [ "$USE_BIG_LOOPFS" = yes ] || \
+    [ "$LARGE_SCRATCH_DEV" = yes ] || \
     $XFS_REPAIR_PROG -n $extra_log_options $extra_rt_options $device >$tmp.repair 2>&1
     if [ $? -ne 0 ]
     then
diff --git a/setup b/setup
index 62798cc..5225951 100755
--- a/setup
+++ b/setup
@@ -23,7 +23,7 @@ fi
 
 [ "$USE_EXTERNAL"    = yes ] || USE_EXTERNAL=no
 [ "$USE_LBD_PATCH"   = yes ] || USE_LBD_PATCH=no
-[ "$USE_BIG_LOOPFS"  = yes ] || USE_BIG_LOOPFS=no
+[ "$LARGE_SCRATCH_DEV"  = yes ] || LARGE_SCRATCH_DEV=no
 [ "$USE_ATTR_SECURE" = yes ] || USE_ATTR_SECURE=no
 [ -z "$FSTYP" ] && FSTYP="xfs"
 
@@ -31,5 +31,6 @@ cat <<EOF
 TEST: DIR=$TEST_DIR DEV=$TEST_DEV rt=[$TEST_RTDEV] log=[$TEST_LOGDEV]
 TAPE: dev=[$TAPE_DEV] rmt=[$RMT_TAPE_DEV] rmtirix=[$RMT_TAPE_USER@$RMT_IRIXTAPE_DEV]
 SCRATCH: MNT=$SCRATCH_MNT DEV=$SCRATCH_DEV rt=[$SCRATCH_RTDEV] log=[$SCRATCH_LOGDEV]
-VARIABLES: external=$USE_EXTERNAL largeblk=$USE_LBD_PATCH fstyp=$FSTYP bigloopfs=$USE_BIG_LOOPFS attrsecure=$USE_ATTR_SECURE
+VARIABLES: external=$USE_EXTERNAL largeblk=$USE_LBD_PATCH fstyp=$FSTYP
+	   large_scratch_dev=$LARGE_SCRATCH_DEV attrsecure=$USE_ATTR_SECURE
 EOF
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
