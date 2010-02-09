Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o19JPLA8244488 for <xfs@oss.sgi.com>; Tue, 9 Feb 2010 13:25:22 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2F4311390AED
	for <xfs@oss.sgi.com>; Tue,  9 Feb 2010 11:26:34 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LT4z6YojEhjL1Hg9 for
	<xfs@oss.sgi.com>; Tue, 09 Feb 2010 11:26:34 -0800 (PST)
Message-ID: <4B71B6E7.1000203@redhat.com>
Date: Tue, 09 Feb 2010 13:26:31 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: optionally run all tests under quota
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs-oss <xfs@oss.sgi.com>
Cc: ext4 development <linux-ext4@vger.kernel.org>

This patch might be a little heavy handed, but it seems to
work; if you set USE_QUOTA=1 in your environment, all
tests should be run with quota on and enabled.

This will hopefully help shake out some of the ext4
quota problems, although one needs to keep an eye
on the console to see whether warnings scroll by.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/common.rc b/common.rc
index 6424871..4fde921 100644
--- a/common.rc
+++ b/common.rc
@@ -64,6 +64,9 @@ _mount_opts()
     *)
 	;;
     esac
+    if [ ! -z "$USE_QUOTA" ]; then
+	export MOUNT_OPTIONS="$MOUNT_OPTIONS -o usrquota,grpquota"
+    fi
 }
 
 _mkfs_opts()
@@ -161,6 +164,10 @@ _test_options()
     type=$1
     TEST_OPTIONS=""
 
+    if [ ! -z "$USE_QUOTA" ]; then
+	TEST_OPTIONS="-o usrquota,grpquota"
+    fi
+
     if [ "$FSTYP" != "xfs" ]; then
         return
     fi
@@ -202,6 +209,25 @@ _mount_ops_filter()
 
 }
 
+_setup_quota()
+{
+    mountpoint=$1
+    if [ ! -z "$USE_QUOTA" ]; then
+	case $FSTYP in
+	xfs)
+	    ;;
+	ext*|reiserfs)
+	    quotaoff $mountpoint &>/dev/null
+	    quotacheck -u -g $mountpoint
+	    quotaon $mountpoint
+	    ;;
+	*)
+	    _fail "Don't know how to turn on quota on $FSTYP"
+	    ;;
+	esac
+    fi
+}
+
 _scratch_mount_options()
 {
     _scratch_options mount
@@ -212,6 +238,7 @@ _scratch_mount_options()
 _scratch_mount()
 {
     _mount -t $FSTYP `_scratch_mount_options $*`
+    _setup_quota $SCRATCH_MNT
 }
 
 _scratch_unmount()
@@ -229,6 +256,7 @@ _test_mount()
 {
     _test_options mount
     _mount -t $FSTYP $TEST_OPTIONS $TEST_FS_MOUNT_OPTS $* $TEST_DEV $TEST_DIR
+    _setup_quota $TEST_DIR
 }
 
 _scratch_mkfs_options()

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
