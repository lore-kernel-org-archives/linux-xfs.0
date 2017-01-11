Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:35706 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937409AbdAKNjr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Jan 2017 08:39:47 -0500
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH] xfs_logprint: handle the log split of inode item correctly
Date: Wed, 11 Jan 2017 21:38:58 +0800
Message-ID: <1484141938-4195-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net

It is possible that the data fork or the attribute fork
of an inode will be splitted to the next log record, so
we need to check the count of available operations
in the log record and calculate the count of skipped
operations properly.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 logprint/log_misc.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index a0f1766..20f0f89 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -524,6 +524,7 @@ xlog_print_trans_inode(
     xfs_inode_log_format_t *f;
     int			   mode;
     int			   size;
+    int			   printed_ops;
 
     /*
      * print inode type header region
@@ -572,13 +573,6 @@ xlog_print_trans_inode(
     xlog_print_trans_inode_core(&dino);
     *ptr += xfs_log_dinode_size(dino.di_version);
 
-    if (*i == num_ops-1 && f->ilf_size == 3)  {
-	return 1;
-    }
-
-    /* does anything come next */
-    op_head = (xlog_op_header_t *)*ptr;
-
     switch (f->ilf_fields & (XFS_ILOG_DEV | XFS_ILOG_UUID)) {
     case XFS_ILOG_DEV:
 	printf(_("DEV inode: no extra region\n"));
@@ -595,7 +589,13 @@ xlog_print_trans_inode(
     ASSERT(f->ilf_size <= 4);
     ASSERT((f->ilf_size == 3) || (f->ilf_fields & XFS_ILOG_AFORK));
 
+    /* does anything come next */
+    printed_ops = 2;
+    op_head = (xlog_op_header_t *)*ptr;
+
     if (f->ilf_fields & XFS_ILOG_DFORK) {
+		if (*i == num_ops-1)
+		return f->ilf_size-printed_ops;
 	    (*i)++;
 	    xlog_print_op_header(op_head, *i, ptr);
 
@@ -618,11 +618,14 @@ xlog_print_trans_inode(
 
 	    *ptr += be32_to_cpu(op_head->oh_len);
 	    if (op_head->oh_flags & XLOG_CONTINUE_TRANS)
-		return 1;
+		return f->ilf_size-printed_ops;
 	    op_head = (xlog_op_header_t *)*ptr;
+		printed_ops++;
     }
 
     if (f->ilf_fields & XFS_ILOG_AFORK) {
+		if (*i == num_ops-1)
+		return f->ilf_size-printed_ops;
 	    (*i)++;
 	    xlog_print_op_header(op_head, *i, ptr);
 
@@ -644,7 +647,7 @@ xlog_print_trans_inode(
 	    }
 	    *ptr += be32_to_cpu(op_head->oh_len);
 	    if (op_head->oh_flags & XLOG_CONTINUE_TRANS)
-		return 1;
+		return f->ilf_size-printed_ops;
     }
 
     return 0;
-- 
2.5.0

