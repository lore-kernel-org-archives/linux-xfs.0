Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p71AVOrZ262012 for <xfs@oss.sgi.com>; Mon, 1 Aug 2011 05:31:24 -0500
Received: from mort.rzone.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B55FF15F88DD
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2011 03:31:59 -0700 (PDT)
Received: from mort.rzone.de (mort.rzone.de [81.169.144.234]) by cuda.sgi.com
	with ESMTP id 4UZomTR4jOw3zZo1 for <xfs@oss.sgi.com>;
	Mon, 01 Aug 2011 03:31:59 -0700 (PDT)
From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: [PATCH v3 1/2] xfstests: make more tests generic
Date: Mon,  1 Aug 2011 12:31:19 +0200
Message-Id: <c9703ec698de4de685eb6822773d3934452b8334.1312193821.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1312193821.git.sbehrens@giantdisaster.de>
References: <cover.1312193821.git.sbehrens@giantdisaster.de>
In-Reply-To: <cover.1312193821.git.sbehrens@giantdisaster.de>
References: <cover.1312193821.git.sbehrens@giantdisaster.de>
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
To: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Use _scratch_mkfs / _scratch_mkfs_sized instead of _scratch_mkfs_xfs
where possible.
Execute 015, 062, 083, 117, 120 and 192 for all filesystems, these
tests used to be XFS specific.

Signed-off-by: Stefan Behrens <sbehrens@giantdisaster.de>
---
 015     |    5 +++--
 062     |    4 ++--
 062.out |    6 ------
 083     |   12 +++++++++---
 117     |    4 ++--
 120     |    4 ++--
 192     |    2 +-
 7 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/015 b/015
index 8f2be7c..4206b93 100755
--- a/015
+++ b/015
@@ -48,13 +48,14 @@ _free()
 }
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _require_scratch
 _require_nobigloopfs
 
-_scratch_mkfs_xfs -d size=50m >/dev/null || _fail "mkfs failed"
+_scratch_mkfs_sized `expr 50 \* 1024 \* 1024` >/dev/null 2>&1 \
+    || _fail "mkfs failed"
 _scratch_mount || _fail "mount failed"
 out=$SCRATCH_MNT/fillup.$$
 rm -f $seq.full
diff --git a/062 b/062
index 5cb6f92..a6e4bc8 100755
--- a/062
+++ b/062
@@ -71,7 +71,7 @@ _create_test_bed()
 }
 
 # real QA test starts here
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os Linux
 
 _require_scratch
@@ -80,7 +80,7 @@ _require_attrs
 rm -f $tmp.backup1 $tmp.backup2 $seq.full
 
 # real QA test starts here
-_scratch_mkfs_xfs | _filter_mkfs 2>$tmp.mkfs
+_scratch_mkfs > /dev/null 2>&1 || _fail "mkfs failed"
 _scratch_mount || _fail "mount failed"
 _create_test_bed
 
diff --git a/062.out b/062.out
index 73fd628..1d5a094 100644
--- a/062.out
+++ b/062.out
@@ -1,10 +1,4 @@
 QA output created by 062
-meta-data=DDEV isize=XXX agcount=N, agsize=XXX blks
-data     = bsize=XXX blocks=XXX, imaxpct=PCT
-         = sunit=XXX swidth=XXX, unwritten=X
-naming   =VERN bsize=XXX
-log      =LDEV bsize=XXX blocks=XXX
-realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
 *** create test bed
 SCRATCH_MNT
 SCRATCH_MNT/dev
diff --git a/083 b/083
index 7342baa..441284e 100755
--- a/083
+++ b/083
@@ -54,7 +54,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _require_scratch
@@ -72,8 +72,14 @@ workout()
 	umount $SCRATCH_DEV >/dev/null 2>&1
 	echo "*** mkfs -dsize=$fsz,agcount=$ags"    >>$seq.full
 	echo ""                                     >>$seq.full
-	_scratch_mkfs_xfs -dsize=$fsz,agcount=$ags  >>$seq.full 2>&1 \
-		|| _fail "size=$fsz,agcount=$ags mkfs failed"
+	if [ $FSTYP = xfs ]
+	then
+		_scratch_mkfs_xfs -dsize=$fsz,agcount=$ags  >>$seq.full 2>&1 \
+			|| _fail "size=$fsz,agcount=$ags mkfs failed"
+	else
+		_scratch_mkfs_sized $fsz >>$seq.full 2>&1 \
+			|| _fail "size=$fsz mkfs failed"
+	fi
 	_scratch_mount                              >>$seq.full 2>&1 \
 		|| _fail "mount failed"
 
diff --git a/117 b/117
index dd880cb..fcf0485 100755
--- a/117
+++ b/117
@@ -51,7 +51,7 @@ _cleanup()
 . ./common.attr
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os IRIX Linux
 
 _setup_testdir
@@ -62,7 +62,7 @@ rm -f $seq.full
 umount $SCRATCH_DEV >/dev/null 2>&1
 echo "*** MKFS ***"                         >>$seq.full
 echo ""                                     >>$seq.full
-_scratch_mkfs_xfs                           >>$seq.full 2>&1 \
+_scratch_mkfs                               >>$seq.full 2>&1 \
     || _fail "mkfs failed"
 _scratch_mount                              >>$seq.full 2>&1 \
     || _fail "mount failed"
diff --git a/120 b/120
index bf1e617..010a8f3 100755
--- a/120
+++ b/120
@@ -37,11 +37,11 @@ trap "rm -f $tmp.*; exit \$status" 0 1 2 3 15
 . ./common.filter
 
 # real QA test starts here
-_supported_fs xfs
+_supported_fs generic
 _supported_os Linux IRIX
 
 _require_scratch
-_scratch_mkfs_xfs >/dev/null 2>&1
+_scratch_mkfs >/dev/null 2>&1 || _fail "mkfs failed"
 
 _compare_access_times()
 {
diff --git a/192 b/192
index d8301d5..4b69147 100755
--- a/192
+++ b/192
@@ -45,7 +45,7 @@ _access_time()
 
 # real QA test starts here
 
-_supported_fs xfs udf nfs
+_supported_fs generic
 _supported_os Linux
 #delay=150
 #delay=75
-- 
1.7.3.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
