Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:33608 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725925AbeJHNbF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 8 Oct 2018 09:31:05 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w986K1fV053837
        for <linux-xfs@vger.kernel.org>; Mon, 8 Oct 2018 02:21:00 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mywmvjhrx-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Mon, 08 Oct 2018 02:21:00 -0400
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 8 Oct 2018 00:20:59 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH 1/2] xfs/139: work with 1k block size
Date: Mon,  8 Oct 2018 11:53:02 +0530
Message-Id: <20181008062303.32286-1-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, guaneryu@gmail.com, darrick.wong@oracle.com, zlang@redhat.com, david@fromorbit.com, linux-xfs@vger.kernel.org

Commit 0e2b99951fa11ea8a8adf4676aef130cfeeb5250 (xfs/139: work with 64k
block size) created a test filesystem with AG size set to (8192 * block
size). When working with a 1k block sized XFS filesystem, this tries to
set the AG size to 8MiB which is less than the minimum AG size of
16MiB. Hence creation of the filesystem had actually failed.

This commit fixes the issue by setting AG size to be (16384 * block
size).

Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/xfs/139     | 4 ++--
 tests/xfs/139.out | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/xfs/139 b/tests/xfs/139
index c074273..3a20ce5 100755
--- a/tests/xfs/139
+++ b/tests/xfs/139
@@ -40,14 +40,14 @@ blksz=$(_get_file_block_size $SCRATCH_MNT)
 _scratch_unmount
 
 echo "Format and mount"
-_scratch_mkfs -d agsize=$((8192 * $blksz)) > $seqres.full 2>&1
+_scratch_mkfs -d agsize=$((16384 * $blksz)) > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
 mkdir $testdir
 
 echo "Create the original files"
-sz=$((12288 * $blksz))
+sz=$((20480 * $blksz))
 _pwrite_byte 0x61 0 $sz $testdir/file1 >> $seqres.full
 _cp_reflink $testdir/file1 $testdir/file2 >> $seqres.full
 _scratch_cycle_mount
diff --git a/tests/xfs/139.out b/tests/xfs/139.out
index 72909bc..1005d5c 100644
--- a/tests/xfs/139.out
+++ b/tests/xfs/139.out
@@ -5,7 +5,7 @@ CoW every other block
 Compare files
 0 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62
 *
-30000
+50000
 0 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61
 *
-30000
+50000
-- 
2.9.5
