Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 226DEC6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:30:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229542AbjCPTa6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbjCPTa5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:30:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F27DFB66
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:30:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 062AB620E3
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:30:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62FC6C433EF;
        Thu, 16 Mar 2023 19:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678995051;
        bh=/EIL0n05gOEseUvVEyVC2m/tMW/6Qrwj6NFXEdIi12s=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=aEnKem0XjP7H0RgMf6VX2IoGGmRegruTj50B8xPZsZlgy14aQVHw5e1w4+wTJ6vpf
         kYKkSGghY/zsu6Lj4upudTclEePaUSPsORdX4UXZeaN+VGncYNvO70Q6nFQkqle3Pr
         iVG4Gv2NDPLRDcVuPu9sYn2yF6HiuTxcbeoBCzDG8z4Zhp992t76R37jSVUQiJ0jaT
         1A3cn95b5k4BlITKZlzq9tKo1ykxURPRS9bdlB85xYuB/sbOkYXR7UfviP4Vl9+ndY
         kGXLF/MKHYZ15QZW+0vH6vfcHs9VxuKNlbdmh4o02y/kzs15jXkd2sVer++NlmEg2r
         u66bz/DkU58vg==
Date:   Thu, 16 Mar 2023 12:30:51 -0700
Subject: [PATCH 1/5] xfs: rename xfs_pptr_info to xfs_getparents
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899416470.16836.8303504979962437435.stgit@frogsfrogsfrogs>
In-Reply-To: <167899416457.16836.2981078472584318439.stgit@frogsfrogsfrogs>
References: <167899416457.16836.2981078472584318439.stgit@frogsfrogsfrogs>
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
 io/parent.c     |    4 ++--
 libfrog/pptrs.c |   24 ++++++++++++------------
 libfrog/pptrs.h |    2 +-
 libxfs/xfs_fs.h |   45 +++++++++++++++++++++++----------------------
 4 files changed, 38 insertions(+), 37 deletions(-)


diff --git a/io/parent.c b/io/parent.c
index 36522f262..1c1453f2c 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -24,14 +24,14 @@ struct pptr_args {
 
 static int
 pptr_print(
-	struct xfs_pptr_info	*pi,
+	struct xfs_getparents	*pi,
 	struct xfs_parent_ptr	*pptr,
 	void			*arg)
 {
 	struct pptr_args	*args = arg;
 	unsigned int		namelen;
 
-	if (pi->pi_flags & XFS_PPTR_OFLAG_ROOT) {
+	if (pi->gp_flags & XFS_GETPARENTS_OFLAG_ROOT) {
 		printf(_("Root directory.\n"));
 		return 0;
 	}
diff --git a/libfrog/pptrs.c b/libfrog/pptrs.c
index 488682738..e292ced19 100644
--- a/libfrog/pptrs.c
+++ b/libfrog/pptrs.c
@@ -12,16 +12,16 @@
 #include "libfrog/pptrs.h"
 
 /* Allocate a buffer large enough for some parent pointer records. */
-static inline struct xfs_pptr_info *
+static inline struct xfs_getparents *
 alloc_pptr_buf(
 	size_t			bufsize)
 {
-	struct xfs_pptr_info	*pi;
+	struct xfs_getparents	*pi;
 
 	pi = calloc(bufsize, 1);
 	if (!pi)
 		return NULL;
-	pi->pi_ptrs_size = bufsize;
+	pi->gp_ptrs_size = bufsize;
 	return pi;
 }
 
@@ -36,7 +36,7 @@ handle_walk_parents(
 	walk_pptr_fn		fn,
 	void			*arg)
 {
-	struct xfs_pptr_info	*pi;
+	struct xfs_getparents	*pi;
 	struct xfs_parent_ptr	*p;
 	unsigned int		i;
 	ssize_t			ret = -1;
@@ -46,25 +46,25 @@ handle_walk_parents(
 		return errno;
 
 	if (handle) {
-		memcpy(&pi->pi_handle, handle, sizeof(struct xfs_handle));
-		pi->pi_flags = XFS_PPTR_IFLAG_HANDLE;
+		memcpy(&pi->gp_handle, handle, sizeof(struct xfs_handle));
+		pi->gp_flags = XFS_GETPARENTS_IFLAG_HANDLE;
 	}
 
 	ret = ioctl(fd, XFS_IOC_GETPARENTS, pi);
 	while (!ret) {
-		if (pi->pi_flags & XFS_PPTR_OFLAG_ROOT) {
+		if (pi->gp_flags & XFS_GETPARENTS_OFLAG_ROOT) {
 			ret = fn(pi, NULL, arg);
 			goto out_pi;
 		}
 
-		for (i = 0; i < pi->pi_count; i++) {
-			p = xfs_ppinfo_to_pp(pi, i);
+		for (i = 0; i < pi->gp_count; i++) {
+			p = xfs_getparents_rec(pi, i);
 			ret = fn(pi, p, arg);
 			if (ret)
 				goto out_pi;
 		}
 
-		if (pi->pi_flags & XFS_PPTR_OFLAG_DONE)
+		if (pi->gp_flags & XFS_GETPARENTS_OFLAG_DONE)
 			break;
 
 		ret = ioctl(fd, XFS_IOC_GETPARENTS, pi);
@@ -127,7 +127,7 @@ static int handle_walk_parent_paths(struct walk_ppaths_info *wpi,
 
 static int
 handle_walk_parent_path_ptr(
-	struct xfs_pptr_info		*pi,
+	struct xfs_getparents		*pi,
 	struct xfs_parent_ptr		*p,
 	void				*arg)
 {
@@ -135,7 +135,7 @@ handle_walk_parent_path_ptr(
 	struct walk_ppaths_info		*wpi = wpli->wpi;
 	int				ret = 0;
 
-	if (pi->pi_flags & XFS_PPTR_OFLAG_ROOT)
+	if (pi->gp_flags & XFS_GETPARENTS_OFLAG_ROOT)
 		return wpi->fn(wpi->mntpt, wpi->path, wpi->arg);
 
 	ret = path_component_change(wpli->pc, p->xpp_name,
diff --git a/libfrog/pptrs.h b/libfrog/pptrs.h
index 1666de060..ab1d0f2fa 100644
--- a/libfrog/pptrs.h
+++ b/libfrog/pptrs.h
@@ -8,7 +8,7 @@
 
 struct path_list;
 
-typedef int (*walk_pptr_fn)(struct xfs_pptr_info *pi,
+typedef int (*walk_pptr_fn)(struct xfs_getparents *pi,
 		struct xfs_parent_ptr *pptr, void *arg);
 typedef int (*walk_ppath_fn)(const char *mntpt, struct path_list *path,
 		void *arg);
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 0db0c8fc5..c34303a39 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
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

