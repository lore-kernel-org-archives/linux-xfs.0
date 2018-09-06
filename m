Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38050 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728220AbeIFNMu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Sep 2018 09:12:50 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w868Ywvn061169
        for <linux-xfs@vger.kernel.org>; Thu, 6 Sep 2018 04:38:29 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mayfkbust-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 06 Sep 2018 04:38:29 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 6 Sep 2018 02:38:28 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V2 06/16] Fix xfs/139 to work with 64k block size
Date: Thu,  6 Sep 2018 14:10:03 +0530
In-Reply-To: <20180906084013.2687-1-chandan@linux.vnet.ibm.com>
References: <20180906084013.2687-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180906084013.2687-7-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, eguan@redhat.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

For 64k block size, the agsize provided in the test causes mkfs.xfs to
fail due to insufficient log space. Hence this commit computes agsize
based on block size of the filesystem.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/xfs/139     | 15 +++++++++------
 tests/xfs/139.out |  8 ++++++--
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/tests/xfs/139 b/tests/xfs/139
index 2a26635..9ab74c8 100755
--- a/tests/xfs/139
+++ b/tests/xfs/139
@@ -34,17 +34,20 @@ _require_cp_reflink
 
 rm -f $seqres.full
 
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+blksz=$(_get_block_size $SCRATCH_MNT)
+_scratch_unmount
+
 echo "Format and mount"
-_scratch_mkfs -d agsize=$((32 * 1048576)) > $seqres.full 2>&1
+_scratch_mkfs -d agsize=$((4400 * $blksz)) > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
-blksz="$(_get_block_size $testdir)"
 
 echo "Create the original files"
-sz=$((48 * 1048576))
-nr=$((sz / blksz))
+sz=$((4800 * $blksz))
 _pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
 _cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
 _scratch_cycle_mount
@@ -54,8 +57,8 @@ _pwrite_byte 0x62 0 $sz $testdir/file1 >> $seqres.full
 _scratch_cycle_mount
 
 echo "Compare files"
-md5sum $testdir/file1 | _filter_scratch
-md5sum $testdir/file2 | _filter_scratch
+od -t x1 $testdir/file1 | _filter_od
+od -t x1 $testdir/file2 | _filter_od
 #filefrag -v $testdir/file1 $testdir/file2
 
 # success, all done
diff --git a/tests/xfs/139.out b/tests/xfs/139.out
index dc6a31e..55e03d6 100644
--- a/tests/xfs/139.out
+++ b/tests/xfs/139.out
@@ -3,5 +3,9 @@ Format and mount
 Create the original files
 CoW every other block
 Compare files
-673c759fb131ccf3336c4f8c549a497e  SCRATCH_MNT/test-139/file1
-dc802351f6717547cbf4c951b294f952  SCRATCH_MNT/test-139/file2
+0 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62
+*
+11300
+0 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61
+*
+11300
-- 
2.9.5
