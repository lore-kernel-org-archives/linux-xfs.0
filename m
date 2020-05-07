Return-Path: <SRS0=M5eb=6V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF27BC4724C
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C60F22083B
	for <linux-xfs@archiver.kernel.org>; Thu,  7 May 2020 12:19:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sJJm400R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726744AbgEGMTM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 7 May 2020 08:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725857AbgEGMTM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 7 May 2020 08:19:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF30C05BD43
        for <linux-xfs@vger.kernel.org>; Thu,  7 May 2020 05:19:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=6L0kGWpLh4VXa4GTZtF2VleJWZtjo+6h7qprjRQYsoo=; b=sJJm400RpgprPufRpi7qgiGUbG
        jH2nCPXmJdum3Q9ElL+JZ4zGu1X1HqDmP7sfFtybwhCety8ZHWT7mUqaBKzRoh6fDVV15exhpBbBJ
        OggYGlqVWM54QyLk9TCXjT2RqIRsKJ1IdSYOQY0I4RMcOu5+BCUlDHu6EOgYU7jiBOru5ZDxwviFO
        8Lt1csUlI/ZykWxA1Uj8fAf+eWSglcL2nCU7NuxOjlA7mjKJVjfh0FcJbKyJEdInNYnho3E7Lq/Jo
        jiQBFvaAOF1WF91vbCIgCFWWDZ3KE1FmpRxYQk/6AgZL/pvLA7x0YaETOd+HxCmZtrowjEyd1Mged
        yGyrh/lw==;
Received: from [2001:4bb8:180:9d3f:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jWfUd-00055T-LW; Thu, 07 May 2020 12:19:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org, Dave Chinner <dchinner@redhat.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 07/58] xfs: remove the ATTR_INCOMPLETE flag
Date:   Thu,  7 May 2020 14:18:00 +0200
Message-Id: <20200507121851.304002-8-hch@lst.de>
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

Source kernel commit: 5e81357435cc0ef6b2ba4a9dcfca52be4e471cf5

Replace the ATTR_INCOMPLETE flag with a new boolean field in struct
xfs_attr_list_context.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 libxfs/xfs_attr.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 4243b227..71bcf129 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -36,11 +36,10 @@ struct xfs_attr_list_context;
 #define ATTR_KERNOTIME	0x1000	/* [kernel] don't update inode timestamps */
 #define ATTR_KERNOVAL	0x2000	/* [kernel] get attr size only, not value */
 
-#define ATTR_INCOMPLETE	0x4000	/* [kernel] return INCOMPLETE attr keys */
 #define ATTR_ALLOC	0x8000	/* [kernel] allocate xattr buffer on demand */
 
 #define ATTR_KERNEL_FLAGS \
-	(ATTR_KERNOTIME | ATTR_KERNOVAL | ATTR_INCOMPLETE | ATTR_ALLOC)
+	(ATTR_KERNOTIME | ATTR_KERNOVAL | ATTR_ALLOC)
 
 #define XFS_ATTR_FLAGS \
 	{ ATTR_DONTFOLLOW, 	"DONTFOLLOW" }, \
@@ -51,7 +50,6 @@ struct xfs_attr_list_context;
 	{ ATTR_REPLACE,		"REPLACE" }, \
 	{ ATTR_KERNOTIME,	"KERNOTIME" }, \
 	{ ATTR_KERNOVAL,	"KERNOVAL" }, \
-	{ ATTR_INCOMPLETE,	"INCOMPLETE" }, \
 	{ ATTR_ALLOC,		"ALLOC" }
 
 /*
@@ -123,6 +121,7 @@ typedef struct xfs_attr_list_context {
 	 * error values to the xfs_attr_list caller.
 	 */
 	int				seen_enough;
+	bool				allow_incomplete;
 
 	ssize_t				count;		/* num used entries */
 	int				dupcnt;		/* count dup hashvals seen */
-- 
2.26.2

