Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 25 Jun 2007 06:50:47 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5PDogdo010636
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 06:50:43 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5PDohsb001898
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 09:50:43 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5PDohm4255808
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 07:50:43 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5PDogcw019100
	for <xfs@oss.sgi.com>; Mon, 25 Jun 2007 07:50:43 -0600
Date: Mon, 25 Jun 2007 19:20:51 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: [PATCH 7/7][TAKE5] ext4: support new modes
Message-ID: <20070625135051.GH1951@amitarora.in.ibm.com>
References: <20070510115620.GB21400@amitarora.in.ibm.com> <20070510223950.GD86004887@sgi.com> <20070511110301.GB28425@in.ibm.com> <20070512080157.GF85884050@sgi.com> <20070612061652.GA6320@amitarora.in.ibm.com> <20070613235217.GS86004887@sgi.com> <20070614091458.GH5181@schatzie.adilger.int> <20070614120413.GD86004887@sgi.com> <20070614193347.GN5181@schatzie.adilger.int> <20070625132810.GA1951@amitarora.in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070625132810.GA1951@amitarora.in.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Cc: David Chinner <dgc@sgi.com>, Andreas Dilger <adilger@clusterfs.com>, suparna@in.ibm.com, cmm@us.ibm.com, xfs@oss.sgi.com

Support new values of mode in ext4.

This patch supports new mode values/flags in ext4. With this patch ext4
will be able to support FA_ALLOCATE and FA_RESV_SPACE modes. Supporting
FA_DEALLOCATE and FA_UNRESV_SPACE fallocate modes in ext4 is a work for
future.

Signed-off-by: Amit Arora <aarora@in.ibm.com>

Index: linux-2.6.22-rc4/fs/ext4/extents.c
===================================================================
--- linux-2.6.22-rc4.orig/fs/ext4/extents.c
+++ linux-2.6.22-rc4/fs/ext4/extents.c
@@ -2477,7 +2477,8 @@ int ext4_ext_writepage_trans_blocks(stru
 /*
  * preallocate space for a file. This implements ext4's fallocate inode
  * operation, which gets called from sys_fallocate system call.
- * Currently only FA_ALLOCATE mode is supported on extent based files.
+ * Currently only FA_ALLOCATE  and FA_RESV_SPACE modes are supported on
+ * extent based files.
  * We may have more modes supported in future - like FA_DEALLOCATE, which
  * tells fallocate to unallocate previously (pre)allocated blocks.
  * For block-mapped files, posix_fallocate should fall back to the method
@@ -2499,7 +2500,8 @@ long ext4_fallocate(struct inode *inode,
 	 * currently supporting (pre)allocate mode for extent-based
 	 * files _only_
 	 */
-	if (mode != FA_ALLOCATE || !(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL))
+	if (!(EXT4_I(inode)->i_flags & EXT4_EXTENTS_FL) ||
+		!(mode == FA_ALLOCATE || mode == FA_RESV_SPACE))
 		return -EOPNOTSUPP;
 
 	/* preallocation to directories is currently not supported */
@@ -2572,9 +2574,10 @@ retry:
 
 	/*
 	 * Time to update the file size.
-	 * Update only when preallocation was requested beyond the file size.
+	 * Update only when preallocation was requested beyond the file size
+	 * and when FA_FL_KEEP_SIZE mode is not specified!
 	 */
-	if ((offset + len) > i_size_read(inode)) {
+	if (!(mode & FA_FL_KEEP_SIZE) && (offset + len) > i_size_read(inode)) {
 		if (ret > 0) {
 			/*
 			 * if no error, we assume preallocation succeeded
