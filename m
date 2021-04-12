Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A7BCC433B4
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 13:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4816C6128E
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 13:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241898AbhDLNiy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 09:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241455AbhDLNix (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Apr 2021 09:38:53 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E610C061574
        for <linux-xfs@vger.kernel.org>; Mon, 12 Apr 2021 06:38:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=/g0MKtccqPVvFjNiJhWSFYL2a6X4EpeNRZ13xO299Pw=; b=oNvcOqdCxQ0MyKtR2T9x0S/Isv
        dDcPlTk3I5At7L7ov6CpfG7V+MK2+sXNQC8d4YVZqp3Rj8lJUkU4jWovUJKmoJcpHGnn4ghEPQDtT
        2+zu51u1+aYif43LeXxqQBVMC8ex22FE+rKTUgKufjEvUYvtbc7IsiUblwCtSBB/Dk3/QHnmx0RUs
        k3i45hs51+kzoLgtz3ZZ8mlTbw9PfaX0h5R8x1N7rxPjckPz+oJCXyLUtJdRUDpyejFg5SVh09pEU
        rUiBREr7sHDUNvAEdhddhdKHjUKFPhOoxdJF1NQjL+JqRnUTH7XAAt54U6IIyBhF+po8B4idHAqob
        nXw8s9UQ==;
Received: from [2001:4bb8:199:e2bd:3218:1918:85d1:2852] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lVwlu-006H0a-Q5
        for linux-xfs@vger.kernel.org; Mon, 12 Apr 2021 13:38:35 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 5/7] xfs: remove XFS_IFBROOT
Date:   Mon, 12 Apr 2021 15:38:17 +0200
Message-Id: <20210412133819.2618857-6-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210412133819.2618857-1-hch@lst.de>
References: <20210412133819.2618857-1-hch@lst.de>
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
index e32b8228d9cc2e..580b36f19a26f7 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -633,7 +633,6 @@ xfs_bmap_btree_to_extents(
 		cur->bc_bufs[0] = NULL;
 	xfs_iroot_realloc(ip, -1, whichfork);
 	ASSERT(ifp->if_broot == NULL);
-	ASSERT((ifp->if_flags & XFS_IFBROOT) == 0);
 	ifp->if_format = XFS_DINODE_FMT_EXTENTS;
 	*logflagsp |= XFS_ILOG_CORE | xfs_ilog_fext(whichfork);
 	return 0;
@@ -677,7 +676,6 @@ xfs_bmap_extents_to_btree(
 	 * to expand the root.
 	 */
 	xfs_iroot_realloc(ip, 1, whichfork);
-	ifp->if_flags |= XFS_IFBROOT;
 
 	/*
 	 * Fill in the root.
@@ -4196,7 +4194,7 @@ xfs_bmapi_allocate(
 			return error;
 	}
 
-	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur)
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE && !bma->cur)
 		bma->cur = xfs_bmbt_init_cursor(mp, bma->tp, bma->ip, whichfork);
 	/*
 	 * Bump the number of extents we've allocated
@@ -4269,7 +4267,7 @@ xfs_bmapi_convert_unwritten(
 	 * Modify (by adding) the state flag, if writing.
 	 */
 	ASSERT(mval->br_blockcount <= len);
-	if ((ifp->if_flags & XFS_IFBROOT) && !bma->cur) {
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE && !bma->cur) {
 		bma->cur = xfs_bmbt_init_cursor(bma->ip->i_mount, bma->tp,
 					bma->ip, whichfork);
 	}
@@ -4732,7 +4730,7 @@ xfs_bmapi_remap(
 	ip->i_nblocks += len;
 	xfs_trans_log_inode(tp, ip, XFS_ILOG_CORE);
 
-	if (ifp->if_flags & XFS_IFBROOT) {
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_ino.flags = 0;
 	}
@@ -5411,7 +5409,7 @@ __xfs_bunmapi(
 	end--;
 
 	logflags = 0;
-	if (ifp->if_flags & XFS_IFBROOT) {
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
 		ASSERT(ifp->if_format == XFS_DINODE_FMT_BTREE);
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_ino.flags = 0;
@@ -5885,7 +5883,7 @@ xfs_bmap_collapse_extents(
 	if (error)
 		return error;
 
-	if (ifp->if_flags & XFS_IFBROOT) {
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_ino.flags = 0;
 	}
@@ -6000,7 +5998,7 @@ xfs_bmap_insert_extents(
 	if (error)
 		return error;
 
-	if (ifp->if_flags & XFS_IFBROOT) {
+	if (ifp->if_format == XFS_DINODE_FMT_BTREE) {
 		cur = xfs_bmbt_init_cursor(mp, tp, ip, whichfork);
 		cur->bc_ino.flags = 0;
 	}
@@ -6115,7 +6113,7 @@ xfs_bmap_split_extent(
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
index 73eea7939b55e4..02ad722004d3f4 100644
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
index 06682ff49a5bfc..8ffaa7cc1f7c3f 100644
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

