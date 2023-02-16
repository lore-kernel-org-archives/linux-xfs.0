Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D8EC636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjBPVMg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjBPVMg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:12:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BEB92BEC4
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:12:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF31DB82760
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:12:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AFBAC433D2;
        Thu, 16 Feb 2023 21:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581952;
        bh=AONjIdRC3i/exYU/3MyWn29Ni+0cdznK6QGeQKKE3/U=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=vH9hmPmdH9ZPYlKdWgxYZByi+pER5OYt+MhlwH6CGBMz/CbpoArXGejmSuBDUUeLd
         v1bt+XZpDPpCrLdU7x1czS2ML7gLDS1gPHO8Z1xQI50b8y4RPFwGvVLmBY8rHX5hWK
         wAgVALfV7aiECEiWiwUkwILUVz/tQg7prlhzVa1SIMKvXFofmyPkER1G6quVn5kOoa
         ZJBLwpY8+GHXrrrd4uYbneUUv817luCvrXIXF1+9LUasdIRwHKtY8VarKcn3oIrVZh
         /cFe9sK6BeTAwZ+RvpfOXbGCQn9++Uwt82LnMT1AcgMKpvV3EX4BF4QF/prXRHDXar
         /KOIWPnE9lMfw==
Date:   Thu, 16 Feb 2023 13:12:32 -0800
Subject: [PATCH 2/3] xfs: rename xfs_parent_ptr
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657882772.3478223.7099237750506767525.stgit@magnolia>
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

Change the name to xfs_getparents_rec so that the name matches the head
structure.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 io/parent.c     |   18 +++++++++---------
 libfrog/pptrs.c |   12 ++++++------
 libfrog/pptrs.h |    2 +-
 libxfs/xfs_fs.h |   22 +++++++++++-----------
 4 files changed, 27 insertions(+), 27 deletions(-)


diff --git a/io/parent.c b/io/parent.c
index 1c1453f2..162c3169 100644
--- a/io/parent.c
+++ b/io/parent.c
@@ -25,7 +25,7 @@ struct pptr_args {
 static int
 pptr_print(
 	struct xfs_getparents	*pi,
-	struct xfs_parent_ptr	*pptr,
+	struct xfs_getparents_rec *pptr,
 	void			*arg)
 {
 	struct pptr_args	*args = arg;
@@ -36,21 +36,21 @@ pptr_print(
 		return 0;
 	}
 
-	if (args->filter_ino && pptr->xpp_ino != args->filter_ino)
+	if (args->filter_ino && pptr->gpr_ino != args->filter_ino)
 		return 0;
-	if (args->filter_name && strcmp(args->filter_name, pptr->xpp_name))
+	if (args->filter_name && strcmp(args->filter_name, pptr->gpr_name))
 		return 0;
 
-	namelen = strlen(pptr->xpp_name);
+	namelen = strlen(pptr->gpr_name);
 	if (args->shortformat) {
 		printf("%llu/%u/%u/%s\n",
-			(unsigned long long)pptr->xpp_ino,
-			(unsigned int)pptr->xpp_gen, namelen, pptr->xpp_name);
+			(unsigned long long)pptr->gpr_ino,
+			(unsigned int)pptr->gpr_gen, namelen, pptr->gpr_name);
 	} else {
-		printf(_("p_ino    = %llu\n"), (unsigned long long)pptr->xpp_ino);
-		printf(_("p_gen    = %u\n"), (unsigned int)pptr->xpp_gen);
+		printf(_("p_ino    = %llu\n"), (unsigned long long)pptr->gpr_ino);
+		printf(_("p_gen    = %u\n"), (unsigned int)pptr->gpr_gen);
 		printf(_("p_reclen = %u\n"), namelen);
-		printf(_("p_name   = \"%s\"\n\n"), pptr->xpp_name);
+		printf(_("p_name   = \"%s\"\n\n"), pptr->gpr_name);
 	}
 	return 0;
 }
diff --git a/libfrog/pptrs.c b/libfrog/pptrs.c
index 3bb441f0..48a09f69 100644
--- a/libfrog/pptrs.c
+++ b/libfrog/pptrs.c
@@ -38,7 +38,7 @@ handle_walk_parents(
 	void			*arg)
 {
 	struct xfs_getparents	*pi;
-	struct xfs_parent_ptr	*p;
+	struct xfs_getparents_rec	*p;
 	unsigned int		i;
 	ssize_t			ret = -1;
 
@@ -129,7 +129,7 @@ static int handle_walk_parent_paths(struct walk_ppaths_info *wpi,
 static int
 handle_walk_parent_path_ptr(
 	struct xfs_getparents		*pi,
-	struct xfs_parent_ptr		*p,
+	struct xfs_getparents_rec	*p,
 	void				*arg)
 {
 	struct walk_ppath_level_info	*wpli = arg;
@@ -139,13 +139,13 @@ handle_walk_parent_path_ptr(
 	if (pi->gp_flags & XFS_GETPARENTS_OFLAG_ROOT)
 		return wpi->fn(wpi->mntpt, wpi->path, wpi->arg);
 
-	ret = path_component_change(wpli->pc, p->xpp_name,
-				strlen((char *)p->xpp_name), p->xpp_ino);
+	ret = path_component_change(wpli->pc, p->gpr_name,
+				strlen((char *)p->gpr_name), p->gpr_ino);
 	if (ret)
 		return ret;
 
-	wpli->newhandle.ha_fid.fid_ino = p->xpp_ino;
-	wpli->newhandle.ha_fid.fid_gen = p->xpp_gen;
+	wpli->newhandle.ha_fid.fid_ino = p->gpr_ino;
+	wpli->newhandle.ha_fid.fid_gen = p->gpr_gen;
 
 	path_list_add_parent_component(wpi->path, wpli->pc);
 	ret = handle_walk_parent_paths(wpi, &wpli->newhandle);
diff --git a/libfrog/pptrs.h b/libfrog/pptrs.h
index ab1d0f2f..05aaea60 100644
--- a/libfrog/pptrs.h
+++ b/libfrog/pptrs.h
@@ -9,7 +9,7 @@
 struct path_list;
 
 typedef int (*walk_pptr_fn)(struct xfs_getparents *pi,
-		struct xfs_parent_ptr *pptr, void *arg);
+		struct xfs_getparents_rec *pptr, void *arg);
 typedef int (*walk_ppath_fn)(const char *mntpt, struct path_list *path,
 		void *arg);
 
diff --git a/libxfs/xfs_fs.h b/libxfs/xfs_fs.h
index 2a23c010..ec6fdf78 100644
--- a/libxfs/xfs_fs.h
+++ b/libxfs/xfs_fs.h
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

