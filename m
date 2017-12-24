Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:40288 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751574AbdLXMfB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 24 Dec 2017 07:35:01 -0500
From: Xiongwei Song <sxwjean@gmail.com>
Subject: [PATCH] xfs: destroy mutex qi_tree_lock before free xfs_quotainfo_t object
Date: Sun, 24 Dec 2017 20:34:47 +0800
Message-Id: <20171224123447.2998-1-sxwjean@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com, linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

The mutex qi_tree_lock of xfs_quotainfo_t object was initialized when
calling xfs_qm_init_quotainfo, but it was not destroyed before free
xfs_quotainfo_t object when calling xfs_qm_destroy_quotainfo, this was
incorrect, so destroy it in function xfs_qm_destroy_quotainfo.

Signed-off-by: Xiongwei Song <sxwjean@gmail.com>
---
 fs/xfs/xfs_qm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ec952dfad359..deceef5cbbf3 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -737,6 +737,7 @@ xfs_qm_destroy_quotainfo(
 		qi->qi_pquotaip = NULL;
 	}
 	mutex_destroy(&qi->qi_quotaofflock);
+	mutex_destroy(&qi->qi_tree_lock);
 	kmem_free(qi);
 	mp->m_quotainfo = NULL;
 }
-- 
2.15.1

