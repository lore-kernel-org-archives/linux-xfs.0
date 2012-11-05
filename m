Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA6El1w0065821 for <xfs@oss.sgi.com>; Tue, 6 Nov 2012 08:47:02 -0600
Received: from gulag1.americas.sgi.com (gulag1.americas.sgi.com
	[128.162.236.41])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CBCD08F8049
	for <xfs@oss.sgi.com>; Tue,  6 Nov 2012 06:48:55 -0800 (PST)
Message-Id: <20121105150150.558785273@sgi.com>
Date: Mon, 05 Nov 2012 09:01:34 -0600
From: rjohnston@sgi.com
Subject: [patch] xfstests: Revert commit edd6bc "optionally run all tests
	under quota"
References: <20121105150133.857716755@sgi.com>
Content-Disposition: inline; filename=xfstests-revert-commit-edd6bc.patch
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

Revert commit edd6bc which causes the following tests to fail:

142.out.bad:Can't initialize the DMAPI
143.out.bad:Can't initialize the DMAPI
144.out.bad:Can't initialize the DMAPI
145.out.bad:Can't initialize the DMAPI
146.out.bad:Can't initialize the DMAPI
147.out.bad:Can't initialize the DMAPI
150.out.bad:Can't initialize the DMAPI
155.out.bad:Can't initialize the DMAPI
156.out.bad:Can't initialize the DMAPI
157.out.bad:Can't initialize the DMAPI
158.out.bad:Can't initialize the DMAPI
161.out.bad:Can't initialize the DMAPI
168.out.bad:Can't initialize the DMAPI
175.out.bad:Can't initialize the DMAPI
176.out.bad:Can't initialize the DMAPI
185.out.bad:Can't initialize the DMAPI

Signed-off-by: Rich Johnston <rjohnston@sgi.com>

Index: xfstests/common.rc
===================================================================
--- xfstests.orig/common.rc
+++ xfstests/common.rc
@@ -100,9 +100,6 @@ _mount_opts()
     *)
 	;;
     esac
-    if [ ! -z "$USE_QUOTA" ]; then
-	export MOUNT_OPTIONS="$MOUNT_OPTIONS -o usrquota,grpquota"
-    fi
 }
 
 _mkfs_opts()
@@ -203,10 +200,6 @@ _test_options()
     type=$1
     TEST_OPTIONS=""
 
-    if [ ! -z "$USE_QUOTA" ]; then
-	TEST_OPTIONS="-o usrquota,grpquota"
-    fi
-
     if [ "$FSTYP" != "xfs" ]; then
         return
     fi
@@ -248,25 +241,6 @@ _mount_ops_filter()
 
 }
 
-_setup_quota()
-{
-    mountpoint=$1
-    if [ ! -z "$USE_QUOTA" ]; then
-	case $FSTYP in
-	xfs)
-	    ;;
-	ext*|reiserfs)
-	    quotaoff $mountpoint &>/dev/null
-	    quotacheck -u -g $mountpoint
-	    quotaon $mountpoint
-	    ;;
-	*)
-	    _fail "Don't know how to turn on quota on $FSTYP"
-	    ;;
-	esac
-    fi
-}
-
 _scratch_mount_options()
 {
     _scratch_options mount
@@ -277,7 +251,6 @@ _scratch_mount_options()
 _scratch_mount()
 {
     _mount -t $FSTYP `_scratch_mount_options $*`
-    _setup_quota $SCRATCH_MNT
 }
 
 _scratch_unmount()
@@ -295,7 +268,6 @@ _test_mount()
 {
     _test_options mount
     _mount -t $FSTYP $TEST_OPTIONS $TEST_FS_MOUNT_OPTS $SELINUX_MOUNT_OPTIONS $* $TEST_DEV $TEST_DIR
-    _setup_quota $TEST_DIR
 }
 
 _scratch_mkfs_options()


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
