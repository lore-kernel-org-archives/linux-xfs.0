Return-Path: <SRS0=FSF3=YN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D542CCA9EA0
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Oct 2019 08:22:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7701C21928
	for <linux-xfs@archiver.kernel.org>; Sun, 20 Oct 2019 08:22:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="IJtaiVpp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbfJTIWA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 20 Oct 2019 04:22:00 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:45854 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbfJTIV7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 20 Oct 2019 04:21:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gw31Sd+6aOZJvWjAmPweP+kmJZyA+WaR2SQOdhLqHrw=; b=IJtaiVppAC0kyxnMxLXqF1v4c
        /32Z/uEllEh1nkZNa6WibCI4ADywULpZXoEkZrwogTMQ/FmM08JDao4DIpCGWBk6H0Lj1NHy/gEDd
        qemwgQKP/vUt6ZRMgc+viRvlvD2al32kLup3hbhDhm+DX+7CqPgcu+z+AyedV/1HQY6+nZ8LkYGkH
        zeNbyG7uw1jyAlyHrVol1zVNsbhmbrAmBdmnlXEU0f3wBXiSRcrSy7WAnXOblsasDc1Px7i2Y4pbB
        p1dteCj1vR2v7jjYplv7GlswAgt/JxPop4hO5+4HS2yCk9hiBoUhkZ/62LAPDHHZ+IbZzzwsRUyUD
        Eu+XOCnTA==;
Received: from [2001:4bb8:18c:d7b:c70:4a89:bc61:3] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iM6TO-0004eX-FQ
        for linux-xfs@vger.kernel.org; Sun, 20 Oct 2019 08:21:59 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/4] xfs: remove struct xfs_icdinode
Date:   Sun, 20 Oct 2019 10:21:45 +0200
Message-Id: <20191020082145.32515-5-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191020082145.32515-1-hch@lst.de>
References: <20191020082145.32515-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

There is no point in having this sub-structure except for historical
reasons.  Remove it and just fold the fields into struct xfs_inode.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c           |  16 +--
 fs/xfs/libxfs/xfs_attr_leaf.c      |  44 +++----
 fs/xfs/libxfs/xfs_bmap.c           |  54 ++++-----
 fs/xfs/libxfs/xfs_bmap_btree.c     |  10 +-
 fs/xfs/libxfs/xfs_da_btree.c       |   4 +-
 fs/xfs/libxfs/xfs_dir2.c           |  22 ++--
 fs/xfs/libxfs/xfs_dir2_block.c     |  12 +-
 fs/xfs/libxfs/xfs_dir2_node.c      |   2 +-
 fs/xfs/libxfs/xfs_dir2_sf.c        |  50 ++++----
 fs/xfs/libxfs/xfs_inode_buf.c      | 107 ++++++++--------
 fs/xfs/libxfs/xfs_inode_buf.h      |  30 -----
 fs/xfs/libxfs/xfs_inode_fork.c     |   8 +-
 fs/xfs/libxfs/xfs_inode_fork.h     |  24 ++--
 fs/xfs/libxfs/xfs_rtbitmap.c       |   4 +-
 fs/xfs/libxfs/xfs_symlink_remote.c |   2 +-
 fs/xfs/libxfs/xfs_trans_inode.c    |   2 +-
 fs/xfs/scrub/common.c              |   2 +-
 fs/xfs/scrub/dir.c                 |  10 +-
 fs/xfs/scrub/parent.c              |   4 +-
 fs/xfs/scrub/symlink.c             |   2 +-
 fs/xfs/xfs_aops.c                  |   6 +-
 fs/xfs/xfs_attr_inactive.c         |   3 +-
 fs/xfs/xfs_attr_list.c             |   2 +-
 fs/xfs/xfs_bmap_util.c             |  88 +++++++-------
 fs/xfs/xfs_dir2_readdir.c          |   4 +-
 fs/xfs/xfs_dquot.c                 |   6 +-
 fs/xfs/xfs_file.c                  |  14 +--
 fs/xfs/xfs_filestream.h            |   2 +-
 fs/xfs/xfs_icache.c                |  34 +++++-
 fs/xfs/xfs_inode.c                 | 189 ++++++++++++++---------------
 fs/xfs/xfs_inode.h                 |  32 +++--
 fs/xfs/xfs_inode_item.c            |  71 ++++++-----
 fs/xfs/xfs_ioctl.c                 |  64 +++++-----
 fs/xfs/xfs_iomap.c                 |   6 +-
 fs/xfs/xfs_iops.c                  |  36 +++---
 fs/xfs/xfs_itable.c                |  31 +++--
 fs/xfs/xfs_linux.h                 |   2 +-
 fs/xfs/xfs_log_recover.c           |   4 +-
 fs/xfs/xfs_pnfs.c                  |   2 +-
 fs/xfs/xfs_qm.c                    |  36 +++---
 fs/xfs/xfs_qm_bhv.c                |   2 +-
 fs/xfs/xfs_qm_syscalls.c           |   4 +-
 fs/xfs/xfs_quotaops.c              |   4 +-
 fs/xfs/xfs_reflink.c               |  14 +--
 fs/xfs/xfs_rtalloc.c               |  12 +-
 fs/xfs/xfs_super.c                 |   4 +-
 fs/xfs/xfs_symlink.c               |  24 ++--
 fs/xfs/xfs_trace.h                 |  20 +--
 48 files changed, 562 insertions(+), 563 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 510ca6974604..923a7270afc8 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -87,8 +87,8 @@ xfs_inode_hasattr(
 	struct xfs_inode	*ip)
 {
 	if (!XFS_IFORK_Q(ip) ||
-	    (ip->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
-	     ip->i_d.di_anextents == 0))
+	    (ip->i_aformat == XFS_DINODE_FMT_EXTENTS &&
+	     ip->i_anextents == 0))
 		return 0;
 	return 1;
 }
@@ -110,7 +110,7 @@ xfs_attr_get_ilocked(
 
 	if (!xfs_inode_hasattr(ip))
 		return -ENOATTR;
-	else if (ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
+	else if (ip->i_aformat == XFS_DINODE_FMT_LOCAL)
 		return xfs_attr_shortform_getvalue(args);
 	else if (xfs_bmap_one_block(ip, XFS_ATTR_FORK))
 		return xfs_attr_leaf_get(args);
@@ -262,14 +262,14 @@ xfs_attr_set_args(
 	 * If the attribute list is non-existent or a shortform list,
 	 * upgrade it to a single-leaf-block attribute list.
 	 */
-	if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL ||
-	    (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS &&
-	     dp->i_d.di_anextents == 0)) {
+	if (dp->i_aformat == XFS_DINODE_FMT_LOCAL ||
+	    (dp->i_aformat == XFS_DINODE_FMT_EXTENTS &&
+	     dp->i_anextents == 0)) {
 
 		/*
 		 * Build initial attribute list (if required).
 		 */
-		if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS)
+		if (dp->i_aformat == XFS_DINODE_FMT_EXTENTS)
 			xfs_attr_shortform_create(args);
 
 		/*
@@ -322,7 +322,7 @@ xfs_attr_remove_args(
 
 	if (!xfs_inode_hasattr(dp)) {
 		error = -ENOATTR;
-	} else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL) {
+	} else if (dp->i_aformat == XFS_DINODE_FMT_LOCAL) {
 		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
 		error = xfs_attr_shortform_remove(args);
 	} else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK)) {
diff --git a/fs/xfs/libxfs/xfs_attr_leaf.c b/fs/xfs/libxfs/xfs_attr_leaf.c
index f0089e862216..752ced87846a 100644
--- a/fs/xfs/libxfs/xfs_attr_leaf.c
+++ b/fs/xfs/libxfs/xfs_attr_leaf.c
@@ -462,9 +462,9 @@ xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes)
 	xfs_mount_t *mp = dp->i_mount;
 
 	/* rounded down */
-	offset = (XFS_LITINO(mp, dp->i_d.di_version) - bytes) >> 3;
+	offset = (XFS_LITINO(mp, dp->i_version) - bytes) >> 3;
 
-	if (dp->i_d.di_format == XFS_DINODE_FMT_DEV) {
+	if (dp->i_format == XFS_DINODE_FMT_DEV) {
 		minforkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
 		return (offset >= minforkoff) ? minforkoff : 0;
 	}
@@ -480,7 +480,7 @@ xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes)
 	 * literal area rebalancing.
 	 */
 	if (bytes <= XFS_IFORK_ASIZE(dp))
-		return dp->i_d.di_forkoff;
+		return dp->i_forkoff;
 
 	/*
 	 * For attr2 we can try to move the forkoff if there is space in the
@@ -492,7 +492,7 @@ xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes)
 
 	dsize = dp->i_df.if_bytes;
 
-	switch (dp->i_d.di_format) {
+	switch (dp->i_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		/*
 		 * If there is no attr fork and the data fork is extents, 
@@ -501,7 +501,7 @@ xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes)
 		 * minimum offset only needs to be the space required for
 		 * the btree root.
 		 */
-		if (!dp->i_d.di_forkoff && dp->i_df.if_bytes >
+		if (!dp->i_forkoff && dp->i_df.if_bytes >
 		    xfs_default_attroffset(dp))
 			dsize = XFS_BMDR_SPACE_CALC(MINDBTPTRS);
 		break;
@@ -512,10 +512,10 @@ xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes)
 		 * minforkoff to where the btree root can finish so we have
 		 * plenty of room for attrs
 		 */
-		if (dp->i_d.di_forkoff) {
-			if (offset < dp->i_d.di_forkoff)
+		if (dp->i_forkoff) {
+			if (offset < dp->i_forkoff)
 				return 0;
-			return dp->i_d.di_forkoff;
+			return dp->i_forkoff;
 		}
 		dsize = XFS_BMAP_BROOT_SPACE(mp, dp->i_df.if_broot);
 		break;
@@ -529,7 +529,7 @@ xfs_attr_shortform_bytesfit(xfs_inode_t *dp, int bytes)
 	minforkoff = roundup(minforkoff, 8) >> 3;
 
 	/* attr fork btree root can have at least this many key/ptr pairs */
-	maxforkoff = XFS_LITINO(mp, dp->i_d.di_version) -
+	maxforkoff = XFS_LITINO(mp, dp->i_version) -
 			XFS_BMDR_SPACE_CALC(MINABTPTRS);
 	maxforkoff = maxforkoff >> 3;	/* rounded down */
 
@@ -575,9 +575,9 @@ xfs_attr_shortform_create(xfs_da_args_t *args)
 	ifp = dp->i_afp;
 	ASSERT(ifp != NULL);
 	ASSERT(ifp->if_bytes == 0);
-	if (dp->i_d.di_aformat == XFS_DINODE_FMT_EXTENTS) {
+	if (dp->i_aformat == XFS_DINODE_FMT_EXTENTS) {
 		ifp->if_flags &= ~XFS_IFEXTENTS;	/* just in case */
-		dp->i_d.di_aformat = XFS_DINODE_FMT_LOCAL;
+		dp->i_aformat = XFS_DINODE_FMT_LOCAL;
 		ifp->if_flags |= XFS_IFINLINE;
 	} else {
 		ASSERT(ifp->if_flags & XFS_IFINLINE);
@@ -607,7 +607,7 @@ xfs_attr_shortform_add(xfs_da_args_t *args, int forkoff)
 
 	dp = args->dp;
 	mp = dp->i_mount;
-	dp->i_d.di_forkoff = forkoff;
+	dp->i_forkoff = forkoff;
 
 	ifp = dp->i_afp;
 	ASSERT(ifp->if_flags & XFS_IFINLINE);
@@ -653,10 +653,10 @@ xfs_attr_fork_remove(
 	struct xfs_trans	*tp)
 {
 	xfs_idestroy_fork(ip, XFS_ATTR_FORK);
-	ip->i_d.di_forkoff = 0;
-	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
+	ip->i_forkoff = 0;
+	ip->i_aformat = XFS_DINODE_FMT_EXTENTS;
 
-	ASSERT(ip->i_d.di_anextents == 0);
+	ASSERT(ip->i_anextents == 0);
 	ASSERT(ip->i_afp == NULL);
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
@@ -712,17 +712,17 @@ xfs_attr_shortform_remove(xfs_da_args_t *args)
 	totsize -= size;
 	if (totsize == sizeof(xfs_attr_sf_hdr_t) &&
 	    (mp->m_flags & XFS_MOUNT_ATTR2) &&
-	    (dp->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
+	    (dp->i_format != XFS_DINODE_FMT_BTREE) &&
 	    !(args->op_flags & XFS_DA_OP_ADDNAME)) {
 		xfs_attr_fork_remove(dp, args->trans);
 	} else {
 		xfs_idata_realloc(dp, -size, XFS_ATTR_FORK);
-		dp->i_d.di_forkoff = xfs_attr_shortform_bytesfit(dp, totsize);
-		ASSERT(dp->i_d.di_forkoff);
+		dp->i_forkoff = xfs_attr_shortform_bytesfit(dp, totsize);
+		ASSERT(dp->i_forkoff);
 		ASSERT(totsize > sizeof(xfs_attr_sf_hdr_t) ||
 				(args->op_flags & XFS_DA_OP_ADDNAME) ||
 				!(mp->m_flags & XFS_MOUNT_ATTR2) ||
-				dp->i_d.di_format == XFS_DINODE_FMT_BTREE);
+				dp->i_format == XFS_DINODE_FMT_BTREE);
 		xfs_trans_log_inode(args->trans, dp,
 					XFS_ILOG_CORE | XFS_ILOG_ADATA);
 	}
@@ -907,7 +907,7 @@ xfs_attr_shortform_allfit(
 				+ be16_to_cpu(name_loc->valuelen);
 	}
 	if ((dp->i_mount->m_flags & XFS_MOUNT_ATTR2) &&
-	    (dp->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
+	    (dp->i_format != XFS_DINODE_FMT_BTREE) &&
 	    (bytes == sizeof(struct xfs_attr_sf_hdr)))
 		return -1;
 	return xfs_attr_shortform_bytesfit(dp, bytes);
@@ -926,7 +926,7 @@ xfs_attr_shortform_verify(
 	int				i;
 	int				size;
 
-	ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_LOCAL);
+	ASSERT(ip->i_aformat == XFS_DINODE_FMT_LOCAL);
 	ifp = XFS_IFORK_PTR(ip, XFS_ATTR_FORK);
 	sfp = (struct xfs_attr_shortform *)ifp->if_u1.if_data;
 	size = ifp->if_bytes;
@@ -1030,7 +1030,7 @@ xfs_attr3_leaf_to_shortform(
 
 	if (forkoff == -1) {
 		ASSERT(dp->i_mount->m_flags & XFS_MOUNT_ATTR2);
-		ASSERT(dp->i_d.di_format != XFS_DINODE_FMT_BTREE);
+		ASSERT(dp->i_format != XFS_DINODE_FMT_BTREE);
 		xfs_attr_fork_remove(dp, args->trans);
 		goto out;
 	}
diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index 02469d59c787..fb6cf88f338c 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -193,13 +193,13 @@ xfs_default_attroffset(
 	uint			offset;
 
 	if (mp->m_sb.sb_inodesize == 256) {
-		offset = XFS_LITINO(mp, ip->i_d.di_version) -
+		offset = XFS_LITINO(mp, ip->i_version) -
 				XFS_BMDR_SPACE_CALC(MINABTPTRS);
 	} else {
 		offset = XFS_BMDR_SPACE_CALC(6 * MINABTPTRS);
 	}
 
-	ASSERT(offset < XFS_LITINO(mp, ip->i_d.di_version));
+	ASSERT(offset < XFS_LITINO(mp, ip->i_version));
 	return offset;
 }
 
@@ -214,12 +214,12 @@ xfs_bmap_forkoff_reset(
 	int		whichfork)
 {
 	if (whichfork == XFS_ATTR_FORK &&
-	    ip->i_d.di_format != XFS_DINODE_FMT_DEV &&
-	    ip->i_d.di_format != XFS_DINODE_FMT_BTREE) {
+	    ip->i_format != XFS_DINODE_FMT_DEV &&
+	    ip->i_format != XFS_DINODE_FMT_BTREE) {
 		uint	dfl_forkoff = xfs_default_attroffset(ip) >> 3;
 
-		if (dfl_forkoff > ip->i_d.di_forkoff)
-			ip->i_d.di_forkoff = dfl_forkoff;
+		if (dfl_forkoff > ip->i_forkoff)
+			ip->i_forkoff = dfl_forkoff;
 	}
 }
 
@@ -335,7 +335,7 @@ xfs_bmap_check_leaf_extents(
 	}
 
 	/* skip large extent count inodes */
-	if (ip->i_d.di_nextents > 10000)
+	if (ip->i_nextents > 10000)
 		return;
 
 	bno = NULLFSBLOCK;
@@ -623,7 +623,7 @@ xfs_bmap_btree_to_extents(
 		return error;
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, whichfork);
 	xfs_bmap_add_free(cur->bc_tp, cbno, 1, &oinfo);
-	ip->i_d.di_nblocks--;
+	ip->i_nblocks--;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
 	xfs_trans_binval(tp, cbp);
 	if (cur->bc_bufs[0] == cbp)
@@ -725,7 +725,7 @@ xfs_bmap_extents_to_btree(
 	       args.agno >= XFS_FSB_TO_AGNO(mp, tp->t_firstblock));
 	tp->t_firstblock = args.fsbno;
 	cur->bc_private.b.allocated++;
-	ip->i_d.di_nblocks++;
+	ip->i_nblocks++;
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, 1L);
 	abp = xfs_btree_get_bufl(mp, tp, args.fsbno);
 	if (!abp) {
@@ -903,7 +903,7 @@ xfs_bmap_local_to_extents(
 	xfs_iext_insert(ip, &icur, &rec, 0);
 
 	XFS_IFORK_NEXT_SET(ip, whichfork, 1);
-	ip->i_d.di_nblocks = 1;
+	ip->i_nblocks = 1;
 	xfs_trans_mod_dquot_byino(tp, ip,
 		XFS_TRANS_DQ_BCOUNT, 1L);
 	flags |= xfs_ilog_fext(whichfork);
@@ -964,7 +964,7 @@ xfs_bmap_add_attrfork_extents(
 	xfs_btree_cur_t		*cur;		/* bmap btree cursor */
 	int			error;		/* error return value */
 
-	if (ip->i_d.di_nextents * sizeof(xfs_bmbt_rec_t) <= XFS_IFORK_DSIZE(ip))
+	if (ip->i_nextents * sizeof(xfs_bmbt_rec_t) <= XFS_IFORK_DSIZE(ip))
 		return 0;
 	cur = NULL;
 	error = xfs_bmap_extents_to_btree(tp, ip, &cur, 0, flags,
@@ -1025,16 +1025,16 @@ xfs_bmap_set_attrforkoff(
 	int			size,
 	int			*version)
 {
-	switch (ip->i_d.di_format) {
+	switch (ip->i_format) {
 	case XFS_DINODE_FMT_DEV:
-		ip->i_d.di_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
+		ip->i_forkoff = roundup(sizeof(xfs_dev_t), 8) >> 3;
 		break;
 	case XFS_DINODE_FMT_LOCAL:
 	case XFS_DINODE_FMT_EXTENTS:
 	case XFS_DINODE_FMT_BTREE:
-		ip->i_d.di_forkoff = xfs_attr_shortform_bytesfit(ip, size);
-		if (!ip->i_d.di_forkoff)
-			ip->i_d.di_forkoff = xfs_default_attroffset(ip) >> 3;
+		ip->i_forkoff = xfs_attr_shortform_bytesfit(ip, size);
+		if (!ip->i_forkoff)
+			ip->i_forkoff = xfs_default_attroffset(ip) >> 3;
 		else if ((ip->i_mount->m_flags & XFS_MOUNT_ATTR2) && version)
 			*version = 2;
 		break;
@@ -1083,16 +1083,16 @@ xfs_bmap_add_attrfork(
 		goto trans_cancel;
 	if (XFS_IFORK_Q(ip))
 		goto trans_cancel;
-	if (ip->i_d.di_anextents != 0) {
+	if (ip->i_anextents != 0) {
 		error = -EFSCORRUPTED;
 		goto trans_cancel;
 	}
-	if (ip->i_d.di_aformat != XFS_DINODE_FMT_EXTENTS) {
+	if (ip->i_aformat != XFS_DINODE_FMT_EXTENTS) {
 		/*
 		 * For inodes coming from pre-6.2 filesystems.
 		 */
-		ASSERT(ip->i_d.di_aformat == 0);
-		ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
+		ASSERT(ip->i_aformat == 0);
+		ip->i_aformat = XFS_DINODE_FMT_EXTENTS;
 	}
 
 	xfs_trans_ijoin(tp, ip, 0);
@@ -1104,7 +1104,7 @@ xfs_bmap_add_attrfork(
 	ip->i_afp = kmem_zone_zalloc(xfs_ifork_zone, 0);
 	ip->i_afp->if_flags = XFS_IFEXTENTS;
 	logflags = 0;
-	switch (ip->i_d.di_format) {
+	switch (ip->i_format) {
 	case XFS_DINODE_FMT_LOCAL:
 		error = xfs_bmap_add_attrfork_local(tp, ip, &logflags);
 		break;
@@ -1551,7 +1551,7 @@ xfs_bmap_add_extent_delay_real(
 	ifp = XFS_IFORK_PTR(bma->ip, whichfork);
 	ASSERT(whichfork != XFS_ATTR_FORK);
 	nextents = (whichfork == XFS_COW_FORK ? &bma->ip->i_cnextents :
-						&bma->ip->i_d.di_nextents);
+						&bma->ip->i_nextents);
 
 	ASSERT(!isnullstartblock(new->br_startblock));
 	ASSERT(!bma->cur ||
@@ -3365,7 +3365,7 @@ xfs_bmap_btalloc_accounting(
 	}
 
 	/* data/attr fork only */
-	ap->ip->i_d.di_nblocks += args->len;
+	ap->ip->i_nblocks += args->len;
 	xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 	if (ap->wasdel) {
 		ap->ip->i_delayed_blks -= args->len;
@@ -4601,7 +4601,7 @@ xfs_bmapi_remap(
 		ASSERT(got.br_startoff - bno >= len);
 	}
 
-	ip->i_d.di_nblocks += len;
+	ip->i_nblocks += len;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (ifp->if_flags & XFS_IFBROOT) {
@@ -4625,9 +4625,9 @@ xfs_bmapi_remap(
 	error = xfs_bmap_btree_to_extents(tp, ip, cur, &logflags, whichfork);
 
 error0:
-	if (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS)
+	if (ip->i_format != XFS_DINODE_FMT_EXTENTS)
 		logflags &= ~XFS_ILOG_DEXT;
-	else if (ip->i_d.di_format != XFS_DINODE_FMT_BTREE)
+	else if (ip->i_format != XFS_DINODE_FMT_BTREE)
 		logflags &= ~XFS_ILOG_DBROOT;
 
 	if (logflags)
@@ -5156,7 +5156,7 @@ xfs_bmap_del_extent_real(
 	 * Adjust inode # blocks in the file.
 	 */
 	if (nblks)
-		ip->i_d.di_nblocks -= nblks;
+		ip->i_nblocks -= nblks;
 	/*
 	 * Adjust quota data.
 	 */
diff --git a/fs/xfs/libxfs/xfs_bmap_btree.c b/fs/xfs/libxfs/xfs_bmap_btree.c
index ffe608d2a2d9..2b36d939c15c 100644
--- a/fs/xfs/libxfs/xfs_bmap_btree.c
+++ b/fs/xfs/libxfs/xfs_bmap_btree.c
@@ -183,7 +183,7 @@ xfs_bmbt_update_cursor(
 	struct xfs_btree_cur	*dst)
 {
 	ASSERT((dst->bc_tp->t_firstblock != NULLFSBLOCK) ||
-	       (dst->bc_private.b.ip->i_d.di_flags & XFS_DIFLAG_REALTIME));
+	       (dst->bc_private.b.ip->i_diflags & XFS_DIFLAG_REALTIME));
 
 	dst->bc_private.b.allocated += src->bc_private.b.allocated;
 	dst->bc_tp->t_firstblock = src->bc_tp->t_firstblock;
@@ -260,7 +260,7 @@ xfs_bmbt_alloc_block(
 	ASSERT(args.len == 1);
 	cur->bc_tp->t_firstblock = args.fsbno;
 	cur->bc_private.b.allocated++;
-	cur->bc_private.b.ip->i_d.di_nblocks++;
+	cur->bc_private.b.ip->i_nblocks++;
 	xfs_trans_log_inode(args.tp, cur->bc_private.b.ip, XFS_ILOG_CORE);
 	xfs_trans_mod_dquot_byino(args.tp, cur->bc_private.b.ip,
 			XFS_TRANS_DQ_BCOUNT, 1L);
@@ -287,7 +287,7 @@ xfs_bmbt_free_block(
 
 	xfs_rmap_ino_bmbt_owner(&oinfo, ip->i_ino, cur->bc_private.b.whichfork);
 	xfs_bmap_add_free(cur->bc_tp, fsbno, 1, &oinfo);
-	ip->i_d.di_nblocks--;
+	ip->i_nblocks--;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	xfs_trans_mod_dquot_byino(tp, ip, XFS_TRANS_DQ_BCOUNT, -1L);
@@ -637,9 +637,9 @@ xfs_bmbt_change_owner(
 	ASSERT(tp || buffer_list);
 	ASSERT(!(tp && buffer_list));
 	if (whichfork == XFS_DATA_FORK)
-		ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_BTREE);
+		ASSERT(ip->i_format == XFS_DINODE_FMT_BTREE);
 	else
-		ASSERT(ip->i_d.di_aformat == XFS_DINODE_FMT_BTREE);
+		ASSERT(ip->i_aformat == XFS_DINODE_FMT_BTREE);
 
 	cur = xfs_bmbt_init_cursor(ip->i_mount, tp, ip, whichfork);
 	if (!cur)
diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 4fd1223c1bd5..7bf5f569c35d 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2065,7 +2065,7 @@ xfs_da_grow_inode_int(
 	struct xfs_trans	*tp = args->trans;
 	struct xfs_inode	*dp = args->dp;
 	int			w = args->whichfork;
-	xfs_rfsblock_t		nblks = dp->i_d.di_nblocks;
+	xfs_rfsblock_t		nblks = dp->i_nblocks;
 	struct xfs_bmbt_irec	map, *mapp;
 	int			nmap, error, got, i, mapi;
 
@@ -2131,7 +2131,7 @@ xfs_da_grow_inode_int(
 	}
 
 	/* account for newly allocated blocks in reserved blocks total */
-	args->total -= dp->i_d.di_nblocks - nblks;
+	args->total -= dp->i_nblocks - nblks;
 
 out_free_map:
 	if (mapp != &map)
diff --git a/fs/xfs/libxfs/xfs_dir2.c b/fs/xfs/libxfs/xfs_dir2.c
index 867c5dee0751..11691e5c39d7 100644
--- a/fs/xfs/libxfs/xfs_dir2.c
+++ b/fs/xfs/libxfs/xfs_dir2.c
@@ -173,9 +173,9 @@ xfs_dir_isempty(
 	xfs_dir2_sf_hdr_t	*sfp;
 
 	ASSERT(S_ISDIR(VFS_I(dp)->i_mode));
-	if (dp->i_d.di_size == 0)	/* might happen during shutdown. */
+	if (dp->i_disk_size == 0)	/* might happen during shutdown. */
 		return 1;
-	if (dp->i_d.di_size > XFS_IFORK_DSIZE(dp))
+	if (dp->i_disk_size > XFS_IFORK_DSIZE(dp))
 		return 0;
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
 	return !sfp->count;
@@ -272,7 +272,7 @@ xfs_dir_createname(
 	if (!inum)
 		args->op_flags |= XFS_DA_OP_JUSTCHECK;
 
-	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
+	if (dp->i_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_addname(args);
 		goto out_free;
 	}
@@ -367,7 +367,7 @@ xfs_dir_lookup(
 		args->op_flags |= XFS_DA_OP_CILOOKUP;
 
 	lock_mode = xfs_ilock_data_map_shared(dp);
-	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
+	if (dp->i_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_lookup(args);
 		goto out_check_rval;
 	}
@@ -437,7 +437,7 @@ xfs_dir_removename(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 
-	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
+	if (dp->i_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_removename(args);
 		goto out_free;
 	}
@@ -498,7 +498,7 @@ xfs_dir_replace(
 	args->whichfork = XFS_DATA_FORK;
 	args->trans = tp;
 
-	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL) {
+	if (dp->i_format == XFS_DINODE_FMT_LOCAL) {
 		rval = xfs_dir2_sf_replace(args);
 		goto out_free;
 	}
@@ -578,8 +578,8 @@ xfs_dir2_grow_inode(
 		xfs_fsize_t	size;		/* directory file (data) size */
 
 		size = XFS_FSB_TO_B(mp, bno + count);
-		if (size > dp->i_d.di_size) {
-			dp->i_d.di_size = size;
+		if (size > dp->i_disk_size) {
+			dp->i_disk_size = size;
 			xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
 		}
 	}
@@ -600,7 +600,7 @@ xfs_dir2_isblock(
 	if ((rval = xfs_bmap_last_offset(args->dp, &last, XFS_DATA_FORK)))
 		return rval;
 	rval = XFS_FSB_TO_B(args->dp->i_mount, last) == args->geo->blksize;
-	if (rval != 0 && args->dp->i_d.di_size != args->geo->blksize)
+	if (rval != 0 && args->dp->i_disk_size != args->geo->blksize)
 		return -EFSCORRUPTED;
 	*vp = rval;
 	return 0;
@@ -679,7 +679,7 @@ xfs_dir2_shrink_inode(
 	/*
 	 * If the block isn't the last one in the directory, we're done.
 	 */
-	if (dp->i_d.di_size > xfs_dir2_db_off_to_byte(args->geo, db + 1, 0))
+	if (dp->i_disk_size > xfs_dir2_db_off_to_byte(args->geo, db + 1, 0))
 		return 0;
 	bno = da;
 	if ((error = xfs_bmap_last_before(tp, dp, &bno, XFS_DATA_FORK))) {
@@ -695,7 +695,7 @@ xfs_dir2_shrink_inode(
 	/*
 	 * Set the size to the new last block.
 	 */
-	dp->i_d.di_size = XFS_FSB_TO_B(mp, bno);
+	dp->i_disk_size = XFS_FSB_TO_B(mp, bno);
 	xfs_trans_log_inode(tp, dp, XFS_ILOG_CORE);
 	return 0;
 }
diff --git a/fs/xfs/libxfs/xfs_dir2_block.c b/fs/xfs/libxfs/xfs_dir2_block.c
index 49e4bc39e7bb..e07de8202735 100644
--- a/fs/xfs/libxfs/xfs_dir2_block.c
+++ b/fs/xfs/libxfs/xfs_dir2_block.c
@@ -935,7 +935,7 @@ xfs_dir2_leaf_to_block(
 	 * been left behind during no-space-reservation operations.
 	 * These will show up in the leaf bests table.
 	 */
-	while (dp->i_d.di_size > args->geo->blksize) {
+	while (dp->i_disk_size > args->geo->blksize) {
 		int hdrsz;
 
 		hdrsz = dp->d_ops->data_entry_offset;
@@ -1076,17 +1076,17 @@ xfs_dir2_sf_to_block(
 	/*
 	 * Bomb out if the shortform directory is way too short.
 	 */
-	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
+	if (dp->i_disk_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
 		ASSERT(XFS_FORCED_SHUTDOWN(mp));
 		return -EIO;
 	}
 
 	oldsfp = (xfs_dir2_sf_hdr_t *)ifp->if_u1.if_data;
 
-	ASSERT(ifp->if_bytes == dp->i_d.di_size);
+	ASSERT(ifp->if_bytes == dp->i_disk_size);
 	ASSERT(ifp->if_u1.if_data != NULL);
-	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(oldsfp->i8count));
-	ASSERT(dp->i_d.di_nextents == 0);
+	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(oldsfp->i8count));
+	ASSERT(dp->i_nextents == 0);
 
 	/*
 	 * Copy the directory into a temporary buffer.
@@ -1097,7 +1097,7 @@ xfs_dir2_sf_to_block(
 
 	xfs_idata_realloc(dp, -ifp->if_bytes, XFS_DATA_FORK);
 	xfs_bmap_local_to_extents_empty(tp, dp, XFS_DATA_FORK);
-	dp->i_d.di_size = 0;
+	dp->i_disk_size = 0;
 
 	/*
 	 * Add block 0 to the inode.
diff --git a/fs/xfs/libxfs/xfs_dir2_node.c b/fs/xfs/libxfs/xfs_dir2_node.c
index 705c4f562758..6f09403a0ac0 100644
--- a/fs/xfs/libxfs/xfs_dir2_node.c
+++ b/fs/xfs/libxfs/xfs_dir2_node.c
@@ -373,7 +373,7 @@ xfs_dir2_leaf_to_node(
 	leaf = lbp->b_addr;
 	ltp = xfs_dir2_leaf_tail_p(args->geo, leaf);
 	if (be32_to_cpu(ltp->bestcount) >
-				(uint)dp->i_d.di_size / args->geo->blksize)
+				(uint)dp->i_disk_size / args->geo->blksize)
 		return -EFSCORRUPTED;
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_dir2_sf.c b/fs/xfs/libxfs/xfs_dir2_sf.c
index 85f14fc2a8da..1e134023bd6f 100644
--- a/fs/xfs/libxfs/xfs_dir2_sf.c
+++ b/fs/xfs/libxfs/xfs_dir2_sf.c
@@ -241,8 +241,8 @@ xfs_dir2_block_to_sf(
 	 */
 	ASSERT(dp->i_df.if_bytes == 0);
 	xfs_init_local_fork(dp, XFS_DATA_FORK, dst, size);
-	dp->i_d.di_format = XFS_DINODE_FMT_LOCAL;
-	dp->i_d.di_size = size;
+	dp->i_format = XFS_DINODE_FMT_LOCAL;
+	dp->i_disk_size = size;
 
 	logflags |= XFS_ILOG_DDATA;
 	xfs_dir2_sf_check(args);
@@ -280,14 +280,14 @@ xfs_dir2_sf_addname(
 	/*
 	 * Make sure the shortform value has some of its header.
 	 */
-	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
+	if (dp->i_disk_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
 		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
 		return -EIO;
 	}
-	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
+	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
+	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
 	/*
 	 * Compute entry (and change in) size.
 	 */
@@ -305,7 +305,7 @@ xfs_dir2_sf_addname(
 		objchange = 1;
 	}
 
-	new_isize = (int)dp->i_d.di_size + incr_isize;
+	new_isize = (int)dp->i_disk_size + incr_isize;
 	/*
 	 * Won't fit as shortform any more (due to size),
 	 * or the pick routine says it won't (due to offset values).
@@ -397,7 +397,7 @@ xfs_dir2_sf_addname_easy(
 	sfp->count++;
 	if (args->inumber > XFS_DIR2_MAX_SHORT_INUM)
 		sfp->i8count++;
-	dp->i_d.di_size = new_isize;
+	dp->i_disk_size = new_isize;
 	xfs_dir2_sf_check(args);
 }
 
@@ -435,7 +435,7 @@ xfs_dir2_sf_addname_hard(
 	dp = args->dp;
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-	old_isize = (int)dp->i_d.di_size;
+	old_isize = (int)dp->i_disk_size;
 	buf = kmem_alloc(old_isize, 0);
 	oldsfp = (xfs_dir2_sf_hdr_t *)buf;
 	memcpy(oldsfp, sfp, old_isize);
@@ -492,7 +492,7 @@ xfs_dir2_sf_addname_hard(
 		memcpy(sfep, oldsfep, old_isize - nbytes);
 	}
 	kmem_free(buf);
-	dp->i_d.di_size = new_isize;
+	dp->i_disk_size = new_isize;
 	xfs_dir2_sf_check(args);
 }
 
@@ -605,7 +605,7 @@ xfs_dir2_sf_check(
 		ASSERT(dp->d_ops->sf_get_ftype(sfep) < XFS_DIR3_FT_MAX);
 	}
 	ASSERT(i8count == sfp->i8count);
-	ASSERT((char *)sfep - (char *)sfp == dp->i_d.di_size);
+	ASSERT((char *)sfep - (char *)sfp == dp->i_disk_size);
 	ASSERT(offset +
 	       (sfp->count + 2) * (uint)sizeof(xfs_dir2_leaf_entry_t) +
 	       (uint)sizeof(xfs_dir2_block_tail_t) <= args->geo->blksize);
@@ -632,7 +632,7 @@ xfs_dir2_sf_verify(
 	int				error;
 	uint8_t				filetype;
 
-	ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_LOCAL);
+	ASSERT(ip->i_format == XFS_DINODE_FMT_LOCAL);
 	/*
 	 * xfs_iread calls us before xfs_setup_inode sets up ip->d_ops,
 	 * so we can only trust the mountpoint to have the right pointer.
@@ -736,14 +736,14 @@ xfs_dir2_sf_create(
 	dp = args->dp;
 
 	ASSERT(dp != NULL);
-	ASSERT(dp->i_d.di_size == 0);
+	ASSERT(dp->i_disk_size == 0);
 	/*
 	 * If it's currently a zero-length extent file,
 	 * convert it to local format.
 	 */
-	if (dp->i_d.di_format == XFS_DINODE_FMT_EXTENTS) {
+	if (dp->i_format == XFS_DINODE_FMT_EXTENTS) {
 		dp->i_df.if_flags &= ~XFS_IFEXTENTS;	/* just in case */
-		dp->i_d.di_format = XFS_DINODE_FMT_LOCAL;
+		dp->i_format = XFS_DINODE_FMT_LOCAL;
 		xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE);
 		dp->i_df.if_flags |= XFS_IFINLINE;
 	}
@@ -765,7 +765,7 @@ xfs_dir2_sf_create(
 	 */
 	dp->d_ops->sf_put_parent_ino(sfp, pino);
 	sfp->count = 0;
-	dp->i_d.di_size = size;
+	dp->i_disk_size = size;
 	xfs_dir2_sf_check(args);
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
 	return 0;
@@ -796,14 +796,14 @@ xfs_dir2_sf_lookup(
 	/*
 	 * Bail out if the directory is way too short.
 	 */
-	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
+	if (dp->i_disk_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
 		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
 		return -EIO;
 	}
-	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
+	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
+	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
 	/*
 	 * Special case for .
 	 */
@@ -878,7 +878,7 @@ xfs_dir2_sf_removename(
 	dp = args->dp;
 
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
-	oldsize = (int)dp->i_d.di_size;
+	oldsize = (int)dp->i_disk_size;
 	/*
 	 * Bail out if the directory is way too short.
 	 */
@@ -924,7 +924,7 @@ xfs_dir2_sf_removename(
 	 * Fix up the header and file size.
 	 */
 	sfp->count--;
-	dp->i_d.di_size = newsize;
+	dp->i_disk_size = newsize;
 	/*
 	 * Reallocate, making it smaller.
 	 */
@@ -966,14 +966,14 @@ xfs_dir2_sf_replace(
 	/*
 	 * Bail out if the shortform directory is way too small.
 	 */
-	if (dp->i_d.di_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
+	if (dp->i_disk_size < offsetof(xfs_dir2_sf_hdr_t, parent)) {
 		ASSERT(XFS_FORCED_SHUTDOWN(dp->i_mount));
 		return -EIO;
 	}
-	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
+	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
-	ASSERT(dp->i_d.di_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
+	ASSERT(dp->i_disk_size >= xfs_dir2_sf_hdr_size(sfp->i8count));
 
 	/*
 	 * New inode number is large, and need to convert to 8-byte inodes.
@@ -1136,7 +1136,7 @@ xfs_dir2_sf_toino4(
 	 * Clean up the inode.
 	 */
 	kmem_free(buf);
-	dp->i_d.di_size = newsize;
+	dp->i_disk_size = newsize;
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
 }
 
@@ -1209,6 +1209,6 @@ xfs_dir2_sf_toino8(
 	 * Clean up the inode.
 	 */
 	kmem_free(buf);
-	dp->i_d.di_size = newsize;
+	dp->i_disk_size = newsize;
 	xfs_trans_log_inode(args->trans, dp, XFS_ILOG_CORE | XFS_ILOG_DDATA);
 }
diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index 8afacfe4be0a..ba0dd8878b41 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -202,29 +202,27 @@ xfs_inode_from_disk(
 	struct xfs_inode	*ip,
 	struct xfs_dinode	*from)
 {
-	struct xfs_icdinode	*to = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
-
 	/*
 	 * Convert v1 inodes immediately to v2 inode format as this is the
 	 * minimum inode version format we support in the rest of the code.
 	 */
-	to->di_version = from->di_version;
-	if (to->di_version == 1) {
+	ip->i_version = from->di_version;
+	if (ip->i_version == 1) {
 		set_nlink(inode, be16_to_cpu(from->di_onlink));
-		to->di_projid = 0;
-		to->di_version = 2;
+		ip->i_projid = 0;
+		ip->i_version = 2;
 	} else {
 		set_nlink(inode, be32_to_cpu(from->di_nlink));
-		to->di_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
+		ip->i_projid = (prid_t)be16_to_cpu(from->di_projid_hi) << 16 |
 					be16_to_cpu(from->di_projid_lo);
 	}
 
-	to->di_format = from->di_format;
-	to->di_uid = be32_to_cpu(from->di_uid);
-	to->di_gid = be32_to_cpu(from->di_gid);
-	to->di_flushiter = be16_to_cpu(from->di_flushiter);
+	ip->i_format = from->di_format;
+	ip->i_uid = be32_to_cpu(from->di_uid);
+	ip->i_gid = be32_to_cpu(from->di_gid);
+	ip->i_flushiter = be16_to_cpu(from->di_flushiter);
 
 	/*
 	 * Time is signed, so need to convert to signed 32 bit before
@@ -241,24 +239,24 @@ xfs_inode_from_disk(
 	inode->i_generation = be32_to_cpu(from->di_gen);
 	inode->i_mode = be16_to_cpu(from->di_mode);
 
-	to->di_size = be64_to_cpu(from->di_size);
-	to->di_nblocks = be64_to_cpu(from->di_nblocks);
-	to->di_extsize = be32_to_cpu(from->di_extsize);
-	to->di_nextents = be32_to_cpu(from->di_nextents);
-	to->di_anextents = be16_to_cpu(from->di_anextents);
-	to->di_forkoff = from->di_forkoff;
-	to->di_aformat	= from->di_aformat;
-	to->di_dmevmask	= be32_to_cpu(from->di_dmevmask);
-	to->di_dmstate	= be16_to_cpu(from->di_dmstate);
-	to->di_flags	= be16_to_cpu(from->di_flags);
-
-	if (to->di_version == 3) {
+	ip->i_disk_size = be64_to_cpu(from->di_size);
+	ip->i_nblocks = be64_to_cpu(from->di_nblocks);
+	ip->i_extsize = be32_to_cpu(from->di_extsize);
+	ip->i_nextents = be32_to_cpu(from->di_nextents);
+	ip->i_anextents = be16_to_cpu(from->di_anextents);
+	ip->i_forkoff = from->di_forkoff;
+	ip->i_aformat	= from->di_aformat;
+	ip->i_dmevmask	= be32_to_cpu(from->di_dmevmask);
+	ip->i_dmstate	= be16_to_cpu(from->di_dmstate);
+	ip->i_diflags	= be16_to_cpu(from->di_flags);
+
+	if (ip->i_version == 3) {
 		inode_set_iversion_queried(inode,
 					   be64_to_cpu(from->di_changecount));
-		to->di_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
-		to->di_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
-		to->di_flags2 = be64_to_cpu(from->di_flags2);
-		to->di_cowextsize = be32_to_cpu(from->di_cowextsize);
+		ip->i_crtime.tv_sec = be32_to_cpu(from->di_crtime.t_sec);
+		ip->i_crtime.tv_nsec = be32_to_cpu(from->di_crtime.t_nsec);
+		ip->i_diflags2 = be64_to_cpu(from->di_flags2);
+		ip->i_cowextsize = be32_to_cpu(from->di_cowextsize);
 	}
 }
 
@@ -268,18 +266,17 @@ xfs_inode_to_disk(
 	struct xfs_dinode	*to,
 	xfs_lsn_t		lsn)
 {
-	struct xfs_icdinode	*from = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
 	to->di_magic = cpu_to_be16(XFS_DINODE_MAGIC);
 	to->di_onlink = 0;
 
-	to->di_version = from->di_version;
-	to->di_format = from->di_format;
-	to->di_uid = cpu_to_be32(from->di_uid);
-	to->di_gid = cpu_to_be32(from->di_gid);
-	to->di_projid_lo = cpu_to_be16(from->di_projid & 0xffff);
-	to->di_projid_hi = cpu_to_be16(from->di_projid >> 16);
+	to->di_version = ip->i_version;
+	to->di_format = ip->i_format;
+	to->di_uid = cpu_to_be32(ip->i_uid);
+	to->di_gid = cpu_to_be32(ip->i_gid);
+	to->di_projid_lo = cpu_to_be16(ip->i_projid & 0xffff);
+	to->di_projid_hi = cpu_to_be16(ip->i_projid >> 16);
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
 	to->di_atime.t_sec = cpu_to_be32(inode->i_atime.tv_sec);
@@ -292,30 +289,30 @@ xfs_inode_to_disk(
 	to->di_gen = cpu_to_be32(inode->i_generation);
 	to->di_mode = cpu_to_be16(inode->i_mode);
 
-	to->di_size = cpu_to_be64(from->di_size);
-	to->di_nblocks = cpu_to_be64(from->di_nblocks);
-	to->di_extsize = cpu_to_be32(from->di_extsize);
-	to->di_nextents = cpu_to_be32(from->di_nextents);
-	to->di_anextents = cpu_to_be16(from->di_anextents);
-	to->di_forkoff = from->di_forkoff;
-	to->di_aformat = from->di_aformat;
-	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
-	to->di_dmstate = cpu_to_be16(from->di_dmstate);
-	to->di_flags = cpu_to_be16(from->di_flags);
-
-	if (from->di_version == 3) {
+	to->di_size = cpu_to_be64(ip->i_disk_size);
+	to->di_nblocks = cpu_to_be64(ip->i_nblocks);
+	to->di_extsize = cpu_to_be32(ip->i_extsize);
+	to->di_nextents = cpu_to_be32(ip->i_nextents);
+	to->di_anextents = cpu_to_be16(ip->i_anextents);
+	to->di_forkoff = ip->i_forkoff;
+	to->di_aformat = ip->i_aformat;
+	to->di_dmevmask = cpu_to_be32(ip->i_dmevmask);
+	to->di_dmstate = cpu_to_be16(ip->i_dmstate);
+	to->di_flags = cpu_to_be16(ip->i_diflags);
+
+	if (ip->i_version == 3) {
 		to->di_changecount = cpu_to_be64(inode_peek_iversion(inode));
-		to->di_crtime.t_sec = cpu_to_be32(from->di_crtime.tv_sec);
-		to->di_crtime.t_nsec = cpu_to_be32(from->di_crtime.tv_nsec);
-		to->di_flags2 = cpu_to_be64(from->di_flags2);
-		to->di_cowextsize = cpu_to_be32(from->di_cowextsize);
+		to->di_crtime.t_sec = cpu_to_be32(ip->i_crtime.tv_sec);
+		to->di_crtime.t_nsec = cpu_to_be32(ip->i_crtime.tv_nsec);
+		to->di_flags2 = cpu_to_be64(ip->i_diflags2);
+		to->di_cowextsize = cpu_to_be32(ip->i_cowextsize);
 		to->di_ino = cpu_to_be64(ip->i_ino);
 		to->di_lsn = cpu_to_be64(lsn);
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
 		to->di_flushiter = 0;
 	} else {
-		to->di_flushiter = cpu_to_be16(from->di_flushiter);
+		to->di_flushiter = cpu_to_be16(ip->i_flushiter);
 	}
 }
 
@@ -632,7 +629,7 @@ xfs_iread(
 	    xfs_sb_version_hascrc(&mp->m_sb) &&
 	    !(mp->m_flags & XFS_MOUNT_IKEEP)) {
 		VFS_I(ip)->i_generation = prandom_u32();
-		ip->i_d.di_version = 3;
+		ip->i_version = 3;
 		return 0;
 	}
 
@@ -674,9 +671,9 @@ xfs_iread(
 		 * Partial initialisation of the in-core inode. Just the bits
 		 * that xfs_ialloc won't overwrite or relies on being correct.
 		 */
-		ip->i_d.di_version = dip->di_version;
+		ip->i_version = dip->di_version;
 		VFS_I(ip)->i_generation = be32_to_cpu(dip->di_gen);
-		ip->i_d.di_flushiter = be16_to_cpu(dip->di_flushiter);
+		ip->i_flushiter = be16_to_cpu(dip->di_flushiter);
 
 		/*
 		 * Make sure to pull in the mode here as well in
@@ -688,7 +685,7 @@ xfs_iread(
 		VFS_I(ip)->i_mode = 0;
 	}
 
-	ASSERT(ip->i_d.di_version >= 2);
+	ASSERT(ip->i_version >= 2);
 	ip->i_delayed_blks = 0;
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_inode_buf.h b/fs/xfs/libxfs/xfs_inode_buf.h
index fd94b1078722..9c851f558805 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.h
+++ b/fs/xfs/libxfs/xfs_inode_buf.h
@@ -9,36 +9,6 @@
 struct xfs_inode;
 struct xfs_dinode;
 
-/*
- * In memory representation of the XFS inode. This is held in the in-core struct
- * xfs_inode and represents the current on disk values but the structure is not
- * in on-disk format.  That is, this structure is always translated to on-disk
- * format specific structures at the appropriate time.
- */
-struct xfs_icdinode {
-	int8_t		di_version;	/* inode version */
-	int8_t		di_format;	/* format of di_c data */
-	uint16_t	di_flushiter;	/* incremented on flush */
-	uint32_t	di_uid;		/* owner's user id */
-	uint32_t	di_gid;		/* owner's group id */
-	uint32_t	di_projid;	/* owner's project id */
-	xfs_fsize_t	di_size;	/* number of bytes in file */
-	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
-	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
-	xfs_extnum_t	di_nextents;	/* number of extents in data fork */
-	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
-	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
-	int8_t		di_aformat;	/* format of attr fork's data */
-	uint32_t	di_dmevmask;	/* DMIG event mask */
-	uint16_t	di_dmstate;	/* DMIG state info */
-	uint16_t	di_flags;	/* random flags, XFS_DIFLAG_... */
-
-	uint64_t	di_flags2;	/* more random flags */
-	uint32_t	di_cowextsize;	/* basic cow extent size for file */
-
-	struct timespec64 di_crtime;	/* time created */
-};
-
 /*
  * Inode location information.  Stored in the inode and passed to
  * xfs_imap_to_bp() to get a buffer and dinode for a given inode.
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index c643beeb5a24..7400fd13658c 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -55,7 +55,7 @@ xfs_iformat_fork(
 	case S_IFCHR:
 	case S_IFBLK:
 	case S_IFSOCK:
-		ip->i_d.di_size = 0;
+		ip->i_disk_size = 0;
 		inode->i_rdev = xfs_to_linux_dev_t(xfs_dinode_get_rdev(dip));
 		break;
 
@@ -291,7 +291,7 @@ xfs_iformat_btree(
 		     nrecs == 0 ||
 		     XFS_BMDR_SPACE_CALC(nrecs) >
 					XFS_DFORK_SIZE(dip, mp, whichfork) ||
-		     XFS_IFORK_NEXTENTS(ip, whichfork) > ip->i_d.di_nblocks) ||
+		     XFS_IFORK_NEXTENTS(ip, whichfork) > ip->i_nblocks) ||
 		     level == 0 || level > XFS_BTREE_MAXLEVELS) {
 		xfs_warn(mp, "corrupt inode %Lu (btree).",
 					(unsigned long long) ip->i_ino);
@@ -703,7 +703,7 @@ xfs_ifork_verify_data(
 	struct xfs_ifork_ops	*ops)
 {
 	/* Non-local data fork, we're done. */
-	if (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL)
+	if (ip->i_format != XFS_DINODE_FMT_LOCAL)
 		return NULL;
 
 	/* Check the inline data fork if there is one. */
@@ -724,7 +724,7 @@ xfs_ifork_verify_attr(
 	struct xfs_ifork_ops	*ops)
 {
 	/* There has to be an attr fork allocated if aformat is local. */
-	if (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)
+	if (ip->i_aformat != XFS_DINODE_FMT_LOCAL)
 		return NULL;
 	if (!XFS_IFORK_PTR(ip, XFS_ATTR_FORK))
 		return __this_address;
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index 00c62ce170d0..fa982c00c785 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -36,8 +36,8 @@ struct xfs_ifork {
  * Fork handling.
  */
 
-#define XFS_IFORK_Q(ip)			((ip)->i_d.di_forkoff != 0)
-#define XFS_IFORK_BOFF(ip)		((int)((ip)->i_d.di_forkoff << 3))
+#define XFS_IFORK_Q(ip)			((ip)->i_forkoff != 0)
+#define XFS_IFORK_BOFF(ip)		((int)((ip)->i_forkoff << 3))
 
 #define XFS_IFORK_PTR(ip,w)		\
 	((w) == XFS_DATA_FORK ? \
@@ -48,10 +48,10 @@ struct xfs_ifork {
 #define XFS_IFORK_DSIZE(ip) \
 	(XFS_IFORK_Q(ip) ? \
 		XFS_IFORK_BOFF(ip) : \
-		XFS_LITINO((ip)->i_mount, (ip)->i_d.di_version))
+		XFS_LITINO((ip)->i_mount, (ip)->i_version))
 #define XFS_IFORK_ASIZE(ip) \
 	(XFS_IFORK_Q(ip) ? \
-		XFS_LITINO((ip)->i_mount, (ip)->i_d.di_version) - \
+		XFS_LITINO((ip)->i_mount, (ip)->i_version) - \
 			XFS_IFORK_BOFF(ip) : \
 		0)
 #define XFS_IFORK_SIZE(ip,w) \
@@ -62,27 +62,27 @@ struct xfs_ifork {
 			0))
 #define XFS_IFORK_FORMAT(ip,w) \
 	((w) == XFS_DATA_FORK ? \
-		(ip)->i_d.di_format : \
+		(ip)->i_format : \
 		((w) == XFS_ATTR_FORK ? \
-			(ip)->i_d.di_aformat : \
+			(ip)->i_aformat : \
 			(ip)->i_cformat))
 #define XFS_IFORK_FMT_SET(ip,w,n) \
 	((w) == XFS_DATA_FORK ? \
-		((ip)->i_d.di_format = (n)) : \
+		((ip)->i_format = (n)) : \
 		((w) == XFS_ATTR_FORK ? \
-			((ip)->i_d.di_aformat = (n)) : \
+			((ip)->i_aformat = (n)) : \
 			((ip)->i_cformat = (n))))
 #define XFS_IFORK_NEXTENTS(ip,w) \
 	((w) == XFS_DATA_FORK ? \
-		(ip)->i_d.di_nextents : \
+		(ip)->i_nextents : \
 		((w) == XFS_ATTR_FORK ? \
-			(ip)->i_d.di_anextents : \
+			(ip)->i_anextents : \
 			(ip)->i_cnextents))
 #define XFS_IFORK_NEXT_SET(ip,w,n) \
 	((w) == XFS_DATA_FORK ? \
-		((ip)->i_d.di_nextents = (n)) : \
+		((ip)->i_nextents = (n)) : \
 		((w) == XFS_ATTR_FORK ? \
-			((ip)->i_d.di_anextents = (n)) : \
+			((ip)->i_anextents = (n)) : \
 			((ip)->i_cnextents = (n))))
 #define XFS_IFORK_MAXEXT(ip, w) \
 	(XFS_IFORK_SIZE(ip, w) / sizeof(xfs_bmbt_rec_t))
diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index 8ea1efc97b41..899291644368 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -997,8 +997,8 @@ xfs_rtfree_extent(
 	 */
 	if (tp->t_frextents_delta + mp->m_sb.sb_frextents ==
 	    mp->m_sb.sb_rextents) {
-		if (!(mp->m_rbmip->i_d.di_flags & XFS_DIFLAG_NEWRTBM))
-			mp->m_rbmip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
+		if (!(mp->m_rbmip->i_diflags & XFS_DIFLAG_NEWRTBM))
+			mp->m_rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
 		*(uint64_t *)&VFS_I(mp->m_rbmip)->i_atime = 0;
 		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
 	}
diff --git a/fs/xfs/libxfs/xfs_symlink_remote.c b/fs/xfs/libxfs/xfs_symlink_remote.c
index 3b8260ca7d1b..30589611cc64 100644
--- a/fs/xfs/libxfs/xfs_symlink_remote.c
+++ b/fs/xfs/libxfs/xfs_symlink_remote.c
@@ -209,7 +209,7 @@ xfs_symlink_shortform_verify(
 	struct xfs_ifork	*ifp;
 	int			size;
 
-	ASSERT(ip->i_d.di_format == XFS_DINODE_FMT_LOCAL);
+	ASSERT(ip->i_format == XFS_DINODE_FMT_LOCAL);
 	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	sfp = (char *)ifp->if_u1.if_data;
 	size = ifp->if_bytes;
diff --git a/fs/xfs/libxfs/xfs_trans_inode.c b/fs/xfs/libxfs/xfs_trans_inode.c
index b7b81c5de2de..7679b4df228a 100644
--- a/fs/xfs/libxfs/xfs_trans_inode.c
+++ b/fs/xfs/libxfs/xfs_trans_inode.c
@@ -67,7 +67,7 @@ xfs_trans_ichgtime(
 	if (flags & XFS_ICHGTIME_CHG)
 		inode->i_ctime = tv;
 	if (flags & XFS_ICHGTIME_CREATE)
-		ip->i_d.di_crtime = tv;
+		ip->i_crtime = tv;
 }
 
 /*
diff --git a/fs/xfs/scrub/common.c b/fs/xfs/scrub/common.c
index 18876056e5e0..254dc813696d 100644
--- a/fs/xfs/scrub/common.c
+++ b/fs/xfs/scrub/common.c
@@ -835,7 +835,7 @@ xchk_metadata_inode_forks(
 		return 0;
 
 	/* Metadata inodes don't live on the rt device. */
-	if (sc->ip->i_d.di_flags & XFS_DIFLAG_REALTIME) {
+	if (sc->ip->i_diflags & XFS_DIFLAG_REALTIME) {
 		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 		return 0;
 	}
diff --git a/fs/xfs/scrub/dir.c b/fs/xfs/scrub/dir.c
index 1e2e11721eb9..9ea123abc18a 100644
--- a/fs/xfs/scrub/dir.c
+++ b/fs/xfs/scrub/dir.c
@@ -515,7 +515,7 @@ xchk_directory_leaf1_bestfree(
 	 * There should be as many bestfree slots as there are dir data
 	 * blocks that can fit under i_size.
 	 */
-	if (bestcount != xfs_dir2_byte_to_db(geo, sc->ip->i_d.di_size)) {
+	if (bestcount != xfs_dir2_byte_to_db(geo, sc->ip->i_disk_size)) {
 		xchk_fblock_set_corrupt(sc, XFS_DATA_FORK, lblk);
 		goto out;
 	}
@@ -638,8 +638,8 @@ xchk_directory_blocks(
 	int			error;
 
 	/* Ignore local format directories. */
-	if (sc->ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS &&
-	    sc->ip->i_d.di_format != XFS_DINODE_FMT_BTREE)
+	if (sc->ip->i_format != XFS_DINODE_FMT_EXTENTS &&
+	    sc->ip->i_format != XFS_DINODE_FMT_BTREE)
 		return 0;
 
 	ifp = XFS_IFORK_PTR(sc->ip, XFS_DATA_FORK);
@@ -781,7 +781,7 @@ xchk_directory(
 		return -ENOENT;
 
 	/* Plausible size? */
-	if (sc->ip->i_d.di_size < xfs_dir2_sf_hdr_size(0)) {
+	if (sc->ip->i_disk_size < xfs_dir2_sf_hdr_size(0)) {
 		xchk_ino_set_corrupt(sc, sc->ip->i_ino);
 		goto out;
 	}
@@ -807,7 +807,7 @@ xchk_directory(
 	 * Userspace usually asks for a 32k buffer, so we will too.
 	 */
 	bufsize = (size_t)min_t(loff_t, XFS_READDIR_BUFSIZE,
-			sc->ip->i_d.di_size);
+			sc->ip->i_disk_size);
 
 	/*
 	 * Look up every name in this directory by hash.
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index c962bd534690..666f29edef48 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -79,7 +79,7 @@ xchk_parent_count_parent_dentries(
 	 * if there is one.
 	 */
 	lock_mode = xfs_ilock_data_map_shared(parent);
-	if (parent->i_d.di_nextents > 0)
+	if (parent->i_nextents > 0)
 		error = xfs_dir3_data_readahead(parent, 0, -1);
 	xfs_iunlock(parent, lock_mode);
 	if (error)
@@ -91,7 +91,7 @@ xchk_parent_count_parent_dentries(
 	 * scanned.
 	 */
 	bufsize = (size_t)min_t(loff_t, XFS_READDIR_BUFSIZE,
-			parent->i_d.di_size);
+			parent->i_disk_size);
 	oldpos = 0;
 	while (true) {
 		error = xfs_readdir(sc->tp, parent, &spc.dc, bufsize);
diff --git a/fs/xfs/scrub/symlink.c b/fs/xfs/scrub/symlink.c
index 5641ae512c9e..9b751d79adf0 100644
--- a/fs/xfs/scrub/symlink.c
+++ b/fs/xfs/scrub/symlink.c
@@ -43,7 +43,7 @@ xchk_symlink(
 	if (!S_ISLNK(VFS_I(ip)->i_mode))
 		return -ENOENT;
 	ifp = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
-	len = ip->i_d.di_size;
+	len = ip->i_disk_size;
 
 	/* Plausible size? */
 	if (len > XFS_SYMLINK_MAXLEN || len <= 0) {
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index f16d5f196c6b..ecff037ce563 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -122,7 +122,7 @@ xfs_destroy_ioend(
 static inline bool xfs_ioend_is_append(struct xfs_ioend *ioend)
 {
 	return ioend->io_offset + ioend->io_size >
-		XFS_I(ioend->io_inode)->i_d.di_size;
+		XFS_I(ioend->io_inode)->i_disk_size;
 }
 
 STATIC int
@@ -174,7 +174,7 @@ __xfs_setfilesize(
 
 	trace_xfs_setfilesize(ip, offset, size);
 
-	ip->i_d.di_size = isize;
+	ip->i_disk_size = isize;
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
@@ -530,7 +530,7 @@ xfs_map_blocks(
 	 */
 retry:
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
-	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
+	ASSERT(ip->i_format != XFS_DINODE_FMT_BTREE ||
 	       (ip->i_df.if_flags & XFS_IFEXTENTS));
 
 	/*
diff --git a/fs/xfs/xfs_attr_inactive.c b/fs/xfs/xfs_attr_inactive.c
index a640a285cc52..34aa5e911f19 100644
--- a/fs/xfs/xfs_attr_inactive.c
+++ b/fs/xfs/xfs_attr_inactive.c
@@ -412,8 +412,7 @@ xfs_attr_inactive(
 	 * blocks to read and returns an error. In this case, just do the fork
 	 * removal below.
 	 */
-	if (xfs_inode_hasattr(dp) &&
-	    dp->i_d.di_aformat != XFS_DINODE_FMT_LOCAL) {
+	if (xfs_inode_hasattr(dp) && dp->i_aformat != XFS_DINODE_FMT_LOCAL) {
 		error = xfs_attr3_root_inactive(&trans, dp);
 		if (error)
 			goto out_cancel;
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 00758fdc2fec..4a06ea8de53b 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -501,7 +501,7 @@ xfs_attr_list_int_ilocked(
 	 */
 	if (!xfs_inode_hasattr(dp))
 		return 0;
-	else if (dp->i_d.di_aformat == XFS_DINODE_FMT_LOCAL)
+	else if (dp->i_aformat == XFS_DINODE_FMT_LOCAL)
 		return xfs_attr_shortform_list(context);
 	else if (xfs_bmap_one_block(dp, XFS_ATTR_FORK))
 		return xfs_attr_leaf_list(context);
diff --git a/fs/xfs/xfs_bmap_util.c b/fs/xfs/xfs_bmap_util.c
index 4f443703065e..dd8095e71c31 100644
--- a/fs/xfs/xfs_bmap_util.c
+++ b/fs/xfs/xfs_bmap_util.c
@@ -153,7 +153,7 @@ xfs_bmap_rtalloc(
 		ap->blkno *= mp->m_sb.sb_rextsize;
 		ralen *= mp->m_sb.sb_rextsize;
 		ap->length = ralen;
-		ap->ip->i_d.di_nblocks += ralen;
+		ap->ip->i_nblocks += ralen;
 		xfs_trans_log_inode(ap->tp, ap->ip, XFS_ILOG_CORE);
 		if (ap->wasdel)
 			ap->ip->i_delayed_blks -= ralen;
@@ -562,7 +562,7 @@ xfs_getbmap(
 		break;
 	case XFS_DATA_FORK:
 		if (!(iflags & BMV_IF_DELALLOC) &&
-		    (ip->i_delayed_blks || XFS_ISIZE(ip) > ip->i_d.di_size)) {
+		    (ip->i_delayed_blks || XFS_ISIZE(ip) > ip->i_disk_size)) {
 			error = filemap_write_and_wait(VFS_I(ip)->i_mapping);
 			if (error)
 				goto out_unlock_iolock;
@@ -578,7 +578,7 @@ xfs_getbmap(
 		}
 
 		if (xfs_get_extsz_hint(ip) ||
-		    (ip->i_d.di_flags &
+		    (ip->i_diflags &
 		     (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND)))
 			max_len = mp->m_super->s_maxbytes;
 		else
@@ -759,7 +759,7 @@ xfs_can_free_eofblocks(struct xfs_inode *ip, bool force)
 	 * Do not free real preallocated or append-only files unless the file
 	 * has delalloc blocks and we are forced to remove them.
 	 */
-	if (ip->i_d.di_flags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
+	if (ip->i_diflags & (XFS_DIFLAG_PREALLOC | XFS_DIFLAG_APPEND))
 		if (!force || ip->i_delayed_blks == 0)
 			return false;
 
@@ -1374,15 +1374,15 @@ xfs_swap_extents_check_format(
 {
 
 	/* Should never get a local format */
-	if (ip->i_d.di_format == XFS_DINODE_FMT_LOCAL ||
-	    tip->i_d.di_format == XFS_DINODE_FMT_LOCAL)
+	if (ip->i_format == XFS_DINODE_FMT_LOCAL ||
+	    tip->i_format == XFS_DINODE_FMT_LOCAL)
 		return -EINVAL;
 
 	/*
 	 * if the target inode has less extents that then temporary inode then
 	 * why did userspace call us?
 	 */
-	if (ip->i_d.di_nextents < tip->i_d.di_nextents)
+	if (ip->i_nextents < tip->i_nextents)
 		return -EINVAL;
 
 	/*
@@ -1397,18 +1397,18 @@ xfs_swap_extents_check_format(
 	 * form then we will end up with the target inode in the wrong format
 	 * as we already know there are less extents in the temp inode.
 	 */
-	if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
-	    tip->i_d.di_format == XFS_DINODE_FMT_BTREE)
+	if (ip->i_format == XFS_DINODE_FMT_EXTENTS &&
+	    tip->i_format == XFS_DINODE_FMT_BTREE)
 		return -EINVAL;
 
 	/* Check temp in extent form to max in target */
-	if (tip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
+	if (tip->i_format == XFS_DINODE_FMT_EXTENTS &&
 	    XFS_IFORK_NEXTENTS(tip, XFS_DATA_FORK) >
 			XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK))
 		return -EINVAL;
 
 	/* Check target in extent form to max in temp */
-	if (ip->i_d.di_format == XFS_DINODE_FMT_EXTENTS &&
+	if (ip->i_format == XFS_DINODE_FMT_EXTENTS &&
 	    XFS_IFORK_NEXTENTS(ip, XFS_DATA_FORK) >
 			XFS_IFORK_MAXEXT(tip, XFS_DATA_FORK))
 		return -EINVAL;
@@ -1422,7 +1422,7 @@ xfs_swap_extents_check_format(
 	 * (a common defrag case) which will occur when the temp inode is in
 	 * extent format...
 	 */
-	if (tip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
+	if (tip->i_format == XFS_DINODE_FMT_BTREE) {
 		if (XFS_IFORK_Q(ip) &&
 		    XFS_BMAP_BMDR_SPACE(tip->i_df.if_broot) > XFS_IFORK_BOFF(ip))
 			return -EINVAL;
@@ -1432,7 +1432,7 @@ xfs_swap_extents_check_format(
 	}
 
 	/* Reciprocal target->temp btree format checks */
-	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE) {
+	if (ip->i_format == XFS_DINODE_FMT_BTREE) {
 		if (XFS_IFORK_Q(tip) &&
 		    XFS_BMAP_BMDR_SPACE(ip->i_df.if_broot) > XFS_IFORK_BOFF(tip))
 			return -EINVAL;
@@ -1489,9 +1489,9 @@ xfs_swap_extent_rmap(
 	 * rmap functions when we go to fix up the rmaps.  The flags
 	 * will be switch for reals later.
 	 */
-	tip_flags2 = tip->i_d.di_flags2;
-	if (ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK)
-		tip->i_d.di_flags2 |= XFS_DIFLAG2_REFLINK;
+	tip_flags2 = tip->i_diflags2;
+	if (ip->i_diflags2 & XFS_DIFLAG2_REFLINK)
+		tip->i_diflags2 |= XFS_DIFLAG2_REFLINK;
 
 	offset_fsb = 0;
 	end_fsb = XFS_B_TO_FSB(ip->i_mount, i_size_read(VFS_I(ip)));
@@ -1562,12 +1562,12 @@ xfs_swap_extent_rmap(
 		offset_fsb += ilen;
 	}
 
-	tip->i_d.di_flags2 = tip_flags2;
+	tip->i_diflags2 = tip_flags2;
 	return 0;
 
 out:
 	trace_xfs_swap_extent_rmap_error(ip, error, _RET_IP_);
-	tip->i_d.di_flags2 = tip_flags2;
+	tip->i_diflags2 = tip_flags2;
 	return error;
 }
 
@@ -1589,15 +1589,15 @@ xfs_swap_extent_forks(
 	/*
 	 * Count the number of extended attribute blocks
 	 */
-	if ( ((XFS_IFORK_Q(ip) != 0) && (ip->i_d.di_anextents > 0)) &&
-	     (ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)) {
+	if ( ((XFS_IFORK_Q(ip) != 0) && (ip->i_anextents > 0)) &&
+	     (ip->i_aformat != XFS_DINODE_FMT_LOCAL)) {
 		error = xfs_bmap_count_blocks(tp, ip, XFS_ATTR_FORK, &junk,
 				&aforkblks);
 		if (error)
 			return error;
 	}
-	if ( ((XFS_IFORK_Q(tip) != 0) && (tip->i_d.di_anextents > 0)) &&
-	     (tip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL)) {
+	if ( ((XFS_IFORK_Q(tip) != 0) && (tip->i_anextents > 0)) &&
+	     (tip->i_aformat != XFS_DINODE_FMT_LOCAL)) {
 		error = xfs_bmap_count_blocks(tp, tip, XFS_ATTR_FORK, &junk,
 				&taforkblks);
 		if (error)
@@ -1611,11 +1611,11 @@ xfs_swap_extent_forks(
 	 * event of a crash. Set the owner change log flags now and leave the
 	 * bmbt scan as the last step.
 	 */
-	if (ip->i_d.di_version == 3 &&
-	    ip->i_d.di_format == XFS_DINODE_FMT_BTREE)
+	if (ip->i_version == 3 &&
+	    ip->i_format == XFS_DINODE_FMT_BTREE)
 		(*target_log_flags) |= XFS_ILOG_DOWNER;
-	if (tip->i_d.di_version == 3 &&
-	    tip->i_d.di_format == XFS_DINODE_FMT_BTREE)
+	if (tip->i_version == 3 &&
+	    tip->i_format == XFS_DINODE_FMT_BTREE)
 		(*src_log_flags) |= XFS_ILOG_DOWNER;
 
 	/*
@@ -1626,12 +1626,12 @@ xfs_swap_extent_forks(
 	/*
 	 * Fix the on-disk inode values
 	 */
-	tmp = (uint64_t)ip->i_d.di_nblocks;
-	ip->i_d.di_nblocks = tip->i_d.di_nblocks - taforkblks + aforkblks;
-	tip->i_d.di_nblocks = tmp + taforkblks - aforkblks;
+	tmp = (uint64_t)ip->i_nblocks;
+	ip->i_nblocks = tip->i_nblocks - taforkblks + aforkblks;
+	tip->i_nblocks = tmp + taforkblks - aforkblks;
 
-	swap(ip->i_d.di_nextents, tip->i_d.di_nextents);
-	swap(ip->i_d.di_format, tip->i_d.di_format);
+	swap(ip->i_nextents, tip->i_nextents);
+	swap(ip->i_format, tip->i_format);
 
 	/*
 	 * The extents in the source inode could still contain speculative
@@ -1646,24 +1646,24 @@ xfs_swap_extent_forks(
 	tip->i_delayed_blks = ip->i_delayed_blks;
 	ip->i_delayed_blks = 0;
 
-	switch (ip->i_d.di_format) {
+	switch (ip->i_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		(*src_log_flags) |= XFS_ILOG_DEXT;
 		break;
 	case XFS_DINODE_FMT_BTREE:
-		ASSERT(ip->i_d.di_version < 3 ||
+		ASSERT(ip->i_version < 3 ||
 		       (*src_log_flags & XFS_ILOG_DOWNER));
 		(*src_log_flags) |= XFS_ILOG_DBROOT;
 		break;
 	}
 
-	switch (tip->i_d.di_format) {
+	switch (tip->i_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		(*target_log_flags) |= XFS_ILOG_DEXT;
 		break;
 	case XFS_DINODE_FMT_BTREE:
 		(*target_log_flags) |= XFS_ILOG_DBROOT;
-		ASSERT(tip->i_d.di_version < 3 ||
+		ASSERT(tip->i_version < 3 ||
 		       (*target_log_flags & XFS_ILOG_DOWNER));
 		break;
 	}
@@ -1808,8 +1808,8 @@ xfs_swap_extents(
 
 	/* Verify all data are being swapped */
 	if (sxp->sx_offset != 0 ||
-	    sxp->sx_length != ip->i_d.di_size ||
-	    sxp->sx_length != tip->i_d.di_size) {
+	    sxp->sx_length != ip->i_disk_size ||
+	    sxp->sx_length != tip->i_disk_size) {
 		error = -EFAULT;
 		goto out_trans_cancel;
 	}
@@ -1860,13 +1860,13 @@ xfs_swap_extents(
 		goto out_trans_cancel;
 
 	/* Do we have to swap reflink flags? */
-	if ((ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK) ^
-	    (tip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK)) {
-		f = ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
-		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
-		ip->i_d.di_flags2 |= tip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
-		tip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
-		tip->i_d.di_flags2 |= f & XFS_DIFLAG2_REFLINK;
+	if ((ip->i_diflags2 & XFS_DIFLAG2_REFLINK) ^
+	    (tip->i_diflags2 & XFS_DIFLAG2_REFLINK)) {
+		f = ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
+		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+		ip->i_diflags2 |= tip->i_diflags2 & XFS_DIFLAG2_REFLINK;
+		tip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
+		tip->i_diflags2 |= f & XFS_DIFLAG2_REFLINK;
 	}
 
 	/* Swap the cow forks. */
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index 283df898dd9f..359c8fc92fc1 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -56,7 +56,7 @@ xfs_dir2_sf_getdents(
 	struct xfs_da_geometry	*geo = args->geo;
 
 	ASSERT(dp->i_df.if_flags & XFS_IFINLINE);
-	ASSERT(dp->i_df.if_bytes == dp->i_d.di_size);
+	ASSERT(dp->i_df.if_bytes == dp->i_disk_size);
 	ASSERT(dp->i_df.if_u1.if_data != NULL);
 
 	sfp = (xfs_dir2_sf_hdr_t *)dp->i_df.if_u1.if_data;
@@ -513,7 +513,7 @@ xfs_readdir(
 	args.geo = dp->i_mount->m_dir_geo;
 	args.trans = tp;
 
-	if (dp->i_d.di_format == XFS_DINODE_FMT_LOCAL)
+	if (dp->i_format == XFS_DINODE_FMT_LOCAL)
 		rval = xfs_dir2_sf_getdents(&args, ctx);
 	else if ((rval = xfs_dir2_isblock(&args, &v)))
 		;
diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 12074c1d250c..4d8efdc17da9 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -829,11 +829,11 @@ xfs_qm_id_for_quotatype(
 {
 	switch (type) {
 	case XFS_DQ_USER:
-		return ip->i_d.di_uid;
+		return ip->i_uid;
 	case XFS_DQ_GROUP:
-		return ip->i_d.di_gid;
+		return ip->i_gid;
 	case XFS_DQ_PROJ:
-		return ip->i_d.di_projid;
+		return ip->i_projid;
 	}
 	ASSERT(0);
 	return 0;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 1ffb179f35d2..fdb05077a79c 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -56,9 +56,9 @@ xfs_update_prealloc_flags(
 	}
 
 	if (flags & XFS_PREALLOC_SET)
-		ip->i_d.di_flags |= XFS_DIFLAG_PREALLOC;
+		ip->i_diflags |= XFS_DIFLAG_PREALLOC;
 	if (flags & XFS_PREALLOC_CLEAR)
-		ip->i_d.di_flags &= ~XFS_DIFLAG_PREALLOC;
+		ip->i_diflags &= ~XFS_DIFLAG_PREALLOC;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	if (flags & XFS_PREALLOC_SYNC)
@@ -1012,10 +1012,10 @@ xfs_file_remap_range(
 	 */
 	cowextsize = 0;
 	if (pos_in == 0 && len == i_size_read(inode_in) &&
-	    (src->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) &&
+	    (src->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) &&
 	    pos_out == 0 && len >= i_size_read(inode_out) &&
-	    !(dest->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
-		cowextsize = src->i_d.di_cowextsize;
+	    !(dest->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE))
+		cowextsize = src->i_cowextsize;
 
 	ret = xfs_reflink_update_dest(dest, pos_out + len, cowextsize,
 			remap_flags);
@@ -1058,7 +1058,7 @@ xfs_dir_open(
 	 * certain to have the next operation be a read there.
 	 */
 	mode = xfs_ilock_data_map_shared(ip);
-	if (ip->i_d.di_nextents > 0)
+	if (ip->i_nextents > 0)
 		error = xfs_dir3_data_readahead(ip, 0, -1);
 	xfs_iunlock(ip, mode);
 	return error;
@@ -1093,7 +1093,7 @@ xfs_file_readdir(
 	 * point we can change the ->readdir prototype to include the
 	 * buffer size.  For now we use the current glibc buffer size.
 	 */
-	bufsize = (size_t)min_t(loff_t, XFS_READDIR_BUFSIZE, ip->i_d.di_size);
+	bufsize = (size_t)min_t(loff_t, XFS_READDIR_BUFSIZE, ip->i_disk_size);
 
 	return xfs_readdir(NULL, ip, ctx, bufsize);
 }
diff --git a/fs/xfs/xfs_filestream.h b/fs/xfs/xfs_filestream.h
index 5cc7665e93c9..3af963743e4d 100644
--- a/fs/xfs/xfs_filestream.h
+++ b/fs/xfs/xfs_filestream.h
@@ -22,7 +22,7 @@ xfs_inode_is_filestream(
 	struct xfs_inode	*ip)
 {
 	return (ip->i_mount->m_flags & XFS_MOUNT_FILESTREAMS) ||
-		(ip->i_d.di_flags & XFS_DIFLAG_FILESTREAM);
+		(ip->i_diflags & XFS_DIFLAG_FILESTREAM);
 }
 
 #endif /* __XFS_FILESTREAM_H__ */
diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index ec302b7e48f3..df755de3705c 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -62,12 +62,34 @@ xfs_inode_alloc(
 	memset(&ip->i_imap, 0, sizeof(struct xfs_imap));
 	ip->i_afp = NULL;
 	ip->i_cowfp = NULL;
-	ip->i_cnextents = 0;
-	ip->i_cformat = XFS_DINODE_FMT_EXTENTS;
 	memset(&ip->i_df, 0, sizeof(ip->i_df));
+
 	ip->i_flags = 0;
 	ip->i_delayed_blks = 0;
-	memset(&ip->i_d, 0, sizeof(ip->i_d));
+
+	ip->i_version = 0;
+	ip->i_format = 0;
+	ip->i_flushiter = 0;
+	ip->i_uid = 0;
+	ip->i_gid = 0;
+	ip->i_projid = 0;
+	ip->i_disk_size = 0;
+	ip->i_nblocks = 0;
+	ip->i_extsize = 0;
+	ip->i_nextents = 0;
+	ip->i_anextents = 0;
+	ip->i_forkoff = 0;
+	ip->i_aformat = 0;
+	ip->i_dmevmask = 0;
+	ip->i_dmstate = 0;
+	ip->i_diflags = 0;
+	ip->i_diflags2 = 0;
+	ip->i_cowextsize = 0;
+	ip->i_crtime.tv_sec = 0;
+	ip->i_crtime.tv_nsec = 0;
+	ip->i_cnextents = 0;
+	ip->i_cformat = XFS_DINODE_FMT_EXTENTS;
+
 	ip->i_sick = 0;
 	ip->i_checked = 0;
 	INIT_WORK(&ip->i_ioend_work, xfs_end_io);
@@ -324,7 +346,7 @@ xfs_iget_check_free_state(
 			return -EFSCORRUPTED;
 		}
 
-		if (ip->i_d.di_nblocks != 0) {
+		if (ip->i_nblocks != 0) {
 			xfs_warn(ip->i_mount,
 "Corruption detected! Free inode 0x%llx has blocks allocated!",
 				ip->i_ino);
@@ -1419,7 +1441,7 @@ xfs_inode_match_id(
 		return 0;
 
 	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
-	    ip->i_d.di_projid != eofb->eof_prid)
+	    ip->i_projid != eofb->eof_prid)
 		return 0;
 
 	return 1;
@@ -1443,7 +1465,7 @@ xfs_inode_match_id_union(
 		return 1;
 
 	if ((eofb->eof_flags & XFS_EOF_FLAGS_PRID) &&
-	    ip->i_d.di_projid == eofb->eof_prid)
+	    ip->i_projid == eofb->eof_prid)
 		return 1;
 
 	return 0;
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 685c21d0a6ca..3d9e2ff3065c 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -55,8 +55,8 @@ xfs_extlen_t
 xfs_get_extsz_hint(
 	struct xfs_inode	*ip)
 {
-	if ((ip->i_d.di_flags & XFS_DIFLAG_EXTSIZE) && ip->i_d.di_extsize)
-		return ip->i_d.di_extsize;
+	if ((ip->i_diflags & XFS_DIFLAG_EXTSIZE) && ip->i_extsize)
+		return ip->i_extsize;
 	if (XFS_IS_REALTIME_INODE(ip))
 		return ip->i_mount->m_sb.sb_rextsize;
 	return 0;
@@ -75,8 +75,8 @@ xfs_get_cowextsz_hint(
 	xfs_extlen_t		a, b;
 
 	a = 0;
-	if (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
-		a = ip->i_d.di_cowextsize;
+	if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
+		a = ip->i_cowextsize;
 	b = xfs_get_extsz_hint(ip);
 
 	a = max(a, b);
@@ -106,7 +106,7 @@ xfs_ilock_data_map_shared(
 {
 	uint			lock_mode = XFS_ILOCK_SHARED;
 
-	if (ip->i_d.di_format == XFS_DINODE_FMT_BTREE &&
+	if (ip->i_format == XFS_DINODE_FMT_BTREE &&
 	    (ip->i_df.if_flags & XFS_IFEXTENTS) == 0)
 		lock_mode = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, lock_mode);
@@ -119,7 +119,7 @@ xfs_ilock_attr_map_shared(
 {
 	uint			lock_mode = XFS_ILOCK_SHARED;
 
-	if (ip->i_d.di_aformat == XFS_DINODE_FMT_BTREE &&
+	if (ip->i_aformat == XFS_DINODE_FMT_BTREE &&
 	    (ip->i_afp->if_flags & XFS_IFEXTENTS) == 0)
 		lock_mode = XFS_ILOCK_EXCL;
 	xfs_ilock(ip, lock_mode);
@@ -664,9 +664,8 @@ uint
 xfs_ip2xflags(
 	struct xfs_inode	*ip)
 {
-	struct xfs_icdinode	*dic = &ip->i_d;
-
-	return _xfs_dic2xflags(dic->di_flags, dic->di_flags2, XFS_IFORK_Q(ip));
+	return _xfs_dic2xflags(ip->i_diflags, ip->i_diflags2,
+			XFS_IFORK_Q(ip));
 }
 
 /*
@@ -801,18 +800,18 @@ xfs_ialloc(
 	 * with >= v2 inode capability, so there is no reason for ever leaving
 	 * an inode in v1 format.
 	 */
-	if (ip->i_d.di_version == 1)
-		ip->i_d.di_version = 2;
+	if (ip->i_version == 1)
+		ip->i_version = 2;
 
 	inode->i_mode = mode;
 	set_nlink(inode, nlink);
-	ip->i_d.di_uid = xfs_kuid_to_uid(current_fsuid());
-	ip->i_d.di_gid = xfs_kgid_to_gid(current_fsgid());
+	ip->i_uid = xfs_kuid_to_uid(current_fsuid());
+	ip->i_gid = xfs_kgid_to_gid(current_fsgid());
 	inode->i_rdev = rdev;
-	ip->i_d.di_projid = prid;
+	ip->i_projid = prid;
 
 	if (pip && XFS_INHERIT_GID(pip)) {
-		ip->i_d.di_gid = pip->i_d.di_gid;
+		ip->i_gid = pip->i_gid;
 		if ((VFS_I(pip)->i_mode & S_ISGID) && S_ISDIR(mode))
 			inode->i_mode |= S_ISGID;
 	}
@@ -824,28 +823,28 @@ xfs_ialloc(
 	 */
 	if ((irix_sgid_inherit) &&
 	    (inode->i_mode & S_ISGID) &&
-	    (!in_group_p(xfs_gid_to_kgid(ip->i_d.di_gid))))
+	    (!in_group_p(xfs_gid_to_kgid(ip->i_gid))))
 		inode->i_mode &= ~S_ISGID;
 
-	ip->i_d.di_size = 0;
-	ip->i_d.di_nextents = 0;
-	ASSERT(ip->i_d.di_nblocks == 0);
+	ip->i_disk_size = 0;
+	ip->i_nextents = 0;
+	ASSERT(ip->i_nblocks == 0);
 
 	tv = current_time(inode);
 	inode->i_mtime = tv;
 	inode->i_atime = tv;
 	inode->i_ctime = tv;
 
-	ip->i_d.di_extsize = 0;
-	ip->i_d.di_dmevmask = 0;
-	ip->i_d.di_dmstate = 0;
-	ip->i_d.di_flags = 0;
+	ip->i_extsize = 0;
+	ip->i_dmevmask = 0;
+	ip->i_dmstate = 0;
+	ip->i_diflags = 0;
 
-	if (ip->i_d.di_version == 3) {
+	if (ip->i_version == 3) {
 		inode_set_iversion(inode, 1);
-		ip->i_d.di_flags2 = 0;
-		ip->i_d.di_cowextsize = 0;
-		ip->i_d.di_crtime = tv;
+		ip->i_diflags2 = 0;
+		ip->i_cowextsize = 0;
+		ip->i_crtime = tv;
 	}
 
 
@@ -855,70 +854,70 @@ xfs_ialloc(
 	case S_IFCHR:
 	case S_IFBLK:
 	case S_IFSOCK:
-		ip->i_d.di_format = XFS_DINODE_FMT_DEV;
+		ip->i_format = XFS_DINODE_FMT_DEV;
 		ip->i_df.if_flags = 0;
 		flags |= XFS_ILOG_DEV;
 		break;
 	case S_IFREG:
 	case S_IFDIR:
-		if (pip && (pip->i_d.di_flags & XFS_DIFLAG_ANY)) {
+		if (pip && (pip->i_diflags & XFS_DIFLAG_ANY)) {
 			uint		di_flags = 0;
 
 			if (S_ISDIR(mode)) {
-				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+				if (pip->i_diflags & XFS_DIFLAG_RTINHERIT)
 					di_flags |= XFS_DIFLAG_RTINHERIT;
-				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
+				if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
 					di_flags |= XFS_DIFLAG_EXTSZINHERIT;
-					ip->i_d.di_extsize = pip->i_d.di_extsize;
+					ip->i_extsize = pip->i_extsize;
 				}
-				if (pip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
+				if (pip->i_diflags & XFS_DIFLAG_PROJINHERIT)
 					di_flags |= XFS_DIFLAG_PROJINHERIT;
 			} else if (S_ISREG(mode)) {
-				if (pip->i_d.di_flags & XFS_DIFLAG_RTINHERIT)
+				if (pip->i_diflags & XFS_DIFLAG_RTINHERIT)
 					di_flags |= XFS_DIFLAG_REALTIME;
-				if (pip->i_d.di_flags & XFS_DIFLAG_EXTSZINHERIT) {
+				if (pip->i_diflags & XFS_DIFLAG_EXTSZINHERIT) {
 					di_flags |= XFS_DIFLAG_EXTSIZE;
-					ip->i_d.di_extsize = pip->i_d.di_extsize;
+					ip->i_extsize = pip->i_extsize;
 				}
 			}
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NOATIME) &&
+			if ((pip->i_diflags & XFS_DIFLAG_NOATIME) &&
 			    xfs_inherit_noatime)
 				di_flags |= XFS_DIFLAG_NOATIME;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NODUMP) &&
+			if ((pip->i_diflags & XFS_DIFLAG_NODUMP) &&
 			    xfs_inherit_nodump)
 				di_flags |= XFS_DIFLAG_NODUMP;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_SYNC) &&
+			if ((pip->i_diflags & XFS_DIFLAG_SYNC) &&
 			    xfs_inherit_sync)
 				di_flags |= XFS_DIFLAG_SYNC;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) &&
+			if ((pip->i_diflags & XFS_DIFLAG_NOSYMLINKS) &&
 			    xfs_inherit_nosymlinks)
 				di_flags |= XFS_DIFLAG_NOSYMLINKS;
-			if ((pip->i_d.di_flags & XFS_DIFLAG_NODEFRAG) &&
+			if ((pip->i_diflags & XFS_DIFLAG_NODEFRAG) &&
 			    xfs_inherit_nodefrag)
 				di_flags |= XFS_DIFLAG_NODEFRAG;
-			if (pip->i_d.di_flags & XFS_DIFLAG_FILESTREAM)
+			if (pip->i_diflags & XFS_DIFLAG_FILESTREAM)
 				di_flags |= XFS_DIFLAG_FILESTREAM;
 
-			ip->i_d.di_flags |= di_flags;
+			ip->i_diflags |= di_flags;
 		}
 		if (pip &&
-		    (pip->i_d.di_flags2 & XFS_DIFLAG2_ANY) &&
-		    pip->i_d.di_version == 3 &&
-		    ip->i_d.di_version == 3) {
+		    (pip->i_diflags2 & XFS_DIFLAG2_ANY) &&
+		    pip->i_version == 3 &&
+		    ip->i_version == 3) {
 			uint64_t	di_flags2 = 0;
 
-			if (pip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE) {
+			if (pip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE) {
 				di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
-				ip->i_d.di_cowextsize = pip->i_d.di_cowextsize;
+				ip->i_cowextsize = pip->i_cowextsize;
 			}
-			if (pip->i_d.di_flags2 & XFS_DIFLAG2_DAX)
+			if (pip->i_diflags2 & XFS_DIFLAG2_DAX)
 				di_flags2 |= XFS_DIFLAG2_DAX;
 
-			ip->i_d.di_flags2 |= di_flags2;
+			ip->i_diflags2 |= di_flags2;
 		}
 		/* FALLTHROUGH */
 	case S_IFLNK:
-		ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
+		ip->i_format = XFS_DINODE_FMT_EXTENTS;
 		ip->i_df.if_flags = XFS_IFEXTENTS;
 		ip->i_df.if_bytes = 0;
 		ip->i_df.if_u1.if_root = NULL;
@@ -929,8 +928,8 @@ xfs_ialloc(
 	/*
 	 * Attribute fork settings for new inode.
 	 */
-	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
-	ip->i_d.di_anextents = 0;
+	ip->i_aformat = XFS_DINODE_FMT_EXTENTS;
+	ip->i_anextents = 0;
 
 	/*
 	 * Log the new values stuffed into the inode.
@@ -1116,7 +1115,7 @@ xfs_bumplink(
 {
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
 
-	ASSERT(ip->i_d.di_version > 1);
+	ASSERT(ip->i_version > 1);
 	inc_nlink(VFS_I(ip));
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 }
@@ -1416,8 +1415,8 @@ xfs_link(
 	 * creation in our tree when the project IDs are the same; else
 	 * the tree quota mechanism could be circumvented.
 	 */
-	if (unlikely((tdp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     tdp->i_d.di_projid != sip->i_d.di_projid)) {
+	if (unlikely((tdp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
+		     tdp->i_projid != sip->i_projid)) {
 		error = -EXDEV;
 		goto error_return;
 	}
@@ -1475,7 +1474,7 @@ xfs_itruncate_clear_reflink_flags(
 	dfork = XFS_IFORK_PTR(ip, XFS_DATA_FORK);
 	cfork = XFS_IFORK_PTR(ip, XFS_COW_FORK);
 	if (dfork->if_bytes == 0 && cfork->if_bytes == 0)
-		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
 	if (cfork->if_bytes == 0)
 		xfs_inode_clear_cowblocks_tag(ip);
 }
@@ -1695,14 +1694,14 @@ xfs_inactive_truncate(
 	 * of a system crash before the truncate completes. See the related
 	 * comment in xfs_vn_setattr_size() for details.
 	 */
-	ip->i_d.di_size = 0;
+	ip->i_disk_size = 0;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);
 	if (error)
 		goto error_trans_cancel;
 
-	ASSERT(ip->i_d.di_nextents == 0);
+	ASSERT(ip->i_nextents == 0);
 
 	error = xfs_trans_commit(tp);
 	if (error)
@@ -1851,8 +1850,8 @@ xfs_inactive(
 	}
 
 	if (S_ISREG(VFS_I(ip)->i_mode) &&
-	    (ip->i_d.di_size != 0 || XFS_ISIZE(ip) != 0 ||
-	     ip->i_d.di_nextents > 0 || ip->i_delayed_blks > 0))
+	    (ip->i_disk_size != 0 || XFS_ISIZE(ip) != 0 ||
+	     ip->i_nextents > 0 || ip->i_delayed_blks > 0))
 		truncate = 1;
 
 	error = xfs_qm_dqattach(ip);
@@ -1878,8 +1877,8 @@ xfs_inactive(
 	}
 
 	ASSERT(!ip->i_afp);
-	ASSERT(ip->i_d.di_anextents == 0);
-	ASSERT(ip->i_d.di_forkoff == 0);
+	ASSERT(ip->i_anextents == 0);
+	ASSERT(ip->i_forkoff == 0);
 
 	/*
 	 * Free the inode.
@@ -2740,10 +2739,10 @@ xfs_ifree(
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 	ASSERT(VFS_I(ip)->i_nlink == 0);
-	ASSERT(ip->i_d.di_nextents == 0);
-	ASSERT(ip->i_d.di_anextents == 0);
-	ASSERT(ip->i_d.di_size == 0 || !S_ISREG(VFS_I(ip)->i_mode));
-	ASSERT(ip->i_d.di_nblocks == 0);
+	ASSERT(ip->i_nextents == 0);
+	ASSERT(ip->i_anextents == 0);
+	ASSERT(ip->i_disk_size == 0 || !S_ISREG(VFS_I(ip)->i_mode));
+	ASSERT(ip->i_nblocks == 0);
 
 	/*
 	 * Pull the on-disk inode from the AGI unlinked list.
@@ -2760,12 +2759,12 @@ xfs_ifree(
 	xfs_ifree_local_data(ip, XFS_ATTR_FORK);
 
 	VFS_I(ip)->i_mode = 0;		/* mark incore inode as free */
-	ip->i_d.di_flags = 0;
-	ip->i_d.di_flags2 = 0;
-	ip->i_d.di_dmevmask = 0;
-	ip->i_d.di_forkoff = 0;		/* mark the attr fork not in use */
-	ip->i_d.di_format = XFS_DINODE_FMT_EXTENTS;
-	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
+	ip->i_diflags = 0;
+	ip->i_diflags2 = 0;
+	ip->i_dmevmask = 0;
+	ip->i_forkoff = 0;		/* mark the attr fork not in use */
+	ip->i_format = XFS_DINODE_FMT_EXTENTS;
+	ip->i_aformat = XFS_DINODE_FMT_EXTENTS;
 
 	/* Don't attempt to replay owner changes for a deleted inode */
 	ip->i_itemp->ili_fields &= ~(XFS_ILOG_AOWNER|XFS_ILOG_DOWNER);
@@ -3268,8 +3267,8 @@ xfs_rename(
 	 * into our tree when the project IDs are the same; else the
 	 * tree quota mechanism would be circumvented.
 	 */
-	if (unlikely((target_dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
-		     target_dp->i_d.di_projid != src_ip->i_d.di_projid)) {
+	if (unlikely((target_dp->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
+		     target_dp->i_projid != src_ip->i_projid)) {
 		error = -EXDEV;
 		goto out_trans_cancel;
 	}
@@ -3642,8 +3641,8 @@ xfs_iflush(
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(xfs_isiflocked(ip));
-	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
-	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
+	ASSERT(ip->i_format != XFS_DINODE_FMT_BTREE ||
+	       ip->i_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
 
 	*bpp = NULL;
 
@@ -3774,10 +3773,10 @@ xfs_iflush_int(
 
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL|XFS_ILOCK_SHARED));
 	ASSERT(xfs_isiflocked(ip));
-	ASSERT(ip->i_d.di_format != XFS_DINODE_FMT_BTREE ||
-	       ip->i_d.di_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
+	ASSERT(ip->i_format != XFS_DINODE_FMT_BTREE ||
+	       ip->i_nextents > XFS_IFORK_MAXEXT(ip, XFS_DATA_FORK));
 	ASSERT(iip != NULL && iip->ili_fields != 0);
-	ASSERT(ip->i_d.di_version > 1);
+	ASSERT(ip->i_version > 1);
 
 	/* set *dip = inode's place in the buffer */
 	dip = xfs_buf_offset(bp, ip->i_imap.im_boffset);
@@ -3791,8 +3790,8 @@ xfs_iflush_int(
 	}
 	if (S_ISREG(VFS_I(ip)->i_mode)) {
 		if (XFS_TEST_ERROR(
-		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
-		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE),
+		    (ip->i_format != XFS_DINODE_FMT_EXTENTS) &&
+		    (ip->i_format != XFS_DINODE_FMT_BTREE),
 		    mp, XFS_ERRTAG_IFLUSH_3)) {
 			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 				"%s: Bad regular inode %Lu, ptr "PTR_FMT,
@@ -3801,9 +3800,9 @@ xfs_iflush_int(
 		}
 	} else if (S_ISDIR(VFS_I(ip)->i_mode)) {
 		if (XFS_TEST_ERROR(
-		    (ip->i_d.di_format != XFS_DINODE_FMT_EXTENTS) &&
-		    (ip->i_d.di_format != XFS_DINODE_FMT_BTREE) &&
-		    (ip->i_d.di_format != XFS_DINODE_FMT_LOCAL),
+		    (ip->i_format != XFS_DINODE_FMT_EXTENTS) &&
+		    (ip->i_format != XFS_DINODE_FMT_BTREE) &&
+		    (ip->i_format != XFS_DINODE_FMT_LOCAL),
 		    mp, XFS_ERRTAG_IFLUSH_4)) {
 			xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 				"%s: Bad directory inode %Lu, ptr "PTR_FMT,
@@ -3811,21 +3810,21 @@ xfs_iflush_int(
 			goto corrupt_out;
 		}
 	}
-	if (XFS_TEST_ERROR(ip->i_d.di_nextents + ip->i_d.di_anextents >
-				ip->i_d.di_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
+	if (XFS_TEST_ERROR(ip->i_nextents + ip->i_anextents >
+				ip->i_nblocks, mp, XFS_ERRTAG_IFLUSH_5)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 			"%s: detected corrupt incore inode %Lu, "
 			"total extents = %d, nblocks = %Ld, ptr "PTR_FMT,
 			__func__, ip->i_ino,
-			ip->i_d.di_nextents + ip->i_d.di_anextents,
-			ip->i_d.di_nblocks, ip);
+			ip->i_nextents + ip->i_anextents,
+			ip->i_nblocks, ip);
 		goto corrupt_out;
 	}
-	if (XFS_TEST_ERROR(ip->i_d.di_forkoff > mp->m_sb.sb_inodesize,
+	if (XFS_TEST_ERROR(ip->i_forkoff > mp->m_sb.sb_inodesize,
 				mp, XFS_ERRTAG_IFLUSH_6)) {
 		xfs_alert_tag(mp, XFS_PTAG_IFLUSH,
 			"%s: bad inode %Lu, forkoff 0x%x, ptr "PTR_FMT,
-			__func__, ip->i_ino, ip->i_d.di_forkoff, ip);
+			__func__, ip->i_ino, ip->i_forkoff, ip);
 		goto corrupt_out;
 	}
 
@@ -3838,8 +3837,8 @@ xfs_iflush_int(
 	 * backwards compatibility with old kernels that predate logging all
 	 * inode changes.
 	 */
-	if (ip->i_d.di_version < 3)
-		ip->i_d.di_flushiter++;
+	if (ip->i_version < 3)
+		ip->i_flushiter++;
 
 	/* Check the inline fork data before we write out. */
 	if (!xfs_inode_verify_forks(ip))
@@ -3853,8 +3852,8 @@ xfs_iflush_int(
 	xfs_inode_to_disk(ip, dip, iip->ili_item.li_lsn);
 
 	/* Wrap, we never let the log put out DI_MAX_FLUSH */
-	if (ip->i_d.di_flushiter == DI_MAX_FLUSH)
-		ip->i_d.di_flushiter = 0;
+	if (ip->i_flushiter == DI_MAX_FLUSH)
+		ip->i_flushiter = 0;
 
 	xfs_iflush_fork(ip, dip, iip, XFS_DATA_FORK);
 	if (XFS_IFORK_Q(ip))
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index a0ca7ded3ab8..32fbe8feeb0e 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -58,8 +58,25 @@ typedef struct xfs_inode {
 	unsigned long		i_flags;	/* see defined flags below */
 	uint64_t		i_delayed_blks;	/* count of delay alloc blks */
 
-	struct xfs_icdinode	i_d;		/* most of ondisk inode */
-
+	int8_t			i_version;	/* inode version */
+	int8_t			i_format;	/* data fork format */
+	uint16_t		i_flushiter;	/* incremented on flush */
+	uint32_t		i_uid;		/* owner's user id */
+	uint32_t		i_gid;		/* owner's group id */
+	uint16_t		i_projid;	/* owner's project id */
+	xfs_fsize_t		i_disk_size;	/* number of bytes in file */
+	xfs_rfsblock_t		i_nblocks;	/* direct & btree blocks used */
+	xfs_extlen_t		i_extsize;	/* extent size hint  */
+	xfs_extnum_t		i_nextents;	/* # of extents in data fork */
+	xfs_aextnum_t		i_anextents;	/* # of extents in attr fork */
+	uint8_t			i_forkoff;	/* attr fork offset */
+	int8_t			i_aformat;	/* attr fork format */
+	uint32_t		i_dmevmask;	/* DMIG event mask */
+	uint16_t		i_dmstate;	/* DMIG state info */
+	uint16_t		i_diflags;	/* random flags */
+	uint64_t		i_diflags2;	/* more random flags */
+	uint32_t		i_cowextsize;	/* cow extent size hint */
+	struct timespec64	i_crtime;	/* time created */
 	xfs_extnum_t		i_cnextents;	/* # of extents in cow fork */
 	unsigned int		i_cformat;	/* format of cow fork */
 
@@ -93,7 +110,7 @@ static inline xfs_fsize_t XFS_ISIZE(struct xfs_inode *ip)
 {
 	if (S_ISREG(VFS_I(ip)->i_mode))
 		return i_size_read(VFS_I(ip));
-	return ip->i_d.di_size;
+	return ip->i_disk_size;
 }
 
 /*
@@ -107,7 +124,7 @@ xfs_new_eof(struct xfs_inode *ip, xfs_fsize_t new_size)
 
 	if (new_size > i_size || new_size < 0)
 		new_size = i_size;
-	return new_size > ip->i_d.di_size ? new_size : 0;
+	return new_size > ip->i_disk_size ? new_size : 0;
 }
 
 /*
@@ -180,15 +197,14 @@ xfs_iflags_test_and_set(xfs_inode_t *ip, unsigned short flags)
 static inline prid_t
 xfs_get_initial_prid(struct xfs_inode *dp)
 {
-	if (dp->i_d.di_flags & XFS_DIFLAG_PROJINHERIT)
-		return dp->i_d.di_projid;
-
+	if (dp->i_diflags & XFS_DIFLAG_PROJINHERIT)
+		return dp->i_projid;
 	return XFS_PROJID_DEFAULT;
 }
 
 static inline bool xfs_is_reflink_inode(struct xfs_inode *ip)
 {
-	return ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK;
+	return ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
 }
 
 /*
diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
index e6ffeb1b8a92..5d012eb44752 100644
--- a/fs/xfs/xfs_inode_item.c
+++ b/fs/xfs/xfs_inode_item.c
@@ -35,10 +35,10 @@ xfs_inode_item_data_fork_size(
 {
 	struct xfs_inode	*ip = iip->ili_inode;
 
-	switch (ip->i_d.di_format) {
+	switch (ip->i_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		if ((iip->ili_fields & XFS_ILOG_DEXT) &&
-		    ip->i_d.di_nextents > 0 &&
+		    ip->i_nextents > 0 &&
 		    ip->i_df.if_bytes > 0) {
 			/* worst case, doesn't subtract delalloc extents */
 			*nbytes += XFS_IFORK_DSIZE(ip);
@@ -76,10 +76,10 @@ xfs_inode_item_attr_fork_size(
 {
 	struct xfs_inode	*ip = iip->ili_inode;
 
-	switch (ip->i_d.di_aformat) {
+	switch (ip->i_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
 		if ((iip->ili_fields & XFS_ILOG_AEXT) &&
-		    ip->i_d.di_anextents > 0 &&
+		    ip->i_anextents > 0 &&
 		    ip->i_afp->if_bytes > 0) {
 			/* worst case, doesn't subtract unused space */
 			*nbytes += XFS_IFORK_ASIZE(ip);
@@ -124,7 +124,7 @@ xfs_inode_item_size(
 
 	*nvecs += 2;
 	*nbytes += sizeof(struct xfs_inode_log_format) +
-		   xfs_log_dinode_size(ip->i_d.di_version);
+		   xfs_log_dinode_size(ip->i_version);
 
 	xfs_inode_item_data_fork_size(iip, nvecs, nbytes);
 	if (XFS_IFORK_Q(ip))
@@ -141,13 +141,13 @@ xfs_inode_item_format_data_fork(
 	struct xfs_inode	*ip = iip->ili_inode;
 	size_t			data_bytes;
 
-	switch (ip->i_d.di_format) {
+	switch (ip->i_format) {
 	case XFS_DINODE_FMT_EXTENTS:
 		iip->ili_fields &=
 			~(XFS_ILOG_DDATA | XFS_ILOG_DBROOT | XFS_ILOG_DEV);
 
 		if ((iip->ili_fields & XFS_ILOG_DEXT) &&
-		    ip->i_d.di_nextents > 0 &&
+		    ip->i_nextents > 0 &&
 		    ip->i_df.if_bytes > 0) {
 			struct xfs_bmbt_rec *p;
 
@@ -195,7 +195,7 @@ xfs_inode_item_format_data_fork(
 			 */
 			data_bytes = roundup(ip->i_df.if_bytes, 4);
 			ASSERT(ip->i_df.if_u1.if_data != NULL);
-			ASSERT(ip->i_d.di_size > 0);
+			ASSERT(ip->i_disk_size > 0);
 			xlog_copy_iovec(lv, vecp, XLOG_REG_TYPE_ILOCAL,
 					ip->i_df.if_u1.if_data, data_bytes);
 			ilf->ilf_dsize = (unsigned)data_bytes;
@@ -226,18 +226,18 @@ xfs_inode_item_format_attr_fork(
 	struct xfs_inode	*ip = iip->ili_inode;
 	size_t			data_bytes;
 
-	switch (ip->i_d.di_aformat) {
+	switch (ip->i_aformat) {
 	case XFS_DINODE_FMT_EXTENTS:
 		iip->ili_fields &=
 			~(XFS_ILOG_ADATA | XFS_ILOG_ABROOT);
 
 		if ((iip->ili_fields & XFS_ILOG_AEXT) &&
-		    ip->i_d.di_anextents > 0 &&
+		    ip->i_anextents > 0 &&
 		    ip->i_afp->if_bytes > 0) {
 			struct xfs_bmbt_rec *p;
 
 			ASSERT(xfs_iext_count(ip->i_afp) ==
-				ip->i_d.di_anextents);
+				ip->i_anextents);
 
 			p = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_IATTR_EXT);
 			data_bytes = xfs_iextents_copy(ip, p, XFS_ATTR_FORK);
@@ -300,17 +300,16 @@ xfs_inode_to_log_dinode(
 	struct xfs_log_dinode	*to,
 	xfs_lsn_t		lsn)
 {
-	struct xfs_icdinode	*from = &ip->i_d;
 	struct inode		*inode = VFS_I(ip);
 
 	to->di_magic = XFS_DINODE_MAGIC;
 
-	to->di_version = from->di_version;
-	to->di_format = from->di_format;
-	to->di_uid = from->di_uid;
-	to->di_gid = from->di_gid;
-	to->di_projid_lo = from->di_projid & 0xffff;
-	to->di_projid_hi = from->di_projid >> 16;
+	to->di_version = ip->i_version;
+	to->di_format = ip->i_format;
+	to->di_uid = ip->i_uid;
+	to->di_gid = ip->i_gid;
+	to->di_projid_lo = ip->i_projid & 0xffff;
+	to->di_projid_hi = ip->i_projid >> 16;
 
 	memset(to->di_pad, 0, sizeof(to->di_pad));
 	memset(to->di_pad3, 0, sizeof(to->di_pad3));
@@ -324,33 +323,33 @@ xfs_inode_to_log_dinode(
 	to->di_gen = inode->i_generation;
 	to->di_mode = inode->i_mode;
 
-	to->di_size = from->di_size;
-	to->di_nblocks = from->di_nblocks;
-	to->di_extsize = from->di_extsize;
-	to->di_nextents = from->di_nextents;
-	to->di_anextents = from->di_anextents;
-	to->di_forkoff = from->di_forkoff;
-	to->di_aformat = from->di_aformat;
-	to->di_dmevmask = from->di_dmevmask;
-	to->di_dmstate = from->di_dmstate;
-	to->di_flags = from->di_flags;
+	to->di_size = ip->i_disk_size;
+	to->di_nblocks = ip->i_nblocks;
+	to->di_extsize = ip->i_extsize;
+	to->di_nextents = ip->i_nextents;
+	to->di_anextents = ip->i_anextents;
+	to->di_forkoff = ip->i_forkoff;
+	to->di_aformat = ip->i_aformat;
+	to->di_dmevmask = ip->i_dmevmask;
+	to->di_dmstate = ip->i_dmstate;
+	to->di_flags = ip->i_diflags;
 
 	/* log a dummy value to ensure log structure is fully initialised */
 	to->di_next_unlinked = NULLAGINO;
 
-	if (from->di_version == 3) {
+	if (ip->i_version == 3) {
 		to->di_changecount = inode_peek_iversion(inode);
-		to->di_crtime.t_sec = from->di_crtime.tv_sec;
-		to->di_crtime.t_nsec = from->di_crtime.tv_nsec;
-		to->di_flags2 = from->di_flags2;
-		to->di_cowextsize = from->di_cowextsize;
+		to->di_crtime.t_sec = ip->i_crtime.tv_sec;
+		to->di_crtime.t_nsec = ip->i_crtime.tv_nsec;
+		to->di_flags2 = ip->i_diflags2;
+		to->di_cowextsize = ip->i_cowextsize;
 		to->di_ino = ip->i_ino;
 		to->di_lsn = lsn;
 		memset(to->di_pad2, 0, sizeof(to->di_pad2));
 		uuid_copy(&to->di_uuid, &ip->i_mount->m_sb.sb_meta_uuid);
 		to->di_flushiter = 0;
 	} else {
-		to->di_flushiter = from->di_flushiter;
+		to->di_flushiter = ip->i_flushiter;
 	}
 }
 
@@ -369,7 +368,7 @@ xfs_inode_item_format_core(
 
 	dic = xlog_prepare_iovec(lv, vecp, XLOG_REG_TYPE_ICORE);
 	xfs_inode_to_log_dinode(ip, dic, ip->i_itemp->ili_item.li_lsn);
-	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_d.di_version));
+	xlog_finish_iovec(lv, *vecp, xfs_log_dinode_size(ip->i_version));
 }
 
 /*
@@ -394,7 +393,7 @@ xfs_inode_item_format(
 	struct xfs_log_iovec	*vecp = NULL;
 	struct xfs_inode_log_format *ilf;
 
-	ASSERT(ip->i_d.di_version > 1);
+	ASSERT(ip->i_version > 1);
 
 	ilf = xlog_prepare_iovec(lv, &vecp, XLOG_REG_TYPE_IFORMAT);
 	ilf->ilf_type = XFS_LI_INODE;
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 6ff01e4a8b7b..43c70f681b69 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -313,8 +313,8 @@ xfs_set_dmattrs(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, XFS_ILOCK_EXCL);
 
-	ip->i_d.di_dmevmask = evmask;
-	ip->i_d.di_dmstate  = state;
+	ip->i_dmevmask = evmask;
+	ip->i_dmstate  = state;
 
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	error = xfs_trans_commit(tp);
@@ -1113,24 +1113,24 @@ xfs_fill_fsxattr(
 	struct fsxattr		*fa)
 {
 	simple_fill_fsxattr(fa, xfs_ip2xflags(ip));
-	fa->fsx_extsize = ip->i_d.di_extsize << ip->i_mount->m_sb.sb_blocklog;
-	fa->fsx_cowextsize = ip->i_d.di_cowextsize <<
+	fa->fsx_extsize = ip->i_extsize << ip->i_mount->m_sb.sb_blocklog;
+	fa->fsx_cowextsize = ip->i_cowextsize <<
 			ip->i_mount->m_sb.sb_blocklog;
-	fa->fsx_projid = ip->i_d.di_projid;
+	fa->fsx_projid = ip->i_projid;
 
 	if (attr) {
 		if (ip->i_afp) {
 			if (ip->i_afp->if_flags & XFS_IFEXTENTS)
 				fa->fsx_nextents = xfs_iext_count(ip->i_afp);
 			else
-				fa->fsx_nextents = ip->i_d.di_anextents;
+				fa->fsx_nextents = ip->i_anextents;
 		} else
 			fa->fsx_nextents = 0;
 	} else {
 		if (ip->i_df.if_flags & XFS_IFEXTENTS)
 			fa->fsx_nextents = xfs_iext_count(&ip->i_df);
 		else
-			fa->fsx_nextents = ip->i_d.di_nextents;
+			fa->fsx_nextents = ip->i_nextents;
 	}
 }
 
@@ -1158,7 +1158,7 @@ xfs_flags2diflags(
 {
 	/* can't set PREALLOC this way, just preserve it */
 	uint16_t		di_flags =
-		(ip->i_d.di_flags & XFS_DIFLAG_PREALLOC);
+		(ip->i_diflags & XFS_DIFLAG_PREALLOC);
 
 	if (xflags & FS_XFLAG_IMMUTABLE)
 		di_flags |= XFS_DIFLAG_IMMUTABLE;
@@ -1199,7 +1199,7 @@ xfs_flags2diflags2(
 	unsigned int		xflags)
 {
 	uint64_t		di_flags2 =
-		(ip->i_d.di_flags2 & XFS_DIFLAG2_REFLINK);
+		(ip->i_diflags2 & XFS_DIFLAG2_REFLINK);
 
 	if (xflags & FS_XFLAG_DAX)
 		di_flags2 |= XFS_DIFLAG2_DAX;
@@ -1250,20 +1250,20 @@ xfs_ioctl_setattr_xflags(
 	uint64_t		di_flags2;
 
 	/* Can't change realtime flag if any extents are allocated. */
-	if ((ip->i_d.di_nextents || ip->i_delayed_blks) &&
+	if ((ip->i_nextents || ip->i_delayed_blks) &&
 	    XFS_IS_REALTIME_INODE(ip) != (fa->fsx_xflags & FS_XFLAG_REALTIME))
 		return -EINVAL;
 
 	/* If realtime flag is set then must have realtime device */
 	if (fa->fsx_xflags & FS_XFLAG_REALTIME) {
 		if (mp->m_sb.sb_rblocks == 0 || mp->m_sb.sb_rextsize == 0 ||
-		    (ip->i_d.di_extsize % mp->m_sb.sb_rextsize))
+		    (ip->i_extsize % mp->m_sb.sb_rextsize))
 			return -EINVAL;
 	}
 
 	/* Clear reflink if we are actually able to set the rt flag. */
 	if ((fa->fsx_xflags & FS_XFLAG_REALTIME) && xfs_is_reflink_inode(ip))
-		ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+		ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
 
 	/* Don't allow us to set DAX mode for a reflinked file for now. */
 	if ((fa->fsx_xflags & FS_XFLAG_DAX) && xfs_is_reflink_inode(ip))
@@ -1271,11 +1271,11 @@ xfs_ioctl_setattr_xflags(
 
 	/* diflags2 only valid for v3 inodes. */
 	di_flags2 = xfs_flags2diflags2(ip, fa->fsx_xflags);
-	if (di_flags2 && ip->i_d.di_version < 3)
+	if (di_flags2 && ip->i_version < 3)
 		return -EINVAL;
 
-	ip->i_d.di_flags = xfs_flags2diflags(ip, fa->fsx_xflags);
-	ip->i_d.di_flags2 = di_flags2;
+	ip->i_diflags = xfs_flags2diflags(ip, fa->fsx_xflags);
+	ip->i_diflags2 = di_flags2;
 
 	xfs_diflags_to_linux(ip);
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_CHG);
@@ -1429,8 +1429,8 @@ xfs_ioctl_setattr_check_extsize(
 	xfs_extlen_t		size;
 	xfs_fsblock_t		extsize_fsb;
 
-	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_d.di_nextents &&
-	    ((ip->i_d.di_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
+	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_nextents &&
+	    ((ip->i_extsize << mp->m_sb.sb_blocklog) != fa->fsx_extsize))
 		return -EINVAL;
 
 	if (fa->fsx_extsize == 0)
@@ -1483,7 +1483,7 @@ xfs_ioctl_setattr_check_cowextsize(
 		return 0;
 
 	if (!xfs_sb_version_hasreflink(&ip->i_mount->m_sb) ||
-	    ip->i_d.di_version != 3)
+	    ip->i_version != 3)
 		return -EINVAL;
 
 	if (fa->fsx_cowextsize == 0)
@@ -1544,8 +1544,8 @@ xfs_ioctl_setattr(
 	 * because the i_*dquot fields will get updated anyway.
 	 */
 	if (XFS_IS_QUOTA_ON(mp)) {
-		code = xfs_qm_vop_dqalloc(ip, ip->i_d.di_uid,
-					 ip->i_d.di_gid, fa->fsx_projid,
+		code = xfs_qm_vop_dqalloc(ip, ip->i_uid,
+					 ip->i_gid, fa->fsx_projid,
 					 XFS_QMOPT_PQUOTA, &udqp, NULL, &pdqp);
 		if (code)
 			return code;
@@ -1569,7 +1569,7 @@ xfs_ioctl_setattr(
 	}
 
 	if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp) &&
-	    ip->i_d.di_projid != fa->fsx_projid) {
+	    ip->i_projid != fa->fsx_projid) {
 		code = xfs_qm_vop_chown_reserve(tp, ip, udqp, NULL, pdqp,
 				capable(CAP_FOWNER) ?  XFS_QMOPT_FORCE_RES : 0);
 		if (code)	/* out of quota */
@@ -1606,13 +1606,13 @@ xfs_ioctl_setattr(
 		VFS_I(ip)->i_mode &= ~(S_ISUID|S_ISGID);
 
 	/* Change the ownerships and register project quota modifications */
-	if (ip->i_d.di_projid != fa->fsx_projid) {
+	if (ip->i_projid != fa->fsx_projid) {
 		if (XFS_IS_QUOTA_RUNNING(mp) && XFS_IS_PQUOTA_ON(mp)) {
 			olddquot = xfs_qm_vop_chown(tp, ip,
 						&ip->i_pdquot, pdqp);
 		}
-		ASSERT(ip->i_d.di_version > 1);
-		ip->i_d.di_projid = fa->fsx_projid;
+		ASSERT(ip->i_version > 1);
+		ip->i_projid = fa->fsx_projid;
 	}
 
 	/*
@@ -1620,16 +1620,16 @@ xfs_ioctl_setattr(
 	 * extent size hint should be set on the inode. If no extent size flags
 	 * are set on the inode then unconditionally clear the extent size hint.
 	 */
-	if (ip->i_d.di_flags & (XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT))
-		ip->i_d.di_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
+	if (ip->i_diflags & (XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT))
+		ip->i_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
 	else
-		ip->i_d.di_extsize = 0;
-	if (ip->i_d.di_version == 3 &&
-	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
-		ip->i_d.di_cowextsize = fa->fsx_cowextsize >>
+		ip->i_extsize = 0;
+	if (ip->i_version == 3 &&
+	    (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE))
+		ip->i_cowextsize = fa->fsx_cowextsize >>
 				mp->m_sb.sb_blocklog;
 	else
-		ip->i_d.di_cowextsize = 0;
+		ip->i_cowextsize = 0;
 
 	code = xfs_trans_commit(tp);
 
@@ -1677,7 +1677,7 @@ xfs_ioc_getxflags(
 {
 	unsigned int		flags;
 
-	flags = xfs_di2lxflags(ip->i_d.di_flags);
+	flags = xfs_di2lxflags(ip->i_diflags);
 	if (copy_to_user(arg, &flags, sizeof(flags)))
 		return -EFAULT;
 	return 0;
diff --git a/fs/xfs/xfs_iomap.c b/fs/xfs/xfs_iomap.c
index f780e223b118..994308785098 100644
--- a/fs/xfs/xfs_iomap.c
+++ b/fs/xfs/xfs_iomap.c
@@ -805,7 +805,7 @@ xfs_iomap_write_unwritten(
 			i_size_write(inode, i_size);
 		i_size = xfs_new_eof(ip, i_size);
 		if (i_size) {
-			ip->i_d.di_size = i_size;
+			ip->i_disk_size = i_size;
 			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 		}
 
@@ -1247,12 +1247,12 @@ xfs_xattr_iomap_begin(
 	lockmode = xfs_ilock_attr_map_shared(ip);
 
 	/* if there are no attribute fork or extents, return ENOENT */
-	if (!XFS_IFORK_Q(ip) || !ip->i_d.di_anextents) {
+	if (!XFS_IFORK_Q(ip) || !ip->i_anextents) {
 		error = -ENOENT;
 		goto out_unlock;
 	}
 
-	ASSERT(ip->i_d.di_aformat != XFS_DINODE_FMT_LOCAL);
+	ASSERT(ip->i_aformat != XFS_DINODE_FMT_LOCAL);
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
 			       &nimaps, XFS_BMAPI_ATTRFORK);
 out_unlock:
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index c71c34798654..339e34d6412d 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -511,12 +511,12 @@ xfs_vn_getattr(
 	stat->mtime = inode->i_mtime;
 	stat->ctime = inode->i_ctime;
 	stat->blocks =
-		XFS_FSB_TO_BB(mp, ip->i_d.di_nblocks + ip->i_delayed_blks);
+		XFS_FSB_TO_BB(mp, ip->i_nblocks + ip->i_delayed_blks);
 
-	if (ip->i_d.di_version == 3) {
+	if (ip->i_version == 3) {
 		if (request_mask & STATX_BTIME) {
 			stat->result_mask |= STATX_BTIME;
-			stat->btime = ip->i_d.di_crtime;
+			stat->btime = ip->i_crtime;
 		}
 	}
 
@@ -524,11 +524,11 @@ xfs_vn_getattr(
 	 * Note: If you add another clause to set an attribute flag, please
 	 * update attributes_mask below.
 	 */
-	if (ip->i_d.di_flags & XFS_DIFLAG_IMMUTABLE)
+	if (ip->i_diflags & XFS_DIFLAG_IMMUTABLE)
 		stat->attributes |= STATX_ATTR_IMMUTABLE;
-	if (ip->i_d.di_flags & XFS_DIFLAG_APPEND)
+	if (ip->i_diflags & XFS_DIFLAG_APPEND)
 		stat->attributes |= STATX_ATTR_APPEND;
-	if (ip->i_d.di_flags & XFS_DIFLAG_NODUMP)
+	if (ip->i_diflags & XFS_DIFLAG_NODUMP)
 		stat->attributes |= STATX_ATTR_NODUMP;
 
 	stat->attributes_mask |= (STATX_ATTR_IMMUTABLE |
@@ -663,7 +663,7 @@ xfs_setattr_nonsize(
 		ASSERT(gdqp == NULL);
 		error = xfs_qm_vop_dqalloc(ip, xfs_kuid_to_uid(uid),
 					   xfs_kgid_to_gid(gid),
-					   ip->i_d.di_projid,
+					   ip->i_projid,
 					   qflags, &udqp, &gdqp, NULL);
 		if (error)
 			return error;
@@ -732,7 +732,7 @@ xfs_setattr_nonsize(
 				olddquot1 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_udquot, udqp);
 			}
-			ip->i_d.di_uid = xfs_kuid_to_uid(uid);
+			ip->i_uid = xfs_kuid_to_uid(uid);
 			inode->i_uid = uid;
 		}
 		if (!gid_eq(igid, gid)) {
@@ -744,7 +744,7 @@ xfs_setattr_nonsize(
 				olddquot2 = xfs_qm_vop_chown(tp, ip,
 							&ip->i_gdquot, gdqp);
 			}
-			ip->i_d.di_gid = xfs_kgid_to_gid(gid);
+			ip->i_gid = xfs_kgid_to_gid(gid);
 			inode->i_gid = gid;
 		}
 	}
@@ -846,7 +846,7 @@ xfs_setattr_size(
 	/*
 	 * Short circuit the truncate case for zero length files.
 	 */
-	if (newsize == 0 && oldsize == 0 && ip->i_d.di_nextents == 0) {
+	if (newsize == 0 && oldsize == 0 && ip->i_nextents == 0) {
 		if (!(iattr->ia_valid & (ATTR_CTIME|ATTR_MTIME)))
 			return 0;
 
@@ -923,9 +923,9 @@ xfs_setattr_size(
 	 * otherwise those blocks may not be zeroed after a crash.
 	 */
 	if (did_zeroing ||
-	    (newsize > ip->i_d.di_size && oldsize != ip->i_d.di_size)) {
+	    (newsize > ip->i_disk_size && oldsize != ip->i_disk_size)) {
 		error = filemap_write_and_wait_range(VFS_I(ip)->i_mapping,
-						ip->i_d.di_size, newsize - 1);
+						ip->i_disk_size, newsize - 1);
 		if (error)
 			return error;
 	}
@@ -967,7 +967,7 @@ xfs_setattr_size(
 	 * permanent before actually freeing any blocks it doesn't matter if
 	 * they get written to.
 	 */
-	ip->i_d.di_size = newsize;
+	ip->i_disk_size = newsize;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	if (newsize <= oldsize) {
@@ -1218,7 +1218,7 @@ xfs_inode_supports_dax(
 
 	/* DAX mount option or DAX iflag must be set. */
 	if (!(mp->m_flags & XFS_MOUNT_DAX) &&
-	    !(ip->i_d.di_flags2 & XFS_DIFLAG2_DAX))
+	    !(ip->i_diflags2 & XFS_DIFLAG2_DAX))
 		return false;
 
 	/* Block size must match page size */
@@ -1234,7 +1234,7 @@ xfs_diflags_to_iflags(
 	struct inode		*inode,
 	struct xfs_inode	*ip)
 {
-	uint16_t		flags = ip->i_d.di_flags;
+	uint16_t		flags = ip->i_diflags;
 
 	inode->i_flags &= ~(S_IMMUTABLE | S_APPEND | S_SYNC |
 			    S_NOATIME | S_DAX);
@@ -1273,10 +1273,10 @@ xfs_setup_inode(
 	/* make the inode look hashed for the writeback code */
 	inode_fake_hash(inode);
 
-	inode->i_uid    = xfs_uid_to_kuid(ip->i_d.di_uid);
-	inode->i_gid    = xfs_gid_to_kgid(ip->i_d.di_gid);
+	inode->i_uid    = xfs_uid_to_kuid(ip->i_uid);
+	inode->i_gid    = xfs_gid_to_kgid(ip->i_gid);
 
-	i_size_write(inode, ip->i_d.di_size);
+	i_size_write(inode, ip->i_disk_size);
 	xfs_diflags_to_iflags(inode, ip);
 
 	if (S_ISDIR(inode->i_mode)) {
diff --git a/fs/xfs/xfs_itable.c b/fs/xfs/xfs_itable.c
index 4b31c29b7e6b..2e8a2a08f760 100644
--- a/fs/xfs/xfs_itable.c
+++ b/fs/xfs/xfs_itable.c
@@ -58,7 +58,6 @@ xfs_bulkstat_one_int(
 	xfs_ino_t		ino,
 	struct xfs_bstat_chunk	*bc)
 {
-	struct xfs_icdinode	*dic;		/* dinode core info pointer */
 	struct xfs_inode	*ip;		/* incore inode pointer */
 	struct inode		*inode;
 	struct xfs_bulkstat	*buf = bc->buf;
@@ -79,16 +78,14 @@ xfs_bulkstat_one_int(
 	ASSERT(ip->i_imap.im_blkno != 0);
 	inode = VFS_I(ip);
 
-	dic = &ip->i_d;
-
 	/* xfs_iget returns the following without needing
 	 * further change.
 	 */
-	buf->bs_projectid = ip->i_d.di_projid;
+	buf->bs_projectid = ip->i_projid;
 	buf->bs_ino = ino;
-	buf->bs_uid = dic->di_uid;
-	buf->bs_gid = dic->di_gid;
-	buf->bs_size = dic->di_size;
+	buf->bs_uid = ip->i_uid;
+	buf->bs_gid = ip->i_gid;
+	buf->bs_size = ip->i_disk_size;
 
 	buf->bs_nlink = inode->i_nlink;
 	buf->bs_atime = inode->i_atime.tv_sec;
@@ -97,25 +94,25 @@ xfs_bulkstat_one_int(
 	buf->bs_mtime_nsec = inode->i_mtime.tv_nsec;
 	buf->bs_ctime = inode->i_ctime.tv_sec;
 	buf->bs_ctime_nsec = inode->i_ctime.tv_nsec;
-	buf->bs_btime = dic->di_crtime.tv_sec;
-	buf->bs_btime_nsec = dic->di_crtime.tv_nsec;
+	buf->bs_btime = ip->i_crtime.tv_sec;
+	buf->bs_btime_nsec = ip->i_crtime.tv_nsec;
 	buf->bs_gen = inode->i_generation;
 	buf->bs_mode = inode->i_mode;
 
 	buf->bs_xflags = xfs_ip2xflags(ip);
-	buf->bs_extsize_blks = dic->di_extsize;
-	buf->bs_extents = dic->di_nextents;
+	buf->bs_extsize_blks = ip->i_extsize;
+	buf->bs_extents = ip->i_nextents;
 	xfs_bulkstat_health(ip, buf);
-	buf->bs_aextents = dic->di_anextents;
+	buf->bs_aextents = ip->i_anextents;
 	buf->bs_forkoff = XFS_IFORK_BOFF(ip);
 	buf->bs_version = XFS_BULKSTAT_VERSION_V5;
 
-	if (dic->di_version == 3) {
-		if (dic->di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
-			buf->bs_cowextsize_blks = dic->di_cowextsize;
+	if (ip->i_version == 3) {
+		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
+			buf->bs_cowextsize_blks = ip->i_cowextsize;
 	}
 
-	switch (dic->di_format) {
+	switch (ip->i_format) {
 	case XFS_DINODE_FMT_DEV:
 		buf->bs_rdev = sysv_encode_dev(inode->i_rdev);
 		buf->bs_blksize = BLKDEV_IOSIZE;
@@ -130,7 +127,7 @@ xfs_bulkstat_one_int(
 	case XFS_DINODE_FMT_BTREE:
 		buf->bs_rdev = 0;
 		buf->bs_blksize = mp->m_sb.sb_blocksize;
-		buf->bs_blocks = dic->di_nblocks + ip->i_delayed_blks;
+		buf->bs_blocks = ip->i_nblocks + ip->i_delayed_blks;
 		break;
 	}
 	xfs_iunlock(ip, XFS_ILOCK_SHARED);
diff --git a/fs/xfs/xfs_linux.h b/fs/xfs/xfs_linux.h
index ca15105681ca..0cf9ef2d97cd 100644
--- a/fs/xfs/xfs_linux.h
+++ b/fs/xfs/xfs_linux.h
@@ -252,7 +252,7 @@ int xfs_rw_bdev(struct block_device *bdev, sector_t sector, unsigned int count,
  * configured realtime device.
  */
 #define XFS_IS_REALTIME_INODE(ip)			\
-	(((ip)->i_d.di_flags & XFS_DIFLAG_REALTIME) &&	\
+	(((ip)->i_diflags & XFS_DIFLAG_REALTIME) &&	\
 	 (ip)->i_mount->m_rtdev_targp)
 #define XFS_IS_REALTIME_MOUNT(mp) ((mp)->m_rtdev_targp ? 1 : 0)
 #else
diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index c1a514ffff55..4eeea9aa300d 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -2876,7 +2876,7 @@ xfs_recover_inode_owner_change(
 
 	/* instantiate the inode */
 	xfs_inode_from_disk(ip, dip);
-	ASSERT(ip->i_d.di_version >= 3);
+	ASSERT(ip->i_version >= 3);
 
 	error = xfs_iformat_fork(ip, dip);
 	if (error)
@@ -5003,7 +5003,7 @@ xlog_recover_process_one_iunlink(
 	 * Prevent any DMAPI event from being sent when the reference on
 	 * the inode is dropped.
 	 */
-	ip->i_d.di_dmevmask = 0;
+	ip->i_dmevmask = 0;
 
 	xfs_irele(ip);
 	return agino;
diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index a339bd5fa260..e829d06a789e 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -291,7 +291,7 @@ xfs_fs_commit_blocks(
 	xfs_setattr_time(ip, iattr);
 	if (update_isize) {
 		i_size_write(inode, iattr->ia_size);
-		ip->i_d.di_size = iattr->ia_size;
+		ip->i_disk_size = iattr->ia_size;
 	}
 
 	xfs_trans_set_sync(tp);
diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
index 168f4ae4bdb8..bb5157931960 100644
--- a/fs/xfs/xfs_qm.c
+++ b/fs/xfs/xfs_qm.c
@@ -325,7 +325,7 @@ xfs_qm_dqattach_locked(
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_EXCL));
 
 	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
-		error = xfs_qm_dqattach_one(ip, ip->i_d.di_uid, XFS_DQ_USER,
+		error = xfs_qm_dqattach_one(ip, ip->i_uid, XFS_DQ_USER,
 				doalloc, &ip->i_udquot);
 		if (error)
 			goto done;
@@ -333,7 +333,7 @@ xfs_qm_dqattach_locked(
 	}
 
 	if (XFS_IS_GQUOTA_ON(mp) && !ip->i_gdquot) {
-		error = xfs_qm_dqattach_one(ip, ip->i_d.di_gid, XFS_DQ_GROUP,
+		error = xfs_qm_dqattach_one(ip, ip->i_gid, XFS_DQ_GROUP,
 				doalloc, &ip->i_gdquot);
 		if (error)
 			goto done;
@@ -341,7 +341,7 @@ xfs_qm_dqattach_locked(
 	}
 
 	if (XFS_IS_PQUOTA_ON(mp) && !ip->i_pdquot) {
-		error = xfs_qm_dqattach_one(ip, ip->i_d.di_projid, XFS_DQ_PROJ,
+		error = xfs_qm_dqattach_one(ip, ip->i_projid, XFS_DQ_PROJ,
 				doalloc, &ip->i_pdquot);
 		if (error)
 			goto done;
@@ -975,7 +975,7 @@ xfs_qm_reset_dqcounts_buf(
 	 * trans_reserve. But, this gets called during quotacheck, and that
 	 * happens only at mount time which is single threaded.
 	 */
-	if (qip->i_d.di_nblocks == 0)
+	if (qip->i_nblocks == 0)
 		return 0;
 
 	map = kmem_alloc(XFS_DQITER_MAP_SIZE * sizeof(*map), 0);
@@ -1157,7 +1157,7 @@ xfs_qm_dqusage_adjust(
 		xfs_bmap_count_leaves(ifp, &rtblks);
 	}
 
-	nblks = (xfs_qcnt_t)ip->i_d.di_nblocks - rtblks;
+	nblks = (xfs_qcnt_t)ip->i_nblocks - rtblks;
 
 	/*
 	 * Add the (disk blocks and inode) resources occupied by this
@@ -1630,7 +1630,7 @@ xfs_qm_vop_dqalloc(
 	xfs_ilock(ip, lockflags);
 
 	if ((flags & XFS_QMOPT_INHERIT) && XFS_INHERIT_GID(ip))
-		gid = ip->i_d.di_gid;
+		gid = ip->i_gid;
 
 	/*
 	 * Attach the dquot(s) to this inode, doing a dquot allocation
@@ -1645,7 +1645,7 @@ xfs_qm_vop_dqalloc(
 	}
 
 	if ((flags & XFS_QMOPT_UQUOTA) && XFS_IS_UQUOTA_ON(mp)) {
-		if (ip->i_d.di_uid != uid) {
+		if (ip->i_uid != uid) {
 			/*
 			 * What we need is the dquot that has this uid, and
 			 * if we send the inode to dqget, the uid of the inode
@@ -1677,7 +1677,7 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 	if ((flags & XFS_QMOPT_GQUOTA) && XFS_IS_GQUOTA_ON(mp)) {
-		if (ip->i_d.di_gid != gid) {
+		if (ip->i_gid != gid) {
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, gid, XFS_DQ_GROUP, true, &gq);
 			if (error) {
@@ -1693,7 +1693,7 @@ xfs_qm_vop_dqalloc(
 		}
 	}
 	if ((flags & XFS_QMOPT_PQUOTA) && XFS_IS_PQUOTA_ON(mp)) {
-		if (ip->i_d.di_projid != prid) {
+		if (ip->i_projid != prid) {
 			xfs_iunlock(ip, lockflags);
 			error = xfs_qm_dqget(mp, (xfs_dqid_t)prid, XFS_DQ_PROJ,
 					true, &pq);
@@ -1757,11 +1757,11 @@ xfs_qm_vop_chown(
 	ASSERT(prevdq);
 	ASSERT(prevdq != newdq);
 
-	xfs_trans_mod_dquot(tp, prevdq, bfield, -(ip->i_d.di_nblocks));
+	xfs_trans_mod_dquot(tp, prevdq, bfield, -(ip->i_nblocks));
 	xfs_trans_mod_dquot(tp, prevdq, XFS_TRANS_DQ_ICOUNT, -1);
 
 	/* the sparkling new dquot */
-	xfs_trans_mod_dquot(tp, newdq, bfield, ip->i_d.di_nblocks);
+	xfs_trans_mod_dquot(tp, newdq, bfield, ip->i_nblocks);
 	xfs_trans_mod_dquot(tp, newdq, XFS_TRANS_DQ_ICOUNT, 1);
 
 	/*
@@ -1805,7 +1805,7 @@ xfs_qm_vop_chown_reserve(
 			XFS_QMOPT_RES_RTBLKS : XFS_QMOPT_RES_REGBLKS;
 
 	if (XFS_IS_UQUOTA_ON(mp) && udqp &&
-	    ip->i_d.di_uid != be32_to_cpu(udqp->q_core.d_id)) {
+	    ip->i_uid != be32_to_cpu(udqp->q_core.d_id)) {
 		udq_delblks = udqp;
 		/*
 		 * If there are delayed allocation blocks, then we have to
@@ -1818,7 +1818,7 @@ xfs_qm_vop_chown_reserve(
 		}
 	}
 	if (XFS_IS_GQUOTA_ON(ip->i_mount) && gdqp &&
-	    ip->i_d.di_gid != be32_to_cpu(gdqp->q_core.d_id)) {
+	    ip->i_gid != be32_to_cpu(gdqp->q_core.d_id)) {
 		gdq_delblks = gdqp;
 		if (delblks) {
 			ASSERT(ip->i_gdquot);
@@ -1827,7 +1827,7 @@ xfs_qm_vop_chown_reserve(
 	}
 
 	if (XFS_IS_PQUOTA_ON(ip->i_mount) && pdqp &&
-	    ip->i_d.di_projid != be32_to_cpu(pdqp->q_core.d_id)) {
+	    ip->i_projid != be32_to_cpu(pdqp->q_core.d_id)) {
 		prjflags = XFS_QMOPT_ENOSPC;
 		pdq_delblks = pdqp;
 		if (delblks) {
@@ -1838,7 +1838,7 @@ xfs_qm_vop_chown_reserve(
 
 	error = xfs_trans_reserve_quota_bydquots(tp, ip->i_mount,
 				udq_delblks, gdq_delblks, pdq_delblks,
-				ip->i_d.di_nblocks, 1,
+				ip->i_nblocks, 1,
 				flags | blkflags | prjflags);
 	if (error)
 		return error;
@@ -1915,20 +1915,20 @@ xfs_qm_vop_create_dqattach(
 
 	if (udqp && XFS_IS_UQUOTA_ON(mp)) {
 		ASSERT(ip->i_udquot == NULL);
-		ASSERT(ip->i_d.di_uid == be32_to_cpu(udqp->q_core.d_id));
+		ASSERT(ip->i_uid == be32_to_cpu(udqp->q_core.d_id));
 
 		ip->i_udquot = xfs_qm_dqhold(udqp);
 		xfs_trans_mod_dquot(tp, udqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
 	if (gdqp && XFS_IS_GQUOTA_ON(mp)) {
 		ASSERT(ip->i_gdquot == NULL);
-		ASSERT(ip->i_d.di_gid == be32_to_cpu(gdqp->q_core.d_id));
+		ASSERT(ip->i_gid == be32_to_cpu(gdqp->q_core.d_id));
 		ip->i_gdquot = xfs_qm_dqhold(gdqp);
 		xfs_trans_mod_dquot(tp, gdqp, XFS_TRANS_DQ_ICOUNT, 1);
 	}
 	if (pdqp && XFS_IS_PQUOTA_ON(mp)) {
 		ASSERT(ip->i_pdquot == NULL);
-		ASSERT(ip->i_d.di_projid == be32_to_cpu(pdqp->q_core.d_id));
+		ASSERT(ip->i_projid == be32_to_cpu(pdqp->q_core.d_id));
 
 		ip->i_pdquot = xfs_qm_dqhold(pdqp);
 		xfs_trans_mod_dquot(tp, pdqp, XFS_TRANS_DQ_ICOUNT, 1);
diff --git a/fs/xfs/xfs_qm_bhv.c b/fs/xfs/xfs_qm_bhv.c
index ac8885d0f752..57a54b9e7bfd 100644
--- a/fs/xfs/xfs_qm_bhv.c
+++ b/fs/xfs/xfs_qm_bhv.c
@@ -60,7 +60,7 @@ xfs_qm_statvfs(
 	xfs_mount_t		*mp = ip->i_mount;
 	xfs_dquot_t		*dqp;
 
-	if (!xfs_qm_dqget(mp, ip->i_d.di_projid, XFS_DQ_PROJ, false, &dqp)) {
+	if (!xfs_qm_dqget(mp, ip->i_projid, XFS_DQ_PROJ, false, &dqp)) {
 		xfs_fill_statvfs_from_dquot(statp, dqp);
 		xfs_qm_dqput(dqp);
 	}
diff --git a/fs/xfs/xfs_qm_syscalls.c b/fs/xfs/xfs_qm_syscalls.c
index da7ad0383037..b542073c71ce 100644
--- a/fs/xfs/xfs_qm_syscalls.c
+++ b/fs/xfs/xfs_qm_syscalls.c
@@ -229,7 +229,7 @@ xfs_qm_scall_trunc_qfile(
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
 	xfs_trans_ijoin(tp, ip, 0);
 
-	ip->i_d.di_size = 0;
+	ip->i_disk_size = 0;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 	error = xfs_itruncate_extents(&tp, ip, XFS_DATA_FORK, 0);
@@ -238,7 +238,7 @@ xfs_qm_scall_trunc_qfile(
 		goto out_unlock;
 	}
 
-	ASSERT(ip->i_d.di_nextents == 0);
+	ASSERT(ip->i_nextents == 0);
 
 	xfs_trans_ichgtime(tp, ip, XFS_ICHGTIME_MOD | XFS_ICHGTIME_CHG);
 	error = xfs_trans_commit(tp);
diff --git a/fs/xfs/xfs_quotaops.c b/fs/xfs/xfs_quotaops.c
index cd6c7210a373..450166e98ef7 100644
--- a/fs/xfs/xfs_quotaops.c
+++ b/fs/xfs/xfs_quotaops.c
@@ -35,8 +35,8 @@ xfs_qm_fill_state(
 		tempqip = true;
 	}
 	tstate->flags |= QCI_SYSFILE;
-	tstate->blocks = ip->i_d.di_nblocks;
-	tstate->nextents = ip->i_d.di_nextents;
+	tstate->blocks = ip->i_nblocks;
+	tstate->nextents = ip->i_nextents;
 	tstate->spc_timelimit = q->qi_btimelimit;
 	tstate->ino_timelimit = q->qi_itimelimit;
 	tstate->rt_spc_timelimit = q->qi_rtbtimelimit;
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 0f08153b4994..0d4963f9f4c7 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -884,7 +884,7 @@ xfs_reflink_set_inode_flag(
 	if (!xfs_is_reflink_inode(src)) {
 		trace_xfs_reflink_set_inode_flag(src);
 		xfs_trans_ijoin(tp, src, XFS_ILOCK_EXCL);
-		src->i_d.di_flags2 |= XFS_DIFLAG2_REFLINK;
+		src->i_diflags2 |= XFS_DIFLAG2_REFLINK;
 		xfs_trans_log_inode(tp, src, XFS_ILOG_CORE);
 		xfs_ifork_init_cow(src);
 	} else
@@ -896,7 +896,7 @@ xfs_reflink_set_inode_flag(
 	if (!xfs_is_reflink_inode(dest)) {
 		trace_xfs_reflink_set_inode_flag(dest);
 		xfs_trans_ijoin(tp, dest, XFS_ILOCK_EXCL);
-		dest->i_d.di_flags2 |= XFS_DIFLAG2_REFLINK;
+		dest->i_diflags2 |= XFS_DIFLAG2_REFLINK;
 		xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
 		xfs_ifork_init_cow(dest);
 	} else
@@ -940,12 +940,12 @@ xfs_reflink_update_dest(
 	if (newlen > i_size_read(VFS_I(dest))) {
 		trace_xfs_reflink_update_inode_size(dest, newlen);
 		i_size_write(VFS_I(dest), newlen);
-		dest->i_d.di_size = newlen;
+		dest->i_disk_size = newlen;
 	}
 
 	if (cowextsize) {
-		dest->i_d.di_cowextsize = cowextsize;
-		dest->i_d.di_flags2 |= XFS_DIFLAG2_COWEXTSIZE;
+		dest->i_cowextsize = cowextsize;
+		dest->i_diflags2 |= XFS_DIFLAG2_COWEXTSIZE;
 	}
 
 	xfs_trans_log_inode(tp, dest, XFS_ILOG_CORE);
@@ -1079,7 +1079,7 @@ xfs_reflink_remap_extent(
 		if (newlen > i_size_read(VFS_I(ip))) {
 			trace_xfs_reflink_update_inode_size(ip, newlen);
 			i_size_write(VFS_I(ip), newlen);
-			ip->i_d.di_size = newlen;
+			ip->i_disk_size = newlen;
 			xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 		}
 
@@ -1542,7 +1542,7 @@ xfs_reflink_clear_inode_flag(
 
 	/* Clear the inode flag. */
 	trace_xfs_reflink_unset_inode_flag(ip);
-	ip->i_d.di_flags2 &= ~XFS_DIFLAG2_REFLINK;
+	ip->i_diflags2 &= ~XFS_DIFLAG2_REFLINK;
 	xfs_inode_clear_cowblocks_tag(ip);
 	xfs_trans_log_inode(*tpp, ip, XFS_ILOG_CORE);
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index 4a48a8c75b4f..3a08bf08c703 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -944,8 +944,8 @@ xfs_growfs_rt(
 	 * Get the old block counts for bitmap and summary inodes.
 	 * These can't change since other growfs callers are locked out.
 	 */
-	rbmblocks = XFS_B_TO_FSB(mp, mp->m_rbmip->i_d.di_size);
-	rsumblocks = XFS_B_TO_FSB(mp, mp->m_rsumip->i_d.di_size);
+	rbmblocks = XFS_B_TO_FSB(mp, mp->m_rbmip->i_disk_size);
+	rsumblocks = XFS_B_TO_FSB(mp, mp->m_rsumip->i_disk_size);
 	/*
 	 * Allocate space to the bitmap and summary files, as necessary.
 	 */
@@ -1012,7 +1012,7 @@ xfs_growfs_rt(
 		/*
 		 * Update the bitmap inode's size.
 		 */
-		mp->m_rbmip->i_d.di_size =
+		mp->m_rbmip->i_disk_size =
 			nsbp->sb_rbmblocks * nsbp->sb_blocksize;
 		xfs_trans_log_inode(tp, mp->m_rbmip, XFS_ILOG_CORE);
 		/*
@@ -1023,7 +1023,7 @@ xfs_growfs_rt(
 		/*
 		 * Update the summary inode's size.
 		 */
-		mp->m_rsumip->i_d.di_size = nmp->m_rsumsize;
+		mp->m_rsumip->i_disk_size = nmp->m_rsumsize;
 		xfs_trans_log_inode(tp, mp->m_rsumip, XFS_ILOG_CORE);
 		/*
 		 * Copy summary data from old to new sizes.
@@ -1284,8 +1284,8 @@ xfs_rtpick_extent(
 	ASSERT(xfs_isilocked(mp->m_rbmip, XFS_ILOCK_EXCL));
 
 	seqp = (uint64_t *)&VFS_I(mp->m_rbmip)->i_atime;
-	if (!(mp->m_rbmip->i_d.di_flags & XFS_DIFLAG_NEWRTBM)) {
-		mp->m_rbmip->i_d.di_flags |= XFS_DIFLAG_NEWRTBM;
+	if (!(mp->m_rbmip->i_diflags & XFS_DIFLAG_NEWRTBM)) {
+		mp->m_rbmip->i_diflags |= XFS_DIFLAG_NEWRTBM;
 		*seqp = 0;
 	}
 	seq = *seqp;
diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 8d1df9f8be07..7737f404fe48 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1125,13 +1125,13 @@ xfs_fs_statfs(
 	statp->f_ffree = max_t(int64_t, ffree, 0);
 
 
-	if ((ip->i_d.di_flags & XFS_DIFLAG_PROJINHERIT) &&
+	if ((ip->i_diflags & XFS_DIFLAG_PROJINHERIT) &&
 	    ((mp->m_qflags & (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))) ==
 			      (XFS_PQUOTA_ACCT|XFS_PQUOTA_ENFD))
 		xfs_qm_statvfs(ip, statp);
 
 	if (XFS_IS_REALTIME_MOUNT(mp) &&
-	    (ip->i_d.di_flags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME))) {
+	    (ip->i_diflags & (XFS_DIFLAG_RTINHERIT | XFS_DIFLAG_REALTIME))) {
 		statp->f_blocks = sbp->sb_rblocks;
 		statp->f_bavail = statp->f_bfree =
 			sbp->sb_frextents * sbp->sb_rextsize;
diff --git a/fs/xfs/xfs_symlink.c b/fs/xfs/xfs_symlink.c
index ed66fd2de327..d91a37ceaefa 100644
--- a/fs/xfs/xfs_symlink.c
+++ b/fs/xfs/xfs_symlink.c
@@ -32,7 +32,7 @@ xfs_readlink_bmap_ilocked(
 	struct xfs_buf		*bp;
 	xfs_daddr_t		d;
 	char			*cur_chunk;
-	int			pathlen = ip->i_d.di_size;
+	int			pathlen = ip->i_disk_size;
 	int			nmaps = XFS_SYMLINK_MAPS;
 	int			byte_cnt;
 	int			n;
@@ -95,7 +95,7 @@ xfs_readlink_bmap_ilocked(
 	}
 	ASSERT(pathlen == 0);
 
-	link[ip->i_d.di_size] = '\0';
+	link[ip->i_disk_size] = '\0';
 	error = 0;
 
  out:
@@ -120,7 +120,7 @@ xfs_readlink(
 
 	xfs_ilock(ip, XFS_ILOCK_SHARED);
 
-	pathlen = ip->i_d.di_size;
+	pathlen = ip->i_disk_size;
 	if (!pathlen)
 		goto out;
 
@@ -203,7 +203,7 @@ xfs_symlink(
 	 * The symlink will fit into the inode data fork?
 	 * There can't be any attributes so we get the whole variable part.
 	 */
-	if (pathlen <= XFS_LITINO(mp, dp->i_d.di_version))
+	if (pathlen <= XFS_LITINO(mp, dp->i_version))
 		fs_blocks = 0;
 	else
 		fs_blocks = xfs_symlink_blocks(mp, pathlen);
@@ -219,7 +219,7 @@ xfs_symlink(
 	/*
 	 * Check whether the directory allows new symlinks or not.
 	 */
-	if (dp->i_d.di_flags & XFS_DIFLAG_NOSYMLINKS) {
+	if (dp->i_diflags & XFS_DIFLAG_NOSYMLINKS) {
 		error = -EPERM;
 		goto out_trans_cancel;
 	}
@@ -263,8 +263,8 @@ xfs_symlink(
 	if (pathlen <= XFS_IFORK_DSIZE(ip)) {
 		xfs_init_local_fork(ip, XFS_DATA_FORK, target_path, pathlen);
 
-		ip->i_d.di_size = pathlen;
-		ip->i_d.di_format = XFS_DINODE_FMT_LOCAL;
+		ip->i_disk_size = pathlen;
+		ip->i_format = XFS_DINODE_FMT_LOCAL;
 		xfs_trans_log_inode(tp, ip, XFS_ILOG_DDATA | XFS_ILOG_CORE);
 	} else {
 		int	offset;
@@ -279,7 +279,7 @@ xfs_symlink(
 
 		if (resblks)
 			resblks -= fs_blocks;
-		ip->i_d.di_size = pathlen;
+		ip->i_disk_size = pathlen;
 		xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
 		cur_chunk = target_path;
@@ -400,7 +400,7 @@ xfs_inactive_symlink_rmt(
 	 * either 1 or 2 extents and that we can
 	 * free them all in one bunmapi call.
 	 */
-	ASSERT(ip->i_d.di_nextents > 0 && ip->i_d.di_nextents <= 2);
+	ASSERT(ip->i_nextents > 0 && ip->i_nextents <= 2);
 
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_itruncate, 0, 0, 0, &tp);
 	if (error)
@@ -415,8 +415,8 @@ xfs_inactive_symlink_rmt(
 	 * locked for the second transaction.  In the error paths we need it
 	 * held so the cancel won't rele it, see below.
 	 */
-	size = (int)ip->i_d.di_size;
-	ip->i_d.di_size = 0;
+	size = (int)ip->i_disk_size;
+	ip->i_disk_size = 0;
 	VFS_I(ip)->i_mode = (VFS_I(ip)->i_mode & ~S_IFMT) | S_IFREG;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 	/*
@@ -493,7 +493,7 @@ xfs_inactive_symlink(
 		return -EIO;
 
 	xfs_ilock(ip, XFS_ILOCK_EXCL);
-	pathlen = (int)ip->i_d.di_size;
+	pathlen = (int)ip->i_disk_size;
 	ASSERT(pathlen);
 
 	if (pathlen <= 0 || pathlen > XFS_SYMLINK_MAXLEN) {
diff --git a/fs/xfs/xfs_trace.h b/fs/xfs/xfs_trace.h
index eaae275ed430..8b510de5b086 100644
--- a/fs/xfs/xfs_trace.h
+++ b/fs/xfs/xfs_trace.h
@@ -1135,7 +1135,7 @@ DECLARE_EVENT_CLASS(xfs_file_class,
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->size = ip->i_d.di_size;
+		__entry->size = ip->i_disk_size;
 		__entry->offset = offset;
 		__entry->count = count;
 	),
@@ -1241,7 +1241,7 @@ DECLARE_EVENT_CLASS(xfs_imap_class,
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->size = ip->i_d.di_size;
+		__entry->size = ip->i_disk_size;
 		__entry->offset = offset;
 		__entry->count = count;
 		__entry->whichfork = whichfork;
@@ -1287,7 +1287,7 @@ DECLARE_EVENT_CLASS(xfs_simple_io_class,
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
 		__entry->isize = VFS_I(ip)->i_size;
-		__entry->disize = ip->i_d.di_size;
+		__entry->disize = ip->i_disk_size;
 		__entry->offset = offset;
 		__entry->count = count;
 	),
@@ -1325,7 +1325,7 @@ DECLARE_EVENT_CLASS(xfs_itrunc_class,
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->size = ip->i_d.di_size;
+		__entry->size = ip->i_disk_size;
 		__entry->new_size = new_size;
 	),
 	TP_printk("dev %d:%d ino 0x%llx size 0x%llx new_size 0x%llx",
@@ -1355,7 +1355,7 @@ TRACE_EVENT(xfs_pagecache_inval,
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->size = ip->i_d.di_size;
+		__entry->size = ip->i_disk_size;
 		__entry->start = start;
 		__entry->finish = finish;
 	),
@@ -1383,7 +1383,7 @@ TRACE_EVENT(xfs_bunmap,
 	TP_fast_assign(
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->ino = ip->i_ino;
-		__entry->size = ip->i_d.di_size;
+		__entry->size = ip->i_disk_size;
 		__entry->bno = bno;
 		__entry->len = len;
 		__entry->caller_ip = caller_ip;
@@ -1922,8 +1922,8 @@ DECLARE_EVENT_CLASS(xfs_swap_extent_class,
 		__entry->dev = VFS_I(ip)->i_sb->s_dev;
 		__entry->which = which;
 		__entry->ino = ip->i_ino;
-		__entry->format = ip->i_d.di_format;
-		__entry->nex = ip->i_d.di_nextents;
+		__entry->format = ip->i_format;
+		__entry->nex = ip->i_nextents;
 		__entry->broot_size = ip->i_df.if_broot_bytes;
 		__entry->fork_off = XFS_IFORK_BOFF(ip);
 	),
@@ -3009,12 +3009,12 @@ DECLARE_EVENT_CLASS(xfs_double_io_class,
 		__entry->dev = VFS_I(src)->i_sb->s_dev;
 		__entry->src_ino = src->i_ino;
 		__entry->src_isize = VFS_I(src)->i_size;
-		__entry->src_disize = src->i_d.di_size;
+		__entry->src_disize = src->i_disk_size;
 		__entry->src_offset = soffset;
 		__entry->len = len;
 		__entry->dest_ino = dest->i_ino;
 		__entry->dest_isize = VFS_I(dest)->i_size;
-		__entry->dest_disize = dest->i_d.di_size;
+		__entry->dest_disize = dest->i_disk_size;
 		__entry->dest_offset = doffset;
 	),
 	TP_printk("dev %d:%d count %zd "
-- 
2.20.1

