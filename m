Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 May 2008 23:12:24 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m4M6CG9d019003
	for <xfs@oss.sgi.com>; Wed, 21 May 2008 23:12:17 -0700
Date: Thu, 22 May 2008 16:12:57 +1000
From: David Chinner <dgc@sgi.com>
Subject: [patch] xfsqa test to check log size scaling
Message-ID: <20080522061257.GR173056135@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-dev <xfs-dev@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

XFS-QA test to check that log size scaling works correctly
for old and new maximum log sizes.

Signed-off-by: Dave Chinner <dgc@sgi.com>
---
 xfstests/188     |   88 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 xfstests/188.out |   16 ++++++++++
 xfstests/group   |    1 
 3 files changed, 105 insertions(+)

Index: xfs-cmds/xfstests/188
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs-cmds/xfstests/188	2008-05-15 22:39:08.741203552 +1000
@@ -0,0 +1,88 @@
+#! /bin/sh
+# FS QA Test No. 188
+#
+# large log size mkfs test - ensure the log size scaling works
+#
+#-----------------------------------------------------------------------
+# Copyright (c) 2008 Silicon Graphics, Inc.  All Rights Reserved.
+#-----------------------------------------------------------------------
+#
+# creator
+owner=dgc@sgi.com
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
+    cd /
+    rm -f $tmp.*
+    _cleanup_testdir
+}
+
+# get standard environment, filters and checks
+. ./common.rc
+. ./common.filter
+
+# real QA test starts here
+_supported_fs xfs
+_supported_os Linux
+
+_setup_testdir
+_require_scratch
+_scratch_mkfs_xfs >/dev/null 2>&1
+_scratch_mount
+
+_require_loop
+LOOP_DEV=$SCRATCH_MNT/test_fs
+LOOP_MNT=$SCRATCH_MNT/test_fs_dir
+
+_do_mkfs()
+{
+	for i in $*; do
+		echo -n "fssize=${i}g "
+		$MKFS_XFS_PROG -f -b size=4096 -l version=2 \
+			-d name=$LOOP_DEV,size=${i}g |grep log
+		mount -o loop -t xfs $LOOP_DEV $LOOP_MNT
+		echo "test write" > $LOOP_MNT/test
+		umount $LOOP_MNT
+	done
+}
+# make large holey file
+$XFS_IO_PROG -f -c "truncate 100t" $LOOP_DEV
+
+#make loopback mount dir
+mkdir $LOOP_MNT
+
+# test if large logs are supported
+LARGE_LOG=
+$MKFS_XFS_PROG -f -l size=256m -d name=$LOOP_DEV,size=10g > /dev/null 2>&1
+if [ $? -eq 0 ]; then
+	LARGE_LOG=true
+fi
+
+# walk over standard sizes (up to 256GB)
+_do_mkfs 1 2 4 8 16 32 64 128 256
+
+if [ -n "$LARGE_LOG" ]; then
+	# walk over larger sizes
+	_do_mkfs 512 1024 2048 4096 8192 16384
+else
+	# just cut'n'paste from the golden output for the remaining sizes
+	cat << EOF
+fssize=512g log      =internal log           bsize=4096   blocks=65536, version=2
+fssize=1024g log      =internal log           bsize=4096   blocks=131072, version=2
+fssize=2048g log      =internal log           bsize=4096   blocks=262144, version=2
+fssize=4096g log      =internal log           bsize=4096   blocks=521728, version=2
+fssize=8192g log      =internal log           bsize=4096   blocks=521728, version=2
+fssize=16384g log      =internal log           bsize=4096   blocks=521728, version=2
+EOF
+fi
+
+status=0
+exit
Index: xfs-cmds/xfstests/188.out
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ xfs-cmds/xfstests/188.out	2008-05-15 22:39:26.254922874 +1000
@@ -0,0 +1,16 @@
+QA output created by 188
+fssize=1g log      =internal log           bsize=4096   blocks=2560, version=2
+fssize=2g log      =internal log           bsize=4096   blocks=2560, version=2
+fssize=4g log      =internal log           bsize=4096   blocks=2560, version=2
+fssize=8g log      =internal log           bsize=4096   blocks=2560, version=2
+fssize=16g log      =internal log           bsize=4096   blocks=2560, version=2
+fssize=32g log      =internal log           bsize=4096   blocks=4096, version=2
+fssize=64g log      =internal log           bsize=4096   blocks=8192, version=2
+fssize=128g log      =internal log           bsize=4096   blocks=16384, version=2
+fssize=256g log      =internal log           bsize=4096   blocks=32768, version=2
+fssize=512g log      =internal log           bsize=4096   blocks=65536, version=2
+fssize=1024g log      =internal log           bsize=4096   blocks=131072, version=2
+fssize=2048g log      =internal log           bsize=4096   blocks=262144, version=2
+fssize=4096g log      =internal log           bsize=4096   blocks=521728, version=2
+fssize=8192g log      =internal log           bsize=4096   blocks=521728, version=2
+fssize=16384g log      =internal log           bsize=4096   blocks=521728, version=2
Index: xfs-cmds/xfstests/group
===================================================================
--- xfs-cmds.orig/xfstests/group	2008-05-15 16:32:52.489519140 +1000
+++ xfs-cmds/xfstests/group	2008-05-15 22:38:32.000000000 +1000
@@ -275,3 +275,4 @@ filestreams	dgc@sgi.com
 185 dmapi auto
 186 attr auto
 187 attr auto
+188 log metadata auto
