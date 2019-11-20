Return-Path: <SRS0=ArDI=ZM=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2177C432C0
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 11:17:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89C54223D8
	for <linux-xfs@archiver.kernel.org>; Wed, 20 Nov 2019 11:17:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="jGYaUs4M"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728048AbfKTLRd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 20 Nov 2019 06:17:33 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:47686 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726771AbfKTLRd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 20 Nov 2019 06:17:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fz65BA+hPi5unEPpPTisklpi5N2cAvviyf/1SS2E3Z0=; b=jGYaUs4MPYlhZlRH5uqaSK39EN
        5bqr0p9I8P2/oo2KbspxKbedQICOIGVCMQOhydECiZbFotNJkvsD0kR0ODXEzwgGmlu2b2JvYioZ6
        OiCGe+dF7wAomYk17NKoSpE0c7qt5jJ4jvrcquwURzxtQ9RMvjQMoZrRv6mPXUdqwc6HPrDtA4Vcb
        SfkVsh59JkiXcl2phR4suxutgL86FKSgDCY30FEzWJE/885g5FWp3g6xdmbB2Mt09d1oW0zm96wcS
        +1P1yFWt7Mcs3nE2XaVcIKVM4WtlWwG39dE8pwEmUbW9gHNUhgLhX25eCxm0PlpHDzQa4eJB3JBoK
        0aRkfBVA==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iXNzI-0001QS-Gt; Wed, 20 Nov 2019 11:17:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 02/10] xfs: refactor xfs_dabuf_map
Date:   Wed, 20 Nov 2019 12:17:19 +0100
Message-Id: <20191120111727.16119-3-hch@lst.de>
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

Merge xfs_buf_map_from_irec and xfs_da_map_covers_blocks into a single
loop in the caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_btree.c | 156 ++++++++++++-----------------------
 1 file changed, 54 insertions(+), 102 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index f3087f061a48..e078817fc26c 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2460,74 +2460,6 @@ xfs_da_shrink_inode(
 	return error;
 }
 
-/*
- * See if the mapping(s) for this btree block are valid, i.e.
- * don't contain holes, are logically contiguous, and cover the whole range.
- */
-STATIC int
-xfs_da_map_covers_blocks(
-	int		nmap,
-	xfs_bmbt_irec_t	*mapp,
-	xfs_dablk_t	bno,
-	int		count)
-{
-	int		i;
-	xfs_fileoff_t	off;
-
-	for (i = 0, off = bno; i < nmap; i++) {
-		if (mapp[i].br_startblock == HOLESTARTBLOCK ||
-		    mapp[i].br_startblock == DELAYSTARTBLOCK) {
-			return 0;
-		}
-		if (off != mapp[i].br_startoff) {
-			return 0;
-		}
-		off += mapp[i].br_blockcount;
-	}
-	return off == bno + count;
-}
-
-/*
- * Convert a struct xfs_bmbt_irec to a struct xfs_buf_map.
- *
- * For the single map case, it is assumed that the caller has provided a pointer
- * to a valid xfs_buf_map.  For the multiple map case, this function will
- * allocate the xfs_buf_map to hold all the maps and replace the caller's single
- * map pointer with the allocated map.
- */
-static int
-xfs_buf_map_from_irec(
-	struct xfs_mount	*mp,
-	struct xfs_buf_map	**mapp,
-	int			*nmaps,
-	struct xfs_bmbt_irec	*irecs,
-	int			nirecs)
-{
-	struct xfs_buf_map	*map;
-	int			i;
-
-	ASSERT(*nmaps == 1);
-	ASSERT(nirecs >= 1);
-
-	if (nirecs > 1) {
-		map = kmem_zalloc(nirecs * sizeof(struct xfs_buf_map),
-				  KM_NOFS);
-		if (!map)
-			return -ENOMEM;
-		*mapp = map;
-	}
-
-	*nmaps = nirecs;
-	map = *mapp;
-	for (i = 0; i < *nmaps; i++) {
-		ASSERT(irecs[i].br_startblock != DELAYSTARTBLOCK &&
-		       irecs[i].br_startblock != HOLESTARTBLOCK);
-		map[i].bm_bn = XFS_FSB_TO_DADDR(mp, irecs[i].br_startblock);
-		map[i].bm_len = XFS_FSB_TO_BB(mp, irecs[i].br_blockcount);
-	}
-	return 0;
-}
-
 /*
  * Map the block we are given ready for reading. There are three possible return
  * values:
@@ -2542,58 +2474,78 @@ xfs_dabuf_map(
 	xfs_dablk_t		bno,
 	xfs_daddr_t		mappedbno,
 	int			whichfork,
-	struct xfs_buf_map	**map,
+	struct xfs_buf_map	**mapp,
 	int			*nmaps)
 {
 	struct xfs_mount	*mp = dp->i_mount;
 	int			nfsb = xfs_dabuf_nfsb(mp, whichfork);
-	int			error = 0;
-	struct xfs_bmbt_irec	irec;
-	struct xfs_bmbt_irec	*irecs = &irec;
-	int			nirecs;
-
-	ASSERT(map && *map);
-	ASSERT(*nmaps == 1);
+	struct xfs_bmbt_irec	irec, *irecs = &irec;
+	struct xfs_buf_map	*map = *mapp;
+	xfs_fileoff_t		off = bno;
+	int			error = 0, nirecs, i;
 
-	if (nfsb != 1)
+	if (nfsb > 1)
 		irecs = kmem_zalloc(sizeof(irec) * nfsb, KM_NOFS);
+
 	nirecs = nfsb;
-	error = xfs_bmapi_read(dp, (xfs_fileoff_t)bno, nfsb, irecs,
-			       &nirecs, xfs_bmapi_aflag(whichfork));
+	error = xfs_bmapi_read(dp, bno, nfsb, irecs, &nirecs,
+			xfs_bmapi_aflag(whichfork));
 	if (error)
-		goto out;
+		goto out_free_irecs;
 
-	if (!xfs_da_map_covers_blocks(nirecs, irecs, bno, nfsb)) {
-		/* Caller ok with no mapping. */
-		if (!XFS_IS_CORRUPT(mp, mappedbno != -2)) {
-			error = -1;
-			goto out;
-		}
+	/*
+	 * Use the caller provided map for the single map case, else allocate a
+	 * larger one that needs to be free by the caller.
+	 */
+	if (nirecs > 1) {
+		map = kmem_zalloc(nirecs * sizeof(struct xfs_buf_map), KM_NOFS);
+		if (!map)
+			goto out_free_irecs;
+		*mapp = map;
+	}
 
-		/* Caller expected a mapping, so abort. */
+	for (i = 0; i < nirecs; i++) {
+		if (irecs[i].br_startblock == HOLESTARTBLOCK ||
+		    irecs[i].br_startblock == DELAYSTARTBLOCK)
+			goto invalid_mapping;
+		if (off != irecs[i].br_startoff)
+			goto invalid_mapping;
+
+		map[i].bm_bn = XFS_FSB_TO_DADDR(mp, irecs[i].br_startblock);
+		map[i].bm_len = XFS_FSB_TO_BB(mp, irecs[i].br_blockcount);
+		off += irecs[i].br_blockcount;
+	}
+
+	if (off != bno + nfsb)
+		goto invalid_mapping;
+
+	*nmaps = nirecs;
+out_free_irecs:
+	if (irecs != &irec)
+		kmem_free(irecs);
+	return error;
+
+invalid_mapping:
+	/* Caller ok with no mapping. */
+	if (XFS_IS_CORRUPT(mp, mappedbno != -2)) {
+		error = -EFSCORRUPTED;
 		if (xfs_error_level >= XFS_ERRLEVEL_LOW) {
-			int i;
+			xfs_alert(mp, "%s: bno %u inode %llu",
+					__func__, bno, dp->i_ino);
 
-			xfs_alert(mp, "%s: bno %lld dir: inode %lld", __func__,
-					(long long)bno, (long long)dp->i_ino);
-			for (i = 0; i < *nmaps; i++) {
+			for (i = 0; i < nirecs; i++) {
 				xfs_alert(mp,
 "[%02d] br_startoff %lld br_startblock %lld br_blockcount %lld br_state %d",
-					i,
-					(long long)irecs[i].br_startoff,
-					(long long)irecs[i].br_startblock,
-					(long long)irecs[i].br_blockcount,
+					i, irecs[i].br_startoff,
+					irecs[i].br_startblock,
+					irecs[i].br_blockcount,
 					irecs[i].br_state);
 			}
 		}
-		error = -EFSCORRUPTED;
-		goto out;
+	} else {
+		*nmaps = 0;
 	}
-	error = xfs_buf_map_from_irec(mp, map, nmaps, irecs, nirecs);
-out:
-	if (irecs != &irec)
-		kmem_free(irecs);
-	return error;
+	goto out_free_irecs;
 }
 
 /*
-- 
2.20.1

