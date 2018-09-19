Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:34472 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731523AbeISRhZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Sep 2018 13:37:25 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8JC1csF055451
        for <linux-xfs@vger.kernel.org>; Wed, 19 Sep 2018 08:02:24 -0400
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2mkmh13ujd-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 19 Sep 2018 08:02:24 -0400
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 19 Sep 2018 07:59:47 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V4 17/20] Fix generic/235 to work with 64k block size
Date: Wed, 19 Sep 2018 17:30:50 +0530
In-Reply-To: <20180919120053.7339-1-chandan@linux.vnet.ibm.com>
References: <20180919120053.7339-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180919120053.7339-18-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, guaneryu@gmail.com, darrick.wong@oracle.com, zlang@redhat.com, linux-xfs@vger.kernel.org

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
