Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4RIrNdX204177 for <xfs@oss.sgi.com>; Wed, 27 May 2009 13:53:23 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 09E821A2DC47
	for <xfs@oss.sgi.com>; Wed, 27 May 2009 11:53:36 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id MiDo01HGPjMsuj6D for
	<xfs@oss.sgi.com>; Wed, 27 May 2009 11:53:36 -0700 (PDT)
From: Eric Sandeen <sandeen@sandeen.net>
Subject: [PATCH 8/9] Enable generic filesystems to be fsck'd
Date: Wed, 27 May 2009 13:53:32 -0500
Message-Id: <1243450413-12681-9-git-send-email-sandeen@sandeen.net>
In-Reply-To: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
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
Cc: Eric Sandeen <sandeen@sandeen.net>

This includes a fair bit of rearranging to avoid code duplication,
but the goal is to allow 'fsck -n -t $FSTYP $device' to be run on
any generic filesystem.

Any FS for which this doesn't work will need it's own fsck routine.

Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
---
 common.rc |  164 ++++++++++++++++++++++++++++++++++++++++++++++++-------------
 1 files changed, 130 insertions(+), 34 deletions(-)

diff --git a/common.rc b/common.rc
index 54c36f3..c0e6582 100644
--- a/common.rc
+++ b/common.rc
@@ -693,29 +693,36 @@ _require_user()
     [ "$?" == "0" ] || _notrun "$qa_user user not defined."
 }
 
-# check that a FS is mounted as XFS. if so, return mount point
+# check that a FS on a device ($1) is mounted (optionally as fstype ($2)).
+# if so, return mount point
 #
-_xfs_mounted()
+_is_mounted()
 {
-    if [ $# -ne 1 ]
+    if [ $# -le 0 -o $# -ge 3 ]
     then
-	echo "Usage: _xfs_mounted device" 1>&2
+	echo "Usage: _is_mounted device [fstype]" 1>&2
 	exit 1
     fi
 
     device=$1
 
-    if _mount | grep "$device " | $AWK_PROG '
-        /type xfs/  { print $3 ; exit 0 }
-        END         { exit 1 }
+    if [ $# -eq 2 ]
+    then
+	fstype=$2
+    else
+	fstype=$FSTYP
+    fi
+
+    if _mount | grep "$device " | $AWK_PROG -v pattern="type $fstype" '
+        pattern        { print $3 ; exit 0 }
+        END            { exit 1 }
     '
     then
-        echo "_xfs_mounted: $device is not a mounted XFS FS"
+        echo "_is_mounted: $device is not a mounted $fstype FS"
         exit 1
     fi
 }
 
-
 # remount a FS to a new mode (ro or rw)
 #
 _remount()
@@ -735,14 +742,105 @@ _remount()
     fi
 }
 
-# run xfs_check and friends on a FS.
+# Run the apropriate repair/check on a filesystem
 #
 # if the filesystem is mounted, it's either remounted ro before being
 # checked or it's unmounted and then remounted
 #
 
+# If set, we remount ro instead of unmounting for fsck
 USE_REMOUNT=0
 
+_umount_or_remount_ro()
+{
+    if [ $# -ne 1 ]
+    then
+	echo "Usage: _umount_or_remount_ro device" 1>&2
+	exit 1
+    fi
+    device=$1
+
+    if [ $USE_REMOUNT -eq 0 ]
+    then
+        mountpoint=`_is_mounted $device`
+        $UMOUNT_PROG $device
+    else
+        _remount $device ro
+    fi
+    echo "$mountpoint"
+}
+
+_mount_or_remount_rw()
+{
+    if [ $# -ne 3 ]
+    then
+	echo "Usage: _mount_or_remount_rw opts device mountpoint" 1>&2
+	exit 1
+    fi
+    mount_opts=$1
+    device=$2
+    mountpoint=$3
+
+    if [ $USE_REMOUNT -eq 0 ]
+    then
+        if ! _mount -t $FSTYP $mount_opts $device $mountpoint
+        then
+            echo "!!! failed to remount $device on $mountpoint"
+            return 0 # ok=0
+        fi
+    else
+        _remount $device rw
+    fi
+
+    return 1 # ok=1
+}
+
+_check_generic_filesystem()
+{
+    device=$1
+
+    # If type is set, we're mounted
+    type=`_fs_type $device`
+    ok=1
+
+    if [ "$type" = "$FSTYP" ]
+    then
+        # mounted ...
+        mountpoint=`_umount_or_remount_ro $device`
+    fi
+
+    fsck -t $FSTYP -n $device >$tmp.fsck 2>&1
+    if [ $? -ne 0 ]
+    then
+        echo "_check_generic_filesystem: filesystem on $device is inconsistent (see $seq.full)"
+
+        echo "_check_generic filesystem: filesystem on $device is inconsistent" >>$here/$seq.full
+        echo "*** fsck.$FSTYP output ***"                     >>$here/$seq.full
+        cat $tmp.fsck                                         >>$here/$seq.full
+        echo "*** end fsck.$FSTYP output"                     >>$here/$seq.full
+
+        ok=0
+    fi
+    rm -f $tmp.fsck
+
+    if [ $ok -eq 0 ]
+    then
+        echo "*** mount output ***"                             >>$here/$seq.full
+        _mount                                                  >>$here/$seq.full
+        echo "*** end mount output"                             >>$here/$seq.full
+    elif [ "$type" = "$FSTYP" ]
+    then
+        # was mounted ...
+	_mount_or_remount_rw "$MOUNT_OPTIONS" $device $mountpoint
+        ok=$?
+    fi
+
+    [ $ok -eq 0 ] && exit 1
+    return 0
+}
+
+# run xfs_check and friends on a FS.
+
 _check_xfs_filesystem()
 {
     if [ $# -ne 3 ]
@@ -773,15 +871,8 @@ _check_xfs_filesystem()
 
     if [ "$type" = "xfs" ]
     then
-        # mounted...
-
-        if [ $USE_REMOUNT -eq 0 ]
-        then
-            mountpoint=`_xfs_mounted $device`
-            $UMOUNT_PROG $device
-        else
-            _remount $device ro
-        fi
+        # mounted ...
+        mountpoint=`_umount_or_remount_ro $device`
     fi
 
     $XFS_LOGPRINT_PROG -t $extra_log_options $device 2>&1 \
@@ -834,17 +925,7 @@ _check_xfs_filesystem()
         echo "*** end mount output"                             >>$here/$seq.full
     elif [ "$type" = "xfs" ]
     then
-        # mounted...
-        if [ $USE_REMOUNT -eq 0 ]
-        then
-            if ! _mount -t xfs $extra_mount_options $device $mountpoint
-            then
-                echo "!!! failed to remount $device on $mountpoint"
-                ok=0
-            fi
-        else
-            _remount $device rw
-        fi
+	_mount_or_remount_rw "$extra_mount_options" $device $mountpoint
     fi
 
     [ $ok -eq 0 ] && exit 1
@@ -894,12 +975,13 @@ _check_udf_filesystem()
 
 }
 
-_check_test_fs()
+_check_generic_test_fs()
 {
-    if [ "$FSTYP" != "xfs" ]; then
-        return
-    fi
+    _check_generic_filesystem $TEST_DEV
+}
 
+_check_xfs_test_fs()
+{
     TEST_LOG="none"
     TEST_RT="none"
     [ "$USE_EXTERNAL" = yes -a ! -z "$TEST_LOGDEV" ] && \
@@ -918,6 +1000,18 @@ _check_test_fs()
     fi
 }
 
+_check_test_fs()
+{
+    case $FSTYP in
+    xfs)
+	_check_xfs_test_fs
+	;;
+    *)
+	_check_generic_test_fs
+	;;
+    esac
+}
+
 _check_scratch_fs()
 {
     case $FSTYP in
@@ -939,6 +1033,7 @@ _check_scratch_fs()
 	# Don't know how to check an NFS filesystem, yet.
 	;;
     *)
+	_check_generic_filesystem $SCRATCH_DEV
 	;;
     esac
 }
@@ -988,6 +1083,7 @@ _check_testdir()
 	# Don't know how to check an NFS filesystem, yet.
 	;;
     *)
+	_check_generic_test_fs
 	;;
     esac
 }
-- 
1.5.5.6

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
