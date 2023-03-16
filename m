Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF6B3C6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:20:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230135AbjCPTUe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbjCPTUc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:20:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C49A162DB2
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:20:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 429BC620DC
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A689CC433D2;
        Thu, 16 Mar 2023 19:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994427;
        bh=oKeXifRdIhAJ+hypK41Ohc9hOs/mgUeC15SVsRYcYRw=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=iqoIn8Ogt13L411C9SmKKVd13L4b3Hfg/FmFCmMbxHLlM4lEWJWEoL40v+c6ZN7o0
         IYMRunij6jyygfqV2Az/BfFdF62aQjvcD+onDG84ocdCtb/tJjdoWChQ0ZqjBprJTf
         /oQOOHzNPmO32TbZULnP3VYzI5OpyvHzGmVH/tEqn0nmRY4ha4mB4ifZNCzj1noBN1
         a4mObKtDoyA6Qw7NgeS/X136DMn9Uv9HKuJg9KaN3YHBYPz4wKfBVNren4L8p0oh+a
         iLM/tSU5tOKe2Q7O7jTaL4ciIUZmOtTmlUtmfNtF5AghzO+nesCYqzY/vunWoQ7hT2
         lmd/vpwBaVnyw==
Date:   Thu, 16 Mar 2023 12:20:27 -0700
Subject: [PATCH 3/7] xfs: rename xfs_parent_ptr
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899413970.15157.11823693862087443664.stgit@frogsfrogsfrogs>
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

Change the name to xfs_getparents_rec so that the name matches the head
structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_fs.h    |   20 ++++++++++----------
 fs/xfs/xfs_ioctl.c        |    6 +++---
 fs/xfs/xfs_ondisk.h       |    2 +-
 fs/xfs/xfs_parent_utils.c |   16 ++++++++--------
 4 files changed, 22 insertions(+), 22 deletions(-)


diff --git a/fs/xfs/libxfs/xfs_fs.h b/fs/xfs/libxfs/xfs_fs.h
index c34303a39157..c8edc7c099e8 100644
--- a/fs/xfs/libxfs/xfs_fs.h
+++ b/fs/xfs/libxfs/xfs_fs.h
@@ -768,12 +768,12 @@ struct xfs_scrub_metadata {
 					 XFS_GETPARENTS_OFLAG_DONE)
 
 /* Get an inode parent pointer through ioctl */
-struct xfs_parent_ptr {
-	__u64		xpp_ino;			/* Inode */
-	__u32		xpp_gen;			/* Inode generation */
-	__u32		xpp_diroffset;			/* Directory offset */
-	__u64		xpp_rsvd;			/* Reserved */
-	__u8		xpp_name[];			/* File name */
+struct xfs_getparents_rec {
+	__u64		gpr_ino;			/* Inode */
+	__u32		gpr_gen;			/* Inode generation */
+	__u32		gpr_diroffset;			/* Directory offset */
+	__u64		gpr_rsvd;			/* Reserved */
+	__u8		gpr_name[];			/* File name */
 };
 
 /* Iterate through an inodes parent pointers */
@@ -811,15 +811,15 @@ static inline size_t
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
 	int			idx)
 {
-	return (struct xfs_parent_ptr *)((char *)info + info->gp_offsets[idx]);
+	return (struct xfs_getparents_rec *)((char *)info + info->gp_offsets[idx]);
 }
 
 /*
@@ -867,7 +867,7 @@ xfs_getparents_rec(
 /*	XFS_IOC_GETFSMAP ------ hoisted 59         */
 #define XFS_IOC_SCRUB_METADATA	_IOWR('X', 60, struct xfs_scrub_metadata)
 #define XFS_IOC_AG_GEOMETRY	_IOWR('X', 61, struct xfs_ag_geometry)
-#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_parent_ptr)
+#define XFS_IOC_GETPARENTS	_IOWR('X', 62, struct xfs_getparents_rec)
 
 /*
  * ioctl commands that replace IRIX syssgi()'s
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index bc3fe5704eaa..04123ab41684 100644
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
- * number of xfs_parent_ptr returned will be stored in gp_ptrs_count.
+ * number of xfs_getparents_rec returned will be stored in gp_ptrs_count.
  *
  * Returns 0 on success or non-zero on failure
  */
@@ -1699,7 +1699,7 @@ xfs_ioc_get_parent_pointer(
 	struct xfs_inode		*call_ip = file_ip;
 	struct xfs_mount		*mp = file_ip->i_mount;
 	void				__user *o_pptr;
-	struct xfs_parent_ptr		*i_pptr;
+	struct xfs_getparents_rec		*i_pptr;
 	unsigned int			bytes;
 
 	if (!capable(CAP_SYS_ADMIN))
diff --git a/fs/xfs/xfs_ondisk.h b/fs/xfs/xfs_ondisk.h
index ba68c3270e07..88f9ec393c3d 100644
--- a/fs/xfs/xfs_ondisk.h
+++ b/fs/xfs/xfs_ondisk.h
@@ -151,7 +151,7 @@ xfs_check_ondisk_structs(void)
 	XFS_CHECK_OFFSET(struct xfs_efi_log_format_64, efi_extents,	16);
 
 	/* parent pointer ioctls */
-	XFS_CHECK_STRUCT_SIZE(struct xfs_parent_ptr,            24);
+	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents_rec,	24);
 	XFS_CHECK_STRUCT_SIZE(struct xfs_getparents,		96);
 
 	/*
diff --git a/fs/xfs/xfs_parent_utils.c b/fs/xfs/xfs_parent_utils.c
index d74cb2081cd2..8aff31ed9082 100644
--- a/fs/xfs/xfs_parent_utils.c
+++ b/fs/xfs/xfs_parent_utils.c
@@ -33,7 +33,7 @@ static inline unsigned int
 xfs_getparents_rec_sizeof(
 	const struct xfs_parent_name_irec	*irec)
 {
-	return round_up(sizeof(struct xfs_parent_ptr) + irec->p_namelen + 1,
+	return round_up(sizeof(struct xfs_getparents_rec) + irec->p_namelen + 1,
 			sizeof(uint32_t));
 }
 
@@ -48,7 +48,7 @@ xfs_getparent_listent(
 {
 	struct xfs_getparent_ctx	*gp;
 	struct xfs_getparents		*ppi;
-	struct xfs_parent_ptr		*pptr;
+	struct xfs_getparents_rec	*pptr;
 	struct xfs_parent_name_rec	*rec = (void *)name;
 	struct xfs_parent_name_irec	*irec;
 	struct xfs_mount		*mp = context->dp->i_mount;
@@ -89,13 +89,13 @@ xfs_getparent_listent(
 	/* Format the parent pointer directly into the caller buffer. */
 	ppi->gp_offsets[ppi->gp_count] = context->firstu;
 	pptr = xfs_getparents_rec(ppi, ppi->gp_count);
-	pptr->xpp_ino = irec->p_ino;
-	pptr->xpp_gen = irec->p_gen;
-	pptr->xpp_diroffset = irec->p_diroffset;
-	pptr->xpp_rsvd = 0;
+	pptr->gpr_ino = irec->p_ino;
+	pptr->gpr_gen = irec->p_gen;
+	pptr->gpr_diroffset = irec->p_diroffset;
+	pptr->gpr_rsvd = 0;
 
-	memcpy(pptr->xpp_name, irec->p_name, irec->p_namelen);
-	pptr->xpp_name[irec->p_namelen] = 0;
+	memcpy(pptr->gpr_name, irec->p_name, irec->p_namelen);
+	pptr->gpr_name[irec->p_namelen] = 0;
 	ppi->gp_count++;
 }
 

