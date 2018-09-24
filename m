Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:59018 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730558AbeIXVUw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Sep 2018 17:20:52 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8OFEtE7107743
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 11:18:11 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mq1re2957-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 24 Sep 2018 11:18:11 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 24 Sep 2018 09:18:09 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V5 07/20] Fix xfs/140 to work with 64k block size
Date: Mon, 24 Sep 2018 20:49:29 +0530
In-Reply-To: <20180924151942.8220-1-chandan@linux.vnet.ibm.com>
References: <20180924151942.8220-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180924151942.8220-8-chandan@linux.vnet.ibm.com>
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
