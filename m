Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7IEvcR8146699 for <xfs@oss.sgi.com>; Tue, 18 Aug 2009 09:57:48 -0500
Received: from thunker.thunk.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8A1614D131C
	for <xfs@oss.sgi.com>; Tue, 18 Aug 2009 07:57:55 -0700 (PDT)
Received: from thunker.thunk.org (THUNK.ORG [69.25.196.29]) by cuda.sgi.com
	with ESMTP id 8QIfhcfWI5bdqNVh for <xfs@oss.sgi.com>;
	Tue, 18 Aug 2009 07:57:55 -0700 (PDT)
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH] Add ext2/3/4-specific _check_extN_filesystem function
Date: Tue, 18 Aug 2009 10:57:47 -0400
Message-Id: <1250607467-15085-1-git-send-email-tytso@mit.edu>
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
Cc: Theodore Ts'o <tytso@mit.edu>

The _check_generic_filesystem function doesn't force a full filesystem
check, so filesystem inconsistencies after a test wouldn't be noticed.
To fix this, I added an extN specific check filesystem function.

Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 common.rc |   52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/common.rc b/common.rc
index 82b0d51..da5f99e 100644
--- a/common.rc
+++ b/common.rc
@@ -865,6 +865,52 @@ _check_generic_filesystem()
     return 0
 }
 
+# Check an ext2/3/4 filesystem
+#
+_check_extN_filesystem()
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
+    e2fsck -nf $device >$tmp.fsck 2>&1
+    if [ $? -ne 0 ]
+    then
+        echo "_check_extN_filesystem: filesystem on $device is inconsistent (see $seq.full)"
+
+        echo "_check_extN filesystem: filesystem on $device is inconsistent" >>$here/$seq.full
+        echo "*** e2fsck output ***"                          >>$here/$seq.full
+        cat $tmp.fsck                                         >>$here/$seq.full
+        echo "*** end e2fsck output"                          >>$here/$seq.full
+
+        ok=0
+    fi
+    rm -f $tmp.fsck
+
+    if [ $ok -eq 0 ]
+    then
+        echo "*** mount output ***"                           >>$here/$seq.full
+        _mount                                                >>$here/$seq.full
+        echo "*** end mount output"                           >>$here/$seq.full
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
 # run xfs_check and friends on a FS.
 
 _check_xfs_filesystem()
@@ -1033,6 +1079,9 @@ _check_test_fs()
     udf)
 	# do nothing for now
 	;;
+    ext2|ext3|ext4)
+	_check_extN_filesystem $TEST_DEV
+	;;
     *)
 	_check_generic_filesystem $TEST_DEV
 	;;
@@ -1059,6 +1108,9 @@ _check_scratch_fs()
     nfs*)
 	# Don't know how to check an NFS filesystem, yet.
 	;;
+    ext2|ext3|ext4)
+	_check_extN_filesystem $SCRATCH_DEV
+	;;
     *)
 	_check_generic_filesystem $SCRATCH_DEV
 	;;
-- 
1.6.3.2.1.gb9f7d.dirty

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
