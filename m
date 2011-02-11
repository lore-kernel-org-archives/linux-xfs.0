Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1BM23xL212922 for <xfs@oss.sgi.com>; Fri, 11 Feb 2011 16:02:04 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E34B615608E4
	for <xfs@oss.sgi.com>; Fri, 11 Feb 2011 14:04:39 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id M5swxt9QMPPoBFPP for
	<xfs@oss.sgi.com>; Fri, 11 Feb 2011 14:04:39 -0800 (PST)
Received: from int-mx01.intmail.prod.int.phx2.redhat.com
	(int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1BM4coC018703
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 11 Feb 2011 17:04:39 -0500
Received: from segfault.boston.devel.redhat.com
	(segfault.boston.devel.redhat.com [10.16.60.26])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p1BM4cLW005358
	for <xfs@oss.sgi.com>; Fri, 11 Feb 2011 17:04:38 -0500
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch][xfstests-dev] 078: xfs_repair should be run against the
	losetup'd device, not the image file
Date: Fri, 11 Feb 2011 17:04:37 -0500
Message-ID: <x49pqqy8byi.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: xfs@oss.sgi.com

Hi,

When running test 078 against a 4k logical block sized disk, it fails in
xfs_repair.  The problem is that xfs_repair is passed the loopback
filename instead of the actual loop device.  This means that it opens
the file O_DIRECT, and tries to do 512 byte aligned I/O to a 4k sector
device.  The loop device, for better or for worse, will do buffered I/O,
and thus does not suffer from the same problem.  So, the attached patch
sets up the loop device and passes that to xfs_repair.  This resolves
the issue on my test system.

Comments are more than welcome.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/078 b/078
index b8d9132..5cb66df 100755
--- a/078
+++ b/078
@@ -53,7 +53,7 @@ _supported_os Linux
 # Must have loop device
 _require_loop
 
-LOOP_DEV=$TEST_DIR/$seq.fs
+LOOP_IMG=$TEST_DIR/$seq.fs
 LOOP_MNT=$TEST_DIR/$seq.mnt
 
 _filter_io()
@@ -75,7 +75,7 @@ _grow_loop()
 	check=$4
 	agsize=$5
 
-	dparam="file,name=$LOOP_DEV,size=$original"
+	dparam="file,name=$LOOP_IMG,size=$original"
 	if [ -n "$agsize" ]; then
 		dparam="$dparam,agsize=$agsize"
 	fi
@@ -89,9 +89,9 @@ _grow_loop()
 		| _filter_mkfs 2>/dev/null
 
 	echo "*** extend loop file"
-	$XFS_IO_PROG -c "pwrite $new_size $bsize" $LOOP_DEV | _filter_io
+	$XFS_IO_PROG -c "pwrite $new_size $bsize" $LOOP_IMG | _filter_io
 	echo "*** mount loop filesystem"
-	mount -t xfs -o loop $LOOP_DEV $LOOP_MNT
+	mount -t xfs -o loop $LOOP_IMG $LOOP_MNT
 
 	echo "*** grow loop filesystem"
 	#xfs_growfs $LOOP_MNT 2>&1 | grep -e "^data" #| _filter_growfs 2>/dev/null
@@ -104,10 +104,13 @@ _grow_loop()
 	if [ "$check" -gt "0" ]
 	then
 		echo "*** check"
+		LOOP_DEV=`losetup -f`
+		losetup $LOOP_DEV $LOOP_IMG
 		 _check_xfs_filesystem $LOOP_DEV none none
+		losetup -d $LOOP_DEV
 	fi
 
-	rm -f $LOOP_DEV
+	rm -f $LOOP_IMG
 }
 
 # Wes' problem sizes...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
