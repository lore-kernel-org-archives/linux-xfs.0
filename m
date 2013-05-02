Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 634C77F59
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 09:04:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F2859AC002
	for <xfs@oss.sgi.com>; Thu,  2 May 2013 07:04:18 -0700 (PDT)
Received: from mail-wi0-f180.google.com (mail-wi0-f180.google.com
	[209.85.212.180]) by cuda.sgi.com with ESMTP id
	ja8QSQVgryDYlV8E (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 02 May 2013 07:04:17 -0700 (PDT)
Received: by mail-wi0-f180.google.com with SMTP id h11so621864wiv.13
	for <xfs@oss.sgi.com>; Thu, 02 May 2013 07:04:16 -0700 (PDT)
From: ranto.boris@gmail.com
Subject: [PATCH 1/3] xfstests: Add tmpfs support
Date: Thu,  2 May 2013 16:03:57 +0200
Message-Id: <1367503439-12827-2-git-send-email-ranto.boris@gmail.com>
In-Reply-To: <1367503439-12827-1-git-send-email-ranto.boris@gmail.com>
References: <1367503439-12827-1-git-send-email-ranto.boris@gmail.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: Boris Ranto <ranto.boris@gmail.com>

From: Boris Ranto <ranto.boris@gmail.com>

This is just a simple patch to get the tmpfs working as a target file
system. The patch copies the way nfs is handled in xfstests.

I didn't change the xfstests logic to recognize a proper SCRATCH_DEV.
Hence, the SCRATCH_DEV for tmpfs should be in nfs form (with ':' sign
in it) in order for this to work properly.

Signed-off-by: Boris Ranto <ranto.boris@gmail.com>
---
 check     |    2 ++
 common/rc |   55 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 0 deletions(-)

diff --git a/check b/check
index 966fbe5..fc335ec 100755
--- a/check
+++ b/check
@@ -76,6 +76,7 @@ check options
     -xfs                test XFS (default)
     -udf                test UDF
     -nfs                test NFS
+    -tmpfs              test TMPFS
     -l			line mode diff
     -udiff		show unified diff (default)
     -n			show me, do not run tests
@@ -162,6 +163,7 @@ while [ $# -gt 0 ]; do
 	-udf)	FSTYP=udf ;;
 	-xfs)	FSTYP=xfs ;;
 	-nfs)	FSTYP=nfs ;;
+	-tmpfs)	FSTYP=tmpfs ;;
 
 	-g)	group=$2 ; shift ;
 		group_list=$(get_group_list $group)
diff --git a/common/rc b/common/rc
index 8e37368..4825371 100644
--- a/common/rc
+++ b/common/rc
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
@@ -125,6 +129,9 @@ _mkfs_opts()
     jfs)
 	export MKFS_OPTIONS="$JFS_MKFS_OPTIONS -q"
 	;;
+    tmpfs)
+	export MKFS_OPTIONS="$TMPFS_MKFS_OPTIONS"
+	;;
     *)
 	;;
     esac
@@ -520,6 +527,9 @@ _scratch_mkfs()
     ext4)
 	_scratch_mkfs_ext4 $*
 	;;
+    tmpfs)
+	# do nothing for tmpfs
+	;;
     *)
 	yes | $MKFS_PROG -t $FSTYP -- $MKFS_OPTIONS $* $SCRATCH_DEV
 	;;
@@ -930,6 +940,12 @@ _require_scratch()
 		     _notrun "this test requires a valid \$SCRATCH_DEV"
 		 fi
 		 ;;
+	tmpfs)
+		if [ -z "$SCRATCH_DEV" -o ! -d "$SCRATCH_MNT" ];
+		then
+		    _notrun "this test requires a valid \$SCRATCH_MNT and unique $SCRATCH_DEV"
+		fi
+		;;
 	*)
 		 if [ -z "$SCRATCH_DEV" -o "`_is_block_dev $SCRATCH_DEV`" = "" ]
 		 then
@@ -1626,6 +1642,9 @@ _check_test_fs()
     btrfs)
 	_check_btrfs_filesystem $TEST_DEV
 	;;
+    tmpfs)
+	# no way to check the consistency of tmpfs
+	;;
     *)
 	_check_generic_filesystem $TEST_DEV
 	;;
@@ -1655,6 +1674,9 @@ _check_scratch_fs()
     btrfs)
 	_check_btrfs_filesystem $SCRATCH_DEV
 	;;
+    tmpfs)
+	# No way to check the consistency of tmpfs
+	;;
     *)
 	_check_generic_filesystem $SCRATCH_DEV
 	;;
@@ -1743,6 +1765,32 @@ _setup_nfs_scratchdir()
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
+            _fail "\$SCRATCH_DEV is mounted but not on \$SCRATCH_MNT - aborting"
+        fi
+        $UMOUNT_PROG $SCRATCH_DEV
+    fi
+
+    _scratch_mkfs
+    _scratch_mount
+
+    testdir=$SCRATCH_MNT
+}
+
 #
 # Warning for UDF and NFS:
 # this function calls _setup_udf_scratchdir and _setup_udf_scratchdir
@@ -1761,6 +1809,9 @@ _setup_testdir()
     nfs*)
 	_setup_nfs_scratchdir
 	;;
+    tmpfs)
+	_setup_tmpfs_scratchdir
+	;;
     *)
 	testdir=$TEST_DIR
 	;;
@@ -1778,6 +1829,10 @@ _cleanup_testdir()
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
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
