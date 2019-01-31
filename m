Return-Path: linux-xfs-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:43338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726164AbfAaSJe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 31 Jan 2019 13:09:34 -0500
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 08/10] fs/xfs: fix f_ffree value for statfs when project quota is set
Date: Thu, 31 Jan 2019 10:09:17 -0800
Message-Id: <20190131180919.2500-9-mcgrof@kernel.org>
In-Reply-To: <20190131180919.2500-1-mcgrof@kernel.org>
References: <20190131180919.2500-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
To: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com
Cc: amir73il@gmail.com, hch@infradead.org, Ye Yin <dbyin@tencent.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>

From: Ye Yin <dbyin@tencent.com>

When project is set, we should use inode limit minus the used count

Signed-off-by: Ye Yin <dbyin@tencent.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/xfs_qm_bhv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index 73a1d77ec187..3091e4bc04ef 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -40,7 +40,7 @@ xfs_fill_statvfs_from_dquot(
 		statp->f_files = limit;
 		statp->f_ffree =
 			(statp->f_files > dqp->q_res_icount) ?
-			 (statp->f_ffree - dqp->q_res_icount) : 0;
+			 (statp->f_files - dqp->q_res_icount) : 0;
 	}
 }
 
-- 
2.18.0
