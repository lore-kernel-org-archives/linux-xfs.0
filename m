Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58639C433DB
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2051761962
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236245AbhCXOWH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236201AbhCXOVm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 10:21:42 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C02C0613DE
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 07:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=usX6c60ONLrfkEiPgXS7sfZUUJQbnAtPGw9800+lAlU=; b=ItF0NE8NWTjk9KWhZvHZWozAXK
        BNLgfBJxDPEjHq2nNQPzY0jejC4xwC/Eka3eekMXmi0ajdY306G2ZP5ZsrwZqfZ2oHGwpTDOnpdyR
        ZSHSbgQlvKeZoZN1ycQGUBLfXBUmpacPYbBEJ0ypF/5FF+YNgVPrJnlvk24ApFqCJjMdcD4eozqUU
        g+H5kwNfG8cfvCGoqQsn8EVsN33b0AZJ9r7izBhnE46OgBYD0Fuqp3+pkIa9qs//sSRM0AyQ5iD9E
        jM83Qm/9m0E560IbGK76JZgT63pn231g9KFr8uG4ecbB9IM2ZAiwEgLI6/B69YU3bTWf+ijmi4fmq
        Pcs9NHLA==;
Received: from [2001:4bb8:191:f692:b499:58dc:411a:54d1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lP4O9-0045WY-2f
        for linux-xfs@vger.kernel.org; Wed, 24 Mar 2021 14:21:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/18] xfs: consistently initialize di_flags2
Date:   Wed, 24 Mar 2021 15:21:13 +0100
Message-Id: <20210324142129.1011766-3-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210324142129.1011766-1-hch@lst.de>
References: <20210324142129.1011766-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Make sure di_flags2 is always initialized.  We currently get this implicitly
by clearing the dinode core on allocating the in-core inode, but that is
about to go away.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 1 +
 fs/xfs/xfs_inode.c  | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 266fb77ac5608c..0e43d27e8e13bc 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -64,6 +64,7 @@ xfs_inode_alloc(
 	ip->i_flags = 0;
 	ip->i_delayed_blks = 0;
 	memset(&ip->i_d, 0, sizeof(ip->i_d));
+	ip->i_d.di_flags2 = mp->m_ino_geo.new_diflags2;
 	ip->i_sick = 0;
 	ip->i_checked = 0;
 	INIT_WORK(&ip->i_ioend_work, xfs_end_io);
diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3fa332a1d24f9f..093689996f06f3 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -845,7 +845,6 @@ xfs_init_new_inode(
 
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		inode_set_iversion(inode, 1);
-		ip->i_d.di_flags2 = mp->m_ino_geo.new_diflags2;
 		ip->i_d.di_cowextsize = 0;
 		ip->i_d.di_crtime = tv;
 	}
-- 
2.30.1

