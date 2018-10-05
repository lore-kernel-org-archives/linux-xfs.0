Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:56014 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727625AbeJEHmg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Oct 2018 03:42:36 -0400
Subject: [PATCH 14/15] ocfs2: support partial clone range and dedupe range
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 04 Oct 2018 17:46:20 -0700
Message-ID: <153870038054.29072.6999468698657448422.stgit@magnolia>
In-Reply-To: <153870027422.29072.7433543674436957232.stgit@magnolia>
References: <153870027422.29072.7433543674436957232.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, ocfs2-devel@oss.oracle.com, sandeen@redhat.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Change the ocfs2 remap code to allow for returning partial results.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ocfs2/file.c         |   14 ++++----------
 fs/ocfs2/refcounttree.c |   35 ++++++++++++++++++++---------------
 fs/ocfs2/refcounttree.h |    4 ++--
 3 files changed, 26 insertions(+), 27 deletions(-)


diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 1ee6d3ecdac6..4562111259b4 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2534,11 +2534,8 @@ static s64 ocfs2_file_clone_range(struct file *file_in,
 				  u64 len,
 				  unsigned int flags)
 {
-	int ret;
-
-	ret = ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
-					len, false);
-	return ret < 0 ? ret : len;
+	return ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
+			len, flags);
 }
 
 static s64 ocfs2_file_dedupe_range(struct file *file_in,
@@ -2547,11 +2544,8 @@ static s64 ocfs2_file_dedupe_range(struct file *file_in,
 				   loff_t pos_out,
 				   u64 len)
 {
-	int ret;
-
-	ret = ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
-					len, true);
-	return ret < 0 ? ret : len;
+	return ocfs2_reflink_remap_range(file_in, pos_in, file_out, pos_out,
+			len, CLONERANGE_DEDUPE | CLONERANGE_SHORT);
 }
 
 const struct inode_operations ocfs2_file_iops = {
diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 02283c38b5a4..60be5c76db6d 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4499,7 +4499,7 @@ static int ocfs2_reflink_update_dest(struct inode *dest,
 }
 
 /* Remap the range pos_in:len in s_inode to pos_out:len in t_inode. */
-static int ocfs2_reflink_remap_extent(struct inode *s_inode,
+static s64 ocfs2_reflink_remap_extent(struct inode *s_inode,
 				      struct buffer_head *s_bh,
 				      loff_t pos_in,
 				      struct inode *t_inode,
@@ -4514,6 +4514,7 @@ static int ocfs2_reflink_remap_extent(struct inode *s_inode,
 	struct buffer_head *ref_root_bh = NULL;
 	struct ocfs2_refcount_tree *ref_tree;
 	struct ocfs2_super *osb;
+	s64 remapped = 0;
 	loff_t pstart, plen;
 	u32 p_cluster, num_clusters, slast, spos, tpos;
 	unsigned int ext_flags;
@@ -4597,18 +4598,20 @@ static int ocfs2_reflink_remap_extent(struct inode *s_inode,
 next_loop:
 		spos += num_clusters;
 		tpos += num_clusters;
+		remapped += ocfs2_clusters_to_bytes(t_inode->i_sb,
+				num_clusters);
 	}
 
-out:
-	return ret;
+	return remapped;
 out_unlock_refcount:
 	ocfs2_unlock_refcount_tree(osb, ref_tree, 1);
 	brelse(ref_root_bh);
-	return ret;
+out:
+	return remapped > 0 ? remapped : ret;
 }
 
 /* Set up refcount tree and remap s_inode to t_inode. */
-static int ocfs2_reflink_remap_blocks(struct inode *s_inode,
+static s64 ocfs2_reflink_remap_blocks(struct inode *s_inode,
 				      struct buffer_head *s_bh,
 				      loff_t pos_in,
 				      struct inode *t_inode,
@@ -4620,7 +4623,7 @@ static int ocfs2_reflink_remap_blocks(struct inode *s_inode,
 	struct ocfs2_super *osb;
 	struct ocfs2_dinode *dis;
 	struct ocfs2_dinode *dit;
-	int ret;
+	s64 ret;
 
 	osb = OCFS2_SB(s_inode->i_sb);
 	dis = (struct ocfs2_dinode *)s_bh->b_data;
@@ -4692,7 +4695,7 @@ static int ocfs2_reflink_remap_blocks(struct inode *s_inode,
 	/* Actually remap extents now. */
 	ret = ocfs2_reflink_remap_extent(s_inode, s_bh, pos_in, t_inode, t_bh,
 					 pos_out, len, &dealloc);
-	if (ret) {
+	if (ret < 0) {
 		mlog_errno(ret);
 		goto out;
 	}
@@ -4812,18 +4815,19 @@ static void ocfs2_reflink_inodes_unlock(struct inode *s_inode,
 }
 
 /* Link a range of blocks from one file to another. */
-int ocfs2_reflink_remap_range(struct file *file_in,
+s64 ocfs2_reflink_remap_range(struct file *file_in,
 			      loff_t pos_in,
 			      struct file *file_out,
 			      loff_t pos_out,
 			      u64 len,
-			      bool is_dedupe)
+			      unsigned int flags)
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
 	struct ocfs2_super *osb = OCFS2_SB(inode_in->i_sb);
 	struct buffer_head *in_bh = NULL, *out_bh = NULL;
 	bool same_inode = (inode_in == inode_out);
+	s64 remapped = 0;
 	ssize_t ret;
 
 	if (!ocfs2_refcount_tree(osb))
@@ -4843,7 +4847,7 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 		goto out_unlock;
 
 	ret = vfs_clone_file_prep(file_in, pos_in, file_out, pos_out,
-			&len, is_dedupe ? CLONERANGE_DEDUPE : 0);
+			&len, flags);
 	if (ret <= 0)
 		goto out_unlock;
 
@@ -4857,12 +4861,13 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 	truncate_inode_pages_range(&inode_out->i_data, pos_out,
 				   PAGE_ALIGN(pos_out + len) - 1);
 
-	ret = ocfs2_reflink_remap_blocks(inode_in, in_bh, pos_in, inode_out,
-					 out_bh, pos_out, len);
+	remapped = ocfs2_reflink_remap_blocks(inode_in, in_bh, pos_in,
+			inode_out, out_bh, pos_out, len);
 	up_write(&OCFS2_I(inode_in)->ip_alloc_sem);
 	if (!same_inode)
 		up_write(&OCFS2_I(inode_out)->ip_alloc_sem);
-	if (ret) {
+	if (remapped < 0) {
+		ret = remapped;
 		mlog_errno(ret);
 		goto out_unlock;
 	}
@@ -4881,9 +4886,9 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 	}
 
 	ocfs2_reflink_inodes_unlock(inode_in, in_bh, inode_out, out_bh);
-	return 0;
+	return remapped;
 
 out_unlock:
 	ocfs2_reflink_inodes_unlock(inode_in, in_bh, inode_out, out_bh);
-	return ret;
+	return remapped > 0 ? remapped : ret;
 }
diff --git a/fs/ocfs2/refcounttree.h b/fs/ocfs2/refcounttree.h
index 4af55bf4b35b..410a3145a06a 100644
--- a/fs/ocfs2/refcounttree.h
+++ b/fs/ocfs2/refcounttree.h
@@ -115,11 +115,11 @@ int ocfs2_reflink_ioctl(struct inode *inode,
 			const char __user *oldname,
 			const char __user *newname,
 			bool preserve);
-int ocfs2_reflink_remap_range(struct file *file_in,
+s64 ocfs2_reflink_remap_range(struct file *file_in,
 			      loff_t pos_in,
 			      struct file *file_out,
 			      loff_t pos_out,
 			      u64 len,
-			      bool is_dedupe);
+			      unsigned int flags);
 
 #endif /* OCFS2_REFCOUNTTREE_H */
