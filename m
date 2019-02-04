Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:37896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728619AbfBDQyh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 4 Feb 2019 11:54:37 -0500
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH v2 08/10] fs/xfs: fix f_ffree value for statfs when project quota is set
Date: Mon,  4 Feb 2019 08:54:25 -0800
Message-Id: <20190204165427.23607-9-mcgrof@kernel.org>
In-Reply-To: <20190204165427.23607-1-mcgrof@kernel.org>
References: <20190204165427.23607-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org, Alexander.Levin@microsoft.com
Cc: stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org, Ye Yin <dbyin@tencent.com>, "Darrick J . Wong" <darrick.wong@oracle.com>, Luis Chamberlain <mcgrof@kernel.org>

From: Ye Yin <dbyin@tencent.com>

commit de7243057e7cefa923fa5f467c0f1ec24eef41d2 upsream.

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
