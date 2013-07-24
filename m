Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4D1C27F3F
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 13:32:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1FEA18F8035
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 11:31:59 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id avBynrC3iUUjaBgX (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Jul 2013 11:31:58 -0700 (PDT)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id r6OIVuTO022570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 18:31:57 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6OIVt6M004643
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 18:31:56 GMT
Received: from abhmt110.oracle.com (abhmt110.oracle.com [141.146.116.62])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	r6OIVtxi003169 for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 18:31:55 GMT
Date: Wed, 24 Jul 2013 14:32:08 -0400
From: Dwight Engen <dwight.engen@oracle.com>
Subject: [PATCH] xfstests: 091,240,268 fix for xfs on 4k sector hard drive
Message-ID: <20130724143208.34b77534@oracle.com>
Mime-Version: 1.0
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Tests 091,240, and 268 are failing on my 4k sector hard disk. The dio writes
from fsx and aiodio_sparse2 are failing on xfs with EINVAL which is returned
from the check at the top of xfs_file_dio_aio_write().

The fix is to use blockdev -getpbsz to get the physical sector size instead
of the logical sector size. This makes 091 and 268 work. 240 will not run
on a 4k drive since fs block size == device block size. Tested against
xfs,ext4, and btrfs.

Signed-off-by: Dwight Engen <dwight.engen@oracle.com>
---
 tests/generic/091 | 2 +-
 tests/generic/240 | 2 +-
 tests/generic/263 | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/generic/091 b/tests/generic/091
index cee012d..8a11505 100755
--- a/tests/generic/091
+++ b/tests/generic/091
@@ -54,7 +54,7 @@ run_fsx()
 }
 
 psize=`$here/src/feature -s`
-bsize=`blockdev --getss $TEST_DEV`
+bsize=`blockdev --getpbsz $TEST_DEV`
 kernel=`uname -r  | sed -e 's/\(2\..\).*/\1/'`
 
 # 2.4 Linux kernels support bsize aligned direct I/O only
diff --git a/tests/generic/240 b/tests/generic/240
index e692318..ac8560d 100755
--- a/tests/generic/240
+++ b/tests/generic/240
@@ -60,7 +60,7 @@ rm -f $seqres.full
 
 rm -f $TEST_DIR/aiodio_sparse
 
-logical_block_size=`blockdev --getss $TEST_DEV`
+logical_block_size=`blockdev --getpbsz $TEST_DEV`
 fs_block_size=`stat -f $TEST_DIR | grep "Block size:" | awk '{print $3}'`
 
 if [ $fs_block_size -le $logical_block_size ]; then
diff --git a/tests/generic/263 b/tests/generic/263
index 377b199..9795bc2 100755
--- a/tests/generic/263
+++ b/tests/generic/263
@@ -54,7 +54,7 @@ run_fsx()
 }
 
 psize=`$here/src/feature -s`
-bsize=`blockdev --getss $TEST_DEV`
+bsize=`blockdev --getpbsz $TEST_DEV`
 
 run_fsx -N 10000  -o 8192   -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
 run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
