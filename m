Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06484C4332F
	for <linux-xfs@archiver.kernel.org>; Wed,  8 Nov 2023 17:53:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbjKHRx1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 8 Nov 2023 12:53:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbjKHRx0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 8 Nov 2023 12:53:26 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B7521BEF
        for <linux-xfs@vger.kernel.org>; Wed,  8 Nov 2023 09:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=O6oBmCXTp3MXij3KaxX3EZzW9XQGwoFNkXO1gjKbJtk=; b=o/tpTZKEnu+JvKOJ1pQTI1lmLN
        6l1wXf8gyRdDNkjRkm0oQhCWdYPbozBMWXfbRuPCbS8uAo9o/4b76epUWXfrDtYvDStKM3IQZ+ML6
        E7RgH63gMgk7oU7AcyJPLAZBiX1L9zZFo/6/GfRMiFwsnFWqK1PUHvdHa1F4aMONsKCuZGBjQNaFL
        7NOFTOYV5ARAX8DL4N93w2/9XpeqVovrWGSxNr0JnN/D2tsHbsYt50IzXItklH6PUK3nmezRYat4P
        ICfWMp2pfo5M75o6CDATbVJP9yXQmMoqOc/DragTk3HxxilHbQI3VtT6ciovlFvlDoDN6XPSlGNAC
        9eZkDfeg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1r0mjz-004Rc5-2b
        for linux-xfs@vger.kernel.org;
        Wed, 08 Nov 2023 17:53:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] repair: fix process_rt_rec_dups
Date:   Wed,  8 Nov 2023 18:53:20 +0100
Message-Id: <20231108175320.500847-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

search_rt_dup_extent takes a xfs_rtblock_t, not an RT extent number.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---

What scares me about this is that no test seems to hit this and report
false duplicates.  I'll need to see if I can come up with an
artifical reproducers of some kind.

 repair/dinode.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/repair/dinode.c b/repair/dinode.c
index c10dd1fa3..9aa367138 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -194,13 +194,11 @@ process_rt_rec_dups(
 	struct xfs_bmbt_irec	*irec)
 {
 	xfs_fsblock_t		b;
-	xfs_rtblock_t		ext;
 
 	for (b = rounddown(irec->br_startblock, mp->m_sb.sb_rextsize);
 	     b < irec->br_startblock + irec->br_blockcount;
 	     b += mp->m_sb.sb_rextsize) {
-		ext = (xfs_rtblock_t) b / mp->m_sb.sb_rextsize;
-		if (search_rt_dup_extent(mp, ext))  {
+		if (search_rt_dup_extent(mp, b))  {
 			do_warn(
 _("data fork in rt ino %" PRIu64 " claims dup rt extent,"
 "off - %" PRIu64 ", start - %" PRIu64 ", count %" PRIu64 "\n"),
-- 
2.39.2

