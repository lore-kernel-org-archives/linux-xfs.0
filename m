Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1EGtOIE144020 for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 10:55:24 -0600
Received: from mx1.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 101CA1EAF436
	for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 08:58:02 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 1VUFjza5KtMRJ0dC for
	<xfs@oss.sgi.com>; Mon, 14 Feb 2011 08:58:02 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1EGw1qw000530
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 11:58:01 -0500
Received: from segfault.boston.devel.redhat.com
	(segfault.boston.devel.redhat.com [10.16.60.26])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id p1EGw020012145
	for <xfs@oss.sgi.com>; Mon, 14 Feb 2011 11:58:01 -0500
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch][xfstests-dev] 164: write a multiple of 4k instead of 512
Date: Mon, 14 Feb 2011 11:58:00 -0500
Message-ID: <x49ei7alfjb.fsf@segfault.boston.devel.redhat.com>
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

When running test 164 against a 4k sector device, the initial file write
of 50K fails with EINVAL, since it isn't a multiple of the device sector
size.  I fixed this by bumping the amount written to 52K.  Comments, as
always, are appreciated.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/164 b/164
index 03784c6..2aea353 100755
--- a/164
+++ b/164
@@ -78,7 +78,7 @@ _test_eof_hole()
 	# on a BB boundary
 	rm -f $testfile
 	$XFS_IO_PROG -f -d \
-		  -c 'pwrite -b 50k 0 50k' \
+		  -c 'pwrite -b 52k 0 52k' \
 		  -c 'truncate 100k' \
                   -c 'pread -b 200k 0 200k' \
 		  $testfile | _filter_io
@@ -90,7 +90,7 @@ _test_eof_hole()
 	boundary_minus1=`expr 100 \* 1024 - 1`
 	echo "boundary_minus1 = $boundary_minus1"
 	$XFS_IO_PROG -f -d \
-		  -c 'pwrite -b 50k 0 50k' \
+		  -c 'pwrite -b 52k 0 52k' \
 		  -c "truncate $boundary_minus1" \
                   -c 'pread -b 200k 0 200k' \
 		  $testfile | _filter_io
@@ -102,7 +102,7 @@ _test_eof_hole()
 	boundary_plus1=`expr 100 \* 1024 + 1`
 	echo "boundary_plus1 = $boundary_plus1"
 	$XFS_IO_PROG -f -d \
-		  -c 'pwrite -b 50k 0 50k' \
+		  -c 'pwrite -b 52k 0 52k' \
 		  -c "truncate $boundary_plus1" \
                   -c 'pread -b 200k 0 200k' \
 		  $testfile | _filter_io
@@ -117,7 +117,7 @@ _test_eof_unwritten_extent()
 	$XFS_IO_PROG -f -d \
 		  -c 'resvsp 0 100k' \
 		  -c 'truncate 100k' \
-		  -c 'pwrite -b 50k 0 50k' \
+		  -c 'pwrite -b 52k 0 52k' \
                   -c 'pread -b 200k 0 200k' \
 		  $testfile | _filter_io
 	$XFS_IO_PROG -c 'bmap -vp' $testfile | _filter_bmap
@@ -130,7 +130,7 @@ _test_eof_unwritten_extent()
 	$XFS_IO_PROG -f -d \
 		  -c "resvsp 0 $boundary_minus1" \
 		  -c "truncate $boundary_minus1" \
-		  -c 'pwrite -b 50k 0 50k' \
+		  -c 'pwrite -b 52k 0 52k' \
                   -c 'pread -b 200k 0 200k' \
 		$testfile | _filter_io
 	$XFS_IO_PROG -c 'bmap -vp' $testfile | _filter_bmap
@@ -143,7 +143,7 @@ _test_eof_unwritten_extent()
 	$XFS_IO_PROG -f -d \
 		  -c "resvsp 0 $boundary_plus1" \
 		  -c "truncate $boundary_plus1" \
-		  -c 'pwrite -b 50k 0 50k' \
+		  -c 'pwrite -b 52k 0 52k' \
                   -c 'pread -b 200k 0 200k' \
 		  $testfile | _filter_io
 	$XFS_IO_PROG -c 'bmap -vp' $testfile | _filter_bmap
diff --git a/164.out b/164.out
index df67f05..d55e7b5 100644
--- a/164.out
+++ b/164.out
@@ -1,35 +1,35 @@
 QA output created by 164
-wrote 51200/51200 bytes at offset 0
-50 KiB, 1 ops
+wrote 53248/53248 bytes at offset 0
+52 KiB, 1 ops
 read 102400/204800 bytes at offset 0
 100 KiB, 1 ops
 
 boundary_minus1 = 102399
-wrote 51200/51200 bytes at offset 0
-50 KiB, 1 ops
+wrote 53248/53248 bytes at offset 0
+52 KiB, 1 ops
 read 102399/204800 bytes at offset 0
 100 KiB, 1 ops
 
 boundary_plus1 = 102401
-wrote 51200/51200 bytes at offset 0
-50 KiB, 1 ops
+wrote 53248/53248 bytes at offset 0
+52 KiB, 1 ops
 read 102401/204800 bytes at offset 0
 100 KiB, 1 ops
 
-wrote 51200/51200 bytes at offset 0
-50 KiB, 1 ops
+wrote 53248/53248 bytes at offset 0
+52 KiB, 1 ops
 read 102400/204800 bytes at offset 0
 100 KiB, 1 ops
 
 boundary_minus1 = 102399
-wrote 51200/51200 bytes at offset 0
-50 KiB, 1 ops
+wrote 53248/53248 bytes at offset 0
+52 KiB, 1 ops
 read 102399/204800 bytes at offset 0
 100 KiB, 1 ops
 
 boundary_plus1 = 102401
-wrote 51200/51200 bytes at offset 0
-50 KiB, 1 ops
+wrote 53248/53248 bytes at offset 0
+52 KiB, 1 ops
 read 102401/204800 bytes at offset 0
 100 KiB, 1 ops
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
