Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E9BCC433ED
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 13:38:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 271E36128B
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 13:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238495AbhDLNiy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 09:38:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242004AbhDLNiv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Apr 2021 09:38:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0531C061574
        for <linux-xfs@vger.kernel.org>; Mon, 12 Apr 2021 06:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=bKd0CAW5+ez0Vpp1OtuGpScrd6fZiKdaCok47kNzFCA=; b=mY6PPRByeP3W9zk7F3Xa+zBsiP
        5+AnmsWmiFISgVYBXNaRKhvKkXpAT8D6XUFIOzYt9vuWgdfBUpLmp0EItawKElFVjxyYq/N/JixEt
        Pa8IQP/bji+/WHOVm+lFbkyOp/ENrssulrHLQPuCqZGC+VIbKcs0c8ORCxEAvgbFJolLWDyNt9zPd
        rXytURfFs+S69Fd5TdzxPPfgQZmcGuRDaruj0rm0ib3+qQccbX8R2lqxpJDiqHaIvayr4VfOKo4E3
        Bot+hvtbRRfZQdkbQye6q7BZxhDOrQRAkohIRdWOIXSoX7htgchEvgnKc8j3mGR0dnJ/1PTm2WiNh
        kmZ/oslw==;
Received: from [2001:4bb8:199:e2bd:3218:1918:85d1:2852] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lVwls-006H0U-7u; Mon, 12 Apr 2021 13:38:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH 4/7] xfs: only look at the fork format in xfs_idestroy_fork
Date:   Mon, 12 Apr 2021 15:38:16 +0200
Message-Id: <20210412133819.2618857-5-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210412133819.2618857-1-hch@lst.de>
References: <20210412133819.2618857-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Stop using the XFS_IFEXTENTS flag, and instead switch on the fork format
in xfs_idestroy_fork to decide how to cleanup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_inode_fork.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
index a8800ff03f9432..73eea7939b55e4 100644
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

