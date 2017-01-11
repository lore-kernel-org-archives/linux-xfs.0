Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34122 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933704AbdAKIYi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 03:24:38 -0500
Received: by mail-wm0-f65.google.com with SMTP id c85so35008049wmi.1
        for <linux-xfs@vger.kernel.org>; Wed, 11 Jan 2017 00:24:37 -0800 (PST)
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v8 6/6] xfs: sanity check inode di_mode
Date: Wed, 11 Jan 2017 10:24:10 +0200
Message-Id: <1484123050-11064-7-git-send-email-amir73il@gmail.com>
In-Reply-To: <1484123050-11064-1-git-send-email-amir73il@gmail.com>
References: <1484123050-11064-1-git-send-email-amir73il@gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J . Wong" <darrick.wong@oracle.com>
Cc: Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org

Check for invalid file type in xfs_dinode_verify()
and fail to load the inode structure from disk.

Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 0091ac3..d93f9d9 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -29,6 +29,7 @@
 #include "xfs_icache.h"
 #include "xfs_trans.h"
 #include "xfs_ialloc.h"
+#include "xfs_dir2.h"
 
 /*
  * Check that none of the inode's in the buffer have a next
@@ -398,6 +399,8 @@ xfs_dinode_verify(
 		return false;
 
 	mode = be16_to_cpu(dip->di_mode);
+	if (mode && xfs_mode_to_ftype(mode) == XFS_DIR3_FT_UNKNOWN)
+		return false;
 
 	/* No zero-length symlinks/dirs. */
 	if ((S_ISLNK(mode) || S_ISDIR(mode)) && dip->di_size == 0)
-- 
2.7.4

