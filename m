Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2940C433B4
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 14:24:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AD9260201
	for <linux-xfs@archiver.kernel.org>; Fri,  2 Apr 2021 14:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235650AbhDBOYW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Apr 2021 10:24:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235675AbhDBOYV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Apr 2021 10:24:21 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F243CC0613E6
        for <linux-xfs@vger.kernel.org>; Fri,  2 Apr 2021 07:24:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=PVlCIx8ZiR5oDzS+X//DYEa28GhWOjGRihaAwTtOjME=; b=MGyEAC9ejQYPe0tHsg16yhHo+r
        Ep99kBbD22PCano1rg0tBjNE1Ys7qFYeVXnzjx978blu7vfH5d5V5+6ncpoGQRxiejImrS6rajCL4
        c7+7Zo+j09C0MKbVB1ucW2rH2rGYyKZTGMeFeQ2f7WalRxtl3fU0j2cqBoYwnQgOPSsGqH5+rw81n
        ZaPz3Rq8qnChd1MJ5ap6RN7p08tfU8sJj6nc4sW9Qs1AWgYUXJfaSIvqd2qek1oKw6P3US3Mi9XqE
        i0JWlEe4B6F3JqaegL9PdByvBTrvYJ8rxJCRhSlh+BGvamu7czJvpdmBa8yxhwaZE28KH3DIGNkTl
        E+WtG9bQ==;
Received: from [2001:4bb8:180:7517:6acc:e698:6fa4:15da] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lSKii-00FA5f-8e
        for linux-xfs@vger.kernel.org; Fri, 02 Apr 2021 14:24:20 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/7] xfs: simplify xfs_attr_remove_args
Date:   Fri,  2 Apr 2021 16:24:05 +0200
Message-Id: <20210402142409.372050-4-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210402142409.372050-1-hch@lst.de>
References: <20210402142409.372050-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Directly return from the subfunctions and avoid the error variable.  Also
remove the not really needed dp local variable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_attr.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 0146f70b71b1e2..6d1854d506d5ad 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
@@ -386,21 +386,16 @@ int
 xfs_attr_remove_args(
 	struct xfs_da_args      *args)
 {
-	struct xfs_inode	*dp = args->dp;
-	int			error;
+	if (!xfs_inode_hasattr(args->dp))
+		return -ENOATTR;
 
-	if (!xfs_inode_hasattr(dp)) {
-		error = -ENOATTR;
-	} else if (dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
-		ASSERT(dp->i_afp->if_flags & XFS_IFINLINE);
-		error = xfs_attr_shortform_remove(args);
-	} else if (xfs_attr_is_leaf(dp)) {
-		error = xfs_attr_leaf_removename(args);
-	} else {
-		error = xfs_attr_node_removename(args);
+	if (args->dp->i_afp->if_format == XFS_DINODE_FMT_LOCAL) {
+		ASSERT(args->dp->i_afp->if_flags & XFS_IFINLINE);
+		return xfs_attr_shortform_remove(args);
 	}
-
-	return error;
+	if (xfs_attr_is_leaf(args->dp))
+		return xfs_attr_leaf_removename(args);
+	return xfs_attr_node_removename(args);
 }
 
 /*
-- 
2.30.1

