Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB67C433EA
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 05:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 47D0D6196D
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 05:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhC2Fkb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 01:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhC2FkS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 01:40:18 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44F3C061764
        for <linux-xfs@vger.kernel.org>; Sun, 28 Mar 2021 22:40:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=1WUmGZIKn5gyXxmKCA/D+Fk67OPk7MpM1f+Ekf5LaWc=; b=VuizoDYaopzmE4ySBKxaQY26FV
        vPyYG0HqCS8p0gDqxcYduulLkFK0fYi34lBMK/fogtgK1qXh19Hu7QZn6AuKIuOwC1ogVs976rmsG
        Kk854XXK3l3mdHc5utTHMQS9vVewRiTN51KYHcaldSbOa8MLNjLRvVux3exKFcj6l7SpuyxHiRrDl
        M7dU6vhOktyxUsDgn/H/JqD/xi7/rb2mYO53o8yUKaaM5M3dbzsGq7uDhZW69lWh6s70E/YEo0I5T
        VouzBh49mU5UbKEsdDArf5VKXRKahVsae8Ko2i3r9IOPJQboB2QxsQhPs27Qw6ht96j1dCgIvoRsu
        2Foy/jFQ==;
Received: from 173.40.253.84.static.wline.lns.sme.cust.swisscom.ch ([84.253.40.173] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lQkcD-006oQ2-TZ
        for linux-xfs@vger.kernel.org; Mon, 29 Mar 2021 05:39:06 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 14/20] xfs: use XFS_B_TO_FSB in xfs_ioctl_setattr
Date:   Mon, 29 Mar 2021 07:38:23 +0200
Message-Id: <20210329053829.1851318-15-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329053829.1851318-1-hch@lst.de>
References: <20210329053829.1851318-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Clean up xfs_ioctl_setattr a bit by using XFS_B_TO_FSB.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index d589ecef4ec730..7909e46b5c5a18 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1520,12 +1520,12 @@ xfs_ioctl_setattr(
 	 * are set on the inode then unconditionally clear the extent size hint.
 	 */
 	if (ip->i_d.di_flags & (XFS_DIFLAG_EXTSIZE | XFS_DIFLAG_EXTSZINHERIT))
-		ip->i_extsize = fa->fsx_extsize >> mp->m_sb.sb_blocklog;
+		ip->i_extsize = XFS_B_TO_FSB(mp, fa->fsx_extsize);
 	else
 		ip->i_extsize = 0;
 	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
 	    (ip->i_d.di_flags2 & XFS_DIFLAG2_COWEXTSIZE))
-		ip->i_cowextsize = fa->fsx_cowextsize >> mp->m_sb.sb_blocklog;
+		ip->i_cowextsize = XFS_B_TO_FSB(mp, fa->fsx_cowextsize);
 	else
 		ip->i_cowextsize = 0;
 
-- 
2.30.1

