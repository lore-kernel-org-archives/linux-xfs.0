Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65B82C433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 06:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 400976196F
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 06:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbhC2G4Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 02:56:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229709AbhC2Gz5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 02:55:57 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C97DFC061574
        for <linux-xfs@vger.kernel.org>; Sun, 28 Mar 2021 23:55:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
        :Reply-To:Content-Type:Content-ID:Content-Description;
        bh=o8mzrmY813pFo/rcpdM2nJYh+WR9t6lyGABVKp9/vY8=; b=bC+2vbE18QOQlqTaNnEUOPC7Jo
        TjcWSGlo9VaQZuIS+FFPBad6z8Sya5e99ab+gJrWHEv/K+DlNAXVo+GLz6X/Skl4HvI/MOy3SxvCl
        GkCDzufT/ebgJCbCmgbGhN8QlD4rXLc5pa8OPzKM2/Dh+QPYi5j3P4plmbzhkjXTuP/iyJ2ZNe9A5
        l16rkiDkopXe97G7+8Zc39C4MdEW19eoZB2HdbFosrUcvvrarZ0cD39r2Cj09fZ2Ojfqct8rblITE
        gif9q3AbvD6SRH/OnFW35VZTQxIj6q5wA/NBwluzF0i1SBTpC+NwAjSCmC3lNbON8l+Fmvhg0KZsc
        nmt2X/xw==;
Received: from 173.40.253.84.static.wline.lns.sme.cust.swisscom.ch ([84.253.40.173] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lQkbv-006oPB-0x; Mon, 29 Mar 2021 05:38:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Cc:     "Darrick J . Wong" <djwong@kernel.org>
Subject: [PATCH 06/20] xfs: don't clear the "dinode core" in xfs_inode_alloc
Date:   Mon, 29 Mar 2021 07:38:15 +0200
Message-Id: <20210329053829.1851318-7-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329053829.1851318-1-hch@lst.de>
References: <20210329053829.1851318-1-hch@lst.de>
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
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_icache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_icache.c b/fs/xfs/xfs_icache.c
index 54d483ea34c8b7..fae6392f7c5650 100644
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

