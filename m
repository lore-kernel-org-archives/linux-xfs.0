Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E889BC2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:03:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6C832070E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:03:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QeDrUXDs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726922AbgA2RDc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 12:03:32 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46608 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgA2RDc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 12:03:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=/Kc/FVyv3dmePiXOw0wTogoc3ttmyDdgXEKwZM9/hY0=; b=QeDrUXDs16eEjMoWNzCxZDHND7
        QYW1VI0mUxARKBrYxjfRSgfNfZx8fnPPefN7P+cnbajqhyu0COgL9AQw0faqHc9j5inVbTrfchnjL
        K9z8o5T1Wc99Q9re4eF/7Owxmet9uEDFjM2rrH5r/jxYLjs3NzYBCNqLc43l0a5Pq/gBNUoh+QlK0
        jAolYAD5evsMvBSAd0EAxyeqERjvntlEsoOt4CjTyGgqvdHuIKZqGEkB1+wLs+2r+B7ZXsPRg9ru+
        zxnDvkgFHo2ldrgTWYH6YSUwWdJpvYwKnVvmWPR0Uw0L/6g3azfhpZi/YWwCcInSfrNIhbQP0DDuB
        tY4WeiPA==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwqkV-0006sx-Oa; Wed, 29 Jan 2020 17:03:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/30] xfs: remove the MAXNAMELEN check from xfs_attr_args_init
Date:   Wed, 29 Jan 2020 18:02:47 +0100
Message-Id: <20200129170310.51370-9-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200129170310.51370-1-hch@lst.de>
References: <20200129170310.51370-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

All the callers already check the length when allocating the
in-kernel xattrs buffers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index a968158b9bb1..f887d62e0956 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -72,9 +72,6 @@ xfs_attr_args_init(
 	args->flags = flags;
 	args->name = name;
 	args->namelen = namelen;
-	if (args->namelen >= MAXNAMELEN)
-		return -EFAULT;		/* match IRIX behaviour */
-
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
 	return 0;
 }
-- 
2.24.1

