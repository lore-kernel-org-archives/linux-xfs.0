Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n52HPT6W115510 for <xfs@oss.sgi.com>; Tue, 2 Jun 2009 12:25:30 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D37561042B54
	for <xfs@oss.sgi.com>; Tue,  2 Jun 2009 10:32:13 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id YyVCa9xAzwo9Hx3u for
	<xfs@oss.sgi.com>; Tue, 02 Jun 2009 10:32:13 -0700 (PDT)
Date: Tue, 2 Jun 2009 13:25:42 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 8/9] Enable generic filesystems to be fsck'd
Message-ID: <20090602172542.GA21701@infradead.org>
References: <1243450413-12681-1-git-send-email-sandeen@sandeen.net>
	<1243450413-12681-9-git-send-email-sandeen@sandeen.net>
	<20090528125128.GA13425@infradead.org>
	<20090602123852.GA4101@infradead.org>
	<4A2540F4.4050204@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A2540F4.4050204@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Tue, Jun 02, 2009 at 10:10:44AM -0500, Eric Sandeen wrote:
> Maybe we should move the mountpoint assignment outside the conditional,
> since we echo it unconditionally.  Only the !USE_REMOUNT case cares
> anyway but still...

It's only used to be passed as an argument to _mount_or_remount_rw
where we only care for the !USE_REMOUNT case.

So I've left this one as-is and fixed up all other issues.


Index: xfstests-dev/common.rc
===================================================================
--- xfstests-dev.orig/common.rc	2009-06-02 12:12:24.000000000 +0000
+++ xfstests-dev/common.rc	2009-06-02 17:10:20.000000000 +0000
@@ -707,29 +707,29 @@
     [ "$?" == "0" ] || _notrun "$qa_user user not defined."
 }
 
-# check that a FS is mounted as XFS. if so, return mount point
+# check that a FS on a device is mounted
+# if so, return mount point
 #
-_xfs_mounted()
+_is_mounted()
 {
     if [ $# -ne 1 ]
     then
-	echo "Usage: _xfs_mounted device" 1>&2
+	echo "Usage: _is_mounted device" 1>&2
 	exit 1
     fi
 
     device=$1
 
-    if _mount | grep "$device " | $AWK_PROG '
-        /type xfs/  { print $3 ; exit 0 }
-        END         { exit 1 }
+    if _mount | grep "$device " | $AWK_PROG -v pattern="type $FSTYP" '
+        pattern        { print $3 ; exit 0 }
+        END            { exit 1 }
     '
     then
-        echo "_xfs_mounted: $device is not a mounted XFS FS"
+        echo "_is_mounted: $device is not a mounted $FSTYP FS"
         exit 1
     fi
 }
 
-
 # remount a FS to a new mode (ro or rw)
 #
 _remount()
@@ -749,14 +749,112 @@
     fi
 }
 
-# run xfs_check and friends on a FS.
+# Run the appropriate repair/check on a filesystem
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
+	echo "Usage: _umount_or_remount_ro <device>" 1>&2
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
+	echo "Usage: _mount_or_remount_rw <opts> <device> <mountpoint>" 1>&2
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
+# Check a generic filesystem in no-op mode; this assumes that the
+# underlying fsck program accepts "-n" for a no-op (check-only) run,
+# and that it will still return an errno for corruption in this mode.
+#
+# Filesystems which don't support this will need to define their
+# own check routine.
+#
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
+	# was mounted ...
+	_mount_or_remount_rw "$MOUNT_OPTIONS" $device $mountpoint
+	ok=$?
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
@@ -787,15 +885,8 @@
 
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
@@ -848,17 +939,7 @@
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
@@ -908,12 +989,8 @@
 
 }
 
-_check_test_fs()
+_check_xfs_test_fs()
 {
-    if [ "$FSTYP" != "xfs" ]; then
-        return
-    fi
-
     TEST_LOG="none"
     TEST_RT="none"
     [ "$USE_EXTERNAL" = yes -a ! -z "$TEST_LOGDEV" ] && \
@@ -932,6 +1009,24 @@
     fi
 }
 
+_check_test_fs()
+{
+    case $FSTYP in
+    xfs)
+	_check_xfs_test_fs
+	;;
+    nfs)
+	# no way to check consistency for nfs
+	;;
+    udf)
+	# do nothing for now
+	;;
+    *)
+	_check_generic_filesystem $TEST_DEV
+	;;
+    esac
+}
+
 _check_scratch_fs()
 {
     case $FSTYP in
@@ -953,6 +1048,7 @@
 	# Don't know how to check an NFS filesystem, yet.
 	;;
     *)
+	_check_generic_filesystem $SCRATCH_DEV
 	;;
     esac
 }
@@ -987,25 +1083,6 @@
      echo "$os/$platform $host $kernel"
 }
 
-_check_testdir()
-{
-    case $FSTYP in
-    xfs)
-	_check_test_fs
-	;;
-    udf)
-	_cleanup_testdir
-	_check_scratch_fs
-	_scratch_mount
-	;;
-    nfs*)
-	# Don't know how to check an NFS filesystem, yet.
-	;;
-    *)
-	;;
-    esac
-}
-
 _setup_udf_scratchdir()
 {
     [ "$FSTYP" != "udf" ] \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
