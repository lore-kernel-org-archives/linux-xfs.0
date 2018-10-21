Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:43152 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727408AbeJVAdA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Oct 2018 20:33:00 -0400
Subject: [PATCH 26/28] xfs: remove redundant remap partial EOF block checks
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 21 Oct 2018 09:18:04 -0700
Message-ID: <154013868417.29026.5852711121957107278.stgit@magnolia>
In-Reply-To: <154013850285.29026.16168387526580596209.stgit@magnolia>
References: <154013850285.29026.16168387526580596209.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Now that we've moved the partial EOF block checks to the VFS helpers, we
can remove the redundant functionality from XFS.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 fs/xfs/xfs_reflink.c |   19 -------------------
 1 file changed, 19 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 4abb2aea8f31..bccc66316cc4 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1314,7 +1314,6 @@ xfs_reflink_remap_prep(
 	struct inode		*inode_out = file_inode(file_out);
 	struct xfs_inode	*dest = XFS_I(inode_out);
 	bool			same_inode = (inode_in == inode_out);
-	u64			blkmask = i_blocksize(inode_in) - 1;
 	ssize_t			ret;
 
 	/* Lock both files against IO */
@@ -1342,24 +1341,6 @@ xfs_reflink_remap_prep(
 	if (ret < 0 || *len == 0)
 		goto out_unlock;
 
-	/*
-	 * If the dedupe data matches, chop off the partial EOF block
-	 * from the source file so we don't try to dedupe the partial
-	 * EOF block.
-	 */
-	if (remap_flags & REMAP_FILE_DEDUP) {
-		*len &= ~blkmask;
-	} else if (*len & blkmask) {
-		/*
-		 * The user is attempting to share a partial EOF block,
-		 * if it's inside the destination EOF then reject it.
-		 */
-		if (pos_out + *len < i_size_read(inode_out)) {
-			ret = -EINVAL;
-			goto out_unlock;
-		}
-	}
-
 	/* Attach dquots to dest inode before changing block map */
 	ret = xfs_qm_dqattach(dest);
 	if (ret)
