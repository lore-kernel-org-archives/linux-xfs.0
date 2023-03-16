Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C337C7618A
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:20:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230167AbjCPTUX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjCPTUX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:20:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D12695261
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65E2AB8231F
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0392DC433A4;
        Thu, 16 Mar 2023 19:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994412;
        bh=iduJ8EEH5XRSbgd85kwh2qiI4MlprrZFsPJoxrJ3B44=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=kbfH0qdTsG2JMAsnHx9furWFH6ePpjLIii+PgHH+rIBBweVk8elN51PRLbmXHAHVu
         I2jPrN3httaEJ2YcJegbrxh4eVSY22L6dGlSDJJU9OeB8sW+WteeBvFIsgmYuuVvBm
         cgdgXQCg7Z9qKXxPPfFPNwEi19PgZYpH/nhmLsxRdsA/KfRMykNzIJd4jovNRH3Y1c
         UwDG4YHhVw8lzfLJ3i62lGznY2Q1q80DH5PFSX0tbkTdFjoTs3MbPKUaoRbXZt656c
         8iYKuvNaRFS7qgrzpkU/k4BIFJPFTyGSxLsW5la4h0kSpMZiFwU8gzofnoar5XLNDB
         ZcxvbE2UstkJw==
Date:   Thu, 16 Mar 2023 12:20:11 -0700
Subject: [PATCH 2/7] xfs: rename xfs_pptr_info to xfs_getparents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899413955.15157.2069784185328971658.stgit@frogsfrogsfrogs>
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

Rename the head structure of the parent pointer ioctl to match the name
of the ioctl (XFS_IOC_GETPARENTS).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h    |   45 +++++++++++++++++++++++---------------------
 fs/xfs/xfs_ioctl.c        |   46 +++++++++++++++++++++++----------------------
 fs/xfs/xfs_ondisk.h       |    2 +-
 fs/xfs/xfs_parent_utils.c |   26 +++++++++++++------------
 fs/xfs/xfs_parent_utils.h |    8 ++++----
 5 files changed, 64 insertions(+), 63 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index 0db0c8fc5359..c34303a39157 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -752,19 +752,20 @@ struct xfs_scrub_metadata {
 				 XFS_SCRUB_OFLAG_NO_REPAIR_NEEDED)
 #define XFS_SCRUB_FLAGS_ALL	(XFS_SCRUB_FLAGS_IN | XFS_SCRUB_FLAGS_OUT)
 
-#define XFS_PPTR_MAXNAMELEN				256
+#define XFS_GETPARENTS_MAXNAMELEN	256
 
 /* return parents of the handle, not the open fd */
-#define XFS_PPTR_IFLAG_HANDLE  (1U << 0)
+#define XFS_GETPARENTS_IFLAG_HANDLE	(1U << 0)
 
 /* target was the root directory */
-#define XFS_PPTR_OFLAG_ROOT    (1U << 1)
+#define XFS_GETPARENTS_OFLAG_ROOT	(1U << 1)
 
 /* Cursor is done iterating pptrs */
-#define XFS_PPTR_OFLAG_DONE    (1U << 2)
+#define XFS_GETPARENTS_OFLAG_DONE	(1U << 2)
 
- #define XFS_PPTR_FLAG_ALL     (XFS_PPTR_IFLAG_HANDLE | XFS_PPTR_OFLAG_ROOT | \
-				XFS_PPTR_OFLAG_DONE)
+#define XFS_GETPARENTS_FLAG_ALL		(XFS_GETPARENTS_IFLAG_HANDLE | \
+					 XFS_GETPARENTS_OFLAG_ROOT | \
+					 XFS_GETPARENTS_OFLAG_DONE)
 
 /* Get an inode parent pointer through ioctl */
 struct xfs_parent_ptr {
@@ -776,49 +777,49 @@ struct xfs_parent_ptr {
 };
 
 /* Iterate through an inodes parent pointers */
-struct xfs_pptr_info {
-	/* File handle, if XFS_PPTR_IFLAG_HANDLE is set */
-	struct xfs_handle		pi_handle;
+struct xfs_getparents {
+	/* File handle, if XFS_GETPARENTS_IFLAG_HANDLE is set */
+	struct xfs_handle		gp_handle;
 
 	/*
 	 * Structure to track progress in iterating the parent pointers.
 	 * Must be initialized to zeroes before the first ioctl call, and
 	 * not touched by callers after that.
 	 */
-	struct xfs_attrlist_cursor	pi_cursor;
+	struct xfs_attrlist_cursor	gp_cursor;
 
-	/* Operational flags: XFS_PPTR_*FLAG* */
-	__u32				pi_flags;
+	/* Operational flags: XFS_GETPARENTS_*FLAG* */
+	__u32				gp_flags;
 
 	/* Must be set to zero */
-	__u32				pi_reserved;
+	__u32				gp_reserved;
 
 	/* size of the trailing buffer in bytes */
-	__u32				pi_ptrs_size;
+	__u32				gp_ptrs_size;
 
 	/* # of entries filled in (output) */
-	__u32				pi_count;
+	__u32				gp_count;
 
 	/* Must be set to zero */
-	__u64				pi_reserved2[5];
+	__u64				gp_reserved2[5];
 
 	/* Byte offset of each record within the buffer */
-	__u32				pi_offsets[];
+	__u32				gp_offsets[];
 };
 
 static inline size_t
-xfs_pptr_info_sizeof(int nr_ptrs)
+xfs_getparents_sizeof(int nr_ptrs)
 {
-	return sizeof(struct xfs_pptr_info) +
+	return sizeof(struct xfs_getparents) +
 	       (nr_ptrs * sizeof(struct xfs_parent_ptr));
 }
 
 static inline struct xfs_parent_ptr*
-xfs_ppinfo_to_pp(
-	struct xfs_pptr_info	*info,
+xfs_getparents_rec(
+	struct xfs_getparents	*info,
 	int			idx)
 {
-	return (struct xfs_parent_ptr *)((char *)info + info->pi_offsets[idx]);
+	return (struct xfs_parent_ptr *)((char *)info + info->gp_offsets[idx]);
 }
 
 /*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index f34396fb2e88..bc3fe5704eaa 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1679,12 +1679,12 @@ xfs_ioc_scrub_metadata(
 
 /*
  * IOCTL routine to get the parent pointers of an inode and return it to user
- * space.  Caller must pass a buffer space containing a struct xfs_pptr_info,
+ * space.  Caller must pass a buffer space containing a struct xfs_getparents,
  * followed by a region large enough to contain an array of struct
- * xfs_parent_ptr of a size specified in pi_ptrs_size.  If the inode contains
+ * xfs_parent_ptr of a size specified in gp_ptrs_size.  If the inode contains
  * more parent pointers than can fit in the buffer space, caller may re-call
- * the function using the returned pi_cursor to resume iteration.  The
- * number of xfs_parent_ptr returned will be stored in pi_ptrs_count.
+ * the function using the returned gp_cursor to resume iteration.  The
+ * number of xfs_parent_ptr returned will be stored in gp_ptrs_count.
  *
  * Returns 0 on success or non-zero on failure
  */
@@ -1693,7 +1693,7 @@ xfs_ioc_get_parent_pointer(
 	struct file			*filp,
 	void				__user *arg)
 {
-	struct xfs_pptr_info		*ppi = NULL;
+	struct xfs_getparents		*ppi = NULL;
 	int				error = 0;
 	struct xfs_inode		*file_ip = XFS_I(file_inode(filp));
 	struct xfs_inode		*call_ip = file_ip;
@@ -1705,46 +1705,46 @@ xfs_ioc_get_parent_pointer(
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	/* Allocate an xfs_pptr_info to put the user data */
-	ppi = kvmalloc(sizeof(struct xfs_pptr_info), GFP_KERNEL);
+	/* Allocate an xfs_getparents to put the user data */
+	ppi = kvmalloc(sizeof(struct xfs_getparents), GFP_KERNEL);
 	if (!ppi)
 		return -ENOMEM;
 
 	/* Copy the data from the user */
-	error = copy_from_user(ppi, arg, sizeof(struct xfs_pptr_info));
+	error = copy_from_user(ppi, arg, sizeof(struct xfs_getparents));
 	if (error) {
 		error = -EFAULT;
 		goto out;
 	}
 
 	/* Check size of buffer requested by user */
-	if (ppi->pi_ptrs_size > XFS_XATTR_LIST_MAX) {
+	if (ppi->gp_ptrs_size > XFS_XATTR_LIST_MAX) {
 		error = -ENOMEM;
 		goto out;
 	}
-	if (ppi->pi_ptrs_size < sizeof(struct xfs_pptr_info)) {
+	if (ppi->gp_ptrs_size < sizeof(struct xfs_getparents)) {
 		error = -EINVAL;
 		goto out;
 	}
 
-	if (ppi->pi_flags & ~XFS_PPTR_FLAG_ALL) {
+	if (ppi->gp_flags & ~XFS_GETPARENTS_FLAG_ALL) {
 		error = -EINVAL;
 		goto out;
 	}
-	ppi->pi_flags &= ~(XFS_PPTR_OFLAG_ROOT | XFS_PPTR_OFLAG_DONE);
+	ppi->gp_flags &= ~(XFS_GETPARENTS_OFLAG_ROOT | XFS_GETPARENTS_OFLAG_DONE);
 
 	/*
 	 * Now that we know how big the trailing buffer is, expand
-	 * our kernel xfs_pptr_info to be the same size
+	 * our kernel xfs_getparents to be the same size
 	 */
-	ppi = kvrealloc(ppi, sizeof(struct xfs_pptr_info),
-			xfs_pptr_info_sizeof(ppi->pi_ptrs_size),
+	ppi = kvrealloc(ppi, sizeof(struct xfs_getparents),
+			xfs_getparents_sizeof(ppi->gp_ptrs_size),
 			GFP_KERNEL | __GFP_ZERO);
 	if (!ppi)
 		return -ENOMEM;
 
-	if (ppi->pi_flags & XFS_PPTR_IFLAG_HANDLE) {
-		struct xfs_handle	*hanp = &ppi->pi_handle;
+	if (ppi->gp_flags & XFS_GETPARENTS_IFLAG_HANDLE) {
+		struct xfs_handle	*hanp = &ppi->gp_handle;
 
 		if (memcmp(&hanp->ha_fsid, mp->m_fixedfsid,
 							sizeof(xfs_fsid_t))) {
@@ -1775,26 +1775,26 @@ xfs_ioc_get_parent_pointer(
 	 * all, the caller's buffer was too short.  Tell userspace that, erm,
 	 * the message is too long.
 	 */
-	if (ppi->pi_count == 0 && !(ppi->pi_flags & XFS_PPTR_OFLAG_DONE)) {
+	if (ppi->gp_count == 0 && !(ppi->gp_flags & XFS_GETPARENTS_OFLAG_DONE)) {
 		error = -EMSGSIZE;
 		goto out;
 	}
 
 	/* Copy the parent pointer head back to the user */
-	bytes = xfs_getparents_arraytop(ppi, ppi->pi_count);
+	bytes = xfs_getparents_arraytop(ppi, ppi->gp_count);
 	error = copy_to_user(arg, ppi, bytes);
 	if (error) {
 		error = -EFAULT;
 		goto out;
 	}
 
-	if (ppi->pi_count == 0)
+	if (ppi->gp_count == 0)
 		goto out;
 
 	/* Copy the parent pointer records back to the user. */
-	o_pptr = (__user char*)arg + ppi->pi_offsets[ppi->pi_count - 1];
-	i_pptr = xfs_ppinfo_to_pp(ppi, ppi->pi_count - 1);
-	bytes = ((char *)ppi + ppi->pi_ptrs_size) - (char *)i_pptr;
+	o_pptr = (__user char*)arg + ppi->gp_offsets[ppi->gp_count - 1];
+	i_pptr = xfs_getparents_rec(ppi, ppi->gp_count - 1);
+	bytes = ((char *)ppi + ppi->gp_ptrs_size) - (char *)i_pptr;
 	error = copy_to_user(o_pptr, i_pptr, bytes);
 	if (error) {
 		error = -EFAULT;
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 829bee58fc63..ba68c3270e07 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -152,7 +152,7 @@ xfs_check_ondisk_structs(void)
 
 	/* parent pointer ioctls */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_ptr,            24);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_pptr_info,             96);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents,		96);
 
 	/*
 	 * The v5 superblock format extended several v4 header structures with
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
index f3cf8b33605d..d74cb2081cd2 100644
--- a/fs/xfs/xfs_parent_utils.c
+++ b/fs/xfs/xfs_parent_utils.c
@@ -26,7 +26,7 @@
 struct xfs_getparent_ctx {
 	struct xfs_attr_list_context	context;
 	struct xfs_parent_name_irec	pptr_irec;
-	struct xfs_pptr_info		*ppi;
+	struct xfs_getparents		*ppi;
 };
 
 static inline unsigned int
@@ -47,7 +47,7 @@ xfs_getparent_listent(
 	int				valuelen)
 {
 	struct xfs_getparent_ctx	*gp;
-	struct xfs_pptr_info		*ppi;
+	struct xfs_getparents		*ppi;
 	struct xfs_parent_ptr		*pptr;
 	struct xfs_parent_name_rec	*rec = (void *)name;
 	struct xfs_parent_name_irec	*irec;
@@ -79,7 +79,7 @@ xfs_getparent_listent(
 	 * to the caller that we did /not/ reach the end of the parent pointer
 	 * recordset.
 	 */
-	arraytop = xfs_getparents_arraytop(ppi, ppi->pi_count + 1);
+	arraytop = xfs_getparents_arraytop(ppi, ppi->gp_count + 1);
 	context->firstu -= xfs_getparents_rec_sizeof(irec);
 	if (context->firstu < arraytop) {
 		context->seen_enough = 1;
@@ -87,8 +87,8 @@ xfs_getparent_listent(
 	}
 
 	/* Format the parent pointer directly into the caller buffer. */
-	ppi->pi_offsets[ppi->pi_count] = context->firstu;
-	pptr = xfs_ppinfo_to_pp(ppi, ppi->pi_count);
+	ppi->gp_offsets[ppi->gp_count] = context->firstu;
+	pptr = xfs_getparents_rec(ppi, ppi->gp_count);
 	pptr->xpp_ino = irec->p_ino;
 	pptr->xpp_gen = irec->p_gen;
 	pptr->xpp_diroffset = irec->p_diroffset;
@@ -96,14 +96,14 @@ xfs_getparent_listent(
 
 	memcpy(pptr->xpp_name, irec->p_name, irec->p_namelen);
 	pptr->xpp_name[irec->p_namelen] = 0;
-	ppi->pi_count++;
+	ppi->gp_count++;
 }
 
 /* Retrieve the parent pointers for a given inode. */
 int
 xfs_getparent_pointers(
 	struct xfs_inode		*ip,
-	struct xfs_pptr_info		*ppi)
+	struct xfs_getparents		*ppi)
 {
 	struct xfs_getparent_ctx	*gp;
 	int				error;
@@ -115,13 +115,13 @@ xfs_getparent_pointers(
 	gp->context.dp = ip;
 	gp->context.resynch = 1;
 	gp->context.put_listent = xfs_getparent_listent;
-	gp->context.bufsize = round_down(ppi->pi_ptrs_size, sizeof(uint32_t));
+	gp->context.bufsize = round_down(ppi->gp_ptrs_size, sizeof(uint32_t));
 	gp->context.firstu = gp->context.bufsize;
 
 	/* Copy the cursor provided by caller */
-	memcpy(&gp->context.cursor, &ppi->pi_cursor,
+	memcpy(&gp->context.cursor, &ppi->gp_cursor,
 			sizeof(struct xfs_attrlist_cursor));
-	ppi->pi_count = 0;
+	ppi->gp_count = 0;
 
 	error = xfs_attr_list(&gp->context);
 	if (error)
@@ -133,17 +133,17 @@ xfs_getparent_pointers(
 
 	/* Is this the root directory? */
 	if (ip->i_ino == ip->i_mount->m_sb.sb_rootino)
-		ppi->pi_flags |= XFS_PPTR_OFLAG_ROOT;
+		ppi->gp_flags |= XFS_GETPARENTS_OFLAG_ROOT;
 
 	/*
 	 * If we did not run out of buffer space, then we reached the end of
 	 * the pptr recordset, so set the DONE flag.
 	 */
 	if (gp->context.seen_enough == 0)
-		ppi->pi_flags |= XFS_PPTR_OFLAG_DONE;
+		ppi->gp_flags |= XFS_GETPARENTS_OFLAG_DONE;
 
 	/* Update the caller with the current cursor position */
-	memcpy(&ppi->pi_cursor, &gp->context.cursor,
+	memcpy(&ppi->gp_cursor, &gp->context.cursor,
 			sizeof(struct xfs_attrlist_cursor));
 out_free:
 	kfree(gp);
diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
index d79197f23c40..48de5b700f9c 100644
--- a/fs/xfs/xfs_parent_utils.h
+++ b/fs/xfs/xfs_parent_utils.h
@@ -8,13 +8,13 @@
 
 static inline unsigned int
 xfs_getparents_arraytop(
-	const struct xfs_pptr_info	*ppi,
+	const struct xfs_getparents	*ppi,
 	unsigned int			nr)
 {
-	return sizeof(struct xfs_pptr_info) +
-			(nr * sizeof(ppi->pi_offsets[0]));
+	return sizeof(struct xfs_getparents) +
+			(nr * sizeof(ppi->gp_offsets[0]));
 }
 
-int xfs_getparent_pointers(struct xfs_inode *ip, struct xfs_pptr_info *ppi);
+int xfs_getparent_pointers(struct xfs_inode *ip, struct xfs_getparents *ppi);
 
 #endif	/* __XFS_PARENT_UTILS_H__ */

