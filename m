Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B843EC4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F381207DD
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="icMQZjJ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbgEHGew (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 02:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727116AbgEHGew (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 02:34:52 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01EC1C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 23:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=1bWPliNmHGYRPjtNurbmgREo4+Ml2XLCTG5WvWyexBE=; b=icMQZjJ6QQVpyevQFOdu6VEk5m
        /JkRpGhltkvQL83ipvcnRPDhcHOSaJ8BhpfK682f+hWP6vmB/vfyCCkg2AU2YM5oRwK4H9eOq41h2
        7Yio/AFU1NIveG/4wCvvdlSvz7CizcePqatJQxlvB4CK7pflu04OoNPKuWBz0j4I+c3b28HSfrbLk
        q9DP2/VxNCjacCfYUelLucI8H7kQFWGb3eBvPvtUHLcxzRz66VphBvQZorWydoR7Ih9gZGGuLnlsg
        tJu+28sBGbsbiNazkR+EU1n0GboSwhw2ya3X6BAgl27w7tuedJkKqdMqsgIhEthxKQSSsErKO9tPR
        Oq2oJY0g==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWwax-0002wg-Gd; Fri, 08 May 2020 06:34:51 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH 11/12] xfs: remove the special COW fork handling in xfs_bmapi_read
Date:   Fri,  8 May 2020 08:34:22 +0200
Message-Id: <20200508063423.482370-12-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508063423.482370-1-hch@lst.de>
References: <20200508063423.482370-1-hch@lst.de>
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
Reviewed-by: Brian Foster <bfoster@redhat.com>
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

