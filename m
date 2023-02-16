Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4678FC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbjBPUxU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjBPUxT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:53:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961F14CCBA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:53:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 20DF4B826BA
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:53:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5673C433EF;
        Thu, 16 Feb 2023 20:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580795;
        bh=8bd5QUn7OUwftD7iCR0MPNVYTOHYlzfGOWShMhwqQzY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=vAEi/dF2fW7EhgP/bTgF9q9oKhxLiSqpSjUZkVzf2V1J2Mk0hmzgErVpLtNZEsGnz
         8X1tnAYffM7Aa3gT+LmY4WNeo+8Yt8nE6/xZexYKROUhAQOWbIpyJpHJqPqsrYRlRF
         D9wbUsW1VOFLyoE0W2+YeTnngdsOFayM6UVHYiGwfZ3nWoNyVEyUOSCYS4U0CSoyWR
         lkc5NZH52Die1zCYBe5crohM1CZqqkO8ay3GRaTFUkzhtJ4TxX8afQpTXTCZ12og9f
         uJdc1SLxmarfI1/OQBoq47iL1IQBjkDKjR3d0HnrL+QAde4OCj0SUCcTl2eAZyUWvf
         UDzGQVDllhbvA==
Date:   Thu, 16 Feb 2023 12:53:15 -0800
Subject: [PATCH 2/3] xfs: rename xfs_parent_ptr
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657876266.3475586.7183544100362573325.stgit@magnolia>
In-Reply-To: <167657876236.3475586.14505209064881107848.stgit@magnolia>
References: <167657876236.3475586.14505209064881107848.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Change the name to xfs_getparents_rec so that the name matches the head
structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h    |   22 +++++++++++-----------
 fs/xfs/xfs_ioctl.c        |    4 ++--
 fs/xfs/xfs_ondisk.h       |    2 +-
 fs/xfs/xfs_parent_utils.c |   16 ++++++++--------
 4 files changed, 22 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 2a23c010a0a0..ec6fdf78fde7 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -768,12 +768,12 @@ struct xfs_scrub_metadata {
 					 XFS_GETPARENTS_OFLAG_DONE)
 
 /* Get an inode parent pointer through ioctl */
-struct xfs_parent_ptr {
-	__u64		xpp_ino;			/* Inode */
-	__u32		xpp_gen;			/* Inode generation */
-	__u32		xpp_rsvd;			/* Reserved */
-	__u64		xpp_rsvd2;			/* Reserved */
-	__u8		xpp_name[XFS_GETPARENTS_MAXNAMELEN];	/* File name */
+struct xfs_getparents_rec {
+	__u64		gpr_ino;			/* Inode */
+	__u32		gpr_gen;			/* Inode generation */
+	__u32		gpr_rsvd;			/* Reserved */
+	__u64		gpr_rsvd2;			/* Reserved */
+	__u8		gpr_name[XFS_GETPARENTS_MAXNAMELEN];	/* File name */
 };
 
 /* Iterate through an inodes parent pointers */
@@ -804,21 +804,21 @@ struct xfs_getparents {
 	__u64				gp_reserved2[6];
 
 	/*
-	 * An array of struct xfs_parent_ptr follows the header
+	 * An array of struct xfs_getparents_rec follows the header
 	 * information. Use xfs_getparents_rec() to access the
 	 * parent pointer array entries.
 	 */
-	struct xfs_parent_ptr		gp_parents[];
+	struct xfs_getparents_rec		gp_parents[];
 };
 
 static inline size_t
 xfs_getparents_sizeof(int nr_ptrs)
 {
 	return sizeof(struct xfs_getparents) +
-	       (nr_ptrs * sizeof(struct xfs_parent_ptr));
+	       (nr_ptrs * sizeof(struct xfs_getparents_rec));
 }
 
-static inline struct xfs_parent_ptr*
+static inline struct xfs_getparents_rec*
 xfs_getparents_rec(
 	struct xfs_getparents	*info,
 	unsigned int		idx)
@@ -871,7 +871,7 @@ xfs_getparents_rec(
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
-#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_parent_ptr)
+#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_getparents_rec)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 2687e9965310..b3154830ef91 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1681,10 +1681,10 @@ xfs_ioc_scrub_metadata(
  * IOCTL routine to get the parent pointers of an inode and return it to user
  * space.  Caller must pass a buffer space containing a struct xfs_getparents,
  * followed by a region large enough to contain an array of struct
- * xfs_parent_ptr of a size specified in gp_ptrs_size.  If the inode contains
+ * xfs_getparents_rec of a size specified in gp_ptrs_size.  If the inode contains
  * more parent pointers than can fit in the buffer space, caller may re-call
  * the function using the returned gp_cursor to resume iteration.  The
- * number of xfs_parent_ptr returned will be stored in gp_ptrs_used.
+ * number of xfs_getparents_rec returned will be stored in gp_ptrs_used.
  *
  * Returns 0 on success or non-zero on failure
  */
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index ba85dec53b0f..38d8113b832d 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -157,7 +157,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
 
 	/* parent pointer ioctls */
-	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_ptr,            280);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_rec,	280);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents,		104);
 
 	/*
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
index d10d04a8a3c4..801223d011e7 100644
--- a/fs/xfs/xfs_parent_utils.c
+++ b/fs/xfs/xfs_parent_utils.c
@@ -40,7 +40,7 @@ xfs_getparent_listent(
 {
 	struct xfs_getparent_ctx	*gp;
 	struct xfs_getparents		*ppi;
-	struct xfs_parent_ptr		*pptr;
+	struct xfs_getparents_rec	*pptr;
 	struct xfs_parent_name_irec	*irec;
 	struct xfs_mount		*mp = context->dp->i_mount;
 
@@ -81,14 +81,14 @@ xfs_getparent_listent(
 
 	/* Format the parent pointer directly into the caller buffer. */
 	pptr = &ppi->gp_parents[ppi->gp_ptrs_used++];
-	pptr->xpp_ino = irec->p_ino;
-	pptr->xpp_gen = irec->p_gen;
-	pptr->xpp_rsvd2 = 0;
-	pptr->xpp_rsvd = 0;
+	pptr->gpr_ino = irec->p_ino;
+	pptr->gpr_gen = irec->p_gen;
+	pptr->gpr_rsvd2 = 0;
+	pptr->gpr_rsvd = 0;
 
-	memcpy(pptr->xpp_name, irec->p_name, irec->p_namelen);
-	memset(pptr->xpp_name + irec->p_namelen, 0,
-			sizeof(pptr->xpp_name) - irec->p_namelen);
+	memcpy(pptr->gpr_name, irec->p_name, irec->p_namelen);
+	memset(pptr->gpr_name + irec->p_namelen, 0,
+			sizeof(pptr->gpr_name) - irec->p_namelen);
 }
 
 /* Retrieve the parent pointers for a given inode. */

