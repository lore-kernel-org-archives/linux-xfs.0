Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33273 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S939184AbdAJPjf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Jan 2017 10:39:35 -0500
Received: by mail-wm0-f65.google.com with SMTP id r144so21804766wme.0
        for <linux-xfs@vger.kernel.org>; Tue, 10 Jan 2017 07:39:34 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v7 3/6] xfs: add missing include dependencies to xfs_dir2.h
Date: Tue, 10 Jan 2017 17:39:14 +0200
Message-Id: <1484062757-12433-4-git-send-email-amir73il@gmail.com>
In-Reply-To: <1484062757-12433-1-git-send-email-amir73il@gmail.com>
References: <1484062757-12433-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

xfs_dir2.h dereferences some data types in inline functions
and fails to include those type definitions, e.g.:
xfs_dir2_data_aoff_t, struct xfs_da_geometry.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_dir2.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_dir2.h b/fs/xfs/libxfs/xfs_dir2.h
index 0197590..72df0dc 100644
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
2.7.4

