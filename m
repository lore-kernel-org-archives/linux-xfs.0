Return-Path: <SRS0=4QIy=6W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D22BC47257
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BCF621582
	for <linux-xfs@archiver.kernel.org>; Fri,  8 May 2020 06:34:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AYKTXCfq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgEHGe3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 8 May 2020 02:34:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727051AbgEHGe3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 8 May 2020 02:34:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A78AC05BD09
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 23:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=xGiXb1vvIWAyqtdFlCQWzRWgE7kTbHEvkw8muflKjPk=; b=AYKTXCfqDw+Cih/WAfEDq4fKmG
        R9CShDdIxmiCGVTNl/RhWYNSOmS9EZMbJohIuF18/MdzMneJcvAG43XJopIjG4qVQHpZKZerLJr6u
        SKO7myIT8WvcavDUT52ynJdWqol+K5T1rf9SI24Ad9gUDiGh0yUDLaBYEB8GuMAhVXdTNqL9cQ9nK
        ViAwEqdPzM/YZJUv6twzaNW22cO0d3aJRBEFxlUplOe/EO10oqBt1w/XE/CWEBHbteu79QIHXXr8G
        duQza2ERAlVruT25UCjTMMfrmMsy4RFhRRmlEUCqjZeofxKlilDJlxIjaagq6CKBMrlyjhGS+fq10
        UXgDiQIA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWwaZ-0002ta-Mn; Fri, 08 May 2020 06:34:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH 01/12] xfs: xfs_bmapi_read doesn't take a fork id as the last argument
Date:   Fri,  8 May 2020 08:34:12 +0200
Message-Id: <20200508063423.482370-2-hch@lst.de>
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

The last argument to xfs_bmapi_raad contains XFS_BMAPI_* flags, not the
fork.  Given that XFS_DATA_FORK evaluates to 0 no real harm is done,
but let's fix this anyway.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
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

