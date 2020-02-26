Return-Path: <SRS0=HAJZ=4O=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C6A2C4BA24
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:24:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E50D624656
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Feb 2020 20:24:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YirCi+pA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727301AbgBZUYA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Feb 2020 15:24:00 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:34852 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbgBZUYA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Feb 2020 15:24:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=tX71Ja6IEnfZjcX+ncLMRhhN8/wBXB32WS4EdhH99kU=; b=YirCi+pARyrrrH12JrhW5xJcFz
        qNb18cXIBoIxmBLBa9MwSB/3ZZ75QRq7jvpVuzSZkf546JaExggvHgo6SEvWKCKIYNvAPiIGoWuRG
        d/r86F6M3XurVRbh/w1w1nw8n5crYO/GfcF7yZVOXvm0QOc6YpzwFjO+Szke6NZI/HrRre33F0YUM
        rSrWgpTGFssgeUNZ0ZoUd6h5Y8KP77EGF4jRyBg1BCrOL1pEnDYKH6DHmBfE1DcWF5vAMucesEVwx
        IulT4pvFMIuGk5OV1azC6NZw21Iy5a7h5JBvRfC1hBsRP+OL0VBuQnl3gTgnrVAHz6DT5U4A/JNZV
        g0pO5wHg==;
Received: from [199.255.44.128] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j73Ds-0008Oe-5Z; Wed, 26 Feb 2020 20:24:00 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 09/32] xfs: turn xfs_da_args.value into a void pointer
Date:   Wed, 26 Feb 2020 12:22:43 -0800
Message-Id: <20200226202306.871241-10-hch@lst.de>
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

The xattr values are blobs and should not be typed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_da_btree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_da_btree.h b/fs/xfs/libxfs/xfs_da_btree.h
index 0f4fbb0889ff..0967d1bd3ceb 100644
--- a/fs/xfs/libxfs/xfs_da_btree.h
+++ b/fs/xfs/libxfs/xfs_da_btree.h
@@ -57,7 +57,7 @@ typedef struct xfs_da_args {
 	const uint8_t		*name;		/* string (maybe not NULL terminated) */
 	int		namelen;	/* length of string (maybe no NULL) */
 	uint8_t		filetype;	/* filetype of inode for directories */
-	uint8_t		*value;		/* set of bytes (maybe contain NULLs) */
+	void		*value;		/* set of bytes (maybe contain NULLs) */
 	int		valuelen;	/* length of value */
 	int		flags;		/* argument flags (eg: ATTR_NOCREATE) */
 	xfs_dahash_t	hashval;	/* hash value of name */
-- 
2.24.1

