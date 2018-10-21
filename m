Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:41090 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727641AbeJVAa4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 21 Oct 2018 20:30:56 -0400
Subject: [PATCH 08/28] vfs: rename clone_verify_area to remap_verify_area
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Sun, 21 Oct 2018 09:15:58 -0700
Message-ID: <154013855860.29026.18117400241937143769.stgit@magnolia>
In-Reply-To: <154013850285.29026.16168387526580596209.stgit@magnolia>
References: <154013850285.29026.16168387526580596209.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com

From: Darrick J. Wong <darrick.wong@oracle.com>

Since we use clone_verify_area for both clone and dedupe range checks,
rename the function to make it clear that it's for both.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/read_write.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index aca75a97a695..734c5661fb69 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1686,7 +1686,7 @@ SYSCALL_DEFINE6(copy_file_range, int, fd_in, loff_t __user *, off_in,
 	return ret;
 }
 
-static int clone_verify_area(struct file *file, loff_t pos, u64 len, bool write)
+static int remap_verify_area(struct file *file, loff_t pos, u64 len, bool write)
 {
 	struct inode *inode = file_inode(file);
 
@@ -1852,11 +1852,11 @@ int do_clone_file_range(struct file *file_in, loff_t pos_in,
 	if (!file_in->f_op->clone_file_range)
 		return -EOPNOTSUPP;
 
-	ret = clone_verify_area(file_in, pos_in, len, false);
+	ret = remap_verify_area(file_in, pos_in, len, false);
 	if (ret)
 		return ret;
 
-	ret = clone_verify_area(file_out, pos_out, len, true);
+	ret = remap_verify_area(file_out, pos_out, len, true);
 	if (ret)
 		return ret;
 
@@ -1989,7 +1989,7 @@ int vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 	if (ret)
 		return ret;
 
-	ret = clone_verify_area(dst_file, dst_pos, len, true);
+	ret = remap_verify_area(dst_file, dst_pos, len, true);
 	if (ret < 0)
 		goto out_drop_write;
 
@@ -2051,7 +2051,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 	if (!S_ISREG(src->i_mode))
 		goto out;
 
-	ret = clone_verify_area(file, off, len, false);
+	ret = remap_verify_area(file, off, len, false);
 	if (ret < 0)
 		goto out;
 	ret = 0;
