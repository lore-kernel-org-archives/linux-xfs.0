Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7859C388F9
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 09:43:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B37F20729
	for <linux-xfs@archiver.kernel.org>; Wed, 11 Nov 2020 09:43:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Xfn2wQeB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbgKKJna (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 11 Nov 2020 04:43:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725830AbgKKJna (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 11 Nov 2020 04:43:30 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF85C0613D1
        for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2020 01:43:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=hk88r0W5IZoBLeNAuVKd8PMdH+y6OQeye/EkkzywVgE=; b=Xfn2wQeBXteAmo+SLKULOzyNxk
        w+z9nbZpHaHEGumIppLfM23autha1ytM/t5WZ+TwewFVez1h+EsLNIkO36qoqL5GKccE5mxcQrEp5
        W0atuh/SrsPNne4uJGtW2mI4bl6PPM5rG6H4xILr6quqFu2j2mSHsSsrKfxRChOftd0RxZUY8cqGS
        kSMvoJ7yVBnQNP2nkZ7HwNUJsV0Iqp0glY0YuqlNTMt5pSnVwGz17tTo4+mtnqwQLGweAWO+G1VG8
        +g8gi+aStLqSEAOBErOSmaD8xfMMtVaIHH78NH0QM+yFcgeGUUkkqTparKYtRmBCgfUCvllLP0vR3
        YMgjoU7g==;
Received: from [2001:4bb8:180:6600:bcde:334f:863c:27b8] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kcmf2-0004qt-5g
        for linux-xfs@vger.kernel.org; Wed, 11 Nov 2020 09:43:28 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: fix a missing unlock on error in xfs_fs_map_blocks
Date:   Wed, 11 Nov 2020 10:43:26 +0100
Message-Id: <20201111094326.3513946-1-hch@lst.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We also need to drop the iolock when invalidate_inode_pages2 fails, not
only on all other error or successful cases.

Fixes: 527851124d10 ("xfs: implement pNFS export operations")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_pnfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_pnfs.c b/fs/xfs/xfs_pnfs.c
index b101feb2aab452..f3082a957d5e1a 100644
--- a/fs/xfs/xfs_pnfs.c
+++ b/fs/xfs/xfs_pnfs.c
@@ -134,7 +134,7 @@ xfs_fs_map_blocks(
 		goto out_unlock;
 	error = invalidate_inode_pages2(inode->i_mapping);
 	if (WARN_ON_ONCE(error))
-		return error;
+		goto out_unlock;
 
 	end_fsb = XFS_B_TO_FSB(mp, (xfs_ufsize_t)offset + length);
 	offset_fsb = XFS_B_TO_FSBT(mp, offset);
-- 
2.28.0

