Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:45932 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728220AbeIFNMr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Sep 2018 09:12:47 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w868Xu6G025985
        for <linux-xfs@vger.kernel.org>; Thu, 6 Sep 2018 04:38:26 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2maymd3brp-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 06 Sep 2018 04:38:25 -0400
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 6 Sep 2018 02:38:25 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V2 05/16] Fix xfs/127 to work with 64k block size
Date: Thu,  6 Sep 2018 14:10:02 +0530
In-Reply-To: <20180906084013.2687-1-chandan@linux.vnet.ibm.com>
References: <20180906084013.2687-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180906084013.2687-6-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, eguan@redhat.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

With reflink feature enabled, we require atleast 500MiB of
disk space to create a filesystem with 64k block size. Hence this commit
sets the size of the scratch filesystem to 512MiB.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/xfs/127 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tests/xfs/127 b/tests/xfs/127
index 41dacd7..6a95026 100755
--- a/tests/xfs/127
+++ b/tests/xfs/127
@@ -34,7 +34,7 @@ _require_no_large_scratch_dev
 _require_cp_reflink
 
 echo "Format and mount"
-_scratch_mkfs_sized $((2 * 4096 * 4096)) > $seqres.full 2>&1
+_scratch_mkfs_sized $((512 * 1024 * 1024)) > $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 
 testdir=$SCRATCH_MNT/test-$seq
-- 
2.9.5
