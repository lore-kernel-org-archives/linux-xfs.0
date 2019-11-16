Return-Path: <SRS0=QPje=ZI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED75FC432C3
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 18:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4ACE2068D
	for <linux-xfs@archiver.kernel.org>; Sat, 16 Nov 2019 18:22:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HC7jBwmo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727684AbfKPSWY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 16 Nov 2019 13:22:24 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:35006 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfKPSWY (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 16 Nov 2019 13:22:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=S7UvlDV8tofHRA8ezTS6+Cgdgj/QcN1VPru+FGYPQ1k=; b=HC7jBwmoTtLkLvP1w97WWSXFee
        dZX+KILzCZlreG8y10KYYjWkOyB7zYAgv6d3rD83VCA0ayHkPO48uLcClo0S8QEfuAOg+p9VtoCSQ
        xJgBvlkRDPJfXDg0xh/TmT98mMaFv7eJaytSbyUHp2N1neWi/RI5zgFQFslFVa5mQLjxFywT8CDOf
        GEqFEZU/WBF/Q6Wwyq8UxgeUYHWA96BAb+xNkALFHt+pSuY1OequwyD6I0ytmNQwhJp6OM1EnOsn+
        OG6+HfH4IF0Aid3ZEApFDiG/0AAiuAQ2xBgd33/+0gLq/jEfrJ4VfwE/yUF0zI0cuLDGutkAV+1/2
        Sz//hrgA==;
Received: from [2001:4bb8:180:3806:c70:4a89:bc61:6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iW2iF-0006gk-KR; Sat, 16 Nov 2019 18:22:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 2/9] xfs: improve the xfs_dabuf_map calling conventions
Date:   Sat, 16 Nov 2019 19:22:07 +0100
Message-Id: <20191116182214.23711-3-hch@lst.de>
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

Use a flags argument with the XFS_DABUF_MAP_HOLE_OK flag to signal that
a hole is okay and not corruption, and return -ENOENT instead of the
nameless -1 to signal that case in the return value.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_da_btree.c | 25 +++++++++++++++----------
 fs/xfs/libxfs/xfs_da_btree.h |  3 +++
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 681fba5731c2..c26f139bcf00 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2571,7 +2571,7 @@ static int
 xfs_dabuf_map(
 	struct xfs_inode	*dp,
 	xfs_dablk_t		bno,
-	xfs_daddr_t		mappedbno,
+	unsigned int		flags,
 	int			whichfork,
 	struct xfs_buf_map	**map,
 	int			*nmaps)
@@ -2596,8 +2596,8 @@ xfs_dabuf_map(
 
 	if (!xfs_da_map_covers_blocks(nirecs, irecs, bno, nfsb)) {
 		/* Caller ok with no mapping. */
-		if (mappedbno == -2) {
-			error = -1;
+		if (flags & XFS_DABUF_MAP_HOLE_OK) {
+			error = -ENOENT;
 			goto out;
 		}
 
@@ -2655,10 +2655,12 @@ xfs_da_get_buf(
 		goto done;
 	}
 
-	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork, &mapp, &nmap);
+	error = xfs_dabuf_map(dp, bno,
+			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
+			whichfork, &mapp, &nmap);
 	if (error) {
 		/* mapping a hole is not an error, but we don't continue */
-		if (error == -1)
+		if (error == -ENOENT)
 			error = 0;
 		goto out_free;
 	}
@@ -2710,10 +2712,12 @@ xfs_da_read_buf(
 		goto done;
 	}
 
-	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork, &mapp, &nmap);
+	error = xfs_dabuf_map(dp, bno,
+			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
+			whichfork, &mapp, &nmap);
 	if (error) {
 		/* mapping a hole is not an error, but we don't continue */
-		if (error == -1)
+		if (error == -ENOENT)
 			error = 0;
 		goto out_free;
 	}
@@ -2757,11 +2761,12 @@ xfs_da_reada_buf(
 
 	mapp = &map;
 	nmap = 1;
-	error = xfs_dabuf_map(dp, bno, mappedbno, whichfork,
-				&mapp, &nmap);
+	error = xfs_dabuf_map(dp, bno,
+			mappedbno == -1 ? XFS_DABUF_MAP_HOLE_OK : 0,
+			whichfork, &mapp, &nmap);
 	if (error) {
 		/* mapping a hole is not an error, but we don't continue */
-		if (error == -1)
+		if (error == -ENOENT)
 			error = 0;
 		goto out_free;
 	}
diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 5af4df71e92b..9ec0d0243e96 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -204,6 +204,9 @@ int	xfs_da3_node_read(struct xfs_trans *tp, struct xfs_inode *dp,
 /*
  * Utility routines.
  */
+
+#define XFS_DABUF_MAP_HOLE_OK	(1 << 0)
+
 int	xfs_da_grow_inode(xfs_da_args_t *args, xfs_dablk_t *new_blkno);
 int	xfs_da_grow_inode_int(struct xfs_da_args *args, xfs_fileoff_t *bno,
 			      int count);
-- 
2.20.1

