Return-Path: <SRS0=QPje=ZI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C75C432C3
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 18:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4049C2068D
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 18:22:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P9II5s0O"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfKPSWV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Nov 2019 13:22:21 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34998 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfKPSWV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Nov 2019 13:22:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=NKhR/cYSrjNBnB3ss8lM28ISAYpcu+AkmNugMg1l3Hg=; b=P9II5s0Ol1OeCfLQJbj8+6zB8W
        NXfBBvAl+RDxCKGXVbchlOXBhB1TpbmoLgg/CLMs186KTyyIPPiDey5XRZEkoEpJT5VWul8O/0uX/
        libzpRQM/sLv1aVkBydWQb6CdgqCnpJ6kE/VD1r9Tl78ORYHX5M4mt3wcLvIOpLfF2IFGyOgDFU50
        PSnXeiMe2mMqVQYUptcsnj72qMd+aczgckEfuoLyYf0uRw4qjMf1CdWXa/6o/NkvGNkAwu5Q2S+fT
        V1mztgX7Of/9xP9g9ndEPKv93p1Zpc8p4uUQWti3Hfk7vF6aTVQ/mZxPFvT7IXaOA5t0K87SQYi61
        bOl1krSA==;
Received: from [2001:4bb8:180:3806:c70:4a89:bc61:6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iW2iD-0006gQ-1K; Sat, 16 Nov 2019 18:22:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 1/9] xfs: simplify mappedbno case from xfs_da_get_buf and xfs_da_read_buf
Date:   Sat, 16 Nov 2019 19:22:06 +0100
Message-Id: <20191116182214.23711-2-hch@lst.de>
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

Shortcut the creation of xfs_bmbt_irec and xfs_buf_map for the case
where the callers passed an already mapped xfs_daddr_t.  This is in
preparation for splitting these cases out entirely later.  Also reject
the mappedbno case for xfs_da_reada_buf as no callers currently uses
it and it will be removed soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_btree.c | 103 +++++++++++++++++------------------
 1 file changed, 51 insertions(+), 52 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 46b1c3fb305c..681fba5731c2 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -110,6 +110,13 @@ xfs_da_state_free(xfs_da_state_t *state)
 	kmem_zone_free(xfs_da_state_zone, state);
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
@@ -2570,7 +2577,7 @@ xfs_dabuf_map(
 	int			*nmaps)
 {
 	struct xfs_mount	*mp = dp->i_mount;
-	int			nfsb;
+	int			nfsb = xfs_dabuf_nfsb(mp, whichfork);
 	int			error = 0;
 	struct xfs_bmbt_irec	irec;
 	struct xfs_bmbt_irec	*irecs = &irec;
@@ -2579,35 +2586,13 @@ xfs_dabuf_map(
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
@@ -2648,24 +2633,29 @@ xfs_dabuf_map(
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
@@ -2673,12 +2663,12 @@ xfs_da_get_buf(
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
 
@@ -2696,7 +2686,7 @@ xfs_da_get_buf(
  */
 int
 xfs_da_read_buf(
-	struct xfs_trans	*trans,
+	struct xfs_trans	*tp,
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
 	xfs_daddr_t		mappedbno,
@@ -2704,17 +2694,23 @@ xfs_da_read_buf(
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
@@ -2722,9 +2718,9 @@ xfs_da_read_buf(
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
 
@@ -2756,6 +2752,9 @@ xfs_da_reada_buf(
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

