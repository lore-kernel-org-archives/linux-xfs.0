Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D95EC61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:53:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjBPUxg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:53:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229793AbjBPUxf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:53:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C8E2942C
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:53:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9AE2DB82962
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61750C433D2;
        Thu, 16 Feb 2023 20:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580811;
        bh=PKJ5qPmhtzuLyHTPqNJroGsO6L+JODNx/UbrL5Ikaek=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=PJ/HtEClA7HmyQUpQVk2Gejw1Ik8V2udu/2dFrPzhnD4q+gYLU+txaYslsgq2jytl
         ce6pQrVAnqjBw/JdVFyIZZqP8TPjN3sw0DztsI4lNLuX9fwch/q1EWIUbSC/y8h2e6
         zOG7rUJqTMdpIcfi89G+vXyiwCQhlHTHDk1LQ8LnVJ8KGLMWiBmiVcqSoRhASnWGPU
         yxAqWB88wbNzppBbNF5FrEEcatxPHHFq/OR8/oRAH2NOi+qvlRfPDY6b+i3bj6cwV2
         lgEuvnP0vSA/WGfLELievug6kcaI8GIOZkX+GIjkTcwvkV2B2KtnPZb/WjJauJ5kQt
         m2gjfwUpXJERg==
Date:   Thu, 16 Feb 2023 12:53:30 -0800
Subject: [PATCH 3/3] xfs: convert GETPARENTS structures to flex arrays
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657876281.3475586.6793318307162105453.stgit@magnolia>
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

The current definition of the GETPARENTS ioctl doesn't use the buffer
space terribly efficiently because each parent pointer record struct
incorporates enough space to hold the maximally sized dirent name.  Most
dirent names are much less than 255 bytes long, which means we're
wasting a lot of space.

Convert the xfs_getparents_rec structure to use a flex array to store
the dirent name as a null terminated string, which allows us to pack the
information much more densely.  For this to work, augment the
xfs_getparents struct to end with a flex array of buffer offsets to each
xfs_getparents_rec object, much as we do for the attrlist multi ioctl.
Record objects are allocated from the end of the buffer towards the
head.

Finally, reduce the amount of data that we copy to userspace to the head
array containg the offsets, and however much of the buffer's end is used
for the parent records.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h    |   38 ++++++++++++++------------------------
 fs/xfs/xfs_ioctl.c        |   43 ++++++++++++++++++++++++++++++++++++-------
 fs/xfs/xfs_ondisk.h       |    4 ++--
 fs/xfs/xfs_parent_utils.c |   31 ++++++++++++++++++++++---------
 fs/xfs/xfs_parent_utils.h |    9 +++++++++
 fs/xfs/xfs_trace.h        |   22 +++++++++++-----------
 6 files changed, 94 insertions(+), 53 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index ec6fdf78fde7..c8be149398a6 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -769,11 +769,11 @@ struct xfs_scrub_metadata {
 
 /* Get an inode parent pointer through ioctl */
 struct xfs_getparents_rec {
-	__u64		gpr_ino;			/* Inode */
-	__u32		gpr_gen;			/* Inode generation */
-	__u32		gpr_rsvd;			/* Reserved */
-	__u64		gpr_rsvd2;			/* Reserved */
-	__u8		gpr_name[XFS_GETPARENTS_MAXNAMELEN];	/* File name */
+	__u64		gpr_ino;	/* Inode */
+	__u32		gpr_gen;	/* Inode generation */
+	__u32		gpr_rsvd;	/* Reserved */
+	__u64		gpr_rsvd2;	/* Reserved */
+	__u8		gpr_name[];	/* File name and null terminator */
 };
 
 /* Iterate through an inodes parent pointers */
@@ -794,36 +794,26 @@ struct xfs_getparents {
 	/* Must be set to zero */
 	__u32				gp_reserved;
 
-	/* # of entries in array */
-	__u32				gp_ptrs_size;
+	/* size of the memory buffer in bytes, including this header */
+	__u32				gp_bufsize;
 
 	/* # of entries filled in (output) */
-	__u32				gp_ptrs_used;
+	__u32				gp_count;
 
 	/* Must be set to zero */
-	__u64				gp_reserved2[6];
+	__u64				gp_reserved2[5];
 
-	/*
-	 * An array of struct xfs_getparents_rec follows the header
-	 * information. Use xfs_getparents_rec() to access the
-	 * parent pointer array entries.
-	 */
-	struct xfs_getparents_rec		gp_parents[];
+	/* Byte offset of each xfs_getparents_rec object within the buffer. */
+	__u32				gp_offsets[];
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
 	unsigned int		idx)
 {
-	return &info->gp_parents[idx];
+	return (struct xfs_getparents_rec *)((char *)info +
+					     info->gp_offsets[idx]);
 }
 
 /*
@@ -871,7 +861,7 @@ xfs_getparents_rec(
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
-#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_getparents_rec)
+#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_getparents)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index b3154830ef91..14138ce5100a 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1684,7 +1684,7 @@ xfs_ioc_scrub_metadata(
  * xfs_getparents_rec of a size specified in gp_ptrs_size.  If the inode contains
  * more parent pointers than can fit in the buffer space, caller may re-call
  * the function using the returned gp_cursor to resume iteration.  The
- * number of xfs_getparents_rec returned will be stored in gp_ptrs_used.
+ * number of xfs_getparents_rec returned will be stored in gp_count.
  *
  * Returns 0 on success or non-zero on failure
  */
@@ -1698,6 +1698,9 @@ xfs_ioc_get_parent_pointer(
 	struct xfs_inode		*file_ip = XFS_I(file_inode(filp));
 	struct xfs_inode		*call_ip = file_ip;
 	struct xfs_mount		*mp = file_ip->i_mount;
+	void				__user *o_pptr;
+	struct xfs_getparents_rec	*i_pptr;
+	unsigned int			bytes;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -1715,10 +1718,14 @@ xfs_ioc_get_parent_pointer(
 	}
 
 	/* Check size of buffer requested by user */
-	if (xfs_getparents_sizeof(ppi->gp_ptrs_size) > XFS_XATTR_LIST_MAX) {
+	if (ppi->gp_bufsize > XFS_XATTR_LIST_MAX) {
 		error = -ENOMEM;
 		goto out;
 	}
+	if (ppi->gp_bufsize < sizeof(struct xfs_getparents)) {
+		error = -EINVAL;
+		goto out;
+	}
 
 	if (ppi->gp_flags & ~XFS_GETPARENTS_FLAG_ALL) {
 		error = -EINVAL;
@@ -1730,8 +1737,7 @@ xfs_ioc_get_parent_pointer(
 	 * Now that we know how big the trailing buffer is, expand
 	 * our kernel xfs_getparents to be the same size
 	 */
-	ppi = kvrealloc(ppi, sizeof(struct xfs_getparents),
-			xfs_getparents_sizeof(ppi->gp_ptrs_size),
+	ppi = kvrealloc(ppi, sizeof(struct xfs_getparents), ppi->gp_bufsize,
 			GFP_KERNEL | __GFP_ZERO);
 	if (!ppi)
 		return -ENOMEM;
@@ -1763,9 +1769,32 @@ xfs_ioc_get_parent_pointer(
 	if (error)
 		goto out;
 
-	/* Copy the parent pointers back to the user */
-	error = copy_to_user(arg, ppi,
-			xfs_getparents_sizeof(ppi->gp_ptrs_size));
+	/*
+	 * If we ran out of buffer space before copying any parent pointers at
+	 * all, the caller's buffer was too short.  Tell userspace that, erm,
+	 * the message is too long.
+	 */
+	if (ppi->gp_count == 0 && !(ppi->gp_flags & XFS_GETPARENTS_OFLAG_DONE)) {
+		error = -EMSGSIZE;
+		goto out;
+	}
+
+	/* Copy the parent pointer head back to the user */
+	bytes = xfs_getparents_arraytop(ppi, ppi->gp_count);
+	error = copy_to_user(arg, ppi, bytes);
+	if (error) {
+		error = -EFAULT;
+		goto out;
+	}
+
+	if (ppi->gp_count == 0)
+		goto out;
+
+	/* Copy the parent pointer records back to the user. */
+	o_pptr = (__user char*)arg + ppi->gp_offsets[ppi->gp_count - 1];
+	i_pptr = xfs_getparents_rec(ppi, ppi->gp_count - 1);
+	bytes = ((char *)ppi + ppi->gp_bufsize) - (char *)i_pptr;
+	error = copy_to_user(o_pptr, i_pptr, bytes);
 	if (error) {
 		error = -EFAULT;
 		goto out;
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index 38d8113b832d..b7f29b4acac3 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -157,8 +157,8 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
 
 	/* parent pointer ioctls */
-	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_rec,	280);
-	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents,		104);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_rec,	24);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents,		96);
 
 	/*
 	 * The v5 superblock format extended several v4 header structures with
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
index 801223d011e7..04e2e93a1986 100644
--- a/fs/xfs/xfs_parent_utils.c
+++ b/fs/xfs/xfs_parent_utils.c
@@ -29,6 +29,14 @@ struct xfs_getparent_ctx {
 	struct xfs_getparents		*ppi;
 };
 
+static inline unsigned int
+xfs_getparents_rec_sizeof(
+	const struct xfs_parent_name_irec	*irec)
+{
+	return round_up(sizeof(struct xfs_getparents_rec) + irec->p_namelen + 1,
+			sizeof(uint32_t));
+}
+
 static void
 xfs_getparent_listent(
 	struct xfs_attr_list_context	*context,
@@ -43,6 +51,7 @@ xfs_getparent_listent(
 	struct xfs_getparents_rec	*pptr;
 	struct xfs_parent_name_irec	*irec;
 	struct xfs_mount		*mp = context->dp->i_mount;
+	int				arraytop;
 
 	gp = container_of(context, struct xfs_getparent_ctx, context);
 	ppi = gp->ppi;
@@ -64,31 +73,34 @@ xfs_getparent_listent(
 		return;
 	}
 
+	xfs_parent_irec_from_disk(&gp->pptr_irec, (void *)name, namelen, value,
+			valuelen);
+
 	/*
 	 * We found a parent pointer, but we've filled up the buffer.  Signal
 	 * to the caller that we did /not/ reach the end of the parent pointer
 	 * recordset.
 	 */
-	if (ppi->gp_ptrs_used >= ppi->gp_ptrs_size) {
+	arraytop = xfs_getparents_arraytop(ppi, ppi->gp_count + 1);
+	context->firstu -= xfs_getparents_rec_sizeof(irec);
+	if (context->firstu < arraytop) {
 		context->seen_enough = 1;
 		return;
 	}
 
-	xfs_parent_irec_from_disk(&gp->pptr_irec, (void *)name, namelen, value,
-			valuelen);
-
 	trace_xfs_getparent_listent(context->dp, ppi, irec);
 
 	/* Format the parent pointer directly into the caller buffer. */
-	pptr = &ppi->gp_parents[ppi->gp_ptrs_used++];
+	ppi->gp_offsets[ppi->gp_count] = context->firstu;
+	pptr = xfs_getparents_rec(ppi, ppi->gp_count);
 	pptr->gpr_ino = irec->p_ino;
 	pptr->gpr_gen = irec->p_gen;
 	pptr->gpr_rsvd2 = 0;
 	pptr->gpr_rsvd = 0;
 
 	memcpy(pptr->gpr_name, irec->p_name, irec->p_namelen);
-	memset(pptr->gpr_name + irec->p_namelen, 0,
-			sizeof(pptr->gpr_name) - irec->p_namelen);
+	pptr->gpr_name[irec->p_namelen] = 0;
+	ppi->gp_count++;
 }
 
 /* Retrieve the parent pointers for a given inode. */
@@ -107,12 +119,13 @@ xfs_getparent_pointers(
 	gp->context.dp = ip;
 	gp->context.resynch = 1;
 	gp->context.put_listent = xfs_getparent_listent;
-	gp->context.bufsize = 1; /* always init cursor */
+	gp->context.bufsize = round_down(ppi->gp_bufsize, sizeof(uint32_t));
+	gp->context.firstu = gp->context.bufsize;
 
 	/* Copy the cursor provided by caller */
 	memcpy(&gp->context.cursor, &ppi->gp_cursor,
 			sizeof(struct xfs_attrlist_cursor));
-	ppi->gp_ptrs_used = 0;
+	ppi->gp_count = 0;
 
 	trace_xfs_getparent_pointers(ip, ppi, &gp->context.cursor);
 
diff --git a/fs/xfs/xfs_parent_utils.h b/fs/xfs/xfs_parent_utils.h
index 01f127dae086..48de5b700f9c 100644
--- a/fs/xfs/xfs_parent_utils.h
+++ b/fs/xfs/xfs_parent_utils.h
@@ -6,6 +6,15 @@
 #ifndef	__XFS_PARENT_UTILS_H__
 #define	__XFS_PARENT_UTILS_H__
 
+static inline unsigned int
+xfs_getparents_arraytop(
+	const struct xfs_getparents	*ppi,
+	unsigned int			nr)
+{
+	return sizeof(struct xfs_getparents) +
+			(nr * sizeof(ppi->gp_offsets[0]));
+}
+
 int xfs_getparent_pointers(struct xfs_inode *ip, struct xfs_getparents *ppi);
 
 #endif	/* __XFS_PARENT_UTILS_H__ */
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index d31f47eced4c..f831ee910235 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -4327,8 +4327,8 @@ TRACE_EVENT(xfs_getparent_listent,
 	TP_STRUCT__entry(
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
-		__field(unsigned int, pused)
-		__field(unsigned int, psize)
+		__field(unsigned int, count)
+		__field(unsigned int, bufsize)
 		__field(xfs_ino_t, parent_ino)
 		__field(unsigned int, parent_gen)
 		__field(unsigned int, namelen)
@@ -4337,18 +4337,18 @@ TRACE_EVENT(xfs_getparent_listent,
 	TP_fast_assign(
 		__entry->dev = ip->i_mount->m_super->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->pused = ppi->gp_ptrs_used;
-		__entry->psize = ppi->gp_ptrs_size;
+		__entry->count = ppi->gp_count;
+		__entry->bufsize = ppi->gp_bufsize;
 		__entry->parent_ino = irec->p_ino;
 		__entry->parent_gen = irec->p_gen;
 		__entry->namelen = irec->p_namelen;
 		memcpy(__get_str(name), irec->p_name, irec->p_namelen);
 	),
-	TP_printk("dev %d:%d ino 0x%llx pptr %u/%u: parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
+	TP_printk("dev %d:%d ino 0x%llx bufsize %u count %u: parent_ino 0x%llx parent_gen 0x%x name '%.*s'",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
-		  __entry->pused,
-		  __entry->psize,
+		  __entry->bufsize,
+		  __entry->count,
 		  __entry->parent_ino,
 		  __entry->parent_gen,
 		  __entry->namelen,
@@ -4363,7 +4363,7 @@ TRACE_EVENT(xfs_getparent_pointers,
 		__field(dev_t, dev)
 		__field(xfs_ino_t, ino)
 		__field(unsigned int, flags)
-		__field(unsigned int, psize)
+		__field(unsigned int, bufsize)
 		__field(unsigned int, hashval)
 		__field(unsigned int, blkno)
 		__field(unsigned int, offset)
@@ -4373,17 +4373,17 @@ TRACE_EVENT(xfs_getparent_pointers,
 		__entry->dev = ip->i_mount->m_super->s_dev;
 		__entry->ino = ip->i_ino;
 		__entry->flags = ppi->gp_flags;
-		__entry->psize = ppi->gp_ptrs_size;
+		__entry->bufsize = ppi->gp_bufsize;
 		__entry->hashval = cur->hashval;
 		__entry->blkno = cur->blkno;
 		__entry->offset = cur->offset;
 		__entry->initted = cur->initted;
 	),
-	TP_printk("dev %d:%d ino 0x%llx flags 0x%x psize %u cur_init? %d hashval 0x%x blkno %u offset %u",
+	TP_printk("dev %d:%d ino 0x%llx flags 0x%x bufsize %u cur_init? %d hashval 0x%x blkno %u offset %u",
 		  MAJOR(__entry->dev), MINOR(__entry->dev),
 		  __entry->ino,
 		  __entry->flags,
-		  __entry->psize,
+		  __entry->bufsize,
 		  __entry->initted,
 		  __entry->hashval,
 		  __entry->blkno,

