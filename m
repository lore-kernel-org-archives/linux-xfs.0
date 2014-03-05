Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id DB2937F59
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 09:51:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A3E208F8070
	for <xfs@oss.sgi.com>; Wed,  5 Mar 2014 07:51:57 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zHlYRC4VBl8coePj for
	<xfs@oss.sgi.com>; Wed, 05 Mar 2014 07:51:56 -0800 (PST)
From: Lukas Czerner <lczerner@redhat.com>
Subject: [PATCH v2 2/8] xfstests: create _test_block_boundaries in common/punch
Date: Wed,  5 Mar 2014 16:51:33 +0100
Message-Id: <1394034699-21187-3-git-send-email-lczerner@redhat.com>
In-Reply-To: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
References: <1394034699-21187-1-git-send-email-lczerner@redhat.com>
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
To: linux-ext4@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, lczerner@redhat.com, xfs@oss.sgi.com

Create new function _test_block_boundaries() which is testing content of
the blocks after the operation such as zero, or punch hole. The test is
doing the operation around block boundaries to assure correct behaviour
of the operation on block unaligned ranges.

This has been based on test xfs/290 which has been changed to use this
new function. A small change to the output file was required.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
---
 common/punch      | 106 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/290     |  40 ++-------------------
 tests/xfs/290.out |  13 +++++--
 3 files changed, 119 insertions(+), 40 deletions(-)

diff --git a/common/punch b/common/punch
index 9340d3b..f2d538c 100644
--- a/common/punch
+++ b/common/punch
@@ -566,3 +566,109 @@ _test_generic_punch()
 	[ $? -ne 0 ] && die_now
 	od -x $testfile | head -n -1
 }
+
+_test_block_boundaries()
+{
+
+	remove_testfile=1
+	sync_cmd="-c fsync"
+	unwritten_tests=1
+	OPTIND=1
+	while getopts 'dk' OPTION
+	do
+		case $OPTION in
+		k)	remove_testfile=
+		;;
+		d)	sync_cmd=
+		;;
+		?)	echo Invalid flag
+		exit 1
+		;;
+		esac
+	done
+	shift $(($OPTIND - 1))
+
+	bs=$1
+	zero_cmd=$2
+	filter_cmd=$3
+	testfile=$4
+
+	# Block size plus 1
+	bs_p1=$(($bs + 1))
+	# Block size plus 2
+	bs_p2=$(($bs + 2))
+
+	# Block size minus 1
+	bs_m1=$(($bs - 1))
+
+	# Block size multiplied by 2
+	bs_t2=$(($bs * 2))
+
+	# Block size divided by 2
+	bs_d2=$(($bs / 2))
+
+	echo "zero 0, 1"
+	$XFS_IO_PROG -f -t -c "pwrite -S 0x41 0 $bs" \
+			   -c "pwrite -S 0x42 $bs $bs" \
+			   -c "$zero_cmd 0 1" \
+			   -c "pread -v 0 $bs_t2" \
+			   $testfile | $filter_cmd
+
+	echo "zero 0, $bs_m1"
+	$XFS_IO_PROG -f -t -c "pwrite -S 0x41 0 $bs" \
+			   -c "pwrite -S 0x42 $bs $bs" \
+			   -c "$zero_cmd 0 $bs_m1" \
+			   -c "pread -v 0 $bs_t2" \
+			   $testfile | $filter_cmd
+
+	echo "zero 0, $bs"
+	$XFS_IO_PROG -f -t -c "pwrite -S 0x41 0 $bs" \
+			   -c "pwrite -S 0x42 $bs $bs" \
+			   -c "$zero_cmd 0 $bs" \
+			   -c "pread -v 0 $bs_t2" \
+			   $testfile | $filter_cmd
+
+	echo "zero 0, $bs_p1"
+	$XFS_IO_PROG -f -t -c "pwrite -S 0x41 0 $bs" \
+			   -c "pwrite -S 0x42 $bs $bs" \
+			   -c "$zero_cmd 0 $bs_p1" \
+			   -c "pread -v 0 $bs_t2" \
+			   $testfile | $filter_cmd
+
+	echo "zero $bs_m1, $bs"
+	$XFS_IO_PROG -f -t -c "pwrite -S 0x41 0 $bs" \
+			   -c "pwrite -S 0x42 $bs $bs" \
+			   -c "$zero_cmd $bs_m1 $bs" \
+			   -c "pread -v 0 $bs_t2" \
+			   $testfile | $filter_cmd
+
+	echo "zero $bs_m1, $bs_p1"
+	$XFS_IO_PROG -f -t -c "pwrite -S 0x41 0 $bs" \
+			   -c "pwrite -S 0x42 $bs $bs" \
+			   -c "$zero_cmd $bs_m1 $bs_p1" \
+			   -c "pread -v 0 $bs_t2" \
+			   $testfile | $filter_cmd
+
+	echo "zero $bs_m1, $bs_p2"
+	$XFS_IO_PROG -f -t -c "pwrite -S 0x41 0 $bs" \
+			   -c "pwrite -S 0x42 $bs $bs" \
+			   -c "$zero_cmd $bs_m1 $bs_p2" \
+			   -c "pread -v 0 $bs_t2" \
+			   $testfile | $filter_cmd
+
+
+	echo "zero $bs, $bs"
+	$XFS_IO_PROG -f -t -c "pwrite -S 0x41 0 $bs" \
+			   -c "pwrite -S 0x42 $bs $bs" \
+			   -c "$zero_cmd $bs $bs" \
+			   -c "pread -v 0 $bs_t2" \
+			   $testfile | $filter_cmd
+
+
+	echo "zero $bs_d2 , $bs"
+	$XFS_IO_PROG -f -t -c "pwrite -S 0x41 0 $bs" \
+			   -c "pwrite -S 0x42 $bs $bs" \
+			   -c "$zero_cmd $bs_d2 $bs" \
+			   -c "pread -v 0 $bs_t2" \
+			   $testfile | $filter_cmd
+}
diff --git a/tests/xfs/290 b/tests/xfs/290
index 547a0ba..cbe7108 100755
--- a/tests/xfs/290
+++ b/tests/xfs/290
@@ -38,6 +38,7 @@ trap "exit \$status" 0 1 2 3 15
 # get standard environment, filters and checks
 . ./common/rc
 . ./common/filter
+. ./common/punch
 
 # real QA test starts here
 
@@ -49,44 +50,7 @@ _require_xfs_io_zero
 
 testfile=$TEST_DIR/290.$$
 
-test_zero()
-{
-	zero_start=$1
-	zero_len=$2
-
-	$XFS_IO_PROG -f -t -c "pwrite -S 0x41 0 4096" \
-                      -c "pwrite -S 0x42 4096 4096" \
-                      -c "zero $zero_start $zero_len" \
-                      -c "pread -v 0 8192" \
-                      $testfile | _filter_xfs_io_unique
-}
-
-# [0,1] -- Shouldn't toss anything
-test_zero    0    1
-
-#[0,4095] -- Shouldn't toss anything
-test_zero    0 4095
-
-#[0,4096] -- Should toss first page
-test_zero    0 4096
-
-#[0,4097] -- Should toss first page
-test_zero    0 4097
-
-#[4095,8191] -- Should toss last byte of first page
-test_zero 4095 4096
-
-#[4095,8192] -- Should toss second page & last byte of first page
-test_zero 4095 4097
-
-#[4095,8193] -- Should toss second page & last byte of first page
-test_zero 4095 4098
-
-#[4096,8192] -- Should toss second page
-test_zero 4096 4096
-
-#[1024,5120] -- Should toss from 1024 to end of first page
-test_zero 1024 4096
+_test_block_boundaries 4096 zero _filter_xfs_io_unique $testfile
 
 # success, all done
 status=0
diff --git a/tests/xfs/290.out b/tests/xfs/290.out
index 229c2b3..2487a93 100644
--- a/tests/xfs/290.out
+++ b/tests/xfs/290.out
@@ -1,4 +1,5 @@
 QA output created by 290
+zero 0, 1
 wrote 4096/4096 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 4096/4096 bytes at offset 4096
@@ -10,6 +11,7 @@ XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 *
 read 8192/8192 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 0, 4095
 wrote 4096/4096 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 4096/4096 bytes at offset 4096
@@ -21,6 +23,7 @@ XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 *
 read 8192/8192 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 0, 4096
 wrote 4096/4096 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 4096/4096 bytes at offset 4096
@@ -31,6 +34,7 @@ XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 *
 read 8192/8192 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 0, 4097
 wrote 4096/4096 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 4096/4096 bytes at offset 4096
@@ -42,6 +46,7 @@ XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 *
 read 8192/8192 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 4095, 4096
 wrote 4096/4096 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 4096/4096 bytes at offset 4096
@@ -54,6 +59,7 @@ XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 00001ff0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 42  ...............B
 read 8192/8192 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 4095, 4097
 wrote 4096/4096 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 4096/4096 bytes at offset 4096
@@ -65,6 +71,7 @@ XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 *
 read 8192/8192 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 4095, 4098
 wrote 4096/4096 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 4096/4096 bytes at offset 4096
@@ -76,6 +83,7 @@ XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 *
 read 8192/8192 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 4096, 4096
 wrote 4096/4096 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 4096/4096 bytes at offset 4096
@@ -86,15 +94,16 @@ XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 *
 read 8192/8192 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
+zero 2048 , 4096
 wrote 4096/4096 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 wrote 4096/4096 bytes at offset 4096
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
 00000000:  41 41 41 41 41 41 41 41 41 41 41 41 41 41 41 41  AAAAAAAAAAAAAAAA
 *
-00000400:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
+00000800:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
 *
-00001400:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
+00001800:  42 42 42 42 42 42 42 42 42 42 42 42 42 42 42 42  BBBBBBBBBBBBBBBB
 *
 read 8192/8192 bytes at offset 0
 XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
