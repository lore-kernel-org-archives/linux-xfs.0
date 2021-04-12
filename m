Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51345C43460
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 13:38:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22C8561289
	for <linux-xfs@archiver.kernel.org>; Mon, 12 Apr 2021 13:38:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242002AbhDLNis (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 12 Apr 2021 09:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238495AbhDLNis (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 12 Apr 2021 09:38:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 634EEC061574
        for <linux-xfs@vger.kernel.org>; Mon, 12 Apr 2021 06:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=F9fwMljqNElnTl6pUMEybOM4p+8JtWpRVoTY4VAdU50=; b=giJbdGA6l2btFQGWZoAOfQng/O
        CUWQCerxnpq9bZpdCre5eecysb7D+9Y1UQzfVnCfSjNo/5JYgza7m1/BI0hcgygl8v6SJqGlJh1pd
        Msby6CpzuF7Gmiu81Q+97IKG2e4E/UYi69Q93iviSJFvCArCIeRZ1H0ZuJocg1Gz54NZKxECsBwkG
        Ns5VkXr+kYzRDUzyPq15ZfXnzhGKTcLK7UMVbs+COs+FUhP6IpCU2ogconcF0qMswfGnRhjwae5Tc
        niZFPljmf1Xp56POcuQGojmbj+ws0yzkzaeORLfNC4yC/cNUCzKhaujoK5VdlLPTz++MTeKq8Lxt8
        RjYND4qw==;
Received: from [2001:4bb8:199:e2bd:3218:1918:85d1:2852] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lVwlp-006H0M-M7; Mon, 12 Apr 2021 13:38:30 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Brian Foster <bfoster@redhat.com>
Subject: [PATCH 3/7] xfs: simplify xfs_attr_remove_args
Date:   Mon, 12 Apr 2021 15:38:15 +0200
Message-Id: <20210412133819.2618857-4-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210412133819.2618857-1-hch@lst.de>
References: <20210412133819.2618857-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Directly return from the subfunctions and avoid the error variable.  Also
remove the not really needed dp local variable.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/libxfs/xfs_attr.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index fd61c67f573925..43ef85678cba6b 100644
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

