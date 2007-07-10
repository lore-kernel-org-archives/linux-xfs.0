Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 10 Jul 2007 13:24:36 -0700 (PDT)
Received: from e3.ny.us.ibm.com (e3.ny.us.ibm.com [32.97.182.143])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6AKOWbm003544
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2007 13:24:33 -0700
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6AJKiCi005902
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2007 15:20:44 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6AKORc3311456
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2007 16:24:27 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6AKORbq006488
	for <xfs@oss.sgi.com>; Tue, 10 Jul 2007 16:24:27 -0400
Date: Wed, 11 Jul 2007 01:54:41 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 6/7] ext4: support new modes in ext4
Message-ID: <20070710202441.GF8797@amitarora.in.ibm.com>
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

From: Amit Arora <aarora@in.ibm.com>
Support new values of mode in ext4.

This patch supports new mode values/flags in ext4. With this patch ext4
will be able to support FALLOC_ALLOCATE and FALLOC_RESV_SPACE modes. Supporting
FALLOC_DEALLOCATE and FALLOC_UNRESV_SPACE fallocate modes in ext4 is a work for
future.

Signed-off-by: Amit Arora <aarora@in.ibm.com>

Index: linux-2.6.22/fs/ext4/extents.c
===================================================================
--- linux-2.6.22.orig/fs/ext4/extents.c
+++ linux-2.6.22/fs/ext4/extents.c
@@ -2453,8 +2453,9 @@ int ext4_ext_writepage_trans_blocks(stru
 /*
  * preallocate space for a file. This implements ext4's fallocate inode
  * operation, which gets called from sys_fallocate system call.
- * Currently only FA_ALLOCATE mode is supported on extent based files.
- * We may have more modes supported in future - like FA_DEALLOCATE, which
+ * Currently only FALLOC_ALLOCATE  and FALLOC_RESV_SPACE modes are supported on
+ * extent based files.
+ * We may have more modes supported in future - like FALLOC_DEALLOCATE, which
  * tells fallocate to unallocate previously (pre)allocated blocks.
  * For block-mapped files, posix_fallocate should fall back to the method
  * of writing zeroes to the required new blocks (the same behavior which is
@@ -2475,7 +2476,8 @@ long ext4_fallocate(struct inode *inode,
 	 * currently supporting (pre)allocate mode for extent-based
 	 * files _only_
 	 */
-	if (mode != FA_ALLOCATE || !(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) ||
+		!(mode == FALLOC_ALLOCATE || mode == FALLOC_RESV_SPACE))
 		return -EOPNOTSUPP;
 
 	/* preallocation to directories is currently not supported */
@@ -2548,9 +2550,11 @@ retry:
 
 	/*
 	 * Time to update the file size.
-	 * Update only when preallocation was requested beyond the file size.
+	 * Update only when preallocation was requested beyond the file size
+	 * and when FALLOC_FL_KEEP_SIZE mode is not specified!
 	 */
-	if ((offset + len) > i_size_read(inode)) {
+	if (!(mode & FALLOC_FL_KEEP_SIZE) &&
+	    (offset + len) > i_size_read(inode)) {
 		if (ret > 0) {
 			/*
 			 * if no error, we assume preallocation succeeded
