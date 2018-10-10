Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:59896 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbeJJHeA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 10 Oct 2018 03:34:00 -0400
Subject: [PATCH 21/25] ocfs2: truncate page cache for clone destination file
 before remapping
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 09 Oct 2018 17:14:24 -0700
Message-ID: <153913046462.32295.3245494254410288586.stgit@magnolia>
In-Reply-To: <153913023835.32295.13962696655740190941.stgit@magnolia>
References: <153913023835.32295.13962696655740190941.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

When cloning blocks into another file, truncate the page cache before we
start remapping blocks so that concurrent reads wait for us to finish.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/refcounttree.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)


diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index a3df118bf3b9..851ba3ae7ce8 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4869,14 +4869,12 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 		down_write_nested(&OCFS2_I(inode_out)->ip_alloc_sem,
 				  SINGLE_DEPTH_NESTING);
 
-	ret = ocfs2_reflink_remap_blocks(inode_in, in_bh, pos_in, inode_out,
-					 out_bh, pos_out, len);
-
 	/* Zap any page cache for the destination file's range. */
-	if (!ret)
-		truncate_inode_pages_range(&inode_out->i_data, pos_out,
-					   PAGE_ALIGN(pos_out + len) - 1);
+	truncate_inode_pages_range(&inode_out->i_data, pos_out,
+				   PAGE_ALIGN(pos_out + len) - 1);
 
+	ret = ocfs2_reflink_remap_blocks(inode_in, in_bh, pos_in, inode_out,
+					 out_bh, pos_out, len);
 	up_write(&OCFS2_I(inode_in)->ip_alloc_sem);
 	if (!same_inode)
 		up_write(&OCFS2_I(inode_out)->ip_alloc_sem);
