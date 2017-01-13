Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:17092 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751553AbdAMLFd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 13 Jan 2017 06:05:33 -0500
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH v2] xfs_logprint: handle log operation split of inode item correctly
Date: Fri, 13 Jan 2017 19:05:30 +0800
Message-ID: <1484305530-19129-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net, bfoster@redhat.com

If the data/attr fork log operations of an inode log item are splitted to
the next log record, xfs_logprint doesn't check the remaining log operations
in current log record and still tries to print these log operations which
don't exist in the log record. The content of these log operations will be
incorrect, or worse xfs_logprint will trigger a segment-fault and exit.

xfs_logprint also doesn't calculate the count of the splitted log operations
correctly. It just returns 1 when the current log operation is splitted to
the next log record. It needs to consider the log operations behind.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 logprint/log_misc.c | 28 +++++++++++++++++-----------
 1 file changed, 17 insertions(+), 11 deletions(-)

v2:
- rewrite the commit message to clarify the patch
- use "skip_count" suggested by Brian Foster
- fix the indentation

v1: http://www.spinics.net/lists/linux-xfs/msg03430.html

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index a0f1766..4fa0ce1 100644
--- a/logprint/log_misc.c
+++ b/logprint/log_misc.c
@@ -524,6 +524,7 @@ xlog_print_trans_inode(
     xfs_inode_log_format_t *f;
     int			   mode;
     int			   size;
+    int			   skip_count;
 
     /*
      * print inode type header region
@@ -555,15 +556,17 @@ xlog_print_trans_inode(
 	return f->ilf_size;
     }
 
+    skip_count = f->ilf_size-1;
+
     if (*i >= num_ops)			/* end of LR */
-	    return f->ilf_size-1;
+	    return skip_count;
 
     /* core inode comes 2nd */
     op_head = (xlog_op_header_t *)*ptr;
     xlog_print_op_header(op_head, *i, ptr);
 
     if (op_head->oh_flags & XLOG_CONTINUE_TRANS)  {
-	return f->ilf_size-1;
+        return skip_count;
     }
 
     memmove(&dino, *ptr, sizeof(dino));
@@ -571,13 +574,7 @@ xlog_print_trans_inode(
     size = (int)dino.di_size;
     xlog_print_trans_inode_core(&dino);
     *ptr += xfs_log_dinode_size(dino.di_version);
-
-    if (*i == num_ops-1 && f->ilf_size == 3)  {
-	return 1;
-    }
-
-    /* does anything come next */
-    op_head = (xlog_op_header_t *)*ptr;
+    skip_count--;
 
     switch (f->ilf_fields & (XFS_ILOG_DEV | XFS_ILOG_UUID)) {
     case XFS_ILOG_DEV:
@@ -595,7 +592,12 @@ xlog_print_trans_inode(
     ASSERT(f->ilf_size <= 4);
     ASSERT((f->ilf_size == 3) || (f->ilf_fields & XFS_ILOG_AFORK));
 
+    /* does anything come next */
+    op_head = (xlog_op_header_t *)*ptr;
+
     if (f->ilf_fields & XFS_ILOG_DFORK) {
+	    if (*i == num_ops-1)
+	        return skip_count;
 	    (*i)++;
 	    xlog_print_op_header(op_head, *i, ptr);
 
@@ -618,11 +620,14 @@ xlog_print_trans_inode(
 
 	    *ptr += be32_to_cpu(op_head->oh_len);
 	    if (op_head->oh_flags & XLOG_CONTINUE_TRANS)
-		return 1;
+	        return skip_count;
 	    op_head = (xlog_op_header_t *)*ptr;
+	    skip_count--;
     }
 
     if (f->ilf_fields & XFS_ILOG_AFORK) {
+	    if (*i == num_ops-1)
+	        return skip_count;
 	    (*i)++;
 	    xlog_print_op_header(op_head, *i, ptr);
 
@@ -644,7 +649,8 @@ xlog_print_trans_inode(
 	    }
 	    *ptr += be32_to_cpu(op_head->oh_len);
 	    if (op_head->oh_flags & XLOG_CONTINUE_TRANS)
-		return 1;
+	        return skip_count;
+	    skip_count--;
     }
 
     return 0;
-- 
2.5.0

