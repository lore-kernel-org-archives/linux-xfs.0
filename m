Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66B1C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:15:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D25564F06
	for <linux-xfs@archiver.kernel.org>; Thu, 25 Feb 2021 08:15:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232975AbhBYIPA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 Feb 2021 03:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235475AbhBYIO4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 Feb 2021 03:14:56 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEE26C061786
        for <linux-xfs@vger.kernel.org>; Thu, 25 Feb 2021 00:14:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=p6yhYI9FnQkFnsKNrqj/UBzzJe0lA/ToKy0saaCQ6Yg=; b=oClmjBBRC7Gn1OXhlltuw2kMcC
        imrnECPbIDzSBrZ0KgtsEYBGCFZTF7IrE3KQMt5xelvoL5QBGPlOEbWOOvqb+PwB5P4sFJtmc6au5
        6/3w/kct/i78J+rSd70RsLZnoZgozwvOsMCEZRbGhniN7JvwgAEK+NDUP5d2UiLi/AChrc2rcIPku
        +07R8sNALMN6DmGYeEEF127DOhKZ6MhfA29VCCoOo/V53U3mea5MqKAmib2ih44Tdu+eemS/CaH+W
        JrK8PX9bPY50q2I0j8MrvWEJFYQu+w0GSwobsx1O/KZYpj2Uw2+YOUEAL2uXzcL+tB6aHBc3ATxeG
        4djuY7mw==;
Received: from [2001:4bb8:188:6508:774c:3d81:3abc:7b82] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lFBmX-00AS82-G0
        for linux-xfs@vger.kernel.org; Thu, 25 Feb 2021 08:14:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: mark xfs_bmap_set_attrforkoff static
Date:   Thu, 25 Feb 2021 09:13:55 +0100
Message-Id: <20210225081355.139766-1-hch@lst.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs_bmap_set_attrforkoff is only used inside of xfs_bmap.c, so mark it
static.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/libxfs/xfs_bmap.c | 2 +-
 fs/xfs/libxfs/xfs_bmap.h | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
index e0905ad171f0a5..d53afd82e109e5 100644
--- a/fs/xfs/libxfs/xfs_bmap.c
+++ b/fs/xfs/libxfs/xfs_bmap.c
@@ -1028,7 +1028,7 @@ xfs_bmap_add_attrfork_local(
 }
 
 /* Set an inode attr fork off based on the format */
-int
+static int
 xfs_bmap_set_attrforkoff(
 	struct xfs_inode	*ip,
 	int			size,
diff --git a/fs/xfs/libxfs/xfs_bmap.h b/fs/xfs/libxfs/xfs_bmap.h
index 6747e97a794901..66a7b5b755a493 100644
--- a/fs/xfs/libxfs/xfs_bmap.h
+++ b/fs/xfs/libxfs/xfs_bmap.h
@@ -186,7 +186,6 @@ static inline bool xfs_bmap_is_written_extent(struct xfs_bmbt_irec *irec)
 void	xfs_trim_extent(struct xfs_bmbt_irec *irec, xfs_fileoff_t bno,
 		xfs_filblks_t len);
 int	xfs_bmap_add_attrfork(struct xfs_inode *ip, int size, int rsvd);
-int	xfs_bmap_set_attrforkoff(struct xfs_inode *ip, int size, int *version);
 void	xfs_bmap_local_to_extents_empty(struct xfs_trans *tp,
 		struct xfs_inode *ip, int whichfork);
 void	__xfs_bmap_add_free(struct xfs_trans *tp, xfs_fsblock_t bno,
-- 
2.29.2

