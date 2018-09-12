Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58198 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727403AbeILL1m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Sep 2018 07:27:42 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8C6Je8E121916
        for <linux-xfs@vger.kernel.org>; Wed, 12 Sep 2018 02:24:43 -0400
Received: from e14.ny.us.ibm.com (e14.ny.us.ibm.com [129.33.205.204])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mescu87f7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Sep 2018 02:24:42 -0400
Received: from localhost
        by e14.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 12 Sep 2018 02:24:41 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V3 15/19] Fix generic/230 to work with 64k block size
Date: Wed, 12 Sep 2018 11:56:22 +0530
In-Reply-To: <20180912062626.14349-1-chandan@linux.vnet.ibm.com>
References: <20180912062626.14349-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180912062626.14349-16-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, guaneryu@gmail.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

This commit changes the test to work on file offsets that are aligned
with the block size of the underlying filesystem.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/generic/230     | 23 +++++++++++++----------
 tests/generic/230.out | 16 ++++++++--------
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/tests/generic/230 b/tests/generic/230
index bc8c1ad..fc09391 100755
--- a/tests/generic/230
+++ b/tests/generic/230
@@ -42,27 +42,27 @@ test_enforcement()
 	echo "### some buffered IO (type=$type)"
 	echo "--- initiating IO..." >>$seqres.full
 	# Firstly fit below block soft limit
-	echo "Write 900k..."
-	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 900k' -c fsync \
+	echo "Write 225 blocks..."
+	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 $((225 * $BLOCK_SIZE))' -c fsync \
 		$SCRATCH_MNT/file1" 2>&1 >>$seqres.full | \
 		_filter_xfs_io_error | tee -a $seqres.full
 	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
 	# Secondly overcome block soft limit
-	echo "Rewrite 1001k..."
-	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 1001k' -c fsync \
+	echo "Rewrite 250 blocks plus 1 byte..."
+	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 $((250 * $BLOCK_SIZE + 1))' -c fsync \
 		$SCRATCH_MNT/file1" 2>&1 >>$seqres.full | \
 		_filter_xfs_io_error | tee -a $seqres.full
 	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
 	# Now try to overcome block hardlimit
-	echo "Write 1000k..."
-	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 1000k' -c fsync \
+	echo "Write 250 blocks..."
+	su $qa_user -c "$XFS_IO_PROG -c 'pwrite 0 $((250 * $BLOCK_SIZE))' -c fsync \
 		$SCRATCH_MNT/file2" 2>&1 >>$seqres.full | \
 		_filter_xfs_io_error | tee -a $seqres.full
 	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
 	# Now sleep for grace time and check that softlimit got enforced
 	sleep $((grace+1))
-	echo "Write 4096..."
-	su $qa_user -c "$XFS_IO_PROG -c 'truncate 0' -c 'pwrite 0 4096' \
+	echo "Write 1 block..."
+	su $qa_user -c "$XFS_IO_PROG -c 'truncate 0' -c 'pwrite 0 $BLOCK_SIZE' \
 		$SCRATCH_MNT/file2" 2>&1 >>$seqres.full | \
 		_filter_xfs_io_error | tee -a $seqres.full
 	repquota -$type $SCRATCH_MNT  | grep -v "^root" >>$seqres.full 2>&1
@@ -101,11 +101,14 @@ grace=2
 
 _scratch_mkfs >> $seqres.full 2>&1
 _scratch_mount "-o usrquota,grpquota"
+BLOCK_SIZE=$(_get_block_size $SCRATCH_MNT)
 quotacheck -u -g $SCRATCH_MNT 2>/dev/null
 quotaon $SCRATCH_MNT 2>/dev/null
-setquota -u $qa_user 1000 2000 3 5 $SCRATCH_MNT
+setquota -u $qa_user $((250 * $BLOCK_SIZE / 1024)) \
+	 $((500 * $BLOCK_SIZE / 1024)) 3 5 $SCRATCH_MNT
 setquota -u -t $grace $grace $SCRATCH_MNT
-setquota -g $qa_user 1000 2000 3 5 $SCRATCH_MNT
+setquota -g $qa_user $((250 * $BLOCK_SIZE / 1024)) \
+	 $((500 * $BLOCK_SIZE / 1024)) 3 5 $SCRATCH_MNT
 setquota -g -t $grace $grace $SCRATCH_MNT
 _scratch_unmount
 
diff --git a/tests/generic/230.out b/tests/generic/230.out
index fcbacf2..9e89a47 100644
--- a/tests/generic/230.out
+++ b/tests/generic/230.out
@@ -4,11 +4,11 @@ QA output created by 230
 
 ### create files, setting up ownership (type=u)
 ### some buffered IO (type=u)
-Write 900k...
-Rewrite 1001k...
-Write 1000k...
+Write 225 blocks...
+Rewrite 250 blocks plus 1 byte...
+Write 250 blocks...
 pwrite: Disk quota exceeded
-Write 4096...
+Write 1 block...
 pwrite: Disk quota exceeded
 Touch 3+4
 Touch 5+6
@@ -20,11 +20,11 @@ touch: cannot touch 'SCRATCH_MNT/file5': Disk quota exceeded
 
 ### create files, setting up ownership (type=g)
 ### some buffered IO (type=g)
-Write 900k...
-Rewrite 1001k...
-Write 1000k...
+Write 225 blocks...
+Rewrite 250 blocks plus 1 byte...
+Write 250 blocks...
 pwrite: Disk quota exceeded
-Write 4096...
+Write 1 block...
 pwrite: Disk quota exceeded
 Touch 3+4
 Touch 5+6
-- 
2.9.5
