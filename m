Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:14420 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752629AbdASNdl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 19 Jan 2017 08:33:41 -0500
From: Hou Tao <houtao1@huawei.com>
Subject: [PATCH v3] xfs_logprint: handle log operation split of inode item correctly
Date: Thu, 19 Jan 2017 21:32:47 +0800
Message-ID: <1484832767-39865-1-git-send-email-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net, bfoster@redhat.com

If an inode log item has 4 log operations, and the 4th operation
(attr fork op) is splitted to the next log record due to the size
limitation of log record, xfs_logprint doesn't check whether or not
the 4th operation is in the current log record and print invalid data.

xfs_logprint also needs to calculate the count of splitted log
operations correctly instead of just returning 1.

The following is the output before patch applied:
============================================================================
cycle: 120  version: 2      lsn: 120,11014  tail_lsn: 120,427
length of Log Record: 32256 prev offset: 10984      num ops: 243
......
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: 2db4353b  len: 0  clientid: TRANS  flags: START
......
----------------------------------------------------------------------------
Oper (240): tid: 2db4353b  len: 56  clientid: TRANS  flags: none
INODE: #regs: 4   ino: 0x200a4bf  flags: 0x45   dsize: 64
        blkno: 10506832  len: 16  boff: 7936
Oper (241): tid: 2db4353b  len: 96  clientid: TRANS  flags: none
INODE CORE
......
Oper (242): tid: 2db4353b  len: 64  clientid: TRANS  flags: none
EXTENTS inode data
Oper (243): tid: 150000  len: 83886080  clientid: ERROR  flags: none
LOCAL attr data
============================================================================
cycle: 120  version: 2      lsn: 120,11078  tail_lsn: 120,427
length of Log Record: 3584  prev offset: 11014      num ops: 44
......
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: 2db4353b  len: 52  clientid: TRANS  flags: none
----------------------------------------------------------------------------
Oper (1): tid: 2db4353b  len: 56  clientid: TRANS  flags: none
INODE: #regs: 3   ino: 0x100047b  flags: 0x5   dsize: 64
......
----------------------------------------------------------------------------

The following is the output after patch applied:
============================================================================
cycle: 120	version: 2		lsn: 120,11014	tail_lsn: 120,427
length of Log Record: 32256	prev offset: 10984		num ops: 243
......
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: 2db4353b  len: 0  clientid: TRANS  flags: START
......
----------------------------------------------------------------------------
Oper (240): tid: 2db4353b  len: 56  clientid: TRANS  flags: none
INODE: #regs: 4   ino: 0x200a4bf  flags: 0x45   dsize: 64
        blkno: 10506832  len: 16  boff: 7936
Oper (241): tid: 2db4353b  len: 96  clientid: TRANS  flags: none
INODE CORE
......
Oper (242): tid: 2db4353b  len: 64  clientid: TRANS  flags: none
EXTENTS inode data
============================================================================
cycle: 120	version: 2		lsn: 120,11078	tail_lsn: 120,427
length of Log Record: 3584	prev offset: 11014		num ops: 44
......
h_size: 32768
----------------------------------------------------------------------------
Oper (0): tid: 2db4353b  len: 52  clientid: TRANS  flags: none
Left over region from split log item
----------------------------------------------------------------------------
Oper (1): tid: 2db4353b  len: 56  clientid: TRANS  flags: none
INODE: #regs: 3   ino: 0x100047b  flags: 0x5   dsize: 64
......
----------------------------------------------------------------------------

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
 logprint/log_misc.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

v3:
- update commit log description as suggested by Brian Foster
- add ASSERT(skip_count == 0) as suggested by Brian Foster

v2: https://www.spinics.net/lists/linux-xfs/msg03500.html
- rewrite the commit message to clarify the patch
- use "skip_count" suggested by Brian Foster
- fix the indentation

v1: http://www.spinics.net/lists/linux-xfs/msg03430.html

diff --git a/logprint/log_misc.c b/logprint/log_misc.c
index a0f1766..0dfcfd1 100644
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
 
@@ -644,9 +649,12 @@ xlog_print_trans_inode(
 	    }
 	    *ptr += be32_to_cpu(op_head->oh_len);
 	    if (op_head->oh_flags & XLOG_CONTINUE_TRANS)
-		return 1;
+	        return skip_count;
+	    skip_count--;
     }
 
+    ASSERT(skip_count == 0);
+
     return 0;
 }	/* xlog_print_trans_inode */
 
-- 
2.5.0

