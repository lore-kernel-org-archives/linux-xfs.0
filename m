Return-Path: <SRS0=8ZQd=3D=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0E8CC33CB1
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 08:16:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3ACF206D5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Jan 2020 08:16:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KUA/XNcb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgANIQM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Jan 2020 03:16:12 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:42280 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726669AbgANIQM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Jan 2020 03:16:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From
        :Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Swd/nb8fGRBlz6LdyYIGit078As487N0Eb0lT2GrADI=; b=KUA/XNcbXo3mtRTA5V1t1zIz4o
        Wteji+joi8NJlufXsTzqK4YSi42Hdomu2GbiaaIxzxcLMEXCu6aTNacx1Iat/opMNdCip6PsHOOSW
        ZmgT7YKiYtSfJge29Blsuw1qcSj7UvuVPOZ1tBcIG9Dix/mrWBT509NN91FgGEnoG06G6OYEV1cLY
        MoKeze7Y7if1eIEI+wDScIX+91UJE9ziX1jHX+pXSKNMq6QSgDQcUs7uXnfYOjRMe+JV/2dOm+kT/
        MX2VF3jbN3B7XcPdzxTkA9zi7B+zJsKzJV/szDvM0NePH90JP52XV2F1HeqNtwMP8vO7RV7ospfWc
        lJyXcbEA==;
Received: from [2001:4bb8:18c:4f54:fcbb:a92b:61e1:719] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1irHMx-00073M-Fn; Tue, 14 Jan 2020 08:16:12 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     Allison Collins <allison.henderson@oracle.com>
Subject: [PATCH 19/29] xfs: replace ATTR_ENTBASESIZE with offsetoff
Date:   Tue, 14 Jan 2020 09:10:41 +0100
Message-Id: <20200114081051.297488-20-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200114081051.297488-1-hch@lst.de>
References: <20200114081051.297488-1-hch@lst.de>
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
2.24.1

