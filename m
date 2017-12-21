Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:39519 "EHLO
        mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755389AbdLUURu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 21 Dec 2017 15:17:50 -0500
Received: by mail-lf0-f68.google.com with SMTP id m20so16126316lfi.6
        for <linux-xfs@vger.kernel.org>; Thu, 21 Dec 2017 12:17:50 -0800 (PST)
From: Aliaksei Karaliou <akaraliou.dev@gmail.com>
Subject: [PATCH 1/2] xfs: quota: fix missed destroy of qi_tree_lock
Date: Thu, 21 Dec 2017 23:17:42 +0300
Message-Id: <20171221201743.18016-1-akaraliou.dev@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: Aliaksei Karaliou <akaraliou.dev@gmail.com>, linux-xfs@vger.kernel.org

xfs_qm_destroy_quotainfo() does not destroy quotainfo->qi_tree_lock
while destroys quotainfo->qi_quotaofflock.

Signed-off-by: Aliaksei Karaliou <akaraliou.dev@gmail.com>
---
 fs/xfs/xfs_qm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index ec952dfad359..d0053115427f 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -736,6 +736,7 @@ xfs_qm_destroy_quotainfo(
 		IRELE(qi->qi_pquotaip);
 		qi->qi_pquotaip = NULL;
 	}
+	mutex_destroy(&qi->qi_tree_lock);
 	mutex_destroy(&qi->qi_quotaofflock);
 	kmem_free(qi);
 	mp->m_quotainfo = NULL;
-- 
2.11.0

