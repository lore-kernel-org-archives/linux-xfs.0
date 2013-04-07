Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 143657F5E
	for <xfs@oss.sgi.com>; Sun,  7 Apr 2013 05:39:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A00BBAC002
	for <xfs@oss.sgi.com>; Sun,  7 Apr 2013 03:39:22 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wqDvvy3W4aK6SaLN for
	<xfs@oss.sgi.com>; Sun, 07 Apr 2013 03:39:18 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r37AdIri020725
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sun, 7 Apr 2013 06:39:18 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 2/3] xfstests: replace $seq.full with $seqres.full in ext4/305
	and generic/308
Date: Sun,  7 Apr 2013 18:39:06 +0800
Message-Id: <1365331147-15179-2-git-send-email-eguan@redhat.com>
In-Reply-To: <1365331147-15179-1-git-send-email-eguan@redhat.com>
References: <1365331147-15179-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>

We use $seqres.full to record verbose output now, replace $seq.full with
$seqres.full in ext4/305 and generic/308.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 tests/ext4/305    | 6 +++---
 tests/generic/308 | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/tests/ext4/305 b/tests/ext4/305
index bf9d9cd..eee461a 100644
--- a/tests/ext4/305
+++ b/tests/ext4/305
@@ -46,12 +46,12 @@ _supported_os Linux
 
 _require_scratch
 
-rm -f $seq.full
+rm -f $seqres.full
 echo "Silence is golden"
 
 DEV_BASENAME=$(basename $(readlink -f $SCRATCH_DEV))
-echo "Start test on device $SCRATCH_DEV, basename $DEV_BASENAME" >$seq.full
-_scratch_mkfs >>$seq.full 2>&1
+echo "Start test on device $SCRATCH_DEV, basename $DEV_BASENAME" >$seqres.full
+_scratch_mkfs >>$seqres.full 2>&1
 
 while true;do
 	mount $SCRATCH_DEV $SCRATCH_MNT
diff --git a/tests/generic/308 b/tests/generic/308
index 0db093a..8037c08 100644
--- a/tests/generic/308
+++ b/tests/generic/308
@@ -45,7 +45,7 @@ testfile=$TEST_DIR/testfile.$seq
 _supported_fs generic
 _supported_os Linux
 
-rm -f $seq.full
+rm -f $seqres.full
 echo "Silence is golden"
 
 block_size=`stat -f -c %s $TEST_DIR`
@@ -58,11 +58,11 @@ block_size=`stat -f -c %s $TEST_DIR`
 
 # Create a sparse file with an extent lays at one block before old s_maxbytes
 offset=$(((2**32 - 2) * $block_size))
-$XFS_IO_PROG -f -c "pwrite $offset $block_size" -c fsync $testfile >$seq.full 2>&1
+$XFS_IO_PROG -f -c "pwrite $offset $block_size" -c fsync $testfile >$seqres.full 2>&1
 
 # Write to the block after the extent just created
 offset=$(((2**32 - 1) * $block_size))
-$XFS_IO_PROG -f -c "pwrite $offset $block_size" -c fsync $testfile >>$seq.full 2>&1
+$XFS_IO_PROG -f -c "pwrite $offset $block_size" -c fsync $testfile >>$seqres.full 2>&1
 
 # Got here without hitting BUG_ON(), test passed
 status=0
-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
