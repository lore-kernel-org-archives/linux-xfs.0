Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:38818 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726020AbeJHNbJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Oct 2018 09:31:09 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w986JpLi098330
        for <linux-xfs@vger.kernel.org>; Mon, 8 Oct 2018 02:21:03 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2myxynxayx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 08 Oct 2018 02:21:03 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 8 Oct 2018 00:21:02 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH 2/2] xfs/140: work with 1k block size
Date: Mon,  8 Oct 2018 11:53:03 +0530
In-Reply-To: <20181008062303.32286-1-chandan@linux.vnet.ibm.com>
References: <20181008062303.32286-1-chandan@linux.vnet.ibm.com>
Message-Id: <20181008062303.32286-2-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, guaneryu@gmail.com, darrick.wong@oracle.com, zlang@redhat.com, david@fromorbit.com, linux-xfs@vger.kernel.org

Commit 7a7641063ac3a7ae051c9e1959f4d7b1a25bb91c (xfs/140: work with 64k
block size) created a test filesystem with AG size set to (8192 * block
size). When working with a 1k block sized XFS filesystem, this tries to
set the AG size to 8MiB which is less than the minimum AG size of
16MiB. Hence creation of the filesystem had actually failed.

This commit fixes the issue by resetting AG size to 16MiB if (8192 *
block size) results in a value less than 16MiB. Later the test file size
and the test file block count are then appropriately calculated.

Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/xfs/140 | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tests/xfs/140 b/tests/xfs/140
index c06a722..7385dc4 100755
--- a/tests/xfs/140
+++ b/tests/xfs/140
@@ -39,16 +39,21 @@ _scratch_mount
 blksz=$(_get_file_block_size $SCRATCH_MNT)
 _scratch_unmount
 
+agsize=$((8192 * $blksz))
+if [[ $agsize -lt $((16 * 1024 * 1024)) ]]; then
+	agsize=$((16 * 1024 * 1024))
+fi
+sz=$((4096 * $blksz + $agsize))
+nr=$(($sz / $blksz))
+
 echo "Format and mount"
-_scratch_mkfs -d agsize=$((8192 * $blksz)) > $seqres.full 2>&1
+_scratch_mkfs -d agsize=$agsize > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
-nr=12288
-sz=$(($nr * $blksz))
 _pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
 _cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
 _pwrite_byte 0x61 0 $sz $testdir/file2.chk >> $seqres.full
-- 
2.9.5
