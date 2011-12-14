Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pBE7ognN196322 for <xfs@oss.sgi.com>; Wed, 14 Dec 2011 01:50:42 -0600
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A8E8F1218D61
	for <xfs@oss.sgi.com>; Tue, 13 Dec 2011 23:36:16 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 5fc1FYuiupxUBAQr for
	<xfs@oss.sgi.com>; Tue, 13 Dec 2011 23:36:16 -0800 (PST)
Message-ID: <4EE851B8.8010505@cn.fujitsu.com>
Date: Wed, 14 Dec 2011 15:35:20 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: open btrfsck to check the btrfs filesystem
Reply-To: miaox@cn.fujitsu.com
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

We failed to get fsck program to check the btrfs file system, it is
because btrfs uses its independent check tool which is named btrfsck
to check the file system, so the common checker -- fsck -- could not
find it, and reported there is no checker.

This patch fix it by using btrfsck directly. 

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
---
 common.rc |   54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 54 insertions(+), 0 deletions(-)

diff --git a/common.rc b/common.rc
index cab0b64..b42e46d 100644
--- a/common.rc
+++ b/common.rc
@@ -1299,6 +1299,54 @@ _check_xfs_test_fs()
     fi
 }
 
+_check_btrfs_filesystem()
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
+    btrfsck $device >$tmp.fsck 2>&1
+    if [ $? -ne 0 ]
+    then
+        echo "_check_btrfs_filesystem: filesystem on $device is inconsistent (see $seq.full)"
+
+        echo "_check_btrfs_filesystem: filesystem on $device is inconsistent" >>$here/$seq.full
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
+    if [ $ok -eq 0 ]; then
+	status=1
+	exit 1
+    fi
+
+    return 0
+}
+
 _check_test_fs()
 {
     case $FSTYP in
@@ -1311,6 +1359,9 @@ _check_test_fs()
     udf)
 	# do nothing for now
 	;;
+    btrfs)
+	_check_btrfs_filesystem $TEST_DEV
+	;;
     *)
 	_check_generic_filesystem $TEST_DEV
 	;;
@@ -1337,6 +1388,9 @@ _check_scratch_fs()
     nfs*)
 	# Don't know how to check an NFS filesystem, yet.
 	;;
+    btrfs)
+	_check_btrfs_filesystem $SCRATCH_DEV
+	;;
     *)
 	_check_generic_filesystem $SCRATCH_DEV
 	;;
-- 
1.7.6.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
