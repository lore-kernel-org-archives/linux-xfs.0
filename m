Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E091A7F37
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 11:13:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id BF292304081
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 09:13:46 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 4KW5KDj5IDqh7p1s for <xfs@oss.sgi.com>;
	Thu, 28 Mar 2013 09:13:45 -0700 (PDT)
Received: from relay2.suse.de (unknown [195.135.220.254])
	by mx2.suse.de (Postfix) with ESMTP id 09FCDA5202
	for <xfs@oss.sgi.com>; Thu, 28 Mar 2013 17:13:45 +0100 (CET)
From: David Sterba <dsterba@suse.cz>
Subject: [PATCH] xfstests: use BTRFS_UTIL_PROG instead of btrfs
Date: Thu, 28 Mar 2013 17:13:43 +0100
Message-Id: <1364487223-29249-1-git-send-email-dsterba@suse.cz>
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
Cc: David Sterba <dsterba@suse.cz>

Signed-off-by: David Sterba <dsterba@suse.cz>
---
 tests/btrfs/254 | 12 ++++++------
 tests/btrfs/264 |  4 ++--
 tests/btrfs/265 | 14 +++++++-------
 tests/btrfs/284 |  8 ++++----
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/tests/btrfs/254 b/tests/btrfs/254
index 4a3336c..140e535 100755
--- a/tests/btrfs/254
+++ b/tests/btrfs/254
@@ -58,7 +58,7 @@ dd if=/dev/zero of=$SCRATCH_MNT/foo bs=1M count=1 &> /dev/null
 echo "List root dir"
 ls $SCRATCH_MNT
 echo "Creating snapshot of root dir"
-btrfs subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap | _filter_scratch
+$BTRFS_UTIL_PROG subvolume snapshot $SCRATCH_MNT $SCRATCH_MNT/snap | _filter_scratch
 echo "List root dir after snapshot"
 ls $SCRATCH_MNT
 echo "List snapshot dir"
@@ -70,7 +70,7 @@ echo "List snapshot dir"
 ls $SCRATCH_MNT/snap
 
 # Test creating a normal subvolme
-btrfs subvolume create $SCRATCH_MNT/subvol | _filter_scratch
+$BTRFS_UTIL_PROG subvolume create $SCRATCH_MNT/subvol | _filter_scratch
 echo "Listing root dir"
 ls $SCRATCH_MNT
 echo "Listing subvol"
@@ -80,7 +80,7 @@ ls $SCRATCH_MNT/subvol
 echo "Creating file bar in subvol"
 dd if=/dev/zero of=$SCRATCH_MNT/subvol/bar bs=1M count=1 &> /dev/null
 echo "Setting subvol to the default"
-btrfs subvolume set-default 0 $SCRATCH_MNT/subvol | _filter_scratch
+$BTRFS_UTIL_PROG subvolume set-default 0 $SCRATCH_MNT/subvol | _filter_scratch
 _scratch_remount
 echo "List root dir which is now subvol"
 ls $SCRATCH_MNT
@@ -90,17 +90,17 @@ _scratch_mount "-o subvolid=0"
 echo "List root dir"
 ls $SCRATCH_MNT
 echo "Setting the root dir as the default again"
-btrfs subvolume set-default 0 $SCRATCH_MNT | _filter_scratch
+$BTRFS_UTIL_PROG subvolume set-default 0 $SCRATCH_MNT | _filter_scratch
 _scratch_remount
 echo "List root dir"
 ls $SCRATCH_MNT
 
 # Test listing the subvolumes
 echo "Listing subvolumes"
-btrfs subvolume list $SCRATCH_MNT | awk '{ print $NF }'
+$BTRFS_UTIL_PROG subvolume list $SCRATCH_MNT | awk '{ print $NF }'
 
 # Delete the snapshot
-btrfs subvolume delete $SCRATCH_MNT/snap | _filter_scratch
+$BTRFS_UTIL_PROG subvolume delete $SCRATCH_MNT/snap | _filter_scratch
 echo "List root dir"
 ls $SCRATCH_MNT
 _scratch_remount
diff --git a/tests/btrfs/264 b/tests/btrfs/264
index ed08403..ab814c7 100755
--- a/tests/btrfs/264
+++ b/tests/btrfs/264
@@ -83,7 +83,7 @@ _create_snap()
 	local x
 	[ -d $1 ] || _fail "Destination dir $1 not present"
 	SNAPNAME=`mktemp -u $SCRATCH_MNT/snap.XXXXXX`
-	btrfs subvolume snapshot $1 $SNAPNAME > /dev/null || _fail "snapshot create failed"
+	$BTRFS_UTIL_PROG subvolume snapshot $1 $SNAPNAME > /dev/null || _fail "snapshot create failed"
 }
 
 # Reads and writes new data but does not allocate new blocks
@@ -152,7 +152,7 @@ _append_file()
 ##################### real QA test starts here###################################
 # sv1 - is just a name nothing spl
 firstvol="$SCRATCH_MNT/sv1"
-btrfs subvolume create $firstvol > /dev/null || _fail "btrfs subvolume create $firstvol failed"
+$BTRFS_UTIL_PROG subvolume create $firstvol > /dev/null || _fail "btrfs subvolume create $firstvol failed"
 dirp=`mktemp -duq $firstvol/dir.XXXXXX`
 _populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10 -x
 SNAPNAME=0
diff --git a/tests/btrfs/265 b/tests/btrfs/265
index f78ed24..7837cc3 100755
--- a/tests/btrfs/265
+++ b/tests/btrfs/265
@@ -110,9 +110,9 @@ _test_add()
 	dirp=`mktemp -duq $SCRATCH_MNT/dir.XXXXXX`
 	_populate_fs -n 1 -f 20 -d 10 -r $dirp -s 10
 	for i in `seq 1 $n`; do
-		btrfs device add ${devs[$i]} $SCRATCH_MNT > /dev/null 2>&1 || _fail "device add failed"
+		$BTRFS_UTIL_PROG device add ${devs[$i]} $SCRATCH_MNT > /dev/null 2>&1 || _fail "device add failed"
 	done
-	btrfs filesystem balance $SCRATCH_MNT || _fail "balance failed"
+	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT || _fail "balance failed"
 	umount $SCRATCH_MNT
 }
 
@@ -146,16 +146,16 @@ _test_replace()
 	_devmgt_remove ${DEVHTL}
 	dev_removed=1
 
-	btrfs fi show $SCRATCH_DEV | grep "Some devices missing" > /dev/null || _fail \
+	$BTRFS_UTIL_PROG fi show $SCRATCH_DEV | grep "Some devices missing" > /dev/null || _fail \
 							"btrfs did not report device missing"
 
 	# add a new disk to btrfs
 	ds=${devs[@]:$(($n)):1}
-	btrfs device add ${ds} $SCRATCH_MNT > /dev/null 2>&1 || _fail "dev add failed"
+	$BTRFS_UTIL_PROG device add ${ds} $SCRATCH_MNT > /dev/null 2>&1 || _fail "dev add failed"
 	# in some system balance fails if there is no delay (a bug)
 	# putting sleep 10 to work around as of now
 	# sleep 10
-	btrfs fi balance $SCRATCH_MNT || _fail "dev balance failed"
+	$BTRFS_UTIL_PROG filesystem balance $SCRATCH_MNT || _fail "dev balance failed"
 
 	# cleaup. add the removed disk
 	umount $SCRATCH_MNT
@@ -172,8 +172,8 @@ _test_remove()
 
 	# pick last dev in the list
 	dev_del=`echo ${SCRATCH_DEV_POOL} | awk '{print $NF}'`
-	btrfs device delete $dev_del $SCRATCH_MNT || _fail "btrfs device delete failed"
-	btrfs fi show $SCRATCH_DEV 2>&1 | grep $dev_del > /dev/null && _fail "btrfs still shows the deleted dev"
+	$BTRFS_UTIL_PROG device delete $dev_del $SCRATCH_MNT || _fail "btrfs device delete failed"
+	$BTRFS_UTIL_PROG filesystem show $SCRATCH_DEV 2>&1 | grep $dev_del > /dev/null && _fail "btrfs still shows the deleted dev"
 	umount $SCRATCH_MNT
 }
 
diff --git a/tests/btrfs/284 b/tests/btrfs/284
index 9c260b2..1f79acc 100644
--- a/tests/btrfs/284
+++ b/tests/btrfs/284
@@ -79,14 +79,14 @@ _btrfs_online_defrag()
 	fi
 
 	if [ "$str" != "" ]; then
-		btrfs filesystem defragment $str $SCRATCH_MNT/tmp_file
+		$BTRFS_UTIL_PROG filesystem defragment $str $SCRATCH_MNT/tmp_file
 	else
 		if [ "$1" = "1" ];then
-			btrfs filesystem defragment $SCRATCH_MNT/tmp_file
+			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT/tmp_file
 		elif [ "$1" = "2" ];then
-			btrfs filesystem defragment $SCRATCH_MNT/tmp_dir
+			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT/tmp_dir
 		elif [ "$1" = "3" ];then
-			btrfs filesystem defragment $SCRATCH_MNT
+			$BTRFS_UTIL_PROG filesystem defragment $SCRATCH_MNT
 		fi
 	fi
 	ret_val=$?
-- 
1.8.2

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
