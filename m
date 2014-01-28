Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id CC88A7FA0
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 12:40:39 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id A10868F8064
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 10:40:39 -0800 (PST)
Received: from mx0a-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id 1qjU6Rhi78G9DShj
	for <xfs@oss.sgi.com>; Tue, 28 Jan 2014 10:40:38 -0800 (PST)
From: Josef Bacik <jbacik@fb.com>
Subject: [PATCH] xfstests: change btrfs/029's golden output and it's filtering
Date: Tue, 28 Jan 2014 13:40:33 -0500
Message-ID: <1390934433-22299-1-git-send-email-jbacik@fb.com>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

I noticed while testing a different mkfs option that btrfs/029 was failing
because it was getting the extra output from our mkfs.btrfs.  After I fixed that
I was still failing because my version of cp will spit out the source and
destination files, not just the destination file.  So redirect _scratch_mkfs to
/dev/null like everybody does and make the golden output just expect to see "cp
failed" instead of the cp specific output.  Thanks,

Signed-off-by: Josef Bacik <jbacik@fb.com>
---
 tests/btrfs/029     | 6 +++---
 tests/btrfs/029.out | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/tests/btrfs/029 b/tests/btrfs/029
index b93b6df..80c05e3 100644
--- a/tests/btrfs/029
+++ b/tests/btrfs/029
@@ -66,7 +66,7 @@ mkdir $SOURCE_DIR
 
 rm -f $seqres.full
 
-_scratch_mkfs
+_scratch_mkfs > /dev/null 2>&1
 $XFS_IO_PROG -f -c 'pwrite -S 0x61 0 9000' $SOURCE_DIR/original \
  >> $seqres.full
 
@@ -87,8 +87,8 @@ _create_reflinks_to()
     # always reflink, should fail outright
     rm -rf $1; mkdir $1
     echo "reflink=always:"
-    cp --reflink=always $SOURCE_DIR/original $1/copyfail \
-        2>&1 | _filter_testdirs
+    cp --reflink=always $SOURCE_DIR/original $1/copyfail > $seqres.full 2>&1 \
+	|| echo "cp reflink failed"
 
     # The failed target actually gets created by cp:
     ls $1/copyfail | _filter_testdirs
diff --git a/tests/btrfs/029.out b/tests/btrfs/029.out
index 655c081..9390d95 100644
--- a/tests/btrfs/029.out
+++ b/tests/btrfs/029.out
@@ -4,12 +4,12 @@ reflink=auto:
 42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-029/original
 42d69d1a6d333a7ebdf64792a555e392  SCRATCH_MNT/test-029/copy
 reflink=always:
-cp: failed to clone 'SCRATCH_MNT/test-029/copyfail': Invalid cross-device link
+cp reflink failed
 SCRATCH_MNT/test-029/copyfail
 test reflinks across different mountpoints of same device
 reflink=auto:
 42d69d1a6d333a7ebdf64792a555e392  TEST_DIR/test-029/original
 42d69d1a6d333a7ebdf64792a555e392  SCRATCH_MNT/test-bis-029/copy
 reflink=always:
-cp: failed to clone 'SCRATCH_MNT/test-bis-029/copyfail': Invalid cross-device link
+cp reflink failed
 SCRATCH_MNT/test-bis-029/copyfail
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
