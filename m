Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFF97C38A24
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A10B620CC7
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rtjsSeVM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726788AbgEGMTW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:19:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEGMTW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:19:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 085B6C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:19:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=iKJR2sk5NnoUGRrJaWTTzJMXLdIn8ZrBj3VnSGYu/ME=; b=rtjsSeVMnHplWR7i+HR1l7YDMz
        GLpPc7TrCeQDCkkTjtcpfzJrZWeKTC7cxKruA5Jh9nDztp4LOLas47xy4OfmNsfF3GW4PZtstKf1M
        om04UhbREP9Kcbv7Wip9rMqsBEEUoOrxi0WyVkHpbcb+3pTQA8pkQJtrdtfYVsDpTIlzsIuap/A59
        FL86WqkZSNVNFIPgE5JGxHToeR5++phucnJPIIEMng8LdjI+QU2HdEu++9C9sx+vXuRN6AhfdGb9a
        TcKlCucWZ6vn4IUP7w1L+tzvoMS27MzPEhIBKZ5Nw6JtgajN9fjQihVLmCBiW+nnVghb2RJtfE1OL
        5vnkYTqA==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfUn-00057R-HN; Thu, 07 May 2020 12:19:21 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 11/58] xfs: turn xfs_da_args.value into a void pointer
Date:   Thu,  7 May 2020 14:18:04 +0200
Message-Id: <20200507121851.304002-12-hch@lst.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200507121851.304002-1-hch@lst.de>
References: <20200507121851.304002-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Source kernel commit: ead189adb8abebc1555bf2776954131ba00c7619

The xattr values are blobs and should not be typed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_da_btree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxfs/xfs_da_btree.h b/libxfs/xfs_da_btree.h
index 0f4fbb08..0967d1bd 100644
--- a/libxfs/xfs_da_btree.h
+++ b/libxfs/xfs_da_btree.h
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
2.26.2

