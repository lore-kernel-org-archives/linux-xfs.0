Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46458 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751768AbdB1Nr5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Feb 2017 08:47:57 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v1S9tHrG107160
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2017 04:57:11 -0500
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 28w3d4hj0y-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Tue, 28 Feb 2017 04:57:10 -0500
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-xfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Tue, 28 Feb 2017 02:57:09 -0700
From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH] xfs: Use xfs_icluster_size_fsb() to calculate inode alignment mask
Date: Tue, 28 Feb 2017 15:26:56 +0530
Message-Id: <1488275816-26711-1-git-send-email-chandan@linux.vnet.ibm.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, darrick.wong@oracle.com, sandeen@sandeen.net

When block size is larger than inode cluster size, the call to
XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size) returns 0. Also, mkfs.xfs
would have set xfs_sb->sb_inoalignmt to 0. Hence in
xfs_set_inoalignment(), xfs_mount->m_inoalign_mask gets initialized to
-1 instead of 0. However, xfs_mount->m_sinoalign would get correctly
intialized to 0 because for every positive value of xfs_mount->m_dalign,
the condition "!(mp->m_dalign & mp->m_inoalign_mask)" would evaluate to
false.

Also, xfs_imap() worked fine even with xfs_mount->m_inoalign_mask having
-1 as the value because blks_per_cluster variable would have the value 1
and hence we would never have a need to use xfs_mount->m_inoalign_mask
to compute the inode chunk's agbno and offset within the chunk.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/xfs/xfs_mount.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 450bde6..688ebff 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -513,8 +513,7 @@ STATIC void
 xfs_set_inoalignment(xfs_mount_t *mp)
 {
 	if (xfs_sb_version_hasalign(&mp->m_sb) &&
-	    mp->m_sb.sb_inoalignmt >=
-	    XFS_B_TO_FSBT(mp, mp->m_inode_cluster_size))
+		mp->m_sb.sb_inoalignmt >= xfs_icluster_size_fsb(mp))
 		mp->m_inoalign_mask = mp->m_sb.sb_inoalignmt - 1;
 	else
 		mp->m_inoalign_mask = 0;
-- 
2.5.5

