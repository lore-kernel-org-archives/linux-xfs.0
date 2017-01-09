Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:59768 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S938655AbdAIPkM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Jan 2017 10:40:12 -0500
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 23/32] xfs: don't crash if reading a directory results in an unexpected hole
Date: Mon,  9 Jan 2017 16:38:54 +0100
Message-Id: <1483976343-661-24-git-send-email-hch@lst.de>
In-Reply-To: <1483976343-661-1-git-send-email-hch@lst.de>
References: <1483976343-661-1-git-send-email-hch@lst.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: stable@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 96a3aefb8ffde23180130460b0b2407b328eb727 upstream.

In xfs_dir3_data_read, we can encounter the situation where err == 0 and
*bpp == NULL if the given bno offset happens to be a hole; this leads to
a crash if we try to set the buffer type after the _da_read_buf call.
Holes can happen due to corrupt or malicious entries in the bmbt data,
so be a little more careful when we're handling buffers.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Signed-off-by: Dave Chinner <david@fromorbit.com>
---
 fs/xfs/libxfs/xfs_dir2_data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 725fc78..e526f5a 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -329,7 +329,7 @@ xfs_dir3_data_read(
 
 	err = xfs_da_read_buf(tp, dp, bno, mapped_bno, bpp,
 				XFS_DATA_FORK, &xfs_dir3_data_buf_ops);
-	if (!err && tp)
+	if (!err && tp && *bpp)
 		xfs_trans_buf_set_type(tp, *bpp, XFS_BLFT_DIR_DATA_BUF);
 	return err;
 }
-- 
2.1.4

