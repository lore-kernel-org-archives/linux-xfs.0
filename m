Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD59FC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbjBPUxD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:53:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229797AbjBPUxD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:53:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698122942C
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:53:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C756660AB9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:53:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 354DAC433EF;
        Thu, 16 Feb 2023 20:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580780;
        bh=20R37CmzS6PYScFU/5eIJUoIYCjkC2btTL/gPACIofY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=jHfPNqCjxKmnI6QZDZhW28vx3wz6+uU1T2Zm55KtDnPKFooPcmydg+MxYBgq1PDOj
         EEw8Iu3UbCBgtp+a5bLNwv5ftXiO+fk0Ft7HUwl+0rI7uBchjkZsoIFuwJE9WNAu1c
         Q6yOLXsAEwEPvb2wcM2yBbb91Oo5M+d2R266W95vGXENbpg0Wlp3JCUtRXglDEKbVx
         d4SqocUppAGfnOJn6eC1SDCelthAYIXXsJum0YWQeoxoUhrDnXv0tSEafEZ8k9lbzF
         ezkba1nwXmTMVxfu/Juhw1hQjHH+nlxANhMGkk6BfOEwfRpM6HGPfyOYFlW6N6dAwc
         Yn8Fom2mzEM9Q==
Date:   Thu, 16 Feb 2023 12:52:59 -0800
Subject: [PATCH 1/3] xfs: rename xfs_pptr_info to xfs_getparents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657876252.3475586.14453439715014094354.stgit@magnolia>
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

Rename the head structure of the parent pointer ioctl to match the name
of the ioctl (XFS_IOC_GETPARENTS).

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h    |   51 +++++++++++++++++++++++----------------------
 fs/xfs/xfs_ioctl.c        |   34 +++++++++++++++---------------
 fs/xfs/xfs_ondisk.h       |    2 +-
 fs/xfs/xfs_parent_utils.c |   20 +++++++++---------
 fs/xfs/xfs_parent_utils.h |    2 +-
 fs/xfs/xfs_trace.h        |   14 ++++++------
 6 files changed, 62 insertions(+), 61 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index c65345d2ba7a..2a23c010a0a0 100644
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
@@ -772,57 +773,57 @@ struct xfs_parent_ptr {
 	__u32		xpp_gen;			/* Inode generation */
 	__u32		xpp_rsvd;			/* Reserved */
 	__u64		xpp_rsvd2;			/* Reserved */
-	__u8		xpp_name[XFS_PPTR_MAXNAMELEN];	/* File name */
+	__u8		xpp_name[XFS_GETPARENTS_MAXNAMELEN];	/* File name */
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
 
 	/* # of entries in array */
-	__u32				pi_ptrs_size;
+	__u32				gp_ptrs_size;
 
 	/* # of entries filled in (output) */
-	__u32				pi_ptrs_used;
+	__u32				gp_ptrs_used;
 
 	/* Must be set to zero */
-	__u64				pi_reserved2[6];
+	__u64				gp_reserved2[6];
 
 	/*
 	 * An array of struct xfs_parent_ptr follows the header
-	 * information. Use xfs_ppinfo_to_pp() to access the
+	 * information. Use xfs_getparents_rec() to access the
 	 * parent pointer array entries.
 	 */
-	struct xfs_parent_ptr		pi_parents[];
+	struct xfs_parent_ptr		gp_parents[];
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
-	int			idx)
+xfs_getparents_rec(
+	struct xfs_getparents	*info,
+	unsigned int		idx)
 {
-	return &info->pi_parents[idx];
+	return &info->gp_parents[idx];
 }
 
 /*
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 4c36ddd19dbd..2687e9965310 100644
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
- * number of xfs_parent_ptr returned will be stored in pi_ptrs_used.
+ * the function using the returned gp_cursor to resume iteration.  The
+ * number of xfs_parent_ptr returned will be stored in gp_ptrs_used.
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
@@ -1702,42 +1702,42 @@ xfs_ioc_get_parent_pointer(
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
-	if (xfs_pptr_info_sizeof(ppi->pi_ptrs_size) > XFS_XATTR_LIST_MAX) {
+	if (xfs_getparents_sizeof(ppi->gp_ptrs_size) > XFS_XATTR_LIST_MAX) {
 		error = -ENOMEM;
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
@@ -1765,7 +1765,7 @@ xfs_ioc_get_parent_pointer(
 
 	/* Copy the parent pointers back to the user */
 	error = copy_to_user(arg, ppi,
-			xfs_pptr_info_sizeof(ppi->pi_ptrs_size));
+			xfs_getparents_sizeof(ppi->gp_ptrs_size));
 	if (error) {
 		error = -EFAULT;
 		goto out;
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 5f32dea26221..ba85dec53b0f 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -158,7 +158,7 @@ xfs_check_ondisk_structs(void)
 
 	/* parent pointer ioctls */
 	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_ptr,            280);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_pptr_info,             104);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents,		104);
 
 	/*
 	 * The v5 superblock format extended several v4 header structures with
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
index 284ca3c14a0f..d10d04a8a3c4 100644
--- a/fs/xfs/xfs_parent_utils.c
+++ b/fs/xfs/xfs_parent_utils.c
@@ -26,7 +26,7 @@
 struct xfs_getparent_ctx {
 	struct xfs_attr_list_context	context;
 	struct xfs_parent_name_irec	pptr_irec;
-	struct xfs_pptr_info		*ppi;
+	struct xfs_getparents		*ppi;
 };
 
 static void
@@ -39,7 +39,7 @@ xfs_getparent_listent(
 	int				valuelen)
 {
 	struct xfs_getparent_ctx	*gp;
-	struct xfs_pptr_info		*ppi;
+	struct xfs_getparents		*ppi;
 	struct xfs_parent_ptr		*pptr;
 	struct xfs_parent_name_irec	*irec;
 	struct xfs_mount		*mp = context->dp->i_mount;
@@ -69,7 +69,7 @@ xfs_getparent_listent(
 	 * to the caller that we did /not/ reach the end of the parent pointer
 	 * recordset.
 	 */
-	if (ppi->pi_ptrs_used >= ppi->pi_ptrs_size) {
+	if (ppi->gp_ptrs_used >= ppi->gp_ptrs_size) {
 		context->seen_enough = 1;
 		return;
 	}
@@ -80,7 +80,7 @@ xfs_getparent_listent(
 	trace_xfs_getparent_listent(context->dp, ppi, irec);
 
 	/* Format the parent pointer directly into the caller buffer. */
-	pptr = &ppi->pi_parents[ppi->pi_ptrs_used++];
+	pptr = &ppi->gp_parents[ppi->gp_ptrs_used++];
 	pptr->xpp_ino = irec->p_ino;
 	pptr->xpp_gen = irec->p_gen;
 	pptr->xpp_rsvd2 = 0;
@@ -95,7 +95,7 @@ xfs_getparent_listent(
 int
 xfs_getparent_pointers(
 	struct xfs_inode		*ip,
-	struct xfs_pptr_info		*ppi)
+	struct xfs_getparents		*ppi)
 {
 	struct xfs_getparent_ctx	*gp;
 	int				error;
@@ -110,9 +110,9 @@ xfs_getparent_pointers(
 	gp->context.bufsize = 1; /* always init cursor */
 
 	/* Copy the cursor provided by caller */
-	memcpy(&gp->context.cursor, &ppi->pi_cursor,
+	memcpy(&gp->context.cursor, &ppi->gp_cursor,
 			sizeof(struct xfs_attrlist_cursor));
-	ppi->pi_ptrs_used = 0;
+	ppi->gp_ptrs_used = 0;
 
 	trace_xfs_getparent_pointers(ip, ppi, &gp->context.cursor);
 
@@ -126,17 +126,17 @@ xfs_getparent_pointers(
 
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
index 9936c74e6f96..01f127dae086 100644
--- a/fs/xfs/xfs_parent_utils.h
+++ b/fs/xfs/xfs_parent_utils.h
@@ -6,6 +6,6 @@
 #ifndef	__XFS_PARENT_UTILS_H__
 #define	__XFS_PARENT_UTILS_H__
 
-int xfs_getparent_pointers(struct xfs_inode *ip, struct xfs_pptr_info *ppi);
+int xfs_getparent_pointers(struct xfs_inode *ip, struct xfs_getparents *ppi);
 
 #endif	/* __XFS_PARENT_UTILS_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index 959aff69822d..d31f47eced4c 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -74,7 +74,7 @@ struct xfs_inobt_rec_incore;
 union xfs_btree_ptr;
 struct xfs_dqtrx;
 struct xfs_icwalk;
-struct xfs_pptr_info;
+struct xfs_getparents;
 struct xfs_parent_name_irec;
 struct xfs_attrlist_cursor_kern;
 
@@ -4321,7 +4321,7 @@ TRACE_EVENT(xfs_force_shutdown,
 );
 
 TRACE_EVENT(xfs_getparent_listent,
-	TP_PROTO(struct xfs_inode *ip, const struct xfs_pptr_info *ppi,
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_getparents *ppi,
 	         const struct xfs_parent_name_irec *irec),
 	TP_ARGS(ip, ppi, irec),
 	TP_STRUCT__entry(
@@ -4337,8 +4337,8 @@ TRACE_EVENT(xfs_getparent_listent,
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->pused = ppi->pi_ptrs_used;
-		__entry->psize = ppi->pi_ptrs_size;
+		__entry->pused = ppi->gp_ptrs_used;
+		__entry->psize = ppi->gp_ptrs_size;
 		__entry->parent_ino = irec->p_ino;
 		__entry->parent_gen = irec->p_gen;
 		__entry->namelen = irec->p_namelen;
@@ -4356,7 +4356,7 @@ TRACE_EVENT(xfs_getparent_listent,
 );
 
 TRACE_EVENT(xfs_getparent_pointers,
-	TP_PROTO(struct xfs_inode *ip, const struct xfs_pptr_info *ppi,
+	TP_PROTO(struct xfs_inode *ip, const struct xfs_getparents *ppi,
 		 const struct xfs_attrlist_cursor_kern *cur),
 	TP_ARGS(ip, ppi, cur),
 	TP_STRUCT__entry(
@@ -4372,8 +4372,8 @@ TRACE_EVENT(xfs_getparent_pointers,
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->flags = ppi->pi_flags;
-		__entry->psize = ppi->pi_ptrs_size;
+		__entry->flags = ppi->gp_flags;
+		__entry->psize = ppi->gp_ptrs_size;
 		__entry->hashval = cur->hashval;
 		__entry->blkno = cur->blkno;
 		__entry->offset = cur->offset;

