Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:39631 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728514AbfDQB1d (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 16 Apr 2019 21:27:33 -0400
From: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
Subject: [RFC PATCH 4/4] fs/xfs: iomap: update the extent list after a COW
Date: Wed, 17 Apr 2019 09:27:15 +0800
Message-ID: <20190417012715.8287-5-ruansy.fnst@cn.fujitsu.com>
In-Reply-To: <20190417012715.8287-1-ruansy.fnst@cn.fujitsu.com>
References: <20190417012715.8287-1-ruansy.fnst@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org, linux-nvdimm@lists.01.org

COW allocated new extents, which are new part of the inode,  So we
need to update the metadata.

Signed-off-by: Shiyang Ruan <ruansy.fnst@cn.fujitsu.com>
---
 fs/xfs/xfs_iomap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index a45b4e5a1d87..5c05c11e0cb2 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -1146,6 +1146,9 @@ xfs_file_iomap_end(
 	if ((flags & IOMAP_WRITE) && iomap->type == IOMAP_DELALLOC)
 		return xfs_file_iomap_end_delalloc(XFS_I(inode), offset,
 				length, written, iomap);
+	/* update the extent list after a COW operation */
+	if (iomap->flags & IOMAP_F_SHARED && iomap->src_addr)
+		return xfs_reflink_end_cow(XFS_I(inode), offset, length);
 	return 0;
 }
 
-- 
2.17.0
