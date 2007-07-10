Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jul 2007 13:21:13 -0700 (PDT)
Received: from e2.ny.us.ibm.com (e2.ny.us.ibm.com [32.97.182.142])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6AKL9bm001820
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2007 13:21:10 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6AKLBBs019329
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2007 16:21:11 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6AKLBiW543634
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2007 16:21:11 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6AKLB6M027958
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2007 16:21:11 -0400
Date: Wed, 11 Jul 2007 01:51:24 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 3/7] support new modes in fallocate
Message-ID: <20070710202124.GC8797@amitarora.in.ibm.com>
References: <20070710201200.GA10255@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710201200.GA10255@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: xfs@oss.sgi.com

From:  Amit Arora <aarora@in.ibm.com>
Implement new flags and values for mode argument.

This patch implements the new flags and values for the "mode" argument
of the fallocate system call. It is based on the discussion between
Andreas Dilger and David Chinner on the man page proposed (by the later)
on fallocate.

Signed-off-by: Amit Arora <aarora@in.ibm.com>

Index: linux-2.6.22/include/linux/fs.h
===================================================================
--- linux-2.6.22.orig/include/linux/fs.h
+++ linux-2.6.22/include/linux/fs.h
@@ -267,15 +267,17 @@ extern int dir_notify_enable;
 #define SYNC_FILE_RANGE_WAIT_AFTER	4
 
 /*
- * sys_fallocate modes
- * Currently sys_fallocate supports two modes:
- * FA_ALLOCATE  : This is the preallocate mode, using which an application/user
- *		  may request (pre)allocation of blocks.
- * FA_DEALLOCATE: This is the deallocate mode, which can be used to free
- *		  the preallocated blocks.
+ * sys_fallocate mode flags and values
  */
-#define FA_ALLOCATE	0x1
-#define FA_DEALLOCATE	0x2
+#define FALLOC_FL_DEALLOC	0x01 /* default is allocate */
+#define FALLOC_FL_KEEP_SIZE	0x02 /* default is extend/shrink size */
+#define FALLOC_FL_DEL_DATA	0x04 /* default is keep written data on DEALLOC */
+
+#define FALLOC_ALLOCATE 	0
+#define FALLOC_DEALLOCATE	FALLOC_FL_DEALLOC
+#define FALLOC_RESV_SPACE	FALLOC_FL_KEEP_SIZE
+#define FALLOC_UNRESV_SPACE	(FALLOC_FL_DEALLOC | FALLOC_FL_KEEP_SIZE | \
+				 FALLOC_FL_DEL_DATA)
 
 #ifdef __KERNEL__
 
Index: linux-2.6.22/fs/open.c
===================================================================
--- linux-2.6.22.orig/fs/open.c
+++ linux-2.6.22/fs/open.c
@@ -356,23 +356,26 @@ asmlinkage long sys_ftruncate64(unsigned
  * sys_fallocate - preallocate blocks or free preallocated blocks
  * @fd: the file descriptor
  * @mode: mode specifies if fallocate should preallocate blocks OR free
- *	  (unallocate) preallocated blocks. Currently only FA_ALLOCATE and
- *	  FA_DEALLOCATE modes are supported.
+ *	  (unallocate) preallocated blocks.
  * @offset: The offset within file, from where (un)allocation is being
  *	    requested. It should not have a negative value.
  * @len: The amount (in bytes) of space to be (un)allocated, from the offset.
  *
  * This system call, depending on the mode, preallocates or unallocates blocks
  * for a file. The range of blocks depends on the value of offset and len
- * arguments provided by the user/application. For FA_ALLOCATE mode, if this
+ * arguments provided by the user/application. For FALLOC_ALLOCATE and
+ * FALLOC_RESV_SPACE modes, if the sys_fallocate()
  * system call succeeds, subsequent writes to the file in the given range
  * (specified by offset & len) should not fail - even if the file system
  * later becomes full. Hence the preallocation done is persistent (valid
- * even after reopen of the file and remount/reboot).
+ * even after reopen of the file and remount/reboot). If FALLOC_RESV_SPACE mode
+ * is passed, the file size will not be changed even if the preallocation
+ * is beyond EOF.
  *
  * It is expected that the ->fallocate() inode operation implemented by the
  * individual file systems will update the file size and/or ctime/mtime
- * depending on the mode and also on the success of the operation.
+ * depending on the mode (change is visible to user or not - say file size)
+ * and obviously, on the success of the operation.
  *
  * Note: Incase the file system does not support preallocation,
  * posix_fallocate() should fall back to the library implementation (i.e.
@@ -398,7 +401,8 @@ asmlinkage long sys_fallocate(int fd, in
 
 	/* Return error if mode is not supported */
 	ret = -EOPNOTSUPP;
-	if (mode != FA_ALLOCATE && mode != FA_DEALLOCATE)
+	if (!(mode == FALLOC_ALLOCATE || mode == FALLOC_DEALLOCATE ||
+		mode == FALLOC_RESV_SPACE || mode == FALLOC_UNRESV_SPACE))
 		goto out;
 
 	ret = -EBADF;
