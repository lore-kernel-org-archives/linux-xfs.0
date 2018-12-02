Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:56730 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbeLBIEm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Dec 2018 03:04:42 -0500
Date: Sat, 1 Dec 2018 17:07:49 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] vfs: allow some remap flags to be passed to
 vfs_clone_file_range
Message-ID: <20181202010749.GQ8125@magnolia>
References: <20181130204238.GE8131@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181130204238.GE8131@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs <linux-xfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, amir73il@gmail.com, linux-unionfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

In overlayfs, ovl_remap_file_range calls vfs_clone_file_range on the
lower filesystem's inode, passing through whatever remap flags it got
from its caller.  Since vfs_copy_file_range first tries a filesystem's
remap function with REMAP_FILE_CAN_SHORTEN, this can get passed through
to the second vfs_copy_file_range call, and this isn't an issue.
Change the WARN_ON to look only for the DEDUP flag.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/read_write.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 4dae0399c75a..58f30537c47a 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1956,7 +1956,7 @@ loff_t do_clone_file_range(struct file *file_in, loff_t pos_in,
 	struct inode *inode_out = file_inode(file_out);
 	loff_t ret;
 
-	WARN_ON_ONCE(remap_flags);
+	WARN_ON_ONCE(remap_flags & REMAP_FILE_DEDUP);
 
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
 		return -EISDIR;
