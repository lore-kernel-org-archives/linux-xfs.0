Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36722 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727384AbeILL1i (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 12 Sep 2018 07:27:38 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w8C6JdLi143330
        for <linux-xfs@vger.kernel.org>; Wed, 12 Sep 2018 02:24:38 -0400
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2meqxvbaa2-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Wed, 12 Sep 2018 02:24:37 -0400
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Wed, 12 Sep 2018 02:24:36 -0400
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V3 12/19] Fix generic/172 to work with 64k block size
Date: Wed, 12 Sep 2018 11:56:19 +0530
In-Reply-To: <20180912062626.14349-1-chandan@linux.vnet.ibm.com>
References: <20180912062626.14349-1-chandan@linux.vnet.ibm.com>
Message-Id: <20180912062626.14349-13-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: fstests@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, guaneryu@gmail.com, darrick.wong@oracle.com, linux-xfs@vger.kernel.org

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
