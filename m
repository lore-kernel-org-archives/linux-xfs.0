Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 444277F59
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 04:59:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C696AAC002
	for <xfs@oss.sgi.com>; Wed,  6 Nov 2013 02:59:37 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id Q7NDRkhSBT412hVc (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 06 Nov 2013 02:59:32 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1Ve0pg-000224-C7
	for xfs@oss.sgi.com; Wed, 06 Nov 2013 10:59:32 +0000
Date: Wed, 6 Nov 2013 02:59:32 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH] xfststs: add a helper to get the minimum dio size
Message-ID: <20131106105932.GA7807@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
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

Various tests opencode checks to find out the minimum support direct I/O
size.  Replace those with a generic helper that handles network filesystems as
well.  Also remove the Linux 2.4 workaround we had in once place.

Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/common/rc b/common/rc
index ea3af12..64139c8 100644
--- a/common/rc
+++ b/common/rc
@@ -2179,6 +2179,21 @@ _scale_fsstress_args()
     echo $args
 }
 
+#
+# Return the logical block size if running on a block device,
+# else substitute the page size.
+#
+_min_dio_alignment()
+{
+    dev=$1
+
+    if [ -b "$dev" ]; then
+        blockdev --getss $dev
+    else
+        $here/src/feature -s
+    fi
+}
+
 run_check()
 {
 	echo "# $@" >> $seqres.full 2>&1
diff --git a/tests/generic/091 b/tests/generic/091
index cee012d..d0f5800 100755
--- a/tests/generic/091
+++ b/tests/generic/091
@@ -54,11 +54,7 @@ run_fsx()
 }
 
 psize=`$here/src/feature -s`
-bsize=`blockdev --getss $TEST_DEV`
-kernel=`uname -r  | sed -e 's/\(2\..\).*/\1/'`
-
-# 2.4 Linux kernels support bsize aligned direct I/O only
-[ "$HOSTOS" = "Linux" -a "$kernel" = "2.4" ] && bsize=$psize
+bsize=`_min_dio_alignment $TEST_DEV`
 
 # fsx usage:
 # 
diff --git a/tests/generic/240 b/tests/generic/240
index e692318..d3fd442 100755
--- a/tests/generic/240
+++ b/tests/generic/240
@@ -60,7 +60,7 @@ rm -f $seqres.full
 
 rm -f $TEST_DIR/aiodio_sparse
 
-logical_block_size=`blockdev --getss $TEST_DEV`
+logical_block_size=`_min_dio_alignment $TEST_DEV`
 fs_block_size=`stat -f $TEST_DIR | grep "Block size:" | awk '{print $3}'`
 
 if [ $fs_block_size -le $logical_block_size ]; then
diff --git a/tests/generic/263 b/tests/generic/263
index 377b199..094c3d1 100755
--- a/tests/generic/263
+++ b/tests/generic/263
@@ -54,7 +54,7 @@ run_fsx()
 }
 
 psize=`$here/src/feature -s`
-bsize=`blockdev --getss $TEST_DEV`
+bsize=`_min_dio_alignment $TEST_DEV`
 
 run_fsx -N 10000  -o 8192   -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z
 run_fsx -N 10000  -o 128000 -l 500000 -r PSIZE -t BSIZE -w BSIZE -Z

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
