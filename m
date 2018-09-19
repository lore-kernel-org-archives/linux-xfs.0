Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:41244 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731472AbeISRgr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Sep 2018 13:36:47 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8JBx001051590
        for <linux-xfs@vger.kernel.org>; Wed, 19 Sep 2018 07:59:10 -0400
Received: from e11.ny.us.ibm.com (e11.ny.us.ibm.com [129.33.205.201])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2mkkxjdcas-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 19 Sep 2018 07:59:10 -0400
Received: from localhost
        by e11.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 19 Sep 2018 07:59:10 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V4 07/20] Fix xfs/140 to work with 64k block size
Date: Wed, 19 Sep 2018 17:30:40 +0530
In-Reply-To: <20180919120053.7339-1-chandan@linux.vnet.ibm.com>
References: <20180919120053.7339-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180919120053.7339-8-chandan@linux.vnet.ibm.com>
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
 tests/xfs/140 | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tests/xfs/140 b/tests/xfs/140
index 6e89fe3..c06a722 100755
--- a/tests/xfs/140
+++ b/tests/xfs/140
@@ -34,17 +34,21 @@ _require_cp_reflink
 
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
-blksz=$(_get_block_size $testdir)
 
 echo "Create the original files"
-sz=$((48 * 1048576))
-nr=$((sz / blksz))
+nr=12288
+sz=$(($nr * $blksz))
 _pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
 _cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
 _pwrite_byte 0x61 0 $sz $testdir/file2.chk >> $seqres.full
-- 
2.9.5
