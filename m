Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40075 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751999AbdIQVHi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 17 Sep 2017 17:07:38 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 47/47] xfs: use kmem_free to free return value of kmem_zalloc
Date: Sun, 17 Sep 2017 14:07:12 -0700
Message-Id: <20170917210712.10804-48-hch@lst.de>
In-Reply-To: <20170917210712.10804-1-hch@lst.de>
References: <20170917210712.10804-1-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Pan Bian <bianpan2016@163.com>, "Darrick J . Wong" <darrick.wong@oracle.com>

From: Pan Bian <bianpan2016@163.com>

commit 6c370590cfe0c36bcd62d548148aa65c984540b7 upstream.

In function xfs_test_remount_options(), kfree() is used to free memory
allocated by kmem_zalloc(). But it is better to use kmem_free().

Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/xfs_super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 882fb8524fcb..67d589e0a49f 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1214,7 +1214,7 @@ xfs_test_remount_options(
 	tmp_mp->m_super = sb;
 	error = xfs_parseargs(tmp_mp, options);
 	xfs_free_fsname(tmp_mp);
-	kfree(tmp_mp);
+	kmem_free(tmp_mp);
 
 	return error;
 }
-- 
2.14.1

