Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n8G6wEl3019049 for <xfs@oss.sgi.com>; Wed, 16 Sep 2009 01:58:14 -0500
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id AEF704569D9
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2009 23:59:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HbH8g4c8lKrZIklb for
	<xfs@oss.sgi.com>; Tue, 15 Sep 2009 23:59:27 -0700 (PDT)
Received: from int-mx04.intmail.prod.int.phx2.redhat.com
	(int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.17])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id n8G6xQEN003924
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2009 02:59:26 -0400
Received: from loki.usersys.redhat.com (dhcp-lab-108.englab.brq.redhat.com
	[10.34.33.108])
	by int-mx04.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id n8G6xOsh004108
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 16 Sep 2009 02:59:26 -0400
From: Jaroslav Barton <jbarton@redhat.com>
Subject: [PATCH] _check_generic_filesistem support for fsck parameters
Date: Wed, 16 Sep 2009 08:24:05 +0200
Message-Id: <1253082245-5333-1-git-send-email-jbarton@redhat.com>
In-Reply-To: <20090915124908.GA4070@infradead.org>
References: <20090915124908.GA4070@infradead.org>
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
Cc: Jaroslav Barton <jbarton@redhat.com>

_check_generic_filesystem now support fsck parameters. Fsck parameters
can be passed by FSCK_OPTIONS environmental variable. Default values
will be used if FSCK_OPTIONS is missing or empty (same mechanism as
MOUNT_OPTIONS and MKFS_OPTIONS).

_check_extN_filesystem function is no longer needed, extN filesystem are
properly handled by default values in _check_generic_filesystem.
---
 common.rc |   70 ++++++++++++++----------------------------------------------
 1 files changed, 17 insertions(+), 53 deletions(-)

diff --git a/common.rc b/common.rc
index da5f99e..761170d 100644
--- a/common.rc
+++ b/common.rc
@@ -91,9 +91,25 @@ _mkfs_opts()
     esac
 }
 
+_fsck_opts()
+{
+    case $FSTYP in
+    ext2|ext3|ext4)
+	export FSCK_OPTIONS="-nf"
+	;;
+    reiserfs)
+	export FSCK_OPTIONS="--yes"
+	;;
+    *)
+	export FSCK_OPTIONS="-n"
+	;;
+    esac
+}
+
 [ -z "$FSTYP" ] && FSTYP=xfs
 [ -z "$MOUNT_OPTIONS" ] && _mount_opts
 [ -z "$MKFS_OPTIONS" ] && _mkfs_opts
+[ -z "$FSCK_OPTIONS" ] && _fsck_opts
 
 
 # we need common.config
@@ -835,7 +851,7 @@ _check_generic_filesystem()
         mountpoint=`_umount_or_remount_ro $device`
     fi
 
-    fsck -t $FSTYP -n $device >$tmp.fsck 2>&1
+    fsck -t $FSTYP $FSCK_OPTIONS $device >$tmp.fsck 2>&1
     if [ $? -ne 0 ]
     then
         echo "_check_generic_filesystem: filesystem on $device is inconsistent (see $seq.full)"
@@ -865,52 +881,6 @@ _check_generic_filesystem()
     return 0
 }
 
-# Check an ext2/3/4 filesystem
-#
-_check_extN_filesystem()
-{
-    device=$1
-
-    # If type is set, we're mounted
-    type=`_fs_type $device`
-    ok=1
-
-    if [ "$type" = "$FSTYP" ]
-    then
-        # mounted ...
-        mountpoint=`_umount_or_remount_ro $device`
-    fi
-
-    e2fsck -nf $device >$tmp.fsck 2>&1
-    if [ $? -ne 0 ]
-    then
-        echo "_check_extN_filesystem: filesystem on $device is inconsistent (see $seq.full)"
-
-        echo "_check_extN filesystem: filesystem on $device is inconsistent" >>$here/$seq.full
-        echo "*** e2fsck output ***"                          >>$here/$seq.full
-        cat $tmp.fsck                                         >>$here/$seq.full
-        echo "*** end e2fsck output"                          >>$here/$seq.full
-
-        ok=0
-    fi
-    rm -f $tmp.fsck
-
-    if [ $ok -eq 0 ]
-    then
-        echo "*** mount output ***"                           >>$here/$seq.full
-        _mount                                                >>$here/$seq.full
-        echo "*** end mount output"                           >>$here/$seq.full
-    elif [ "$type" = "$FSTYP" ]
-    then
-	# was mounted ...
-	_mount_or_remount_rw "$MOUNT_OPTIONS" $device $mountpoint
-	ok=$?
-    fi
-
-    [ $ok -eq 0 ] && exit 1
-    return 0
-}
-
 # run xfs_check and friends on a FS.
 
 _check_xfs_filesystem()
@@ -1079,9 +1049,6 @@ _check_test_fs()
     udf)
 	# do nothing for now
 	;;
-    ext2|ext3|ext4)
-	_check_extN_filesystem $TEST_DEV
-	;;
     *)
 	_check_generic_filesystem $TEST_DEV
 	;;
@@ -1108,9 +1075,6 @@ _check_scratch_fs()
     nfs*)
 	# Don't know how to check an NFS filesystem, yet.
 	;;
-    ext2|ext3|ext4)
-	_check_extN_filesystem $SCRATCH_DEV
-	;;
     *)
 	_check_generic_filesystem $SCRATCH_DEV
 	;;
-- 
1.6.2.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
