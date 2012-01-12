Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0CHOKNX008438 for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 11:24:20 -0600
Received: from mail-vw0-f53.google.com (mail-vw0-f53.google.com
	[209.85.212.53]) by cuda.sgi.com with ESMTP id 0kbv5cd4s5a4SH8l
	for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 09:24:18 -0800 (PST)
Received: by vbbez10 with SMTP id ez10so623515vbb.26
	for <xfs@oss.sgi.com>; Thu, 12 Jan 2012 09:24:18 -0800 (PST)
From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] xfstests 273 274 275: do test in dedicated dir and leave test
	files in it
Date: Fri, 13 Jan 2012 01:20:15 +0800
Message-Id: <1326388815-21181-1-git-send-email-guaneryu@gmail.com>
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
Cc: Eryu Guan <guaneryu@gmail.com>

Do all testings in dedicated dir($SCRATCH_MNT/$seq) instead of
$SCRATCH_MNT and don't remove test files in _cleanup() for debug
purpose.

Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 273 |   14 ++++++++------
 274 |    9 ++++++---
 275 |    9 ++++++---
 3 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/273 b/273
index 2965132..a7f14c1 100755
--- a/273
+++ b/273
@@ -35,7 +35,7 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
 	cd /
-	rm -rf $SCRATCH_MNT/* $tmp.*
+	rm -rf $tmp.*
 	_scratch_unmount
 }
 
@@ -44,6 +44,7 @@ _cleanup()
 
 threads=50
 count=1
+WORK_DIR="$SCRATCH_MNT/$seq"
 
 _threads_set()
 {
@@ -59,14 +60,14 @@ _file_create()
 {
 	_i=0
 
-	if ! mkdir $SCRATCH_MNT/origin
+	if ! mkdir $WORK_DIR/origin
 	then
 		echo "mkdir origin err"
 		status=1
 		exit
 	fi
 
-	cd $SCRATCH_MNT/origin
+	cd $WORK_DIR/origin
 
 	_disksize=`df --block-size=1 | grep $SCRATCH_DEV | awk '{print $2}'`
 	_disksize=$(($_disksize / 3))
@@ -85,14 +86,14 @@ _porter()
 {
 	_suffix=$1
 
-	if ! mkdir $SCRATCH_MNT/sub_$_suffix
+	if ! mkdir $WORK_DIR/sub_$_suffix
 	then
 		echo "mkdir sub_xxx err"
 		status=1
 		exit
 	fi
 
-	cp -r $SCRATCH_MNT/origin $SCRATCH_MNT/sub_$_suffix >$seq.full 2>&1
+	cp -r $WORK_DIR/origin $WORK_DIR/sub_$_suffix >$seq.full 2>&1
 	if [ $? -ne 0 ]
 	then
 		echo "_porter $_suffix not complete"
@@ -106,7 +107,8 @@ _do_workload()
 	_pids=""
 	_pid=1
 	
-	rm -rf $SCRATCH_MNT/*
+	rm -rf $WORK_DIR
+	mkdir -p $WORK_DIR
 
 	_threads_set
 	_file_create
diff --git a/274 b/274
index b658004..c351c40 100755
--- a/274
+++ b/274
@@ -35,13 +35,15 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
 	cd /
-	rm -f $SCRATCH_MNT/* $tmp.*
+	rm -f $tmp.*
 	_scratch_unmount
 }
 
 . ./common.rc
 . ./common.filter
 
+WORK_DIR="$SCRATCH_MNT/$seq"
+
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
@@ -57,8 +59,9 @@ umount $SCRATCH_DEV 2>/dev/null
 _scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
 _scratch_mount
 
-rm -rf $SCRATCH_MNT/*
-cd $SCRATCH_MNT
+rm -rf $WORK_DIR
+mkdir -p $WORK_DIR
+cd $WORK_DIR
 dd if=/dev/zero of=test bs=4K count=1 >/dev/null 2>&1
 if [ $? -ne 0 ]
 then
diff --git a/275 b/275
index 214262e..7a4d414 100755
--- a/275
+++ b/275
@@ -36,13 +36,15 @@ trap "_cleanup; exit \$status" 0 1 2 3 15
 _cleanup()
 {
 	cd /
-	rm -f $SCRATCH_MNT/* $tmp.*
+	rm -f $tmp.*
 	_scratch_unmount
 }
 
 . ./common.rc
 . ./common.filter
 
+WORK_DIR="$SCRATCH_MNT/$seq"
+
 # real QA test starts here
 _supported_fs generic
 _supported_os IRIX Linux
@@ -58,8 +60,9 @@ umount $SCRATCH_DEV 2>/dev/null
 _scratch_mkfs_sized $((1 * 1024 * 1024 * 1024)) >>$seq.full 2>&1
 _scratch_mount
 
-rm -rf $SCRATCH_MNT/*
-cd $SCRATCH_MNT
+rm -rf $WORK_DIR
+mkdir -p $WORK_DIR
+cd $WORK_DIR
 
 dd if=/dev/zero of=tmp1 bs=4K count=1 >/dev/null 2>&1
 if [ $? -ne 0 ]
-- 
1.7.8.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
