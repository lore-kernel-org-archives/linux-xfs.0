Return-Path: <SRS0=0MSb=2C=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1ABCBC43603
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9E772173E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Dec 2019 10:55:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="H++3YX/C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbfLLKzc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Dec 2019 05:55:32 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53334 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728733AbfLLKzc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Dec 2019 05:55:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=brGf2NXT55MpcWu8V3iQgUYGve3iWDK83MuWXMlXJB8=; b=H++3YX/CjUdgC7YQD51kjEthKP
        iarZ4s2cLA1NJwKbeGDwtXIKAA8lvUjomf5MsKkIvftnDBdEuqSMUe+iDo/kC5TwUglMq/S6jE1De
        PuJYvLl5x5QWppFjQw4ncYOew9MGZY5bzgbv9wiO+O2+vZsvtAyF9dG0EXPHbld+onhFvbUDkmM/4
        Z4MM6ZmOLIbRcJL2QJAfCXYAsu+9d26hi2bnCB1A7a5akdQBAjqhwHdumZl0ol7n5a9kLiZNhWHsj
        8+kMqZ/PxV24tr0Un1fYSPfS5MMXkUsFO+St1peMolYcZiEHR+V73l1d+oSe0Zt0aTJPVM/uU5spx
        sM9lZFCA==;
Received: from clnet-p19-102.ikbnet.co.at ([83.175.77.102] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ifM83-0002Uv-Le; Thu, 12 Dec 2019 10:55:31 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 23/33] xfs: replace ATTR_ENTBASESIZE with offsetoff
Date:   Thu, 12 Dec 2019 11:54:23 +0100
Message-Id: <20191212105433.1692-24-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191212105433.1692-1-hch@lst.de>
References: <20191212105433.1692-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Replace an opencoded offsetof with the actual helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_attr_list.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
index 9c4acb6dc856..7f08e417d131 100644
--- a/fs/xfs/xfs_attr_list.c
+++ b/fs/xfs/xfs_attr_list.c
@@ -545,10 +545,9 @@ xfs_attr_list_int(
 	return error;
 }
 
-#define	ATTR_ENTBASESIZE		/* minimum bytes used by an attr */ \
-	(((struct attrlist_ent *) 0)->a_name - (char *) 0)
 #define	ATTR_ENTSIZE(namelen)		/* actual bytes used by an attr */ \
-	((ATTR_ENTBASESIZE + (namelen) + 1 + sizeof(uint32_t)-1) \
+	((offsetof(struct attrlist_ent, a_name) + \
+	 (namelen) + 1 + sizeof(uint32_t) - 1) \
 	 & ~(sizeof(uint32_t)-1))
 
 /*
-- 
2.20.1

