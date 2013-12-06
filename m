Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7C3C529E05
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 03:24:50 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5B1908F80BA
	for <xfs@oss.sgi.com>; Fri,  6 Dec 2013 01:24:47 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ousQwD6XxpFHomY1 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 06 Dec 2013 01:24:16 -0800 (PST)
Received: from acsinet22.oracle.com (acsinet22.oracle.com [141.146.126.238])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rB69OF7Z022307
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 6 Dec 2013 09:24:16 GMT
Received: from userz7021.oracle.com (userz7021.oracle.com [156.151.31.85])
	by acsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rB69OD42000391
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 6 Dec 2013 09:24:15 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
	by userz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rB69ODTH015691 for <xfs@oss.sgi.com>; Fri, 6 Dec 2013 09:24:13 GMT
From: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
Subject: [PATCH] generic: require filesize to be greater than fs block size in
	generic/240
Date: Fri,  6 Dec 2013 13:24:05 +0400
Message-Id: <1386321845-9221-1-git-send-email-stanislav.kholmanskikh@oracle.com>
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
Cc: vasily.isaenko@oracle.com

If we execute generic/240 on a fs which has its fs block size greater
than 64k (for example, NFS), this test will fail with:

  io_submit failed: Invalid argument

This will happen because in src/aio-dio-regress/aiodio_sparse2.c this
expression

  num_aio = filesize / step;

will set num_aio to 0 and this means that no io_setup() will happen
before calling io_submit().

Signed-off-by: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>
---
 tests/generic/240 |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/tests/generic/240 b/tests/generic/240
index e26f495..acf0515 100755
--- a/tests/generic/240
+++ b/tests/generic/240
@@ -62,14 +62,19 @@ rm -f $TEST_DIR/aiodio_sparse
 
 logical_block_size=`_min_dio_alignment $TEST_DEV`
 fs_block_size=`stat -f $TEST_DIR | grep "Block size:" | awk '{print $3}'`
+file_size=65536
 
 if [ $fs_block_size -le $logical_block_size ]; then
 	_notrun "fs block size must be larger than the device block size.  fs block size: $fs_block_size, device block size: $logical_block_size"
 fi
 
-# 2 threads, fs block sized writes, 64k filesize, stride through file by
+if [ $file_size -lt $fs_block_size ]; then
+	file_size=$fs_block_size
+fi
+
+# 2 threads, fs block sized writes, filesize, stride through file by
 # fs block size, start at logical block size offset
-$AIO_TEST -i 2 -w $fs_block_size -s 64k -n $fs_block_size -o $logical_block_size "$TEST_DIR/aiodio_sparse"
+$AIO_TEST -i 2 -w $fs_block_size -s $file_size -n $fs_block_size -o $logical_block_size "$TEST_DIR/aiodio_sparse"
 
 status=$?
 exit
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
