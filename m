Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q7FEXE0B146838 for <xfs@oss.sgi.com>; Wed, 15 Aug 2012 09:33:14 -0500
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id UJUw0b0hND0HHY4u for
	<xfs@oss.sgi.com>; Wed, 15 Aug 2012 07:33:13 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q7FEXC8v010775
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 15 Aug 2012 10:33:13 -0400
Subject: xfststs: Add support for tmpfs filesystem
From: Boris Ranto <branto@redhat.com>
Date: Wed, 15 Aug 2012 16:33:10 +0200
Message-ID: <1345041190.17637.54.camel@localhost>
Mime-Version: 1.0
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
To: xfs <xfs@oss.sgi.com>
Cc: Eric Sandeen <esandeen@redhat.com>, Dave Chinner <dchinner@redhat.com>

This is just a simple patch to get the tmpfs working. I've made the full
xfstests run with the tmpfs as the target filesystem. Some tests passed
properly, some tests failed (and some of them due to the nature of
tmpfs). I'll try to write another patch that would handle the tmpfs
exclusion there where it would not make sense, later (I was thinking of
using _require_scratch_block_dev, _require_test_block_dev,
_require_scratch_stable_mount and _require_test_stable_mount helper
functions).

And one more thing: I didn't change the xfstests logic to recognize a
proper SCRATCH_DEV so the SCRATCH_DEV for tmpfs should be in the nfs
form (with the : in it) for this to work properly.


commit e95ae7d120787921cd390bf2927a209d5c54b2a0
Author: Boris Ranto <branto@redhat.com>
Date:   Wed Aug 15 14:50:36 2012 +0200

    xfstests: Add tmpfs support to xfstets
    This is a simple patch to support tmpfs as a target
    filesystem.
    The patch just copies the way nfs is handled in
    xfstests and adds two new parameters to specify
    tmpfs-specific mkfs and mount options.

diff --git a/common b/common
index 0723224..5853602 100644
--- a/common
+++ b/common
@@ -126,6 +126,7 @@ check options
     -xfs                test XFS (default)
     -udf                test UDF
     -nfs                test NFS
+    -tmpfs              test TMPFS
     -l			line mode diff
     -xdiff		graphical mode diff
     -udiff		show unified diff (default)
@@ -158,6 +159,11 @@ testlist options
 	    xpand=false
 	    ;;
 
+	-tmpfs)	# -tmpfs ... set FSTYP to tmpfs
+	    FSTYP=tmpfs
+	    xpand=false
+	    ;;
+
 	-g)	# -g group ... pick from group file
 	    group=true
 	    xpand=false
diff --git a/common.rc b/common.rc
index 602513a..9189896 100644
--- a/common.rc
+++ b/common.rc
@@ -97,6 +97,10 @@ _mount_opts()
 	# acls aren't turned on by default on gfs2
 	export MOUNT_OPTIONS="-o acl $GFS2_MOUNT_OPTIONS"
 	;;
+    tmpfs)
+	# We need to specify the size at mount, use 512 MB by default
+	export MOUNT_OPTIONS="-o size=512M $TMPFS_MOUNT_OPTIONS"
+	;;
     *)
 	;;
     esac
@@ -116,6 +120,9 @@ _mkfs_opts()
     nfs)
 	export MKFS_OPTIONS=$NFS_MKFS_OPTIONS
 	;;
+    tmpfs)
+	export MKFS_OPTIONS=$TMPFS_MKFS_OPTIONS
+	;;
     reiserfs)
 	export MKFS_OPTIONS="$REISERFS_MKFS_OPTIONS -q"
 	;;
@@ -327,6 +334,9 @@ _scratch_mkfs()
     nfs*)
 	# do nothing for nfs
 	;;
+    tmpfs)
+	# do nothing for tmpfs
+	;;
     udf)
         $MKFS_UDF_PROG $MKFS_OPTIONS $* $SCRATCH_DEV > /dev/null
 	;;
@@ -736,6 +746,12 @@ _require_scratch()
 		     _notrun "this test requires a valid \$SCRATCH_DEV"
 		 fi
 		 ;;
+	tmpfs)
+		if [ -z "$SCRATCH_DEV" -o ! -d "$SCRATCH_MNT" ];
+		then
+		    _notrun "this test requires a valid \$SCRATCH_MNT and unique
$SCRATCH_DEV"
+		fi
+		;;
 	*)
 		 if [ -z "$SCRATCH_DEV" -o "`_is_block_dev $SCRATCH_DEV`" = "" ]
 		 then
@@ -1394,6 +1410,9 @@ _check_test_fs()
     nfs)
 	# no way to check consistency for nfs
 	;;
+    tmpfs)
+        # no way to check the consistency for tmpfs
+	;;
     udf)
 	# do nothing for now
 	;;
@@ -1426,6 +1445,9 @@ _check_scratch_fs()
     nfs*)
 	# Don't know how to check an NFS filesystem, yet.
 	;;
+    tmpfs)
+	# No way to check the consistency of tmpfs
+	;;
     btrfs)
 	_check_btrfs_filesystem $SCRATCH_DEV
 	;;
@@ -1517,6 +1539,33 @@ _setup_nfs_scratchdir()
     testdir=$SCRATCH_MNT
 }
 
+_setup_tmpfs_scratchdir()
+{
+    [ "$FSTYP" != "tmpfs" ] \
+        && _fail "setup_tmpfs_testdir: \$FSTYP is not tmpfs"
+    [ -z "$SCRATCH_DEV" ] \
+	&& _notrun "this test requires a valid host fs for \$SCRATCH_DEV"
+    [ -z "$SCRATCH_MNT" ] \
+	&& _notrun "this test requires a valid \$SCRATCH_MNT"
+
+    # mounted?
+    if _mount | grep -q $SCRATCH_DEV
+    then
+        # if it's mounted, make sure its on $SCRATCH_MNT
+        if ! _mount | grep $SCRATCH_DEV | grep -q $SCRATCH_MNT
+        then
+            _fail "\$SCRATCH_DEV is mounted but not on \$SCRATCH_MNT -
aborting"
+        fi
+    	$UMOUNT_PROG $SCRATCH_DEV
+    fi
+
+    _scratch_mkfs
+    _scratch_mount
+
+    testdir=$SCRATCH_MNT
+}
+
+
 #
 # Warning for UDF and NFS:
 # this function calls _setup_udf_scratchdir and _setup_udf_scratchdir
@@ -1535,6 +1584,9 @@ _setup_testdir()
     nfs*)
 	_setup_nfs_scratchdir
 	;;
+    tmpfs)
+	_setup_tmpfs_scratchdir
+	;;
     *)
 	testdir=$TEST_DIR
 	;;
@@ -1552,6 +1604,10 @@ _cleanup_testdir()
 	# umount testdir as it is $SCRATCH_MNT which could be used by xfs next
 	[ -n "$testdir" ] && $UMOUNT_PROG $testdir
 	;;
+    tmpfs)
+	# umount testdir since it is actually a scrath mount
+	[ -n "$testdir" ] && $UMOUNT_PROG $testdir
+	;;
     *)
 	# do nothing, testdir is $TEST_DIR
 	:
Signed-off-by: Boris Ranto <branto@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
