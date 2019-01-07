Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:8570 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726574AbfAGJxo (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Jan 2019 04:53:44 -0500
From: Su Yanjun <suyj.fnst@cn.fujitsu.com>
Subject: [PATCH] xfs: correct statx's result_mask value
Date: Mon, 7 Jan 2019 04:53:10 -0500
Message-ID: <1546854790-5233-1-git-send-email-suyj.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, suyj.fnst@cn.fujitsu.com, suyanjun218@gmail.com

For statx syscall, xfs return the wrong result_mask.

Signed-off-by: Su Yanjun <suyj.fnst@cn.fujitsu.com>
---
 fs/xfs/xfs_iops.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index f48ffd7..3811457 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -521,6 +521,9 @@ xfs_vn_getattr(
 			stat->btime.tv_nsec = ip->i_d.di_crtime.t_nsec;
 		}
 	}
+	
+	/* Only return mask that we care */
+	stat->result_mask &= request_mask;
 
 	if (ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE)
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
-- 
2.7.4
