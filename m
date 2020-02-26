Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3665C4BA24
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:23:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 993592072D
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:23:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QpkGDvVP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgBZUXz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 15:23:55 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34830 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbgBZUXz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 15:23:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=VwReIK2Wv5hggJYXLfnABzyYc5b93fHIm+IPidvFfvE=; b=QpkGDvVP7b290LX/pOSpRamY2p
        NXPxxABWO2mV6uZnQa75f0WM6It8Yjs65JVQ222wzF8xUYUvW/QdxzP/4HS7A/pc/SuxtyW5alcQ7
        cj3zzj4bLwrG/8AKvog5Bp2wS/RQFeM7r/SRbZQg03vCGni9jYXD2R/q8xykKSwSTuHLsUyXywLrH
        0qa/Z8FdMt567SrJkH3hkOhmEZVbNwhrPwJPE1680WGY6WWjmBLuITpz/M29LgQJmI8YO6CMxk61W
        3zN/TxN265Ar2Vwoi+d4yXaeH5uxl34AyiHOL7Bo9EBLEBQqf0NLYLrCjHz7YQZFH7u6bJVKcy+fG
        KTqQVtvw==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j73Dm-0008Nv-Tu; Wed, 26 Feb 2020 20:23:54 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        Chandan Rajendra <chandanrlinux@gmail.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 08/32] xfs: remove the MAXNAMELEN check from xfs_attr_args_init
Date:   Wed, 26 Feb 2020 12:22:42 -0800
Message-Id: <20200226202306.871241-9-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226202306.871241-1-hch@lst.de>
References: <20200226202306.871241-1-hch@lst.de>
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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Chandan Rajendra <chandanrlinux@gmail.com>
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

