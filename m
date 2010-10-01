Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o91D8bxH074965 for <xfs@oss.sgi.com>; Fri, 1 Oct 2010 08:08:37 -0500
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2FD51304066
	for <xfs@oss.sgi.com>; Fri,  1 Oct 2010 06:09:35 -0700 (PDT)
Received: from [134.15.95.106] (cf-vpn-hw-arenaud-9.corp.sgi.com
	[134.15.95.106])
	by estes.americas.sgi.com (Postfix) with ESMTP id D3C72700186B
	for <xfs@oss.sgi.com>; Fri,  1 Oct 2010 08:09:34 -0500 (CDT)
Message-ID: <4CA5DD8D.3010200@sgi.com>
Date: Fri, 01 Oct 2010 09:09:33 -0400
From: Alain Renaud <arenaud@sgi.com>
MIME-Version: 1.0
Subject: [PATCH] xfstests: make 223 use more compatible indirection operator
Content-Type: multipart/mixed; boundary="------------020905090800000305080804"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

This is a multi-part message in MIME format.
--------------020905090800000305080804
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hello all,

I notice while running xfstests on SLES machine that the test 223 fail
because of syntax error.

# bash 223
QA output created by 223
223: line 66: syntax error near unexpected token `>'
223: line 66: `    _scratch_mkfs_geom $SUNIT_BYTES 4 $BLOCKSIZE&>>  $seq.full'

The error is due to the use of the '&>>' operator for redirection that does not
work  on older bash version(3.2.x).
Note that this operator only seem to work with bash version 4.X+

This patch simply replace the operator with '>>  $seq.full 2>&1' which does
the same thing.

--
Signed-off-by: Alain Renaud <arenaud@sgi.com>




--------------020905090800000305080804
Content-Type: text/x-patch;
 name="223.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="223.patch"

Index: xfstests/223
===================================================================
--- xfstests/223.orig
+++ xfstests/223
@@ -63,7 +63,7 @@
 	let SUNIT_BLOCKS=$SUNIT_BYTES/$BLOCKSIZE
 
 	echo "=== mkfs with su $SUNIT_BLOCKS blocks x 4 ==="
-	_scratch_mkfs_geom $SUNIT_BYTES 4 $BLOCKSIZE &>> $seq.full
+	_scratch_mkfs_geom $SUNIT_BYTES 4 $BLOCKSIZE >> $seq.full 2>&1
 	_scratch_mount
 
 	for SIZE_MULT in 1 2 8 64 256; do
@@ -73,10 +73,10 @@
 		for FILE in 1 2 3 4; do
 			xfs_io -F -f -c "falloc 0 $SIZE" \
 				$SCRATCH_MNT/file-$FILE-$SIZE-falloc \
-					&>> $seq.full
+					>> $seq.full 2>&1
 			xfs_io -F -f -c "pwrite 0 $SIZE" \
 				$SCRATCH_MNT/file-$FILE-$SIZE-write \
-					&>> $seq.full
+					>> $seq.full 2>&1
 			src/t_stripealign $SCRATCH_MNT/file-$FILE-$SIZE-falloc \
 				$SUNIT_BLOCKS | _filter_scratch
 			src/t_stripealign $SCRATCH_MNT/file-$FILE-$SIZE-write \
@@ -85,7 +85,8 @@
 	done
 
 	echo "=== Testing size 1g falloc on ${SUNIT_K}k stripe ==="
-	xfs_io -F -f -c "falloc 0 1g" $SCRATCH_MNT/file-1g-falloc &>> $seq.full
+	xfs_io -F -f -c "falloc 0 1g" \
+	    $SCRATCH_MNT/file-1g-falloc >> $seq.full 2>&1
 	src/t_stripealign $SCRATCH_MNT/file-1g-falloc $SUNIT_BLOCKS \
 	    | _filter_scratch
 
@@ -93,7 +94,7 @@
 
 	echo "=== Testing size 1073745920 falloc on ${SUNIT_K}k stripe ==="
 	xfs_io -F -f -c "falloc 0 1073745920" \
-		$SCRATCH_MNT/file-1073745920-falloc &>> $seq.full
+		$SCRATCH_MNT/file-1073745920-falloc >> $seq.full 2>&1
 	src/t_stripealign $SCRATCH_MNT/file-1073745920-falloc \
 		$SUNIT_BLOCKS | _filter_scratch
 


--------------020905090800000305080804
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

--------------020905090800000305080804--
