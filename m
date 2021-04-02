Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AA64C433ED
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 14:24:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 688FE61106
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 14:24:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235716AbhDBOYZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 10:24:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235702AbhDBOYZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 10:24:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DB1C0613E6
        for <linux-xfs@vger.kernel.org>; Fri,  2 Apr 2021 07:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=v757f1kjPip2vA9vSKSmu3XUvRoFxsV+yyWAfWROuYU=; b=I87f3R0OJ1OeiOO7R/X8bOejSn
        u9QgD5m1tBWNfy9FEsYMa1sX1t2dBCjow/M6g7GQ+mgTzcfCLeP+eHjhT9zsY9OMJlLXWW28mGjbD
        EvhhVUQrw6SXLuhuZNfd+pfKPPilKbRvR1CCQVv5FSDkGyNSo7CF1uKKgfqBH4I4Ak/ThY0wbOWFh
        8lc5ptDPLqktmooUXdlAtV/QqToYOqUj3r2xXl2cUkte24CeIaBna1a1Zyi2uwB2odqbDSaO8DT4j
        6YuRbIXicoEi887MYkEqcKhMSHGGmG4MINXUV2fbF47PP8KJJ07V5eKyP2Xxh0ZSj7bg2k1aLT26P
        m3v1+7Ew==;
Received: from [2001:4bb8:180:7517:6acc:e698:6fa4:15da] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lSKik-00FA5l-Mb
        for linux-xfs@vger.kernel.org; Fri, 02 Apr 2021 14:24:23 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/7] xfs: only look at the fork format in xfs_idestroy_fork
Date:   Fri,  2 Apr 2021 16:24:06 +0200
Message-Id: <20210402142409.372050-5-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210402142409.372050-1-hch@lst.de>
References: <20210402142409.372050-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Stop using the XFS_IFEXTENTS flag, and instead switch on the fork format
in xfs_idestroy_fork to decide how to cleanup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index 1851d6f266d06b..9bdeb2d474b038 100644
--- a/fs/xfs/libxfs/xfs_inode_fork.c
+++ b/fs/xfs/libxfs/xfs_inode_fork.c
@@ -522,17 +522,16 @@ xfs_idestroy_fork(
 		ifp->if_broot = NULL;
 	}
 
-	/*
-	 * If the format is local, then we can't have an extents array so just
-	 * look for an inline data array.  If we're not local then we may or may
-	 * not have an extents list, so check and free it up if we do.
-	 */
-	if (ifp->if_format == XFS_DINODE_FMT_LOCAL) {
+	switch (ifp->if_format) {
+	case XFS_DINODE_FMT_LOCAL:
 		kmem_free(ifp->if_u1.if_data);
 		ifp->if_u1.if_data = NULL;
-	} else if (ifp->if_flags & XFS_IFEXTENTS) {
+		break;
+	case XFS_DINODE_FMT_EXTENTS:
+	case XFS_DINODE_FMT_BTREE:
 		if (ifp->if_height)
 			xfs_iext_destroy(ifp);
+		break;
 	}
 }
 
-- 
2.30.1

