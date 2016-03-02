Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 345877CB4
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 10:52:17 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9E635AC001
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 08:52:16 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Oh6jwiaxSqcaHGFq (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Mar 2016 08:52:15 -0800 (PST)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH] xfs/259: disable CRC if testing with 512 bytes block size
Date: Thu,  3 Mar 2016 00:51:58 +0800
Message-Id: <1456937518-20505-1-git-send-email-eguan@redhat.com>
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

With CRCs being the default, TEST_DEV can still be created with
"-m crc=0" option explicitly, then 512 bytes block size is picked up by
the test, which causes mkfs failure in later mkfs tests.

Fix it by adding "-m crc=0" mkfs option in this case.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/xfs/259 | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/tests/xfs/259 b/tests/xfs/259
index 16c1935..b5681fe 100755
--- a/tests/xfs/259
+++ b/tests/xfs/259
@@ -62,6 +62,12 @@ else
 	sizes_to_check="512 1024 2048 4096"
 fi
 
+# If XFS mounted at $TEST_DIR is created with crc disabled explicitly, option
+# "-m crc=0" should be added to mkfs option as blocksize is 512
+mkfs_opts="-l size=32m -b size=$blocksize"
+if [ $_fs_has_crcs -ne 1 -a "$XFS_MKFS_HAS_NO_META_SUPPORT" == "" ]; then
+	mkfs_opts="$mkfs_opts -m crc=0"
+fi
 four_TB=$(_math "2^42")
 for del in $sizes_to_check; do
 	ddseek=$(_math "$four_TB - $del")
@@ -71,8 +77,7 @@ for del in $sizes_to_check; do
 					>/dev/null 2>&1 || echo "dd failed"
 	lofile=$(losetup -f)
 	losetup $lofile "$testfile"
-	"$MKFS_XFS_PROG" -l size=32m -b size=$blocksize $lofile \
-					>/dev/null || echo "mkfs failed!"
+	"$MKFS_XFS_PROG" $mkfs_opts $lofile >/dev/null || echo "mkfs failed!"
 	sync
 	losetup -d $lofile
 done
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
