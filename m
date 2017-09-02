Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:39056 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752780AbdIBWmB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 2 Sep 2017 18:42:01 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v82MfMQD021548
        for <linux-xfs@vger.kernel.org>; Sat, 2 Sep 2017 15:42:00 -0700
Received: from mail.thefacebook.com ([199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2cqrp71bpe-2
        (version=TLSv1 cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NOT)
        for <linux-xfs@vger.kernel.org>; Sat, 02 Sep 2017 15:42:00 -0700
From: Richard Wareing <rwareing@fb.com>
Subject: [PATCH v2 2/3] fs/xfs: Add real-time device support to statfs
Date: Sat, 2 Sep 2017 15:41:44 -0700
Message-ID: <20170902224145.1291030-3-rwareing@fb.com>
In-Reply-To: <20170902224145.1291030-1-rwareing@fb.com>
References: <20170902224145.1291030-1-rwareing@fb.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Richard Wareing <rwareing@fb.com>, david@fromorbit.com, darrick.wong@oracle.com

- Reports real-time device free blocks in statfs calls if
inheritance bit is set on the inode of directory.  This is a bit more
intuitive, especially for use-cases which are using a much larger
device for the real-time device.

Signed-off-by: Richard Wareing <rwareing@fb.com>
---
 fs/xfs/xfs_super.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 4dbf95c..a1d6968 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1148,6 +1148,12 @@ xfs_fs_statfs(
 	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
 			      (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))
 		xfs_qm_statvfs(ip, statp);
+	if ((ip->i_d.di_flags & XFS_DIFLAG_RTINHERIT) &&
+		(mp->m_rtdev_targp != NULL)) {
+		statp->f_blocks = sbp->sb_rblocks;
+		statp->f_bfree = sbp->sb_frextents * sbp->sb_rextsize -
+			mp->m_alloc_set_aside;
+	}
 	return 0;
 }
 
-- 
2.9.3

