Return-Path: <SRS0=xgbg=7A=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00D13C433DF
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 17:04:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB8E120758
	for <linux-xfs@archiver.kernel.org>; Mon, 18 May 2020 17:04:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="K7s244UT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728043AbgERREs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 18 May 2020 13:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726958AbgERREs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 18 May 2020 13:04:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E950C061A0C
        for <linux-xfs@vger.kernel.org>; Mon, 18 May 2020 10:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=FadrEfJSi9gd6fZluLolBXj+fE7KbH6CxPclpqq/rJk=; b=K7s244UTy5PJO24gltKyZImsN6
        68Bh93U4w1t+bDdZ/zqR+VtVVgx4YczxEUwxeafhBCZHevcTI9nuoMJQXRnSFaND7MuGA+p3DXENd
        O4XelfpBW/g0OEA00xZvpKgbTXmXJlxoO6UJ//WBKQD9qGdiRctfQMjei6Ag1u63aujzF6kgbLnSN
        HSagHRXDnDCpwna5cwVAbmXuqMzw3gY5UL6FrTdeosuSY5J2gjhB2/weB0eQMe8oIVPtsFDHrWvNM
        +tSO1qSiwYSI7IhxEbNEh3UIe91nIuaq6hDzmG9VinTOtRG1Ie4czVEuunkyUacWkq+S82MXUM8Bs
        1lYD2nJg==;
Received: from [2001:4bb8:188:1506:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jajC3-0001wU-PH
        for linux-xfs@vger.kernel.org; Mon, 18 May 2020 17:04:48 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/6] xfs: remove __xfs_icache_free_eofblocks
Date:   Mon, 18 May 2020 19:04:34 +0200
Message-Id: <20200518170437.1218883-4-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518170437.1218883-1-hch@lst.de>
References: <20200518170437.1218883-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Just open code the trivial logic in the two callers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 31 +++++++++++--------------------
 1 file changed, 11 insertions(+), 20 deletions(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 6c6f8015ab6ef..b638d12fb56a2 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -1504,30 +1504,17 @@ xfs_inode_free_eofblocks(
 	return ret;
 }
 
-static int
-__xfs_icache_free_eofblocks(
+int
+xfs_icache_free_eofblocks(
 	struct xfs_mount	*mp,
-	struct xfs_eofblocks	*eofb,
-	int			(*execute)(struct xfs_inode *ip, int flags,
-					   void *args),
-	int			tag)
+	struct xfs_eofblocks	*eofb)
 {
 	int flags = SYNC_TRYLOCK;
 
 	if (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC))
 		flags = SYNC_WAIT;
-
-	return xfs_inode_ag_iterator_tag(mp, execute, flags,
-					 eofb, tag);
-}
-
-int
-xfs_icache_free_eofblocks(
-	struct xfs_mount	*mp,
-	struct xfs_eofblocks	*eofb)
-{
-	return __xfs_icache_free_eofblocks(mp, eofb, xfs_inode_free_eofblocks,
-			XFS_ICI_EOFBLOCKS_TAG);
+	return xfs_inode_ag_iterator_tag(mp, xfs_inode_free_eofblocks, flags,
+					 eofb, XFS_ICI_EOFBLOCKS_TAG);
 }
 
 /*
@@ -1789,8 +1776,12 @@ xfs_icache_free_cowblocks(
 	struct xfs_mount	*mp,
 	struct xfs_eofblocks	*eofb)
 {
-	return __xfs_icache_free_eofblocks(mp, eofb, xfs_inode_free_cowblocks,
-			XFS_ICI_COWBLOCKS_TAG);
+	int flags = SYNC_TRYLOCK;
+
+	if (eofb && (eofb->eof_flags & XFS_EOF_FLAGS_SYNC))
+		flags = SYNC_WAIT;
+	return xfs_inode_ag_iterator_tag(mp, xfs_inode_free_cowblocks, flags,
+					 eofb, XFS_ICI_COWBLOCKS_TAG);
 }
 
 int
-- 
2.26.2

