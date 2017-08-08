Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from m12-14.163.com ([220.181.12.14]:60202 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751880AbdHHMSR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 8 Aug 2017 08:18:17 -0400
From: Pan Bian <bianpan2016@163.com>
Subject: xfs: use kmem_free to free return value of kmem_zalloc
Date: Tue,  8 Aug 2017 20:17:57 +0800
Message-Id: <1502194677-28047-1-git-send-email-bianpan2016@163.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>

In function xfs_test_remount_options(), kfree() is used to free memory
allocated by kmem_zalloc(). But it is better to use kmem_free().

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 38aaacd..c1c4c2e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1220,7 +1220,7 @@ struct proc_xfs_info {
 	tmp_mp->m_super = sb;
 	error = xfs_parseargs(tmp_mp, options);
 	xfs_free_fsname(tmp_mp);
-	kfree(tmp_mp);
+	kmem_free(tmp_mp);
 
 	return error;
 }
-- 
1.9.1


