Return-Path: <SRS0=QPje=ZI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76683C432C3
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 18:22:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C54B206D5
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 18:22:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="U0HVuXa9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbfKPSW0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Nov 2019 13:22:26 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35014 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfKPSW0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Nov 2019 13:22:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=itG31qg95PlW9JF9hx+RZIELPkHfb16MiWdOZ7zd0B8=; b=U0HVuXa9A9hR2iZh4yj1LNbJCq
        NvdsL8S+c+fEl/PR0oP5kHfaLtEdt5o18wWvkXQyBA8maYUZMEShHxKtSNkf63im2bonkiUJy285y
        vFMIV4NJjqRloqKUaIoctSuzqDC/LTrUTr5je72Blc+CQDsObLLuqXl1t5GN7IAEzJ4Gv3+M02wrL
        xum+s8JaApG5D7Mo4XSzB+V13x8easyausIAbnYxtzCM54ajWfNZbYGMkj+uUzGrZJVovHtH3IdfS
        OGcr3CR+1TiVYUaDZIErhNk+F1WblAYLralppAzRwfhLKShuX8e35nHP1JCObcsafMZyNRTO71MRQ
        GaSVVhPQ==;
Received: from [2001:4bb8:180:3806:c70:4a89:bc61:6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iW2iI-0006h2-6E; Sat, 16 Nov 2019 18:22:26 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 3/9] xfs: remove the mappedbno argument to xfs_da_reada_buf
Date:   Sat, 16 Nov 2019 19:22:08 +0100
Message-Id: <20191116182214.23711-4-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116182214.23711-1-hch@lst.de>
References: <20191116182214.23711-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace the mappedbno argument with the simple flags for xfs_da_reada_buf
and xfs_dir3_data_readahead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_btree.c  | 10 ++--------
 fs/xfs/libxfs/xfs_da_btree.h  |  4 ++--
 fs/xfs/libxfs/xfs_dir2_data.c |  6 +++---
 fs/xfs/libxfs/xfs_dir2_priv.h |  4 ++--
 fs/xfs/scrub/parent.c         |  2 +-
 fs/xfs/xfs_dir2_readdir.c     |  3 ++-
 fs/xfs/xfs_file.c             |  2 +-
 7 files changed, 13 insertions(+), 18 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index c26f139bcf00..b1b0b38d7747 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2747,7 +2747,7 @@ int
 xfs_da_reada_buf(
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
-	xfs_daddr_t		mappedbno,
+	unsigned int		flags,
 	int			whichfork,
 	const struct xfs_buf_ops *ops)
 {
@@ -2756,14 +2756,9 @@ xfs_da_reada_buf(
 	int			nmap;
 	int			error;
 
-	if (mappedbno >= 0)
-		return -EINVAL;
-
 	mapp = &map;
 	nmap = 1;
-	error = xfs_dabuf_map(dp, bno,
-			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
-			whichfork, &mapp, &nmap);
+	error = xfs_dabuf_map(dp, bno, flags, whichfork, &mapp, &nmap);
 	if (error) {
 		/* mapping a hole is not an error, but we don't continue */
 		if (error == -ENOENT)
@@ -2771,7 +2766,6 @@ xfs_da_reada_buf(
 		goto out_free;
 	}
 
-	mappedbno = mapp[0].bm_bn;
 	xfs_buf_readahead_map(dp->i_mount->m_ddev_targp, mapp, nmap, ops);
 
 out_free:
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 9ec0d0243e96..4ba0ded7b973 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -218,8 +218,8 @@ int	xfs_da_read_buf(struct xfs_trans *trans, struct xfs_inode *dp,
 			       struct xfs_buf **bpp, int whichfork,
 			       const struct xfs_buf_ops *ops);
 int	xfs_da_reada_buf(struct xfs_inode *dp, xfs_dablk_t bno,
-				xfs_daddr_t mapped_bno, int whichfork,
-				const struct xfs_buf_ops *ops);
+		unsigned int flags, int whichfork,
+		const struct xfs_buf_ops *ops);
 int	xfs_da_shrink_inode(xfs_da_args_t *args, xfs_dablk_t dead_blkno,
 					  struct xfs_buf *dead_buf);
 
diff --git a/fs/xfs/libxfs/xfs_dir2_data.c b/fs/xfs/libxfs/xfs_dir2_data.c
index 9e471a28b6c6..10680f6422c2 100644
--- a/fs/xfs/libxfs/xfs_dir2_data.c
+++ b/fs/xfs/libxfs/xfs_dir2_data.c
@@ -417,10 +417,10 @@ int
 xfs_dir3_data_readahead(
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
-	xfs_daddr_t		mapped_bno)
+	unsigned int		flags)
 {
-	return xfs_da_reada_buf(dp, bno, mapped_bno,
-				XFS_DATA_FORK, &xfs_dir3_data_reada_buf_ops);
+	return xfs_da_reada_buf(dp, bno, flags, XFS_DATA_FORK,
+				&xfs_dir3_data_reada_buf_ops);
 }
 
 /*
diff --git a/fs/xfs/libxfs/xfs_dir2_priv.h b/fs/xfs/libxfs/xfs_dir2_priv.h
index a22222df4bf2..a730c5223c64 100644
--- a/fs/xfs/libxfs/xfs_dir2_priv.h
+++ b/fs/xfs/libxfs/xfs_dir2_priv.h
@@ -76,8 +76,8 @@ extern xfs_failaddr_t __xfs_dir3_data_check(struct xfs_inode *dp,
 		struct xfs_buf *bp);
 extern int xfs_dir3_data_read(struct xfs_trans *tp, struct xfs_inode *dp,
 		xfs_dablk_t bno, xfs_daddr_t mapped_bno, struct xfs_buf **bpp);
-extern int xfs_dir3_data_readahead(struct xfs_inode *dp, xfs_dablk_t bno,
-		xfs_daddr_t mapped_bno);
+int xfs_dir3_data_readahead(struct xfs_inode *dp, xfs_dablk_t bno,
+		unsigned int flags);
 
 extern struct xfs_dir2_data_free *
 xfs_dir2_data_freeinsert(struct xfs_dir2_data_hdr *hdr,
diff --git a/fs/xfs/scrub/parent.c b/fs/xfs/scrub/parent.c
index c962bd534690..17100a83e23e 100644
--- a/fs/xfs/scrub/parent.c
+++ b/fs/xfs/scrub/parent.c
@@ -80,7 +80,7 @@ xchk_parent_count_parent_dentries(
 	 */
 	lock_mode = xfs_ilock_data_map_shared(parent);
 	if (parent->i_d.di_nextents > 0)
-		error = xfs_dir3_data_readahead(parent, 0, -1);
+		error = xfs_dir3_data_readahead(parent, 0, 0);
 	xfs_iunlock(parent, lock_mode);
 	if (error)
 		return error;
diff --git a/fs/xfs/xfs_dir2_readdir.c b/fs/xfs/xfs_dir2_readdir.c
index b149cb4a4d86..f23f3b23ec37 100644
--- a/fs/xfs/xfs_dir2_readdir.c
+++ b/fs/xfs/xfs_dir2_readdir.c
@@ -315,7 +315,8 @@ xfs_dir2_leaf_readbuf(
 				break;
 			}
 			if (next_ra > *ra_blk) {
-				xfs_dir3_data_readahead(dp, next_ra, -2);
+				xfs_dir3_data_readahead(dp, next_ra,
+						        XFS_DABUF_MAP_HOLE_OK);
 				*ra_blk = next_ra;
 			}
 			ra_want -= geo->fsbcount;
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 865543e41fb4..c93250108952 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1104,7 +1104,7 @@ xfs_dir_open(
 	 */
 	mode = xfs_ilock_data_map_shared(ip);
 	if (ip->i_d.di_nextents > 0)
-		error = xfs_dir3_data_readahead(ip, 0, -1);
+		error = xfs_dir3_data_readahead(ip, 0, 0);
 	xfs_iunlock(ip, mode);
 	return error;
 }
-- 
2.20.1

