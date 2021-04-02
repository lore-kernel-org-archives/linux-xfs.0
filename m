Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81D91C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 14:24:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 651796113D
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 14:24:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235782AbhDBOYa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 10:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235659AbhDBOY3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 10:24:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 923C4C0613E6
        for <linux-xfs@vger.kernel.org>; Fri,  2 Apr 2021 07:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=9Xr9V0Iz5lDJhahNVBS7Y5zu0cvMf5+s1TyQTf7zZd8=; b=HaWSKQJwxLGmFSE4/UQBP6PRoK
        DDQ/5p+5PNnkJqLwfpFpvk7QHI7mqCCHr8ZOSA+ZkQNPiFIvziGpIFLQme5177sqtFYz2TrKLGZGC
        ebzfRBuCX6xafjdbAXOnXdf/ytICn3zjrDWz3V3quhnuFJ39f4lK62m2M1qSSRn/DTg2ST9X4alZx
        gYYRqSW84iQ5HD2o9LxMkqk5w7KF5+C5MkCidoEAd+GPSI8VHHJn1HG4oC5sWoFuiPAHzQfJ6s/3c
        dveQBy+QIkR4VqeZNJtGElaJgp1NzeX01ed0pGtJ1CRa3ShwcI0ngWDZqTW/OPOGNh3AIlw/VxwSl
        MBfTZFQw==;
Received: from [2001:4bb8:180:7517:6acc:e698:6fa4:15da] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lSKip-00FA63-NG
        for linux-xfs@vger.kernel.org; Fri, 02 Apr 2021 14:24:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/7] xfs: remove XFS_IFINLINE
Date:   Fri,  2 Apr 2021 16:24:08 +0200
Message-Id: <20210402142409.372050-7-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210402142409.372050-1-hch@lst.de>
References: <20210402142409.372050-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just check for an inline format fork instead of the using the equivalent
in-memory XFS_IFINLINE flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c       |  8 ++------
 fs/xfs/libxfs/xfs_attr_leaf.c  |  9 +++------
 fs/xfs/libxfs/xfs_bmap.c       |  3 +--
 fs/xfs/libxfs/xfs_dir2_block.c |  2 +-
 fs/xfs/libxfs/xfs_dir2_sf.c    | 11 +++++------
 fs/xfs/libxfs/xfs_inode_fork.c |  1 -
 fs/xfs/libxfs/xfs_inode_fork.h |  1 -
 fs/xfs/scrub/symlink.c         |  2 +-
 fs/xfs/xfs_dir2_readdir.c      |  2 +-
 fs/xfs/xfs_iops.c              |  4 ++--
 fs/xfs/xfs_symlink.c           |  4 ++--
 11 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 6d1854d506d5ad..1f150f24230c9a 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -362,10 +362,8 @@ xfs_has_attr(
 	if (!xfs_inode_hasattr(dp))
 		return -ENOATTR;
 
-	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
-		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
+	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_attr_sf_findname(args, NULL, NULL);
-	}
 
 	if (xfs_attr_is_leaf(dp)) {
 		error = xfs_attr_leaf_hasname(args, &bp);
@@ -389,10 +387,8 @@ xfs_attr_remove_args(
 	if (!xfs_inode_hasattr(args->dp))
 		return -ENOATTR;
 
-	if (args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
-		ASSERT(args->dp->i_afp->if_flags & XFS_IFINLINE);
+	if (args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_attr_shortform_remove(args);
-	}
 	if (xfs_attr_is_leaf(args->dp))
 		return xfs_attr_leaf_removename(args);
 	return xfs_attr_node_removename(args);
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index d6ef69ab1c67a5..2de6ff2425a449 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -654,9 +654,6 @@ xfs_attr_shortform_create(
 	if (ifp->if_format == XFS_DINODE_FMT_EXTENTS) {
 		ifp->if_flags &= ~XFS_IFEXTENTS;	/* just in case */
 		ifp->if_format = XFS_DINODE_FMT_LOCAL;
-		ifp->if_flags |= XFS_IFINLINE;
-	} else {
-		ASSERT(ifp->if_flags & XFS_IFINLINE);
 	}
 	xfs_idata_realloc(dp, sizeof(*hdr), XFS_ATTR_FORK);
 	hdr = (struct xfs_attr_sf_hdr *)ifp->if_u1.if_data;
@@ -733,7 +730,7 @@ xfs_attr_shortform_add(
 	dp->i_d.di_forkoff = forkoff;
 
 	ifp = dp->i_afp;
-	ASSERT(ifp->if_flags & XFS_IFINLINE);
+	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
 	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	if (xfs_attr_sf_findname(args, &sfe, NULL) == -EEXIST)
 		ASSERT(0);
@@ -851,7 +848,7 @@ xfs_attr_shortform_lookup(xfs_da_args_t *args)
 	trace_xfs_attr_sf_lookup(args);
 
 	ifp = args->dp->i_afp;
-	ASSERT(ifp->if_flags & XFS_IFINLINE);
+	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
 	sf = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
@@ -878,7 +875,7 @@ xfs_attr_shortform_getvalue(
 	struct xfs_attr_sf_entry *sfe;
 	int			i;
 
-	ASSERT(args->dp->i_afp->if_flags == XFS_IFINLINE);
+	ASSERT(args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL);
 	sf = (struct xfs_attr_shortform *)args->dp->i_afp->if_u1.if_data;
 	sfe = &sf->list[0];
 	for (i = 0; i < sf->hdr.count;
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 8c93ee1b751286..854f313749b638 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -803,7 +803,6 @@ xfs_bmap_local_to_extents_empty(
 	ASSERT(ifp->if_nextents == 0);
 
 	xfs_bmap_forkoff_reset(ip, whichfork);
-	ifp->if_flags &= ~XFS_IFINLINE;
 	ifp->if_flags |= XFS_IFEXTENTS;
 	ifp->if_u1.if_root = NULL;
 	ifp->if_height = 0;
@@ -848,7 +847,7 @@ xfs_bmap_local_to_extents(
 
 	flags = 0;
 	error = 0;
-	ASSERT((ifp->if_flags & (XFS_IFINLINE|XFS_IFEXTENTS)) == XFS_IFINLINE);
+	ASSERT(!(ifp->if_flags & XFS_IFEXTENTS));
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = ip->i_mount;
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 5b59d3f7746b34..7e1df0c13fa74b 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -1096,7 +1096,7 @@ xfs_dir2_sf_to_block(
 
 	trace_xfs_dir2_sf_to_block(args);
 
-	ASSERT(ifp->if_flags & XFS_IFINLINE);
+	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
 	ASSERT(dp->i_d.di_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
 
 	oldsfp = (xfs_dir2_sf_hdr_t *)ifp->if_u1.if_data;
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 8c4f76bba88be1..e8a53a68625eaf 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -378,7 +378,7 @@ xfs_dir2_sf_addname(
 
 	ASSERT(xfs_dir2_sf_lookup(args) == -ENOENT);
 	dp = args->dp;
-	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
+	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
 	ASSERT(dp->i_d.di_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
@@ -830,9 +830,8 @@ xfs_dir2_sf_create(
 		dp->i_df.if_flags &= ~XFS_IFEXTENTS;	/* just in case */
 		dp->i_df.if_format = XFS_DINODE_FMT_LOCAL;
 		xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
-		dp->i_df.if_flags |= XFS_IFINLINE;
 	}
-	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
+	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
 	ASSERT(dp->i_df.if_bytes == 0);
 	i8count = pino > XFS_DIR2_MAX_SHORT_INUM;
 	size = xfs_dir2_sf_hdr_size(i8count);
@@ -877,7 +876,7 @@ xfs_dir2_sf_lookup(
 
 	xfs_dir2_sf_check(args);
 
-	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
+	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
 	ASSERT(dp->i_d.di_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
@@ -954,7 +953,7 @@ xfs_dir2_sf_removename(
 
 	trace_xfs_dir2_sf_removename(args);
 
-	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
+	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
 	oldsize = (int)dp->i_d.di_size;
 	ASSERT(oldsize >= offsetof(struct xfs_dir2_sf_hdr, parent));
 	ASSERT(dp->i_df.if_bytes == oldsize);
@@ -1053,7 +1052,7 @@ xfs_dir2_sf_replace(
 
 	trace_xfs_dir2_sf_replace(args);
 
-	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
+	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
 	ASSERT(dp->i_d.di_size >= offsetof(struct xfs_dir2_sf_hdr, parent));
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 4389a00d103359..5d7d3bddd9a083 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -61,7 +61,6 @@ xfs_init_local_fork(
 
 	ifp->if_bytes = size;
 	ifp->if_flags &= ~XFS_IFEXTENTS;
-	ifp->if_flags |= XFS_IFINLINE;
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 745eae58325791..5f10377cdd6c36 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -30,7 +30,6 @@ struct xfs_ifork {
 /*
  * Per-fork incore inode flags.
  */
-#define	XFS_IFINLINE	0x01	/* Inline data is read in */
 #define	XFS_IFEXTENTS	0x02	/* All extent pointers are read in */
 
 /*
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index c08be5ede0661a..436e2a3a27ef3d 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -52,7 +52,7 @@ xchk_symlink(
 	}
 
 	/* Inline symlink? */
-	if (ifp->if_flags & XFS_IFINLINE) {
+	if (ifp->if_format == XFS_DINODE_FMT_LOCAL) {
 		if (len > XFS_IFORK_DSIZE(ip) ||
 		    len > strnlen(ifp->if_u1.if_data, XFS_IFORK_DSIZE(ip)))
 			xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, 0);
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 477df4869d19bd..1756ed55ff0595 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -57,7 +57,7 @@ xfs_dir2_sf_getdents(
 	xfs_ino_t		ino;
 	struct xfs_da_geometry	*geo = args->geo;
 
-	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
+	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
 	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
 
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index 5b8ac9b6cef8e7..934e205935c116 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -519,7 +519,7 @@ xfs_vn_get_link_inline(
 	struct xfs_inode	*ip = XFS_I(inode);
 	char			*link;
 
-	ASSERT(ip->i_df.if_flags & XFS_IFINLINE);
+	ASSERT(dp->i_df.if_format == XFS_DINODE_FMT_LOCAL);
 
 	/*
 	 * The VFS crashes on a NULL pointer, so return -EFSCORRUPTED if
@@ -1402,7 +1402,7 @@ xfs_setup_iops(
 		inode->i_fop = &xfs_dir_file_operations;
 		break;
 	case S_IFLNK:
-		if (ip->i_df.if_flags & XFS_IFINLINE)
+		if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL)
 			inode->i_op = &xfs_inline_symlink_inode_operations;
 		else
 			inode->i_op = &xfs_symlink_inode_operations;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index db9c400f92584b..7b443dab47727c 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -104,7 +104,7 @@ xfs_readlink(
 
 	trace_xfs_readlink(ip);
 
-	ASSERT(!(ip->i_df.if_flags & XFS_IFINLINE));
+	ASSERT(dp->i_df.if_format != XFS_DINODE_FMT_LOCAL);
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
@@ -492,7 +492,7 @@ xfs_inactive_symlink(
 	 * Inline fork state gets removed by xfs_difree() so we have nothing to
 	 * do here in that case.
 	 */
-	if (ip->i_df.if_flags & XFS_IFINLINE) {
+	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
 		xfs_iunlock(ip, XFS_ILOCK_EXCL);
 		return 0;
 	}
-- 
2.30.1

