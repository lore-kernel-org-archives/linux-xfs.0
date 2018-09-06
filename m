Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45452 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728224AbeIFNNL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Sep 2018 09:13:11 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w868Xvcj100723
        for <linux-xfs@vger.kernel.org>; Thu, 6 Sep 2018 04:38:49 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2maymd3gj7-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Thu, 06 Sep 2018 04:38:49 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Thu, 6 Sep 2018 02:38:48 -0600
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V2 12/16] Fix generic/172 to work with 64k block size
Date: Thu,  6 Sep 2018 14:10:09 +0530
In-Reply-To: <20180906084013.2687-1-chandan@linux.vnet.ibm.com>
References: <20180906084013.2687-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180906084013.2687-13-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, eguan@redhat.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

For 64k block size, With 256MiB as the XFS filesystem size and 168 MiB
as the size of the clone source file, we end up hitting ENOSPC when
cloning the source file. This happens due to lack of space for housing
the corresponding metadata. This scenario also occurs when using a
512MiB XFS filesystem and 300MiB clone source file.

Hence this commit increases the size of the test filesystem to 1 GiB and
the size of the clone source file to 768MiB.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 tests/generic/172 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/generic/172 b/tests/generic/172
index 5d6f295..08d2789 100755
--- a/tests/generic/172
+++ b/tests/generic/172
@@ -47,8 +47,8 @@ echo "Reformat with appropriate size"
 blksz="$(_get_block_size $testdir)"
 umount $SCRATCH_MNT
 
-file_size=$((168 * 1024 * 1024))
-fs_size=$((256 * 1024 * 1024))
+file_size=$((768 * 1024 * 1024))
+fs_size=$((1024 * 1024 * 1024))
 _scratch_mkfs_sized $fs_size >> $seqres.full 2>&1
 _scratch_mount >> $seqres.full 2>&1
 rm -rf $testdir
-- 
2.9.5
