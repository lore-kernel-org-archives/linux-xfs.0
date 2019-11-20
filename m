Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88919C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 11:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6087822445
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 11:17:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="LXzsGZjx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbfKTLRb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 06:17:31 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47674 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfKTLRa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 06:17:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=TTsLp+GjHb/eSx2psCwiXZi8+xaioaAXY7R+vSlb24g=; b=LXzsGZjxwjwtb+VqMIl9my0/mQ
        HybrWQR3PjLwmCpCHapWcVwrkpw3iKL20YMCCbuQ6xRkVNmwCkTpgxqazvW3N7T5tX3eqW+zBsbly
        hkhgA/7PUPsg1CzCIaf5dHt+65qNi2Jz//mjUSZByVYhnx8hL2Wl6VyBfsOvZkCokXVVRzddlfuAn
        is2MQIwew5djKzre3BuMzOdHJhoij4PdWzPMSXpzf4C8WbannHgPXTOQhEvDKO5VkOxbQDX0WnifA
        1SzEqWB/LXrG0fQBpLcRzhY3GQ1djuq0Fv95hr1UPHkq80dUeeOByyZnZluptpsfK9mgj48ezjanC
        orsUcWQQ==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iXNzG-0001Q8-Aa; Wed, 20 Nov 2019 11:17:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/10] xfs: simplify mappedbno handling in xfs_da_{get,read}_buf
Date:   Wed, 20 Nov 2019 12:17:18 +0100
Message-Id: <20191120111727.16119-2-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191120111727.16119-1-hch@lst.de>
References: <20191120111727.16119-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Shortcut the creation of xfs_bmbt_irec and xfs_buf_map for the case
where the callers passed an already mapped xfs_daddr_t.  This is in
preparation for splitting these cases out entirely later.  Also reject
the mappedbno case for xfs_da_reada_buf as no callers currently uses
it and it will be removed soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.c | 103 +++++++++++++++++------------------
 1 file changed, 51 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 272db30947e5..f3087f061a48 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -110,6 +110,13 @@ xfs_da_state_free(xfs_da_state_t *state)
 	kmem_cache_free(xfs_da_state_zone, state);
 }
 
+static inline int xfs_dabuf_nfsb(struct xfs_mount *mp, int whichfork)
+{
+	if (whichfork == XFS_DATA_FORK)
+		return mp->m_dir_geo->fsbcount;
+	return mp->m_attr_geo->fsbcount;
+}
+
 void
 xfs_da3_node_hdr_from_disk(
 	struct xfs_mount		*mp,
@@ -2539,7 +2546,7 @@ xfs_dabuf_map(
 	int			*nmaps)
 {
 	struct xfs_mount	*mp = dp->i_mount;
-	int			nfsb;
+	int			nfsb = xfs_dabuf_nfsb(mp, whichfork);
 	int			error = 0;
 	struct xfs_bmbt_irec	irec;
 	struct xfs_bmbt_irec	*irecs = &irec;
@@ -2548,35 +2555,13 @@ xfs_dabuf_map(
 	ASSERT(map && *map);
 	ASSERT(*nmaps == 1);
 
-	if (whichfork == XFS_DATA_FORK)
-		nfsb = mp->m_dir_geo->fsbcount;
-	else
-		nfsb = mp->m_attr_geo->fsbcount;
-
-	/*
-	 * Caller doesn't have a mapping.  -2 means don't complain
-	 * if we land in a hole.
-	 */
-	if (mappedbno == -1 || mappedbno == -2) {
-		/*
-		 * Optimize the one-block case.
-		 */
-		if (nfsb != 1)
-			irecs = kmem_zalloc(sizeof(irec) * nfsb,
-					    KM_NOFS);
-
-		nirecs = nfsb;
-		error = xfs_bmapi_read(dp, (xfs_fileoff_t)bno, nfsb, irecs,
-				       &nirecs, xfs_bmapi_aflag(whichfork));
-		if (error)
-			goto out;
-	} else {
-		irecs->br_startblock = XFS_DADDR_TO_FSB(mp, mappedbno);
-		irecs->br_startoff = (xfs_fileoff_t)bno;
-		irecs->br_blockcount = nfsb;
-		irecs->br_state = 0;
-		nirecs = 1;
-	}
+	if (nfsb != 1)
+		irecs = kmem_zalloc(sizeof(irec) * nfsb, KM_NOFS);
+	nirecs = nfsb;
+	error = xfs_bmapi_read(dp, (xfs_fileoff_t)bno, nfsb, irecs,
+			       &nirecs, xfs_bmapi_aflag(whichfork));
+	if (error)
+		goto out;
 
 	if (!xfs_da_map_covers_blocks(nirecs, irecs, bno, nfsb)) {
 		/* Caller ok with no mapping. */
@@ -2616,24 +2601,29 @@ xfs_dabuf_map(
  */
 int
 xfs_da_get_buf(
-	struct xfs_trans	*trans,
+	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
 	xfs_daddr_t		mappedbno,
 	struct xfs_buf		**bpp,
 	int			whichfork)
 {
+	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_buf		*bp;
-	struct xfs_buf_map	map;
-	struct xfs_buf_map	*mapp;
-	int			nmap;
+	struct xfs_buf_map	map, *mapp = &map;
+	int			nmap = 1;
 	int			error;
 
 	*bpp = NULL;
-	mapp = &map;
-	nmap = 1;
-	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork,
-				&mapp, &nmap);
+
+	if (mappedbno >= 0) {
+		bp = xfs_trans_get_buf(tp, mp->m_ddev_targp, mappedbno,
+				XFS_FSB_TO_BB(mp,
+					xfs_dabuf_nfsb(mp, whichfork)), 0);
+		goto done;
+	}
+
+	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork, &mapp, &nmap);
 	if (error) {
 		/* mapping a hole is not an error, but we don't continue */
 		if (error == -1)
@@ -2641,12 +2631,12 @@ xfs_da_get_buf(
 		goto out_free;
 	}
 
-	bp = xfs_trans_get_buf_map(trans, dp->i_mount->m_ddev_targp,
-				    mapp, nmap, 0);
+	bp = xfs_trans_get_buf_map(tp, mp->m_ddev_targp, mapp, nmap, 0);
+done:
 	error = bp ? bp->b_error : -EIO;
 	if (error) {
 		if (bp)
-			xfs_trans_brelse(trans, bp);
+			xfs_trans_brelse(tp, bp);
 		goto out_free;
 	}
 
@@ -2664,7 +2654,7 @@ xfs_da_get_buf(
  */
 int
 xfs_da_read_buf(
-	struct xfs_trans	*trans,
+	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
 	xfs_daddr_t		mappedbno,
@@ -2672,17 +2662,23 @@ xfs_da_read_buf(
 	int			whichfork,
 	const struct xfs_buf_ops *ops)
 {
+	struct xfs_mount	*mp = dp->i_mount;
 	struct xfs_buf		*bp;
-	struct xfs_buf_map	map;
-	struct xfs_buf_map	*mapp;
-	int			nmap;
+	struct xfs_buf_map	map, *mapp = &map;
+	int			nmap = 1;
 	int			error;
 
 	*bpp = NULL;
-	mapp = &map;
-	nmap = 1;
-	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork,
-				&mapp, &nmap);
+
+	if (mappedbno >= 0) {
+		error = xfs_trans_read_buf(mp, tp, mp->m_ddev_targp,
+				mappedbno, XFS_FSB_TO_BB(mp,
+					xfs_dabuf_nfsb(mp, whichfork)),
+				0, &bp, ops);
+		goto done;
+	}
+
+	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork, &mapp, &nmap);
 	if (error) {
 		/* mapping a hole is not an error, but we don't continue */
 		if (error == -1)
@@ -2690,9 +2686,9 @@ xfs_da_read_buf(
 		goto out_free;
 	}
 
-	error = xfs_trans_read_buf_map(dp->i_mount, trans,
-					dp->i_mount->m_ddev_targp,
-					mapp, nmap, 0, &bp, ops);
+	error = xfs_trans_read_buf_map(mp, tp, mp->m_ddev_targp, mapp, nmap, 0,
+			&bp, ops);
+done:
 	if (error)
 		goto out_free;
 
@@ -2724,6 +2720,9 @@ xfs_da_reada_buf(
 	int			nmap;
 	int			error;
 
+	if (mappedbno >= 0)
+		return -EINVAL;
+
 	mapp = &map;
 	nmap = 1;
 	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork,
-- 
2.20.1

