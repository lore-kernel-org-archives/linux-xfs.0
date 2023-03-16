Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30BC0C6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:20:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjCPTUv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:20:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbjCPTUu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:20:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547ABCC18
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:20:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E21A6620E3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41CDBC433D2;
        Thu, 16 Mar 2023 19:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994443;
        bh=QwvYjIGjfxz91bvvzLyVPjPc62/H1q0R+HeilO2X8rw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=SaepbXRPChq4FW7xr3UXhRvXAyjWBd6cepNCCn2s+NC5mhrsUW4xtm4aYPbSJR/ZS
         5gXnSNb4UdOlFoq+CWgyB0APP+ML8mI2DsnsKLsLn3j8vsipWcHN43nVwFErATxEqA
         1a7ee0GDHN47eSYCkWdZkvgpsQS9zvsQ9Q0PjSYbb0DNIZKbXT+kIpuxBRYlj7v3D0
         Xu+icnder8YZCbLXPvxi0Bq+5XAn/1OvQI7Su8UNCOxqX/H2L1mVjQLFlxXoDJOvRl
         0zXcorzE6Mqpe8OXL0Fo0mi5WNPWQW5ic5yroTdacXKPCRZ4UUQbZMXTPjy1P/1x1/
         GiqUZnxK+JEUg==
Date:   Thu, 16 Mar 2023 12:20:42 -0700
Subject: [PATCH 4/7] xfs: fix GETPARENTS ioctl
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899413984.15157.14162458611662578891.stgit@frogsfrogsfrogs>
In-Reply-To: <167899413920.15157.15106630627506949304.stgit@frogsfrogsfrogs>
References: <167899413920.15157.15106630627506949304.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix a few remaining issues with this ioctl:

The ioctl encodes the size of the parent rec, not the parent head.

The parent rec should say that it returns a null terminated filename.

The parent head encodes the buffer size, not the size of the parent
record array, but the field name and documentation doesn't make this
clear.

The getparents sizeof function is pointless and wrong.

Get rid of the last vestiges of the non-flex-array definitions.

The rec address should take an unsigned argument

Whitespace damage

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h    |   30 +++++++++++-------------------
 fs/xfs/xfs_ioctl.c        |   15 +++++++--------
 fs/xfs/xfs_parent_utils.c |    3 +--
 3 files changed, 19 insertions(+), 29 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index c8edc7c099e8..d7e061089e75 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -752,8 +752,6 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
-#define XFS_GETPARENTS_MAXNAMELEN	256
-
 /* return parents of the handle, not the open fd */
 #define XFS_GETPARENTS_IFLAG_HANDLE	(1U << 0)
 
@@ -769,11 +767,11 @@ struct xfs_scrub_metadata {
 
 /* Get an inode parent pointer through ioctl */
 struct xfs_getparents_rec {
-	__u64		gpr_ino;			/* Inode */
-	__u32		gpr_gen;			/* Inode generation */
-	__u32		gpr_diroffset;			/* Directory offset */
-	__u64		gpr_rsvd;			/* Reserved */
-	__u8		gpr_name[];			/* File name */
+	__u64		gpr_ino;	/* Inode number */
+	__u32		gpr_gen;	/* Inode generation */
+	__u32		gpr_diroffset;	/* Directory offset */
+	__u64		gpr_rsvd;	/* Reserved */
+	__u8		gpr_name[];	/* File name and null terminator */
 };
 
 /* Iterate through an inodes parent pointers */
@@ -794,8 +792,8 @@ struct xfs_getparents {
 	/* Must be set to zero */
 	__u32				gp_reserved;
 
-	/* size of the trailing buffer in bytes */
-	__u32				gp_ptrs_size;
+	/* Size of the buffer in bytes, including this header */
+	__u32				gp_bufsize;
 
 	/* # of entries filled in (output) */
 	__u32				gp_count;
@@ -807,19 +805,13 @@ struct xfs_getparents {
 	__u32				gp_offsets[];
 };
 
-static inline size_t
-xfs_getparents_sizeof(int nr_ptrs)
-{
-	return sizeof(struct xfs_getparents) +
-	       (nr_ptrs * sizeof(struct xfs_getparents_rec));
-}
-
 static inline struct xfs_getparents_rec*
 xfs_getparents_rec(
 	struct xfs_getparents	*info,
-	int			idx)
+	unsigned int		idx)
 {
-	return (struct xfs_getparents_rec *)((char *)info + info->gp_offsets[idx]);
+	return (struct xfs_getparents_rec *)((char *)info +
+					     info->gp_offsets[idx]);
 }
 
 /*
@@ -867,7 +859,7 @@ xfs_getparents_rec(
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
-#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_getparents_rec)
+#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_getparents)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 04123ab41684..f265e28d0611 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1681,10 +1681,10 @@ xfs_ioc_scrub_metadata(
  * IOCTL routine to get the parent pointers of an inode and return it to user
  * space.  Caller must pass a buffer space containing a struct xfs_getparents,
  * followed by a region large enough to contain an array of struct
- * xfs_getparents_rec of a size specified in gp_ptrs_size.  If the inode contains
+ * xfs_getparents_rec of a size specified in gp_bufsize.  If the inode contains
  * more parent pointers than can fit in the buffer space, caller may re-call
  * the function using the returned gp_cursor to resume iteration.  The
- * number of xfs_getparents_rec returned will be stored in gp_ptrs_count.
+ * number of xfs_getparents_rec returned will be stored in gp_count.
  *
  * Returns 0 on success or non-zero on failure
  */
@@ -1699,7 +1699,7 @@ xfs_ioc_get_parent_pointer(
 	struct xfs_inode		*call_ip = file_ip;
 	struct xfs_mount		*mp = file_ip->i_mount;
 	void				__user *o_pptr;
-	struct xfs_getparents_rec		*i_pptr;
+	struct xfs_getparents_rec	*i_pptr;
 	unsigned int			bytes;
 
 	if (!capable(CAP_SYS_ADMIN))
@@ -1718,11 +1718,11 @@ xfs_ioc_get_parent_pointer(
 	}
 
 	/* Check size of buffer requested by user */
-	if (ppi->gp_ptrs_size > XFS_XATTR_LIST_MAX) {
+	if (ppi->gp_bufsize > XFS_XATTR_LIST_MAX) {
 		error = -ENOMEM;
 		goto out;
 	}
-	if (ppi->gp_ptrs_size < sizeof(struct xfs_getparents)) {
+	if (ppi->gp_bufsize < sizeof(struct xfs_getparents)) {
 		error = -EINVAL;
 		goto out;
 	}
@@ -1737,8 +1737,7 @@ xfs_ioc_get_parent_pointer(
 	 * Now that we know how big the trailing buffer is, expand
 	 * our kernel xfs_getparents to be the same size
 	 */
-	ppi = kvrealloc(ppi, sizeof(struct xfs_getparents),
-			xfs_getparents_sizeof(ppi->gp_ptrs_size),
+	ppi = kvrealloc(ppi, sizeof(struct xfs_getparents), ppi->gp_bufsize,
 			GFP_KERNEL | __GFP_ZERO);
 	if (!ppi)
 		return -ENOMEM;
@@ -1794,7 +1793,7 @@ xfs_ioc_get_parent_pointer(
 	/* Copy the parent pointer records back to the user. */
 	o_pptr = (__user char*)arg + ppi->gp_offsets[ppi->gp_count - 1];
 	i_pptr = xfs_getparents_rec(ppi, ppi->gp_count - 1);
-	bytes = ((char *)ppi + ppi->gp_ptrs_size) - (char *)i_pptr;
+	bytes = ((char *)ppi + ppi->gp_bufsize) - (char *)i_pptr;
 	error = copy_to_user(o_pptr, i_pptr, bytes);
 	if (error) {
 		error = -EFAULT;
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
index 8aff31ed9082..059454c43934 100644
--- a/fs/xfs/xfs_parent_utils.c
+++ b/fs/xfs/xfs_parent_utils.c
@@ -115,7 +115,7 @@ xfs_getparent_pointers(
 	gp->context.dp = ip;
 	gp->context.resynch = 1;
 	gp->context.put_listent = xfs_getparent_listent;
-	gp->context.bufsize = round_down(ppi->gp_ptrs_size, sizeof(uint32_t));
+	gp->context.bufsize = round_down(ppi->gp_bufsize, sizeof(uint32_t));
 	gp->context.firstu = gp->context.bufsize;
 
 	/* Copy the cursor provided by caller */
@@ -149,4 +149,3 @@ xfs_getparent_pointers(
 	kfree(gp);
 	return error;
 }
-

