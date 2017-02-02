Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41827 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750926AbdBBH4q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Feb 2017 02:56:46 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 08/19] xfs: add missing include dependencies to xfs_dir2.h
Date: Thu,  2 Feb 2017 08:56:00 +0100
Message-Id: <1486022171-8076-9-git-send-email-hch@lst.de>
In-Reply-To: <1486022171-8076-1-git-send-email-hch@lst.de>
References: <1486022171-8076-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, "Darrick J. Wong" <darrick.wong@oracle.com>

From: Amir Goldstein <amir73il@gmail.com>

commit b597dd5373a1ccc08218665dc8417433b1c09550 upstream.

xfs_dir2.h dereferences some data types in inline functions
and fails to include those type definitions, e.g.:
xfs_dir2_data_aoff_t, struct xfs_da_geometry.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_dir2.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index becc926..6a3fe31 100644
--- a/fs/xfs/libxfs/xfs_dir2.h
+++ b/fs/xfs/libxfs/xfs_dir2.h
@@ -18,6 +18,9 @@
 #ifndef __XFS_DIR2_H__
 #define __XFS_DIR2_H__
 
+#include "xfs_da_format.h"
+#include "xfs_da_btree.h"
+
 struct xfs_defer_ops;
 struct xfs_da_args;
 struct xfs_inode;
-- 
2.1.4

