Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF106C47254
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 95E172071C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:14:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VIWHS2D6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728359AbgEAIOl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 04:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbgEAIOk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:14:40 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB88BC035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:14:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=xWiUcSCtvMBZTpRJdjgtSP/GBntgrWA00pCq8ZnR1B8=; b=VIWHS2D664t+hqTSl2KkcL3WfF
        HNYpl8cHMjkRC5pqGQdSvf5d+jHQc88viluKlVIlOuMZypxLWplHOTQRbJ62TV5YAdKi9DX3vriSX
        +/Cv2Vw0YrysEARCBAsaKuxOFAuPf6d5euiieDQQe7otvR2Q08KdIB3DVMHiUtMZQttiLudfW4JpA
        GWhhgX7aGCrMGBo3OKyyKPdhR7fRCwY4BBzTKc1CFggIYGDnfh/S+9H8thhr/lVblnpM8NxrXgZmt
        FW4U5fUUYWla2mZ5woO8swzpfg05lBAyFKnqkoETzTaxCE83oFHZ5FH09Pult7+5m2EjnR//kWxoK
        kJhV2Jng==;
Received: from [2001:4bb8:18c:10bd:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQoi-0002tw-GB
        for linux-xfs@vger.kernel.org; Fri, 01 May 2020 08:14:40 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/12] xfs: don't reset i_delayed_blks in xfs_iread
Date:   Fri,  1 May 2020 10:14:18 +0200
Message-Id: <20200501081424.2598914-7-hch@lst.de>
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

i_delayed_blks is set to 0 in xfs_inode_alloc and can't have anything
assigned to it until the inode is visible to the VFS.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_buf.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
index a00001a2336ef..0357dc4b29481 100644
--- a/fs/xfs/libxfs/xfs_inode_buf.c
+++ b/fs/xfs/libxfs/xfs_inode_buf.c
@@ -673,8 +673,6 @@ xfs_iread(
 	if (error)
 		goto out_brelse;
 
-	ip->i_delayed_blks = 0;
-
 	/*
 	 * Mark the buffer containing the inode as something to keep
 	 * around for a while.  This helps to keep recently accessed
-- 
2.26.2

