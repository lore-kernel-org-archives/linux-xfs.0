Return-Path: <SRS0=ZB14=6Y=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 386B3C54E8B
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:24:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 000AA218AC
	for <linux-xfs@archiver.kernel.org>; Sun, 10 May 2020 07:24:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="B3/ty761"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728424AbgEJHYW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 10 May 2020 03:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725810AbgEJHYV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 10 May 2020 03:24:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4841CC061A0C
        for <linux-xfs@vger.kernel.org>; Sun, 10 May 2020 00:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=Hp3TX1HEh9zSfZynFgDoc4B6xl15PbialwbINjmeZS4=; b=B3/ty761ijWmt4Eg7bxajkep8L
        rKGLl+uSpQKTJyYOxQvoYd7F43xdozAqJ8eMt06Gk64kD+jUIEl2N9BfXukmHnGw+Thx1l2HLbCYi
        +kSfqdTufmR42vM0ADv11ZmtDpNYS9zUZhLF+b8wLdxHhvqzXzOGrm0P9EPiSI17NNsXtim+0kaDm
        OeKbc15g0t2R/QhVD5ueR3Va4iyZ7TT15zra68ni6Hah141F7THEFssJ7e7iNO4L4XmgDCxOuXQJh
        ffTYLDCkFfSdI3+qSZ4Le6FIEGsO/iV4ygwNN8dBtu12oq3bKOSqU3Rnnt++D3NmiU4WqUpy1L2Z5
        j2bO3+cw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXgJw-0004w5-JB
        for linux-xfs@vger.kernel.org; Sun, 10 May 2020 07:24:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/6] xfs: move the fork format fields into struct xfs_ifork
Date:   Sun, 10 May 2020 09:24:03 +0200
Message-Id: <20200510072404.986627-6-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200510072404.986627-1-hch@lst.de>
References: <20200510072404.986627-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Both the data and attr fork have a format that is stored in the legacy
idinode.  Move it into the xfs_ifork structure instead, where it uses
up padding.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c           |  12 +--
 fs/xfs/libxfs/xfs_attr_leaf.c      |  32 ++++----
 fs/xfs/libxfs/xfs_bmap.c           | 120 +++++++++++++----------------
 fs/xfs/libxfs/xfs_bmap_btree.c     |   5 +-
 fs/xfs/libxfs/xfs_dir2.c           |   8 +-
 fs/xfs/libxfs/xfs_dir2_sf.c        |  13 ++--
 fs/xfs/libxfs/xfs_inode_buf.c      |   6 +-
 fs/xfs/libxfs/xfs_inode_buf.h      |   2 -
 fs/xfs/libxfs/xfs_inode_fork.c     |  14 ++--
 fs/xfs/libxfs/xfs_inode_fork.h     |  28 ++++---
 fs/xfs/libxfs/xfs_symlink_remote.c |  16 ++--
 fs/xfs/scrub/bmap.c                |   4 +-
 fs/xfs/scrub/dabtree.c             |   2 +-
 fs/xfs/scrub/dir.c                 |   7 +-
 fs/xfs/xfs_aops.c                  |   2 +-
 fs/xfs/xfs_attr_inactive.c         |   2 +-
 fs/xfs/xfs_attr_list.c             |   4 +-
 fs/xfs/xfs_bmap_util.c             |  56 +++++++-------
 fs/xfs/xfs_dir2_readdir.c          |   2 +-
 fs/xfs/xfs_icache.c                |   1 -
 fs/xfs/xfs_inode.c                 |  36 ++++-----
 fs/xfs/xfs_inode.h                 |   2 -
 fs/xfs/xfs_inode_item.c            |  12 +--
 fs/xfs/xfs_iomap.c                 |   4 +-
 fs/xfs/xfs_itable.c                |   2 +-
 fs/xfs/xfs_symlink.c               |   2 +-
 fs/xfs/xfs_trace.h                 |   2 +-
 27 files changed, 181 insertions(+), 215 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 1b01675e9c80b..3b1bd6e112f89 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -61,7 +61,7 @@ xfs_inode_hasattr(
 	struct xfs_inode	*ip)
 {
 	if (!XFS_IFORK_Q(ip) ||
-	    (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
+	    (ip->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
 	     ip->i_afp->if_nextents == 0))
 		return 0;
 	return 1;
@@ -84,7 +84,7 @@ xfs_attr_get_ilocked(
 	if (!xfs_inode_hasattr(args->dp))
 		return -ENOATTR;
 
-	if (args->dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
+	if (args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_attr_shortform_getvalue(args);
 	if (xfs_bmap_one_block(args->dp, XFS_ATTR_FORK))
 		return xfs_attr_leaf_get(args);
@@ -212,14 +212,14 @@ xfs_attr_set_args(
 	 * If the attribute list is non-existent or a shortform list,
 	 * upgrade it to a single-leaf-block attribute list.
 	 */
-	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
-	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
+	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL ||
+	    (dp->i_afp->if_format == XFS_DINODE_FMT_EXTENTS &&
 	     dp->i_afp->if_nextents == 0)) {
 
 		/*
 		 * Build initial attribute list (if required).
 		 */
-		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
+		if (dp->i_afp->if_format == XFS_DINODE_FMT_EXTENTS)
 			xfs_attr_shortform_create(args);
 
 		/*
@@ -272,7 +272,7 @@ xfs_attr_remove_args(
 
 	if (!xfs_inode_hasattr(dp)) {
 		error = -ENOATTR;
-	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
 		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
 		error = xfs_attr_shortform_remove(args);
 	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index 64b172180c42c..d7f3173ce3c31 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -539,7 +539,7 @@ xfs_attr_shortform_bytesfit(
 	/* rounded down */
 	offset = (XFS_LITINO(mp) - bytes) >> 3;
 
-	if (dp->i_d.di_format == XFS_DINODE_FMT_DEV) {
+	if (dp->i_df.if_format == XFS_DINODE_FMT_DEV) {
 		minforkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
 		return (offset >= minforkoff) ? minforkoff : 0;
 	}
@@ -567,7 +567,7 @@ xfs_attr_shortform_bytesfit(
 
 	dsize = dp->i_df.if_bytes;
 
-	switch (dp->i_d.di_format) {
+	switch (dp->i_df.if_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		/*
 		 * If there is no attr fork and the data fork is extents, 
@@ -636,22 +636,19 @@ xfs_sbversion_add_attr2(xfs_mount_t *mp, xfs_trans_t *tp)
  * Create the initial contents of a shortform attribute list.
  */
 void
-xfs_attr_shortform_create(xfs_da_args_t *args)
+xfs_attr_shortform_create(
+	struct xfs_da_args	*args)
 {
-	xfs_attr_sf_hdr_t *hdr;
-	xfs_inode_t *dp;
-	struct xfs_ifork *ifp;
+	struct xfs_inode	*dp = args->dp;
+	struct xfs_ifork	*ifp = dp->i_afp;
+	struct xfs_attr_sf_hdr	*hdr;
 
 	trace_xfs_attr_sf_create(args);
 
-	dp = args->dp;
-	ASSERT(dp != NULL);
-	ifp = dp->i_afp;
-	ASSERT(ifp != NULL);
 	ASSERT(ifp->if_bytes == 0);
-	if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS) {
+	if (ifp->if_format == XFS_DINODE_FMT_EXTENTS) {
 		ifp->if_flags &= ~XFS_IFEXTENTS;	/* just in case */
-		dp->i_d.di_aformat = XFS_DINODE_FMT_LOCAL;
+		ifp->if_format = XFS_DINODE_FMT_LOCAL;
 		ifp->if_flags |= XFS_IFINLINE;
 	} else {
 		ASSERT(ifp->if_flags & XFS_IFINLINE);
@@ -721,7 +718,6 @@ xfs_attr_fork_remove(
 {
 	xfs_idestroy_fork(ip, XFS_ATTR_FORK);
 	ip->i_d.di_forkoff = 0;
-	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
 	ASSERT(ip->i_afp == NULL);
 
@@ -774,7 +770,7 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
 	totsize -= size;
 	if (totsize == sizeof(xfs_attr_sf_hdr_t) &&
 	    (mp->m_flags & XFS_MOUNT_ATTR2) &&
-	    (dp->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
+	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
 	    !(args->op_flags & XFS_DA_OP_ADDNAME)) {
 		xfs_attr_fork_remove(dp, args->trans);
 	} else {
@@ -784,7 +780,7 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
 		ASSERT(totsize > sizeof(xfs_attr_sf_hdr_t) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
 				!(mp->m_flags & XFS_MOUNT_ATTR2) ||
-				dp->i_d.di_format == XFS_DINODE_FMT_BTREE);
+				dp->i_df.if_format == XFS_DINODE_FMT_BTREE);
 		xfs_trans_log_inode(args->trans, dp,
 					XFS_ILOG_CORE | XFS_ILOG_ADATA);
 	}
@@ -961,7 +957,7 @@ xfs_attr_shortform_allfit(
 				+ be16_to_cpu(name_loc->valuelen);
 	}
 	if ((dp->i_mount->m_flags & XFS_MOUNT_ATTR2) &&
-	    (dp->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
+	    (dp->i_df.if_format != XFS_DINODE_FMT_BTREE) &&
 	    (bytes == sizeof(struct xfs_attr_sf_hdr)))
 		return -1;
 	return xfs_attr_shortform_bytesfit(dp, bytes);
@@ -980,7 +976,7 @@ xfs_attr_shortform_verify(
 	int				i;
 	int64_t				size;
 
-	ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL);
+	ASSERT(ip->i_afp->if_format == XFS_DINODE_FMT_LOCAL);
 	ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
 	sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	size = ifp->if_bytes;
@@ -1084,7 +1080,7 @@ xfs_attr3_leaf_to_shortform(
 
 	if (forkoff == -1) {
 		ASSERT(dp->i_mount->m_flags & XFS_MOUNT_ATTR2);
-		ASSERT(dp->i_d.di_format != XFS_DINODE_FMT_BTREE);
+		ASSERT(dp->i_df.if_format != XFS_DINODE_FMT_BTREE);
 		xfs_attr_fork_remove(dp, args->trans);
 		goto out;
 	}
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index c1136be49abeb..edc63dba007f4 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -123,7 +123,7 @@ static inline bool xfs_bmap_needs_btree(struct xfs_inode *ip, int whichfork)
 	struct xfs_ifork *ifp = XFS_IFORK_PTR(ip, whichfork);
 
 	return whichfork != XFS_COW_FORK &&
-		XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
+		ifp->if_format == XFS_DINODE_FMT_EXTENTS &&
 		ifp->if_nextents > XFS_IFORK_MAXEXT(ip, whichfork);
 }
 
@@ -135,7 +135,7 @@ static inline bool xfs_bmap_wants_extents(struct xfs_inode *ip, int whichfork)
 	struct xfs_ifork *ifp = XFS_IFORK_PTR(ip, whichfork);
 
 	return whichfork != XFS_COW_FORK &&
-		XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE &&
+		ifp->if_format == XFS_DINODE_FMT_BTREE &&
 		ifp->if_nextents <= XFS_IFORK_MAXEXT(ip, whichfork);
 }
 
@@ -215,8 +215,8 @@ xfs_bmap_forkoff_reset(
 	int		whichfork)
 {
 	if (whichfork == XFS_ATTR_FORK &&
-	    ip->i_d.di_format != XFS_DINODE_FMT_DEV &&
-	    ip->i_d.di_format != XFS_DINODE_FMT_BTREE) {
+	    ip->i_df.if_format != XFS_DINODE_FMT_DEV &&
+	    ip->i_df.if_format != XFS_DINODE_FMT_BTREE) {
 		uint	dfl_forkoff = xfs_default_attroffset(ip) >> 3;
 
 		if (dfl_forkoff > ip->i_d.di_forkoff)
@@ -317,31 +317,28 @@ xfs_bmap_check_leaf_extents(
 	xfs_inode_t		*ip,		/* incore inode pointer */
 	int			whichfork)	/* data or attr fork */
 {
+	struct xfs_mount	*mp = ip->i_mount;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_btree_block	*block;	/* current btree block */
 	xfs_fsblock_t		bno;	/* block # of "block" */
 	xfs_buf_t		*bp;	/* buffer for "block" */
 	int			error;	/* error return value */
 	xfs_extnum_t		i=0, j;	/* index into the extents list */
-	struct xfs_ifork	*ifp;	/* fork structure */
 	int			level;	/* btree level, for checking */
-	xfs_mount_t		*mp;	/* file system mount structure */
 	__be64			*pp;	/* pointer to block address */
 	xfs_bmbt_rec_t		*ep;	/* pointer to current extent */
 	xfs_bmbt_rec_t		last = {0, 0}; /* last extent in prev block */
 	xfs_bmbt_rec_t		*nextp;	/* pointer to next extent */
 	int			bp_release = 0;
 
-	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE) {
+	if (ifp->if_format != XFS_DINODE_FMT_BTREE)
 		return;
-	}
 
 	/* skip large extent count inodes */
 	if (ip->i_df.if_nextents > 10000)
 		return;
 
 	bno = NULLFSBLOCK;
-	mp = ip->i_mount;
-	ifp = XFS_IFORK_PTR(ip, whichfork);
 	block = ifp->if_broot;
 	/*
 	 * Root level must use BMAP_BROOT_PTR_ADDR macro to get ptr out.
@@ -606,7 +603,7 @@ xfs_bmap_btree_to_extents(
 	ASSERT(cur);
 	ASSERT(whichfork != XFS_COW_FORK);
 	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
-	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE);
+	ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
 	ASSERT(be16_to_cpu(rblock->bb_level) == 1);
 	ASSERT(be16_to_cpu(rblock->bb_numrecs) == 1);
 	ASSERT(xfs_bmbt_maxrecs(mp, ifp->if_broot_bytes, 0) == 1);
@@ -634,7 +631,7 @@ xfs_bmap_btree_to_extents(
 	xfs_iroot_realloc(ip, -1, whichfork);
 	ASSERT(ifp->if_broot == NULL);
 	ASSERT((ifp->if_flags & XFS_IFBROOT) == 0);
-	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
+	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	*logflagsp |= XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 	return 0;
 }
@@ -670,7 +667,7 @@ xfs_bmap_extents_to_btree(
 	mp = ip->i_mount;
 	ASSERT(whichfork != XFS_COW_FORK);
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS);
+	ASSERT(ifp->if_format == XFS_DINODE_FMT_EXTENTS);
 
 	/*
 	 * Make space in the inode incore. This needs to be undone if we fail
@@ -694,7 +691,7 @@ xfs_bmap_extents_to_btree(
 	/*
 	 * Convert to a btree with two levels, one record in root.
 	 */
-	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_BTREE);
+	ifp->if_format = XFS_DINODE_FMT_BTREE;
 	memset(&args, 0, sizeof(args));
 	args.tp = tp;
 	args.mp = mp;
@@ -780,7 +777,7 @@ xfs_bmap_extents_to_btree(
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 out_root_realloc:
 	xfs_iroot_realloc(ip, -1, whichfork);
-	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
+	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	ASSERT(ifp->if_broot == NULL);
 	xfs_btree_del_cursor(cur, XFS_BTREE_ERROR);
 
@@ -802,7 +799,7 @@ xfs_bmap_local_to_extents_empty(
 	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 
 	ASSERT(whichfork != XFS_COW_FORK);
-	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL);
+	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
 	ASSERT(ifp->if_bytes == 0);
 	ASSERT(ifp->if_nextents == 0);
 
@@ -811,7 +808,7 @@ xfs_bmap_local_to_extents_empty(
 	ifp->if_flags |= XFS_IFEXTENTS;
 	ifp->if_u1.if_root = NULL;
 	ifp->if_height = 0;
-	XFS_IFORK_FMT_SET(ip, whichfork, XFS_DINODE_FMT_EXTENTS);
+	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
 
@@ -842,7 +839,7 @@ xfs_bmap_local_to_extents(
 	 */
 	ASSERT(!(S_ISREG(VFS_I(ip)->i_mode) && whichfork == XFS_DATA_FORK));
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL);
+	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
 
 	if (!ifp->if_bytes) {
 		xfs_bmap_local_to_extents_empty(tp, ip, whichfork);
@@ -1036,7 +1033,7 @@ xfs_bmap_set_attrforkoff(
 	int			size,
 	int			*version)
 {
-	switch (ip->i_d.di_format) {
+	switch (ip->i_df.if_format) {
 	case XFS_DINODE_FMT_DEV:
 		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
 		break;
@@ -1094,13 +1091,6 @@ xfs_bmap_add_attrfork(
 		goto trans_cancel;
 	if (XFS_IFORK_Q(ip))
 		goto trans_cancel;
-	if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS) {
-		/*
-		 * For inodes coming from pre-6.2 filesystems.
-		 */
-		ASSERT(ip->i_d.di_aformat == 0);
-		ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
-	}
 
 	xfs_trans_ijoin(tp, ip, 0);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
@@ -1109,9 +1099,10 @@ xfs_bmap_add_attrfork(
 		goto trans_cancel;
 	ASSERT(ip->i_afp == NULL);
 	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, 0);
+	ip->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_afp->if_flags = XFS_IFEXTENTS;
 	logflags = 0;
-	switch (ip->i_d.di_format) {
+	switch (ip->i_df.if_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		error = xfs_bmap_add_attrfork_local(tp, ip, &logflags);
 		break;
@@ -1237,9 +1228,7 @@ xfs_iread_extents(
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
-	if (XFS_IS_CORRUPT(mp,
-			   XFS_IFORK_FORMAT(ip, whichfork) !=
-			   XFS_DINODE_FMT_BTREE)) {
+	if (XFS_IS_CORRUPT(mp, ifp->if_format != XFS_DINODE_FMT_BTREE)) {
 		error = -EFSCORRUPTED;
 		goto out;
 	}
@@ -1287,14 +1276,13 @@ xfs_bmap_first_unused(
 	xfs_fileoff_t		lowest, max;
 	int			error;
 
-	ASSERT(xfs_ifork_has_extents(ip, whichfork) ||
-	       XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL);
-
-	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
+	if (ifp->if_format == XFS_DINODE_FMT_LOCAL) {
 		*first_unused = 0;
 		return 0;
 	}
 
+	ASSERT(xfs_ifork_has_extents(ifp));
+
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		error = xfs_iread_extents(tp, ip, whichfork);
 		if (error)
@@ -1335,7 +1323,7 @@ xfs_bmap_last_before(
 	struct xfs_iext_cursor	icur;
 	int			error;
 
-	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
+	switch (ifp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		*last_block = 0;
 		return 0;
@@ -1434,16 +1422,17 @@ xfs_bmap_last_offset(
 	xfs_fileoff_t		*last_block,
 	int			whichfork)
 {
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_bmbt_irec	rec;
 	int			is_empty;
 	int			error;
 
 	*last_block = 0;
 
-	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL)
+	if (ifp->if_format == XFS_DINODE_FMT_LOCAL)
 		return 0;
 
-	if (XFS_IS_CORRUPT(ip->i_mount, !xfs_ifork_has_extents(ip, whichfork)))
+	if (XFS_IS_CORRUPT(ip->i_mount, !xfs_ifork_has_extents(ifp)))
 		return -EFSCORRUPTED;
 
 	error = xfs_bmap_last_extent(NULL, ip, whichfork, &rec, &is_empty);
@@ -1475,7 +1464,7 @@ xfs_bmap_one_block(
 #endif	/* !DEBUG */
 	if (ifp->if_nextents != 1)
 		return 0;
-	if (XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
+	if (ifp->if_format != XFS_DINODE_FMT_EXTENTS)
 		return 0;
 	ASSERT(ifp->if_flags & XFS_IFEXTENTS);
 	xfs_iext_first(ifp, &icur);
@@ -3895,10 +3884,9 @@ xfs_bmapi_read(
 	if (WARN_ON_ONCE(!ifp))
 		return -EFSCORRUPTED;
 
-	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
-	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
+	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
+	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT))
 		return -EFSCORRUPTED;
-	}
 
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
@@ -4281,11 +4269,13 @@ xfs_bmapi_minleft(
 	struct xfs_inode	*ip,
 	int			fork)
 {
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, fork);
+
 	if (tp && tp->t_firstblock != NULLFSBLOCK)
 		return 0;
-	if (XFS_IFORK_FORMAT(ip, fork) != XFS_DINODE_FMT_BTREE)
+	if (ifp->if_format != XFS_DINODE_FMT_BTREE)
 		return 1;
-	return be16_to_cpu(XFS_IFORK_PTR(ip, fork)->if_broot->bb_level) + 1;
+	return be16_to_cpu(ifp->if_broot->bb_level) + 1;
 }
 
 /*
@@ -4300,11 +4290,13 @@ xfs_bmapi_finish(
 	int			whichfork,
 	int			error)
 {
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(bma->ip, whichfork);
+
 	if ((bma->logflags & xfs_ilog_fext(whichfork)) &&
-	    XFS_IFORK_FORMAT(bma->ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
+	    ifp->if_format != XFS_DINODE_FMT_EXTENTS)
 		bma->logflags &= ~xfs_ilog_fext(whichfork);
 	else if ((bma->logflags & xfs_ilog_fbroot(whichfork)) &&
-		 XFS_IFORK_FORMAT(bma->ip, whichfork) != XFS_DINODE_FMT_BTREE)
+		 ifp->if_format != XFS_DINODE_FMT_BTREE)
 		bma->logflags &= ~xfs_ilog_fbroot(whichfork);
 
 	if (bma->logflags)
@@ -4336,13 +4328,13 @@ xfs_bmapi_write(
 		.total		= total,
 	};
 	struct xfs_mount	*mp = ip->i_mount;
-	struct xfs_ifork	*ifp;
+	int			whichfork = xfs_bmapi_whichfork(flags);
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, whichfork);
 	xfs_fileoff_t		end;		/* end of mapped file region */
 	bool			eof = false;	/* after the end of extents */
 	int			error;		/* error return */
 	int			n;		/* current extent index */
 	xfs_fileoff_t		obno;		/* old block number (offset) */
-	int			whichfork;	/* data or attr fork */
 
 #ifdef DEBUG
 	xfs_fileoff_t		orig_bno;	/* original block number value */
@@ -4357,13 +4349,12 @@ xfs_bmapi_write(
 	orig_mval = mval;
 	orig_nmap = *nmap;
 #endif
-	whichfork = xfs_bmapi_whichfork(flags);
 
 	ASSERT(*nmap >= 1);
 	ASSERT(*nmap <= XFS_BMAP_MAX_NMAP);
 	ASSERT(tp != NULL);
 	ASSERT(len > 0);
-	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_LOCAL);
+	ASSERT(ifp->if_format != XFS_DINODE_FMT_LOCAL);
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(!(flags & XFS_BMAPI_REMAP));
 
@@ -4379,7 +4370,7 @@ xfs_bmapi_write(
 	ASSERT((flags & (XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO)) !=
 			(XFS_BMAPI_PREALLOC | XFS_BMAPI_ZERO));
 
-	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
+	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		return -EFSCORRUPTED;
 	}
@@ -4387,8 +4378,6 @@ xfs_bmapi_write(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	ifp = XFS_IFORK_PTR(ip, whichfork);
-
 	XFS_STATS_INC(mp, xs_blk_mapw);
 
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
@@ -4498,7 +4487,7 @@ xfs_bmapi_write(
 	if (error)
 		goto error0;
 
-	ASSERT(XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE ||
+	ASSERT(ifp->if_format != XFS_DINODE_FMT_BTREE ||
 	       ifp->if_nextents > XFS_IFORK_MAXEXT(ip, whichfork));
 	xfs_bmapi_finish(&bma, whichfork, 0);
 	xfs_bmap_validate_ret(orig_bno, orig_len, orig_flags, orig_mval,
@@ -4645,7 +4634,7 @@ xfs_bmapi_remap(
 	ASSERT((flags & (XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC)) !=
 			(XFS_BMAPI_ATTRFORK | XFS_BMAPI_PREALLOC));
 
-	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
+	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		return -EFSCORRUPTED;
 	}
@@ -4689,9 +4678,9 @@ xfs_bmapi_remap(
 	error = xfs_bmap_btree_to_extents(tp, ip, cur, &logflags, whichfork);
 
 error0:
-	if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS)
+	if (ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS)
 		logflags &= ~XFS_ILOG_DEXT;
-	else if (ip->i_d.di_format != XFS_DINODE_FMT_BTREE)
+	else if (ip->i_df.if_format != XFS_DINODE_FMT_BTREE)
 		logflags &= ~XFS_ILOG_DBROOT;
 
 	if (logflags)
@@ -5041,7 +5030,7 @@ xfs_bmap_del_extent_real(
 	 * conversion to btree format, since the transaction will be dirty then.
 	 */
 	if (tp->t_blk_res == 0 &&
-	    XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_EXTENTS &&
+	    ifp->if_format == XFS_DINODE_FMT_EXTENTS &&
 	    ifp->if_nextents >= XFS_IFORK_MAXEXT(ip, whichfork) &&
 	    del->br_startoff > got.br_startoff && del_endoff < got_endoff)
 		return -ENOSPC;
@@ -5284,7 +5273,7 @@ __xfs_bunmapi(
 	whichfork = xfs_bmapi_whichfork(flags);
 	ASSERT(whichfork != XFS_COW_FORK);
 	ifp = XFS_IFORK_PTR(ip, whichfork);
-	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)))
+	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)))
 		return -EFSCORRUPTED;
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
@@ -5322,7 +5311,7 @@ __xfs_bunmapi(
 
 	logflags = 0;
 	if (ifp->if_flags & XFS_IFBROOT) {
-		ASSERT(XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_BTREE);
+		ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_ino.flags = 0;
 	} else
@@ -5567,10 +5556,10 @@ __xfs_bunmapi(
 	 * logging the extent records if we've converted to btree format.
 	 */
 	if ((logflags & xfs_ilog_fext(whichfork)) &&
-	    XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_EXTENTS)
+	    ifp->if_format != XFS_DINODE_FMT_EXTENTS)
 		logflags &= ~xfs_ilog_fext(whichfork);
 	else if ((logflags & xfs_ilog_fbroot(whichfork)) &&
-		 XFS_IFORK_FORMAT(ip, whichfork) != XFS_DINODE_FMT_BTREE)
+		 ifp->if_format != XFS_DINODE_FMT_BTREE)
 		logflags &= ~xfs_ilog_fbroot(whichfork);
 	/*
 	 * Log inode even in the error case, if the transaction
@@ -5781,7 +5770,7 @@ xfs_bmap_collapse_extents(
 	int			error = 0;
 	int			logflags = 0;
 
-	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
+	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		return -EFSCORRUPTED;
 	}
@@ -5898,7 +5887,7 @@ xfs_bmap_insert_extents(
 	int			error = 0;
 	int			logflags = 0;
 
-	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
+	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		return -EFSCORRUPTED;
 	}
@@ -5992,18 +5981,18 @@ xfs_bmap_split_extent(
 	xfs_fileoff_t		split_fsb)
 {
 	int				whichfork = XFS_DATA_FORK;
+	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, whichfork);
 	struct xfs_btree_cur		*cur = NULL;
 	struct xfs_bmbt_irec		got;
 	struct xfs_bmbt_irec		new; /* split extent */
 	struct xfs_mount		*mp = ip->i_mount;
-	struct xfs_ifork		*ifp;
 	xfs_fsblock_t			gotblkcnt; /* new block count for got */
 	struct xfs_iext_cursor		icur;
 	int				error = 0;
 	int				logflags = 0;
 	int				i = 0;
 
-	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
+	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ifp)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		return -EFSCORRUPTED;
 	}
@@ -6011,7 +6000,6 @@ xfs_bmap_split_extent(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		return -EIO;
 
-	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 		/* Read in all the extents */
 		error = xfs_iread_extents(tp, ip, whichfork);
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index 295a59cf88407..d9c63f17d2dec 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -636,10 +636,7 @@ xfs_bmbt_change_owner(
 
 	ASSERT(tp || buffer_list);
 	ASSERT(!(tp && buffer_list));
-	if (whichfork == XFS_DATA_FORK)
-		ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_BTREE);
-	else
-		ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_BTREE);
+	ASSERT(XFS_IFORK_PTR(ip, whichfork)->if_format == XFS_DINODE_FMT_BTREE);
 
 	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
 	if (!cur)
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index dd6fcaaea318a..612a9c5e41b1c 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -278,7 +278,7 @@ xfs_dir_createname(
 	if (!inum)
 		args->op_flags |= XFS_DA_OP_JUSTCHECK;
 
-	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_addname(args);
 		goto out_free;
 	}
@@ -373,7 +373,7 @@ xfs_dir_lookup(
 		args->op_flags |= XFS_DA_OP_CILOOKUP;
 
 	lock_mode = xfs_ilock_data_map_shared(dp);
-	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_lookup(args);
 		goto out_check_rval;
 	}
@@ -443,7 +443,7 @@ xfs_dir_removename(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 
-	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_removename(args);
 		goto out_free;
 	}
@@ -504,7 +504,7 @@ xfs_dir_replace(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 
-	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_replace(args);
 		goto out_free;
 	}
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 7b7f6fb2ea3b2..2463b5d734472 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -343,7 +343,7 @@ xfs_dir2_block_to_sf(
 	 */
 	ASSERT(dp->i_df.if_bytes == 0);
 	xfs_init_local_fork(dp, XFS_DATA_FORK, sfp, size);
-	dp->i_d.di_format = XFS_DINODE_FMT_LOCAL;
+	dp->i_df.if_format = XFS_DINODE_FMT_LOCAL;
 	dp->i_d.di_size = size;
 
 	logflags |= XFS_ILOG_DDATA;
@@ -710,11 +710,11 @@ xfs_dir2_sf_verify(
 	struct xfs_inode		*ip)
 {
 	struct xfs_mount		*mp = ip->i_mount;
+	struct xfs_ifork		*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	struct xfs_dir2_sf_hdr		*sfp;
 	struct xfs_dir2_sf_entry	*sfep;
 	struct xfs_dir2_sf_entry	*next_sfep;
 	char				*endp;
-	struct xfs_ifork		*ifp;
 	xfs_ino_t			ino;
 	int				i;
 	int				i8count;
@@ -723,9 +723,8 @@ xfs_dir2_sf_verify(
 	int				error;
 	uint8_t				filetype;
 
-	ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_LOCAL);
+	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
 
-	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	sfp = (struct xfs_dir2_sf_hdr *)ifp->if_u1.if_data;
 	size = ifp->if_bytes;
 
@@ -827,9 +826,9 @@ xfs_dir2_sf_create(
 	 * If it's currently a zero-length extent file,
 	 * convert it to local format.
 	 */
-	if (dp->i_d.di_format == XFS_DINODE_FMT_EXTENTS) {
+	if (dp->i_df.if_format == XFS_DINODE_FMT_EXTENTS) {
 		dp->i_df.if_flags &= ~XFS_IFEXTENTS;	/* just in case */
-		dp->i_d.di_format = XFS_DINODE_FMT_LOCAL;
+		dp->i_df.if_format = XFS_DINODE_FMT_LOCAL;
 		xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
 		dp->i_df.if_flags |= XFS_IFINLINE;
 	}
@@ -1027,7 +1026,7 @@ xfs_dir2_sf_replace_needblock(
 	int			newsize;
 	struct xfs_dir2_sf_hdr	*sfp;
 
-	if (dp->i_d.di_format != XFS_DINODE_FMT_LOCAL)
+	if (dp->i_df.if_format != XFS_DINODE_FMT_LOCAL)
 		return false;
 
 	sfp = (struct xfs_dir2_sf_hdr *)dp->i_df.if_u1.if_data;
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index a374e2a81e764..ab555671e1543 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -225,7 +225,6 @@ xfs_inode_from_disk(
 					be16_to_cpu(from->di_projid_lo);
 	}
 
-	to->di_format = from->di_format;
 	i_uid_write(inode, be32_to_cpu(from->di_uid));
 	i_gid_write(inode, be32_to_cpu(from->di_gid));
 
@@ -246,7 +245,6 @@ xfs_inode_from_disk(
 	to->di_nblocks = be64_to_cpu(from->di_nblocks);
 	to->di_extsize = be32_to_cpu(from->di_extsize);
 	to->di_forkoff = from->di_forkoff;
-	to->di_aformat	= from->di_aformat;
 	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
 	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
 	to->di_flags	= be16_to_cpu(from->di_flags);
@@ -289,7 +287,7 @@ xfs_inode_to_disk(
 	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 	to->di_onlink = 0;
 
-	to->di_format = from->di_format;
+	to->di_format = xfs_ifork_format(&ip->i_df);
 	to->di_uid = cpu_to_be32(i_uid_read(inode));
 	to->di_gid = cpu_to_be32(i_gid_read(inode));
 	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
@@ -312,7 +310,7 @@ xfs_inode_to_disk(
 	to->di_nextents = cpu_to_be32(xfs_ifork_nextents(&ip->i_df));
 	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
 	to->di_forkoff = from->di_forkoff;
-	to->di_aformat = from->di_aformat;
+	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
 	to->di_dmstate = cpu_to_be16(from->di_dmstate);
 	to->di_flags = cpu_to_be16(from->di_flags);
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index fecccfb26463c..865ac493c72a2 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -16,14 +16,12 @@ struct xfs_dinode;
  * format specific structures at the appropriate time.
  */
 struct xfs_icdinode {
-	int8_t		di_format;	/* format of di_c data */
 	uint16_t	di_flushiter;	/* incremented on flush */
 	uint32_t	di_projid;	/* owner's project id */
 	xfs_fsize_t	di_size;	/* number of bytes in file */
 	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
 	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
 	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
-	int8_t		di_aformat;	/* format of attr fork's data */
 	uint32_t	di_dmevmask;	/* DMIG event mask */
 	uint16_t	di_dmstate;	/* DMIG state info */
 	uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 195da3552c5b5..6562f2bcd15cc 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -228,6 +228,7 @@ xfs_iformat_data_fork(
 	struct inode		*inode = VFS_I(ip);
 	int			error;
 
+	ip->i_df.if_format = dip->di_format;
 	ip->i_df.if_nextents = be32_to_cpu(dip->di_nextents);
 
 	switch (inode->i_mode & S_IFMT) {
@@ -241,7 +242,7 @@ xfs_iformat_data_fork(
 	case S_IFREG:
 	case S_IFLNK:
 	case S_IFDIR:
-		switch (dip->di_format) {
+		switch (ip->i_df.if_format) {
 		case XFS_DINODE_FMT_LOCAL:
 			error = xfs_iformat_local(ip, dip, XFS_DATA_FORK,
 					be64_to_cpu(dip->di_size));
@@ -283,9 +284,12 @@ xfs_iformat_attr_fork(
 	int			error = 0;
 
 	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, KM_NOFS);
+	ip->i_afp->if_format = dip->di_aformat;
+	if (unlikely(ip->i_afp->if_format == 0)) /* pre IRIX 6.2 file system */
+		ip->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
 	ip->i_afp->if_nextents = be16_to_cpu(dip->di_anextents);
 
-	switch (dip->di_aformat) {
+	switch (ip->i_afp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		error = xfs_iformat_local(ip, dip, XFS_ATTR_FORK,
 				xfs_dfork_attr_shortform_size(dip));
@@ -508,7 +512,7 @@ xfs_idestroy_fork(
 	 * not local then we may or may not have an extents list,
 	 * so check and free it up if we do.
 	 */
-	if (XFS_IFORK_FORMAT(ip, whichfork) == XFS_DINODE_FMT_LOCAL) {
+	if (ifp->if_format == XFS_DINODE_FMT_LOCAL) {
 		if (ifp->if_u1.if_data != NULL) {
 			kmem_free(ifp->if_u1.if_data);
 			ifp->if_u1.if_data = NULL;
@@ -605,7 +609,7 @@ xfs_iflush_fork(
 	}
 	cp = XFS_DFORK_PTR(dip, whichfork);
 	mp = ip->i_mount;
-	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
+	switch (ifp->if_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		if ((iip->ili_fields & dataflag[whichfork]) &&
 		    (ifp->if_bytes > 0)) {
@@ -678,7 +682,7 @@ xfs_ifork_init_cow(
 	ip->i_cowfp = kmem_zone_zalloc(xfs_ifork_zone,
 				       KM_NOFS);
 	ip->i_cowfp->if_flags = XFS_IFEXTENTS;
-	ip->i_cformat = XFS_DINODE_FMT_EXTENTS;
+	ip->i_cowfp->if_format = XFS_DINODE_FMT_EXTENTS;
 }
 
 /* Verify the inline contents of the data fork of an inode. */
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index a69d425fe68df..d849cca103edd 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -23,6 +23,7 @@ struct xfs_ifork {
 	} if_u1;
 	short			if_broot_bytes;	/* bytes allocated for root */
 	unsigned char		if_flags;	/* per-fork flags */
+	int8_t			if_format;	/* format of this fork */
 	xfs_extnum_t		if_nextents;	/* # of extents in this fork */
 };
 
@@ -56,24 +57,14 @@ struct xfs_ifork {
 		((w) == XFS_ATTR_FORK ? \
 			XFS_IFORK_ASIZE(ip) : \
 			0))
-#define XFS_IFORK_FORMAT(ip,w) \
-	((w) == XFS_DATA_FORK ? \
-		(ip)->i_d.di_format : \
-		((w) == XFS_ATTR_FORK ? \
-			(ip)->i_d.di_aformat : \
-			(ip)->i_cformat))
-#define XFS_IFORK_FMT_SET(ip,w,n) \
-	((w) == XFS_DATA_FORK ? \
-		((ip)->i_d.di_format = (n)) : \
-		((w) == XFS_ATTR_FORK ? \
-			((ip)->i_d.di_aformat = (n)) : \
-			((ip)->i_cformat = (n))))
 #define XFS_IFORK_MAXEXT(ip, w) \
 	(XFS_IFORK_SIZE(ip, w) / sizeof(xfs_bmbt_rec_t))
 
-#define xfs_ifork_has_extents(ip, w) \
-	(XFS_IFORK_FORMAT((ip), (w)) == XFS_DINODE_FMT_EXTENTS || \
-	 XFS_IFORK_FORMAT((ip), (w)) == XFS_DINODE_FMT_BTREE)
+static inline bool xfs_ifork_has_extents(struct xfs_ifork *ifp)
+{
+	return ifp->if_format == XFS_DINODE_FMT_EXTENTS ||
+		ifp->if_format == XFS_DINODE_FMT_BTREE;
+}
 
 static inline xfs_extnum_t xfs_ifork_nextents(struct xfs_ifork *ifp)
 {
@@ -82,6 +73,13 @@ static inline xfs_extnum_t xfs_ifork_nextents(struct xfs_ifork *ifp)
 	return ifp->if_nextents;
 }
 
+static inline int8_t xfs_ifork_format(struct xfs_ifork *ifp)
+{
+	if (!ifp)
+		return XFS_DINODE_FMT_EXTENTS;
+	return ifp->if_format;
+}
+
 struct xfs_ifork *xfs_iext_state_to_fork(struct xfs_inode *ip, int state);
 
 int		xfs_iformat_data_fork(struct xfs_inode *, struct xfs_dinode *);
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 3b8260ca7d1b8..594bc447a7dd2 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -204,16 +204,12 @@ xfs_failaddr_t
 xfs_symlink_shortform_verify(
 	struct xfs_inode	*ip)
 {
-	char			*sfp;
-	char			*endp;
-	struct xfs_ifork	*ifp;
-	int			size;
-
-	ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_LOCAL);
-	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-	sfp = (char *)ifp->if_u1.if_data;
-	size = ifp->if_bytes;
-	endp = sfp + size;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
+	char			*sfp = (char *)ifp->if_u1.if_data;
+	int			size = ifp->if_bytes;
+	char			*endp = sfp + size;
+
+	ASSERT(ifp->if_format == XFS_DINODE_FMT_LOCAL);
 
 	/*
 	 * Zero length symlinks should never occur in memory as they are
diff --git a/fs/xfs/scrub/bmap.c b/fs/xfs/scrub/bmap.c
index 157f72efec5e9..dfa1533b4edfc 100644
--- a/fs/xfs/scrub/bmap.c
+++ b/fs/xfs/scrub/bmap.c
@@ -598,7 +598,7 @@ xchk_bmap_check_rmaps(
 		size = 0;
 		break;
 	}
-	if (XFS_IFORK_FORMAT(sc->ip, whichfork) != XFS_DINODE_FMT_BTREE &&
+	if (ifp->if_format != XFS_DINODE_FMT_BTREE &&
 	    (size == 0 || ifp->if_nextents > 0))
 		return 0;
 
@@ -664,7 +664,7 @@ xchk_bmap(
 	}
 
 	/* Check the fork values */
-	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
+	switch (ifp->if_format) {
 	case XFS_DINODE_FMT_UUID:
 	case XFS_DINODE_FMT_DEV:
 	case XFS_DINODE_FMT_LOCAL:
diff --git a/fs/xfs/scrub/dabtree.c b/fs/xfs/scrub/dabtree.c
index 9a2e27ac13003..44b15015021f3 100644
--- a/fs/xfs/scrub/dabtree.c
+++ b/fs/xfs/scrub/dabtree.c
@@ -468,7 +468,7 @@ xchk_da_btree(
 	int				error;
 
 	/* Skip short format data structures; no btree to scan. */
-	if (!xfs_ifork_has_extents(sc->ip, whichfork))
+	if (!xfs_ifork_has_extents(XFS_IFORK_PTR(sc->ip, whichfork)))
 		return 0;
 
 	/* Set up initial da state. */
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index fe2a6e030c8a0..7c432997edade 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -635,7 +635,7 @@ xchk_directory_blocks(
 {
 	struct xfs_bmbt_irec	got;
 	struct xfs_da_args	args;
-	struct xfs_ifork	*ifp;
+	struct xfs_ifork	*ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
 	struct xfs_mount	*mp = sc->mp;
 	xfs_fileoff_t		leaf_lblk;
 	xfs_fileoff_t		free_lblk;
@@ -647,11 +647,10 @@ xchk_directory_blocks(
 	int			error;
 
 	/* Ignore local format directories. */
-	if (sc->ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
-	    sc->ip->i_d.di_format != XFS_DINODE_FMT_BTREE)
+	if (ifp->if_format != XFS_DINODE_FMT_EXTENTS &&
+	    ifp->if_format != XFS_DINODE_FMT_BTREE)
 		return 0;
 
-	ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
 	lblk = XFS_B_TO_FSB(mp, XFS_DIR2_DATA_OFFSET);
 	leaf_lblk = XFS_B_TO_FSB(mp, XFS_DIR2_LEAF_OFFSET);
 	free_lblk = XFS_B_TO_FSB(mp, XFS_DIR2_FREE_OFFSET);
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 9d9cebf187268..2834cbf1212e5 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -382,7 +382,7 @@ xfs_map_blocks(
 	 */
 retry:
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
+	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
 	       (ip->i_df.if_flags & XFS_IFEXTENTS));
 
 	/*
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index c42f90e16b4fa..00ffc46c0bf71 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -367,7 +367,7 @@ xfs_attr_inactive(
 	 * removal below.
 	 */
 	if (xfs_inode_hasattr(dp) &&
-	    dp->i_d.di_aformat != XFS_DINODE_FMT_LOCAL) {
+	    dp->i_afp->if_format != XFS_DINODE_FMT_LOCAL) {
 		error = xfs_attr3_root_inactive(&trans, dp);
 		if (error)
 			goto out_cancel;
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 5ff1d929d3b5f..e380bd1a9bfc9 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -512,9 +512,9 @@ xfs_attr_list_ilocked(
 	 */
 	if (!xfs_inode_hasattr(dp))
 		return 0;
-	else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
+	if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL)
 		return xfs_attr_shortform_list(context);
-	else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
+	if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
 		return xfs_attr_leaf_list(context);
 	return xfs_attr_node_list(context);
 }
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 4f277a6253b8d..5e32c3cf8e8c1 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -223,7 +223,7 @@ xfs_bmap_count_blocks(
 	if (!ifp)
 		return 0;
 
-	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
+	switch (ifp->if_format) {
 	case XFS_DINODE_FMT_BTREE:
 		if (!(ifp->if_flags & XFS_IFEXTENTS)) {
 			error = xfs_iread_extents(tp, ip, whichfork);
@@ -449,7 +449,7 @@ xfs_getbmap(
 		break;
 	}
 
-	switch (XFS_IFORK_FORMAT(ip, whichfork)) {
+	switch (ifp->if_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 	case XFS_DINODE_FMT_BTREE:
 		break;
@@ -1210,17 +1210,19 @@ xfs_swap_extents_check_format(
 	struct xfs_inode	*ip,	/* target inode */
 	struct xfs_inode	*tip)	/* tmp inode */
 {
+	struct xfs_ifork	*ifp = &ip->i_df;
+	struct xfs_ifork	*tifp = &tip->i_df;
 
 	/* Should never get a local format */
-	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL ||
-	    tip->i_d.di_format == XFS_DINODE_FMT_LOCAL)
+	if (ifp->if_format == XFS_DINODE_FMT_LOCAL ||
+	    tifp->if_format == XFS_DINODE_FMT_LOCAL)
 		return -EINVAL;
 
 	/*
 	 * if the target inode has less extents that then temporary inode then
 	 * why did userspace call us?
 	 */
-	if (ip->i_df.if_nextents < tip->i_df.if_nextents)
+	if (ifp->if_nextents < tifp->if_nextents)
 		return -EINVAL;
 
 	/*
@@ -1235,18 +1237,18 @@ xfs_swap_extents_check_format(
 	 * form then we will end up with the target inode in the wrong format
 	 * as we already know there are less extents in the temp inode.
 	 */
-	if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
-	    tip->i_d.di_format == XFS_DINODE_FMT_BTREE)
+	if (ifp->if_format == XFS_DINODE_FMT_EXTENTS &&
+	    tifp->if_format == XFS_DINODE_FMT_BTREE)
 		return -EINVAL;
 
 	/* Check temp in extent form to max in target */
-	if (tip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
-	    tip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))
+	if (tifp->if_format == XFS_DINODE_FMT_EXTENTS &&
+	    tifp->if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))
 		return -EINVAL;
 
 	/* Check target in extent form to max in temp */
-	if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
-	    ip->i_df.if_nextents > XFS_IFORK_MAXEXT(tip, XFS_DATA_FORK))
+	if (ifp->if_format == XFS_DINODE_FMT_EXTENTS &&
+	    ifp->if_nextents > XFS_IFORK_MAXEXT(tip, XFS_DATA_FORK))
 		return -EINVAL;
 
 	/*
@@ -1258,22 +1260,20 @@ xfs_swap_extents_check_format(
 	 * (a common defrag case) which will occur when the temp inode is in
 	 * extent format...
 	 */
-	if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
+	if (tifp->if_format == XFS_DINODE_FMT_BTREE) {
 		if (XFS_IFORK_Q(ip) &&
-		    XFS_BMAP_BMDR_SPACE(tip->i_df.if_broot) > XFS_IFORK_BOFF(ip))
+		    XFS_BMAP_BMDR_SPACE(tifp->if_broot) > XFS_IFORK_BOFF(ip))
 			return -EINVAL;
-		if (tip->i_df.if_nextents <=
-		    XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))
+		if (tifp->if_nextents <= XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))
 			return -EINVAL;
 	}
 
 	/* Reciprocal target->temp btree format checks */
-	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
 		if (XFS_IFORK_Q(tip) &&
 		    XFS_BMAP_BMDR_SPACE(ip->i_df.if_broot) > XFS_IFORK_BOFF(tip))
 			return -EINVAL;
-		if (ip->i_df.if_nextents <=
-		    XFS_IFORK_MAXEXT(tip, XFS_DATA_FORK))
+		if (ifp->if_nextents <= XFS_IFORK_MAXEXT(tip, XFS_DATA_FORK))
 			return -EINVAL;
 	}
 
@@ -1426,14 +1426,14 @@ xfs_swap_extent_forks(
 	 * Count the number of extended attribute blocks
 	 */
 	if (XFS_IFORK_Q(ip) && ip->i_afp->if_nextents > 0 &&
-	    ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL) {
+	    ip->i_afp->if_format != XFS_DINODE_FMT_LOCAL) {
 		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK, &junk,
 				&aforkblks);
 		if (error)
 			return error;
 	}
 	if (XFS_IFORK_Q(tip) && tip->i_afp->if_nextents > 0 &&
-	    tip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL) {
+	    tip->i_afp->if_format != XFS_DINODE_FMT_LOCAL) {
 		error = xfs_bmap_count_blocks(tp, tip, XFS_ATTR_FORK, &junk,
 				&taforkblks);
 		if (error)
@@ -1448,9 +1448,9 @@ xfs_swap_extent_forks(
 	 * bmbt scan as the last step.
 	 */
 	if (xfs_sb_version_has_v3inode(&ip->i_mount->m_sb)) {
-		if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE)
+		if (ip->i_df.if_format == XFS_DINODE_FMT_BTREE)
 			(*target_log_flags) |= XFS_ILOG_DOWNER;
-		if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE)
+		if (tip->i_df.if_format == XFS_DINODE_FMT_BTREE)
 			(*src_log_flags) |= XFS_ILOG_DOWNER;
 	}
 
@@ -1466,8 +1466,6 @@ xfs_swap_extent_forks(
 	ip->i_d.di_nblocks = tip->i_d.di_nblocks - taforkblks + aforkblks;
 	tip->i_d.di_nblocks = tmp + taforkblks - aforkblks;
 
-	swap(ip->i_d.di_format, tip->i_d.di_format);
-
 	/*
 	 * The extents in the source inode could still contain speculative
 	 * preallocation beyond EOF (e.g. the file is open but not modified
@@ -1481,7 +1479,7 @@ xfs_swap_extent_forks(
 	tip->i_delayed_blks = ip->i_delayed_blks;
 	ip->i_delayed_blks = 0;
 
-	switch (ip->i_d.di_format) {
+	switch (ip->i_df.if_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		(*src_log_flags) |= XFS_ILOG_DEXT;
 		break;
@@ -1492,7 +1490,7 @@ xfs_swap_extent_forks(
 		break;
 	}
 
-	switch (tip->i_d.di_format) {
+	switch (tip->i_df.if_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		(*target_log_flags) |= XFS_ILOG_DEXT;
 		break;
@@ -1714,8 +1712,10 @@ xfs_swap_extents(
 
 	/* Swap the cow forks. */
 	if (xfs_sb_version_hasreflink(&mp->m_sb)) {
-		ASSERT(ip->i_cformat == XFS_DINODE_FMT_EXTENTS);
-		ASSERT(tip->i_cformat == XFS_DINODE_FMT_EXTENTS);
+		ASSERT(!ip->i_cowfp ||
+		       ip->i_cowfp->if_format == XFS_DINODE_FMT_EXTENTS);
+		ASSERT(!tip->i_cowfp ||
+		       tip->i_cowfp->if_format == XFS_DINODE_FMT_EXTENTS);
 
 		swap(ip->i_cowfp, tip->i_cowfp);
 
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 871ec22c9aee9..66deddd5e2969 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -524,7 +524,7 @@ xfs_readdir(
 	args.geo = dp->i_mount->m_dir_geo;
 	args.trans = tp;
 
-	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
+	if (dp->i_df.if_format == XFS_DINODE_FMT_LOCAL)
 		rval = xfs_dir2_sf_getdents(&args, ctx);
 	else if ((rval = xfs_dir2_isblock(&args, &v)))
 		;
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 791d5d5e318cf..c09b3e9eab1da 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -63,7 +63,6 @@ xfs_inode_alloc(
 	memset(&ip->i_imap, 0, sizeof(struct xfs_imap));
 	ip->i_afp = NULL;
 	ip->i_cowfp = NULL;
-	ip->i_cformat = XFS_DINODE_FMT_EXTENTS;
 	memset(&ip->i_df, 0, sizeof(ip->i_df));
 	ip->i_flags = 0;
 	ip->i_delayed_blks = 0;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 1677c4e7207ed..64f5f9a440aed 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -112,7 +112,7 @@ xfs_ilock_data_map_shared(
 {
 	uint			lock_mode = XFS_ILOCK_SHARED;
 
-	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
+	if (ip->i_df.if_format == XFS_DINODE_FMT_BTREE &&
 	    (ip->i_df.if_flags & XFS_IFEXTENTS) == 0)
 		lock_mode = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, lock_mode);
@@ -125,7 +125,8 @@ xfs_ilock_attr_map_shared(
 {
 	uint			lock_mode = XFS_ILOCK_SHARED;
 
-	if (ip->i_d.di_aformat == XFS_DINODE_FMT_BTREE &&
+	if (ip->i_afp &&
+	    ip->i_afp->if_format == XFS_DINODE_FMT_BTREE &&
 	    (ip->i_afp->if_flags & XFS_IFEXTENTS) == 0)
 		lock_mode = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, lock_mode);
@@ -851,7 +852,7 @@ xfs_ialloc(
 	case S_IFCHR:
 	case S_IFBLK:
 	case S_IFSOCK:
-		ip->i_d.di_format = XFS_DINODE_FMT_DEV;
+		ip->i_df.if_format = XFS_DINODE_FMT_DEV;
 		ip->i_df.if_flags = 0;
 		flags |= XFS_ILOG_DEV;
 		break;
@@ -907,7 +908,7 @@ xfs_ialloc(
 		}
 		/* FALLTHROUGH */
 	case S_IFLNK:
-		ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
+		ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
 		ip->i_df.if_flags = XFS_IFEXTENTS;
 		ip->i_df.if_bytes = 0;
 		ip->i_df.if_u1.if_root = NULL;
@@ -915,10 +916,6 @@ xfs_ialloc(
 	default:
 		ASSERT(0);
 	}
-	/*
-	 * Attribute fork settings for new inode.
-	 */
-	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 
 	/*
 	 * Log the new values stuffed into the inode.
@@ -2749,7 +2746,7 @@ xfs_ifree(
 	 * data fork to extents format.  Note that the attr fork data has
 	 * already been freed by xfs_attr_inactive.
 	 */
-	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
+	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL) {
 		kmem_free(ip->i_df.if_u1.if_data);
 		ip->i_df.if_u1.if_data = NULL;
 		ip->i_df.if_bytes = 0;
@@ -2760,8 +2757,7 @@ xfs_ifree(
 	ip->i_d.di_flags2 = 0;
 	ip->i_d.di_dmevmask = 0;
 	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
-	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
-	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
+	ip->i_df.if_format = XFS_DINODE_FMT_EXTENTS;
 
 	/* Don't attempt to replay owner changes for a deleted inode */
 	ip->i_itemp->ili_fields &= ~(XFS_ILOG_AOWNER|XFS_ILOG_DOWNER);
@@ -3624,7 +3620,7 @@ xfs_iflush(
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(xfs_isiflocked(ip));
-	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
+	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
 
 	*bpp = NULL;
@@ -3706,7 +3702,7 @@ xfs_iflush_int(
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(xfs_isiflocked(ip));
-	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
+	ASSERT(ip->i_df.if_format != XFS_DINODE_FMT_BTREE ||
 	       ip->i_df.if_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
 	ASSERT(iip != NULL && iip->ili_fields != 0);
 
@@ -3728,8 +3724,8 @@ xfs_iflush_int(
 	}
 	if (S_ISREG(VFS_I(ip)->i_mode)) {
 		if (XFS_TEST_ERROR(
-		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
-		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE),
+		    ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
+		    ip->i_df.if_format != XFS_DINODE_FMT_BTREE,
 		    mp, XFS_ERRTAG_IFLUSH_3)) {
 			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 				"%s: Bad regular inode %Lu, ptr "PTR_FMT,
@@ -3738,9 +3734,9 @@ xfs_iflush_int(
 		}
 	} else if (S_ISDIR(VFS_I(ip)->i_mode)) {
 		if (XFS_TEST_ERROR(
-		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
-		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
-		    (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL),
+		    ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
+		    ip->i_df.if_format != XFS_DINODE_FMT_BTREE &&
+		    ip->i_df.if_format != XFS_DINODE_FMT_LOCAL,
 		    mp, XFS_ERRTAG_IFLUSH_4)) {
 			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 				"%s: Bad directory inode %Lu, ptr "PTR_FMT,
@@ -3782,10 +3778,10 @@ xfs_iflush_int(
 	 * If there are inline format data / attr forks attached to this inode,
 	 * make sure they are not corrupt.
 	 */
-	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL &&
+	if (ip->i_df.if_format == XFS_DINODE_FMT_LOCAL &&
 	    xfs_ifork_verify_local_data(ip))
 		goto flush_out;
-	if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL &&
+	if (ip->i_afp && ip->i_afp->if_format == XFS_DINODE_FMT_LOCAL &&
 	    xfs_ifork_verify_local_attr(ip))
 		goto flush_out;
 
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 24dae63ba16c0..dadcf19458960 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -57,8 +57,6 @@ typedef struct xfs_inode {
 
 	struct xfs_icdinode	i_d;		/* most of ondisk inode */
 
-	unsigned int		i_cformat;	/* format of cow fork */
-
 	/* VFS inode */
 	struct inode		i_vnode;	/* embedded VFS inode */
 
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index 401ba26aeed7b..ba47bf65b772b 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -36,7 +36,7 @@ xfs_inode_item_data_fork_size(
 {
 	struct xfs_inode	*ip = iip->ili_inode;
 
-	switch (ip->i_d.di_format) {
+	switch (ip->i_df.if_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		if ((iip->ili_fields & XFS_ILOG_DEXT) &&
 		    ip->i_df.if_nextents > 0 &&
@@ -77,7 +77,7 @@ xfs_inode_item_attr_fork_size(
 {
 	struct xfs_inode	*ip = iip->ili_inode;
 
-	switch (ip->i_d.di_aformat) {
+	switch (ip->i_afp->if_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		if ((iip->ili_fields & XFS_ILOG_AEXT) &&
 		    ip->i_afp->if_nextents > 0 &&
@@ -142,7 +142,7 @@ xfs_inode_item_format_data_fork(
 	struct xfs_inode	*ip = iip->ili_inode;
 	size_t			data_bytes;
 
-	switch (ip->i_d.di_format) {
+	switch (ip->i_df.if_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT | XFS_ILOG_DEV);
@@ -227,7 +227,7 @@ xfs_inode_item_format_attr_fork(
 	struct xfs_inode	*ip = iip->ili_inode;
 	size_t			data_bytes;
 
-	switch (ip->i_d.di_aformat) {
+	switch (ip->i_afp->if_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		iip->ili_fields &=
 			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT);
@@ -305,7 +305,7 @@ xfs_inode_to_log_dinode(
 	struct inode		*inode = VFS_I(ip);
 
 	to->di_magic = XFS_DINODE_MAGIC;
-	to->di_format = from->di_format;
+	to->di_format = xfs_ifork_format(&ip->i_df);
 	to->di_uid = i_uid_read(inode);
 	to->di_gid = i_gid_read(inode);
 	to->di_projid_lo = from->di_projid & 0xffff;
@@ -329,7 +329,7 @@ xfs_inode_to_log_dinode(
 	to->di_nextents = xfs_ifork_nextents(&ip->i_df);
 	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
 	to->di_forkoff = from->di_forkoff;
-	to->di_aformat = from->di_aformat;
+	to->di_aformat = xfs_ifork_format(ip->i_afp);
 	to->di_dmevmask = from->di_dmevmask;
 	to->di_dmstate = from->di_dmstate;
 	to->di_flags = from->di_flags;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index b4fd918749e5f..6ae3a2457777a 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -856,7 +856,7 @@ xfs_buffered_write_iomap_begin(
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 
-	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, XFS_DATA_FORK)) ||
+	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(&ip->i_df)) ||
 	    XFS_TEST_ERROR(false, mp, XFS_ERRTAG_BMAPIFORMAT)) {
 		error = -EFSCORRUPTED;
 		goto out_unlock;
@@ -1263,7 +1263,7 @@ xfs_xattr_iomap_begin(
 		goto out_unlock;
 	}
 
-	ASSERT(ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL);
+	ASSERT(ip->i_afp->if_format != XFS_DINODE_FMT_LOCAL);
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
 			       &nimaps, XFS_BMAPI_ATTRFORK);
 out_unlock:
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 80da86c5703fb..16ca97a7ff00f 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -115,7 +115,7 @@ xfs_bulkstat_one_int(
 			buf->bs_cowextsize_blks = dic->di_cowextsize;
 	}
 
-	switch (dic->di_format) {
+	switch (ip->i_df.if_format) {
 	case XFS_DINODE_FMT_DEV:
 		buf->bs_rdev = sysv_encode_dev(inode->i_rdev);
 		buf->bs_blksize = BLKDEV_IOSIZE;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index 8cf2fcb509c12..8e88a7ca387ea 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -251,7 +251,7 @@ xfs_symlink(
 		xfs_init_local_fork(ip, XFS_DATA_FORK, target_path, pathlen);
 
 		ip->i_d.di_size = pathlen;
-		ip->i_d.di_format = XFS_DINODE_FMT_LOCAL;
+		ip->i_df.if_format = XFS_DINODE_FMT_LOCAL;
 		xfs_trans_log_inode(tp, ip, XFS_ILOG_DDATA | XFS_ILOG_CORE);
 	} else {
 		int	offset;
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index ba2ab69e1fc7d..460136628a795 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1897,7 +1897,7 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->which = which;
 		__entry->ino = ip->i_ino;
-		__entry->format = ip->i_d.di_format;
+		__entry->format = ip->i_df.if_format;
 		__entry->nex = ip->i_df.if_nextents;
 		__entry->broot_size = ip->i_df.if_broot_bytes;
 		__entry->fork_off = XFS_IFORK_BOFF(ip);
-- 
2.26.2

