Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:4684 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730566AbeIXVUr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Sep 2018 17:20:47 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8OFEbUW086412
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 11:18:07 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mq0mw5xpv-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 11:18:06 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 24 Sep 2018 09:18:05 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V5 06/20] Fix xfs/139 to work with 64k block size
Date: Mon, 24 Sep 2018 20:49:28 +0530
In-Reply-To: <20180924151942.8220-1-chandan@linux.vnet.ibm.com>
References: <20180924151942.8220-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180924151942.8220-7-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, guaneryu@gmail.com, darrick.wong@oracle.com, zlang@redhat.com, linux-xfs@vger.kernel.org

For 64k block size, the agsize provided in the test causes mkfs.xfs to
fail due to insufficient log space. Hence this commit computes agsize
based on block size of the filesystem.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/xfs/139     | 15 +++++++++------
 tests/xfs/139.out |  8 ++++++--
 2 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/tests/xfs/139 b/tests/xfs/139
index 2a26635..c074273 100755
--- a/tests/xfs/139
+++ b/tests/xfs/139
@@ -34,17 +34,20 @@ _require_cp_reflink
 
 rm -f $seqres.full
 
+_scratch_mkfs >/dev/null 2>&1
+_scratch_mount
+blksz=$(_get_file_block_size $SCRATCH_MNT)
+_scratch_unmount
+
 echo "Format and mount"
-_scratch_mkfs -d agsize=$((32 * 1048576)) > $seqres.full 2>&1
+_scratch_mkfs -d agsize=$((8192 * $blksz)) > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
-blksz="$(_get_block_size $testdir)"
 
 echo "Create the original files"
-sz=$((48 * 1048576))
-nr=$((sz / blksz))
+sz=$((12288 * $blksz))
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
index dc6a31e..72909bc 100644
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
+30000
+0 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61
+*
+30000
-- 
2.9.5
