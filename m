Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE4FAC433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 14:24:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C05D60201
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 14:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235675AbhDBOY1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 10:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235659AbhDBOY0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 10:24:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF113C0613E6
        for <linux-xfs@vger.kernel.org>; Fri,  2 Apr 2021 07:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=sGfo+NfKtF0/NocRdzOGP4+GMliNNHlOS+EWQbK38hI=; b=tGSSzdEx2J2g21eqU/mYfEDZ1f
        7/XB1ajGY3nv8jnyOFwIzIOQXXaBBpMb6HpB7ZBpt8tckmiS+XO/tcJjvBmKU1OMpehpQKyDUfR3X
        +JgnUBPFpvoSZZ6N5Y5Oh93zhKZSUS2iL+ODd73LMmbAbI74ocuWCukXCMGNpBkqiMN9jgAGPuKM1
        7RanpZPSJ1f4L+BsDaoGdxQVMNqFEVAp5KLkvaCK6Y3vmajh1FZloVKwxW5oJ2bmXpbz7qdsBiDD2
        9sYJmCHbS8Jh/fQ1FRr+NK0lyPdPtTE86N4xCxfO1VERx3FZvm23YG+BUzUQJmwH/bnyhvxYxmWZ4
        Kls1Ul0A==;
Received: from [2001:4bb8:180:7517:6acc:e698:6fa4:15da] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lSKin-00FA5w-64
        for linux-xfs@vger.kernel.org; Fri, 02 Apr 2021 14:24:25 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/7] xfs: remove XFS_IFBROOT
Date:   Fri,  2 Apr 2021 16:24:07 +0200
Message-Id: <20210402142409.372050-6-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210402142409.372050-1-hch@lst.de>
References: <20210402142409.372050-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just check for a btree format fork instead of the using the equivalent
in-memory XFS_IFBROOT flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c          | 16 +++++++---------
 fs/xfs/libxfs/xfs_btree_staging.c |  1 -
 fs/xfs/libxfs/xfs_inode_fork.c    |  4 +---
 fs/xfs/libxfs/xfs_inode_fork.h    |  1 -
 4 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e11f8faaf8898b..8c93ee1b751286 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -631,7 +631,6 @@ xfs_bmap_btree_to_extents(
 		cur->bc_bufs[0] = NULL;
 	xfs_iroot_realloc(ip, -1, whichfork);
 	ASSERT(ifp->if_broot == NULL);
-	ASSERT((ifp->if_flags & XFS_IFBROOT) == 0);
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	*logflagsp |= XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 	return 0;
@@ -675,7 +674,6 @@ xfs_bmap_extents_to_btree(
 	 * to expand the root.
 	 */
 	xfs_iroot_realloc(ip, 1, whichfork);
-	ifp->if_flags |= XFS_IFBROOT;
 
 	/*
 	 * Fill in the root.
@@ -4189,7 +4187,7 @@ xfs_bmapi_allocate(
 			return error;
 	}
 
-	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur)
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE && !bma->cur)
 		bma->cur = xfs_bmbt_init_cursor(mp, bma->tp, bma->ip, whichfork);
 	/*
 	 * Bump the number of extents we've allocated
@@ -4262,7 +4260,7 @@ xfs_bmapi_convert_unwritten(
 	 * Modify (by adding) the state flag, if writing.
 	 */
 	ASSERT(mval->br_blockcount <= len);
-	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur) {
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE && !bma->cur) {
 		bma->cur = xfs_bmbt_init_cursor(bma->ip->i_mount, bma->tp,
 					bma->ip, whichfork);
 	}
@@ -4725,7 +4723,7 @@ xfs_bmapi_remap(
 	ip->i_d.di_nblocks += len;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	if (ifp->if_flags & XFS_IFBROOT) {
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_ino.flags = 0;
 	}
@@ -5404,7 +5402,7 @@ __xfs_bunmapi(
 	end--;
 
 	logflags = 0;
-	if (ifp->if_flags & XFS_IFBROOT) {
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
 		ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_ino.flags = 0;
@@ -5878,7 +5876,7 @@ xfs_bmap_collapse_extents(
 	if (error)
 		return error;
 
-	if (ifp->if_flags & XFS_IFBROOT) {
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_ino.flags = 0;
 	}
@@ -5993,7 +5991,7 @@ xfs_bmap_insert_extents(
 	if (error)
 		return error;
 
-	if (ifp->if_flags & XFS_IFBROOT) {
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_ino.flags = 0;
 	}
@@ -6108,7 +6106,7 @@ xfs_bmap_split_extent(
 	new.br_blockcount = got.br_blockcount - gotblkcnt;
 	new.br_state = got.br_state;
 
-	if (ifp->if_flags & XFS_IFBROOT) {
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_ino.flags = 0;
 		error = xfs_bmbt_lookup_eq(cur, &got, &i);
diff --git a/fs/xfs/libxfs/xfs_btree_staging.c b/fs/xfs/libxfs/xfs_btree_staging.c
index f464a7c7cf2246..aa8dc9521c3942 100644
--- a/fs/xfs/libxfs/xfs_btree_staging.c
+++ b/fs/xfs/libxfs/xfs_btree_staging.c
@@ -387,7 +387,6 @@ xfs_btree_bload_prep_block(
 		new_size = bbl->iroot_size(cur, nr_this_block, priv);
 		ifp->if_broot = kmem_zalloc(new_size, 0);
 		ifp->if_broot_bytes = (int)new_size;
-		ifp->if_flags |= XFS_IFBROOT;
 
 		/* Initialize it and send it out. */
 		xfs_btree_init_block_int(cur->bc_mp, ifp->if_broot,
diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 9bdeb2d474b038..4389a00d103359 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -60,7 +60,7 @@ xfs_init_local_fork(
 	}
 
 	ifp->if_bytes = size;
-	ifp->if_flags &= ~(XFS_IFEXTENTS | XFS_IFBROOT);
+	ifp->if_flags &= ~XFS_IFEXTENTS;
 	ifp->if_flags |= XFS_IFINLINE;
 }
 
@@ -214,7 +214,6 @@ xfs_iformat_btree(
 	xfs_bmdr_to_bmbt(ip, dfp, XFS_DFORK_SIZE(dip, ip->i_mount, whichfork),
 			 ifp->if_broot, size);
 	ifp->if_flags &= ~XFS_IFEXTENTS;
-	ifp->if_flags |= XFS_IFBROOT;
 
 	ifp->if_bytes = 0;
 	ifp->if_u1.if_root = NULL;
@@ -433,7 +432,6 @@ xfs_iroot_realloc(
 			XFS_BMBT_BLOCK_LEN(ip->i_mount));
 	} else {
 		new_broot = NULL;
-		ifp->if_flags &= ~XFS_IFBROOT;
 	}
 
 	/*
diff --git a/fs/xfs/libxfs/xfs_inode_fork.h b/fs/xfs/libxfs/xfs_inode_fork.h
index a0717ab0e5c574..745eae58325791 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.h
+++ b/fs/xfs/libxfs/xfs_inode_fork.h
@@ -32,7 +32,6 @@ struct xfs_ifork {
  */
 #define	XFS_IFINLINE	0x01	/* Inline data is read in */
 #define	XFS_IFEXTENTS	0x02	/* All extent pointers are read in */
-#define	XFS_IFBROOT	0x04	/* i_broot points to the bmap b-tree root */
 
 /*
  * Worst-case increase in the fork extent count when we're adding a single
-- 
2.30.1

