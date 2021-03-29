Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2614EC433DB
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 06:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D85A961481
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 06:56:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhC2G4S (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 02:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbhC2G4C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 02:56:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC30BC061574
        for <linux-xfs@vger.kernel.org>; Sun, 28 Mar 2021 23:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=2v9dKq+ttI0ppWOq5bVUeynG/F+OAaOikgNuvBuEbvQ=; b=fXyPht36YDWpCYCN960rLvCGB+
        sFCIxD57LOF5dPzNsOOWsaNgjSr0j0mCBTHLsgKSvtey5l9vnsCdj4tkfMEMWG8EbEeaFnzsQy0HQ
        raeP/HfQSH9FkLCE/2t5oCYX0PZtz3G8qJDK9IJN18OWMz+fRo53W5M8wUwUbPE/ziXX5mXvU5EvF
        tuVnMFAG/G/tPRAgT/J8Keui47XqwlAaJNGyFbdlfbnlPAZcHfnvxZ0VSQfdxb8ReIn7Bfkugo3Lm
        berS1S0O5PaAe+dcrn/TLp6dcYX6YaOtlH9GN8OzIvSUyk7ACuRlXepEHd7QmzHvJDl3PC9pgJZIV
        7ui/mkVQ==;
Received: from 173.40.253.84.static.wline.lns.sme.cust.swisscom.ch ([84.253.40.173] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lQkbl-006oOw-GI; Mon, 29 Mar 2021 05:38:37 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 02/20] xfs: consistently initialize di_flags2
Date:   Mon, 29 Mar 2021 07:38:11 +0200
Message-Id: <20210329053829.1851318-3-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329053829.1851318-1-hch@lst.de>
References: <20210329053829.1851318-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c | 1 +
 fs/xfs/xfs_inode.c  | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 248c42bf212d65..54d483ea34c8b7 100644
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
index 8983ef05dc66f7..8c164fe621548b 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -846,7 +846,6 @@ xfs_init_new_inode(
 
 	if (xfs_sb_version_has_v3inode(&mp->m_sb)) {
 		inode_set_iversion(inode, 1);
-		ip->i_d.di_flags2 = mp->m_ino_geo.new_diflags2;
 		ip->i_d.di_cowextsize = 0;
 		ip->i_d.di_crtime = tv;
 	}
-- 
2.30.1

