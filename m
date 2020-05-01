Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6707C47254
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:14:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 985EF2071C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:14:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fAyWB5Av"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728380AbgEAIOx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 04:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728363AbgEAIOw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:14:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9238C035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=I41r0LGfO+z9i832fe+ZNfhlREweT0iT/7LwkszKodE=; b=fAyWB5AvS1832mCG6JSjG7t3FH
        aRBRoFpUdU8ucUSpTc4yZm7EdvZxdvgcy+WqxkATB3ccgPCR2g5Y0dRXmtK4DKcLeUEBtIYSwCTCQ
        OizcDjGyZMP2MpbkTRXDh1gZZ1RhAwhYkqPFOQ4BS4oqNBQHIphvZma+f8Szy4ljGz6T7tbTokUOg
        krbnevf9KFYz3l4BxkTD5hzUaqJzM+OHFLgE1//OcgVgGNtsnIcjcAL1TaAzqieRIELRSl0Z3wrkn
        5nH8GPm5hniYyrndb4Uv2ukkqpU5xvG4Dbi2b5jcvA7lDNH5egd6p7IwT1HIcyH7lovwq6XFz/dDu
        +g76O23w==;
Received: from [2001:4bb8:18c:10bd:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQou-0002wu-Dn
        for linux-xfs@vger.kernel.org; Fri, 01 May 2020 08:14:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 11/12] xfs: remove the special COW fork handling in xfs_bmapi_read
Date:   Fri,  1 May 2020 10:14:23 +0200
Message-Id: <20200501081424.2598914-12-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501081424.2598914-1-hch@lst.de>
References: <20200501081424.2598914-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We don't call xfs_bmapi_read for the COW fork anymore, so remove the
special casing.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index fda13cd7add0e..76be1a18e2442 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -3902,8 +3902,7 @@ xfs_bmapi_read(
 	int			whichfork = xfs_bmapi_whichfork(flags);
 
 	ASSERT(*nmap >= 1);
-	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK|XFS_BMAPI_ENTIRE|
-			   XFS_BMAPI_COWFORK)));
+	ASSERT(!(flags & ~(XFS_BMAPI_ATTRFORK | XFS_BMAPI_ENTIRE)));
 	ASSERT(xfs_isilocked(ip, XFS_ILOCK_SHARED|XFS_ILOCK_EXCL));
 
 	if (XFS_IS_CORRUPT(mp, !xfs_ifork_has_extents(ip, whichfork)) ||
@@ -3918,16 +3917,6 @@ xfs_bmapi_read(
 
 	ifp = XFS_IFORK_PTR(ip, whichfork);
 	if (!ifp) {
-		/* No CoW fork?  Return a hole. */
-		if (whichfork == XFS_COW_FORK) {
-			mval->br_startoff = bno;
-			mval->br_startblock = HOLESTARTBLOCK;
-			mval->br_blockcount = len;
-			mval->br_state = XFS_EXT_NORM;
-			*nmap = 1;
-			return 0;
-		}
-
 		/*
 		 * A missing attr ifork implies that the inode says we're in
 		 * extents or btree format but failed to pass the inode fork
-- 
2.26.2

