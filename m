Return-Path: <SRS0=zOuE=3S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 679F7C2D0DB
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:03:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D9B22071E
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jan 2020 17:03:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FyF5Row6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726830AbgA2RDR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jan 2020 12:03:17 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:46560 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726683AbgA2RDR (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jan 2020 12:03:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=CRR7nLMKr5x8vPmxetUDp7eMUVpjYxzfdsrqnYSu32k=; b=FyF5Row6qqicxUvRfkdaO+doWX
        QGbgKXiHawMHXf3zKwKiB4LvfS29JOOsc/TkXuAnyFgm8Sid8qA5y2v+9/qUf/GlQ147Y0icbWez2
        5wSdnTcW+PY48XlF7OcndIpKEPD0sZorCbI8t1VRPC0d557g7xBgHmYWzRuurEOJNgjIXP2jEo4oM
        VlhqWB2XfYLuyVILmO1x81kN7KjZptjptN6TEcd0N7cUrYywlQSrfmhU6sKqoLJczx5w2jUdfWaO7
        DNl/zbiSA/yvRE0JClr6rRXdTjKnyjg7kfMmkFTCwQos2VIIO5oPyMxEGIyPAwB9TvMUxOGAl8xn8
        BgT8mKwg==;
Received: from [2001:4bb8:18c:3335:c19:50e8:dbcf:dcc6] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iwqkH-0006qt-12; Wed, 29 Jan 2020 17:03:17 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/30] xfs: remove the ATTR_INCOMPLETE flag
Date:   Wed, 29 Jan 2020 18:02:41 +0100
Message-Id: <20200129170310.51370-3-hch@lst.de>
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

Replace the ATTR_INCOMPLETE flag with a new boolean field in struct
xfs_attr_list_context.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/xfs/libxfs/xfs_attr.h | 5 ++---
 fs/xfs/scrub/attr.c      | 2 +-
 fs/xfs/xfs_attr_list.c   | 6 +-----
 3 files changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 4243b2272642..71bcf1298e4c 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
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
diff --git a/fs/xfs/scrub/attr.c b/fs/xfs/scrub/attr.c
index d9f0dd444b80..d804558cdbca 100644
--- a/fs/xfs/scrub/attr.c
+++ b/fs/xfs/scrub/attr.c
@@ -497,7 +497,7 @@ xchk_xattr(
 	sx.context.resynch = 1;
 	sx.context.put_listent = xchk_xattr_listent;
 	sx.context.tp = sc->tp;
-	sx.context.flags = ATTR_INCOMPLETE;
+	sx.context.allow_incomplete = true;
 	sx.sc = sc;
 
 	/*
diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index d37743bdf274..5139ef983cd6 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -452,7 +452,7 @@ xfs_attr3_leaf_list_int(
 		}
 
 		if ((entry->flags & XFS_ATTR_INCOMPLETE) &&
-		    !(context->flags & ATTR_INCOMPLETE))
+		    !context->allow_incomplete)
 			continue;		/* skip incomplete entries */
 
 		if (entry->flags & XFS_ATTR_LOCAL) {
@@ -632,10 +632,6 @@ xfs_attr_list(
 	    (cursor->hashval || cursor->blkno || cursor->offset))
 		return -EINVAL;
 
-	/* Only internal consumers can retrieve incomplete attrs. */
-	if (flags & ATTR_INCOMPLETE)
-		return -EINVAL;
-
 	/*
 	 * Check for a properly aligned buffer.
 	 */
-- 
2.24.1

