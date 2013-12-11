Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id DC02E7FFC
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:36:31 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 75B08AC012
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:36:28 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id MluE68FB3dgeQPZt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:36:27 -0800 (PST)
Message-Id: <20131211073626.560323136@bombadil.infradead.org>
Date: Tue, 10 Dec 2013 23:34:48 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/12] 079: use TEST_DIR instead of a SCRATCH_DEV
References: <20131211073445.353655850@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0003-079-use-TEST_DIR-instead-of-a-SCRATCH_DEV.patch
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
 tests/generic/079 |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/tests/generic/079 b/tests/generic/079
index a533484..044447a 100755
--- a/tests/generic/079
+++ b/tests/generic/079
@@ -36,8 +36,7 @@ _cleanup()
 {
     cd /
     echo "*** cleaning up"
-    $timmutable -r $SCRATCH_MNT/$seq
-    umount $SCRATCH_MNT
+    $timmutable -r $TEST_DIR/$seq
 }
 
 # get standard environment, filters and checks
@@ -49,16 +48,11 @@ _supported_fs generic
 _supported_os Linux
 
 _require_attrs
-_require_scratch
 
 [ -x $timmutable ] || _notrun "t_immutable was not built for this platform"
 
-# real QA test starts here
-_scratch_mkfs >/dev/null 2>&1 || _fail "mkfs failed"
-_scratch_mount || _fail "mount failed"
-
 echo "*** starting up"
-$timmutable -c $SCRATCH_MNT/$seq >$tmp.out 2>&1
+$timmutable -c $TEST_DIR/$seq >$tmp.out 2>&1
 if grep -q 'Operation not supported' $tmp.out; then
     rm -f $tmp.out
     _notrun "Setting immutable/append flag not supported"
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
