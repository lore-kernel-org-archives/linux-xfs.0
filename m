Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D106B7FF3
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:36:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5777FAC011
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:36:28 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Xux5TBT1PGARFkk6 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:36:27 -0800 (PST)
Message-Id: <20131211073626.435083084@bombadil.infradead.org>
Date: Tue, 10 Dec 2013 23:34:47 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 02/12] 069: use TEST_DIR instead of a SCRATCH_DEV
References: <20131211073445.353655850@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0002-069-use-TEST_DIR-instead-of-a-SCRATCH_DEV.patch
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
Cc: Stanislav Kholmanskikh <stanislav.kholmanskikh@oracle.com>

The test does not require a fresh file system.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 tests/generic/069     |   23 +++++++++--------------
 tests/generic/069.out |    2 --
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/tests/generic/069 b/tests/generic/069
index c3fa862..f55da37 100755
--- a/tests/generic/069
+++ b/tests/generic/069
@@ -39,18 +39,13 @@ trap "rm -rf $tmp.*; exit \$status" 0 1 2 3 15
 _supported_fs generic
 _supported_os IRIX Linux
 
-_require_scratch
 rm -f $seqres.full
 
-umount $SCRATCH_DEV >/dev/null 2>&1
+dir="$TEST_DIR/append"
 
-echo "*** mkfs"
-_scratch_mkfs >/dev/null 2>&1 || _fail "mkfs failed"
-
-echo "*** mount FS"
-_scratch_mount >/dev/null || _fail "mount failed"
-
-cd $SCRATCH_MNT
+rm -rf $dir
+mkdir $dir
+cd $dir
 
 sizes="1 20 300 40000 3000000 12345"
 for size in $sizes ; do
@@ -61,18 +56,18 @@ done
 cd $here
 
 wait
-ls -lh $SCRATCH_MNT >> $seqres.full
+ls -lh $dir >> $seqres.full
 echo "*** PIDs file" >> $seqres.full
-cat $SCRATCH_MNT/pids >> $seqres.full
+cat $dir/pids >> $seqres.full
 
-cat $SCRATCH_MNT/pids | while read pid size
+cat $dir/pids | while read pid size
 do
 	echo "*** checking file with $size integers"
 	echo checking pid=$pid size=$size >> $seqres.full
-	$here/src/append_reader $SCRATCH_MNT/testfile.$pid
+	$here/src/append_reader $dir/testfile.$pid
 	status=$?
 	[ $status -ne 0 ] && \
-		echo "maybe corrupt O_APPEND to $SCRATCH_MOUNT/testfile.$pid!"
+		echo "maybe corrupt O_APPEND to $dir/testfile.$pid!"
 	echo status: $status >> $seqres.full
 done
 
diff --git a/tests/generic/069.out b/tests/generic/069.out
index 0d7b23c..491ea57 100644
--- a/tests/generic/069.out
+++ b/tests/generic/069.out
@@ -1,6 +1,4 @@
 QA output created by 069
-*** mkfs
-*** mount FS
 *** checking file with 1 integers
 *** checking file with 20 integers
 *** checking file with 300 integers
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
