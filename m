Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B40C4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B719D2166E
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:14:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lGQXlEKi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgEAIO3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 04:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728277AbgEAIO3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:14:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B06EC035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:14:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=ecYMIeTPAZi62Nffxj+It0n++QYhVcLQoESRraLd8WI=; b=lGQXlEKiiQ5wILS9ysDQWwh3EV
        1gRDPnX3HirD+Amui1WmHlFTu3qYaWd+F7ntqbjM55Z+NIXEIcyCkNLz1/TCffjdw0fSPiZujE291
        hoJ1MRFohCSQ1jbFcedGz1fDrH+/lLNFvz2f2rbJlFfvdia2at2yQvktvp4HcEsaEGy1lm9pAyclC
        eemjFXxUlrrNsocQTsr77OgNTGGh7B5H2dHQiJHN9x31ptVyMlp1H1CkvYokwJ/13M/k36D4gsGEo
        GrBRV0lNQKARAxvaHem8wgsomueRjvRkDUsl1XHI6KK0eToWBaiE7MUePOpYbljMeOKKlV5VIRump
        b6APhHLg==;
Received: from [2001:4bb8:18c:10bd:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQoW-0002rf-Ih
        for linux-xfs@vger.kernel.org; Fri, 01 May 2020 08:14:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 01/12] xfs: xfs_bmapi_read doesn't take a fork id as the last argument
Date:   Fri,  1 May 2020 10:14:13 +0200
Message-Id: <20200501081424.2598914-2-hch@lst.de>
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

The last argument to xfs_bmapi_raad contains XFS_BMAPI_* flags, not the
fork.  Given that XFS_DATA_FORK evaluates to 0 no real harm is done,
but let's fix this anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_rtbitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_rtbitmap.c b/fs/xfs/libxfs/xfs_rtbitmap.c
index f42c74cb8be53..9498ced947be9 100644
--- a/fs/xfs/libxfs/xfs_rtbitmap.c
+++ b/fs/xfs/libxfs/xfs_rtbitmap.c
@@ -66,7 +66,7 @@ xfs_rtbuf_get(
 
 	ip = issum ? mp->m_rsumip : mp->m_rbmip;
 
-	error = xfs_bmapi_read(ip, block, 1, &map, &nmap, XFS_DATA_FORK);
+	error = xfs_bmapi_read(ip, block, 1, &map, &nmap, 0);
 	if (error)
 		return error;
 
-- 
2.26.2

