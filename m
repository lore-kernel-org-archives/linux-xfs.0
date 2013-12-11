Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 5C2587FE2
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 01:36:28 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 499BE304066
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 23:36:28 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id sniEDVAfxUjLzZUF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 10 Dec 2013 23:36:27 -0800 (PST)
Message-Id: <20131211073626.963044931@bombadil.infradead.org>
Date: Tue, 10 Dec 2013 23:34:51 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 06/12] 117: use TEST_DIR instead of a SCRATCH_DEV
References: <20131211073445.353655850@bombadil.infradead.org>
Content-Disposition: inline;
	filename=0006-117-use-TEST_DIR-instead-of-a-SCRATCH_DEV.patch
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
 tests/generic/117     |   24 +++++-------------------
 tests/generic/117.out |    2 --
 2 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/tests/generic/117 b/tests/generic/117
index f81265b..504dd88 100755
--- a/tests/generic/117
+++ b/tests/generic/117
@@ -78,38 +78,24 @@ _cleanup()
 _supported_fs generic
 _supported_os IRIX Linux
 
-_require_scratch
 _require_attrs
 
 rm -f $seqres.full
-umount $SCRATCH_DEV >/dev/null 2>&1
-echo "*** MKFS ***"                         >>$seqres.full
-echo ""                                     >>$seqres.full
-_scratch_mkfs                               >>$seqres.full 2>&1 \
-    || _fail "mkfs failed"
-_scratch_mount                              >>$seqres.full 2>&1 \
-    || _fail "mount failed"
 
-mkdir -p $SCRATCH_MNT/fsstress
+testdir=$TEST_DIR/fsstress.$seq
+rm -rf $testdir
+mkdir -p $testdir
 
 echo
 echo Running fsstress in serial:
 i=0
 while [ $i -lt $ITERATIONS ]; do
     echo fsstress iteration: $i | tee -a $seqres.full
-    $FSSTRESS_PROG \
-	-d $SCRATCH_MNT/fsstress \
+    $FSSTRESS_PROG -d $testdir \
 	$fss_ops -S c >>$seqres.full 2>&1
 
     let i=$i+1
 done
 
-cd /
-umount $SCRATCH_MNT
-echo 
-echo Checking filesystem
-_check_scratch_fs
-_scratch_mount
-
-status=$?
+status=0
 exit
diff --git a/tests/generic/117.out b/tests/generic/117.out
index 1306ebc..e295515 100644
--- a/tests/generic/117.out
+++ b/tests/generic/117.out
@@ -11,5 +11,3 @@ fsstress iteration: 6
 fsstress iteration: 7
 fsstress iteration: 8
 fsstress iteration: 9
-
-Checking filesystem
-- 
1.7.10.4


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
