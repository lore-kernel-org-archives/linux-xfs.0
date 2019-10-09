Return-Path: <SRS0=7gTY=YC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 086A8ECE58D
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:32:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C365F206BB
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Oct 2019 14:32:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="CoFX8Byw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731340AbfJIOcd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Oct 2019 10:32:33 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:44022 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbfJIOcd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Oct 2019 10:32:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=mbhe583mzvheHsuVuTvv0liLaGrqIe89ip2/CQ8gfHI=; b=CoFX8Byw1ruKGf5bznnDZMyiE
        uxZfY6EhmxGcIOMbSl8hb/XvftYsY/ZvbiNB4lQxYsNQGZLnwdodSoW0pY9BSbd3yQzGS5Gu7sJz1
        zHRB1QyIN9rC3k2OZctt08pzP3rWr9F+O4p4EF4PFPEkEbXhnSgY64RVpNz66+ZLmFBU5LrMrJK24
        eS8RGm45f4Af0F+ZnHtLl/digVPyBSpAoTNEQHYlWzcEEarPRnO3c5A3DkCiKcn/D1dWfx34wF7m4
        IOnjWYm9A4dh4XCqBtKi5OOi29c5u8S/dMd8TVumC0zkt4+rpjOvsw8YXcCSVynwmrxZQXThdQTzu
        9e8H48oLw==;
Received: from [2001:4bb8:188:141c:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iID0y-0005dv-ON
        for linux-xfs@vger.kernel.org; Wed, 09 Oct 2019 14:32:33 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 6/8] xfs: remove the unused XLOG_STATE_ALL and XLOG_STATE_UNUSED flags
Date:   Wed,  9 Oct 2019 16:27:46 +0200
Message-Id: <20191009142748.18005-7-hch@lst.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009142748.18005-1-hch@lst.de>
References: <20191009142748.18005-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_log_priv.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
index 90e210e433cf..66bd370ae60a 100644
--- a/fs/xfs/xfs_log_priv.h
+++ b/fs/xfs/xfs_log_priv.h
@@ -49,8 +49,6 @@ static inline uint xlog_get_client_id(__be32 i)
 #define XLOG_STATE_CALLBACK  0x0020 /* Callback functions now */
 #define XLOG_STATE_DIRTY     0x0040 /* Dirty IC log, not ready for ACTIVE status*/
 #define XLOG_STATE_IOERROR   0x0080 /* IO error happened in sync'ing log */
-#define XLOG_STATE_ALL	     0x7FFF /* All possible valid flags */
-#define XLOG_STATE_NOTUSED   0x8000 /* This IC log not being used */
 
 /*
  * Flags to log ticket
-- 
2.20.1

