Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7732C433E4
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:22:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDF6F61A0F
	for <linux-xfs@archiver.kernel.org>; Wed, 24 Mar 2021 14:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbhCXOWK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 24 Mar 2021 10:22:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236209AbhCXOVs (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 24 Mar 2021 10:21:48 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC68AC061763
        for <linux-xfs@vger.kernel.org>; Wed, 24 Mar 2021 07:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=qzJfS/ZqQH/A6+oCNSMK4N7oUgQAZGrCHIfysdZvaj4=; b=ZSfTpPCijQRgYhfp8+03CgxABO
        F6ktSsMfLLLGH30GolSvZEgYegdLAY3CodreW1FPSpQNYx5stldJEoWGrihWMo2jWcc8dQsCvl0OK
        i9jRqpNNWjWnQJfhFX2t9inB4Wsh8Th/h2/6NcbNOlVx+3QKyA5VruJmTK+aUQxWcTCugmnRvaJEj
        zhAKG18FB84FcdOpbfH6utxgoZkzzY2BdPbAr6I5sJDW+HElA5ot0zU71U2OGlykbuVL3CmFxTCcj
        XsJoQGe+bCbH1szPqxCrDcCvyw5ciFiyAQsutpP6FKQS1tj26JRH7CrUuRv9yuhUV40UpYVET0/XA
        VHLm6xrQ==;
Received: from [2001:4bb8:191:f692:b499:58dc:411a:54d1] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lP4OJ-0045XE-8C
        for linux-xfs@vger.kernel.org; Wed, 24 Mar 2021 14:21:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 06/18] xfs: don't clear the "dinode core" in xfs_inode_alloc
Date:   Wed, 24 Mar 2021 15:21:17 +0100
Message-Id: <20210324142129.1011766-7-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210324142129.1011766-1-hch@lst.de>
References: <20210324142129.1011766-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The xfs_icdinode structure just contains a random mix of inode field,
which are all read from the on-disk inode and mostly not looked at
before reading the inode or initializing a new inode cluster.  The
only exceptions are the forkoff and blocks field, which are used
in sanity checks for freshly allocated inodes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_icache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 0e43d27e8e13bc..a8d982a10df828 100644
--- a/fs/xfs/xfs_icache.c
+++ b/fs/xfs/xfs_icache.c
@@ -63,8 +63,9 @@ xfs_inode_alloc(
 	memset(&ip->i_df, 0, sizeof(ip->i_df));
 	ip->i_flags = 0;
 	ip->i_delayed_blks = 0;
-	memset(&ip->i_d, 0, sizeof(ip->i_d));
 	ip->i_d.di_flags2 = mp->m_ino_geo.new_diflags2;
+	ip->i_d.di_nblocks = 0;
+	ip->i_d.di_forkoff = 0;
 	ip->i_sick = 0;
 	ip->i_checked = 0;
 	INIT_WORK(&ip->i_ioend_work, xfs_end_io);
-- 
2.30.1

