Return-Path: <SRS0=u4TP=4I=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABE2EC761A6
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 04:05:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B4E32465D
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Feb 2020 04:05:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mctAs3+E"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727747AbgBTEFw (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Feb 2020 23:05:52 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38698 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727576AbgBTEFw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Feb 2020 23:05:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=Kq7wp/3ZP7gTIK7jipV4kVJHzGmrJEiRhYgVDvieYqM=; b=mctAs3+EnWu9H3KTwdv8HkNriX
        Zf5DBd8nM/6dWl3LZQ9P0PsYrlMhN8RjanmlsByHUcrnD+uAuNiJrXlVaFcj4Gt7M90nizG+2n8a4
        xY08vAgiaXtqLJmJ06bxOvRwsk4OQC7NxI6VBRZjDV2CYyNTx3lECsmX67nljiPTeVM6Ey/k7TMP5
        UW4YotY7FHSszzEYooax/BWVDikDYG9sWfs/5JEwLG3BHYXjaWmR9n2yYaHTahBm5weDjfk043Jv3
        fHxGeQT0WZyxHrMurB2aJcf3r1wfW6DCxPkQa2N3d5ft019BombygDDHjKoFXoQT3MNrS1T9q/HvJ
        oXhaZQWw==;
Received: from [38.126.112.138] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4d60-0001R5-DH
        for linux-xfs@vger.kernel.org; Thu, 20 Feb 2020 04:05:52 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 2/2] xfs: ratelimit xfs_discard_page alert messages
Date:   Wed, 19 Feb 2020 20:05:49 -0800
Message-Id: <20200220040549.366547-3-hch@lst.de>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200220040549.366547-1-hch@lst.de>
References: <20200220040549.366547-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Use printk_ratelimit() to limit the amount of messages printed from
xfs_discard_page.  Without that a failing device causes a large
number of errors that doesn't really help debugging the underling
issue.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_aops.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 58e937be24ce..acdda808fbdd 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -539,9 +539,10 @@ xfs_discard_page(
 	if (XFS_FORCED_SHUTDOWN(mp))
 		goto out_invalidate;
 
-	xfs_alert(mp,
-		"page discard on page "PTR_FMT", inode 0x%llx, offset %llu.",
-			page, ip->i_ino, offset);
+	if (printk_ratelimit())
+		xfs_alert(mp,
+			"page discard on page "PTR_FMT", inode 0x%llx, offset %llu.",
+				page, ip->i_ino, offset);
 
 	error = xfs_bmap_punch_delalloc_range(ip, start_fsb,
 			PAGE_SIZE / i_blocksize(inode));
-- 
2.24.1

