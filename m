Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q6Q8ZMQ5000811 for <xfs@oss.sgi.com>; Thu, 26 Jul 2012 03:35:23 -0500
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	83ALUZGgDqaHkrEm for <xfs@oss.sgi.com>;
	Thu, 26 Jul 2012 01:35:21 -0700 (PDT)
Received: from disappointment ([192.168.1.1]) by dastard with esmtp (Exim 4.76)
	(envelope-from <dave@fromorbit.com>) id 1SuJXS-00012n-QN
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:35:18 +1000
Received: from dave by disappointment with local (Exim 4.80)
	(envelope-from <dave@disappointment.disaster>) id 1SuJXI-0003sy-ML
	for xfs@oss.sgi.com; Thu, 26 Jul 2012 18:35:08 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 4/4] xfstests: speed up 227 by using preallocation
Date: Thu, 26 Jul 2012 18:35:06 +1000
Message-Id: <1343291706-14882-5-git-send-email-david@fromorbit.com>
In-Reply-To: <1343291706-14882-1-git-send-email-david@fromorbit.com>
References: <1343291706-14882-1-git-send-email-david@fromorbit.com>
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

From: Dave Chinner <dchinner@redhat.com>

Test 227 (fsr test) creates fragmented fre space by doing lots of
small writes to sparse offsets ni a file. This seeks the disk heads
around a lot writing data. We don't need to write data - just
trigger allocation. Hence use preallocation instead of data writes
and run at allocation speed rather than data write speed.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 227 |   46 +++++++++++++++++++++++++++++++++-------------
 1 file changed, 33 insertions(+), 13 deletions(-)

diff --git a/227 b/227
index cb7fa70..dfcb1a5 100755
--- a/227
+++ b/227
@@ -52,6 +52,8 @@ _supported_fs xfs
 _supported_os Linux
 _require_scratch
 
+rm -f $seq.full
+
 [ "$XFS_FSR_PROG" = "" ] && _notrun "xfs_fsr not found"
 
 # create freespace holes of 1-3 blocks in length
@@ -62,26 +64,41 @@ _require_scratch
 # (say 5 extents) and lots of variations around that dependent on the
 # number of attributes in the files being defragmented.
 #
+# We have to make sure there are enough free inodes for the test to
+# pass without needing to allocate new clusters during the test.
+# With such fragemented free space, that will fail.
+#
 fragment_freespace()
 {
 	_file="$SCRATCH_MNT/not_free"
+	_dir="$SCRATCH_MNT/saved"
 
-	for i in `seq 0 1 10000`; do
-		echo foo > $_file.$i
+	# allocate inode space
+	mkdir -p $_dir
+	for i in `seq 0 1 1000`; do
+		touch $_file.$i
 	done
-	sync
-
-	for i in `seq 0 2 10000`; do
-		rm -f $_file.$i
+	for i in `seq 0 63 1000`; do
+		mv $_file.$i $_dir
 	done
-	for i in `seq 0 7 10000`; do
+	for i in `seq 0 1 1000`; do
 		rm -f $_file.$i
 	done
+
+	$XFS_IO_PROG -fs -c "resvsp 0 40000k" $_file > /dev/null 2>&1
+
+	for i in `seq 0 8 40000`; do
+		$XFS_IO_PROG -f -c "unresvsp ${i}k 4k" $_file \
+					> /dev/null 2>&1
+	done
+	for i in `seq 0 28 40000`; do
+		$XFS_IO_PROG -f -c "unresvsp ${i}k 4k" $_file \
+					> /dev/null 2>&1
+	done
 	sync
 
 	# and now use up all the remaining extents larger than 3 blocks
-	dd if=/dev/zero of=$_file.large bs=4k count=1024 > /dev/null 2>&1
-	sync
+	$XFS_IO_PROG -fs -c "resvsp 0 4m" $_file.large > /dev/null 2>&1
 }
 
 create_attrs()
@@ -93,11 +110,12 @@ create_attrs()
 
 create_data()
 {
+	size=`expr \( $1 + 1 \) \* 4096`
+	$XFS_IO_PROG -f -c "truncate $size" $2 > /dev/null 2>&1
 	for foo in `seq $1 -1 0`; do
 		let offset=$foo*4096
-		$XFS_IO_PROG -f -c "pwrite $offset 4096" -c "fsync" $2 > /dev/null 2>&1
+		$XFS_IO_PROG -f -c "resvsp $offset 4096" $2 > /dev/null 2>&1
 	done
-	xfs_bmap -vp $2
 }
 
 # create the designated file with a certain number of attributes and a certain
@@ -113,7 +131,7 @@ create_target_attr_first()
 	target=$3
 
 	rm -f $target
-	echo > $target
+	touch $target
 	create_attrs $nattrs $target
 	create_data $file_blocks $target
 }
@@ -131,7 +149,7 @@ create_target_attr_last()
 	target=$3
 
 	rm -f $target
-	echo > $target
+	touch $target
 	create_data $file_blocks $target
 	create_attrs $nattrs $target
 }
@@ -176,11 +194,13 @@ for n in `seq 4 1 12`; do
 		for j in `seq 5 1 20`; do
 			create_target_attr_first $i $j $targ.$i.$j >> $seq.full 2>&1
 		done
+		xfs_bmap -vp $targ.$i.* >> $seq.full 2>&1
 		FSRXFSTEST=true xfs_fsr -d -v -C $n $targ.$i.* >> $seq.full 2>&1
 		xfs_bmap -vp $targ.$i.* >> $seq.full 2>&1
 		for j in `seq 5 1 20`; do
 			create_target_attr_last $i $j $targ.$i.$j >> $seq.full 2>&1
 		done
+		xfs_bmap -vp $targ.$i.* >> $seq.full 2>&1
 		FSRXFSTEST=true xfs_fsr -d -v -C $n $targ.$i.* >> $seq.full 2>&1
 		xfs_bmap -vp $targ.$i.* >> $seq.full 2>&1
 	done
-- 
1.7.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
