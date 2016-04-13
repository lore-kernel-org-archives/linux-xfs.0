Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 0A9DB7CA0
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 06:56:32 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B5BD0304062
	for <xfs@oss.sgi.com>; Wed, 13 Apr 2016 04:56:31 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id zENNsJgSFI13fEtp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 13 Apr 2016 04:56:30 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2] xfs/259: test more block sizes and handle minimum block
	size correctly
Date: Wed, 13 Apr 2016 19:56:21 +0800
Message-Id: <1460548581-26505-1-git-send-email-eguan@redhat.com>
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
To: fstests@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

Currently xfs/259 tests against TEST_DIR for CRC support status to
decide whether 512 block size should be tested, which is wrong for this
test, because configuration of TEST_DIR is not controlled by test
harness and can be different to the configuration being used in the
test.

Fix it by reversing the block size order that's tested and capture the
output of the actual mkfs command that is being tested, and determine if
512 byte block sizes should be tested based on that output.

While we're at it, I think the test matrix can be enlarged as well, 4k,
2k, 1k and 512 block size can be tested in each fs size boundary, not
only the minimum block size.

Suggested-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Eryu Guan <eguan@redhat.com>
---

v2:
- take Dave's suggestion, and make changes only to xfs/259. Thanks Dave and
  Christoph for spending their time on such a corner case.
- test more block sizes

 tests/xfs/259     | 47 ++++++++++++++++++++++++-----------------------
 tests/xfs/259.out | 20 ++++++++++++++++----
 2 files changed, 40 insertions(+), 27 deletions(-)

diff --git a/tests/xfs/259 b/tests/xfs/259
index 16c1935..17f3c6d 100755
--- a/tests/xfs/259
+++ b/tests/xfs/259
@@ -51,32 +51,33 @@ testfile=$TEST_DIR/259.image
 # Test various sizes slightly less than 4 TB. Need to handle different
 # minimum block sizes for CRC enabled filesystems, but use a small log so we
 # don't write lots of zeros unnecessarily.
-xfs_info $TEST_DIR | _filter_mkfs 2> $tmp.mkfs > /dev/null
-. $tmp.mkfs
-if [ $_fs_has_crcs -eq 1 ]; then
-	blocksize=1024
-	sizes_to_check="1024 2048 4096"
-	echo "Trying to make (4 TB - 512) B long xfs fs image"
-else
-	blocksize=512
-	sizes_to_check="512 1024 2048 4096"
-fi
-
+sizes_to_check="4096 2048 1024 512"
+blocksizes="4096 2048 1024 512"
 four_TB=$(_math "2^42")
+# The initial value of _fs_has_crcs is not important, because we start testing
+# with 4096 block size, it only matters for 512 block size test
+_fs_has_crcs=0
 for del in $sizes_to_check; do
-	ddseek=$(_math "$four_TB - $del")
-	echo "Trying to make (4 TB - $del) B long xfs fs image"
-	rm -f "$testfile"
-	dd if=/dev/zero "of=$testfile" bs=1 count=0 seek=$ddseek \
-					>/dev/null 2>&1 || echo "dd failed"
-	lofile=$(losetup -f)
-	losetup $lofile "$testfile"
-	"$MKFS_XFS_PROG" -l size=32m -b size=$blocksize $lofile \
-					>/dev/null || echo "mkfs failed!"
-	sync
-	losetup -d $lofile
+	for bs in $blocksizes; do
+		echo "Trying to make (4TB - ${del}B) long xfs, block size $bs"
+		# skip tests with 512 block size if the fs created has crc
+		# enabled by default
+		if [ $_fs_has_crcs -eq 1 -a $bs -eq 512 ]; then
+			break;
+		fi
+		ddseek=$(_math "$four_TB - $del")
+		rm -f "$testfile"
+		dd if=/dev/zero "of=$testfile" bs=1 count=0 seek=$ddseek \
+			>/dev/null 2>&1 || echo "dd failed"
+		lofile=$(losetup -f)
+		losetup $lofile "$testfile"
+		$MKFS_XFS_PROG -l size=32m -b size=$bs $lofile |  _filter_mkfs \
+			>/dev/null 2> $tmp.mkfs || echo "mkfs failed!"
+		. $tmp.mkfs
+		sync
+		losetup -d $lofile
+	done
 done
 
 status=0
-
 exit
diff --git a/tests/xfs/259.out b/tests/xfs/259.out
index 6e0be9a..9fc4920 100644
--- a/tests/xfs/259.out
+++ b/tests/xfs/259.out
@@ -1,5 +1,17 @@
 QA output created by 259
-Trying to make (4 TB - 512) B long xfs fs image
-Trying to make (4 TB - 1024) B long xfs fs image
-Trying to make (4 TB - 2048) B long xfs fs image
-Trying to make (4 TB - 4096) B long xfs fs image
+Trying to make (4TB - 4096B) long xfs, block size 4096
+Trying to make (4TB - 4096B) long xfs, block size 2048
+Trying to make (4TB - 4096B) long xfs, block size 1024
+Trying to make (4TB - 4096B) long xfs, block size 512
+Trying to make (4TB - 2048B) long xfs, block size 4096
+Trying to make (4TB - 2048B) long xfs, block size 2048
+Trying to make (4TB - 2048B) long xfs, block size 1024
+Trying to make (4TB - 2048B) long xfs, block size 512
+Trying to make (4TB - 1024B) long xfs, block size 4096
+Trying to make (4TB - 1024B) long xfs, block size 2048
+Trying to make (4TB - 1024B) long xfs, block size 1024
+Trying to make (4TB - 1024B) long xfs, block size 512
+Trying to make (4TB - 512B) long xfs, block size 4096
+Trying to make (4TB - 512B) long xfs, block size 2048
+Trying to make (4TB - 512B) long xfs, block size 1024
+Trying to make (4TB - 512B) long xfs, block size 512
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
