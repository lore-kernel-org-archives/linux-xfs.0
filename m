Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 18:32:33 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4F1WDm4023641
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 18:32:14 -0700
Date: Thu, 15 May 2008 11:32:55 +1000
From: David Chinner <dgc@sgi.com>
Subject: [patch] xfsqa 073 - don't host loopback images in /tmp
Message-ID: <20080515013255.GM155679365@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

/tmp might be small, might not support files larger than 2GB,
etc, so trying to host loopback images of 100GB filesystems
will break in some situations. We should use $TEST_DIR for the
images.

Note: remounting of loopback images has a major bug (in mount)
that "leaks" loopback device references. Hence all the hackery
with losetup to work around this.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 xfstests/073 |   78 ++++++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 51 insertions(+), 27 deletions(-)

Index: xfs-cmds/xfstests/073
===================================================================
--- xfs-cmds.orig/xfstests/073	2007-06-13 17:49:44.000000000 +1000
+++ xfs-cmds/xfstests/073	2008-05-14 08:52:51.029055515 +1000
@@ -3,8 +3,17 @@
 #
 # Test xfs_copy
 #
+# HACK WARNING:
+#
+# Due to the severe brokenness of mount's handling of loopback devices, we
+# hardcode the loop devices we use for this test. This enables us to clean up
+# the pieces when we remount the loop device because mount loses all trace of
+# the fact this is a loop device. Hence to enable us to unmount the hosting
+# filesystem, we need to manually tear down the relevant loop device. If
+# mount ever gets fixed then this hack can be removed.
+#
 #-----------------------------------------------------------------------
-# Copyright (c) 2000-2003 Silicon Graphics, Inc.  All Rights Reserved.
+# Copyright (c) 2000-2003,2008 Silicon Graphics, Inc.  All Rights Reserved.
 #-----------------------------------------------------------------------
 #
 # creator
@@ -16,14 +25,22 @@ echo "QA output created by $seq"
 here=`pwd`
 tmp=/tmp/$$
 status=1	# failure is the default!
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# don't put fs images in /tmp
+imgs=$TEST_DIR/$$
+
 _cleanup()
 {
 	cd /
 	umount $SCRATCH_MNT 2>/dev/null
-	umount $tmp.loop 2>/dev/null
-	[ -d $tmp.loop ] && rmdir $tmp.loop
-	[ -d $tmp.source_dir ] && rm -rf $tmp.source_dir
-	rm -f $tmp.* /var/tmp/xfs_copy.log.*
+	umount $imgs.loop 2>/dev/null
+	[ -d $imgs.loop ] && rmdir $imgs.loop
+	[ -d $imgs.source_dir ] && rm -rf $imgs.source_dir
+	rm -f $imgs.* $tmp.* /var/tmp/xfs_copy.log.*
 }
 trap "_cleanup; exit \$status" 0 1 2 3 15
 
@@ -51,9 +68,10 @@ _populate_scratch()
 _verify_copy()
 {
 	target=$1
-	target_dir=$tmp.loop
+	target_dir=$imgs.loop
 	source=$2
 	source_dir=$3
+	loop=`losetup -sf`
 
 	[ $source = $SCRATCH_DEV ] && _scratch_mount
 
@@ -63,7 +81,8 @@ _verify_copy()
 	echo mounting new image on loopback
 	rmdir $target_dir 2>/dev/null
 	mkdir $target_dir
-	mount -t xfs -o loop $target $target_dir 2>/dev/null
+
+	mount -t xfs -o loop=$loop $target $target_dir 2>/dev/null
 	if [ $? -ne 0 ]; then
 		echo retrying mount with nouuid option
 		mount -t xfs -o loop -o nouuid $target $target_dir
@@ -96,13 +115,10 @@ _verify_copy()
 
 	echo unmounting and removing new image
 	umount $source $target
+	losetup -d $loop > /dev/null 2>&1
 	rm -f $target
 }
 
-# get standard environment, filters and checks
-. ./common.rc
-. ./common.filter
-
 
 # real QA test starts here
 _supported_fs xfs
@@ -124,31 +140,39 @@ umount $SCRATCH_MNT 2>/dev/null
 
 echo
 echo === copying scratch device to single target
-xfs_copy $SCRATCH_DEV $tmp.image | _filter_copy '#' $tmp.image '#' '#'
-_verify_copy $tmp.image $SCRATCH_DEV $SCRATCH_MNT
+xfs_copy $SCRATCH_DEV $imgs.image | _filter_copy '#' $imgs.image '#' '#'
+_verify_copy $imgs.image $SCRATCH_DEV $SCRATCH_MNT
 
 echo
 echo === copying scratch device to single target, duplicate UUID
-xfs_copy -d $SCRATCH_DEV $tmp.image | _filter_copy '#' $tmp.image '#' '#'
-_verify_copy $tmp.image $SCRATCH_DEV $SCRATCH_MNT
+xfs_copy -d $SCRATCH_DEV $imgs.image | _filter_copy '#' $imgs.image '#' '#'
+_verify_copy $imgs.image $SCRATCH_DEV $SCRATCH_MNT
 
 echo 
 echo === copying scratch device to single target, large ro device
-/sbin/mkfs.xfs -dfile,name=$tmp.source,size=100g | _filter_mkfs 2>/dev/null
-rmdir $tmp.source_dir 2>/dev/null
-mkdir $tmp.source_dir
-mount -t xfs -o loop $tmp.source $tmp.source_dir
-cp -a $here $tmp.source_dir
-mount -t xfs -o remount,ro $tmp.source $tmp.source_dir
-xfs_copy $tmp.source $tmp.image | _filter_copy '#' $tmp.image '#' '#'
-_verify_copy $tmp.image $tmp.source $tmp.source_dir
+/sbin/mkfs.xfs -dfile,name=$imgs.source,size=100g | _filter_mkfs 2>/dev/null
+rmdir $imgs.source_dir 2>/dev/null
+mkdir $imgs.source_dir
+
+loop2=`losetup -sf`
+mount -t xfs -o loop=$loop2 $imgs.source $imgs.source_dir
+cp -a $here $imgs.source_dir
+mount -t xfs -o remount,ro $imgs.source $imgs.source_dir
+xfs_copy $imgs.source $imgs.image | _filter_copy '#' $imgs.image '#' '#'
+_verify_copy $imgs.image $imgs.source $imgs.source_dir
+
+# HACK WARNING:
+#
+# We're done with the nested loop mount, now we have to clean
+# up the pieces that mount is incapable of doing.
+losetup -d $loop2 > /dev/null 2>&1
 
 echo
 echo === copying scratch device to multiple targets
-xfs_copy -L$tmp.log -b $SCRATCH_DEV $tmp.image1 $tmp.image2 \
-	| _filter_copy '#' $tmp.image1 '#' $tmp.image2
-_verify_copy $tmp.image1 $SCRATCH_DEV $SCRATCH_MNT
-_verify_copy $tmp.image2 $SCRATCH_DEV $SCRATCH_MNT
+xfs_copy -L$imgs.log -b $SCRATCH_DEV $imgs.image1 $imgs.image2 \
+	| _filter_copy '#' $imgs.image1 '#' $imgs.image2
+_verify_copy $imgs.image1 $SCRATCH_DEV $SCRATCH_MNT
+_verify_copy $imgs.image2 $SCRATCH_DEV $SCRATCH_MNT
 
 # success, all done
 status=0
