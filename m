Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40540 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728180AbeIFNNX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Sep 2018 09:13:23 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w868YwgX061150
        for <linux-xfs@vger.kernel.org>; Thu, 6 Sep 2018 04:39:02 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mayfkbvaq-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 06 Sep 2018 04:39:02 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 6 Sep 2018 02:39:01 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V2 16/16] Fix generic/235 to work with 64k block size
Date: Thu,  6 Sep 2018 14:10:13 +0530
In-Reply-To: <20180906084013.2687-1-chandan@linux.vnet.ibm.com>
References: <20180906084013.2687-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180906084013.2687-17-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, eguan@redhat.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

With 64k blocksized filesystem, this test fails since a single 8k write
will actually end up consuming 64k. Hence this commit writes 64k data
into the test file.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/generic/235     | 2 +-
 tests/generic/235.out | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tests/generic/235 b/tests/generic/235
index 902e9ad..6adc803 100755
--- a/tests/generic/235
+++ b/tests/generic/235
@@ -55,7 +55,7 @@ _try_scratch_mount "-o remount,ro" 2>&1 | tee -a $seqres.full | _filter_scratch
 touch $SCRATCH_MNT/failed 2>&1 | tee -a $seqres.full | _filter_scratch
 _try_scratch_mount "-o remount,rw" 2>&1 | tee -a $seqres.full | _filter_scratch
 
-$XFS_IO_PROG -c 'pwrite 0 8k' -c 'fsync' \
+$XFS_IO_PROG -c 'pwrite 0 64k' -c 'fsync' \
 			$SCRATCH_MNT/testfile >>$seqres.full 2>&1
 do_repquota
 
diff --git a/tests/generic/235.out b/tests/generic/235.out
index 601fa2f..abcb47a 100644
--- a/tests/generic/235.out
+++ b/tests/generic/235.out
@@ -17,10 +17,10 @@ Block grace time: 7days; Inode grace time: 7days
                         Block limits                File limits
 User            used    soft    hard  grace    used  soft  hard  grace
 ----------------------------------------------------------------------
-fsgqa     --       8       0       0              1     0     0       
+fsgqa     --      64       0       0              1     0     0       
 *** Report for group quotas on device SCRATCH_DEV
 Block grace time: 7days; Inode grace time: 7days
                         Block limits                File limits
 Group           used    soft    hard  grace    used  soft  hard  grace
 ----------------------------------------------------------------------
-fsgqa     --       8       0       0              1     0     0       
+fsgqa     --      64       0       0              1     0     0       
-- 
2.9.5
