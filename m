Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D69CC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:12:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbjBPVMy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjBPVMx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:12:53 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C4A26A57
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:12:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id EB75CCE2D79
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F81CC433D2;
        Thu, 16 Feb 2023 21:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581968;
        bh=o2MGK8frsrbTU8GIbCIrGm9G3NKiWA2O/9HdEF1eNoM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=UmGgglSZHatjRw2TOQPVYhMjSi5YArUHoPRq2UZR61BaWS7m0H+yzrY6GuTOAxo/0
         CMCz9b8a0QQJECPeb5UQe0LNLhX9WSYYySRyokHrqqsSMSwg2yHz5UNgVfSN9IA7Zl
         cnnOPY3AM78EfDVdMAx266GC/XM8F77eg+/ON6zD/Yc1muvBa0WI9Cz219WtlfLbq2
         xXTAvWrywTm1R53Q+VQrQiTUNvEsGup9dWdWFR0l9uA0xdqHfyJ7VtTSzxDJauUGED
         FFtZAvLe38+c94S3iUmH63o4vcx/LKlLrxr0G3EfdMKyT93NSFmOUA7+YBaSigUt6z
         1kuVsvbHKv2FA==
Date:   Thu, 16 Feb 2023 13:12:47 -0800
Subject: [PATCH 3/3] xfs: convert GETPARENTS structures to flex arrays
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657882785.3478223.6288557795459574411.stgit@magnolia>
In-Reply-To: <167657882746.3478223.17677270918788774260.stgit@magnolia>
References: <167657882746.3478223.17677270918788774260.stgit@magnolia>
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

Reduce the amount of data that we copy to userspace to the head array
containg the offsets, and however much of the buffer's end is used for
the parent records.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libfrog/pptrs.c |   12 ++++++------
 libxfs/xfs_fs.h |   38 ++++++++++++++------------------------
 2 files changed, 20 insertions(+), 30 deletions(-)


diff --git a/libfrog/pptrs.c b/libfrog/pptrs.c
index 48a09f69..67fd40c3 100644
--- a/libfrog/pptrs.c
+++ b/libfrog/pptrs.c
@@ -14,15 +14,15 @@
 /* Allocate a buffer large enough for some parent pointer records. */
 static inline struct xfs_getparents *
 alloc_pptr_buf(
-	size_t			nr_ptrs)
+	size_t			bufsize)
 {
 	struct xfs_getparents	*pi;
 
-	pi = malloc(xfs_getparents_sizeof(nr_ptrs));
+	pi = calloc(bufsize, 1);
 	if (!pi)
 		return NULL;
-	memset(pi, 0, sizeof(struct xfs_getparents));
-	pi->gp_ptrs_size = nr_ptrs;
+
+	pi->gp_bufsize = bufsize;
 	return pi;
 }
 
@@ -42,7 +42,7 @@ handle_walk_parents(
 	unsigned int		i;
 	ssize_t			ret = -1;
 
-	pi = alloc_pptr_buf(4);
+	pi = alloc_pptr_buf(XFS_XATTR_LIST_MAX);
 	if (!pi)
 		return errno;
 
@@ -58,7 +58,7 @@ handle_walk_parents(
 			goto out_pi;
 		}
 
-		for (i = 0; i < pi->gp_ptrs_used; i++) {
+		for (i = 0; i < pi->gp_count; i++) {
 			p = xfs_getparents_rec(pi, i);
 			ret = fn(pi, p, arg);
 			if (ret)
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index ec6fdf78..c8be1493 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
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

