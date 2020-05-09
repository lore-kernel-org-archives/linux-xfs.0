Return-Path: <SRS0=gwgl=6X=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07C5BC28CBC
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:01:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB9B42184D
	for <linux-xfs@archiver.kernel.org>; Sat,  9 May 2020 17:01:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="upwVJWYv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728171AbgEIRBp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sat, 9 May 2020 13:01:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727787AbgEIRBp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sat, 9 May 2020 13:01:45 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF31C061A0C
        for <linux-xfs@vger.kernel.org>; Sat,  9 May 2020 10:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=KuvJSh3lnAJIXSfsh3EbXlso8s4CD0kqTenK/w4OQyU=; b=upwVJWYvtCR1trrRCaMoYZ0rd7
        o8qcGBcUSlcN5qzkTZS/QIgpqMKN5Sgm8L/TFE5oCxf2IeUKwKO2t7cKAXngkEa/AMRPfIt6jbpBz
        vxeMP4kIlIOJG+DkEKPFaXHrLJnyLeQXXpxIkGpXqSIP8/AqNSn96m3/bLaRW8Zikn9oahHL0jwxN
        ZP1K+W2LDFgK+JO6GXJpFzv7O8YWDQFcyltVaJihXUHmm0jK6M8zMOyvx4tBV7eStStTkGCtk3TK0
        HKsq7Qly1mdg12focRKJJDInZ9iVr3XiPWm+Mifzby3MkhuKCFqHKVll7w3cbLhiQVXEBxOjqLJd3
        x/wfRTrw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jXSrA-00065u-PA; Sat, 09 May 2020 17:01:45 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 7/8] repair: cleanup build_agf_agfl
Date:   Sat,  9 May 2020 19:01:24 +0200
Message-Id: <20200509170125.952508-8-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200509170125.952508-1-hch@lst.de>
References: <20200509170125.952508-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

No need to have two variables for the AGFL block number array.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/phase5.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/repair/phase5.c b/repair/phase5.c
index 17b57448..677297fe 100644
--- a/repair/phase5.c
+++ b/repair/phase5.c
@@ -2149,18 +2149,15 @@ build_agf_agfl(
 
 	/* setting to 0xff results in initialisation to NULLAGBLOCK */
 	memset(agfl, 0xff, mp->m_sb.sb_sectsize);
+	freelist = xfs_buf_to_agfl_bno(agfl_buf);
 	if (xfs_sb_version_hascrc(&mp->m_sb)) {
-		__be32 *agfl_bno = xfs_buf_to_agfl_bno(agfl_buf);
-
 		agfl->agfl_magicnum = cpu_to_be32(XFS_AGFL_MAGIC);
 		agfl->agfl_seqno = cpu_to_be32(agno);
 		platform_uuid_copy(&agfl->agfl_uuid, &mp->m_sb.sb_meta_uuid);
 		for (i = 0; i < libxfs_agfl_size(mp); i++)
-			agfl_bno[i] = cpu_to_be32(NULLAGBLOCK);
+			freelist[i] = cpu_to_be32(NULLAGBLOCK);
 	}
 
-	freelist = xfs_buf_to_agfl_bno(agfl_buf);
-
 	/*
 	 * do we have left-over blocks in the btree cursors that should
 	 * be used to fill the AGFL?
-- 
2.26.2

