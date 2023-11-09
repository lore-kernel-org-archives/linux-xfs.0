Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B469C4332F
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Nov 2023 16:02:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234298AbjKIQCl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Nov 2023 11:02:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjKIQCk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Nov 2023 11:02:40 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEAC6270C
        for <linux-xfs@vger.kernel.org>; Thu,  9 Nov 2023 08:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=vxEmhkCrloBY2wcx2bCLPSH3+BqqaEFxPl7KYIyAkcE=; b=Zh3cdE0lB/trvSqDaCrlcZyZsd
        h74MIlEkxXrLcVEI6UneKs/K4GJK6DOjfvFPByQLLgYNFIloA+c6k/5sFsE4vmjFltEZMvCcLWbTA
        hYrDz/Zfu+ZdK8dPFH1zNtvhlG+pMa2BtzObK7FgFAXyLxgnfW9Xe5BqtoCvHFxU2FG2Sm3zxoH3o
        cY1yjCqJ7lRXNbdS4eOgPcZIfg5dU210vgkM73LdvaUu0Ni9ARNVuSXC5KwYpYF9j7uFfAnIwDlf6
        7rHMW+ITSnZDGYtrKbIgOsZPwSLudHwQq3GJBwqO9tShzqFSURZugpwPDoid0AuddcSuT9yQB36Q/
        OmQYKBNQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1r17UM-006g2v-0r
        for linux-xfs@vger.kernel.org;
        Thu, 09 Nov 2023 16:02:38 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] repair: fix the call to search_rt_dup_extent in scan_bmapbt
Date:   Thu,  9 Nov 2023 17:02:33 +0100
Message-Id: <20231109160233.703566-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

search_rt_dup_extent expects an RT extent number and not a fsbno.
Convert the units before the call.  Without this we are unlikely
to ever found a legit duplicate extent on the RT subvolume because
the search will always be off the end.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 repair/scan.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/repair/scan.c b/repair/scan.c
index 27a33286a..7a0587615 100644
--- a/repair/scan.c
+++ b/repair/scan.c
@@ -402,8 +402,10 @@ _("bad state %d, inode %" PRIu64 " bmap block 0x%" PRIx64 "\n"),
 					XFS_FSB_TO_AGBNO(mp, bno) + 1))
 				return(1);
 		} else  {
-			if (search_rt_dup_extent(mp, bno))
-				return(1);
+			xfs_rtblock_t	ext = bno / mp->m_sb.sb_rextsize;
+
+			if (search_rt_dup_extent(mp, ext))
+				return 1;
 		}
 	}
 	(*tot)++;
-- 
2.39.2

